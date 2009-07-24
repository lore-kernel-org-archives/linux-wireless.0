Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23612 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbZGXSNR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jul 2009 14:13:17 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes@sipsolutions.net>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 06/14] iwlwifi: fix up command sending
Date: Fri, 24 Jul 2009 11:13:05 -0700
Message-Id: <1248459194-10239-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
References: <1248459194-10239-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

The current command sending in iwlwifi is a bit of a mess:
 1) there is a struct, iwl_cmd, that contains both driver
    and device data in a single packed structure -- this
    is very confusing
 2) the on-stack data and the command metadata share a
    structure by embedding the latter in the former, which
    is also rather confusing because it leads to weird
    unions and similarly odd constructs
 3) each txq always has enough space for 256 commands,
    even if only 32 end up being used

This patch fixes these things:
 1) rename iwl_cmd to iwl_device_cmd and keep track of
    command metadata and device command separately, in
    two arrays in each tx queue
 2) remove the 'meta' member from iwl_host_cmd and only
    put in the required members
 3) allocate the cmd/meta arrays separately instead of
    embedding them into the txq structure

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    6 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |   18 +++--
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    9 ++-
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-calib.c    |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.c     |    4 +-
 drivers/net/wireless/iwlwifi/iwl-core.h     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h      |   69 +++++++++++--------
 drivers/net/wireless/iwlwifi/iwl-hcmd.c     |   48 +++++++-------
 drivers/net/wireless/iwlwifi/iwl-led.c      |    4 +-
 drivers/net/wireless/iwlwifi/iwl-scan.c     |    8 +-
 drivers/net/wireless/iwlwifi/iwl-sta.c      |   30 +++++----
 drivers/net/wireless/iwlwifi/iwl-tx.c       |   96 ++++++++++++++++----------
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   20 +++---
 14 files changed, 180 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index 225e5f8..b379382 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -80,7 +80,7 @@ static const struct {
 #define IWL_SOLID_BLINK_IDX (ARRAY_SIZE(blink_tbl) - 1)
 
 static int iwl3945_led_cmd_callback(struct iwl_priv *priv,
-				    struct iwl_cmd *cmd,
+				    struct iwl_device_cmd *cmd,
 				    struct sk_buff *skb)
 {
 	return 1;
@@ -99,8 +99,8 @@ static int iwl_send_led_cmd(struct iwl_priv *priv,
 		.id = REPLY_LEDS_CMD,
 		.len = sizeof(struct iwl_led_cmd),
 		.data = led_cmd,
-		.meta.flags = CMD_ASYNC,
-		.meta.u.callback = iwl3945_led_cmd_callback,
+		.flags = CMD_ASYNC,
+		.callback = iwl3945_led_cmd_callback,
 	};
 
 	return iwl_send_cmd(priv, &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 8ee403c..e1b0ef3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -749,8 +749,8 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (counter)
 		pci_unmap_single(dev,
-				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
-				pci_unmap_len(&txq->cmd[index]->meta, len),
+				pci_unmap_addr(&txq->meta[index], mapping),
+				pci_unmap_len(&txq->meta[index], len),
 				PCI_DMA_TODEVICE);
 
 	/* unmap chunks if any */
@@ -774,9 +774,11 @@ void iwl3945_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
  * iwl3945_hw_build_tx_cmd_rate - Add rate portion to TX_CMD:
  *
 */
-void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
-			      struct ieee80211_tx_info *info,
-			      struct ieee80211_hdr *hdr, int sta_id, int tx_id)
+void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
+				  struct iwl_device_cmd *cmd,
+				  struct ieee80211_tx_info *info,
+				  struct ieee80211_hdr *hdr,
+				  int sta_id, int tx_id)
 {
 	u16 hw_value = ieee80211_get_tx_rate(priv->hw, info)->hw_value;
 	u16 rate_index = min(hw_value & 0xffff, IWL_RATE_COUNT - 1);
@@ -1858,7 +1860,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_RXON_ASSOC,
 		.len = sizeof(rxon_assoc),
-		.meta.flags = CMD_WANT_SKB,
+		.flags = CMD_WANT_SKB,
 		.data = &rxon_assoc,
 	};
 	const struct iwl_rxon_cmd *rxon1 = &priv->staging_rxon;
@@ -1882,14 +1884,14 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	if (rc)
 		return rc;
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_RXON_ASSOC command\n");
 		rc = -EIO;
 	}
 
 	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
