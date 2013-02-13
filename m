Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:17271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756032Ab3BMOtR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2013 09:49:17 -0500
Date: Wed, 13 Feb 2013 15:49:08 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] iwlegacy: more checks for dma mapping errors
Message-ID: <20130213144906.GA1378@redhat.com> (sfid-20130213_154920_217699_24DD6280)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch check output of pci_map_single() calls. I missed them on
my previous patch "iwlegacy: check for dma mapping errors", which
fixed only pci_map_page() calls.

To handle remaining possible dma mappings errors, we need to rearrange
ilXXXX_tx_skb() and il_enqueue_hcmd() functions.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-mac.c | 51 +++++++++++++++++---------------
 drivers/net/wireless/iwlegacy/4965-mac.c | 36 ++++++++++++----------
 drivers/net/wireless/iwlegacy/common.c   | 16 ++++++----
 3 files changed, 59 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index 83856d1..3630a41 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -572,26 +572,11 @@ il3945_tx_skb(struct il_priv *il,
 	il3945_hw_build_tx_cmd_rate(il, out_cmd, info, hdr, sta_id);
 
 	/* Total # bytes to be transmitted */
-	len = (u16) skb->len;
-	tx_cmd->len = cpu_to_le16(len);
+	tx_cmd->len = cpu_to_le16((u16) skb->len);
 
-	il_update_stats(il, true, fc, len);
 	tx_cmd->tx_flags &= ~TX_CMD_FLG_ANT_A_MSK;
 	tx_cmd->tx_flags &= ~TX_CMD_FLG_ANT_B_MSK;
 
-	if (!ieee80211_has_morefrags(hdr->frame_control)) {
-		txq->need_update = 1;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
-
-	D_TX("sequence nr = 0X%x\n", le16_to_cpu(out_cmd->hdr.sequence));
-	D_TX("tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
-	il_print_hex_dump(il, IL_DL_TX, tx_cmd, sizeof(*tx_cmd));
-	il_print_hex_dump(il, IL_DL_TX, (u8 *) tx_cmd->hdr,
-			  ieee80211_hdrlen(fc));
-
 	/*
 	 * Use the first empty entry in this queue's command buffer array
 	 * to contain the Tx command and MAC header concatenated together
@@ -610,14 +595,8 @@ il3945_tx_skb(struct il_priv *il,
 	 * within command buffer array. */
 	txcmd_phys =
 	    pci_map_single(il->pci_dev, &out_cmd->hdr, len, PCI_DMA_TODEVICE);
-	/* we do not map meta data ... so we can safely access address to
-	 * provide to unmap command*/
-	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	dma_unmap_len_set(out_meta, len, len);
-
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1, 0);
+	if (unlikely(pci_dma_mapping_error(il->pci_dev, txcmd_phys)))
+		goto drop_unlock;
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -626,10 +605,34 @@ il3945_tx_skb(struct il_priv *il,
 		phys_addr =
 		    pci_map_single(il->pci_dev, skb->data + hdr_len, len,
 				   PCI_DMA_TODEVICE);
+		if (unlikely(pci_dma_mapping_error(il->pci_dev, phys_addr)))
+			goto drop_unlock;
+	}
+
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, len, 1, 0);
+	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	dma_unmap_len_set(out_meta, len, len);
+	if (len)
 		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, len, 0,
 					       U32_PAD(len));
+
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
+		txq->need_update = 1;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
 	}
 
