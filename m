Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33716 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754813Ab2FFNXh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jun 2012 09:23:37 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 19/29] iwlwifi: s/txq_setup/txq_enable
Date: Wed,  6 Jun 2012 15:22:00 +0200
Message-Id: <1338988930-11561-19-git-send-email-johannes@sipsolutions.net> (sfid-20120606_152342_476093_6010A75C)
In-Reply-To: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
References: <1338988930-11561-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

We need to be able to enable / disable Tx queues in HW
dynamically. So this function is no longer related to AGG
only. It can do the job for any queue, even AC ones. Change
the name to better reflect its role.

Also use the new function to configure the AC / CMD queues
in tx_start.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/mac80211.c  |    2 +-
 drivers/net/wireless/iwlwifi/dvm/tx.c        |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |   14 ++++-----
 drivers/net/wireless/iwlwifi/pcie/internal.h |    7 +++--
 drivers/net/wireless/iwlwifi/pcie/trans.c    |   29 +++--------------
 drivers/net/wireless/iwlwifi/pcie/tx.c       |   43 +++++++++++++++++++-------
 6 files changed, 50 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/mac80211.c b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
index 33603c5..32a823d 100644
--- a/drivers/net/wireless/iwlwifi/dvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/dvm/mac80211.c
@@ -665,7 +665,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 		ret = iwl_sta_rx_agg_stop(priv, sta, tid);
 		break;
 	case IEEE80211_AMPDU_TX_START:
-		if (!priv->trans->ops->tx_agg_setup)
+		if (!priv->trans->ops->txq_enable)
 			break;
 		if (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_TXAGG)
 			break;
