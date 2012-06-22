Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:48650 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932866Ab2FVNOs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Jun 2012 09:14:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] mac80211: pass sdata to some RX functions
Date: Fri, 22 Jun 2012 15:14:39 +0200
Message-Id: <1340370882-9258-4-git-send-email-johannes@sipsolutions.net> (sfid-20120622_151452_567059_A93D0478)
In-Reply-To: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
References: <1340370882-9258-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For better debugging, we would like to have
the sdata pointer available later, so pass
it into these functions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/mac80211/rx.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 446a327..9f1bd69 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -554,11 +554,11 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
 }
 
 
-static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
+static void ieee80211_release_reorder_frame(struct ieee80211_sub_if_data *sdata,
 					    struct tid_ampdu_rx *tid_agg_rx,
 					    int index)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_local *local = sdata->local;
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
 	struct ieee80211_rx_status *status;
 
@@ -578,7 +578,7 @@ no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
 }
 
-static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
+static void ieee80211_release_reorder_frames(struct ieee80211_sub_if_data *sdata,
 					     struct tid_ampdu_rx *tid_agg_rx,
 					     u16 head_seq_num)
 {
@@ -589,7 +589,7 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
 	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
 		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
+		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index);
 	}
 }
 
@@ -604,7 +604,7 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
  */
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
-static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
+static void ieee80211_sta_reorder_release(struct ieee80211_sub_if_data *sdata,
 					  struct tid_ampdu_rx *tid_agg_rx)
 {
 	int index, j;
@@ -634,10 +634,10 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			if (net_ratelimit())
-				wiphy_debug(hw->wiphy,
+				wiphy_debug(sdata->local->hw.wiphy,
 					    "release an RX reorder frame due to timeout on earlier frames\n");
 #endif
-			ieee80211_release_reorder_frame(hw, tid_agg_rx, j);
+			ieee80211_release_reorder_frame(sdata, tid_agg_rx, j);
 
 			/*
 			 * Increment the head seq# also for the skipped slots.
@@ -647,7 +647,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 			skipped = 0;
 		}
 	} else while (tid_agg_rx->reorder_buf[index]) {
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
+		ieee80211_release_reorder_frame(sdata, tid_agg_rx, index);
 		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
@@ -677,7 +677,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
  * rcu_read_lock protection. It returns false if the frame
  * can be processed immediately, true if it was consumed.
  */
-static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
+static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_sub_if_data *sdata,
 					     struct tid_ampdu_rx *tid_agg_rx,
 					     struct sk_buff *skb)
 {
@@ -706,7 +706,8 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
 		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
 		/* release stored frames up to new head to stack */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
+		ieee80211_release_reorder_frames(sdata, tid_agg_rx,
+						 head_seq_num);
 	}
 
 	/* Now the new frame is always in the range of the reordering buffer */
@@ -736,7 +737,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	tid_agg_rx->reorder_buf[index] = skb;
 	tid_agg_rx->reorder_time[index] = jiffies;
 	tid_agg_rx->stored_mpdu_num++;
-	ieee80211_sta_reorder_release(hw, tid_agg_rx);
+	ieee80211_sta_reorder_release(sdata, tid_agg_rx);
 
  out:
 	spin_unlock(&tid_agg_rx->reorder_lock);
@@ -751,7 +752,6 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_local *local = rx->local;
-	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(skb);
 	struct sta_info *sta = rx->sta;
@@ -813,7 +813,7 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 	 * sure that we cannot get to it any more before doing
 	 * anything with it.
 	 */
-	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb))
+	if (ieee80211_sta_manage_reorder_buf(rx->sdata, tid_agg_rx, skb))
 		return;
 
  dont_reorder:
@@ -2058,8 +2058,6 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 {
-	struct ieee80211_local *local = rx->local;
-	struct ieee80211_hw *hw = &local->hw;
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_bar *bar = (struct ieee80211_bar *)skb->data;
 	struct tid_ampdu_rx *tid_agg_rx;
@@ -2096,7 +2094,8 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 
 		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num);
+		ieee80211_release_reorder_frames(rx->sdata, tid_agg_rx,
+						 start_seq_num);
 		spin_unlock(&tid_agg_rx->reorder_lock);
 
 		kfree_skb(skb);
@@ -2747,7 +2746,7 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 		return;
 
 	spin_lock(&tid_agg_rx->reorder_lock);
-	ieee80211_sta_reorder_release(&sta->local->hw, tid_agg_rx);
+	ieee80211_sta_reorder_release(sta->sdata, tid_agg_rx);
 	spin_unlock(&tid_agg_rx->reorder_lock);
 
 	ieee80211_rx_handlers(&rx);
-- 
1.7.10

