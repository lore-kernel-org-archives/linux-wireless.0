Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0HWOxe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:34 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 19/26] iwlagn: parsing uart message and take actions
Date: Mon, 23 Aug 2010 07:57:10 -0700
Message-Id: <1282575437-23270-20-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

1. Based on uart message from uCode, re-configure BT kill ack mask
messages from uCode
2. send REPLY_BT_COEX_SCO command to uCode based on the uart frame
received from uCode

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c      |  116 ++++++++++++++++++++++---
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    5 +
 drivers/net/wireless/iwlwifi/iwl-agn.c       |   16 ++++
 drivers/net/wireless/iwlwifi/iwl-commands.h  |  110 ++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-dev.h       |    4 +
 5 files changed, 235 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 54b59da..e4873cc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -221,17 +221,17 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 	struct iwl6000g2b_bt_cmd bt_cmd = {
 		.max_kill = IWL6000G2B_BT_MAX_KILL_DEFAULT,
 		.bt3_timer_t7_value = IWL6000G2B_BT3_T7_DEFAULT,
-		.kill_ack_mask = IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT,
-		.kill_cts_mask = IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT,
 		.bt3_prio_sample_time = IWL6000G2B_BT3_PRIO_SAMPLE_DEFAULT,
 		.bt3_timer_t2_value = IWL6000G2B_BT3_T2_DEFAULT,
-		.valid = IWL6000G2B_BT_VALID_ENABLE_FLAGS,
 	};
 
 	BUILD_BUG_ON(sizeof(iwl6000g2b_def_3w_lookup) !=
 			sizeof(bt_cmd.bt3_lookup_table));
 
 	bt_cmd.prio_boost = priv->cfg->bt_prio_boost;
