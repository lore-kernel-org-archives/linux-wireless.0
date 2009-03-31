Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21542 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756410AbZCaWRG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 18:17:06 -0400
Subject: Re: kernel BUG at drivers/net/wireless/iwlwifi/iwl3945-base.c:3127!
From: reinette chatre <reinette.chatre@intel.com>
To: Jason Andryuk <jandryuk@gmail.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>,
	Tomas Winkler <tomasw@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1237768621.8764.13.camel@rainbow>
References: <760481.57662.qm@web57614.mail.re1.yahoo.com>
	 <1236649234.6685.9.camel@rainbow> <1236661466.15923.53.camel@rc-desk>
	 <1236742805.6267.9.camel@rainbow>
	 <c4d76b3b0903122031o7baea17ay5704df428ea2fced@mail.gmail.com>
	 <c4d76b3b0903160510i5afc6cd6t856b63383a275fca@mail.gmail.com>
	 <1237254243.13077.33.camel@rainbow> <1237427568.6943.13.camel@rainbow>
	 <c4d76b3b0903191822l5494f268h395acc4a14608239@mail.gmail.com>
	 <1237581564.21165.5.camel@abhi-desktop>
	 <c4d76b3b0903221029r21282bbbs13a8af06f9d8ce2@mail.gmail.com>
	 <1237768621.8764.13.camel@rainbow>
Content-Type: text/plain
Date: Tue, 31 Mar 2009 15:22:41 -0700
Message-Id: <1238538161.10366.144.camel@rc-desk> (sfid-20090401_001711_788640_16DD0629)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Jason,

Sorry for the delay ...

On Sun, 2009-03-22 at 17:37 -0700, Jason Andryuk wrote:
> On Sun, 2009-03-22 at 13:29 -0400, Jason Andryuk wrote:
> > The patch did not work.
> > 
> > However, I do not think it's an alignment issue.
> > 
> > pci_map_single on x86_64 with >3G memory and no IOMMU uses the swiotlb
> > by default.  swiotlb provides "bounce buffers" for physical addresses
> > over 4GB.  So for memory where the kmalloc value is at a physical
> > address over 2**32, pci_map_single will copy to a swiotlb slot.  That
> > means the dma_handle return value of pci_map_single is not necessarily
> > the physical address of the virtual address.
> > 
> > In iwl3945_tx_skb (iwl3945-base.c line 1099) use the pci_map_single
> > which copies the memory of out_cmd at that time.  However,
> > iwl3945_build_tx_cmd_basic, iwl3945_hw_build_tx_cmd_rate, and
> > iwl3945_build_tx_cmd_hwcrypto are all passed out_cmd and modify memory
> > located there.  These modifications are not reflected in the memory
> > located at txcmd_phys.
> > 
> > pci_map_single should only be called once the tx command structures
> > are completely written.
> > 
> > Additionally, pci_unmap_single should be called once the memory is no
> > longer needed to free the swiotlb entry for that command.  I am not
> > sure if this is currently handled for all cases.
> > 
> > Previous use of pci_alloc_coherent meant that memory would allocated
> > at an physical address below 4GB and kept in-sync both the device and
> > cpu.
> > 
> > Refer to Documentation/x86/x86_64/boot-options.txt and lib/swiotlb.c
> > for information on IOMMU and swiotlb
> > 
> > Jason
> 
> I hacked up an inelegant patch that does get the driver working.
> 
> We call pci_dma_sync_single_for_device to ensure the correct contents
> are visible to the device.  That is, we copy out_cmd to phys_addr, so
> the desired contents are viewable for the device.
> 
> I tried moving the pci_map_single call to right before the call to
> iwl_txq_update_write_ptr, but I never got that working successfully.
> Presumably that is how the problem should be fixed.  Another failed
> attempt was to map from "out_cmd + offsetof(struck iwl_cmd, hdr)"
> instead of out_cmd.  The phys_addr + offsetof(struck iwl_cmd, hdr) is
> what is passed to txq_attach_buf_to_tfd, so I thought that should work.
> Unfortunately it did not.  The added benefit would have been that it
> moved "len" and "mapping" of struct iwl_cmd_meta out of the mapped area.
> Then losing them since they were written after the mapping would not
> have been a problem. 
> 
> If struct iwl_cmd_meta's len and mapping members are read by one of the
> "reclaim" functions, then they should probably be sync'ed with
> pci_dma_sync_single_for_cpu beforehand.
> 

I addressed these issues as well as a few more that I uncovered while
digging into this.

Could you please try this patch?


>From c152258435c047dfd7423e0279781c3fcb2f4e71 Mon Sep 17 00:00:00 2001
From: Reinette Chatre <reinette.chatre@intel.com>
Date: Tue, 31 Mar 2009 14:16:05 -0700
Subject: [PATCH] iwlwifi: DMA fixes

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

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: Jason Andryuk <jandryuk@gmail.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    1 +
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   11 +--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   93 ++++++++++--------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  144 +++++++++++++++++++--------
 6 files changed, 161 insertions(+), 94 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index d03f553..05cd499 100644
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
index 29bc0d2..3213a63 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -214,6 +214,7 @@ extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern int iwl3945_tx_queue_init(struct iwl_priv *priv,
 			     struct iwl_tx_queue *txq, int count, u32 id);
 extern void iwl3945_rx_replenish(void *data);
