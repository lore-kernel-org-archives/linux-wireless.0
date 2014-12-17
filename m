Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6081 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751714AbaLQKVf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Dec 2014 05:21:35 -0500
Subject: [PATCH v2 4/8] ath10k: add 10.2.4 firmware support
To: <ath10k@lists.infradead.org>
From: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Date: Wed, 17 Dec 2014 12:21:12 +0200
Message-ID: <20141217102112.15964.34656.stgit@potku.adurom.net> (sfid-20141217_112139_591947_7C513F57)
In-Reply-To: <20141217101755.15964.2625.stgit@potku.adurom.net>
References: <20141217101755.15964.2625.stgit@potku.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

10.2.4 firmware uses bitmask in wmi_resource_config to configure
10.2 firmware features like airtime fairness and rx batch mode instead
of maintaining separete bool entry. This allows new features that can be
configure during init time without breaking backward compatibility.

kvalo: use WMI op version, bump up FW API to 4 to not break older versions of
ath10k

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   11 +
 drivers/net/wireless/ath/ath10k/hw.h   |    4 
 drivers/net/wireless/ath/ath10k/mac.c  |    1 
 drivers/net/wireless/ath/ath10k/wmi.c  |  291 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h  |    7 +
 5 files changed, 312 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index f17366620fde..45bca513719e 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -690,6 +690,13 @@ static int ath10k_core_fetch_firmware_files(struct ath10k *ar)
 	/* calibration file is optional, don't check for any errors */
 	ath10k_fetch_cal_file(ar);
 
+	ar->fw_api = 4;
+	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
+
+	ret = ath10k_core_fetch_firmware_api_n(ar, ATH10K_FW_API4_FILE);
+	if (ret == 0)
+		goto success;
+
 	ar->fw_api = 3;
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "trying fw api %d\n", ar->fw_api);
 
