Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50973 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752732Ab1GHQUh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2011 12:20:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/21] iwlagn: add an API to free the TX context
Date: Fri,  8 Jul 2011 08:46:10 -0700
Message-Id: <1310139989-27661-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110708_182114_691218_945A7C97)
In-Reply-To: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1310139989-27661-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Tx free functions move to the transport layer. Unify the functions that deal with tx queues and cmd queue.

Since the CMD queue is not fully allocated, but uses the q->n_bd / q->window trick, the release flow of TX queue and CMD queue was different.
iwlagn_txq_free_tfd receives now the index of the TFD to be freed, which allows to unify the release flow for all the queues.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   32 +--------
 drivers/net/wireless/iwlwifi/iwl-agn.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c   |    6 --
 drivers/net/wireless/iwlwifi/iwl-core.h   |    5 --
 drivers/net/wireless/iwlwifi/iwl-dev.h    |    3 +
 drivers/net/wireless/iwlwifi/iwl-trans.c  |   83 +++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-tx.c     |  108 ++---------------------------
 8 files changed, 95 insertions(+), 148 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index c05a8d9..b476c95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -853,31 +853,6 @@ static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
 }
 
 /**
- * iwlagn_hw_txq_ctx_free - Free TXQ Context
- *
- * Destroy all TX DMA queues and structures
- */
-void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv)
-{
-	int txq_id;
-
-	/* Tx queues */
-	if (priv->txq) {
-		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-			if (txq_id == priv->cmd_queue)
-				iwl_cmd_queue_free(priv);
-			else
-				iwl_tx_queue_free(priv, txq_id);
-	}
-	iwlagn_free_dma_ptr(priv, &priv->kw);
-
-	iwlagn_free_dma_ptr(priv, &priv->scd_bc_tbls);
-
-	/* free tx queue structure */
-	iwl_free_txq_mem(priv);
-}
-
-/**
  * iwlagn_txq_ctx_stop - Stop all Tx DMA channels
  */
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
@@ -907,10 +882,7 @@ void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 
 	/* Unmap DMA from host system and free skb's */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		if (txq_id == priv->cmd_queue)
-			iwl_cmd_queue_unmap(priv);
-		else
-			iwl_tx_queue_unmap(priv, txq_id);
+		iwl_tx_queue_unmap(priv, txq_id);
 }
 
 /*
@@ -1171,7 +1143,7 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 
 		iwlagn_txq_inval_byte_cnt_tbl(priv, txq);
 
-		iwlagn_txq_free_tfd(priv, txq);
+		iwlagn_txq_free_tfd(priv, txq, txq->q.read_ptr);
 	}
 	return nfreed;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7e6c463..4d5b7cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3710,7 +3710,7 @@ void __devexit iwl_remove(struct iwl_priv * priv)
 	iwl_dealloc_ucode(priv);
 
 	priv->trans.ops->rx_free(priv);
-	iwlagn_hw_txq_ctx_free(priv);
+	priv->trans.ops->tx_free(priv);
 
 	iwl_eeprom_free(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 4351151..fabab0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -198,7 +198,8 @@ int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
 
 /* tx */
-void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+				int index);
 int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len, u8 reset);
@@ -217,7 +218,6 @@ int iwlagn_txq_check_empty(struct iwl_priv *priv,
 void iwlagn_rx_reply_compressed_ba(struct iwl_priv *priv,
 				struct iwl_rx_mem_buffer *rxb);
 int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index);
-void iwlagn_hw_txq_ctx_free(struct iwl_priv *priv);
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv);
 
 static inline u32 iwl_tx_status_to_mac80211(u32 status)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index f91e306..9bf4686 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -1370,12 +1370,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 
 }
 
-void iwl_free_txq_mem(struct iwl_priv *priv)
-{
-	kfree(priv->txq);
-	priv->txq = NULL;
-}
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 
 #define IWL_TRAFFIC_DUMP_SIZE	(IWL_TRAFFIC_ENTRY_SIZE * IWL_TRAFFIC_ENTRIES)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6c21de9..7d8be6b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -328,8 +328,6 @@ void iwl_mac_remove_interface(struct ieee80211_hw *hw,
 int iwl_mac_change_interface(struct ieee80211_hw *hw,
 			     struct ieee80211_vif *vif,
 			     enum nl80211_iftype newtype, bool newp2p);
-void iwl_free_txq_mem(struct iwl_priv *priv);
-
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 int iwl_alloc_traffic_mem(struct iwl_priv *priv);
 void iwl_free_traffic_mem(struct iwl_priv *priv);