+	il_update_stats(il, true, fc, skb->len);
+
+	D_TX("sequence nr = 0X%x\n", le16_to_cpu(out_cmd->hdr.sequence));
+	D_TX("tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
+	il_print_hex_dump(il, IL_DL_TX, tx_cmd, sizeof(*tx_cmd));
+	il_print_hex_dump(il, IL_DL_TX, (u8 *) tx_cmd->hdr,
+			  ieee80211_hdrlen(fc));
+
 	/* Tell device the write idx *just past* this latest filled TFD */
 	q->write_ptr = il_queue_inc_wrap(q->write_ptr, q->n_bd);
 	il_txq_update_write_ptr(il, txq);
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 835662a..7941eb3 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -1793,8 +1793,7 @@ il4965_tx_skb(struct il_priv *il,
 	memcpy(tx_cmd->hdr, hdr, hdr_len);
 
 	/* Total # bytes to be transmitted */
-	len = (u16) skb->len;
-	tx_cmd->len = cpu_to_le16(len);
+	tx_cmd->len = cpu_to_le16((u16) skb->len);
 
 	if (info->control.hw_key)
 		il4965_tx_cmd_build_hwcrypto(il, info, tx_cmd, skb, sta_id);
@@ -1804,7 +1803,6 @@ il4965_tx_skb(struct il_priv *il,
 
 	il4965_tx_cmd_build_rate(il, tx_cmd, info, sta, fc);
 
-	il_update_stats(il, true, fc, len);
 	/*
 	 * Use the first empty entry in this queue's command buffer array
 	 * to contain the Tx command and MAC header concatenated together
@@ -1826,18 +1824,8 @@ il4965_tx_skb(struct il_priv *il,
 	txcmd_phys =
 	    pci_map_single(il->pci_dev, &out_cmd->hdr, firstlen,
 			   PCI_DMA_BIDIRECTIONAL);
-	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
-	dma_unmap_len_set(out_meta, len, firstlen);
-	/* Add buffer containing Tx command and MAC(!) header to TFD's
-	 * first entry */
-	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
-
-	if (!ieee80211_has_morefrags(hdr->frame_control)) {
-		txq->need_update = 1;
-	} else {
-		wait_write_ptr = 1;
-		txq->need_update = 0;
-	}
+	if (unlikely(pci_dma_mapping_error(il->pci_dev, txcmd_phys)))
+		goto drop_unlock;
 
 	/* Set up TFD's 2nd entry to point directly to remainder of skb,
 	 * if any (802.11 null frames have no payload). */
@@ -1846,8 +1834,24 @@ il4965_tx_skb(struct il_priv *il,
 		phys_addr =
 		    pci_map_single(il->pci_dev, skb->data + hdr_len, secondlen,
 				   PCI_DMA_TODEVICE);
+		if (unlikely(pci_dma_mapping_error(il->pci_dev, phys_addr)))
+			goto drop_unlock;
+	}
+
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	il->ops->txq_attach_buf_to_tfd(il, txq, txcmd_phys, firstlen, 1, 0);
+	dma_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	dma_unmap_len_set(out_meta, len, firstlen);
+	if (secondlen)
 		il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, secondlen,
 					       0, 0);
+
+	if (!ieee80211_has_morefrags(hdr->frame_control)) {
+		txq->need_update = 1;
+	} else {
+		wait_write_ptr = 1;
+		txq->need_update = 0;
 	}
 
 	scratch_phys =
@@ -1860,6 +1864,8 @@ il4965_tx_skb(struct il_priv *il,
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
 	tx_cmd->dram_msb_ptr = il_get_dma_hi_addr(scratch_phys);
 
+	il_update_stats(il, true, fc, skb->len);
+
 	D_TX("sequence nr = 0X%x\n", le16_to_cpu(out_cmd->hdr.sequence));
 	D_TX("tx_flags = 0X%x\n", le32_to_cpu(tx_cmd->tx_flags));
 	il_print_hex_dump(il, IL_DL_TX, (u8 *) tx_cmd, sizeof(*tx_cmd));
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index 1f59860..4ed2949 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -3162,18 +3162,23 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 		     idx, il->cmd_queue);
 	}
 #endif
-	txq->need_update = 1;
-
-	if (il->ops->txq_update_byte_cnt_tbl)
-		/* Set up entry in queue's byte count circular buffer */
-		il->ops->txq_update_byte_cnt_tbl(il, txq, 0);
 
 	phys_addr =
 	    pci_map_single(il->pci_dev, &out_cmd->hdr, fix_size,
 			   PCI_DMA_BIDIRECTIONAL);
+	if (unlikely(pci_dma_mapping_error(il->pci_dev, phys_addr))) {
+		idx = -ENOMEM;
+		goto out;
+	}
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
 	dma_unmap_len_set(out_meta, len, fix_size);
 
+	txq->need_update = 1;
+
+	if (il->ops->txq_update_byte_cnt_tbl)
+		/* Set up entry in queue's byte count circular buffer */
+		il->ops->txq_update_byte_cnt_tbl(il, txq, 0);
+
 	il->ops->txq_attach_buf_to_tfd(il, txq, phys_addr, fix_size, 1,
 					    U32_PAD(cmd->len));
 
@@ -3181,6 +3186,7 @@ il_enqueue_hcmd(struct il_priv *il, struct il_host_cmd *cmd)
 	q->write_ptr = il_queue_inc_wrap(q->write_ptr, q->n_bd);
 	il_txq_update_write_ptr(il, txq);
 
+out:
 	spin_unlock_irqrestore(&il->hcmd_lock, flags);
 	return idx;
 }
-- 
1.7.11.7

