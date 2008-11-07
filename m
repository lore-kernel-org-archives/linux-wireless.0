Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:61438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751563AbYKGR6P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2008 12:58:15 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	"Winkler, Tomas" <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/13] iwlwifi: move rx queue read pointer into rxq
Date: Fri,  7 Nov 2008 09:58:39 -0800
Message-Id: <1226080726-24860-7-git-send-email-reinette.chatre@intel.com> (sfid-20081107_185824_656208_F5386C77)
In-Reply-To: <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
References: <>
 <1226080726-24860-1-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-2-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-3-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-4-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-5-git-send-email-reinette.chatre@intel.com>
 <1226080726-24860-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Winkler, Tomas <tomas.winkler@intel.com>

This patch moves rx status/read registers into
iwl_rx_queue structures. This solution is more memory
hungry but is more structured and provides needed RX/TX
separation

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   27 --------------------------
 drivers/net/wireless/iwlwifi/iwl-4965.c    |    9 --------
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |   29 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c    |    9 --------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.h    |    1 -
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    9 +++----
 drivers/net/wireless/iwlwifi/iwl-fh.h      |   16 +++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-rx.c      |   21 ++++++++++++++++---
 9 files changed, 38 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 9da7c7b..94ae1a8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -927,33 +927,6 @@ struct iwl4965_schedq_bc_tbl {
  */
 struct iwl4965_shared {
 	struct iwl4965_schedq_bc_tbl queues_bc_tbls[IWL49_NUM_QUEUES];
-	__le32 rb_closed;
-
-	/* __le32 rb_closed_stts_rb_num:12; */
-#define IWL_rb_closed_stts_rb_num_POS 0
-#define IWL_rb_closed_stts_rb_num_LEN 12
-#define IWL_rb_closed_stts_rb_num_SYM rb_closed
-	/* __le32 rsrv1:4; */
-	/* __le32 rb_closed_stts_rx_frame_num:12; */
-#define IWL_rb_closed_stts_rx_frame_num_POS 16
-#define IWL_rb_closed_stts_rx_frame_num_LEN 12
-#define IWL_rb_closed_stts_rx_frame_num_SYM rb_closed
-	/* __le32 rsrv2:4; */
-
-	__le32 frm_finished;
-	/* __le32 frame_finished_stts_rb_num:12; */
-#define IWL_frame_finished_stts_rb_num_POS 0
-#define IWL_frame_finished_stts_rb_num_LEN 12
-#define IWL_frame_finished_stts_rb_num_SYM frm_finished
-	/* __le32 rsrv3:4; */
-	/* __le32 frame_finished_stts_rx_frame_num:12; */
-#define IWL_frame_finished_stts_rx_frame_num_POS 16
-#define IWL_frame_finished_stts_rx_frame_num_LEN 12
-#define IWL_frame_finished_stts_rx_frame_num_SYM frm_finished
-	/* __le32 rsrv4:4; */
-
-	__le32 padding1;  /* so that allocation will be aligned to 16B */
-	__le32 padding2;
 } __attribute__ ((packed));
 
 #endif /* __iwl4965_4965_hw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 157cad4..017e5ea 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -1631,12 +1631,6 @@ static int iwl4965_hw_channel_switch(struct iwl_priv *priv, u16 channel)
 }
 #endif
 
-static int iwl4965_shared_mem_rx_idx(struct iwl_priv *priv)
-{
-	struct iwl4965_shared *s = priv->shared_virt;
-	return le32_to_cpu(s->rb_closed) & 0xFFF;
-}
-
 static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
 {
 	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
@@ -1647,8 +1641,6 @@ static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
 
 	memset(priv->shared_virt, 0, sizeof(struct iwl4965_shared));
 
-	priv->rb_closed_offset = offsetof(struct iwl4965_shared, rb_closed);
-
 	return 0;
 }
 
@@ -2306,7 +2298,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.set_hw_params = iwl4965_hw_set_hw_params,
 	.alloc_shared_mem = iwl4965_alloc_shared_mem,
 	.free_shared_mem = iwl4965_free_shared_mem,
