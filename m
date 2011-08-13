Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:31394 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab1HMSSt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:49 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 56/60] iwlagn: cosmetics in iwl-trans.h
Date: Sat, 13 Aug 2011 10:38:32 -0700
Message-Id: <1313257116-2697-57-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201934_118053_31789BEB)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Remove a few dereferences of priv from the transport layer while
at it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    8 ++--
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   48 ++++++++++----------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   14 +++---
 drivers/net/wireless/iwlwifi/iwl-trans.h          |   16 +++---
 5 files changed, 44 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 034a55a..ed1ac78 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2562,7 +2562,7 @@ static int iwlagn_mac_ampdu_action(struct ieee80211_hw *hw,
 	case IEEE80211_AMPDU_TX_OPERATIONAL:
 		buf_size = min_t(int, buf_size, LINK_QUAL_AGG_FRAME_LIMIT_DEF);
 
-		iwl_trans_txq_agg_setup(trans(priv), ctx->ctxid, iwl_sta_id(sta),
+		iwl_trans_tx_agg_setup(trans(priv), ctx->ctxid, iwl_sta_id(sta),
 				tid, buf_size);
 
 		/*
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index a310831..abb2ce6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -194,15 +194,15 @@ int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
 				  enum iwl_rxon_context_id ctx, int sta_id,
 				  int tid);
 void iwl_trans_set_wr_ptrs(struct iwl_trans *trans, int txq_id, u32 index);
-void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
+void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
 int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 				enum iwl_rxon_context_id ctx, int sta_id,
 				int tid, u16 *ssn);
-void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
-					enum iwl_rxon_context_id ctx,
-					int sta_id, int tid, int frame_limit);
+void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
+				 enum iwl_rxon_context_id ctx,
+				 int sta_id, int tid, int frame_limit);
 void iwlagn_txq_free_tfd(struct iwl_trans *trans, struct iwl_tx_queue *txq,
 	int index);
 int iwl_tx_queue_reclaim(struct iwl_trans *trans, int txq_id, int index,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 7bb86eb..8713233 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -403,14 +403,15 @@ void iwl_trans_set_wr_ptrs(struct iwl_trans *trans,
 	iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(txq_id), index);
 }
 
-void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
+void iwl_trans_tx_queue_set_status(struct iwl_trans *trans,
 					struct iwl_tx_queue *txq,
 					int tx_fifo_id, int scd_retry)
 {
 	int txq_id = txq->q.id;
-	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
+	int active =
+		test_bit(txq_id, &priv(trans)->txq_ctx_active_msk) ? 1 : 0;
 
-	iwl_write_prph(bus(priv), SCD_QUEUE_STATUS_BITS(txq_id),
+	iwl_write_prph(bus(trans), SCD_QUEUE_STATUS_BITS(txq_id),
 			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
 			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
 			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
@@ -418,7 +419,7 @@ void iwl_trans_tx_queue_set_status(struct iwl_priv *priv,
 
 	txq->sched_retry = scd_retry;
 
-	IWL_DEBUG_INFO(priv, "%s %s Queue %d on FIFO %d\n",
+	IWL_DEBUG_INFO(trans, "%s %s Queue %d on FIFO %d\n",
 		       active ? "Activate" : "Deactivate",
 		       scd_retry ? "BA" : "AC/CMD", txq_id, tx_fifo_id);
 }
@@ -434,16 +435,15 @@ static inline int get_fifo_from_tid(struct iwl_trans_pcie *trans_pcie,
 	return -EINVAL;
 }
 
-void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
-				  enum iwl_rxon_context_id ctx, int sta_id,
-				  int tid, int frame_limit)
+void iwl_trans_pcie_tx_agg_setup(struct iwl_trans *trans,
+				 enum iwl_rxon_context_id ctx, int sta_id,
+				 int tid, int frame_limit)
 {
 	int tx_fifo, txq_id, ssn_idx;
 	u16 ra_tid;
 	unsigned long flags;
 	struct iwl_tid_data *tid_data;
 
-	struct iwl_trans *trans = trans(priv);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -458,15 +458,15 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
 		return;
 	}
 
-	spin_lock_irqsave(&priv->shrd->sta_lock, flags);
-	tid_data = &priv->shrd->tid_data[sta_id][tid];
+	spin_lock_irqsave(&trans->shrd->sta_lock, flags);
+	tid_data = &trans->shrd->tid_data[sta_id][tid];
 	ssn_idx = SEQ_TO_SN(tid_data->seq_number);
 	txq_id = tid_data->agg.txq_id;
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 
 	ra_tid = BUILD_RAxTID(sta_id, tid);
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 
 	/* Stop this Tx queue before configuring it */
 	iwlagn_tx_queue_stop_scheduler(trans, txq_id);
@@ -475,19 +475,19 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
 	iwlagn_tx_queue_set_q2ratid(trans, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(bus(priv), SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(bus(trans), SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
 	/* enable aggregations for the queue */
-	iwl_set_bits_prph(bus(priv), SCD_AGGR_SEL, (1<<txq_id));
+	iwl_set_bits_prph(bus(trans), SCD_AGGR_SEL, (1<<txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
-	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
-	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
+	priv(trans)->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
+	priv(trans)->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	iwl_trans_set_wr_ptrs(trans, txq_id, ssn_idx);
 
 	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(bus(priv), trans_pcie->scd_base_addr +
+	iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
 			((frame_limit <<
@@ -497,15 +497,16 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv,
 			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
 			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
-	iwl_set_bits_prph(bus(priv), SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
-	iwl_trans_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
+	iwl_trans_tx_queue_set_status(trans, &priv(trans)->txq[txq_id],
+					tx_fifo, 1);
 
-	priv->txq[txq_id].sta_id = sta_id;
-	priv->txq[txq_id].tid = tid;
+	priv(trans)->txq[txq_id].sta_id = sta_id;
+	priv(trans)->txq[txq_id].tid = tid;
 
-	spin_unlock_irqrestore(&priv->shrd->lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 }
 
 /*
@@ -574,8 +575,7 @@ void iwl_trans_pcie_txq_agg_disable(struct iwl_trans *trans, int txq_id)
 
 	iwl_clear_bits_prph(bus(trans), SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl_txq_ctx_deactivate(priv(trans), txq_id);
-	iwl_trans_tx_queue_set_status(priv(trans),
-					&priv(trans)->txq[txq_id], 0, 0);
+	iwl_trans_tx_queue_set_status(trans, &priv(trans)->txq[txq_id], 0, 0);
 }
 
 int iwl_trans_pcie_tx_agg_disable(struct iwl_trans *trans,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index ab35fd8..9b0ecd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -774,7 +774,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
-	priv->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
+	trans->shrd->ucode_owner = IWL_OWNERSHIP_DRIVER;
 	trans_pcie->ac_to_queue[IWL_RXON_CTX_BSS] = iwlagn_bss_ac_to_queue;
 	trans_pcie->ac_to_queue[IWL_RXON_CTX_PAN] = iwlagn_pan_ac_to_queue;
 
@@ -784,7 +784,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 	trans_pcie->mcast_queue[IWL_RXON_CTX_BSS] = 0;
 	trans_pcie->mcast_queue[IWL_RXON_CTX_PAN] = IWL_IPAN_MCAST_QUEUE;
 
-	if ((hw_params(priv).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
+	if ((hw_params(trans).sku & EEPROM_SKU_CAP_AMT_ENABLE) &&
 	     iwl_trans_pcie_prepare_card_hw(trans)) {
 		IWL_WARN(trans, "Exit HW not ready\n");
 		return -EIO;
@@ -862,7 +862,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 		a += 4)
 		iwl_write_targ_mem(bus(trans), a, 0);
 	for (; a < trans_pcie->scd_base_addr +
-	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(priv).max_txq_num);
+	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(trans).max_txq_num);
 	       a += 4)
 		iwl_write_targ_mem(bus(trans), a, 0);
 
@@ -881,11 +881,11 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
 	iwl_write_prph(bus(trans), SCD_QUEUECHAIN_SEL,
-		SCD_QUEUECHAIN_SEL_ALL(priv));
+		SCD_QUEUECHAIN_SEL_ALL(trans));
 	iwl_write_prph(bus(trans), SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
-	for (i = 0; i < hw_params(priv).max_txq_num; i++) {
+	for (i = 0; i < hw_params(trans).max_txq_num; i++) {
 		iwl_write_prph(bus(trans), SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(bus(trans), HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_targ_mem(bus(trans), trans_pcie->scd_base_addr +
@@ -941,7 +941,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_trans *trans)
 
 		if (ac != IWL_AC_UNSET)
 			iwl_set_swq_id(&priv->txq[i], ac, i);
-		iwl_trans_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
+		iwl_trans_tx_queue_set_status(trans, &priv->txq[i], fifo, 0);
 	}
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
@@ -2017,7 +2017,7 @@ const struct iwl_trans_ops trans_ops_pcie = {
 
 	.tx_agg_disable = iwl_trans_pcie_tx_agg_disable,
 	.tx_agg_alloc = iwl_trans_pcie_tx_agg_alloc,
-	.txq_agg_setup = iwl_trans_pcie_txq_agg_setup,
+	.tx_agg_setup = iwl_trans_pcie_tx_agg_setup,
 
 	.kick_nic = iwl_trans_pcie_kick_nic,
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 1fd6bde..c92c9fe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -95,7 +95,7 @@ struct iwl_device_cmd;
  * @tx: send an skb
  * @reclaim: free packet until ssn. Returns a list of freed packets.
  * @tx_agg_alloc: allocate resources for a TX BA session
- * @txq_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
+ * @tx_agg_setup: setup a tx queue for AMPDU - will be called once the HW is
  *                 ready and a successful ADDBA response has been received.
  * @tx_agg_disable: de-configure a Tx queue to send AMPDUs
  * @kick_nic: remove the RESET from the embedded CPU and let it run
@@ -128,14 +128,14 @@ struct iwl_trans_ops {
 			struct sk_buff_head *skbs);
 
 	int (*tx_agg_disable)(struct iwl_trans *trans,
-			       enum iwl_rxon_context_id ctx, int sta_id,
-			       int tid);
+			      enum iwl_rxon_context_id ctx, int sta_id,
+			      int tid);
 	int (*tx_agg_alloc)(struct iwl_trans *trans,
 			    enum iwl_rxon_context_id ctx, int sta_id, int tid,
 			    u16 *ssn);
-	void (*txq_agg_setup)(struct iwl_priv *priv,
-			      enum iwl_rxon_context_id ctx, int sta_id,
-			      int tid, int frame_limit);
+	void (*tx_agg_setup)(struct iwl_trans *trans,
+			     enum iwl_rxon_context_id ctx, int sta_id, int tid,
+			     int frame_limit);
 
 	void (*kick_nic)(struct iwl_trans *trans);
 
@@ -233,12 +233,12 @@ static inline int iwl_trans_tx_agg_alloc(struct iwl_trans *trans,
 }
 
 
-static inline void iwl_trans_txq_agg_setup(struct iwl_trans *trans,
+static inline void iwl_trans_tx_agg_setup(struct iwl_trans *trans,
 					   enum iwl_rxon_context_id ctx,
 					   int sta_id, int tid,
 					   int frame_limit)
 {
-	trans->ops->txq_agg_setup(priv(trans), ctx, sta_id, tid, frame_limit);
+	trans->ops->tx_agg_setup(trans, ctx, sta_id, tid, frame_limit);
 }
 
 static inline void iwl_trans_kick_nic(struct iwl_trans *trans)
-- 
1.7.0.4

