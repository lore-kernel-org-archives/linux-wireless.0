Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62634 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab0L3Qqm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Dec 2010 11:46:42 -0500
Received: by fxm20 with SMTP id 20so11325491fxm.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Dec 2010 08:46:41 -0800 (PST)
Message-Id: <3f6f7ecee0ecea67238627fb1a60611087ce0ee3.1293727387.git.chunkeey@googlemail.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 30 Dec 2010 17:25:29 +0100
Subject: [PATCH 1/2] mac80211: serialize rx path workers
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, linville@tuxdriver.com
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses the issue of serialization between
the main rx path and various reorder release timers.

<http://www.spinics.net/lists/linux-wireless/msg57214.html>

It converts the previously local "frames" queue into
a global rx queue [rx_skb_queue]. This way, everyone
(be it the main rx-path or some reorder release timeout)
can add frames to it.

Only one active rx handler worker [ieee80211_rx_handlers]
is needed. All other threads which have lost the race of
"runnning_rx_handler" can now simply "return", knowing that
the thread who had the "edge" will also take care of their
workload.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
 net/mac80211/ieee80211_i.h |    9 +++++
 net/mac80211/main.c        |    3 ++
 net/mac80211/rx.c          |   80 ++++++++++++++++++++-----------------------
 3 files changed, 49 insertions(+), 43 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a0cf5ab..acc1299 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -774,6 +774,15 @@ struct ieee80211_local {
 	struct sk_buff_head skb_queue;
 	struct sk_buff_head skb_queue_unreliable;
 
+	/*
+	 * Internal FIFO queue which is shared between multiple rx path
+	 * stages. Its main task is to provide a serialization mechanism,
+	 * so all rx handlers can enjoy having exclusive access to their
+	 * private data structures.
+	 */
+	struct sk_buff_head rx_skb_queue;
+	bool running_rx_handler;	/* protected by rx_skb_queue.lock */
+
 	/* Station data */
 	/*
 	 * The mutex only protects the list and counter,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 32e58ee..485d36b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -569,6 +569,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	skb_queue_head_init(&local->rx_skb_queue);
+
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
 	ieee80211_work_init(local);
@@ -917,6 +919,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 		wiphy_warn(local->hw.wiphy, "skb_queue not empty\n");
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
+	skb_queue_purge(&local->rx_skb_queue);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e9d3bc..62a82ec 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -533,9 +533,9 @@ static inline u16 seq_sub(u16 sq1, u16 sq2)
 
 static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 					    struct tid_ampdu_rx *tid_agg_rx,
-					    int index,
-					    struct sk_buff_head *frames)
+					    int index)
 {
+	struct ieee80211_local *local = hw_to_local(hw);
 	struct sk_buff *skb = tid_agg_rx->reorder_buf[index];
 
 	lockdep_assert_held(&tid_agg_rx->reorder_lock);
@@ -546,7 +546,7 @@ static void ieee80211_release_reorder_frame(struct ieee80211_hw *hw,
 	/* release the frame from the reorder ring buffer */
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
-	__skb_queue_tail(frames, skb);
+	skb_queue_tail(&local->rx_skb_queue, skb);
 
 no_frame:
 	tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
@@ -554,8 +554,7 @@ no_frame:
 
 static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
 					     struct tid_ampdu_rx *tid_agg_rx,
-					     u16 head_seq_num,
-					     struct sk_buff_head *frames)
+					     u16 head_seq_num)
 {
 	int index;
 
@@ -564,7 +563,7 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
 	while (seq_less(tid_agg_rx->head_seq_num, head_seq_num)) {
 		index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index, frames);
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
 	}
 }
 
@@ -580,8 +579,7 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
 static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
-					  struct tid_ampdu_rx *tid_agg_rx,
-					  struct sk_buff_head *frames)
+					  struct tid_ampdu_rx *tid_agg_rx)
 {
 	int index, j;
 
@@ -612,8 +610,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 				wiphy_debug(hw->wiphy,
 					    "release an RX reorder frame due to timeout on earlier frames\n");
 #endif
-			ieee80211_release_reorder_frame(hw, tid_agg_rx,
-							j, frames);
+			ieee80211_release_reorder_frame(hw, tid_agg_rx, j);
 
 			/*
 			 * Increment the head seq# also for the skipped slots.
@@ -623,7 +620,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 			skipped = 0;
 		}
 	} else while (tid_agg_rx->reorder_buf[index]) {
-		ieee80211_release_reorder_frame(hw, tid_agg_rx, index, frames);
+		ieee80211_release_reorder_frame(hw, tid_agg_rx, index);
 		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
@@ -679,8 +676,7 @@ set_release_timer:
  */
 static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					     struct tid_ampdu_rx *tid_agg_rx,
-					     struct sk_buff *skb,
-					     struct sk_buff_head *frames)
+					     struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 sc = le16_to_cpu(hdr->seq_ctrl);
@@ -707,8 +703,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
 		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
 		/* release stored frames up to new head to stack */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num,
