Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54298 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753542AbZKPOYr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 09:24:47 -0500
Message-Id: <20091116142413.377808361@sipsolutions.net>
Date: Mon, 16 Nov 2009 15:21:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jouni Malinen <j@w1.fi>
Subject: [RFC 3/3] mac80211: correctly place aMPDU RX reorder code
References: <20091116142134.288122270@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As indicated by the comment, the aMPDU RX reorder code
should logically be after ieee80211_rx_h_check(). The
previous patch moved the code there, and this patch now
hooks it up in that place by introducing a list of skbs
that are then processed by the remaining handlers. The
list may be empty if the function is buffering the skb
to release it later.

The only change needed to the RX data is that the crypto
handler needs to clear the key that may be set from a
previous loop iteration, and that not everything can be
in the rx flags now.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/ieee80211_i.h |    1 
 net/mac80211/rx.c          |  164 ++++++++++++++++++++++++++-------------------
 2 files changed, 96 insertions(+), 69 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-11-16 15:14:23.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-16 15:14:24.000000000 +0100
@@ -555,7 +555,8 @@ static inline u16 seq_sub(u16 sq1, u16 s
 
 static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 					    struct tid_ampdu_rx *tid_agg_rx,
-					    int index)
+					    int index,
+					    struct sk_buff_head *frames)
 {
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_rate *rate = NULL;
@@ -571,9 +572,9 @@ static void ieee80211_release_reorder_fr
 	sband = hw->wiphy->bands[status->band];
 	if (!(status->flag & RX_FLAG_HT))
 		rate = &sband->bitrates[status->rate_idx];
-	__ieee80211_rx_handle_packet(hw, skb, rate);
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
+	skb_queue_tail(frames, skb);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
@@ -581,14 +582,15 @@ no_frame:
 
 static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
 					     struct tid_ampdu_rx *tid_agg_rx,
-					     u16 head_seq_num)
+					     u16 head_seq_num,
+					     struct sk_buff_head *frames)
 {
 	int index;
 
 	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
 		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index, frames);
 	}
 }
 
@@ -608,7 +610,8 @@ static void ieee80211_release_reorder_fr
  */
 static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					     struct tid_ampdu_rx *tid_agg_rx,
-					     struct sk_buff *skb)
+					     struct sk_buff *skb,
+					     struct sk_buff_head *frames)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 sc = le16_to_cpu(hdr->seq_ctrl);
@@ -632,7 +635,8 @@ static bool ieee80211_sta_manage_reorder
 	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
 		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
 		/* release stored frames up to new head to stack */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num,
+						 frames);
 	}
 
 	/* Now the new frame is always in the range of the reordering buffer */
@@ -687,7 +691,8 @@ static bool ieee80211_sta_manage_reorder
 				       "frames\n",
 				       wiphy_name(hw->wiphy));
 #endif
-			ieee80211_release_reorder_frame(hw, tid_agg_rx, j);
+			ieee80211_release_reorder_frame(hw, tid_agg_rx,
+							j, frames);
 
 			/*
 			 * Increment the head seq# also for the skipped slots.
@@ -697,7 +702,7 @@ static bool ieee80211_sta_manage_reorder
 			skipped = 0;
 		}
 	} else while (tid_agg_rx->reorder_buf[index]) {
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index, frames);
 		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
@@ -709,38 +714,39 @@ static bool ieee80211_sta_manage_reorder
  * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
  * true if the MPDU was buffered, false if it should be processed.
  */
