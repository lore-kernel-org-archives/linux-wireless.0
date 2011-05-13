Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750911Ab1EMTin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:43 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 02/13] iwlagn: clean up TXQ indirection
Date: Fri, 13 May 2011 12:13:19 -0700
Message-Id: <1305314010-18073-3-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213858_315196_C664091E)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

All of these functions no longer need to be
accessed indirectly since they're shared in
all AGN devices.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-2000.c      |    4 -
 drivers/net/wireless/iwlwifi/iwl-5000.c      |    8 --
 drivers/net/wireless/iwlwifi/iwl-6000.c      |    8 --
 drivers/net/wireless/iwlwifi/iwl-agn-tx.c    |   16 +--
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |  149 ------------------------
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-core.h      |   10 --
 drivers/net/wireless/iwlwifi/iwl-tx.c        |  160 +++++++++++++++++++++++++-
 10 files changed, 164 insertions(+), 203 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index b4c8193..61d4a11 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -171,10 +171,6 @@ static int iwl1000_hw_set_hw_params(struct iwl_priv *priv)
 
 static struct iwl_lib_ops iwl1000_lib = {
 	.set_hw_params = iwl1000_hw_set_hw_params,
-	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = iwl_hw_txq_free_tfd,
-	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-2000.c b/drivers/net/wireless/iwlwifi/iwl-2000.c
index 9f34cd7..86feec8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-2000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-2000.c
@@ -252,10 +252,6 @@ static int iwl2030_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl2000_lib = {
 	.set_hw_params = iwl2000_hw_set_hw_params,
-	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = iwl_hw_txq_free_tfd,
-	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 09751f2..a70b8cf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -339,10 +339,6 @@ static int iwl5000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl5000_lib = {
 	.set_hw_params = iwl5000_hw_set_hw_params,
-	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = iwl_hw_txq_free_tfd,
-	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
@@ -374,10 +370,6 @@ static struct iwl_lib_ops iwl5000_lib = {
 
 static struct iwl_lib_ops iwl5150_lib = {
 	.set_hw_params = iwl5150_hw_set_hw_params,
-	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = iwl_hw_txq_free_tfd,
-	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 860c26e..f8c710d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -278,10 +278,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = iwl_hw_txq_free_tfd,
-	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwlagn_rx_handler_setup,
 	.setup_deferred_work = iwlagn_setup_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
@@ -314,10 +310,6 @@ static struct iwl_lib_ops iwl6000_lib = {
 
 static struct iwl_lib_ops iwl6030_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
-	.txq_set_sched = iwlagn_txq_set_sched,
-	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
-	.txq_free_tfd = iwl_hw_txq_free_tfd,
-	.txq_init = iwl_hw_tx_queue_init,
 	.rx_handler_setup = iwlagn_bt_rx_handler_setup,
 	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
 	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
index 7c1becf..d34e103 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-tx.c
@@ -750,12 +750,10 @@ int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	spin_unlock(&priv->sta_lock);
 
 	/* Attach buffers to TFD */
-	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   txcmd_phys, firstlen, 1, 0);
+	iwlagn_txq_attach_buf_to_tfd(priv, txq, txcmd_phys, firstlen, 1, 0);
 	if (secondlen > 0)
-		priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-							   phys_addr, secondlen,
-							   0, 0);
+		iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr,
+					     secondlen, 0, 0);
 
 	scratch_phys = txcmd_phys + sizeof(struct iwl_cmd_header) +
 				offsetof(struct iwl_tx_cmd, scratch);
@@ -911,7 +909,7 @@ int iwlagn_txq_ctx_alloc(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
-	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+	iwlagn_txq_set_sched(priv, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
 	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
@@ -949,7 +947,7 @@ void iwlagn_txq_ctx_reset(struct iwl_priv *priv)
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Turn off all Tx DMA fifos */
-	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+	iwlagn_txq_set_sched(priv, 0);
 
 	/* Tell NIC where to find the "keep warm" buffer */
 	iwl_write_direct32(priv, FH_KW_MEM_ADDR_REG, priv->kw.dma >> 4);
@@ -975,7 +973,7 @@ void iwlagn_txq_ctx_stop(struct iwl_priv *priv)
 	/* Turn off all Tx DMA fifos */
 	spin_lock_irqsave(&priv->lock, flags);
 
-	priv->cfg->ops->lib->txq_set_sched(priv, 0);
+	iwlagn_txq_set_sched(priv, 0);
 
 	/* Stop each Tx DMA channel, and wait for it to be idle */
 	for (ch = 0; ch < priv->hw_params.dma_chnl_num; ch++) {
@@ -1258,7 +1256,7 @@ int iwlagn_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 
 		iwlagn_txq_inval_byte_cnt_tbl(priv, txq);
 
-		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+		iwlagn_txq_free_tfd(priv, txq);
 	}
 	return nfreed;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index e35755c..97de5d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -440,7 +440,7 @@ static int iwlagn_alive_notify(struct iwl_priv *priv)
 			IWL_MASK(0, priv->hw_params.max_txq_num));
 
 	/* Activate all Tx DMA/FIFO channels */
-	priv->cfg->ops->lib->txq_set_sched(priv, IWL_MASK(0, 7));
+	iwlagn_txq_set_sched(priv, IWL_MASK(0, 7));
 
 	/* map queues to FIFOs */
 	if (priv->valid_contexts != BIT(IWL_RXON_CTX_BSS))
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2713081..2bb08d7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -200,155 +200,6 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	return err;
 }
 
-static inline dma_addr_t iwl_tfd_tb_get_addr(struct iwl_tfd *tfd, u8 idx)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-
-	dma_addr_t addr = get_unaligned_le32(&tb->lo);
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		addr |=
-		((dma_addr_t)(le16_to_cpu(tb->hi_n_len) & 0xF) << 16) << 16;
-
-	return addr;
-}
-
-static inline u16 iwl_tfd_tb_get_len(struct iwl_tfd *tfd, u8 idx)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-
-	return le16_to_cpu(tb->hi_n_len) >> 4;
-}
-
-static inline void iwl_tfd_set_tb(struct iwl_tfd *tfd, u8 idx,
-				  dma_addr_t addr, u16 len)
-{
-	struct iwl_tfd_tb *tb = &tfd->tbs[idx];
-	u16 hi_n_len = len << 4;
-
-	put_unaligned_le32(addr, &tb->lo);
-	if (sizeof(dma_addr_t) > sizeof(u32))
-		hi_n_len |= ((addr >> 16) >> 16) & 0xF;
-
-	tb->hi_n_len = cpu_to_le16(hi_n_len);
-
-	tfd->num_tbs = idx + 1;
-}
-
-static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
-{
-	return tfd->num_tbs & 0x1f;
-}
-
-/**
- * iwl_hw_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
- * @priv - driver private data
- * @txq - tx queue
- *
- * Does NOT advance any TFD circular buffer read/write indexes
- * Does NOT free the TFD itself (which is within circular buffer)
- */
-void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
-{
-	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)txq->tfds;
-	struct iwl_tfd *tfd;
-	struct pci_dev *dev = priv->pci_dev;
-	int index = txq->q.read_ptr;
-	int i;
-	int num_tbs;
-
-	tfd = &tfd_tmp[index];
-
-	/* Sanity check on number of chunks */
-	num_tbs = iwl_tfd_get_num_tbs(tfd);
-
-	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(priv, "Too many chunks: %i\n", num_tbs);
-		/* @todo issue fatal error, it is quite serious situation */
-		return;
-	}
-
-	/* Unmap tx_cmd */
-	if (num_tbs)
-		pci_unmap_single(dev,
-				dma_unmap_addr(&txq->meta[index], mapping),
-				dma_unmap_len(&txq->meta[index], len),
-				PCI_DMA_BIDIRECTIONAL);
-
-	/* Unmap chunks, if any. */
-	for (i = 1; i < num_tbs; i++)
-		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
-				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
-
-	/* free SKB */
-	if (txq->txb) {
-		struct sk_buff *skb;
-
-		skb = txq->txb[txq->q.read_ptr].skb;
-
-		/* can be called from irqs-disabled context */
-		if (skb) {
-			dev_kfree_skb_any(skb);
-			txq->txb[txq->q.read_ptr].skb = NULL;
-		}
-	}
-}
-
-int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
-				 struct iwl_tx_queue *txq,
-				 dma_addr_t addr, u16 len,
-				 u8 reset, u8 pad)
-{
-	struct iwl_queue *q;
-	struct iwl_tfd *tfd, *tfd_tmp;
-	u32 num_tbs;
-
-	q = &txq->q;
-	tfd_tmp = (struct iwl_tfd *)txq->tfds;
-	tfd = &tfd_tmp[q->write_ptr];
-
-	if (reset)
-		memset(tfd, 0, sizeof(*tfd));
-
-	num_tbs = iwl_tfd_get_num_tbs(tfd);
-
-	/* Each TFD can point to a maximum 20 Tx buffers */
-	if (num_tbs >= IWL_NUM_OF_TBS) {
-		IWL_ERR(priv, "Error can not send more than %d chunks\n",
-			  IWL_NUM_OF_TBS);
-		return -EINVAL;
-	}
-
-	if (WARN_ON(addr & ~DMA_BIT_MASK(36)))
-		return -EINVAL;
-
-	if (unlikely(addr & ~IWL_TX_DMA_MASK))
-		IWL_ERR(priv, "Unaligned address = %llx\n",
-			  (unsigned long long)addr);
-
-	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
-
-	return 0;
-}
-
-/*
- * Tell nic where to find circular buffer of Tx Frame Descriptors for
- * given Tx queue, and enable the DMA channel used for that queue.
- *
- * supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
- * channels supported in hardware.
- */
-int iwl_hw_tx_queue_init(struct iwl_priv *priv,
-			 struct iwl_tx_queue *txq)
-{
-	int txq_id = txq->q.id;
-
-	/* Circular buffer (TFD queue in DRAM) physical base address */
-	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
-			     txq->q.dma_addr >> 8);
-
-	return 0;
-}
-
 static void iwl_bg_beacon_update(struct work_struct *work)
 {
 	struct iwl_priv *priv =
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index fe33fe8..269e0c4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -191,12 +191,10 @@ int iwlagn_hwrate_to_mac80211_idx(u32 rate_n_flags, enum ieee80211_band band);
 void iwl_setup_rx_handlers(struct iwl_priv *priv);
 
 /* tx */
-void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
-int iwl_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
+int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 				 struct iwl_tx_queue *txq,
 				 dma_addr_t addr, u16 len, u8 reset, u8 pad);
