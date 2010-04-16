Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:50641 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932594Ab0DPVwp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/21] iwlwifi: more code clean up for agn devices
Date: Fri, 16 Apr 2010 14:52:33 -0700
Message-Id: <1271454758-14351-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Since multiple new devices having similar uCode architecture and use same
registers address, remove more reference to 5000 series to eliminate the
confusion.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   42 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |   34 ++++++------
 drivers/net/wireless/iwlwifi/iwl-prph.h      |   80 +++++++++++++-------------
 3 files changed, 78 insertions(+), 78 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 3077eac..11661fa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -167,7 +167,7 @@ static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	scd_q2ratid = ra_tid & IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
 
 	tbl_dw_addr = priv->scd_base_addr +
-			IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
+			IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
 
 	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
 
@@ -186,9 +186,9 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
 	iwl_write_prph(priv,
-		IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << IWL50_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+		IWLAGN_SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << IWLAGN_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << IWLAGN_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
 void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
@@ -196,7 +196,7 @@ void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
 {
 	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(priv, IWLAGN_SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
@@ -206,11 +206,11 @@ void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
 	int txq_id = txq->q.id;
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
 
-	iwl_write_prph(priv, IWL50_SCD_QUEUE_STATUS_BITS(txq_id),
-			(active << IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			(tx_fifo_id << IWL50_SCD_QUEUE_STTS_REG_POS_TXF) |
-			(1 << IWL50_SCD_QUEUE_STTS_REG_POS_WSL) |
-			IWL50_SCD_QUEUE_STTS_REG_MSK);
+	iwl_write_prph(priv, IWLAGN_SCD_QUEUE_STATUS_BITS(txq_id),
+			(active << IWLAGN_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			(tx_fifo_id << IWLAGN_SCD_QUEUE_STTS_REG_POS_TXF) |
+			(1 << IWLAGN_SCD_QUEUE_STTS_REG_POS_WSL) |
+			IWLAGN_SCD_QUEUE_STTS_REG_MSK);
 
 	txq->sched_retry = scd_retry;
 
@@ -250,10 +250,10 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 	iwlagn_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(priv, IWL50_SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(priv, IWLAGN_SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
 	/* enable aggregations for the queue */
-	iwl_set_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1<<txq_id));
+	iwl_set_bits_prph(priv, IWLAGN_SCD_AGGR_SEL, (1<<txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -263,16 +263,16 @@ int iwlagn_txq_agg_enable(struct iwl_priv *priv, int txq_id,
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(priv, priv->scd_base_addr +
-			IWL50_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
+			IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
 			((SCD_WIN_SIZE <<
-			IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-			IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
 			((SCD_FRAME_LIMIT <<
-			IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-			IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
-	iwl_set_bits_prph(priv, IWL50_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(priv, IWLAGN_SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
@@ -298,14 +298,14 @@ int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
 
-	iwl_clear_bits_prph(priv, IWL50_SCD_AGGR_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(priv, IWLAGN_SCD_AGGR_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwlagn_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl_clear_bits_prph(priv, IWL50_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(priv, IWLAGN_SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl_txq_ctx_deactivate(priv, txq_id);
 	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
@@ -318,7 +318,7 @@ int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
  */
 void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask)
 {
-	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
+	iwl_write_prph(priv, IWLAGN_SCD_TXFACT, mask);
 }
 
 static inline int get_queue_from_ac(u16 ac)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 059b70e..ae476c2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -329,19 +329,19 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 
 	spin_lock_irqsave(&priv->lock, flags);
 
-	priv->scd_base_addr = iwl_read_prph(priv, IWL50_SCD_SRAM_BASE_ADDR);
-	a = priv->scd_base_addr + IWL50_SCD_CONTEXT_DATA_OFFSET;
-	for (; a < priv->scd_base_addr + IWL50_SCD_TX_STTS_BITMAP_OFFSET;
+	priv->scd_base_addr = iwl_read_prph(priv, IWLAGN_SCD_SRAM_BASE_ADDR);
+	a = priv->scd_base_addr + IWLAGN_SCD_CONTEXT_DATA_OFFSET;
+	for (; a < priv->scd_base_addr + IWLAGN_SCD_TX_STTS_BITMAP_OFFSET;
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
-	for (; a < priv->scd_base_addr + IWL50_SCD_TRANSLATE_TBL_OFFSET;
+	for (; a < priv->scd_base_addr + IWLAGN_SCD_TRANSLATE_TBL_OFFSET;
 		a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 	for (; a < priv->scd_base_addr +
-	       IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
+	       IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
 		iwl_write_targ_mem(priv, a, 0);
 
-	iwl_write_prph(priv, IWL50_SCD_DRAM_BASE_ADDR,
+	iwl_write_prph(priv, IWLAGN_SCD_DRAM_BASE_ADDR,
 		       priv->scd_bc_tbls.dma >> 10);
 
 	/* Enable DMA channel */
@@ -355,28 +355,28 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
 			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
 
-	iwl_write_prph(priv, IWL50_SCD_QUEUECHAIN_SEL,
-		IWL50_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
-	iwl_write_prph(priv, IWL50_SCD_AGGR_SEL, 0);
+	iwl_write_prph(priv, IWLAGN_SCD_QUEUECHAIN_SEL,
+		IWLAGN_SCD_QUEUECHAIN_SEL_ALL(priv->hw_params.max_txq_num));
+	iwl_write_prph(priv, IWLAGN_SCD_AGGR_SEL, 0);
 
 	/* initiate the queues */
 	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
-		iwl_write_prph(priv, IWL50_SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_prph(priv, IWLAGN_SCD_QUEUE_RDPTR(i), 0);
 		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
 		iwl_write_targ_mem(priv, priv->scd_base_addr +
-				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i), 0);
+				IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(i), 0);
 		iwl_write_targ_mem(priv, priv->scd_base_addr +
-				IWL50_SCD_CONTEXT_QUEUE_OFFSET(i) +
+				IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(i) +
 				sizeof(u32),
 				((SCD_WIN_SIZE <<
-				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-				IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+				IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+				IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
 				((SCD_FRAME_LIMIT <<
-				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+				IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 	}
 
-	iwl_write_prph(priv, IWL50_SCD_INTERRUPT_MASK,
+	iwl_write_prph(priv, IWLAGN_SCD_INTERRUPT_MASK,
 			IWL_MASK(0, priv->hw_params.max_txq_num));
 
 	/* Activate all Tx DMA/FIFO channels */
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 5944de7..b1f101c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -529,48 +529,48 @@
 #define IWL_SCD_TXFIFO_POS_RA			(4)
 #define IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK	(0x01FF)
 
-/* 5000 SCD */
-#define IWL50_SCD_QUEUE_STTS_REG_POS_TXF	(0)
-#define IWL50_SCD_QUEUE_STTS_REG_POS_ACTIVE	(3)
-#define IWL50_SCD_QUEUE_STTS_REG_POS_WSL	(4)
-#define IWL50_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN (19)
-#define IWL50_SCD_QUEUE_STTS_REG_MSK		(0x00FF0000)
-
-#define IWL50_SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
-#define IWL50_SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
-#define IWL50_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_POS	(24)
-#define IWL50_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_MSK	(0xFF000000)
-#define IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS		(0)
-#define IWL50_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK		(0x0000007F)
-#define IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
-#define IWL50_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
-
-#define IWL50_SCD_CONTEXT_DATA_OFFSET		(0x600)
-#define IWL50_SCD_TX_STTS_BITMAP_OFFSET		(0x7B1)
-#define IWL50_SCD_TRANSLATE_TBL_OFFSET		(0x7E0)
-
-#define IWL50_SCD_CONTEXT_QUEUE_OFFSET(x)\
-	(IWL50_SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
-
-#define IWL50_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
-	((IWL50_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffc)
-
-#define IWL50_SCD_QUEUECHAIN_SEL_ALL(x)		(((1<<(x)) - 1) &\
+/* agn SCD */
+#define IWLAGN_SCD_QUEUE_STTS_REG_POS_TXF	(0)
+#define IWLAGN_SCD_QUEUE_STTS_REG_POS_ACTIVE	(3)
+#define IWLAGN_SCD_QUEUE_STTS_REG_POS_WSL	(4)
+#define IWLAGN_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN (19)
+#define IWLAGN_SCD_QUEUE_STTS_REG_MSK		(0x00FF0000)
+
+#define IWLAGN_SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
+#define IWLAGN_SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
+#define IWLAGN_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_POS	(24)
+#define IWLAGN_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_MSK	(0xFF000000)
+#define IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS		(0)
+#define IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK		(0x0000007F)
+#define IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
+#define IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
+
+#define IWLAGN_SCD_CONTEXT_DATA_OFFSET		(0x600)
+#define IWLAGN_SCD_TX_STTS_BITMAP_OFFSET		(0x7B1)
+#define IWLAGN_SCD_TRANSLATE_TBL_OFFSET		(0x7E0)
+
+#define IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(x)\
+	(IWLAGN_SCD_CONTEXT_DATA_OFFSET + ((x) * 8))
+
+#define IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
+	((IWLAGN_SCD_TRANSLATE_TBL_OFFSET + ((x) * 2)) & 0xfffc)
+
+#define IWLAGN_SCD_QUEUECHAIN_SEL_ALL(x)		(((1<<(x)) - 1) &\
 	(~(1<<IWL_CMD_QUEUE_NUM)))
 
-#define IWL50_SCD_BASE			(PRPH_BASE + 0xa02c00)
-
-#define IWL50_SCD_SRAM_BASE_ADDR         (IWL50_SCD_BASE + 0x0)
-#define IWL50_SCD_DRAM_BASE_ADDR	 (IWL50_SCD_BASE + 0x8)
-#define IWL50_SCD_AIT                    (IWL50_SCD_BASE + 0x0c)
-#define IWL50_SCD_TXFACT                 (IWL50_SCD_BASE + 0x10)
-#define IWL50_SCD_ACTIVE		 (IWL50_SCD_BASE + 0x14)
-#define IWL50_SCD_QUEUE_WRPTR(x)         (IWL50_SCD_BASE + 0x18 + (x) * 4)
-#define IWL50_SCD_QUEUE_RDPTR(x)         (IWL50_SCD_BASE + 0x68 + (x) * 4)
-#define IWL50_SCD_QUEUECHAIN_SEL         (IWL50_SCD_BASE + 0xe8)
-#define IWL50_SCD_AGGR_SEL	     	 (IWL50_SCD_BASE + 0x248)
-#define IWL50_SCD_INTERRUPT_MASK         (IWL50_SCD_BASE + 0x108)
-#define IWL50_SCD_QUEUE_STATUS_BITS(x)   (IWL50_SCD_BASE + 0x10c + (x) * 4)
+#define IWLAGN_SCD_BASE			(PRPH_BASE + 0xa02c00)
+
+#define IWLAGN_SCD_SRAM_BASE_ADDR	(IWLAGN_SCD_BASE + 0x0)
+#define IWLAGN_SCD_DRAM_BASE_ADDR	(IWLAGN_SCD_BASE + 0x8)
+#define IWLAGN_SCD_AIT			(IWLAGN_SCD_BASE + 0x0c)
+#define IWLAGN_SCD_TXFACT		(IWLAGN_SCD_BASE + 0x10)
+#define IWLAGN_SCD_ACTIVE		(IWLAGN_SCD_BASE + 0x14)
+#define IWLAGN_SCD_QUEUE_WRPTR(x)	(IWLAGN_SCD_BASE + 0x18 + (x) * 4)
+#define IWLAGN_SCD_QUEUE_RDPTR(x)	(IWLAGN_SCD_BASE + 0x68 + (x) * 4)
+#define IWLAGN_SCD_QUEUECHAIN_SEL	(IWLAGN_SCD_BASE + 0xe8)
+#define IWLAGN_SCD_AGGR_SEL		(IWLAGN_SCD_BASE + 0x248)
+#define IWLAGN_SCD_INTERRUPT_MASK	(IWLAGN_SCD_BASE + 0x108)
+#define IWLAGN_SCD_QUEUE_STATUS_BITS(x)	(IWLAGN_SCD_BASE + 0x10c + (x) * 4)
 
 /*********************** END TX SCHEDULER *************************************/
 
-- 
1.6.3.3

