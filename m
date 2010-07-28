Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:35602 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755154Ab0G1PV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jul 2010 11:21:56 -0400
Received: by mail-bw0-f46.google.com with SMTP id 1so4018409bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jul 2010 08:21:55 -0700 (PDT)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [WIP 3/3] mac80211: AMPDU rx reorder timeout timer
Date: Wed, 28 Jul 2010 17:21:51 +0200
Cc: linux-wireless@vger.kernel.org
References: <201007270820.25347.chunkeey@googlemail.com> <1280219845.19098.4.camel@jlt3.sipsolutions.net>
In-Reply-To: <1280219845.19098.4.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201007281721.51568.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Everytime a hole is discovered in the reorder ring-buffer,
the release timer (for this tid_ampdu_rx) is set to fire
after HT_RX_REORDER_BUF_TIMEOUT jiffies.

If the missing frame(s) is/are arriving in time, the
timer gets deactivated/postponed(another hole has opened up).

Or, if the frame is really "lost", then the timer puts
the reorder tid_ampdu_rx into the local device's 
"tid_rx_reorder" list and schedules the tasklet, which
will look-up the tid_ampdu_rx and release all expired frames.

---
Hmm, I'm not sure if the tasklet code is 100% sane.
On one hand: we set rx.flags and sdata/sta pointers
without the usual rcu-protection.

but on the other hand,it should be OK because the
sta/sdata don't disappear without initiating a teardown.
(or simply poison reorder_head by using list_del)
---
diff --git a/net/mac80211/agg-rx.c b/net/mac80211/agg-rx.c
index 965b272..393f4e5 100644
--- a/net/mac80211/agg-rx.c
+++ b/net/mac80211/agg-rx.c
@@ -86,6 +86,11 @@ void ___ieee80211_stop_rx_ba_session(struct sta_info *sta, u16 tid,
 				     tid, 0, reason);
 
 	del_timer_sync(&tid_rx->session_timer);
+	del_timer_sync(&tid_rx->reorder_timer);
+
+	spin_lock_bh(&local->tid_rx_reorder_lock);
+	list_del_init(&tid_rx->reorder_list);
+	spin_unlock_bh(&local->tid_rx_reorder_lock);
 
 	call_rcu(&tid_rx->rcu_head, ieee80211_free_tid_rx);
 }
@@ -120,6 +125,24 @@ static void sta_rx_agg_session_timer_expired(unsigned long data)
 	ieee80211_queue_work(&sta->local->hw, &sta->ampdu_mlme.work);
 }
 
+static void sta_rx_agg_reorder_timer_expired(unsigned long data)
+{
+	u8 *ptid = (u8 *)data;
+	u8 *timer_to_id = ptid - *ptid;
+	struct sta_info *sta = container_of(timer_to_id, struct sta_info,
+			timer_to_tid[0]);
+
+	struct ieee80211_local *local = sta->local;
+	struct tid_ampdu_rx *tid_rx = sta->ampdu_mlme.tid_rx[*ptid];
+
+	spin_lock(&local->tid_rx_reorder_lock);
+	if (list_empty(&tid_rx->reorder_list))
+		list_add_tail(&tid_rx->reorder_list, &local->tid_rx_reorder);
+	spin_unlock(&local->tid_rx_reorder_lock);
+
+	tasklet_schedule(&local->tasklet);
+}
+
 static void ieee80211_send_addba_resp(struct ieee80211_sub_if_data *sdata, u8 *da, u16 tid,
 				      u8 dialog_token, u16 status, u16 policy,
 				      u16 buf_size, u16 timeout)
@@ -256,6 +279,12 @@ void ieee80211_process_addba_request(struct ieee80211_local *local,
 	tid_agg_rx->session_timer.data = (unsigned long)&sta->timer_to_tid[tid];
 	init_timer(&tid_agg_rx->session_timer);
 
+	/* rx reorder timer */
+	INIT_LIST_HEAD(&tid_agg_rx->reorder_list);
+	tid_agg_rx->reorder_timer.function = sta_rx_agg_reorder_timer_expired;
+	tid_agg_rx->reorder_timer.data = (unsigned long)&sta->timer_to_tid[tid];
+	init_timer(&tid_agg_rx->reorder_timer);
+
 	/* prepare reordering buffer */
 	tid_agg_rx->reorder_buf =
 		kcalloc(buf_size, sizeof(struct sk_buff *), GFP_ATOMIC);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index ef47006..fd658ef 100644
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
@@ -1130,6 +1132,7 @@ void ieee80211_start_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u16 tid);
 void ieee80211_stop_tx_ba_cb(struct ieee80211_vif *vif, u8 *ra, u8 tid);
 void ieee80211_ba_session_work(struct work_struct *work);
 void ieee80211_tx_ba_session_handle_start(struct sta_info *sta, int tid);
+void ieee80211_release_expired_mpdus(struct ieee80211_local *local);
 
 /* Spectrum management */
 void ieee80211_process_measurement_req(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 0e95c75..7d8e556 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -281,6 +281,8 @@ static void ieee80211_tasklet_handler(unsigned long data)
 			break;
 		}
 	}
