Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39205 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbbFVOlx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:41:53 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 04/10] ath10k: set 10.4 fw exclusive wmi cmd as unsupported for other fw versions
Date: Mon, 22 Jun 2015 20:10:12 +0530
Message-ID: <1434984018-24057-5-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_164156_339317_498107FB)
In-Reply-To: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984018-24057-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In fact, explicit assigned to ZERO for unsupported wmi commands
are not really needed. Global static variable will have ZERO by
default. However, just for better readability setting all wmi cmds
in non 10.4 firmware wmi mapping table as unsupported for wmi cmd
which are exclusively available only in 10.4 firmware.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi-tlv.c |  32 ++++++
 drivers/net/wireless/ath/ath10k/wmi.c     | 158 ++++++++++++++++++++++++++++++
 2 files changed, 190 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index 8fdba38..7e75dec 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -3151,6 +3151,38 @@ static struct wmi_cmd_map wmi_tlv_cmd_map = {
 	.tdls_set_state_cmdid = WMI_TLV_TDLS_SET_STATE_CMDID,
 	.tdls_peer_update_cmdid = WMI_TLV_TDLS_PEER_UPDATE_CMDID,
 	.adaptive_qcs_cmdid = WMI_TLV_RESMGR_ADAPTIVE_OCS_CMDID,
+	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_add_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_evict_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_restore_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_print_all_peers_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_update_wds_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_add_proxy_sta_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.rtt_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.oem_req_cmdid = WMI_CMD_UNSUPPORTED,
+	.nan_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_ratemask_cmdid = WMI_CMD_UNSUPPORTED,
+	.qboost_cfg_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_enable_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_set_rx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_tx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_train_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_node_config_ops_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_antenna_switch_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_ctl_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_mimogain_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_chainmsk_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_fips_cmdid = WMI_CMD_UNSUPPORTED,
+	.tt_set_conf_cmdid = WMI_CMD_UNSUPPORTED,
+	.fwtest_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_cck_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_ofdm_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_reserve_ast_entry_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 static struct wmi_pdev_param_map wmi_tlv_pdev_param_map = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 8dc937d..a58ddb7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -148,6 +148,48 @@ static struct wmi_cmd_map wmi_cmd_map = {
 	.gpio_config_cmdid = WMI_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_add_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_evict_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_restore_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_print_all_peers_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_update_wds_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_add_proxy_sta_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.rtt_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.oem_req_cmdid = WMI_CMD_UNSUPPORTED,
+	.nan_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_ratemask_cmdid = WMI_CMD_UNSUPPORTED,
+	.qboost_cfg_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_enable_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_set_rx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_tx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_train_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_node_config_ops_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_antenna_switch_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_ctl_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_mimogain_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_chainmsk_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_fips_cmdid = WMI_CMD_UNSUPPORTED,
+	.tt_set_conf_cmdid = WMI_CMD_UNSUPPORTED,
+	.fwtest_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_cck_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_ofdm_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_reserve_ast_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_nfcal_power_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_tpc_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ast_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_set_dscp_tid_map_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_filter_neighbor_rx_packets_cmdid = WMI_CMD_UNSUPPORTED,
+	.mu_cal_start_cmdid = WMI_CMD_UNSUPPORTED,
+	.set_cca_params_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_bss_chan_info_request_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 /* 10.X WMI cmd track */
@@ -271,6 +313,48 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.gpio_config_cmdid = WMI_10X_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_add_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_evict_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_restore_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_print_all_peers_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_update_wds_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_add_proxy_sta_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.rtt_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.oem_req_cmdid = WMI_CMD_UNSUPPORTED,
+	.nan_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_ratemask_cmdid = WMI_CMD_UNSUPPORTED,
+	.qboost_cfg_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_enable_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_set_rx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_tx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_train_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_node_config_ops_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_antenna_switch_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_ctl_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_mimogain_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_chainmsk_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_fips_cmdid = WMI_CMD_UNSUPPORTED,
+	.tt_set_conf_cmdid = WMI_CMD_UNSUPPORTED,
+	.fwtest_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_cck_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_ofdm_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_reserve_ast_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_nfcal_power_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_tpc_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ast_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_set_dscp_tid_map_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_filter_neighbor_rx_packets_cmdid = WMI_CMD_UNSUPPORTED,
+	.mu_cal_start_cmdid = WMI_CMD_UNSUPPORTED,
+	.set_cca_params_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_bss_chan_info_request_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 /* 10.2.4 WMI cmd track */
@@ -393,6 +477,48 @@ static struct wmi_cmd_map wmi_10_2_4_cmd_map = {
 	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_10_2_PDEV_GET_TEMPERATURE_CMDID,
+	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_add_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_evict_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_restore_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_print_all_peers_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_update_wds_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_add_proxy_sta_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.rtt_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.oem_req_cmdid = WMI_CMD_UNSUPPORTED,
+	.nan_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_ratemask_cmdid = WMI_CMD_UNSUPPORTED,
+	.qboost_cfg_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_enable_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_set_rx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_tx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_train_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_node_config_ops_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_antenna_switch_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_ctl_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_mimogain_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_chainmsk_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_fips_cmdid = WMI_CMD_UNSUPPORTED,
+	.tt_set_conf_cmdid = WMI_CMD_UNSUPPORTED,
+	.fwtest_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_cck_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_ofdm_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_reserve_ast_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_nfcal_power_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_tpc_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ast_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_set_dscp_tid_map_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_get_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_filter_neighbor_rx_packets_cmdid = WMI_CMD_UNSUPPORTED,
+	.mu_cal_start_cmdid = WMI_CMD_UNSUPPORTED,
+	.set_cca_params_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_bss_chan_info_request_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 /* 10.4 WMI cmd track */
@@ -1032,6 +1158,38 @@ static struct wmi_cmd_map wmi_10_2_cmd_map = {
 	.gpio_config_cmdid = WMI_10_2_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10_2_GPIO_OUTPUT_CMDID,
 	.pdev_get_temperature_cmdid = WMI_CMD_UNSUPPORTED,
+	.scan_update_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_standby_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_resume_response_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_add_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_evict_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_restore_peer_cmdid = WMI_CMD_UNSUPPORTED,
+	.wlan_peer_caching_print_all_peers_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_update_wds_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_add_proxy_sta_entry_cmdid = WMI_CMD_UNSUPPORTED,
+	.rtt_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.oem_req_cmdid = WMI_CMD_UNSUPPORTED,
+	.nan_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_ratemask_cmdid = WMI_CMD_UNSUPPORTED,
+	.qboost_cfg_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_enable_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_smart_ant_set_rx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_tx_antenna_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_train_info_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_smart_ant_set_node_config_ops_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_antenna_switch_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_ctl_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_set_mimogain_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_ratepwr_chainmsk_table_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_fips_cmdid = WMI_CMD_UNSUPPORTED,
+	.tt_set_conf_cmdid = WMI_CMD_UNSUPPORTED,
+	.fwtest_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.peer_atf_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_cck_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_get_ani_ofdm_config_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_reserve_ast_entry_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
 void ath10k_wmi_put_wmi_channel(struct wmi_channel *ch,
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