+	dev_kfree_skb_any(cmd.reply_skb);
 
 	return rc;
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index f2ffc48..f240369 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -254,10 +254,11 @@ extern int iwl3945_hw_tx_queue_init(struct iwl_priv *priv,
 				struct iwl_tx_queue *txq);
 extern unsigned int iwl3945_hw_get_beacon_cmd(struct iwl_priv *priv,
 				 struct iwl3945_frame *frame, u8 rate);
-void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv, struct iwl_cmd *cmd,
-				     struct ieee80211_tx_info *info,
-				     struct ieee80211_hdr *hdr,
-				     int sta_id, int tx_id);
+void iwl3945_hw_build_tx_cmd_rate(struct iwl_priv *priv,
+				  struct iwl_device_cmd *cmd,
+				  struct ieee80211_tx_info *info,
+				  struct ieee80211_hdr *hdr,
+				  int sta_id, int tx_id);
 extern int iwl3945_hw_reg_send_txpower(struct iwl_priv *priv);
 extern int iwl3945_hw_reg_set_txpower(struct iwl_priv *priv, s8 power);
 extern void iwl3945_hw_rx_statistics(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 23ae991..4cb1a1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -442,8 +442,8 @@ void iwl_hw_txq_free_tfd(struct iwl_priv *priv, struct iwl_tx_queue *txq)
 	/* Unmap tx_cmd */
 	if (num_tbs)
 		pci_unmap_single(dev,
-				pci_unmap_addr(&txq->cmd[index]->meta, mapping),
-				pci_unmap_len(&txq->cmd[index]->meta, len),
+				pci_unmap_addr(&txq->meta[index], mapping),
+				pci_unmap_len(&txq->meta[index], len),
 				PCI_DMA_BIDIRECTIONAL);
 
 	/* Unmap chunks, if any. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-calib.c b/drivers/net/wireless/iwlwifi/iwl-calib.c
index f8bf592..13180d6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-calib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-calib.c
@@ -86,7 +86,7 @@ int iwl_send_calib_results(struct iwl_priv *priv)
 
 	struct iwl_host_cmd hcmd = {
 		.id = REPLY_PHY_CALIBRATION_CMD,
-		.meta.flags = CMD_SIZE_HUGE,
+		.flags = CMD_SIZE_HUGE,
 	};
 
 	for (i = 0; i < IWL_CALIB_MAX; i++) {
@@ -419,7 +419,7 @@ static int iwl_sensitivity_write(struct iwl_priv *priv)
 	struct iwl_host_cmd cmd_out = {
 		.id = SENSITIVITY_CMD,
 		.len = sizeof(struct iwl_sensitivity_cmd),
-		.meta.flags = CMD_ASYNC,
+		.flags = CMD_ASYNC,
 		.data = &cmd,
 	};
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index d8aeb24..710dd41 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -2089,7 +2089,7 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags)
 	u32 stat_flags = 0;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_STATISTICS_CMD,
-		.meta.flags = flags,
+		.flags = flags,
 		.len = sizeof(stat_flags),
 		.data = (u8 *) &stat_flags,
 	};
@@ -2282,7 +2282,7 @@ int iwl_send_card_state(struct iwl_priv *priv, u32 flags, u8 meta_flag)
 		.id = REPLY_CARD_STATE_CMD,
 		.len = sizeof(u32),
 		.data = &flags,
-		.meta.flags = meta_flag,
+		.flags = meta_flag,
 	};
 
 	return iwl_send_cmd(priv, &cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 614ec7c..4156deb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -447,7 +447,7 @@ int __must_check iwl_send_cmd_pdu(struct iwl_priv *priv, u8 id,
 int iwl_send_cmd_pdu_async(struct iwl_priv *priv, u8 id, u16 len,
 			   const void *data,
 			   int (*callback)(struct iwl_priv *priv,
-					   struct iwl_cmd *cmd,
+					   struct iwl_device_cmd *cmd,
 					   struct sk_buff *skb));
 
 int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd);
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index cddf173..ce765f7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -150,6 +150,31 @@ struct iwl_rx_mem_buffer {
 	struct list_head list;
 };
 
+/* defined below */
+struct iwl_device_cmd;
+
+struct iwl_cmd_meta {
+	/* only for SYNC commands, iff the reply skb is wanted */
+	struct iwl_host_cmd *source;
+	/*
+	 * only for ASYNC commands
+	 * (which is somewhat stupid -- look at iwl-sta.c for instance
+	 * which duplicates a bunch of code because the callback isn't
+	 * invoked for SYNC commands, if it were and its result passed
+	 * through it would be simpler...)
+	 */
+	int (*callback)(struct iwl_priv *priv,
+			struct iwl_device_cmd *cmd,
+			struct sk_buff *skb);
+
+	/* The CMD_SIZE_HUGE flag bit indicates that the command
+	 * structure is stored at the end of the shared queue memory. */
+	u32 flags;
+
+	DECLARE_PCI_UNMAP_ADDR(mapping)
+	DECLARE_PCI_UNMAP_LEN(len)
+};
+
 /*
  * Generic queue structure
  *
@@ -177,7 +202,8 @@ struct iwl_tx_info {
  * struct iwl_tx_queue - Tx Queue for DMA
  * @q: generic Rx/Tx queue descriptor
  * @bd: base of circular buffer of TFDs
- * @cmd: array of command/Tx buffers
+ * @cmd: array of command/TX buffer pointers
+ * @meta: array of meta data for each command/tx buffer
  * @dma_addr_cmd: physical address of cmd/tx buffer array
  * @txb: array of per-TFD driver data
  * @need_update: indicates need to update read/write index
@@ -192,7 +218,8 @@ struct iwl_tx_info {
 struct iwl_tx_queue {
 	struct iwl_queue q;
 	void *tfds;
-	struct iwl_cmd *cmd[TFD_TX_CMD_SLOTS];
+	struct iwl_device_cmd **cmd;
+	struct iwl_cmd_meta *meta;
 	struct iwl_tx_info *txb;
 	u8 need_update;
 	u8 sched_retry;
@@ -329,35 +356,16 @@ enum {
 	CMD_WANT_SKB = (1 << 2),
 };
 
-struct iwl_cmd;
-struct iwl_priv;
-
-struct iwl_cmd_meta {
-	struct iwl_cmd_meta *source;
-	union {
-		struct sk_buff *skb;
-		int (*callback)(struct iwl_priv *priv,
-				struct iwl_cmd *cmd, struct sk_buff *skb);
-	} __attribute__ ((packed)) u;
-
-	/* The CMD_SIZE_HUGE flag bit indicates that the command
-	 * structure is stored at the end of the shared queue memory. */
-	u32 flags;
-	DECLARE_PCI_UNMAP_ADDR(mapping)
-	DECLARE_PCI_UNMAP_LEN(len)
-} __attribute__ ((packed));
-
 #define IWL_CMD_MAX_PAYLOAD 320
 
 /**
- * struct iwl_cmd
+ * struct iwl_device_cmd
  *
  * For allocation of the command and tx queues, this establishes the overall
  * size of the largest command we send to uCode, except for a scan command
  * (which is relatively huge; space is allocated separately).
  */
