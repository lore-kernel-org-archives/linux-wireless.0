Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59612 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757826AbZCWQcq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Mar 2009 12:32:46 -0400
Message-Id: <20090323163053.563402186@sipsolutions.net> (sfid-20090323_173311_250111_64C94EA1)
References: <20090323162834.154525349@sipsolutions.net>
Date: Mon, 23 Mar 2009 17:28:42 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Reinette Chattre <reinette.chatre@intel.com>
Subject: [PATCH 8/8] mac80211/iwlwifi: move virtual A-MDPU queue
 bookkeeping to iwlwifi
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes all the virtual A-MPDU-queue bookkeeping from
mac80211. Curiously, iwlwifi already does its own bookkeeping, so
it doesn't require much changes except where it needs to handle
starting and stopping the queues in mac80211.

To handle the queue stop/wake properly, we rewrite the software
queue number for aggregation frames and internally to iwlwifi keep
track of the queues that map into the same AC queue, and only talk
to mac80211 about the AC queue. The implementation requires calling
two new functions, iwl_stop_queue and iwl_wake_queue instead of the
mac80211 counterparts.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: Reinette Chattre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    7 +--
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    7 +--
 drivers/net/wireless/iwlwifi/iwl-core.c     |    3 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    6 ++
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |   52 +++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    8 ++-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    2 
 drivers/net/wireless/mac80211_hwsim.c       |    1 
 include/net/mac80211.h                      |   14 ------
 net/mac80211/agg-tx.c                       |   44 +--------------------
 net/mac80211/ieee80211_i.h                  |    7 ---
 net/mac80211/main.c                         |    9 ----
 net/mac80211/sta_info.c                     |   12 -----
 net/mac80211/sta_info.h                     |    2 
 net/mac80211/tx.c                           |   19 ---------
 net/mac80211/util.c                         |   58 +++-------------------------
 17 files changed, 84 insertions(+), 169 deletions(-)

--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-03-23 14:04:30.000000000 +0100
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-03-23 14:04:33.000000000 +0100
@@ -592,12 +592,7 @@ struct ieee80211_local {
 
 	const struct ieee80211_ops *ops;
 
-	/* AC queue corresponding to each AMPDU queue */
-	s8 ampdu_ac_queue[IEEE80211_MAX_AMPDU_QUEUES];
-	unsigned int amdpu_ac_stop_refcnt[IEEE80211_MAX_AMPDU_QUEUES];
-
-	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES +
-					 IEEE80211_MAX_AMPDU_QUEUES];
+	unsigned long queue_stop_reasons[IEEE80211_MAX_QUEUES];
 	/* also used to protect ampdu_ac_queue and amdpu_ac_stop_refcnt */
 	spinlock_t queue_stop_reason_lock;
 
