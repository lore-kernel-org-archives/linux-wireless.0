Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64219 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091AbcFCPeI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jun 2016 11:34:08 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: remove 10.1 firmware support
Date: Fri, 3 Jun 2016 21:03:28 +0530
Message-ID: <20160603153328.11947-2-rmanohar@qti.qualcomm.com> (sfid-20160603_173414_347460_3CF32706)
In-Reply-To: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
References: <20160603153328.11947-1-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Earlier qca9888 device was brought up using 10.1 firmware and then
later all firmware fixes and new features are migrated to 10.2/10.2.x
firmware branch. As all of 10.1 funtionalities are supported in 10.2
based firmware, removing 10.1 firmware support for qca9888 device.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c     |   4 +-
 drivers/net/wireless/ath/ath10k/mac.c      |   4 +-
 drivers/net/wireless/ath/ath10k/testmode.c |   2 +-
 drivers/net/wireless/ath/ath10k/wmi.c      | 543 +----------------------------
 drivers/net/wireless/ath/ath10k/wmi.h      | 246 -------------
 5 files changed, 8 insertions(+), 791 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index cedf127df168..156e1b8a2470 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1546,7 +1546,6 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 			WMI_STAT_PEER;
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
-	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		if (ath10k_peer_stats_enabled(ar)) {
@@ -1588,6 +1587,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		else
 			ar->htt.max_num_pending_tx = TARGET_10_4_NUM_MSDU_DESC;
 		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
 		WARN_ON(1);
@@ -1602,7 +1602,6 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		case ATH10K_FW_WMI_OP_VERSION_MAIN:
 			fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_MAIN;
 			break;
-		case ATH10K_FW_WMI_OP_VERSION_10_1:
 		case ATH10K_FW_WMI_OP_VERSION_10_2:
 		case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 			fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_10_1;
@@ -1610,6 +1609,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		case ATH10K_FW_WMI_OP_VERSION_TLV:
 			fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_TLV;
 			break;
+		case ATH10K_FW_WMI_OP_VERSION_10_1:
 		case ATH10K_FW_WMI_OP_VERSION_10_4:
 		case ATH10K_FW_WMI_OP_VERSION_UNSET:
 		case ATH10K_FW_WMI_OP_VERSION_MAX:
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 84a3e4902720..23109d1431a2 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5284,7 +5284,7 @@ static void ath10k_bss_info_changed(struct ieee80211_hw *hw,
 		if (info->assoc) {
 			/* Workaround: Make sure monitor vdev is not running
 			 * when associating to prevent some firmware revisions
-			 * (e.g. 10.1 and 10.2) from crashing.
+			 * (e.g. 10.2) from crashing.
 			 */
 			if (ar->monitor_started)
 				ath10k_monitor_stop(ar);
@@ -7852,7 +7852,6 @@ int ath10k_mac_register(struct ath10k *ar)
 		}
 		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 		break;
-	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
@@ -7864,6 +7863,7 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_10_4_if_comb);
 		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
 		WARN_ON(1);
diff --git a/drivers/net/wireless/ath/ath10k/testmode.c b/drivers/net/wireless/ath/ath10k/testmode.c
index 120f4234d3b0..8b8fcfc1705d 100644
--- a/drivers/net/wireless/ath/ath10k/testmode.c
+++ b/drivers/net/wireless/ath/ath10k/testmode.c
@@ -162,7 +162,7 @@ static int ath10k_tm_fetch_utf_firmware_api_1(struct ath10k *ar,
 	 * correct WMI interface.
 	 */
 
-	fw_file->wmi_op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
+	fw_file->wmi_op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
 	fw_file->htt_op_version = ATH10K_FW_HTT_OP_VERSION_10_1;
 	fw_file->firmware_data = fw_file->firmware->data;
 	fw_file->firmware_len = fw_file->firmware->size;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index b7fb0d76c433..70be2d40870d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -193,172 +193,6 @@ static struct wmi_cmd_map wmi_cmd_map = {
 	.pdev_bss_chan_info_request_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
-/* 10.X WMI cmd track */
-static struct wmi_cmd_map wmi_10x_cmd_map = {
-	.init_cmdid = WMI_10X_INIT_CMDID,
-	.start_scan_cmdid = WMI_10X_START_SCAN_CMDID,
-	.stop_scan_cmdid = WMI_10X_STOP_SCAN_CMDID,
-	.scan_chan_list_cmdid = WMI_10X_SCAN_CHAN_LIST_CMDID,
-	.scan_sch_prio_tbl_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_set_regdomain_cmdid = WMI_10X_PDEV_SET_REGDOMAIN_CMDID,
-	.pdev_set_channel_cmdid = WMI_10X_PDEV_SET_CHANNEL_CMDID,
-	.pdev_set_param_cmdid = WMI_10X_PDEV_SET_PARAM_CMDID,
-	.pdev_pktlog_enable_cmdid = WMI_10X_PDEV_PKTLOG_ENABLE_CMDID,
-	.pdev_pktlog_disable_cmdid = WMI_10X_PDEV_PKTLOG_DISABLE_CMDID,
-	.pdev_set_wmm_params_cmdid = WMI_10X_PDEV_SET_WMM_PARAMS_CMDID,
-	.pdev_set_ht_cap_ie_cmdid = WMI_10X_PDEV_SET_HT_CAP_IE_CMDID,
-	.pdev_set_vht_cap_ie_cmdid = WMI_10X_PDEV_SET_VHT_CAP_IE_CMDID,
-	.pdev_set_dscp_tid_map_cmdid = WMI_10X_PDEV_SET_DSCP_TID_MAP_CMDID,
-	.pdev_set_quiet_mode_cmdid = WMI_10X_PDEV_SET_QUIET_MODE_CMDID,
-	.pdev_green_ap_ps_enable_cmdid = WMI_10X_PDEV_GREEN_AP_PS_ENABLE_CMDID,
-	.pdev_get_tpc_config_cmdid = WMI_10X_PDEV_GET_TPC_CONFIG_CMDID,
-	.pdev_set_base_macaddr_cmdid = WMI_10X_PDEV_SET_BASE_MACADDR_CMDID,
-	.vdev_create_cmdid = WMI_10X_VDEV_CREATE_CMDID,
-	.vdev_delete_cmdid = WMI_10X_VDEV_DELETE_CMDID,
-	.vdev_start_request_cmdid = WMI_10X_VDEV_START_REQUEST_CMDID,
-	.vdev_restart_request_cmdid = WMI_10X_VDEV_RESTART_REQUEST_CMDID,
-	.vdev_up_cmdid = WMI_10X_VDEV_UP_CMDID,
-	.vdev_stop_cmdid = WMI_10X_VDEV_STOP_CMDID,
-	.vdev_down_cmdid = WMI_10X_VDEV_DOWN_CMDID,
-	.vdev_set_param_cmdid = WMI_10X_VDEV_SET_PARAM_CMDID,
-	.vdev_install_key_cmdid = WMI_10X_VDEV_INSTALL_KEY_CMDID,
-	.peer_create_cmdid = WMI_10X_PEER_CREATE_CMDID,
-	.peer_delete_cmdid = WMI_10X_PEER_DELETE_CMDID,
-	.peer_flush_tids_cmdid = WMI_10X_PEER_FLUSH_TIDS_CMDID,
-	.peer_set_param_cmdid = WMI_10X_PEER_SET_PARAM_CMDID,
-	.peer_assoc_cmdid = WMI_10X_PEER_ASSOC_CMDID,
-	.peer_add_wds_entry_cmdid = WMI_10X_PEER_ADD_WDS_ENTRY_CMDID,
-	.peer_remove_wds_entry_cmdid = WMI_10X_PEER_REMOVE_WDS_ENTRY_CMDID,
-	.peer_mcast_group_cmdid = WMI_10X_PEER_MCAST_GROUP_CMDID,
-	.bcn_tx_cmdid = WMI_10X_BCN_TX_CMDID,
-	.pdev_send_bcn_cmdid = WMI_10X_PDEV_SEND_BCN_CMDID,
-	.bcn_tmpl_cmdid = WMI_CMD_UNSUPPORTED,
-	.bcn_filter_rx_cmdid = WMI_10X_BCN_FILTER_RX_CMDID,
-	.prb_req_filter_rx_cmdid = WMI_10X_PRB_REQ_FILTER_RX_CMDID,
-	.mgmt_tx_cmdid = WMI_10X_MGMT_TX_CMDID,
-	.prb_tmpl_cmdid = WMI_CMD_UNSUPPORTED,
-	.addba_clear_resp_cmdid = WMI_10X_ADDBA_CLEAR_RESP_CMDID,
-	.addba_send_cmdid = WMI_10X_ADDBA_SEND_CMDID,
-	.addba_status_cmdid = WMI_10X_ADDBA_STATUS_CMDID,
-	.delba_send_cmdid = WMI_10X_DELBA_SEND_CMDID,
-	.addba_set_resp_cmdid = WMI_10X_ADDBA_SET_RESP_CMDID,
-	.send_singleamsdu_cmdid = WMI_10X_SEND_SINGLEAMSDU_CMDID,
-	.sta_powersave_mode_cmdid = WMI_10X_STA_POWERSAVE_MODE_CMDID,
-	.sta_powersave_param_cmdid = WMI_10X_STA_POWERSAVE_PARAM_CMDID,
-	.sta_mimo_ps_mode_cmdid = WMI_10X_STA_MIMO_PS_MODE_CMDID,
-	.pdev_dfs_enable_cmdid = WMI_10X_PDEV_DFS_ENABLE_CMDID,
-	.pdev_dfs_disable_cmdid = WMI_10X_PDEV_DFS_DISABLE_CMDID,
-	.roam_scan_mode = WMI_10X_ROAM_SCAN_MODE,
-	.roam_scan_rssi_threshold = WMI_10X_ROAM_SCAN_RSSI_THRESHOLD,
-	.roam_scan_period = WMI_10X_ROAM_SCAN_PERIOD,
-	.roam_scan_rssi_change_threshold =
-				WMI_10X_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
-	.roam_ap_profile = WMI_10X_ROAM_AP_PROFILE,
-	.ofl_scan_add_ap_profile = WMI_10X_OFL_SCAN_ADD_AP_PROFILE,
-	.ofl_scan_remove_ap_profile = WMI_10X_OFL_SCAN_REMOVE_AP_PROFILE,
-	.ofl_scan_period = WMI_10X_OFL_SCAN_PERIOD,
-	.p2p_dev_set_device_info = WMI_10X_P2P_DEV_SET_DEVICE_INFO,
-	.p2p_dev_set_discoverability = WMI_10X_P2P_DEV_SET_DISCOVERABILITY,
-	.p2p_go_set_beacon_ie = WMI_10X_P2P_GO_SET_BEACON_IE,
-	.p2p_go_set_probe_resp_ie = WMI_10X_P2P_GO_SET_PROBE_RESP_IE,
-	.p2p_set_vendor_ie_data_cmdid = WMI_CMD_UNSUPPORTED,
-	.ap_ps_peer_param_cmdid = WMI_10X_AP_PS_PEER_PARAM_CMDID,
-	.ap_ps_peer_uapsd_coex_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_rate_retry_sched_cmdid = WMI_10X_PEER_RATE_RETRY_SCHED_CMDID,
-	.wlan_profile_trigger_cmdid = WMI_10X_WLAN_PROFILE_TRIGGER_CMDID,
-	.wlan_profile_set_hist_intvl_cmdid =
-				WMI_10X_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
-	.wlan_profile_get_profile_data_cmdid =
-				WMI_10X_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
-	.wlan_profile_enable_profile_id_cmdid =
-				WMI_10X_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
-	.wlan_profile_list_profile_id_cmdid =
-				WMI_10X_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
-	.pdev_suspend_cmdid = WMI_10X_PDEV_SUSPEND_CMDID,
-	.pdev_resume_cmdid = WMI_10X_PDEV_RESUME_CMDID,
-	.add_bcn_filter_cmdid = WMI_10X_ADD_BCN_FILTER_CMDID,
-	.rmv_bcn_filter_cmdid = WMI_10X_RMV_BCN_FILTER_CMDID,
-	.wow_add_wake_pattern_cmdid = WMI_10X_WOW_ADD_WAKE_PATTERN_CMDID,
-	.wow_del_wake_pattern_cmdid = WMI_10X_WOW_DEL_WAKE_PATTERN_CMDID,
-	.wow_enable_disable_wake_event_cmdid =
-				WMI_10X_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
-	.wow_enable_cmdid = WMI_10X_WOW_ENABLE_CMDID,
-	.wow_hostwakeup_from_sleep_cmdid =
-				WMI_10X_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
-	.rtt_measreq_cmdid = WMI_10X_RTT_MEASREQ_CMDID,
-	.rtt_tsf_cmdid = WMI_10X_RTT_TSF_CMDID,
-	.vdev_spectral_scan_configure_cmdid =
-				WMI_10X_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
-	.vdev_spectral_scan_enable_cmdid =
-				WMI_10X_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
-	.request_stats_cmdid = WMI_10X_REQUEST_STATS_CMDID,
-	.set_arp_ns_offload_cmdid = WMI_CMD_UNSUPPORTED,
-	.network_list_offload_config_cmdid = WMI_CMD_UNSUPPORTED,
-	.gtk_offload_cmdid = WMI_CMD_UNSUPPORTED,
-	.csa_offload_enable_cmdid = WMI_CMD_UNSUPPORTED,
-	.csa_offload_chanswitch_cmdid = WMI_CMD_UNSUPPORTED,
-	.chatter_set_mode_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_tid_addba_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_tid_delba_cmdid = WMI_CMD_UNSUPPORTED,
-	.sta_dtim_ps_method_cmdid = WMI_CMD_UNSUPPORTED,
-	.sta_uapsd_auto_trig_cmdid = WMI_CMD_UNSUPPORTED,
-	.sta_keepalive_cmd = WMI_CMD_UNSUPPORTED,
-	.echo_cmdid = WMI_10X_ECHO_CMDID,
-	.pdev_utf_cmdid = WMI_10X_PDEV_UTF_CMDID,
-	.dbglog_cfg_cmdid = WMI_10X_DBGLOG_CFG_CMDID,
-	.pdev_qvit_cmdid = WMI_10X_PDEV_QVIT_CMDID,
-	.pdev_ftm_intg_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_set_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_get_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
-	.force_fw_hang_cmdid = WMI_CMD_UNSUPPORTED,
-	.gpio_config_cmdid = WMI_10X_GPIO_CONFIG_CMDID,
-	.gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
-	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_enable_adaptive_cca_cmdid = WMI_CMD_UNSUPPORTED,
-	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
-	.wlan_peer_caching_add_peer_cmdid = WMI_CMD_UNSUPPORTED,
-	.wlan_peer_caching_evict_peer_cmdid = WMI_CMD_UNSUPPORTED,
-	.wlan_peer_caching_restore_peer_cmdid = WMI_CMD_UNSUPPORTED,
-	.wlan_peer_caching_print_all_peers_info_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_update_wds_entry_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_add_proxy_sta_entry_cmdid = WMI_CMD_UNSUPPORTED,
-	.rtt_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
-	.oem_req_cmdid = WMI_CMD_UNSUPPORTED,
-	.nan_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_ratemask_cmdid = WMI_CMD_UNSUPPORTED,
-	.qboost_cfg_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_smart_ant_enable_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_smart_ant_set_rx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_smart_ant_set_tx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_smart_ant_set_train_info_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_smart_ant_set_node_config_ops_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_set_antenna_switch_table_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_set_ctl_table_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_set_mimogain_table_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_ratepwr_table_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_ratepwr_chainmsk_table_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_fips_cmdid = WMI_CMD_UNSUPPORTED,
-	.tt_set_conf_cmdid = WMI_CMD_UNSUPPORTED,
-	.fwtest_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
-	.peer_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_get_ani_cck_config_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_get_ani_ofdm_config_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_reserve_ast_entry_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_get_nfcal_power_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_get_tpc_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_get_ast_info_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_set_dscp_tid_map_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
-	.vdev_filter_neighbor_rx_packets_cmdid = WMI_CMD_UNSUPPORTED,
-	.mu_cal_start_cmdid = WMI_CMD_UNSUPPORTED,
-	.set_cca_params_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_bss_chan_info_request_cmdid = WMI_CMD_UNSUPPORTED,
-};
-
 /* 10.2.4 WMI cmd track */
 static struct wmi_cmd_map wmi_10_2_4_cmd_map = {
 	.init_cmdid = WMI_10_2_INIT_CMDID,
@@ -1575,23 +1409,6 @@ static const struct wmi_peer_flags_map wmi_peer_flags_map = {
 	.pmf = WMI_PEER_PMF,
 };
 
-static const struct wmi_peer_flags_map wmi_10x_peer_flags_map = {
-	.auth = WMI_10X_PEER_AUTH,
-	.qos = WMI_10X_PEER_QOS,
-	.need_ptk_4_way = WMI_10X_PEER_NEED_PTK_4_WAY,
-	.need_gtk_2_way = WMI_10X_PEER_NEED_GTK_2_WAY,
-	.apsd = WMI_10X_PEER_APSD,
-	.ht = WMI_10X_PEER_HT,
-	.bw40 = WMI_10X_PEER_40MHZ,
-	.stbc = WMI_10X_PEER_STBC,
-	.ldbc = WMI_10X_PEER_LDPC,
-	.dyn_mimops = WMI_10X_PEER_DYN_MIMOPS,
-	.static_mimops = WMI_10X_PEER_STATIC_MIMOPS,
-	.spatial_mux = WMI_10X_PEER_SPATIAL_MUX,
-	.vht = WMI_10X_PEER_VHT,
-	.bw80 = WMI_10X_PEER_80MHZ,
-};
-
 static const struct wmi_peer_flags_map wmi_10_2_peer_flags_map = {
 	.auth = WMI_10_2_PEER_AUTH,
 	.qos = WMI_10_2_PEER_QOS,
@@ -2689,65 +2506,6 @@ static int ath10k_wmi_main_op_pull_fw_stats(struct ath10k *ar,
 	return 0;
 }
 
-static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
-					   struct sk_buff *skb,
-					   struct ath10k_fw_stats *stats)
-{
-	const struct wmi_stats_event *ev = (void *)skb->data;
-	u32 num_pdev_stats, num_vdev_stats, num_peer_stats;
-	int i;
-
-	if (!skb_pull(skb, sizeof(*ev)))
-		return -EPROTO;
-
-	num_pdev_stats = __le32_to_cpu(ev->num_pdev_stats);
-	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
-	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
-
-	for (i = 0; i < num_pdev_stats; i++) {
-		const struct wmi_10x_pdev_stats *src;
-		struct ath10k_fw_stats_pdev *dst;
-
-		src = (void *)skb->data;
-		if (!skb_pull(skb, sizeof(*src)))
-			return -EPROTO;
-
-		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
-		if (!dst)
-			continue;
-
-		ath10k_wmi_pull_pdev_stats_base(&src->base, dst);
-		ath10k_wmi_pull_pdev_stats_tx(&src->tx, dst);
-		ath10k_wmi_pull_pdev_stats_rx(&src->rx, dst);
-		ath10k_wmi_pull_pdev_stats_extra(&src->extra, dst);
-
-		list_add_tail(&dst->list, &stats->pdevs);
-	}
-
-	/* fw doesn't implement vdev stats */
-
-	for (i = 0; i < num_peer_stats; i++) {
-		const struct wmi_10x_peer_stats *src;
-		struct ath10k_fw_stats_peer *dst;
-
-		src = (void *)skb->data;
-		if (!skb_pull(skb, sizeof(*src)))
-			return -EPROTO;
-
-		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
-		if (!dst)
-			continue;
-
-		ath10k_wmi_pull_peer_stats(&src->old, dst);
-
-		dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
-
-		list_add_tail(&dst->list, &stats->peers);
-	}
-
-	return 0;
-}
-
 static int ath10k_wmi_10_2_op_pull_fw_stats(struct ath10k *ar,
 					    struct sk_buff *skb,
 					    struct ath10k_fw_stats *stats)
@@ -4967,130 +4725,6 @@ out:
 	dev_kfree_skb(skb);
 }
 
-static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
-{
-	struct wmi_cmd_hdr *cmd_hdr;
-	enum wmi_10x_event_id id;
-	bool consumed;
-
-	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
-	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
-
-	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
-		goto out;
-
-	trace_ath10k_wmi_event(ar, id, skb->data, skb->len);
-
-	consumed = ath10k_tm_event_wmi(ar, id, skb);
-
-	/* Ready event must be handled normally also in UTF mode so that we
-	 * know the UTF firmware has booted, others we are just bypass WMI
-	 * events to testmode.
-	 */
-	if (consumed && id != WMI_10X_READY_EVENTID) {
-		ath10k_dbg(ar, ATH10K_DBG_WMI,
-			   "wmi testmode consumed 0x%x\n", id);
-		goto out;
-	}
-
-	switch (id) {
-	case WMI_10X_MGMT_RX_EVENTID:
-		ath10k_wmi_event_mgmt_rx(ar, skb);
-		/* mgmt_rx() owns the skb now! */
-		return;
-	case WMI_10X_SCAN_EVENTID:
-		ath10k_wmi_event_scan(ar, skb);
-		break;
-	case WMI_10X_CHAN_INFO_EVENTID:
-		ath10k_wmi_event_chan_info(ar, skb);
-		break;
-	case WMI_10X_ECHO_EVENTID:
-		ath10k_wmi_event_echo(ar, skb);
-		break;
-	case WMI_10X_DEBUG_MESG_EVENTID:
-		ath10k_wmi_event_debug_mesg(ar, skb);
-		break;
-	case WMI_10X_UPDATE_STATS_EVENTID:
-		ath10k_wmi_event_update_stats(ar, skb);
-		break;
-	case WMI_10X_VDEV_START_RESP_EVENTID:
-		ath10k_wmi_event_vdev_start_resp(ar, skb);
-		break;
-	case WMI_10X_VDEV_STOPPED_EVENTID:
-		ath10k_wmi_event_vdev_stopped(ar, skb);
-		break;
-	case WMI_10X_PEER_STA_KICKOUT_EVENTID:
-		ath10k_wmi_event_peer_sta_kickout(ar, skb);
-		break;
-	case WMI_10X_HOST_SWBA_EVENTID:
-		ath10k_wmi_event_host_swba(ar, skb);
-		break;
-	case WMI_10X_TBTTOFFSET_UPDATE_EVENTID:
-		ath10k_wmi_event_tbttoffset_update(ar, skb);
-		break;
-	case WMI_10X_PHYERR_EVENTID:
-		ath10k_wmi_event_phyerr(ar, skb);
-		break;
-	case WMI_10X_ROAM_EVENTID:
-		ath10k_wmi_event_roam(ar, skb);
-		break;
-	case WMI_10X_PROFILE_MATCH:
-		ath10k_wmi_event_profile_match(ar, skb);
-		break;
-	case WMI_10X_DEBUG_PRINT_EVENTID:
-		ath10k_wmi_event_debug_print(ar, skb);
-		break;
-	case WMI_10X_PDEV_QVIT_EVENTID:
-		ath10k_wmi_event_pdev_qvit(ar, skb);
-		break;
-	case WMI_10X_WLAN_PROFILE_DATA_EVENTID:
-		ath10k_wmi_event_wlan_profile_data(ar, skb);
-		break;
-	case WMI_10X_RTT_MEASUREMENT_REPORT_EVENTID:
-		ath10k_wmi_event_rtt_measurement_report(ar, skb);
-		break;
-	case WMI_10X_TSF_MEASUREMENT_REPORT_EVENTID:
-		ath10k_wmi_event_tsf_measurement_report(ar, skb);
-		break;
-	case WMI_10X_RTT_ERROR_REPORT_EVENTID:
-		ath10k_wmi_event_rtt_error_report(ar, skb);
-		break;
-	case WMI_10X_WOW_WAKEUP_HOST_EVENTID:
-		ath10k_wmi_event_wow_wakeup_host(ar, skb);
-		break;
-	case WMI_10X_DCS_INTERFERENCE_EVENTID:
-		ath10k_wmi_event_dcs_interference(ar, skb);
-		break;
-	case WMI_10X_PDEV_TPC_CONFIG_EVENTID:
-		ath10k_wmi_event_pdev_tpc_config(ar, skb);
-		break;
-	case WMI_10X_INST_RSSI_STATS_EVENTID:
-		ath10k_wmi_event_inst_rssi_stats(ar, skb);
-		break;
-	case WMI_10X_VDEV_STANDBY_REQ_EVENTID:
-		ath10k_wmi_event_vdev_standby_req(ar, skb);
-		break;
-	case WMI_10X_VDEV_RESUME_REQ_EVENTID:
-		ath10k_wmi_event_vdev_resume_req(ar, skb);
-		break;
-	case WMI_10X_SERVICE_READY_EVENTID:
-		ath10k_wmi_event_service_ready(ar, skb);
-		return;
-	case WMI_10X_READY_EVENTID:
-		ath10k_wmi_event_ready(ar, skb);
-		break;
-	case WMI_10X_PDEV_UTF_EVENTID:
-		/* ignore utf events */
-		break;
-	default:
-		ath10k_warn(ar, "Unknown eventid: %d\n", id);
-		break;
-	}
-
-out:
-	dev_kfree_skb(skb);
-}
-
 static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
@@ -5543,71 +5177,6 @@ static struct sk_buff *ath10k_wmi_op_gen_init(struct ath10k *ar)
 	return buf;
 }
 
-static struct sk_buff *ath10k_wmi_10_1_op_gen_init(struct ath10k *ar)
-{
-	struct wmi_init_cmd_10x *cmd;
-	struct sk_buff *buf;
-	struct wmi_resource_config_10x config = {};
-	u32 len, val;
-
-	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
-	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
-	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
-	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
-	config.ast_skid_limit = __cpu_to_le32(TARGET_10X_AST_SKID_LIMIT);
-	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
-	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
-	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
-	config.rx_timeout_pri_vi = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
-	config.rx_timeout_pri_be = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
-	config.rx_timeout_pri_bk = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_HI_PRI);
-	config.rx_decap_mode = __cpu_to_le32(ar->wmi.rx_decap_mode);
-	config.scan_max_pending_reqs =
-		__cpu_to_le32(TARGET_10X_SCAN_MAX_PENDING_REQS);
-
-	config.bmiss_offload_max_vdev =
-		__cpu_to_le32(TARGET_10X_BMISS_OFFLOAD_MAX_VDEV);
-
-	config.roam_offload_max_vdev =
-		__cpu_to_le32(TARGET_10X_ROAM_OFFLOAD_MAX_VDEV);
-
-	config.roam_offload_max_ap_profiles =
-		__cpu_to_le32(TARGET_10X_ROAM_OFFLOAD_MAX_AP_PROFILES);
-
-	config.num_mcast_groups = __cpu_to_le32(TARGET_10X_NUM_MCAST_GROUPS);
-	config.num_mcast_table_elems =
-		__cpu_to_le32(TARGET_10X_NUM_MCAST_TABLE_ELEMS);
-
-	config.mcast2ucast_mode = __cpu_to_le32(TARGET_10X_MCAST2UCAST_MODE);
-	config.tx_dbg_log_size = __cpu_to_le32(TARGET_10X_TX_DBG_LOG_SIZE);
-	config.num_wds_entries = __cpu_to_le32(TARGET_10X_NUM_WDS_ENTRIES);
-	config.dma_burst_size = __cpu_to_le32(TARGET_10X_DMA_BURST_SIZE);
-	config.mac_aggr_delim = __cpu_to_le32(TARGET_10X_MAC_AGGR_DELIM);
-
-	val = TARGET_10X_RX_SKIP_DEFRAG_TIMEOUT_DUP_DETECTION_CHECK;
-	config.rx_skip_defrag_timeout_dup_detection_check = __cpu_to_le32(val);
-
-	config.vow_config = __cpu_to_le32(TARGET_10X_VOW_CONFIG);
-
-	config.num_msdu_desc = __cpu_to_le32(TARGET_10X_NUM_MSDU_DESC);
-	config.max_frag_entries = __cpu_to_le32(TARGET_10X_MAX_FRAG_ENTRIES);
-
-	len = sizeof(*cmd) +
-	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
-
-	buf = ath10k_wmi_alloc_skb(ar, len);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
-
-	cmd = (struct wmi_init_cmd_10x *)buf->data;
-
-	memcpy(&cmd->resource_config, &config, sizeof(config));
-	ath10k_wmi_put_host_mem_chunks(ar, &cmd->mem_chunks);
-
-	ath10k_dbg(ar, ATH10K_DBG_WMI, "wmi init 10x\n");
-	return buf;
-}
-
 static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 {
 	struct wmi_init_cmd_10_2 *cmd;
@@ -6555,13 +6124,6 @@ ath10k_wmi_peer_assoc_fill_main(struct ath10k *ar, void *buf,
 }
 
 static void
-ath10k_wmi_peer_assoc_fill_10_1(struct ath10k *ar, void *buf,
-				const struct wmi_peer_assoc_complete_arg *arg)
-{
-	ath10k_wmi_peer_assoc_fill(ar, buf, arg);
-}
-
-static void
 ath10k_wmi_peer_assoc_fill_10_2(struct ath10k *ar, void *buf,
 				const struct wmi_peer_assoc_complete_arg *arg)
 {
@@ -6629,31 +6191,6 @@ ath10k_wmi_op_gen_peer_assoc(struct ath10k *ar,
 }
 
 static struct sk_buff *
-ath10k_wmi_10_1_op_gen_peer_assoc(struct ath10k *ar,
-				  const struct wmi_peer_assoc_complete_arg *arg)
-{
-	size_t len = sizeof(struct wmi_10_1_peer_assoc_complete_cmd);
-	struct sk_buff *skb;
-	int ret;
-
-	ret = ath10k_wmi_peer_assoc_check_arg(arg);
-	if (ret)
-		return ERR_PTR(ret);
-
-	skb = ath10k_wmi_alloc_skb(ar, len);
-	if (!skb)
-		return ERR_PTR(-ENOMEM);
-
-	ath10k_wmi_peer_assoc_fill_10_1(ar, skb->data, arg);
-
-	ath10k_dbg(ar, ATH10K_DBG_WMI,
-		   "wmi peer assoc vdev %d addr %pM (%s)\n",
-		   arg->vdev_id, arg->addr,
-		   arg->peer_reassoc ? "reassociate" : "new");
-	return skb;
-}
-
-static struct sk_buff *
 ath10k_wmi_10_2_op_gen_peer_assoc(struct ath10k *ar,
 				  const struct wmi_peer_assoc_complete_arg *arg)
 {
@@ -7696,74 +7233,6 @@ static const struct wmi_ops wmi_ops = {
 	/* .gen_pdev_enable_adaptive_cca not implemented */
 };
 
-static const struct wmi_ops wmi_10_1_ops = {
-	.rx = ath10k_wmi_10_1_op_rx,
-	.map_svc = wmi_10x_svc_map,
-	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
-	.pull_fw_stats = ath10k_wmi_10x_op_pull_fw_stats,
-	.gen_init = ath10k_wmi_10_1_op_gen_init,
-	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
-	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
-	.gen_peer_assoc = ath10k_wmi_10_1_op_gen_peer_assoc,
-	/* .gen_pdev_get_temperature not implemented */
-
-	/* shared with main branch */
-	.pull_scan = ath10k_wmi_op_pull_scan_ev,
-	.pull_mgmt_rx = ath10k_wmi_op_pull_mgmt_rx_ev,
-	.pull_ch_info = ath10k_wmi_op_pull_ch_info_ev,
-	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
-	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
-	.pull_swba = ath10k_wmi_op_pull_swba_ev,
-	.pull_phyerr_hdr = ath10k_wmi_op_pull_phyerr_ev_hdr,
-	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
-	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
-	.pull_roam_ev = ath10k_wmi_op_pull_roam_ev,
-
-	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
-	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
-	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
-	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
-	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
-	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
-	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
-	.gen_vdev_stop = ath10k_wmi_op_gen_vdev_stop,
-	.gen_vdev_up = ath10k_wmi_op_gen_vdev_up,
-	.gen_vdev_down = ath10k_wmi_op_gen_vdev_down,
-	.gen_vdev_set_param = ath10k_wmi_op_gen_vdev_set_param,
-	.gen_vdev_install_key = ath10k_wmi_op_gen_vdev_install_key,
-	.gen_vdev_spectral_conf = ath10k_wmi_op_gen_vdev_spectral_conf,
-	.gen_vdev_spectral_enable = ath10k_wmi_op_gen_vdev_spectral_enable,
-	/* .gen_vdev_wmm_conf not implemented */
-	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
-	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
-	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
-	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
-	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
-	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
-	.gen_set_ap_ps = ath10k_wmi_op_gen_set_ap_ps,
-	.gen_scan_chan_list = ath10k_wmi_op_gen_scan_chan_list,
-	.gen_beacon_dma = ath10k_wmi_op_gen_beacon_dma,
-	.gen_pdev_set_wmm = ath10k_wmi_op_gen_pdev_set_wmm,
-	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
-	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
-	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
-	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
-	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
-	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
-	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
-	.gen_addba_clear_resp = ath10k_wmi_op_gen_addba_clear_resp,
-	.gen_addba_send = ath10k_wmi_op_gen_addba_send,
-	.gen_addba_set_resp = ath10k_wmi_op_gen_addba_set_resp,
-	.gen_delba_send = ath10k_wmi_op_gen_delba_send,
-	.fw_stats_fill = ath10k_wmi_10x_op_fw_stats_fill,
-	.get_vdev_subtype = ath10k_wmi_op_get_vdev_subtype,
-	/* .gen_bcn_tmpl not implemented */
-	/* .gen_prb_tmpl not implemented */
-	/* .gen_p2p_go_bcn_ie not implemented */
-	/* .gen_adaptive_qcs not implemented */
-	/* .gen_pdev_enable_adaptive_cca not implemented */
-};
-
 static const struct wmi_ops wmi_10_2_ops = {
 	.rx = ath10k_wmi_10_2_op_rx,
 	.pull_fw_stats = ath10k_wmi_10_2_op_pull_fw_stats,
@@ -7771,7 +7240,7 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
 	/* .gen_pdev_get_temperature not implemented */
 
-	/* shared with 10.1 */
+	/* shared with 10.2.4 */
 	.map_svc = wmi_10x_svc_map,
 	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
@@ -7837,7 +7306,7 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 	.gen_pdev_get_temperature = ath10k_wmi_10_2_op_gen_pdev_get_temperature,
 	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 
-	/* shared with 10.1 */
+	/* shared with 10.2 */
 	.map_svc = wmi_10x_svc_map,
 	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
@@ -7989,13 +7458,6 @@ int ath10k_wmi_attach(struct ath10k *ar)
 		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
 		ar->wmi.peer_flags = &wmi_10_2_peer_flags_map;
 		break;
-	case ATH10K_FW_WMI_OP_VERSION_10_1:
-		ar->wmi.cmd = &wmi_10x_cmd_map;
-		ar->wmi.ops = &wmi_10_1_ops;
-		ar->wmi.vdev_param = &wmi_10x_vdev_param_map;
-		ar->wmi.pdev_param = &wmi_10x_pdev_param_map;
-		ar->wmi.peer_flags = &wmi_10x_peer_flags_map;
-		break;
 	case ATH10K_FW_WMI_OP_VERSION_MAIN:
 		ar->wmi.cmd = &wmi_cmd_map;
 		ar->wmi.ops = &wmi_ops;
@@ -8006,6 +7468,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	case ATH10K_FW_WMI_OP_VERSION_TLV:
 		ath10k_wmi_tlv_attach(ar);
 		break;
+	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_UNSET:
 	case ATH10K_FW_WMI_OP_VERSION_MAX:
 		ath10k_err(ar, "unsupported WMI op version: %d\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 90f594e89f94..940ce480bcb8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1116,217 +1116,6 @@ enum wmi_event_id {
 	WMI_GPIO_INPUT_EVENTID = WMI_EVT_GRP_START_ID(WMI_GRP_GPIO),
 };
 
-/* Command IDs and command events for 10.X firmware */
-enum wmi_10x_cmd_id {
-	WMI_10X_START_CMDID = 0x9000,
-	WMI_10X_END_CMDID = 0x9FFF,
-
-	/* initialize the wlan sub system */
-	WMI_10X_INIT_CMDID,
-
-	/* Scan specific commands */
-
-	WMI_10X_START_SCAN_CMDID = WMI_10X_START_CMDID,
-	WMI_10X_STOP_SCAN_CMDID,
-	WMI_10X_SCAN_CHAN_LIST_CMDID,
-	WMI_10X_ECHO_CMDID,
-
-	/* PDEV(physical device) specific commands */
-	WMI_10X_PDEV_SET_REGDOMAIN_CMDID,
-	WMI_10X_PDEV_SET_CHANNEL_CMDID,
-	WMI_10X_PDEV_SET_PARAM_CMDID,
-	WMI_10X_PDEV_PKTLOG_ENABLE_CMDID,
-	WMI_10X_PDEV_PKTLOG_DISABLE_CMDID,
-	WMI_10X_PDEV_SET_WMM_PARAMS_CMDID,
-	WMI_10X_PDEV_SET_HT_CAP_IE_CMDID,
-	WMI_10X_PDEV_SET_VHT_CAP_IE_CMDID,
-	WMI_10X_PDEV_SET_BASE_MACADDR_CMDID,
-	WMI_10X_PDEV_SET_DSCP_TID_MAP_CMDID,
-	WMI_10X_PDEV_SET_QUIET_MODE_CMDID,
-	WMI_10X_PDEV_GREEN_AP_PS_ENABLE_CMDID,
-	WMI_10X_PDEV_GET_TPC_CONFIG_CMDID,
-
-	/* VDEV(virtual device) specific commands */
-	WMI_10X_VDEV_CREATE_CMDID,
-	WMI_10X_VDEV_DELETE_CMDID,
-	WMI_10X_VDEV_START_REQUEST_CMDID,
-	WMI_10X_VDEV_RESTART_REQUEST_CMDID,
-	WMI_10X_VDEV_UP_CMDID,
-	WMI_10X_VDEV_STOP_CMDID,
-	WMI_10X_VDEV_DOWN_CMDID,
-	WMI_10X_VDEV_STANDBY_RESPONSE_CMDID,
-	WMI_10X_VDEV_RESUME_RESPONSE_CMDID,
-	WMI_10X_VDEV_SET_PARAM_CMDID,
-	WMI_10X_VDEV_INSTALL_KEY_CMDID,
-
-	/* peer specific commands */
-	WMI_10X_PEER_CREATE_CMDID,
-	WMI_10X_PEER_DELETE_CMDID,
-	WMI_10X_PEER_FLUSH_TIDS_CMDID,
-	WMI_10X_PEER_SET_PARAM_CMDID,
-	WMI_10X_PEER_ASSOC_CMDID,
-	WMI_10X_PEER_ADD_WDS_ENTRY_CMDID,
-	WMI_10X_PEER_REMOVE_WDS_ENTRY_CMDID,
-	WMI_10X_PEER_MCAST_GROUP_CMDID,
-
-	/* beacon/management specific commands */
-
-	WMI_10X_BCN_TX_CMDID,
-	WMI_10X_BCN_PRB_TMPL_CMDID,
-	WMI_10X_BCN_FILTER_RX_CMDID,
-	WMI_10X_PRB_REQ_FILTER_RX_CMDID,
-	WMI_10X_MGMT_TX_CMDID,
-
-	/* commands to directly control ba negotiation directly from host. */
-	WMI_10X_ADDBA_CLEAR_RESP_CMDID,
-	WMI_10X_ADDBA_SEND_CMDID,
-	WMI_10X_ADDBA_STATUS_CMDID,
-	WMI_10X_DELBA_SEND_CMDID,
-	WMI_10X_ADDBA_SET_RESP_CMDID,
-	WMI_10X_SEND_SINGLEAMSDU_CMDID,
-
-	/* Station power save specific config */
-	WMI_10X_STA_POWERSAVE_MODE_CMDID,
-	WMI_10X_STA_POWERSAVE_PARAM_CMDID,
-	WMI_10X_STA_MIMO_PS_MODE_CMDID,
-
-	/* set debug log config */
-	WMI_10X_DBGLOG_CFG_CMDID,
-
-	/* DFS-specific commands */
-	WMI_10X_PDEV_DFS_ENABLE_CMDID,
-	WMI_10X_PDEV_DFS_DISABLE_CMDID,
-
-	/* QVIT specific command id */
-	WMI_10X_PDEV_QVIT_CMDID,
-
-	/* Offload Scan and Roaming related  commands */
-	WMI_10X_ROAM_SCAN_MODE,
-	WMI_10X_ROAM_SCAN_RSSI_THRESHOLD,
-	WMI_10X_ROAM_SCAN_PERIOD,
-	WMI_10X_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
-	WMI_10X_ROAM_AP_PROFILE,
-	WMI_10X_OFL_SCAN_ADD_AP_PROFILE,
-	WMI_10X_OFL_SCAN_REMOVE_AP_PROFILE,
-	WMI_10X_OFL_SCAN_PERIOD,
-
-	/* P2P specific commands */
-	WMI_10X_P2P_DEV_SET_DEVICE_INFO,
-	WMI_10X_P2P_DEV_SET_DISCOVERABILITY,
-	WMI_10X_P2P_GO_SET_BEACON_IE,
-	WMI_10X_P2P_GO_SET_PROBE_RESP_IE,
-
-	/* AP power save specific config */
-	WMI_10X_AP_PS_PEER_PARAM_CMDID,
-	WMI_10X_AP_PS_PEER_UAPSD_COEX_CMDID,
-
-	/* Rate-control specific commands */
-	WMI_10X_PEER_RATE_RETRY_SCHED_CMDID,
-
-	/* WLAN Profiling commands. */
-	WMI_10X_WLAN_PROFILE_TRIGGER_CMDID,
-	WMI_10X_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
-	WMI_10X_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
-	WMI_10X_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
-	WMI_10X_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
-
-	/* Suspend resume command Ids */
-	WMI_10X_PDEV_SUSPEND_CMDID,
-	WMI_10X_PDEV_RESUME_CMDID,
-
-	/* Beacon filter commands */
-	WMI_10X_ADD_BCN_FILTER_CMDID,
-	WMI_10X_RMV_BCN_FILTER_CMDID,
-
-	/* WOW Specific WMI commands*/
-	WMI_10X_WOW_ADD_WAKE_PATTERN_CMDID,
-	WMI_10X_WOW_DEL_WAKE_PATTERN_CMDID,
-	WMI_10X_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
-	WMI_10X_WOW_ENABLE_CMDID,
-	WMI_10X_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
-
-	/* RTT measurement related cmd */
-	WMI_10X_RTT_MEASREQ_CMDID,
-	WMI_10X_RTT_TSF_CMDID,
-
-	/* transmit beacon by value */
-	WMI_10X_PDEV_SEND_BCN_CMDID,
-
-	/* F/W stats */
-	WMI_10X_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
-	WMI_10X_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
-	WMI_10X_REQUEST_STATS_CMDID,
-
-	/* GPIO Configuration */
-	WMI_10X_GPIO_CONFIG_CMDID,
-	WMI_10X_GPIO_OUTPUT_CMDID,
-
-	WMI_10X_PDEV_UTF_CMDID = WMI_10X_END_CMDID - 1,
-};
-
-enum wmi_10x_event_id {
-	WMI_10X_SERVICE_READY_EVENTID = 0x8000,
-	WMI_10X_READY_EVENTID,
-	WMI_10X_START_EVENTID = 0x9000,
-	WMI_10X_END_EVENTID = 0x9FFF,
-
-	/* Scan specific events */
-	WMI_10X_SCAN_EVENTID = WMI_10X_START_EVENTID,
-	WMI_10X_ECHO_EVENTID,
-	WMI_10X_DEBUG_MESG_EVENTID,
-	WMI_10X_UPDATE_STATS_EVENTID,
-
-	/* Instantaneous RSSI event */
-	WMI_10X_INST_RSSI_STATS_EVENTID,
-
-	/* VDEV specific events */
-	WMI_10X_VDEV_START_RESP_EVENTID,
-	WMI_10X_VDEV_STANDBY_REQ_EVENTID,
-	WMI_10X_VDEV_RESUME_REQ_EVENTID,
-	WMI_10X_VDEV_STOPPED_EVENTID,
-
-	/* peer  specific events */
-	WMI_10X_PEER_STA_KICKOUT_EVENTID,
-
-	/* beacon/mgmt specific events */
-	WMI_10X_HOST_SWBA_EVENTID,
-	WMI_10X_TBTTOFFSET_UPDATE_EVENTID,
-	WMI_10X_MGMT_RX_EVENTID,
-
-	/* Channel stats event */
-	WMI_10X_CHAN_INFO_EVENTID,
-
-	/* PHY Error specific WMI event */
-	WMI_10X_PHYERR_EVENTID,
-
-	/* Roam event to trigger roaming on host */
-	WMI_10X_ROAM_EVENTID,
-
-	/* matching AP found from list of profiles */
-	WMI_10X_PROFILE_MATCH,
-
-	/* debug print message used for tracing FW code while debugging */
-	WMI_10X_DEBUG_PRINT_EVENTID,
-	/* VI spoecific event */
-	WMI_10X_PDEV_QVIT_EVENTID,
-	/* FW code profile data in response to profile request */
-	WMI_10X_WLAN_PROFILE_DATA_EVENTID,
-
-	/*RTT related event ID*/
-	WMI_10X_RTT_MEASUREMENT_REPORT_EVENTID,
-	WMI_10X_TSF_MEASUREMENT_REPORT_EVENTID,
-	WMI_10X_RTT_ERROR_REPORT_EVENTID,
-
-	WMI_10X_WOW_WAKEUP_HOST_EVENTID,
-	WMI_10X_DCS_INTERFERENCE_EVENTID,
-
-	/* TPC config for the current operating channel */
-	WMI_10X_PDEV_TPC_CONFIG_EVENTID,
-
-	WMI_10X_GPIO_INPUT_EVENTID,
-	WMI_10X_PDEV_UTF_EVENTID = WMI_10X_END_EVENTID - 1,
-};
-
 enum wmi_10_2_cmd_id {
 	WMI_10_2_START_CMDID = 0x9000,
 	WMI_10_2_END_CMDID = 0x9FFF,
@@ -2739,12 +2528,6 @@ struct wmi_init_cmd {
 	struct wmi_host_mem_chunks mem_chunks;
 } __packed;
 
-/* _10x stucture is from 10.X FW API */
-struct wmi_init_cmd_10x {
-	struct wmi_resource_config_10x resource_config;
-	struct wmi_host_mem_chunks mem_chunks;
-} __packed;
-
 struct wmi_init_cmd_10_2 {
 	struct wmi_resource_config_10_2 resource_config;
 	struct wmi_host_mem_chunks mem_chunks;
@@ -4241,14 +4024,6 @@ struct wmi_pdev_stats_extra {
 	__le32 mib_int_count;
 } __packed;
 
-struct wmi_10x_pdev_stats {
-	struct wmi_pdev_stats_base base;
-	struct wmi_pdev_stats_tx tx;
-	struct wmi_pdev_stats_rx rx;
-	struct wmi_pdev_stats_peer peer;
-	struct wmi_pdev_stats_extra extra;
-} __packed;
-
 struct wmi_pdev_stats_mem {
 	__le32 dram_free;
 	__le32 iram_free;
@@ -5863,23 +5638,6 @@ enum wmi_peer_flags {
 	WMI_PEER_PMF = 0x10000000,
 };
 
-enum wmi_10x_peer_flags {
-	WMI_10X_PEER_AUTH = 0x00000001,
-	WMI_10X_PEER_QOS = 0x00000002,
-	WMI_10X_PEER_NEED_PTK_4_WAY = 0x00000004,
-	WMI_10X_PEER_NEED_GTK_2_WAY = 0x00000010,
-	WMI_10X_PEER_APSD = 0x00000800,
-	WMI_10X_PEER_HT = 0x00001000,
-	WMI_10X_PEER_40MHZ = 0x00002000,
-	WMI_10X_PEER_STBC = 0x00008000,
-	WMI_10X_PEER_LDPC = 0x00010000,
-	WMI_10X_PEER_DYN_MIMOPS = 0x00020000,
-	WMI_10X_PEER_STATIC_MIMOPS = 0x00040000,
-	WMI_10X_PEER_SPATIAL_MUX = 0x00200000,
-	WMI_10X_PEER_VHT = 0x02000000,
-	WMI_10X_PEER_80MHZ = 0x04000000,
-};
-
 enum wmi_10_2_peer_flags {
 	WMI_10_2_PEER_AUTH = 0x00000001,
 	WMI_10_2_PEER_QOS = 0x00000002,
@@ -5949,10 +5707,6 @@ struct wmi_main_peer_assoc_complete_cmd {
 	__le32 peer_ht_info[2];
 } __packed;
 
-struct wmi_10_1_peer_assoc_complete_cmd {
-	struct wmi_common_peer_assoc_complete_cmd cmd;
-} __packed;
-
 #define WMI_PEER_ASSOC_INFO0_MAX_MCS_IDX_LSB 0
 #define WMI_PEER_ASSOC_INFO0_MAX_MCS_IDX_MASK 0x0f
 #define WMI_PEER_ASSOC_INFO0_MAX_NSS_LSB 4
-- 
2.8.3