+	bt_cmd.kill_ack_mask = priv->kill_ack_mask;
+	bt_cmd.kill_cts_mask = priv->kill_cts_mask;
+	bt_cmd.valid = priv->bt_valid;
 
 	/*
 	 * Configure BT coex mode to "no coexistence" when the
@@ -245,7 +245,6 @@ static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
 		bt_cmd.flags = IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION |
 				IWL6000G2B_BT_FLAG_COEX_MODE_3W <<
 					IWL6000G2B_BT_FLAG_COEX_MODE_SHIFT;
-		bt_cmd.valid |= IWL6000G2B_BT_ALL_VALID_MSK;
 	}
 
 	if (priv->bt_full_concurrent)
@@ -453,6 +452,93 @@ static void iwl6000g2b_bt_traffic_change_work(struct work_struct *work)
 	mutex_unlock(&priv->mutex);
 }
 
+static void iwlagn_print_uartmsg(struct iwl_priv *priv,
+				struct iwl_bt_uart_msg *uart_msg)
+{
+	IWL_DEBUG_NOTIF(priv, "Message Type = 0x%X, SSN = 0x%X, "
+			"Update Req = 0x%X",
+		(BT_UART_MSG_FRAME1MSGTYPE_MSK & uart_msg->frame1) >>
+			BT_UART_MSG_FRAME1MSGTYPE_POS,
+		(BT_UART_MSG_FRAME1SSN_MSK & uart_msg->frame1) >>
+			BT_UART_MSG_FRAME1SSN_POS,
+		(BT_UART_MSG_FRAME1UPDATEREQ_MSK & uart_msg->frame1) >>
+			BT_UART_MSG_FRAME1UPDATEREQ_POS);
+
+	IWL_DEBUG_NOTIF(priv, "Open connections = 0x%X, Traffic load = 0x%X, "
+			"Chl_SeqN = 0x%X, In band = 0x%X",
+		(BT_UART_MSG_FRAME2OPENCONNECTIONS_MSK & uart_msg->frame2) >>
+			BT_UART_MSG_FRAME2OPENCONNECTIONS_POS,
+		(BT_UART_MSG_FRAME2TRAFFICLOAD_MSK & uart_msg->frame2) >>
+			BT_UART_MSG_FRAME2TRAFFICLOAD_POS,
+		(BT_UART_MSG_FRAME2CHLSEQN_MSK & uart_msg->frame2) >>
+			BT_UART_MSG_FRAME2CHLSEQN_POS,
+		(BT_UART_MSG_FRAME2INBAND_MSK & uart_msg->frame2) >>
+			BT_UART_MSG_FRAME2INBAND_POS);
+
+	IWL_DEBUG_NOTIF(priv, "SCO/eSCO = 0x%X, Sniff = 0x%X, A2DP = 0x%X, "
+			"ACL = 0x%X, Master = 0x%X, OBEX = 0x%X",
+		(BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3) >>
+			BT_UART_MSG_FRAME3SCOESCO_POS,
+		(BT_UART_MSG_FRAME3SNIFF_MSK & uart_msg->frame3) >>
+			BT_UART_MSG_FRAME3SNIFF_POS,
+		(BT_UART_MSG_FRAME3A2DP_MSK & uart_msg->frame3) >>
+			BT_UART_MSG_FRAME3A2DP_POS,
+		(BT_UART_MSG_FRAME3ACL_MSK & uart_msg->frame3) >>
+			BT_UART_MSG_FRAME3ACL_POS,
+		(BT_UART_MSG_FRAME3MASTER_MSK & uart_msg->frame3) >>
+			BT_UART_MSG_FRAME3MASTER_POS,
+		(BT_UART_MSG_FRAME3OBEX_MSK & uart_msg->frame3) >>
+			BT_UART_MSG_FRAME3OBEX_POS);
+
+	IWL_DEBUG_NOTIF(priv, "Idle duration = 0x%X",
+		(BT_UART_MSG_FRAME4IDLEDURATION_MSK & uart_msg->frame4) >>
+			BT_UART_MSG_FRAME4IDLEDURATION_POS);
+
+	IWL_DEBUG_NOTIF(priv, "Tx Activity = 0x%X, Rx Activity = 0x%X, "
+			"eSCO Retransmissions = 0x%X",
+		(BT_UART_MSG_FRAME5TXACTIVITY_MSK & uart_msg->frame5) >>
+			BT_UART_MSG_FRAME5TXACTIVITY_POS,
+		(BT_UART_MSG_FRAME5RXACTIVITY_MSK & uart_msg->frame5) >>
+			BT_UART_MSG_FRAME5RXACTIVITY_POS,
+		(BT_UART_MSG_FRAME5ESCORETRANSMIT_MSK & uart_msg->frame5) >>
+			BT_UART_MSG_FRAME5ESCORETRANSMIT_POS);
+
+	IWL_DEBUG_NOTIF(priv, "Sniff Interval = 0x%X, Discoverable = 0x%X",
+		(BT_UART_MSG_FRAME6SNIFFINTERVAL_MSK & uart_msg->frame6) >>
+			BT_UART_MSG_FRAME6SNIFFINTERVAL_POS,
+		(BT_UART_MSG_FRAME6DISCOVERABLE_MSK & uart_msg->frame6) >>
+			BT_UART_MSG_FRAME6DISCOVERABLE_POS);
+
+	IWL_DEBUG_NOTIF(priv, "Sniff Activity = 0x%X, Inquiry/Page SR Mode = "
+			"0x%X, Connectable = 0x%X",
+		(BT_UART_MSG_FRAME7SNIFFACTIVITY_MSK & uart_msg->frame7) >>
+			BT_UART_MSG_FRAME7SNIFFACTIVITY_POS,
+		(BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_MSK & uart_msg->frame7) >>
+			BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_POS,
+		(BT_UART_MSG_FRAME7CONNECTABLE_MSK & uart_msg->frame7) >>
+			BT_UART_MSG_FRAME7CONNECTABLE_POS);
+}
+
+static void iwl6000g2b_set_kill_ack_msk(struct iwl_priv *priv,
+				     struct iwl_bt_uart_msg *uart_msg)
+{
+	u8 kill_ack_msk;
+	__le32 bt_kill_ack_msg[2] = {
+		cpu_to_le32(0xFFFFFFF), cpu_to_le32(0xFFFFFC00) };
+
+	kill_ack_msk = (((BT_UART_MSG_FRAME3A2DP_MSK |
+			BT_UART_MSG_FRAME3SNIFF_MSK |
+			BT_UART_MSG_FRAME3SCOESCO_MSK) &
+			uart_msg->frame3) == 0) ? 1 : 0;
+	if (priv->kill_ack_mask != bt_kill_ack_msg[kill_ack_msk]) {
+		priv->bt_valid |= IWL6000G2B_BT_VALID_KILL_ACK_MASK;
+		priv->kill_ack_mask = bt_kill_ack_msg[kill_ack_msk];
+		/* schedule to send runtime bt_config */
+		queue_work(priv->workqueue, &priv->bt_runtime_config);
+	}
+
+}
+
 static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 					     struct iwl_rx_mem_buffer *rxb)
 {
@@ -460,16 +546,13 @@ static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
 	struct iwl6000g2b_bt_sco_cmd sco_cmd = { .flags = 0 };
+	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
 
 	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
 	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
 	IWL_DEBUG_NOTIF(priv, "    traffic load: %d\n", coex->bt_traffic_load);
 	IWL_DEBUG_NOTIF(priv, "    CI compliance: %d\n", coex->bt_ci_compliance);
-	IWL_DEBUG_NOTIF(priv, "    UART msg: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x:"
-			      "%.2x:%.2x\n",
-			coex->uart_msg[0], coex->uart_msg[1], coex->uart_msg[2],
-			coex->uart_msg[3], coex->uart_msg[4], coex->uart_msg[5],
-			coex->uart_msg[6], coex->uart_msg[7]);
+	iwlagn_print_uartmsg(priv, uart_msg);
 
 	priv->notif_bt_traffic_load = coex->bt_traffic_load;
 
@@ -481,14 +564,19 @@ static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
 				   &priv->bt_traffic_change_work);
 		}
 