@@ -371,8 +369,6 @@ static inline void iwl_update_stats(struct iwl_priv *priv, bool is_tx,
 /*****************************************************
 * RX
 ******************************************************/
-void iwl_cmd_queue_free(struct iwl_priv *priv);
-void iwl_cmd_queue_unmap(struct iwl_priv *priv);
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
@@ -386,7 +382,6 @@ void iwl_chswitch_done(struct iwl_priv *priv, bool is_success);
 * TX
 ******************************************************/
 void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
 int iwl_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
 			  int count, int slots_num, u32 id);
 void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e429e32..a29fdd4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1233,11 +1233,14 @@ struct iwl_trans;
  * @rx_init: inits the rx memory, allocate it if needed
  * @rx_free: frees the rx memory
  * @tx_init:inits the tx memory, allocate if needed
+ * @tx_free: frees the tx memory
  */
 struct iwl_trans_ops {
 	int (*rx_init)(struct iwl_priv *priv);
 	void (*rx_free)(struct iwl_priv *priv);
+
 	int (*tx_init)(struct iwl_priv *priv);
+	void (*tx_free)(struct iwl_priv *priv);
 };
 
 struct iwl_trans {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index 7b7b97d..38b43e4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -203,6 +203,16 @@ static inline int iwlagn_alloc_dma_ptr(struct iwl_priv *priv,
 	return 0;
 }
 
+static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
+				    struct iwl_dma_ptr *ptr)
+{
+	if (unlikely(!ptr->addr))
+		return;
+
+	dma_free_coherent(priv->bus.dev, ptr->size, ptr->addr, ptr->dma);
+	memset(ptr, 0, sizeof(*ptr));
+}
+
 static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		      int slots_num, u32 txq_id)
 {
@@ -212,6 +222,8 @@ static int iwl_trans_txq_alloc(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	if (WARN_ON(txq->meta || txq->cmd || txq->txb || txq->tfds))
 		return -EINVAL;
 
+	txq->q.n_window = slots_num;
+
 	txq->meta = kzalloc(sizeof(txq->meta[0]) * slots_num,
 			    GFP_KERNEL);
 	txq->cmd = kzalloc(sizeof(txq->cmd[0]) * slots_num,
@@ -307,6 +319,72 @@ static int iwl_trans_txq_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 }
 
 /**
+ * iwl_tx_queue_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct device *dev = priv->bus.dev;
+	int i;
+	if (WARN_ON(!txq))
+		return;
+
+	iwl_tx_queue_unmap(priv, txq_id);
+
+	/* De-alloc array of command/tx buffers */
+	for (i = 0; i < txq->q.n_window; i++)
+		kfree(txq->cmd[i]);
+
+	/* De-alloc circular buffer of TFDs */
+	if (txq->q.n_bd) {
+		dma_free_coherent(dev, priv->hw_params.tfd_size *
+				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
+		memset(&txq->q.dma_addr, 0, sizeof(txq->q.dma_addr));
+	}
+
+	/* De-alloc array of per-TFD driver data */
+	kfree(txq->txb);
+	txq->txb = NULL;
+
+	/* deallocate arrays */
+	kfree(txq->cmd);
+	kfree(txq->meta);
+	txq->cmd = NULL;
+	txq->meta = NULL;
+
+	/* 0-fill queue descriptor structure */
+	memset(txq, 0, sizeof(*txq));
+}
+
+/**
+ * iwl_trans_tx_free - Free TXQ Context
+ *
+ * Destroy all TX DMA queues and structures
+ */
+static void iwl_trans_tx_free(struct iwl_priv *priv)
+{
+	int txq_id;
+
+	/* Tx queues */
+	if (priv->txq) {
+		for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+			iwl_tx_queue_free(priv, txq_id);
+	}
+
+	kfree(priv->txq);
+	priv->txq = NULL;
+
+	iwlagn_free_dma_ptr(priv, &priv->kw);
+
+	iwlagn_free_dma_ptr(priv, &priv->scd_bc_tbls);
+}
+
+/**
  * iwl_trans_tx_alloc - allocate TX context
  * Allocate all Tx DMA structures and initialize them
  *
@@ -362,7 +440,7 @@ static int iwl_trans_tx_alloc(struct iwl_priv *priv)
 	return 0;
 
 error:
-	iwlagn_hw_txq_ctx_free(priv);
+	priv->trans.ops->tx_free(priv);
 
 	return ret;
 }
@@ -406,7 +484,7 @@ static int iwl_trans_tx_init(struct iwl_priv *priv)
 error:
 	/*Upon error, free only if we allocated something */
 	if (alloc)
-		iwlagn_hw_txq_ctx_free(priv);
+		priv->trans.ops->tx_free(priv);
 	return ret;
 }
 
@@ -415,6 +493,7 @@ static const struct iwl_trans_ops trans_ops = {
 	.rx_free = iwl_trans_rx_free,
 
 	.tx_init = iwl_trans_tx_init,
+	.tx_free = iwl_trans_tx_free,
 };
 
 void iwl_trans_register(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index dc8f63f..36b643a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -157,14 +157,15 @@ static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
  * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
  * @priv - driver private data
  * @txq - tx queue
+ * @index - the index of the TFD to be freed
  *
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq,
+	int index)
 {
 	struct iwl_tfd *tfd_tmp = txq->tfds;
-	int index = txq->q.read_ptr;
 
 	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index],
 			 DMA_TO_DEVICE);
