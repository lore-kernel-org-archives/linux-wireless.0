Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752322AbZJWUmr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:47 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 13/18] iwlwifi: remove unused parameters
Date: Fri, 23 Oct 2009 13:42:31 -0700
Message-Id: <1256330556-20997-14-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

parameters "len" is not used in both iwl_tx_queue_free() and
iwl_cmd_queue_free() functions

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |    9 ++-------
 1 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 5c43d7c..8ae4c9b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -131,7 +131,7 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
-	int i, len;
+	int i;
 
 	if (q->n_bd == 0)
 		return;
@@ -141,8 +141,6 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 
-	len = sizeof(struct iwl_device_cmd) * q->n_window;
-
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
 		kfree(txq->cmd[i]);
@@ -180,14 +178,11 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
-	int i, len;
+	int i;
 
 	if (q->n_bd == 0)
 		return;
 
-	len = sizeof(struct iwl_device_cmd) * q->n_window;
-	len += IWL_MAX_SCAN_SIZE;
-
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i <= TFD_CMD_SLOTS; i++)
 		kfree(txq->cmd[i]);
-- 
1.5.6.3

