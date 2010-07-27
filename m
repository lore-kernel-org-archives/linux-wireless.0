Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59099 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab0G0GUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jul 2010 02:20:34 -0400
Received: by wwj40 with SMTP id 40so872558wwj.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Jul 2010 23:20:32 -0700 (PDT)
Received: from debian64.daheim
	([192.168.0.4] helo=debian64.localnet ident=chuck)
	by debian64.daheim with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <chunkeey@googlemail.com>)
	id 1OddWg-0003LA-Ph
	for linux-wireless@vger.kernel.org; Tue, 27 Jul 2010 08:20:30 +0200
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [WIP] mac80211: AMPDU rx reorder timeout timer
Date: Tue, 27 Jul 2010 08:20:24 +0200
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Message-Id: <201007270820.25347.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This (rather _unfinished_ :-D ) patch adds a timer which
if trigger schedules the automatic release of all expired
A-MPDU frames. This implementation has the advantage that
all queued-up MPDU will now arrive in the network core
within a timely manner.

In my "experiments", the patch helped to ironed out the
sudden throughput drops that have been _killing_ my
average tcp performance ever since I can remember.

But there is a catch: The logs will quickly fill up with:
"release an RX reorder frame due to timeout on earlier frames".
and the package loss will goes through the roof...

Now, I can think of several reasons why this could happen:
	1. we don't wait long enough for the HT peer to
		finish their _retry_ procedure?

	2. previously - when the stream simply _stopped_ - we had
		to wait until the tcp retry kick in again. So we had
		some "silent" periods and therefore less noise from
		the reordering code?

	3. ->bugs<- but where are they?

Regards,
	Christian
---
yeah, it's past 8 AM here...

so please excuse me, if this is nothing but utter rubbish.
---
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 965b272..947352e 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -86,6 +86,11 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     tid, 0, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
+	del_timer_sync(&tid_rx->reorder_timer);
+
+	spin_lock_bh(&local->tid_rx_reorder_lock);
+	list_del_init(&tid_rx->reorder_head);
+	spin_unlock_bh(&local->tid_rx_reorder_lock);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
@@ -120,6 +125,28 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
 }
 
+static void sta_rx_agg_reorder_timer_expired(unsigned long data)
+{
+	/* not an elegant detour, but there is no choice as the timer passes
+	 * only one argument, and various sta_info are needed here, so init
+	 * flow in sta_info_create gives the TID as data, while the timer_to_id
+	 * array gives the sta through container_of */
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
+					 timer_to_tid[0]);
+
+	struct ieee80211_local *local = sta->local;
+	struct tid_ampdu_rx *tid_rx = sta->ampdu_mlme.tid_rx[*ptid];
+
+	spin_lock_bh(&local->tid_rx_reorder_lock);
+	if (list_empty(&tid_rx->reorder_head))
+		list_add_tail(&tid_rx->reorder_head, &local->tid_rx_reorder);
+	spin_unlock_bh(&local->tid_rx_reorder_lock);
+
+	tasklet_schedule(&local->tasklet);
+}
+
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
 				      u8 dialog_token, u16 status, u16 policy,
 				      u16 buf_size, u16 timeout)
@@ -251,11 +278,17 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		goto end;
 	}
 
-	/* rx timer */
+	/* rx session timer */
 	tid_agg_rx->session_timer.function = sta_rx_agg_session_timer_expired;
 	tid_agg_rx->session_timer.data = (unsigned long)&sta->timer_to_tid[tid];
 	init_timer(&tid_agg_rx->session_timer);
 
+	/* rx reorder timer */
+	INIT_LIST_HEAD(&tid_agg_rx->reorder_head);
+	tid_agg_rx->reorder_timer.function = sta_rx_agg_reorder_timer_expired;
+	tid_agg_rx->reorder_timer.data = (unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&tid_agg_rx->reorder_timer);
+
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
 		kcalloc(buf_size, sizeof(struct sk_buff *), GFP_ATOMIC);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c6b5c2d..b8bd0f9 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -704,6 +704,8 @@ struct ieee80211_local {
 	struct tasklet_struct tasklet;
 	struct sk_buff_head skb_queue;
 	struct sk_buff_head skb_queue_unreliable;
+	spinlock_t tid_rx_reorder_lock;
+	struct list_head tid_rx_reorder;
 
 	/* Station data */
 	/*
@@ -1241,6 +1243,8 @@ int ieee80211_wk_remain_on_channel(struct ieee80211_sub_if_data *sdata,
 int ieee80211_wk_cancel_remain_on_channel(
 	struct ieee80211_sub_if_data *sdata, u64 cookie);
 
+void ieee80211_release_reorder_timeout(struct sta_info *sta, unsigned int tid);
+
 /* channel management */
 enum ieee80211_chan_mode {
 	CHAN_MODE_UNDEFINED,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0e95c75..7bff2db 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -281,6 +281,26 @@ static void ieee80211_tasklet_handler(unsigned long data)
 			break;
 		}
 	}
+
+	spin_lock_bh(&local->tid_rx_reorder_lock);
+	while (!list_empty(&local->tid_rx_reorder)) {
+		struct tid_ampdu_rx *iter;
+		struct sta_info *sta;
+		u8 *ptid, *timer_to_id;
+
+		iter = list_first_entry(&local->tid_rx_reorder,
+					struct tid_ampdu_rx,
+					reorder_head);
+
+		ptid = (u8 *)iter->session_timer.data;
+		timer_to_id = ptid - *ptid;
+		sta = container_of(timer_to_id, struct sta_info,
+				   timer_to_tid[0]);
+
+		list_del_init(&iter->reorder_head);
+		ieee80211_release_reorder_timeout(sta, *ptid);
+	}
+	spin_unlock_bh(&local->tid_rx_reorder_lock);
 }
 
 static void ieee80211_restart_work(struct work_struct *work)
