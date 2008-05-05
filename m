Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:14360 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754553AbYEECYZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:25 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 16/25] iwlwifi: move NIC init and Tx queues init to iwlcore
Date: Mon,  5 May 2008 10:22:43 +0800
Message-Id: <1209954172-3092-17-git-send-email-yi.zhu@intel.com> (sfid-20080505_044417_976178_1B72D93E)
In-Reply-To: <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
References: <1209954172-3092-1-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-2-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-3-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-4-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-5-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-6-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-7-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-8-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-9-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-10-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-11-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-12-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-13-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-14-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-15-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-16-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch does the following:

1 - change hw_nic_init from a handler to a function
2 - move hw_nic_init function to iwlcore
3 - open a new file - iwl-tx.c
4 - move all Tx queues initialization (part of NIC init) to iwl-tx.c
5 - move iwl_rx_init, previously as part of the NIC init, to iwl-rx.c
6 - iwl4965_tfd_frame rename to iwl_tfd_frame

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile       |    2 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |   10 +-
 drivers/net/wireless/iwlwifi/iwl-4965.c     |  339 +------------------------
 drivers/net/wireless/iwlwifi/iwl-core.c     |   95 +++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |   17 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   10 +-
 drivers/net/wireless/iwlwifi/iwl-rx.c       |   52 ++++
 drivers/net/wireless/iwlwifi/iwl-tx.c       |  374 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |  177 +------------
 9 files changed, 550 insertions(+), 526 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-tx.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index c340200..ab372fc 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_IWLCORE)	+= iwlcore.o
 iwlcore-objs 		= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
-iwlcore-objs 		+= iwl-rx.o
+iwlcore-objs 		+= iwl-rx.o iwl-tx.o
 iwlcore-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlcore-$(CONFIG_IWLWIFI_LEDS) += iwl-led.o
 iwlcore-$(CONFIG_IWLWIFI_RFKILL) += iwl-rfkill.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 29749e2..ee55b28 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -829,7 +829,7 @@ static inline __le32 iwl4965_hw_set_rate_n_flags(u8 rate, u16 flags)
 #define IWL49_NUM_QUEUES	16
 
 /**
- * struct iwl4965_tfd_frame_data
+ * struct iwl_tfd_frame_data
  *
  * Describes up to 2 buffers containing (contiguous) portions of a Tx frame.
  * Each buffer must be on dword boundary.
@@ -848,7 +848,7 @@ static inline __le32 iwl4965_hw_set_rate_n_flags(u8 rate, u16 flags)
  * 31-20: Tx buffer 2 length (bytes)
  * 19- 0: Tx buffer 2 address bits [35:16]
  */
