Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4785 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbYJNTfT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Oct 2008 15:35:19 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/9] iwlwifi: fix TX cmd dma unmapping
Date: Tue, 14 Oct 2008 12:32:48 -0700
Message-Id: <1224012769-8920-9-git-send-email-reinette.chatre@intel.com> (sfid-20081014_213526_323512_324CC152)
In-Reply-To: <1224012769-8920-8-git-send-email-reinette.chatre@intel.com>
References: <>
 <1224012769-8920-1-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-2-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-3-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-4-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-5-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-6-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-7-git-send-email-reinette.chatre@intel.com>
 <1224012769-8920-8-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch:
1. fixes command DMA unmapping, this might be visible only
	on platforms where DMA unmapping is no noop such as PPC64 (not tested)
2. attaches correctly high memory part of the host command buffer
3. changes structure of TFD TB
	instead of describing transmit buffer (TB) tuple it describes single
	TB and makes code more readable on price of one unaligned access
4. eliminates using of IWL_GET/SET_BITs for TFD handling
5. renames TFD structures to mach the HW spec
6. reduces iwl_tx_info size by reserving first TB to the host command

This patch should not have any visible effect on x86 32

This patch is rework of
iwlwifi: fix DMA code and bugs from
Johannes Berg <johannes@sipsolutions.net>

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Zhu Yi <yi.zhu@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |  100 ++++--------
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-helpers.h |    5 -
 drivers/net/wireless/iwlwifi/iwl-tx.c      |  231 +++++++++++++++-------------
 5 files changed, 163 insertions(+), 184 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index f4793a6..b66dd09 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -822,94 +822,62 @@ enum {
 #define IWL49_NUM_QUEUES	16
 #define IWL49_NUM_AMPDU_QUEUES	8
 
+#define IWL_TX_DMA_MASK        (DMA_BIT_MASK(36) & ~0x3)
+#define IWL_NUM_OF_TBS		20
+
+static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
+{
+	return (sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0) & 0xF;
+}
 /**
- * struct iwl_tfd_frame_data
+ * struct iwl_tfd_tb transmit buffer descriptor within transmit frame descriptor
  *
- * Describes up to 2 buffers containing (contiguous) portions of a Tx frame.
- * Each buffer must be on dword boundary.
- * Up to 10 iwl_tfd_frame_data structures, describing up to 20 buffers,
- * may be filled within a TFD (iwl_tfd_frame).
+ * This structure contains dma address and length of transmission address
  *
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
+ * @lo: low [31:0] portion of the dma address of TX buffer
+ * 	every even is unaligned on 16 bit boundary
+ * @hi_n_len 0-3 [35:32] portion of dma
+ *	     4-16 length of the tx buffer
  */
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
+struct iwl_tfd_tb {
+	__le32 lo;
+	__le16 hi_n_len;
+} __attribute__((packed));
 
 /**
- * struct iwl_tfd_frame
+ * struct iwl_tfd
  *
  * Transmit Frame Descriptor (TFD)
  *
- * 4965 supports up to 16 Tx queues resident in host DRAM.
+ * @ __reserved1[3] reserved
+ * @ num_tbs 0-5 number of active tbs
+ * 	     6-7 padding (not used)
+ * @ tbs[20]	transmit frame buffer descriptors
+ * @ __pad 	padding
+ *
  * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
  * Both driver and device share these circular buffers, each of which must be
- * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes for 4965.
+ * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes
  *
  * Driver must indicate the physical address of the base of each
- * circular buffer via the 4965's FH_MEM_CBBC_QUEUE registers.
+ * circular buffer via the FH_MEM_CBBC_QUEUE registers.
  *
  * Each TFD contains pointer/size information for up to 20 data buffers
  * in host DRAM.  These buffers collectively contain the (one) frame described
  * by the TFD.  Each buffer must be a single contiguous block of memory within
  * itself, but buffers may be scattered in host DRAM.  Each buffer has max size
- * of (4K - 4).  The 4965 concatenates all of a TFD's buffers into a single
+ * of (4K - 4).  The concatenates all of a TFD's buffers into a single
  * Tx frame, up to 8 KBytes in size.
  *
- * Bit fields in the control dword (val0):
- * 31-30: # dwords (0-3) of padding required at end of frame for 16-byte bound
- *    29: reserved
- * 28-24: # Transmit Buffer Descriptors in TFD
- * 23- 0: reserved
- *
  * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
+ *
+ * Bit fields in the control dword (val0):
  */
-struct iwl_tfd_frame {
-	__le32 val0;
-	/* __le32 rsvd1:24; */
-	/* __le32 num_tbs:5; */
-#define IWL_num_tbs_POS 24
-#define IWL_num_tbs_LEN 5
-#define IWL_num_tbs_SYM val0
-	/* __le32 rsvd2:1; */
-	/* __le32 padding:2; */
-	struct iwl_tfd_frame_data pa[10];
-	__le32 reserved;
+struct iwl_tfd {
+	u8 __reserved1[3];
+	u8 num_tbs;
+	struct iwl_tfd_tb tbs[IWL_NUM_OF_TBS];
+	__le32 __pad;
 } __attribute__ ((packed));
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 0290c03..da7cef0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -536,7 +536,7 @@ static int iwl5000_load_section(struct iwl_priv *priv,
 
 	iwl_write_direct32(priv,
 		FH_TFDIB_CTRL1_REG(FH_SRVC_CHNL),
-		(iwl_get_dma_hi_address(phy_addr)
+		(iwl_get_dma_hi_addr(phy_addr)
 			<< FH_MEM_TFDIB_REG1_ADDR_BITSHIFT) | byte_cnt);
 
 	iwl_write_direct32(priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 8f1e37a..764eeed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -112,11 +112,9 @@ struct iwl_queue {
 				* space less than this */
 } __attribute__ ((packed));
 
-#define MAX_NUM_OF_TBS          (20)
-
 /* One for each TFD */
 struct iwl_tx_info {
-	struct sk_buff *skb[MAX_NUM_OF_TBS];
+	struct sk_buff *skb[IWL_NUM_OF_TBS - 1];
 };
 
 /**
@@ -134,7 +132,7 @@ struct iwl_tx_info {
  */
 struct iwl_tx_queue {
 	struct iwl_queue q;
-	struct iwl_tfd_frame *bd;
+	struct iwl_tfd *tfds;
 	struct iwl_cmd *cmd[TFD_TX_CMD_SLOTS];
 	struct iwl_tx_info *txb;
 	u8 need_update;
@@ -253,7 +251,8 @@ struct iwl_cmd_meta {
 	/* The CMD_SIZE_HUGE flag bit indicates that the command
 	 * structure is stored at the end of the shared queue memory. */
 	u32 flags;
-
+	DECLARE_PCI_UNMAP_ADDR(mapping)
+	DECLARE_PCI_UNMAP_LEN(len)
 } __attribute__ ((packed));
 
 #define IWL_CMD_MAX_PAYLOAD 320
diff --git a/drivers/net/wireless/iwlwifi/iwl-helpers.h b/drivers/net/wireless/iwlwifi/iwl-helpers.h
index 41eed67..029d19c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-helpers.h
+++ b/drivers/net/wireless/iwlwifi/iwl-helpers.h
@@ -159,11 +159,6 @@ static inline unsigned long elapsed_jiffies(unsigned long start,
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
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 61e8e12..2fadb8f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -56,92 +56,112 @@ static const u16 default_tid_to_tx_fifo[] = {
 	IWL_TX_FIFO_AC3
 };
 
+static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+
+	dma_addr_t addr = get_unaligned_le32(&tb->lo);
+	if (sizeof(dma_addr_t) > sizeof(u32))
+		addr |=
+		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
+
+	return addr;
+}
+
+static inline u16 iwl_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+
+	return le16_to_cpu(tb->hi_n_len) >> 4;
+}
+
+static inline void iwl_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
+				  dma_addr_t addr, u16 len)
+{
+	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
+	u16 hi_n_len = len << 4;
+
+	put_unaligned_le32(addr, &tb->lo);
+	if (sizeof(dma_addr_t) > sizeof(u32))
+		hi_n_len |= ((addr >> 16) >> 16) & 0xF;
+
+	tb->hi_n_len = cpu_to_le16(hi_n_len);
+
+	tfd->num_tbs = idx + 1;
+}
+
+static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
+{
+	return tfd->num_tbs & 0x1f;
+}
 
 /**
  * iwl_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
+ * @priv - driver private data
+ * @txq - tx queue
  *
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-static int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+static void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
-	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
-	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
+	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)&txq->tfds[0];
+	struct iwl_tfd *tfd;
 	struct pci_dev *dev = priv->pci_dev;
+	int index = txq->q.read_ptr;
 	int i;
-	int counter = 0;
-	int index, is_odd;
+	int num_tbs;
+
+	tfd = &tfd_tmp[index];
 
 	/* Sanity check on number of chunks */
-	counter = IWL_GET_BITS(*bd, num_tbs);
-	if (counter > MAX_NUM_OF_TBS) {
-		IWL_ERROR("Too many chunks: %i\n", counter);
+	num_tbs = iwl_tfd_get_num_tbs(tfd);
+
+	if (num_tbs >= IWL_NUM_OF_TBS) {
+		IWL_ERROR("Too many chunks: %i\n", num_tbs);
 		/* @todo issue fatal error, it is quite serious situation */
-		return 0;
+		return;
 	}
 
-	/* Unmap chunks, if any.
-	 * TFD info for odd chunks is different format than for even chunks. */
-	for (i = 0; i < counter; i++) {
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
+	/* Unmap tx_cmd */
+	if (num_tbs)
+		pci_unmap_single(dev,
+				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
+				pci_unmap_len(&txq->cmd[index]->meta, len),
 				PCI_DMA_TODEVICE);
 
-		else if (i > 0)
-			pci_unmap_single(dev,
-					 le32_to_cpu(bd->pa[index].tb1_addr),
-					 IWL_GET_BITS(bd->pa[index], tb1_len),
-					 PCI_DMA_TODEVICE);
-
-		/* Free SKB, if any, for this chunk */
-		if (txq->txb[txq->q.read_ptr].skb[i]) {
-			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[i];
+	/* Unmap chunks, if any. */
+	for (i = 1; i < num_tbs; i++) {
+		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
+				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
 
-			dev_kfree_skb(skb);
-			txq->txb[txq->q.read_ptr].skb[i] = NULL;
+		if (txq->txb) {
+			dev_kfree_skb(txq->txb[txq->q.read_ptr].skb[i - 1]);
+			txq->txb[txq->q.read_ptr].skb[i - 1] = NULL;
 		}
 	}
-	return 0;
 }
 
-static int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
-				 dma_addr_t addr, u16 len)
+static int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+					struct iwl_tfd *tfd,
+					dma_addr_t addr, u16 len)
 {
-	int index, is_odd;
-	struct iwl_tfd_frame *tfd = ptr;
-	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
+
+	u32 num_tbs = iwl_tfd_get_num_tbs(tfd);
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
-	if (num_tbs >= MAX_NUM_OF_TBS) {
+	if (num_tbs >= IWL_NUM_OF_TBS) {
 		IWL_ERROR("Error can not send more than %d chunks\n",
-			  MAX_NUM_OF_TBS);
+			  IWL_NUM_OF_TBS);
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
+	BUG_ON(addr & ~DMA_BIT_MASK(36));
+	if (unlikely(addr & ~IWL_TX_DMA_MASK))
+		IWL_ERROR("Unaligned address = %llx\n",
+			  (unsigned long long)addr);
 
-	IWL_SET_BITS(*tfd, num_tbs, num_tbs + 1);
+	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
 
 	return 0;
 }
@@ -224,8 +244,8 @@ static void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl_tfd_frame) *
-				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
+		pci_free_consistent(dev, sizeof(struct iwl_tfd) *
+				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
 	kfree(txq->txb);
@@ -263,8 +283,8 @@ static void iwl_cmd_queue_free(struct iwl_priv *priv)
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl_tfd_frame) *
-				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
+		pci_free_consistent(dev, sizeof(struct iwl_tfd) *
+				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
 
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
@@ -364,13 +384,13 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->bd = pci_alloc_consistent(dev,
-			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
+	txq->tfds = pci_alloc_consistent(dev,
+			sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
 
-	if (!txq->bd) {
+	if (!txq->tfds) {
 		IWL_ERROR("pci_alloc_consistent(%zd) failed\n",
-			  sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX);
+			  sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
 	txq->q.id = id;
@@ -394,15 +414,15 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
 static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl_tx_queue *txq)
 {
-	int rc;
+	int ret;
 	unsigned long flags;
 	int txq_id = txq->q.id;
 
 	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
 		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
+		return ret;
 	}
 
 	/* Circular buffer (TFD queue in DRAM) physical base address */
@@ -410,10 +430,10 @@ static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
 			     txq->q.dma_addr >> 8);
 
 	/* Enable DMA channel, using same id as for TFD queue */
-	iwl_write_direct32(
-		priv, FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
+	iwl_write_direct32(priv, FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
 		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL);
+
 	iwl_release_nic_access(priv);
 	spin_unlock_irqrestore(&priv->lock, flags);
 
@@ -788,7 +808,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
-	struct iwl_tfd_frame *tfd;
+	struct iwl_tfd *tfd;
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
 	struct iwl_cmd *out_cmd;
@@ -884,7 +904,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Set up first empty TFD within this queue's circular TFD buffer */
-	tfd = &txq->bd[q->write_ptr];
+	tfd = &txq->tfds[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
@@ -933,12 +953,14 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = pci_map_single(priv->pci_dev, out_cmd,
-				sizeof(struct iwl_cmd), PCI_DMA_TODEVICE);
-	txcmd_phys += offsetof(struct iwl_cmd, hdr);
-
+	txcmd_phys = pci_map_single(priv->pci_dev,
+				    out_cmd, sizeof(struct iwl_cmd),
+				    PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
+	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
+	txcmd_phys += offsetof(struct iwl_cmd, hdr);
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, txcmd_phys, len);
 
 	if (info->control.hw_key)
@@ -971,7 +993,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 		offsetof(struct iwl_tx_cmd, scratch);
 	tx_cmd->dram_lsb_ptr = cpu_to_le32(scratch_phys);
-	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_address(scratch_phys);
+	tx_cmd->dram_msb_ptr = iwl_get_dma_hi_addr(scratch_phys);
 
 	if (!ieee80211_has_morefrags(hdr->frame_control)) {
 		txq->need_update = 1;
@@ -1032,7 +1054,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
-	struct iwl_tfd_frame *tfd;
+	struct iwl_tfd *tfd;
 	struct iwl_cmd *out_cmd;
 	dma_addr_t phys_addr;
 	unsigned long flags;
@@ -1061,7 +1083,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	tfd = &txq->bd[q->write_ptr];
+	tfd = &txq->tfds[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 
 
@@ -1082,9 +1104,13 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 	len = (idx == TFD_CMD_SLOTS) ?
 			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
-	phys_addr = pci_map_single(priv->pci_dev, out_cmd, len,
-						PCI_DMA_TODEVICE);
+
+	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
+				   len, PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
+	pci_unmap_len_set(&out_cmd->meta, len, len);
 	phys_addr += offsetof(struct iwl_cmd, hdr);
+
 	iwl_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
@@ -1134,8 +1160,9 @@ int iwl_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 		return 0;
 	}
 
-	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	for (index = iwl_queue_inc_wrap(index, q->n_bd);
+	     q->read_ptr != index;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		tx_info = &txq->txb[txq->q.read_ptr];
 		ieee80211_tx_status_irqsafe(priv->hw, tx_info->skb[0]);
@@ -1159,44 +1186,34 @@ EXPORT_SYMBOL(iwl_tx_queue_reclaim);
  * need to be reclaimed. As result, some free space forms.  If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
-static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
+static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
+				   int idx, int cmd_idx)
 {
 	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
-	struct iwl_tfd_frame *bd = &txq->bd[index];
-	dma_addr_t dma_addr;
-	int is_odd, buf_len;
 	int nfreed = 0;
 
-	if ((index >= q->n_bd) || (iwl_queue_used(q, index) == 0)) {
+	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
 		IWL_ERROR("Read index for DMA queue txq id (%d), index %d, "
 			  "is out of range [0-%d] %d %d.\n", txq_id,
-			  index, q->n_bd, q->write_ptr, q->read_ptr);
+			  idx, q->n_bd, q->write_ptr, q->read_ptr);
 		return;
 	}
 
-	for (index = iwl_queue_inc_wrap(index, q->n_bd); q->read_ptr != index;
-		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
+	pci_unmap_single(priv->pci_dev,
+		pci_unmap_addr(&txq->cmd[cmd_idx]->meta, mapping),
+		pci_unmap_len(&txq->cmd[cmd_idx]->meta, len),
+		PCI_DMA_TODEVICE);
+
+	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
-		if (nfreed > 1) {
-			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
+		if (nfreed++ > 0) {
+			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", idx,
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
-		nfreed++;
 	}
 }
 
@@ -1236,7 +1253,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
 		rxb->skb = NULL;
 
-	iwl_hcmd_queue_reclaim(priv, txq_id, index);
+	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
 
 	if (!(cmd->meta.flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-- 
1.5.4.3

