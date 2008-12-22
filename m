Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:37081 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbYLVDin (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Dec 2008 22:38:43 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 03/10] iwl3945: sync tx queue data structure with iwlagn
Date: Mon, 22 Dec 2008 11:31:16 +0800
Message-Id: <1229916683-9772-4-git-send-email-yi.zhu@intel.com> (sfid-20081222_043853_712179_18EA6D60)
In-Reply-To: <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
References: <1229916683-9772-1-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-2-git-send-email-yi.zhu@intel.com>
 <1229916683-9772-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

We are now using the iwl_tx_queue for iwl3945. To reach that goal, we
included the 3945 specific tfd frame structure to iwl_tx_queue. This
has no effect on the current iwlagn code.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |    4 -
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   14 ++--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h  |    3 -
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   28 +-----
 drivers/net/wireless/iwlwifi/iwl-fh.h       |   11 +++
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  125 ++++++++++++++++----------
 7 files changed, 103 insertions(+), 90 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 1ba59df..c9db98c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -240,7 +240,6 @@ struct iwl3945_eeprom {
 
 #define TFD_QUEUE_MIN           0
 #define TFD_QUEUE_MAX           6
-#define TFD_QUEUE_SIZE_MAX      (256)
 
 #define IWL_NUM_SCAN_RATES         (2)
 
@@ -262,9 +261,6 @@ struct iwl3945_eeprom {
 #define TFD_CTL_PAD_SET(n)         (n << 28)
 #define TFD_CTL_PAD_GET(ctl)       (ctl >> 28)
 
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
 /*
  * RX related structures and functions
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index a0aea81..41556b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -306,7 +306,7 @@ int iwl3945_rs_next_rate(struct iwl_priv *priv, int rate)
 static void iwl3945_tx_queue_reclaim(struct iwl_priv *priv,
 				     int txq_id, int index)
 {
-	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	struct iwl_tx_info *tx_info;
 
@@ -337,7 +337,7 @@ static void iwl3945_rx_reply_tx(struct iwl_priv *priv,
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
-	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct ieee80211_tx_info *info;
 	struct iwl3945_tx_resp *tx_resp = (void *)&pkt->u.raw[0];
 	u32  status = le32_to_cpu(tx_resp->status);
@@ -756,9 +756,9 @@ int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *ptr,
  *
  * Does NOT advance any indexes
  */
-int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
+int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
-	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)&txq->tfds[0];
+	struct iwl3945_tfd *tfd_tmp = (struct iwl3945_tfd *)&txq->tfds39[0];
 	struct iwl3945_tfd *tfd = &tfd_tmp[txq->q.read_ptr];
 	struct pci_dev *dev = priv->pci_dev;
 	int i;
@@ -1062,7 +1062,7 @@ static int iwl3945_txq_ctx_reset(struct iwl_priv *priv)
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++) {
 		slots_num = (txq_id == IWL_CMD_QUEUE_NUM) ?
 				TFD_CMD_SLOTS : TFD_TX_CMD_SLOTS;
-		rc = iwl3945_tx_queue_init(priv, &priv->txq39[txq_id], slots_num,
+		rc = iwl3945_tx_queue_init(priv, &priv->txq[txq_id], slots_num,
 				txq_id);
 		if (rc) {
 			IWL_ERR(priv, "Tx %d queue init failed\n", txq_id);
@@ -1252,7 +1252,7 @@ void iwl3945_hw_txq_ctx_free(struct iwl_priv *priv)
 
 	/* Tx queues */
 	for (txq_id = 0; txq_id < TFD_QUEUE_MAX; txq_id++)
-		iwl3945_tx_queue_free(priv, &priv->txq39[txq_id]);
+		iwl3945_tx_queue_free(priv, &priv->txq[txq_id]);
 }
 
 void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv)
@@ -2343,7 +2343,7 @@ int iwl3945_hw_rxq_stop(struct iwl_priv *priv)
 	return 0;
 }
 