-struct iwl4965_tfd_frame_data {
+struct iwl_tfd_frame_data {
 	__le32 tb1_addr;
 
 	__le32 val1;
@@ -878,7 +878,7 @@ struct iwl4965_tfd_frame_data {
 
 
 /**
- * struct iwl4965_tfd_frame
+ * struct iwl_tfd_frame
  *
  * Transmit Frame Descriptor (TFD)
  *
@@ -905,7 +905,7 @@ struct iwl4965_tfd_frame_data {
  *
  * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
  */
-struct iwl4965_tfd_frame {
+struct iwl_tfd_frame {
 	__le32 val0;
 	/* __le32 rsvd1:24; */
 	/* __le32 num_tbs:5; */
@@ -914,7 +914,7 @@ struct iwl4965_tfd_frame {
 #define IWL_num_tbs_SYM val0
 	/* __le32 rsvd2:1; */
 	/* __le32 padding:2; */
-	struct iwl4965_tfd_frame_data pa[10];
+	struct iwl_tfd_frame_data pa[10];
 	__le32 reserved;
 } __attribute__ ((packed));
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d5ee512..639bbc3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -53,8 +53,6 @@ static struct iwl_mod_params iwl4965_mod_params = {
 	/* the rest are 0 by default */
 };
 
-static void iwl4965_hw_card_show_info(struct iwl_priv *priv);
-
 #ifdef CONFIG_IWL4965_HT
 
 static const u16 default_tid_to_tx_fifo[] = {
@@ -372,104 +370,6 @@ int iwl4965_set_pwr_src(struct iwl_priv *priv, enum iwl_pwr_src src)
 	return ret;
 }
 
-static int iwl4965_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
-{
-	int ret;
-	unsigned long flags;
-	unsigned int rb_size;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	ret = iwl_grab_nic_access(priv);
-	if (ret) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return ret;
-	}
-
-	if (priv->cfg->mod_params->amsdu_size_8K)
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
-	else
-		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
-
-	/* Stop Rx DMA */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
-
-	/* Reset driver's Rx queue write index */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
-
-	/* Tell device where to find RBD circular buffer in DRAM */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
-			   rxq->dma_addr >> 8);
-
-	/* Tell device where in DRAM to update its Rx status */
-	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
-			   (priv->shared_phys +
-			    offsetof(struct iwl4965_shared, rb_closed)) >> 4);
-
-	/* Enable Rx DMA, enable host interrupt, Rx buffer size 4k, 256 RBDs */
-	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
-			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
-			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
-			   rb_size |
-			     /* 0x10 << 4 | */
-			   (RX_QUEUE_SIZE_LOG <<
-			      FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT));
-
-	/*
-	 * iwl_write32(priv,CSR_INT_COAL_REG,0);
-	 */
-
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
-}
-
-/* Tell 4965 where to find the "keep warm" buffer */
-static int iwl4965_kw_init(struct iwl_priv *priv)
-{
-	unsigned long flags;
-	int rc;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc)
-		goto out;
-
-	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG,
-			     priv->kw.dma_addr >> 4);
-	iwl_release_nic_access(priv);
-out:
-	spin_unlock_irqrestore(&priv->lock, flags);
-	return rc;
-}
-
-static int iwl4965_kw_alloc(struct iwl_priv *priv)
-{
-	struct pci_dev *dev = priv->pci_dev;
-	struct iwl4965_kw *kw = &priv->kw;
-
-	kw->size = IWL4965_KW_SIZE;	/* TBW need set somewhere else */
-	kw->v_addr = pci_alloc_consistent(dev, kw->size, &kw->dma_addr);
-	if (!kw->v_addr)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/**
- * iwl4965_kw_free - Free the "keep warm" buffer
- */
-static void iwl4965_kw_free(struct iwl_priv *priv)
-{
-	struct pci_dev *dev = priv->pci_dev;
-	struct iwl4965_kw *kw = &priv->kw;
-
-	if (kw->v_addr) {
-		pci_free_consistent(dev, kw->size, kw->v_addr, kw->dma_addr);
-		memset(kw, 0, sizeof(*kw));
-	}
-}
-
 static int iwl4965_disable_tx_fifo(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -491,65 +391,6 @@ static int iwl4965_disable_tx_fifo(struct iwl_priv *priv)
 	return 0;
 }
 
-/**
- * iwl4965_txq_ctx_reset - Reset TX queue context
- * Destroys all DMA structures and initialise them again
- *
- * @param priv
- * @return error code
- */
-static int iwl4965_txq_ctx_reset(struct iwl_priv *priv)
-{
-	int rc = 0;
-	int txq_id, slots_num;
-
-	iwl4965_kw_free(priv);
-
-	/* Free all tx/cmd queues and keep-warm buffer */
-	iwl4965_hw_txq_ctx_free(priv);
-
-	/* Alloc keep-warm buffer */
-	rc = iwl4965_kw_alloc(priv);
-	if (rc) {
-		IWL_ERROR("Keep Warm allocation failed");
-		goto error_kw;
-	}
-
-	/* Turn off all Tx DMA fifos */
-	rc = priv->cfg->ops->lib->disable_tx_fifo(priv);
-	if (unlikely(rc))
-		goto error_reset;
-
-	/* Tell 4965 where to find the keep-warm buffer */
-	rc = iwl4965_kw_init(priv);
-	if (rc) {
-		IWL_ERROR("kw_init failed\n");
-		goto error_reset;
-	}
-
-	/* Alloc and init all (default 16) Tx queues,
-	 * including the command queue (#4) */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
-		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
-					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		rc = iwl4965_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
-				       txq_id);
-		if (rc) {
-			IWL_ERROR("Tx %d queue init failed\n", txq_id);
-			goto error;
-		}
-	}
-
-	return rc;
-
- error:
-	iwl4965_hw_txq_ctx_free(priv);
- error_reset:
-	iwl4965_kw_free(priv);
- error_kw:
-	return rc;
-}
-
 static int iwl4965_apm_init(struct iwl_priv *priv)
 {
 	unsigned long flags;
@@ -633,58 +474,6 @@ static void iwl4965_nic_config(struct iwl_priv *priv)
 	spin_unlock_irqrestore(&priv->lock, flags);
 }
 
-int iwl4965_hw_nic_init(struct iwl_priv *priv)
-{
-	unsigned long flags;
-	struct iwl_rx_queue *rxq = &priv->rxq;
-	int ret;
-
-	/* nic_init */
-	priv->cfg->ops->lib->apm_ops.init(priv);
-
-	spin_lock_irqsave(&priv->lock, flags);
-	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
-
-	priv->cfg->ops->lib->apm_ops.config(priv);
-
-	iwl4965_hw_card_show_info(priv);
-
-	/* end nic_init */
-
-	/* Allocate the RX queue, or reset if it is already allocated */
-	if (!rxq->bd) {
-		ret = iwl_rx_queue_alloc(priv);
-		if (ret) {
-			IWL_ERROR("Unable to initialize Rx queue\n");
-			return -ENOMEM;
-		}
-	} else
-		iwl_rx_queue_reset(priv, rxq);
-
-	iwl_rx_replenish(priv);
-
-	iwl4965_rx_init(priv, rxq);
-
-	spin_lock_irqsave(&priv->lock, flags);
-
-	rxq->need_update = 1;
-	iwl_rx_queue_update_write_ptr(priv, rxq);
-
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	/* Allocate and init all Tx and Command queues */
-	ret = iwl4965_txq_ctx_reset(priv);
-	if (ret)
-		return ret;
-
-	set_bit(STATUS_INIT, &priv->status);
-
-	return 0;
-}
-
 int iwl4965_hw_nic_stop_master(struct iwl_priv *priv)
 {
 	int rc = 0;
@@ -745,7 +534,7 @@ void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv)
 	}
 
 	/* Deallocate memory for all Tx queues */
-	iwl4965_hw_txq_ctx_free(priv);
+	iwl_hw_txq_ctx_free(priv);
 }
 
 int iwl4965_hw_nic_reset(struct iwl_priv *priv)
@@ -1199,82 +988,6 @@ int iwl4965_hw_set_hw_params(struct iwl_priv *priv)
 	return 0;
 }
 