-static bool ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-				       struct sk_buff *skb)
+static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
+				       struct sk_buff_head *frames)
 {
+	struct sk_buff *skb = rx->skb;
+	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
-	struct sta_info *sta;
+	struct sta_info *sta = rx->sta;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 sc;
 	int tid;
 
 	if (!ieee80211_is_data_qos(hdr->frame_control))
-		return false;
+		goto dont_reorder;
 
 	/*
 	 * filter the QoS data rx stream according to
 	 * STA/TID and check if this STA/TID is on aggregation
 	 */
 
-	sta = sta_info_get(local, hdr->addr2);
 	if (!sta)
-		return false;
+		goto dont_reorder;
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
 	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
-		return false;
+		goto dont_reorder;
 
 	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
 
 	/* qos null data frames are excluded */
 	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
-		return false;
+		goto dont_reorder;
 
 	/* new, potentially un-ordered, ampdu frame - process it */
 
@@ -755,10 +761,14 @@ static bool ieee80211_rx_reorder_ampdu(s
 		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
 			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
 		dev_kfree_skb(skb);
-		return true;
+		return;
 	}
 
-	return ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb);
+	ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, frames);
+	return;
+
+ dont_reorder:
+	__skb_queue_tail(frames, skb);
 }
 
 static ieee80211_rx_result debug_noinline
@@ -863,6 +873,9 @@ ieee80211_rx_h_decrypt(struct ieee80211_
 	if (!(rx->flags & IEEE80211_RX_RA_MATCH))
 		return RX_CONTINUE;
 
+	/* start without a key */
+	rx->key = NULL;
+
 	if (rx->sta)
 		stakey = rcu_dereference(rx->sta->key);
 
@@ -1811,7 +1824,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
+ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
@@ -1841,7 +1854,8 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 				  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
 		/* release stored frames up to start of BAR */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num);
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num,
+						 frames);
 		kfree_skb(skb);
 		return RX_QUEUED;
 	}
