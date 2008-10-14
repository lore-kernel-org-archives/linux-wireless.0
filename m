Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4763 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbYJNTfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 4/9] iwlwifi: add iwl_cmd_queue_free for readability
Date: Tue, 14 Oct 2008 12:32:44 -0700
Message-Id: <1224012769-8920-5-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213523_689569_087406B5)
In-Reply-To: <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds iwl_cmd_queue_free function and
separate cmd queue freeing from regular tx queue freeing.
This improves readability and adds one more step in
restructuring  of cmd queue handling

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Reviewed-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   53 +++++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 907a53e..77e5e65 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -72,10 +72,6 @@ static int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	int counter = 0;
 	int index, is_odd;
 
-	/* Host command buffers stay mapped in memory, nothing to clean */
-	if (txq->q.id == IWL_CMD_QUEUE_NUM)
-		return 0;
-
 	/* Sanity check on number of chunks */
 	counter = IWL_GET_BITS(*bd, num_tbs);
 	if (counter > MAX_NUM_OF_TBS) {
@@ -210,7 +206,7 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
-	int i, slots_num, len;
+	int i, len;
 
 	if (q->n_bd == 0)
 		return;
@@ -221,16 +217,10 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 		iwl_hw_txq_free_tfd(priv, txq);
 
 	len = sizeof(struct iwl_cmd) * q->n_window;
-	if (q->id == IWL_CMD_QUEUE_NUM)
-		len += IWL_MAX_SCAN_SIZE;
 
 	/* De-alloc array of command/tx buffers */
-	slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
-			TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-	for (i = 0; i < slots_num; i++)
+	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
 		kfree(txq->cmd[i]);
-	if (txq_id == IWL_CMD_QUEUE_NUM)
-		kfree(txq->cmd[slots_num]);
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
@@ -245,6 +235,40 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	memset(txq, 0, sizeof(*txq));
 }
 
+
+/**
+ * iwl_cmd_queue_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+static void iwl_cmd_queue_free(struct iwl_priv *priv)
+{
+	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl_queue *q = &txq->q;
+	struct pci_dev *dev = priv->pci_dev;
+	int i, len;
+
+	if (q->n_bd == 0)
+		return;
+
+	len = sizeof(struct iwl_cmd) * q->n_window;
+	len += IWL_MAX_SCAN_SIZE;
+
+	/* De-alloc array of command/tx buffers */
+	for (i = 0; i <= TFD_CMD_SLOTS; i++)
+		kfree(txq->cmd[i]);
+
+	/* De-alloc circular buffer of TFDs */
+	if (txq->q.n_bd)
+		pci_free_consistent(dev, sizeof(struct iwl_tfd_frame) *
+				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
+
+	/* 0-fill queue descriptor structure */
+	memset(txq, 0, sizeof(*txq));
+}
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
@@ -468,7 +492,10 @@ void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		iwl_tx_queue_free(priv, txq_id);
+		if (txq_id == IWL_CMD_QUEUE_NUM)
+			iwl_cmd_queue_free(priv);
+		else
+			iwl_tx_queue_free(priv, txq_id);
 
 	/* Keep-warm buffer */
 	iwl_kw_free(priv);
-- 
1.5.4.3

