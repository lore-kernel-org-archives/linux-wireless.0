Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24115 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753858Ab0HWOx3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:29 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 06/26] iwlwifi: add BT notification support for bt coex
Date: Mon, 23 Aug 2010 07:56:57 -0700
Message-Id: <1282575437-23270-7-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When advanced bt coex enabled, uCode will send bt status
notification to driver, here add support for it.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c     |  161 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/iwl-commands.h |    7 +
 drivers/net/wireless/iwlwifi/iwl-dev.h      |    4 +
 3 files changed, 171 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index fc2eeb0..f049ebc 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -377,6 +377,90 @@ static int iwl6000_hw_channel_switch(struct iwl_priv *priv,
 	return iwl_send_cmd_sync(priv, &hcmd);
 }
 
+static void iwl6000g2b_bt_traffic_change_work(struct work_struct *work)
+{
+	struct iwl_priv *priv =
+		container_of(work, struct iwl_priv, bt_traffic_change_work);
+	int smps_request = -1;
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
+	if (smps_request != -1 &&
+	    priv->vif && priv->vif->type == NL80211_IFTYPE_STATION)
+		ieee80211_request_smps(priv->vif, smps_request);
+
+	mutex_unlock(&priv->mutex);
+}
+
+static void iwl6000g2b_bt_coex_profile_notif(struct iwl_priv *priv,
+					     struct iwl_rx_mem_buffer *rxb)
+{
+	struct iwl_rx_packet *pkt = rxb_addr(rxb);
+	struct iwl_bt_coex_profile_notif *coex = &pkt->u.bt_coex_profile_notif;
+	struct iwl6000g2b_bt_sco_cmd sco_cmd = { .flags = 0 };
+
+	IWL_DEBUG_NOTIF(priv, "BT Coex notification:\n");
+	IWL_DEBUG_NOTIF(priv, "    status: %d\n", coex->bt_status);
+	IWL_DEBUG_NOTIF(priv, "    traffic load: %d\n", coex->bt_traffic_load);
+	IWL_DEBUG_NOTIF(priv, "    CI compliance: %d\n", coex->bt_ci_compliance);
+	IWL_DEBUG_NOTIF(priv, "    UART msg: %.2x:%.2x:%.2x:%.2x:%.2x:%.2x:"
+			      "%.2x:%.2x\n",
+			coex->uart_msg[0], coex->uart_msg[1], coex->uart_msg[2],
+			coex->uart_msg[3], coex->uart_msg[4], coex->uart_msg[5],
+			coex->uart_msg[6], coex->uart_msg[7]);
+
+	if (coex->bt_traffic_load != priv->bt_traffic_load) {
+		priv->bt_traffic_load = coex->bt_traffic_load;
+
+		queue_work(priv->workqueue, &priv->bt_traffic_change_work);
+	}
+
+	/* FIXME: add defines for this check */
+	priv->bt_sco_active = coex->uart_msg[3] & 1;
+	if (priv->bt_sco_active)
+		sco_cmd.flags |= IWL6000G2B_BT_SCO_ACTIVE;
+	iwl_send_cmd_pdu_async(priv, REPLY_BT_COEX_SCO,
+			       sizeof(sco_cmd), &sco_cmd, NULL);
+}
+
+void iwl6000g2b_rx_handler_setup(struct iwl_priv *priv)
+{
+	iwlagn_rx_handler_setup(priv);
+	priv->rx_handlers[REPLY_BT_COEX_PROFILE_NOTIF] =
+		iwl6000g2b_bt_coex_profile_notif;
+}
+
+static void iwl6000g2b_bt_setup_deferred_work(struct iwl_priv *priv)
+{
+	iwlagn_setup_deferred_work(priv);
+
+	INIT_WORK(&priv->bt_traffic_change_work,
+		  iwl6000g2b_bt_traffic_change_work);
+
+}
+
+static void iwl6000g2b_bt_cancel_deferred_work(struct iwl_priv *priv)
+{
+	cancel_work_sync(&priv->bt_traffic_change_work);
+}
+
 static struct iwl_lib_ops iwl6000_lib = {
 	.set_hw_params = iwl6000_hw_set_hw_params,
 	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
@@ -451,6 +535,81 @@ static struct iwl_lib_ops iwl6000_lib = {
 	}
 };
 
