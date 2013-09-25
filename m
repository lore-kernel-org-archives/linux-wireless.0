Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:55912 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267Ab3IYJi0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 05:38:26 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 01/13] ath10k: introduce dynamic WMI structures
Date: Wed, 25 Sep 2013 11:37:59 +0200
Message-ID: <1380101891-18312-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20130925_113831_328194_B5800B43)
In-Reply-To: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is the initial framework to implement dynamic
WMI API in order to support new firmware (from so
called 10.X branch)

The realization is to have a static WMI cmd map for
each of the firmwares, registered upom wmi init.

This patch creates such map for MAIN FW, updates
wmi_cmd_send() calls to take as a parameter
the map value instead of direct WMI enum.

As soon as complete 10.X API will be on place,
we will introduce the FW IE mechanics to dynamicaly
identify which FW is being used and based on that
we will use correct map, API, structures, etc.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    4 +
 drivers/net/wireless/ath/ath10k/wmi.c  |  246 +++++++++++++++++++++++++++-----
 drivers/net/wireless/ath/ath10k/wmi.h  |  112 +++++++++++++++
 3 files changed, 323 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 292ad45..0db08ea 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -107,6 +107,7 @@ struct ath10k_wmi {
 	struct completion service_ready;
 	struct completion unified_ready;
 	wait_queue_head_t tx_credits_wq;
+	struct wmi_cmd_map *cmd;
 };
 
 struct ath10k_peer_stat {
@@ -268,6 +269,9 @@ enum ath10k_fw_features {
 	/* wmi_mgmt_rx_hdr contains extra RSSI information */
 	ATH10K_FW_FEATURE_EXT_WMI_MGMT_RX = 0,
 
+	/* firmware from 10X branch */
+	ATH10K_FW_FEATURE_10X = 1,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6803ead..9cf426f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -23,6 +23,131 @@
 #include "wmi.h"
 #include "mac.h"
 
+/* MAIN WMI cmd track */
+static struct wmi_cmd_map wmi_cmd_map = {
+	.wmi_init_cmdid = WMI_INIT_CMDID,
+	.wmi_start_scan_cmdid = WMI_START_SCAN_CMDID,
+	.wmi_stop_scan_cmdid = WMI_STOP_SCAN_CMDID,
+	.wmi_scan_chan_list_cmdid = WMI_SCAN_CHAN_LIST_CMDID,
+	.wmi_scan_sch_prio_tbl_cmdid = WMI_SCAN_SCH_PRIO_TBL_CMDID,
+	.wmi_pdev_set_regdomain_cmdid = WMI_PDEV_SET_REGDOMAIN_CMDID,
+	.wmi_pdev_set_channel_cmdid = WMI_PDEV_SET_CHANNEL_CMDID,
+	.wmi_pdev_set_param_cmdid = WMI_PDEV_SET_PARAM_CMDID,
+	.wmi_pdev_pktlog_enable_cmdid = WMI_PDEV_PKTLOG_ENABLE_CMDID,
+	.wmi_pdev_pktlog_disable_cmdid = WMI_PDEV_PKTLOG_DISABLE_CMDID,
+	.wmi_pdev_set_wmm_params_cmdid = WMI_PDEV_SET_WMM_PARAMS_CMDID,
+	.wmi_pdev_set_ht_cap_ie_cmdid = WMI_PDEV_SET_HT_CAP_IE_CMDID,
+	.wmi_pdev_set_vht_cap_ie_cmdid = WMI_PDEV_SET_VHT_CAP_IE_CMDID,
+	.wmi_pdev_set_dscp_tid_map_cmdid = WMI_PDEV_SET_DSCP_TID_MAP_CMDID,
+	.wmi_pdev_set_quiet_mode_cmdid = WMI_PDEV_SET_QUIET_MODE_CMDID,
+	.wmi_pdev_green_ap_ps_enable_cmdid = WMI_PDEV_GREEN_AP_PS_ENABLE_CMDID,
+	.wmi_pdev_get_tpc_config_cmdid = WMI_PDEV_GET_TPC_CONFIG_CMDID,
+	.wmi_pdev_set_base_macaddr_cmdid = WMI_PDEV_SET_BASE_MACADDR_CMDID,
+	.wmi_vdev_create_cmdid = WMI_VDEV_CREATE_CMDID,
+	.wmi_vdev_delete_cmdid = WMI_VDEV_DELETE_CMDID,
+	.wmi_vdev_start_request_cmdid = WMI_VDEV_START_REQUEST_CMDID,
+	.wmi_vdev_restart_request_cmdid = WMI_VDEV_RESTART_REQUEST_CMDID,
+	.wmi_vdev_up_cmdid = WMI_VDEV_UP_CMDID,
+	.wmi_vdev_stop_cmdid = WMI_VDEV_STOP_CMDID,
+	.wmi_vdev_down_cmdid = WMI_VDEV_DOWN_CMDID,
+	.wmi_vdev_set_param_cmdid = WMI_VDEV_SET_PARAM_CMDID,
+	.wmi_vdev_install_key_cmdid = WMI_VDEV_INSTALL_KEY_CMDID,
+	.wmi_peer_create_cmdid = WMI_PEER_CREATE_CMDID,
+	.wmi_peer_delete_cmdid = WMI_PEER_DELETE_CMDID,
+	.wmi_peer_flush_tids_cmdid = WMI_PEER_FLUSH_TIDS_CMDID,
+	.wmi_peer_set_param_cmdid = WMI_PEER_SET_PARAM_CMDID,
+	.wmi_peer_assoc_cmdid = WMI_PEER_ASSOC_CMDID,
+	.wmi_peer_add_wds_entry_cmdid = WMI_PEER_ADD_WDS_ENTRY_CMDID,
+	.wmi_peer_remove_wds_entry_cmdid = WMI_PEER_REMOVE_WDS_ENTRY_CMDID,
+	.wmi_peer_mcast_group_cmdid = WMI_PEER_MCAST_GROUP_CMDID,
+	.wmi_bcn_tx_cmdid = WMI_BCN_TX_CMDID,
+	.wmi_pdev_send_bcn_cmdid = WMI_PDEV_SEND_BCN_CMDID,
+	.wmi_bcn_tmpl_cmdid = WMI_BCN_TMPL_CMDID,
+	.wmi_bcn_filter_rx_cmdid = WMI_BCN_FILTER_RX_CMDID,
+	.wmi_prb_req_filter_rx_cmdid = WMI_PRB_REQ_FILTER_RX_CMDID,
+	.wmi_mgmt_tx_cmdid = WMI_MGMT_TX_CMDID,
+	.wmi_prb_tmpl_cmdid = WMI_PRB_TMPL_CMDID,
+	.wmi_addba_clear_resp_cmdid = WMI_ADDBA_CLEAR_RESP_CMDID,
+	.wmi_addba_send_cmdid = WMI_ADDBA_SEND_CMDID,
+	.wmi_addba_status_cmdid = WMI_ADDBA_STATUS_CMDID,
+	.wmi_delba_send_cmdid = WMI_DELBA_SEND_CMDID,
+	.wmi_addba_set_resp_cmdid = WMI_ADDBA_SET_RESP_CMDID,
+	.wmi_send_singleamsdu_cmdid = WMI_SEND_SINGLEAMSDU_CMDID,
+	.wmi_sta_powersave_mode_cmdid = WMI_STA_POWERSAVE_MODE_CMDID,
+	.wmi_sta_powersave_param_cmdid = WMI_STA_POWERSAVE_PARAM_CMDID,
+	.wmi_sta_mimo_ps_mode_cmdid = WMI_STA_MIMO_PS_MODE_CMDID,
+	.wmi_pdev_dfs_enable_cmdid = WMI_PDEV_DFS_ENABLE_CMDID,
+	.wmi_pdev_dfs_disable_cmdid = WMI_PDEV_DFS_DISABLE_CMDID,
+	.wmi_roam_scan_mode = WMI_ROAM_SCAN_MODE,
+	.wmi_roam_scan_rssi_threshold = WMI_ROAM_SCAN_RSSI_THRESHOLD,
+	.wmi_roam_scan_period = WMI_ROAM_SCAN_PERIOD,
+	.wmi_roam_scan_rssi_change_threshold =
+					WMI_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
+	.wmi_roam_ap_profile = WMI_ROAM_AP_PROFILE,
+	.wmi_ofl_scan_add_ap_profile = WMI_ROAM_AP_PROFILE,
+	.wmi_ofl_scan_remove_ap_profile = WMI_OFL_SCAN_REMOVE_AP_PROFILE,
+	.wmi_ofl_scan_period = WMI_OFL_SCAN_PERIOD,
+	.wmi_p2p_dev_set_device_info = WMI_P2P_DEV_SET_DEVICE_INFO,
+	.wmi_p2p_dev_set_discoverability = WMI_P2P_DEV_SET_DISCOVERABILITY,
+	.wmi_p2p_go_set_beacon_ie = WMI_P2P_DEV_SET_DISCOVERABILITY,
+	.wmi_p2p_go_set_probe_resp_ie = WMI_P2P_GO_SET_PROBE_RESP_IE,
+	.wmi_p2p_set_vendor_ie_data_cmdid = WMI_P2P_SET_VENDOR_IE_DATA_CMDID,
+	.wmi_ap_ps_peer_param_cmdid = WMI_AP_PS_PEER_PARAM_CMDID,
+	.wmi_ap_ps_peer_uapsd_coex_cmdid = WMI_AP_PS_PEER_UAPSD_COEX_CMDID,
+	.wmi_peer_rate_retry_sched_cmdid = WMI_PEER_RATE_RETRY_SCHED_CMDID,
+	.wmi_wlan_profile_trigger_cmdid = WMI_WLAN_PROFILE_TRIGGER_CMDID,
+	.wmi_wlan_profile_set_hist_intvl_cmdid =
+					 WMI_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
+	.wmi_wlan_profile_get_profile_data_cmdid =
+				 WMI_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
+	.wmi_wlan_profile_enable_profile_id_cmdid =
+				 WMI_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
+	.wmi_wlan_profile_list_profile_id_cmdid =
+				 WMI_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
+	.wmi_pdev_suspend_cmdid = WMI_PDEV_SUSPEND_CMDID,
+	.wmi_pdev_resume_cmdid = WMI_PDEV_RESUME_CMDID,
+	.wmi_add_bcn_filter_cmdid = WMI_ADD_BCN_FILTER_CMDID,
+	.wmi_rmv_bcn_filter_cmdid = WMI_RMV_BCN_FILTER_CMDID,
+	.wmi_wow_add_wake_pattern_cmdid = WMI_WOW_ADD_WAKE_PATTERN_CMDID,
+	.wmi_wow_del_wake_pattern_cmdid = WMI_WOW_DEL_WAKE_PATTERN_CMDID,
+	.wmi_wow_enable_disable_wake_event_cmdid =
+				 WMI_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
+	.wmi_wow_enable_cmdid = WMI_WOW_ENABLE_CMDID,
+	.wmi_wow_hostwakeup_from_sleep_cmdid =
+				 WMI_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
+	.wmi_rtt_measreq_cmdid = WMI_RTT_MEASREQ_CMDID,
+	.wmi_rtt_tsf_cmdid = WMI_RTT_TSF_CMDID,
+	.wmi_vdev_spectral_scan_configure_cmdid =
+				 WMI_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
+	.wmi_vdev_spectral_scan_enable_cmdid =
+				 WMI_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
+	.wmi_request_stats_cmdid = WMI_REQUEST_STATS_CMDID,
+	.wmi_set_arp_ns_offload_cmdid = WMI_SET_ARP_NS_OFFLOAD_CMDID,
+	.wmi_network_list_offload_config_cmdid =
+				 WMI_NETWORK_LIST_OFFLOAD_CONFIG_CMDID,
+	.wmi_gtk_offload_cmdid = WMI_GTK_OFFLOAD_CMDID,
+	.wmi_csa_offload_enable_cmdid = WMI_CSA_OFFLOAD_ENABLE_CMDID,
+	.wmi_csa_offload_chanswitch_cmdid = WMI_CSA_OFFLOAD_CHANSWITCH_CMDID,
+	.wmi_chatter_set_mode_cmdid = WMI_CHATTER_SET_MODE_CMDID,
+	.wmi_peer_tid_addba_cmdid = WMI_CHATTER_SET_MODE_CMDID,
+	.wmi_peer_tid_delba_cmdid = WMI_PEER_TID_DELBA_CMDID,
+	.wmi_sta_dtim_ps_method_cmdid = WMI_STA_DTIM_PS_METHOD_CMDID,
+	.wmi_sta_uapsd_auto_trig_cmdid = WMI_STA_UAPSD_AUTO_TRIG_CMDID,
+	.wmi_sta_keepalive_cmd = WMI_STA_KEEPALIVE_CMD,
+	.wmi_echo_cmdid = WMI_ECHO_CMDID,
+	.wmi_pdev_utf_cmdid = WMI_PDEV_UTF_CMDID,
+	.wmi_dbglog_cfg_cmdid = WMI_DBGLOG_CFG_CMDID,
+	.wmi_pdev_qvit_cmdid = WMI_PDEV_QVIT_CMDID,
+	.wmi_pdev_ftm_intg_cmdid = WMI_PDEV_FTM_INTG_CMDID,
+	.wmi_vdev_set_keepalive_cmdid = WMI_VDEV_SET_KEEPALIVE_CMDID,
+	.wmi_vdev_get_keepalive_cmdid = WMI_VDEV_GET_KEEPALIVE_CMDID,
+	.wmi_force_fw_hang_cmdid = WMI_FORCE_FW_HANG_CMDID,
+	.wmi_gpio_config_cmdid = WMI_FORCE_FW_HANG_CMDID,
+	.wmi_gpio_output_cmdid = WMI_GPIO_OUTPUT_CMDID,
+};
+
+/* TODO: 10.X WMI cmd track */
+
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
@@ -64,7 +189,7 @@ static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 }
 
 static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
-				      enum wmi_cmd_id cmd_id)
+				      u32 cmd_id)
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	struct wmi_cmd_hdr *cmd_hdr;
@@ -144,7 +269,7 @@ static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar)
 }
 
 static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
