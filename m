Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:43661 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753404AbZASX2R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:17 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 07/15] iwl3945: Use iwl-hcmd host command routines
Date: Mon, 19 Jan 2009 15:30:27 -0800
Message-Id: <1232407835-19451-8-git-send-email-reinette.chatre@intel.com> (sfid-20090120_002829_611495_A93423EA)
In-Reply-To: <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <samuel.ortiz@intel.com>

With the previously added tfd related ops, we can now use the iwl-tx.c host
command enqueue routine. Since the 3945 host command specific
routines are identical to the agn ones, we can just remove them from the 3945
code.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-led.c |    4 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c     |    9 +-
 drivers/net/wireless/iwlwifi/iwl-tx.c       |    8 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |  270 ++------------------------
 4 files changed, 34 insertions(+), 257 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-led.c b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
index e35dc54..fab1373 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-led.c
@@ -40,6 +40,8 @@
 
 #include "iwl-commands.h"
 #include "iwl-3945.h"
+#include "iwl-core.h"
+#include "iwl-dev.h"
 
 
 static const struct {
@@ -91,7 +93,7 @@ static int iwl_send_led_cmd(struct iwl_priv *priv,
 		.meta.u.callback = iwl3945_led_cmd_callback,
 	};
 
-	return iwl3945_send_cmd(priv, &cmd);
+	return iwl_send_cmd(priv, &cmd);
 }
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 18e0f0e..1f3305b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -1766,8 +1766,9 @@ int iwl3945_hw_reg_send_txpower(struct iwl_priv *priv)
 				txpower.power[i].rate);
 	}
 
-	return iwl3945_send_cmd_pdu(priv, REPLY_TX_PWR_TABLE_CMD,
-			sizeof(struct iwl3945_txpowertable_cmd), &txpower);
+	return iwl_send_cmd_pdu(priv, REPLY_TX_PWR_TABLE_CMD,
+				sizeof(struct iwl3945_txpowertable_cmd),
+				&txpower);
 
 }
 
@@ -2463,14 +2464,14 @@ int iwl3945_init_hw_rate_table(struct iwl_priv *priv)
 
 	/* Update the rate scaling for control frame Tx */
 	rate_cmd.table_id = 0;
-	rc = iwl3945_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
+	rc = iwl_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
 			      &rate_cmd);
 	if (rc)
 		return rc;
 
 	/* Update the rate scaling for data frame Tx */
 	rate_cmd.table_id = 1;
-	return iwl3945_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
+	return iwl_send_cmd_pdu(priv, REPLY_RATE_SCALE, sizeof(rate_cmd),
 				&rate_cmd);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-tx.c b/drivers/net/wireless/iwlwifi/iwl-tx.c
index 487a1d6..1a2cfbe 100644
--- a/drivers/net/wireless/iwlwifi/iwl-tx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-tx.c
@@ -1004,7 +1004,8 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	phys_addr += offsetof(struct iwl_cmd, hdr);
 
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   phys_addr, fix_size, 1, 0);
+						   phys_addr, fix_size, 1,
+						   U32_PAD(cmd->len));
 
 #ifdef CONFIG_IWLWIFI_DEBUG
 	switch (out_cmd->hdr.cmd) {
@@ -1028,8 +1029,9 @@ int iwl_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 #endif
 	txq->need_update = 1;
 
-	/* Set up entry in queue's byte count circular buffer */
-	priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, 0);
+	if (priv->cfg->ops->lib->txq_update_byte_cnt_tbl)
+		/* Set up entry in queue's byte count circular buffer */
+		priv->cfg->ops->lib->txq_update_byte_cnt_tbl(priv, txq, 0);
 
 	/* Increment and update queue's write index */
 	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index d76ad43..67f05bc 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -434,246 +434,17 @@ u8 iwl3945_add_station(struct iwl_priv *priv, const u8 *addr, int is_ap, u8 flag
 
 }
 
