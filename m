Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:53622 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752817Ab1EMTio (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 May 2011 15:38:44 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 04/13] iwlagn: support multiple TBs per command
Date: Fri, 13 May 2011 12:13:21 -0700
Message-Id: <1305314010-18073-5-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110513_213855_063009_523B849C)
In-Reply-To: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1305314010-18073-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The current "huge" command handling is a bit
confusing, and very limited since only one
command may be huge at a time. Additionally,
we often copy data around quite pointlessly
since we could instead map the existing scan
buffer for example and use it directly.

This patch makes that possible. The first
change is that multiple buffers may be given
to each command (this change was prepared
earlier so callsites don't need to change).
Each of those can be mapped attached to a TB
in the TFD, and the command header can use a
TB (the first one) in the TFD as well.

Doing this allows getting rid of huge commands
in favour of mapping existing buffers. The
beacon transmission is also optimised to not
copy the SKB at all but use multiple TBs.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-calib.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   28 ++--
 drivers/net/wireless/iwlwifi/iwl-commands.h  |    5 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |   46 +++--
 drivers/net/wireless/iwlwifi/iwl-devtrace.h  |   17 ++-
 drivers/net/wireless/iwlwifi/iwl-sv-open.c   |    1 +
 drivers/net/wireless/iwlwifi/iwl-tx.c        |  231 ++++++++++++++------------
 8 files changed, 180 insertions(+), 152 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
index 30e11c7..d39efcc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-calib.c
@@ -87,7 +87,6 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_PHY_CALIBRATION_CMD,
-		.flags = CMD_SIZE_HUGE,
 	};
 
 	for (i = 0; i < IWL_CALIB_MAX; i++) {
@@ -95,6 +94,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 		    priv->calib_results[i].buf) {
 			hcmd.len[0] = priv->calib_results[i].buf_len;
 			hcmd.data[0] = priv->calib_results[i].buf;
+			hcmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
 			ret = iwl_send_cmd_sync(priv, &hcmd);
 			if (ret) {
 				IWL_ERR(priv, "Error %d iteration %d\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 576f45e..f803fb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1141,7 +1141,6 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = { sizeof(struct iwl_scan_cmd), },
-		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl_scan_cmd *scan;
 	struct iwl_rxon_context *ctx = &priv->contexts[IWL_RXON_CTX_BSS];
@@ -1428,6 +1427,7 @@ int iwlagn_request_scan(struct iwl_priv *priv, struct ieee80211_vif *vif)
 	cmd.len[0] += le16_to_cpu(scan->tx_cmd.len) +
 	    scan->channel_count * sizeof(struct iwl_scan_channel);
 	cmd.data[0] = scan;
+	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
 	scan->len = cpu_to_le16(cmd.len[0]);
 
 	/* set scan bit here for PAN params */
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 2bb08d7..675b9a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -134,12 +134,10 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	struct iwl_tx_beacon_cmd *tx_beacon_cmd;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_BEACON,
-		.flags = CMD_SIZE_HUGE,
 	};
 	u32 frame_size;
 	u32 rate_flags;
 	u32 rate;
-	int err;
 
 	/*
 	 * We have to set up the TX command, the TX Beacon command, and the
@@ -156,17 +154,15 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 	if (WARN_ON(!priv->beacon_skb))
 		return -EINVAL;
 
-	/* Allocate beacon memory */
-	tx_beacon_cmd = kzalloc(sizeof(*tx_beacon_cmd) + priv->beacon_skb->len,
-				GFP_KERNEL);
+	/* Allocate beacon command */
+	if (!priv->beacon_cmd)
+		priv->beacon_cmd = kzalloc(sizeof(*tx_beacon_cmd), GFP_KERNEL);
+	tx_beacon_cmd = priv->beacon_cmd;
 	if (!tx_beacon_cmd)
 		return -ENOMEM;
 
 	frame_size = priv->beacon_skb->len;
 
-	/* Set up TX beacon contents */
-	memcpy(tx_beacon_cmd->frame, priv->beacon_skb->data, frame_size);
-
 	/* Set up TX command fields */
 	tx_beacon_cmd->tx.len = cpu_to_le16((u16)frame_size);
 	tx_beacon_cmd->tx.sta_id = priv->beacon_ctx->bcast_sta_id;
@@ -175,7 +171,7 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 		TX_CMD_FLG_TSF_MSK | TX_CMD_FLG_STA_RATE_MSK;
 
 	/* Set up TX beacon command fields */
-	iwl_set_beacon_tim(priv, tx_beacon_cmd, (u8 *)tx_beacon_cmd->frame,
+	iwl_set_beacon_tim(priv, tx_beacon_cmd, priv->beacon_skb->data,
 			   frame_size);
 
 	/* Set up packet rate and flags */
@@ -189,15 +185,14 @@ int iwlagn_send_beacon_cmd(struct iwl_priv *priv)
 			rate_flags);
 
 	/* Submit command */
-	cmd.len[0] = sizeof(*tx_beacon_cmd) + frame_size;
+	cmd.len[0] = sizeof(*tx_beacon_cmd);
 	cmd.data[0] = tx_beacon_cmd;
+	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
+	cmd.len[1] = frame_size;
+	cmd.data[1] = priv->beacon_skb->data;
+	cmd.dataflags[1] = IWL_HCMD_DFL_NOCOPY;
 
-	err = iwl_send_cmd_sync(priv, &cmd);
-
-	/* Free temporary storage */
-	kfree(tx_beacon_cmd);
-
-	return err;
+	return iwl_send_cmd_sync(priv, &cmd);
 }
 
 static void iwl_bg_beacon_update(struct work_struct *work)
@@ -3246,6 +3241,7 @@ static void iwl_uninit_drv(struct iwl_priv *priv)
 	iwlcore_free_geos(priv);
 	iwl_free_channel_map(priv);
 	kfree(priv->scan_cmd);
+	kfree(priv->beacon_cmd);
 }
 
 struct ieee80211_ops iwlagn_hw_ops = {
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5fdad65..6ee5f1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -205,7 +205,6 @@ enum {
 #define QUEUE_TO_SEQ(q)	(((q) & 0x1f) << 8)
 #define SEQ_TO_INDEX(s)	((s) & 0xff)
 #define INDEX_TO_SEQ(i)	((i) & 0xff)
-#define SEQ_HUGE_FRAME	cpu_to_le16(0x4000)
 #define SEQ_RX_FRAME	cpu_to_le16(0x8000)
 
 /**
@@ -234,9 +233,7 @@ struct iwl_cmd_header {
 	 *
 	 *  0:7		tfd index - position within TX queue
 	 *  8:12	TX queue id
-	 *  13		reserved
-	 *  14		huge - driver sets this to indicate command is in the
-	 *  		'huge' storage at the end of the command buffers
+	 *  13:14	reserved
 	 *  15		unsolicited RX or uCode-originated notification
 	 */
 	__le16 sequence;
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 38254bd..3e3b8b8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -110,8 +110,6 @@ struct iwl_cmd_meta {
 			 struct iwl_device_cmd *cmd,
 			 struct iwl_rx_packet *pkt);
 
-	/* The CMD_SIZE_HUGE flag bit indicates that the command
-	 * structure is stored at the end of the shared queue memory. */
 	u32 flags;
 
 	DEFINE_DMA_UNMAP_ADDR(mapping);
@@ -121,7 +119,23 @@ struct iwl_cmd_meta {
 /*
  * Generic queue structure
  *
- * Contains common data for Rx and Tx queues
+ * Contains common data for Rx and Tx queues.
+ *
+ * Note the difference between n_bd and n_window: the hardware
+ * always assumes 256 descriptors, so n_bd is always 256 (unless
+ * there might be HW changes in the future). For the normal TX
+ * queues, n_window, which is the size of the software queue data
+ * is also 256; however, for the command queue, n_window is only
+ * 32 since we don't need so many commands pending. Since the HW
+ * still uses 256 BDs for DMA though, n_bd stays 256. As a result,
+ * the software buffers (in the variables @meta, @txb in struct
+ * iwl_tx_queue) only have 32 entries, while the HW buffers (@tfds
+ * in the same struct) have 256.
+ * This means that we end up with the following:
+ *  HW entries: | 0 | ... | N * 32 | ... | N * 32 + 31 | ... | 255 |
+ *  SW entries:           | 0      | ... | 31          |
+ * where N is a number between 0 and 7. This means that the SW
+ * data is a window overlayed over the HW queue.
  */
 struct iwl_queue {
 	int n_bd;              /* number of BDs in this queue */
@@ -163,7 +177,7 @@ struct iwl_tx_info {
 
 struct iwl_tx_queue {
 	struct iwl_queue q;
-	void *tfds;
+	struct iwl_tfd *tfds;
 	struct iwl_device_cmd **cmd;
 	struct iwl_cmd_meta *meta;
 	struct iwl_tx_info *txb;
@@ -245,7 +259,6 @@ enum {
 	CMD_SYNC = 0,
 	CMD_SIZE_NORMAL = 0,
 	CMD_NO_SKB = 0,
-	CMD_SIZE_HUGE = (1 << 0),
 	CMD_ASYNC = (1 << 1),
 	CMD_WANT_SKB = (1 << 2),
 	CMD_MAPPED = (1 << 3),
@@ -257,8 +270,8 @@ enum {
  * struct iwl_device_cmd
  *
  * For allocation of the command and tx queues, this establishes the overall
- * size of the largest command we send to uCode, except for a scan command
- * (which is relatively huge; space is allocated separately).
+ * size of the largest command we send to uCode, except for commands that
+ * aren't fully copied and use other TFD space.
  */
 struct iwl_device_cmd {
 	struct iwl_cmd_header hdr;	/* uCode API */
@@ -275,7 +288,11 @@ struct iwl_device_cmd {
 
 #define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
 
-#define IWL_MAX_CMD_TFDS	1
+#define IWL_MAX_CMD_TFDS	2
+
+enum iwl_hcmd_dataflag {
+	IWL_HCMD_DFL_NOCOPY	= BIT(0),
+};
 
 struct iwl_host_cmd {
 	const void *data[IWL_MAX_CMD_TFDS];
@@ -285,6 +302,7 @@ struct iwl_host_cmd {
 			 struct iwl_rx_packet *pkt);
 	u32 flags;
 	u16 len[IWL_MAX_CMD_TFDS];
+	u8 dataflags[IWL_MAX_CMD_TFDS];
 	u8 id;
 };
 
@@ -687,17 +705,8 @@ static inline int iwl_queue_used(const struct iwl_queue *q, int i)
 }
 
 
-static inline u8 get_cmd_index(struct iwl_queue *q, u32 index, int is_huge)
+static inline u8 get_cmd_index(struct iwl_queue *q, u32 index)
 {
-	/*
-	 * This is for init calibration result and scan command which
-	 * required buffer > TFD_MAX_PAYLOAD_SIZE,
-	 * the big buffer at end of command array
-	 */
-	if (is_huge)
-		return q->n_window;	/* must be power of 2 */
-
-	/* Otherwise, use normal size buffers */
 	return index & (q->n_window - 1);
 }
 
@@ -1451,6 +1460,7 @@ struct iwl_priv {
 	struct work_struct beacon_update;
 	struct iwl_rxon_context *beacon_ctx;
 	struct sk_buff *beacon_skb;
+	void *beacon_cmd;
 
 	struct work_struct tt_work;
 	struct work_struct ct_enter;
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index f00172c..fc13186 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -137,20 +137,27 @@ TRACE_EVENT(iwlwifi_dev_ucode_wrap_event,
 #define TRACE_SYSTEM iwlwifi
 
 TRACE_EVENT(iwlwifi_dev_hcmd,
-	TP_PROTO(struct iwl_priv *priv, void *hcmd, size_t len, u32 flags),
-	TP_ARGS(priv, hcmd, len, flags),
+	TP_PROTO(struct iwl_priv *priv, u32 flags,
+		 const void *hcmd0, size_t len0,
+		 const void *hcmd1, size_t len1,
+		 const void *hcmd2, size_t len2),
+	TP_ARGS(priv, flags, hcmd0, len0, hcmd1, len1, hcmd2, len2),
 	TP_STRUCT__entry(
 		PRIV_ENTRY
-		__dynamic_array(u8, hcmd, len)
+		__dynamic_array(u8, hcmd0, len0)
+		__dynamic_array(u8, hcmd1, len1)
+		__dynamic_array(u8, hcmd2, len2)
 		__field(u32, flags)
 	),
 	TP_fast_assign(
 		PRIV_ASSIGN;
-		memcpy(__get_dynamic_array(hcmd), hcmd, len);
+		memcpy(__get_dynamic_array(hcmd0), hcmd0, len0);
+		memcpy(__get_dynamic_array(hcmd1), hcmd1, len1);
+		memcpy(__get_dynamic_array(hcmd2), hcmd2, len2);
 		__entry->flags = flags;
 	),
 	TP_printk("[%p] hcmd %#.2x (%ssync)",
-		  __entry->priv, ((u8 *)__get_dynamic_array(hcmd))[0],
+		  __entry->priv, ((u8 *)__get_dynamic_array(hcmd0))[0],
 		  __entry->flags & CMD_ASYNC ? "a" : "")
 );
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-sv-open.c b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
index 01a8ec9..dd2904a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sv-open.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sv-open.c
@@ -200,6 +200,7 @@ static int iwl_testmode_ucode(struct ieee80211_hw *hw, struct nlattr **tb)
 	cmd.id = nla_get_u8(tb[IWL_TM_ATTR_UCODE_CMD_ID]);
 	cmd.data[0] = nla_data(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
 	cmd.len[0] = nla_len(tb[IWL_TM_ATTR_UCODE_CMD_DATA]);
+	cmd.dataflags[0] = IWL_HCMD_DFL_NOCOPY;
 	IWL_INFO(priv, "testmode ucode command ID 0x%x, flags 0x%x,"
 				" len %d\n", cmd.id, cmd.flags, cmd.len[0]);
 	/* ok, let's submit the command to ucode */
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index a47558f..2f6b38c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -125,25 +125,13 @@ static inline u8 iwl_tfd_get_num_tbs(struct iwl_tfd *tfd)
 	return tfd->num_tbs & 0x1f;
 }
 
-/**
- * iwlagn_txq_free_tfd - Free all chunks referenced by TFD [txq->q.read_ptr]
- * @priv - driver private data
- * @txq - tx queue
- *
- * Does NOT advance any TFD circular buffer read/write indexes
- * Does NOT free the TFD itself (which is within circular buffer)
- */
-void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
+static void iwlagn_unmap_tfd(struct iwl_priv *priv, struct iwl_cmd_meta *meta,
+			     struct iwl_tfd *tfd)
 {
-	struct iwl_tfd *tfd_tmp = (struct iwl_tfd *)txq->tfds;
-	struct iwl_tfd *tfd;
 	struct pci_dev *dev = priv->pci_dev;
-	int index = txq->q.read_ptr;
 	int i;
 	int num_tbs;
 
-	tfd = &tfd_tmp[index];
-
 	/* Sanity check on number of chunks */
 	num_tbs = iwl_tfd_get_num_tbs(tfd);
 
@@ -156,14 +144,30 @@ void iwlagn_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (num_tbs)
 		pci_unmap_single(dev,
-				dma_unmap_addr(&txq->meta[index], mapping),
-				dma_unmap_len(&txq->meta[index], len),
+				dma_unmap_addr(meta, mapping),
+				dma_unmap_len(meta, len),
 				PCI_DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
 	for (i = 1; i < num_tbs; i++)
 		pci_unmap_single(dev, iwl_tfd_tb_get_addr(tfd, i),
 				iwl_tfd_tb_get_len(tfd, i), PCI_DMA_TODEVICE);
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
+	struct iwl_tfd *tfd_tmp = txq->tfds;
+	int index = txq->q.read_ptr;
+
+	iwlagn_unmap_tfd(priv, &txq->meta[index], &tfd_tmp[index]);
 
 	/* free SKB */
 	if (txq->txb) {
@@ -189,7 +193,7 @@ int iwlagn_txq_attach_buf_to_tfd(struct iwl_priv *priv,
 	u32 num_tbs;
 
 	q = &txq->q;
-	tfd_tmp = (struct iwl_tfd *)txq->tfds;
+	tfd_tmp = txq->tfds;
 	tfd = &tfd_tmp[q->write_ptr];
 
 	if (reset)
@@ -303,7 +307,7 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 		return;
 
 	while (q->read_ptr != q->write_ptr) {
-		i = get_cmd_index(q, q->read_ptr, 0);
+		i = get_cmd_index(q, q->read_ptr);
 
 		if (txq->meta[i].flags & CMD_MAPPED) {
 			pci_unmap_single(priv->pci_dev,
@@ -315,15 +319,6 @@ void iwl_cmd_queue_unmap(struct iwl_priv *priv)
 
 		q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd);
 	}
-
-	i = q->n_window;
-	if (txq->meta[i].flags & CMD_MAPPED) {
-		pci_unmap_single(priv->pci_dev,
-				 dma_unmap_addr(&txq->meta[i], mapping),
-				 dma_unmap_len(&txq->meta[i], len),
-				 PCI_DMA_BIDIRECTIONAL);
-		txq->meta[i].flags = 0;
-	}
 }
 
 /**
@@ -343,7 +338,7 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 	iwl_cmd_queue_unmap(priv);
 
 	/* De-alloc array of command/tx buffers */
-	for (i = 0; i <= TFD_CMD_SLOTS; i++)
+	for (i = 0; i < TFD_CMD_SLOTS; i++)
 		kfree(txq->cmd[i]);
 
 	/* De-alloc circular buffer of TFDs */
@@ -483,33 +478,17 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 {
 	int i, len;
 	int ret;
-	int actual_slots = slots_num;
-
-	/*
-	 * Alloc buffer array for commands (Tx or other types of commands).
-	 * For the command queue (#4/#9), allocate command space + one big
-	 * command for scan, since scan command is very huge; the system will
-	 * not have two scans at the same time, so only one is needed.
-	 * For normal Tx queues (all other queues), no super-size command
-	 * space is needed.
-	 */
-	if (txq_id == priv->cmd_queue)
-		actual_slots++;
 
-	txq->meta = kzalloc(sizeof(struct iwl_cmd_meta) * actual_slots,
+	txq->meta = kzalloc(sizeof(struct iwl_cmd_meta) * slots_num,
 			    GFP_KERNEL);
-	txq->cmd = kzalloc(sizeof(struct iwl_device_cmd *) * actual_slots,
+	txq->cmd = kzalloc(sizeof(struct iwl_device_cmd *) * slots_num,
 			   GFP_KERNEL);
 
 	if (!txq->meta || !txq->cmd)
 		goto out_free_arrays;
 
 	len = sizeof(struct iwl_device_cmd);
-	for (i = 0; i < actual_slots; i++) {
-		/* only happens for cmd queue */
-		if (i == slots_num)
-			len = IWL_MAX_CMD_SIZE;
-
+	for (i = 0; i < slots_num; i++) {
 		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
 		if (!txq->cmd[i])
 			goto err;
@@ -544,7 +523,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	return 0;
 err:
-	for (i = 0; i < actual_slots; i++)
+	for (i = 0; i < slots_num; i++)
 		kfree(txq->cmd[i]);
 out_free_arrays:
 	kfree(txq->meta);
@@ -592,23 +571,44 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	dma_addr_t phys_addr;
 	unsigned long flags;
 	u32 idx;
-	u16 fix_size;
+	u16 copy_size, cmd_size;
 	bool is_ct_kill = false;
+	bool had_nocopy = false;
+	int i;
+	u8 *cmd_dest;
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+	const void *trace_bufs[IWL_MAX_CMD_TFDS + 1] = {};
+	int trace_lens[IWL_MAX_CMD_TFDS + 1] = {};
+	int trace_idx;
+#endif
 
-	fix_size = (u16)(cmd->len[0] + sizeof(out_cmd->hdr));
+	copy_size = sizeof(out_cmd->hdr);
+	cmd_size = sizeof(out_cmd->hdr);
+
+	/* need one for the header if the first is NOCOPY */
+	BUILD_BUG_ON(IWL_MAX_CMD_TFDS > IWL_NUM_OF_TBS - 1);
+
+	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+		if (!cmd->len[i])
+			continue;
+		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY) {
+			had_nocopy = true;
+		} else {
+			/* NOCOPY must not be followed by normal! */
+			if (WARN_ON(had_nocopy))
+				return -EINVAL;
+			copy_size += cmd->len[i];
+		}
+		cmd_size += cmd->len[i];
+	}
 
 	/*
 	 * If any of the command structures end up being larger than
-	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
-	 * we will need to increase the size of the TFD entries
-	 * Also, check to see if command buffer should not exceed the size
-	 * of device_cmd and max_cmd_size.
+	 * the TFD_MAX_PAYLOAD_SIZE and they aren't dynamically
+	 * allocated into separate TFDs, then we will need to
+	 * increase the size of the buffers.
 	 */
-	if (WARN_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
-		    !(cmd->flags & CMD_SIZE_HUGE)))
-		return -EINVAL;
-
-	if (WARN_ON(fix_size > IWL_MAX_CMD_SIZE))
+	if (WARN_ON(copy_size > TFD_MAX_PAYLOAD_SIZE))
 		return -EINVAL;
 
 	if (iwl_is_rfkill(priv) || iwl_is_ctkill(priv)) {
@@ -617,14 +617,6 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -EIO;
 	}
 
-	/*
-	 * As we only have a single huge buffer, check that the command
-	 * is synchronous (otherwise buffers could end up being reused).
-	 */
-
-	if (WARN_ON((cmd->flags & CMD_ASYNC) && (cmd->flags & CMD_SIZE_HUGE)))
-		return -EINVAL;
-
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
 	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
@@ -639,7 +631,7 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		return -ENOSPC;
 	}
 
-	idx = get_cmd_index(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
+	idx = get_cmd_index(q, q->write_ptr);
 	out_cmd = txq->cmd[idx];
 	out_meta = &txq->meta[idx];
 
@@ -654,55 +646,84 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	if (cmd->flags & CMD_ASYNC)
 		out_meta->callback = cmd->callback;
 
-	out_cmd->hdr.cmd = cmd->id;
-	memcpy(&out_cmd->cmd.payload, cmd->data[0], cmd->len[0]);
-
-	/* At this point, the out_cmd now has all of the incoming cmd
-	 * information */
+	/* set up the header */
 
+	out_cmd->hdr.cmd = cmd->id;
 	out_cmd->hdr.flags = 0;
 	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(priv->cmd_queue) |
-			INDEX_TO_SEQ(q->write_ptr));
-	if (cmd->flags & CMD_SIZE_HUGE)
-		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-	switch (out_cmd->hdr.cmd) {
-	case REPLY_TX_LINK_QUALITY_CMD:
-	case SENSITIVITY_CMD:
-		IWL_DEBUG_HC_DUMP(priv, "Sending command %s (#%x), seq: 0x%04X, "
-				"%d bytes at %d[%d]:%d\n",
-				get_cmd_string(out_cmd->hdr.cmd),
-				out_cmd->hdr.cmd,
-				le16_to_cpu(out_cmd->hdr.sequence), fix_size,
-				q->write_ptr, idx, priv->cmd_queue);
-		break;
-	default:
-		IWL_DEBUG_HC(priv, "Sending command %s (#%x), seq: 0x%04X, "
-				"%d bytes at %d[%d]:%d\n",
-				get_cmd_string(out_cmd->hdr.cmd),
-				out_cmd->hdr.cmd,
-				le16_to_cpu(out_cmd->hdr.sequence), fix_size,
-				q->write_ptr, idx, priv->cmd_queue);
+					    INDEX_TO_SEQ(q->write_ptr));
+
+	/* and copy the data that needs to be copied */
+
+	cmd_dest = &out_cmd->cmd.payload[0];
+	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+		if (!cmd->len[i])
+			continue;
+		if (cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY)
+			break;
+		memcpy(cmd_dest, cmd->data[i], cmd->len[i]);
+		cmd_dest += cmd->len[i];
 	}
-#endif
+
+	IWL_DEBUG_HC(priv, "Sending command %s (#%x), seq: 0x%04X, "
+			"%d bytes at %d[%d]:%d\n",
+			get_cmd_string(out_cmd->hdr.cmd),
+			out_cmd->hdr.cmd,
+			le16_to_cpu(out_cmd->hdr.sequence), cmd_size,
+			q->write_ptr, idx, priv->cmd_queue);
+
 	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
-				   fix_size, PCI_DMA_BIDIRECTIONAL);
+				   copy_size, PCI_DMA_BIDIRECTIONAL);
 	if (unlikely(pci_dma_mapping_error(priv->pci_dev, phys_addr))) {
 		idx = -ENOMEM;
 		goto out;
 	}
 
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
-	dma_unmap_len_set(out_meta, len, fix_size);
+	dma_unmap_len_set(out_meta, len, copy_size);
+
+	iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr, copy_size, 1);
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+	trace_bufs[0] = &out_cmd->hdr;
+	trace_lens[0] = copy_size;
+	trace_idx = 1;
+#endif
+
+	for (i = 0; i < IWL_MAX_CMD_TFDS; i++) {
+		if (!cmd->len[i])
+			continue;
+		if (!(cmd->dataflags[i] & IWL_HCMD_DFL_NOCOPY))
+			continue;
+		phys_addr = pci_map_single(priv->pci_dev, (void *)cmd->data[i],
+					   cmd->len[i], PCI_DMA_TODEVICE);
+		if (pci_dma_mapping_error(priv->pci_dev, phys_addr)) {
+			iwlagn_unmap_tfd(priv, out_meta,
+					 &txq->tfds[q->write_ptr]);
+			idx = -ENOMEM;
+			goto out;
+		}
+
+		iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr,
+					     cmd->len[i], 0);
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+		trace_bufs[trace_idx] = cmd->data[i];
+		trace_lens[trace_idx] = cmd->len[i];
+		trace_idx++;
+#endif
+	}
 
 	out_meta->flags = cmd->flags | CMD_MAPPED;
 
 	txq->need_update = 1;
 
-	trace_iwlwifi_dev_hcmd(priv, &out_cmd->hdr, fix_size, cmd->flags);
-
-	iwlagn_txq_attach_buf_to_tfd(priv, txq, phys_addr, fix_size, 1);
+	/* check that tracing gets all possible blocks */
+	BUILD_BUG_ON(IWL_MAX_CMD_TFDS + 1 != 3);
+#ifdef CONFIG_IWLWIFI_DEVICE_TRACING
+	trace_iwlwifi_dev_hcmd(priv, cmd->flags,
+			       trace_bufs[0], trace_lens[0],
+			       trace_bufs[1], trace_lens[1],
+			       trace_bufs[2], trace_lens[2]);
+#endif
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
@@ -761,7 +782,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	int txq_id = SEQ_TO_QUEUE(sequence);
 	int index = SEQ_TO_INDEX(sequence);
 	int cmd_index;
-	bool huge = !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
 	struct iwl_tx_queue *txq = &priv->txq[priv->cmd_queue];
@@ -779,14 +799,11 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		return;
 	}
 
-	cmd_index = get_cmd_index(&txq->q, index, huge);
+	cmd_index = get_cmd_index(&txq->q, index);
 	cmd = txq->cmd[cmd_index];
 	meta = &txq->meta[cmd_index];
 
-	pci_unmap_single(priv->pci_dev,
-			 dma_unmap_addr(meta, mapping),
-			 dma_unmap_len(meta, len),
-			 PCI_DMA_BIDIRECTIONAL);
+	iwlagn_unmap_tfd(priv, meta, &txq->tfds[index]);
 
 	/* Input error checking is done when commands are added to queue. */
 	if (meta->flags & CMD_WANT_SKB) {
-- 
1.7.0.4

