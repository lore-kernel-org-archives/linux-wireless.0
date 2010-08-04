Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37442 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759425Ab0HDXgN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 19:36:13 -0400
Received: by bwz1 with SMTP id 1so2671501bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 16:36:10 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3 v2] mac80211: put rx handlers into separate functions
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 5 Aug 2010 01:36:04 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201008050136.05372.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch takes the reorder logic from the RX path and
moves it into separate routines to make the expired frame
release accessible.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
WIP -> v1:
 	- no changes

v1 -> v2:
	- rearrange code and get rid of the forward declaration
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fa0f37e..fccd5f7 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -583,6 +583,57 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
  */
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
+static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
+					  struct tid_ampdu_rx *tid_agg_rx,
+					  struct sk_buff_head *frames)
+{
+	int index;
+
+	/* release the buffer until next missing frame */
+	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+						tid_agg_rx->buf_size;
+	if (!tid_agg_rx->reorder_buf[index] &&
+	    tid_agg_rx->stored_mpdu_num > 1) {
+		/*
+		 * No buffers ready to be released, but check whether any
+		 * frames in the reorder buffer have timed out.
+		 */
+		int j;
+		int skipped = 1;
+		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
+		     j = (j + 1) % tid_agg_rx->buf_size) {
+			if (!tid_agg_rx->reorder_buf[j]) {
+				skipped++;
+				continue;
+			}
+			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
+					HT_RX_REORDER_BUF_TIMEOUT))
+				break;
+
+#ifdef CONFIG_MAC80211_HT_DEBUG
+			if (net_ratelimit())
+				printk(KERN_DEBUG "%s: release an RX reorder "
+				       "frame due to timeout on earlier "
+				       "frames\n",
+				       wiphy_name(hw->wiphy));
+#endif
+			ieee80211_release_reorder_frame(hw, tid_agg_rx,
+							j, frames);
+
+			/*
+			 * Increment the head seq# also for the skipped slots.
+			 */
+			tid_agg_rx->head_seq_num =
+				(tid_agg_rx->head_seq_num + skipped) & SEQ_MASK;
+			skipped = 0;
+		}
+	} else while (tid_agg_rx->reorder_buf[index]) {
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index, frames);
+		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+							tid_agg_rx->buf_size;
+	}
+}
+
 /*
  * As this function belongs to the RX path it must be under
  * rcu_read_lock protection. It returns false if the frame
@@ -643,49 +694,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	tid_agg_rx->reorder_buf[index] = skb;
 	tid_agg_rx->reorder_time[index] = jiffies;
 	tid_agg_rx->stored_mpdu_num++;
-	/* release the buffer until next missing frame */
-	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
-						tid_agg_rx->buf_size;
-	if (!tid_agg_rx->reorder_buf[index] &&
-	    tid_agg_rx->stored_mpdu_num > 1) {
-		/*
-		 * No buffers ready to be released, but check whether any
-		 * frames in the reorder buffer have timed out.
-		 */
-		int j;
-		int skipped = 1;
-		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
-		     j = (j + 1) % tid_agg_rx->buf_size) {
-			if (!tid_agg_rx->reorder_buf[j]) {
-				skipped++;
-				continue;
-			}
-			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
-					HT_RX_REORDER_BUF_TIMEOUT))
-				break;
-
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			if (net_ratelimit())
-				printk(KERN_DEBUG "%s: release an RX reorder "
-				       "frame due to timeout on earlier "
-				       "frames\n",
-				       wiphy_name(hw->wiphy));
-#endif
-			ieee80211_release_reorder_frame(hw, tid_agg_rx,
-							j, frames);
-
-			/*
-			 * Increment the head seq# also for the skipped slots.
-			 */
-			tid_agg_rx->head_seq_num =
-				(tid_agg_rx->head_seq_num + skipped) & SEQ_MASK;
-			skipped = 0;
-		}
-	} else while (tid_agg_rx->reorder_buf[index]) {
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index, frames);
-		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
-							tid_agg_rx->buf_size;
-	}
+	ieee80211_sta_reorder_release(hw, tid_agg_rx, frames);
 
 	return true;
 }
@@ -2267,19 +2276,46 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	dev_kfree_skb(skb);
 }
 
