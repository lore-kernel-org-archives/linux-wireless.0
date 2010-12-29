Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33572 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790Ab0L2XPN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Dec 2010 18:15:13 -0500
Received: by fxm20 with SMTP id 20so10836877fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Dec 2010 15:15:11 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: serialize rx path workers
Date: Thu, 30 Dec 2010 00:15:08 +0100
Cc: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201012300015.09858.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch addresses the issue of serialization between
the main rx path and various reorder release timers.

<http://www.spinics.net/lists/linux-wireless/msg57214.html>

As discussed before, we can choose between:
	1. get a new rx-path lock

	2. convert all drivers to use ieee80211_rx_irqsafe
	  and let the tasklet handle the timeout procedure.

	3. call the release reorder code from within ieee80211_rx()
	  (e.g.: before returning back to the driver)

	4. like 1. but without the global "lock".
	   (this patch)

	5. ... maybe more?

Seems like we are spoilt for choice?
However, each way does have its own unique drawback.

	1. Locking is easy to implement but hard to maintain.
	   Furthermore, Johannes worked very hard to get rid
	   of as many as possible.

	2. converting the drivers to ieee80211_rx_irqsafe has
	   the drawback that frames have to go through several
	   queues and tasklets/workers (driver and mac80211)
	   before they can be passed on to net-core (backlog).
	   I tried this approach before and on a UP-system
	   ath9k struggled to reach even 11g speeds.
	  
	3. Not so bad, but in order to work properly the driver
	   needs to "deliver" a constant stream of frames. 
	   Which isn't a problem, as long as beacons are not
	   filtered and the beacon interval is reasonably short.

So, what should we do?

The attached solution is so far the easiest to implement.
It converts the previously local "frames" queue into
a global rx queue (reorder_release). This way, everyone
(be it the main rx-path or some reorder release timeout)
can add frames to it.

Now, only one active rx handler worker (ieee80211_rx_handlers)
is needed. All other threads which have lost the race of
"runnning_rx_handlers" can now simply "return", knowing that
the thread who had the "edge" will also take care of their
workload.

(not the most intelligent bits, but it's getting late...) 
---
Don't forget that the reorder release timers have been
disabled. If you want to test this patch, you must also
revert "mac80211: temporarily disable reorder release timer"
(15943a72c7d2031c9150917ca9161a9f891d455a in wt.git)

Regards,
	Chr

 ieee80211_i.h |    3 ++
 main.c        |    4 ++
 rx.c          |   82 +++++++++++++++++++++++++---------------------------------
 3 files changed, 43 insertions(+), 46 deletions(-)

---
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index a0cf5ab..57b223a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -704,6 +704,9 @@ struct ieee80211_local {
 	struct work_struct work_work;
 	struct sk_buff_head work_skb_queue;
 
+	struct sk_buff_head reorder_release;
+	atomic_t running_rx_handlers;
+
 	/*
 	 * private workqueue to mac80211. mac80211 makes this accessible
 	 * via ieee80211_queue_work()
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 32e58ee..18f7e9a 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -569,6 +569,9 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	skb_queue_head_init(&local->reorder_release);
+	atomic_set(&local->running_rx_handlers, 0);
+
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
 	ieee80211_work_init(local);
@@ -917,6 +920,7 @@ void ieee80211_unregister_hw(struct ieee80211_hw *hw)
 		wiphy_warn(local->hw.wiphy, "skb_queue not empty\n");
 	skb_queue_purge(&local->skb_queue);
 	skb_queue_purge(&local->skb_queue_unreliable);
+	skb_queue_purge(&local->reorder_release);
 
 	destroy_workqueue(local->workqueue);
 	wiphy_unregister(local->hw.wiphy);
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 5e9d3bc..842824e 100644
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
+	skb_queue_tail(&local->reorder_release, skb);
 
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
@@ -679,8 +675,7 @@ set_release_timer:
  */
 static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 					     struct tid_ampdu_rx *tid_agg_rx,
-					     struct sk_buff *skb,
-					     struct sk_buff_head *frames)
+					     struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
 	u16 sc = le16_to_cpu(hdr->seq_ctrl);
@@ -707,8 +702,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	if (!seq_less(mpdu_seq_num, head_seq_num + buf_size)) {
 		head_seq_num = seq_inc(seq_sub(mpdu_seq_num, buf_size));
 		/* release stored frames up to new head to stack */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num,
-						 frames);
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, head_seq_num);
 	}
 
 	/* Now the new frame is always in the range of the reordering buffer */
