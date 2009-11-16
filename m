Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:40756 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbZKPLIv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Nov 2009 06:08:51 -0500
Message-Id: <20091116110720.865556081@sipsolutions.net>
Date: Mon, 16 Nov 2009 12:00:40 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Subject: [PATCH 4/4] mac80211: cleanup reorder buffer handling
References: <20091116110036.010062226@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The reorder buffer handling is written in a quite
peculiar style (especially comments) and also has
a quirk where it invokes the entire reorder code
in ieee80211_sta_manage_reorder_buf() for just a
handful of lines in it with a special argument.

Split out ieee80211_release_reorder_frames which
can then be invoked from BAR handling and other
reordering code, clean up code and comments and
remove function arguments that are now unused from
ieee80211_sta_manage_reorder_buf().

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/rx.c |  162 +++++++++++++++++++++++++++---------------------------
 1 file changed, 81 insertions(+), 81 deletions(-)

--- wireless-testing.orig/net/mac80211/rx.c	2009-11-16 11:40:20.000000000 +0100
+++ wireless-testing/net/mac80211/rx.c	2009-11-16 11:48:36.000000000 +0100
@@ -27,11 +27,10 @@
 #include "tkip.h"
 #include "wme.h"
 
-static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
-					   struct tid_ampdu_rx *tid_agg_rx,
-					   struct sk_buff *skb,
-					   u16 mpdu_seq_num,
-					   int bar_req);
+static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
+					     struct tid_ampdu_rx *tid_agg_rx,
+					     u16 head_seq_num);
+
 /*
  * monitor mode reception
  *
@@ -1592,11 +1591,11 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 
 	if (ieee80211_is_back_req(bar->frame_control)) {
 		if (!rx->sta)
-			return RX_CONTINUE;
+			return RX_DROP_MONITOR;
 		tid = le16_to_cpu(bar->control) >> 12;
 		if (rx->sta->ampdu_mlme.tid_state_rx[tid]
 					!= HT_AGG_STATE_OPERATIONAL)
-			return RX_CONTINUE;
+			return RX_DROP_MONITOR;
 		tid_agg_rx = rx->sta->ampdu_mlme.tid_rx[tid];
 
 		start_seq_num = le16_to_cpu(bar->start_seq_num) >> 4;
@@ -1606,13 +1605,10 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_
 			mod_timer(&tid_agg_rx->session_timer,
 				  TU_TO_EXP_TIME(tid_agg_rx->timeout));
 
-		/* manage reordering buffer according to requested */
-		/* sequence number */
-		rcu_read_lock();
-		ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, NULL,
-						 start_seq_num, 1);
-		rcu_read_unlock();
-		return RX_DROP_UNUSABLE;
+		/* release stored frames up to start of BAR */
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num);
+		kfree_skb(skb);
+		return RX_QUEUED;
 	}
 
 	return RX_CONTINUE;
@@ -2223,6 +2219,18 @@ no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
 }
 
+static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
+					     struct tid_ampdu_rx *tid_agg_rx,
+					     u16 head_seq_num)
+{
+	int index;
+
+	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
+		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+							tid_agg_rx->buf_size;
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
+	}
+}
 
 /*
  * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
@@ -2234,15 +2242,17 @@ no_frame:
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
 /*
- * As it function blongs to Rx path it must be called with
- * the proper rcu_read_lock protection for its flow.
+ * As this function belongs to the RX path it must be under
+ * rcu_read_lock protection. It returns false if the frame
+ * can be processed immediately, true if it was consumed.
  */
-static u8 ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
-					   struct tid_ampdu_rx *tid_agg_rx,
-					   struct sk_buff *skb,
-					   u16 mpdu_seq_num,
-					   int bar_req)
+static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
+					     struct tid_ampdu_rx *tid_agg_rx,
+					     struct sk_buff *skb)
 {
+	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+	u16 sc = le16_to_cpu(hdr->seq_ctrl);
+	u16 mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
 	u16 head_seq_num, buf_size;
 	int index;
 
@@ -2252,47 +2262,37 @@ static u8 ieee80211_sta_manage_reorder_b
 	/* frame with out of date sequence number */
 	if (seq_less(mpdu_seq_num, head_seq_num)) {
 		dev_kfree_skb(skb);
-		return 1;
+		return true;
 	}
 
-	/* if frame sequence number exceeds our buffering window size or
-	 * block Ack Request arrived - release stored frames */
-	if ((!seq_less(mpdu_seq_num, head_seq_num + buf_size)) || (bar_req)) {
-		/* new head to the ordering buffer */
-		if (bar_req)
-			head_seq_num = mpdu_seq_num;
-		else
-			head_seq_num =
-				seq_inc(seq_sub(mpdu_seq_num, buf_size));
+	/*
+	 * If frame the sequence number exceeds our buffering window
+	 * size release some previous frames to make room for this one.
+	 */
+	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
+		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
 		/* release stored frames up to new head to stack */
-		while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
-			index = seq_sub(tid_agg_rx->head_seq_num,
-				tid_agg_rx->ssn)
-				% tid_agg_rx->buf_size;
-			ieee80211_release_reorder_frame(hw, tid_agg_rx,
-							index);
-		}
-		if (bar_req)
-			return 1;
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
 	}
 