+static struct iwl_lib_ops iwl6000g2b_lib = {
+	.set_hw_params = iwl6000_hw_set_hw_params,
+	.txq_update_byte_cnt_tbl = iwlagn_txq_update_byte_cnt_tbl,
+	.txq_inval_byte_cnt_tbl = iwlagn_txq_inval_byte_cnt_tbl,
+	.txq_set_sched = iwlagn_txq_set_sched,
+	.txq_agg_enable = iwlagn_txq_agg_enable,
+	.txq_agg_disable = iwlagn_txq_agg_disable,
+	.txq_attach_buf_to_tfd = iwl_hw_txq_attach_buf_to_tfd,
+	.txq_free_tfd = iwl_hw_txq_free_tfd,
+	.txq_init = iwl_hw_tx_queue_init,
+	.rx_handler_setup = iwl6000g2b_rx_handler_setup,
+	.setup_deferred_work = iwl6000g2b_bt_setup_deferred_work,
+	.cancel_deferred_work = iwl6000g2b_bt_cancel_deferred_work,
+	.is_valid_rtc_data_addr = iwlagn_hw_valid_rtc_data_addr,
+	.load_ucode = iwlagn_load_ucode,
+	.dump_nic_event_log = iwl_dump_nic_event_log,
+	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.dump_csr = iwl_dump_csr,
+	.dump_fh = iwl_dump_fh,
+	.init_alive_start = iwlagn_init_alive_start,
+	.alive_notify = iwlagn_alive_notify,
+	.send_tx_power = iwlagn_send_tx_power,
+	.update_chain_flags = iwl_update_chain_flags,
+	.set_channel_switch = iwl6000_hw_channel_switch,
+	.apm_ops = {
+		.init = iwl_apm_init,
+		.stop = iwl_apm_stop,
+		.config = iwl6000_nic_config,
+		.set_pwr_src = iwl_set_pwr_src,
+	},
+	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_REG_BAND_1_CHANNELS,
+			EEPROM_REG_BAND_2_CHANNELS,
+			EEPROM_REG_BAND_3_CHANNELS,
+			EEPROM_REG_BAND_4_CHANNELS,
+			EEPROM_REG_BAND_5_CHANNELS,
+			EEPROM_6000_REG_BAND_24_HT40_CHANNELS,
+			EEPROM_REG_BAND_52_HT40_CHANNELS
+		},
+		.verify_signature  = iwlcore_eeprom_verify_signature,
+		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
+		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.calib_version	= iwlagn_eeprom_calib_version,
+		.query_addr = iwlagn_eeprom_query_addr,
+		.update_enhanced_txpower = iwlcore_eeprom_enhanced_txpower,
+	},
+	.post_associate = iwl_post_associate,
+	.isr = iwl_isr_ict,
+	.config_ap = iwl_config_ap,
+	.temp_ops = {
+		.temperature = iwlagn_temperature,
+		.set_ct_kill = iwl6000_set_ct_threshold,
+		.set_calib_version = iwl6000_set_calib_version,
+	 },
+	.manage_ibss_station = iwlagn_manage_ibss_station,
+	.update_bcast_station = iwl_update_bcast_station,
+	.debugfs_ops = {
+		.rx_stats_read = iwl_ucode_rx_stats_read,
+		.tx_stats_read = iwl_ucode_tx_stats_read,
+		.general_stats_read = iwl_ucode_general_stats_read,
+		.bt_stats_read = iwl_ucode_bt_stats_read,
+	},
+	.recover_from_tx_stall = iwl_bg_monitor_recover,
+	.check_plcp_health = iwl_good_plcp_health,
+	.check_ack_health = iwl_good_ack_health,
+	.txfifo_flush = iwlagn_txfifo_flush,
+	.dev_txfifo_flush = iwlagn_dev_txfifo_flush,
+	.tt_ops = {
+		.lower_power_detection = iwl_tt_is_low_power_state,
+		.tt_power_mode = iwl_tt_current_power_mode,
+		.ct_kill_check = iwl_check_for_ct_kill,
+	}
+};
+
 static const struct iwl_ops iwl6000_ops = {
 	.lib = &iwl6000_lib,
 	.hcmd = &iwlagn_hcmd,
@@ -467,7 +626,7 @@ static struct iwl_hcmd_ops iwl6000g2b_hcmd = {
 };
 
 static const struct iwl_ops iwl6000g2b_ops = {
-	.lib = &iwl6000_lib,
+	.lib = &iwl6000g2b_lib,
 	.hcmd = &iwl6000g2b_hcmd,
 	.utils = &iwlagn_hcmd_utils,
 	.led = &iwlagn_led_ops,
diff --git a/drivers/net/wireless/iwlwifi/iwl-commands.h b/drivers/net/wireless/iwlwifi/iwl-commands.h
index 69fc774..67eaeb6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-commands.h
+++ b/drivers/net/wireless/iwlwifi/iwl-commands.h
@@ -178,6 +178,7 @@ enum {
 	REPLY_BT_COEX_PRIO_TABLE = 0xcc,
 	REPLY_BT_COEX_PROT_ENV = 0xcd,
 	REPLY_BT_COEX_PROFILE_NOTIF = 0xce,
+	REPLY_BT_COEX_SCO = 0xcf,
 
 	REPLY_MAX = 0xff
 };
@@ -2456,6 +2457,12 @@ struct iwl6000g2b_bt_cmd {
 	u8 reserved[3];
 };
 
+#define IWL6000G2B_BT_SCO_ACTIVE	cpu_to_le32(BIT(0))
+
+struct iwl6000g2b_bt_sco_cmd {
+	__le32 flags;
+};
+
 /******************************************************************************
  * (6)
  * Spectrum Management (802.11h) Commands, Responses, Notifications:
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 1ad3303..5d327b4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -1362,6 +1362,10 @@ struct iwl_priv {
 #endif
 	};
 
+	u8 bt_traffic_load;
+	bool bt_sco_active;
+	struct work_struct bt_traffic_change_work;
+
 	struct iwl_hw_params hw_params;
 
 	u32 inta_mask;
-- 
1.7.0.4

