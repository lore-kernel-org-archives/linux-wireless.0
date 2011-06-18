Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:65503 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753102Ab1FRQF2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jun 2011 12:05:28 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 10/25] iwlagn: don't use the PCI wrappers for DMA operation
Date: Sat, 18 Jun 2011 08:34:16 -0700
Message-Id: <1308411271-26093-11-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110618_180553_038459_B5C98132)
In-Reply-To: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1308411271-26093-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Get a pointer to the struct device during probe and get the rid of all the PCI
specific DMA wrappers.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c |   12 ++++++------
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c  |   27 +++++++++++++--------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    8 ++++----
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   27 +++++++++++++--------------
 4 files changed, 36 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 4c11edc..52da539 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -639,9 +639,9 @@ void iwlagn_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 		/* In the reset function, these buffers may have been allocated
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+			dma_unmap_page(priv->bus.dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
-				PCI_DMA_FROMDEVICE);
+				DMA_FROM_DEVICE);
 			__iwl_free_pages(priv, rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
 		}
@@ -913,9 +913,9 @@ void iwlagn_rx_allocate(struct iwl_priv *priv, gfp_t priority)
 		BUG_ON(rxb->page);
 		rxb->page = page;
 		/* Get physical address of the RB */
-		rxb->page_dma = pci_map_page(priv->pci_dev, page, 0,
+		rxb->page_dma = dma_map_page(priv->bus.dev, page, 0,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
-				PCI_DMA_FROMDEVICE);
+				DMA_FROM_DEVICE);
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
 		/* and also 256 byte aligned! */
@@ -958,9 +958,9 @@ void iwlagn_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 	int i;
 	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
 		if (rxq->pool[i].page != NULL) {
-			pci_unmap_page(priv->pci_dev, rxq->pool[i].page_dma,
+			dma_unmap_page(priv->bus.dev, rxq->pool[i].page_dma,
 				PAGE_SIZE << priv->hw_params.rx_page_order,
-				PCI_DMA_FROMDEVICE);
+				DMA_FROM_DEVICE);
 			__iwl_free_pages(priv, rxq->pool[i].page);
 			rxq->pool[i].page = NULL;
 		}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index f4e5ede..d0ac090 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -716,10 +716,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = pci_map_single(priv->pci_dev,
+	txcmd_phys = dma_map_single(priv->bus.dev,
 				    &out_cmd->hdr, firstlen,
-				    PCI_DMA_BIDIRECTIONAL);
-	if (unlikely(pci_dma_mapping_error(priv->pci_dev, txcmd_phys)))
+				    DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(priv->bus.dev, txcmd_phys)))
 		goto drop_unlock_sta;
 	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
 	dma_unmap_len_set(out_meta, len, firstlen);
