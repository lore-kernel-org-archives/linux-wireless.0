Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57277 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1BQBzo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Feb 2011 20:55:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, nbd@openwrt.org,
	bloat-devel@lists.bufferbloat.net,
	"Nathaniel J. Smith" <njs@pobox.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [RFC] mac80211: implement eBDP algorithm to fight bufferbloat
Date: Wed, 16 Feb 2011 20:49:16 -0500
Message-Id: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1297619803-2832-1-git-send-email-njs@pobox.com>
References: <1297619803-2832-1-git-send-email-njs@pobox.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an implementation of the eBDP algorithm as documented in
Section IV of "Buffer Sizing for 802.11 Based Networks" by Tianji Li,
et al.

	http://www.hamilton.ie/tianji_li/buffersizing.pdf

This implementation timestamps an skb before handing it to the hardware
driver, then computes the service time when the transmit status is
reported back from the driver.  An exponentially weighted moving
average of per packet service times is used to restrict queueing
delays in hopes of achieving a target packet transmission latency.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
This is preliminary, but it seems to put some limits on latencies
for me.  I haven't even really done much testing, so YMMV...

I'm sure this isn't ideal.  This should be combined with the ALT
algorithm to yield the A* algorithm.  There are parameters that
probably should be tunable (or at least better researched).  This may
not be ideal for 802.11n -- it may even be detrimental to it.

Still, it is an attempt at addressing buffer bloat.  Plus, it should
pertain to all mac80211-based drivers.  So, feel free to test it,
suggest different parameters, report real numbers, post patches,
etc... :-)

 net/mac80211/ieee80211_i.h |    7 +++++++
 net/mac80211/iface.c       |    6 ++++++
 net/mac80211/status.c      |    9 +++++++++
 net/mac80211/tx.c          |   16 ++++++++++++++++
 4 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f2ef15d..1c69b29 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -604,6 +604,13 @@ struct ieee80211_sub_if_data {
 		struct dentry *default_mgmt_key;
 	} debugfs;
 #endif
+
+	/* number of packets currently in flight */
+	atomic_t enqueued;
+
+	/* average packet service time */
+	struct ewma tserv_ns_avg;
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5a4e19b..ccfb659 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -857,6 +857,12 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 
+	/* initialize service time estimate for buffer control */
+	ewma_init(&sdata->tserv_ns_avg, 1, 8);
+	ewma_add(&sdata->tserv_ns_avg, 2 * NSEC_PER_MSEC);
+
+	atomic_set(&sdata->enqueued, 0);
+
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
 		type = NL80211_IFTYPE_AP;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 010a559..9e5eed3 100644
--- a/net/mac80211/status.c
+++ b/net/mac80211/status.c
@@ -172,6 +172,7 @@ static void ieee80211_frame_acked(struct sta_info *sta, struct sk_buff *skb)
 
 void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
+	ktime_t tserv;
 	struct sk_buff *skb2;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -188,6 +189,9 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	bool send_to_cooked;
 	bool acked;
 
+	/* grab timestamp info for buffer control estimates */
+	tserv = ktime_sub(ktime_get(), skb->tstamp);
+
 	for (i = 0; i < IEEE80211_TX_MAX_RATES; i++) {
 		/* the HW cannot have attempted that rate */
 		if (i >= hw->max_report_rates) {
@@ -212,6 +216,11 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
 			continue;
 
+		atomic_dec(&sta->sdata->enqueued);
+
+		/* factor current tserv into service time estimate */
+		ewma_add(&sta->sdata->tserv_ns_avg, ktime_to_ns(tserv));
+
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 17ef4f4..8ccf60b 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1298,6 +1298,8 @@ static int __ieee80211_tx(struct ieee80211_local *local,
 
 	while (skb) {
 		int q = skb_get_queue_mapping(skb);
+		int max_enqueued;
+		unsigned long tserv_ns_avg;
 		__le16 fc;
 
 		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
@@ -1323,6 +1325,20 @@ static int __ieee80211_tx(struct ieee80211_local *local,
 
 		sdata = vif_to_sdata(info->control.vif);
 
+		/* test for queue admission qualifications */
+		tserv_ns_avg = ewma_read(&sdata->tserv_ns_avg);
+		/* constants 2 msec and offset 5 should be tunable? */
+		max_enqueued = 2 * NSEC_PER_MSEC / tserv_ns_avg + 5;
+		if (atomic_read(&sdata->enqueued) > max_enqueued) {
+			/* silently drop */
+			dev_kfree_skb(skb);
+			return IEEE80211_TX_OK;
+		}
+
+		/* timestamp queue entry and increment queue length */
+		skb->tstamp = ktime_get();
+		atomic_inc(&sdata->enqueued);
+
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
 			info->control.vif = NULL;
-- 
1.7.4