-int iwl_hw_tx_queue_init(struct iwl_priv *priv,
-			 struct iwl_tx_queue *txq);
 void iwlagn_hwrate_to_tx_control(struct iwl_priv *priv, u32 rate_n_flags,
 			      struct ieee80211_tx_info *info);
 int iwlagn_tx_skb(struct iwl_priv *priv, struct sk_buff *skb);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 5b5b0cc..3bb76f6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -127,16 +127,6 @@ struct iwl_temp_ops {
 struct iwl_lib_ops {
 	/* set hw dependent parameters */
 	int (*set_hw_params)(struct iwl_priv *priv);
-	/* Handling TX */
-	void (*txq_set_sched)(struct iwl_priv *priv, u32 mask);
-	int (*txq_attach_buf_to_tfd)(struct iwl_priv *priv,
-				     struct iwl_tx_queue *txq,
-				     dma_addr_t addr,
-				     u16 len, u8 reset, u8 pad);
-	void (*txq_free_tfd)(struct iwl_priv *priv,
-			     struct iwl_tx_queue *txq);
-	int (*txq_init)(struct iwl_priv *priv,
-			struct iwl_tx_queue *txq);
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
 	/* setup deferred work */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 7843195..302284b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -32,6 +32,7 @@
 #include <linux/slab.h>
 #include <net/mac80211.h>
 #include "iwl-eeprom.h"
+#include "iwl-agn.h"
 #include "iwl-dev.h"
 #include "iwl-core.h"
 #include "iwl-sta.h"
@@ -85,6 +86,154 @@ void iwl_txq_update_write_ptr(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	txq->need_update = 0;
 }
 
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
+
+/**
+ * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
+ * @priv - driver private data
+ * @txq - tx queue
+ *
+ * Does NOT advance any TFD circular buffer read/write indexes
+ * Does NOT free the TFD itself (which is within circular buffer)
+ */
+void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+{
+	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)txq->tfds;
+	struct iwl_tfd *tfd;
+	struct pci_dev *dev = priv->pci_dev;
+	int index = txq->q.read_ptr;
+	int i;
+	int num_tbs;
+
+	tfd = &tfd_tmp[index];
+
+	/* Sanity check on number of chunks */
+	num_tbs = iwl_tfd_get_num_tbs(tfd);
+
+	if (num_tbs >= IWL_NUM_OF_TBS) {
+		IWL_ERR(priv, "Too many chunks: %i\n", num_tbs);
+		/* @todo issue fatal error, it is quite serious situation */
+		return;
+	}
+
+	/* Unmap tx_cmd */
+	if (num_tbs)
+		pci_unmap_single(dev,
+				dma_unmap_addr(&txq->meta[index], mapping),
+				dma_unmap_len(&txq->meta[index], len),
+				PCI_DMA_BIDIRECTIONAL);
+
+	/* Unmap chunks, if any. */
+	for (i = 1; i < num_tbs; i++)
+		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
+				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
+
+	/* free SKB */
+	if (txq->txb) {
+		struct sk_buff *skb;
+
+		skb = txq->txb[txq->q.read_ptr].skb;
+
+		/* can be called from irqs-disabled context */
+		if (skb) {
+			dev_kfree_skb_any(skb);
+			txq->txb[txq->q.read_ptr].skb = NULL;
+		}
+	}
+}
+
+int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
+				 struct iwl_tx_queue *txq,
+				 dma_addr_t addr, u16 len,
+				 u8 reset, u8 pad)
+{
+	struct iwl_queue *q;
+	struct iwl_tfd *tfd, *tfd_tmp;
+	u32 num_tbs;
+
+	q = &txq->q;
+	tfd_tmp = (struct iwl_tfd *)txq->tfds;
+	tfd = &tfd_tmp[q->write_ptr];
+
+	if (reset)
+		memset(tfd, 0, sizeof(*tfd));
+
+	num_tbs = iwl_tfd_get_num_tbs(tfd);
+
+	/* Each TFD can point to a maximum 20 Tx buffers */
+	if (num_tbs >= IWL_NUM_OF_TBS) {
+		IWL_ERR(priv, "Error can not send more than %d chunks\n",
+			  IWL_NUM_OF_TBS);
+		return -EINVAL;
+	}
+
+	if (WARN_ON(addr & ~DMA_BIT_MASK(36)))
+		return -EINVAL;
+
+	if (unlikely(addr & ~IWL_TX_DMA_MASK))
+		IWL_ERR(priv, "Unaligned address = %llx\n",
+			  (unsigned long long)addr);
+
+	iwl_tfd_set_tb(tfd, num_tbs, addr, len);
+
+	return 0;
+}
+
+/*
+ * Tell nic where to find circular buffer of Tx Frame Descriptors for
+ * given Tx queue, and enable the DMA channel used for that queue.
+ *
+ * supports up to 16 Tx queues in DRAM, mapped to up to 8 Tx DMA
+ * channels supported in hardware.
+ */
+static int iwlagn_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+{
+	int txq_id = txq->q.id;
+
+	/* Circular buffer (TFD queue in DRAM) physical base address */
+	iwl_write_direct32(priv, FH_MEM_CBBC_QUEUE(txq_id),
+			     txq->q.dma_addr >> 8);
+
+	return 0;
+}
+
 /**
  * iwl_tx_queue_unmap -  Unmap any remaining DMA mappings and free skb's
  */
