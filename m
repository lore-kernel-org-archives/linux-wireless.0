Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:51789 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728233AbeIPXFw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Sep 2018 19:05:52 -0400
Subject: [PATCH RFC v4 1/4] mac80211: Add TXQ scheduling API
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Rajkumar Manoharan <rmanohar@codeaurora.org>,
        Kan Yan <kyan@google.com>
Date: Sun, 16 Sep 2018 19:42:11 +0200
Message-ID: <153711973109.9231.7094211814263758096.stgit@alrua-x1.karlstad.toke.dk> (sfid-20180916_194320_375882_E529F232)
In-Reply-To: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
References: <153711966150.9231.13481453399723518107.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds an API to mac80211 to handle scheduling of TXQs. The interface
between driver and mac80211 for TXQ handling is changed by adding two new
functions: ieee80211_next_txq(), which will return the next TXQ to schedule
in the current round-robin rotation, and ieee80211_return_txq(), which the
driver uses to indicate that it has finished scheduling a TXQ (which will
then be put back in the scheduling rotation if it isn't empty).

The driver must call ieee80211_txq_schedule_start() at the start of each
scheduling session, and ieee80211_txq_schedule_end() at the end. The API
then guarantees that the same TXQ is not returned twice in the same
session (so a driver can loop on ieee80211_next_txq() without worrying
about breaking the loop.

Usage of the new API is optional, so drivers can be ported one at a time.
In this patch, the actual scheduling performed by mac80211 is simple
round-robin, but a subsequent commit adds airtime fairness awareness to the
scheduler.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/mac80211.h     |   62 +++++++++++++++++++++++++++++++++++++++++---
 net/mac80211/agg-tx.c      |    2 +
 net/mac80211/driver-ops.h  |    9 ++++++
 net/mac80211/ieee80211_i.h |    9 ++++++
 net/mac80211/main.c        |    5 ++++
 net/mac80211/sta_info.c    |    2 +
 net/mac80211/tx.c          |   59 +++++++++++++++++++++++++++++++++++++++++-
 7 files changed, 141 insertions(+), 7 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c4fadbafbf21..5ca1484cba58 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -108,9 +108,16 @@
  * The driver is expected to initialize its private per-queue data for stations
  * and interfaces in the .add_interface and .sta_add ops.
  *
- * The driver can't access the queue directly. To dequeue a frame, it calls
- * ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a queue, it
- * calls the .wake_tx_queue driver op.
+ * The driver can't access the queue directly. To dequeue a frame from a
+ * txq, it calls ieee80211_tx_dequeue(). Whenever mac80211 adds a new frame to a
+ * queue, it calls the .wake_tx_queue driver op.
+ *
+ * Drivers can optionally delegate responsibility for scheduling queues to
+ * mac80211, to take advantage of airtime fairness accounting. In this case, to
+ * obtain the next queue to pull frames from, the driver calls
+ * ieee80211_next_txq(). The driver is then expected to re-schedule the txq
+ * using ieee80211_schedule_txq() if it is still active after the driver has
+ * finished pulling packets from it.
  *
  * For AP powersave TIM handling, the driver only needs to indicate if it has
  * buffered packets in the driver specific data structures by calling
@@ -6045,13 +6052,60 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
  * ieee80211_tx_dequeue - dequeue a packet from a software tx queue
  *
  * @hw: pointer as obtained from ieee80211_alloc_hw()
- * @txq: pointer obtained from station or virtual interface
+ * @txq: pointer obtained from station or virtual interface, or from
+ *       ieee80211_next_txq()
  *
  * Returns the skb if successful, %NULL if no frame was available.
  */
 struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 				     struct ieee80211_txq *txq);
 
+/**
+ * ieee80211_next_txq - get next tx queue to pull packets from
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @ac: AC number to return packets from.
+ *
+ * Should only be called between calls to ieee80211_txq_schedule_start()
+ * and ieee80211_txq_schedule_end().
+ * Returns the next txq if successful, %NULL if no queue is eligible. If a txq
+ * is returned, it should be returned with ieee80211_return_txq() after the
+ * driver has finished scheduling it.
+ */
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac);
+
+/**
+ * ieee80211_return_txq - return a TXQ previously acquired by ieee80211_next_txq()
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ *
+ * Should only be called between calls to ieee80211_txq_schedule_start()
+ * and ieee80211_txq_schedule_end().
+ */
+void ieee80211_return_txq(struct ieee80211_hw *hw, struct ieee80211_txq *txq);
+
+/**
+ * ieee80211_txq_schedule_start - acquire locks for safe scheduling of an AC
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @ac: AC number to acquire locks for
+ *
+ * Acquire locks needed to schedule TXQs from the given AC. Should be called
+ * before ieee80211_next_txq() or ieee80211_schedule_txq().
+ */
+void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac);
+
+/**
+ * ieee80211_txq_schedule_end - release locks for safe scheduling of an AC
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @ac: AC number to acquire locks for
+ *
+ * Release locks previously acquired by ieee80211_txq_schedule_end().
+ */
+void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac);
+
 /**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 69e831bc317b..e94b1a0407af 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -229,7 +229,7 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
 	local_bh_disable();
 	rcu_read_lock();
-	drv_wake_tx_queue(sta->sdata->local, txqi);
+	schedule_and_wake_txq(sta->sdata->local, txqi);
 	rcu_read_unlock();
 	local_bh_enable();
 }
diff --git a/net/mac80211/driver-ops.h b/net/mac80211/driver-ops.h
index e42c641b6190..0d47dadee747 100644
--- a/net/mac80211/driver-ops.h
+++ b/net/mac80211/driver-ops.h
@@ -1173,6 +1173,15 @@ static inline void drv_wake_tx_queue(struct ieee80211_local *local,
 	local->ops->wake_tx_queue(&local->hw, &txq->txq);
 }
 
+static inline void schedule_and_wake_txq(struct ieee80211_local *local,
+					 struct txq_info *txqi)
+{
+	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
+	ieee80211_return_txq(&local->hw, &txqi->txq);
+	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
+	drv_wake_tx_queue(local, txqi);
+}
+
 static inline int drv_can_aggregate_in_amsdu(struct ieee80211_local *local,
 					     struct sk_buff *head,
 					     struct sk_buff *skb)
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index f40a2167935f..976531717902 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -829,6 +829,8 @@ enum txq_info_flags {
  *	a fq_flow which is already owned by a different tin
  * @def_cvars: codel vars for @def_flow
  * @frags: used to keep fragments created after dequeue
+ * @schedule_order: used with ieee80211_local->active_txqs
+ * @schedule_round: counter to prevent infinite loops on TXQ scheduling
  */
 struct txq_info {
 	struct fq_tin tin;
@@ -836,6 +838,8 @@ struct txq_info {
 	struct codel_vars def_cvars;
 	struct codel_stats cstats;
 	struct sk_buff_head frags;
+	struct list_head schedule_order;
+	u16 schedule_round;
 	unsigned long flags;
 
 	/* keep last! */
@@ -1127,6 +1131,11 @@ struct ieee80211_local {
 	struct codel_vars *cvars;
 	struct codel_params cparams;
 
+	/* protects active_txqs and txqi->schedule_order */
+	spinlock_t active_txq_lock[IEEE80211_NUM_ACS];
+	struct list_head active_txqs[IEEE80211_NUM_ACS];
+	u16 schedule_round[IEEE80211_NUM_ACS];
+
 	const struct ieee80211_ops *ops;
 
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 77381017bac7..d9315de90b48 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -663,6 +663,11 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	for (i = 0; i < IEEE80211_NUM_ACS; i++) {
+		INIT_LIST_HEAD(&local->active_txqs[i]);
+		spin_lock_init(&local->active_txq_lock[i]);
+	}
+
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index fb8c2252ac0e..c2f5cb7df54f 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1249,7 +1249,7 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 		if (!sta->sta.txq[i] || !txq_has_queue(sta->sta.txq[i]))
 			continue;
 
-		drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
+		schedule_and_wake_txq(local, to_txq_info(sta->sta.txq[i]));
 	}
 
 	skb_queue_head_init(&pending);
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index c42bfa1dcd2c..1e071121cb44 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1445,6 +1445,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	codel_vars_init(&txqi->def_cvars);
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
+	INIT_LIST_HEAD(&txqi->schedule_order);
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1485,6 +1486,9 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	spin_lock_bh(&local->active_txq_lock[txqi->txq.ac]);
+	list_del_init(&txqi->schedule_order);
+	spin_unlock_bh(&local->active_txq_lock[txqi->txq.ac]);
 }
 
 void ieee80211_txq_set_params(struct ieee80211_local *local)
@@ -1601,7 +1605,7 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	ieee80211_txq_enqueue(local, txqi, skb);
 	spin_unlock_bh(&fq->lock);
 
-	drv_wake_tx_queue(local, txqi);
+	schedule_and_wake_txq(local, txqi);
 
 	return true;
 }
