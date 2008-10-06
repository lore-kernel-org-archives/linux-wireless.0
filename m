Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:55938 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbYJFQKj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Oct 2008 12:10:39 -0400
Subject: [PATCH v2] iwlwifi: fix DMA code and bugs
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Tomas Winkler <tomasw@gmail.com>
In-Reply-To: <1223308831.15196.28.camel@johannes.berg> (sfid-20081006_180110_939098_1A64839A)
References: <1223308831.15196.28.camel@johannes.berg>
	 (sfid-20081006_180110_939098_1A64839A)
Content-Type: text/plain
Date: Mon, 06 Oct 2008 18:10:05 +0200
Message-Id: <1223309405.15196.32.camel@johannes.berg> (sfid-20081006_181043_313891_E9288151)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch cleans up the DMA code to be understandable and not
completely wrong. In particular:
 * there is no need to have a weird iwl_tfd_frame_data struct that is
   used 10 times, just use an address struct 20 times
 * therefore, all the is_odd junk goes away
 * fix a bug in iwl_hcmd_queue_reclaim where it would reclaim all the
   fragments of a descriptor rather than all descriptors (this may be
   the cause of the dma unmapping problem I reported)
 * some more cleanups

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Tested on 5000 hw, please apply.

v2: fixes small issue with getting rid of iwl_get_dma_hi_address.

Oh and who came up with struct iwl_tfd_frame_data? Were drugs involved?

 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   98 ++++++++++++++---------------
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    3 
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    5 -
 drivers/net/wireless/iwlwifi/iwl-tx.c      |   84 +++++-------------------
 4 files changed, 70 insertions(+), 120 deletions(-)

--- everything.orig/drivers/net/wireless/iwlwifi/iwl-4965-hw.h	2008-10-06 17:55:40.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-4965-hw.h	2008-10-06 17:55:45.000000000 +0200
@@ -822,54 +822,11 @@ enum {
 #define IWL49_NUM_QUEUES	16
 #define IWL49_NUM_AMPDU_QUEUES	8
 
-/**
- * struct iwl_tfd_frame_data
- *
- * Describes up to 2 buffers containing (contiguous) portions of a Tx frame.
- * Each buffer must be on dword boundary.
- * Up to 10 iwl_tfd_frame_data structures, describing up to 20 buffers,
- * may be filled within a TFD (iwl_tfd_frame).
- *
- * Bit fields in tb1_addr:
- * 31- 0: Tx buffer 1 address bits [31:0]
- *
- * Bit fields in val1:
- * 31-16: Tx buffer 2 address bits [15:0]
- * 15- 4: Tx buffer 1 length (bytes)
- *  3- 0: Tx buffer 1 address bits [32:32]
- *
- * Bit fields in val2:
- * 31-20: Tx buffer 2 length (bytes)
- * 19- 0: Tx buffer 2 address bits [35:16]
- */
-struct iwl_tfd_frame_data {
-	__le32 tb1_addr;
-
-	__le32 val1;
-	/* __le32 ptb1_32_35:4; */
-#define IWL_tb1_addr_hi_POS 0
-#define IWL_tb1_addr_hi_LEN 4
-#define IWL_tb1_addr_hi_SYM val1
-	/* __le32 tb_len1:12; */
-#define IWL_tb1_len_POS 4
-#define IWL_tb1_len_LEN 12
-#define IWL_tb1_len_SYM val1
-	/* __le32 ptb2_0_15:16; */
-#define IWL_tb2_addr_lo16_POS 16
-#define IWL_tb2_addr_lo16_LEN 16
-#define IWL_tb2_addr_lo16_SYM val1
-
-	__le32 val2;
-	/* __le32 ptb2_16_35:20; */
-#define IWL_tb2_addr_hi20_POS 0
-#define IWL_tb2_addr_hi20_LEN 20
-#define IWL_tb2_addr_hi20_SYM val2
-	/* __le32 tb_len2:12; */
-#define IWL_tb2_len_POS 20
-#define IWL_tb2_len_LEN 12
-#define IWL_tb2_len_SYM val2
-} __attribute__ ((packed));
-
+struct iwl_tfd_addr_desc {
+	__le32 lo;
+	/* 4 bits address, 12 bits length */
+	__le16 hi_len;
+} __attribute__((packed));
 
 /**
  * struct iwl_tfd_frame
@@ -908,11 +865,54 @@ struct iwl_tfd_frame {
 #define IWL_num_tbs_SYM val0
 	/* __le32 rsvd2:1; */
 	/* __le32 padding:2; */
-	struct iwl_tfd_frame_data pa[10];
+	struct iwl_tfd_addr_desc addrs[20];
 	__le32 reserved;
 } __attribute__ ((packed));
 
 
