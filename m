Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45792 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab1BNOcY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Feb 2011 09:32:24 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH v2] iwlwifi: fix dma mappings and skbs leak
Date: Mon, 14 Feb 2011 15:32:27 +0100
Message-Id: <1297693947-15310-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since commit commit 470058e0ad82fcfaaffd57307d8bf8c094e8e9d7
"iwlwifi: avoid Tx queue memory allocation in interface down" we do
not unmap dma and free skbs when down device and there is pending
transfer. What in consequence may cause that system hung when
performing shutdown at iptables module unload.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
v1 -> v2: do not claim patch fixes warning, which is still
observable with patch applied

 drivers/net/wireless/iwlwifi/iwl-agn-tx.c |   12 +++++-
 drivers/net/wireless/iwlwifi/iwl-core.h   |    2 +
 drivers/net/wireless/iwlwifi/iwl-tx.c     |   61 ++++++++++++++++++++--------
 3 files changed, 56 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 266490d..a709d05 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -947,7 +947,7 @@ void iwlagn_txq_ctx_reset(struct iwl_priv *priv)
  */
 void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 {
-	int ch;
+	int ch, txq_id;
 	unsigned long flags;
 
 	/* Turn off all Tx DMA fifos */
@@ -966,6 +966,16 @@ void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 			    iwl_read_direct32(priv, FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (!priv->txq)
+		return;
+
+	/* Unmap DMA from host system and free skb's */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		if (txq_id == priv->cmd_queue)
+			iwl_cmd_queue_unmap(priv);
+		else
+			iwl_tx_queue_unmap(priv, txq_id);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e0ec170..ed701f9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -509,6 +509,7 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 * RX
 ******************************************************/
 void iwl_cmd_queue_free(struct iwl_priv *priv);
+void iwl_cmd_queue_unmap(struct iwl_priv *priv);
 int iwl_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
@@ -533,6 +534,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 			int slots_num, u32 txq_id);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id);
+void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id);
 void iwl_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
  * TX power
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 073b6ce..a8935cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -87,6 +87,24 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 EXPORT_SYMBOL(iwl_txq_update_write_ptr);
 
 /**
+ * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
+ */
+void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+
+	if (q->n_bd == 0)
+		return;
+
+	 while (q->write_ptr != q->read_ptr) {
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
+	}
+}
+EXPORT_SYMBOL(iwl_tx_queue_unmap);
+
+/**
  * iwl_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
  *
@@ -97,17 +115,10 @@ EXPORT_SYMBOL(iwl_txq_update_write_ptr);
 void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
-	struct iwl_queue *q = &txq->q;
 	struct device *dev = &priv->pci_dev->dev;
 	int i;
 
-	if (q->n_bd == 0)
-		return;
-
-	/* first, empty all BD's */
-	for (; q->write_ptr != q->read_ptr;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
-		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+	iwl_tx_queue_unmap(priv, txq_id);
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
@@ -134,26 +145,19 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 EXPORT_SYMBOL(iwl_tx_queue_free);
 
 /**
- * iwl_cmd_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
+ * iwl_cmd_queue_unmap - Unmap any remaining DMA mappings from command queue
  */
-void iwl_cmd_queue_free(struct iwl_priv *priv)
+void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 {
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 	struct iwl_queue *q = &txq->q;
-	struct device *dev = &priv->pci_dev->dev;
 	int i;
 	bool huge = false;
 
 	if (q->n_bd == 0)
 		return;
 
-	for (; q->read_ptr != q->write_ptr;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	while (q->read_ptr != q->write_ptr) {
 		/* we have no way to tell if it is a huge cmd ATM */
 		i = get_cmd_index(q, q->read_ptr, 0);
 
@@ -166,7 +170,10 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 				 dma_unmap_addr(&txq->meta[i], mapping),
 				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
+
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
+
 	if (huge) {
 		i = q->n_window;
 		pci_unmap_single(priv->pci_dev,
@@ -174,6 +181,24 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
 	}
+}
+EXPORT_SYMBOL(iwl_cmd_queue_unmap);
+
+/**
+ * iwl_cmd_queue_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+void iwl_cmd_queue_free(struct iwl_priv *priv)
+{
+	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
+	struct device *dev = &priv->pci_dev->dev;
+	int i;
+
+	iwl_cmd_queue_unmap(priv);
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i <= TFD_CMD_SLOTS; i++)
-- 
1.7.1

