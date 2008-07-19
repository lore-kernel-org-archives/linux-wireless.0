Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:53557 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750939AbYGSApv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jul 2008 20:45:51 -0400
Message-Id: <20080719004518.846156000@sipsolutions.net> (sfid-20080719_024555_879060_770F8C6B)
References: <20080719004147.795661000@sipsolutions.net>
Date: Sat, 19 Jul 2008 02:41:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: David Miller <davem@davemloft.net>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [RFC 3/3] mac80211: fix requeue race
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    4 
 include/net/mac80211.h                |   16 ---
 net/mac80211/ieee80211_i.h            |    7 +
 net/mac80211/main.c                   |  146 +++++++++++++++++++++-------------
 net/mac80211/wme.c                    |   76 ++++++++++++++++-
 net/mac80211/wme.h                    |    4 
 6 files changed, 175 insertions(+), 78 deletions(-)

--- everything.orig/net/mac80211/ieee80211_i.h	2008-07-19 01:37:10.000000000 +0200
+++ everything/net/mac80211/ieee80211_i.h	2008-07-19 02:04:39.000000000 +0200
@@ -534,8 +534,7 @@ struct ieee80211_sub_if_data *vif_to_sda
 enum {
 	IEEE80211_RX_MSG	= 1,
 	IEEE80211_TX_STATUS_MSG	= 2,
-	IEEE80211_DELBA_MSG	= 3,
-	IEEE80211_ADDBA_MSG	= 4,
+	IEEE80211_ADDBA_MSG	= 3,
 };
 
 /* maximum number of hardware queues we support. */