-						 frames);
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
 	}
 
 	/* Now the new frame is always in the range of the reordering buffer */
@@ -736,7 +731,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	tid_agg_rx->reorder_buf[index] = skb;
 	tid_agg_rx->reorder_time[index] = jiffies;
 	tid_agg_rx->stored_mpdu_num++;
-	ieee80211_sta_reorder_release(hw, tid_agg_rx, frames);
+	ieee80211_sta_reorder_release(hw, tid_agg_rx);
 
  out:
 	spin_unlock(&tid_agg_rx->reorder_lock);
@@ -747,8 +742,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
  * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
  * true if the MPDU was buffered, false if it should be processed.
  */
-static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
-				       struct sk_buff_head *frames)
+static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_local *local = rx->local;
@@ -803,11 +797,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	 * sure that we cannot get to it any more before doing
 	 * anything with it.
 	 */
-	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, frames))
+	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb))
 		return;
 
  dont_reorder:
-	__skb_queue_tail(frames, skb);
+	skb_queue_tail(&local->rx_skb_queue, skb);
 }
 
 static ieee80211_rx_result debug_noinline
@@ -1930,7 +1924,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
+ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
@@ -1970,8 +1964,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 
 		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num,
-						 frames);
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num);
 		spin_unlock(&tid_agg_rx->reorder_lock);
 
 		kfree_skb(skb);
@@ -2488,8 +2481,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	}
 }
 
-static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
-				  struct sk_buff_head *frames)
+static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 	struct sk_buff *skb;
@@ -2501,7 +2493,15 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 			goto rxh_next;  \
 	} while (0);
 
-	while ((skb = __skb_dequeue(frames))) {
+	spin_lock(&rx->local->rx_skb_queue.lock);
+	if (rx->local->running_rx_handler)
+		goto unlock;
+
+	rx->local->running_rx_handler = true;
+
+	while ((skb = __skb_dequeue(&rx->local->rx_skb_queue))) {
+		spin_unlock(&rx->local->rx_skb_queue.lock);
+
 		/*
 		 * all the other fields are valid across frames
 		 * that belong to an aMPDU since they are on the
@@ -2524,12 +2524,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 			CALL_RXH(ieee80211_rx_h_mesh_fwding);
 #endif
 		CALL_RXH(ieee80211_rx_h_data)
-
-		/* special treatment -- needs the queue */
-		res = ieee80211_rx_h_ctrl(rx, frames);
-		if (res != RX_CONTINUE)
-			goto rxh_next;
-
+		CALL_RXH(ieee80211_rx_h_ctrl);
 		CALL_RXH(ieee80211_rx_h_mgmt_check)
 		CALL_RXH(ieee80211_rx_h_action)
 		CALL_RXH(ieee80211_rx_h_userspace_mgmt)
@@ -2538,18 +2533,20 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 
  rxh_next:
 		ieee80211_rx_handlers_result(rx, res);
-
+		spin_lock(&rx->local->rx_skb_queue.lock);
 #undef CALL_RXH
 	}
+
+	rx->local->running_rx_handler = false;
+
+ unlock:
+	spin_unlock(&rx->local->rx_skb_queue.lock);
 }
 
 static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 {
-	struct sk_buff_head reorder_release;
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 
-	__skb_queue_head_init(&reorder_release);
-
 #define CALL_RXH(rxh)			\
 	do {				\
 		res = rxh(rx);		\
@@ -2560,9 +2557,9 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
 
-	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
+	ieee80211_rx_reorder_ampdu(rx);
 
-	ieee80211_rx_handlers(rx, &reorder_release);
+	ieee80211_rx_handlers(rx);
 	return;
 
  rxh_next:
@@ -2577,7 +2574,6 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
  */
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 {
-	struct sk_buff_head frames;
 	struct ieee80211_rx_data rx = {
 		.sta = sta,
 		.sdata = sta->sdata,
@@ -2590,13 +2586,11 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 	if (!tid_agg_rx)
 		return;
 
-	__skb_queue_head_init(&frames);
-
 	spin_lock(&tid_agg_rx->reorder_lock);
-	ieee80211_sta_reorder_release(&sta->local->hw, tid_agg_rx, &frames);
+	ieee80211_sta_reorder_release(&sta->local->hw, tid_agg_rx);
 	spin_unlock(&tid_agg_rx->reorder_lock);
 
-	ieee80211_rx_handlers(&rx, &frames);
+	ieee80211_rx_handlers(&rx);
 }
 
 /* main receive path */
-- 
1.7.2.3