@@ -448,6 +468,8 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 
 	INIT_LIST_HEAD(&local->interfaces);
+	INIT_LIST_HEAD(&local->tid_rx_reorder);
+	spin_lock_init(&local->tid_rx_reorder_lock);
 
 	__hw_addr_init(&local->mc_list);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index d70e1a9..fae1dbe 100644
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
 	/* release the reordered frames to stack */
-	sband = hw->wiphy->bands[status->band];
-	if (!(status->flag & RX_FLAG_HT))
-		rate = &sband->bitrates[status->rate_idx];
 	tid_agg_rx->stored_mpdu_num--;
 	tid_agg_rx->reorder_buf[index] = NULL;
 	__skb_queue_tail(frames, skb);
@@ -583,6 +575,73 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
  */
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
+static void ieee80211_sta_reorder_timeout(struct ieee80211_hw *hw,
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
+					HT_RX_REORDER_BUF_TIMEOUT)) {
+
+				mod_timer(&tid_agg_rx->reorder_timer, jiffies -
+					  tid_agg_rx->reorder_time[j] + 1 +
+					  HT_RX_REORDER_BUF_TIMEOUT);
+				break;
+			}
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
+	} else {
+		while (tid_agg_rx->reorder_buf[index]) {
+			ieee80211_release_reorder_frame(hw, tid_agg_rx,
+							index, frames);
+			index =	seq_sub(tid_agg_rx->head_seq_num,
+				tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+		}
+
+		if (tid_agg_rx->stored_mpdu_num) {
+			mod_timer(&tid_agg_rx->reorder_timer, jiffies -
+				  tid_agg_rx->reorder_time[index] + 1 +
+				  HT_RX_REORDER_BUF_TIMEOUT);
+		} else {
+			del_timer(&tid_agg_rx->reorder_timer);
+		}
+	}
+}
+
 /*
  * As this function belongs to the RX path it must be under
  * rcu_read_lock protection. It returns false if the frame
@@ -643,49 +702,8 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
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
+	ieee80211_sta_reorder_timeout(hw, tid_agg_rx, frames);
 
 	return true;
 }
@@ -2267,19 +2285,47 @@ static void ieee80211_rx_cooked_monitor(struct ieee80211_rx_data *rx,
 	dev_kfree_skb(skb);
 }
 
-
-static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
-					 struct ieee80211_rx_data *rx,
-					 struct sk_buff *skb,
-					 struct ieee80211_rate *rate)
+static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
+					 ieee80211_rx_result res)
 {
-	struct sk_buff_head reorder_release;
-	ieee80211_rx_result res = RX_DROP_MONITOR;
+	struct ieee80211_rx_status *status;
 
-	__skb_queue_head_init(&reorder_release);
+	switch (res) {
+	case RX_DROP_MONITOR:
+		I802_DEBUG_INC(rx->sdata->local->rx_handlers_drop);
+		if (rx->sta)
+			rx->sta->rx_dropped++;
+		/* fall through */
+	case RX_CONTINUE: {
+		struct ieee80211_rate *rate = NULL;
+		struct ieee80211_supported_band *sband;
 
-	rx->skb = skb;
-	rx->sdata = sdata;
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
+
+static void ieee80211_rx_handlers(struct ieee80211_rx_data *rx,
+				  struct sk_buff_head *frames)
+{
+	ieee80211_rx_result res = RX_DROP_MONITOR;
+	struct sk_buff *skb;
 
 #define CALL_RXH(rxh)			\
 	do {				\
@@ -2288,17 +2334,7 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
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
@@ -2316,42 +2352,88 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
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
+	/*
+	 * NB: the rxh_next label works even if we jump
+	 *     to it from here because then the list will
+	 *     be empty, which is a trivial check
+	 */
+	CALL_RXH(ieee80211_rx_h_passive_scan)
+	CALL_RXH(ieee80211_rx_h_check)
+
+	ieee80211_rx_reorder_ampdu(rx, &reorder_release);
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
+}
+
+void ieee80211_release_reorder_timeout(struct sta_info *sta, unsigned int tid)
+{
+	struct sk_buff_head frames;
+	struct ieee80211_rx_data rx = { };
+
+	__skb_queue_head_init(&frames);
+
+	rx.sdata = sta->sdata;
+	rx.local = sta->local;
+	rx.sta = sta;
+	rx.queue = tid;
+	rx.flags |= IEEE80211_RX_RA_MATCH;
+
+	if (unlikely(test_bit(SCAN_HW_SCANNING, &sta->local->scanning) ||
+		     test_bit(SCAN_OFF_CHANNEL, &sta->local->scanning)))
+		rx.flags |= IEEE80211_RX_IN_SCAN;
+
+	rcu_read_lock();
+	ieee80211_sta_reorder_timeout(&sta->local->hw,
+		sta->ampdu_mlme.tid_rx[tid], &frames);
+
+	ieee80211_rx_handlers(&rx, &frames);
+	rcu_read_unlock();
+
 }
 
 /* main receive path */
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 54262e7..4dccce8 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -110,6 +110,7 @@ struct tid_ampdu_tx {
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  * @rcu_head: RCU head used for freeing this struct
+ * @reorder_head: used to release expired frames
  *
  * This structure is protected by RCU and the per-station
  * spinlock. Assignments to the array holding it must hold
@@ -121,9 +122,11 @@ struct tid_ampdu_tx {
  */
 struct tid_ampdu_rx {
 	struct rcu_head rcu_head;
+	struct list_head reorder_head;
 	struct sk_buff **reorder_buf;
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
+	struct timer_list reorder_timer;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
 	u16 ssn;