-			       enum wmi_cmd_id cmd_id)
+			       u32 cmd_id)
 {
 	int ret = -EINVAL;
 
@@ -1055,7 +1180,7 @@ static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_event_id id;
@@ -1174,14 +1299,31 @@ static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 
+static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
+{
+	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features))
+		ath10k_warn("Firmware 10.X is not yet supported\n");
+	else
+		ath10k_wmi_main_process_rx(ar, skb);
+}
+
 /* WMI Initialization functions */
 int ath10k_wmi_attach(struct ath10k *ar)
 {
+	int ret = 0;
+
+	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features)) {
+		ath10k_warn("Firmware 10.X is not yet supported\n");
+		ret = -ENOTSUPP;
+	} else {
+		ar->wmi.cmd = &wmi_cmd_map;
+	}
+
 	init_completion(&ar->wmi.service_ready);
 	init_completion(&ar->wmi.unified_ready);
 	init_waitqueue_head(&ar->wmi.tx_credits_wq);
 
-	return 0;
+	return ret;
 }
 
 void ath10k_wmi_detach(struct ath10k *ar)
@@ -1237,7 +1379,8 @@ int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
 		   "wmi pdev regdomain rd %x rd2g %x rd5g %x ctl2g %x ctl5g %x\n",
 		   rd, rd2g, rd5g, ctl2g, ctl5g);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_REGDOMAIN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_pdev_set_regdomain_cmdid);
 }
 
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
@@ -1267,7 +1410,8 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 		   "wmi set channel mode %d freq %d\n",
 		   arg->mode, arg->freq);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_CHANNEL_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_pdev_set_channel_cmdid);
 }
 
 int ath10k_wmi_pdev_suspend_target(struct ath10k *ar)