+extern void iwl3945_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 51f6a01..ea859f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -976,11 +976,9 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
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
@@ -1031,9 +1029,6 @@ void iwl_rx_handle(struct iwl_priv *priv)
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				 priv->hw_params.rx_buf_size + 256,
-				 PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 0baae80..721c80f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -360,12 +360,16 @@ struct iwl_host_cmd {
 
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
index 57ea320..f85b47f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -797,6 +797,22 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
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
@@ -817,21 +833,30 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
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
@@ -844,42 +869,26 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
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
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd, sizeof(*tx_cmd));
-
 	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx_cmd->hdr, hdr_len);
 
 	/* Set up entry for this TFD in Tx byte-count array */
 	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, len);
 
+	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
+				       len, PCI_DMA_BIDIRECTIONAL);
+
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
 	ret = iwl_txq_update_write_ptr(priv, txq);
@@ -966,18 +975,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 			INDEX_TO_SEQ(q->write_ptr));
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
-	len = (idx == TFD_CMD_SLOTS) ?
-			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
-
-	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
-				   len, PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
-	pci_unmap_len_set(&out_cmd->meta, len, len);
-	phys_addr += offsetof(struct iwl_cmd, hdr);
+	len = sizeof(struct iwl_cmd) - sizeof(struct iwl_cmd_meta);
+	len += (idx == TFD_CMD_SLOTS) ?  IWL_MAX_SCAN_SIZE : 0;
 
-	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   phys_addr, fix_size, 1,
-						   U32_PAD(cmd->len));
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	switch (out_cmd->hdr.cmd) {
@@ -1005,6 +1005,15 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
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
index c29189b..c4c8943 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -972,7 +972,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	int txq_id = skb_get_queue_mapping(skb);
-	u16 len, idx, len_org, hdr_len;
+	u16 len, idx, len_org, hdr_len; /* TODO: len_org is not used */
 	u8 id;
 	u8 unicast;
 	u8 sta_id;
@@ -1074,6 +1074,38 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
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
+	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
+
+	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
+			   ieee80211_hdrlen(fc));
+
 	/*
 	 * Use the first empty entry in this queue's command buffer array
 	 * to contain the Tx command and MAC header concatenated together
@@ -1096,22 +1128,18 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
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
@@ -1124,32 +1152,6 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
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
-	iwl_print_hex_dump(priv, IWL_DL_TX, tx, sizeof(*tx));
-
-	iwl_print_hex_dump(priv, IWL_DL_TX, (u8 *)tx->hdr,
-			   ieee80211_hdrlen(fc));
 
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
@@ -1661,6 +1663,37 @@ static void iwl3945_rx_allocate(struct iwl_priv *priv)
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
@@ -1685,6 +1718,34 @@ void iwl3945_rx_replenish(void *data)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
+/* Assumes that the skb field of the buffers in 'pool' is kept accurate.
+ * If an SKB has been detached, the POOL needs to have its SKB set to NULL
+ * This free routine walks the list of POOL entries and if SKB is set to
+ * non NULL it is unmapped and freed
+ */
+void iwl3945_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
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
@@ -1802,9 +1863,9 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 		rxq->queue[i] = NULL;
 
-		pci_dma_sync_single_for_cpu(priv->pci_dev, rxb->real_dma_addr,
-					    priv->hw_params.rx_buf_size,
-					    PCI_DMA_FROMDEVICE);
+		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
+				priv->hw_params.rx_buf_size,
+				PCI_DMA_FROMDEVICE);
 		pkt = (struct iwl_rx_packet *)rxb->skb->data;
 
 		/* Reclaim a command buffer only if this packet is a response
@@ -1852,9 +1913,6 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 			rxb->skb = NULL;
 		}
 
-		pci_unmap_single(priv->pci_dev, rxb->real_dma_addr,
-				priv->hw_params.rx_buf_size,
-				PCI_DMA_FROMDEVICE);
 		spin_lock_irqsave(&rxq->lock, flags);
 		list_add_tail(&rxb->list, &priv->rxq.rx_used);
 		spin_unlock_irqrestore(&rxq->lock, flags);
@@ -5144,7 +5202,7 @@ static void __devexit iwl3945_pci_remove(struct pci_dev *pdev)
 	iwl3945_dealloc_ucode_pci(priv);
 
 	if (priv->rxq.bd)
-		iwl_rx_queue_free(priv, &priv->rxq);
+		iwl3945_rx_queue_free(priv, &priv->rxq);
 	iwl3945_hw_txq_ctx_free(priv);
 
 	iwl3945_unset_hw_params(priv);
-- 
1.5.6.3



