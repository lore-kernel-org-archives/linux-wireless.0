Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:44969 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932126AbdJJOCp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 10 Oct 2017 10:02:45 -0400
From: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: make-wifi-fast@lists.bufferbloat.net,
        linux-wireless@vger.kernel.org
Cc: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Subject: [RFC 1/3] mac80211: Add TXQ scheduling API
Date: Tue, 10 Oct 2017 16:02:06 +0200
Message-Id: <20171010140208.1515-1-toke@toke.dk> (sfid-20171010_160341_258014_BDC1BDA8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds an API to mac80211 to handle scheduling of TXQs and changes the
interface between driver and mac80211 for TXQ handling as follows:

- The wake_tx_queue callback interface no longer includes the TXQ. Instead, the
  driver is expected to retrieve that from ieee80211_next_txq()

- Two new mac80211 functions are added: ieee80211_next_txq() and
  ieee80211_schedule_txq(). The former returns the next TXQ that should be
  scheduled, and is how the driver gets a queue to pull packets from. The latter
  is called internally by mac80211 to start scheduling a queue, and the driver
  is supposed to call it to re-schedule the TXQ after it is finished pulling
  packets from it (unless the queue emptied).

- A drv_buffered flag is added to struct ieee80211_txq which the driver can set
  to request mac80211 to re-schedule the TXQ at PS wakeup.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
This version of the scheduler is pretty dumb and just does round-robin
scheduling (pretty much identical to what ath10k does today). In the
future, this will be extended to do airtime fairness scheduling for
drivers that provide airtime information.

I have only compile tested this series; will runtime test it later this
week, but for now comments on the API would be appreciated. In
particular, I'm not sure what the right thing to do in regards to PS
wakeup is...

 include/net/mac80211.h     | 34 +++++++++++++++++++++++++++++-----
 net/mac80211/agg-tx.c      |  4 +++-
 net/mac80211/driver-ops.h  | 12 +++---------
 net/mac80211/ieee80211_i.h |  7 ++++++-
 net/mac80211/main.c        |  3 +++
 net/mac80211/sta_info.c    |  3 ++-
 net/mac80211/trace.h       | 21 ++++-----------------
 net/mac80211/tx.c          | 40 +++++++++++++++++++++++++++++++++++++++-
 8 files changed, 89 insertions(+), 35 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index cc9073e45be9..80a80efa06b1 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -105,9 +105,12 @@
  * The driver is expected to initialize its private per-queue data for stations
  * and interfaces in the .add_interface and .sta_add ops.
  *
- * The driver can't access the queue directly. To dequeue a frame, it calls
- * ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a queue, it
- * calls the .wake_tx_queue driver op.
+ * The driver can't access the queue directly. To obtain the next queue to pull
+ * frames from, the driver calls ieee80211_next_txq(). To dequeue a frame from a
+ * txq, it calls ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a
+ * queue, it calls the .wake_tx_queue driver op. The driver is expected to
+ * re-schedule the txq using ieee80211_schedule_txq() if it is still active
+ * after the driver has finished pulling packets from it.
  *
  * For AP powersave TIM handling, the driver only needs to indicate if it has
  * buffered packets in the driver specific data structures by calling
@@ -1870,6 +1873,7 @@ struct ieee80211_txq {
 	u8 tid;
 	u8 ac;
 
+	bool drv_buffered;
 	/* must be last */
 	u8 drv_priv[0] __aligned(sizeof(void *));
 };
@@ -3723,8 +3727,7 @@ struct ieee80211_ops {
 					 struct ieee80211_vif *vif,
 					 struct ieee80211_tdls_ch_sw_params *params);
 
-	void (*wake_tx_queue)(struct ieee80211_hw *hw,
-			      struct ieee80211_txq *txq);
+	void (*wake_tx_queue)(struct ieee80211_hw *hw);
 	void (*sync_rx_queues)(struct ieee80211_hw *hw);
 
 	int (*start_nan)(struct ieee80211_hw *hw,
@@ -5876,6 +5879,27 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq);
 
+/**
+ * ieee80211_schedule_txq - add txq to scheduling loop
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ */
+void ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq);
+
+/**
+ * ieee80211_next_txq - get next tx queue to pull packets from
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ *
+ * Returns the next txq if successful, %NULL if no queue is eligible. If a txq
+ * is returned, it will have been removed from the scheduler queue and needs to
+ * be re-scheduled with ieee80211_schedule_txq() to continue to be active.
+ */
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw);
+
 /**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index bef516ec47f9..77bd0ff90677 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -226,9 +226,11 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
 
 	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+	ieee80211_schedule_txq(&sta->sdata->local->hw, txq);
+
 	local_bh_disable();
 	rcu_read_lock();
-	drv_wake_tx_queue(sta->sdata->local, txqi);
+	drv_wake_tx_queue(sta->sdata->local);
 	rcu_read_unlock();
 	local_bh_enable();
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index 09f77e4a8a79..e20a9e2acd53 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1157,16 +1157,10 @@ drv_tdls_recv_channel_switch(struct ieee80211_local *local,
 	trace_drv_return_void(local);
 }
 
-static inline void drv_wake_tx_queue(struct ieee80211_local *local,
-				     struct txq_info *txq)
+static inline void drv_wake_tx_queue(struct ieee80211_local *local)
 {
-	struct ieee80211_sub_if_data *sdata = vif_to_sdata(txq->txq.vif);
-
-	if (!check_sdata_in_driver(sdata))
-		return;
-
-	trace_drv_wake_tx_queue(local, sdata, txq);
-	local->ops->wake_tx_queue(&local->hw, &txq->txq);
+	trace_drv_wake_tx_queue(local);
+	local->ops->wake_tx_queue(&local->hw);
 }
 
 static inline int drv_start_nan(struct ieee80211_local *local,
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 9675814f64db..521bedb5dc86 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -832,6 +832,7 @@ struct txq_info {
 	struct codel_vars def_cvars;
 	struct codel_stats cstats;
 	struct sk_buff_head frags;
+	struct list_head schedule_order;
 	unsigned long flags;
 
 	/* keep last! */