+
+	ieee80211_release_expired_mpdus(local);
 }
 
 static void ieee80211_restart_work(struct work_struct *work)
@@ -448,6 +450,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	local->uapsd_max_sp_len = IEEE80211_DEFAULT_MAX_SP_LEN;
 
 	INIT_LIST_HEAD(&local->interfaces);
+	INIT_LIST_HEAD(&local->tid_rx_reorder);
 
 	__hw_addr_init(&local->mc_list);
 
@@ -457,6 +460,7 @@ struct ieee80211_hw *ieee80211_alloc_hw(size_t priv_data_len,
 	mutex_init(&local->key_mtx);
 	spin_lock_init(&local->filter_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
+	spin_lock_init(&local->tid_rx_reorder_lock);
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_scan_work);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6cb5541..e56b5da 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -570,7 +570,6 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 					  struct tid_ampdu_rx *tid_agg_rx,
 					  struct sk_buff_head *frames);
 
-
 /*
  * Timeout (in jiffies) for skb's that are waiting in the RX reorder buffer. If
  * the skb was added to the buffer longer than this time ago, the earlier
@@ -649,7 +648,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 					  struct tid_ampdu_rx *tid_agg_rx,
 					  struct sk_buff_head *frames)
 {
-	int index;
+	int index, j;
 
 	/* release the buffer until next missing frame */
 	index = seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
@@ -660,7 +659,6 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 		 * No buffers ready to be released, but check whether any
 		 * frames in the reorder buffer have timed out.
 		 */
-		int j;
 		int skipped = 1;
 		for (j = (index + 1) % tid_agg_rx->buf_size; j != index;
 		     j = (j + 1) % tid_agg_rx->buf_size) {
@@ -670,7 +668,7 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 			}
 			if (!time_after(jiffies, tid_agg_rx->reorder_time[j] +
 					HT_RX_REORDER_BUF_TIMEOUT))
-				break;
+				goto set_release_timer;
 
 #ifdef CONFIG_MAC80211_HT_DEBUG
 			if (net_ratelimit())
@@ -694,6 +692,26 @@ static void ieee80211_sta_reorder_release(struct ieee80211_hw *hw,
 		index =	seq_sub(tid_agg_rx->head_seq_num, tid_agg_rx->ssn) %
 							tid_agg_rx->buf_size;
 	}
+
+	if ((tid_agg_rx->stored_mpdu_num) &&
+	    list_empty(&tid_agg_rx->reorder_list)) {
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
+		mod_timer(&tid_agg_rx->reorder_timer, round_jiffies_up(
+			(tid_agg_rx->reorder_time[j] +
+			HT_RX_REORDER_BUF_TIMEOUT) + 1));
+	} else {
+		del_timer(&tid_agg_rx->reorder_timer);
+	}
 }
 
 /*
@@ -2398,6 +2416,61 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 	}
 }
 
+static void ieee80211_release_reorder_timeout(struct sta_info *sta,
+					      unsigned int tid)
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
+	ieee80211_sta_reorder_release(&sta->local->hw,
+		sta->ampdu_mlme.tid_rx[tid], &frames);
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
+void ieee80211_release_expired_mpdus(struct ieee80211_local *local)
+{
+	struct tid_ampdu_rx *iter;
+	struct sta_info *sta;
+	u8 *ptid, *timer_to_id;
+
+	spin_lock(&local->tid_rx_reorder_lock);
+	while (!list_empty(&local->tid_rx_reorder)) {
+		iter = list_first_entry(&local->tid_rx_reorder,
+					struct tid_ampdu_rx,
+					reorder_list);
+
+		ptid = (u8 *)iter->session_timer.data;
+		timer_to_id = ptid - *ptid;
+		sta = container_of(timer_to_id, struct sta_info,
+				   timer_to_tid[0]);
+
+		list_del_init(&iter->reorder_list);
+		ieee80211_release_reorder_timeout(sta, *ptid);
+	}
+	spin_unlock(&local->tid_rx_reorder_lock);
+}
+
 /* main receive path */
 
 static int prepare_for_handlers(struct ieee80211_sub_if_data *sdata,
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 54262e7..5040c47 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -110,6 +110,7 @@ struct tid_ampdu_tx {
  * @timeout: reset timer value (in TUs).
  * @dialog_token: dialog token for aggregation session
  * @rcu_head: RCU head used for freeing this struct
+ * @reorder_list: used to release expired frames
  *
  * This structure is protected by RCU and the per-station
  * spinlock. Assignments to the array holding it must hold
@@ -121,9 +122,11 @@ struct tid_ampdu_tx {
  */
 struct tid_ampdu_rx {
 	struct rcu_head rcu_head;
+	struct list_head reorder_list;
 	struct sk_buff **reorder_buf;
 	unsigned long *reorder_time;
 	struct timer_list session_timer;
+	struct timer_list reorder_timer;
 	u16 head_seq_num;
 	u16 stored_mpdu_num;
 	u16 ssn;
