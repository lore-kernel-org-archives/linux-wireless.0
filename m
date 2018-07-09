Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.toke.dk ([52.28.52.200]:49177 "EHLO mail.toke.dk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932961AbeGIQhJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Jul 2018 12:37:09 -0400
Subject: [RFC v2 1/4] mac80211: Add TXQ scheduling API
From: Toke =?utf-8?q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: linux-wireless@vger.kernel.org
Cc: make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>
Date: Mon, 09 Jul 2018 18:37:04 +0200
Message-ID: <153115422491.7447.12479559048433925372.stgit@alrua-x1> (sfid-20180709_183719_768645_CF7DCAEC)
In-Reply-To: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
References: <153115421866.7447.6363834356268564403.stgit@alrua-x1>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds an API to mac80211 to handle scheduling of TXQs. The API
consists of two new functions: ieee80211_next_txq() and
ieee80211_schedule_txq(). The former returns the next TXQ that should be
scheduled, and is how the driver gets a queue to pull packets from. The
latter is called internally by mac80211 to start scheduling a queue, and
the driver is supposed to call it to re-schedule the TXQ after it is
finished pulling packets from it (unless the queue emptied). Drivers can
optionally filter TXQs on ac to support per-AC hardware queue designs,
and a sequence number mechanism is used to support drivers looping over
all available TXQs exactly once.

Using this API allows drivers to take advantage of mac80211 scheduling
features such as airtime fairness (added in a subsequent commit).
However, usage of the new API is optional, so support can be added to
individual drivers one at a time.

Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
---
 include/net/mac80211.h     |   50 +++++++++++++++++++++++++++++---
 net/mac80211/agg-tx.c      |    2 +
 net/mac80211/ieee80211_i.h |    7 ++++
 net/mac80211/main.c        |    3 ++
 net/mac80211/sta_info.c    |    3 ++
 net/mac80211/tx.c          |   69 ++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 130 insertions(+), 4 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 5790f55c241d..18e43193b614 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -107,9 +107,16 @@
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
@@ -5971,13 +5978,48 @@ void ieee80211_unreserve_tid(struct ieee80211_sta *sta, u8 tid);
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
+ * ieee80211_schedule_txq - add txq to scheduling loop
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @txq: pointer obtained from station or virtual interface
+ * @reset_seqno: Whether to reset the internal scheduling sequence number,
+ *               allowing this txq to appear again in the current scheduling
+ *               round (see doc for ieee80211_next_txq()).
+ *
+ * Returns %true if the txq was actually added to the scheduling,
+ * %false otherwise.
+ */
+bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq,
+			    bool reset_seqno);
+
+/**
+ * ieee80211_next_txq - get next tx queue to pull packets from
+ *
+ * @hw: pointer as obtained from ieee80211_alloc_hw()
+ * @ac: filter returned txqs with this AC number. Pass -1 for no filtering.
+ * @inc_seqno: Whether to increase the scheduling sequence number. Setting this
+ *             to true signifies the start of a new scheduling round. Each TXQ
+ *             will only be returned exactly once in each round (unless its
+ *             sequence number is explicitly reset when calling
+ *             ieee80211_schedule_txq()).
+ *
+ * Returns the next txq if successful, %NULL if no queue is eligible. If a txq
+ * is returned, it will have been removed from the scheduler queue and needs to
+ * be re-scheduled with ieee80211_schedule_txq() to continue to be active.
+ */
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
+					 bool inc_seqno);
+
 /**
  * ieee80211_txq_get_depth - get pending frame/byte count of given txq
  *
diff --git a/net/mac80211/agg-tx.c b/net/mac80211/agg-tx.c
index 69e831bc317b..0a2e0d64fc11 100644
--- a/net/mac80211/agg-tx.c
+++ b/net/mac80211/agg-tx.c
@@ -227,6 +227,8 @@ ieee80211_agg_start_txq(struct sta_info *sta, int tid, bool enable)
 		clear_bit(IEEE80211_TXQ_AMPDU, &txqi->flags);
 
 	clear_bit(IEEE80211_TXQ_STOP, &txqi->flags);
+	ieee80211_schedule_txq(&sta->sdata->local->hw, txq, true);
+
 	local_bh_disable();
 	rcu_read_lock();
 	drv_wake_tx_queue(sta->sdata->local, txqi);
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 172aeae21ae9..6bd68639c699 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -835,6 +835,8 @@ struct txq_info {
 	struct codel_vars def_cvars;
 	struct codel_stats cstats;
 	struct sk_buff_head frags;
+	struct list_head schedule_order;
+	u16 schedule_seqno;
 	unsigned long flags;
 
 	/* keep last! */