@@ -557,6 +556,10 @@ struct ieee80211_local {
 	 */
 	unsigned long queue_pool[BITS_TO_LONGS(QD_MAX_QUEUES)];
 
+	struct work_struct tx_ba_stop_work;
+	spinlock_t tx_ba_stop_lock;
+	struct list_head tx_ba_stop_list;
+
 	struct net_device *mdev; /* wmaster# - "master" 802.11 device */
 	int open_count;
 	int monitors, cooked_mntrs;
--- everything.orig/net/mac80211/main.c	2008-07-19 01:38:52.000000000 +0200
+++ everything/net/mac80211/main.c	2008-07-19 02:28:00.000000000 +0200
@@ -644,7 +644,7 @@ int ieee80211_start_tx_ba_session(struct
 		/* No need to requeue the packets in the agg queue, since we
 		 * haven't yet marked the queue in the queue_pool no packet
 		 * can have been enqueued to the newly allocated queue */
-		ieee80211_ht_agg_queue_remove(local, sta->tid_to_tx_q[tid], false);
+		ieee80211_ht_agg_queue_remove(local, sta->tid_to_tx_q[tid], -1);
 		sta->tid_to_tx_q[tid] = ieee80211_num_queues(hw);
 #ifdef CONFIG_MAC80211_HT_DEBUG
 		printk(KERN_DEBUG "BA request denied - HW unavailable for"
@@ -658,7 +658,7 @@ int ieee80211_start_tx_ba_session(struct
 	set_bit(reserved_queue, local->queue_pool);
 
 	/* Put all the packets onto the new aggregation queue */
-	ieee80211_requeue(local, ieee802_1d_to_ac[tid]);
+	ieee80211_requeue_toagg(local, ieee802_1d_to_ac[tid]);
 	spin_unlock_bh(&sta->lock);
 
 	/* send an addBA request */
@@ -805,9 +805,39 @@ void ieee80211_start_tx_ba_cb(struct iee
 }
 EXPORT_SYMBOL(ieee80211_start_tx_ba_cb);
 
-void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid)
+void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
+				      const u8 *ra, u16 tid)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
+	struct ieee80211_ra_tid *ra_tid;
+	struct sk_buff *skb = dev_alloc_skb(0);
+
+	if (unlikely(!skb)) {
+#ifdef CONFIG_MAC80211_HT_DEBUG
+		if (net_ratelimit())
+			printk(KERN_WARNING "%s: Not enough memory, "
+			       "dropping start BA session", skb->dev->name);
+#endif
+		return;
+	}
+	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
+	memcpy(&ra_tid->ra, ra, ETH_ALEN);
+	ra_tid->tid = tid;
+
+	skb->pkt_type = IEEE80211_ADDBA_MSG;
+	skb_queue_tail(&local->skb_queue, skb);
+	tasklet_schedule(&local->tasklet);
+}
+EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
+
+struct tx_ba_work {
+	struct list_head list;
+	u8 ra[ETH_ALEN];
+	u8 tid;
+};
+
+static void ieee80211_stop_tx_ba_do(struct ieee80211_local *local, u8 *ra, u8 tid)
+{
 	struct sta_info *sta;
 	u8 *state;
 	int agg_queue;
@@ -856,15 +886,13 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 
 	agg_queue = sta->tid_to_tx_q[tid];
 
-	ieee80211_ht_agg_queue_remove(local, agg_queue, true);
-	sta->tid_to_tx_q[tid] = ieee80211_num_queues(hw);
-
-	/* We just requeued the all the frames that were in the
-	 * removed queue, and since we might miss a softirq we do
-	 * netif_schedule_queue.  ieee80211_wake_queue is not used
-	 * here as this queue is not necessarily stopped
+	/*
+	 * From this point on, the queue will no longer be used to
+	 * queue frames on.
 	 */
-	netif_schedule_queue(netdev_get_tx_queue(local->mdev, agg_queue));
+	sta->tid_to_tx_q[tid] = ieee80211_num_queues(&local->hw);
+
+	/* Therefore, we can free the state now. */
 	spin_lock_bh(&sta->lock);
 	*state = HT_AGG_STATE_IDLE;
 	sta->ampdu_mlme.addba_req_num[tid] = 0;
@@ -873,58 +901,72 @@ void ieee80211_stop_tx_ba_cb(struct ieee
 	spin_unlock_bh(&sta->lock);
 
 	rcu_read_unlock();
+
+	/*
+	 * Now we need to synchronise so that the select_queue function
+	 * can no longer queue on the aggregation queue.
+	 */
+	synchronize_net();
+
+	/* Then, we can kill that queue. */
+	ieee80211_ht_agg_queue_remove(local, agg_queue, ieee802_1d_to_ac[tid]);
+
+	/*
+	 * We just requeued the all the frames that were in the
+	 * removed queue, and since we might miss a softirq we do
+	 * netif_schedule_queue.  ieee80211_wake_queue is not used
+	 * here as this queue is not necessarily stopped
+	 */
+	netif_schedule_queue(netdev_get_tx_queue(local->mdev, agg_queue));
 }
-EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
 
-void ieee80211_start_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
-				      const u8 *ra, u16 tid)
+static void ieee80211_stop_tx_ba_work(struct work_struct *work)
 {
-	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_ra_tid *ra_tid;
-	struct sk_buff *skb = dev_alloc_skb(0);
+	struct ieee80211_local *local;
+	struct tx_ba_work *todo;
+	unsigned long flags;
 
-	if (unlikely(!skb)) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping start BA session", skb->dev->name);
-#endif
-		return;
-	}
-	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-	memcpy(&ra_tid->ra, ra, ETH_ALEN);
-	ra_tid->tid = tid;
+	local = container_of(work, struct ieee80211_local, tx_ba_stop_work);
 
-	skb->pkt_type = IEEE80211_ADDBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
+	spin_lock_irqsave(&local->tx_ba_stop_lock, flags);
+	while (1) {
+		if (list_empty(&local->tx_ba_stop_list))
+			break;
+		todo = list_first_entry(&local->tx_ba_stop_list,
+					struct tx_ba_work, list);
+		list_del(&todo->list);
+		spin_unlock_irqrestore(&local->tx_ba_stop_lock, flags);
+
+		ieee80211_stop_tx_ba_do(local, todo->ra, todo->tid);
+		kfree(todo);
+
+		spin_lock_irqsave(&local->tx_ba_stop_lock, flags);
+	}
+	spin_unlock_irqrestore(&local->tx_ba_stop_lock, flags);
 }
-EXPORT_SYMBOL(ieee80211_start_tx_ba_cb_irqsafe);
 
-void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw,
-				     const u8 *ra, u16 tid)
+void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, const u8 *ra, u8 tid)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	struct ieee80211_ra_tid *ra_tid;
-	struct sk_buff *skb = dev_alloc_skb(0);
+	struct tx_ba_work *todo = kzalloc(sizeof(*todo), GFP_ATOMIC);
+	unsigned long flags;
 
