Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:51895 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754334Ab0DBUjO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:39:14 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 3/3] iwlwifi: avoid Tx queue memory allocation in interface down
Date: Fri,  2 Apr 2010 13:39:08 -0700
Message-Id: <1270240748-12865-4-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240748-12865-1-git-send-email-reinette.chatre@intel.com>
References: <1270240748-12865-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhu Yi <yi.zhu@intel.com>

We used to free all the Tx queues memory when interface is brought
down and reallocate them again in interface up. This requires
order-4 allocation for txq->cmd[]. In situations like s2ram, this
usually leads to allocation failure in the memory subsystem. The
patch fixed this problem by allocating the Tx queues memory only at
the first time. Later iwl_down/iwl_up only initialize but don't
free and reallocate them. The memory is freed at the device removal
time. BTW, we have already done this for the Rx queue.

This fixed bug https://bugzilla.kernel.org/show_bug.cgi?id=15551

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-core.c |   11 ++++--
 drivers/net/wireless/iwlwifi/iwl-core.h |    5 ++-
 drivers/net/wireless/iwlwifi/iwl-tx.c   |   59 +++++++++++++++++++++++++-----
 3 files changed, 60 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 112149e..894bcb8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -307,10 +307,13 @@ int iwl_hw_nic_init(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Allocate and init all Tx and Command queues */
-	ret = iwl_txq_ctx_reset(priv);
-	if (ret)
-		return ret;
+	/* Allocate or reset and init all Tx and Command queues */
+	if (!priv->txq) {
+		ret = iwl_txq_ctx_alloc(priv);
+		if (ret)
+			return ret;
+	} else
+		iwl_txq_ctx_reset(priv);
 
 	set_bit(STATUS_INIT, &priv->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 4ef7739..732590f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -442,7 +442,8 @@ void iwl_rx_csa(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
 /*****************************************************
 * TX
 ******************************************************/
-int iwl_txq_ctx_reset(struct iwl_priv *priv);
+int iwl_txq_ctx_alloc(struct iwl_priv *priv);
+void iwl_txq_ctx_reset(struct iwl_priv *priv);
 void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq,
@@ -456,6 +457,8 @@ void iwl_free_tfds_in_queue(struct iwl_priv *priv,
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id);
+void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+			int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
 int iwl_tx_agg_start(struct iwl_priv *priv, const u8 *ra, u16 tid, u16 *ssn);
 int iwl_tx_agg_stop(struct iwl_priv *priv , const u8 *ra, u16 tid);
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 6aa3090..343d81a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -433,6 +433,26 @@ out_free_arrays:
 }
 EXPORT_SYMBOL(iwl_tx_queue_init);
 
+void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+			int slots_num, u32 txq_id)
+{
+	int actual_slots = slots_num;
+
+	if (txq_id == IWL_CMD_QUEUE_NUM)
+		actual_slots++;
+
+	memset(txq->meta, 0, sizeof(struct iwl_cmd_meta) * actual_slots);
+
+	txq->need_update = 0;
+
+	/* Initialize queue's high/low-water marks, and head/tail indexes */
+	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+
+	/* Tell device where to find queue */
+	priv->cfg->ops->lib->txq_init(priv, txq);
+}
+EXPORT_SYMBOL(iwl_tx_queue_reset);
+
 /**
  * iwl_hw_txq_ctx_free - Free TXQ Context
  *
@@ -444,8 +464,7 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	if (priv->txq) {
-		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
-		     txq_id++)
+		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
 			if (txq_id == IWL_CMD_QUEUE_NUM)
 				iwl_cmd_queue_free(priv);
 			else
@@ -461,15 +480,15 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
 
 /**
- * iwl_txq_ctx_reset - Reset TX queue context
- * Destroys all DMA structures and initialize them again
+ * iwl_txq_ctx_alloc - allocate TX queue context
+ * Allocate all Tx DMA structures and initialize them
  *
  * @param priv
  * @return error code
  */
-int iwl_txq_ctx_reset(struct iwl_priv *priv)
+int iwl_txq_ctx_alloc(struct iwl_priv *priv)
 {
-	int ret = 0;
+	int ret;
 	int txq_id, slots_num;
 	unsigned long flags;
 
@@ -527,8 +546,31 @@ int iwl_txq_ctx_reset(struct iwl_priv *priv)
 	return ret;
 }
 
+void iwl_txq_ctx_reset(struct iwl_priv *priv)
+{
+	int txq_id, slots_num;
+	unsigned long flags;
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	/* Turn off all Tx DMA fifos */
+	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+
+	/* Tell NIC where to find the "keep warm" buffer */
+	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Alloc and init all Tx queues, including the command queue (#4) */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+		slots_num = txq_id == IWL_CMD_QUEUE_NUM ?
+			    TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		iwl_tx_queue_reset(priv, &priv->txq[txq_id], slots_num, txq_id);
+	}
+}
+
 /**
- * iwl_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
+ * iwl_txq_ctx_stop - Stop all Tx DMA channels
  */
 void iwl_txq_ctx_stop(struct iwl_priv *priv)
 {
@@ -548,9 +590,6 @@ void iwl_txq_ctx_stop(struct iwl_priv *priv)
 				    1000);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Deallocate memory for all Tx queues */
-	iwl_hw_txq_ctx_free(priv);
 }
 EXPORT_SYMBOL(iwl_txq_ctx_stop);
 
-- 
1.6.3.3

