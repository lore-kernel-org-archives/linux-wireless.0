Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37442 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759492Ab0HDXgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Aug 2010 19:36:45 -0400
Received: by mail-bw0-f46.google.com with SMTP id 1so2671501bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 04 Aug 2010 16:36:44 -0700 (PDT)
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3 v2] mac80211: AMPDU rx reorder timeout timer
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
From: Christian Lamparter <chunkeey@googlemail.com>
Date: Thu, 5 Aug 2010 01:36:41 +0200
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201008050136.41821.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch introduces a new timer, which will release
queued-up MPDUs from the reorder buffer, whenever
they've waited for more than HT_RX_REORDER_BUF_TIMEOUT
(which is at around 100 ms).

The advantage of having a dedicated timer, instead of
relying on a constant stream of freshly arriving aMPDUs
to release the old ones, is particularly observable when
even a small fraction of MPDUs are forever lost at
low network speeds.

Previously under these circumstances frames would become
stuck in the reorder buffer and the network stack of both
HT peers throttled back, instead of revving up and
gunning the pipes.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
WIP -> v1:
 	- thread-safe ampdu reordering
 	- do the reorder release in the timer

v1 -> v2:
	- update documentation entries
	- refine locking

NB:
I hope the timed release stuff is now probably protected against
races from the RX - path. The code was tested and nothing blew up,
that said the testbed only had a puny single-core Pentium M engine...

But nevertheless, it managed to hold tcp speed high enough to
qualify as an 11n device (~ 60mbps) over the bad link.
---
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 965b272..58eab9e 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -86,6 +86,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     tid, 0, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
+	del_timer_sync(&tid_rx->reorder_timer);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
@@ -120,6 +121,20 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
 }
 
+static void sta_rx_agg_reorder_timer_expired(unsigned long data)
+{
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
+			timer_to_tid[0]);
+
+	rcu_read_lock();
+	spin_lock(&sta->lock);
+	ieee80211_release_reorder_timeout(sta, *ptid);
+	spin_unlock(&sta->lock);
+	rcu_read_unlock();
+}
+
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
 				      u8 dialog_token, u16 status, u16 policy,
 				      u16 buf_size, u16 timeout)
@@ -251,11 +266,18 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		goto end;
 	}
 
+	spin_lock_init(&tid_agg_rx->reorder_lock);
+
 	/* rx timer */
 	tid_agg_rx->session_timer.function = sta_rx_agg_session_timer_expired;
 	tid_agg_rx->session_timer.data = (unsigned long)&sta->timer_to_tid[tid];
 	init_timer(&tid_agg_rx->session_timer);
 
+	/* rx reorder timer */
+	tid_agg_rx->reorder_timer.function = sta_rx_agg_reorder_timer_expired;
+	tid_agg_rx->reorder_timer.data = (unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&tid_agg_rx->reorder_timer);
+
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
 		kcalloc(buf_size, sizeof(struct sk_buff *), GFP_ATOMIC);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 65e0ed6..0a46f8f 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1131,6 +1131,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 void ieee80211_ba_session_work(struct work_struct *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
+void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 118c2e2..8c0044a 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -572,6 +572,8 @@ static void ieee80211_release_reorder_frames(struct ieee80211_hw *hw,
  * frames that have not yet been received are assumed to be lost and the skb
  * can be released for processing. This may also release other skb's from the
  * reorder buffer if there are no additional gaps between the frames.
+ *
+ * Callers must hold tid_agg_rx->reorder_lock.
  */
 #define HT_RX_REORDER_BUF_TIMEOUT (HZ / 10)
 
@@ -579,7 +581,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 					  struct tid_ampdu_rx *tid_agg_rx,
 					  struct sk_buff_head *frames)
 {
-	int index;
+	int index, j;
 
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
@@ -590,7 +592,6 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 		 * No buffers ready to be released, but check whether any
 		 * frames in the reorder buffer have timed out.
 		 */
-		int j;
 		int skipped = 1;
 		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
@@ -600,7 +601,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 			}
 			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
 					HT_RX_REORDER_BUF_TIMEOUT))