-/**
- * iwl4965_hw_txq_ctx_free - Free TXQ Context
- *
- * Destroy all TX DMA queues and structures
- */
-void iwl4965_hw_txq_ctx_free(struct iwl_priv *priv)
-{
-	int txq_id;
-
-	/* Tx queues */
-	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
-		iwl4965_tx_queue_free(priv, &priv->txq[txq_id]);
-
-	/* Keep-warm buffer */
-	iwl4965_kw_free(priv);
-}
-
-/**
- * iwl4965_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
- *
- * Does NOT advance any TFD circular buffer read/write indexes
- * Does NOT free the TFD itself (which is within circular buffer)
- */
-int iwl4965_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
-{
-	struct iwl4965_tfd_frame *bd_tmp = (struct iwl4965_tfd_frame *)&txq->bd[0];
-	struct iwl4965_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
-	struct pci_dev *dev = priv->pci_dev;
-	int i;
-	int counter = 0;
-	int index, is_odd;
-
-	/* Host command buffers stay mapped in memory, nothing to clean */
-	if (txq->q.id == IWL_CMD_QUEUE_NUM)
-		return 0;
-
-	/* Sanity check on number of chunks */
-	counter = IWL_GET_BITS(*bd, num_tbs);
-	if (counter > MAX_NUM_OF_TBS) {
-		IWL_ERROR("Too many chunks: %i\n", counter);
-		/* @todo issue fatal error, it is quite serious situation */
-		return 0;
-	}
-
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
-
-			dev_kfree_skb(skb);
-			txq->txb[txq->q.read_ptr].skb[i] = NULL;
-		}
-	}
-	return 0;
-}
-
 /* set card power command */
 static int iwl4965_set_power(struct iwl_priv *priv,
 		      void *cmd)
@@ -2240,46 +1953,11 @@ unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 	return (sizeof(*tx_beacon_cmd) + frame_size);
 }
 
-/*
- * Tell 4965 where to find circular buffer of Tx Frame Descriptors for
- * given Tx queue, and enable the DMA channel used for that queue.
- *
- * 4965 supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
- * channels supported in hardware.
- */
-int iwl4965_hw_tx_queue_init(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
-{
-	int rc;
-	unsigned long flags;
-	int txq_id = txq->q.id;
-
-	spin_lock_irqsave(&priv->lock, flags);
-	rc = iwl_grab_nic_access(priv);
-	if (rc) {
-		spin_unlock_irqrestore(&priv->lock, flags);
-		return rc;
-	}
-
-	/* Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
-			     txq->q.dma_addr >> 8);
-
-	/* Enable DMA channel, using same id as for TFD queue */
-	iwl_write_direct32(
-		priv, FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
-		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL);
-	iwl_release_nic_access(priv);
-	spin_unlock_irqrestore(&priv->lock, flags);
-
-	return 0;
-}
-
 int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 				 dma_addr_t addr, u16 len)
 {
 	int index, is_odd;
-	struct iwl4965_tfd_frame *tfd = ptr;
+	struct iwl_tfd_frame *tfd = ptr;
 	u32 num_tbs = IWL_GET_BITS(*tfd, num_tbs);
 
 	/* Each TFD can point to a maximum 20 Tx buffers */
@@ -2309,18 +1987,6 @@ int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
 	return 0;
 }
 