diff --git a/drivers/net/wireless/iwlwifi/dvm/tx.c b/drivers/net/wireless/iwlwifi/dvm/tx.c
index 494a25c..7fdbd17 100644
--- a/drivers/net/wireless/iwlwifi/dvm/tx.c
+++ b/drivers/net/wireless/iwlwifi/dvm/tx.c
@@ -688,9 +688,8 @@ int iwlagn_tx_agg_oper(struct iwl_priv *priv, struct ieee80211_vif *vif,
 
 	fifo = ctx->ac_to_fifo[tid_to_ac[tid]];
 
-	iwl_trans_tx_agg_setup(priv->trans, q, fifo,
-			       sta_priv->sta_id, tid,
-			       buf_size, ssn);
+	iwl_trans_txq_enable(priv->trans, q, fifo, sta_priv->sta_id, tid,
+			     buf_size, ssn);
 
 	/*
 	 * If the limit is 0, then it wasn't initialised yet,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 1fff285..90ef0dc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -355,7 +355,7 @@ struct iwl_trans;
  *	Must be atomic
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  *	Must be atomic
- * @tx_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
+ * @txq_enable: setup a tx queue for AMPDU - will be called once the HW is
  *	ready and a successful ADDBA response has been received.
  *	May sleep
  * @txq_disable: de-configure a Tx queue to send AMPDUs
@@ -391,8 +391,8 @@ struct iwl_trans_ops {
 	void (*reclaim)(struct iwl_trans *trans, int queue, int ssn,
 			struct sk_buff_head *skbs);
 
-	void (*tx_agg_setup)(struct iwl_trans *trans, int queue, int fifo,
-			     int sta_id, int tid, int frame_limit, u16 ssn);
+	void (*txq_enable)(struct iwl_trans *trans, int queue, int fifo,
+			   int sta_id, int tid, int frame_limit, u16 ssn);
 	void (*txq_disable)(struct iwl_trans *trans, int queue);
 
 	int (*dbgfs_register)(struct iwl_trans *trans, struct dentry* dir);
@@ -551,16 +551,16 @@ static inline void iwl_trans_txq_disable(struct iwl_trans *trans, int queue)
 	trans->ops->txq_disable(trans, queue);
 }
 
-static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans, int queue,
-					  int fifo, int sta_id, int tid,
-					  int frame_limit, u16 ssn)
+static inline void iwl_trans_txq_enable(struct iwl_trans *trans, int queue,
+					int fifo, int sta_id, int tid,
+					int frame_limit, u16 ssn)
 {
 	might_sleep();
 
 	WARN_ONCE(trans->state != IWL_TRANS_FW_ALIVE,
 		  "%s bad state = %d", __func__, trans->state);
 
-	trans->ops->tx_agg_setup(trans, queue, fifo, sta_id, tid,
+	trans->ops->txq_enable(trans, queue, fifo, sta_id, tid,
 				 frame_limit, ssn);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/internal.h b/drivers/net/wireless/iwlwifi/pcie/internal.h
index f802b5a..94201c4 100644
--- a/drivers/net/wireless/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/iwlwifi/pcie/internal.h
@@ -344,8 +344,11 @@ void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
 void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 				   struct iwl_tx_queue *txq,
 				   int tx_fifo_id, bool active);
-void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int queue, int fifo,
-				 int sta_id, int tid, int frame_limit, u16 ssn);
+void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
+					int fifo, int sta_id, int tid,
+					int frame_limit, u16 ssn);
+void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
+			       int sta_id, int tid, int frame_limit, u16 ssn);
 void iwl_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 		      enum dma_data_direction dma_dir);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
diff --git a/drivers/net/wireless/iwlwifi/pcie/trans.c b/drivers/net/wireless/iwlwifi/pcie/trans.c
index 7c7702a..0f59e1f 100644
--- a/drivers/net/wireless/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/iwlwifi/pcie/trans.c
@@ -1054,33 +1054,12 @@ static void iwl_tx_start(struct iwl_trans *trans)
 	iwl_write_prph(trans, SCD_DRAM_BASE_ADDR,
 		       trans_pcie->scd_bc_tbls.dma >> 10);
 
-	iwl_write_prph(trans, SCD_QUEUECHAIN_SEL,
-		       SCD_QUEUECHAIN_SEL_ALL(trans, trans_pcie));
-	iwl_write_prph(trans, SCD_AGGR_SEL, 0);
-
-	/* initiate the queues */
-	for (i = 0; i < trans->cfg->base_params->num_of_queues; i++) {
-		iwl_trans_set_wr_ptrs(trans, i, 0);
-		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
-				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
-		iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
-				SCD_CONTEXT_QUEUE_OFFSET(i) +
-				sizeof(u32),
-				((SCD_WIN_SIZE <<
-				SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-				((SCD_FRAME_LIMIT <<
-				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-	}
-
 	for (i = 0; i < trans_pcie->n_q_to_fifo; i++) {
 		int fifo = trans_pcie->setup_q_to_fifo[i];
 
-		set_bit(i, trans_pcie->queue_used);
-
-		iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[i],
-					      fifo, true);
+		__iwl_trans_pcie_txq_enable(trans, i, fifo, IWL_INVALID_STATION,
+					    IWL_TID_NON_QOS,
+					    SCD_FRAME_LIMIT, 0);
 	}
 
 	/* Activate all Tx DMA/FIFO channels */
@@ -2040,7 +2019,7 @@ static const struct iwl_trans_ops trans_ops_pcie = {
 	.reclaim = iwl_trans_pcie_reclaim,
 
 	.txq_disable = iwl_trans_pcie_txq_disable,
-	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
+	.txq_enable = iwl_trans_pcie_txq_enable,
 
 	.dbgfs_register = iwl_trans_pcie_dbgfs_register,
 
diff --git a/drivers/net/wireless/iwlwifi/pcie/tx.c b/drivers/net/wireless/iwlwifi/pcie/tx.c
index 98ddc80..35e8216 100644
--- a/drivers/net/wireless/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/iwlwifi/pcie/tx.c
@@ -442,29 +442,34 @@ void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 		IWL_DEBUG_TX_QUEUES(trans, "Deactivate queue %d\n", txq_id);
 }
 
-void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int txq_id, int fifo,
-				 int sta_id, int tid, int frame_limit, u16 ssn)
+void __iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id,
+					int fifo, int sta_id, int tid,
+					int frame_limit, u16 ssn)
 {
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	unsigned long flags;
-	u16 ra_tid = BUILD_RAxTID(sta_id, tid);
+
+	lockdep_assert_held(&trans_pcie->irq_lock);
 
 	if (test_and_set_bit(txq_id, trans_pcie->queue_used))
 		WARN_ONCE(1, "queue %d already used - expect issues", txq_id);
 
-	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
-
 	/* Stop this Tx queue before configuring it */
 	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
 
-	/* Map receiver-address / traffic-ID to this queue */
-	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
+	/* Set this queue as a chain-building queue unless it is CMD queue */
+	if (txq_id != trans_pcie->cmd_queue)
+		iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, BIT(txq_id));
+
+	/* If this queue is mapped to a certain station: it is an AGG queue */
+	if (sta_id != IWL_INVALID_STATION) {
+		u16 ra_tid = BUILD_RAxTID(sta_id, tid);
 
-	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(trans, SCD_QUEUECHAIN_SEL, BIT(txq_id));
+		/* Map receiver-address / traffic-ID to this queue */
+		iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
 
-	/* enable aggregations for the queue */
-	iwl_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+		/* enable aggregations for the queue */
+		iwl_set_bits_prph(trans, SCD_AGGR_SEL, BIT(txq_id));
+	}
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -474,6 +479,8 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int txq_id, int fifo,
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
+			SCD_CONTEXT_QUEUE_OFFSET(txq_id), 0);
+	iwl_write_targ_mem(trans, trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) + sizeof(u32),
 			((frame_limit << SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
 				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
@@ -483,6 +490,18 @@ void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans, int txq_id, int fifo,
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwl_trans_tx_queue_set_status(trans, &trans_pcie->txq[txq_id],
 				      fifo, true);
+}
+
+void iwl_trans_pcie_txq_enable(struct iwl_trans *trans, int txq_id, int fifo,
+			       int sta_id, int tid, int frame_limit, u16 ssn)
+{
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	unsigned long flags;
+
+	spin_lock_irqsave(&trans_pcie->irq_lock, flags);
+
+	__iwl_trans_pcie_txq_enable(trans, txq_id, fifo, sta_id,
+				    tid, frame_limit, ssn);
 
 	spin_unlock_irqrestore(&trans_pcie->irq_lock, flags);
 }
-- 
1.7.10