-struct iwl_cmd {
-	struct iwl_cmd_meta meta;	/* driver data */
+struct iwl_device_cmd {
 	struct iwl_cmd_header hdr;	/* uCode API */
 	union {
 		u32 flags;
@@ -369,17 +377,20 @@ struct iwl_cmd {
 	} __attribute__ ((packed)) cmd;
 } __attribute__ ((packed));
 
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_device_cmd))
+
 
 struct iwl_host_cmd {
-	u8 id;
-	u16 len;
-	struct iwl_cmd_meta meta;
 	const void *data;
+	struct sk_buff *reply_skb;
+	int (*callback)(struct iwl_priv *priv,
+			struct iwl_device_cmd *cmd,
+			struct sk_buff *skb);
+	u32 flags;
+	u16 len;
+	u8 id;
 };
 
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct iwl_cmd) - \
-			      sizeof(struct iwl_cmd_meta))
-
 /*
  * RX related structures and functions
  */
diff --git a/drivers/net/wireless/iwlwifi/iwl-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
index 17d61ac..d8a3eac 100644
--- a/drivers/net/wireless/iwlwifi/iwl-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-hcmd.c
@@ -104,7 +104,8 @@ EXPORT_SYMBOL(get_cmd_string);
 #define HOST_COMPLETE_TIMEOUT (HZ / 2)
 
 static int iwl_generic_cmd_callback(struct iwl_priv *priv,
-				    struct iwl_cmd *cmd, struct sk_buff *skb)
+				    struct iwl_device_cmd *cmd,
+				    struct sk_buff *skb)
 {
 	struct iwl_rx_packet *pkt = NULL;
 
@@ -142,14 +143,14 @@ static int iwl_send_cmd_async(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	int ret;
 
-	BUG_ON(!(cmd->meta.flags & CMD_ASYNC));
+	BUG_ON(!(cmd->flags & CMD_ASYNC));
 
 	/* An asynchronous command can not expect an SKB to be set. */
-	BUG_ON(cmd->meta.flags & CMD_WANT_SKB);
+	BUG_ON(cmd->flags & CMD_WANT_SKB);
 
 	/* Assign a generic callback if one is not provided */
-	if (!cmd->meta.u.callback)
-		cmd->meta.u.callback = iwl_generic_cmd_callback;
+	if (!cmd->callback)
+		cmd->callback = iwl_generic_cmd_callback;
 
 	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
 		return -EBUSY;
@@ -168,10 +169,10 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	int cmd_idx;
 	int ret;
 
-	BUG_ON(cmd->meta.flags & CMD_ASYNC);
+	BUG_ON(cmd->flags & CMD_ASYNC);
 
 	 /* A synchronous command can not have a callback set. */
-	BUG_ON(cmd->meta.u.callback != NULL);
+	BUG_ON(cmd->callback);
 
 	if (test_and_set_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status)) {
 		IWL_ERR(priv,
@@ -183,9 +184,6 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
 
-	if (cmd->meta.flags & CMD_WANT_SKB)
-		cmd->meta.source = &cmd->meta;
-
 	cmd_idx = iwl_enqueue_hcmd(priv, cmd);
 	if (cmd_idx < 0) {
 		ret = cmd_idx;
@@ -222,7 +220,7 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 		ret = -EIO;
 		goto fail;
 	}
-	if ((cmd->meta.flags & CMD_WANT_SKB) && !cmd->meta.u.skb) {
+	if ((cmd->flags & CMD_WANT_SKB) && !cmd->reply_skb) {
 		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
 			  get_cmd_string(cmd->id));
 		ret = -EIO;
@@ -233,20 +231,20 @@ int iwl_send_cmd_sync(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	goto out;
 
 cancel:
-	if (cmd->meta.flags & CMD_WANT_SKB) {
-		struct iwl_cmd *qcmd;
-
-		/* Cancel the CMD_WANT_SKB flag for the cmd in the
+	if (cmd->flags & CMD_WANT_SKB) {
+		/*
+		 * Cancel the CMD_WANT_SKB flag for the cmd in the
 		 * TX cmd queue. Otherwise in case the cmd comes
 		 * in later, it will possibly set an invalid
-		 * address (cmd->meta.source). */
-		qcmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
-		qcmd->meta.flags &= ~CMD_WANT_SKB;
+		 * address (cmd->meta.source).
+		 */
+		priv->txq[IWL_CMD_QUEUE_NUM].meta[cmd_idx].flags &=
+							~CMD_WANT_SKB;
 	}
 fail:
-	if (cmd->meta.u.skb) {
-		dev_kfree_skb_any(cmd->meta.u.skb);
-		cmd->meta.u.skb = NULL;
+	if (cmd->reply_skb) {
+		dev_kfree_skb_any(cmd->reply_skb);
+		cmd->reply_skb = NULL;
 	}
 out:
 	clear_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status);
@@ -256,7 +254,7 @@ EXPORT_SYMBOL(iwl_send_cmd_sync);
 
 int iwl_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
-	if (cmd->meta.flags & CMD_ASYNC)
+	if (cmd->flags & CMD_ASYNC)
 		return iwl_send_cmd_async(priv, cmd);
 
 	return iwl_send_cmd_sync(priv, cmd);
@@ -278,7 +276,7 @@ EXPORT_SYMBOL(iwl_send_cmd_pdu);
 int iwl_send_cmd_pdu_async(struct iwl_priv *priv,
 			   u8 id, u16 len, const void *data,
 			   int (*callback)(struct iwl_priv *priv,
-					   struct iwl_cmd *cmd,
+					   struct iwl_device_cmd *cmd,
 					   struct sk_buff *skb))
 {
 	struct iwl_host_cmd cmd = {
@@ -287,8 +285,8 @@ int iwl_send_cmd_pdu_async(struct iwl_priv *priv,
 		.data = data,
 	};
 
-	cmd.meta.flags |= CMD_ASYNC;
-	cmd.meta.u.callback = callback;
+	cmd.flags |= CMD_ASYNC;
+	cmd.callback = callback;
 
 	return iwl_send_cmd_async(priv, &cmd);
 }
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 8c81152..7cce8f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -91,8 +91,8 @@ static int iwl_send_led_cmd(struct iwl_priv *priv, struct iwl_led_cmd *led_cmd)
 		.id = REPLY_LEDS_CMD,
 		.len = sizeof(struct iwl_led_cmd),
 		.data = led_cmd,
-		.meta.flags = CMD_ASYNC,
-		.meta.u.callback = NULL,
+		.flags = CMD_ASYNC,
+		.callback = NULL,
 	};
 	u32 reg;
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-scan.c b/drivers/net/wireless/iwlwifi/iwl-scan.c
index 00398d9..c4c916d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@ -115,7 +115,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	struct iwl_rx_packet *res;
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_ABORT_CMD,
-		.meta.flags = CMD_WANT_SKB,
+		.flags = CMD_WANT_SKB,
 	};
 
 	/* If there isn't a scan actively going on in the hardware
@@ -132,7 +132,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 		return ret;
 	}
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
 	if (res->u.status != CAN_ABORT_STATUS) {
 		/* The scan abort will return 1 for success or
 		 * 2 for "failure".  A failure condition can be
@@ -146,7 +146,7 @@ static int iwl_send_scan_abort(struct iwl_priv *priv)
 	}
 
 	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
+	dev_kfree_skb_any(cmd.reply_skb);
 
 	return ret;
 }
@@ -567,7 +567,7 @@ static void iwl_bg_request_scan(struct work_struct *data)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl_scan_cmd),
-		.meta.flags = CMD_SIZE_HUGE,
+		.flags = CMD_SIZE_HUGE,
 	};
 	struct iwl_scan_cmd *scan;
 	struct ieee80211_conf *conf = NULL;
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index cbe4e26..1571ace 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -98,7 +98,8 @@ static void iwl_sta_ucode_activate(struct iwl_priv *priv, u8 sta_id)
 }
 
 static int iwl_add_sta_callback(struct iwl_priv *priv,
-				   struct iwl_cmd *cmd, struct sk_buff *skb)
+				struct iwl_device_cmd *cmd,
+				struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
 	struct iwl_addsta_cmd *addsta =
@@ -139,14 +140,14 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	u8 data[sizeof(*sta)];
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_ADD_STA,
-		.meta.flags = flags,
+		.flags = flags,
 		.data = data,
 	};
 
 	if (flags & CMD_ASYNC)
-		cmd.meta.u.callback = iwl_add_sta_callback;
+		cmd.callback = iwl_add_sta_callback;
 	else
-		cmd.meta.flags |= CMD_WANT_SKB;
+		cmd.flags |= CMD_WANT_SKB;
 
 	cmd.len = priv->cfg->ops->utils->build_addsta_hcmd(sta, data);
 	ret = iwl_send_cmd(priv, &cmd);
@@ -154,7 +155,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_ADD_STA (0x%08X)\n",
 			  res->hdr.flags);
@@ -175,7 +176,7 @@ int iwl_send_add_sta(struct iwl_priv *priv,
 	}
 
 	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
+	dev_kfree_skb_any(cmd.reply_skb);
 
 	return ret;
 }
@@ -325,7 +326,8 @@ static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, const char *addr)
 }
 
 static int iwl_remove_sta_callback(struct iwl_priv *priv,
-				   struct iwl_cmd *cmd, struct sk_buff *skb)
+				   struct iwl_device_cmd *cmd,
+				   struct sk_buff *skb)
 {
 	struct iwl_rx_packet *res = NULL;
 	struct iwl_rem_sta_cmd *rm_sta =
@@ -368,7 +370,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_REMOVE_STA,
 		.len = sizeof(struct iwl_rem_sta_cmd),
-		.meta.flags = flags,
+		.flags = flags,
 		.data = &rm_sta_cmd,
 	};
 
@@ -377,15 +379,15 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 	memcpy(&rm_sta_cmd.addr, addr , ETH_ALEN);
 
 	if (flags & CMD_ASYNC)
-		cmd.meta.u.callback = iwl_remove_sta_callback;
+		cmd.callback = iwl_remove_sta_callback;
 	else
-		cmd.meta.flags |= CMD_WANT_SKB;
+		cmd.flags |= CMD_WANT_SKB;
 	ret = iwl_send_cmd(priv, &cmd);
 
 	if (ret || (flags & CMD_ASYNC))
 		return ret;
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_REMOVE_STA (0x%08X)\n",
 			  res->hdr.flags);
@@ -406,7 +408,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv, const u8 *addr,
 	}
 
 	priv->alloc_rxb_skb--;
-	dev_kfree_skb_any(cmd.meta.u.skb);
+	dev_kfree_skb_any(cmd.reply_skb);
 
 	return ret;
 }
@@ -525,7 +527,7 @@ int iwl_send_static_wepkey_cmd(struct iwl_priv *priv, u8 send_if_empty)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_WEPKEY,
 		.data = wep_cmd,
-		.meta.flags = CMD_ASYNC,
+		.flags = CMD_ASYNC,
 	};
 
 	memset(wep_cmd, 0, cmd_size +
@@ -930,7 +932,7 @@ int iwl_send_lq_cmd(struct iwl_priv *priv,
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_TX_LINK_QUALITY_CMD,
 		.len = sizeof(struct iwl_link_quality_cmd),
-		.meta.flags = flags,
+		.flags = flags,
 		.data = lq,
 	};
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 0912987..51ddbab 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -141,7 +141,7 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd))
 		priv->cfg->ops->lib->txq_free_tfd(priv, txq);
 
-	len = sizeof(struct iwl_cmd) * q->n_window;
+	len = sizeof(struct iwl_device_cmd) * q->n_window;
 
 	/* De-alloc array of command/tx buffers */
 	for (i = 0; i < TFD_TX_CMD_SLOTS; i++)
@@ -156,6 +156,12 @@ void iwl_tx_queue_free(struct iwl_priv *priv, int txq_id)
 	kfree(txq->txb);
 	txq->txb = NULL;
 
+	/* deallocate arrays */
+	kfree(txq->cmd);
+	kfree(txq->meta);
+	txq->cmd = NULL;
+	txq->meta = NULL;
+
 	/* 0-fill queue descriptor structure */
 	memset(txq, 0, sizeof(*txq));
 }
@@ -179,7 +185,7 @@ void iwl_cmd_queue_free(struct iwl_priv *priv)
 	if (q->n_bd == 0)
 		return;
 
-	len = sizeof(struct iwl_cmd) * q->n_window;
+	len = sizeof(struct iwl_device_cmd) * q->n_window;
 	len += IWL_MAX_SCAN_SIZE;
 
 	/* De-alloc array of command/tx buffers */
@@ -318,6 +324,7 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 {
 	int i, len;
 	int ret;
+	int actual_slots = slots_num;
 
 	/*
 	 * Alloc buffer array for commands (Tx or other types of commands).
@@ -327,14 +334,22 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 	 * For normal Tx queues (all other queues), no super-size command
 	 * space is needed.
 	 */
-	len = sizeof(struct iwl_cmd);
-	for (i = 0; i <= slots_num; i++) {
-		if (i == slots_num) {
-			if (txq_id == IWL_CMD_QUEUE_NUM)
-				len += IWL_MAX_SCAN_SIZE;
-			else
-				continue;
-		}
+	if (txq_id == IWL_CMD_QUEUE_NUM)
+		actual_slots++;
+
+	txq->meta = kzalloc(sizeof(struct iwl_cmd_meta) * actual_slots,
+			    GFP_KERNEL);
+	txq->cmd = kzalloc(sizeof(struct iwl_device_cmd *) * actual_slots,
+			   GFP_KERNEL);
+
+	if (!txq->meta || !txq->cmd)
+		goto out_free_arrays;
+
+	len = sizeof(struct iwl_device_cmd);
+	for (i = 0; i < actual_slots; i++) {
+		/* only happens for cmd queue */
+		if (i == slots_num)
+			len += IWL_MAX_SCAN_SIZE;
 
 		txq->cmd[i] = kmalloc(len, GFP_KERNEL);
 		if (!txq->cmd[i])
@@ -364,15 +379,12 @@ int iwl_tx_queue_init(struct iwl_priv *priv, struct iwl_tx_queue *txq,
 
 	return 0;
 err:
-	for (i = 0; i < slots_num; i++) {
+	for (i = 0; i < actual_slots; i++)
 		kfree(txq->cmd[i]);
-		txq->cmd[i] = NULL;
-	}
+out_free_arrays:
+	kfree(txq->meta);
+	kfree(txq->cmd);
 
-	if (txq_id == IWL_CMD_QUEUE_NUM) {
-		kfree(txq->cmd[slots_num]);
-		txq->cmd[slots_num] = NULL;
-	}
 	return -ENOMEM;
 }
 EXPORT_SYMBOL(iwl_tx_queue_init);
@@ -673,7 +685,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
-	struct iwl_cmd *out_cmd;
+	struct iwl_device_cmd *out_cmd;
+	struct iwl_cmd_meta *out_meta;
 	struct iwl_tx_cmd *tx_cmd;
 	int swq_id, txq_id;
 	dma_addr_t phys_addr;
@@ -766,6 +779,7 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Set up first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[q->write_ptr];
+	out_meta = &txq->meta[q->write_ptr];
 	tx_cmd = &out_cmd->cmd.tx;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(tx_cmd, 0, sizeof(struct iwl_tx_cmd));
@@ -828,8 +842,8 @@ int iwl_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	txcmd_phys = pci_map_single(priv->pci_dev,
 				    &out_cmd->hdr, len,
 				    PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
-	pci_unmap_len_set(&out_cmd->meta, len, len);
+	pci_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	pci_unmap_len_set(out_meta, len, len);
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
@@ -923,7 +937,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 {
 	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
 	struct iwl_queue *q = &txq->q;
-	struct iwl_cmd *out_cmd;
+	struct iwl_device_cmd *out_cmd;
+	struct iwl_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
 	unsigned long flags;
 	int len, ret;
@@ -937,25 +952,31 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
 	 * we will need to increase the size of the TFD entries */
 	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
-	       !(cmd->meta.flags & CMD_SIZE_HUGE));
+	       !(cmd->flags & CMD_SIZE_HUGE));
 
 	if (iwl_is_rfkill(priv)) {
 		IWL_DEBUG_INFO(priv, "Not sending command - RF KILL\n");
 		return -EIO;
 	}
 
-	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
+	if (iwl_queue_space(q) < ((cmd->flags & CMD_ASYNC) ? 2 : 1)) {
 		IWL_ERR(priv, "No space for Tx\n");
 		return -ENOSPC;
 	}
 
 	spin_lock_irqsave(&priv->hcmd_lock, flags);
 
-	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
+	idx = get_cmd_index(q, q->write_ptr, cmd->flags & CMD_SIZE_HUGE);
 	out_cmd = txq->cmd[idx];
+	out_meta = &txq->meta[idx];
+
+	out_meta->flags = cmd->flags;
+	if (cmd->flags & CMD_WANT_SKB)
+		out_meta->source = cmd;
+	if (cmd->flags & CMD_ASYNC)
+		out_meta->callback = cmd->callback;
 
 	out_cmd->hdr.cmd = cmd->id;
-	memcpy(&out_cmd->meta, &cmd->meta, sizeof(cmd->meta));
 	memcpy(&out_cmd->cmd.payload, cmd->data, cmd->len);
 
 	/* At this point, the out_cmd now has all of the incoming cmd
@@ -964,9 +985,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	out_cmd->hdr.flags = 0;
 	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
 			INDEX_TO_SEQ(q->write_ptr));
-	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
+	if (cmd->flags & CMD_SIZE_HUGE)
 		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
-	len = sizeof(struct iwl_cmd) - sizeof(struct iwl_cmd_meta);
+	len = sizeof(struct iwl_device_cmd);
 	len += (idx == TFD_CMD_SLOTS) ?  IWL_MAX_SCAN_SIZE : 0;
 
 
@@ -998,8 +1019,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 
 	phys_addr = pci_map_single(priv->pci_dev, &out_cmd->hdr,
 				   fix_size, PCI_DMA_BIDIRECTIONAL);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
-	pci_unmap_len_set(&out_cmd->meta, len, fix_size);
+	pci_unmap_addr_set(out_meta, mapping, phys_addr);
+	pci_unmap_len_set(out_meta, len, fix_size);
 
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 						   phys_addr, fix_size, 1,
@@ -1068,8 +1089,8 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id,
 	}
 
 	pci_unmap_single(priv->pci_dev,
-		pci_unmap_addr(&txq->cmd[cmd_idx]->meta, mapping),
-		pci_unmap_len(&txq->cmd[cmd_idx]->meta, len),
+		pci_unmap_addr(&txq->meta[cmd_idx], mapping),
+		pci_unmap_len(&txq->meta[cmd_idx], len),
 		PCI_DMA_BIDIRECTIONAL);
 
 	for (idx = iwl_queue_inc_wrap(idx, q->n_bd); q->read_ptr != idx;
@@ -1100,7 +1121,8 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	int index = SEQ_TO_INDEX(sequence);
 	int cmd_index;
 	bool huge = !!(pkt->hdr.sequence & SEQ_HUGE_FRAME);
-	struct iwl_cmd *cmd;
+	struct iwl_device_cmd *cmd;
+	struct iwl_cmd_meta *meta;
 
 	/* If a Tx command is being handled and it isn't in the actual
 	 * command queue then there a command routing bug has been introduced
@@ -1116,18 +1138,18 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 
 	cmd_index = get_cmd_index(&priv->txq[IWL_CMD_QUEUE_NUM].q, index, huge);
 	cmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_index];
+	meta = &priv->txq[IWL_CMD_QUEUE_NUM].meta[cmd_index];
 
 	/* Input error checking is done when commands are added to queue. */
-	if (cmd->meta.flags & CMD_WANT_SKB) {
-		cmd->meta.source->u.skb = rxb->skb;
+	if (meta->flags & CMD_WANT_SKB) {
+		meta->source->reply_skb = rxb->skb;
 		rxb->skb = NULL;
-	} else if (cmd->meta.u.callback &&
-		   !cmd->meta.u.callback(priv, cmd, rxb->skb))
+	} else if (meta->callback && !meta->callback(priv, cmd, rxb->skb))
 		rxb->skb = NULL;
 
 	iwl_hcmd_queue_reclaim(priv, txq_id, index, cmd_index);
 
-	if (!(cmd->meta.flags & CMD_ASYNC)) {
+	if (!(meta->flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
 		wake_up_interruptible(&priv->wait_command_queue);
 	}
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 2cc7e30..5ded898 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -363,7 +363,7 @@ static void iwl3945_unset_hw_params(struct iwl_priv *priv)
 
 static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
 				      struct ieee80211_tx_info *info,
-				      struct iwl_cmd *cmd,
+				      struct iwl_device_cmd *cmd,
 				      struct sk_buff *skb_frag,
 				      int sta_id)
 {
@@ -403,7 +403,7 @@ static void iwl3945_build_tx_cmd_hwcrypto(struct iwl_priv *priv,
  * handle build REPLY_TX command notification.
  */
 static void iwl3945_build_tx_cmd_basic(struct iwl_priv *priv,
-				  struct iwl_cmd *cmd,
+				  struct iwl_device_cmd *cmd,
 				  struct ieee80211_tx_info *info,
 				  struct ieee80211_hdr *hdr, u8 std_id)
 {
@@ -476,7 +476,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	struct iwl3945_tx_cmd *tx;
 	struct iwl_tx_queue *txq = NULL;
 	struct iwl_queue *q = NULL;
-	struct iwl_cmd *out_cmd = NULL;
+	struct iwl_device_cmd *out_cmd;
+	struct iwl_cmd_meta *out_meta;
 	dma_addr_t phys_addr;
 	dma_addr_t txcmd_phys;
 	int txq_id = skb_get_queue_mapping(skb);
@@ -565,6 +566,7 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 
 	/* Init first empty entry in queue's array of Tx/cmd buffers */
 	out_cmd = txq->cmd[idx];
+	out_meta = &txq->meta[idx];
 	tx = (struct iwl3945_tx_cmd *)out_cmd->cmd.payload;
 	memset(&out_cmd->hdr, 0, sizeof(out_cmd->hdr));
 	memset(tx, 0, sizeof(*tx));
@@ -642,8 +644,8 @@ static int iwl3945_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 				    len, PCI_DMA_TODEVICE);
 	/* we do not map meta data ... so we can safely access address to
 	 * provide to unmap command*/
-	pci_unmap_addr_set(&out_cmd->meta, mapping, txcmd_phys);
-	pci_unmap_len_set(&out_cmd->meta, len, len);
+	pci_unmap_addr_set(out_meta, mapping, txcmd_phys);
+	pci_unmap_len_set(out_meta, len, len);
 
 	/* Add buffer containing Tx command and MAC(!) header to TFD's
 	 * first entry */
@@ -753,7 +755,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SPECTRUM_MEASUREMENT_CMD,
 		.data = (void *)&spectrum,
-		.meta.flags = CMD_WANT_SKB,
+		.flags = CMD_WANT_SKB,
 	};
 	u32 add_time = le64_to_cpu(params->start_time);
 	int rc;
@@ -794,7 +796,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 	if (rc)
 		return rc;
 
-	res = (struct iwl_rx_packet *)cmd.meta.u.skb->data;
+	res = (struct iwl_rx_packet *)cmd.reply_skb->data;
 	if (res->hdr.flags & IWL_CMD_FAILED_MSK) {
 		IWL_ERR(priv, "Bad return from REPLY_RX_ON_ASSOC command\n");
 		rc = -EIO;
@@ -817,7 +819,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 		break;
 	}
 
-	dev_kfree_skb_any(cmd.meta.u.skb);
+	dev_kfree_skb_any(cmd.reply_skb);
 
 	return rc;
 }
@@ -2717,7 +2719,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	struct iwl_host_cmd cmd = {
 		.id = REPLY_SCAN_CMD,
 		.len = sizeof(struct iwl3945_scan_cmd),
-		.meta.flags = CMD_SIZE_HUGE,
+		.flags = CMD_SIZE_HUGE,
 	};
 	int rc = 0;
 	struct iwl3945_scan_cmd *scan;
-- 
1.5.6.3