+static inline dma_addr_t iwl_get_addr(struct iwl_tfd_frame *frame, u8 idx)
+{
+	struct iwl_tfd_addr_desc *dsc = &frame->addrs[idx];
+
+	BUG_ON(idx >= 20);
+
+	return (u64)le32_to_cpu(dsc->lo) |
+		((u64)(le16_to_cpu(dsc->hi_len) & 0xF)) << 32;
+}
+
+static inline u16 iwl_get_len(struct iwl_tfd_frame *frame, u8 idx)
+{
+	struct iwl_tfd_addr_desc *dsc = &frame->addrs[idx];
+
+	BUG_ON(idx >= 20);
+
+	return le16_to_cpu(dsc->hi_len) >> 4;
+}
+
+static inline void iwl_set_addr(struct iwl_tfd_frame *frame, u8 idx, dma_addr_t addr)
+{
+	struct iwl_tfd_addr_desc *dsc = &frame->addrs[idx];
+
+	BUG_ON(idx >= 20);
+	BUG_ON(addr & ~0xFFFFFFFFFULL);
+	WARN_ON(addr & 0x3);
+
+	dsc->lo = cpu_to_le32(addr);
+	dsc->hi_len &= cpu_to_le16(~0xF);
+	dsc->hi_len |= cpu_to_le16((u64)addr >> 32);
+}
+
+static inline void iwl_set_len(struct iwl_tfd_frame *frame, u8 idx, u16 len)
+{
+	struct iwl_tfd_addr_desc *dsc = &frame->addrs[idx];
+
+	BUG_ON(idx >= 20);
+
+	dsc->hi_len &= cpu_to_le16(0xF);
+	dsc->hi_len |= cpu_to_le16(len << 4);
+}
+
+
 /**
  * struct iwl4965_queue_byte_cnt_entry
  *
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-10-06 17:55:40.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-tx.c	2008-10-06 18:06:38.000000000 +0200
@@ -63,63 +63,39 @@ static const u16 default_tid_to_tx_fifo[
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-static int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+static void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
 	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
 	int counter = 0;
-	int index, is_odd;
 
 	/* Host command buffers stay mapped in memory, nothing to clean */
 	if (txq->q.id == IWL_CMD_QUEUE_NUM)
-		return 0;
+		return;
 
 	/* Sanity check on number of chunks */
 	counter = IWL_GET_BITS(*bd, num_tbs);
