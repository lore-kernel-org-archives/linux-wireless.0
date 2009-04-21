Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:21382 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZDURtp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 13:49:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.30 and w-t 2/2] iwlwifi: DMA fixes
Date: Tue, 21 Apr 2009 10:55:48 -0700
Message-Id: <1240336548-20913-3-git-send-email-reinette.chatre@intel.com> (sfid-20090421_194952_904233_5D08E2A0)
In-Reply-To: <1240336548-20913-2-git-send-email-reinette.chatre@intel.com>
References: <1240336548-20913-1-git-send-email-reinette.chatre@intel.com>
 <1240336548-20913-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Reinette Chatre <reinette.chatre@intel.com>

A few issues wrt DMA were uncovered when using the driver with swiotlb.
- driver should not use memory after it has been mapped
- iwl3945's RX queue management cannot use all of iwlagn because
  the size of the RX buffer is different. Revert back to using
  iwl3945 specific routines that map/unmap memory.
- no need to "dma_syn_single_range_for_cpu" followed by pci_unmap_single,
  we can just call pci_unmap_single initially
- only map the memory area that will be used by device. this is especially
  relevant to the mapping of iwl_cmd. we should not map the entire
  structure because the meta data at the beginning of structure contains
  the address to be used later for unmapping. If the address to be used for
  unmapping is stored in mapped data it creates a problem.
- ensure that _if_ memory needs to be modified after it is mapped that we
  call _sync_single_for_cpu first, and then release it back to device with
  _sync_single_for_device
- we mapped the wrong length of data for host commands, with mapped length
  differing with length provided to device, fix that.

Thanks to Jason Andryuk <jandryuk@gmail.com> for significant bisecting
help to find these issues.

This fixes http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1964

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Jason Andryuk <jandryuk@gmail.com>
Tested-by: Ben Gamari <bgamari@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   95 ++++++++++--------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  148 +++++++++++++++++++--------
 6 files changed, 165 insertions(+), 96 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index edc0cb3..41f1d66 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1192,7 +1192,7 @@ int iwl3945_hw_nic_init(struct iwl_priv *priv)
 			return -ENOMEM;
 		}
 	} else
-		iwl_rx_queue_reset(priv, rxq);
+		iwl3945_rx_queue_reset(priv, rxq);
 
 	iwl3945_rx_replenish(priv);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 4f5473e..da87528 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -215,6 +215,7 @@ extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern int iwl3945_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq, int count, u32 id);
 extern void iwl3945_rx_replenish(void *data);
+extern void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 4f1cee6..374fb22 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -883,11 +883,9 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		dma_sync_single_range_for_cpu(
-				&priv->pci_dev->dev, rxb->real_dma_addr,
-				rxb->aligned_dma_addr - rxb->real_dma_addr,
-				priv->hw_params.rx_buf_size,
-				PCI_DMA_FROMDEVICE);
+		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
+				 priv->hw_params.rx_buf_size + 256,
+				 PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response
@@ -939,9 +937,6 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				 priv->hw_params.rx_buf_size + 256,
-				 PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index e363d9b..5aa76a7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -361,12 +361,16 @@ struct iwl_host_cmd {
 
 /**
  * struct iwl_rx_queue - Rx queue
+ * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
+ * @dma_addr: bus address of buffer of receive buffer descriptors (rbd)
  * @read: Shared index to newest available Rx buffer
  * @write: Shared index to oldest written Rx packet
  * @free_count: Number of pre-allocated buffers in rx_free
  * @rx_free: list of free SKBs for use
  * @rx_used: List of Rx buffers with no SKB
  * @need_update: flag to indicate we need to update read/write index
+ * @rb_stts: driver's pointer to receive buffer status
+ * @rb_stts_dma: bus address of receive buffer status
  *
  * NOTE:  rx_free and rx_used are used as a FIFO for iwl_rx_mem_buffers
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index c8c0a13..a82cca0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -799,6 +799,22 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
 
+
+	/* Total # bytes to be transmitted */
+	len = (u16)skb->len;
+	tx_cmd->len = cpu_to_le16(len);
+
+	if (info->control.hw_key)
+		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
+
+	/* TODO need this for burst mode later on */
+	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
+
+	/* set is_hcca to 0; it probably will never be implemented */
+	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
+
+	iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
+
 	/*
 	 * Use the first empty entry in this queue's command buffer array
 	 * to contain the Tx command and MAC header concatenated together
@@ -819,21 +835,30 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	else
 		len_org = 0;
 
+	/* Tell NIC about any 2-byte padding after MAC header */
+	if (len_org)
+		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
+
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
 	txcmd_phys = pci_map_single(priv->pci_dev,
-				    out_cmd, sizeof(struct iwl_cmd),
+				    &out_cmd->hdr, len,
 				    PCI_DMA_BIDIRECTIONAL);
 	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
-	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
+	pci_unmap_len_set(&out_cmd->meta, len, len);
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
-	txcmd_phys += offsetof(struct iwl_cmd, hdr);
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 						   txcmd_phys, len, 1, 0);
 