@@ -1121,6 +1122,9 @@ struct ieee80211_local {
 	struct codel_vars *cvars;
 	struct codel_params cparams;
 
+	struct list_head active_txqs;
+	spinlock_t active_txq_lock;
+
 	const struct ieee80211_ops *ops;
 
 	/*
@@ -1505,7 +1509,8 @@ static inline bool txq_has_queue(struct ieee80211_txq *txq)
 {
 	struct txq_info *txqi = to_txq_info(txq);
 
-	return !(skb_queue_empty(&txqi->frags) && !txqi->tin.backlog_packets);
+	return !(skb_queue_empty(&txqi->frags) && !txqi->tin.backlog_packets
+		 && !txq->drv_buffered);
 }
 
 static inline int ieee80211_bssid_match(const u8 *raddr, const u8 *addr)
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 8aa1f5b6a051..9ad0556aa24b 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -616,6 +616,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	INIT_LIST_HEAD(&local->active_txqs);
+	spin_lock_init(&local->active_txq_lock);
+
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 9673e157bf8f..bd31e6dc808f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1250,8 +1250,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 			if (!txq_has_queue(sta->sta.txq[i]))
 				continue;
 
-			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
+			ieee80211_schedule_txq(&local->hw, sta->sta.txq[i]);
 		}
+		drv_wake_tx_queue(local);
 	}
 
 	skb_queue_head_init(&pending);
diff --git a/net/mac80211/trace.h b/net/mac80211/trace.h
index 3d9ac17af407..531c0e7f2358 100644
--- a/net/mac80211/trace.h
+++ b/net/mac80211/trace.h
@@ -2550,33 +2550,20 @@ TRACE_EVENT(drv_tdls_recv_channel_switch,
 );
 
 TRACE_EVENT(drv_wake_tx_queue,
-	TP_PROTO(struct ieee80211_local *local,
-		 struct ieee80211_sub_if_data *sdata,
-		 struct txq_info *txq),
+	TP_PROTO(struct ieee80211_local *local),
 
-	TP_ARGS(local, sdata, txq),
+	TP_ARGS(local),
 
 	TP_STRUCT__entry(
 		LOCAL_ENTRY
-		VIF_ENTRY
-		STA_ENTRY
-		__field(u8, ac)
-		__field(u8, tid)
 	),
 
 	TP_fast_assign(
-		struct ieee80211_sta *sta = txq->txq.sta;
-
 		LOCAL_ASSIGN;
-		VIF_ASSIGN;
-		STA_ASSIGN;
-		__entry->ac = txq->txq.ac;
-		__entry->tid = txq->txq.tid;
 	),
-
 	TP_printk(
-		LOCAL_PR_FMT  VIF_PR_FMT  STA_PR_FMT " ac:%d tid:%d",
-		LOCAL_PR_ARG, VIF_PR_ARG, STA_PR_ARG, __entry->ac, __entry->tid
+		LOCAL_PR_FMT,
+		LOCAL_PR_ARG
 	)
 );
 
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 94826680cf2b..9c43c17c5144 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1405,6 +1405,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	codel_vars_init(&txqi->def_cvars);
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
+	INIT_LIST_HEAD(&txqi->schedule_order);
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1428,6 +1429,7 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	list_del_init(&txqi->schedule_order);
 }
 
 int ieee80211_txq_setup_flows(struct ieee80211_local *local)
@@ -1524,7 +1526,8 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	ieee80211_txq_enqueue(local, txqi, skb);
 	spin_unlock_bh(&fq->lock);
 
-	drv_wake_tx_queue(local, txqi);
+	ieee80211_schedule_txq(&local->hw, &txqi->txq);
+	drv_wake_tx_queue(local);
 
 	return true;
 }
@@ -3517,6 +3520,41 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
 
+void ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			     struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = to_txq_info(txq);
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	if (!list_empty(&txqi->schedule_order))
+		list_add_tail(&txqi->schedule_order, &local->active_txqs);
+
+	spin_unlock_bh(&local->active_txq_lock);
+}
+EXPORT_SYMBOL(ieee80211_schedule_txq);
+
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = NULL;
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	if (list_empty(&local->active_txqs))
+		goto out;
+
+	txqi = list_first_entry(&local->active_txqs, struct txq_info, schedule_order);
+	list_del_init(&txqi->schedule_order);
+
+out:
+	spin_unlock_bh(&local->active_txq_lock);
+
+	return &txqi->txq;
+}
+EXPORT_SYMBOL(ieee80211_next_txq);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
-- 
2.14.2