-	if (counter > MAX_NUM_OF_TBS) {
+	if (counter >= MAX_NUM_OF_TBS) {
 		IWL_ERROR("Too many chunks: %i\n", counter);
 		/* @todo issue fatal error, it is quite serious situation */
-		return 0;
+		return;
 	}
 
-	/* Unmap chunks, if any.
-	 * TFD info for odd chunks is different format than for even chunks. */
+	/* Unmap chunks, if any. */
 	for (i = 0; i < counter; i++) {
-		index = i / 2;
-		is_odd = i & 0x1;
-
-		if (is_odd)
-			pci_unmap_single(
-				dev,
-				IWL_GET_BITS(bd->pa[index], tb2_addr_lo16) |
-				(IWL_GET_BITS(bd->pa[index],
-					      tb2_addr_hi20) << 16),
-				IWL_GET_BITS(bd->pa[index], tb2_len),
-				PCI_DMA_TODEVICE);
-
-		else if (i > 0)
-			pci_unmap_single(dev,
-					 le32_to_cpu(bd->pa[index].tb1_addr),
-					 IWL_GET_BITS(bd->pa[index], tb1_len),
-					 PCI_DMA_TODEVICE);
-
-		/* Free SKB, if any, for this chunk */
-		if (txq->txb[txq->q.read_ptr].skb[i]) {
-			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[i];
+		pci_unmap_single(dev, iwl_get_addr(bd, i), iwl_get_len(bd, i),
+				 PCI_DMA_TODEVICE);
 
-			dev_kfree_skb(skb);
-			txq->txb[txq->q.read_ptr].skb[i] = NULL;
-		}
+		dev_kfree_skb(txq->txb[txq->q.read_ptr].skb[i]);
+		txq->txb[txq->q.read_ptr].skb[i] = NULL;
 	}
-	return 0;
 }
 
 static int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 				 dma_addr_t addr, u16 len)
 {
-	int index, is_odd;
 	struct iwl_tfd_frame *tfd = ptr;
 	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
 
@@ -130,20 +106,8 @@ static int iwl_hw_txq_attach_buf_to_tfd(
 		return -EINVAL;
 	}
 
-	index = num_tbs / 2;
-	is_odd = num_tbs & 0x1;
-
-	if (!is_odd) {
-		tfd->pa[index].tb1_addr = cpu_to_le32(addr);
-		IWL_SET_BITS(tfd->pa[index], tb1_addr_hi,
-			     iwl_get_dma_hi_address(addr));
-		IWL_SET_BITS(tfd->pa[index], tb1_len, len);
-	} else {
-		IWL_SET_BITS(tfd->pa[index], tb2_addr_lo16,
-			     (u32) (addr & 0xffff));
-		IWL_SET_BITS(tfd->pa[index], tb2_addr_hi20, addr >> 16);
-		IWL_SET_BITS(tfd->pa[index], tb2_len, len);
-	}
+	iwl_set_addr(tfd, num_tbs, addr);
+	iwl_set_len(tfd, num_tbs, len);
 
 	IWL_SET_BITS(*tfd, num_tbs, num_tbs + 1);
 
@@ -950,7 +914,7 @@ int iwl_tx_skb(struct iwl_priv *priv, st
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 		offsetof(struct iwl_tx_cmd, scratch);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
+	tx_cmd->dram_msb_ptr = ((u64)scratch_phys >> 32) & 0xFF;
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -1106,6 +1070,8 @@ int iwl_tx_queue_reclaim(struct iwl_priv
 	struct iwl_tx_info *tx_info;
 	int nfreed = 0;
 
+	BUILD_BUG_ON(sizeof(struct iwl_tfd_frame) != 128);
+
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
@@ -1113,8 +1079,9 @@ int iwl_tx_queue_reclaim(struct iwl_priv
 		return 0;
 	}
 
-	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	for (index = iwl_queue_inc_wrap(index, q->n_bd);
+	     q->read_ptr != index;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
@@ -1143,8 +1110,6 @@ static void iwl_hcmd_queue_reclaim(struc
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_tfd_frame *bd = &txq->bd[index];
-	dma_addr_t dma_addr;
-	int is_odd, buf_len;
 	int nfreed = 0;
 
 	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
@@ -1156,25 +1121,16 @@ static void iwl_hcmd_queue_reclaim(struc
 
 	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+		bd = &txq->bd[index];
 
 		if (nfreed > 1) {
 			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
 					q->write_ptr, q->read_ptr);
 			queue_work(priv->workqueue, &priv->restart);
 		}
-		is_odd = (index/2) & 0x1;
-		if (is_odd) {
-			dma_addr = IWL_GET_BITS(bd->pa[index], tb2_addr_lo16) |
-					(IWL_GET_BITS(bd->pa[index],
-							tb2_addr_hi20) << 16);
-			buf_len = IWL_GET_BITS(bd->pa[index], tb2_len);
-		} else {
-			dma_addr = le32_to_cpu(bd->pa[index].tb1_addr);
-			buf_len = IWL_GET_BITS(bd->pa[index], tb1_len);
-		}
 
-		pci_unmap_single(priv->pci_dev, dma_addr, buf_len,
-				 PCI_DMA_TODEVICE);
+		pci_unmap_single(priv->pci_dev, iwl_get_addr(bd, 0),
+				 iwl_get_len(bd, 0), PCI_DMA_TODEVICE);
 		nfreed++;
 	}
 }
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-helpers.h	2008-09-11 05:22:48.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-helpers.h	2008-10-06 17:55:45.000000000 +0200
@@ -159,11 +159,6 @@ static inline unsigned long elapsed_jiff
 	return end + (MAX_JIFFY_OFFSET - start) + 1;
 }
 
-static inline u8 iwl_get_dma_hi_address(dma_addr_t addr)
-{
-	return sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0;
-}
-
 /**
  * iwl_queue_inc_wrap - increment queue index, wrap back to beginning
  * @index -- current index
--- everything.orig/drivers/net/wireless/iwlwifi/iwl-5000.c	2008-09-11 23:03:03.000000000 +0200
+++ everything/drivers/net/wireless/iwlwifi/iwl-5000.c	2008-10-06 18:04:24.000000000 +0200
@@ -535,8 +535,7 @@ static int iwl5000_load_section(struct i
 
 	iwl_write_direct32(priv,
 		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
-		(iwl_get_dma_hi_address(phy_addr)
-			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
+		(((u64)phy_addr >> 32) << FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
 
 	iwl_write_direct32(priv,
 		FH_TCSR_CHNL_TX_BUF_STS_REG(FH_SRVC_CHNL),