@@ -173,12 +174,12 @@ void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	if (txq->txb) {
 		struct sk_buff *skb;
 
-		skb = txq->txb[txq->q.read_ptr].skb;
+		skb = txq->txb[index].skb;
 
 		/* can be called from irqs-disabled context */
 		if (skb) {
 			dev_kfree_skb_any(skb);
-			txq->txb[txq->q.read_ptr].skb = NULL;
+			txq->txb[index].skb = NULL;
 		}
 	}
 }
@@ -232,108 +233,11 @@ void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
 		return;
 
 	 while (q->write_ptr != q->read_ptr) {
-		iwlagn_txq_free_tfd(priv, txq);
+		iwlagn_txq_free_tfd(priv, txq, get_cmd_index(q, q->read_ptr));
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 }
 
-/**
- * iwl_tx_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
- */
-void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
-{
-	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct device *dev = priv->bus.dev;
-	int i;
-
-	iwl_tx_queue_unmap(priv, txq_id);
-
-	/* De-alloc array of command/tx buffers */
-	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
-		kfree(txq->cmd[i]);
-
-	/* De-alloc circular buffer of TFDs */
-	if (txq->q.n_bd)
-		dma_free_coherent(dev, priv->hw_params.tfd_size *
-				  txq->q.n_bd, txq->tfds, txq->q.dma_addr);
-
-	/* De-alloc array of per-TFD driver data */
-	kfree(txq->txb);
-	txq->txb = NULL;
-
-	/* deallocate arrays */
-	kfree(txq->cmd);
-	kfree(txq->meta);
-	txq->cmd = NULL;
-	txq->meta = NULL;
-
-	/* 0-fill queue descriptor structure */
-	memset(txq, 0, sizeof(*txq));
-}
-
-/**
- * iwl_cmd_queue_unmap - Unmap any remaining DMA mappings from command queue
- */
-void iwl_cmd_queue_unmap(struct iwl_priv *priv)
-{
-	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
-	struct iwl_queue *q = &txq->q;
-	int i;
-
-	if (q->n_bd == 0)
-		return;
-
-	while (q->read_ptr != q->write_ptr) {
-		i = get_cmd_index(q, q->read_ptr);
-
-		iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i],
-				 DMA_BIDIRECTIONAL);
-		txq->meta[i].flags = 0;
-
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
-	}
-}
-
-/**
- * iwl_cmd_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
- */
-void iwl_cmd_queue_free(struct iwl_priv *priv)
-{
-	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
-	struct device *dev = priv->bus.dev;
-	int i;
-
-	iwl_cmd_queue_unmap(priv);
-
-	/* De-alloc array of command/tx buffers */
-	for (i = 0; i < TFD_CMD_SLOTS; i++)
-		kfree(txq->cmd[i]);
-
-	/* De-alloc circular buffer of TFDs */
-	if (txq->q.n_bd)
-		dma_free_coherent(dev, priv->hw_params.tfd_size * txq->q.n_bd,
-				  txq->tfds, txq->q.dma_addr);
-
-	/* deallocate arrays */
-	kfree(txq->cmd);
-	kfree(txq->meta);
-	txq->cmd = NULL;
-	txq->meta = NULL;
-
-	/* 0-fill queue descriptor structure */
-	memset(txq, 0, sizeof(*txq));
-}
-
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
-- 
1.7.0.4