-static void iwl4965_hw_card_show_info(struct iwl_priv *priv)
-{
-	u16 hw_version = iwl_eeprom_query16(priv, EEPROM_4965_BOARD_REVISION);
-
-	IWL_DEBUG_INFO("4965ABGN HW Version %u.%u.%u\n",
-		       ((hw_version >> 8) & 0x0F),
-		       ((hw_version >> 8) >> 4), (hw_version & 0x00FF));
-
-	IWL_DEBUG_INFO("4965ABGN PBA Number %.16s\n",
-		       &priv->eeprom[EEPROM_4965_BOARD_PBA]);
-}
-
 static int iwl4965_alloc_shared_mem(struct iwl_priv *priv)
 {
 	priv->shared_virt = pci_alloc_consistent(priv->pci_dev,
@@ -4051,7 +3717,6 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.alloc_shared_mem = iwl4965_alloc_shared_mem,
 	.free_shared_mem = iwl4965_free_shared_mem,
 	.txq_update_byte_cnt_tbl = iwl4965_txq_update_byte_cnt_tbl,
-	.hw_nic_init = iwl4965_hw_nic_init,
 	.disable_tx_fifo = iwl4965_disable_tx_fifo,
 	.rx_handler_setup = iwl4965_rx_handler_setup,
 	.is_valid_rtc_data_addr = iwl4965_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 4bf140f..c29d287 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -121,6 +121,101 @@ void iwl_hw_detect(struct iwl_priv *priv)
 }
 EXPORT_SYMBOL(iwl_hw_detect);
 
+/* Tell nic where to find the "keep warm" buffer */
+int iwl_kw_init(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	int ret;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (ret)
+		goto out;
+
+	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG,
+			     priv->kw.dma_addr >> 4);
+	iwl_release_nic_access(priv);
+out:
+	spin_unlock_irqrestore(&priv->lock, flags);
+	return ret;
+}
+
+int iwl_kw_alloc(struct iwl_priv *priv)
+{
+	struct pci_dev *dev = priv->pci_dev;
+	struct iwl4965_kw *kw = &priv->kw;
+
+	kw->size = IWL4965_KW_SIZE;	/* TBW need set somewhere else */
+	kw->v_addr = pci_alloc_consistent(dev, kw->size, &kw->dma_addr);
+	if (!kw->v_addr)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * iwl_kw_free - Free the "keep warm" buffer
+ */
+void iwl_kw_free(struct iwl_priv *priv)
+{
+	struct pci_dev *dev = priv->pci_dev;
+	struct iwl4965_kw *kw = &priv->kw;
+
+	if (kw->v_addr) {
+		pci_free_consistent(dev, kw->size, kw->v_addr, kw->dma_addr);
+		memset(kw, 0, sizeof(*kw));
+	}
+}
+
+int iwl_hw_nic_init(struct iwl_priv *priv)
+{
+	unsigned long flags;
+	struct iwl_rx_queue *rxq = &priv->rxq;
+	int ret;
+
+	/* nic_init */
+	priv->cfg->ops->lib->apm_ops.init(priv);
+
+	spin_lock_irqsave(&priv->lock, flags);
+	iwl_write32(priv, CSR_INT_COALESCING, 512 / 32);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	ret = priv->cfg->ops->lib->apm_ops.set_pwr_src(priv, IWL_PWR_SRC_VMAIN);
+
+	priv->cfg->ops->lib->apm_ops.config(priv);
+
+	/* Allocate the RX queue, or reset if it is already allocated */
+	if (!rxq->bd) {
+		ret = iwl_rx_queue_alloc(priv);
+		if (ret) {
+			IWL_ERROR("Unable to initialize Rx queue\n");
+			return -ENOMEM;
+		}
+	} else
+		iwl_rx_queue_reset(priv, rxq);
+
+	iwl_rx_replenish(priv);
+
+	iwl_rx_init(priv, rxq);
+
+	spin_lock_irqsave(&priv->lock, flags);
+
+	rxq->need_update = 1;
+	iwl_rx_queue_update_write_ptr(priv, rxq);
+
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	/* Allocate and init all Tx and Command queues */
+	ret = iwl_txq_ctx_reset(priv);
+	if (ret)
+		return ret;
+
+	set_bit(STATUS_INIT, &priv->status);
+
+	return 0;
+}
+EXPORT_SYMBOL(iwl_hw_nic_init);
+
 /**
  * iwlcore_clear_stations_table - Clear the driver's station table
  *
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index c29f8b3..3a75dc6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -108,8 +108,6 @@ struct iwl_lib_ops {
 					u16 byte_cnt);
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
-	/* nic init */
-	int (*hw_nic_init)(struct iwl_priv *priv);
 	/* nic Tx fifo handling */
 	int (*disable_tx_fifo)(struct iwl_priv *priv);
 	/* alive notification */
@@ -178,6 +176,12 @@ int iwl_setup(struct iwl_priv *priv);
 void iwl_set_rxon_ht(struct iwl_priv *priv, struct iwl_ht_info *ht_info);
 u8 iwl_is_fat_tx_allowed(struct iwl_priv *priv,
 			 struct ieee80211_ht_info *sta_ht_inf);
+int iwl_hw_nic_init(struct iwl_priv *priv);
+
+/* "keep warm" functions */
+int iwl_kw_init(struct iwl_priv *priv);
+int iwl_kw_alloc(struct iwl_priv *priv);
+void iwl_kw_free(struct iwl_priv *priv);
 
 /*****************************************************
 * RX
@@ -189,12 +193,21 @@ int iwl_rx_queue_update_write_ptr(struct iwl_priv *priv,
 				  struct iwl_rx_queue *q);
 void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 void iwl_rx_replenish(struct iwl_priv *priv);
+int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq);
 /* FIXME: remove when TX is moved to iwl core */
 int iwl_rx_queue_restock(struct iwl_priv *priv);
 int iwl_rx_queue_space(const struct iwl_rx_queue *q);
 void iwl_rx_allocate(struct iwl_priv *priv);
 
 /*****************************************************
+* TX
+******************************************************/
+int iwl_txq_ctx_reset(struct iwl_priv *priv);
+/* FIXME: remove when free Tx is fully merged into iwlcore */
+int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
+void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
+
+/*****************************************************
  *   S e n d i n g     H o s t     C o m m a n d s   *
  *****************************************************/
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 23cae4c..e730583 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -138,7 +138,7 @@ struct iwl4965_tx_info {
  */
 struct iwl4965_tx_queue {
 	struct iwl4965_queue q;
-	struct iwl4965_tfd_frame *bd;
+	struct iwl_tfd_frame *bd;
 	struct iwl_cmd *cmd;
 	dma_addr_t dma_addr_cmd;
 	struct iwl4965_tx_info *txb;
@@ -649,9 +649,6 @@ extern int iwl4965_is_duplicate_packet(struct iwl_priv *priv,
 				       struct ieee80211_hdr *header);
 extern int iwl4965_calc_db_from_ratio(int sig_ratio);
 extern int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm);
-extern int iwl4965_tx_queue_init(struct iwl_priv *priv,
-			     struct iwl4965_tx_queue *txq, int count, u32 id);
-extern void iwl4965_tx_queue_free(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
 extern unsigned int iwl4965_fill_beacon_frame(struct iwl_priv *priv,
 					struct ieee80211_hdr *hdr,
 					const u8 *dest, int left);
@@ -692,17 +689,12 @@ extern void iwl4965_hw_setup_deferred_work(struct iwl_priv *priv);
 extern void iwl4965_hw_cancel_deferred_work(struct iwl_priv *priv);
 extern int iwl4965_hw_rxq_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_set_hw_params(struct iwl_priv *priv);
-extern int iwl4965_hw_nic_init(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_stop_master(struct iwl_priv *priv);
-extern void iwl4965_hw_txq_ctx_free(struct iwl_priv *priv);
 extern void iwl4965_hw_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl4965_hw_nic_reset(struct iwl_priv *priv);
 extern int iwl4965_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
-extern int iwl4965_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
 extern int iwl4965_hw_get_temperature(struct iwl_priv *priv);
-extern int iwl4965_hw_tx_queue_init(struct iwl_priv *priv,
-				struct iwl4965_tx_queue *txq);
 extern unsigned int iwl4965_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl4965_frame *frame, u8 rate);
 extern int iwl4965_hw_get_rx_read(struct iwl_priv *priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 667b592..171751e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -369,3 +369,55 @@ void iwl_rx_queue_reset(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
 }
 EXPORT_SYMBOL(iwl_rx_queue_reset);
 
+int iwl_rx_init(struct iwl_priv *priv, struct iwl_rx_queue *rxq)
+{
+	int ret;
+	unsigned long flags;
+	unsigned int rb_size;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	ret = iwl_grab_nic_access(priv);
+	if (ret) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return ret;
+	}
+
+	if (priv->cfg->mod_params->amsdu_size_8K)
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_8K;
+	else
+		rb_size = FH_RCSR_RX_CONFIG_REG_VAL_RB_SIZE_4K;
+
+	/* Stop Rx DMA */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG, 0);
+
+	/* Reset driver's Rx queue write index */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_WPTR_REG, 0);
+
+	/* Tell device where to find RBD circular buffer in DRAM */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_RBDCB_BASE_REG,
+			   rxq->dma_addr >> 8);
+
+	/* Tell device where in DRAM to update its Rx status */
+	iwl_write_direct32(priv, FH_RSCSR_CHNL0_STTS_WPTR_REG,
+			   (priv->shared_phys +
+			    offsetof(struct iwl4965_shared, rb_closed)) >> 4);
+
+	/* Enable Rx DMA, enable host interrupt, Rx buffer size 4k, 256 RBDs */
+	iwl_write_direct32(priv, FH_MEM_RCSR_CHNL0_CONFIG_REG,
+			   FH_RCSR_RX_CONFIG_CHNL_EN_ENABLE_VAL |
+			   FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL |
+			   rb_size |
+			     /* 0x10 << 4 | */
+			   (RX_QUEUE_SIZE_LOG <<
+			      FH_RCSR_RX_CONFIG_RBDCB_SIZE_BITSHIFT));
+
+	/*
+	 * iwl_write32(priv,CSR_INT_COAL_REG,0);
+	 */
+
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
new file mode 100644
index 0000000..ade247e
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -0,0 +1,374 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2003 - 2008 Intel Corporation. All rights reserved.
+ *
+ * Portions of this file are derived from the ipw3945 project, as well
+ * as portions of the ieee80211 subsystem header files.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <net/mac80211.h>
+#include "iwl-eeprom.h"
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-sta.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+
+/**
+ * iwl_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
+ *
+ * Does NOT advance any TFD circular buffer read/write indexes
+ * Does NOT free the TFD itself (which is within circular buffer)
+ */
+int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
+{
+	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
+	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
+	struct pci_dev *dev = priv->pci_dev;
+	int i;
+	int counter = 0;
+	int index, is_odd;
+
+	/* Host command buffers stay mapped in memory, nothing to clean */
+	if (txq->q.id == IWL_CMD_QUEUE_NUM)
+		return 0;
+
+	/* Sanity check on number of chunks */
+	counter = IWL_GET_BITS(*bd, num_tbs);
+	if (counter > MAX_NUM_OF_TBS) {
+		IWL_ERROR("Too many chunks: %i\n", counter);
+		/* @todo issue fatal error, it is quite serious situation */
+		return 0;
+	}
+
+	/* Unmap chunks, if any.
+	 * TFD info for odd chunks is different format than for even chunks. */
+	for (i = 0; i < counter; i++) {
+		index = i / 2;
+		is_odd = i & 0x1;
+
+		if (is_odd)
+			pci_unmap_single(
+				dev,
+				IWL_GET_BITS(bd->pa[index], tb2_addr_lo16) |
+				(IWL_GET_BITS(bd->pa[index],
+					      tb2_addr_hi20) << 16),
+				IWL_GET_BITS(bd->pa[index], tb2_len),
+				PCI_DMA_TODEVICE);
+
+		else if (i > 0)
+			pci_unmap_single(dev,
+					 le32_to_cpu(bd->pa[index].tb1_addr),
+					 IWL_GET_BITS(bd->pa[index], tb1_len),
+					 PCI_DMA_TODEVICE);
+
+		/* Free SKB, if any, for this chunk */
+		if (txq->txb[txq->q.read_ptr].skb[i]) {
+			struct sk_buff *skb = txq->txb[txq->q.read_ptr].skb[i];
+
+			dev_kfree_skb(skb);
+			txq->txb[txq->q.read_ptr].skb[i] = NULL;
+		}
+	}
+	return 0;
+}
+EXPORT_SYMBOL(iwl_hw_txq_free_tfd);
+
+/**
+ * iwl_tx_queue_free - Deallocate DMA queue.
+ * @txq: Transmit queue to deallocate.
+ *
+ * Empty queue by removing and destroying all BD's.
+ * Free all buffers.
+ * 0-fill, but do not free "txq" descriptor structure.
+ */
+static void iwl_tx_queue_free(struct iwl_priv *priv,
+			      struct iwl4965_tx_queue *txq)
+{
+	struct iwl4965_queue *q = &txq->q;
+	struct pci_dev *dev = priv->pci_dev;
+	int len;
+
+	if (q->n_bd == 0)
+		return;
+
+	/* first, empty all BD's */
+	for (; q->write_ptr != q->read_ptr;
+	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
+		iwl_hw_txq_free_tfd(priv, txq);
+
+	len = sizeof(struct iwl_cmd) * q->n_window;
+	if (q->id == IWL_CMD_QUEUE_NUM)
+		len += IWL_MAX_SCAN_SIZE;
+
+	/* De-alloc array of command/tx buffers */
+	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
+
+	/* De-alloc circular buffer of TFDs */
+	if (txq->q.n_bd)
+		pci_free_consistent(dev, sizeof(struct iwl_tfd_frame) *
+				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
+
+	/* De-alloc array of per-TFD driver data */
+	kfree(txq->txb);
+	txq->txb = NULL;
+
+	/* 0-fill queue descriptor structure */
+	memset(txq, 0, sizeof(*txq));
+}
+
+/**
+ * iwl_hw_txq_ctx_free - Free TXQ Context
+ *
+ * Destroy all TX DMA queues and structures
+ */
+void iwl_hw_txq_ctx_free(struct iwl_priv *priv)
+{
+	int txq_id;
+
+	/* Tx queues */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++)
+		iwl_tx_queue_free(priv, &priv->txq[txq_id]);
+
+	/* Keep-warm buffer */
+	iwl_kw_free(priv);
+}
+EXPORT_SYMBOL(iwl_hw_txq_ctx_free);
+
+/**
+ * iwl_queue_init - Initialize queue's high/low-water and read/write indexes
+ */
+static int iwl_queue_init(struct iwl_priv *priv, struct iwl4965_queue *q,
+			  int count, int slots_num, u32 id)
+{
+	q->n_bd = count;
+	q->n_window = slots_num;
+	q->id = id;
+
+	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
+	 * and iwl_queue_dec_wrap are broken. */
+	BUG_ON(!is_power_of_2(count));
+
+	/* slots_num must be power-of-two size, otherwise
+	 * get_cmd_index is broken. */
+	BUG_ON(!is_power_of_2(slots_num));
+
+	q->low_mark = q->n_window / 4;
+	if (q->low_mark < 4)
+		q->low_mark = 4;
+
+	q->high_mark = q->n_window / 8;
+	if (q->high_mark < 2)
+		q->high_mark = 2;
+
+	q->write_ptr = q->read_ptr = 0;
+
+	return 0;
+}
+
+/**
+ * iwl_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
+ */
+static int iwl_tx_queue_alloc(struct iwl_priv *priv,
+			      struct iwl4965_tx_queue *txq, u32 id)
+{
+	struct pci_dev *dev = priv->pci_dev;
+
+	/* Driver private data, only for Tx (not command) queues,
+	 * not shared with device. */
+	if (id != IWL_CMD_QUEUE_NUM) {
+		txq->txb = kmalloc(sizeof(txq->txb[0]) *
+				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
+		if (!txq->txb) {
+			IWL_ERROR("kmalloc for auxiliary BD "
+				  "structures failed\n");
+			goto error;
+		}
+	} else
+		txq->txb = NULL;
+
+	/* Circular buffer of transmit frame descriptors (TFDs),
+	 * shared with device */
+	txq->bd = pci_alloc_consistent(dev,
+			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
+			&txq->q.dma_addr);
+
+	if (!txq->bd) {
+		IWL_ERROR("pci_alloc_consistent(%zd) failed\n",
+			  sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX);
+		goto error;
+	}
+	txq->q.id = id;
+
+	return 0;
+
+ error:
+	kfree(txq->txb);
+	txq->txb = NULL;
+
+	return -ENOMEM;
+}
+
+/*
+ * Tell nic where to find circular buffer of Tx Frame Descriptors for
+ * given Tx queue, and enable the DMA channel used for that queue.
+ *
+ * 4965 supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
+ * channels supported in hardware.
+ */
+static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
+				struct iwl4965_tx_queue *txq)
+{
+	int rc;
+	unsigned long flags;
+	int txq_id = txq->q.id;
+
+	spin_lock_irqsave(&priv->lock, flags);
+	rc = iwl_grab_nic_access(priv);
+	if (rc) {
+		spin_unlock_irqrestore(&priv->lock, flags);
+		return rc;
+	}
+
+	/* Circular buffer (TFD queue in DRAM) physical base address */
+	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
+			     txq->q.dma_addr >> 8);
+
+	/* Enable DMA channel, using same id as for TFD queue */
+	iwl_write_direct32(
+		priv, FH_TCSR_CHNL_TX_CONFIG_REG(txq_id),
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CHNL_ENABLE |
+		FH_TCSR_TX_CONFIG_REG_VAL_DMA_CREDIT_ENABLE_VAL);
+	iwl_release_nic_access(priv);
+	spin_unlock_irqrestore(&priv->lock, flags);
+
+	return 0;
+}
+
+/**
+ * iwl_tx_queue_init - Allocate and initialize one tx/cmd queue
+ */
+static int iwl_tx_queue_init(struct iwl_priv *priv,
+			     struct iwl4965_tx_queue *txq,
+			     int slots_num, u32 txq_id)
+{
+	struct pci_dev *dev = priv->pci_dev;
+	int len;
+	int rc = 0;
+
+	/*
+	 * Alloc buffer array for commands (Tx or other types of commands).
+	 * For the command queue (#4), allocate command space + one big
+	 * command for scan, since scan command is very huge; the system will
+	 * not have two scans at the same time, so only one is needed.
+	 * For normal Tx queues (all other queues), no super-size command
+	 * space is needed.
+	 */
+	len = sizeof(struct iwl_cmd) * slots_num;
+	if (txq_id == IWL_CMD_QUEUE_NUM)
+		len +=  IWL_MAX_SCAN_SIZE;
+	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
+	if (!txq->cmd)
+		return -ENOMEM;
+
+	/* Alloc driver data array and TFD circular buffer */
+	rc = iwl_tx_queue_alloc(priv, txq, txq_id);
+	if (rc) {
+		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
+
+		return -ENOMEM;
+	}
+	txq->need_update = 0;
+
+	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
+	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
+	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
+
+	/* Initialize queue's high/low-water marks, and head/tail indexes */
+	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
+
+	/* Tell device where to find queue */
+	iwl_hw_tx_queue_init(priv, txq);
+
+	return 0;
+}
+
+/**
+ * iwl_txq_ctx_reset - Reset TX queue context
+ * Destroys all DMA structures and initialise them again
+ *
+ * @param priv
+ * @return error code
+ */
+int iwl_txq_ctx_reset(struct iwl_priv *priv)
+{
+	int ret = 0;
+	int txq_id, slots_num;
+
+	iwl_kw_free(priv);
+
+	/* Free all tx/cmd queues and keep-warm buffer */
+	iwl_hw_txq_ctx_free(priv);
+
+	/* Alloc keep-warm buffer */
+	ret = iwl_kw_alloc(priv);
+	if (ret) {
+		IWL_ERROR("Keep Warm allocation failed");
+		goto error_kw;
+	}
+
+	/* Turn off all Tx DMA fifos */
+	ret = priv->cfg->ops->lib->disable_tx_fifo(priv);
+	if (unlikely(ret))
+		goto error_reset;
+
+	/* Tell nic where to find the keep-warm buffer */
+	ret = iwl_kw_init(priv);
+	if (ret) {
+		IWL_ERROR("kw_init failed\n");
+		goto error_reset;
+	}
+
+	/* Alloc and init all (default 16) Tx queues,
+	 * including the command queue (#4) */
+	for (txq_id = 0; txq_id < priv->hw_params.max_txq_num; txq_id++) {
+		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
+					TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
+		ret = iwl_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
+				       txq_id);
+		if (ret) {
+			IWL_ERROR("Tx %d queue init failed\n", txq_id);
+			goto error;
+		}
+	}
+
+	return ret;
+
+ error:
+	iwl_hw_txq_ctx_free(priv);
+ error_reset:
+	iwl_kw_free(priv);
+ error_kw:
+	return ret;
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 349c8e3..5b54579 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -207,173 +207,6 @@ static inline u8 get_cmd_index(struct iwl4965_queue *q, u32 index, int is_huge)
 	return index & (q->n_window - 1);
 }
 
