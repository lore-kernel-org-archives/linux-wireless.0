Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54726 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751469AbcIOSLp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:11:45 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:10 +0300
Message-Id: <20160915181131.32213-4-luca@coelho.fi> (sfid-20160915_201153_608018_CF36A846)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 04/25] iwlwifi: pcie: introduce new tfd and tb formats
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

New hardware supports bigger TFDs and TBs.
Introduce the new formats and adjust defines and code
relying on old format.
Changing the actual TFD allocation is trickier and
deferred to the next patch.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-fh.h        | 50 +++++++++++++++++-----
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     |  1 +
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     |  4 --
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  4 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 16 ++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 20 ++++-----
 6 files changed, 64 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
index dd75ea7..98d2ff2 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-fh.h
@@ -643,6 +643,7 @@ struct iwl_rb_status {
 #define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
 #define IWL_TX_DMA_MASK        DMA_BIT_MASK(36)
 #define IWL_NUM_OF_TBS		20
+#define IWL_TFH_NUM_TBS		25
 
 static inline u8 iwl_get_dma_hi_addr(dma_addr_t addr)
 {
@@ -664,25 +665,29 @@ struct iwl_tfd_tb {
 } __packed;
 
 /**
- * struct iwl_tfd
+ * struct iwl_tfh_tb transmit buffer descriptor within transmit frame descriptor
  *
- * Transmit Frame Descriptor (TFD)
- *
- * @ __reserved1[3] reserved
- * @ num_tbs 0-4 number of active tbs
- *	     5   reserved
- * 	     6-7 padding (not used)
- * @ tbs[20]	transmit frame buffer descriptors
- * @ __pad 	padding
+ * This structure contains dma address and length of transmission address
  *
+ * @tb_len length of the tx buffer
+ * @addr 64 bits dma address
+ */
+struct iwl_tfh_tb {
+	__le16 tb_len;
+	__le64 addr;
+} __packed;
+
+/**
  * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
  * Both driver and device share these circular buffers, each of which must be
- * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes
+ * contiguous 256 TFDs.
+ * For pre a000 HW it is 256 x 128 bytes-per-TFD = 32 KBytes
+ * For a000 HW and on it is 256 x 256 bytes-per-TFD = 65 KBytes
  *
  * Driver must indicate the physical address of the base of each
  * circular buffer via the FH_MEM_CBBC_QUEUE registers.
  *
- * Each TFD contains pointer/size information for up to 20 data buffers
+ * Each TFD contains pointer/size information for up to 20 / 25 data buffers
  * in host DRAM.  These buffers collectively contain the (one) frame described
  * by the TFD.  Each buffer must be a single contiguous block of memory within
  * itself, but buffers may be scattered in host DRAM.  Each buffer has max size
@@ -691,6 +696,16 @@ struct iwl_tfd_tb {
  *
  * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
  */
+
+/**
+ * struct iwl_tfd - Transmit Frame Descriptor (TFD)
+ * @ __reserved1[3] reserved
+ * @ num_tbs 0-4 number of active tbs
+ *	     5   reserved
+ *	     6-7 padding (not used)
+ * @ tbs[20]	transmit frame buffer descriptors
+ * @ __pad	padding
+ */
 struct iwl_tfd {
 	u8 __reserved1[3];
 	u8 num_tbs;
@@ -698,6 +713,19 @@ struct iwl_tfd {
 	__le32 __pad;
 } __packed;
 
+/**
+ * struct iwl_tfh_tfd - Transmit Frame Descriptor (TFD)
+ * @ num_tbs 0-4 number of active tbs
+ *	     5 -15   reserved
+ * @ tbs[25]	transmit frame buffer descriptors
+ * @ __pad	padding
+ */
+struct iwl_tfh_tfd {
+	__le16 num_tbs;
+	struct iwl_tfh_tb tbs[IWL_TFH_NUM_TBS];
+	__le32 __pad;
+} __packed;
+
 /* Keep Warm Size */
 #define IWL_KW_SIZE 0x1000	/* 4k */
 
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
index 6069a9f..b0bd67c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.c
@@ -65,6 +65,7 @@
 
 #include "iwl-trans.h"
 #include "iwl-drv.h"
+#include "iwl-fh.h"
 
 struct iwl_trans *iwl_trans_alloc(unsigned int priv_size,
 				  struct device *dev,
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
index 5535e22..883cb487b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-trans.h
@@ -262,8 +262,6 @@ static inline u32 iwl_rx_packet_payload_len(const struct iwl_rx_packet *pkt)
  *	(i.e. mark it as non-idle).
  * @CMD_WANT_ASYNC_CALLBACK: the op_mode's async callback function must be
  *	called after this command completes. Valid only with CMD_ASYNC.
- * @CMD_TB_BITMAP_POS: Position of the first bit for the TB bitmap. We need to
- *	check that we leave enough room for the TBs bitmap which needs 20 bits.
  */
 enum CMD_MODE {
 	CMD_ASYNC		= BIT(0),
@@ -274,8 +272,6 @@ enum CMD_MODE {
 	CMD_MAKE_TRANS_IDLE	= BIT(5),
 	CMD_WAKE_UP_TRANS	= BIT(6),
 	CMD_WANT_ASYNC_CALLBACK	= BIT(7),
-
-	CMD_TB_BITMAP_POS	= 11,
 };
 
 #define DEF_CMD_PAYLOAD_SIZE 320
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
index 11e347d..975900a 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/internal.h
@@ -49,7 +49,7 @@
  * be needed for potential data in the SKB's head. The remaining ones can
  * be used for frags.
  */
-#define IWL_PCIE_MAX_FRAGS (IWL_NUM_OF_TBS - 3)
+#define IWL_PCIE_MAX_FRAGS(x) (x->max_tbs - 3)
 
 /*
  * RX related structures and functions
@@ -192,6 +192,7 @@ struct iwl_cmd_meta {
 	/* only for SYNC commands, iff the reply skb is wanted */
 	struct iwl_host_cmd *source;
 	u32 flags;
+	u32 tbs;
 };
 
 /*
@@ -391,6 +392,7 @@ struct iwl_trans_pcie {
 	unsigned int cmd_q_wdg_timeout;
 	u8 n_no_reclaim_cmds;
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
+	u8 max_tbs;
 
 	enum iwl_amsdu_size rx_buf_size;
 	bool bc_table_dword;
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
index 2f46eed..0c2ccbe 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/trans.c
@@ -2437,12 +2437,14 @@ err:
 }
 #endif /*CONFIG_IWLWIFI_DEBUGFS */
 
-static u32 iwl_trans_pcie_get_cmdlen(struct iwl_tfd *tfd)
+static u32 iwl_trans_pcie_get_cmdlen(struct iwl_trans *trans,
+				     struct iwl_tfd *tfd)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 cmdlen = 0;
 	int i;
 
-	for (i = 0; i < IWL_NUM_OF_TBS; i++)
+	for (i = 0; i < trans_pcie->max_tbs; i++)
 		cmdlen += iwl_pcie_tfd_tb_get_len(tfd, i);
 
 	return cmdlen;
@@ -2731,7 +2733,7 @@ static struct iwl_trans_dump_data
 		u8 idx = get_cmd_index(&cmdq->q, ptr);
 		u32 caplen, cmdlen;
 
-		cmdlen = iwl_trans_pcie_get_cmdlen(&cmdq->tfds[ptr]);
+		cmdlen = iwl_trans_pcie_get_cmdlen(trans, &cmdq->tfds[ptr]);
 		caplen = min_t(u32, TFD_MAX_PAYLOAD_SIZE, cmdlen);
 
 		if (cmdlen) {
@@ -2839,8 +2841,6 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	if (!trans)
 		return ERR_PTR(-ENOMEM);
 
-	trans->max_skb_frags = IWL_PCIE_MAX_FRAGS;
-
 	trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 
 	trans_pcie->trans = trans;
@@ -2874,6 +2874,12 @@ struct iwl_trans *iwl_trans_pcie_alloc(struct pci_dev *pdev,
 	else
 		addr_size = 36;
 
+	if (cfg->use_tfh)
+		trans_pcie->max_tbs = IWL_TFH_NUM_TBS;
+	else
+		trans_pcie->max_tbs = IWL_NUM_OF_TBS;
+	trans->max_skb_frags = IWL_PCIE_MAX_FRAGS(trans_pcie);
+
 	pci_set_master(pdev);
 
 	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(addr_size));
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
index 9636dc8..1c46f14 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/tx.c
@@ -348,13 +348,13 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 			       struct iwl_cmd_meta *meta,
 			       struct iwl_tfd *tfd)
 {
-	int i;
-	int num_tbs;
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
+	int i, num_tbs;
 
 	/* Sanity check on number of chunks */
 	num_tbs = iwl_pcie_tfd_get_num_tbs(tfd);
 
-	if (num_tbs >= IWL_NUM_OF_TBS) {
+	if (num_tbs >= trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Too many chunks: %i\n", num_tbs);
 		/* @todo issue fatal error, it is quite serious situation */
 		return;
@@ -363,7 +363,7 @@ static void iwl_pcie_tfd_unmap(struct iwl_trans *trans,
 	/* first TB is never freed - it's the bidirectional DMA data */
 
 	for (i = 1; i < num_tbs; i++) {
-		if (meta->flags & BIT(i + CMD_TB_BITMAP_POS))
+		if (meta->tbs & BIT(i))
 			dma_unmap_page(trans->dev,
 				       iwl_pcie_tfd_tb_get_addr(tfd, i),
 				       iwl_pcie_tfd_tb_get_len(tfd, i),
@@ -423,6 +423,7 @@ static void iwl_pcie_txq_free_tfd(struct iwl_trans *trans, struct iwl_txq *txq)
 static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 				  dma_addr_t addr, u16 len, bool reset)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_queue *q;
 	struct iwl_tfd *tfd, *tfd_tmp;
 	u32 num_tbs;
@@ -437,9 +438,9 @@ static int iwl_pcie_txq_build_tfd(struct iwl_trans *trans, struct iwl_txq *txq,
 	num_tbs = iwl_pcie_tfd_get_num_tbs(tfd);
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
-	if (num_tbs >= IWL_NUM_OF_TBS) {
+	if (num_tbs >= trans_pcie->max_tbs) {
 		IWL_ERR(trans, "Error can not send more than %d chunks\n",
-			IWL_NUM_OF_TBS);
+			trans_pcie->max_tbs);
 		return -EINVAL;
 	}
 
@@ -1640,8 +1641,7 @@ static int iwl_pcie_enqueue_hcmd(struct iwl_trans *trans,
 		iwl_pcie_txq_build_tfd(trans, txq, phys_addr, cmdlen[i], false);
 	}
 
-	BUILD_BUG_ON(IWL_NUM_OF_TBS + CMD_TB_BITMAP_POS >
-		     sizeof(out_meta->flags) * BITS_PER_BYTE);
+	BUILD_BUG_ON(IWL_TFH_NUM_TBS > sizeof(out_meta->tbs) * BITS_PER_BYTE);
 	out_meta->flags = cmd->flags;
 	if (WARN_ON_ONCE(txq->entries[idx].free_buf))
 		kzfree(txq->entries[idx].free_buf);
@@ -1953,7 +1953,7 @@ static int iwl_fill_data_tbs(struct iwl_trans *trans, struct sk_buff *skb,
 		tb_idx = iwl_pcie_txq_build_tfd(trans, txq, tb_phys,
 						skb_frag_size(frag), false);
 
-		out_meta->flags |= BIT(tb_idx + CMD_TB_BITMAP_POS);
+		out_meta->tbs |= BIT(tb_idx);
 	}
 
 	trace_iwlwifi_dev_tx(trans->dev, skb,
@@ -2247,7 +2247,7 @@ int iwl_trans_pcie_tx(struct iwl_trans *trans, struct sk_buff *skb,
 	}
 
 	if (skb_is_nonlinear(skb) &&
-	    skb_shinfo(skb)->nr_frags > IWL_PCIE_MAX_FRAGS &&
+	    skb_shinfo(skb)->nr_frags > IWL_PCIE_MAX_FRAGS(trans_pcie) &&
 	    __skb_linearize(skb))
 		return -ENOMEM;
 
-- 
2.9.3