--- wireless-testing.orig/net/mac80211/util.c	2009-03-23 14:03:45.000000000 +0100
+++ wireless-testing/net/mac80211/util.c	2009-03-23 14:04:33.000000000 +0100
@@ -339,29 +339,8 @@ static void __ieee80211_wake_queue(struc
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (queue >= hw->queues) {
-		if (local->ampdu_ac_queue[queue - hw->queues] < 0)
-			return;
-
-		/*
-		 * for virtual aggregation queues, we need to refcount the
-		 * internal mac80211 disable (multiple times!), keep track of
-		 * driver disable _and_ make sure the regular queue is
-		 * actually enabled.
-		 */
-		if (reason == IEEE80211_QUEUE_STOP_REASON_AGGREGATION)
-			local->amdpu_ac_stop_refcnt[queue - hw->queues]--;
-		else
-			__clear_bit(reason, &local->queue_stop_reasons[queue]);
-
-		if (local->queue_stop_reasons[queue] ||
-		    local->amdpu_ac_stop_refcnt[queue - hw->queues])
-			return;
-
-		/* now go on to treat the corresponding regular queue */
-		queue = local->ampdu_ac_queue[queue - hw->queues];
-		reason = IEEE80211_QUEUE_STOP_REASON_AGGREGATION;
-	}
+	if (WARN_ON(queue >= hw->queues))
+		return;
 
 	__clear_bit(reason, &local->queue_stop_reasons[queue]);
 
@@ -400,25 +379,8 @@ static void __ieee80211_stop_queue(struc
 {
 	struct ieee80211_local *local = hw_to_local(hw);
 
-	if (queue >= hw->queues) {
-		if (local->ampdu_ac_queue[queue - hw->queues] < 0)
-			return;
-
-		/*
-		 * for virtual aggregation queues, we need to refcount the
-		 * internal mac80211 disable (multiple times!), keep track of
-		 * driver disable _and_ make sure the regular queue is
-		 * actually enabled.
-		 */
-		if (reason == IEEE80211_QUEUE_STOP_REASON_AGGREGATION)
-			local->amdpu_ac_stop_refcnt[queue - hw->queues]++;
-		else
-			__set_bit(reason, &local->queue_stop_reasons[queue]);
-
-		/* now go on to treat the corresponding regular queue */
-		queue = local->ampdu_ac_queue[queue - hw->queues];
-		reason = IEEE80211_QUEUE_STOP_REASON_AGGREGATION;
-	}
+	if (WARN_ON(queue >= hw->queues))
+		return;
 
 	/*
 	 * Only stop if it was previously running, this is necessary
@@ -474,15 +436,9 @@ EXPORT_SYMBOL(ieee80211_stop_queues);
 int ieee80211_queue_stopped(struct ieee80211_hw *hw, int queue)
 {
 	struct ieee80211_local *local = hw_to_local(hw);
-	unsigned long flags;
 
-	if (queue >= hw->queues) {
-		spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
-		queue = local->ampdu_ac_queue[queue - hw->queues];
-		spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
-		if (queue < 0)
-			return true;
-	}
+	if (WARN_ON(queue >= hw->queues))
+		return true;
 
 	return __netif_subqueue_stopped(local->mdev, queue);
 }
@@ -497,7 +453,7 @@ void ieee80211_wake_queues_by_reason(str
 
 	spin_lock_irqsave(&local->queue_stop_reason_lock, flags);
 
-	for (i = 0; i < hw->queues + hw->ampdu_queues; i++)
+	for (i = 0; i < hw->queues; i++)
 		__ieee80211_wake_queue(hw, i, reason);
 
 	spin_unlock_irqrestore(&local->queue_stop_reason_lock, flags);
--- wireless-testing.orig/net/mac80211/agg-tx.c	2009-03-23 14:04:30.000000000 +0100
+++ wireless-testing/net/mac80211/agg-tx.c	2009-03-23 14:04:33.000000000 +0100
@@ -131,14 +131,6 @@ static int ___ieee80211_stop_tx_ba_sessi
 
 	state = &sta->ampdu_mlme.tid_state_tx[tid];
 
-	if (local->hw.ampdu_queues) {
-		/*
-		 * Pretend the driver woke the queue, just in case
-		 * it disabled it before the session was stopped.
-		 */
-		ieee80211_wake_queue(
-			&local->hw, local->hw.queues + sta->tid_to_tx_q[tid]);
-	}
 	*state = HT_AGG_STATE_REQ_STOP_BA_MSK |
 		(initiator << HT_AGG_STATE_INITIATOR_SHIFT);
 
@@ -206,7 +198,7 @@ int ieee80211_start_tx_ba_session(struct
 	struct sta_info *sta;
 	struct ieee80211_sub_if_data *sdata;
 	u8 *state;
-	int i, qn = -1, ret = 0;
+	int ret = 0;
 	u16 start_seq_num;
 
 	if (WARN_ON(!local->ops->ampdu_action))
@@ -275,29 +267,6 @@ int ieee80211_start_tx_ba_session(struct
 		goto err_unlock_sta;
 	}
 
-	if (hw->ampdu_queues) {
-		spin_lock(&local->queue_stop_reason_lock);
-		/* reserve a new queue for this session */
-		for (i = 0; i < local->hw.ampdu_queues; i++) {
-			if (local->ampdu_ac_queue[i] < 0) {
-				qn = i;
-				local->ampdu_ac_queue[qn] =
-					ieee80211_ac_from_tid(tid);
-				break;
-			}
-		}
-		spin_unlock(&local->queue_stop_reason_lock);
-
-		if (qn < 0) {
-#ifdef CONFIG_MAC80211_HT_DEBUG
-			printk(KERN_DEBUG "BA request denied - "
-			       "queue unavailable for tid %d\n", tid);
-#endif /* CONFIG_MAC80211_HT_DEBUG */
-			ret = -ENOSPC;
-			goto err_unlock_sta;
-		}
-	}
-
 	/*
 	 * While we're asking the driver about the aggregation,
 	 * stop the AC queue so that we don't have to worry
@@ -319,7 +288,7 @@ int ieee80211_start_tx_ba_session(struct
 					tid);
 #endif
 		ret = -ENOMEM;
-		goto err_return_queue;
+		goto err_wake_queue;
 	}
 
 	skb_queue_head_init(&sta->ampdu_mlme.tid_tx[tid]->pending);
@@ -348,7 +317,6 @@ int ieee80211_start_tx_ba_session(struct
 		*state = HT_AGG_STATE_IDLE;
 		goto err_free;
 	}
-	sta->tid_to_tx_q[tid] = qn;
 
 	/* Driver vetoed or OKed, but we can take packets again now */
 	ieee80211_wake_queue_by_reason(
@@ -380,13 +348,7 @@ int ieee80211_start_tx_ba_session(struct
  err_free:
 	kfree(sta->ampdu_mlme.tid_tx[tid]);
 	sta->ampdu_mlme.tid_tx[tid] = NULL;
- err_return_queue:
-	if (qn >= 0) {
-		/* give queue back to pool */
-		spin_lock(&local->queue_stop_reason_lock);
-		local->ampdu_ac_queue[qn] = -1;
-		spin_unlock(&local->queue_stop_reason_lock);
-	}
+ err_wake_queue:
 	ieee80211_wake_queue_by_reason(
 		&local->hw, ieee80211_ac_from_tid(tid),
 		IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
--- wireless-testing.orig/net/mac80211/main.c	2009-03-23 14:04:30.000000000 +0100
+++ wireless-testing/net/mac80211/main.c	2009-03-23 14:04:33.000000000 +0100
@@ -774,11 +774,6 @@ struct ieee80211_hw *ieee80211_alloc_hw(
 	setup_timer(&local->dynamic_ps_timer,
 		    ieee80211_dynamic_ps_timer, (unsigned long) local);
 
-	for (i = 0; i < IEEE80211_MAX_AMPDU_QUEUES; i++)
-		local->ampdu_ac_queue[i] = -1;
-	/* using an s8 won't work with more than that */
-	BUILD_BUG_ON(IEEE80211_MAX_AMPDU_QUEUES > 127);
-
 	sta_info_init(local);
 
 	for (i = 0; i < IEEE80211_MAX_QUEUES; i++)
@@ -874,10 +869,6 @@ int ieee80211_register_hw(struct ieee802
 	 */
 	if (hw->queues > IEEE80211_MAX_QUEUES)
 		hw->queues = IEEE80211_MAX_QUEUES;
-	if (hw->ampdu_queues > IEEE80211_MAX_AMPDU_QUEUES)
-		hw->ampdu_queues = IEEE80211_MAX_AMPDU_QUEUES;
-	if (hw->queues < 4)
-		hw->ampdu_queues = 0;
 
 	mdev = alloc_netdev_mq(sizeof(struct ieee80211_master_priv),
 			       "wmaster%d", ieee80211_master_setup,
--- wireless-testing.orig/include/net/mac80211.h	2009-03-23 14:04:30.000000000 +0100
+++ wireless-testing/include/net/mac80211.h	2009-03-23 14:04:33.000000000 +0100
@@ -93,12 +93,9 @@ struct ieee80211_ht_bss_info {
  * enum ieee80211_max_queues - maximum number of queues
  *
  * @IEEE80211_MAX_QUEUES: Maximum number of regular device queues.
- * @IEEE80211_MAX_AMPDU_QUEUES: Maximum number of queues usable
- *	for A-MPDU operation.
  */
 enum ieee80211_max_queues {
 	IEEE80211_MAX_QUEUES =		4,
-	IEEE80211_MAX_AMPDU_QUEUES =	16,
 };
 
 /**
@@ -947,12 +944,6 @@ enum ieee80211_hw_flags {
  *	data packets. WMM/QoS requires at least four, these
  *	queues need to have configurable access parameters.
  *
- * @ampdu_queues: number of available hardware transmit queues
- *	for A-MPDU packets, these have no access parameters
- *	because they're used only for A-MPDU frames. Note that
- *	mac80211 will not currently use any of the regular queues
- *	for aggregation.
- *
  * @rate_control_algorithm: rate control algorithm for this hardware.
  *	If unset (NULL), the default algorithm will be used. Must be
  *	set before calling ieee80211_register_hw().
@@ -977,7 +968,6 @@ struct ieee80211_hw {
 	int vif_data_size;
 	int sta_data_size;
 	u16 queues;
-	u16 ampdu_queues;
 	u16 max_listen_interval;
 	s8 max_signal;
 	u8 max_rates;
@@ -1347,8 +1337,8 @@ enum ieee80211_ampdu_mlme_action {
  * @get_tx_stats: Get statistics of the current TX queue status. This is used
  *	to get number of currently queued packets (queue length), maximum queue
  *	size (limit), and total number of packets sent using each TX queue
- *	(count). The 'stats' pointer points to an array that has hw->queues +
- *	hw->ampdu_queues items.
+ *	(count). The 'stats' pointer points to an array that has hw->queues
+ *	items.
  *
  * @get_tsf: Get the current TSF timer value from firmware/hardware. Currently,
  *	this is only used for IBSS mode BSSID merging and debugging. Is not a
--- wireless-testing.orig/net/mac80211/sta_info.c	2009-03-23 14:04:30.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.c	2009-03-23 14:04:33.000000000 +0100
@@ -203,17 +203,6 @@ void sta_info_destroy(struct sta_info *s
 		if (tid_rx)
 			tid_rx->shutdown = true;
 
-		/*
-		 * The stop callback cannot find this station any more, but
-		 * it didn't complete its work -- start the queue if necessary
-		 */
-		if (sta->ampdu_mlme.tid_state_tx[i] & HT_AGG_STATE_INITIATOR_MSK &&
-		    sta->ampdu_mlme.tid_state_tx[i] & HT_AGG_STATE_REQ_STOP_BA_MSK &&
-		    local->hw.ampdu_queues)
-			ieee80211_wake_queue_by_reason(&local->hw,
-				local->hw.queues + sta->tid_to_tx_q[i],
-				IEEE80211_QUEUE_STOP_REASON_AGGREGATION);
-
 		spin_unlock_bh(&sta->lock);
 
 		/*
@@ -292,7 +281,6 @@ struct sta_info *sta_info_alloc(struct i
 		 * enable session_timer's data differentiation. refer to
 		 * sta_rx_agg_session_timer_expired for useage */
 		sta->timer_to_tid[i] = i;
-		sta->tid_to_tx_q[i] = -1;
 		/* rx */
 		sta->ampdu_mlme.tid_state_rx[i] = HT_AGG_STATE_IDLE;
 		sta->ampdu_mlme.tid_rx[i] = NULL;
--- wireless-testing.orig/net/mac80211/sta_info.h	2009-03-23 14:04:30.000000000 +0100
+++ wireless-testing/net/mac80211/sta_info.h	2009-03-23 14:04:33.000000000 +0100
@@ -206,7 +206,6 @@ struct sta_ampdu_mlme {
  * @tid_seq: per-TID sequence numbers for sending to this STA
  * @ampdu_mlme: A-MPDU state machine state
  * @timer_to_tid: identity mapping to ID timers
- * @tid_to_tx_q: map tid to tx queue (invalid == negative values)
  * @llid: Local link ID
  * @plid: Peer link ID
  * @reason: Cancel reason on PLINK_HOLDING state
@@ -281,7 +280,6 @@ struct sta_info {
 	 */
 	struct sta_ampdu_mlme ampdu_mlme;
 	u8 timer_to_tid[STA_TID_NUM];
-	s8 tid_to_tx_q[STA_TID_NUM];
 
 #ifdef CONFIG_MAC80211_MESH
 	/*
--- wireless-testing.orig/net/mac80211/tx.c	2009-03-23 14:04:30.000000000 +0100
+++ wireless-testing/net/mac80211/tx.c	2009-03-23 14:04:33.000000000 +0100
@@ -1145,25 +1145,6 @@ static int __ieee80211_tx(struct ieee802
 			info->flags &= ~(IEEE80211_TX_CTL_CLEAR_PS_FILT |
 					 IEEE80211_TX_CTL_FIRST_FRAGMENT);
 
-		/*
-		 * Internally, we need to have the queue mapping point to
-		 * the real AC queue, not the virtual A-MPDU queue. This
-		 * now finally sets the queue to what the driver wants.
-		 * We will later move this down into the only driver that
-		 * needs it, iwlwifi.
-		 */
-		if (sta && local->hw.ampdu_queues &&
-		    info->flags & IEEE80211_TX_CTL_AMPDU) {
-			unsigned long flags;
-			u8 *qc = ieee80211_get_qos_ctl((void *) skb->data);
-			int tid = *qc & IEEE80211_QOS_CTL_TID_MASK;
-
-			spin_lock_irqsave(&sta->lock, flags);
-			skb_set_queue_mapping(skb, local->hw.queues +
-						   sta->tid_to_tx_q[tid]);
-			spin_unlock_irqrestore(&sta->lock, flags);
-		}
-
 		next = skb->next;
 		len = skb->len;
 		ret = local->ops->tx(local_to_hw(local), skb);
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-core.c	2009-03-23 13:24:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-core.c	2009-03-23 14:04:33.000000000 +0100
@@ -1309,9 +1309,6 @@ int iwl_setup_mac(struct iwl_priv *priv)
 
 	/* Default value; 4 EDCA QOS priorities */
 	hw->queues = 4;
-	/* queues to support 11n aggregation */
-	if (priv->cfg->sku & IWL_SKU_N)
-		hw->ampdu_queues = priv->cfg->mod_params->num_of_ampdu_queues;
 
 	hw->conf.beacon_int = 100;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
--- wireless-testing.orig/drivers/net/wireless/mac80211_hwsim.c	2009-03-23 13:24:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/mac80211_hwsim.c	2009-03-23 14:04:33.000000000 +0100
@@ -927,7 +927,6 @@ static int __init init_mac80211_hwsim(vo
 			BIT(NL80211_IFTYPE_STATION) |
 			BIT(NL80211_IFTYPE_AP) |
 			BIT(NL80211_IFTYPE_MESH_POINT);
-		hw->ampdu_queues = 1;
 
 		hw->flags = IEEE80211_HW_MFP_CAPABLE;
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-3945.c	2009-03-23 13:24:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-3945.c	2009-03-23 14:04:33.000000000 +0100
@@ -293,7 +293,7 @@ static void iwl3945_tx_queue_reclaim(str
 	if (iwl_queue_space(q) > q->low_mark && (txq_id >= 0) &&
 			(txq_id != IWL_CMD_QUEUE_NUM) &&
 			priv->mac80211_registered)
-		ieee80211_wake_queue(priv->hw, txq_id);
+		iwl_wake_queue(priv, txq_id);
 }
 
 /**
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-4965.c	2009-03-23 13:24:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-4965.c	2009-03-23 14:04:33.000000000 +0100
@@ -2178,10 +2178,9 @@ static void iwl4965_rx_reply_tx(struct i
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
 				if (agg->state == IWL_AGG_OFF)
-					ieee80211_wake_queue(priv->hw, txq_id);
+					iwl_wake_queue(priv, txq_id);
 				else
-					ieee80211_wake_queue(priv->hw,
-							     txq->swq_id);
+					iwl_wake_queue(priv, txq->swq_id);
 			}
 		}
 	} else {
@@ -2205,7 +2204,7 @@ static void iwl4965_rx_reply_tx(struct i
 
 		if (priv->mac80211_registered &&
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
-			ieee80211_wake_queue(priv->hw, txq_id);
+			iwl_wake_queue(priv, txq_id);
 	}
 
 	if (qc && likely(sta_id != IWL_INVALID_STATION))
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-5000.c	2009-03-23 13:24:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-5000.c	2009-03-23 14:04:33.000000000 +0100
@@ -1295,10 +1295,9 @@ static void iwl5000_rx_reply_tx(struct i
 			    (iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 			    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA)) {
 				if (agg->state == IWL_AGG_OFF)
-					ieee80211_wake_queue(priv->hw, txq_id);
+					iwl_wake_queue(priv, txq_id);
 				else
-					ieee80211_wake_queue(priv->hw,
-							     txq->swq_id);
+					iwl_wake_queue(priv, txq->swq_id);
 			}
 		}
 	} else {
@@ -1324,7 +1323,7 @@ static void iwl5000_rx_reply_tx(struct i
 
 		if (priv->mac80211_registered &&
 		    (iwl_queue_space(&txq->q) > txq->q.low_mark))
-			ieee80211_wake_queue(priv->hw, txq_id);
+			iwl_wake_queue(priv, txq_id);
 	}
 
 	if (ieee80211_is_data_qos(tx_resp->frame_ctrl))
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-dev.h	2009-03-23 13:24:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-dev.h	2009-03-23 14:04:33.000000000 +0100
@@ -996,6 +996,12 @@ struct iwl_priv {
 	u8 key_mapping_key;
 	unsigned long ucode_key_table;
 
+	/* queue refcounts */
+#define IWL_MAX_HW_QUEUES	32
+	unsigned long queue_stopped[BITS_TO_LONGS(IWL_MAX_HW_QUEUES)];
+	/* for each AC */
+	atomic_t queue_stop_count[4];
+
 	/* Indication if ieee80211_ops->open has been called */
 	u8 is_open;
 
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-helpers.h	2009-03-23 13:24:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-helpers.h	2009-03-23 14:04:33.000000000 +0100
@@ -93,4 +93,56 @@ static inline int iwl_alloc_fw_desc(stru
 	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
 }
 
+/*
+ * we have 8 bits used like this:
+ *
+ * 7 6 5 4 3 2 1 0
+ * | | | | | | | |
+ * | | | | | | +-+-------- AC queue (0-3)
+ * | | | | | |
+ * | +-+-+-+-+------------ HW A-MPDU queue
+ * |
+ * +---------------------- indicates agg queue
+ */
+static inline u8 iwl_virtual_agg_queue_num(u8 ac, u8 hwq)
+{
+	BUG_ON(ac > 3);   /* only have 2 bits */
+	BUG_ON(hwq > 31); /* only have 5 bits */
+
+	return 0x80 | (hwq << 2) | ac;
+}
+
+static inline void iwl_wake_queue(struct iwl_priv *priv, u8 queue)
+{
+	u8 ac = queue;
+	u8 hwq = queue;
+
+	if (queue & 0x80) {
+		ac = queue & 3;
+		hwq = (queue >> 2) & 0x1f;
+	}
+
+	if (test_and_clear_bit(hwq, priv->queue_stopped))
+		if (atomic_dec_return(&priv->queue_stop_count[ac]) <= 0)
+			ieee80211_wake_queue(priv->hw, ac);
+}
+
+static inline void iwl_stop_queue(struct iwl_priv *priv, u8 queue)
+{
+	u8 ac = queue;
+	u8 hwq = queue;
+
+	if (queue & 0x80) {
+		ac = queue & 3;
+		hwq = (queue >> 2) & 0x1f;
+	}
+
+	if (!test_and_set_bit(hwq, priv->queue_stopped))
+		if (atomic_inc_return(&priv->queue_stop_count[ac]) > 0)
+			ieee80211_stop_queue(priv->hw, ac);
+}
+
+#define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
+#define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
+
 #endif				/* __iwl_helpers_h__ */
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2009-03-23 13:24:03.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl-tx.c	2009-03-23 14:04:33.000000000 +0100
@@ -763,8 +763,10 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 		hdr->seq_ctrl |= cpu_to_le16(seq_number);
 		seq_number += 0x10;
 		/* aggregation is on for this <sta,tid> */
-		if (info->flags & IEEE80211_TX_CTL_AMPDU)
+		if (info->flags & IEEE80211_TX_CTL_AMPDU) {
 			txq_id = priv->stations[sta_id].tid[tid].agg.txq_id;
+			swq_id = iwl_virtual_agg_queue_num(swq_id, txq_id);
+		}
 		priv->stations[sta_id].tid[tid].tfds_in_queue++;
 	}
 
@@ -895,7 +897,7 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 			iwl_txq_update_write_ptr(priv, txq);
 			spin_unlock_irqrestore(&priv->lock, flags);
 		} else {
-			ieee80211_stop_queue(priv->hw, txq->swq_id);
+			iwl_stop_queue(priv, txq->swq_id);
 		}
 	}
 
@@ -1433,7 +1435,7 @@ void iwl_rx_reply_compressed_ba(struct i
 		if ((iwl_queue_space(&txq->q) > txq->q.low_mark) &&
 		    priv->mac80211_registered &&
 		    (agg->state != IWL_EMPTYING_HW_QUEUE_DELBA))
-			ieee80211_wake_queue(priv->hw, txq->swq_id);
+			iwl_wake_queue(priv, txq->swq_id);
 
 		iwl_txq_check_empty(priv, sta_id, tid, scd_flow);
 	}
--- wireless-testing.orig/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-03-23 13:24:02.000000000 +0100
+++ wireless-testing/drivers/net/wireless/iwlwifi/iwl3945-base.c	2009-03-23 14:04:33.000000000 +0100
@@ -1168,7 +1168,7 @@ static int iwl3945_tx_skb(struct iwl_pri
 			spin_unlock_irqrestore(&priv->lock, flags);
 		}
 
-		ieee80211_stop_queue(priv->hw, skb_get_queue_mapping(skb));
+		iwl_stop_queue(priv, skb_get_queue_mapping(skb));
 	}
 
 	return 0;

-- 