@@ -1282,7 +1426,8 @@ int ath10k_wmi_pdev_suspend_target(struct ath10k *ar)
 	cmd = (struct wmi_pdev_suspend_cmd *)skb->data;
 	cmd->suspend_opt = WMI_PDEV_SUSPEND;
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SUSPEND_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_pdev_suspend_cmdid);
 }
 
 int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
@@ -1293,7 +1438,8 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
 	if (skb == NULL)
 		return -ENOMEM;
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_RESUME_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_pdev_resume_cmdid);
 }
 
 int ath10k_wmi_pdev_set_param(struct ath10k *ar, enum wmi_pdev_param id,
@@ -1312,7 +1458,8 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, enum wmi_pdev_param id,
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi pdev set param %d value %d\n",
 		   id, value);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_pdev_set_param_cmdid);
 }
 
 int ath10k_wmi_cmd_init(struct ath10k *ar)
@@ -1382,7 +1529,7 @@ int ath10k_wmi_cmd_init(struct ath10k *ar)
 	memcpy(&cmd->resource_config, &config, sizeof(config));
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi init\n");
-	return ath10k_wmi_cmd_send(ar, buf, WMI_INIT_CMDID);
+	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->wmi_init_cmdid);
 }
 
 static int ath10k_wmi_start_scan_calc_len(const struct wmi_start_scan_arg *arg)