@@ -1126,6 +1128,11 @@ struct ieee80211_local {
 	struct codel_vars *cvars;
 	struct codel_params cparams;
 
+	/* protects active_txqs and txqi->schedule_order */
+	spinlock_t active_txq_lock;
+	struct list_head active_txqs;
+	u16 schedule_seqno;
+
 	const struct ieee80211_ops *ops;
 
 	/*
diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 4fb2709cb527..abaca5e1a59f 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -634,6 +634,9 @@ struct ieee80211_hw *ieee80211_alloc_hw_nm(size_t priv_data_len,
 	spin_lock_init(&local->rx_path_lock);
 	spin_lock_init(&local->queue_stop_reason_lock);
 
+	INIT_LIST_HEAD(&local->active_txqs);
+	spin_lock_init(&local->active_txq_lock);
+
 	INIT_LIST_HEAD(&local->chanctx_list);
 	mutex_init(&local->chanctx_mtx);
 
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index f34202242d24..bb92bf516b6b 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1244,6 +1244,9 @@ void ieee80211_sta_ps_deliver_wakeup(struct sta_info *sta)
 			if (!txq_has_queue(sta->sta.txq[i]))
 				continue;
 
+			ieee80211_schedule_txq(&local->hw,
+					       sta->sta.txq[i],
+					       true);
 			drv_wake_tx_queue(local, to_txq_info(sta->sta.txq[i]));
 		}
 	}
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 5b93bde248fd..24766566a380 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1437,6 +1437,7 @@ void ieee80211_txq_init(struct ieee80211_sub_if_data *sdata,
 	codel_vars_init(&txqi->def_cvars);
 	codel_stats_init(&txqi->cstats);
 	__skb_queue_head_init(&txqi->frags);
+	INIT_LIST_HEAD(&txqi->schedule_order);
 
 	txqi->txq.vif = &sdata->vif;
 
@@ -1460,6 +1461,9 @@ void ieee80211_txq_purge(struct ieee80211_local *local,
 
 	fq_tin_reset(fq, tin, fq_skb_free_func);
 	ieee80211_purge_tx_queue(&local->hw, &txqi->frags);
+	spin_lock_bh(&local->active_txq_lock);
+	list_del_init(&txqi->schedule_order);
+	spin_unlock_bh(&local->active_txq_lock);
 }
 
 void ieee80211_txq_set_params(struct ieee80211_local *local)
@@ -1576,6 +1580,7 @@ static bool ieee80211_queue_skb(struct ieee80211_local *local,
 	ieee80211_txq_enqueue(local, txqi, skb);
 	spin_unlock_bh(&fq->lock);
 
+	ieee80211_schedule_txq(&local->hw, &txqi->txq, true);
 	drv_wake_tx_queue(local, txqi);
 
 	return true;
@@ -3574,6 +3579,70 @@ struct sk_buff *ieee80211_tx_dequeue(struct ieee80211_hw *hw,
 }
 EXPORT_SYMBOL(ieee80211_tx_dequeue);
 
+bool ieee80211_schedule_txq(struct ieee80211_hw *hw,
+			    struct ieee80211_txq *txq,
+			    bool reset_seqno)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = to_txq_info(txq);
+	bool ret = false;
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	if (list_empty(&txqi->schedule_order)) {
+		list_add_tail(&txqi->schedule_order, &local->active_txqs);
+		if (reset_seqno)
+			txqi->schedule_seqno = local->schedule_seqno - 1;
+		ret = true;
+	}
+
+	spin_unlock_bh(&local->active_txq_lock);
+
+	return ret;
+}
+EXPORT_SYMBOL(ieee80211_schedule_txq);
+
+struct ieee80211_txq *ieee80211_next_txq(struct ieee80211_hw *hw, s8 ac,
+					 bool inc_seqno)
+{
+	struct ieee80211_local *local = hw_to_local(hw);
+	struct txq_info *txqi = NULL;
+
+	spin_lock_bh(&local->active_txq_lock);
+
+	if (inc_seqno)
+		local->schedule_seqno++;
+
+	if (list_empty(&local->active_txqs))
+		goto out;
+
+	list_for_each_entry(txqi, &local->active_txqs, schedule_order) {
+		if (ac < 0 || txqi->txq.ac == ac) {
+			/* If seqnos are equal, we've seen this txqi before in
+			 * this scheduling round, so abort.
+			 */
+			if (txqi->schedule_seqno == local->schedule_seqno)
+				txqi = NULL;
+			else
+				list_del_init(&txqi->schedule_order);
+			goto out;
+		}
+	}
+
+	/* no txq with requested ac found */
+	txqi = NULL;
+
+out:
+	spin_unlock_bh(&local->active_txq_lock);
+
+	if (!txqi)
+		return NULL;
+
+	txqi->schedule_seqno = local->schedule_seqno;
+	return &txqi->txq;
+}
+EXPORT_SYMBOL(ieee80211_next_txq);
+
 void __ieee80211_subif_start_xmit(struct sk_buff *skb,
 				  struct net_device *dev,
 				  u32 info_flags)
