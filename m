Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36304 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1BRVaq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Feb 2011 16:30:46 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: bloat-devel@lists.bufferbloat.net,
	"Nathaniel J. Smith" <njs@pobox.com>, johannes@sipsolutions.net,
	nbd@openwrt.org, "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC v2] mac80211: implement eBDP algorithm to fight bufferbloat
Date: Fri, 18 Feb 2011 16:21:14 -0500
Message-Id: <1298064074-8108-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
References: <1297907356-3214-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is an implementation of the eBDP algorithm as documented in
Section IV of "Buffer Sizing for 802.11 Based Networks" by Tianji Li,
et al.

	http://www.hamilton.ie/tianji_li/buffersizing.pdf

This implementation timestamps an skb before handing it to the
hardware driver, then computes the service time when the frame is
freed by the driver.  An exponentially weighted moving average of per
fragment service times is used to restrict queueing delays in hopes
of achieving a target fragment transmission latency.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
v1 -> v2:
- execute algorithm separately for each WMM queue
- change ewma scaling parameters
- calculate max queue len only when new latency data is received
- stop queues when occupancy limit is reached rather than dropping
- use skb->destructor for tracking queue occupancy

Johannes' comment about tx status reporting being unreliable (and what
he was really saying) finally sunk-in.  So, this version uses
skb->destructor to track in-flight fragments.  That should handle
fragments that get silently dropped in the driver for whatever reason
without leaking queue capacity.  Correct me if I'm wrong!

This version runs separate instances of the algorithm for each WMM
queue -- I reckon that makes sense.  I still ignore HT aggregation, as
I'm pretty sure I don't understand how it realy effects the issue.

I still haven't done any objective testing, so still no numbers -- feel
free to provide your own! ;-)  But for me, this version "feels" pretty
good where I meet the chair.

There are still bits that I would like to be adjustable.  But since I'm
still not sure what this ultimately becomes, I'm in no hurry to finalize
a UI.  I would be happy to consider a contribution from someone else in
that regard.

No doubt that this is all still quite preliminary!  I'm pretty sure
it still eats puppies.  So, don't get it wet!  And never, ever feed
it after midnight...

 net/mac80211/ieee80211_i.h |   12 ++++++++++++
 net/mac80211/iface.c       |   12 ++++++++++++
 net/mac80211/status.c      |   23 +++++++++++++++++++++++
 net/mac80211/tx.c          |   26 ++++++++++++++++++++++++++
 4 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f2ef15d..47e65bd 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -604,6 +604,18 @@ struct ieee80211_sub_if_data {
 		struct dentry *default_mgmt_key;
 	} debugfs;
 #endif
+
+	struct {
+		/* number of packets currently in flight */
+		atomic_t enqueued;
+
+		/* computed maximum packets in flight */
+		int max_enqueued;
+
+		/* average packet service time */
+		struct ewma tserv_ns_avg;
+	} qdata[4];
+
 	/* must be last, dynamically sized area in this! */
 	struct ieee80211_vif vif;
 };
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 5a4e19b..3e04ddb 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -839,6 +839,8 @@ static void ieee80211_iface_work(struct work_struct *work)
 static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 				  enum nl80211_iftype type)
 {
+	int i;
+
 	/* clear type-dependent union */
 	memset(&sdata->u, 0, sizeof(sdata->u));
 
@@ -857,6 +859,16 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
 	skb_queue_head_init(&sdata->skb_queue);
 	INIT_WORK(&sdata->work, ieee80211_iface_work);
 
+	for (i=0; i<4; i++) {
+		/* initialize service time estimate for buffer control */
+		ewma_init(&sdata->qdata[i].tserv_ns_avg, 1, 64);
+
+		atomic_set(&sdata->qdata[i].enqueued, 0);
+
+		/* default max should be ??? */
+		sdata->qdata[i].max_enqueued = 2;
+	}
+
 	switch (type) {
 	case NL80211_IFTYPE_P2P_GO:
 		type = NL80211_IFTYPE_AP;
diff --git a/net/mac80211/status.c b/net/mac80211/status.c
index 010a559..8cb6539 100644
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
@@ -208,10 +212,29 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
 	fc = hdr->frame_control;
 
 	for_each_sta_info(local, hdr->addr1, sta, tmp) {
+		int q = skb_get_queue_mapping(skb);
+		unsigned long tserv_ns_avg;
+
 		/* skip wrong virtual interface */
 		if (memcmp(hdr->addr2, sta->sdata->vif.addr, ETH_ALEN))
 			continue;
 
+		/* factor current tserv into service time estimate */
+		ewma_add(&sta->sdata->qdata[q].tserv_ns_avg,
+			 ktime_to_ns(tserv));
+
+		/* determine queue admission qualifications */
+		tserv_ns_avg = ewma_read(&sta->sdata->qdata[q].tserv_ns_avg);
+		if (tserv_ns_avg) {
+			/* latency target and min limit should be tunable? */
+			sta->sdata->qdata[q].max_enqueued =
+				max_t(int, 2, 2 * NSEC_PER_MSEC / tserv_ns_avg);
+		}
+		if (atomic_read(&sta->sdata->qdata[q].enqueued) >=
+				sta->sdata->qdata[q].max_enqueued &&
+		    !ieee80211_queue_stopped(&local->hw, q))
+			ieee80211_stop_queue(&local->hw, q);
+
 		acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
 		if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
 			/*
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 17ef4f4..cba9060 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1284,6 +1284,20 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data *sdata,
 	return TX_CONTINUE;
 }
 
+static void ieee80211_tx_skb_free(struct sk_buff *skb)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(skb->dev);
+	struct ieee80211_local *local = sdata->local;
+	int q = skb_get_queue_mapping(skb);
+
+	/* decrement enqueued count */
+	atomic_dec(&sdata->qdata[q].enqueued);
+
+	/* if queue stopped, wake it */
+	if (ieee80211_queue_stopped(&local->hw, q))
+		ieee80211_wake_queue(&local->hw, q);
+}
+
 static int __ieee80211_tx(struct ieee80211_local *local,
 			  struct sk_buff **skbp,
 			  struct sta_info *sta,
@@ -1323,6 +1337,18 @@ static int __ieee80211_tx(struct ieee80211_local *local,
 
 		sdata = vif_to_sdata(info->control.vif);
 
+		/* timestamp queue entry and increment queue length */
+		skb->tstamp = ktime_get();
+		atomic_inc(&sdata->qdata[q].enqueued);
+
+		/* take ownership of skb */
+		skb_orphan(skb);
+		skb->dev = sdata->dev;
+		skb->destructor = ieee80211_tx_skb_free;
+		if (atomic_read(&sdata->qdata[q].enqueued) >=
+				sdata->qdata[q].max_enqueued)
+			ieee80211_stop_queue(&local->hw, q);
+
 		switch (sdata->vif.type) {
 		case NL80211_IFTYPE_MONITOR:
 			info->control.vif = NULL;
-- 
1.7.4