@@ -1543,7 +1690,8 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 	}
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi start scan\n");
-	return ath10k_wmi_cmd_send(ar, skb, WMI_START_SCAN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_start_scan_cmdid);
 }
 
 void ath10k_wmi_start_scan_init(struct ath10k *ar,
@@ -1603,7 +1751,8 @@ int ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi stop scan reqid %d req_type %d vdev/scan_id %d\n",
 		   arg->req_id, arg->req_type, arg->u.scan_id);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_STOP_SCAN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_stop_scan_cmdid);
 }
 
 int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
@@ -1628,7 +1777,8 @@ int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
 		   "WMI vdev create: id %d type %d subtype %d macaddr %pM\n",
 		   vdev_id, type, subtype, macaddr);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_CREATE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_vdev_create_cmdid);
 }
 
 int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
@@ -1646,20 +1796,21 @@ int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "WMI vdev delete id %d\n", vdev_id);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_DELETE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_vdev_delete_cmdid);
 }
 
 static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 				const struct wmi_vdev_start_request_arg *arg,
-				enum wmi_cmd_id cmd_id)
+				u32 cmd_id)
 {
 	struct wmi_vdev_start_request_cmd *cmd;
 	struct sk_buff *skb;
 	const char *cmdname;
 	u32 flags = 0;
 
-	if (cmd_id != WMI_VDEV_START_REQUEST_CMDID &&
-	    cmd_id != WMI_VDEV_RESTART_REQUEST_CMDID)
+	if (cmd_id != ar->wmi.cmd->wmi_vdev_start_request_cmdid &&
+	    cmd_id != ar->wmi.cmd->wmi_vdev_restart_request_cmdid)
 		return -EINVAL;
 	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
 		return -EINVAL;
@@ -1668,9 +1819,9 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
 		return -EINVAL;
 
-	if (cmd_id == WMI_VDEV_START_REQUEST_CMDID)
+	if (cmd_id == ar->wmi.cmd->wmi_vdev_start_request_cmdid)
 		cmdname = "start";
-	else if (cmd_id == WMI_VDEV_RESTART_REQUEST_CMDID)
+	else if (cmd_id == ar->wmi.cmd->wmi_vdev_restart_request_cmdid)
 		cmdname = "restart";
 	else
 		return -EINVAL; /* should not happen, we already check cmd_id */
@@ -1722,14 +1873,14 @@ int ath10k_wmi_vdev_start(struct ath10k *ar,
 			  const struct wmi_vdev_start_request_arg *arg)
 {
 	return ath10k_wmi_vdev_start_restart(ar, arg,
-					     WMI_VDEV_START_REQUEST_CMDID);
+				ar->wmi.cmd->wmi_vdev_start_request_cmdid);
 }
 
 int ath10k_wmi_vdev_restart(struct ath10k *ar,
 		     const struct wmi_vdev_start_request_arg *arg)
 {
 	return ath10k_wmi_vdev_start_restart(ar, arg,
-					     WMI_VDEV_RESTART_REQUEST_CMDID);
+				ar->wmi.cmd->wmi_vdev_restart_request_cmdid);
 }
 
 int ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id)