@@ -736,7 +730,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	tid_agg_rx->reorder_buf[index] = skb;
 	tid_agg_rx->reorder_time[index] = jiffies;
 	tid_agg_rx->stored_mpdu_num++;
-	ieee80211_sta_reorder_release(hw, tid_agg_rx, frames);
+	ieee80211_sta_reorder_release(hw, tid_agg_rx);
 
  out:
 	spin_unlock(&tid_agg_rx->reorder_lock);
@@ -747,8 +741,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
  * Reorder MPDUs from A-MPDUs, keeping them on a buffer. Returns
  * true if the MPDU was buffered, false if it should be processed.
  */
-static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
-				       struct sk_buff_head *frames)
+static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx)
 {
 	struct sk_buff *skb = rx->skb;
 	struct ieee80211_local *local = rx->local;
@@ -803,11 +796,11 @@ static void ieee80211_rx_reorder_ampdu(struct ieee80211_rx_data *rx,
 	 * sure that we cannot get to it any more before doing
 	 * anything with it.
 	 */
-	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb, frames))
+	if (ieee80211_sta_manage_reorder_buf(hw, tid_agg_rx, skb))
 		return;
 
  dont_reorder:
-	__skb_queue_tail(frames, skb);
+	skb_queue_tail(&local->reorder_release, skb);
 }
 
 static ieee80211_rx_result debug_noinline
@@ -1930,7 +1923,7 @@ ieee80211_rx_h_data(struct ieee80211_rx_data *rx)
 }
 
 static ieee80211_rx_result debug_noinline
-ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
+ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx)
 {
 	struct ieee80211_local *local = rx->local;
 	struct ieee80211_hw *hw = &local->hw;
@@ -1970,8 +1963,7 @@ ieee80211_rx_h_ctrl(struct ieee80211_rx_data *rx, struct sk_buff_head *frames)
 
 		spin_lock(&tid_agg_rx->reorder_lock);
 		/* release stored frames up to start of BAR */
-		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num,
-						 frames);
+		ieee80211_release_reorder_frames(hw, tid_agg_rx, start_seq_num);
 		spin_unlock(&tid_agg_rx->reorder_lock);
 
 		kfree_skb(skb);
@@ -2488,8 +2480,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	}
 }
 
-static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
-				  struct sk_buff_head *frames)
+static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx)
 {
 	ieee80211_rx_result res = RX_DROP_MONITOR;
 	struct sk_buff *skb;
@@ -2501,7 +2492,13 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 			goto rxh_next;  \
 	} while (0);
 
-	while ((skb = __skb_dequeue(frames))) {
+rerun:
+	if (atomic_inc_return(&rx->local->running_rx_handlers) > 1) {
+		atomic_dec(&rx->local->running_rx_handlers);
+		return;
+	}
+
+	while ((skb = skb_dequeue(&rx->local->reorder_release))) {
 		/*
 		 * all the other fields are valid across frames
 		 * that belong to an aMPDU since they are on the
@@ -2524,12 +2521,7 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
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
@@ -2541,15 +2533,16 @@ static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
 
 #undef CALL_RXH
 	}
+
+	atomic_dec(&rx->local->running_rx_handlers);
+	if (!skb_queue_empty(&rx->local->reorder_release))
+		goto rerun;
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
@@ -2560,9 +2553,9 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
 	CALL_RXH(ieee80211_rx_h_passive_scan)
 	CALL_RXH(ieee80211_rx_h_check)
 
-	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
+	ieee80211_rx_reorder_ampdu(rx);
 
-	ieee80211_rx_handlers(rx, &reorder_release);
+	ieee80211_rx_handlers(rx);
 	return;
 
  rxh_next:
@@ -2577,7 +2570,6 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_rx_data *rx)
  */
 void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
 {
-	struct sk_buff_head frames;
 	struct ieee80211_rx_data rx = {
 		.sta = sta,
 		.sdata = sta->sdata,
@@ -2590,13 +2582,11 @@ void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
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
