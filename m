Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:43792 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935431Ab1KJPtn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 10:49:43 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH RESEND 24/27] iwlwifi: add debug information on queue stop / wake
Date: Thu, 10 Nov 2011 06:55:24 -0800
Message-Id: <1320936927-9078-25-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111110_164954_566987_92A1D8B6)
In-Reply-To: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1320936927-9078-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Users complain that the traffic gets stalled sometimes. This will
allow easier debugging.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-rx.c         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-rxon.c       |    3 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c         |    3 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |   35 +++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |   14 +++++---
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   23 ++++++++------
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   15 +++++---
 8 files changed, 67 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
index f0d6d94..fdb4c37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rx.c
@@ -800,7 +800,8 @@ static void iwlagn_pass_packet_to_mac80211(struct iwl_priv *priv,
 					       ctx->active.bssid_addr))
 				continue;
 			ctx->last_tx_rejected = false;
-			iwl_trans_wake_any_queue(trans(priv), ctx->ctxid);
+			iwl_trans_wake_any_queue(trans(priv), ctx->ctxid,
+				"channel got active");
 		}
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
index b73077f..8de97f5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-rxon.c
@@ -844,7 +844,8 @@ void iwlagn_bss_info_changed(struct ieee80211_hw *hw,
 			if (ctx->last_tx_rejected) {
 				ctx->last_tx_rejected = false;
 				iwl_trans_wake_any_queue(trans(priv),
-							 ctx->ctxid);
+							 ctx->ctxid,
+							 "Disassoc: flush queue");
 			}
 			ctx->staging.filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 014b98a..e6a02e0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -813,7 +813,8 @@ int iwlagn_rx_reply_tx(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb,
 			    iwl_is_associated_ctx(ctx) && ctx->vif &&
 			    ctx->vif->type == NL80211_IFTYPE_STATION) {
 				ctx->last_tx_rejected = true;
-				iwl_trans_stop_queue(trans(priv), txq_id);
+				iwl_trans_stop_queue(trans(priv), txq_id,
+					"Tx on passive channel");
 
 				IWL_DEBUG_TX_REPLY(priv,
 					   "TXQ %d status %s (0x%08x) "
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index a11e7aa..40ef97b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -166,7 +166,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DL_11H		(1 << 28)
 #define IWL_DL_STATS		(1 << 29)
 #define IWL_DL_TX_REPLY		(1 << 30)
-#define IWL_DL_UNUSED		(1 << 31)
+#define IWL_DL_TX_QUEUES	(1 << 31)
 
 #define IWL_DEBUG_INFO(p, f, a...)	IWL_DEBUG(p, IWL_DL_INFO, f, ## a)
 #define IWL_DEBUG_MAC80211(p, f, a...)	IWL_DEBUG(p, IWL_DL_MAC80211, f, ## a)
@@ -203,7 +203,7 @@ static inline void iwl_dbgfs_unregister(struct iwl_priv *priv)
 #define IWL_DEBUG_TX_REPLY(p, f, a...)	IWL_DEBUG(p, IWL_DL_TX_REPLY, f, ## a)
 #define IWL_DEBUG_TX_REPLY_LIMIT(p, f, a...) \
 		IWL_DEBUG_LIMIT(p, IWL_DL_TX_REPLY, f, ## a)
-#define IWL_DEBUG_UNUSED(p, f, a...)	IWL_DEBUG(p, IWL_DL_UNUSED, f, ## a)
+#define IWL_DEBUG_TX_QUEUES(p, f, a...)	IWL_DEBUG(p, IWL_DL_TX_QUEUES, f, ## a)
 #define IWL_DEBUG_RADIO(p, f, a...)	IWL_DEBUG(p, IWL_DL_RADIO, f, ## a)
 #define IWL_DEBUG_POWER(p, f, a...)	IWL_DEBUG(p, IWL_DL_POWER, f, ## a)
 #define IWL_DEBUG_11H(p, f, a...)	IWL_DEBUG(p, IWL_DL_11H, f, ## a)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 2b6756e..afaaa2a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -355,7 +355,7 @@ static inline void iwl_set_swq_id(struct iwl_tx_queue *txq, u8 ac, u8 hwq)
 }
 
 static inline void iwl_wake_queue(struct iwl_trans *trans,
-				  struct iwl_tx_queue *txq)
+				  struct iwl_tx_queue *txq, const char *msg)
 {
 	u8 queue = txq->swq_id;
 	u8 ac = queue & 3;
@@ -363,13 +363,22 @@ static inline void iwl_wake_queue(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped))
-		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0)
+	if (test_and_clear_bit(hwq, trans_pcie->queue_stopped)) {
+		if (atomic_dec_return(&trans_pcie->queue_stop_count[ac]) <= 0) {
 			iwl_wake_sw_queue(priv(trans), ac);
+			IWL_DEBUG_TX_QUEUES(trans, "Wake hwq %d ac %d. %s",
+					    hwq, ac, msg);
+		} else {
+			IWL_DEBUG_TX_QUEUES(trans, "Don't wake hwq %d ac %d"
+					    " stop count %d. %s",
+					    hwq, ac, atomic_read(&trans_pcie->
+					    queue_stop_count[ac]), msg);
+		}
+	}
 }
 
 static inline void iwl_stop_queue(struct iwl_trans *trans,
-				  struct iwl_tx_queue *txq)
+				  struct iwl_tx_queue *txq, const char *msg)
 {
 	u8 queue = txq->swq_id;
 	u8 ac = queue & 3;
@@ -377,9 +386,23 @@ static inline void iwl_stop_queue(struct iwl_trans *trans,
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped))
-		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0)
+	if (!test_and_set_bit(hwq, trans_pcie->queue_stopped)) {
+		if (atomic_inc_return(&trans_pcie->queue_stop_count[ac]) > 0) {
 			iwl_stop_sw_queue(priv(trans), ac);
+			IWL_DEBUG_TX_QUEUES(trans, "Stop hwq %d ac %d"
+					    " stop count %d. %s",
+					    hwq, ac, atomic_read(&trans_pcie->
+					    queue_stop_count[ac]), msg);
+		} else {
+			IWL_DEBUG_TX_QUEUES(trans, "Don't stop hwq %d ac %d"
+					    " stop count %d. %s",
+					    hwq, ac, atomic_read(&trans_pcie->
+					    queue_stop_count[ac]), msg);
+		}
+	} else {
+		IWL_DEBUG_TX_QUEUES(trans, "stop hwq %d, but it is stopped/ %s",
+				    hwq, msg);
+	}
 }
 
 #ifdef ieee80211_stop_queue
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index a6d898b..6dba151 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -430,7 +430,7 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 
 	txq->sched_retry = scd_retry;
 
