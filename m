Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:26702 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1IFRPH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 13:15:07 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 03/10] iwlagn: remove priv dereferences from the transport layer
Date: Tue,  6 Sep 2011 09:31:18 -0700
Message-Id: <1315326685-22213-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110906_191516_286416_1DE01388)
In-Reply-To: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1315326685-22213-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Another round of clean up on the transport layer.
Define a wrapper around wiphy_rfkill_set_hw_state to prevent the
transport layer from accessing priv->hw.
Also move wait_command_queue to the transport layer.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c      |    2 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c            |    2 +-
 drivers/net/wireless/iwlwifi/iwl-core.c           |    7 +++-
 drivers/net/wireless/iwlwifi/iwl-dev.h            |    6 +--
 drivers/net/wireless/iwlwifi/iwl-rx.c             |    2 +-
 drivers/net/wireless/iwlwifi/iwl-shared.h         |    3 ++
 drivers/net/wireless/iwlwifi/iwl-sta.c            |    4 +-
 drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h |    3 +-
 drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c  |   36 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c  |   36 ++++++++++-----------
 drivers/net/wireless/iwlwifi/iwl-trans.c          |   18 ++++------
 11 files changed, 59 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index ddb255a..8b14d24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -114,7 +114,7 @@ static int iwlagn_load_section(struct iwl_priv *priv, const char *name,
 		FH_TCSR_TX_CONFIG_REG_VAL_CIRQ_HOST_ENDTFD);
 
 	IWL_DEBUG_FW(priv, "%s uCode section being loaded...\n", name);
