Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab0G1PV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 11:21:28 -0400
Received: by bwz1 with SMTP id 1so4018409bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 08:21:27 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [WIP 2/3] mac80211: remove (now) unused rate function parameters
Date: Wed, 28 Jul 2010 17:21:24 +0200
Cc: linux-wireless@vger.kernel.org
References: <201007270820.25347.chunkeey@googlemail.com> <1280219845.19098.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280219845.19098.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007281721.25200.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dead code removal. This can probably go in in one form
or another.

---
additionally: we could drop the extra sdata parameter of

prepare_for_handlers
ieee80211_invoke_rx_handlers

and use the one from the rx_data structure?
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
 