-	IWL_DEBUG_INFO(trans, "%s %s Queue %d on FIFO %d\n",
+	IWL_DEBUG_TX_QUEUES(trans, "%s %s Queue %d on FIFO %d\n",
 		       active ? "Activate" : "Deactivate",
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
@@ -561,12 +561,13 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 
 	tid_data = &trans->shrd->tid_data[sta_id][tid];
 	if (tid_data->tfds_in_queue == 0) {
-		IWL_DEBUG_HT(trans, "HW queue is empty\n");
+		IWL_DEBUG_TX_QUEUES(trans, "HW queue is empty\n");
 		tid_data->agg.state = IWL_AGG_ON;
 		iwl_start_tx_ba_trans_ready(priv(trans), ctx, sta_id, tid);
 	} else {
-		IWL_DEBUG_HT(trans, "HW queue is NOT empty: %d packets in HW"
-			     "queue\n", tid_data->tfds_in_queue);
+		IWL_DEBUG_TX_QUEUES(trans,
+				    "HW queue is NOT empty: %d packets in HW"
+				    " queue\n", tid_data->tfds_in_queue);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
 	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
@@ -643,14 +644,15 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 
 	/* The queue is not empty */
 	if (write_ptr != read_ptr) {
-		IWL_DEBUG_HT(trans, "Stopping a non empty AGG HW QUEUE\n");
+		IWL_DEBUG_TX_QUEUES(trans,
+				    "Stopping a non empty AGG HW QUEUE\n");
 		trans->shrd->tid_data[sta_id][tid].agg.state =
 			IWL_EMPTYING_HW_QUEUE_DELBA;
 		spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 		return 0;
 	}
 
-	IWL_DEBUG_HT(trans, "HW queue is empty\n");
+	IWL_DEBUG_TX_QUEUES(trans, "HW queue is empty\n");
 turn_off:
 	trans->shrd->tid_data[sta_id][tid].agg.state = IWL_AGG_OFF;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index da34110..a1a5833 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -1231,7 +1231,7 @@ static int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 			txq->need_update = 1;
 			iwl_txq_update_write_ptr(trans, txq);
 		} else {
-			iwl_stop_queue(trans, txq);
+			iwl_stop_queue(trans, txq, "Queue is full");
 		}
 	}
 	return 0;
@@ -1283,20 +1283,21 @@ static int iwlagn_txq_check_empty(struct iwl_trans *trans,
 		/* aggregated HW queue */
 		if ((txq_id  == tid_data->agg.txq_id) &&
 		    (q->read_ptr == q->write_ptr)) {
-			IWL_DEBUG_HT(trans,
+			IWL_DEBUG_TX_QUEUES(trans,
 				"HW queue empty: continue DELBA flow\n");
 			iwl_trans_pcie_txq_agg_disable(trans, txq_id);
 			tid_data->agg.state = IWL_AGG_OFF;
 			iwl_stop_tx_ba_trans_ready(priv(trans),
 						   NUM_IWL_RXON_CTX,
 						   sta_id, tid);
-			iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
+			iwl_wake_queue(trans, &trans_pcie->txq[txq_id],
+				       "DELBA flow complete");
 		}
 		break;
 	case IWL_EMPTYING_HW_QUEUE_ADDBA:
 		/* We are reclaiming the last packet of the queue */
 		if (tid_data->tfds_in_queue == 0) {
-			IWL_DEBUG_HT(trans,
+			IWL_DEBUG_TX_QUEUES(trans,
 				"HW queue empty: continue ADDBA flow\n");
 			tid_data->agg.state = IWL_AGG_ON;
 			iwl_start_tx_ba_trans_ready(priv(trans),
@@ -1354,7 +1355,7 @@ static void iwl_trans_pcie_reclaim(struct iwl_trans *trans, int sta_id, int tid,
 				ssn , tfd_num, txq_id, txq->swq_id);
 		freed = iwl_tx_queue_reclaim(trans, txq_id, tfd_num, skbs);
 		if (iwl_queue_space(&txq->q) > txq->q.low_mark && cond)
-			iwl_wake_queue(trans, txq);
+			iwl_wake_queue(trans, txq, "Packets reclaimed");
 	}
 
 	iwl_free_tfds_in_queue(trans, sta_id, tid, freed);
@@ -1418,7 +1419,8 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 #endif /* CONFIG_PM_SLEEP */
 
 static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
-					  enum iwl_rxon_context_id ctx)
+					  enum iwl_rxon_context_id ctx,
+					  const char *msg)
 {
 	u8 ac, txq_id;
 	struct iwl_trans_pcie *trans_pcie =
@@ -1426,11 +1428,11 @@ static void iwl_trans_pcie_wake_any_queue(struct iwl_trans *trans,
 
 	for (ac = 0; ac < AC_NUM; ac++) {
 		txq_id = trans_pcie->ac_to_queue[ctx][ac];
-		IWL_DEBUG_INFO(trans, "Queue Status: Q[%d] %s\n",
+		IWL_DEBUG_TX_QUEUES(trans, "Queue Status: Q[%d] %s\n",
 			ac,
 			(atomic_read(&trans_pcie->queue_stop_count[ac]) > 0)
 			      ? "stopped" : "awake");
-		iwl_wake_queue(trans, &trans_pcie->txq[txq_id]);
+		iwl_wake_queue(trans, &trans_pcie->txq[txq_id], msg);
 	}
 }
 
@@ -1453,11 +1455,12 @@ static struct iwl_trans *iwl_trans_pcie_alloc(struct iwl_shared *shrd)
 	return iwl_trans;
 }
 
-static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id)
+static void iwl_trans_pcie_stop_queue(struct iwl_trans *trans, int txq_id,
+				      const char *msg)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	iwl_stop_queue(trans, &trans_pcie->txq[txq_id]);
+	iwl_stop_queue(trans, &trans_pcie->txq[txq_id], msg);
 }
 
 #define IWL_FLUSH_WAIT_MS	2000
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 1ecdd1c..7839362 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -171,7 +171,8 @@ struct iwl_trans_ops {
 	void (*tx_start)(struct iwl_trans *trans);
 
 	void (*wake_any_queue)(struct iwl_trans *trans,
-			       enum iwl_rxon_context_id ctx);
+			       enum iwl_rxon_context_id ctx,
+			       const char *msg);
 
 	int (*send_cmd)(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 
@@ -196,7 +197,7 @@ struct iwl_trans_ops {
 
 	void (*free)(struct iwl_trans *trans);
 
-	void (*stop_queue)(struct iwl_trans *trans, int q);
+	void (*stop_queue)(struct iwl_trans *trans, int q, const char *msg);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
 	int (*check_stuck_queue)(struct iwl_trans *trans, int q);
@@ -277,9 +278,10 @@ static inline void iwl_trans_tx_start(struct iwl_trans *trans)
 }
 
 static inline void iwl_trans_wake_any_queue(struct iwl_trans *trans,
-					    enum iwl_rxon_context_id ctx)
+					    enum iwl_rxon_context_id ctx,
+					    const char *msg)
 {
-	trans->ops->wake_any_queue(trans, ctx);
+	trans->ops->wake_any_queue(trans, ctx, msg);
 }
 
 
@@ -339,9 +341,10 @@ static inline void iwl_trans_free(struct iwl_trans *trans)
 	trans->ops->free(trans);
 }
 
-static inline void iwl_trans_stop_queue(struct iwl_trans *trans, int q)
+static inline void iwl_trans_stop_queue(struct iwl_trans *trans, int q,
+					const char *msg)
 {
-	trans->ops->stop_queue(trans, q);
+	trans->ops->stop_queue(trans, q, msg);
 }
 
 static inline int iwl_trans_wait_tx_queue_empty(struct iwl_trans *trans)
-- 
1.7.0.4

