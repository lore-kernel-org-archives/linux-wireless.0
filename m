Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22570 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179AbZCREq6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2009 00:46:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/13] iwl3945: use iwl_cmd_queue_free
Date: Tue, 17 Mar 2009 21:51:49 -0700
Message-Id: <1237351913-19202-10-git-send-email-reinette.chatre@intel.com> (sfid-20090318_054713_167943_8202DE79)
In-Reply-To: <1237351913-19202-9-git-send-email-reinette.chatre@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-2-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-3-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-4-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-5-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-8-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

iwl_cmd_queue_free needs to be used to free up the cmd_queue,
as TFD slots for cmd_queue and tx_queue are different.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c |   11 +++++------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c   |    6 ++++--
 3 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 99bb48e..50c61ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -747,11 +747,6 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	int i;
 	int counter;
 
-	/* classify bd */
-	if (txq->q.id == IWL_CMD_QUEUE_NUM)
-		/* nothing to cleanup after for host commands */
-		return;
-
 	/* sanity check */
 	counter = TFD_CTL_COUNT_GET(le32_to_cpu(tfd->control_flags));
 	if (counter > NUM_TFD_CHUNKS) {
@@ -1240,7 +1235,11 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id <= priv->hw_params.max_txq_num; txq_id++)
-		iwl_tx_queue_free(priv, txq_id);
+		if (txq_id == IWL_CMD_QUEUE_NUM)
+			iwl_cmd_queue_free(priv);
+		else
+			iwl_tx_queue_free(priv, txq_id);
+
 }
 
 void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 27310fe..a8eac8c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -264,6 +264,7 @@ void iwl_rx_reply_error(struct iwl_priv *priv,
 * RX
 ******************************************************/
 void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
+void iwl_cmd_queue_free(struct iwl_priv *priv);
 int iwl_rx_queue_alloc(struct iwl_priv *priv);
 void iwl_rx_handle(struct iwl_priv *priv);
 int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index dff60fb..9e83ee2 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -174,7 +174,7 @@ EXPORT_SYMBOL(iwl_tx_queue_free);
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-static void iwl_cmd_queue_free(struct iwl_priv *priv)
+void iwl_cmd_queue_free(struct iwl_priv *priv)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
@@ -193,12 +193,14 @@ static void iwl_cmd_queue_free(struct iwl_priv *priv)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl_tfd) *
+		pci_free_consistent(dev, priv->hw_params.tfd_size *
 				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
+EXPORT_SYMBOL(iwl_cmd_queue_free);
+
 /*************** DMA-QUEUE-GENERAL-FUNCTIONS  *****
  * DMA services
  *
-- 
1.5.6.3

