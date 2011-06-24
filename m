Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab1FXU4I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2011 16:56:08 -0400
Date: Fri, 24 Jun 2011 16:55:57 -0400
From: Kyle McMartin <kmcmartin@redhat.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: Re: [3.0 regression] DMAR faults in iwlagn
Message-ID: <20110624205557.GH22060@ihatethathostname.lab.bos.redhat.com> (sfid-20110624_225619_025169_47DA29DC)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1308774416.29571.26.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fixing it up to make it apply against 3.0-rc4 kills the warning for me
as well. Thanks for being so quick to post a fix, Johannes!

Tested-by: Kyle McMartin <kyle@redhat.com>

---
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 686e176..11da90a 100644
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
+		PCI_DMA_TODEVICE);
 
 	/* free SKB */
 	if (txq->txb) {
@@ -700,10 +701,11 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
 		phys_addr = pci_map_single(priv->pci_dev, (void *)cmd->data[i],
-					   cmd->len[i], PCI_DMA_TODEVICE);
+					   cmd->len[i], PCI_DMA_BIDIRECTIONAL);
 		if (pci_dma_mapping_error(priv->pci_dev, phys_addr)) {
 			iwlagn_unmap_tfd(priv, out_meta,
-					 &txq->tfds[q->write_ptr]);
+					 &txq->tfds[q->write_ptr],
+					 PCI_DMA_BIDIRECTIONAL);
 			idx = -ENOMEM;
 			goto out;
 		}
@@ -807,7 +809,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index]);
+	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index], PCI_DMA_BIDIRECTIONAL);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
