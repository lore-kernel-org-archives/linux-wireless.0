Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23684 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab1GPPcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Jul 2011 11:32:14 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.guy@intel.com>
Subject: [PATCH 18/18] iwlagn: add tx start API to transport layer
Date: Sat, 16 Jul 2011 07:56:39 -0700
Message-Id: <1310828199-18000-20-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110716_173224_948488_DFF11B7B)
In-Reply-To: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310828199-18000-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

tx start will start the tx queues: basically configure the SCD
Remove the IWLAGN prefix to SCD defines on the way.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   51 ++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |  136 +-----------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    4 +-
 drivers/net/wireless/iwlwifi/iwl-prph.h      |   82 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-trans.c     |  153 +++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-trans.h     |    5 +
 7 files changed, 222 insertions(+), 210 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 554750d..ece3202 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -166,10 +166,10 @@ static int iwlagn_tx_queue_set_q2ratid(struct iwl_priv *priv, u16 ra_tid,
 	u32 tbl_dw;
 	u16 scd_q2ratid;
 
-	scd_q2ratid = ra_tid & IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK;
+	scd_q2ratid = ra_tid & SCD_QUEUE_RA_TID_MAP_RATID_MSK;
 
 	tbl_dw_addr = priv->scd_base_addr +
-			IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(txq_id);
+			SCD_TRANS_TBL_OFFSET_QUEUE(txq_id);
 
 	tbl_dw = iwl_read_targ_mem(priv, tbl_dw_addr);
 
@@ -188,9 +188,9 @@ static void iwlagn_tx_queue_stop_scheduler(struct iwl_priv *priv, u16 txq_id)
 	/* Simply stop the queue, but don't change any configuration;
 	 * the SCD_ACT_EN bit is the write-enable mask for the ACTIVE bit. */
 	iwl_write_prph(priv,
-		IWLAGN_SCD_QUEUE_STATUS_BITS(txq_id),
-		(0 << IWLAGN_SCD_QUEUE_STTS_REG_POS_ACTIVE)|
-		(1 << IWLAGN_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
+		SCD_QUEUE_STATUS_BITS(txq_id),
+		(0 << SCD_QUEUE_STTS_REG_POS_ACTIVE)|
+		(1 << SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN));
 }
 
 void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
@@ -198,7 +198,7 @@ void iwlagn_set_wr_ptrs(struct iwl_priv *priv,
 {
 	iwl_write_direct32(priv, HBUS_TARG_WRPTR,
 			(index & 0xff) | (txq_id << 8));
-	iwl_write_prph(priv, IWLAGN_SCD_QUEUE_RDPTR(txq_id), index);
+	iwl_write_prph(priv, SCD_QUEUE_RDPTR(txq_id), index);
 }
 
 void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
@@ -208,11 +208,11 @@ void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
 	int txq_id = txq->q.id;
 	int active = test_bit(txq_id, &priv->txq_ctx_active_msk) ? 1 : 0;
 
-	iwl_write_prph(priv, IWLAGN_SCD_QUEUE_STATUS_BITS(txq_id),
-			(active << IWLAGN_SCD_QUEUE_STTS_REG_POS_ACTIVE) |
-			(tx_fifo_id << IWLAGN_SCD_QUEUE_STTS_REG_POS_TXF) |
-			(1 << IWLAGN_SCD_QUEUE_STTS_REG_POS_WSL) |
-			IWLAGN_SCD_QUEUE_STTS_REG_MSK);
+	iwl_write_prph(priv, SCD_QUEUE_STATUS_BITS(txq_id),
+			(active << SCD_QUEUE_STTS_REG_POS_ACTIVE) |
+			(tx_fifo_id << SCD_QUEUE_STTS_REG_POS_TXF) |
+			(1 << SCD_QUEUE_STTS_REG_POS_WSL) |
+			SCD_QUEUE_STTS_REG_MSK);
 
 	txq->sched_retry = scd_retry;
 
@@ -271,10 +271,10 @@ void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
 	iwlagn_tx_queue_set_q2ratid(priv, ra_tid, txq_id);
 
 	/* Set this queue as a chain-building queue */
-	iwl_set_bits_prph(priv, IWLAGN_SCD_QUEUECHAIN_SEL, (1<<txq_id));
+	iwl_set_bits_prph(priv, SCD_QUEUECHAIN_SEL, (1<<txq_id));
 
 	/* enable aggregations for the queue */
-	iwl_set_bits_prph(priv, IWLAGN_SCD_AGGR_SEL, (1<<txq_id));
+	iwl_set_bits_prph(priv, SCD_AGGR_SEL, (1<<txq_id));
 
 	/* Place first TFD at index corresponding to start sequence number.
 	 * Assumes that ssn_idx is valid (!= 0xFFF) */
@@ -284,16 +284,16 @@ void iwlagn_txq_agg_queue_setup(struct iwl_priv *priv,
 
 	/* Set up Tx window size and frame limit for this queue */
 	iwl_write_targ_mem(priv, priv->scd_base_addr +
-			IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
+			SCD_CONTEXT_QUEUE_OFFSET(txq_id) +
 			sizeof(u32),
 			((frame_limit <<
-			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-			IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+			SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+			SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
 			((frame_limit <<
-			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-			IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+			SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
 
-	iwl_set_bits_prph(priv, IWLAGN_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_set_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
 
 	/* Set up Status area in SRAM, map to Tx DMA/FIFO, activate the queue */
 	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 1);
@@ -317,29 +317,20 @@ static int iwlagn_txq_agg_disable(struct iwl_priv *priv, u16 txq_id,
 
 	iwlagn_tx_queue_stop_scheduler(priv, txq_id);
 
-	iwl_clear_bits_prph(priv, IWLAGN_SCD_AGGR_SEL, (1 << txq_id));
+	iwl_clear_bits_prph(priv, SCD_AGGR_SEL, (1 << txq_id));
 
 	priv->txq[txq_id].q.read_ptr = (ssn_idx & 0xff);
 	priv->txq[txq_id].q.write_ptr = (ssn_idx & 0xff);
 	/* supposes that ssn_idx is valid (!= 0xFFF) */
 	iwlagn_set_wr_ptrs(priv, txq_id, ssn_idx);
 
-	iwl_clear_bits_prph(priv, IWLAGN_SCD_INTERRUPT_MASK, (1 << txq_id));
+	iwl_clear_bits_prph(priv, SCD_INTERRUPT_MASK, (1 << txq_id));
 	iwl_txq_ctx_deactivate(priv, txq_id);
 	iwlagn_tx_queue_set_status(priv, &priv->txq[txq_id], tx_fifo, 0);
 
 	return 0;
 }
 
-/*
- * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
- * must be called under priv->lock and mac access
- */
-void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask)
-{
-	iwl_write_prph(priv, IWLAGN_SCD_TXFACT, mask);
-}
-
 static void iwlagn_tx_cmd_protection(struct iwl_priv *priv,
 				     struct ieee80211_tx_info *info,
 				     __le16 fc, __le32 *tx_flags)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index c15a1f7..aebd5c7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -41,38 +41,6 @@
 #include "iwl-agn-calib.h"
 #include "iwl-trans.h"
 
-#define IWL_AC_UNSET -1
-
-struct queue_to_fifo_ac {
-	s8 fifo, ac;
-};
-
-static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
-};
-
-static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
-	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
-	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
-	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
-	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
-	{ IWL_TX_FIFO_BE_IPAN, 2, },
-	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
-};
-
 static struct iwl_wimax_coex_event_entry cu_priorities[COEX_NUM_OF_EVENTS] = {
 	{COEX_CU_UNASSOC_IDLE_RP, COEX_CU_UNASSOC_IDLE_WP,
 	 0, COEX_UNASSOC_IDLE_FLAGS},
@@ -379,111 +347,9 @@ int iwlagn_send_bt_env(struct iwl_priv *priv, u8 action, u8 type)
 
 static int iwlagn_alive_notify(struct iwl_priv *priv)
 {
-	const struct queue_to_fifo_ac *queue_to_fifo;
-	struct iwl_rxon_context *ctx;
-	u32 a;
-	unsigned long flags;
-	int i, chan;
-	u32 reg_val;
 	int ret;
 
-	spin_lock_irqsave(&priv->lock, flags);
-
-	priv->scd_base_addr = iwl_read_prph(priv, IWLAGN_SCD_SRAM_BASE_ADDR);
-	a = priv->scd_base_addr + IWLAGN_SCD_CONTEXT_MEM_LOWER_BOUND;
-	/* reset conext data memory */
-	for (; a < priv->scd_base_addr + IWLAGN_SCD_CONTEXT_MEM_UPPER_BOUND;
-		a += 4)
-		iwl_write_targ_mem(priv, a, 0);
-	/* reset tx status memory */
-	for (; a < priv->scd_base_addr + IWLAGN_SCD_TX_STTS_MEM_UPPER_BOUND;
-		a += 4)
-		iwl_write_targ_mem(priv, a, 0);
-	for (; a < priv->scd_base_addr +
-	       IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
-		iwl_write_targ_mem(priv, a, 0);
-
-	iwl_write_prph(priv, IWLAGN_SCD_DRAM_BASE_ADDR,
-		       priv->scd_bc_tbls.dma >> 10);
-
-	/* Enable DMA channel */
-	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
-		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
-
-	/* Update FH chicken bits */
-	reg_val = iwl_read_direct32(priv, FH_TX_CHICKEN_BITS_REG);
-	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
-			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
-
-	iwl_write_prph(priv, IWLAGN_SCD_QUEUECHAIN_SEL,
-		IWLAGN_SCD_QUEUECHAIN_SEL_ALL(priv));
-	iwl_write_prph(priv, IWLAGN_SCD_AGGR_SEL, 0);
-
-	/* initiate the queues */
-	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
-		iwl_write_prph(priv, IWLAGN_SCD_QUEUE_RDPTR(i), 0);
-		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
-		iwl_write_targ_mem(priv, priv->scd_base_addr +
-				IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(i), 0);
-		iwl_write_targ_mem(priv, priv->scd_base_addr +
-				IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(i) +
-				sizeof(u32),
-				((SCD_WIN_SIZE <<
-				IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
-				IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
-				((SCD_FRAME_LIMIT <<
-				IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
-				IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
-	}
-
-	iwl_write_prph(priv, IWLAGN_SCD_INTERRUPT_MASK,
-			IWL_MASK(0, priv->hw_params.max_txq_num));
-
-	/* Activate all Tx DMA/FIFO channels */
-	iwlagn_txq_set_sched(priv, IWL_MASK(0, 7));
-
-	/* map queues to FIFOs */
-	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
-		queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
-	else
-		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
-
-	iwlagn_set_wr_ptrs(priv, priv->cmd_queue, 0);
-
-	/* make sure all queue are not stopped */
-	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
-	for (i = 0; i < 4; i++)
-		atomic_set(&priv->queue_stop_count[i], 0);
-	for_each_context(priv, ctx)
-		ctx->last_tx_rejected = false;
-
-	/* reset to 0 to enable all the queue first */
-	priv->txq_ctx_active_msk = 0;
-
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) != 10);
-	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) != 10);
-
-	for (i = 0; i < 10; i++) {
-		int fifo = queue_to_fifo[i].fifo;
-		int ac = queue_to_fifo[i].ac;
-
-		iwl_txq_ctx_activate(priv, i);
-
-		if (fifo == IWL_TX_FIFO_UNUSED)
-			continue;
-
-		if (ac != IWL_AC_UNSET)
-			iwl_set_swq_id(&priv->txq[i], ac, i);
-		iwlagn_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
-	}
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Enable L1-Active */
-	iwl_clear_bits_prph(priv, APMG_PCIDEV_STT_REG,
-			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+	trans_tx_start(priv);
 
 	ret = iwlagn_send_wimax_coex(priv);
 	if (ret)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index c851fc2..0e8ccb9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -136,7 +136,6 @@ void iwlagn_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
 void iwlagn_tx_queue_set_status(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq,
 			     int tx_fifo_id, int scd_retry);
-void iwlagn_txq_set_sched(struct iwl_priv *priv, u32 mask);
 void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 			    int sta_id, int tid, int freed);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cf6f4b2..fddc236 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1234,10 +1234,11 @@ struct iwl_trans;
 
 /**
  * struct iwl_trans_ops - transport specific operations
-
  * @rx_init: inits the rx memory, allocate it if needed
  * @rx_free: frees the rx memory
  * @tx_init:inits the tx memory, allocate if needed
+ * @tx_start: starts and configures all the Tx fifo - usually done once the fw
+ *           is alive.
  * @tx_free: frees the tx memory
  * @stop_device:stops the whole device (embedded CPU put to reset)
  * @send_cmd:send a host command
@@ -1256,6 +1257,7 @@ struct iwl_trans_ops {
 	void (*rx_free)(struct iwl_priv *priv);
 
 	int (*tx_init)(struct iwl_priv *priv);
+	void (*tx_start)(struct iwl_priv *priv);
 	void (*tx_free)(struct iwl_priv *priv);
 
 	void (*stop_device)(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index 1cc0ed1..2f267b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -178,61 +178,61 @@
 #define SCD_WIN_SIZE				64
 #define SCD_FRAME_LIMIT				64
 
-#define IWL_SCD_TXFIFO_POS_TID			(0)
-#define IWL_SCD_TXFIFO_POS_RA			(4)
-#define IWL_SCD_QUEUE_RA_TID_MAP_RATID_MSK	(0x01FF)
+#define SCD_TXFIFO_POS_TID			(0)
+#define SCD_TXFIFO_POS_RA			(4)
+#define SCD_QUEUE_RA_TID_MAP_RATID_MSK	(0x01FF)
 
 /* agn SCD */
-#define IWLAGN_SCD_QUEUE_STTS_REG_POS_TXF	(0)
-#define IWLAGN_SCD_QUEUE_STTS_REG_POS_ACTIVE	(3)
-#define IWLAGN_SCD_QUEUE_STTS_REG_POS_WSL	(4)
-#define IWLAGN_SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN (19)
-#define IWLAGN_SCD_QUEUE_STTS_REG_MSK		(0x00FF0000)
-
-#define IWLAGN_SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
-#define IWLAGN_SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
-#define IWLAGN_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_POS	(24)
-#define IWLAGN_SCD_QUEUE_CTX_REG1_SUPER_CREDIT_MSK	(0xFF000000)
-#define IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_POS		(0)
-#define IWLAGN_SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK		(0x0000007F)
-#define IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
-#define IWLAGN_SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
+#define SCD_QUEUE_STTS_REG_POS_TXF	(0)
+#define SCD_QUEUE_STTS_REG_POS_ACTIVE	(3)
+#define SCD_QUEUE_STTS_REG_POS_WSL	(4)
+#define SCD_QUEUE_STTS_REG_POS_SCD_ACT_EN (19)
+#define SCD_QUEUE_STTS_REG_MSK		(0x00FF0000)
+
+#define SCD_QUEUE_CTX_REG1_CREDIT_POS		(8)
+#define SCD_QUEUE_CTX_REG1_CREDIT_MSK		(0x00FFFF00)
+#define SCD_QUEUE_CTX_REG1_SUPER_CREDIT_POS	(24)
+#define SCD_QUEUE_CTX_REG1_SUPER_CREDIT_MSK	(0xFF000000)
+#define SCD_QUEUE_CTX_REG2_WIN_SIZE_POS		(0)
+#define SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK		(0x0000007F)
+#define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS	(16)
+#define SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK	(0x007F0000)
 
 /* Context Data */
-#define IWLAGN_SCD_CONTEXT_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x600)
-#define IWLAGN_SCD_CONTEXT_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x6A0)
+#define SCD_CONTEXT_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x600)
+#define SCD_CONTEXT_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x6A0)
 
 /* Tx status */
-#define IWLAGN_SCD_TX_STTS_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x6A0)
-#define IWLAGN_SCD_TX_STTS_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x7E0)
+#define SCD_TX_STTS_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x6A0)
+#define SCD_TX_STTS_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x7E0)
 
 /* Translation Data */
-#define IWLAGN_SCD_TRANS_TBL_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x7E0)
-#define IWLAGN_SCD_TRANS_TBL_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x808)
+#define SCD_TRANS_TBL_MEM_LOWER_BOUND	(SCD_MEM_LOWER_BOUND + 0x7E0)
+#define SCD_TRANS_TBL_MEM_UPPER_BOUND	(SCD_MEM_LOWER_BOUND + 0x808)
 
-#define IWLAGN_SCD_CONTEXT_QUEUE_OFFSET(x)\
-	(IWLAGN_SCD_CONTEXT_MEM_LOWER_BOUND + ((x) * 8))
+#define SCD_CONTEXT_QUEUE_OFFSET(x)\
+	(SCD_CONTEXT_MEM_LOWER_BOUND + ((x) * 8))
 
-#define IWLAGN_SCD_TRANSLATE_TBL_OFFSET_QUEUE(x) \
-	((IWLAGN_SCD_TRANS_TBL_MEM_LOWER_BOUND + ((x) * 2)) & 0xfffc)
+#define SCD_TRANS_TBL_OFFSET_QUEUE(x) \
+	((SCD_TRANS_TBL_MEM_LOWER_BOUND + ((x) * 2)) & 0xfffc)
 
-#define IWLAGN_SCD_QUEUECHAIN_SEL_ALL(priv)	\
+#define SCD_QUEUECHAIN_SEL_ALL(priv)	\
 	(((1<<(priv)->hw_params.max_txq_num) - 1) &\
 	(~(1<<(priv)->cmd_queue)))
 
-#define IWLAGN_SCD_BASE			(PRPH_BASE + 0xa02c00)
-
-#define IWLAGN_SCD_SRAM_BASE_ADDR	(IWLAGN_SCD_BASE + 0x0)
-#define IWLAGN_SCD_DRAM_BASE_ADDR	(IWLAGN_SCD_BASE + 0x8)
-#define IWLAGN_SCD_AIT			(IWLAGN_SCD_BASE + 0x0c)
-#define IWLAGN_SCD_TXFACT		(IWLAGN_SCD_BASE + 0x10)
-#define IWLAGN_SCD_ACTIVE		(IWLAGN_SCD_BASE + 0x14)
-#define IWLAGN_SCD_QUEUE_WRPTR(x)	(IWLAGN_SCD_BASE + 0x18 + (x) * 4)
-#define IWLAGN_SCD_QUEUE_RDPTR(x)	(IWLAGN_SCD_BASE + 0x68 + (x) * 4)
-#define IWLAGN_SCD_QUEUECHAIN_SEL	(IWLAGN_SCD_BASE + 0xe8)
-#define IWLAGN_SCD_AGGR_SEL		(IWLAGN_SCD_BASE + 0x248)
-#define IWLAGN_SCD_INTERRUPT_MASK	(IWLAGN_SCD_BASE + 0x108)
-#define IWLAGN_SCD_QUEUE_STATUS_BITS(x)	(IWLAGN_SCD_BASE + 0x10c + (x) * 4)
+#define SCD_BASE			(PRPH_BASE + 0xa02c00)
+
+#define SCD_SRAM_BASE_ADDR	(SCD_BASE + 0x0)
+#define SCD_DRAM_BASE_ADDR	(SCD_BASE + 0x8)
+#define SCD_AIT			(SCD_BASE + 0x0c)
+#define SCD_TXFACT		(SCD_BASE + 0x10)
+#define SCD_ACTIVE		(SCD_BASE + 0x14)
+#define SCD_QUEUE_WRPTR(x)	(SCD_BASE + 0x18 + (x) * 4)
+#define SCD_QUEUE_RDPTR(x)	(SCD_BASE + 0x68 + (x) * 4)
+#define SCD_QUEUECHAIN_SEL	(SCD_BASE + 0xe8)
+#define SCD_AGGR_SEL		(SCD_BASE + 0x248)
+#define SCD_INTERRUPT_MASK	(SCD_BASE + 0x108)
+#define SCD_QUEUE_STATUS_BITS(x)	(SCD_BASE + 0x10c + (x) * 4)
 
 /*********************** END TX SCHEDULER *************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 8d45554..7c748f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -547,7 +547,7 @@ static int iwl_trans_tx_init(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
-	iwl_write_prph(priv, IWLAGN_SCD_TXFACT, 0);
+	iwl_write_prph(priv, SCD_TXFACT, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
 	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
@@ -574,6 +574,154 @@ error:
 	return ret;
 }
 
+/*
+ * Activate/Deactivate Tx DMA/FIFO channels according tx fifos mask
+ * must be called under priv->lock and mac access
+ */
+static void iwl_trans_txq_set_sched(struct iwl_priv *priv, u32 mask)
+{
+	iwl_write_prph(priv, SCD_TXFACT, mask);
+}
+
+#define IWL_AC_UNSET -1
+
+struct queue_to_fifo_ac {
+	s8 fifo, ac;
+};
+
+static const struct queue_to_fifo_ac iwlagn_default_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+	{ IWL_TX_FIFO_UNUSED, IWL_AC_UNSET, },
+};
+
+static const struct queue_to_fifo_ac iwlagn_ipan_queue_to_tx_fifo[] = {
+	{ IWL_TX_FIFO_VO, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_VI, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_BE, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_BK, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BK_IPAN, IEEE80211_AC_BK, },
+	{ IWL_TX_FIFO_BE_IPAN, IEEE80211_AC_BE, },
+	{ IWL_TX_FIFO_VI_IPAN, IEEE80211_AC_VI, },
+	{ IWL_TX_FIFO_VO_IPAN, IEEE80211_AC_VO, },
+	{ IWL_TX_FIFO_BE_IPAN, 2, },
+	{ IWLAGN_CMD_FIFO_NUM, IWL_AC_UNSET, },
+};
+static void iwl_trans_tx_start(struct iwl_priv *priv)
+{
+	const struct queue_to_fifo_ac *queue_to_fifo;
+	struct iwl_rxon_context *ctx;
+	u32 a;
+	unsigned long flags;
+	int i, chan;
+	u32 reg_val;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	priv->scd_base_addr = iwl_read_prph(priv, SCD_SRAM_BASE_ADDR);
+	a = priv->scd_base_addr + SCD_CONTEXT_MEM_LOWER_BOUND;
+	/* reset conext data memory */
+	for (; a < priv->scd_base_addr + SCD_CONTEXT_MEM_UPPER_BOUND;
+		a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+	/* reset tx status memory */
+	for (; a < priv->scd_base_addr + SCD_TX_STTS_MEM_UPPER_BOUND;
+		a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+	for (; a < priv->scd_base_addr +
+	       SCD_TRANS_TBL_OFFSET_QUEUE(priv->hw_params.max_txq_num); a += 4)
+		iwl_write_targ_mem(priv, a, 0);
+
+	iwl_write_prph(priv, SCD_DRAM_BASE_ADDR,
+		       priv->scd_bc_tbls.dma >> 10);
+
+	/* Enable DMA channel */
+	for (chan = 0; chan < FH_TCSR_CHNL_NUM ; chan++)
+		iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(chan),
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+				FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE);
+
+	/* Update FH chicken bits */
+	reg_val = iwl_read_direct32(priv, FH_TX_CHICKEN_BITS_REG);
+	iwl_write_direct32(priv, FH_TX_CHICKEN_BITS_REG,
+			   reg_val | FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN);
+
+	iwl_write_prph(priv, SCD_QUEUECHAIN_SEL,
+		SCD_QUEUECHAIN_SEL_ALL(priv));
+	iwl_write_prph(priv, SCD_AGGR_SEL, 0);
+
+	/* initiate the queues */
+	for (i = 0; i < priv->hw_params.max_txq_num; i++) {
+		iwl_write_prph(priv, SCD_QUEUE_RDPTR(i), 0);
+		iwl_write_direct32(priv, HBUS_TARG_WRPTR, 0 | (i << 8));
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
+				SCD_CONTEXT_QUEUE_OFFSET(i), 0);
+		iwl_write_targ_mem(priv, priv->scd_base_addr +
+				SCD_CONTEXT_QUEUE_OFFSET(i) +
+				sizeof(u32),
+				((SCD_WIN_SIZE <<
+				SCD_QUEUE_CTX_REG2_WIN_SIZE_POS) &
+				SCD_QUEUE_CTX_REG2_WIN_SIZE_MSK) |
+				((SCD_FRAME_LIMIT <<
+				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_POS) &
+				SCD_QUEUE_CTX_REG2_FRAME_LIMIT_MSK));
+	}
+
+	iwl_write_prph(priv, SCD_INTERRUPT_MASK,
+			IWL_MASK(0, priv->hw_params.max_txq_num));
+
+	/* Activate all Tx DMA/FIFO channels */
+	iwl_trans_txq_set_sched(priv, IWL_MASK(0, 7));
+
+	/* map queues to FIFOs */
+	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
+		queue_to_fifo = iwlagn_ipan_queue_to_tx_fifo;
+	else
+		queue_to_fifo = iwlagn_default_queue_to_tx_fifo;
+
+	iwlagn_set_wr_ptrs(priv, priv->cmd_queue, 0);
+
+	/* make sure all queue are not stopped */
+	memset(&priv->queue_stopped[0], 0, sizeof(priv->queue_stopped));
+	for (i = 0; i < 4; i++)
+		atomic_set(&priv->queue_stop_count[i], 0);
+	for_each_context(priv, ctx)
+		ctx->last_tx_rejected = false;
+
+	/* reset to 0 to enable all the queue first */
+	priv->txq_ctx_active_msk = 0;
+
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_default_queue_to_tx_fifo) != 10);
+	BUILD_BUG_ON(ARRAY_SIZE(iwlagn_ipan_queue_to_tx_fifo) != 10);
+
+	for (i = 0; i < 10; i++) {
+		int fifo = queue_to_fifo[i].fifo;
+		int ac = queue_to_fifo[i].ac;
+
+		iwl_txq_ctx_activate(priv, i);
+
+		if (fifo == IWL_TX_FIFO_UNUSED)
+			continue;
+
+		if (ac != IWL_AC_UNSET)
+			iwl_set_swq_id(&priv->txq[i], ac, i);
+		iwlagn_tx_queue_set_status(priv, &priv->txq[i], fifo, 0);
+	}
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Enable L1-Active */
+	iwl_clear_bits_prph(priv, APMG_PCIDEV_STT_REG,
+			  APMG_PCIDEV_STT_VAL_L1_ACT_DIS);
+}
+
 /**
  * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
  */
@@ -585,7 +733,7 @@ static int iwl_trans_tx_stop(struct iwl_priv *priv)
 	/* Turn off all Tx DMA fifos */
 	spin_lock_irqsave(&priv->lock, flags);
 
-	iwlagn_txq_set_sched(priv, 0);
+	iwl_trans_txq_set_sched(priv, 0);
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < FH_TCSR_CHNL_NUM; ch++) {
@@ -822,6 +970,7 @@ static const struct iwl_trans_ops trans_ops = {
 	.rx_free = iwl_trans_rx_free,
 
 	.tx_init = iwl_trans_tx_init,
+	.tx_start = iwl_trans_tx_start,
 	.tx_free = iwl_trans_tx_free,
 
 	.stop_device = iwl_trans_stop_device,
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 55e6c33..16cdb89 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -79,6 +79,11 @@ static inline int trans_tx_init(struct iwl_priv *priv)
 	return priv->trans.ops->tx_init(priv);
 }
 
+static inline void trans_tx_start(struct iwl_priv *priv)
+{
+	priv->trans.ops->tx_start(priv);
+}
+
 static inline void trans_tx_free(struct iwl_priv *priv)
 {
 	priv->trans.ops->tx_free(priv);
-- 
1.7.0.4

