Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:56963 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751538AbbFVOle (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:41:34 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 03/10] ath10k: include 10.4 fw specific wmi cmd and event ids
Date: Mon, 22 Jun 2015 20:10:11 +0530
Message-ID: <1434984018-24057-4-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164137_786568_C9689743)
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

10.4 firmware wmi cmd and event id values are not exactly aligned
with previous firmware versions (main, 10.x, 10.2, etc). Add new
enum to define wmi cmd & event definitions for 10.4 firmware and
prepare wmi_10_4_cmd_map based on 10.4 firmware wmi cmd definitions.

wmi_cmd_map is extended to accommodate new wmi commands which are
exclusively available in 10.4 firmware.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
v2 changes:
 - updated wmi cmd/event ids based on stable 10.4 firmware.

 drivers/net/wireless/ath/ath10k/wmi.c | 184 +++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h | 252 ++++++++++++++++++++++++++++++++++
 2 files changed, 436 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 52493d1..8dc937d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -395,6 +395,189 @@ static struct wmi_cmd_map wmi_10_2_4_cmd_map = {
 	.pdev_get_temperature_cmdid = WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
 };
 
+/* 10.4 WMI cmd track */
+static struct wmi_cmd_map wmi_10_4_cmd_map = {
+	.init_cmdid = WMI_10_4_INIT_CMDID,
+	.start_scan_cmdid = WMI_10_4_START_SCAN_CMDID,
+	.stop_scan_cmdid = WMI_10_4_STOP_SCAN_CMDID,
+	.scan_chan_list_cmdid = WMI_10_4_SCAN_CHAN_LIST_CMDID,
+	.scan_sch_prio_tbl_cmdid = WMI_10_4_SCAN_SCH_PRIO_TBL_CMDID,
+	.pdev_set_regdomain_cmdid = WMI_10_4_PDEV_SET_REGDOMAIN_CMDID,
+	.pdev_set_channel_cmdid = WMI_10_4_PDEV_SET_CHANNEL_CMDID,
+	.pdev_set_param_cmdid = WMI_10_4_PDEV_SET_PARAM_CMDID,
+	.pdev_pktlog_enable_cmdid = WMI_10_4_PDEV_PKTLOG_ENABLE_CMDID,
+	.pdev_pktlog_disable_cmdid = WMI_10_4_PDEV_PKTLOG_DISABLE_CMDID,
+	.pdev_set_wmm_params_cmdid = WMI_10_4_PDEV_SET_WMM_PARAMS_CMDID,
+	.pdev_set_ht_cap_ie_cmdid = WMI_10_4_PDEV_SET_HT_CAP_IE_CMDID,
+	.pdev_set_vht_cap_ie_cmdid = WMI_10_4_PDEV_SET_VHT_CAP_IE_CMDID,
+	.pdev_set_dscp_tid_map_cmdid = WMI_10_4_PDEV_SET_DSCP_TID_MAP_CMDID,
+	.pdev_set_quiet_mode_cmdid = WMI_10_4_PDEV_SET_QUIET_MODE_CMDID,
+	.pdev_green_ap_ps_enable_cmdid = WMI_10_4_PDEV_GREEN_AP_PS_ENABLE_CMDID,
+	.pdev_get_tpc_config_cmdid = WMI_10_4_PDEV_GET_TPC_CONFIG_CMDID,
+	.pdev_set_base_macaddr_cmdid = WMI_10_4_PDEV_SET_BASE_MACADDR_CMDID,
+	.vdev_create_cmdid = WMI_10_4_VDEV_CREATE_CMDID,
+	.vdev_delete_cmdid = WMI_10_4_VDEV_DELETE_CMDID,
+	.vdev_start_request_cmdid = WMI_10_4_VDEV_START_REQUEST_CMDID,
+	.vdev_restart_request_cmdid = WMI_10_4_VDEV_RESTART_REQUEST_CMDID,
+	.vdev_up_cmdid = WMI_10_4_VDEV_UP_CMDID,
+	.vdev_stop_cmdid = WMI_10_4_VDEV_STOP_CMDID,
+	.vdev_down_cmdid = WMI_10_4_VDEV_DOWN_CMDID,
+	.vdev_set_param_cmdid = WMI_10_4_VDEV_SET_PARAM_CMDID,
+	.vdev_install_key_cmdid = WMI_10_4_VDEV_INSTALL_KEY_CMDID,
+	.peer_create_cmdid = WMI_10_4_PEER_CREATE_CMDID,
+	.peer_delete_cmdid = WMI_10_4_PEER_DELETE_CMDID,
+	.peer_flush_tids_cmdid = WMI_10_4_PEER_FLUSH_TIDS_CMDID,
+	.peer_set_param_cmdid = WMI_10_4_PEER_SET_PARAM_CMDID,
+	.peer_assoc_cmdid = WMI_10_4_PEER_ASSOC_CMDID,
+	.peer_add_wds_entry_cmdid = WMI_10_4_PEER_ADD_WDS_ENTRY_CMDID,
+	.peer_remove_wds_entry_cmdid = WMI_10_4_PEER_REMOVE_WDS_ENTRY_CMDID,
+	.peer_mcast_group_cmdid = WMI_10_4_PEER_MCAST_GROUP_CMDID,
+	.bcn_tx_cmdid = WMI_10_4_BCN_TX_CMDID,
+	.pdev_send_bcn_cmdid = WMI_10_4_PDEV_SEND_BCN_CMDID,
+	.bcn_tmpl_cmdid = WMI_10_4_BCN_PRB_TMPL_CMDID,
+	.bcn_filter_rx_cmdid = WMI_10_4_BCN_FILTER_RX_CMDID,
+	.prb_req_filter_rx_cmdid = WMI_10_4_PRB_REQ_FILTER_RX_CMDID,
+	.mgmt_tx_cmdid = WMI_10_4_MGMT_TX_CMDID,
+	.prb_tmpl_cmdid = WMI_10_4_PRB_TMPL_CMDID,
+	.addba_clear_resp_cmdid = WMI_10_4_ADDBA_CLEAR_RESP_CMDID,
+	.addba_send_cmdid = WMI_10_4_ADDBA_SEND_CMDID,
+	.addba_status_cmdid = WMI_10_4_ADDBA_STATUS_CMDID,
+	.delba_send_cmdid = WMI_10_4_DELBA_SEND_CMDID,
+	.addba_set_resp_cmdid = WMI_10_4_ADDBA_SET_RESP_CMDID,
+	.send_singleamsdu_cmdid = WMI_10_4_SEND_SINGLEAMSDU_CMDID,
+	.sta_powersave_mode_cmdid = WMI_10_4_STA_POWERSAVE_MODE_CMDID,
+	.sta_powersave_param_cmdid = WMI_10_4_STA_POWERSAVE_PARAM_CMDID,
+	.sta_mimo_ps_mode_cmdid = WMI_10_4_STA_MIMO_PS_MODE_CMDID,
+	.pdev_dfs_enable_cmdid = WMI_10_4_PDEV_DFS_ENABLE_CMDID,
+	.pdev_dfs_disable_cmdid = WMI_10_4_PDEV_DFS_DISABLE_CMDID,
+	.roam_scan_mode = WMI_10_4_ROAM_SCAN_MODE,
+	.roam_scan_rssi_threshold = WMI_10_4_ROAM_SCAN_RSSI_THRESHOLD,
+	.roam_scan_period = WMI_10_4_ROAM_SCAN_PERIOD,
+	.roam_scan_rssi_change_threshold =
+				WMI_10_4_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
+	.roam_ap_profile = WMI_10_4_ROAM_AP_PROFILE,
+	.ofl_scan_add_ap_profile = WMI_10_4_OFL_SCAN_ADD_AP_PROFILE,
+	.ofl_scan_remove_ap_profile = WMI_10_4_OFL_SCAN_REMOVE_AP_PROFILE,
+	.ofl_scan_period = WMI_10_4_OFL_SCAN_PERIOD,
+	.p2p_dev_set_device_info = WMI_10_4_P2P_DEV_SET_DEVICE_INFO,
+	.p2p_dev_set_discoverability = WMI_10_4_P2P_DEV_SET_DISCOVERABILITY,
+	.p2p_go_set_beacon_ie = WMI_10_4_P2P_GO_SET_BEACON_IE,
+	.p2p_go_set_probe_resp_ie = WMI_10_4_P2P_GO_SET_PROBE_RESP_IE,
+	.p2p_set_vendor_ie_data_cmdid = WMI_10_4_P2P_SET_VENDOR_IE_DATA_CMDID,
+	.ap_ps_peer_param_cmdid = WMI_10_4_AP_PS_PEER_PARAM_CMDID,
+	.ap_ps_peer_uapsd_coex_cmdid = WMI_10_4_AP_PS_PEER_UAPSD_COEX_CMDID,
+	.peer_rate_retry_sched_cmdid = WMI_10_4_PEER_RATE_RETRY_SCHED_CMDID,
+	.wlan_profile_trigger_cmdid = WMI_10_4_WLAN_PROFILE_TRIGGER_CMDID,
+	.wlan_profile_set_hist_intvl_cmdid =
+				WMI_10_4_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
+	.wlan_profile_get_profile_data_cmdid =
+				WMI_10_4_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
+	.wlan_profile_enable_profile_id_cmdid =
+				WMI_10_4_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
+	.wlan_profile_list_profile_id_cmdid =
+				WMI_10_4_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
+	.pdev_suspend_cmdid = WMI_10_4_PDEV_SUSPEND_CMDID,
+	.pdev_resume_cmdid = WMI_10_4_PDEV_RESUME_CMDID,
+	.add_bcn_filter_cmdid = WMI_10_4_ADD_BCN_FILTER_CMDID,
+	.rmv_bcn_filter_cmdid = WMI_10_4_RMV_BCN_FILTER_CMDID,
+	.wow_add_wake_pattern_cmdid = WMI_10_4_WOW_ADD_WAKE_PATTERN_CMDID,
+	.wow_del_wake_pattern_cmdid = WMI_10_4_WOW_DEL_WAKE_PATTERN_CMDID,
+	.wow_enable_disable_wake_event_cmdid =
+				WMI_10_4_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
+	.wow_enable_cmdid = WMI_10_4_WOW_ENABLE_CMDID,
+	.wow_hostwakeup_from_sleep_cmdid =
+				WMI_10_4_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
+	.rtt_measreq_cmdid = WMI_10_4_RTT_MEASREQ_CMDID,
+	.rtt_tsf_cmdid = WMI_10_4_RTT_TSF_CMDID,
+	.vdev_spectral_scan_configure_cmdid =
+				WMI_10_4_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
+	.vdev_spectral_scan_enable_cmdid =
+				WMI_10_4_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
+	.request_stats_cmdid = WMI_10_4_REQUEST_STATS_CMDID,
+	.set_arp_ns_offload_cmdid = WMI_CMD_UNSUPPORTED,
+	.network_list_offload_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.gtk_offload_cmdid = WMI_10_4_GTK_OFFLOAD_CMDID,
+	.csa_offload_enable_cmdid = WMI_10_4_CSA_OFFLOAD_ENABLE_CMDID,
+	.csa_offload_chanswitch_cmdid = WMI_10_4_CSA_OFFLOAD_CHANSWITCH_CMDID,
+	.chatter_set_mode_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_tid_addba_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_tid_delba_cmdid = WMI_CMD_UNSUPPORTED,
+	.sta_dtim_ps_method_cmdid = WMI_CMD_UNSUPPORTED,
+	.sta_uapsd_auto_trig_cmdid = WMI_CMD_UNSUPPORTED,
+	.sta_keepalive_cmd = WMI_CMD_UNSUPPORTED,
+	.echo_cmdid = WMI_10_4_ECHO_CMDID,
+	.pdev_utf_cmdid = WMI_10_4_PDEV_UTF_CMDID,
+	.dbglog_cfg_cmdid = WMI_10_4_DBGLOG_CFG_CMDID,
+	.pdev_qvit_cmdid = WMI_10_4_PDEV_QVIT_CMDID,
+	.pdev_ftm_intg_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_set_keepalive_cmdid = WMI_10_4_VDEV_SET_KEEPALIVE_CMDID,
+	.vdev_get_keepalive_cmdid = WMI_10_4_VDEV_GET_KEEPALIVE_CMDID,
+	.force_fw_hang_cmdid = WMI_10_4_FORCE_FW_HANG_CMDID,
+	.gpio_config_cmdid = WMI_10_4_GPIO_CONFIG_CMDID,
+	.gpio_output_cmdid = WMI_10_4_GPIO_OUTPUT_CMDID,
+	.pdev_get_temperature_cmdid = WMI_10_4_PDEV_GET_TEMPERATURE_CMDID,
+	.vdev_set_wmm_params_cmdid = WMI_CMD_UNSUPPORTED,
+	.tdls_set_state_cmdid = WMI_CMD_UNSUPPORTED,
+	.tdls_peer_update_cmdid = WMI_CMD_UNSUPPORTED,
+	.adaptive_qcs_cmdid = WMI_CMD_UNSUPPORTED,
+	.scan_update_request_cmdid = WMI_10_4_SCAN_UPDATE_REQUEST_CMDID,
+	.vdev_standby_response_cmdid = WMI_10_4_VDEV_STANDBY_RESPONSE_CMDID,
+	.vdev_resume_response_cmdid = WMI_10_4_VDEV_RESUME_RESPONSE_CMDID,
+	.wlan_peer_caching_add_peer_cmdid =
+			WMI_10_4_WLAN_PEER_CACHING_ADD_PEER_CMDID,
+	.wlan_peer_caching_evict_peer_cmdid =
+			WMI_10_4_WLAN_PEER_CACHING_EVICT_PEER_CMDID,
+	.wlan_peer_caching_restore_peer_cmdid =
+			WMI_10_4_WLAN_PEER_CACHING_RESTORE_PEER_CMDID,
+	.wlan_peer_caching_print_all_peers_info_cmdid =
+			WMI_10_4_WLAN_PEER_CACHING_PRINT_ALL_PEERS_INFO_CMDID,
+	.peer_update_wds_entry_cmdid = WMI_10_4_PEER_UPDATE_WDS_ENTRY_CMDID,
+	.peer_add_proxy_sta_entry_cmdid =
+			WMI_10_4_PEER_ADD_PROXY_STA_ENTRY_CMDID,
+	.rtt_keepalive_cmdid = WMI_10_4_RTT_KEEPALIVE_CMDID,
+	.oem_req_cmdid = WMI_10_4_OEM_REQ_CMDID,
+	.nan_cmdid = WMI_10_4_NAN_CMDID,
+	.vdev_ratemask_cmdid = WMI_10_4_VDEV_RATEMASK_CMDID,
+	.qboost_cfg_cmdid = WMI_10_4_QBOOST_CFG_CMDID,
+	.pdev_smart_ant_enable_cmdid = WMI_10_4_PDEV_SMART_ANT_ENABLE_CMDID,
+	.pdev_smart_ant_set_rx_antenna_cmdid =
+			WMI_10_4_PDEV_SMART_ANT_SET_RX_ANTENNA_CMDID,
+	.peer_smart_ant_set_tx_antenna_cmdid =
+			WMI_10_4_PEER_SMART_ANT_SET_TX_ANTENNA_CMDID,
+	.peer_smart_ant_set_train_info_cmdid =
+			WMI_10_4_PEER_SMART_ANT_SET_TRAIN_INFO_CMDID,
+	.peer_smart_ant_set_node_config_ops_cmdid =
+			WMI_10_4_PEER_SMART_ANT_SET_NODE_CONFIG_OPS_CMDID,
+	.pdev_set_antenna_switch_table_cmdid =
+			WMI_10_4_PDEV_SET_ANTENNA_SWITCH_TABLE_CMDID,
+	.pdev_set_ctl_table_cmdid = WMI_10_4_PDEV_SET_CTL_TABLE_CMDID,
+	.pdev_set_mimogain_table_cmdid = WMI_10_4_PDEV_SET_MIMOGAIN_TABLE_CMDID,
+	.pdev_ratepwr_table_cmdid = WMI_10_4_PDEV_RATEPWR_TABLE_CMDID,
+	.pdev_ratepwr_chainmsk_table_cmdid =
+			WMI_10_4_PDEV_RATEPWR_CHAINMSK_TABLE_CMDID,
+	.pdev_fips_cmdid = WMI_10_4_PDEV_FIPS_CMDID,
+	.tt_set_conf_cmdid = WMI_10_4_TT_SET_CONF_CMDID,
+	.fwtest_cmdid = WMI_10_4_FWTEST_CMDID,
+	.vdev_atf_request_cmdid = WMI_10_4_VDEV_ATF_REQUEST_CMDID,
+	.peer_atf_request_cmdid = WMI_10_4_PEER_ATF_REQUEST_CMDID,
+	.pdev_get_ani_cck_config_cmdid = WMI_10_4_PDEV_GET_ANI_CCK_CONFIG_CMDID,
+	.pdev_get_ani_ofdm_config_cmdid =
+			WMI_10_4_PDEV_GET_ANI_OFDM_CONFIG_CMDID,
+	.pdev_reserve_ast_entry_cmdid = WMI_10_4_PDEV_RESERVE_AST_ENTRY_CMDID,
+	.pdev_get_nfcal_power_cmdid = WMI_10_4_PDEV_GET_NFCAL_POWER_CMDID,
+	.pdev_get_tpc_cmdid = WMI_10_4_PDEV_GET_TPC_CMDID,
+	.pdev_get_ast_info_cmdid = WMI_10_4_PDEV_GET_AST_INFO_CMDID,
+	.vdev_set_dscp_tid_map_cmdid = WMI_10_4_VDEV_SET_DSCP_TID_MAP_CMDID,
+	.pdev_get_info_cmdid = WMI_10_4_PDEV_GET_INFO_CMDID,
+	.vdev_get_info_cmdid = WMI_10_4_VDEV_GET_INFO_CMDID,
+	.vdev_filter_neighbor_rx_packets_cmdid =
+			WMI_10_4_VDEV_FILTER_NEIGHBOR_RX_PACKETS_CMDID,
+	.mu_cal_start_cmdid = WMI_10_4_MU_CAL_START_CMDID,
+	.set_cca_params_cmdid = WMI_10_4_SET_CCA_PARAMS_CMDID,
+	.pdev_bss_chan_info_request_cmdid =
+			WMI_10_4_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
+};
+
 /* MAIN WMI VDEV param map */
 static struct wmi_vdev_param_map wmi_vdev_param_map = {
 	.rts_threshold = WMI_VDEV_PARAM_RTS_THRESHOLD,
@@ -5421,6 +5604,7 @@ int ath10k_wmi_attach(struct ath10k *ar)
 	switch (ar->wmi.op_version) {
 	case ATH10K_FW_WMI_OP_VERSION_10_4:
 		ar->wmi.ops = &wmi_10_4_ops;
+		ar->wmi.cmd = &wmi_10_4_cmd_map;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->wmi.cmd = &wmi_10_2_4_cmd_map;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index b54d14b..c3a05a9 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -711,6 +711,48 @@ struct wmi_cmd_map {
 	u32 tdls_set_state_cmdid;
 	u32 tdls_peer_update_cmdid;
 	u32 adaptive_qcs_cmdid;
+	u32 scan_update_request_cmdid;
+	u32 vdev_standby_response_cmdid;
+	u32 vdev_resume_response_cmdid;
+	u32 wlan_peer_caching_add_peer_cmdid;
+	u32 wlan_peer_caching_evict_peer_cmdid;
+	u32 wlan_peer_caching_restore_peer_cmdid;
+	u32 wlan_peer_caching_print_all_peers_info_cmdid;
+	u32 peer_update_wds_entry_cmdid;
+	u32 peer_add_proxy_sta_entry_cmdid;
+	u32 rtt_keepalive_cmdid;
+	u32 oem_req_cmdid;
+	u32 nan_cmdid;
+	u32 vdev_ratemask_cmdid;
+	u32 qboost_cfg_cmdid;
+	u32 pdev_smart_ant_enable_cmdid;
+	u32 pdev_smart_ant_set_rx_antenna_cmdid;
+	u32 peer_smart_ant_set_tx_antenna_cmdid;
+	u32 peer_smart_ant_set_train_info_cmdid;
+	u32 peer_smart_ant_set_node_config_ops_cmdid;
+	u32 pdev_set_antenna_switch_table_cmdid;
+	u32 pdev_set_ctl_table_cmdid;
+	u32 pdev_set_mimogain_table_cmdid;
+	u32 pdev_ratepwr_table_cmdid;
+	u32 pdev_ratepwr_chainmsk_table_cmdid;
+	u32 pdev_fips_cmdid;
+	u32 tt_set_conf_cmdid;
+	u32 fwtest_cmdid;
+	u32 vdev_atf_request_cmdid;
+	u32 peer_atf_request_cmdid;
+	u32 pdev_get_ani_cck_config_cmdid;
+	u32 pdev_get_ani_ofdm_config_cmdid;
+	u32 pdev_reserve_ast_entry_cmdid;
+	u32 pdev_get_nfcal_power_cmdid;
+	u32 pdev_get_tpc_cmdid;
+	u32 pdev_get_ast_info_cmdid;
+	u32 vdev_set_dscp_tid_map_cmdid;
+	u32 pdev_get_info_cmdid;
+	u32 vdev_get_info_cmdid;
+	u32 vdev_filter_neighbor_rx_packets_cmdid;
+	u32 mu_cal_start_cmdid;
+	u32 set_cca_params_cmdid;
+	u32 pdev_bss_chan_info_request_cmdid;
 };
 
 /*
@@ -1366,6 +1408,216 @@ enum wmi_10_2_event_id {
 	WMI_10_2_PDEV_UTF_EVENTID = WMI_10_2_END_EVENTID - 1,
 };
 
+enum wmi_10_4_cmd_id {
+	WMI_10_4_START_CMDID = 0x9000,
+	WMI_10_4_END_CMDID = 0x9FFF,
+	WMI_10_4_INIT_CMDID,
+	WMI_10_4_START_SCAN_CMDID = WMI_10_4_START_CMDID,
+	WMI_10_4_STOP_SCAN_CMDID,
+	WMI_10_4_SCAN_CHAN_LIST_CMDID,
+	WMI_10_4_SCAN_SCH_PRIO_TBL_CMDID,
+	WMI_10_4_SCAN_UPDATE_REQUEST_CMDID,
+	WMI_10_4_ECHO_CMDID,
+	WMI_10_4_PDEV_SET_REGDOMAIN_CMDID,
+	WMI_10_4_PDEV_SET_CHANNEL_CMDID,
+	WMI_10_4_PDEV_SET_PARAM_CMDID,
+	WMI_10_4_PDEV_PKTLOG_ENABLE_CMDID,
+	WMI_10_4_PDEV_PKTLOG_DISABLE_CMDID,
+	WMI_10_4_PDEV_SET_WMM_PARAMS_CMDID,
+	WMI_10_4_PDEV_SET_HT_CAP_IE_CMDID,
+	WMI_10_4_PDEV_SET_VHT_CAP_IE_CMDID,
+	WMI_10_4_PDEV_SET_BASE_MACADDR_CMDID,
+	WMI_10_4_PDEV_SET_DSCP_TID_MAP_CMDID,
+	WMI_10_4_PDEV_SET_QUIET_MODE_CMDID,
+	WMI_10_4_PDEV_GREEN_AP_PS_ENABLE_CMDID,
+	WMI_10_4_PDEV_GET_TPC_CONFIG_CMDID,
+	WMI_10_4_VDEV_CREATE_CMDID,
+	WMI_10_4_VDEV_DELETE_CMDID,
+	WMI_10_4_VDEV_START_REQUEST_CMDID,
+	WMI_10_4_VDEV_RESTART_REQUEST_CMDID,
+	WMI_10_4_VDEV_UP_CMDID,
+	WMI_10_4_VDEV_STOP_CMDID,
+	WMI_10_4_VDEV_DOWN_CMDID,
+	WMI_10_4_VDEV_STANDBY_RESPONSE_CMDID,
+	WMI_10_4_VDEV_RESUME_RESPONSE_CMDID,
+	WMI_10_4_VDEV_SET_PARAM_CMDID,
+	WMI_10_4_VDEV_INSTALL_KEY_CMDID,
+	WMI_10_4_WLAN_PEER_CACHING_ADD_PEER_CMDID,
+	WMI_10_4_WLAN_PEER_CACHING_EVICT_PEER_CMDID,
+	WMI_10_4_WLAN_PEER_CACHING_RESTORE_PEER_CMDID,
+	WMI_10_4_WLAN_PEER_CACHING_PRINT_ALL_PEERS_INFO_CMDID,
+	WMI_10_4_PEER_CREATE_CMDID,
+	WMI_10_4_PEER_DELETE_CMDID,
+	WMI_10_4_PEER_FLUSH_TIDS_CMDID,
+	WMI_10_4_PEER_SET_PARAM_CMDID,
+	WMI_10_4_PEER_ASSOC_CMDID,
+	WMI_10_4_PEER_ADD_WDS_ENTRY_CMDID,
+	WMI_10_4_PEER_UPDATE_WDS_ENTRY_CMDID,
+	WMI_10_4_PEER_REMOVE_WDS_ENTRY_CMDID,
+	WMI_10_4_PEER_ADD_PROXY_STA_ENTRY_CMDID,
+	WMI_10_4_PEER_MCAST_GROUP_CMDID,
+	WMI_10_4_BCN_TX_CMDID,
+	WMI_10_4_PDEV_SEND_BCN_CMDID,
+	WMI_10_4_BCN_PRB_TMPL_CMDID,
+	WMI_10_4_BCN_FILTER_RX_CMDID,
+	WMI_10_4_PRB_REQ_FILTER_RX_CMDID,
+	WMI_10_4_MGMT_TX_CMDID,
+	WMI_10_4_PRB_TMPL_CMDID,
+	WMI_10_4_ADDBA_CLEAR_RESP_CMDID,
+	WMI_10_4_ADDBA_SEND_CMDID,
+	WMI_10_4_ADDBA_STATUS_CMDID,
+	WMI_10_4_DELBA_SEND_CMDID,
+	WMI_10_4_ADDBA_SET_RESP_CMDID,
+	WMI_10_4_SEND_SINGLEAMSDU_CMDID,
+	WMI_10_4_STA_POWERSAVE_MODE_CMDID,
+	WMI_10_4_STA_POWERSAVE_PARAM_CMDID,
+	WMI_10_4_STA_MIMO_PS_MODE_CMDID,
+	WMI_10_4_DBGLOG_CFG_CMDID,
+	WMI_10_4_PDEV_DFS_ENABLE_CMDID,
+	WMI_10_4_PDEV_DFS_DISABLE_CMDID,
+	WMI_10_4_PDEV_QVIT_CMDID,
+	WMI_10_4_ROAM_SCAN_MODE,
+	WMI_10_4_ROAM_SCAN_RSSI_THRESHOLD,
+	WMI_10_4_ROAM_SCAN_PERIOD,
+	WMI_10_4_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
+	WMI_10_4_ROAM_AP_PROFILE,
+	WMI_10_4_OFL_SCAN_ADD_AP_PROFILE,
+	WMI_10_4_OFL_SCAN_REMOVE_AP_PROFILE,
+	WMI_10_4_OFL_SCAN_PERIOD,
+	WMI_10_4_P2P_DEV_SET_DEVICE_INFO,
+	WMI_10_4_P2P_DEV_SET_DISCOVERABILITY,
+	WMI_10_4_P2P_GO_SET_BEACON_IE,
+	WMI_10_4_P2P_GO_SET_PROBE_RESP_IE,
+	WMI_10_4_P2P_SET_VENDOR_IE_DATA_CMDID,
+	WMI_10_4_AP_PS_PEER_PARAM_CMDID,
+	WMI_10_4_AP_PS_PEER_UAPSD_COEX_CMDID,
+	WMI_10_4_PEER_RATE_RETRY_SCHED_CMDID,
+	WMI_10_4_WLAN_PROFILE_TRIGGER_CMDID,
+	WMI_10_4_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
+	WMI_10_4_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
+	WMI_10_4_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
+	WMI_10_4_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
+	WMI_10_4_PDEV_SUSPEND_CMDID,
+	WMI_10_4_PDEV_RESUME_CMDID,
+	WMI_10_4_ADD_BCN_FILTER_CMDID,
+	WMI_10_4_RMV_BCN_FILTER_CMDID,
+	WMI_10_4_WOW_ADD_WAKE_PATTERN_CMDID,
+	WMI_10_4_WOW_DEL_WAKE_PATTERN_CMDID,
+	WMI_10_4_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
+	WMI_10_4_WOW_ENABLE_CMDID,
+	WMI_10_4_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
+	WMI_10_4_RTT_MEASREQ_CMDID,
+	WMI_10_4_RTT_TSF_CMDID,
+	WMI_10_4_RTT_KEEPALIVE_CMDID,
+	WMI_10_4_OEM_REQ_CMDID,
+	WMI_10_4_NAN_CMDID,
+	WMI_10_4_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
+	WMI_10_4_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
+	WMI_10_4_REQUEST_STATS_CMDID,
+	WMI_10_4_GPIO_CONFIG_CMDID,
+	WMI_10_4_GPIO_OUTPUT_CMDID,
+	WMI_10_4_VDEV_RATEMASK_CMDID,
+	WMI_10_4_CSA_OFFLOAD_ENABLE_CMDID,
+	WMI_10_4_GTK_OFFLOAD_CMDID,
+	WMI_10_4_QBOOST_CFG_CMDID,
+	WMI_10_4_CSA_OFFLOAD_CHANSWITCH_CMDID,
+	WMI_10_4_PDEV_SMART_ANT_ENABLE_CMDID,
+	WMI_10_4_PDEV_SMART_ANT_SET_RX_ANTENNA_CMDID,
+	WMI_10_4_PEER_SMART_ANT_SET_TX_ANTENNA_CMDID,
+	WMI_10_4_PEER_SMART_ANT_SET_TRAIN_INFO_CMDID,
+	WMI_10_4_PEER_SMART_ANT_SET_NODE_CONFIG_OPS_CMDID,
+	WMI_10_4_VDEV_SET_KEEPALIVE_CMDID,
+	WMI_10_4_VDEV_GET_KEEPALIVE_CMDID,
+	WMI_10_4_FORCE_FW_HANG_CMDID,
+	WMI_10_4_PDEV_SET_ANTENNA_SWITCH_TABLE_CMDID,
+	WMI_10_4_PDEV_SET_CTL_TABLE_CMDID,
+	WMI_10_4_PDEV_SET_MIMOGAIN_TABLE_CMDID,
+	WMI_10_4_PDEV_RATEPWR_TABLE_CMDID,
+	WMI_10_4_PDEV_RATEPWR_CHAINMSK_TABLE_CMDID,
+	WMI_10_4_PDEV_FIPS_CMDID,
+	WMI_10_4_TT_SET_CONF_CMDID,
+	WMI_10_4_FWTEST_CMDID,
+	WMI_10_4_VDEV_ATF_REQUEST_CMDID,
+	WMI_10_4_PEER_ATF_REQUEST_CMDID,
+	WMI_10_4_PDEV_GET_ANI_CCK_CONFIG_CMDID,
+	WMI_10_4_PDEV_GET_ANI_OFDM_CONFIG_CMDID,
+	WMI_10_4_PDEV_RESERVE_AST_ENTRY_CMDID,
+	WMI_10_4_PDEV_GET_NFCAL_POWER_CMDID,
+	WMI_10_4_PDEV_GET_TPC_CMDID,
+	WMI_10_4_PDEV_GET_AST_INFO_CMDID,
+	WMI_10_4_VDEV_SET_DSCP_TID_MAP_CMDID,
+	WMI_10_4_PDEV_GET_TEMPERATURE_CMDID,
+	WMI_10_4_PDEV_GET_INFO_CMDID,
+	WMI_10_4_VDEV_GET_INFO_CMDID,
+	WMI_10_4_VDEV_FILTER_NEIGHBOR_RX_PACKETS_CMDID,
+	WMI_10_4_MU_CAL_START_CMDID,
+	WMI_10_4_SET_CCA_PARAMS_CMDID,
+	WMI_10_4_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
+	WMI_10_4_PDEV_UTF_CMDID = WMI_10_4_END_CMDID - 1,
+};
+
+enum wmi_10_4_event_id {
+	WMI_10_4_SERVICE_READY_EVENTID = 0x8000,
+	WMI_10_4_READY_EVENTID,
+	WMI_10_4_DEBUG_MESG_EVENTID,
+	WMI_10_4_START_EVENTID = 0x9000,
+	WMI_10_4_END_EVENTID = 0x9FFF,
+	WMI_10_4_SCAN_EVENTID = WMI_10_4_START_EVENTID,
+	WMI_10_4_ECHO_EVENTID,
+	WMI_10_4_UPDATE_STATS_EVENTID,
+	WMI_10_4_INST_RSSI_STATS_EVENTID,
+	WMI_10_4_VDEV_START_RESP_EVENTID,
+	WMI_10_4_VDEV_STANDBY_REQ_EVENTID,
+	WMI_10_4_VDEV_RESUME_REQ_EVENTID,
+	WMI_10_4_VDEV_STOPPED_EVENTID,
+	WMI_10_4_PEER_STA_KICKOUT_EVENTID,
+	WMI_10_4_HOST_SWBA_EVENTID,
+	WMI_10_4_TBTTOFFSET_UPDATE_EVENTID,
+	WMI_10_4_MGMT_RX_EVENTID,
+	WMI_10_4_CHAN_INFO_EVENTID,
+	WMI_10_4_PHYERR_EVENTID,
+	WMI_10_4_ROAM_EVENTID,
+	WMI_10_4_PROFILE_MATCH,
+	WMI_10_4_DEBUG_PRINT_EVENTID,
+	WMI_10_4_PDEV_QVIT_EVENTID,
+	WMI_10_4_WLAN_PROFILE_DATA_EVENTID,
+	WMI_10_4_RTT_MEASUREMENT_REPORT_EVENTID,
+	WMI_10_4_TSF_MEASUREMENT_REPORT_EVENTID,
+	WMI_10_4_RTT_ERROR_REPORT_EVENTID,
+	WMI_10_4_RTT_KEEPALIVE_EVENTID,
+	WMI_10_4_OEM_CAPABILITY_EVENTID,
+	WMI_10_4_OEM_MEASUREMENT_REPORT_EVENTID,
+	WMI_10_4_OEM_ERROR_REPORT_EVENTID,
+	WMI_10_4_NAN_EVENTID,
+	WMI_10_4_WOW_WAKEUP_HOST_EVENTID,
+	WMI_10_4_GTK_OFFLOAD_STATUS_EVENTID,
+	WMI_10_4_GTK_REKEY_FAIL_EVENTID,
+	WMI_10_4_DCS_INTERFERENCE_EVENTID,
+	WMI_10_4_PDEV_TPC_CONFIG_EVENTID,
+	WMI_10_4_CSA_HANDLING_EVENTID,
+	WMI_10_4_GPIO_INPUT_EVENTID,
+	WMI_10_4_PEER_RATECODE_LIST_EVENTID,
+	WMI_10_4_GENERIC_BUFFER_EVENTID,
+	WMI_10_4_MCAST_BUF_RELEASE_EVENTID,
+	WMI_10_4_MCAST_LIST_AGEOUT_EVENTID,
+	WMI_10_4_VDEV_GET_KEEPALIVE_EVENTID,
+	WMI_10_4_WDS_PEER_EVENTID,
+	WMI_10_4_PEER_STA_PS_STATECHG_EVENTID,
+	WMI_10_4_PDEV_FIPS_EVENTID,
+	WMI_10_4_TT_STATS_EVENTID,
+	WMI_10_4_PDEV_CHANNEL_HOPPING_EVENTID,
+	WMI_10_4_PDEV_ANI_CCK_LEVEL_EVENTID,
+	WMI_10_4_PDEV_ANI_OFDM_LEVEL_EVENTID,
+	WMI_10_4_PDEV_RESERVE_AST_ENTRY_EVENTID,
+	WMI_10_4_PDEV_NFCAL_POWER_EVENTID,
+	WMI_10_4_PDEV_TPC_EVENTID,
+	WMI_10_4_PDEV_GET_AST_INFO_EVENTID,
+	WMI_10_4_PDEV_TEMPERATURE_EVENTID,
+	WMI_10_4_PDEV_NFCAL_POWER_ALL_CHANNELS_EVENTID,
+	WMI_10_4_PDEV_BSS_CHAN_INFO_EVENTID,
+	WMI_10_4_PDEV_UTF_EVENTID = WMI_10_4_END_EVENTID - 1,
+};
+
 enum wmi_phy_mode {
 	MODE_11A        = 0,   /* 11a Mode */
 	MODE_11G        = 1,   /* 11b/g Mode */
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
