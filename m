Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:62949 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab1GAPxE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Jul 2011 11:53:04 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/11] iwlagn: move the tx allocation funcs to the transport layer
Date: Fri,  1 Jul 2011 08:20:01 -0700
Message-Id: <1309533605-25774-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110701_175330_581466_3C12831D)
In-Reply-To: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309533605-25774-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These functions allocate all the Tx context. Only the simple tx_init is exported as API.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |    9 +-
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   90 -----------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    2 -
 drivers/net/wireless/iwlwifi/iwl-core.c    |   14 --
 drivers/net/wireless/iwlwifi/iwl-core.h    |    7 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans.c   |  228 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-tx.c      |  139 +-----------------
 8 files changed, 236 insertions(+), 257 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index a2c5c6b..ea83aa5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -699,7 +699,6 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
 	struct iwl_rx_queue *rxq = &priv->rxq;
-	int ret;
 
 	/* nic_init */
 	spin_lock_irqsave(&priv->lock, flags);
@@ -729,12 +728,8 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Allocate or reset and init all Tx and Command queues */
-	if (!priv->txq) {
-		ret = iwlagn_txq_ctx_alloc(priv);
-		if (ret)
-			return ret;
-	} else
-		iwlagn_txq_ctx_reset(priv);
+	if (priv->trans.ops->tx_init(priv))
+		return -ENOMEM;
 
 	if (priv->cfg->base_params->shadow_reg_enable) {
 		/* enable shadow regs in HW */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index d0ac090..c05a8d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -878,96 +878,6 @@ void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv)
 }
 
 /**
- * iwlagn_txq_ctx_alloc - allocate TX queue context
- * Allocate all Tx DMA structures and initialize them
- *
- * @param priv
- * @return error code
- */
-int iwlagn_txq_ctx_alloc(struct iwl_priv *priv)
-{
-	int ret;
-	int txq_id, slots_num;
-	unsigned long flags;
-
-	/* Free all tx/cmd queues and keep-warm buffer */
-	iwlagn_hw_txq_ctx_free(priv);
-
-	ret = iwlagn_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
-				priv->hw_params.scd_bc_tbls_size);
-	if (ret) {
-		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
-		goto error_bc_tbls;
-	}
-	/* Alloc keep-warm buffer */
-	ret = iwlagn_alloc_dma_ptr(priv, &priv->kw, IWL_KW_SIZE);
-	if (ret) {
-		IWL_ERR(priv, "Keep Warm allocation failed\n");
-		goto error_kw;
-	}
-
-	/* allocate tx queue structure */
-	ret = iwl_alloc_txq_mem(priv);
-	if (ret)
-		goto error;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Turn off all Tx DMA fifos */
-	iwlagn_txq_set_sched(priv, 0);
-
-	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		slots_num = (txq_id == priv->cmd_queue) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		ret = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
-				       txq_id);
-		if (ret) {
-			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
-			goto error;
-		}
-	}
-
-	return ret;
-
- error:
-	iwlagn_hw_txq_ctx_free(priv);
-	iwlagn_free_dma_ptr(priv, &priv->kw);
- error_kw:
-	iwlagn_free_dma_ptr(priv, &priv->scd_bc_tbls);
- error_bc_tbls:
-	return ret;
-}
-
-void iwlagn_txq_ctx_reset(struct iwl_priv *priv)
-{
-	int txq_id, slots_num;
-	unsigned long flags;
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	/* Turn off all Tx DMA fifos */
-	iwlagn_txq_set_sched(priv, 0);
-
-	/* Tell NIC where to find the "keep warm" buffer */
-	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Alloc and init all Tx queues, including the command queue (#4) */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		slots_num = txq_id == priv->cmd_queue ?
-			    TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		iwl_tx_queue_reset(priv, &priv->txq[txq_id], slots_num, txq_id);
-	}
-}
-
-/**
  * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
  */
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 877a694..5d0c911 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -218,8 +218,6 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv);
-int iwlagn_txq_ctx_alloc(struct iwl_priv *priv);
-void iwlagn_txq_ctx_reset(struct iwl_priv *priv);
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c5fa232..b63a7d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1372,20 +1372,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 }
 