-				break;
+				goto set_release_timer;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			if (net_ratelimit())
@@ -624,6 +625,25 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
+
+	if (tid_agg_rx->stored_mpdu_num) {
+		j = index = seq_sub(tid_agg_rx->head_seq_num,
+				    tid_agg_rx->ssn) % tid_agg_rx->buf_size;
+
+		for (; j != (index - 1) % tid_agg_rx->buf_size;
+		     j = (j + 1) % tid_agg_rx->buf_size) {
+			if (tid_agg_rx->reorder_buf[j])
+				break;
+		}
+
+ set_release_timer:
+
+		mod_timer(&tid_agg_rx->reorder_timer,
+			  tid_agg_rx->reorder_time[j] +
+			  HT_RX_REORDER_BUF_TIMEOUT);
+	} else {
+		del_timer(&tid_agg_rx->reorder_timer);
+	}
 }
 
 /*
@@ -641,14 +661,16 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	u16 mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
 	u16 head_seq_num, buf_size;
 	int index;
+	bool ret = true;
 
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
 
+	spin_lock(&tid_agg_rx->reorder_lock);
 	/* frame with out of date sequence number */
 	if (seq_less(mpdu_seq_num, head_seq_num)) {
 		dev_kfree_skb(skb);
-		return true;
+		goto out;
 	}
 
 	/*
@@ -669,7 +691,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	/* check if we already stored this frame */
 	if (tid_agg_rx->reorder_buf[index]) {
 		dev_kfree_skb(skb);
-		return true;
+		goto out;
 	}
 
 	/*
@@ -679,7 +701,8 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
 	    tid_agg_rx->stored_mpdu_num == 0) {
 		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
-		return false;
+		ret = false;
+		goto out;
 	}
 
 	/* put the frame in the reordering buffer */
@@ -688,7 +711,9 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	tid_agg_rx->stored_mpdu_num++;
 	ieee80211_sta_reorder_release(hw, tid_agg_rx, frames);
 
-	return true;
+ out:
+	spin_unlock(&tid_agg_rx->reorder_lock);
+	return ret;
 }
 
 /*
@@ -2387,6 +2412,37 @@ static void ieee80211_invoke_rx_handlers(struct ieee80211_sub_if_data *sdata,
 #undef CALL_RXH
 }
 
+/*
+ * This function makes calls into the RX path. Therefore the
+ * caller must hold the sta_info->lock and everything has to
+ * be under rcu_read_lock protection as well.
+ */
+void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid)
+{
+	struct sk_buff_head frames;
+	struct ieee80211_rx_data rx = { };
+
+	__skb_queue_head_init(&frames);
+
+	/* construct rx struct */
+	rx.sta = sta;
+	rx.sdata = sta->sdata;
+	rx.local = sta->local;
+	rx.queue = tid;
+	rx.flags |= IEEE80211_RX_RA_MATCH;
+
+	if (unlikely(test_bit(SCAN_HW_SCANNING, &sta->local->scanning) ||
+		     test_bit(SCAN_OFF_CHANNEL, &sta->local->scanning)))
+		rx.flags |= IEEE80211_RX_IN_SCAN;
+
+	spin_lock(&sta->ampdu_mlme.tid_rx[tid]->reorder_lock);
+	ieee80211_sta_reorder_release(&sta->local->hw,
+		sta->ampdu_mlme.tid_rx[tid], &frames);
+	spin_unlock(&sta->ampdu_mlme.tid_rx[tid]->reorder_lock);
+
+	ieee80211_rx_handlers(&rx, &frames);
+}
+
 /* main receive path */
 
 static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 54262e7..810c5ce 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -103,6 +103,7 @@ struct tid_ampdu_tx {
  * @reorder_buf: buffer to reorder incoming aggregated MPDUs
  * @reorder_time: jiffies when skb was added
  * @session_timer: check if peer keeps Tx-ing on the TID (by timeout value)
+ * @reorder_timer: releases expired frames from the reorder buffer.
  * @head_seq_num: head sequence number in reordering buffer.
  * @stored_mpdu_num: number of MPDUs in reordering buffer
  * @ssn: Starting Sequence Number expected to be aggregated.
@@ -110,20 +111,25 @@ struct tid_ampdu_tx {
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  * @rcu_head: RCU head used for freeing this struct
+ * @reorder_lock: serializes access to reorder buffer, see below.
  *
  * This structure is protected by RCU and the per-station
  * spinlock. Assignments to the array holding it must hold
- * the spinlock, only the RX path can access it under RCU
- * lock-free. The RX path, since it is single-threaded,
- * can even modify the structure without locking since the
- * only other modifications to it are done when the struct
- * can not yet or no longer be found by the RX path.
+ * the spinlock.
+ *
+ * The @reorder_lock is used to protect the variables and
+ * arrays such as @reorder_buf, @reorder_time, @head_seq_num,
+ * @stored_mpdu_num and @reorder_time from being corrupted by
+ * concurrent access of the RX path and the expired frame
+ * release timer.
  */
 struct tid_ampdu_rx {
 	struct rcu_head rcu_head;
+	spinlock_t reorder_lock;
 	struct sk_buff **reorder_buf;
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
+	struct timer_list reorder_timer;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
 	u16 ssn;
