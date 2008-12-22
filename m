Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752308AbYLVDiw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:52 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 10/10] iwl3945: use rx queue management infrastructure from iwlcore
Date: Mon, 22 Dec 2008 11:31:23 +0800
Message-Id: <1229916683-9772-11-git-send-email-yi.zhu@intel.com> (sfid-20081222_043900_918761_763FB521)
In-Reply-To: <1229916683-9772-10-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-4-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-5-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-6-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-7-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-8-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-9-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch uses rx queue alloc free and reset function from iwlcore.
This should fix the regression reported by Kalle Valo.

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    3 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   81 +--------------------------
 3 files changed, 3 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index fb2c2db..77c55a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1195,13 +1195,13 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	if (!rxq->bd) {
-		rc = iwl3945_rx_queue_alloc(priv);
+		rc = iwl_rx_queue_alloc(priv);
 		if (rc) {
 			IWL_ERR(priv, "Unable to initialize Rx queue\n");
 			return -ENOMEM;
 		}
 	} else
-		iwl3945_rx_queue_reset(priv, rxq);
+		iwl_rx_queue_reset(priv, rxq);
 
 	iwl3945_rx_replenish(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 941746b..bd41643 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -212,9 +212,6 @@ extern u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *bssid,
 			  int is_ap, u8 flags);
 extern int iwl3945_power_init_handle(struct iwl_priv *priv);
 extern int iwl3945_eeprom_init(struct iwl_priv *priv);
-extern int iwl3945_rx_queue_alloc(struct iwl_priv *priv);
-extern void iwl3945_rx_queue_reset(struct iwl_priv *priv,
-			       struct iwl_rx_queue *rxq);
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
 extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern int iwl3945_tx_queue_init(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2e5c4d8..c098cac 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -3189,7 +3189,6 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
  *
  * Driver sequence:
  *
- * iwl3945_rx_queue_alloc()   Allocates rx_free
  * iwl3945_rx_replenish()     Replenishes rx_free list from rx_used, and calls
  *                            iwl3945_rx_queue_restock
  * iwl3945_rx_queue_restock() Moves available buffers from rx_free into Rx
@@ -3408,84 +3407,6 @@ void iwl3945_rx_replenish(void *data)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
- * If an SKB has been detached, the POOL needs to have its SKB set to NULL
- * This free routine walks the list of POOL entries and if SKB is set to
- * non NULL it is unmapped and freed
- */
-static void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	int i;
-	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].real_dma_addr,
-					 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			dev_kfree_skb(rxq->pool[i].skb);
-		}
-	}
-
-	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
-			    rxq->dma_addr);
-	rxq->bd = NULL;
-}
-
-int iwl3945_rx_queue_alloc(struct iwl_priv *priv)
-{
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	struct pci_dev *dev = priv->pci_dev;
-	int i;
-
-	spin_lock_init(&rxq->lock);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-
-	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
-	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
-	if (!rxq->bd)
-		return -ENOMEM;
-
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->free_count = 0;
-	rxq->need_update = 0;
-	return 0;
-}
-
-void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	unsigned long flags;
-	int i;
-	spin_lock_irqsave(&rxq->lock, flags);
-	INIT_LIST_HEAD(&rxq->rx_free);
-	INIT_LIST_HEAD(&rxq->rx_used);
-	/* Fill the rx_used queue with _all_ of the Rx buffers */
-	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
-		/* In the reset function, these buffers may have been allocated
-		 * to an SKB, so we need to unmap and free potential storage */
-		if (rxq->pool[i].skb != NULL) {
-			pci_unmap_single(priv->pci_dev,
-					 rxq->pool[i].real_dma_addr,
-					 IWL_RX_BUF_SIZE, PCI_DMA_FROMDEVICE);
-			priv->alloc_rxb_skb--;
-			dev_kfree_skb(rxq->pool[i].skb);
-			rxq->pool[i].skb = NULL;
-		}
-		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
-	}
-
-	/* Set us so that we have processed and used all buffers, but have
-	 * not restocked the Rx queue with fresh buffers */
-	rxq->read = rxq->write = 0;
-	rxq->free_count = 0;
-	spin_unlock_irqrestore(&rxq->lock, flags);
-}
-
 /* Convert linear signal-to-noise ratio into dB */
 static u8 ratio2dB[100] = {
 /*	 0   1   2   3   4   5   6   7   8   9 */
@@ -7746,7 +7667,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-		iwl3945_rx_queue_free(priv, &priv->rxq);
+		iwl_rx_queue_free(priv, &priv->rxq);
 	iwl3945_hw_txq_ctx_free(priv);
 
 	iwl3945_unset_hw_params(priv);
-- 
1.5.3.6