-/**
- * iwl4965_queue_init - Initialize queue's high/low-water and read/write indexes
- */
-static int iwl4965_queue_init(struct iwl_priv *priv, struct iwl4965_queue *q,
-			  int count, int slots_num, u32 id)
-{
-	q->n_bd = count;
-	q->n_window = slots_num;
-	q->id = id;
-
-	/* count must be power-of-two size, otherwise iwl_queue_inc_wrap
-	 * and iwl_queue_dec_wrap are broken. */
-	BUG_ON(!is_power_of_2(count));
-
-	/* slots_num must be power-of-two size, otherwise
-	 * get_cmd_index is broken. */
-	BUG_ON(!is_power_of_2(slots_num));
-
-	q->low_mark = q->n_window / 4;
-	if (q->low_mark < 4)
-		q->low_mark = 4;
-
-	q->high_mark = q->n_window / 8;
-	if (q->high_mark < 2)
-		q->high_mark = 2;
-
-	q->write_ptr = q->read_ptr = 0;
-
-	return 0;
-}
-
-/**
- * iwl4965_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
- */
-static int iwl4965_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl4965_tx_queue *txq, u32 id)
-{
-	struct pci_dev *dev = priv->pci_dev;
-
-	/* Driver private data, only for Tx (not command) queues,
-	 * not shared with device. */
-	if (id != IWL_CMD_QUEUE_NUM) {
-		txq->txb = kmalloc(sizeof(txq->txb[0]) *
-				   TFD_QUEUE_SIZE_MAX, GFP_KERNEL);
-		if (!txq->txb) {
-			IWL_ERROR("kmalloc for auxiliary BD "
-				  "structures failed\n");
-			goto error;
-		}
-	} else
-		txq->txb = NULL;
-
-	/* Circular buffer of transmit frame descriptors (TFDs),
-	 * shared with device */
-	txq->bd = pci_alloc_consistent(dev,
-			sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX,
-			&txq->q.dma_addr);
-
-	if (!txq->bd) {
-		IWL_ERROR("pci_alloc_consistent(%zd) failed\n",
-			  sizeof(txq->bd[0]) * TFD_QUEUE_SIZE_MAX);
-		goto error;
-	}
-	txq->q.id = id;
-
-	return 0;
-
- error:
-	if (txq->txb) {
-		kfree(txq->txb);
-		txq->txb = NULL;
-	}
-
-	return -ENOMEM;
-}
-
-/**
- * iwl4965_tx_queue_init - Allocate and initialize one tx/cmd queue
- */
-int iwl4965_tx_queue_init(struct iwl_priv *priv,
-		      struct iwl4965_tx_queue *txq, int slots_num, u32 txq_id)
-{
-	struct pci_dev *dev = priv->pci_dev;
-	int len;
-	int rc = 0;
-
-	/*
-	 * Alloc buffer array for commands (Tx or other types of commands).
-	 * For the command queue (#4), allocate command space + one big
-	 * command for scan, since scan command is very huge; the system will
-	 * not have two scans at the same time, so only one is needed.
-	 * For normal Tx queues (all other queues), no super-size command
-	 * space is needed.
-	 */
-	len = sizeof(struct iwl_cmd) * slots_num;
-	if (txq_id == IWL_CMD_QUEUE_NUM)
-		len +=  IWL_MAX_SCAN_SIZE;
-	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
-	if (!txq->cmd)
-		return -ENOMEM;
-
-	/* Alloc driver data array and TFD circular buffer */
-	rc = iwl4965_tx_queue_alloc(priv, txq, txq_id);
-	if (rc) {
-		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
-
-		return -ENOMEM;
-	}
-	txq->need_update = 0;
-
-	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
-	 * iwl_queue_inc_wrap and iwl_queue_dec_wrap are broken. */
-	BUILD_BUG_ON(TFD_QUEUE_SIZE_MAX & (TFD_QUEUE_SIZE_MAX - 1));
-
-	/* Initialize queue's high/low-water marks, and head/tail indexes */
-	iwl4965_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
-
-	/* Tell device where to find queue */
-	iwl4965_hw_tx_queue_init(priv, txq);
-
-	return 0;
-}
-
-/**
- * iwl4965_tx_queue_free - Deallocate DMA queue.
- * @txq: Transmit queue to deallocate.
- *
- * Empty queue by removing and destroying all BD's.
- * Free all buffers.
- * 0-fill, but do not free "txq" descriptor structure.
- */
-void iwl4965_tx_queue_free(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
-{
-	struct iwl4965_queue *q = &txq->q;
-	struct pci_dev *dev = priv->pci_dev;
-	int len;
-
-	if (q->n_bd == 0)
-		return;
-
-	/* first, empty all BD's */
-	for (; q->write_ptr != q->read_ptr;
-	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
-		iwl4965_hw_txq_free_tfd(priv, txq);
-
-	len = sizeof(struct iwl_cmd) * q->n_window;
-	if (q->id == IWL_CMD_QUEUE_NUM)
-		len += IWL_MAX_SCAN_SIZE;
-
-	/* De-alloc array of command/tx buffers */
-	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
-
-	/* De-alloc circular buffer of TFDs */
-	if (txq->q.n_bd)
-		pci_free_consistent(dev, sizeof(struct iwl4965_tfd_frame) *
-				    txq->q.n_bd, txq->bd, txq->q.dma_addr);
-
-	/* De-alloc array of per-TFD driver data */
-	if (txq->txb) {
-		kfree(txq->txb);
-		txq->txb = NULL;
-	}
-
-	/* 0-fill queue descriptor structure */
-	memset(txq, 0, sizeof(*txq));
-}
-
 const u8 iwl4965_broadcast_addr[ETH_ALEN] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF };
 
 /*************** STATION TABLE MANAGEMENT ****
@@ -516,7 +349,7 @@ int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl4965_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl4965_queue *q = &txq->q;
-	struct iwl4965_tfd_frame *tfd;
+	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
 	struct iwl_cmd *out_cmd;
 	u32 idx;
@@ -1931,7 +1764,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 		      struct sk_buff *skb, struct ieee80211_tx_control *ctl)
 {
 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
-	struct iwl4965_tfd_frame *tfd;
+	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
 	int txq_id = ctl->queue;
 	struct iwl4965_tx_queue *txq = NULL;
@@ -2515,7 +2348,7 @@ int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 		if (txq_id != IWL_CMD_QUEUE_NUM) {
 			iwl4965_txstatus_to_ieee(priv,
 					&(txq->txb[txq->q.read_ptr]));
-			iwl4965_hw_txq_free_tfd(priv, txq);
+			iwl_hw_txq_free_tfd(priv, txq);
 		} else if (nfreed > 1) {
 			IWL_ERROR("HCMD skipped: index (%d) %d %d\n", index,
 					q->write_ptr, q->read_ptr);
@@ -4678,7 +4511,7 @@ static int __iwl4965_up(struct iwl_priv *priv)
 		return ret;
 	}
 
-	ret = priv->cfg->ops->lib->hw_nic_init(priv);
+	ret = iwl_hw_nic_init(priv);
 	if (ret) {
 		IWL_ERROR("Unable to init nic\n");
 		return ret;
@@ -6941,7 +6774,7 @@ static void __devexit iwl4965_pci_remove(struct pci_dev *pdev)
 
 	if (priv->rxq.bd)
 		iwl_rx_queue_free(priv, &priv->rxq);
-	iwl4965_hw_txq_ctx_free(priv);
+	iwl_hw_txq_ctx_free(priv);
 
 	iwlcore_clear_stations_table(priv);
 	iwl_eeprom_free(priv);
-- 
1.5.3.6