-	if (unlikely(!skb)) {
+	if (unlikely(!todo)) {
 #ifdef CONFIG_MAC80211_HT_DEBUG
-		if (net_ratelimit())
-			printk(KERN_WARNING "%s: Not enough memory, "
-			       "dropping stop BA session", skb->dev->name);
+		printk(KERN_WARNING "%s: Not enough memory, "
+		       "dropping stop BA session", wiphy_name(local->hw.wiphy));
 #endif
 		return;
 	}
-	ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-	memcpy(&ra_tid->ra, ra, ETH_ALEN);
-	ra_tid->tid = tid;
+	memcpy(todo->ra, ra, ETH_ALEN);
+	todo->tid = tid;
 
-	skb->pkt_type = IEEE80211_DELBA_MSG;
-	skb_queue_tail(&local->skb_queue, skb);
-	tasklet_schedule(&local->tasklet);
+	spin_lock_irqsave(&local->tx_ba_stop_lock, flags);
+	list_add_tail(&todo->list, &local->tx_ba_stop_list);
+	queue_work(local->hw.workqueue, &local->tx_ba_stop_work);
+	spin_unlock_irqrestore(&local->tx_ba_stop_lock, flags);
 }
-EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb_irqsafe);
+EXPORT_SYMBOL(ieee80211_stop_tx_ba_cb);
 
 static void ieee80211_set_multicast_list(struct net_device *dev)
 {
@@ -1215,12 +1257,6 @@ static void ieee80211_tasklet_handler(un
 			skb->pkt_type = 0;
 			ieee80211_tx_status(local_to_hw(local), skb);
 			break;
-		case IEEE80211_DELBA_MSG:
-			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
-			ieee80211_stop_tx_ba_cb(local_to_hw(local),
-						ra_tid->ra, ra_tid->tid);
-			dev_kfree_skb(skb);
-			break;
 		case IEEE80211_ADDBA_MSG:
 			ra_tid = (struct ieee80211_ra_tid *) &skb->cb;
 			ieee80211_start_tx_ba_cb(local_to_hw(local),
@@ -1599,6 +1635,10 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 
 	INIT_DELAYED_WORK(&local->scan_work, ieee80211_sta_scan_work);
 
+	INIT_LIST_HEAD(&local->tx_ba_stop_list);
+	spin_lock_init(&local->tx_ba_stop_lock);
+	INIT_WORK(&local->tx_ba_stop_work, ieee80211_stop_tx_ba_work);
+
 	sta_info_init(local);
 
 	tasklet_init(&local->tx_pending_tasklet, ieee80211_tx_pending,
--- everything.orig/include/net/mac80211.h	2008-07-19 02:03:18.000000000 +0200
+++ everything/include/net/mac80211.h	2008-07-19 02:07:08.000000000 +0200
@@ -1734,21 +1734,9 @@ int ieee80211_stop_tx_ba_session(struct 
  *
  * This function must be called by low level driver once it has
  * finished with preparations for the BA session tear down.
+ * This function can be called in any context.
  */
-void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, u8 *ra, u8 tid);
-
-/**
- * ieee80211_stop_tx_ba_cb_irqsafe - low level driver ready to stop aggregate.
- * @hw: pointer as obtained from ieee80211_alloc_hw().
- * @ra: receiver address of the BA session recipient.
- * @tid: the desired TID to BA on.
- *
- * This function must be called by low level driver once it has
- * finished with preparations for the BA session tear down.
- * This version of the function is IRQ-safe.
- */
-void ieee80211_stop_tx_ba_cb_irqsafe(struct ieee80211_hw *hw, const u8 *ra,
-				     u16 tid);
+void ieee80211_stop_tx_ba_cb(struct ieee80211_hw *hw, const u8 *ra, u8 tid);
 
 /**
  * ieee80211_notify_mac - low level driver notification
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-07-19 02:10:42.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-07-19 02:10:46.000000000 +0200
@@ -1304,7 +1304,7 @@ int iwl_tx_agg_stop(struct iwl_priv *pri
 	if (ret)
 		return ret;
 
-	ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, ra, tid);
+	ieee80211_stop_tx_ba_cb(priv->hw, ra, tid);
 
 	return 0;
 }
@@ -1328,7 +1328,7 @@ int iwl_txq_check_empty(struct iwl_priv 
 			priv->cfg->ops->lib->txq_agg_disable(priv, txq_id,
 							     ssn, tx_fifo);
 			tid_data->agg.state = IWL_AGG_OFF;
-			ieee80211_stop_tx_ba_cb_irqsafe(priv->hw, addr, tid);
+			ieee80211_stop_tx_ba_cb(priv->hw, addr, tid);
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
--- everything.orig/net/mac80211/wme.c	2008-07-19 02:14:14.000000000 +0200
+++ everything/net/mac80211/wme.c	2008-07-19 02:36:01.000000000 +0200
@@ -222,17 +222,83 @@ int ieee80211_ht_agg_queue_add(struct ie
 	return -EAGAIN;
 }
 
+static void ieee80211_requeue_fromagg(struct ieee80211_local *local,
+				      int queue, u16 new_queue)
+{
+	struct netdev_queue *from_txq = netdev_get_tx_queue(local->mdev, queue);
+	struct netdev_queue *to_txq;
+	struct sk_buff_head list;
+	spinlock_t *from_root_lock = NULL, *to_root_lock;
+	struct Qdisc *qdisc, *to_qdisc = NULL;
+	u32 len;
+
+	rcu_read_lock_bh();
+
+	qdisc = rcu_dereference(from_txq->qdisc);
+	if (!qdisc || !qdisc->dequeue)
+		goto out_unlock;
+
+	to_txq = netdev_get_tx_queue(local->mdev, new_queue);
+	to_qdisc = rcu_dereference(to_txq->qdisc);
+	if (!to_qdisc || !to_qdisc->enqueue)
+		goto out_unlock;
+
+	to_root_lock = qdisc_root_lock(to_qdisc);
+
+	if (to_qdisc != qdisc)
+		from_root_lock = qdisc_root_lock(qdisc);
+
+	skb_queue_head_init(&list);
+
+	spin_lock(to_root_lock);
+
+	if (from_root_lock) {
+		spin_lock(from_root_lock);
+		for (len = qdisc->q.qlen; len > 0; len--) {
+			struct sk_buff *skb = qdisc->dequeue(qdisc);
+
+			if (skb)
+				__skb_queue_tail(&list, skb);
+		}
+		spin_unlock(from_root_lock);
+	} else {
+		for (len = qdisc->q.qlen; len > 0; len--) {
+			struct sk_buff *skb = qdisc->dequeue(qdisc);
+
+			if (skb)
+				__skb_queue_tail(&list, skb);
+		}
+	}
+
+	for (len = list.qlen; len > 0; len--) {
+		struct sk_buff *skb = __skb_dequeue(&list);
+
+		BUG_ON(!skb);
+		skb_set_queue_mapping(skb, new_queue);
+
+		to_qdisc->enqueue(skb, qdisc);
+	}
+
+	spin_unlock(to_root_lock);
+
+ out_unlock:
+	rcu_read_unlock_bh();
+}
+
 /**
  * the caller needs to hold netdev_get_tx_queue(local->mdev, X)->lock
+ *
+ * regular_queue >= 0 indicates that requeueing must be done and will
+ * go to that queue.
  */
 void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
-				   u16 agg_queue, bool requeue)
+				   u16 agg_queue, int regular_queue)
 {
 	/* return the qdisc to the pool */
 	clear_bit(agg_queue, local->queue_pool);
 
-	if (requeue) {
-		ieee80211_requeue(local, agg_queue);
+	if (regular_queue >= 0) {
+		ieee80211_requeue_fromagg(local, agg_queue, regular_queue);
 	} else {
 		struct netdev_queue *txq;
 		spinlock_t *root_lock;
@@ -246,7 +312,7 @@ void ieee80211_ht_agg_queue_remove(struc
 	}
 }
 
-void ieee80211_requeue(struct ieee80211_local *local, int queue)
+void ieee80211_requeue_toagg(struct ieee80211_local *local, int queue)
 {
 	struct netdev_queue *txq = netdev_get_tx_queue(local->mdev, queue);
 	struct sk_buff_head list;
@@ -291,6 +357,6 @@ void ieee80211_requeue(struct ieee80211_
 		spin_unlock(root_lock);
 	}
 
-out_unlock:
+ out_unlock:
 	rcu_read_unlock_bh();
 }
--- everything.orig/net/mac80211/wme.h	2008-07-19 02:14:37.000000000 +0200
+++ everything/net/mac80211/wme.h	2008-07-19 02:28:12.000000000 +0200
@@ -27,7 +27,7 @@ u16 ieee80211_select_queue(struct net_de
 int ieee80211_ht_agg_queue_add(struct ieee80211_local *local,
 			       struct sta_info *sta, u16 tid);
 void ieee80211_ht_agg_queue_remove(struct ieee80211_local *local,
-				   u16 agg_queue, bool requeue);
-void ieee80211_requeue(struct ieee80211_local *local, int queue);
+				   u16 agg_queue, int regular_queue);
+void ieee80211_requeue_toagg(struct ieee80211_local *local, int from);
 
 #endif /* _WME_H */

-- 

