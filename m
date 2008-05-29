Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:52708 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbYE2Ihb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 04:37:31 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 15/43] iwlwifi: move txq_ctx_stop into iwl-tx.c
Date: Thu, 29 May 2008 16:35:00 +0800
Message-Id: <1212050128-17132-16-git-send-email-yi.zhu@intel.com> (sfid-20080529_110546_034856_C650027B)
In-Reply-To: <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
References: <1212050128-17132-1-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-2-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-3-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-4-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-5-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-6-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-7-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-8-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-9-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-10-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-11-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-12-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-13-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-14-git-send-email-yi.zhu@intel.com>
 <1212050128-17132-15-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch moves txq_ctx_stop into iwl-tx.c iwlcore module.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   59 +++---------------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   32 +++-------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h  |    2 +
 drivers/net/wireless/iwlwifi/iwl-prph.h     |    5 --
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   88 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    2 +-
 8 files changed, 88 insertions(+), 104 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index c586490..fe73191 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -468,25 +468,13 @@ int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 	return ret;
 }
 
-static int iwl4965_disable_tx_fifo(struct iwl_priv *priv)
+/*
+ * Activate/Deactivat Tx DMA/FIFO channels according tx fifos mask
+ * must be called under priv->lock and mac access
+ */
+static void iwl4965_txq_set_sched(struct iwl_priv *priv, u32 mask)
 {
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	ret = iwl_grab_nic_access(priv);
-	if (unlikely(ret)) {
-		IWL_ERROR("Tx fifo reset failed");
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
-	iwl_write_prph(priv, IWL49_SCD_TXFACT, 0);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
+	iwl_write_prph(priv, IWL49_SCD_TXFACT, mask);
 }
 
 static int iwl4965_apm_init(struct iwl_priv *priv)
@@ -579,36 +567,6 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-/**
- * iwl4965_hw_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
- */
-void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
-{
-
-	int txq_id;
-	unsigned long flags;
-
-	/* Stop each Tx DMA channel, and wait for it to be idle */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		spin_lock_irqsave(&priv->lock, flags);
-		if (iwl_grab_nic_access(priv)) {
-			spin_unlock_irqrestore(&priv->lock, flags);
-			continue;
-		}
-
-		iwl_write_direct32(priv,
-				   FH_TCSR_CHNL_TX_CONFIG_REG(txq_id), 0x0);
-		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
-				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE
-				    (txq_id), 200);
-		iwl_release_nic_access(priv);
-		spin_unlock_irqrestore(&priv->lock, flags);
-	}
-
-	/* Deallocate memory for all Tx queues */
-	iwl_hw_txq_ctx_free(priv);
-}
-
 static int iwl4965_apm_stop_master(struct iwl_priv *priv)
 {
 	int ret = 0;
@@ -995,8 +953,7 @@ int iwl4965_alive_notify(struct iwl_priv *priv)
 				 (1 << priv->hw_params.max_txq_num) - 1);
 
 	/* Activate all Tx DMA/FIFO channels */
-	iwl_write_prph(priv, IWL49_SCD_TXFACT,
-				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
+	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
 
 	iwl4965_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 
@@ -3622,7 +3579,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.free_shared_mem = iwl4965_free_shared_mem,
 	.shared_mem_rx_idx = iwl4965_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
-	.disable_tx_fifo = iwl4965_disable_tx_fifo,
+	.txq_set_sched = iwl4965_txq_set_sched,
 	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
 	.alive_notify = iwl4965_alive_notify,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d607452..a94cd36 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -662,10 +662,10 @@ static int iwl5000_alive_notify(struct iwl_priv *priv)
 	}
 
 	iwl_write_prph(priv, IWL50_SCD_INTERRUPT_MASK,
-				 (1 << priv->hw_params.max_txq_num) - 1);
+			IWL_MASK(0, priv->hw_params.max_txq_num));
 
-	iwl_write_prph(priv, IWL50_SCD_TXFACT,
-				 SCD_TXFACT_REG_TXFIFO_MASK(0, 7));
+	/* Activate all Tx DMA/FIFO channels */
+	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
 
 	iwl5000_set_wr_ptrs(priv, IWL_CMD_QUEUE_NUM, 0);
 	/* map qos queues to fifos one-to-one */
@@ -839,25 +839,13 @@ static u16 iwl5000_build_addsta_hcmd(const struct iwl_addsta_cmd *cmd, u8 *data)
 }
 
 
