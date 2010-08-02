Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46807 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752000Ab0HBNPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:15:48 -0400
Received: by bwz1 with SMTP id 1so1447189bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 06:15:46 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/3] mac80211: remove unused rate function parameters
Cc: Johannes Berg j <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 2 Aug 2010 15:15:44 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201008021515.44901.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
WIP -> PATCH:
	- no changes
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8179e62..6cb5541 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -538,20 +538,12 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 					    int index,
 					    struct sk_buff_head *frames)
 {
-	struct ieee80211_supported_band *sband;
-	struct ieee80211_rate *rate = NULL;
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
-	struct ieee80211_rx_status *status;
 
 	if (!skb)
 		goto no_frame;
 
-	status = IEEE80211_SKB_RXCB(skb);
-
-	/* release the reordered frames to stack */
-	sband = hw->wiphy->bands[status->band];
-	if (!(status->flag & RX_FLAG_HT))
-		rate = &sband->bitrates[status->rate_idx];
+	/* release the frame from the reorder ring buffer */
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
 	__skb_queue_tail(frames, skb);
@@ -2289,8 +2281,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_rx_data *rx,
-					 struct sk_buff *skb,
-					 struct ieee80211_rate *rate)
+					 struct sk_buff *skb)
 {
 	struct sk_buff_head reorder_release;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
@@ -2500,8 +2491,7 @@ static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
  * be called with rcu_read_lock protection.
  */
 static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
-					 struct sk_buff *skb,
-					 struct ieee80211_rate *rate)
+					 struct sk_buff *skb)
 {
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct ieee80211_local *local = hw_to_local(hw);
@@ -2609,7 +2599,7 @@ static void __ieee80211_rx_handle_packet(struct ieee80211_hw *hw,
 					       prev->name);
 				goto next;
 			}
-			ieee80211_invoke_rx_handlers(prev, &rx, skb_new, rate);
+			ieee80211_invoke_rx_handlers(prev, &rx, skb_new);
 next:
 			prev = sdata;
 		}
@@ -2625,7 +2615,7 @@ next:
 		}
 	}
 	if (prev)
-		ieee80211_invoke_rx_handlers(prev, &rx, skb, rate);
+		ieee80211_invoke_rx_handlers(prev, &rx, skb);
 	else
 		dev_kfree_skb(skb);
 }
@@ -2711,7 +2701,7 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 		return;
 	}
 
-	__ieee80211_rx_handle_packet(hw, skb, rate);
+	__ieee80211_rx_handle_packet(hw, skb);
 
 	rcu_read_unlock();
 
