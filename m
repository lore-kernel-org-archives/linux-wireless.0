Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:15438 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753968Ab0HWOxf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:35 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 23/26] iwlagn: generic bt coex functions
Date: Mon, 23 Aug 2010 07:57:14 -0700
Message-Id: <1282575437-23270-24-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Move bt coex functions to iwl-agn-lib.c, so those functions
can be shared by multiple wifi/bt combo devices

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c      |  391 +-------------------------
 drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c  |    8 +
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |  370 ++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    8 +-
 drivers/net/wireless/iwlwifi/iwl-agn.c       |    6 +-
 drivers/net/wireless/iwlwifi/iwl-agn.h       |    9 +
 drivers/net/wireless/iwlwifi/iwl-commands.h  |   74 +++---
 7 files changed, 441 insertions(+), 425 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 30dc1f3..fc9344b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -122,165 +122,6 @@ static void iwl6000_nic_config(struct iwl_priv *priv)
 		priv->cfg->ops->lib->temp_ops.set_calib_version(priv);
 }
 
-/*
- * Macros to access the lookup table.
- *
- * The lookup table has 7 inputs: bt3_prio, bt3_txrx, bt_rf_act, wifi_req,
- * wifi_prio, wifi_txrx and wifi_sh_ant_req.
- *
- * It has three outputs: WLAN_ACTIVE, WLAN_KILL and ANT_SWITCH
- *
- * The format is that "registers" 8 through 11 contain the WLAN_ACTIVE bits
- * one after another in 32-bit registers, and "registers" 0 through 7 contain
- * the WLAN_KILL and ANT_SWITCH bits interleaved (in that order).
- *
- * These macros encode that format.
- */
-#define LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, wifi_req, wifi_prio, \
-	wifi_txrx, wifi_sh_ant_req) \
-	(bt3_prio | (bt3_txrx << 1) | (bt_rf_act << 2) | (wifi_req << 3) | \
-	(wifi_prio << 4) | (wifi_txrx << 5) | (wifi_sh_ant_req << 6))
-
-#define LUT_PTA_WLAN_ACTIVE_OP(lut, op, val) \
-	lut[8 + ((val) >> 5)] op (cpu_to_le32(BIT((val) & 0x1f)))
-#define LUT_TEST_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	(!!(LUT_PTA_WLAN_ACTIVE_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx,\
-	bt_rf_act, wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
-#define LUT_SET_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_PTA_WLAN_ACTIVE_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, \
-	bt_rf_act, wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-#define LUT_CLEAR_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_PTA_WLAN_ACTIVE_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, \
-	bt_rf_act, wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-
-#define LUT_WLAN_KILL_OP(lut, op, val) \
-	lut[(val) >> 4] op (cpu_to_le32(BIT(((val) << 1) & 0x1e)))
-#define LUT_TEST_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	(!!(LUT_WLAN_KILL_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
-#define LUT_SET_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_WLAN_KILL_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-#define LUT_CLEAR_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_WLAN_KILL_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-
-#define LUT_ANT_SWITCH_OP(lut, op, val) \
-	lut[(val) >> 4] op (cpu_to_le32(BIT((((val) << 1) & 0x1e) + 1)))
-#define LUT_TEST_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	(!!(LUT_ANT_SWITCH_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
-#define LUT_SET_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_ANT_SWITCH_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-#define LUT_CLEAR_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
-	wifi_prio, wifi_txrx, wifi_sh_ant_req) \
-	LUT_ANT_SWITCH_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
-	wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
-
-static const __le32 iwl6000g2b_def_3w_lookup[12] = {
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaeaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xcc00ff28),
-	cpu_to_le32(0x0000aaaa),
-	cpu_to_le32(0xcc00aaaa),
-	cpu_to_le32(0x0000aaaa),
-	cpu_to_le32(0xc0004000),
-	cpu_to_le32(0x00004000),
-	cpu_to_le32(0xf0005000),
-	cpu_to_le32(0xf0004000),
-};
-
-static const __le32 iwl6000g2b_concurrent_lookup[12] = {
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0xaaaaaaaa),
-	cpu_to_le32(0x00000000),
-	cpu_to_le32(0x00000000),
-	cpu_to_le32(0x00000000),
-	cpu_to_le32(0x00000000),
-};
-
-static void iwl6000g2b_send_bt_config(struct iwl_priv *priv)
-{
-	struct iwl6000g2b_bt_cmd bt_cmd = {
-		.max_kill = IWL6000G2B_BT_MAX_KILL_DEFAULT,
-		.bt3_timer_t7_value = IWL6000G2B_BT3_T7_DEFAULT,
-		.bt3_prio_sample_time = IWL6000G2B_BT3_PRIO_SAMPLE_DEFAULT,
-		.bt3_timer_t2_value = IWL6000G2B_BT3_T2_DEFAULT,
-	};
-
-	BUILD_BUG_ON(sizeof(iwl6000g2b_def_3w_lookup) !=
-			sizeof(bt_cmd.bt3_lookup_table));
-
-	bt_cmd.prio_boost = priv->cfg->bt_prio_boost;
-	bt_cmd.kill_ack_mask = priv->kill_ack_mask;
-	bt_cmd.kill_cts_mask = priv->kill_cts_mask;
-	bt_cmd.valid = priv->bt_valid;
-
-	/*
-	 * Configure BT coex mode to "no coexistence" when the
-	 * user disabled BT coexistence, we have no interface
-	 * user disabled BT coexistence, or the interface is in
-	 * IBSS mode (no proper uCode support for coex then).
-	 */
-	if (!bt_coex_active || priv->iw_mode == NL80211_IFTYPE_ADHOC) {
-		bt_cmd.flags = 0;
-	} else {
-		bt_cmd.flags = IWL6000G2B_BT_FLAG_COEX_MODE_3W <<
-					IWL6000G2B_BT_FLAG_COEX_MODE_SHIFT;
-		if (priv->bt_ch_announce)
-			bt_cmd.flags |= IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION;
-		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", bt_cmd.flags);
-	}
-
-	if (priv->bt_full_concurrent)
-		memcpy(bt_cmd.bt3_lookup_table, iwl6000g2b_concurrent_lookup,
-			sizeof(iwl6000g2b_concurrent_lookup));
-	else
-		memcpy(bt_cmd.bt3_lookup_table, iwl6000g2b_def_3w_lookup,
-			sizeof(iwl6000g2b_def_3w_lookup));
-
-	IWL_DEBUG_INFO(priv, "BT coex %s in %s mode\n",
-		       bt_cmd.flags ? "active" : "disabled",
-		       priv->bt_full_concurrent ?
-		       "full concurrency" : "3-wire");
-
-	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG, sizeof(bt_cmd), &bt_cmd))
-		IWL_ERR(priv, "failed to send BT Coex Config\n");
-
-	/*
-	 * When we are doing a restart, need to also reconfigure BT
-	 * SCO to the device. If not doing a restart, bt_sco_active
-	 * will always be false, so there's no need to have an extra
-	 * variable to check for it.
-	 */
-	if (priv->bt_sco_active) {
-		struct iwl6000g2b_bt_sco_cmd sco_cmd = { .flags = 0 };
-
-		if (priv->bt_sco_active)
-			sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
-		if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_SCO,
-				     sizeof(sco_cmd), &sco_cmd))
-			IWL_ERR(priv, "failed to send BT SCO command\n");
-	}
-}
-
 static struct iwl_sensitivity_ranges iwl6000_sensitivity = {
 	.min_nrg_cck = 97,
 	.max_nrg_cck = 0, /* not used, set to 0 */
@@ -422,210 +263,6 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
 
-static void iwl6000g2b_bt_traffic_change_work(struct work_struct *work)
-{
-	struct iwl_priv *priv =
-		container_of(work, struct iwl_priv, bt_traffic_change_work);
-	int smps_request = -1;
-
-	IWL_DEBUG_INFO(priv, "BT traffic load changes: %d\n",
-		       priv->bt_traffic_load);
-
-	switch (priv->bt_traffic_load) {
-	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
-		smps_request = IEEE80211_SMPS_AUTOMATIC;
-		break;
-	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
-		smps_request = IEEE80211_SMPS_DYNAMIC;
-		break;
-	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
-	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
-		smps_request = IEEE80211_SMPS_STATIC;
-		break;
-	default:
-		IWL_ERR(priv, "Invalid BT traffic load: %d\n",
-			priv->bt_traffic_load);
-		break;
-	}
-
-	mutex_lock(&priv->mutex);
-
-	if (priv->cfg->ops->lib->update_chain_flags)
-		priv->cfg->ops->lib->update_chain_flags(priv);
-
-	if (smps_request != -1 &&
-	    priv->vif && priv->vif->type == NL80211_IFTYPE_STATION)
-		ieee80211_request_smps(priv->vif, smps_request);
-
-	mutex_unlock(&priv->mutex);
-}
-
-static void iwlagn_print_uartmsg(struct iwl_priv *priv,
-				struct iwl_bt_uart_msg *uart_msg)
-{
-	IWL_DEBUG_NOTIF(priv, "Message Type = 0x%X, SSN = 0x%X, "
-			"Update Req = 0x%X",
-		(BT_UART_MSG_FRAME1MSGTYPE_MSK & uart_msg->frame1) >>
-			BT_UART_MSG_FRAME1MSGTYPE_POS,
-		(BT_UART_MSG_FRAME1SSN_MSK & uart_msg->frame1) >>
-			BT_UART_MSG_FRAME1SSN_POS,
-		(BT_UART_MSG_FRAME1UPDATEREQ_MSK & uart_msg->frame1) >>
-			BT_UART_MSG_FRAME1UPDATEREQ_POS);
-
-	IWL_DEBUG_NOTIF(priv, "Open connections = 0x%X, Traffic load = 0x%X, "
-			"Chl_SeqN = 0x%X, In band = 0x%X",
-		(BT_UART_MSG_FRAME2OPENCONNECTIONS_MSK & uart_msg->frame2) >>
-			BT_UART_MSG_FRAME2OPENCONNECTIONS_POS,
-		(BT_UART_MSG_FRAME2TRAFFICLOAD_MSK & uart_msg->frame2) >>
-			BT_UART_MSG_FRAME2TRAFFICLOAD_POS,
-		(BT_UART_MSG_FRAME2CHLSEQN_MSK & uart_msg->frame2) >>
-			BT_UART_MSG_FRAME2CHLSEQN_POS,
-		(BT_UART_MSG_FRAME2INBAND_MSK & uart_msg->frame2) >>
-			BT_UART_MSG_FRAME2INBAND_POS);
-
-	IWL_DEBUG_NOTIF(priv, "SCO/eSCO = 0x%X, Sniff = 0x%X, A2DP = 0x%X, "
-			"ACL = 0x%X, Master = 0x%X, OBEX = 0x%X",
-		(BT_UART_MSG_FRAME3SCOESCO_MSK & uart_msg->frame3) >>
-			BT_UART_MSG_FRAME3SCOESCO_POS,
-		(BT_UART_MSG_FRAME3SNIFF_MSK & uart_msg->frame3) >>
-			BT_UART_MSG_FRAME3SNIFF_POS,
-		(BT_UART_MSG_FRAME3A2DP_MSK & uart_msg->frame3) >>
-			BT_UART_MSG_FRAME3A2DP_POS,
-		(BT_UART_MSG_FRAME3ACL_MSK & uart_msg->frame3) >>
-			BT_UART_MSG_FRAME3ACL_POS,
-		(BT_UART_MSG_FRAME3MASTER_MSK & uart_msg->frame3) >>
-			BT_UART_MSG_FRAME3MASTER_POS,
-		(BT_UART_MSG_FRAME3OBEX_MSK & uart_msg->frame3) >>
-			BT_UART_MSG_FRAME3OBEX_POS);
-
-	IWL_DEBUG_NOTIF(priv, "Idle duration = 0x%X",
-		(BT_UART_MSG_FRAME4IDLEDURATION_MSK & uart_msg->frame4) >>
-			BT_UART_MSG_FRAME4IDLEDURATION_POS);
-
-	IWL_DEBUG_NOTIF(priv, "Tx Activity = 0x%X, Rx Activity = 0x%X, "
-			"eSCO Retransmissions = 0x%X",
-		(BT_UART_MSG_FRAME5TXACTIVITY_MSK & uart_msg->frame5) >>
-			BT_UART_MSG_FRAME5TXACTIVITY_POS,
-		(BT_UART_MSG_FRAME5RXACTIVITY_MSK & uart_msg->frame5) >>
-			BT_UART_MSG_FRAME5RXACTIVITY_POS,
-		(BT_UART_MSG_FRAME5ESCORETRANSMIT_MSK & uart_msg->frame5) >>
-			BT_UART_MSG_FRAME5ESCORETRANSMIT_POS);
-
-	IWL_DEBUG_NOTIF(priv, "Sniff Interval = 0x%X, Discoverable = 0x%X",
-		(BT_UART_MSG_FRAME6SNIFFINTERVAL_MSK & uart_msg->frame6) >>
-			BT_UART_MSG_FRAME6SNIFFINTERVAL_POS,
-		(BT_UART_MSG_FRAME6DISCOVERABLE_MSK & uart_msg->frame6) >>
-			BT_UART_MSG_FRAME6DISCOVERABLE_POS);
-
-	IWL_DEBUG_NOTIF(priv, "Sniff Activity = 0x%X, Inquiry/Page SR Mode = "
-			"0x%X, Connectable = 0x%X",
-		(BT_UART_MSG_FRAME7SNIFFACTIVITY_MSK & uart_msg->frame7) >>
-			BT_UART_MSG_FRAME7SNIFFACTIVITY_POS,
-		(BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_MSK & uart_msg->frame7) >>
-			BT_UART_MSG_FRAME7INQUIRYPAGESRMODE_POS,
-		(BT_UART_MSG_FRAME7CONNECTABLE_MSK & uart_msg->frame7) >>
-			BT_UART_MSG_FRAME7CONNECTABLE_POS);
-}
-
-static void iwl6000g2b_set_kill_ack_msk(struct iwl_priv *priv,
-				     struct iwl_bt_uart_msg *uart_msg)
-{
-	u8 kill_ack_msk;
-	__le32 bt_kill_ack_msg[2] = {
-		cpu_to_le32(0xFFFFFFF), cpu_to_le32(0xFFFFFC00) };
-
-	kill_ack_msk = (((BT_UART_MSG_FRAME3A2DP_MSK |
-			BT_UART_MSG_FRAME3SNIFF_MSK |
-			BT_UART_MSG_FRAME3SCOESCO_MSK) &
-			uart_msg->frame3) == 0) ? 1 : 0;
-	if (priv->kill_ack_mask != bt_kill_ack_msg[kill_ack_msk]) {
-		priv->bt_valid |= IWL6000G2B_BT_VALID_KILL_ACK_MASK;
-		priv->kill_ack_mask = bt_kill_ack_msg[kill_ack_msk];
-		/* schedule to send runtime bt_config */
-		queue_work(priv->workqueue, &priv->bt_runtime_config);
-	}
-
-}
-
-static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
-					     struct iwl_rx_mem_buffer *rxb)
-{
-	unsigned long flags;
-	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
-	struct iwl6000g2b_bt_sco_cmd sco_cmd = { .flags = 0 };
-	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
-	u8 last_traffic_load;
-
-	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
-	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
-	IWL_DEBUG_NOTIF(priv, "    traffic load: %d\n", coex->bt_traffic_load);
-	IWL_DEBUG_NOTIF(priv, "    CI compliance: %d\n", coex->bt_ci_compliance);
-	iwlagn_print_uartmsg(priv, uart_msg);
-
-	last_traffic_load = priv->notif_bt_traffic_load;
-	priv->notif_bt_traffic_load = coex->bt_traffic_load;
-	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
-		if (priv->bt_status != coex->bt_status ||
-		    last_traffic_load != coex->bt_traffic_load) {
-			if (coex->bt_status) {
-				/* BT on */
-				if (!priv->bt_ch_announce)
-					priv->bt_traffic_load =
-						IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
-				else
-					priv->bt_traffic_load =
-						coex->bt_traffic_load;
-			} else {
-				/* BT off */
-				priv->bt_traffic_load =
-					IWL_BT_COEX_TRAFFIC_LOAD_NONE;
-			}
-			priv->bt_status = coex->bt_status;
-			queue_work(priv->workqueue,
-				   &priv->bt_traffic_change_work);
-		}
-		if (priv->bt_sco_active !=
-		    (uart_msg->frame3 & BT_UART_MSG_FRAME3SCOESCO_MSK)) {
-			priv->bt_sco_active = uart_msg->frame3 &
-				BT_UART_MSG_FRAME3SCOESCO_MSK;
-			if (priv->bt_sco_active)
-				sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
-			iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
-				       sizeof(sco_cmd), &sco_cmd, NULL);
-		}
-	}
-
-	iwl6000g2b_set_kill_ack_msk(priv, uart_msg);
-
-	/* FIXME: based on notification, adjust the prio_boost */
-
-	spin_lock_irqsave(&priv->lock, flags);
-	priv->bt_ci_compliance = coex->bt_ci_compliance;
-	spin_unlock_irqrestore(&priv->lock, flags);
-}
-
-void iwl6000g2b_rx_handler_setup(struct iwl_priv *priv)
-{
-	iwlagn_rx_handler_setup(priv);
-	priv->rx_handlers[REPLY_BT_COEX_PROFILE_NOTIF] =
-		iwl6000g2b_bt_coex_profile_notif;
-}
-
-static void iwl6000g2b_bt_setup_deferred_work(struct iwl_priv *priv)
-{
-	iwlagn_setup_deferred_work(priv);
-
-	INIT_WORK(&priv->bt_traffic_change_work,
-		  iwl6000g2b_bt_traffic_change_work);
-
-}
-
-static void iwl6000g2b_bt_cancel_deferred_work(struct iwl_priv *priv)
-{
-	cancel_work_sync(&priv->bt_traffic_change_work);
-}
-
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
@@ -710,9 +347,9 @@ static struct iwl_lib_ops iwl6000g2b_lib = {
 	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
 	.txq_free_tfd = iwl_hw_txq_free_tfd,
 	.txq_init = iwl_hw_tx_queue_init,
-	.rx_handler_setup = iwl6000g2b_rx_handler_setup,
-	.setup_deferred_work = iwl6000g2b_bt_setup_deferred_work,
-	.cancel_deferred_work = iwl6000g2b_bt_cancel_deferred_work,
+	.rx_handler_setup = iwlagn_bt_rx_handler_setup,
+	.setup_deferred_work = iwlagn_bt_setup_deferred_work,
+	.cancel_deferred_work = iwlagn_bt_cancel_deferred_work,
 	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
 	.load_ucode = iwlagn_load_ucode,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
@@ -782,17 +419,9 @@ static const struct iwl_ops iwl6000_ops = {
 	.led = &iwlagn_led_ops,
 };
 
-static struct iwl_hcmd_ops iwl6000g2b_hcmd = {
-	.rxon_assoc = iwlagn_send_rxon_assoc,
-	.commit_rxon = iwl_commit_rxon,
-	.set_rxon_chain = iwl_set_rxon_chain,
-	.set_tx_ant = iwlagn_send_tx_ant_config,
-	.send_bt_config = iwl6000g2b_send_bt_config,
-};
-
 static const struct iwl_ops iwl6000g2b_ops = {
 	.lib = &iwl6000g2b_lib,
-	.hcmd = &iwl6000g2b_hcmd,
+	.hcmd = &iwlagn_bt_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
 };
@@ -945,7 +574,7 @@ struct iwl_cfg iwl6000g2b_2agn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
+	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2abg_cfg = {
@@ -986,7 +615,7 @@ struct iwl_cfg iwl6000g2b_2abg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
+	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2bgn_cfg = {
@@ -1029,7 +658,7 @@ struct iwl_cfg iwl6000g2b_2bgn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
+	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_2bg_cfg = {
@@ -1070,7 +699,7 @@ struct iwl_cfg iwl6000g2b_2bg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
+	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_bgn_cfg = {
@@ -1113,7 +742,7 @@ struct iwl_cfg iwl6000g2b_bgn_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
+	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 struct iwl_cfg iwl6000g2b_bg_cfg = {
@@ -1154,7 +783,7 @@ struct iwl_cfg iwl6000g2b_bg_cfg = {
 	.scan_tx_antennas[IEEE80211_BAND_2GHZ] = ANT_A,
 	.advanced_bt_coexist = true,
 	.bt_init_traffic_load = IWL_BT_COEX_TRAFFIC_LOAD_NONE,
-	.bt_prio_boost = IWL6000G2B_BT_PRIO_BOOST_DEFAULT,
+	.bt_prio_boost = IWLAGN_BT_PRIO_BOOST_DEFAULT,
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
index 8493976..84fe06a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-hcmd.c
@@ -277,6 +277,14 @@ struct iwl_hcmd_ops iwlagn_hcmd = {
 	.send_bt_config = iwl_send_bt_config,
 };
 
+struct iwl_hcmd_ops iwlagn_bt_hcmd = {
+	.rxon_assoc = iwlagn_send_rxon_assoc,
+	.commit_rxon = iwl_commit_rxon,
+	.set_rxon_chain = iwl_set_rxon_chain,
+	.set_tx_ant = iwlagn_send_tx_ant_config,
+	.send_bt_config = iwlagn_send_advance_bt_config,
+};
+
 struct iwl_hcmd_utils_ops iwlagn_hcmd_utils = {
 	.get_hcmd_size = iwlagn_get_hcmd_size,
 	.build_addsta_hcmd = iwlagn_build_addsta_hcmd,
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index ea24240..a9e69a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -1542,3 +1542,373 @@ done:
 	ieee80211_wake_queues(priv->hw);
 	mutex_unlock(&priv->mutex);
 }
+
+/*
+ * BT coex
+ */
+/*
+ * Macros to access the lookup table.
+ *
+ * The lookup table has 7 inputs: bt3_prio, bt3_txrx, bt_rf_act, wifi_req,
+* wifi_prio, wifi_txrx and wifi_sh_ant_req.
+ *
+ * It has three outputs: WLAN_ACTIVE, WLAN_KILL and ANT_SWITCH
+ *
+ * The format is that "registers" 8 through 11 contain the WLAN_ACTIVE bits
+ * one after another in 32-bit registers, and "registers" 0 through 7 contain
+ * the WLAN_KILL and ANT_SWITCH bits interleaved (in that order).
+ *
+ * These macros encode that format.
+ */
+#define LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, wifi_req, wifi_prio, \
+		  wifi_txrx, wifi_sh_ant_req) \
+	(bt3_prio | (bt3_txrx << 1) | (bt_rf_act << 2) | (wifi_req << 3) | \
+	(wifi_prio << 4) | (wifi_txrx << 5) | (wifi_sh_ant_req << 6))
+
+#define LUT_PTA_WLAN_ACTIVE_OP(lut, op, val) \
+	lut[8 + ((val) >> 5)] op (cpu_to_le32(BIT((val) & 0x1f)))
+#define LUT_TEST_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+				 wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	(!!(LUT_PTA_WLAN_ACTIVE_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, \
+				   bt_rf_act, wifi_req, wifi_prio, wifi_txrx, \
+				   wifi_sh_ant_req))))
+#define LUT_SET_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+				wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_PTA_WLAN_ACTIVE_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, \
+			       bt_rf_act, wifi_req, wifi_prio, wifi_txrx, \
+			       wifi_sh_ant_req))
+#define LUT_CLEAR_PTA_WLAN_ACTIVE(lut, bt3_prio, bt3_txrx, bt_rf_act, \
+				  wifi_req, wifi_prio, wifi_txrx, \
+				  wifi_sh_ant_req) \
+	LUT_PTA_WLAN_ACTIVE_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, \
+			       bt_rf_act, wifi_req, wifi_prio, wifi_txrx, \
+			       wifi_sh_ant_req))
+
+#define LUT_WLAN_KILL_OP(lut, op, val) \
+	lut[(val) >> 4] op (cpu_to_le32(BIT(((val) << 1) & 0x1e)))
+#define LUT_TEST_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+			   wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	(!!(LUT_WLAN_KILL_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+			     wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))))
+#define LUT_SET_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+			  wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_WLAN_KILL_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+			 wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+#define LUT_CLEAR_WLAN_KILL(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+			    wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_WLAN_KILL_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+			 wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+
+#define LUT_ANT_SWITCH_OP(lut, op, val) \
+	lut[(val) >> 4] op (cpu_to_le32(BIT((((val) << 1) & 0x1e) + 1)))
+#define LUT_TEST_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+			    wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	(!!(LUT_ANT_SWITCH_OP(lut, &, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+			      wifi_req, wifi_prio, wifi_txrx, \
+			      wifi_sh_ant_req))))
+#define LUT_SET_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+			   wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_ANT_SWITCH_OP(lut, |=, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+			  wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+#define LUT_CLEAR_ANT_SWITCH(lut, bt3_prio, bt3_txrx, bt_rf_act, wifi_req, \
+			     wifi_prio, wifi_txrx, wifi_sh_ant_req) \
+	LUT_ANT_SWITCH_OP(lut, &= ~, LUT_VALUE(bt3_prio, bt3_txrx, bt_rf_act, \
+			  wifi_req, wifi_prio, wifi_txrx, wifi_sh_ant_req))
+
+static const __le32 iwlagn_def_3w_lookup[12] = {
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaeaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xcc00ff28),
+	cpu_to_le32(0x0000aaaa),
+	cpu_to_le32(0xcc00aaaa),
+	cpu_to_le32(0x0000aaaa),
+	cpu_to_le32(0xc0004000),
+	cpu_to_le32(0x00004000),
+	cpu_to_le32(0xf0005000),
+	cpu_to_le32(0xf0004000),
+};
+
+static const __le32 iwlagn_concurrent_lookup[12] = {
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0xaaaaaaaa),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0x00000000),
+	cpu_to_le32(0x00000000),
+};
+
+void iwlagn_send_advance_bt_config(struct iwl_priv *priv)
+{
+	struct iwlagn_bt_cmd bt_cmd = {
+		.max_kill = IWLAGN_BT_MAX_KILL_DEFAULT,
+		.bt3_timer_t7_value = IWLAGN_BT3_T7_DEFAULT,
+		.bt3_prio_sample_time = IWLAGN_BT3_PRIO_SAMPLE_DEFAULT,
+		.bt3_timer_t2_value = IWLAGN_BT3_T2_DEFAULT,
+	};
+
+	BUILD_BUG_ON(sizeof(iwlagn_def_3w_lookup) !=
+			sizeof(bt_cmd.bt3_lookup_table));
+
+	bt_cmd.prio_boost = priv->cfg->bt_prio_boost;
+	bt_cmd.kill_ack_mask = priv->kill_ack_mask;
+	bt_cmd.kill_cts_mask = priv->kill_cts_mask;
+	bt_cmd.valid = priv->bt_valid;
+
+	/*
+	 * Configure BT coex mode to "no coexistence" when the
+	 * user disabled BT coexistence, we have no interface
+	 * (might be in monitor mode), or the interface is in
+	 * IBSS mode (no proper uCode support for coex then).
+	 */
+	if (!bt_coex_active || priv->iw_mode == NL80211_IFTYPE_ADHOC) {
+		bt_cmd.flags = 0;
+	} else {
+		bt_cmd.flags = IWLAGN_BT_FLAG_COEX_MODE_3W <<
+					IWLAGN_BT_FLAG_COEX_MODE_SHIFT;
+		if (priv->bt_ch_announce)
+			bt_cmd.flags |= IWLAGN_BT_FLAG_CHANNEL_INHIBITION;
+		IWL_DEBUG_INFO(priv, "BT coex flag: 0X%x\n", bt_cmd.flags);
+	}
+	if (priv->bt_full_concurrent)
+		memcpy(bt_cmd.bt3_lookup_table, iwlagn_concurrent_lookup,
+			sizeof(iwlagn_concurrent_lookup));
+	else
+		memcpy(bt_cmd.bt3_lookup_table, iwlagn_def_3w_lookup,
+			sizeof(iwlagn_def_3w_lookup));
+
+	IWL_DEBUG_INFO(priv, "BT coex %s in %s mode\n",
+		       bt_cmd.flags ? "active" : "disabled",
+		       priv->bt_full_concurrent ?
+		       "full concurrency" : "3-wire");
+
+	if (iwl_send_cmd_pdu(priv, REPLY_BT_CONFIG, sizeof(bt_cmd), &bt_cmd))
+		IWL_ERR(priv, "failed to send BT Coex Config\n");
+
+	/*
+	 * When we are doing a restart, need to also reconfigure BT
+	 * SCO to the device. If not doing a restart, bt_sco_active
+	 * will always be false, so there's no need to have an extra
+	 * variable to check for it.
+	 */
+	if (priv->bt_sco_active) {
+		struct iwlagn_bt_sco_cmd sco_cmd = { .flags = 0 };
+
+		if (priv->bt_sco_active)
+			sco_cmd.flags |= IWLAGN_BT_SCO_ACTIVE;
+		if (iwl_send_cmd_pdu(priv, REPLY_BT_COEX_SCO,
+				     sizeof(sco_cmd), &sco_cmd))
+			IWL_ERR(priv, "failed to send BT SCO command\n");
+	}
+}
+
+static void iwlagn_bt_traffic_change_work(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, bt_traffic_change_work);
+	int smps_request = -1;
+
+	IWL_DEBUG_INFO(priv, "BT traffic load changes: %d\n",
+		       priv->bt_traffic_load);
+
+	switch (priv->bt_traffic_load) {
+	case IWL_BT_COEX_TRAFFIC_LOAD_NONE:
+		smps_request = IEEE80211_SMPS_AUTOMATIC;
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_LOW:
+		smps_request = IEEE80211_SMPS_DYNAMIC;
+		break;
+	case IWL_BT_COEX_TRAFFIC_LOAD_HIGH:
+	case IWL_BT_COEX_TRAFFIC_LOAD_CONTINUOUS:
+		smps_request = IEEE80211_SMPS_STATIC;
+		break;
+	default:
+		IWL_ERR(priv, "Invalid BT traffic load: %d\n",
+			priv->bt_traffic_load);
+		break;
+	}
+
+	mutex_lock(&priv->mutex);
+
+	if (priv->cfg->ops->lib->update_chain_flags)
+		priv->cfg->ops->lib->update_chain_flags(priv);
+
+	if (smps_request != -1 &&
+	    priv->vif && priv->vif->type == NL80211_IFTYPE_STATION)
+		ieee80211_request_smps(priv->vif, smps_request);
+
+	mutex_unlock(&priv->mutex);
+}
+
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
+static void iwlagn_set_kill_ack_msk(struct iwl_priv *priv,
+				     struct iwl_bt_uart_msg *uart_msg)
+{
+	u8 kill_ack_msk;
+	__le32 bt_kill_ack_msg[2] = {
+			cpu_to_le32(0xFFFFFFF), cpu_to_le32(0xFFFFFC00) };
+
+	kill_ack_msk = (((BT_UART_MSG_FRAME3A2DP_MSK |
+			BT_UART_MSG_FRAME3SNIFF_MSK |
+			BT_UART_MSG_FRAME3SCOESCO_MSK) &
+			uart_msg->frame3) == 0) ? 1 : 0;
+	if (priv->kill_ack_mask != bt_kill_ack_msg[kill_ack_msk]) {
+		priv->bt_valid |= IWLAGN_BT_VALID_KILL_ACK_MASK;
+		priv->kill_ack_mask = bt_kill_ack_msg[kill_ack_msk];
+		/* schedule to send runtime bt_config */
+		queue_work(priv->workqueue, &priv->bt_runtime_config);
+	}
+
+}
+
+void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
+					     struct iwl_rx_mem_buffer *rxb)
+{
+	unsigned long flags;
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
+	struct iwlagn_bt_sco_cmd sco_cmd = { .flags = 0 };
+	struct iwl_bt_uart_msg *uart_msg = &coex->last_bt_uart_msg;
+	u8 last_traffic_load;
+
+	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
+	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
+	IWL_DEBUG_NOTIF(priv, "    traffic load: %d\n", coex->bt_traffic_load);
+	IWL_DEBUG_NOTIF(priv, "    CI compliance: %d\n",
+			coex->bt_ci_compliance);
+	iwlagn_print_uartmsg(priv, uart_msg);
+
+	last_traffic_load = priv->notif_bt_traffic_load;
+	priv->notif_bt_traffic_load = coex->bt_traffic_load;
+	if (priv->iw_mode != NL80211_IFTYPE_ADHOC) {
+		if (priv->bt_status != coex->bt_status ||
+		    last_traffic_load != coex->bt_traffic_load) {
+			if (coex->bt_status) {
+				/* BT on */
+				if (!priv->bt_ch_announce)
+					priv->bt_traffic_load =
+						IWL_BT_COEX_TRAFFIC_LOAD_HIGH;
+				else
+					priv->bt_traffic_load =
+						coex->bt_traffic_load;
+			} else {
+				/* BT off */
+				priv->bt_traffic_load =
+					IWL_BT_COEX_TRAFFIC_LOAD_NONE;
+			}
+			priv->bt_status = coex->bt_status;
+			queue_work(priv->workqueue,
+				   &priv->bt_traffic_change_work);
+		}
+		if (priv->bt_sco_active !=
+		    (uart_msg->frame3 & BT_UART_MSG_FRAME3SCOESCO_MSK)) {
+			priv->bt_sco_active = uart_msg->frame3 &
+				BT_UART_MSG_FRAME3SCOESCO_MSK;
+			if (priv->bt_sco_active)
+				sco_cmd.flags |= IWLAGN_BT_SCO_ACTIVE;
+			iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
+				       sizeof(sco_cmd), &sco_cmd, NULL);
+		}
+	}
+
+	iwlagn_set_kill_ack_msk(priv, uart_msg);
+
+	/* FIXME: based on notification, adjust the prio_boost */
+
+	spin_lock_irqsave(&priv->lock, flags);
+	priv->bt_ci_compliance = coex->bt_ci_compliance;
+	spin_unlock_irqrestore(&priv->lock, flags);
+}
+
+void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv)
+{
+	iwlagn_rx_handler_setup(priv);
+	priv->rx_handlers[REPLY_BT_COEX_PROFILE_NOTIF] =
+		iwlagn_bt_coex_profile_notif;
+}
+
+void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv)
+{
+	iwlagn_setup_deferred_work(priv);
+
+	INIT_WORK(&priv->bt_traffic_change_work,
+		  iwlagn_bt_traffic_change_work);
+}
+
+void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv)
+{
+	cancel_work_sync(&priv->bt_traffic_change_work);
+}
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 771ceff..f2499e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -464,11 +464,11 @@ int iwlagn_alive_notify(struct iwl_priv *priv)
 	if (priv->cfg->advanced_bt_coexist) {
 		/* Configure Bluetooth device coexistence support */
 		/* need to perform this before any calibration */
-		priv->bt_valid = IWL6000G2B_BT_ALL_VALID_MSK;
-		priv->kill_ack_mask = IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT;
-		priv->kill_cts_mask = IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT;
+		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
+		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
+		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
 		priv->cfg->ops->hcmd->send_bt_config(priv);
-		priv->bt_valid = IWL6000G2B_BT_VALID_ENABLE_FLAGS;
+		priv->bt_valid = IWLAGN_BT_VALID_ENABLE_FLAGS;
 
 		if (bt_coex_active && priv->iw_mode != NL80211_IFTYPE_ADHOC) {
 			iwlagn_send_prio_tbl(priv);
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index bd006c5..3826f1f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4021,9 +4021,9 @@ static int iwl_init_drv(struct iwl_priv *priv)
 
 	/* init bt coex */
 	if (priv->cfg->advanced_bt_coexist) {
-		priv->kill_ack_mask = IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT;
-		priv->kill_cts_mask = IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT;
-		priv->bt_valid = IWL6000G2B_BT_ALL_VALID_MSK;
+		priv->kill_ack_mask = IWLAGN_BT_KILL_ACK_MASK_DEFAULT;
+		priv->kill_cts_mask = IWLAGN_BT_KILL_CTS_MASK_DEFAULT;
+		priv->bt_valid = IWLAGN_BT_ALL_VALID_MSK;
 		priv->bt_on_thresh = BT_ON_THRESHOLD_DEF;
 		priv->bt_duration = BT_DURATION_LIMIT_DEF;
 		priv->dynamic_frag_thresh = BT_FRAG_THRESHOLD_DEF;
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index cc6464d..1a7f70f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -95,6 +95,7 @@ extern struct iwl_cfg iwl1000_bg_cfg;
 
 extern struct iwl_mod_params iwlagn_mod_params;
 extern struct iwl_hcmd_ops iwlagn_hcmd;
+extern struct iwl_hcmd_ops iwlagn_bt_hcmd;
 extern struct iwl_hcmd_utils_ops iwlagn_hcmd_utils;
 
 int iwl_reset_ict(struct iwl_priv *priv);
@@ -226,4 +227,12 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 int iwlagn_send_rxon_assoc(struct iwl_priv *priv);
 int iwlagn_send_tx_ant_config(struct iwl_priv *priv, u8 valid_tx_ant);
 
+/* bt coex */
+void iwlagn_send_advance_bt_config(struct iwl_priv *priv);
+void iwlagn_bt_coex_profile_notif(struct iwl_priv *priv,
+				  struct iwl_rx_mem_buffer *rxb);
+void iwlagn_bt_rx_handler_setup(struct iwl_priv *priv);
+void iwlagn_bt_setup_deferred_work(struct iwl_priv *priv);
+void iwlagn_bt_cancel_deferred_work(struct iwl_priv *priv);
+
 #endif /* __iwl_agn_h__ */
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 5df22f1..8ed2412 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -2411,52 +2411,52 @@ struct iwl_bt_cmd {
 	__le32 kill_cts_mask;
 } __packed;
 
-#define IWL6000G2B_BT_FLAG_CHANNEL_INHIBITION	BIT(0)
+#define IWLAGN_BT_FLAG_CHANNEL_INHIBITION	BIT(0)
 
-#define IWL6000G2B_BT_FLAG_COEX_MODE_MASK	(BIT(3)|BIT(4)|BIT(5))
-#define IWL6000G2B_BT_FLAG_COEX_MODE_SHIFT	3
-#define IWL6000G2B_BT_FLAG_COEX_MODE_DISABLED	0
-#define IWL6000G2B_BT_FLAG_COEX_MODE_LEGACY_2W	1
-#define IWL6000G2B_BT_FLAG_COEX_MODE_3W		2
-#define IWL6000G2B_BT_FLAG_COEX_MODE_4W		3
+#define IWLAGN_BT_FLAG_COEX_MODE_MASK		(BIT(3)|BIT(4)|BIT(5))
+#define IWLAGN_BT_FLAG_COEX_MODE_SHIFT		3
+#define IWLAGN_BT_FLAG_COEX_MODE_DISABLED	0
+#define IWLAGN_BT_FLAG_COEX_MODE_LEGACY_2W	1
+#define IWLAGN_BT_FLAG_COEX_MODE_3W		2
+#define IWLAGN_BT_FLAG_COEX_MODE_4W		3
 
-#define IWL6000G2B_BT_FLAG_UCODE_DEFAULT	BIT(6)
-#define IWL6000G2B_BT_FLAG_NOCOEX_NOTIF		BIT(7)
+#define IWLAGN_BT_FLAG_UCODE_DEFAULT	BIT(6)
+#define IWLAGN_BT_FLAG_NOCOEX_NOTIF	BIT(7)
 
-#define IWL6000G2B_BT_PRIO_BOOST_MAX		0xFF
-#define IWL6000G2B_BT_PRIO_BOOST_MIN		0x00
-#define IWL6000G2B_BT_PRIO_BOOST_DEFAULT	0xF0
+#define IWLAGN_BT_PRIO_BOOST_MAX	0xFF
+#define IWLAGN_BT_PRIO_BOOST_MIN	0x00
+#define IWLAGN_BT_PRIO_BOOST_DEFAULT	0xF0
 
-#define IWL6000G2B_BT_MAX_KILL_DEFAULT		5
+#define IWLAGN_BT_MAX_KILL_DEFAULT	5
 
-#define IWL6000G2B_BT3_T7_DEFAULT		1
+#define IWLAGN_BT3_T7_DEFAULT		1
 
-#define IWL6000G2B_BT_KILL_ACK_MASK_DEFAULT	cpu_to_le32(0xffffffff)
-#define IWL6000G2B_BT_KILL_CTS_MASK_DEFAULT	cpu_to_le32(0xffffffff)
+#define IWLAGN_BT_KILL_ACK_MASK_DEFAULT	cpu_to_le32(0xffffffff)
+#define IWLAGN_BT_KILL_CTS_MASK_DEFAULT	cpu_to_le32(0xffffffff)
 
-#define IWL6000G2B_BT3_PRIO_SAMPLE_DEFAULT	2
+#define IWLAGN_BT3_PRIO_SAMPLE_DEFAULT	2
 
-#define IWL6000G2B_BT3_T2_DEFAULT		0xc
+#define IWLAGN_BT3_T2_DEFAULT		0xc
 
-#define IWL6000G2B_BT_VALID_ENABLE_FLAGS	cpu_to_le16(BIT(0))
-#define IWL6000G2B_BT_VALID_BOOST		cpu_to_le16(BIT(1))
-#define IWL6000G2B_BT_VALID_MAX_KILL		cpu_to_le16(BIT(2))
-#define IWL6000G2B_BT_VALID_3W_TIMERS		cpu_to_le16(BIT(3))
-#define IWL6000G2B_BT_VALID_KILL_ACK_MASK	cpu_to_le16(BIT(4))
-#define IWL6000G2B_BT_VALID_KILL_CTS_MASK	cpu_to_le16(BIT(5))
-#define IWL6000G2B_BT_VALID_BT4_TIMES		cpu_to_le16(BIT(6))
-#define IWL6000G2B_BT_VALID_3W_LUT		cpu_to_le16(BIT(7))
+#define IWLAGN_BT_VALID_ENABLE_FLAGS	cpu_to_le16(BIT(0))
+#define IWLAGN_BT_VALID_BOOST		cpu_to_le16(BIT(1))
+#define IWLAGN_BT_VALID_MAX_KILL	cpu_to_le16(BIT(2))
+#define IWLAGN_BT_VALID_3W_TIMERS	cpu_to_le16(BIT(3))
+#define IWLAGN_BT_VALID_KILL_ACK_MASK	cpu_to_le16(BIT(4))
+#define IWLAGN_BT_VALID_KILL_CTS_MASK	cpu_to_le16(BIT(5))
+#define IWLAGN_BT_VALID_BT4_TIMES	cpu_to_le16(BIT(6))
+#define IWLAGN_BT_VALID_3W_LUT		cpu_to_le16(BIT(7))
 
-#define IWL6000G2B_BT_ALL_VALID_MSK	(IWL6000G2B_BT_VALID_ENABLE_FLAGS | \
-					IWL6000G2B_BT_VALID_BOOST | \
-					IWL6000G2B_BT_VALID_MAX_KILL | \
-					IWL6000G2B_BT_VALID_3W_TIMERS | \
-					IWL6000G2B_BT_VALID_KILL_ACK_MASK | \
-					IWL6000G2B_BT_VALID_KILL_CTS_MASK | \
-					IWL6000G2B_BT_VALID_BT4_TIMES | \
-					IWL6000G2B_BT_VALID_3W_LUT)
+#define IWLAGN_BT_ALL_VALID_MSK		(IWLAGN_BT_VALID_ENABLE_FLAGS | \
+					IWLAGN_BT_VALID_BOOST | \
+					IWLAGN_BT_VALID_MAX_KILL | \
+					IWLAGN_BT_VALID_3W_TIMERS | \
+					IWLAGN_BT_VALID_KILL_ACK_MASK | \
+					IWLAGN_BT_VALID_KILL_CTS_MASK | \
+					IWLAGN_BT_VALID_BT4_TIMES | \
+					IWLAGN_BT_VALID_3W_LUT)
 
-struct iwl6000g2b_bt_cmd {
+struct iwlagn_bt_cmd {
 	u8 flags;
 	u8 ledtime; /* unused */
 	u8 max_kill;
@@ -2473,9 +2473,9 @@ struct iwl6000g2b_bt_cmd {
 	u8 reserved[3];
 };
 
-#define IWL6000G2B_BT_SCO_ACTIVE	cpu_to_le32(BIT(0))
+#define IWLAGN_BT_SCO_ACTIVE	cpu_to_le32(BIT(0))
 
-struct iwl6000g2b_bt_sco_cmd {
+struct iwlagn_bt_sco_cmd {
 	__le32 flags;
 };
 
-- 
1.7.0.4