-
-/*************** HOST COMMAND QUEUE FUNCTIONS   *****/
-
-#define IWL_CMD(x) case x: return #x
-#define HOST_COMPLETE_TIMEOUT (HZ / 2)
-
-/**
- * iwl3945_enqueue_hcmd - enqueue a uCode command
- * @priv: device private data point
- * @cmd: a point to the ucode command structure
- *
- * The function returns < 0 values to indicate the operation is
- * failed. On success, it turns the index (> 0) of command in the
- * command queue.
- */
-static int iwl3945_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
-{
-	struct iwl_tx_queue *txq = &priv->txq[IWL_CMD_QUEUE_NUM];
-	struct iwl_queue *q = &txq->q;
-	struct iwl_cmd *out_cmd;
-	u32 idx;
-	u16 fix_size = (u16)(cmd->len + sizeof(out_cmd->hdr));
-	dma_addr_t phys_addr;
-	int ret, len;
-	unsigned long flags;
-
-	/* If any of the command structures end up being larger than
-	 * the TFD_MAX_PAYLOAD_SIZE, and it sent as a 'small' command then
-	 * we will need to increase the size of the TFD entries */
-	BUG_ON((fix_size > TFD_MAX_PAYLOAD_SIZE) &&
-	       !(cmd->meta.flags & CMD_SIZE_HUGE));
-
-
-	if (iwl_is_rfkill(priv)) {
-		IWL_DEBUG_INFO("Not sending command - RF KILL");
-		return -EIO;
-	}
-
-	if (iwl_queue_space(q) < ((cmd->meta.flags & CMD_ASYNC) ? 2 : 1)) {
-		IWL_ERR(priv, "No space for Tx\n");
-		return -ENOSPC;
-	}
-
-	spin_lock_irqsave(&priv->hcmd_lock, flags);
-
-	idx = get_cmd_index(q, q->write_ptr, cmd->meta.flags & CMD_SIZE_HUGE);
-	out_cmd = txq->cmd[idx];
-
-	out_cmd->hdr.cmd = cmd->id;
-	memcpy(&out_cmd->meta, &cmd->meta, sizeof(cmd->meta));
-	memcpy(&out_cmd->cmd.payload, cmd->data, cmd->len);
-
-	/* At this point, the out_cmd now has all of the incoming cmd
-	 * information */
-
-	out_cmd->hdr.flags = 0;
-	out_cmd->hdr.sequence = cpu_to_le16(QUEUE_TO_SEQ(IWL_CMD_QUEUE_NUM) |
-			INDEX_TO_SEQ(q->write_ptr));
-	if (out_cmd->meta.flags & CMD_SIZE_HUGE)
-		out_cmd->hdr.sequence |= SEQ_HUGE_FRAME;
-
-	len = (idx == TFD_CMD_SLOTS) ?
-			IWL_MAX_SCAN_SIZE : sizeof(struct iwl_cmd);
-
-	phys_addr = pci_map_single(priv->pci_dev, out_cmd,
-					len, PCI_DMA_TODEVICE);
-	pci_unmap_addr_set(&out_cmd->meta, mapping, phys_addr);
-	pci_unmap_len_set(&out_cmd->meta, len, len);
-	phys_addr += offsetof(struct iwl_cmd, hdr);
-
-	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
-						   phys_addr, fix_size,
-						   1, U32_PAD(cmd->len));
-
-	IWL_DEBUG_HC("Sending command %s (#%x), seq: 0x%04X, "
-		     "%d bytes at %d[%d]:%d\n",
-		     get_cmd_string(out_cmd->hdr.cmd),
-		     out_cmd->hdr.cmd, le16_to_cpu(out_cmd->hdr.sequence),
-		     fix_size, q->write_ptr, idx, IWL_CMD_QUEUE_NUM);
-
-	txq->need_update = 1;
-
-	/* Increment and update queue's write index */
-	q->write_ptr = iwl_queue_inc_wrap(q->write_ptr, q->n_bd);
-	ret = iwl_txq_update_write_ptr(priv, txq);
-
-	spin_unlock_irqrestore(&priv->hcmd_lock, flags);
-	return ret ? ret : idx;
-}
-
-static int iwl3945_send_cmd_async(struct iwl_priv *priv,
-				  struct iwl_host_cmd *cmd)
-{
-	int ret;
-
-	BUG_ON(!(cmd->meta.flags & CMD_ASYNC));
-
-	/* An asynchronous command can not expect an SKB to be set. */
-	BUG_ON(cmd->meta.flags & CMD_WANT_SKB);
-
-	/* An asynchronous command MUST have a callback. */
-	BUG_ON(!cmd->meta.u.callback);
-
-	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
-		return -EBUSY;
-
-	ret = iwl3945_enqueue_hcmd(priv, cmd);
-	if (ret < 0) {
-		IWL_ERR(priv,
-			"Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
-			get_cmd_string(cmd->id), ret);
-		return ret;
-	}
-	return 0;
-}
-
-static int iwl3945_send_cmd_sync(struct iwl_priv *priv,
-				 struct iwl_host_cmd *cmd)
-{
-	int cmd_idx;
-	int ret;
-
-	BUG_ON(cmd->meta.flags & CMD_ASYNC);
-
-	 /* A synchronous command can not have a callback set. */
-	BUG_ON(cmd->meta.u.callback != NULL);
-
-	if (test_and_set_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status)) {
-		IWL_ERR(priv,
-			"Error sending %s: Already sending a host command\n",
-			get_cmd_string(cmd->id));
-		ret = -EBUSY;
-		goto out;
-	}
-
-	set_bit(STATUS_HCMD_ACTIVE, &priv->status);
-
-	if (cmd->meta.flags & CMD_WANT_SKB)
-		cmd->meta.source = &cmd->meta;
-
-	cmd_idx = iwl3945_enqueue_hcmd(priv, cmd);
-	if (cmd_idx < 0) {
-		ret = cmd_idx;
-		IWL_ERR(priv,
-			"Error sending %s: iwl3945_enqueue_hcmd failed: %d\n",
-			get_cmd_string(cmd->id), ret);
-		goto out;
-	}
-
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
-			!test_bit(STATUS_HCMD_ACTIVE, &priv->status),
-			HOST_COMPLETE_TIMEOUT);
-	if (!ret) {
-		if (test_bit(STATUS_HCMD_ACTIVE, &priv->status)) {
-			IWL_ERR(priv, "Error sending %s: time out after %dms\n",
-				  get_cmd_string(cmd->id),
-				  jiffies_to_msecs(HOST_COMPLETE_TIMEOUT));
-
-			clear_bit(STATUS_HCMD_ACTIVE, &priv->status);
-			ret = -ETIMEDOUT;
-			goto cancel;
-		}
-	}
-
-	if (test_bit(STATUS_RF_KILL_HW, &priv->status)) {
-		IWL_DEBUG_INFO("Command %s aborted: RF KILL Switch\n",
-			       get_cmd_string(cmd->id));
-		ret = -ECANCELED;
-		goto fail;
-	}
-	if (test_bit(STATUS_FW_ERROR, &priv->status)) {
-		IWL_DEBUG_INFO("Command %s failed: FW Error\n",
-			       get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto fail;
-	}
-	if ((cmd->meta.flags & CMD_WANT_SKB) && !cmd->meta.u.skb) {
-		IWL_ERR(priv, "Error: Response NULL in '%s'\n",
-			  get_cmd_string(cmd->id));
-		ret = -EIO;
-		goto cancel;
-	}
-
-	ret = 0;
-	goto out;
-
-cancel:
-	if (cmd->meta.flags & CMD_WANT_SKB) {
-		struct iwl_cmd *qcmd;
-
-		/* Cancel the CMD_WANT_SKB flag for the cmd in the
-		 * TX cmd queue. Otherwise in case the cmd comes
-		 * in later, it will possibly set an invalid
-		 * address (cmd->meta.source). */
-		qcmd = priv->txq[IWL_CMD_QUEUE_NUM].cmd[cmd_idx];
-		qcmd->meta.flags &= ~CMD_WANT_SKB;
-	}
-fail:
-	if (cmd->meta.u.skb) {
-		dev_kfree_skb_any(cmd->meta.u.skb);
-		cmd->meta.u.skb = NULL;
-	}
-out:
-	clear_bit(STATUS_HCMD_SYNC_ACTIVE, &priv->status);
-	return ret;
-}
-
-int iwl3945_send_cmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
-{
-	if (cmd->meta.flags & CMD_ASYNC)
-		return iwl3945_send_cmd_async(priv, cmd);
-
-	return iwl3945_send_cmd_sync(priv, cmd);
-}
-
-int iwl3945_send_cmd_pdu(struct iwl_priv *priv, u8 id, u16 len, const void *data)
+int iwl3945_send_statistics_request(struct iwl_priv *priv)
 {
-	struct iwl_host_cmd cmd = {
-		.id = id,
-		.len = len,
-		.data = data,
-	};
-
-	return iwl3945_send_cmd_sync(priv, &cmd);
-}
+	u32 val = 0;
 
