Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37885 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322Ab0IWTiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Sep 2010 15:38:54 -0400
Message-Id: <20100923193818.848665239@sipsolutions.net>
Date: Thu, 23 Sep 2010 21:37:49 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 2/3] mac80211: consolidate packet processing
References: <20100923193747.677517441@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are now four instances of vaguely the same
code that does packet preparation, checking if
for MMIC errors and reporting them, and then
invoking packet processing. Consolidate all of
these.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |  165 ++++++++++++++++++++----------------------------------
 1 file changed, 62 insertions(+), 103 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2010-09-23 21:37:15.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2010-09-23 21:37:29.000000000 +0200
@@ -2443,18 +2443,13 @@ static void ieee80211_rx_handlers(struct
 	}
 }
 
-static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_rx_data *rx,
-					 struct sk_buff *skb)
+static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 {
 	struct sk_buff_head reorder_release;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
 	__skb_queue_head_init(&reorder_release);
 
-	rx->skb = skb;
-	rx->sdata = sdata;
-
 #define CALL_RXH(rxh)			\
 	do {				\
 		res = rxh(rx);		\
@@ -2598,21 +2593,63 @@ static int prepare_for_handlers(struct i
 }
 
 /*
+ * This function returns whether or not the SKB
+ * was destined for RX processing or not, which,
+ * if consume is true, is equivalent to whether
+ * or not the skb was consumed.
+ */
+static bool ieee80211_prepare_and_rx_handle(struct ieee80211_rx_data *rx,
+					    struct sk_buff *skb, bool consume)
+{
+	struct ieee80211_local *local = rx->local;
+	struct ieee80211_sub_if_data *sdata = rx->sdata;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
+	struct ieee80211_hdr *hdr = (void *)skb->data;
+	int prepares;
+
+	rx->skb = skb;
+	rx->flags |= IEEE80211_RX_RA_MATCH;
+	prepares = prepare_for_handlers(rx, hdr);
+
+	if (!prepares)
+		return false;
+
+	if (status->flag & RX_FLAG_MMIC_ERROR) {
+		if (rx->flags & IEEE80211_RX_RA_MATCH)
+			ieee80211_rx_michael_mic_report(hdr, rx);
+		return false;
+	}
+
+	if (!consume) {
+		skb = skb_copy(skb, GFP_ATOMIC);
+		if (!skb) {
+			if (net_ratelimit())
+				wiphy_debug(local->hw.wiphy,
+					"failed to copy multicast frame for %s\n",
+					sdata->name);
+			return true;
+		}
+
+		rx->skb = skb;
+	}
+
+	ieee80211_invoke_rx_handlers(rx);
+	return true;
+}
+
+/*
  * This is the actual Rx frames handler. as it blongs to Rx path it must
  * be called with rcu_read_lock protection.
  */
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					 struct sk_buff *skb)
 {
-	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_local *local = hw_to_local(hw);
 	struct ieee80211_sub_if_data *sdata;
 	struct ieee80211_hdr *hdr;
 	__le16 fc;
 	struct ieee80211_rx_data rx;
-	int prepares;
-	struct ieee80211_sub_if_data *prev = NULL;
-	struct sk_buff *skb_new;
+	struct ieee80211_sub_if_data *prev;
 	struct sta_info *sta, *tmp, *prev_sta;
 	bool found_sta = false;
 	int err = 0;
@@ -2645,8 +2682,10 @@ static void __ieee80211_rx_handle_packet
 
 	if (ieee80211_is_data(fc)) {
 		prev_sta = NULL;
+
 		for_each_sta_info(local, hdr->addr2, sta, tmp) {
 			found_sta = true;
+
 			if (!prev_sta) {
 				prev_sta = sta;
 				continue;
@@ -2654,65 +2693,23 @@ static void __ieee80211_rx_handle_packet
 
 			rx.sta = prev_sta;
 			rx.sdata = prev_sta->sdata;
+			ieee80211_prepare_and_rx_handle(&rx, skb, false);
 
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(&rx, hdr);
-			if (!prepares)
-				goto next_sta;
-
-			if (status->flag & RX_FLAG_MMIC_ERROR) {
-				if (rx.flags & IEEE80211_RX_RA_MATCH)
-					ieee80211_rx_michael_mic_report(hdr, &rx);
-				goto next_sta;
-			}
-
-			/*
-			 * frame was destined for the previous interface
-			 * so invoke RX handlers for it
-			 */
-			skb_new = skb_copy(skb, GFP_ATOMIC);
-			if (!skb_new) {
-				if (net_ratelimit())
-					wiphy_debug(local->hw.wiphy,
-						    "failed to copy multicast"
-						    " frame for %s\n",
-						    prev_sta->sdata->name);
-				goto next_sta;
-			}
-			ieee80211_invoke_rx_handlers(prev_sta->sdata, &rx,
-						     skb_new);
-next_sta:
 			prev_sta = sta;
-		} /* for all STA info */
+		}
 
 		if (prev_sta) {
 			rx.sta = prev_sta;
 			rx.sdata = prev_sta->sdata;
 
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(&rx, hdr);
-			if (!prepares)
-				prev_sta = NULL;
-
-			if (prev_sta && status->flag & RX_FLAG_MMIC_ERROR) {
-				if (rx.flags & IEEE80211_RX_RA_MATCH)
-					ieee80211_rx_michael_mic_report(hdr, &rx);
-				prev_sta = NULL;
-			}
-		}
-
-
-		if (prev_sta) {
-			ieee80211_invoke_rx_handlers(prev_sta->sdata, &rx, skb);
-			return;
-		} else {
-			if (found_sta) {
-				dev_kfree_skb(skb);
+			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
 				return;
-			}
 		}
-	} /* if data frame */
+	}
+
 	if (!found_sta) {
+		prev = NULL;
+
 		list_for_each_entry_rcu(sdata, &local->interfaces, list) {
 			if (!ieee80211_sdata_running(sdata))
 				continue;
@@ -2734,35 +2731,8 @@ next_sta:
 
 			rx.sta = sta_info_get_bss(prev, hdr->addr2);
 			rx.sdata = prev;
+			ieee80211_prepare_and_rx_handle(&rx, skb, false);
 
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(&rx, hdr);
-
-			if (!prepares)
-				goto next;
-
-			if (status->flag & RX_FLAG_MMIC_ERROR) {
-				if (rx.flags & IEEE80211_RX_RA_MATCH)
-					ieee80211_rx_michael_mic_report(hdr,
-									&rx);
-				goto next;
-			}
-
-			/*
-			 * frame was destined for the previous interface
-			 * so invoke RX handlers for it
-			 */
-
-			skb_new = skb_copy(skb, GFP_ATOMIC);
-			if (!skb_new) {
-				if (net_ratelimit())
-					wiphy_debug(local->hw.wiphy,
-						    "failed to copy multicast frame for %s\n",
-						    prev->name);
-				goto next;
-			}
-			ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
-next:
 			prev = sdata;
 		}
 
@@ -2770,24 +2740,13 @@ next:
 			rx.sta = sta_info_get_bss(prev, hdr->addr2);
 			rx.sdata = prev;
 
-			rx.flags |= IEEE80211_RX_RA_MATCH;
-			prepares = prepare_for_handlers(&rx, hdr);
-
-			if (!prepares)
-				prev = NULL;
-
-			if (prev && status->flag & RX_FLAG_MMIC_ERROR) {
-				if (rx.flags & IEEE80211_RX_RA_MATCH)
-					ieee80211_rx_michael_mic_report(hdr,
-									&rx);
-				prev = NULL;
-			}
+			if (ieee80211_prepare_and_rx_handle(&rx, skb, true))
+				return;
 		}
+
 	}
-	if (prev)
-		ieee80211_invoke_rx_handlers(prev, &rx, skb);
-	else
-		dev_kfree_skb(skb);
+
+	dev_kfree_skb(skb);
 }
 
 /*