-int iwl_alloc_txq_mem(struct iwl_priv *priv)
-{
-	if (!priv->txq)
-		priv->txq = kzalloc(
-			sizeof(struct iwl_tx_queue) *
-				priv->cfg->base_params->num_of_queues,
-			GFP_KERNEL);
-	if (!priv->txq) {
-		IWL_ERR(priv, "Not enough memory for txq\n");
-		return -ENOMEM;
-	}
-	return 0;
-}
-
 void iwl_free_txq_mem(struct iwl_priv *priv)
 {
 	kfree(priv->txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 13d819b..91e7279 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -337,7 +337,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 int iwl_mac_change_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     enum nl80211_iftype newtype, bool newp2p);
-int iwl_alloc_txq_mem(struct iwl_priv *priv);
 void iwl_free_txq_mem(struct iwl_priv *priv);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -396,11 +395,9 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 * TX
 ******************************************************/
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-		      int slots_num, u32 txq_id);
-void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-			int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
+int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
+			  int count, int slots_num, u32 id);
 void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id);
 void iwl_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 04b19a4..4d17619 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1233,11 +1233,13 @@ struct iwl_trans;
  * struct iwl_trans_ops - transport specific operations
 
  * @rx_init: inits the rx memory, allocate it if needed
- *@rx_free: frees the rx memory
+ * @rx_free: frees the rx memory
+ * @tx_init:inits the tx memory, allocate if needed
  */
 struct iwl_trans_ops {
 	int (*rx_init)(struct iwl_priv *priv);
 	void (*rx_free)(struct iwl_priv *priv);
+	int (*tx_init)(struct iwl_priv *priv);
 };
 
 struct iwl_trans {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 1f5834b..7b7b97d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -62,6 +62,10 @@
  *****************************************************************************/
 #include "iwl-dev.h"
 #include "iwl-trans.h"
+#include "iwl-core.h"
+#include "iwl-helpers.h"
+/*TODO remove uneeded includes when the transport layer tx_free will be here */
+#include "iwl-agn.h"
 
 static int iwl_trans_rx_alloc(struct iwl_priv *priv)
 {
@@ -184,9 +188,233 @@ static void iwl_trans_rx_free(struct iwl_priv *priv)
 	rxq->rb_stts = NULL;
 }
 
+/* TODO:remove this code duplication */
+static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
+				    struct iwl_dma_ptr *ptr, size_t size)
+{
+	if (WARN_ON(ptr->addr))
+		return -EINVAL;
+
+	ptr->addr = dma_alloc_coherent(priv->bus.dev, size,
+				       &ptr->dma, GFP_KERNEL);
+	if (!ptr->addr)
+		return -ENOMEM;
+	ptr->size = size;
+	return 0;
+}
+
+static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+		      int slots_num, u32 txq_id)
+{
+	size_t tfd_sz = priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX;
+	int i;
+
+	if (WARN_ON(txq->meta || txq->cmd || txq->txb || txq->tfds))
+		return -EINVAL;
+
+	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num,
+			    GFP_KERNEL);
+	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num,
+			   GFP_KERNEL);
+
+	if (!txq->meta || !txq->cmd)
+		goto error;
+
+	for (i = 0; i < slots_num; i++) {
+		txq->cmd[i] = kmalloc(sizeof(struct iwl_device_cmd),
+					GFP_KERNEL);
+		if (!txq->cmd[i])
+			goto error;
+	}
+
+	/* Alloc driver data array and TFD circular buffer */
+	/* Driver private data, only for Tx (not command) queues,
+	 * not shared with device. */
+	if (txq_id != priv->cmd_queue) {
+		txq->txb = kzalloc(sizeof(txq->txb[0]) *
+				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
+		if (!txq->txb) {
+			IWL_ERR(priv, "kmalloc for auxiliary BD "
+				  "structures failed\n");
+			goto error;
+		}
+	} else {
+		txq->txb = NULL;
+	}
+
+	/* Circular buffer of transmit frame descriptors (TFDs),
+	 * shared with device */
+	txq->tfds = dma_alloc_coherent(priv->bus.dev, tfd_sz, &txq->q.dma_addr,
+				       GFP_KERNEL);
+	if (!txq->tfds) {
+		IWL_ERR(priv, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
+		goto error;
+	}
+	txq->q.id = txq_id;
+
+	return 0;
+error:
+	kfree(txq->txb);
+	txq->txb = NULL;
+	/* since txq->cmd has been zeroed,
+	 * all non allocated cmd[i] will be NULL */
+	if (txq->cmd)
+		for (i = 0; i < slots_num; i++)
+			kfree(txq->cmd[i]);
+	kfree(txq->meta);
+	kfree(txq->cmd);
+	txq->meta = NULL;
+	txq->cmd = NULL;
+
+	return -ENOMEM;
+
+}
+
+static int iwl_trans_txq_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+		      int slots_num, u32 txq_id)
+{
+	int ret;
+
+	txq->need_update = 0;
+	memset(txq->meta, 0, sizeof(txq->meta[0]) * slots_num);
+
+	/*
+	 * For the default queues 0-3, set up the swq_id
+	 * already -- all others need to get one later
+	 * (if they need one at all).
+	 */
+	if (txq_id < 4)
+		iwl_set_swq_id(txq, txq_id, txq_id);
+
+	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
+	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
+	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+
+	/* Initialize queue's high/low-water marks, and head/tail indexes */
+	ret = iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num,
+			txq_id);
+	if (ret)
+		return ret;
+
+	/*
+	 * Tell nic where to find circular buffer of Tx Frame Descriptors for
+	 * given Tx queue, and enable the DMA channel used for that queue.
+	 * Circular buffer (TFD queue in DRAM) physical base address */
+	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
+			     txq->q.dma_addr >> 8);
+
+	return 0;
+}
+
+/**
+ * iwl_trans_tx_alloc - allocate TX context
+ * Allocate all Tx DMA structures and initialize them
+ *
+ * @param priv
+ * @return error code
+ */
+static int iwl_trans_tx_alloc(struct iwl_priv *priv)
+{
+	int ret;
+	int txq_id, slots_num;
+
+	/*It is not allowed to alloc twice, so warn when this happens.
+	 * We cannot rely on the previous allocation, so free and fail */
+	if (WARN_ON(priv->txq)) {
+		ret = -EINVAL;
+		goto error;
+	}
+
+	ret = iwlagn_alloc_dma_ptr(priv, &priv->scd_bc_tbls,
+				priv->hw_params.scd_bc_tbls_size);
+	if (ret) {
+		IWL_ERR(priv, "Scheduler BC Table allocation failed\n");
+		goto error;
+	}
+
+	/* Alloc keep-warm buffer */
+	ret = iwlagn_alloc_dma_ptr(priv, &priv->kw, IWL_KW_SIZE);
+	if (ret) {
+		IWL_ERR(priv, "Keep Warm allocation failed\n");
+		goto error;
+	}
+
+	priv->txq = kzalloc(sizeof(struct iwl_tx_queue) *
+			priv->cfg->base_params->num_of_queues, GFP_KERNEL);
+	if (!priv->txq) {
+		IWL_ERR(priv, "Not enough memory for txq\n");
+		ret = ENOMEM;
+		goto error;
+	}
+
+	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+		slots_num = (txq_id == priv->cmd_queue) ?
+					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		ret = iwl_trans_txq_alloc(priv, &priv->txq[txq_id], slots_num,
+				       txq_id);
+		if (ret) {
+			IWL_ERR(priv, "Tx %d queue alloc failed\n", txq_id);
+			goto error;
+		}
+	}
+
+	return 0;
+
+error:
+	iwlagn_hw_txq_ctx_free(priv);
+
+	return ret;
+}
+static int iwl_trans_tx_init(struct iwl_priv *priv)
+{
+	int ret;
+	int txq_id, slots_num;
+	unsigned long flags;
+	bool alloc = false;
+
+	if (!priv->txq) {
+		ret = iwl_trans_tx_alloc(priv);
+		if (ret)
+			goto error;
+		alloc = true;
+	}
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Turn off all Tx DMA fifos */
+	iwl_write_prph(priv, IWLAGN_SCD_TXFACT, 0);
+
+	/* Tell NIC where to find the "keep warm" buffer */
+	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Alloc and init all Tx queues, including the command queue (#4/#9) */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+		slots_num = (txq_id == priv->cmd_queue) ?
+					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		ret = iwl_trans_txq_init(priv, &priv->txq[txq_id], slots_num,
+				       txq_id);
+		if (ret) {
+			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
+			goto error;
+		}
+	}
+
+	return 0;
+error:
+	/*Upon error, free only if we allocated something */
+	if (alloc)
+		iwlagn_hw_txq_ctx_free(priv);
+	return ret;
+}
+
 static const struct iwl_trans_ops trans_ops = {
 	.rx_init = iwl_trans_rx_init,
 	.rx_free = iwl_trans_rx_free,
+
+	.tx_init = iwl_trans_tx_init,
 };
 
 void iwl_trans_register(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index e72d227..db5abaa 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -220,24 +220,6 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 	return 0;
 }
 