-int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
+int iwl3945_hw_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	int rc;
 	unsigned long flags;
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 716c4b4..e584032 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -219,9 +219,9 @@ extern void iwl3945_rx_queue_reset(struct iwl_priv *priv,
 extern int iwl3945_calc_db_from_ratio(int sig_ratio);
 extern int iwl3945_calc_sig_qual(int rssi_dbm, int noise_dbm);
 extern int iwl3945_tx_queue_init(struct iwl_priv *priv,
-			     struct iwl3945_tx_queue *txq, int count, u32 id);
+			     struct iwl_tx_queue *txq, int count, u32 id);
 extern void iwl3945_rx_replenish(void *data);
-extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue *txq);
+extern void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 extern int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len,
 			    const void *data);
 extern int __must_check iwl3945_send_cmd(struct iwl_priv *priv,
@@ -270,10 +270,10 @@ extern void iwl3945_hw_txq_ctx_stop(struct iwl_priv *priv);
 extern int iwl3945_hw_nic_reset(struct iwl_priv *priv);
 extern int iwl3945_hw_txq_attach_buf_to_tfd(struct iwl_priv *priv, void *tfd,
 					dma_addr_t addr, u16 len);
-extern int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl3945_tx_queue *txq);
+extern int iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq);
 extern int iwl3945_hw_get_temperature(struct iwl_priv *priv);
 extern int iwl3945_hw_tx_queue_init(struct iwl_priv *priv,
-				struct iwl3945_tx_queue *txq);
+				struct iwl_tx_queue *txq);
 extern unsigned int iwl3945_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl3945_frame *frame, u8 rate);
 void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 9330b5a..e751c53 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -114,9 +114,6 @@
 #define RX_QUEUE_MASK                         255
 #define RX_QUEUE_SIZE_LOG                     8
 
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
 /*
  * RX related structures and functions
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1ad4d08..9b9d743 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -134,9 +134,13 @@ struct iwl_tx_info {
  * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
  * descriptors) and required locking structures.
  */
+#define TFD_TX_CMD_SLOTS 256
+#define TFD_CMD_SLOTS 32
+
 struct iwl_tx_queue {
 	struct iwl_queue q;
 	struct iwl_tfd *tfds;
+	struct iwl3945_tfd *tfds39;
 	struct iwl_cmd *cmd[TFD_TX_CMD_SLOTS];
 	struct iwl_tx_info *txb;
 	u8 need_update;
@@ -226,28 +230,6 @@ struct iwl_channel_info {
 	struct iwl3945_scan_power_info scan_pwr_info[IWL_NUM_SCAN_RATES];
 };
 
-/**
- * struct iwl3945_tx_queue - Tx Queue for DMA
- * @q: generic Rx/Tx queue descriptor
- * @bd: base of circular buffer of TFDs
- * @cmd: array of command/Tx buffers
- * @dma_addr_cmd: physical address of cmd/tx buffer array
- * @txb: array of per-TFD driver data
- * @need_update: indicates need to update read/write index
- *
- * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
- * descriptors) and required locking structures.
- */
-struct iwl3945_tx_queue {
-	struct iwl_queue q;
-	struct iwl3945_tfd *tfds;
-	struct iwl_cmd *cmd;
-	dma_addr_t dma_addr_cmd;
-	struct iwl_tx_info *txb;
-	int need_update;
-	int active;
-};
-
 #define IWL_TX_FIFO_AC0	0
 #define IWL_TX_FIFO_AC1	1
 #define IWL_TX_FIFO_AC2	2
@@ -1099,8 +1081,6 @@ struct iwl_priv {
 	struct iwl3945_rxon_cmd staging39_rxon;
 	struct iwl3945_rxon_cmd recovery39_rxon;
 
-	struct iwl3945_tx_queue txq39[IWL39_MAX_NUM_QUEUES];
-
 	struct iwl3945_power_mgr power_data_39;
 	struct iwl3945_notif_statistics statistics_39;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 7c19790..313b03b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -478,6 +478,17 @@ struct iwl_tfd {
 	__le32 __pad;
 } __attribute__ ((packed));
 
+struct iwl3945_tfd_frame_data {
+	__le32 addr;
+	__le32 len;
+} __attribute__ ((packed));
+
+struct iwl3945_tfd_frame {
+	__le32 control_flags;
+	struct iwl3945_tfd_frame_data pa[4];
+	u8 reserved[28];
+} __attribute__ ((packed));
+
 
 /* Keep Warm Size */
 #define IWL_KW_SIZE 0x1000	/* 4k */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 5a0e25b..98f5b7f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -57,7 +57,7 @@
 #include "iwl-dev.h"
 
 static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl3945_tx_queue *txq);
+				  struct iwl_tx_queue *txq);
 
 /*
  * module name, copyright, version, etc.
@@ -162,7 +162,7 @@ static int iwl3945_queue_init(struct iwl_priv *priv, struct iwl_queue *q,
  * iwl3945_tx_queue_alloc - Alloc driver data and TFD CB for one Tx/cmd queue
  */
 static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
