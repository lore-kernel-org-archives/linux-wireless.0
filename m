Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40838 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850Ab1KFNPT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Nov 2011 08:15:19 -0500
Message-Id: <20111106131425.238504799@sipsolutions.net> (sfid-20111106_142607_852517_0E43DCEE)
Date: Sun, 06 Nov 2011 14:13:34 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] mac80211: implement wifi TX status
References: <20111106131332.746774119@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Implement the socket wifi TX status error
queue reflection in mac80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h     |    5 +---
 net/mac80211/ieee80211_i.h |    4 +++
 net/mac80211/main.c        |   18 ++++++++++++++
 net/mac80211/status.c      |   38 ++++++++++++++++++++++++++++++
 net/mac80211/tx.c          |   56 ++++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 115 insertions(+), 6 deletions(-)

--- a/net/mac80211/status.c	2011-11-03 14:02:28.000000000 +0100
+++ b/net/mac80211/status.c	2011-11-03 14:03:12.000000000 +0100
@@ -548,6 +548,24 @@ void ieee80211_tx_status(struct ieee8021
 		}
 	}
 
+	if (unlikely(info->ack_frame_id)) {
+		struct sk_buff *ack_skb;
+		unsigned long flags;
+
+		spin_lock_irqsave(&local->ack_status_lock, flags);
+		ack_skb = idr_find(&local->ack_status_frames,
+				   info->ack_frame_id);
+		if (ack_skb)
+			idr_remove(&local->ack_status_frames,
+				   info->ack_frame_id);
+		spin_unlock_irqrestore(&local->ack_status_lock, flags);
+
+		/* consumes ack_skb */
+		if (ack_skb)
+			skb_complete_wifi_ack(ack_skb,
+				info->flags & IEEE80211_TX_STAT_ACK);
+	}
+
 	/* this was a transmitted frame, but now we want to reuse it */
 	skb_orphan(skb);
 
@@ -621,6 +639,26 @@ EXPORT_SYMBOL(ieee80211_report_low_ack);
 
 void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
+
+	if (unlikely(info->ack_frame_id)) {
+		struct sk_buff *ack_skb;
+		unsigned long flags;
+
+		spin_lock_irqsave(&local->ack_status_lock, flags);
+		ack_skb = idr_find(&local->ack_status_frames,
+				   info->ack_frame_id);
+		if (ack_skb)
+			idr_remove(&local->ack_status_frames,
+				   info->ack_frame_id);
+		spin_unlock_irqrestore(&local->ack_status_lock, flags);
+
+		/* consumes ack_skb */
+		if (ack_skb)
+			dev_kfree_skb_any(ack_skb);
+	}
+
 	dev_kfree_skb_any(skb);
 }
 EXPORT_SYMBOL(ieee80211_free_txskb);
--- a/net/mac80211/tx.c	2011-11-03 13:48:28.000000000 +0100
+++ b/net/mac80211/tx.c	2011-11-03 14:03:12.000000000 +0100
@@ -1684,8 +1684,10 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	int nh_pos, h_pos;
 	struct sta_info *sta = NULL;
 	bool wme_sta = false, authorized = false, tdls_auth = false;
-	struct sk_buff *tmp_skb;
 	bool tdls_direct = false;
