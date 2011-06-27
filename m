Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50702 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab1F0UBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 16:01:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: johannes.berg@intel.com, wey-yi.w.guy@intel.com,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlagn: use PCI_DMA_* for pci_* operations
Date: Mon, 27 Jun 2011 15:50:19 -0400
Message-Id: <1309204219-9579-1-git-send-email-linville@tuxdriver.com> (sfid-20110627_220400_516650_45ED904C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"iwlagn: map command buffers BIDI" uses the DMA_* enumerations for DMA
directions, even though the pci_* DMA API is still in use.  That patch
was undoubtedly developed on top of "iwlagn: don't use the PCI wrappers
for DMA operation", which is due in the next release.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 4707431..9eee978 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -168,7 +168,7 @@ void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	int index = txq->q.read_ptr;
 
 	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index],
-			 DMA_TO_DEVICE);
+			 PCI_DMA_TODEVICE);
 
 	/* free SKB */
 	if (txq->txb) {
@@ -312,7 +312,7 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
 			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i],
-					 DMA_BIDIRECTIONAL);
+					 PCI_DMA_BIDIRECTIONAL);
 			txq->meta[i].flags = 0;
 		}
 
@@ -694,11 +694,11 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr = pci_map_single(priv->pci_dev, (void *)cmd->data[i],
-					   cmd->len[i], DMA_BIDIRECTIONAL);
+					   cmd->len[i], PCI_DMA_BIDIRECTIONAL);
 		if (pci_dma_mapping_error(priv->pci_dev, phys_addr)) {
 			iwlagn_unmap_tfd(priv, out_meta,
 					 &txq->tfds[q->write_ptr],
-					 DMA_BIDIRECTIONAL);
+					 PCI_DMA_BIDIRECTIONAL);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -802,7 +802,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
+	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], PCI_DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-- 
1.7.4.4

