Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:53485 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab3IYJi1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 05:38:27 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 02/13] ath10k: add wmi_10x_<cmd/event> definitions
Date: Wed, 25 Sep 2013 11:38:00 +0200
Message-ID: <1380101891-18312-3-git-send-email-bartosz.markowski@tieto.com> (sfid-20130925_113847_760519_745158A4)
In-Reply-To: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Introduce the cmd and events definitions for 10.X FW API
and make up the wmi_10x_cmd_map. This is the core of
host-firmware WMI interface for 10.X FW branch.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |  132 +++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.h |  215 ++++++++++++++++++++++++++++++++-
 2 files changed, 344 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 9cf426f..dd490b4 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -146,7 +146,133 @@ static struct wmi_cmd_map wmi_cmd_map = {
 	.wmi_gpio_output_cmdid = WMI_GPIO_OUTPUT_CMDID,
 };
 
-/* TODO: 10.X WMI cmd track */
+/* 10.X WMI cmd track */
+static struct wmi_cmd_map wmi_10x_cmd_map = {
+	.wmi_init_cmdid = WMI_10X_INIT_CMDID,
+	.wmi_start_scan_cmdid = WMI_10X_START_SCAN_CMDID,
+	.wmi_stop_scan_cmdid = WMI_10X_STOP_SCAN_CMDID,
+	.wmi_scan_chan_list_cmdid = WMI_10X_SCAN_CHAN_LIST_CMDID,
+	.wmi_scan_sch_prio_tbl_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_pdev_set_regdomain_cmdid = WMI_10X_PDEV_SET_REGDOMAIN_CMDID,
+	.wmi_pdev_set_channel_cmdid = WMI_10X_PDEV_SET_CHANNEL_CMDID,
+	.wmi_pdev_set_param_cmdid = WMI_10X_PDEV_SET_PARAM_CMDID,
+	.wmi_pdev_pktlog_enable_cmdid = WMI_10X_PDEV_PKTLOG_ENABLE_CMDID,
+	.wmi_pdev_pktlog_disable_cmdid = WMI_10X_PDEV_PKTLOG_DISABLE_CMDID,
+	.wmi_pdev_set_wmm_params_cmdid = WMI_10X_PDEV_SET_WMM_PARAMS_CMDID,
+	.wmi_pdev_set_ht_cap_ie_cmdid = WMI_10X_PDEV_SET_HT_CAP_IE_CMDID,
+	.wmi_pdev_set_vht_cap_ie_cmdid = WMI_10X_PDEV_SET_VHT_CAP_IE_CMDID,
+	.wmi_pdev_set_dscp_tid_map_cmdid =
+				WMI_10X_PDEV_SET_DSCP_TID_MAP_CMDID,
+	.wmi_pdev_set_quiet_mode_cmdid = WMI_10X_PDEV_SET_QUIET_MODE_CMDID,
+	.wmi_pdev_green_ap_ps_enable_cmdid =
+				WMI_10X_PDEV_GREEN_AP_PS_ENABLE_CMDID,
+	.wmi_pdev_get_tpc_config_cmdid = WMI_10X_PDEV_GET_TPC_CONFIG_CMDID,
+	.wmi_pdev_set_base_macaddr_cmdid =
+				WMI_10X_PDEV_SET_BASE_MACADDR_CMDID,
+	.wmi_vdev_create_cmdid = WMI_10X_VDEV_CREATE_CMDID,
+	.wmi_vdev_delete_cmdid = WMI_10X_VDEV_DELETE_CMDID,
+	.wmi_vdev_start_request_cmdid = WMI_10X_VDEV_START_REQUEST_CMDID,
+	.wmi_vdev_restart_request_cmdid = WMI_10X_VDEV_RESTART_REQUEST_CMDID,
+	.wmi_vdev_up_cmdid = WMI_10X_VDEV_UP_CMDID,
+	.wmi_vdev_stop_cmdid = WMI_10X_VDEV_STOP_CMDID,
+	.wmi_vdev_down_cmdid = WMI_10X_VDEV_DOWN_CMDID,
+	.wmi_vdev_set_param_cmdid = WMI_10X_VDEV_SET_PARAM_CMDID,
+	.wmi_vdev_install_key_cmdid = WMI_10X_VDEV_INSTALL_KEY_CMDID,
+	.wmi_peer_create_cmdid = WMI_10X_PEER_CREATE_CMDID,
+	.wmi_peer_delete_cmdid = WMI_10X_PEER_DELETE_CMDID,
+	.wmi_peer_flush_tids_cmdid = WMI_10X_PEER_FLUSH_TIDS_CMDID,
+	.wmi_peer_set_param_cmdid = WMI_10X_PEER_SET_PARAM_CMDID,
+	.wmi_peer_assoc_cmdid = WMI_10X_PEER_ASSOC_CMDID,
+	.wmi_peer_add_wds_entry_cmdid = WMI_10X_PEER_ADD_WDS_ENTRY_CMDID,
+	.wmi_peer_remove_wds_entry_cmdid =
+				WMI_10X_PEER_REMOVE_WDS_ENTRY_CMDID,
+	.wmi_peer_mcast_group_cmdid = WMI_10X_PEER_MCAST_GROUP_CMDID,
+	.wmi_bcn_tx_cmdid = WMI_10X_BCN_TX_CMDID,
+	.wmi_pdev_send_bcn_cmdid = WMI_10X_PDEV_SEND_BCN_CMDID,
+	.wmi_bcn_tmpl_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_bcn_filter_rx_cmdid = WMI_10X_BCN_FILTER_RX_CMDID,
+	.wmi_prb_req_filter_rx_cmdid = WMI_10X_PRB_REQ_FILTER_RX_CMDID,
+	.wmi_mgmt_tx_cmdid = WMI_10X_MGMT_TX_CMDID,
+	.wmi_prb_tmpl_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_addba_clear_resp_cmdid = WMI_10X_ADDBA_CLEAR_RESP_CMDID,
+	.wmi_addba_send_cmdid = WMI_10X_ADDBA_SEND_CMDID,
+	.wmi_addba_status_cmdid = WMI_10X_ADDBA_STATUS_CMDID,
+	.wmi_delba_send_cmdid = WMI_10X_DELBA_SEND_CMDID,
+	.wmi_addba_set_resp_cmdid = WMI_10X_ADDBA_SET_RESP_CMDID,
+	.wmi_send_singleamsdu_cmdid = WMI_10X_SEND_SINGLEAMSDU_CMDID,
+	.wmi_sta_powersave_mode_cmdid = WMI_10X_STA_POWERSAVE_MODE_CMDID,
+	.wmi_sta_powersave_param_cmdid = WMI_10X_STA_POWERSAVE_PARAM_CMDID,
+	.wmi_sta_mimo_ps_mode_cmdid = WMI_10X_STA_MIMO_PS_MODE_CMDID,
+	.wmi_pdev_dfs_enable_cmdid = WMI_10X_PDEV_DFS_ENABLE_CMDID,
+	.wmi_pdev_dfs_disable_cmdid = WMI_10X_PDEV_DFS_DISABLE_CMDID,
+	.wmi_roam_scan_mode = WMI_10X_ROAM_SCAN_MODE,
+	.wmi_roam_scan_rssi_threshold = WMI_10X_ROAM_SCAN_RSSI_THRESHOLD,
+	.wmi_roam_scan_period = WMI_10X_ROAM_SCAN_PERIOD,
+	.wmi_roam_scan_rssi_change_threshold
+				= WMI_10X_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
+	.wmi_roam_ap_profile = WMI_10X_ROAM_AP_PROFILE,
+	.wmi_ofl_scan_add_ap_profile = WMI_10X_OFL_SCAN_ADD_AP_PROFILE,
+	.wmi_ofl_scan_remove_ap_profile = WMI_10X_OFL_SCAN_REMOVE_AP_PROFILE,
+	.wmi_ofl_scan_period = WMI_10X_OFL_SCAN_PERIOD,
+	.wmi_p2p_dev_set_device_info = WMI_10X_P2P_DEV_SET_DEVICE_INFO,
+	.wmi_p2p_dev_set_discoverability =
+					WMI_10X_P2P_DEV_SET_DISCOVERABILITY,
+	.wmi_p2p_go_set_beacon_ie = WMI_10X_P2P_GO_SET_BEACON_IE,
+	.wmi_p2p_go_set_probe_resp_ie = WMI_10X_P2P_GO_SET_PROBE_RESP_IE,
+	.wmi_p2p_set_vendor_ie_data_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_ap_ps_peer_param_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_ap_ps_peer_uapsd_coex_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_peer_rate_retry_sched_cmdid =
+					WMI_10X_PEER_RATE_RETRY_SCHED_CMDID,
+	.wmi_wlan_profile_trigger_cmdid = WMI_10X_WLAN_PROFILE_TRIGGER_CMDID,
+	.wmi_wlan_profile_set_hist_intvl_cmdid =
+				WMI_10X_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
+	.wmi_wlan_profile_get_profile_data_cmdid =
+				WMI_10X_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
+	.wmi_wlan_profile_enable_profile_id_cmdid =
+				WMI_10X_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
+	.wmi_wlan_profile_list_profile_id_cmdid =
+				WMI_10X_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
+	.wmi_pdev_suspend_cmdid = WMI_10X_PDEV_SUSPEND_CMDID,
+	.wmi_pdev_resume_cmdid = WMI_10X_PDEV_RESUME_CMDID,
+	.wmi_add_bcn_filter_cmdid = WMI_10X_ADD_BCN_FILTER_CMDID,
+	.wmi_rmv_bcn_filter_cmdid = WMI_10X_RMV_BCN_FILTER_CMDID,
+	.wmi_wow_add_wake_pattern_cmdid = WMI_10X_WOW_ADD_WAKE_PATTERN_CMDID,
+	.wmi_wow_del_wake_pattern_cmdid = WMI_10X_WOW_DEL_WAKE_PATTERN_CMDID,
+	.wmi_wow_enable_disable_wake_event_cmdid =
+				WMI_10X_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
+	.wmi_wow_enable_cmdid = WMI_10X_WOW_ENABLE_CMDID,
+	.wmi_wow_hostwakeup_from_sleep_cmdid =
+				WMI_10X_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
+	.wmi_rtt_measreq_cmdid = WMI_10X_RTT_MEASREQ_CMDID,
+	.wmi_rtt_tsf_cmdid = WMI_10X_RTT_TSF_CMDID,
+	.wmi_vdev_spectral_scan_configure_cmdid =
+				WMI_10X_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
+	.wmi_vdev_spectral_scan_enable_cmdid =
+				WMI_10X_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
+	.wmi_request_stats_cmdid = WMI_10X_REQUEST_STATS_CMDID,
+	.wmi_set_arp_ns_offload_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_network_list_offload_config_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_gtk_offload_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_csa_offload_enable_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_csa_offload_chanswitch_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_chatter_set_mode_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_peer_tid_addba_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_peer_tid_delba_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_sta_dtim_ps_method_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_sta_uapsd_auto_trig_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_sta_keepalive_cmd = WMI_CMD_UNDEFINED,
+	.wmi_echo_cmdid = WMI_10X_ECHO_CMDID,
+	.wmi_pdev_utf_cmdid = WMI_10X_PDEV_UTF_CMDID,
+	.wmi_dbglog_cfg_cmdid = WMI_10X_DBGLOG_CFG_CMDID,
+	.wmi_pdev_qvit_cmdid = WMI_10X_PDEV_QVIT_CMDID,
+	.wmi_pdev_ftm_intg_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_vdev_set_keepalive_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_vdev_get_keepalive_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_force_fw_hang_cmdid = WMI_CMD_UNDEFINED,
+	.wmi_gpio_config_cmdid = WMI_10X_GPIO_CONFIG_CMDID,
+	.wmi_gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
+};
 
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
@@ -1310,13 +1436,15 @@ static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 /* WMI Initialization functions */
 int ath10k_wmi_attach(struct ath10k *ar)
 {
-	int ret = 0;
+	int ret;
 
 	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features)) {
 		ath10k_warn("Firmware 10.X is not yet supported\n");
+		ar->wmi.cmd = &wmi_10x_cmd_map;
 		ret = -ENOTSUPP;
 	} else {
 		ar->wmi.cmd = &wmi_cmd_map;
+		ret = 0;
 	}
 
 	init_completion(&ar->wmi.service_ready);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 94fc008..c23d070 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -359,7 +359,9 @@ enum wmi_cmd_group {
 #define WMI_CMD_GRP(grp_id) (((grp_id) << 12) | 0x1)
 #define WMI_EVT_GRP_START_ID(grp_id) (((grp_id) << 12) | 0x1)
 
-/* Command IDs and commande events. */
+#define WMI_CMD_UNDEFINED 0
+
+/* Command IDs and command events for MAIN FW. */
 enum wmi_cmd_id {
 	WMI_INIT_CMDID = 0x1,
 
@@ -600,6 +602,217 @@ enum wmi_event_id {
 	WMI_GPIO_INPUT_EVENTID = WMI_EVT_GRP_START_ID(WMI_GRP_GPIO),
 };
 
+/* Command IDs and command events for 10.X firmware */
+enum wmi_10x_cmd_id {
+	WMI_10X_START_CMDID = 0x9000,
+	WMI_10X_END_CMDID = 0x9FFF,
+
+	/* initialize the wlan sub system */
+	WMI_10X_INIT_CMDID,
+
+	/* Scan specific commands */
+
+	WMI_10X_START_SCAN_CMDID = WMI_10X_START_CMDID,
+	WMI_10X_STOP_SCAN_CMDID,
+	WMI_10X_SCAN_CHAN_LIST_CMDID,
+	WMI_10X_ECHO_CMDID,
+
+	/* PDEV(physical device) specific commands */
+	WMI_10X_PDEV_SET_REGDOMAIN_CMDID,
+	WMI_10X_PDEV_SET_CHANNEL_CMDID,
+	WMI_10X_PDEV_SET_PARAM_CMDID,
+	WMI_10X_PDEV_PKTLOG_ENABLE_CMDID,
+	WMI_10X_PDEV_PKTLOG_DISABLE_CMDID,
+	WMI_10X_PDEV_SET_WMM_PARAMS_CMDID,
+	WMI_10X_PDEV_SET_HT_CAP_IE_CMDID,
+	WMI_10X_PDEV_SET_VHT_CAP_IE_CMDID,
+	WMI_10X_PDEV_SET_BASE_MACADDR_CMDID,
+	WMI_10X_PDEV_SET_DSCP_TID_MAP_CMDID,
+	WMI_10X_PDEV_SET_QUIET_MODE_CMDID,
+	WMI_10X_PDEV_GREEN_AP_PS_ENABLE_CMDID,
+	WMI_10X_PDEV_GET_TPC_CONFIG_CMDID,
+
+	/* VDEV(virtual device) specific commands */
+	WMI_10X_VDEV_CREATE_CMDID,
+	WMI_10X_VDEV_DELETE_CMDID,
+	WMI_10X_VDEV_START_REQUEST_CMDID,
+	WMI_10X_VDEV_RESTART_REQUEST_CMDID,
+	WMI_10X_VDEV_UP_CMDID,
+	WMI_10X_VDEV_STOP_CMDID,
+	WMI_10X_VDEV_DOWN_CMDID,
+	WMI_10X_VDEV_STANDBY_RESPONSE_CMDID,
+	WMI_10X_VDEV_RESUME_RESPONSE_CMDID,
+	WMI_10X_VDEV_SET_PARAM_CMDID,
+	WMI_10X_VDEV_INSTALL_KEY_CMDID,
+
+	/* peer specific commands */
+	WMI_10X_PEER_CREATE_CMDID,
+	WMI_10X_PEER_DELETE_CMDID,
+	WMI_10X_PEER_FLUSH_TIDS_CMDID,
+	WMI_10X_PEER_SET_PARAM_CMDID,
+	WMI_10X_PEER_ASSOC_CMDID,
+	WMI_10X_PEER_ADD_WDS_ENTRY_CMDID,
+	WMI_10X_PEER_REMOVE_WDS_ENTRY_CMDID,
+	WMI_10X_PEER_MCAST_GROUP_CMDID,
+
+	/* beacon/management specific commands */
+
+	WMI_10X_BCN_TX_CMDID,
+	WMI_10X_BCN_PRB_TMPL_CMDID,
+	WMI_10X_BCN_FILTER_RX_CMDID,
+	WMI_10X_PRB_REQ_FILTER_RX_CMDID,
+	WMI_10X_MGMT_TX_CMDID,
+
+	/* commands to directly control ba negotiation directly from host. */
+	WMI_10X_ADDBA_CLEAR_RESP_CMDID,
+	WMI_10X_ADDBA_SEND_CMDID,
+	WMI_10X_ADDBA_STATUS_CMDID,
+	WMI_10X_DELBA_SEND_CMDID,
+	WMI_10X_ADDBA_SET_RESP_CMDID,
+	WMI_10X_SEND_SINGLEAMSDU_CMDID,
+
+	/* Station power save specific config */
+	WMI_10X_STA_POWERSAVE_MODE_CMDID,
+	WMI_10X_STA_POWERSAVE_PARAM_CMDID,
+	WMI_10X_STA_MIMO_PS_MODE_CMDID,
+
+	/* set debug log config */
+	WMI_10X_DBGLOG_CFG_CMDID,
+
+	/* DFS-specific commands */
+	WMI_10X_PDEV_DFS_ENABLE_CMDID,
+	WMI_10X_PDEV_DFS_DISABLE_CMDID,
+
+	/* QVIT specific command id */
+	WMI_10X_PDEV_QVIT_CMDID,
+
+	/* Offload Scan and Roaming related  commands */
+	WMI_10X_ROAM_SCAN_MODE,
+	WMI_10X_ROAM_SCAN_RSSI_THRESHOLD,
+	WMI_10X_ROAM_SCAN_PERIOD,
+	WMI_10X_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
+	WMI_10X_ROAM_AP_PROFILE,
+	WMI_10X_OFL_SCAN_ADD_AP_PROFILE,
+	WMI_10X_OFL_SCAN_REMOVE_AP_PROFILE,
+	WMI_10X_OFL_SCAN_PERIOD,
+
+	/* P2P specific commands */
+	WMI_10X_P2P_DEV_SET_DEVICE_INFO,
+	WMI_10X_P2P_DEV_SET_DISCOVERABILITY,
+	WMI_10X_P2P_GO_SET_BEACON_IE,
+	WMI_10X_P2P_GO_SET_PROBE_RESP_IE,
+
+	/* AP power save specific config */
+	WMI_10X_AP_PS_PEER_PARAM_CMDID,
+	WMI_10X_AP_PS_PEER_UAPSD_COEX_CMDID,
+
+	/* Rate-control specific commands */
+	WMI_10X_PEER_RATE_RETRY_SCHED_CMDID,
+
+	/* WLAN Profiling commands. */
+	WMI_10X_WLAN_PROFILE_TRIGGER_CMDID,
+	WMI_10X_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
+	WMI_10X_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
+	WMI_10X_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
+	WMI_10X_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
+
+	/* Suspend resume command Ids */
+	WMI_10X_PDEV_SUSPEND_CMDID,
+	WMI_10X_PDEV_RESUME_CMDID,
+
+	/* Beacon filter commands */
+	WMI_10X_ADD_BCN_FILTER_CMDID,
+	WMI_10X_RMV_BCN_FILTER_CMDID,
+
+	/* WOW Specific WMI commands*/
+	WMI_10X_WOW_ADD_WAKE_PATTERN_CMDID,
+	WMI_10X_WOW_DEL_WAKE_PATTERN_CMDID,
+	WMI_10X_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
+	WMI_10X_WOW_ENABLE_CMDID,
+	WMI_10X_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
+
+	/* RTT measurement related cmd */
+	WMI_10X_RTT_MEASREQ_CMDID,
+	WMI_10X_RTT_TSF_CMDID,
+
+	/* transmit beacon by value */
+	WMI_10X_PDEV_SEND_BCN_CMDID,
+
+	/* F/W stats */
+	WMI_10X_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
+	WMI_10X_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
+	WMI_10X_REQUEST_STATS_CMDID,
+
+	/* GPIO Configuration */
+	WMI_10X_GPIO_CONFIG_CMDID,
+	WMI_10X_GPIO_OUTPUT_CMDID,
+
+	WMI_10X_PDEV_UTF_CMDID = WMI_10X_END_CMDID - 1,
+};
+
+enum wmi_10x_event_id {
+	WMI_10X_SERVICE_READY_EVENTID = 0x8000,
+	WMI_10X_READY_EVENTID,
+	WMI_10X_START_EVENTID = 0x9000,
+	WMI_10X_END_EVENTID = 0x9FFF,
+
+	/* Scan specific events */
+	WMI_10X_SCAN_EVENTID = WMI_10X_START_EVENTID,
+	WMI_10X_ECHO_EVENTID,
+	WMI_10X_DEBUG_MESG_EVENTID,
+	WMI_10X_UPDATE_STATS_EVENTID,
+
+	/* Instantaneous RSSI event */
+	WMI_10X_INST_RSSI_STATS_EVENTID,
+
+	/* VDEV specific events */
+	WMI_10X_VDEV_START_RESP_EVENTID,
+	WMI_10X_VDEV_STANDBY_REQ_EVENTID,
+	WMI_10X_VDEV_RESUME_REQ_EVENTID,
+	WMI_10X_VDEV_STOPPED_EVENTID,
+
+	/* peer  specific events */
+	WMI_10X_PEER_STA_KICKOUT_EVENTID,
+
+	/* beacon/mgmt specific events */
+	WMI_10X_HOST_SWBA_EVENTID,
+	WMI_10X_TBTTOFFSET_UPDATE_EVENTID,
+	WMI_10X_MGMT_RX_EVENTID,
+
+	/* Channel stats event */
+	WMI_10X_CHAN_INFO_EVENTID,
+
+	/* PHY Error specific WMI event */
+	WMI_10X_PHYERR_EVENTID,
+
+	/* Roam event to trigger roaming on host */
+	WMI_10X_ROAM_EVENTID,
+
+	/* matching AP found from list of profiles */
+	WMI_10X_PROFILE_MATCH,
+
+	/* debug print message used for tracing FW code while debugging */
+	WMI_10X_DEBUG_PRINT_EVENTID,
+	/* VI spoecific event */
+	WMI_10X_PDEV_QVIT_EVENTID,
+	/* FW code profile data in response to profile request */
+	WMI_10X_WLAN_PROFILE_DATA_EVENTID,
+
+	/*RTT related event ID*/
+	WMI_10X_RTT_MEASUREMENT_REPORT_EVENTID,
+	WMI_10X_TSF_MEASUREMENT_REPORT_EVENTID,
+	WMI_10X_RTT_ERROR_REPORT_EVENTID,
+
+	WMI_10X_WOW_WAKEUP_HOST_EVENTID,
+	WMI_10X_DCS_INTERFERENCE_EVENTID,
+
+	/* TPC config for the current operating channel */
+	WMI_10X_PDEV_TPC_CONFIG_EVENTID,
+
+	WMI_10X_GPIO_INPUT_EVENTID,
+	WMI_10X_PDEV_UTF_EVENTID = WMI_10X_END_EVENTID-1,
+};
+
 enum wmi_phy_mode {
 	MODE_11A        = 0,   /* 11a Mode */
 	MODE_11G        = 1,   /* 11b/g Mode */
-- 
1.7.10