@@ -894,7 +901,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 	 */
 	if (ar->wmi.op_version == ATH10K_FW_WMI_OP_VERSION_UNSET) {
 		if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
-			if (test_bit(ATH10K_FW_FEATURE_WMI_10_2, ar->fw_features))
+			if (test_bit(ATH10K_FW_FEATURE_WMI_10_2,
+				     ar->fw_features))
 				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_2;
 			else
 				ar->wmi.op_version = ATH10K_FW_WMI_OP_VERSION_10_1;
@@ -912,6 +920,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
+	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->max_num_peers = TARGET_10X_NUM_PEERS;
 		ar->max_num_stations = TARGET_10X_NUM_STATIONS;
 		ar->max_num_vdevs = TARGET_10X_NUM_VDEVS;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 809c2521adb3..5729901923ac 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -37,6 +37,9 @@
 #define ATH10K_FW_API2_FILE		"firmware-2.bin"
 #define ATH10K_FW_API3_FILE		"firmware-3.bin"
 
+/* added support for ATH10K_FW_IE_WMI_OP_VERSION */
+#define ATH10K_FW_API4_FILE		"firmware-4.bin"
+
 #define ATH10K_FW_UTF_FILE		"utf.bin"
 
 /* includes also the null byte */
@@ -72,6 +75,7 @@ enum ath10k_fw_wmi_op_version {
 	ATH10K_FW_WMI_OP_VERSION_10_1 = 2,
 	ATH10K_FW_WMI_OP_VERSION_10_2 = 3,
 	ATH10K_FW_WMI_OP_VERSION_TLV = 4,
+	ATH10K_FW_WMI_OP_VERSION_10_2_4 = 5,
 
 	/* keep last */
 	ATH10K_FW_WMI_OP_VERSION_MAX,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 4576d758d50b..658b83e288ee 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5074,6 +5074,7 @@ int ath10k_mac_register(struct ath10k *ar)
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
+	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_10x_if_comb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fa486f69cce7..cf9c727dc7d3 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -269,6 +269,127 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
 };
 
+/* 10.2.4 WMI cmd track */
+static struct wmi_cmd_map wmi_10_2_4_cmd_map = {
+	.init_cmdid = WMI_10_2_INIT_CMDID,
+	.start_scan_cmdid = WMI_10_2_START_SCAN_CMDID,
+	.stop_scan_cmdid = WMI_10_2_STOP_SCAN_CMDID,
+	.scan_chan_list_cmdid = WMI_10_2_SCAN_CHAN_LIST_CMDID,
+	.scan_sch_prio_tbl_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_regdomain_cmdid = WMI_10_2_PDEV_SET_REGDOMAIN_CMDID,
+	.pdev_set_channel_cmdid = WMI_10_2_PDEV_SET_CHANNEL_CMDID,
+	.pdev_set_param_cmdid = WMI_10_2_PDEV_SET_PARAM_CMDID,
+	.pdev_pktlog_enable_cmdid = WMI_10_2_PDEV_PKTLOG_ENABLE_CMDID,
+	.pdev_pktlog_disable_cmdid = WMI_10_2_PDEV_PKTLOG_DISABLE_CMDID,
+	.pdev_set_wmm_params_cmdid = WMI_10_2_PDEV_SET_WMM_PARAMS_CMDID,
+	.pdev_set_ht_cap_ie_cmdid = WMI_10_2_PDEV_SET_HT_CAP_IE_CMDID,
+	.pdev_set_vht_cap_ie_cmdid = WMI_10_2_PDEV_SET_VHT_CAP_IE_CMDID,
+	.pdev_set_quiet_mode_cmdid = WMI_10_2_PDEV_SET_QUIET_MODE_CMDID,
+	.pdev_green_ap_ps_enable_cmdid = WMI_10_2_PDEV_GREEN_AP_PS_ENABLE_CMDID,
+	.pdev_get_tpc_config_cmdid = WMI_10_2_PDEV_GET_TPC_CONFIG_CMDID,
+	.pdev_set_base_macaddr_cmdid = WMI_10_2_PDEV_SET_BASE_MACADDR_CMDID,
+	.vdev_create_cmdid = WMI_10_2_VDEV_CREATE_CMDID,
+	.vdev_delete_cmdid = WMI_10_2_VDEV_DELETE_CMDID,
+	.vdev_start_request_cmdid = WMI_10_2_VDEV_START_REQUEST_CMDID,
+	.vdev_restart_request_cmdid = WMI_10_2_VDEV_RESTART_REQUEST_CMDID,
+	.vdev_up_cmdid = WMI_10_2_VDEV_UP_CMDID,
+	.vdev_stop_cmdid = WMI_10_2_VDEV_STOP_CMDID,
+	.vdev_down_cmdid = WMI_10_2_VDEV_DOWN_CMDID,
+	.vdev_set_param_cmdid = WMI_10_2_VDEV_SET_PARAM_CMDID,
+	.vdev_install_key_cmdid = WMI_10_2_VDEV_INSTALL_KEY_CMDID,
+	.peer_create_cmdid = WMI_10_2_PEER_CREATE_CMDID,
+	.peer_delete_cmdid = WMI_10_2_PEER_DELETE_CMDID,
+	.peer_flush_tids_cmdid = WMI_10_2_PEER_FLUSH_TIDS_CMDID,
+	.peer_set_param_cmdid = WMI_10_2_PEER_SET_PARAM_CMDID,
+	.peer_assoc_cmdid = WMI_10_2_PEER_ASSOC_CMDID,
+	.peer_add_wds_entry_cmdid = WMI_10_2_PEER_ADD_WDS_ENTRY_CMDID,
+	.peer_remove_wds_entry_cmdid = WMI_10_2_PEER_REMOVE_WDS_ENTRY_CMDID,
+	.peer_mcast_group_cmdid = WMI_10_2_PEER_MCAST_GROUP_CMDID,
+	.bcn_tx_cmdid = WMI_10_2_BCN_TX_CMDID,
+	.pdev_send_bcn_cmdid = WMI_10_2_PDEV_SEND_BCN_CMDID,
+	.bcn_tmpl_cmdid = WMI_CMD_UNSUPPORTED,
+	.bcn_filter_rx_cmdid = WMI_10_2_BCN_FILTER_RX_CMDID,
+	.prb_req_filter_rx_cmdid = WMI_10_2_PRB_REQ_FILTER_RX_CMDID,
+	.mgmt_tx_cmdid = WMI_10_2_MGMT_TX_CMDID,
+	.prb_tmpl_cmdid = WMI_CMD_UNSUPPORTED,
+	.addba_clear_resp_cmdid = WMI_10_2_ADDBA_CLEAR_RESP_CMDID,
+	.addba_send_cmdid = WMI_10_2_ADDBA_SEND_CMDID,
+	.addba_status_cmdid = WMI_10_2_ADDBA_STATUS_CMDID,
+	.delba_send_cmdid = WMI_10_2_DELBA_SEND_CMDID,
+	.addba_set_resp_cmdid = WMI_10_2_ADDBA_SET_RESP_CMDID,
+	.send_singleamsdu_cmdid = WMI_10_2_SEND_SINGLEAMSDU_CMDID,
+	.sta_powersave_mode_cmdid = WMI_10_2_STA_POWERSAVE_MODE_CMDID,
+	.sta_powersave_param_cmdid = WMI_10_2_STA_POWERSAVE_PARAM_CMDID,
+	.sta_mimo_ps_mode_cmdid = WMI_10_2_STA_MIMO_PS_MODE_CMDID,
+	.pdev_dfs_enable_cmdid = WMI_10_2_PDEV_DFS_ENABLE_CMDID,
+	.pdev_dfs_disable_cmdid = WMI_10_2_PDEV_DFS_DISABLE_CMDID,
+	.roam_scan_mode = WMI_10_2_ROAM_SCAN_MODE,
+	.roam_scan_rssi_threshold = WMI_10_2_ROAM_SCAN_RSSI_THRESHOLD,
+	.roam_scan_period = WMI_10_2_ROAM_SCAN_PERIOD,
+	.roam_scan_rssi_change_threshold =
+				WMI_10_2_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
+	.roam_ap_profile = WMI_10_2_ROAM_AP_PROFILE,
+	.ofl_scan_add_ap_profile = WMI_10_2_OFL_SCAN_ADD_AP_PROFILE,
+	.ofl_scan_remove_ap_profile = WMI_10_2_OFL_SCAN_REMOVE_AP_PROFILE,
+	.ofl_scan_period = WMI_10_2_OFL_SCAN_PERIOD,
+	.p2p_dev_set_device_info = WMI_10_2_P2P_DEV_SET_DEVICE_INFO,
+	.p2p_dev_set_discoverability = WMI_10_2_P2P_DEV_SET_DISCOVERABILITY,
+	.p2p_go_set_beacon_ie = WMI_10_2_P2P_GO_SET_BEACON_IE,
+	.p2p_go_set_probe_resp_ie = WMI_10_2_P2P_GO_SET_PROBE_RESP_IE,
+	.p2p_set_vendor_ie_data_cmdid = WMI_CMD_UNSUPPORTED,
+	.ap_ps_peer_param_cmdid = WMI_10_2_AP_PS_PEER_PARAM_CMDID,
+	.ap_ps_peer_uapsd_coex_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_rate_retry_sched_cmdid = WMI_10_2_PEER_RATE_RETRY_SCHED_CMDID,
+	.wlan_profile_trigger_cmdid = WMI_10_2_WLAN_PROFILE_TRIGGER_CMDID,
+	.wlan_profile_set_hist_intvl_cmdid =
+				WMI_10_2_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
+	.wlan_profile_get_profile_data_cmdid =
+				WMI_10_2_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
+	.wlan_profile_enable_profile_id_cmdid =
+				WMI_10_2_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
+	.wlan_profile_list_profile_id_cmdid =
+				WMI_10_2_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
+	.pdev_suspend_cmdid = WMI_10_2_PDEV_SUSPEND_CMDID,
+	.pdev_resume_cmdid = WMI_10_2_PDEV_RESUME_CMDID,
+	.add_bcn_filter_cmdid = WMI_10_2_ADD_BCN_FILTER_CMDID,
+	.rmv_bcn_filter_cmdid = WMI_10_2_RMV_BCN_FILTER_CMDID,
+	.wow_add_wake_pattern_cmdid = WMI_10_2_WOW_ADD_WAKE_PATTERN_CMDID,
+	.wow_del_wake_pattern_cmdid = WMI_10_2_WOW_DEL_WAKE_PATTERN_CMDID,
+	.wow_enable_disable_wake_event_cmdid =
+				WMI_10_2_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
+	.wow_enable_cmdid = WMI_10_2_WOW_ENABLE_CMDID,
+	.wow_hostwakeup_from_sleep_cmdid =
+				WMI_10_2_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
+	.rtt_measreq_cmdid = WMI_10_2_RTT_MEASREQ_CMDID,
+	.rtt_tsf_cmdid = WMI_10_2_RTT_TSF_CMDID,
+	.vdev_spectral_scan_configure_cmdid =
+				WMI_10_2_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
+	.vdev_spectral_scan_enable_cmdid =
+				WMI_10_2_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
+	.request_stats_cmdid = WMI_10_2_REQUEST_STATS_CMDID,
+	.set_arp_ns_offload_cmdid = WMI_CMD_UNSUPPORTED,
+	.network_list_offload_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.gtk_offload_cmdid = WMI_CMD_UNSUPPORTED,
+	.csa_offload_enable_cmdid = WMI_CMD_UNSUPPORTED,
+	.csa_offload_chanswitch_cmdid = WMI_CMD_UNSUPPORTED,
+	.chatter_set_mode_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_tid_addba_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_tid_delba_cmdid = WMI_CMD_UNSUPPORTED,
+	.sta_dtim_ps_method_cmdid = WMI_CMD_UNSUPPORTED,
+	.sta_uapsd_auto_trig_cmdid = WMI_CMD_UNSUPPORTED,
+	.sta_keepalive_cmd = WMI_CMD_UNSUPPORTED,
+	.echo_cmdid = WMI_10_2_ECHO_CMDID,
+	.pdev_utf_cmdid = WMI_10_2_PDEV_UTF_CMDID,
+	.dbglog_cfg_cmdid = WMI_10_2_DBGLOG_CFG_CMDID,
+	.pdev_qvit_cmdid = WMI_10_2_PDEV_QVIT_CMDID,
+	.pdev_ftm_intg_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_set_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_get_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.force_fw_hang_cmdid = WMI_CMD_UNSUPPORTED,
+	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
+	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
+};
+
 /* MAIN WMI VDEV param map */
 static struct wmi_vdev_param_map wmi_vdev_param_map = {
 	.rts_threshold = WMI_VDEV_PARAM_RTS_THRESHOLD,
@@ -387,6 +508,64 @@ static struct wmi_vdev_param_map wmi_10x_vdev_param_map = {
 		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
 };
 
+static struct wmi_vdev_param_map wmi_10_2_4_vdev_param_map = {
+	.rts_threshold = WMI_10X_VDEV_PARAM_RTS_THRESHOLD,
+	.fragmentation_threshold = WMI_10X_VDEV_PARAM_FRAGMENTATION_THRESHOLD,
+	.beacon_interval = WMI_10X_VDEV_PARAM_BEACON_INTERVAL,
+	.listen_interval = WMI_10X_VDEV_PARAM_LISTEN_INTERVAL,
+	.multicast_rate = WMI_10X_VDEV_PARAM_MULTICAST_RATE,
+	.mgmt_tx_rate = WMI_10X_VDEV_PARAM_MGMT_TX_RATE,
+	.slot_time = WMI_10X_VDEV_PARAM_SLOT_TIME,
+	.preamble = WMI_10X_VDEV_PARAM_PREAMBLE,
+	.swba_time = WMI_10X_VDEV_PARAM_SWBA_TIME,
+	.wmi_vdev_stats_update_period = WMI_10X_VDEV_STATS_UPDATE_PERIOD,
+	.wmi_vdev_pwrsave_ageout_time = WMI_10X_VDEV_PWRSAVE_AGEOUT_TIME,
+	.wmi_vdev_host_swba_interval = WMI_10X_VDEV_HOST_SWBA_INTERVAL,
+	.dtim_period = WMI_10X_VDEV_PARAM_DTIM_PERIOD,
+	.wmi_vdev_oc_scheduler_air_time_limit =
+				WMI_10X_VDEV_OC_SCHEDULER_AIR_TIME_LIMIT,
+	.wds = WMI_10X_VDEV_PARAM_WDS,
+	.atim_window = WMI_10X_VDEV_PARAM_ATIM_WINDOW,
+	.bmiss_count_max = WMI_10X_VDEV_PARAM_BMISS_COUNT_MAX,
+	.bmiss_first_bcnt = WMI_VDEV_PARAM_UNSUPPORTED,
+	.bmiss_final_bcnt = WMI_VDEV_PARAM_UNSUPPORTED,
+	.feature_wmm = WMI_10X_VDEV_PARAM_FEATURE_WMM,
+	.chwidth = WMI_10X_VDEV_PARAM_CHWIDTH,
+	.chextoffset = WMI_10X_VDEV_PARAM_CHEXTOFFSET,
+	.disable_htprotection = WMI_10X_VDEV_PARAM_DISABLE_HTPROTECTION,
+	.sta_quickkickout = WMI_10X_VDEV_PARAM_STA_QUICKKICKOUT,
+	.mgmt_rate = WMI_10X_VDEV_PARAM_MGMT_RATE,
+	.protection_mode = WMI_10X_VDEV_PARAM_PROTECTION_MODE,
+	.fixed_rate = WMI_10X_VDEV_PARAM_FIXED_RATE,
+	.sgi = WMI_10X_VDEV_PARAM_SGI,
+	.ldpc = WMI_10X_VDEV_PARAM_LDPC,
+	.tx_stbc = WMI_10X_VDEV_PARAM_TX_STBC,
+	.rx_stbc = WMI_10X_VDEV_PARAM_RX_STBC,
+	.intra_bss_fwd = WMI_10X_VDEV_PARAM_INTRA_BSS_FWD,
+	.def_keyid = WMI_10X_VDEV_PARAM_DEF_KEYID,
+	.nss = WMI_10X_VDEV_PARAM_NSS,
+	.bcast_data_rate = WMI_10X_VDEV_PARAM_BCAST_DATA_RATE,
+	.mcast_data_rate = WMI_10X_VDEV_PARAM_MCAST_DATA_RATE,
+	.mcast_indicate = WMI_10X_VDEV_PARAM_MCAST_INDICATE,
+	.dhcp_indicate = WMI_10X_VDEV_PARAM_DHCP_INDICATE,
+	.unknown_dest_indicate = WMI_10X_VDEV_PARAM_UNKNOWN_DEST_INDICATE,
+	.ap_keepalive_min_idle_inactive_time_secs =
+		WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MIN_IDLE_INACTIVE_TIME_SECS,
+	.ap_keepalive_max_idle_inactive_time_secs =
+		WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MAX_IDLE_INACTIVE_TIME_SECS,
+	.ap_keepalive_max_unresponsive_time_secs =
+		WMI_10X_VDEV_PARAM_AP_KEEPALIVE_MAX_UNRESPONSIVE_TIME_SECS,
+	.ap_enable_nawds = WMI_10X_VDEV_PARAM_AP_ENABLE_NAWDS,
+	.mcast2ucast_set = WMI_10X_VDEV_PARAM_MCAST2UCAST_SET,
+	.enable_rtscts = WMI_10X_VDEV_PARAM_ENABLE_RTSCTS,
+	.txbf = WMI_VDEV_PARAM_UNSUPPORTED,
+	.packet_powersave = WMI_VDEV_PARAM_UNSUPPORTED,
+	.drop_unencry = WMI_VDEV_PARAM_UNSUPPORTED,
+	.tx_encap_type = WMI_VDEV_PARAM_UNSUPPORTED,
+	.ap_detect_out_of_sync_sleeping_sta_time_secs =
+		WMI_10X_VDEV_PARAM_AP_DETECT_OUT_OF_SYNC_SLEEPING_STA_TIME_SECS,
+};
+
 static struct wmi_pdev_param_map wmi_pdev_param_map = {
 	.tx_chain_mask = WMI_PDEV_PARAM_TX_CHAIN_MASK,
 	.rx_chain_mask = WMI_PDEV_PARAM_RX_CHAIN_MASK,
@@ -492,6 +671,59 @@ static struct wmi_pdev_param_map wmi_10x_pdev_param_map = {
 	.cal_period = WMI_10X_PDEV_PARAM_CAL_PERIOD,
 };
 
+static struct wmi_pdev_param_map wmi_10_2_4_pdev_param_map = {
+	.tx_chain_mask = WMI_10X_PDEV_PARAM_TX_CHAIN_MASK,
+	.rx_chain_mask = WMI_10X_PDEV_PARAM_RX_CHAIN_MASK,
+	.txpower_limit2g = WMI_10X_PDEV_PARAM_TXPOWER_LIMIT2G,
+	.txpower_limit5g = WMI_10X_PDEV_PARAM_TXPOWER_LIMIT5G,
+	.txpower_scale = WMI_10X_PDEV_PARAM_TXPOWER_SCALE,
+	.beacon_gen_mode = WMI_10X_PDEV_PARAM_BEACON_GEN_MODE,
+	.beacon_tx_mode = WMI_10X_PDEV_PARAM_BEACON_TX_MODE,
+	.resmgr_offchan_mode = WMI_10X_PDEV_PARAM_RESMGR_OFFCHAN_MODE,
+	.protection_mode = WMI_10X_PDEV_PARAM_PROTECTION_MODE,
+	.dynamic_bw = WMI_10X_PDEV_PARAM_DYNAMIC_BW,
+	.non_agg_sw_retry_th = WMI_10X_PDEV_PARAM_NON_AGG_SW_RETRY_TH,
+	.agg_sw_retry_th = WMI_10X_PDEV_PARAM_AGG_SW_RETRY_TH,
+	.sta_kickout_th = WMI_10X_PDEV_PARAM_STA_KICKOUT_TH,
+	.ac_aggrsize_scaling = WMI_10X_PDEV_PARAM_AC_AGGRSIZE_SCALING,
+	.ltr_enable = WMI_10X_PDEV_PARAM_LTR_ENABLE,
+	.ltr_ac_latency_be = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BE,
+	.ltr_ac_latency_bk = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_BK,
+	.ltr_ac_latency_vi = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VI,
+	.ltr_ac_latency_vo = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_VO,
+	.ltr_ac_latency_timeout = WMI_10X_PDEV_PARAM_LTR_AC_LATENCY_TIMEOUT,
+	.ltr_sleep_override = WMI_10X_PDEV_PARAM_LTR_SLEEP_OVERRIDE,
+	.ltr_rx_override = WMI_10X_PDEV_PARAM_LTR_RX_OVERRIDE,
+	.ltr_tx_activity_timeout = WMI_10X_PDEV_PARAM_LTR_TX_ACTIVITY_TIMEOUT,
+	.l1ss_enable = WMI_10X_PDEV_PARAM_L1SS_ENABLE,
+	.dsleep_enable = WMI_10X_PDEV_PARAM_DSLEEP_ENABLE,
+	.pcielp_txbuf_flush = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pcielp_txbuf_watermark = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pcielp_txbuf_tmo_en = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pcielp_txbuf_tmo_value = WMI_PDEV_PARAM_UNSUPPORTED,
+	.pdev_stats_update_period = WMI_10X_PDEV_PARAM_PDEV_STATS_UPDATE_PERIOD,
+	.vdev_stats_update_period = WMI_10X_PDEV_PARAM_VDEV_STATS_UPDATE_PERIOD,
+	.peer_stats_update_period = WMI_10X_PDEV_PARAM_PEER_STATS_UPDATE_PERIOD,
+	.bcnflt_stats_update_period =
+				WMI_10X_PDEV_PARAM_BCNFLT_STATS_UPDATE_PERIOD,
+	.pmf_qos = WMI_10X_PDEV_PARAM_PMF_QOS,
+	.arp_ac_override = WMI_10X_PDEV_PARAM_ARPDHCP_AC_OVERRIDE,
+	.dcs = WMI_10X_PDEV_PARAM_DCS,
+	.ani_enable = WMI_10X_PDEV_PARAM_ANI_ENABLE,
+	.ani_poll_period = WMI_10X_PDEV_PARAM_ANI_POLL_PERIOD,
+	.ani_listen_period = WMI_10X_PDEV_PARAM_ANI_LISTEN_PERIOD,
+	.ani_ofdm_level = WMI_10X_PDEV_PARAM_ANI_OFDM_LEVEL,
+	.ani_cck_level = WMI_10X_PDEV_PARAM_ANI_CCK_LEVEL,
+	.dyntxchain = WMI_10X_PDEV_PARAM_DYNTXCHAIN,
+	.proxy_sta = WMI_PDEV_PARAM_UNSUPPORTED,
+	.idle_ps_config = WMI_PDEV_PARAM_UNSUPPORTED,
+	.power_gating_sleep = WMI_PDEV_PARAM_UNSUPPORTED,
+	.fast_channel_reset = WMI_10X_PDEV_PARAM_FAST_CHANNEL_RESET,
+	.burst_dur = WMI_10X_PDEV_PARAM_BURST_DUR,
+	.burst_enable = WMI_10X_PDEV_PARAM_BURST_ENABLE,
+	.cal_period = WMI_10X_PDEV_PARAM_CAL_PERIOD,
+};
+
 /* firmware 10.2 specific mappings */
 static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.init_cmdid = WMI_10_2_INIT_CMDID,
@@ -4745,9 +4977,68 @@ static const struct wmi_ops wmi_10_2_ops = {
 	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
 };
 
+static const struct wmi_ops wmi_10_2_4_ops = {
+	.rx = ath10k_wmi_10_2_op_rx,
+	.gen_init = ath10k_wmi_10_2_op_gen_init,
+	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
+
+	/* shared with 10.1 */
+	.map_svc = wmi_10x_svc_map,
+	.pull_svc_rdy = ath10k_wmi_10x_op_pull_svc_rdy_ev,
+	.pull_fw_stats = ath10k_wmi_10x_op_pull_fw_stats,
+	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
+	.gen_start_scan = ath10k_wmi_10x_op_gen_start_scan,
+
+	.pull_scan = ath10k_wmi_op_pull_scan_ev,
+	.pull_mgmt_rx = ath10k_wmi_op_pull_mgmt_rx_ev,
+	.pull_ch_info = ath10k_wmi_op_pull_ch_info_ev,
+	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
+	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
+	.pull_swba = ath10k_wmi_op_pull_swba_ev,
+	.pull_phyerr = ath10k_wmi_op_pull_phyerr_ev,
+	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+
+	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
+	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
+	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
+	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
+	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
+	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
+	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
+	.gen_vdev_stop = ath10k_wmi_op_gen_vdev_stop,
+	.gen_vdev_up = ath10k_wmi_op_gen_vdev_up,
+	.gen_vdev_down = ath10k_wmi_op_gen_vdev_down,
+	.gen_vdev_set_param = ath10k_wmi_op_gen_vdev_set_param,
+	.gen_vdev_install_key = ath10k_wmi_op_gen_vdev_install_key,
+	.gen_vdev_spectral_conf = ath10k_wmi_op_gen_vdev_spectral_conf,
+	.gen_vdev_spectral_enable = ath10k_wmi_op_gen_vdev_spectral_enable,
+	.gen_peer_create = ath10k_wmi_op_gen_peer_create,
+	.gen_peer_delete = ath10k_wmi_op_gen_peer_delete,
+	.gen_peer_flush = ath10k_wmi_op_gen_peer_flush,
+	.gen_peer_set_param = ath10k_wmi_op_gen_peer_set_param,
+	.gen_set_psmode = ath10k_wmi_op_gen_set_psmode,
+	.gen_set_sta_ps = ath10k_wmi_op_gen_set_sta_ps,
+	.gen_set_ap_ps = ath10k_wmi_op_gen_set_ap_ps,
+	.gen_scan_chan_list = ath10k_wmi_op_gen_scan_chan_list,
+	.gen_beacon_dma = ath10k_wmi_op_gen_beacon_dma,
+	.gen_pdev_set_wmm = ath10k_wmi_op_gen_pdev_set_wmm,
+	.gen_request_stats = ath10k_wmi_op_gen_request_stats,
+	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
+	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
+	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
+	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
+	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+};
+
 int ath10k_wmi_attach(struct ath10k *ar)
 {
 	switch (ar->wmi.op_version) {
+	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
+		ar->wmi.cmd = &wmi_10_2_4_cmd_map;
+		ar->wmi.ops = &wmi_10_2_4_ops;
+		ar->wmi.vdev_param = &wmi_10_2_4_vdev_param_map;
+		ar->wmi.pdev_param = &wmi_10_2_4_pdev_param_map;
+		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 		ar->wmi.cmd = &wmi_10_2_cmd_map;
 		ar->wmi.ops = &wmi_10_2_ops;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 97f902f03ec5..ce517bf547f2 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1940,6 +1940,11 @@ struct wmi_resource_config_10x {
 	__le32 max_frag_entries;
 } __packed;
 
+enum wmi_10_2_feature_mask {
+	WMI_10_2_RX_BATCH_MODE = BIT(0),
+	WMI_10_2_ATF_CONFIG    = BIT(1),
+};
+
 struct wmi_resource_config_10_2 {
 	struct wmi_resource_config_10x common;
 	__le32 max_peer_ext_stats;
@@ -1948,7 +1953,7 @@ struct wmi_resource_config_10_2 {
 	__le32 be_min_free;
 	__le32 vi_min_free;
 	__le32 vo_min_free;
-	__le32 rx_batchmode; /* 0-disable, 1-enable */
+	__le32 feature_mask;
 } __packed;
 
 #define NUM_UNITS_IS_NUM_VDEVS   0x1