@@ -2164,8 +2178,11 @@ static void ieee80211_invoke_rx_handlers
 					 struct sk_buff *skb,
 					 struct ieee80211_rate *rate)
 {
+	struct sk_buff_head reorder_release;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
+	__skb_queue_head_init(&reorder_release);
+
 	rx->skb = skb;
 	rx->sdata = sdata;
 
@@ -2173,50 +2190,72 @@ static void ieee80211_invoke_rx_handlers
 	do {				\
 		res = rxh(rx);		\
 		if (res != RX_CONTINUE)	\
-			goto rxh_done;  \
+			goto rxh_next;  \
 	} while (0);
 
+	/*
+	 * NB: the rxh_next label works even if we jump
+	 *     to it from here because then the list will
+	 *     be empty, which is a trivial check
+	 */
 	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
-	CALL_RXH(ieee80211_rx_h_decrypt)
-	CALL_RXH(ieee80211_rx_h_check_more_data)
-	CALL_RXH(ieee80211_rx_h_sta_process)
-	CALL_RXH(ieee80211_rx_h_defragment)
-	CALL_RXH(ieee80211_rx_h_ps_poll)
-	CALL_RXH(ieee80211_rx_h_michael_mic_verify)
-	/* must be after MMIC verify so header is counted in MPDU mic */
-	CALL_RXH(ieee80211_rx_h_remove_qos_control)
-	CALL_RXH(ieee80211_rx_h_amsdu)
+
+	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
+
+	while ((skb = __skb_dequeue(&reorder_release))) {
+		/*
+		 * all the other fields are valid across frames
+		 * that belong to an aMPDU since they are on the
+		 * same TID from the same station
+		 */
+		rx->skb = skb;
+
+		CALL_RXH(ieee80211_rx_h_decrypt)
+		CALL_RXH(ieee80211_rx_h_check_more_data)
+		CALL_RXH(ieee80211_rx_h_sta_process)
+		CALL_RXH(ieee80211_rx_h_defragment)
+		CALL_RXH(ieee80211_rx_h_ps_poll)
+		CALL_RXH(ieee80211_rx_h_michael_mic_verify)
+		/* must be after MMIC verify so header is counted in MPDU mic */
+		CALL_RXH(ieee80211_rx_h_remove_qos_control)
+		CALL_RXH(ieee80211_rx_h_amsdu)
 #ifdef CONFIG_MAC80211_MESH
-	if (ieee80211_vif_is_mesh(&sdata->vif))
-		CALL_RXH(ieee80211_rx_h_mesh_fwding);
+		if (ieee80211_vif_is_mesh(&sdata->vif))
+			CALL_RXH(ieee80211_rx_h_mesh_fwding);
 #endif
-	CALL_RXH(ieee80211_rx_h_data)
-	CALL_RXH(ieee80211_rx_h_ctrl)
-	CALL_RXH(ieee80211_rx_h_action)
-	CALL_RXH(ieee80211_rx_h_mgmt)
+		CALL_RXH(ieee80211_rx_h_data)
+
+		/* special treatment -- needs the queue */
+		res = ieee80211_rx_h_ctrl(rx, &reorder_release);
+		if (res != RX_CONTINUE)
+			goto rxh_next;
+
+		CALL_RXH(ieee80211_rx_h_action)
+		CALL_RXH(ieee80211_rx_h_mgmt)
 
 #undef CALL_RXH
 
- rxh_done:
-	switch (res) {
-	case RX_DROP_MONITOR:
-		I802_DEBUG_INC(sdata->local->rx_handlers_drop);
-		if (rx->sta)
-			rx->sta->rx_dropped++;
-		/* fall through */
-	case RX_CONTINUE:
-		ieee80211_rx_cooked_monitor(rx, rate);
-		break;
-	case RX_DROP_UNUSABLE:
-		I802_DEBUG_INC(sdata->local->rx_handlers_drop);
-		if (rx->sta)
-			rx->sta->rx_dropped++;
-		dev_kfree_skb(rx->skb);
-		break;
-	case RX_QUEUED:
-		I802_DEBUG_INC(sdata->local->rx_handlers_queued);
-		break;
+ rxh_next:
+		switch (res) {
+		case RX_DROP_MONITOR:
+			I802_DEBUG_INC(sdata->local->rx_handlers_drop);
+			if (rx->sta)
+				rx->sta->rx_dropped++;
+			/* fall through */
+		case RX_CONTINUE:
+			ieee80211_rx_cooked_monitor(rx, rate);
+			break;
+		case RX_DROP_UNUSABLE:
+			I802_DEBUG_INC(sdata->local->rx_handlers_drop);
+			if (rx->sta)
+				rx->sta->rx_dropped++;
+			dev_kfree_skb(rx->skb);
+			break;
+		case RX_QUEUED:
+			I802_DEBUG_INC(sdata->local->rx_handlers_queued);
+			break;
+		}
 	}
 }
 
@@ -2490,20 +2529,7 @@ void ieee80211_rx(struct ieee80211_hw *h
 		return;
 	}
 
-	/*
-	 * In theory, the block ack reordering should happen after duplicate
-	 * removal (ieee80211_rx_h_check(), which is an RX handler). As such,
-	 * the call to ieee80211_rx_reorder_ampdu() should really be moved to
-	 * happen as a new RX handler between ieee80211_rx_h_check and
-	 * ieee80211_rx_h_decrypt. This cleanup may eventually happen, but for
-	 * the time being, the call can be here since RX reorder buf processing
-	 * will implicitly skip duplicates. We could, in theory at least,
-	 * process frames that ieee80211_rx_h_passive_scan would drop (e.g.,
-	 * frames from other than operational channel), but that should not
-	 * happen in normal networks.
-	 */
-	if (!ieee80211_rx_reorder_ampdu(local, skb))
-		__ieee80211_rx_handle_packet(hw, skb, rate);
+	__ieee80211_rx_handle_packet(hw, skb, rate);
 
 	rcu_read_unlock();
 
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-11-16 15:14:27.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-11-16 15:14:51.000000000 +0100
@@ -163,6 +163,7 @@ typedef unsigned __bitwise__ ieee80211_r
 #define IEEE80211_RX_RA_MATCH		BIT(1)
 #define IEEE80211_RX_AMSDU		BIT(2)
 #define IEEE80211_RX_FRAGMENTED		BIT(3)
+/* only add flags here that do not change with subframes of an aMPDU */
 
 struct ieee80211_rx_data {
 	struct sk_buff *skb;