@@ -735,13 +735,13 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	 * if any (802.11 null frames have no payload). */
 	secondlen = skb->len - hdr_len;
 	if (secondlen > 0) {
-		phys_addr = pci_map_single(priv->pci_dev, skb->data + hdr_len,
-					   secondlen, PCI_DMA_TODEVICE);
-		if (unlikely(pci_dma_mapping_error(priv->pci_dev, phys_addr))) {
-			pci_unmap_single(priv->pci_dev,
+		phys_addr = dma_map_single(priv->bus.dev, skb->data + hdr_len,
+					   secondlen, DMA_TO_DEVICE);
+		if (unlikely(dma_mapping_error(priv->bus.dev, phys_addr))) {
+			dma_unmap_single(priv->bus.dev,
 					 dma_unmap_addr(out_meta, mapping),
 					 dma_unmap_len(out_meta, len),
-					 PCI_DMA_BIDIRECTIONAL);
+					 DMA_BIDIRECTIONAL);
 			goto drop_unlock_sta;
 		}
 	}
@@ -764,8 +764,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 				offsetof(struct iwl_tx_cmd, scratch);
 
 	/* take back ownership of DMA buffer to enable update */
-	pci_dma_sync_single_for_cpu(priv->pci_dev, txcmd_phys,
-				    firstlen, PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_cpu(priv->bus.dev, txcmd_phys, firstlen,
+			DMA_BIDIRECTIONAL);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
@@ -780,8 +780,8 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 		iwlagn_txq_update_byte_cnt_tbl(priv, txq,
 					       le16_to_cpu(tx_cmd->len));
 
-	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
-				       firstlen, PCI_DMA_BIDIRECTIONAL);
+	dma_sync_single_for_device(priv->bus.dev, txcmd_phys, firstlen,
+			DMA_BIDIRECTIONAL);
 
 	trace_iwlwifi_dev_tx(priv,
 			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
@@ -848,8 +848,7 @@ static inline void iwlagn_free_dma_ptr(struct iwl_priv *priv,
 	if (unlikely(!ptr->addr))
 		return;
 
-	dma_free_coherent(priv->bus.dev,
-			  ptr->size, ptr->addr, ptr->dma);
+	dma_free_coherent(priv->bus.dev, ptr->size, ptr->addr, ptr->dma);
 	memset(ptr, 0, sizeof(*ptr));
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 72db1a9..eeb31bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -495,9 +495,9 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		pci_unmap_page(priv->pci_dev, rxb->page_dma,
+		dma_unmap_page(priv->bus.dev, rxb->page_dma,
 			       PAGE_SIZE << priv->hw_params.rx_page_order,
-			       PCI_DMA_FROMDEVICE);
+			       DMA_FROM_DEVICE);
 		pkt = rxb_addr(rxb);
 
 		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
@@ -579,9 +579,9 @@ static void iwl_rx_handle(struct iwl_priv *priv)
 		 * rx_free list for reuse later. */
 		spin_lock_irqsave(&rxq->lock, flags);
 		if (rxb->page != NULL) {
-			rxb->page_dma = pci_map_page(priv->pci_dev, rxb->page,
+			rxb->page_dma = dma_map_page(priv->bus.dev, rxb->page,
 				0, PAGE_SIZE << priv->hw_params.rx_page_order,
-				PCI_DMA_FROMDEVICE);
+				DMA_FROM_DEVICE);
 			list_add_tail(&rxb->list, &rxq->rx_free);
 			rxq->free_count++;
 		} else
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index f982ac9..fd8aee9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -128,7 +128,6 @@ static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
 static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
 			     struct iwl_tfd *tfd)
 {
-	struct pci_dev *dev = priv->pci_dev;
 	int i;
 	int num_tbs;
 
@@ -143,15 +142,15 @@ static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
 
 	/* Unmap tx_cmd */
 	if (num_tbs)
-		pci_unmap_single(dev,
+		dma_unmap_single(priv->bus.dev,
 				dma_unmap_addr(meta, mapping),
 				dma_unmap_len(meta, len),
-				PCI_DMA_BIDIRECTIONAL);
+				DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
-		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
-				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
+		dma_unmap_single(priv->bus.dev, iwl_tfd_tb_get_addr(tfd, i),
+				iwl_tfd_tb_get_len(tfd, i), DMA_TO_DEVICE);
 }
 
 /**
@@ -310,10 +309,10 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 		i = get_cmd_index(q, q->read_ptr);
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
-			pci_unmap_single(priv->pci_dev,
+			dma_unmap_single(priv->bus.dev,
 					 dma_unmap_addr(&txq->meta[i], mapping),
 					 dma_unmap_len(&txq->meta[i], len),
-					 PCI_DMA_BIDIRECTIONAL);
+					 DMA_BIDIRECTIONAL);
 			txq->meta[i].flags = 0;
 		}
 
@@ -456,7 +455,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 	txq->tfds = dma_alloc_coherent(dev, tfd_sz, &txq->q.dma_addr,
 				       GFP_KERNEL);
 	if (!txq->tfds) {
-		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n", tfd_sz);
+		IWL_ERR(priv, "dma_alloc_coherent(%zd) failed\n", tfd_sz);
 		goto error;
 	}
 	txq->q.id = id;
@@ -677,9 +676,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
 			q->write_ptr, idx, priv->cmd_queue);
 
-	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
-				   copy_size, PCI_DMA_BIDIRECTIONAL);
-	if (unlikely(pci_dma_mapping_error(priv->pci_dev, phys_addr))) {
+	phys_addr = dma_map_single(priv->bus.dev, &out_cmd->hdr, copy_size,
+				DMA_BIDIRECTIONAL);
+	if (unlikely(dma_mapping_error(priv->bus.dev, phys_addr))) {
 		idx = -ENOMEM;
 		goto out;
 	}
@@ -699,9 +698,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			continue;
 		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
 			continue;
-		phys_addr = pci_map_single(priv->pci_dev, (void *)cmd->data[i],
-					   cmd->len[i], PCI_DMA_TODEVICE);
-		if (pci_dma_mapping_error(priv->pci_dev, phys_addr)) {
+		phys_addr = dma_map_single(priv->bus.dev, (void *)cmd->data[i],
+					   cmd->len[i], DMA_TO_DEVICE);
+		if (dma_mapping_error(priv->bus.dev, phys_addr)) {
 			iwlagn_unmap_tfd(priv, out_meta,
 					 &txq->tfds[q->write_ptr]);
 			idx = -ENOMEM;
-- 
1.7.0.4

