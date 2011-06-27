Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:5161 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab1F0Pgy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Jun 2011 11:36:54 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 2/2] iwlagn: map command buffers BIDI
Date: Mon, 27 Jun 2011 08:04:35 -0700
Message-Id: <1309187075-3879-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110627_173659_310835_6734CEC9)
In-Reply-To: <1309187075-3879-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1309187075-3879-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Evidently, the device sometimes wants to write back
to command buffers, even if I see no reason why it
should. Allow it to do that.

Tested-by: Andy Lutomirski <luto@mit.edu>
Tested-by: Kyle McMartin <kyle@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-tx.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 8f20065..4707431 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -126,7 +126,7 @@ static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
 }
 
 static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
-			     struct iwl_tfd *tfd)
+			     struct iwl_tfd *tfd, enum dma_data_direction dma_dir)
 {
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
@@ -151,7 +151,7 @@ static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
 		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
-				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
+				iwl_tfd_tb_get_len(tfd, i), dma_dir);
 }
 
 /**
@@ -167,7 +167,8 @@ void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	struct iwl_tfd *tfd_tmp = txq->tfds;
 	int index = txq->q.read_ptr;
 
-	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index]);
+	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index],
+			 DMA_TO_DEVICE);
 
 	/* free SKB */
 	if (txq->txb) {
@@ -310,7 +311,8 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 		i = get_cmd_index(q, q->read_ptr);
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
-			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i]);
+			iwlagn_unmap_tfd(priv, &txq->meta[i], &txq->tfds[i],
+					 DMA_BIDIRECTIONAL);
 			txq->meta[i].flags = 0;
 		}
 
@@ -692,10 +694,11 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr = pci_map_single(priv->pci_dev, (void *)cmd->data[i],
-					   cmd->len[i], PCI_DMA_TODEVICE);
+					   cmd->len[i], DMA_BIDIRECTIONAL);
 		if (pci_dma_mapping_error(priv->pci_dev, phys_addr)) {
 			iwlagn_unmap_tfd(priv, out_meta,
-					 &txq->tfds[q->write_ptr]);
+					 &txq->tfds[q->write_ptr],
+					 DMA_BIDIRECTIONAL);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -799,7 +802,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index]);
+	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-- 
1.7.0.4