@@ -3623,6 +3627,59 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
 
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, u8 ac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = NULL;
+
+	lockdep_assert_held(&local->active_txq_lock[ac]);
+
+	txqi = list_first_entry_or_null(&local->active_txqs[ac],
+					struct txq_info,
+					schedule_order);
+
+	if (!txqi || txqi->schedule_round == local->schedule_round[ac])
+		return NULL;
+
+	list_del_init(&txqi->schedule_order);
+	txqi->schedule_round = local->schedule_round[ac];
+	return &txqi->txq;
+}
+EXPORT_SYMBOL(ieee80211_next_txq);
+
+void ieee80211_return_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = to_txq_info(txq);
+
+	lockdep_assert_held(&local->active_txq_lock[txq->ac]);
+
+	if (list_empty(&txqi->schedule_order) &&
+	    (!skb_queue_empty(&txqi->frags) || txqi->tin.backlog_packets))
+		list_add_tail(&txqi->schedule_order,
+			      &local->active_txqs[txq->ac]);
+
+}
+EXPORT_SYMBOL(ieee80211_return_txq);
+
+void ieee80211_txq_schedule_start(struct ieee80211_hw *hw, u8 ac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	spin_lock_bh(&local->active_txq_lock[ac]);
+	local->schedule_round[ac]++;
+}
+EXPORT_SYMBOL(ieee80211_txq_schedule_start);
+
+void ieee80211_txq_schedule_end(struct ieee80211_hw *hw, u8 ac)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+
+	spin_unlock_bh(&local->active_txq_lock[ac]);
+}
+EXPORT_SYMBOL(ieee80211_txq_schedule_end);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