-	ret = wait_event_interruptible_timeout(priv->wait_command_queue,
+	ret = wait_event_interruptible_timeout(priv->shrd->wait_command_queue,
 					priv->ucode_write_complete, 5 * HZ);
 	if (ret == -ERESTARTSYS) {
 		IWL_ERR(priv, "Could not load the %s uCode section due "
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 8113fbe..484f889 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3032,7 +3032,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 {
 	priv->shrd->workqueue = create_singlethread_workqueue(DRV_NAME);
 
-	init_waitqueue_head(&priv->wait_command_queue);
+	init_waitqueue_head(&priv->shrd->wait_command_queue);
 
 	INIT_WORK(&priv->restart, iwl_bg_restart);
 	INIT_WORK(&priv->beacon_update, iwl_bg_beacon_update);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 20dd1a5..416695a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -868,7 +868,7 @@ void iwlagn_fw_error(struct iwl_priv *priv, bool ondemand)
 	 * commands by clearing the ready bit */
 	clear_bit(STATUS_READY, &priv->shrd->status);
 
-	wake_up_interruptible(&priv->wait_command_queue);
+	wake_up_interruptible(&priv->shrd->wait_command_queue);
 
 	if (!ondemand) {
 		/*
@@ -1865,3 +1865,8 @@ void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
 
 	ieee80211_stop_tx_ba_cb_irqsafe(vif, addr, tid);
 }
+
+void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state)
+{
+	wiphy_rfkill_set_hw_state(priv->hw->wiphy, state);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1e54293..8ae79e9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -102,7 +102,7 @@ struct iwl_cmd_meta {
 	 * invoked for SYNC commands, if it were and its result passed
 	 * through it would be simpler...)
 	 */
-	void (*callback)(struct iwl_priv *priv,
+	void (*callback)(struct iwl_shared *shrd,
 			 struct iwl_device_cmd *cmd,
 			 struct iwl_rx_packet *pkt);
 
@@ -304,7 +304,7 @@ enum iwl_hcmd_dataflag {
 struct iwl_host_cmd {
 	const void *data[IWL_MAX_CMD_TFDS];
 	unsigned long reply_page;
-	void (*callback)(struct iwl_priv *priv,
+	void (*callback)(struct iwl_shared *shrd,
 			 struct iwl_device_cmd *cmd,
 			 struct iwl_rx_packet *pkt);
 	u32 flags;
@@ -1142,8 +1142,6 @@ struct iwl_priv {
 	/* Rate scaling data */
 	u8 retry_rate;
 
-	wait_queue_head_t wait_command_queue;
-
 	int activity_timer_active;
 
 	/* counts mgmt, ctl, and data packets */
diff --git a/drivers/net/wireless/iwlwifi/iwl-rx.c b/drivers/net/wireless/iwlwifi/iwl-rx.c
index 8572548..ee8fabd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -563,7 +563,7 @@ static void iwl_rx_card_state_notif(struct iwl_priv *priv,
 		wiphy_rfkill_set_hw_state(priv->hw->wiphy,
 			test_bit(STATUS_RF_KILL_HW, &priv->shrd->status));
 	else
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up_interruptible(&priv->shrd->wait_command_queue);
 }
 
 static void iwl_rx_missed_beacon_notif(struct iwl_priv *priv,
diff --git a/drivers/net/wireless/iwlwifi/iwl-shared.h b/drivers/net/wireless/iwlwifi/iwl-shared.h
index 8b8cd54..9790d7e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-shared.h
+++ b/drivers/net/wireless/iwlwifi/iwl-shared.h
@@ -250,6 +250,8 @@ struct iwl_shared {
 	struct ieee80211_hw *hw;
 
 	struct iwl_tid_data tid_data[IWLAGN_STATION_COUNT][IWL_MAX_TID_COUNT];
+
+	wait_queue_head_t wait_command_queue;
 };
 
 /*Whatever _m is (iwl_trans, iwl_priv, iwl_bus, these macros will work */
@@ -361,6 +363,7 @@ void iwl_start_tx_ba_trans_ready(struct iwl_priv *priv,
 void iwl_stop_tx_ba_trans_ready(struct iwl_priv *priv,
 				enum iwl_rxon_context_id ctx,
 				u8 sta_id, u8 tid);
+void iwl_set_hw_rfkill_state(struct iwl_priv *priv, bool state);
 
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
diff --git a/drivers/net/wireless/iwlwifi/iwl-sta.c b/drivers/net/wireless/iwlwifi/iwl-sta.c
index 26b2bd4..e24135e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-sta.c
+++ b/drivers/net/wireless/iwlwifi/iwl-sta.c
@@ -123,14 +123,14 @@ static int iwl_process_add_sta_resp(struct iwl_priv *priv,
 	return ret;
 }
 
-static void iwl_add_sta_callback(struct iwl_priv *priv,
+static void iwl_add_sta_callback(struct iwl_shared *shrd,
 				 struct iwl_device_cmd *cmd,
 				 struct iwl_rx_packet *pkt)
 {
 	struct iwl_addsta_cmd *addsta =
 		(struct iwl_addsta_cmd *)cmd->cmd.payload;
 
-	iwl_process_add_sta_resp(priv, addsta, pkt, false);
+	iwl_process_add_sta_resp(shrd->priv, addsta, pkt, false);
 
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
index ec4e737..f76526e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-int-pcie.h
@@ -195,7 +195,8 @@ int iwl_queue_init(struct iwl_queue *q, int count, int slots_num, u32 id);
 int iwl_trans_pcie_send_cmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd);
 int __must_check iwl_trans_pcie_send_cmd_pdu(struct iwl_trans *trans, u8 id,
 			u32 flags, u16 len, const void *data);
-void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb);
+void iwl_tx_cmd_complete(struct iwl_trans *trans,
+			 struct iwl_rx_mem_buffer *rxb);
 void iwl_trans_txq_update_byte_cnt_tbl(struct iwl_trans *trans,
 					   struct iwl_tx_queue *txq,
 					   u16 byte_cnt);
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
index 2d0ddb8..e22cc6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-rx-pcie.c
@@ -453,7 +453,7 @@ static void iwl_rx_handle(struct iwl_trans *trans)
 			 * iwl_trans_send_cmd()
 			 * as we reclaim the driver command queue */
 			if (rxb->page)
-				iwl_tx_cmd_complete(priv(trans), rxb);
+				iwl_tx_cmd_complete(trans, rxb);
 			else
 				IWL_WARN(trans, "Claim null rxb?\n");
 		}
@@ -646,7 +646,7 @@ static void iwl_irq_handle_error(struct iwl_trans *trans)
 		 */
 		clear_bit(STATUS_READY, &trans->shrd->status);
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up_interruptible(&priv->shrd->wait_command_queue);
 		IWL_ERR(trans, "RF is used by WiMAX\n");
 		return;
 	}
@@ -705,18 +705,18 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	ptr = base + EVENT_START_OFFSET + (start_idx * event_size);
 
 	/* Make sure device is powered up for SRAM reads */
-	spin_lock_irqsave(&bus(priv)->reg_lock, reg_flags);
-	iwl_grab_nic_access(bus(priv));
+	spin_lock_irqsave(&bus(trans)->reg_lock, reg_flags);
+	iwl_grab_nic_access(bus(trans));
 
 	/* Set starting address; reads will auto-increment */
-	iwl_write32(bus(priv), HBUS_TARG_MEM_RADDR, ptr);
+	iwl_write32(bus(trans), HBUS_TARG_MEM_RADDR, ptr);
 	rmb();
 
 	/* "time" is actually "data" for mode 0 (no timestamp).
 	* place event id # at far right for easier visual parsing. */
 	for (i = 0; i < num_events; i++) {
-		ev = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
-		time = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+		ev = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
+		time = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
 		if (mode == 0) {
 			/* data, ev */
 			if (bufsz) {
@@ -730,7 +730,7 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 					time, ev);
 			}
 		} else {
-			data = iwl_read32(bus(priv), HBUS_TARG_MEM_RDAT);
+			data = iwl_read32(bus(trans), HBUS_TARG_MEM_RDAT);
 			if (bufsz) {
 				pos += scnprintf(*buf + pos, bufsz - pos,
 						"EVT_LOGT:%010u:0x%08x:%04u\n",
@@ -745,8 +745,8 @@ static int iwl_print_event_log(struct iwl_trans *trans, u32 start_idx,
 	}
 
 	/* Allow device to power down */
-	iwl_release_nic_access(bus(priv));
-	spin_unlock_irqrestore(&bus(priv)->reg_lock, reg_flags);
+	iwl_release_nic_access(bus(trans));
+	spin_unlock_irqrestore(&bus(trans)->reg_lock, reg_flags);
 	return pos;
 }
 
@@ -823,10 +823,10 @@ int iwl_dump_nic_event_log(struct iwl_trans *trans, bool full_log,
 	}
 
 	/* event log header */
-	capacity = iwl_read_targ_mem(bus(priv), base);
-	mode = iwl_read_targ_mem(bus(priv), base + (1 * sizeof(u32)));
-	num_wraps = iwl_read_targ_mem(bus(priv), base + (2 * sizeof(u32)));
-	next_entry = iwl_read_targ_mem(bus(priv), base + (3 * sizeof(u32)));
+	capacity = iwl_read_targ_mem(bus(trans), base);
+	mode = iwl_read_targ_mem(bus(trans), base + (1 * sizeof(u32)));
+	num_wraps = iwl_read_targ_mem(bus(trans), base + (2 * sizeof(u32)));
+	next_entry = iwl_read_targ_mem(bus(trans), base + (3 * sizeof(u32)));
 
 	if (capacity > logsize) {
 		IWL_ERR(trans, "Log capacity %d is bogus, limit to %d "
@@ -908,8 +908,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 	u32 inta_mask;
 #endif
 
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans);
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct isr_statistics *isr_stats = &trans_pcie->isr_stats;
 
 
@@ -1003,8 +1002,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 			else
 				clear_bit(STATUS_RF_KILL_HW,
 					  &trans->shrd->status);
-			wiphy_rfkill_set_hw_state(priv(trans)->hw->wiphy,
-						  hw_rf_kill);
+			iwl_set_hw_rfkill_state(priv(trans), hw_rf_kill);
 		}
 
 		handled |= CSR_INT_BIT_RF_KILL;
@@ -1093,7 +1091,7 @@ void iwl_irq_tasklet(struct iwl_trans *trans)
 		handled |= CSR_INT_BIT_FH_TX;
 		/* Wake up uCode load routine, now that load is complete */
 		priv(trans)->ucode_write_complete = 1;
-		wake_up_interruptible(&priv(trans)->wait_command_queue);
+		wake_up_interruptible(&trans->shrd->wait_command_queue);
 	}
 
 	if (inta & ~handled) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
index 5dd6a6d..3e71107 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans-tx-pcie.c
@@ -536,7 +536,6 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 	struct iwl_tid_data *tid_data;
 	unsigned long flags;
 	u16 txq_id;
-	struct iwl_priv *priv = priv(trans);
 
 	txq_id = iwlagn_txq_ctx_activate_free(trans);
 	if (txq_id == -1) {
@@ -560,7 +559,7 @@ int iwl_trans_pcie_tx_agg_alloc(struct iwl_trans *trans,
 			     "queue\n", tid_data->tfds_in_queue);
 		tid_data->agg.state = IWL_EMPTYING_HW_QUEUE_ADDBA;
 	}
-	spin_unlock_irqrestore(&priv->shrd->sta_lock, flags);
+	spin_unlock_irqrestore(&trans->shrd->sta_lock, flags);
 
 	return 0;
 }
@@ -856,16 +855,16 @@ static int iwl_enqueue_hcmd(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
  * need to be reclaimed. As result, some free space forms.  If there is
  * enough free space (> low mark), wake the stack that feeds us.
  */
-static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int idx)
+static void iwl_hcmd_queue_reclaim(struct iwl_trans *trans, int txq_id,
+				   int idx)
 {
-	struct iwl_trans_pcie *trans_pcie =
-		IWL_TRANS_GET_PCIE_TRANS(trans(priv));
+	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[txq_id];
 	struct iwl_queue *q = &txq->q;
 	int nfreed = 0;
 
 	if ((idx >= q->n_bd) || (iwl_queue_used(q, idx) == 0)) {
-		IWL_ERR(priv, "%s: Read index for DMA queue txq id (%d), "
+		IWL_ERR(trans, "%s: Read index for DMA queue txq id (%d), "
 			  "index %d is out of range [0-%d] %d %d.\n", __func__,
 			  txq_id, idx, q->n_bd, q->write_ptr, q->read_ptr);
 		return;
@@ -875,9 +874,9 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int idx)
 	     q->read_ptr = iwl_queue_inc_wrap(q->read_ptr, q->n_bd)) {
 
 		if (nfreed++ > 0) {
-			IWL_ERR(priv, "HCMD skipped: index (%d) %d %d\n", idx,
+			IWL_ERR(trans, "HCMD skipped: index (%d) %d %d\n", idx,
 					q->write_ptr, q->read_ptr);
-			iwlagn_fw_error(priv, false);
+			iwlagn_fw_error(priv(trans), false);
 		}
 
 	}
@@ -891,7 +890,7 @@ static void iwl_hcmd_queue_reclaim(struct iwl_priv *priv, int txq_id, int idx)
  * will be executed.  The attached skb (if present) will only be freed
  * if the callback returns 1
  */
-void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
+void iwl_tx_cmd_complete(struct iwl_trans *trans, struct iwl_rx_mem_buffer *rxb)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	u16 sequence = le16_to_cpu(pkt->hdr.sequence);
@@ -900,7 +899,6 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 	int cmd_index;
 	struct iwl_device_cmd *cmd;
 	struct iwl_cmd_meta *meta;
-	struct iwl_trans *trans = trans(priv);
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
 	struct iwl_tx_queue *txq = &trans_pcie->txq[trans->shrd->cmd_queue];
 	unsigned long flags;
@@ -913,7 +911,7 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		  txq_id, trans->shrd->cmd_queue, sequence,
 		  trans_pcie->txq[trans->shrd->cmd_queue].q.read_ptr,
 		  trans_pcie->txq[trans->shrd->cmd_queue].q.write_ptr)) {
-		iwl_print_hex_error(priv, pkt, 32);
+		iwl_print_hex_error(trans, pkt, 32);
 		return;
 	}
 
@@ -929,17 +927,17 @@ void iwl_tx_cmd_complete(struct iwl_priv *priv, struct iwl_rx_mem_buffer *rxb)
 		meta->source->reply_page = (unsigned long)rxb_addr(rxb);
 		rxb->page = NULL;
 	} else if (meta->callback)
-		meta->callback(priv, cmd, pkt);
+		meta->callback(trans->shrd, cmd, pkt);
 
 	spin_lock_irqsave(&trans->hcmd_lock, flags);
 
-	iwl_hcmd_queue_reclaim(priv, txq_id, index);
+	iwl_hcmd_queue_reclaim(trans, txq_id, index);
 
 	if (!(meta->flags & CMD_ASYNC)) {
 		clear_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status);
 		IWL_DEBUG_INFO(trans, "Clearing HCMD_ACTIVE for command %s\n",
 			       get_cmd_string(cmd->hdr.cmd));
-		wake_up_interruptible(&priv->wait_command_queue);
+		wake_up_interruptible(&trans->shrd->wait_command_queue);
 	}
 
 	meta->flags = 0;
@@ -1031,12 +1029,12 @@ const char *get_cmd_string(u8 cmd)
 
 #define HOST_COMPLETE_TIMEOUT (2 * HZ)
 
-static void iwl_generic_cmd_callback(struct iwl_priv *priv,
+static void iwl_generic_cmd_callback(struct iwl_shared *shrd,
 				     struct iwl_device_cmd *cmd,
 				     struct iwl_rx_packet *pkt)
 {
 	if (pkt->hdr.flags & IWL_CMD_FAILED_MSK) {
-		IWL_ERR(priv, "Bad return from %s (0x%08X)\n",
+		IWL_ERR(shrd->trans, "Bad return from %s (0x%08X)\n",
 			get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 		return;
 	}
@@ -1045,11 +1043,11 @@ static void iwl_generic_cmd_callback(struct iwl_priv *priv,
 	switch (cmd->hdr.cmd) {
 	case REPLY_TX_LINK_QUALITY_CMD:
 	case SENSITIVITY_CMD:
-		IWL_DEBUG_HC_DUMP(priv, "back from %s (0x%08X)\n",
+		IWL_DEBUG_HC_DUMP(shrd->trans, "back from %s (0x%08X)\n",
 				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 		break;
 	default:
-		IWL_DEBUG_HC(priv, "back from %s (0x%08X)\n",
+		IWL_DEBUG_HC(shrd->trans, "back from %s (0x%08X)\n",
 				get_cmd_string(cmd->hdr.cmd), pkt->hdr.flags);
 	}
 #endif
@@ -1107,7 +1105,7 @@ static int iwl_send_cmd_sync(struct iwl_trans *trans, struct iwl_host_cmd *cmd)
 		return ret;
 	}
 
-	ret = wait_event_interruptible_timeout(priv(trans)->wait_command_queue,
+	ret = wait_event_interruptible_timeout(trans->shrd->wait_command_queue,
 			!test_bit(STATUS_HCMD_ACTIVE, &trans->shrd->status),
 			HOST_COMPLETE_TIMEOUT);
 	if (!ret) {
diff --git a/drivers/net/wireless/iwlwifi/iwl-trans.c b/drivers/net/wireless/iwlwifi/iwl-trans.c
index cec13ad..44e2f91 100644
--- a/drivers/net/wireless/iwlwifi/iwl-trans.c
+++ b/drivers/net/wireless/iwlwifi/iwl-trans.c
@@ -604,9 +604,8 @@ error:
 	return ret;
 }
 
-static void iwl_set_pwr_vmain(struct iwl_priv *priv)
+static void iwl_set_pwr_vmain(struct iwl_trans *trans)
 {
-	struct iwl_trans *trans = trans(priv);
 /*
  * (for documentation purposes)
  * to set power to V_AUX, do:
@@ -625,11 +624,10 @@ static void iwl_set_pwr_vmain(struct iwl_priv *priv)
 static int iwl_nic_init(struct iwl_trans *trans)
 {
 	unsigned long flags;
-	struct iwl_priv *priv = priv(trans);
 
 	/* nic_init */
 	spin_lock_irqsave(&trans->shrd->lock, flags);
-	iwl_apm_init(priv);
+	iwl_apm_init(priv(trans));
 
 	/* Set interrupt coalescing calibration timer to default (512 usecs) */
 	iwl_write8(bus(trans), CSR_INT_COALESCING,
@@ -637,9 +635,9 @@ static int iwl_nic_init(struct iwl_trans *trans)
 
 	spin_unlock_irqrestore(&trans->shrd->lock, flags);
 
-	iwl_set_pwr_vmain(priv);
+	iwl_set_pwr_vmain(trans);
 
-	priv->cfg->lib->nic_config(priv);
+	priv(trans)->cfg->lib->nic_config(priv(trans));
 
 	/* Allocate the RX queue, or reset if it is already allocated */
 	iwl_rx_init(trans);
@@ -764,7 +762,6 @@ static const u8 iwlagn_pan_ac_to_queue[] = {
 static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 {
 	int ret;
-	struct iwl_priv *priv = priv(trans);
 	struct iwl_trans_pcie *trans_pcie =
 		IWL_TRANS_GET_PCIE_TRANS(trans);
 
@@ -792,7 +789,7 @@ static int iwl_trans_pcie_start_device(struct iwl_trans *trans)
 		set_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 
 	if (iwl_is_rfkill(trans->shrd)) {
-		wiphy_rfkill_set_hw_state(priv->hw->wiphy, true);
+		iwl_set_hw_rfkill_state(priv(trans), true);
 		iwl_enable_interrupts(trans);
 		return -ERFKILL;
 	}
@@ -1397,7 +1394,7 @@ static int iwl_trans_pcie_resume(struct iwl_trans *trans)
 	else
 		clear_bit(STATUS_RF_KILL_HW, &trans->shrd->status);
 
-	wiphy_rfkill_set_hw_state(priv(trans)->hw->wiphy, hw_rfkill);
+	iwl_set_hw_rfkill_state(priv(trans), hw_rfkill);
 
 	return 0;
 }
@@ -1674,7 +1671,6 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 {
 	struct iwl_trans *trans = file->private_data;
 	struct iwl_trans_pcie *trans_pcie = IWL_TRANS_GET_PCIE_TRANS(trans);
-	struct iwl_priv *priv = priv(trans);
 	struct iwl_tx_queue *txq;
 	struct iwl_queue *q;
 	char *buf;
@@ -1684,7 +1680,7 @@ static ssize_t iwl_dbgfs_tx_queue_read(struct file *file,
 	const size_t bufsz = sizeof(char) * 64 * hw_params(trans).max_txq_num;
 
 	if (!trans_pcie->txq) {
-		IWL_ERR(priv, "txq not ready\n");
+		IWL_ERR(trans, "txq not ready\n");
 		return -EAGAIN;
 	}
 	buf = kzalloc(bufsz, GFP_KERNEL);
-- 
1.7.0.4