-	if (info->control.hw_key)
-		iwl_tx_cmd_build_hwcrypto(priv, info, tx_cmd, skb, sta_id);
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
+		txq->need_update = 1;
+		if (qc)
+			priv->stations[sta_id].tid[tid].seq_number = seq_number;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
+	}
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -846,35 +871,17 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 							   0, 0);
 	}
 
-	/* Tell NIC about any 2-byte padding after MAC header */
-	if (len_org)
-		tx_cmd->tx_flags |= TX_CMD_FLG_MH_PAD_MSK;
-
-	/* Total # bytes to be transmitted */
-	len = (u16)skb->len;
-	tx_cmd->len = cpu_to_le16(len);
-	/* TODO need this for burst mode later on */
-	iwl_tx_cmd_build_basic(priv, tx_cmd, info, hdr, sta_id);
-
-	/* set is_hcca to 0; it probably will never be implemented */
-	iwl_tx_cmd_build_rate(priv, tx_cmd, info, fc, sta_id, 0);
-
-	iwl_update_tx_stats(priv, le16_to_cpu(fc), len);
-
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
-		offsetof(struct iwl_tx_cmd, scratch);
+				offsetof(struct iwl_tx_cmd, scratch);
+
+	len = sizeof(struct iwl_tx_cmd) +
+		sizeof(struct iwl_cmd_header) + hdr_len;
+	/* take back ownership of DMA buffer to enable update */
+	pci_dma_sync_single_for_cpu(priv->pci_dev, txcmd_phys,
+				    len, PCI_DMA_BIDIRECTIONAL);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
-	if (!ieee80211_has_morefrags(hdr->frame_control)) {
-		txq->need_update = 1;
-		if (qc)
-			priv->stations[sta_id].tid[tid].seq_number = seq_number;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
-
 	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
 		     le16_to_cpu(out_cmd->hdr.sequence));
 	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx_cmd->tx_flags));
@@ -882,7 +889,11 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
-	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, len);
+	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq,
+						     le16_to_cpu(tx_cmd->len));
+
+	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
+				       len, PCI_DMA_BIDIRECTIONAL);
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
@@ -970,18 +981,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
-	len = (idx == TFD_CMD_SLOTS) ?
-			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
+	len = sizeof(struct iwl_cmd) - sizeof(struct iwl_cmd_meta);
+	len += (idx == TFD_CMD_SLOTS) ?  IWL_MAX_SCAN_SIZE : 0;
 
-	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
-				   len, PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
-	pci_unmap_len_set(&out_cmd->meta, len, len);
-	phys_addr += offsetof(struct iwl_cmd, hdr);
-
-	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   phys_addr, fix_size, 1,
-						   U32_PAD(cmd->len));
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	switch (out_cmd->hdr.cmd) {
@@ -1009,6 +1011,15 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		/* Set up entry in queue's byte count circular buffer */
 		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, 0);
 
+	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
+				   fix_size, PCI_DMA_BIDIRECTIONAL);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
+	pci_unmap_len_set(&out_cmd->meta, len, fix_size);
+
+	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
+						   phys_addr, fix_size, 1,
+						   U32_PAD(cmd->len));
+
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl_txq_update_write_ptr(priv, txq);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 3b7b5fa..390473c 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -690,7 +690,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	int txq_id = skb_get_queue_mapping(skb);
-	u16 len, idx, len_org, hdr_len;
+	u16 len, idx, len_org, hdr_len; /* TODO: len_org is not used */
 	u8 id;
 	u8 unicast;
 	u8 sta_id;
@@ -792,6 +792,40 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	/* Copy MAC header from skb into command buffer */
 	memcpy(tx->hdr, hdr, hdr_len);
 
+
+	if (info->control.hw_key)
+		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, sta_id);
+
+	/* TODO need this for burst mode later on */
+	iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, sta_id);
+
+	/* set is_hcca to 0; it probably will never be implemented */
+	iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, sta_id, 0);
+
+	/* Total # bytes to be transmitted */
+	len = (u16)skb->len;
+	tx->len = cpu_to_le16(len);
+
+
+	tx->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
+	tx->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
+
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
+		txq->need_update = 1;
+		if (qc)
+			priv->stations_39[sta_id].tid[tid].seq_number = seq_number;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
+	}
+
+	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
+		     le16_to_cpu(out_cmd->hdr.sequence));
+	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx->tx_flags));
+	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
+			   ieee80211_hdrlen(fc));
+
 	/*
 	 * Use the first empty entry in this queue's command buffer array
 	 * to contain the Tx command and MAC header concatenated together
@@ -814,22 +848,18 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = pci_map_single(priv->pci_dev,
-				    out_cmd, sizeof(struct iwl_cmd),
-				    PCI_DMA_TODEVICE);
+	txcmd_phys = pci_map_single(priv->pci_dev, &out_cmd->hdr,
+				    len, PCI_DMA_TODEVICE);
+	/* we do not map meta data ... so we can safely access address to
+	 * provide to unmap command*/
 	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