+	bool multicast;
+	u32 info_flags = 0;
+	u16 info_id = 0;
 
 	if (unlikely(skb->len < ETH_HLEN)) {
 		ret = NETDEV_TX_OK;
@@ -1872,7 +1874,8 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	 * if it is a multicast address (which can only happen
 	 * in AP mode)
 	 */
-	if (!is_multicast_ether_addr(hdr.addr1)) {
+	multicast = is_multicast_ether_addr(hdr.addr1);
+	if (!multicast) {
 		rcu_read_lock();
 		sta = sta_info_get(sdata, hdr.addr1);
 		if (sta) {
@@ -1913,11 +1916,54 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 		goto fail;
 	}
 
+	if (unlikely(!multicast && skb->sk &&
+		     skb_shinfo(skb)->tx_flags & SKBTX_WIFI_STATUS)) {
+		struct sk_buff *orig_skb = skb;
+
+		skb = skb_clone(skb, GFP_ATOMIC);
+		if (skb) {
+			unsigned long flags;
+			int id, r;
+
+			spin_lock_irqsave(&local->ack_status_lock, flags);
+			r = idr_get_new_above(&local->ack_status_frames,
+					      orig_skb, 1, &id);
+			if (r == -EAGAIN) {
+				idr_pre_get(&local->ack_status_frames,
+					    GFP_ATOMIC);
+				r = idr_get_new_above(&local->ack_status_frames,
+						      orig_skb, 1, &id);
+			}
+			if (WARN_ON(!id) || id > 0xffff) {
+				idr_remove(&local->ack_status_frames, id);
+				r = -ERANGE;
+			}
+			spin_unlock_irqrestore(&local->ack_status_lock, flags);
+
+			if (!r) {
+				info_id = id;
+				info_flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
+			} else if (skb_shared(skb)) {
+				kfree_skb(orig_skb);
+			} else {
+				kfree_skb(skb);
+				skb = orig_skb;
+			}
+		} else {
+			/* couldn't clone -- lose tx status ... */
+			skb = orig_skb;
+		}
+	}
+
 	/*
 	 * If the skb is shared we need to obtain our own copy.
 	 */
 	if (skb_shared(skb)) {
-		tmp_skb = skb;
+		struct sk_buff *tmp_skb = skb;
+
+		/* can't happen -- skb is a clone if info_id != 0 */
+		WARN_ON(info_id);
+
 		skb = skb_clone(skb, GFP_ATOMIC);
 		kfree_skb(tmp_skb);
 
@@ -2018,6 +2064,10 @@ netdev_tx_t ieee80211_subif_start_xmit(s
 	memset(info, 0, sizeof(*info));
 
 	dev->trans_start = jiffies;
+
+	info->flags = info_flags;
+	info->ack_frame_id = info_id;
+
 	ieee80211_xmit(sdata, skb);
 
 	return NETDEV_TX_OK;
--- a/include/net/mac80211.h	2011-11-03 14:02:28.000000000 +0100
+++ b/include/net/mac80211.h	2011-11-03 14:03:12.000000000 +0100
@@ -518,7 +518,7 @@ struct ieee80211_tx_rate {
  * @flags: transmit info flags, defined above
  * @band: the band to transmit on (use for checking for races)
  * @antenna_sel_tx: antenna to use, 0 for automatic diversity
- * @pad: padding, ignore
+ * @ack_frame_id: internal frame ID for TX status, used internally
  * @control: union for control data
  * @status: union for status data
  * @driver_data: array of driver_data pointers
@@ -535,8 +535,7 @@ struct ieee80211_tx_info {
 
 	u8 antenna_sel_tx;
 
-	/* 2 byte hole */
-	u8 pad[2];
+	u16 ack_frame_id;
 
 	union {
 		struct {
--- a/net/mac80211/ieee80211_i.h	2011-11-03 14:02:35.000000000 +0100
+++ b/net/mac80211/ieee80211_i.h	2011-11-03 14:03:12.000000000 +0100
@@ -24,6 +24,7 @@
 #include <linux/spinlock.h>
 #include <linux/etherdevice.h>
 #include <linux/leds.h>
+#include <linux/idr.h>
 #include <net/ieee80211_radiotap.h>
 #include <net/cfg80211.h>
 #include <net/mac80211.h>
@@ -1017,6 +1018,9 @@ struct ieee80211_local {
 	u32 hw_roc_cookie;
 	bool hw_roc_for_tx;
 
+	struct idr ack_status_frames;
+	spinlock_t ack_status_lock;
+
 	/* dummy netdev for use w/ NAPI */
 	struct net_device napi_dev;
 
--- a/net/mac80211/main.c	2011-11-03 14:02:35.000000000 +0100
+++ b/net/mac80211/main.c	2011-11-03 14:03:12.000000000 +0100
@@ -598,6 +598,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 			WIPHY_FLAG_4ADDR_STATION |
 			WIPHY_FLAG_REPORTS_OBSS;
 
+	wiphy->features = NL80211_FEATURE_SK_TX_STATUS;
+
 	if (!ops->set_key)
 		wiphy->flags |= WIPHY_FLAG_IBSS_RSN;
 
@@ -671,6 +673,11 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	INIT_WORK(&local->sched_scan_stopped_work,
 		  ieee80211_sched_scan_stopped_work);
 
+	spin_lock_init(&local->ack_status_lock);
+	idr_init(&local->ack_status_frames);
+	/* preallocate at least one entry */
+	idr_pre_get(&local->ack_status_frames, GFP_KERNEL);
+
 	sta_info_init(local);
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
@@ -1046,6 +1053,13 @@ void ieee80211_unregister_hw(struct ieee
 }
 EXPORT_SYMBOL(ieee80211_unregister_hw);
 
+static int ieee80211_free_ack_frame(int id, void *p, void *data)
+{
+	WARN_ONCE(1, "Have pending ack frames!\n");
+	kfree_skb(p);
+	return 0;
+}
+
 void ieee80211_free_hw(struct ieee80211_hw *hw)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -1056,6 +1070,10 @@ void ieee80211_free_hw(struct ieee80211_
 	if (local->wiphy_ciphers_allocated)
 		kfree(local->hw.wiphy->cipher_suites);
 
+	idr_for_each(&local->ack_status_frames,
+		     ieee80211_free_ack_frame, NULL);
+	idr_destroy(&local->ack_status_frames);
+
 	wiphy_free(local->hw.wiphy);
 }
 EXPORT_SYMBOL(ieee80211_free_hw);