-		/* FIXME: add defines for this check */
-		priv->bt_sco_active = coex->uart_msg[3] & 1;
-		if (priv->bt_sco_active)
-			sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
-		iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
+		if (priv->bt_sco_active !=
+		    (uart_msg->frame3 & BT_UART_MSG_FRAME3SCOESCO_MSK)) {
+			priv->bt_sco_active = uart_msg->frame3 &
+				BT_UART_MSG_FRAME3SCOESCO_MSK;
+			if (priv->bt_sco_active)
+				sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
+			iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
 				       sizeof(sco_cmd), &sco_cmd, NULL);
+		}
 	}
 
+	iwl6000g2b_set_kill_ack_msk(priv, uart_msg);
+
 	/* FIXME: based on notification, adjust the prio_boost */
 
 	spin_lock_irqsave(&priv->lock, flags);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 2dc569b..771ceff 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -464,7 +464,12 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	if (priv->cfg->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
 		/* need to perform this before any calibration */
+		priv->bt_valid = IWL6000G2B_BT_ALL_VALID_MSK;
+		priv->kill_ack_mask = IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT;
+		priv->kill_cts_mask = IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT;
 		priv->cfg->ops->hcmd->send_bt_config(priv);
+		priv->bt_valid = IWL6000G2B_BT_VALID_ENABLE_FLAGS;
+
 		if (bt_coex_active && priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 			iwlagn_send_prio_tbl(priv);
 			iwlagn_send_bt_env(priv, IWL_BT_COEX_ENV_OPEN,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index be13c79..7587508 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -614,6 +614,20 @@ static void iwl_bg_beacon_update(struct work_struct *work)
 	iwl_send_beacon_cmd(priv);
 }
 
+static void iwl_bg_bt_runtime_config(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, bt_runtime_config);
+
+	if (test_bit(STATUS_EXIT_PENDING, &priv->status))
+		return;
+
+	/* dont send host command if rf-kill is on */
+	if (!iwl_is_ready_rf(priv))
+		return;
+	priv->cfg->ops->hcmd->send_bt_config(priv);
+}
+
 static void iwl_bg_bt_full_concurrency(struct work_struct *work)
 {
 	struct iwl_priv *priv =
@@ -3890,6 +3904,7 @@ static void iwl_setup_deferred_work(struct iwl_priv *priv)
 	INIT_WORK(&priv->run_time_calib_work, iwl_bg_run_time_calib_work);
 	INIT_WORK(&priv->tx_flush, iwl_bg_tx_flush);
 	INIT_WORK(&priv->bt_full_concurrency, iwl_bg_bt_full_concurrency);
+	INIT_WORK(&priv->bt_runtime_config, iwl_bg_bt_runtime_config);
 	INIT_DELAYED_WORK(&priv->init_alive_start, iwl_bg_init_alive_start);
 	INIT_DELAYED_WORK(&priv->alive_start, iwl_bg_alive_start);
 
@@ -3933,6 +3948,7 @@ static void iwl_cancel_deferred_work(struct iwl_priv *priv)
 	cancel_work_sync(&priv->run_time_calib_work);
 	cancel_work_sync(&priv->beacon_update);
 	cancel_work_sync(&priv->bt_full_concurrency);
+	cancel_work_sync(&priv->bt_runtime_config);
 	del_timer_sync(&priv->statistics_periodic);
 	del_timer_sync(&priv->ucode_trace);
 	if (priv->cfg->ops->lib->recover_from_tx_stall)
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index e742f99..7369c52 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -4057,7 +4057,7 @@ struct iwl_coex_event_resp {
 
 /*
  * BT Status notification
- * REPLY_BT_COEX_PROFILE_NOTIF = 0xcb
+ * REPLY_BT_COEX_PROFILE_NOTIF = 0xce
  */
 enum iwl_bt_coex_profile_traffic_load {
 	IWL_BT_COEX_TRAFFIC_LOAD_NONE = 	0,
@@ -4070,8 +4070,114 @@ enum iwl_bt_coex_profile_traffic_load {
  */
 };
 
+#define BT_UART_MSG_FRAME1MSGTYPE_POS		(0)
+#define BT_UART_MSG_FRAME1MSGTYPE_MSK		\
+		(0x7 << BT_UART_MSG_FRAME1MSGTYPE_POS)
+#define BT_UART_MSG_FRAME1SSN_POS		(3)
+#define BT_UART_MSG_FRAME1SSN_MSK		\
+		(0x3 << BT_UART_MSG_FRAME1SSN_POS)
+#define BT_UART_MSG_FRAME1UPDATEREQ_POS		(5)
+#define BT_UART_MSG_FRAME1UPDATEREQ_MSK		\
+		(0x1 << BT_UART_MSG_FRAME1UPDATEREQ_POS)
+#define BT_UART_MSG_FRAME1RESERVED_POS		(6)
+#define BT_UART_MSG_FRAME1RESERVED_MSK		\
+		(0x3 << BT_UART_MSG_FRAME1RESERVED_POS)
+
+#define BT_UART_MSG_FRAME2OPENCONNECTIONS_POS	(0)
+#define BT_UART_MSG_FRAME2OPENCONNECTIONS_MSK	\
+		(0x3 << BT_UART_MSG_FRAME2OPENCONNECTIONS_POS)
+#define BT_UART_MSG_FRAME2TRAFFICLOAD_POS	(2)
+#define BT_UART_MSG_FRAME2TRAFFICLOAD_MSK	\
+		(0x3 << BT_UART_MSG_FRAME2TRAFFICLOAD_POS)
+#define BT_UART_MSG_FRAME2CHLSEQN_POS		(4)
+#define BT_UART_MSG_FRAME2CHLSEQN_MSK		\
+		(0x1 << BT_UART_MSG_FRAME2CHLSEQN_POS)
+#define BT_UART_MSG_FRAME2INBAND_POS		(5)
+#define BT_UART_MSG_FRAME2INBAND_MSK		\
+		(0x1 << BT_UART_MSG_FRAME2INBAND_POS)
+#define BT_UART_MSG_FRAME2RESERVED_POS		(6)
+#define BT_UART_MSG_FRAME2RESERVED_MSK		\
+		(0x3 << BT_UART_MSG_FRAME2RESERVED_POS)
+
+#define BT_UART_MSG_FRAME3SCOESCO_POS		(0)
+#define BT_UART_MSG_FRAME3SCOESCO_MSK		\
+		(0x1 << BT_UART_MSG_FRAME3SCOESCO_POS)
+#define BT_UART_MSG_FRAME3SNIFF_POS		(1)
+#define BT_UART_MSG_FRAME3SNIFF_MSK		\
+		(0x1 << BT_UART_MSG_FRAME3SNIFF_POS)
+#define BT_UART_MSG_FRAME3A2DP_POS		(2)
+#define BT_UART_MSG_FRAME3A2DP_MSK		\
+		(0x1 << BT_UART_MSG_FRAME3A2DP_POS)
+#define BT_UART_MSG_FRAME3ACL_POS		(3)
+#define BT_UART_MSG_FRAME3ACL_MSK		\
+		(0x1 << BT_UART_MSG_FRAME3ACL_POS)
+#define BT_UART_MSG_FRAME3MASTER_POS		(4)
+#define BT_UART_MSG_FRAME3MASTER_MSK		\
+		(0x1 << BT_UART_MSG_FRAME3MASTER_POS)
+#define BT_UART_MSG_FRAME3OBEX_POS		(5)
+#define BT_UART_MSG_FRAME3OBEX_MSK		\
+		(0x1 << BT_UART_MSG_FRAME3OBEX_POS)
+#define BT_UART_MSG_FRAME3RESERVED_POS		(6)
+#define BT_UART_MSG_FRAME3RESERVED_MSK		\
+		(0x3 << BT_UART_MSG_FRAME3RESERVED_POS)
+
+#define BT_UART_MSG_FRAME4IDLEDURATION_POS	(0)
+#define BT_UART_MSG_FRAME4IDLEDURATION_MSK	\
+		(0x3F << BT_UART_MSG_FRAME4IDLEDURATION_POS)
+#define BT_UART_MSG_FRAME4RESERVED_POS		(6)
+#define BT_UART_MSG_FRAME4RESERVED_MSK		\
+		(0x3 << BT_UART_MSG_FRAME4RESERVED_POS)
+
+#define BT_UART_MSG_FRAME5TXACTIVITY_POS	(0)
+#define BT_UART_MSG_FRAME5TXACTIVITY_MSK	\
+		(0x3 << BT_UART_MSG_FRAME5TXACTIVITY_POS)
+#define BT_UART_MSG_FRAME5RXACTIVITY_POS	(2)
+#define BT_UART_MSG_FRAME5RXACTIVITY_MSK	\
+		(0x3 << BT_UART_MSG_FRAME5RXACTIVITY_POS)
+#define BT_UART_MSG_FRAME5ESCORETRANSMIT_POS	(4)
+#define BT_UART_MSG_FRAME5ESCORETRANSMIT_MSK	\
+		(0x3 << BT_UART_MSG_FRAME5ESCORETRANSMIT_POS)
+#define BT_UART_MSG_FRAME5RESERVED_POS		(6)
+#define BT_UART_MSG_FRAME5RESERVED_MSK		\
+		(0x3 << BT_UART_MSG_FRAME5RESERVED_POS)
+
+#define BT_UART_MSG_FRAME6SNIFFINTERVAL_POS	(0)
+#define BT_UART_MSG_FRAME6SNIFFINTERVAL_MSK	\
+		(0x1F << BT_UART_MSG_FRAME6SNIFFINTERVAL_POS)
+#define BT_UART_MSG_FRAME6DISCOVERABLE_POS	(5)
+#define BT_UART_MSG_FRAME6DISCOVERABLE_MSK	\
+		(0x1 << BT_UART_MSG_FRAME6DISCOVERABLE_POS)
+#define BT_UART_MSG_FRAME6RESERVED_POS		(6)
+#define BT_UART_MSG_FRAME6RESERVED_MSK		\
+		(0x3 << BT_UART_MSG_FRAME6RESERVED_POS)
+
+#define BT_UART_MSG_FRAME7SNIFFACTIVITY_POS	(0)
+#define BT_UART_MSG_FRAME7SNIFFACTIVITY_MSK	\
+		(0x7 << BT_UART_MSG_FRAME7SNIFFACTIVITY_POS)
+#define BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_POS	(3)
+#define BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_MSK	\
+		(0x3 << BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_POS)
+#define BT_UART_MSG_FRAME7CONNECTABLE_POS	(5)
+#define BT_UART_MSG_FRAME7CONNECTABLE_MSK	\
+		(0x1 << BT_UART_MSG_FRAME7CONNECTABLE_POS)
+#define BT_UART_MSG_FRAME7RESERVED_POS		(6)
+#define BT_UART_MSG_FRAME7RESERVED_MSK		\
+		(0x3 << BT_UART_MSG_FRAME7RESERVED_POS)
+
+
+struct iwl_bt_uart_msg {
+	u8 header;
+	u8 frame1;
+	u8 frame2;
+	u8 frame3;
+	u8 frame4;
+	u8 frame5;
+	u8 frame6;
+	u8 frame7;
+} __attribute__((packed));
+
 struct iwl_bt_coex_profile_notif {
-	u8 uart_msg[8];
+	struct iwl_bt_uart_msg last_bt_uart_msg;
 	u8 bt_status; /* 0 - off, 1 - on */
 	u8 bt_traffic_load; /* 0 .. 3? */
 	u8 bt_ci_compliance; /* 0 - not complied, 1 - complied */
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index bb92a7f..e0d524d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1370,6 +1370,9 @@ struct iwl_priv {
 	bool bt_sco_active;
 	bool bt_full_concurrent;
 	bool bt_ant_couple_ok;
+	__le32 kill_ack_mask;
+	__le32 kill_cts_mask;
+	__le16 bt_valid;
 	u8 bt_ci_compliance;
 	struct work_struct bt_traffic_change_work;
 
@@ -1392,6 +1395,7 @@ struct iwl_priv {
 	struct work_struct start_internal_scan;
 	struct work_struct tx_flush;
 	struct work_struct bt_full_concurrency;
+	struct work_struct bt_runtime_config;
 
 	struct tasklet_struct irq_tasklet;
 
-- 
1.7.0.4