@@ -1746,7 +1897,8 @@ int ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id)
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi vdev stop id 0x%x\n", vdev_id);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_STOP_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_vdev_stop_cmdid);
 }
 
 int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
@@ -1767,7 +1919,7 @@ int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
 		   "wmi mgmt vdev up id 0x%x assoc id %d bssid %pM\n",
 		   vdev_id, aid, bssid);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_UP_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->wmi_vdev_up_cmdid);
 }
 
 int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
@@ -1785,7 +1937,8 @@ int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi mgmt vdev down id 0x%x\n", vdev_id);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_DOWN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_vdev_down_cmdid);
 }
 
 int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
@@ -1807,7 +1960,8 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 		   "wmi vdev id 0x%x set param %d value %d\n",
 		   vdev_id, param_id, param_value);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_SET_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_vdev_set_param_cmdid);
 }
 
 int ath10k_wmi_vdev_install_key(struct ath10k *ar,
@@ -1842,7 +1996,8 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi vdev install key idx %d cipher %d len %d\n",
 		   arg->key_idx, arg->key_cipher, arg->key_len);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_INSTALL_KEY_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_vdev_install_key_cmdid);
 }
 
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
@@ -1862,7 +2017,8 @@ int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer create vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_CREATE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_peer_create_cmdid);
 }
 
 int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