-	.shared_mem_rx_idx = iwl4965_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
 	.txq_set_sched = iwl4965_txq_set_sched,
 	.txq_agg_enable = iwl4965_txq_agg_enable,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 12c7404..8f9edc7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -96,38 +96,9 @@ struct iwl5000_schedq_bc_tbl {
 
 /**
  * struct iwl5000_shared
- * @rb_closed
- * 	address is provided to FH_RSCSR_CHNL0_STTS_WPTR_REG
  */
 struct iwl5000_shared {
 	struct iwl5000_schedq_bc_tbl queues_bc_tbls[IWL50_NUM_QUEUES];
-	__le32 rb_closed;
-
-	/* __le32 rb_closed_stts_rb_num:12; */
-#define IWL_rb_closed_stts_rb_num_POS 0
-#define IWL_rb_closed_stts_rb_num_LEN 12
-#define IWL_rb_closed_stts_rb_num_SYM rb_closed
-	/* __le32 rsrv1:4; */
-	/* __le32 rb_closed_stts_rx_frame_num:12; */
-#define IWL_rb_closed_stts_rx_frame_num_POS 16
-#define IWL_rb_closed_stts_rx_frame_num_LEN 12
-#define IWL_rb_closed_stts_rx_frame_num_SYM rb_closed
-	/* __le32 rsrv2:4; */
-
-	__le32 frm_finished;
-	/* __le32 frame_finished_stts_rb_num:12; */
-#define IWL_frame_finished_stts_rb_num_POS 0
-#define IWL_frame_finished_stts_rb_num_LEN 12
-#define IWL_frame_finished_stts_rb_num_SYM frm_finished
-	/* __le32 rsrv3:4; */
-	/* __le32 frame_finished_stts_rx_frame_num:12; */
-#define IWL_frame_finished_stts_rx_frame_num_POS 16
-#define IWL_frame_finished_stts_rx_frame_num_LEN 12
-#define IWL_frame_finished_stts_rx_frame_num_SYM frm_finished
-	/* __le32 rsrv4:4; */
-
-	__le32 padding1;  /* so that allocation will be aligned to 16B */
-	__le32 padding2;
 } __attribute__ ((packed));
 
 #endif /* __iwl_5000_hw_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 31e62a8..e81000c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -863,8 +863,6 @@ static int iwl5000_alloc_shared_mem(struct iwl_priv *priv)
 
 	memset(priv->shared_virt, 0, sizeof(struct iwl5000_shared));
 
-	priv->rb_closed_offset = offsetof(struct iwl5000_shared, rb_closed);
-
 	return 0;
 }
 
@@ -877,12 +875,6 @@ static void iwl5000_free_shared_mem(struct iwl_priv *priv)
 				    priv->shared_phys);
 }
 
-static int iwl5000_shared_mem_rx_idx(struct iwl_priv *priv)
-{
-	struct iwl5000_shared *s = priv->shared_virt;
-	return le32_to_cpu(s->rb_closed) & 0xFFF;
-}
-
 /**
  * iwl5000_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
@@ -1460,7 +1452,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
 	.alloc_shared_mem = iwl5000_alloc_shared_mem,
 	.free_shared_mem = iwl5000_free_shared_mem,
-	.shared_mem_rx_idx = iwl5000_shared_mem_rx_idx,
 	.txq_update_byte_cnt_tbl = iwl5000_txq_update_byte_cnt_tbl,
 	.txq_inval_byte_cnt_tbl = iwl5000_txq_inval_byte_cnt_tbl,
 	.txq_set_sched = iwl5000_txq_set_sched,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2395a3e..1adda56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1360,7 +1360,7 @@ void iwl_rx_handle(struct iwl_priv *priv)
 
 	/* uCode's read index (stored in shared DRAM) indicates the last Rx
 	 * buffer that the driver may process (last buffer filled by ucode). */