-			      struct iwl3945_tx_queue *txq, u32 id)
+			      struct iwl_tx_queue *txq, u32 id)
 {
 	struct pci_dev *dev = priv->pci_dev;
 
@@ -181,13 +181,13 @@ static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
 
 	/* Circular buffer of transmit frame descriptors (TFDs),
 	 * shared with device */
-	txq->tfds = pci_alloc_consistent(dev,
-			sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX,
+	txq->tfds39 = pci_alloc_consistent(dev,
+			sizeof(txq->tfds39[0]) * TFD_QUEUE_SIZE_MAX,
 			&txq->q.dma_addr);
 
-	if (!txq->tfds) {
+	if (!txq->tfds39) {
 		IWL_ERR(priv, "pci_alloc_consistent(%zd) failed\n",
-			  sizeof(txq->tfds[0]) * TFD_QUEUE_SIZE_MAX);
+			  sizeof(txq->tfds39[0]) * TFD_QUEUE_SIZE_MAX);
 		goto error;
 	}
 	txq->q.id = id;
@@ -205,10 +205,9 @@ static int iwl3945_tx_queue_alloc(struct iwl_priv *priv,
  * iwl3945_tx_queue_init - Allocate and initialize one tx/cmd queue
  */
 int iwl3945_tx_queue_init(struct iwl_priv *priv,
-		      struct iwl3945_tx_queue *txq, int slots_num, u32 txq_id)
+		      struct iwl_tx_queue *txq, int slots_num, u32 txq_id)
 {
-	struct pci_dev *dev = priv->pci_dev;
-	int len;
+	int len, i;
 	int rc = 0;
 
 	/*
@@ -219,20 +218,25 @@ int iwl3945_tx_queue_init(struct iwl_priv *priv,
 	 * For data Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	len = sizeof(struct iwl_cmd) * slots_num;
-	if (txq_id == IWL_CMD_QUEUE_NUM)
-		len +=  IWL_MAX_SCAN_SIZE;
-	txq->cmd = pci_alloc_consistent(dev, len, &txq->dma_addr_cmd);
-	if (!txq->cmd)
-		return -ENOMEM;
+	len = sizeof(struct iwl_cmd);
+	for (i = 0; i <= slots_num; i++) {
+		if (i == slots_num) {
+			if (txq_id == IWL_CMD_QUEUE_NUM)
+				len += IWL_MAX_SCAN_SIZE;
+			else
+				continue;
+		}
+
+		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
+		if (!txq->cmd[i])
+			goto err;
+	}
 
 	/* Alloc driver data array and TFD circular buffer */
 	rc = iwl3945_tx_queue_alloc(priv, txq, txq_id);
-	if (rc) {
-		pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
+	if (rc)
+		goto err;
 
-		return -ENOMEM;
-	}
 	txq->need_update = 0;
 
 	/* TFD_QUEUE_SIZE_MAX must be power-of-two size, otherwise
@@ -246,6 +250,17 @@ int iwl3945_tx_queue_init(struct iwl_priv *priv,
 	iwl3945_hw_tx_queue_init(priv, txq);
 
 	return 0;
+err:
+	for (i = 0; i < slots_num; i++) {
+		kfree(txq->cmd[i]);
+		txq->cmd[i] = NULL;
+	}
+
+	if (txq_id == IWL_CMD_QUEUE_NUM) {
+		kfree(txq->cmd[slots_num]);
+		txq->cmd[slots_num] = NULL;
+	}
+	return -ENOMEM;
 }
 
 /**
@@ -256,11 +271,11 @@ int iwl3945_tx_queue_init(struct iwl_priv *priv,
  * Free all buffers.
  * 0-fill, but do not free "txq" descriptor structure.
  */
-void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
+void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 {
 	struct iwl_queue *q = &txq->q;
 	struct pci_dev *dev = priv->pci_dev;
-	int len;
+	int len, i;
 
 	if (q->n_bd == 0)
 		return;
@@ -275,12 +290,13 @@ void iwl3945_tx_queue_free(struct iwl_priv *priv, struct iwl3945_tx_queue *txq)
 		len += IWL_MAX_SCAN_SIZE;
 
 	/* De-alloc array of command/tx buffers */
-	pci_free_consistent(dev, len, txq->cmd, txq->dma_addr_cmd);
+	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
+		kfree(txq->cmd[i]);
 
 	/* De-alloc circular buffer of TFDs */
 	if (txq->q.n_bd)
 		pci_free_consistent(dev, sizeof(struct iwl3945_tfd) *
-				    txq->q.n_bd, txq->tfds, txq->q.dma_addr);
+				    txq->q.n_bd, txq->tfds39, txq->q.dma_addr);
 
 	/* De-alloc array of per-TFD driver data */
 	kfree(txq->txb);
@@ -445,7 +461,7 @@ u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flag
  */
 static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	struct iwl3945_tx_queue *txq = &priv->txq39[IWL_CMD_QUEUE_NUM];
+	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
 	struct iwl3945_tfd *tfd;
 	struct iwl_cmd *out_cmd;
@@ -453,7 +469,7 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
 	dma_addr_t phys_addr;
 	int pad;
-	int ret;
+	int ret, len;
 	unsigned long flags;
 
 	/* If any of the command structures end up being larger than
@@ -475,11 +491,11 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	tfd = &txq->tfds[q->write_ptr];
+	tfd = &txq->tfds39[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 
 	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
-	out_cmd = &txq->cmd[idx];
+	out_cmd = txq->cmd[idx];
 
 	out_cmd->hdr.cmd = cmd->id;
 	memcpy(&out_cmd->meta, &cmd->meta, sizeof(cmd->meta));
@@ -494,8 +510,15 @@ static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
 
-	phys_addr = txq->dma_addr_cmd + sizeof(txq->cmd[0]) * idx +
-			offsetof(struct iwl_cmd, hdr);
+	len = (idx == TFD_CMD_SLOTS) ?
+			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
+
+	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
+					len, PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
+	pci_unmap_len_set(&out_cmd->meta, len, len);
+	phys_addr += offsetof(struct iwl_cmd, hdr);
+
 	iwl3945_hw_txq_attach_buf_to_tfd(priv, tfd, phys_addr, fix_size);
 
 	pad = U32_PAD(cmd->len);
@@ -621,7 +644,7 @@ cancel:
 		 * TX cmd queue. Otherwise in case the cmd comes
 		 * in later, it will possibly set an invalid
 		 * address (cmd->meta.source). */
-		qcmd = &priv->txq39[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
+		qcmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
 		qcmd->meta.flags &= ~CMD_WANT_SKB;
 	}
 fail:
@@ -2233,7 +2256,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl3945_tfd *tfd;
 	int txq_id = skb_get_queue_mapping(skb);
-	struct iwl3945_tx_queue *txq = NULL;
+	struct iwl_tx_queue *txq = NULL;
 	struct iwl_queue *q = NULL;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
@@ -2312,13 +2335,13 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	}
 
 	/* Descriptor for chosen Tx queue */
-	txq = &priv->txq39[txq_id];
+	txq = &priv->txq[txq_id];
 	q = &txq->q;
 
 	spin_lock_irqsave(&priv->lock, flags);
 
 	/* Set up first empty TFD within this queue's circular TFD buffer */
-	tfd = &txq->tfds[q->write_ptr];
+	tfd = &txq->tfds39[q->write_ptr];
 	memset(tfd, 0, sizeof(*tfd));
 	idx = get_cmd_index(q, q->write_ptr, 0);
 
@@ -2327,7 +2350,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txq->txb[q->write_ptr].skb[0] = skb;
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
-	out_cmd = &txq->cmd[idx];
+	out_cmd = txq->cmd[idx];
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(&out_cmd->cmd.tx, 0, sizeof(out_cmd->cmd.tx));
 
@@ -2366,8 +2389,14 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Physical address of this Tx command's header (not MAC header!),
 	 * within command buffer array. */
-	txcmd_phys = txq->dma_addr_cmd + sizeof(struct iwl_cmd) * idx +
-		     offsetof(struct iwl_cmd, hdr);
+	txcmd_phys = pci_map_single(priv->pci_dev,
+				    out_cmd, sizeof(struct iwl_cmd),
+				    PCI_DMA_TODEVICE);
+	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
+	pci_unmap_len_set(&out_cmd->meta, len, sizeof(struct iwl_cmd));
+	/* Add buffer containing Tx command and MAC(!) header to TFD's
+	 * first entry */
+	txcmd_phys += offsetof(struct iwl_cmd, hdr);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
@@ -3082,7 +3111,7 @@ static void iwl3945_setup_rx_handlers(struct iwl_priv *priv)
 static void iwl3945_cmd_queue_reclaim(struct iwl_priv *priv,
 				      int txq_id, int index)
 {
-	struct iwl3945_tx_queue *txq = &priv->txq39[txq_id];
+	struct iwl_tx_queue *txq = &priv->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
@@ -3127,8 +3156,8 @@ static void iwl3945_tx_cmd_complete(struct iwl_priv *priv,
 
 	BUG_ON(txq_id != IWL_CMD_QUEUE_NUM);
 
-	cmd_index = get_cmd_index(&priv->txq39[IWL_CMD_QUEUE_NUM].q, index, huge);
-	cmd = &priv->txq39[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
+	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
+	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
 
 	/* Input error checking is done when commands are added to queue. */
 	if (cmd->meta.flags & CMD_WANT_SKB) {
@@ -3684,7 +3713,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
  * iwl3945_tx_queue_update_write_ptr - Send new write index to hardware
  */
 static int iwl3945_tx_queue_update_write_ptr(struct iwl_priv *priv,
-				  struct iwl3945_tx_queue *txq)
+				  struct iwl_tx_queue *txq)
 {
 	u32 reg = 0;
 	int rc = 0;
@@ -4098,12 +4127,12 @@ static void iwl3945_irq_tasklet(struct iwl_priv *priv)
 	if (inta & CSR_INT_BIT_WAKEUP) {
 		IWL_DEBUG_ISR("Wakeup interrupt\n");
 		iwl3945_rx_queue_update_write_ptr(priv, &priv->rxq);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[0]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[1]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[2]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[3]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[4]);
-		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq39[5]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[0]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[1]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[2]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[3]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[4]);
+		iwl3945_tx_queue_update_write_ptr(priv, &priv->txq[5]);
 
 		handled |= CSR_INT_BIT_WAKEUP;
 	}
@@ -6752,7 +6781,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 {
 	struct iwl_priv *priv = hw->priv;
 	int i, avail;
-	struct iwl3945_tx_queue *txq;
+	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
 	unsigned long flags;
 
@@ -6766,7 +6795,7 @@ static int iwl3945_mac_get_tx_stats(struct ieee80211_hw *hw,
 	spin_lock_irqsave(&priv->lock, flags);
 
 	for (i = 0; i < AC_NUM; i++) {
-		txq = &priv->txq39[i];
+		txq = &priv->txq[i];
 		q = &txq->q;
 		avail = iwl_queue_space(q);
 
-- 
1.5.3.6