-	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	txcmd_phys += offsetof(struct iwl_cmd, hdr);
+	pci_unmap_len_set(&out_cmd->meta, len, len);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 						   txcmd_phys, len, 1, 0);
 
-	if (info->control.hw_key)
-		iwl3945_build_tx_cmd_hwcrypto(priv, info, out_cmd, skb, sta_id);
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -842,34 +872,6 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 							   0, U32_PAD(len));
 	}
 
-	/* Total # bytes to be transmitted */
-	len = (u16)skb->len;
-	tx->len = cpu_to_le16(len);
-
-	/* TODO need this for burst mode later on */
-	iwl3945_build_tx_cmd_basic(priv, out_cmd, info, hdr, sta_id);
-
-	/* set is_hcca to 0; it probably will never be implemented */
-	iwl3945_hw_build_tx_cmd_rate(priv, out_cmd, info, hdr, sta_id, 0);
-
-	tx->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
-	tx->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
-
-	if (!ieee80211_has_morefrags(hdr->frame_control)) {
-		txq->need_update = 1;
-		if (qc)
-			priv->stations_39[sta_id].tid[tid].seq_number = seq_number;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
-
-	IWL_DEBUG_TX(priv, "sequence nr = 0X%x \n",
-		     le16_to_cpu(out_cmd->hdr.sequence));
-	IWL_DEBUG_TX(priv, "tx_flags = 0X%x \n", le32_to_cpu(tx->tx_flags));
-	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
-			   ieee80211_hdrlen(fc));
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
@@ -1381,6 +1383,37 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&rxq->lock, flags);
 }
 
+void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	unsigned long flags;
+	int i;
+	spin_lock_irqsave(&rxq->lock, flags);
+	INIT_LIST_HEAD(&rxq->rx_free);
+	INIT_LIST_HEAD(&rxq->rx_used);
+	/* Fill the rx_used queue with _all_ of the Rx buffers */
+	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++) {
+		/* In the reset function, these buffers may have been allocated
+		 * to an SKB, so we need to unmap and free potential storage */
+		if (rxq->pool[i].skb != NULL) {
+			pci_unmap_single(priv->pci_dev,
+					 rxq->pool[i].real_dma_addr,
+					 priv->hw_params.rx_buf_size,
+					 PCI_DMA_FROMDEVICE);
+			priv->alloc_rxb_skb--;
+			dev_kfree_skb(rxq->pool[i].skb);
+			rxq->pool[i].skb = NULL;
+		}
+		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
+	}
+
+	/* Set us so that we have processed and used all buffers, but have
+	 * not restocked the Rx queue with fresh buffers */
+	rxq->read = rxq->write = 0;
+	rxq->free_count = 0;
+	spin_unlock_irqrestore(&rxq->lock, flags);
+}
+EXPORT_SYMBOL(iwl3945_rx_queue_reset);
+
 /*
  * this should be called while priv->lock is locked
  */
@@ -1405,6 +1438,34 @@ void iwl3945_rx_replenish(void *data)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
+ * If an SKB has been detached, the POOL needs to have its SKB set to NULL
+ * This free routine walks the list of POOL entries and if SKB is set to
+ * non NULL it is unmapped and freed
+ */
+static void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	int i;
+	for (i = 0; i < RX_QUEUE_SIZE + RX_FREE_BUFFERS; i++) {
+		if (rxq->pool[i].skb != NULL) {
+			pci_unmap_single(priv->pci_dev,
+					 rxq->pool[i].real_dma_addr,
+					 priv->hw_params.rx_buf_size,
+					 PCI_DMA_FROMDEVICE);
+			dev_kfree_skb(rxq->pool[i].skb);
+		}
+	}
+
+	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			    rxq->dma_addr);
+	pci_free_consistent(priv->pci_dev, sizeof(struct iwl_rb_status),
+			    rxq->rb_stts, rxq->rb_stts_dma);
+	rxq->bd = NULL;
+	rxq->rb_stts  = NULL;
+}
+EXPORT_SYMBOL(iwl3945_rx_queue_free);
+
+
 /* Convert linear signal-to-noise ratio into dB */
 static u8 ratio2dB[100] = {
 /*	 0   1   2   3   4   5   6   7   8   9 */
@@ -1522,9 +1583,9 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->real_dma_addr,
-					    priv->hw_params.rx_buf_size,
-					    PCI_DMA_FROMDEVICE);
+		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
+				priv->hw_params.rx_buf_size,
+				PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response
@@ -1573,9 +1634,6 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				priv->hw_params.rx_buf_size,
-				PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
@@ -4431,7 +4489,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-		iwl_rx_queue_free(priv, &priv->rxq);
+		iwl3945_rx_queue_free(priv, &priv->rxq);
 	iwl3945_hw_txq_ctx_free(priv);
 
 	iwl3945_unset_hw_params(priv);
-- 
1.5.6.3