@@ -1882,7 +2038,8 @@ int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer delete vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_DELETE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_peer_delete_cmdid);
 }
 
 int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
@@ -1903,7 +2060,8 @@ int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer flush vdev_id %d peer_addr %pM tids %08x\n",
 		   vdev_id, peer_addr, tid_bitmap);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_FLUSH_TIDS_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_peer_flush_tids_cmdid);
 }
 
 int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
@@ -1927,7 +2085,8 @@ int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
 		   "wmi vdev %d peer 0x%pM set param %d value %d\n",
 		   vdev_id, peer_addr, param_id, param_value);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_SET_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_peer_set_param_cmdid);
 }
 
 int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
@@ -1948,7 +2107,8 @@ int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
 		   "wmi set powersave id 0x%x mode %d\n",
 		   vdev_id, psmode);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_STA_POWERSAVE_MODE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_sta_powersave_mode_cmdid);
 }
 
 int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
@@ -1970,7 +2130,8 @@ int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi sta ps param vdev_id 0x%x param %d value %d\n",
 		   vdev_id, param_id, value);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_STA_POWERSAVE_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_sta_powersave_param_cmdid);
 }
 
 int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
@@ -1996,7 +2157,8 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 		   "wmi ap ps param vdev_id 0x%X param %d value %d mac_addr %pM\n",
 		   vdev_id, param_id, value, mac);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_AP_PS_PEER_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_ap_ps_peer_param_cmdid);
 }
 
 int ath10k_wmi_scan_chan_list(struct ath10k *ar,
@@ -2049,7 +2211,8 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 		ci->flags            |= __cpu_to_le32(flags);
 	}
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_SCAN_CHAN_LIST_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_scan_chan_list_cmdid);
 }
 
 int ath10k_wmi_peer_assoc(struct ath10k *ar,
@@ -2108,7 +2271,8 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer assoc vdev %d addr %pM\n",
 		   arg->vdev_id, arg->addr);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_ASSOC_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_peer_assoc_cmdid);
 }
 
 int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
@@ -2128,7 +2292,8 @@ int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
 	cmd->hdr.bcn_len  = __cpu_to_le32(arg->bcn_len);
 	memcpy(cmd->bcn, arg->bcn, arg->bcn_len);
 
