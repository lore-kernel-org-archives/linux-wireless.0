Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab1BYP5X (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Feb 2011 10:57:23 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Intel Linux Wireless <ilw@linux.intel.com>
Cc: linux-wireless@vger.kernel.org,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 2/3] iwlegacy: fix dma mappings and skbs leak
Date: Fri, 25 Feb 2011 16:57:11 +0100
Message-Id: <1298649432-4416-2-git-send-email-sgruszka@redhat.com>
In-Reply-To: <1298649432-4416-1-git-send-email-sgruszka@redhat.com>
References: <1298649432-4416-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix possible dma mappings and skbs introduced by commit
470058e0ad82fcfaaffd57307d8bf8c094e8e9d7 "iwlwifi: avoid Tx queue
memory allocation in interface down".

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c |   12 ++++-
 drivers/net/wireless/iwlegacy/iwl-core.h    |    2 +
 drivers/net/wireless/iwlegacy/iwl-tx.c      |   75 +++++++++++++++++---------
 3 files changed, 62 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 2e0f0db..eff3743 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -698,7 +698,7 @@ void iwl4965_txq_ctx_reset(struct iwl_priv *priv)
  */
 void iwl4965_txq_ctx_stop(struct iwl_priv *priv)
 {
-	int ch;
+	int ch, txq_id;
 	unsigned long flags;
 
 	/* Turn off all Tx DMA fifos */
@@ -719,6 +719,16 @@ void iwl4965_txq_ctx_stop(struct iwl_priv *priv)
 					FH_TSSR_TX_STATUS_REG));
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
+
+	if (!priv->txq)
+		return;
+
+	/* Unmap DMA from host system and free skb's */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		if (txq_id == priv->cmd_queue)
+			iwl_legacy_cmd_queue_unmap(priv);
+		else
+			iwl_legacy_tx_queue_unmap(priv, txq_id);
 }
 
 /*
diff --git a/drivers/net/wireless/iwlegacy/iwl-core.h b/drivers/net/wireless/iwlegacy/iwl-core.h
index 1159b0d..c7d2310 100644
--- a/drivers/net/wireless/iwlegacy/iwl-core.h
+++ b/drivers/net/wireless/iwlegacy/iwl-core.h
@@ -388,6 +388,7 @@ void iwl_legacy_rx_reply_error(struct iwl_priv *priv,
 /*****************************************************
 * RX
 ******************************************************/
+void iwl_legacy_cmd_queue_unmap(struct iwl_priv *priv);
 void iwl_legacy_cmd_queue_free(struct iwl_priv *priv);
 int iwl_legacy_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_legacy_rx_queue_update_write_ptr(struct iwl_priv *priv,
@@ -415,6 +416,7 @@ int iwl_legacy_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 void iwl_legacy_tx_queue_reset(struct iwl_priv *priv,
 			struct iwl_tx_queue *txq,
 			int slots_num, u32 txq_id);
+void iwl_legacy_tx_queue_unmap(struct iwl_priv *priv, int txq_id);
 void iwl_legacy_tx_queue_free(struct iwl_priv *priv, int txq_id);
 void iwl_legacy_setup_watchdog(struct iwl_priv *priv);
 /*****************************************************
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index 7db8340..a227773 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -82,6 +82,24 @@ iwl_legacy_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 EXPORT_SYMBOL(iwl_legacy_txq_update_write_ptr);
 
 /**
+ * iwl_legacy_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
+ */
+void iwl_legacy_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
+{
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_queue *q = &txq->q;
+
+	if (q->n_bd == 0)
+		return;
+
+	while (q->write_ptr != q->read_ptr) {
+		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+		q->read_ptr = iwl_legacy_queue_inc_wrap(q->read_ptr, q->n_bd);
+	}
+}
+EXPORT_SYMBOL(iwl_legacy_tx_queue_unmap);
+
+/**
  * iwl_legacy_tx_queue_free - Deallocate DMA queue.
  * @txq: Transmit queue to deallocate.
  *
@@ -92,17 +110,10 @@ EXPORT_SYMBOL(iwl_legacy_txq_update_write_ptr);
 void iwl_legacy_tx_queue_free(struct iwl_priv *priv, int txq_id)
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
-	     q->read_ptr = iwl_legacy_queue_inc_wrap(q->read_ptr, q->n_bd))
-		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+	iwl_legacy_tx_queue_unmap(priv, txq_id);
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
@@ -129,39 +140,33 @@ void iwl_legacy_tx_queue_free(struct iwl_priv *priv, int txq_id)
 EXPORT_SYMBOL(iwl_legacy_tx_queue_free);
 
 /**
- * iwl_legacy_cmd_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
+ * iwl_cmd_queue_unmap - Unmap any remaining DMA mappings from command queue
  */
-void iwl_legacy_cmd_queue_free(struct iwl_priv *priv)
+void iwl_legacy_cmd_queue_unmap(struct iwl_priv *priv)
 {
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
 	struct iwl_queue *q = &txq->q;
-	struct device *dev = &priv->pci_dev->dev;
-	int i;
 	bool huge = false;
+	int i;
 
 	if (q->n_bd == 0)
 		return;
 
-	for (; q->read_ptr != q->write_ptr;
-	     q->read_ptr = iwl_legacy_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	while (q->read_ptr != q->write_ptr) {
 		/* we have no way to tell if it is a huge cmd ATM */
 		i = iwl_legacy_get_cmd_index(q, q->read_ptr, 0);
 
-		if (txq->meta[i].flags & CMD_SIZE_HUGE) {
+		if (txq->meta[i].flags & CMD_SIZE_HUGE)
 			huge = true;
-			continue;
-		}
+		else
+			pci_unmap_single(priv->pci_dev,
+					 dma_unmap_addr(&txq->meta[i], mapping),
+					 dma_unmap_len(&txq->meta[i], len),
+					 PCI_DMA_BIDIRECTIONAL);
 
-		pci_unmap_single(priv->pci_dev,
-				 dma_unmap_addr(&txq->meta[i], mapping),
-				 dma_unmap_len(&txq->meta[i], len),
-				 PCI_DMA_BIDIRECTIONAL);
+		q->read_ptr = iwl_legacy_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
+
 	if (huge) {
 		i = q->n_window;
 		pci_unmap_single(priv->pci_dev,
@@ -169,6 +174,24 @@ void iwl_legacy_cmd_queue_free(struct iwl_priv *priv)
 				 dma_unmap_len(&txq->meta[i], len),
 				 PCI_DMA_BIDIRECTIONAL);
 	}
+}
+EXPORT_SYMBOL(iwl_legacy_cmd_queue_unmap);
+
+/**
+ * iwl_legacy_cmd_queue_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+void iwl_legacy_cmd_queue_free(struct iwl_priv *priv)
+{
+	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
+	struct device *dev = &priv->pci_dev->dev;
+	int i;
+
+	iwl_legacy_cmd_queue_unmap(priv);
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i <= TFD_CMD_SLOTS; i++)
-- 
1.7.1

