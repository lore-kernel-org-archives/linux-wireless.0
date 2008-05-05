Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:3844 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692AbYEECYc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 May 2008 22:24:32 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 23/25] iwlwifi: remove 4965 prefix from iwl4965_kw and iwl4965_tx_queue
Date: Mon,  5 May 2008 10:22:50 +0800
Message-Id: <1209954172-3092-24-git-send-email-yi.zhu@intel.com> (sfid-20080505_044416_724979_9A11BB08)
In-Reply-To: <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
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
 <1209954172-3092-17-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-18-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-19-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-20-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-21-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-22-git-send-email-yi.zhu@intel.com>
 <1209954172-3092-23-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ron Rindjunsky <ron.rindjunsky@intel.com>

This patch removes the 4965 prefix to form iwl_kw and iwl_tx_queue structs,
as they are used mostly in iwlcore now.

Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    6 +++---
 drivers/net/wireless/iwlwifi/iwl-core.h     |    4 ++--
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   14 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   11 +++++------
 drivers/net/wireless/iwlwifi/iwl4965-base.c |   14 +++++++-------
 7 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 9be2847..9801c31 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -880,7 +880,7 @@ static void iwl4965_set_wr_ptrs(struct iwl_priv *priv, int txq_id, u32 index)
  * NOTE:  Acquire priv->lock before calling this function !
  */
 static void iwl4965_tx_queue_set_status(struct iwl_priv *priv,
-					struct iwl4965_tx_queue *txq,
+					struct iwl_tx_queue *txq,
 					int tx_fifo_id, int scd_retry)
 {
 	int txq_id = txq->q.id;
@@ -2111,7 +2111,7 @@ static void iwl4965_free_shared_mem(struct iwl_priv *priv)
  * iwl4965_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
 static void iwl4965_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-					    struct iwl4965_tx_queue *txq,
+					    struct iwl_tx_queue *txq,
 					    u16 byte_cnt)
 {
 	int len;
@@ -3286,7 +3286,7 @@ static void iwl4965_rx_reply_compressed_ba(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = (struct iwl_rx_packet *)rxb->skb->data;
 	struct iwl4965_compressed_ba_resp *ba_resp = &pkt->u.compressed_ba;
 	int index;
-	struct iwl4965_tx_queue *txq = NULL;
+	struct iwl_tx_queue *txq = NULL;
 	struct iwl_ht_agg *agg;
 	DECLARE_MAC_BUF(mac);
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index d6b91f7..43b4d20 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -386,7 +386,7 @@ static int iwl5000_shared_mem_rx_idx(struct iwl_priv *priv)
  * iwl5000_txq_update_byte_cnt_tbl - Set up entry in Tx byte-count array
  */
 static void iwl5000_txq_update_byte_cnt_tbl(struct iwl_priv *priv,
-					    struct iwl4965_tx_queue *txq,
+					    struct iwl_tx_queue *txq,
 					    u16 byte_cnt)
 {
 	struct iwl5000_shared *shared_data = priv->shared_virt;
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index c29d287..2158881 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -143,9 +143,9 @@ out:
 int iwl_kw_alloc(struct iwl_priv *priv)
 {
 	struct pci_dev *dev = priv->pci_dev;
-	struct iwl4965_kw *kw = &priv->kw;
+	struct iwl_kw *kw = &priv->kw;
 
-	kw->size = IWL4965_KW_SIZE;	/* TBW need set somewhere else */
+	kw->size = IWL_KW_SIZE;
 	kw->v_addr = pci_alloc_consistent(dev, kw->size, &kw->dma_addr);
 	if (!kw->v_addr)
 		return -ENOMEM;
@@ -159,7 +159,7 @@ int iwl_kw_alloc(struct iwl_priv *priv)
 void iwl_kw_free(struct iwl_priv *priv)
 {
 	struct pci_dev *dev = priv->pci_dev;
-	struct iwl4965_kw *kw = &priv->kw;
+	struct iwl_kw *kw = &priv->kw;
 
 	if (kw->v_addr) {
 		pci_free_consistent(dev, kw->size, kw->v_addr, kw->dma_addr);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 77428db..83fe0cb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -105,7 +105,7 @@ struct iwl_lib_ops {
 	void (*free_shared_mem)(struct iwl_priv *priv);
 	int (*shared_mem_rx_idx)(struct iwl_priv *priv);
 	void (*txq_update_byte_cnt_tbl)(struct iwl_priv *priv,
-					struct iwl4965_tx_queue *txq,
+					struct iwl_tx_queue *txq,
 					u16 byte_cnt);
 	/* setup Rx handler */
 	void (*rx_handler_setup)(struct iwl_priv *priv);
@@ -207,7 +207,7 @@ void iwl_rx_allocate(struct iwl_priv *priv);
 ******************************************************/
 int iwl_txq_ctx_reset(struct iwl_priv *priv);
 /* FIXME: remove when free Tx is fully merged into iwlcore */
-int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq);
+int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 void iwl_hw_txq_ctx_free(struct iwl_priv *priv);
 
 /*****************************************************
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1683bee..5dccc5a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -124,7 +124,7 @@ struct iwl4965_tx_info {
 };
 
 /**
- * struct iwl4965_tx_queue - Tx Queue for DMA
+ * struct iwl_tx_queue - Tx Queue for DMA
  * @q: generic Rx/Tx queue descriptor
  * @bd: base of circular buffer of TFDs
  * @cmd: array of command/Tx buffers
@@ -136,7 +136,7 @@ struct iwl4965_tx_info {
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
  */
-struct iwl4965_tx_queue {
+struct iwl_tx_queue {
 	struct iwl4965_queue q;
 	struct iwl_tfd_frame *bd;
 	struct iwl_cmd *cmd;
@@ -729,7 +729,7 @@ extern void iwl4965_radio_kill_sw(struct iwl_priv *priv, int disable_radio);
  * Forward declare iwl-4965.c functions for iwl-base.c
  */
 extern int iwl4965_tx_queue_update_wr_ptr(struct iwl_priv *priv,
-					  struct iwl4965_tx_queue *txq,
+					  struct iwl_tx_queue *txq,
 					  u16 byte_cnt);
 extern void iwl4965_add_station(struct iwl_priv *priv, const u8 *addr,
 				int is_ap);
@@ -761,9 +761,9 @@ static inline void iwl4965_init_ht_hw_capab(const struct iwl_priv *priv,
 #endif /*CONFIG_IWL4965_HT */
 /* Structures, enum, and defines specific to the 4965 */
 
-#define IWL4965_KW_SIZE 0x1000	/*4k */
+#define IWL_KW_SIZE 0x1000	/*4k */
 
-struct iwl4965_kw {
+struct iwl_kw {
 	dma_addr_t dma_addr;
 	void *v_addr;
 	size_t size;
@@ -1061,9 +1061,9 @@ struct iwl_priv {
 
 	/* Rx and Tx DMA processing queues */
 	struct iwl_rx_queue rxq;
-	struct iwl4965_tx_queue txq[IWL_MAX_NUM_QUEUES];
+	struct iwl_tx_queue txq[IWL_MAX_NUM_QUEUES];
 	unsigned long txq_ctx_active_msk;
-	struct iwl4965_kw kw;	/* keep warm address */
+	struct iwl_kw kw;	/* keep warm address */
 	u32 scd_base_addr;	/* scheduler sram base address */
 
 	unsigned long status;
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index ade247e..a1e03cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -41,7 +41,7 @@
  * Does NOT advance any TFD circular buffer read/write indexes
  * Does NOT free the TFD itself (which is within circular buffer)
  */
-int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl4965_tx_queue *txq)
+int iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_tfd_frame *bd_tmp = (struct iwl_tfd_frame *)&txq->bd[0];
 	struct iwl_tfd_frame *bd = &bd_tmp[txq->q.read_ptr];
@@ -103,8 +103,7 @@ EXPORT_SYMBOL(iwl_hw_txq_free_tfd);
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-static void iwl_tx_queue_free(struct iwl_priv *priv,
-			      struct iwl4965_tx_queue *txq)
+static void iwl_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl4965_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
@@ -191,7 +190,7 @@ static int iwl_queue_init(struct iwl_priv *priv, struct iwl4965_queue *q,
  * iwl_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
  */
 static int iwl_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl4965_tx_queue *txq, u32 id)
+			      struct iwl_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 
@@ -238,7 +237,7 @@ static int iwl_tx_queue_alloc(struct iwl_priv *priv,
  * channels supported in hardware.
  */
 static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
-				struct iwl4965_tx_queue *txq)
+				struct iwl_tx_queue *txq)
 {
 	int rc;
 	unsigned long flags;
@@ -270,7 +269,7 @@ static int iwl_hw_tx_queue_init(struct iwl_priv *priv,
  * iwl_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
 static int iwl_tx_queue_init(struct iwl_priv *priv,
-			     struct iwl4965_tx_queue *txq,
+			     struct iwl_tx_queue *txq,
 			     int slots_num, u32 txq_id)
 {
 	struct pci_dev *dev = priv->pci_dev;
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index d942e98..3b091fc 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -54,7 +54,7 @@
 #include "iwl-calib.h"
 
 static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl4965_tx_queue *txq);
+				  struct iwl_tx_queue *txq);
 
 /******************************************************************************
  *
@@ -347,7 +347,7 @@ u8 iwl4965_add_station_flags(struct iwl_priv *priv, const u8 *addr,
  */
 int iwl4965_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	struct iwl4965_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
+	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl4965_queue *q = &txq->q;
 	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
@@ -1767,7 +1767,7 @@ static int iwl4965_tx_skb(struct iwl_priv *priv,
 	struct iwl_tfd_frame *tfd;
 	u32 *control_flags;
 	int txq_id = ctl->queue;
-	struct iwl4965_tx_queue *txq = NULL;
+	struct iwl_tx_queue *txq = NULL;
 	struct iwl4965_queue *q = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
@@ -2331,7 +2331,7 @@ static void iwl4965_txstatus_to_ieee(struct iwl_priv *priv,
  */
 int iwl4965_tx_queue_reclaim(struct iwl_priv *priv, int txq_id, int index)
 {
-	struct iwl4965_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl4965_queue *q = &txq->q;
 	int nfreed = 0;
 
@@ -2537,7 +2537,7 @@ static void iwl4965_rx_reply_tx(struct iwl_priv *priv,
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
-	struct iwl4965_tx_queue *txq = &priv->txq[txq_id];
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct ieee80211_tx_status *tx_status;
 	struct iwl4965_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
@@ -3274,7 +3274,7 @@ int iwl4965_calc_sig_qual(int rssi_dbm, int noise_dbm)
  * iwl4965_tx_queue_update_write_ptr - Send new write index to hardware
  */
 static int iwl4965_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl4965_tx_queue *txq)
+				  struct iwl_tx_queue *txq)
 {
 	u32 reg = 0;
 	int rc = 0;
@@ -5784,7 +5784,7 @@ static int iwl4965_mac_get_tx_stats(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 	int i, avail;
-	struct iwl4965_tx_queue *txq;
+	struct iwl_tx_queue *txq;
 	struct iwl4965_queue *q;
 	unsigned long flags;
 
-- 
1.5.3.6

