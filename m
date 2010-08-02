Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45951 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866Ab0HBNPP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:15:15 -0400
Received: by bwz1 with SMTP id 1so1446928bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 06:15:13 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] mac80211: put rx handlers into seperate functions
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Mon, 2 Aug 2010 15:15:05 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201008021515.06013.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Note: In order to keep diff from removing and re-adding code,
I used forward declarations. So it should be easier to verify
that I didn't change anything related to the reordering logic.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
WIP -> PATCH:
	- no changes
---
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index fa0f37e..8179e62 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -574,6 +574,11 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
 	}
 }
 
+static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
+					  struct tid_ampdu_rx *tid_agg_rx,
+					  struct sk_buff_head *frames);
+
+
 /*
  * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
  * the skb was added to the buffer longer than this time ago, the earlier
@@ -643,6 +648,17 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	tid_agg_rx->reorder_buf[index] = skb;
 	tid_agg_rx->reorder_time[index] = jiffies;
 	tid_agg_rx->stored_mpdu_num++;
+	ieee80211_sta_reorder_release(hw, tid_agg_rx, frames);
+
+	return true;
+}
+
+static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
+					  struct tid_ampdu_rx *tid_agg_rx,
+					  struct sk_buff_head *frames)
+{
+	int index;
+
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 						tid_agg_rx->buf_size;
@@ -686,8 +702,6 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
-
-	return true;
 }
 
 /*
@@ -2267,6 +2281,11 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	dev_kfree_skb(skb);
 }
 
+static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
+					 ieee80211_rx_result res);
+
+static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
+				  struct sk_buff_head *frames);
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 					 struct ieee80211_rx_data *rx,
@@ -2288,17 +2307,34 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 			goto rxh_next;  \
 	} while (0);
 
-	/*
-	 * NB: the rxh_next label works even if we jump
-	 *     to it from here because then the list will
-	 *     be empty, which is a trivial check
-	 */
 	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
 
 	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
 
-	while ((skb = __skb_dequeue(&reorder_release))) {
+	ieee80211_rx_handlers(rx, &reorder_release);
+	return;
+
+ rxh_next:
+	ieee80211_rx_handlers_result(rx, res);
+
+#undef CALL_RXH
+}
+
+static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
+				  struct sk_buff_head *frames)
+{
+	ieee80211_rx_result res = RX_DROP_MONITOR;
+	struct sk_buff *skb;
+
+#define CALL_RXH(rxh)			\
+	do {				\
+		res = rxh(rx);		\
+		if (res != RX_CONTINUE)	\
+			goto rxh_next;  \
+	} while (0);
+
+	while ((skb = __skb_dequeue(frames))) {
 		/*
 		 * all the other fields are valid across frames
 		 * that belong to an aMPDU since they are on the
@@ -2316,41 +2352,58 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
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
 
- rxh_next:
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
 		}
+	case RX_DROP_UNUSABLE:
+		I802_DEBUG_INC(rx->sdata->local->rx_handlers_drop);
+		if (rx->sta)
+			rx->sta->rx_dropped++;
+		dev_kfree_skb(rx->skb);
+		break;
+	case RX_QUEUED:
+		I802_DEBUG_INC(rx->sdata->local->rx_handlers_queued);
+		break;
 	}
 }
 
