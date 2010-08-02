Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55488 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752002Ab0HBNQd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:16:33 -0400
Received: by bwz1 with SMTP id 1so1447545bwz.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 06:16:31 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 3/3] mac80211: AMPDU rx reorder timeout timer
Date: Mon, 2 Aug 2010 15:16:29 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>
References: <201007270820.25347.chunkeey@googlemail.com> <1280219845.19098.4.camel@jlt3.sipsolutions.net> <201007281721.51568.chunkeey@googlemail.com>
In-Reply-To: <201007281721.51568.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201008021516.29731.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Everytime a hole is discovered in the reorder ring-buffer,
the release timer (for this tid_ampdu_rx) is set to fire
after HT_RX_REORDER_BUF_TIMEOUT jiffies.
 
If the missing frame(s) is/are arriving in time, the
timer gets deactivated/postponed(another hole has opened up).

Else, timer releases all expired frames after the timeout
period has elapsed.

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
---
WIP -> PATCH:
	- thread-safe ampdu reordering
	- do the reorder release in the timer
---
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 965b272..080d792 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -86,6 +86,7 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     tid, 0, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
+	del_timer_sync(&tid_rx->reorder_timer);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
@@ -120,6 +121,16 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
 }
 
+static void sta_rx_agg_reorder_timer_expired(unsigned long data)
+{
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
+			timer_to_tid[0]);
+
+	ieee80211_release_reorder_timeout(sta, *ptid);
+}
+
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
 				      u8 dialog_token, u16 status, u16 policy,
 				      u16 buf_size, u16 timeout)
@@ -251,11 +262,18 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 		goto end;
 	}
 
+	spin_lock_init(&tid_agg_rx->lock);
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
index ef47006..9d1ce88 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -1130,6 +1130,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 void ieee80211_ba_session_work(struct work_struct *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
+void ieee80211_release_reorder_timeout(struct sta_info *sta, int tid);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6cb5541..37d818d 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -595,14 +595,16 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	u16 mpdu_seq_num = (sc & IEEE80211_SCTL_SEQ) >> 4;
 	u16 head_seq_num, buf_size;
 	int index;
+	bool ret = true;
 
 	buf_size = tid_agg_rx->buf_size;
 	head_seq_num = tid_agg_rx->head_seq_num;
 
+	spin_lock(&tid_agg_rx->lock);
 	/* frame with out of date sequence number */
 	if (seq_less(mpdu_seq_num, head_seq_num)) {
 		dev_kfree_skb(skb);
-		return true;
+		goto out;
 	}
 
 	/*
@@ -623,7 +625,7 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	/* check if we already stored this frame */
 	if (tid_agg_rx->reorder_buf[index]) {
 		dev_kfree_skb(skb);
-		return true;
+		goto out;
 	}
 
 	/*
@@ -633,7 +635,8 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	if (mpdu_seq_num == tid_agg_rx->head_seq_num &&
 	    tid_agg_rx->stored_mpdu_num == 0) {
 		tid_agg_rx->head_seq_num = seq_inc(tid_agg_rx->head_seq_num);
-		return false;
+		ret = false;
+		goto out;
 	}
 
 	/* put the frame in the reordering buffer */
@@ -642,14 +645,16 @@ static bool ieee80211_sta_manage_reorder_buf(struct ieee80211_hw *hw,
 	tid_agg_rx->stored_mpdu_num++;
 	ieee80211_sta_reorder_release(hw, tid_agg_rx, frames);
 
-	return true;
+ out:
+	spin_unlock(&tid_agg_rx->lock);
+	return ret;
 }
 
 static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 					  struct tid_ampdu_rx *tid_agg_rx,
 					  struct sk_buff_head *frames)
 {
-	int index;
+	int index, j;
 
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
@@ -660,7 +665,6 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 		 * No buffers ready to be released, but check whether any
 		 * frames in the reorder buffer have timed out.
 		 */
-		int j;
 		int skipped = 1;
 		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
@@ -670,7 +674,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 			}
 			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
 					HT_RX_REORDER_BUF_TIMEOUT))
-				break;
+				goto set_release_timer;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			if (net_ratelimit())
@@ -694,6 +698,25 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
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
@@ -2398,6 +2421,39 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	}
 }
 
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
+	spin_lock(&sta->ampdu_mlme.tid_rx[tid]->lock);
+	ieee80211_sta_reorder_release(&sta->local->hw,
+		sta->ampdu_mlme.tid_rx[tid], &frames);
+	spin_unlock(&sta->ampdu_mlme.tid_rx[tid]->lock);
+
+	/*
+	 * key references and virtual interfaces are protected using RCU
+	 * and this requires that we are in a read-side RCU section during
+	 * receive processing
+	 */
+	rcu_read_lock();
+	ieee80211_rx_handlers(&rx, &frames);
+	rcu_read_unlock();
+}
+
 /* main receive path */
 
 static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 54262e7..5e83c83 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -110,6 +110,7 @@ struct tid_ampdu_tx {
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  * @rcu_head: RCU head used for freeing this struct
+ * @lock: controls exclusive access to the struct
  *
  * This structure is protected by RCU and the per-station
  * spinlock. Assignments to the array holding it must hold
@@ -121,9 +122,11 @@ struct tid_ampdu_tx {
  */
 struct tid_ampdu_rx {
 	struct rcu_head rcu_head;
+	spinlock_t lock;
 	struct sk_buff **reorder_buf;
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
+	struct timer_list reorder_timer;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
 	u16 ssn;