-static int iwl5000_disable_tx_fifo(struct iwl_priv *priv)
+/*
+ * Activate/Deactivat Tx DMA/FIFO channels according tx fifos mask
+ * must be called under priv->lock and mac access
+ */
+static void iwl5000_txq_set_sched(struct iwl_priv *priv, u32 mask)
 {
-	unsigned long flags;
-	int ret;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	ret = iwl_grab_nic_access(priv);
-	if (unlikely(ret)) {
-		IWL_ERROR("Tx fifo reset failed");
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
-	iwl_write_prph(priv, IWL50_SCD_TXFACT, 0);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
+	iwl_write_prph(priv, IWL50_SCD_TXFACT, mask);
 }
 
 /* Currently 5000 is the supperset of everything */
@@ -894,7 +882,7 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.free_shared_mem = iwl5000_free_shared_mem,
 	.shared_mem_rx_idx = iwl5000_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
-	.disable_tx_fifo = iwl5000_disable_tx_fifo,
+	.txq_set_sched = iwl5000_txq_set_sched,
 	.rx_handler_setup = iwl5000_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl5000_hw_valid_rtc_data_addr,
 	.load_ucode = iwl5000_load_ucode,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index d6e6985..d67b53c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -110,7 +110,7 @@ struct iwl_lib_ops {
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* nic Tx fifo handling */
-	int (*disable_tx_fifo)(struct iwl_priv *priv);
+	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
 	/* alive notification after init uCode load */
 	void (*init_alive_start)(struct iwl_priv *priv);
 	/* alive notification */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 44bd827..3cefaaf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -686,7 +686,7 @@ extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
 extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
-extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
+extern void iwl_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl_frame *frame, u8 rate);
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index e4c3f84..dedefa0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -136,6 +136,8 @@ static inline void iwl_set_bits16(__le16 *dst, u8 pos, u8 len, int val)
 
 #define KELVIN_TO_CELSIUS(x) ((x)-273)
 #define CELSIUS_TO_KELVIN(x) ((x)+273)
+#define IWL_MASK(lo, hi) ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
+
 
 #define IEEE80211_CHAN_W_RADAR_DETECT 0x00000010
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index d6a04f6..15cb7ff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -358,11 +358,6 @@
  *  7- 0:  Enable (1), disable (0), one bit for each channel 0-7
  */
 #define IWL49_SCD_TXFACT                   (IWL49_SCD_START_OFFSET + 0x1c)
-
-/* Mask to enable contiguous Tx DMA/FIFO channels between "lo" and "hi". */
-#define SCD_TXFACT_REG_TXFIFO_MASK(lo, hi) \
-       ((1 << (hi)) | ((1 << (hi)) - (1 << (lo))))
-
 /*
  * Queue (x) Write Pointers (indexes, really!), one for each Tx queue.
  * Initialized and updated by driver as new TFDs are added to queue.
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 0ebab96..0b822b5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -263,24 +263,6 @@ EXPORT_SYMBOL(iwl_queue_space);
 
 
 /**
- * iwl_hw_txq_ctx_free - Free TXQ Context
- *
- * Destroy all TX DMA queues and structures
- */
-void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
-{
-	int txq_id;
-
-	/* Tx queues */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		iwl_tx_queue_free(priv, &priv->txq[txq_id]);
-
-	/* Keep-warm buffer */
-	iwl_kw_free(priv);
-}
-EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
-
-/**
  * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
  */
 static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
@@ -437,6 +419,24 @@ static int iwl_tx_queue_init(struct iwl_priv *priv,
 
 	return 0;
 }
+/**
+ * iwl_hw_txq_ctx_free - Free TXQ Context
+ *
+ * Destroy all TX DMA queues and structures
+ */
+void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
+{
+	int txq_id;
+
+	/* Tx queues */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		iwl_tx_queue_free(priv, &priv->txq[txq_id]);
+
+	/* Keep-warm buffer */
+	iwl_kw_free(priv);
+}
+EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
+
 
 /**
  * iwl_txq_ctx_reset - Reset TX queue context
@@ -449,6 +449,7 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 {
 	int ret = 0;
 	int txq_id, slots_num;
+	unsigned long flags;
 
 	iwl_kw_free(priv);
 
@@ -461,11 +462,19 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 		IWL_ERROR("Keep Warm allocation failed");
 		goto error_kw;
 	}
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (unlikely(ret)) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		goto error_reset;
+	}
 
 	/* Turn off all Tx DMA fifos */
-	ret = priv->cfg->ops->lib->disable_tx_fifo(priv);
-	if (unlikely(ret))
-		goto error_reset;
+	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
 
 	/* Tell nic where to find the keep-warm buffer */
 	ret = iwl_kw_init(priv);
@@ -474,8 +483,7 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 		goto error_reset;
 	}
 
-	/* Alloc and init all (default 16) Tx queues,
-	 * including the command queue (#4) */
+	/* Alloc and init all Tx queues, including the command queue (#4) */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
@@ -496,6 +504,40 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
  error_kw:
 	return ret;
 }
+/**
+ * iwl_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
+ */
+void iwl_txq_ctx_stop(struct iwl_priv *priv)
+{
+
+	int txq_id;
+	unsigned long flags;
+
+
+	/* Turn off all Tx DMA fifos */
+	spin_lock_irqsave(&priv->lock, flags);
+	if (iwl_grab_nic_access(priv)) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return;
+	}
+
+	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+
+	/* Stop each Tx DMA channel, and wait for it to be idle */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+		iwl_write_direct32(priv,
+				   FH_TCSR_CHNL_TX_CONFIG_REG(txq_id), 0x0);
+		iwl_poll_direct_bit(priv, FH_TSSR_TX_STATUS_REG,
+				    FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE
+				    (txq_id), 200);
+	}
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Deallocate memory for all Tx queues */
+	iwl_hw_txq_ctx_free(priv);
+}
+EXPORT_SYMBOL(iwl_txq_ctx_stop);
 
 /*
  * handle build REPLY_TX command notification.
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index af0ffd3..2652f5f 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -3404,7 +3404,7 @@ static void __iwl4965_down(struct iwl_priv *priv)
 			 CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	iwl4965_hw_txq_ctx_stop(priv);
+	iwl_txq_ctx_stop(priv);
 	iwl4965_hw_rxq_stop(priv);
 
 	spin_lock_irqsave(&priv->lock, flags);
-- 
1.5.3.6

