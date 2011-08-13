Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:11393 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929Ab1HMSSu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2011 14:18:50 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 30/60] iwlagn: move scd_bc_tbls and scd_base_addr to iwl_trans_pcie
Date: Sat, 13 Aug 2011 10:38:06 -0700
Message-Id: <1313257116-2697-31-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110813_201929_963960_2534DBE4)
In-Reply-To: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1313257116-2697-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Needed for PCIe only

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    3 --
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    4 ++
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   26 ++++++++++++++--
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   33 +++++++++++++-------
 4 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 57b3dd9..f3de4a3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1244,9 +1244,6 @@ struct iwl_priv {
 	struct iwl_tx_queue *txq;
 	unsigned long txq_ctx_active_msk;
 	struct iwl_dma_ptr  kw;	/* keep warm address */
-	struct iwl_dma_ptr  scd_bc_tbls;
-
-	u32 scd_base_addr;	/* scheduler sram base address */
 
 	/* counts mgmt, ctl, and data packets */
 	struct traffic_stats tx_stats;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index 717b6dc..cb4b59d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -91,6 +91,8 @@ struct iwl_rx_queue {
  * @rxq: all the RX queue data
  * @rx_replenish: work that will be called when buffers need to be allocated
  * @trans: pointer to the generic transport area
+ * @scd_base_addr: scheduler sram base address in SRAM
+ * @scd_bc_tbls: pointer to the byte count table of the scheduler
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -109,6 +111,8 @@ struct iwl_trans_pcie {
 	struct isr_statistics isr_stats;
 
 	u32 inta_mask;
+	u32 scd_base_addr;
+	struct iwl_dma_ptr scd_bc_tbls;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 2e54f15..a2f6698 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -45,7 +45,10 @@ void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt)
 {
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 	int write_ptr = txq->q.write_ptr;
 	int txq_id = txq->q.id;
 	u8 sec_ctl = 0;
@@ -53,6 +56,8 @@ void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 	u16 len = byte_cnt + IWL_TX_CRC_SIZE + IWL_TX_DELIMITER_SIZE;
 	__le16 bc_ent;
 
+	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
+
 	WARN_ON(len > 0xFFF || write_ptr >= TFD_QUEUE_SIZE_MAX);
 
 	sta_id = txq->cmd[txq->q.write_ptr]->cmd.tx.sta_id;
@@ -335,12 +340,17 @@ int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 static void iwlagn_txq_inval_byte_cnt_tbl(struct iwl_priv *priv,
 					  struct iwl_tx_queue *txq)
 {
-	struct iwlagn_scd_bc_tbl *scd_bc_tbl = priv->scd_bc_tbls.addr;
+	struct iwlagn_scd_bc_tbl *scd_bc_tbl;
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 	int txq_id = txq->q.id;
 	int read_ptr = txq->q.read_ptr;
 	u8 sta_id = 0;
 	__le16 bc_ent;
 
+	scd_bc_tbl = trans_pcie->scd_bc_tbls.addr;
+
 	WARN_ON(read_ptr >= TFD_QUEUE_SIZE_MAX);
 
 	if (txq_id != priv->shrd->cmd_queue)
@@ -361,9 +371,13 @@ static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	u32 tbl_dw;
 	u16 scd_q2ratid;
 
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
 
-	tbl_dw_addr = priv->scd_base_addr +
+	tbl_dw_addr = trans_pcie->scd_base_addr +
 			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
 
 	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
@@ -424,6 +438,10 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	unsigned long flags;
 	struct iwl_tid_data *tid_data;
 
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
+
 	if (WARN_ON(sta_id == IWL_INVALID_STATION))
 		return;
 	if (WARN_ON(tid >= MAX_TID_COUNT))
@@ -459,7 +477,7 @@ void iwl_trans_pcie_txq_agg_setup(struct iwl_priv *priv, int sta_id, int tid,
 	iwl_trans_set_wr_ptrs(priv, txq_id, ssn_idx);
 
 	/* Set up Tx window size and frame limit for this queue */
-	iwl_write_targ_mem(priv, priv->scd_base_addr +
+	iwl_write_targ_mem(priv, trans_pcie->scd_base_addr +
 			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
 			((frame_limit <<
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 06cec82..0e04b51 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -469,6 +469,9 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 static void iwl_trans_pcie_tx_free(struct iwl_priv *priv)
 {
 	int txq_id;
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/* Tx queues */
 	if (priv->txq) {
@@ -482,7 +485,7 @@ static void iwl_trans_pcie_tx_free(struct iwl_priv *priv)
 
 	iwlagn_free_dma_ptr(priv, &priv->kw);
 
-	iwlagn_free_dma_ptr(priv, &priv->scd_bc_tbls);
+	iwlagn_free_dma_ptr(priv, &trans_pcie->scd_bc_tbls);
 }
 
 /**
@@ -496,6 +499,9 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 {
 	int ret;
 	int txq_id, slots_num;
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	/*It is not allowed to alloc twice, so warn when this happens.
 	 * We cannot rely on the previous allocation, so free and fail */
@@ -504,7 +510,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 		goto error;
 	}
 
-	ret = iwlagn_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
+	ret = iwlagn_alloc_dma_ptr(priv, &trans_pcie->scd_bc_tbls,
 				hw_params(priv).scd_bc_tbls_size);
 	if (ret) {
 		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
@@ -785,30 +791,33 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 {
 	const struct queue_to_fifo_ac *queue_to_fifo;
 	struct iwl_rxon_context *ctx;
+	struct iwl_trans *trans = trans(priv);
+	struct iwl_trans_pcie *trans_pcie =
+		IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 a;
 	unsigned long flags;
 	int i, chan;
 	u32 reg_val;
 
-	spin_lock_irqsave(&priv->shrd->lock, flags);
+	spin_lock_irqsave(&trans->shrd->lock, flags);
 
-	priv->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
-	a = priv->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
+	trans_pcie->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
+	a = trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
 	/* reset conext data memory */
-	for (; a < priv->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
+	for (; a < trans_pcie->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 	/* reset tx status memory */
-	for (; a < priv->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
+	for (; a < trans_pcie->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
-	for (; a < priv->scd_base_addr +
+	for (; a < trans_pcie->scd_base_addr +
 	       SCD_TRANS_TBL_OFFSET_QUEUE(hw_params(priv).max_txq_num);
 	       a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 
 	iwl_write_prph(priv, SCD_DRAM_BASE_ADDR,
-		       priv->scd_bc_tbls.dma >> 10);
+		       trans_pcie->scd_bc_tbls.dma >> 10);
 
 	/* Enable DMA channel */
 	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
@@ -829,9 +838,9 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 	for (i = 0; i < hw_params(priv).max_txq_num; i++) {
 		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
-		iwl_write_targ_mem(priv, priv->scd_base_addr +
+		iwl_write_targ_mem(priv, trans_pcie->scd_base_addr +
 				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
-		iwl_write_targ_mem(priv, priv->scd_base_addr +
+		iwl_write_targ_mem(priv, trans_pcie->scd_base_addr +
 				SCD_CONTEXT_QUEUE_OFFSET(i) +
 				sizeof(u32),
 				((SCD_WIN_SIZE <<
@@ -843,7 +852,7 @@ static void iwl_trans_pcie_tx_start(struct iwl_priv *priv)
 	}
 
 	iwl_write_prph(priv, SCD_INTERRUPT_MASK,
-			IWL_MASK(0, hw_params(priv).max_txq_num));
+			IWL_MASK(0, hw_params(trans).max_txq_num));
 
 	/* Activate all Tx DMA/FIFO channels */
 	iwl_trans_txq_set_sched(priv, IWL_MASK(0, 7));
-- 
1.7.0.4