-static int __must_check iwl3945_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
-{
 	struct iwl_host_cmd cmd = {
-		.id = id,
+		.id = REPLY_STATISTICS_CMD,
 		.len = sizeof(val),
 		.data = &val,
 	};
 
-	return iwl3945_send_cmd_sync(priv, &cmd);
-}
-
-int iwl3945_send_statistics_request(struct iwl_priv *priv)
-{
-	return iwl3945_send_cmd_u32(priv, REPLY_STATISTICS_CMD, 0);
+	return iwl_send_cmd_sync(priv, &cmd);
 }
 
 /**
@@ -864,7 +635,7 @@ static int iwl3945_send_rxon_assoc(struct iwl_priv *priv)
 	rxon_assoc.cck_basic_rates = priv->staging39_rxon.cck_basic_rates;
 	rxon_assoc.reserved = 0;
 
-	rc = iwl3945_send_cmd_sync(priv, &cmd);
+	rc = iwl_send_cmd_sync(priv, &cmd);
 	if (rc)
 		return rc;
 
@@ -936,7 +707,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		IWL_DEBUG_INFO("Toggling associated bit on current RXON\n");
 		active_rxon->filter_flags &= ~RXON_FILTER_ASSOC_MSK;
 
-		rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON,
+		rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 				      sizeof(struct iwl3945_rxon_cmd),
 				      &priv->active39_rxon);
 
@@ -960,7 +731,7 @@ static int iwl3945_commit_rxon(struct iwl_priv *priv)
 		       priv->staging_rxon.bssid_addr);
 
 	/* Apply the new configuration */