+static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
+					 ieee80211_rx_result res)
+{
+	switch (res) {
+	case RX_DROP_MONITOR:
+		I802_DEBUG_INC(rx->sdata->local->rx_handlers_drop);
+		if (rx->sta)
+			rx->sta->rx_dropped++;
+		/* fall through */
+	case RX_CONTINUE: {
+		struct ieee80211_rate *rate = NULL;
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_rx_status *status;
+
+		status = IEEE80211_SKB_RXCB((rx->skb));
+
+		sband = rx->local->hw.wiphy->bands[status->band];
+		if (!(status->flag & RX_FLAG_HT))
+			rate = &sband->bitrates[status->rate_idx];
+
+		ieee80211_rx_cooked_monitor(rx, rate);
+		break;
+		}
+	case RX_DROP_UNUSABLE:
+		I802_DEBUG_INC(rx->sdata->local->rx_handlers_drop);
+		if (rx->sta)
+			rx->sta->rx_dropped++;
+		dev_kfree_skb(rx->skb);
+		break;
+	case RX_QUEUED:
+		I802_DEBUG_INC(rx->sdata->local->rx_handlers_queued);
+		break;
+	}
+}
 
-static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_rx_data *rx,
-					 struct sk_buff *skb,
-					 struct ieee80211_rate *rate)
+static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
+				  struct sk_buff_head *frames)
 {
-	struct sk_buff_head reorder_release;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
-
-	__skb_queue_head_init(&reorder_release);
-
-	rx->skb = skb;
-	rx->sdata = sdata;
+	struct sk_buff *skb;
 
 #define CALL_RXH(rxh)			\
 	do {				\
@@ -2288,17 +2324,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 			goto rxh_next;  \
 	} while (0);
 
-	/*
-	 * NB: the rxh_next label works even if we jump
-	 *     to it from here because then the list will
-	 *     be empty, which is a trivial check
-	 */
-	CALL_RXH(ieee80211_rx_h_passive_scan)
-	CALL_RXH(ieee80211_rx_h_check)
-
-	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
-
-	while ((skb = __skb_dequeue(&reorder_release))) {
+	while ((skb = __skb_dequeue(frames))) {
 		/*
 		 * all the other fields are valid across frames
 		 * that belong to an aMPDU since they are on the
@@ -2316,42 +2342,58 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 		CALL_RXH(ieee80211_rx_h_remove_qos_control)
 		CALL_RXH(ieee80211_rx_h_amsdu)
 #ifdef CONFIG_MAC80211_MESH
-		if (ieee80211_vif_is_mesh(&sdata->vif))
+		if (ieee80211_vif_is_mesh(&rx->sdata->vif))
 			CALL_RXH(ieee80211_rx_h_mesh_fwding);
 #endif
 		CALL_RXH(ieee80211_rx_h_data)
 
 		/* special treatment -- needs the queue */
-		res = ieee80211_rx_h_ctrl(rx, &reorder_release);
+		res = ieee80211_rx_h_ctrl(rx, frames);
 		if (res != RX_CONTINUE)
 			goto rxh_next;
 
 		CALL_RXH(ieee80211_rx_h_action)
 		CALL_RXH(ieee80211_rx_h_mgmt)
 
+ rxh_next:
+		ieee80211_rx_handlers_result(rx, res);
+
 #undef CALL_RXH
+	}
+}
+
+static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
+					 struct ieee80211_rx_data *rx,
+					 struct sk_buff *skb,
+					 struct ieee80211_rate *rate)
+{
+	struct sk_buff_head reorder_release;
+	ieee80211_rx_result res = RX_DROP_MONITOR;
+
+	__skb_queue_head_init(&reorder_release);
+
+	rx->skb = skb;
+	rx->sdata = sdata;
+
+#define CALL_RXH(rxh)			\
+	do {				\
+		res = rxh(rx);		\
+		if (res != RX_CONTINUE)	\
+			goto rxh_next;  \
+	} while (0);
+
+	CALL_RXH(ieee80211_rx_h_passive_scan)
+	CALL_RXH(ieee80211_rx_h_check)
+
+	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
+
+	ieee80211_rx_handlers(rx, &reorder_release);
+	return;
 
  rxh_next:
-		switch (res) {
-		case RX_DROP_MONITOR:
-			I802_DEBUG_INC(sdata->local->rx_handlers_drop);
-			if (rx->sta)
-				rx->sta->rx_dropped++;
-			/* fall through */
-		case RX_CONTINUE:
-			ieee80211_rx_cooked_monitor(rx, rate);
-			break;
-		case RX_DROP_UNUSABLE:
-			I802_DEBUG_INC(sdata->local->rx_handlers_drop);
-			if (rx->sta)
-				rx->sta->rx_dropped++;
-			dev_kfree_skb(rx->skb);
-			break;
-		case RX_QUEUED:
-			I802_DEBUG_INC(sdata->local->rx_handlers_queued);
-			break;
-		}
-	}
+	ieee80211_rx_handlers_result(rx, res);
+
+#undef CALL_RXH
 }
 
 /* main receive path */
