Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58597 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756790Ab0DIUJl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Apr 2010 16:09:41 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net, Zhu Yi <yi.zhu@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 12/12] iwlwifi: avoid Tx queue memory allocation in interface down
Date: Fri,  9 Apr 2010 13:09:29 -0700
Message-Id: <1270843769-30017-13-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
References: <1270843769-30017-1-git-send-email-reinette.chatre@intel.com>
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
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   11 +++++---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   39 ++++++++++++++++++++-------
 drivers/net/wireless/iwlwifi/iwl-agn.h     |    3 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   20 ++++++++++++++
 4 files changed, 58 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 384b45c..c465c85 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -512,10 +512,13 @@ int iwlagn_hw_nic_init(struct iwl_priv *priv)
 
 	spin_unlock_irqrestore(&priv->lock, flags);
 
-	/* Allocate and init all Tx and Command queues */
-	ret = iwlagn_txq_ctx_reset(priv);
-	if (ret)
-		return ret;
+	/* Allocate or reset and init all Tx and Command queues */
+	if (!priv->txq) {
+		ret = iwlagn_txq_ctx_alloc(priv);
+		if (ret)
+			return ret;
+	} else
+		iwlagn_txq_ctx_reset(priv);
 
 	set_bit(STATUS_INIT, &priv->status);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index a76e143..3077eac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -809,8 +809,7 @@ void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	if (priv->txq) {
-		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num;
-		     txq_id++)
+		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
 			if (txq_id == IWL_CMD_QUEUE_NUM)
 				iwl_cmd_queue_free(priv);
 			else
@@ -825,15 +824,15 @@ void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv)
 }
 
 /**
- * iwlagn_txq_ctx_reset - Reset TX queue context
- * Destroys all DMA structures and initialize them again
+ * iwlagn_txq_ctx_alloc - allocate TX queue context
+ * Allocate all Tx DMA structures and initialize them
  *
  * @param priv
  * @return error code
  */
-int iwlagn_txq_ctx_reset(struct iwl_priv *priv)
+int iwlagn_txq_ctx_alloc(struct iwl_priv *priv)
 {
-	int ret = 0;
+	int ret;
 	int txq_id, slots_num;
 	unsigned long flags;
 
@@ -891,8 +890,31 @@ int iwlagn_txq_ctx_reset(struct iwl_priv *priv)
 	return ret;
 }
 
+void iwlagn_txq_ctx_reset(struct iwl_priv *priv)
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
- * iwlagn_txq_ctx_stop - Stop all Tx DMA channels, free Tx queue memory
+ * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
  */
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 {
@@ -912,9 +934,6 @@ void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 				    1000);
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Deallocate memory for all Tx queues */
-	iwlagn_hw_txq_ctx_free(priv);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 608060a..5d31422 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -145,7 +145,8 @@ void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
 void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv);
-int iwlagn_txq_ctx_reset(struct iwl_priv *priv);
+int iwlagn_txq_ctx_alloc(struct iwl_priv *priv);
+void iwlagn_txq_ctx_reset(struct iwl_priv *priv);
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index aea6a2e..c3c6505 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -394,6 +394,26 @@ out_free_arrays:
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
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
 
 /**
-- 
1.6.3.3