-	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON,
+	rc = iwl_send_cmd_pdu(priv, REPLY_RXON,
 			      sizeof(struct iwl3945_rxon_cmd), &priv->staging39_rxon);
 	if (rc) {
 		IWL_ERR(priv, "Error setting new configuration (%d).\n", rc);
@@ -1016,7 +787,7 @@ static int iwl3945_send_bt_config(struct iwl_priv *priv)
 		.kill_cts_mask = 0,
 	};
 
-	return iwl3945_send_cmd_pdu(priv, REPLY_BT_CONFIG,
+	return iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG,
 					sizeof(bt_cmd), &bt_cmd);
 }
 
@@ -1037,7 +808,7 @@ static int iwl3945_send_scan_abort(struct iwl_priv *priv)
 		return 0;
 	}
 
-	rc = iwl3945_send_cmd_sync(priv, &cmd);
+	rc = iwl_send_cmd_sync(priv, &cmd);
 	if (rc) {
 		clear_bit(STATUS_SCAN_ABORTING, &priv->status);
 		return rc;
@@ -1106,7 +877,7 @@ int iwl3945_send_add_station(struct iwl_priv *priv,
 	else
 		cmd.meta.flags |= CMD_WANT_SKB;
 
-	rc = iwl3945_send_cmd(priv, &cmd);
+	rc = iwl_send_cmd(priv, &cmd);
 
 	if (rc || (flags & CMD_ASYNC))
 		return rc;
@@ -1300,7 +1071,7 @@ static int iwl3945_send_beacon_cmd(struct iwl_priv *priv)
 
 	frame_size = iwl3945_hw_get_beacon_cmd(priv, frame, rate);
 
-	rc = iwl3945_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
+	rc = iwl_send_cmd_pdu(priv, REPLY_TX_BEACON, frame_size,
 			      &frame->u.cmd[0]);
 
 	iwl3945_free_frame(priv, frame);
@@ -1513,7 +1284,7 @@ static int iwl3945_send_qos_params_command(struct iwl_priv *priv,
 				       struct iwl_qosparam_cmd *qos)
 {
 
-	return iwl3945_send_cmd_pdu(priv, REPLY_QOS_PARAM,
+	return iwl_send_cmd_pdu(priv, REPLY_QOS_PARAM,
 				sizeof(struct iwl_qosparam_cmd), qos);
 }
 
@@ -1714,8 +1485,8 @@ static int iwl3945_send_power_mode(struct iwl_priv *priv, u32 mode)
 	iwl3945_update_power_cmd(priv, &cmd, final_mode);
 
 	/* FIXME use get_hcmd_size 3945 command is 4 bytes shorter */
-	rc = iwl3945_send_cmd_pdu(priv, POWER_TABLE_CMD,
-				sizeof(struct iwl3945_powertable_cmd), &cmd);
+	rc = iwl_send_cmd_pdu(priv, POWER_TABLE_CMD,
+			      sizeof(struct iwl3945_powertable_cmd), &cmd);
 
 	if (final_mode == IWL_POWER_MODE_CAM)
 		clear_bit(STATUS_POWER_PMI, &priv->status);
@@ -2601,7 +2372,7 @@ static int iwl3945_get_measurement(struct iwl_priv *priv,
 		spectrum.flags |= RXON_FLG_BAND_24G_MSK |
 		    RXON_FLG_AUTO_DETECT_MSK | RXON_FLG_TGG_PROTECT_MSK;
 
-	rc = iwl3945_send_cmd_sync(priv, &cmd);
+	rc = iwl_send_cmd_sync(priv, &cmd);
 	if (rc)
 		return rc;
 
@@ -3425,7 +3196,7 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 		if (reclaim) {
 			/* Invoke any callbacks, transfer the skb to caller, and
-			 * fire off the (possibly) blocking iwl3945_send_cmd()
+			 * fire off the (possibly) blocking iwl_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb && rxb->skb)
 				iwl3945_tx_cmd_complete(priv, rxb);
@@ -5601,7 +5372,7 @@ static void iwl3945_bg_request_scan(struct work_struct *data)
 	scan->len = cpu_to_le16(cmd.len);
 
 	set_bit(STATUS_SCAN_HW, &priv->status);
-	rc = iwl3945_send_cmd_sync(priv, &cmd);
+	rc = iwl_send_cmd_sync(priv, &cmd);
 	if (rc)
 		goto done;
 
@@ -5693,7 +5464,7 @@ static void iwl3945_post_associate(struct iwl_priv *priv)
 
 	memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
 	iwl3945_setup_rxon_timing(priv);
-	rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+	rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
 			      sizeof(priv->rxon_timing), &priv->rxon_timing);
 	if (rc)
 		IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
@@ -6060,8 +5831,9 @@ static void iwl3945_config_ap(struct iwl_priv *priv)
 		/* RXON Timing */
 		memset(&priv->rxon_timing, 0, sizeof(struct iwl_rxon_time_cmd));
 		iwl3945_setup_rxon_timing(priv);
-		rc = iwl3945_send_cmd_pdu(priv, REPLY_RXON_TIMING,
-				sizeof(priv->rxon_timing), &priv->rxon_timing);
+		rc = iwl_send_cmd_pdu(priv, REPLY_RXON_TIMING,
+				      sizeof(priv->rxon_timing),
+				      &priv->rxon_timing);
 		if (rc)
 			IWL_WARN(priv, "REPLY_RXON_TIMING failed - "
 					"Attempting to continue.\n");
-- 
1.5.4.3

