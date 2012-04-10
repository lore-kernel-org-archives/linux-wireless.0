Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:46192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753854Ab2DJAuU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Apr 2012 20:50:20 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/11] iwlwifi: move rx_page_order into transport
Date: Mon,  9 Apr 2012 17:46:51 -0700
Message-Id: <1334018821-30416-2-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120410_025025_104888_784F66A2)
In-Reply-To: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1334018821-30416-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

That way it isn't needed in hw_params, which
is shared data. It also isn't really what we
should configure in the transport, that is
better just 4k/8k, so configure a bool and
derive the page order in the transport. This
also means the transport doesn't need access
to the module parameter any more.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c            |   12 +-----------
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    2 --
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h |    5 +++++
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c  |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-trans-pcie.c     |   13 ++++++++++---
 drivers/net/wireless/iwlwifi/iwl-trans.h          |    4 ++++
 7 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 94af564..0596c95 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -1398,23 +1398,12 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 #endif
 }
 
-/* Size of one Rx buffer in host DRAM */
-#define IWL_RX_BUF_SIZE_4K (4 * 1024)
-#define IWL_RX_BUF_SIZE_8K (8 * 1024)
-
 static void iwl_set_hw_params(struct iwl_priv *priv)
 {
 	if (cfg(priv)->ht_params)
 		hw_params(priv).use_rts_for_aggregation =
 			cfg(priv)->ht_params->use_rts_for_aggregation;
 
-	if (iwlagn_mod_params.amsdu_size_8K)
-		hw_params(priv).rx_page_order =
-			get_order(IWL_RX_BUF_SIZE_8K);
-	else
-		hw_params(priv).rx_page_order =
-			get_order(IWL_RX_BUF_SIZE_4K);
-
 	if (iwlagn_mod_params.disable_11n & IWL_DISABLE_HT_ALL)
 		hw_params(priv).sku &= ~EEPROM_SKU_CAP_11N_ENABLE;
 
@@ -1505,6 +1494,7 @@ static struct iwl_op_mode *iwl_op_mode_dvm_start(struct iwl_trans *trans,
 	trans_cfg.op_mode = op_mode;
 	trans_cfg.no_reclaim_cmds = no_reclaim_cmds;
 	trans_cfg.n_no_reclaim_cmds = ARRAY_SIZE(no_reclaim_cmds);
+	trans_cfg.rx_buf_size_8k = iwlagn_mod_params.amsdu_size_8K;
 
 	ucode_flags = fw->ucode_capa.flags;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 983b41e..c2e5ce9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -166,7 +166,6 @@ struct iwl_mod_params {
  * @valid_rx_ant: usable antennas for RX
  * @ht40_channel: is 40MHz width possible: BIT(IEEE80211_BAND_XXX)
  * @sku: sku read from EEPROM
- * @rx_page_order: Rx buffer page order
  * @ct_kill_threshold: temperature threshold - in hw dependent unit
  * @ct_kill_exit_threshold: when to reeable the device - in hw dependent unit
  *	relevant for 1000, 6000 and up
@@ -182,7 +181,6 @@ struct iwl_hw_params {
 	u8  ht40_channel;
 	bool use_rts_for_aggregation;
 	u16 sku;
-	u32 rx_page_order;
 	u32 ct_kill_threshold;
 	u32 ct_kill_exit_threshold;
 	unsigned int wd_timeout;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
index 32adee3..319f900 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-int.h
@@ -227,6 +227,8 @@ struct iwl_tx_queue {
  * @ucode_write_waitq: wait queue for uCode load
  * @status - transport specific status flags
  * @cmd_queue - command queue number
+ * @rx_buf_size_8k: 8 kB RX buffer size
+ * @rx_page_order: page order for receive buffer size
  */
 struct iwl_trans_pcie {
 	struct iwl_rx_queue rxq;
@@ -266,6 +268,9 @@ struct iwl_trans_pcie {
 	u8 no_reclaim_cmds[MAX_NO_RECLAIM_CMDS];
 	u8 setup_q_to_fifo[IWL_MAX_HW_QUEUES];
 	u8 n_q_to_fifo;
+
+	bool rx_buf_size_8k;
+	u32 rx_page_order;
 };
 
 #define IWL_TRANS_GET_PCIE_TRANS(_iwl_trans) \
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
index ab0f3fc..b35f120 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-rx.c
@@ -274,17 +274,17 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 		if (rxq->free_count > RX_LOW_WATERMARK)
 			gfp_mask |= __GFP_NOWARN;
 
-		if (hw_params(trans).rx_page_order > 0)
+		if (trans_pcie->rx_page_order > 0)
 			gfp_mask |= __GFP_COMP;
 
 		/* Alloc a new receive buffer */
 		page = alloc_pages(gfp_mask,
-				  hw_params(trans).rx_page_order);
+				  trans_pcie->rx_page_order);
 		if (!page) {
 			if (net_ratelimit())
 				IWL_DEBUG_INFO(trans, "alloc_pages failed, "
 					   "order: %d\n",
-					   hw_params(trans).rx_page_order);
+					   trans_pcie->rx_page_order);
 
 			if ((rxq->free_count <= RX_LOW_WATERMARK) &&
 			    net_ratelimit())
@@ -303,7 +303,7 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 
 		if (list_empty(&rxq->rx_used)) {
 			spin_unlock_irqrestore(&rxq->lock, flags);
-			__free_pages(page, hw_params(trans).rx_page_order);
+			__free_pages(page, trans_pcie->rx_page_order);
 			return;
 		}
 		element = rxq->rx_used.next;
@@ -316,7 +316,7 @@ static void iwlagn_rx_allocate(struct iwl_trans *trans, gfp_t priority)
 		rxb->page = page;
 		/* Get physical address of the RB */
 		rxb->page_dma = dma_map_page(trans->dev, page, 0,
-				PAGE_SIZE << hw_params(trans).rx_page_order,
+				PAGE_SIZE << trans_pcie->rx_page_order,
 				DMA_FROM_DEVICE);
 		/* dma address must be no more than 36 bits */
 		BUG_ON(rxb->page_dma & ~DMA_BIT_MASK(36));
@@ -367,7 +367,7 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 	struct iwl_tx_queue *txq = &trans_pcie->txq[trans_pcie->cmd_queue];
 	unsigned long flags;
 	bool page_stolen = false;
-	int max_len = PAGE_SIZE << hw_params(trans).rx_page_order;
+	int max_len = PAGE_SIZE << trans_pcie->rx_page_order;
 	u32 offset = 0;
 
 	if (WARN_ON(!rxb))
@@ -452,7 +452,7 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 
 	/* page was stolen from us -- free our reference */
 	if (page_stolen) {
-		__free_pages(rxb->page, hw_params(trans).rx_page_order);
+		__free_pages(rxb->page, trans_pcie->rx_page_order);
 		rxb->page = NULL;
 	}
 
@@ -463,7 +463,7 @@ static void iwl_rx_handle_rxbuf(struct iwl_trans *trans,
 	if (rxb->page != NULL) {
 		rxb->page_dma =
 			dma_map_page(trans->dev, rxb->page, 0,
-				PAGE_SIZE << hw_params(trans).rx_page_order,
+				PAGE_SIZE << trans_pcie->rx_page_order,
 				DMA_FROM_DEVICE);
 		list_add_tail(&rxb->list, &rxq->rx_free);
 		rxq->free_count++;
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
index 4684e23..d35d0b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie-tx.c
@@ -765,7 +765,7 @@ void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_cmd_buffer *rxb,
 
 		meta->source->resp_pkt = pkt;
 		meta->source->_rx_page_addr = (unsigned long)page_address(p);
-		meta->source->_rx_page_order = hw_params(trans).rx_page_order;
+		meta->source->_rx_page_order = trans_pcie->rx_page_order;
 		meta->source->handler_status = handler_status;
 	}
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
index 52e218b..17fec08 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-pcie.c
@@ -132,10 +132,10 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 		 * to an SKB, so we need to unmap and free potential storage */
 		if (rxq->pool[i].page != NULL) {
 			dma_unmap_page(trans->dev, rxq->pool[i].page_dma,
-				PAGE_SIZE << hw_params(trans).rx_page_order,
+				PAGE_SIZE << trans_pcie->rx_page_order,
 				DMA_FROM_DEVICE);
 			__free_pages(rxq->pool[i].page,
-				     hw_params(trans).rx_page_order);
+				     trans_pcie->rx_page_order);
 			rxq->pool[i].page = NULL;
 		}
 		list_add_tail(&rxq->pool[i].list, &rxq->rx_used);
@@ -145,11 +145,12 @@ static void iwl_trans_rxq_free_rx_bufs(struct iwl_trans *trans)
 static void iwl_trans_rx_hw_init(struct iwl_trans *trans,
 				 struct iwl_rx_queue *rxq)
 {
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	u32 rb_size;
 	const u32 rfdnlog = RX_QUEUE_SIZE_LOG; /* 256 RBDs */
 	u32 rb_timeout = RX_RB_TIMEOUT; /* FIXME: RX_RB_TIMEOUT for all devices? */
 
-	if (iwlagn_mod_params.amsdu_size_8K)
+	if (trans_pcie->rx_buf_size_8k)
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
 	else
 		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
@@ -1493,6 +1494,12 @@ static void iwl_trans_pcie_configure(struct iwl_trans *trans,
 
 	memcpy(trans_pcie->setup_q_to_fifo, trans_cfg->queue_to_fifo,
 	       trans_pcie->n_q_to_fifo * sizeof(u8));
+
+	trans_pcie->rx_buf_size_8k = trans_cfg->rx_buf_size_8k;
+	if (trans_pcie->rx_buf_size_8k)
+		trans_pcie->rx_page_order = get_order(8 * 1024);
+	else
+		trans_pcie->rx_page_order = get_order(4 * 1024);
 }
 
 static void iwl_trans_pcie_free(struct iwl_trans *trans)
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.h b/drivers/net/wireless/iwlwifi/iwl-trans.h
index 66c54c1..46be59f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.h
@@ -305,6 +305,8 @@ static inline struct page *rxb_steal_page(struct iwl_rx_cmd_buffer *r)
  *	list of such notifications to filter. Max length is
  *	%MAX_NO_RECLAIM_CMDS.
  * @n_no_reclaim_cmds: # of commands in list
+ * @rx_buf_size_8k: 8 kB RX buffer size needed for A-MSDUs,
+ *	if unset 4k will be the RX buffer size
  */
 struct iwl_trans_config {
 	struct iwl_op_mode *op_mode;
@@ -314,6 +316,8 @@ struct iwl_trans_config {
 	u8 cmd_queue;
 	const u8 *no_reclaim_cmds;
 	int n_no_reclaim_cmds;
+
+	bool rx_buf_size_8k;
 };
 
 /**
-- 
1.7.0.4