-	/* now the new frame is always in the range of the reordering */
-	/* buffer window */
-	index = seq_sub(mpdu_seq_num, tid_agg_rx->ssn)
-				% tid_agg_rx->buf_size;
+	/* Now the new frame is always in the range of the reordering buffer */
+
+	index = seq_sub(mpdu_seq_num, tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+
 	/* check if we already stored this frame */
 	if (tid_agg_rx->reorder_buf[index]) {
 		dev_kfree_skb(skb);
-		return 1;
+		return true;
 	}
 
-	/* if arrived mpdu is in the right order and nothing else stored */
-	/* release it immediately */
+	/*
+	 * If the current MPDU is in the right order and nothing else
+	 * is stored we can process it directly, no need to buffer it.
+	 */
 	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
-			tid_agg_rx->stored_mpdu_num == 0) {
-		tid_agg_rx->head_seq_num =
-			seq_inc(tid_agg_rx->head_seq_num);
-		return 0;
+	    tid_agg_rx->stored_mpdu_num == 0) {
+		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
+		return false;
 	}
 
 	/* put the frame in the reordering buffer */
@@ -2300,8 +2300,8 @@ static u8 ieee80211_sta_manage_reorder_b
 	tid_agg_rx->reorder_time[index] = jiffies;
 	tid_agg_rx->stored_mpdu_num++;
 	/* release the buffer until next missing frame */
-	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn)
-						% tid_agg_rx->buf_size;
+	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+						tid_agg_rx->buf_size;
 	if (!tid_agg_rx->reorder_buf[index] &&
 	    tid_agg_rx->stored_mpdu_num > 1) {
 		/*
@@ -2312,12 +2312,12 @@ static u8 ieee80211_sta_manage_reorder_b
 		int skipped = 1;
 		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
-			if (tid_agg_rx->reorder_buf[j] == NULL) {
+			if (!tid_agg_rx->reorder_buf[j]) {
 				skipped++;
 				continue;
 			}
 			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
-					HZ / 10))
+					HT_RX_REORDER_BUF_TIMEOUT))
 				break;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
@@ -2333,51 +2333,56 @@ static u8 ieee80211_sta_manage_reorder_b
 			 * Increment the head seq# also for the skipped slots.
 			 */
 			tid_agg_rx->head_seq_num =
-				(tid_agg_rx->head_seq_num + skipped) &
-				SEQ_MASK;
+				(tid_agg_rx->head_seq_num + skipped) & SEQ_MASK;
 			skipped = 0;
 		}
 	} else while (tid_agg_rx->reorder_buf[index]) {
 		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
-		index =	seq_sub(tid_agg_rx->head_seq_num,
-			tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
+							tid_agg_rx->buf_size;
 	}
-	return 1;
+
+	return true;
 }
 
-static u8 ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
-				     struct sk_buff *skb)
+/*
+ * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
+ * true if the MPDU was buffered, false if it should be processed.
+ */
+static bool ieee80211_rx_reorder_ampdu(struct ieee80211_local *local,
+				       struct sk_buff *skb)
 {
 	struct ieee80211_hw *hw = &local->hw;
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	struct sta_info *sta;
 	struct tid_ampdu_rx *tid_agg_rx;
 	u16 sc;
-	u16 mpdu_seq_num;
-	u8 ret = 0;
 	int tid;
 
+	if (!ieee80211_is_data_qos(hdr->frame_control))
+		return false;
+
+	/*
+	 * filter the QoS data rx stream according to
+	 * STA/TID and check if this STA/TID is on aggregation
+	 */
+
 	sta = sta_info_get(local, hdr->addr2);
 	if (!sta)
-		return ret;
-
-	/* filter the QoS data rx stream according to
-	 * STA/TID and check if this STA/TID is on aggregation */
-	if (!ieee80211_is_data_qos(hdr->frame_control))
-		goto end_reorder;
+		return false;
 
 	tid = *ieee80211_get_qos_ctl(hdr) & IEEE80211_QOS_CTL_TID_MASK;
 
 	if (sta->ampdu_mlme.tid_state_rx[tid] != HT_AGG_STATE_OPERATIONAL)
-		goto end_reorder;
+		return false;
 
 	tid_agg_rx = sta->ampdu_mlme.tid_rx[tid];
 
 	/* qos null data frames are excluded */
 	if (unlikely(hdr->frame_control & cpu_to_le16(IEEE80211_STYPE_NULLFUNC)))
-		goto end_reorder;
+		return false;
 
-	/* new un-ordered ampdu frame - process it */
+	/* new, potentially un-ordered, ampdu frame - process it */
 
 	/* reset session timer */
 	if (tid_agg_rx->timeout)
@@ -2389,16 +2394,11 @@ static u8 ieee80211_rx_reorder_ampdu(str
 	if (sc & IEEE80211_SCTL_FRAG) {
 		ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
 			tid, 0, WLAN_REASON_QSTA_REQUIRE_SETUP);
-		ret = 1;
-		goto end_reorder;
+		dev_kfree_skb(skb);
+		return true;
 	}
 
-	/* according to mpdu sequence number deal with reordering buffer */
-	mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
-	ret = ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb,
-						mpdu_seq_num, 0);
- end_reorder:
-	return ret;
+	return ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb);
 }
 
 /*