-/*
- * Tell nic where to find circular buffer of Tx Frame Descriptors for
- * given Tx queue, and enable the DMA channel used for that queue.
- *
- * supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
- * channels supported in hardware.
- */
-static int iwlagn_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
-{
-	int txq_id = txq->q.id;
-
-	/* Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
-			     txq->q.dma_addr >> 8);
-
-	return 0;
-}
-
 /**
  * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
  */
@@ -392,11 +374,10 @@ int iwl_queue_space(const struct iwl_queue *q)
 	return s;
 }
 
-
 /**
  * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
  */
-static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
+int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id)
 {
 	q->n_bd = count;
@@ -426,124 +407,6 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 	return 0;
 }
 
-/**
- * iwl_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
- */
-static int iwl_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl_tx_queue *txq, u32 id)
-{
-	struct device *dev = priv->bus.dev;
-	size_t tfd_sz = priv->hw_params.tfd_size * TFD_QUEUE_SIZE_MAX;
-
-	/* Driver private data, only for Tx (not command) queues,
-	 * not shared with device. */
-	if (id != priv->cmd_queue) {
-		txq->txb = kzalloc(sizeof(txq->txb[0]) *
-				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
-		if (!txq->txb) {
-			IWL_ERR(priv, "kmalloc for auxiliary BD "
-				  "structures failed\n");
-			goto error;
-		}
-	} else {
-		txq->txb = NULL;
-	}
-
-	/* Circular buffer of transmit frame descriptors (TFDs),
-	 * shared with device */
-	txq->tfds = dma_alloc_coherent(dev, tfd_sz, &txq->q.dma_addr,
-				       GFP_KERNEL);
-	if (!txq->tfds) {
-		IWL_ERR(priv, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
-		goto error;
-	}
-	txq->q.id = id;
-
-	return 0;
-
- error:
-	kfree(txq->txb);
-	txq->txb = NULL;
-
-	return -ENOMEM;
-}
-
-/**
- * iwl_tx_queue_init - Allocate and initialize one tx/cmd queue
- */
-int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-		      int slots_num, u32 txq_id)
-{
-	int i, len;
-	int ret;
-
-	txq->meta = kzalloc(sizeof(struct iwl_cmd_meta) * slots_num,
-			    GFP_KERNEL);
-	txq->cmd = kzalloc(sizeof(struct iwl_device_cmd *) * slots_num,
-			   GFP_KERNEL);
-
-	if (!txq->meta || !txq->cmd)
-		goto out_free_arrays;
-
-	len = sizeof(struct iwl_device_cmd);
-	for (i = 0; i < slots_num; i++) {
-		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
-		if (!txq->cmd[i])
-			goto err;
-	}
-
-	/* Alloc driver data array and TFD circular buffer */
-	ret = iwl_tx_queue_alloc(priv, txq, txq_id);
-	if (ret)
-		goto err;
-
-	txq->need_update = 0;
-
-	/*
-	 * For the default queues 0-3, set up the swq_id
-	 * already -- all others need to get one later
-	 * (if they need one at all).
-	 */
-	if (txq_id < 4)
-		iwl_set_swq_id(txq, txq_id, txq_id);
-
-	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
-
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	ret = iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
-	if (ret)
-		return ret;
-
-	/* Tell device where to find queue */
-	iwlagn_tx_queue_init(priv, txq);
-
-	return 0;
-err:
-	for (i = 0; i < slots_num; i++)
-		kfree(txq->cmd[i]);
-out_free_arrays:
-	kfree(txq->meta);
-	kfree(txq->cmd);
-
-	return -ENOMEM;
-}
-
-void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
-			int slots_num, u32 txq_id)
-{
-	memset(txq->meta, 0, sizeof(struct iwl_cmd_meta) * slots_num);
-
-	txq->need_update = 0;
-
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
-
-	/* Tell device where to find queue */
-	iwlagn_tx_queue_init(priv, txq);
-}
-
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
 /**
-- 
1.7.0.4