@@ -97,7 +246,7 @@ void iwl_tx_queue_unmap(struct iwl_priv *priv, int txq_id)
 		return;
 
 	 while (q->write_ptr != q->read_ptr) {
-		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
+		iwlagn_txq_free_tfd(priv, txq);
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
 }
@@ -391,7 +540,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 		return ret;
 
 	/* Tell device where to find queue */
-	priv->cfg->ops->lib->txq_init(priv, txq);
+	iwlagn_tx_queue_init(priv, txq);
 
 	return 0;
 err:
@@ -420,7 +569,7 @@ void iwl_tx_queue_reset(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	iwl_queue_init(priv, &txq->q, TFD_QUEUE_SIZE_MAX, slots_num, txq_id);
 
 	/* Tell device where to find queue */
-	priv->cfg->ops->lib->txq_init(priv, txq);
+	iwlagn_tx_queue_init(priv, txq);
 }
 
 /*************** HOST COMMAND QUEUE FUNCTIONS   *****/
@@ -553,9 +702,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	trace_iwlwifi_dev_hcmd(priv, &out_cmd->hdr, fix_size, cmd->flags);
 
-	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   phys_addr, fix_size, 1,
-						   U32_PAD(cmd->len[0]));
+	iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr, fix_size, 1,
+				     U32_PAD(cmd->len[0]));
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-- 
1.7.0.4