-	r = priv->cfg->ops->lib->shared_mem_rx_idx(priv);
+	r = le16_to_cpu(rxq->rb_stts->closed_rb_num) &  0x0FFF;
 	i = rxq->read;
 
 	/* Rx interrupt, but nothing sent from uCode */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 10f07f6..1dca9d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -105,7 +105,6 @@ struct iwl_lib_ops {
 	/* ucode shared memory */
 	int (*alloc_shared_mem)(struct iwl_priv *priv);
 	void (*free_shared_mem)(struct iwl_priv *priv);
-	int (*shared_mem_rx_idx)(struct iwl_priv *priv);
 	/* Handling TX */
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
 					struct iwl_tx_queue *txq,
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index eb396f2..f4e81a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -300,7 +300,6 @@ struct iwl_host_cmd {
 
 /**
  * struct iwl_rx_queue - Rx queue
- * @processed: Internal index to last handled Rx packet
  * @read: Shared index to newest available Rx buffer
  * @write: Shared index to oldest written Rx packet
  * @free_count: Number of pre-allocated buffers in rx_free
@@ -315,13 +314,14 @@ struct iwl_rx_queue {
 	dma_addr_t dma_addr;
 	struct iwl_rx_mem_buffer pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
 	struct iwl_rx_mem_buffer *queue[RX_QUEUE_SIZE];
-	u32 processed;
 	u32 read;
 	u32 write;
 	u32 free_count;
 	struct list_head rx_free;
 	struct list_head rx_used;
 	int need_update;
+	struct iwl_rb_status *rb_stts;
+	dma_addr_t rb_stts_dma;
 	spinlock_t lock;
 };
 
@@ -966,10 +966,9 @@ struct iwl_priv {
 	struct ieee80211_vif *vif;
 
 	struct iwl_hw_params hw_params;
-	/* driver/uCode shared Tx Byte Counts and Rx status */
+	/* driver/uCode shared Tx Byte Counts */
 	void *shared_virt;
-	int rb_closed_offset;
-	/* Physical Pointer to Tx Byte Counts and Rx status */
+	/* Physical Pointer to Tx Byte Counts */
 	dma_addr_t shared_phys;
 
 	/* Current association information needed to configure the
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 97e2cf4..1537542 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -403,5 +403,21 @@
 #define TFD_QUEUE_SIZE_BC_DUP	(64)
 #define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
 
+/**
+ * struct iwl_rb_status - reseve buffer status
+ * 	host memory mapped FH registers
+ * @closed_rb_num [0:11] - Indicates the index of the RB which was closed
+ * @closed_fr_num [0:11] - Indicates the index of the RX Frame which was closed
+ * @finished_rb_num [0:11] - Indicates the index of the current RB
+ * 	in which the last frame was written to
+ * @finished_fr_num [0:11] - Indicates the index of the RX Frame
+ * 	which was transfered
+ */
+struct iwl_rb_status {
+	__le16 closed_rb_num;
+	__le16 closed_fr_num;
+	__le16 finished_rb_num;
+	__le16 finished_fr_nam;
+} __attribute__ ((packed));
 
 #endif /* !__iwl_fh_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index b86f958..516cd11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -266,8 +266,7 @@ void iwl_rx_allocate(struct iwl_priv *priv)
 		list_del(element);
 
 		/* Get physical address of RB/SKB */
-		rxb->dma_addr =
-		    pci_map_single(priv->pci_dev, rxb->skb->data,
+		rxb->dma_addr = pci_map_single(priv->pci_dev, rxb->skb->data,
 			   priv->hw_params.rx_buf_size, PCI_DMA_FROMDEVICE);
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
@@ -309,7 +308,10 @@ void iwl_rx_queue_free(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 
 	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
 			    rxq->dma_addr);
+	pci_free_consistent(priv->pci_dev, sizeof(struct iwl_rb_status),
+			    rxq->rb_stts, rxq->rb_stts_dma);
 	rxq->bd = NULL;
+	rxq->rb_stts  = NULL;
 }
 EXPORT_SYMBOL(iwl_rx_queue_free);
 
@@ -326,7 +328,12 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 	/* Alloc the circular buffer of Read Buffer Descriptors (RBDs) */
 	rxq->bd = pci_alloc_consistent(dev, 4 * RX_QUEUE_SIZE, &rxq->dma_addr);
 	if (!rxq->bd)
-		return -ENOMEM;
+		goto err_bd;
+
+	rxq->rb_stts = pci_alloc_consistent(dev, sizeof(struct iwl_rb_status),
+					&rxq->rb_stts_dma);
+	if (!rxq->rb_stts)
+		goto err_rb;
 
 	/* Fill the rx_used queue with _all_ of the Rx buffers */
 	for (i = 0; i < RX_FREE_BUFFERS + RX_QUEUE_SIZE; i++)
@@ -338,6 +345,12 @@ int iwl_rx_queue_alloc(struct iwl_priv *priv)
 	rxq->free_count = 0;
 	rxq->need_update = 0;
 	return 0;
+
+err_rb:
+	pci_free_consistent(priv->pci_dev, 4 * RX_QUEUE_SIZE, rxq->bd,
+			    rxq->dma_addr);
+err_bd:
+	return -ENOMEM;
 }
 EXPORT_SYMBOL(iwl_rx_queue_alloc);
 
@@ -404,7 +417,7 @@ int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 
 	/* Tell device where in DRAM to update its Rx status */
 	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   (priv->shared_phys + priv->rb_closed_offset) >> 4);
+			   rxq->rb_stts_dma >> 4);
 
 	/* Enable Rx DMA
 	 * FH_RCSR_CHNL0_RX_IGNORE_RXF_EMPTY is set because of HW bug in
-- 
1.5.4.3