-	return ath10k_wmi_cmd_send_nowait(ar, skb, WMI_BCN_TX_CMDID);
+	return ath10k_wmi_cmd_send_nowait(ar, skb,
+					  ar->wmi.cmd->wmi_bcn_tx_cmdid);
 }
 
 static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
@@ -2159,7 +2324,8 @@ int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_vo, &arg->ac_vo);
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi pdev set wmm params\n");
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_WMM_PARAMS_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_pdev_set_wmm_params_cmdid);
 }
 
 int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
@@ -2175,7 +2341,8 @@ int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
 	cmd->stats_id = __cpu_to_le32(stats_id);
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi request stats %d\n", (int)stats_id);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_REQUEST_STATS_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_request_stats_cmdid);
 }
 
 int ath10k_wmi_force_fw_hang(struct ath10k *ar,
@@ -2194,5 +2361,6 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi force fw hang %d delay %d\n",
 		   type, delay_ms);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_FORCE_FW_HANG_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->wmi_force_fw_hang_cmdid);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2c52c23..94fc008 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -208,6 +208,118 @@ struct wmi_mac_addr {
 	(c_macaddr)[5] = (((pwmi_mac_addr)->word1) >> 8) & 0xff; \
 	} while (0)
 
+struct wmi_cmd_map {
+	u32 wmi_init_cmdid;
+	u32 wmi_start_scan_cmdid;
+	u32 wmi_stop_scan_cmdid;
+	u32 wmi_scan_chan_list_cmdid;
+	u32 wmi_scan_sch_prio_tbl_cmdid;
+	u32 wmi_pdev_set_regdomain_cmdid;
+	u32 wmi_pdev_set_channel_cmdid;
+	u32 wmi_pdev_set_param_cmdid;
+	u32 wmi_pdev_pktlog_enable_cmdid;
+	u32 wmi_pdev_pktlog_disable_cmdid;
+	u32 wmi_pdev_set_wmm_params_cmdid;
+	u32 wmi_pdev_set_ht_cap_ie_cmdid;
+	u32 wmi_pdev_set_vht_cap_ie_cmdid;
+	u32 wmi_pdev_set_dscp_tid_map_cmdid;
+	u32 wmi_pdev_set_quiet_mode_cmdid;
+	u32 wmi_pdev_green_ap_ps_enable_cmdid;
+	u32 wmi_pdev_get_tpc_config_cmdid;
+	u32 wmi_pdev_set_base_macaddr_cmdid;
+	u32 wmi_vdev_create_cmdid;
+	u32 wmi_vdev_delete_cmdid;
+	u32 wmi_vdev_start_request_cmdid;
+	u32 wmi_vdev_restart_request_cmdid;
+	u32 wmi_vdev_up_cmdid;
+	u32 wmi_vdev_stop_cmdid;
+	u32 wmi_vdev_down_cmdid;
+	u32 wmi_vdev_set_param_cmdid;
+	u32 wmi_vdev_install_key_cmdid;
+	u32 wmi_peer_create_cmdid;
+	u32 wmi_peer_delete_cmdid;
+	u32 wmi_peer_flush_tids_cmdid;
+	u32 wmi_peer_set_param_cmdid;
+	u32 wmi_peer_assoc_cmdid;
+	u32 wmi_peer_add_wds_entry_cmdid;
+	u32 wmi_peer_remove_wds_entry_cmdid;
+	u32 wmi_peer_mcast_group_cmdid;
+	u32 wmi_bcn_tx_cmdid;
+	u32 wmi_pdev_send_bcn_cmdid;
+	u32 wmi_bcn_tmpl_cmdid;
+	u32 wmi_bcn_filter_rx_cmdid;
+	u32 wmi_prb_req_filter_rx_cmdid;
+	u32 wmi_mgmt_tx_cmdid;
+	u32 wmi_prb_tmpl_cmdid;
+	u32 wmi_addba_clear_resp_cmdid;
+	u32 wmi_addba_send_cmdid;
+	u32 wmi_addba_status_cmdid;
+	u32 wmi_delba_send_cmdid;
+	u32 wmi_addba_set_resp_cmdid;
+	u32 wmi_send_singleamsdu_cmdid;
+	u32 wmi_sta_powersave_mode_cmdid;
+	u32 wmi_sta_powersave_param_cmdid;
+	u32 wmi_sta_mimo_ps_mode_cmdid;
+	u32 wmi_pdev_dfs_enable_cmdid;
+	u32 wmi_pdev_dfs_disable_cmdid;
+	u32 wmi_roam_scan_mode;
+	u32 wmi_roam_scan_rssi_threshold;
+	u32 wmi_roam_scan_period;
+	u32 wmi_roam_scan_rssi_change_threshold;
+	u32 wmi_roam_ap_profile;
+	u32 wmi_ofl_scan_add_ap_profile;
+	u32 wmi_ofl_scan_remove_ap_profile;
+	u32 wmi_ofl_scan_period;
+	u32 wmi_p2p_dev_set_device_info;
+	u32 wmi_p2p_dev_set_discoverability;
+	u32 wmi_p2p_go_set_beacon_ie;
+	u32 wmi_p2p_go_set_probe_resp_ie;
+	u32 wmi_p2p_set_vendor_ie_data_cmdid;
+	u32 wmi_ap_ps_peer_param_cmdid;
+	u32 wmi_ap_ps_peer_uapsd_coex_cmdid;
+	u32 wmi_peer_rate_retry_sched_cmdid;
+	u32 wmi_wlan_profile_trigger_cmdid;
+	u32 wmi_wlan_profile_set_hist_intvl_cmdid;
+	u32 wmi_wlan_profile_get_profile_data_cmdid;
+	u32 wmi_wlan_profile_enable_profile_id_cmdid;
+	u32 wmi_wlan_profile_list_profile_id_cmdid;
+	u32 wmi_pdev_suspend_cmdid;
+	u32 wmi_pdev_resume_cmdid;
+	u32 wmi_add_bcn_filter_cmdid;
+	u32 wmi_rmv_bcn_filter_cmdid;
+	u32 wmi_wow_add_wake_pattern_cmdid;
+	u32 wmi_wow_del_wake_pattern_cmdid;
+	u32 wmi_wow_enable_disable_wake_event_cmdid;
+	u32 wmi_wow_enable_cmdid;
+	u32 wmi_wow_hostwakeup_from_sleep_cmdid;
+	u32 wmi_rtt_measreq_cmdid;
+	u32 wmi_rtt_tsf_cmdid;
+	u32 wmi_vdev_spectral_scan_configure_cmdid;
+	u32 wmi_vdev_spectral_scan_enable_cmdid;
+	u32 wmi_request_stats_cmdid;
+	u32 wmi_set_arp_ns_offload_cmdid;
+	u32 wmi_network_list_offload_config_cmdid;
+	u32 wmi_gtk_offload_cmdid;
+	u32 wmi_csa_offload_enable_cmdid;
+	u32 wmi_csa_offload_chanswitch_cmdid;
+	u32 wmi_chatter_set_mode_cmdid;
+	u32 wmi_peer_tid_addba_cmdid;
+	u32 wmi_peer_tid_delba_cmdid;
+	u32 wmi_sta_dtim_ps_method_cmdid;
+	u32 wmi_sta_uapsd_auto_trig_cmdid;
+	u32 wmi_sta_keepalive_cmd;
+	u32 wmi_echo_cmdid;
+	u32 wmi_pdev_utf_cmdid;
+	u32 wmi_dbglog_cfg_cmdid;
+	u32 wmi_pdev_qvit_cmdid;
+	u32 wmi_pdev_ftm_intg_cmdid;
+	u32 wmi_vdev_set_keepalive_cmdid;
+	u32 wmi_vdev_get_keepalive_cmdid;
+	u32 wmi_force_fw_hang_cmdid;
+	u32 wmi_gpio_config_cmdid;
+	u32 wmi_gpio_output_cmdid;
+};
+
 /*
  * wmi command groups.
  */
-- 
1.7.10

