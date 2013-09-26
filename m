Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:56240 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751194Ab3IZPrd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 11:47:33 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH v3 01/13] ath10k: introduce dynamic WMI structures
Date: Thu, 26 Sep 2013 17:47:05 +0200
Message-ID: <1380210437-4391-2-git-send-email-bartosz.markowski@tieto.com> (sfid-20130926_174738_801784_082611B0)
In-Reply-To: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380210437-4391-1-git-send-email-bartosz.markowski@tieto.com>
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
 drivers/net/wireless/ath/ath10k/wmi.c  |  230 ++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/wmi.h  |  112 ++++++++++++++++
 3 files changed, 305 insertions(+), 41 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 292ad45..acfee7c 100644
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
+	ATH10K_FW_FEATURE_WMI_10X = 1,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6803ead..1296dbe 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -23,6 +23,128 @@
 #include "wmi.h"
 #include "mac.h"
 
+/* MAIN WMI cmd track */
+static struct wmi_cmd_map wmi_cmd_map = {
+	.init_cmdid = WMI_INIT_CMDID,
+	.start_scan_cmdid = WMI_START_SCAN_CMDID,
+	.stop_scan_cmdid = WMI_STOP_SCAN_CMDID,
+	.scan_chan_list_cmdid = WMI_SCAN_CHAN_LIST_CMDID,
+	.scan_sch_prio_tbl_cmdid = WMI_SCAN_SCH_PRIO_TBL_CMDID,
+	.pdev_set_regdomain_cmdid = WMI_PDEV_SET_REGDOMAIN_CMDID,
+	.pdev_set_channel_cmdid = WMI_PDEV_SET_CHANNEL_CMDID,
+	.pdev_set_param_cmdid = WMI_PDEV_SET_PARAM_CMDID,
+	.pdev_pktlog_enable_cmdid = WMI_PDEV_PKTLOG_ENABLE_CMDID,
+	.pdev_pktlog_disable_cmdid = WMI_PDEV_PKTLOG_DISABLE_CMDID,
+	.pdev_set_wmm_params_cmdid = WMI_PDEV_SET_WMM_PARAMS_CMDID,
+	.pdev_set_ht_cap_ie_cmdid = WMI_PDEV_SET_HT_CAP_IE_CMDID,
+	.pdev_set_vht_cap_ie_cmdid = WMI_PDEV_SET_VHT_CAP_IE_CMDID,
+	.pdev_set_dscp_tid_map_cmdid = WMI_PDEV_SET_DSCP_TID_MAP_CMDID,
+	.pdev_set_quiet_mode_cmdid = WMI_PDEV_SET_QUIET_MODE_CMDID,
+	.pdev_green_ap_ps_enable_cmdid = WMI_PDEV_GREEN_AP_PS_ENABLE_CMDID,
+	.pdev_get_tpc_config_cmdid = WMI_PDEV_GET_TPC_CONFIG_CMDID,
+	.pdev_set_base_macaddr_cmdid = WMI_PDEV_SET_BASE_MACADDR_CMDID,
+	.vdev_create_cmdid = WMI_VDEV_CREATE_CMDID,
+	.vdev_delete_cmdid = WMI_VDEV_DELETE_CMDID,
+	.vdev_start_request_cmdid = WMI_VDEV_START_REQUEST_CMDID,
+	.vdev_restart_request_cmdid = WMI_VDEV_RESTART_REQUEST_CMDID,
+	.vdev_up_cmdid = WMI_VDEV_UP_CMDID,
+	.vdev_stop_cmdid = WMI_VDEV_STOP_CMDID,
+	.vdev_down_cmdid = WMI_VDEV_DOWN_CMDID,
+	.vdev_set_param_cmdid = WMI_VDEV_SET_PARAM_CMDID,
+	.vdev_install_key_cmdid = WMI_VDEV_INSTALL_KEY_CMDID,
+	.peer_create_cmdid = WMI_PEER_CREATE_CMDID,
+	.peer_delete_cmdid = WMI_PEER_DELETE_CMDID,
+	.peer_flush_tids_cmdid = WMI_PEER_FLUSH_TIDS_CMDID,
+	.peer_set_param_cmdid = WMI_PEER_SET_PARAM_CMDID,
+	.peer_assoc_cmdid = WMI_PEER_ASSOC_CMDID,
+	.peer_add_wds_entry_cmdid = WMI_PEER_ADD_WDS_ENTRY_CMDID,
+	.peer_remove_wds_entry_cmdid = WMI_PEER_REMOVE_WDS_ENTRY_CMDID,
+	.peer_mcast_group_cmdid = WMI_PEER_MCAST_GROUP_CMDID,
+	.bcn_tx_cmdid = WMI_BCN_TX_CMDID,
+	.pdev_send_bcn_cmdid = WMI_PDEV_SEND_BCN_CMDID,
+	.bcn_tmpl_cmdid = WMI_BCN_TMPL_CMDID,
+	.bcn_filter_rx_cmdid = WMI_BCN_FILTER_RX_CMDID,
+	.prb_req_filter_rx_cmdid = WMI_PRB_REQ_FILTER_RX_CMDID,
+	.mgmt_tx_cmdid = WMI_MGMT_TX_CMDID,
+	.prb_tmpl_cmdid = WMI_PRB_TMPL_CMDID,
+	.addba_clear_resp_cmdid = WMI_ADDBA_CLEAR_RESP_CMDID,
+	.addba_send_cmdid = WMI_ADDBA_SEND_CMDID,
+	.addba_status_cmdid = WMI_ADDBA_STATUS_CMDID,
+	.delba_send_cmdid = WMI_DELBA_SEND_CMDID,
+	.addba_set_resp_cmdid = WMI_ADDBA_SET_RESP_CMDID,
+	.send_singleamsdu_cmdid = WMI_SEND_SINGLEAMSDU_CMDID,
+	.sta_powersave_mode_cmdid = WMI_STA_POWERSAVE_MODE_CMDID,
+	.sta_powersave_param_cmdid = WMI_STA_POWERSAVE_PARAM_CMDID,
+	.sta_mimo_ps_mode_cmdid = WMI_STA_MIMO_PS_MODE_CMDID,
+	.pdev_dfs_enable_cmdid = WMI_PDEV_DFS_ENABLE_CMDID,
+	.pdev_dfs_disable_cmdid = WMI_PDEV_DFS_DISABLE_CMDID,
+	.roam_scan_mode = WMI_ROAM_SCAN_MODE,
+	.roam_scan_rssi_threshold = WMI_ROAM_SCAN_RSSI_THRESHOLD,
+	.roam_scan_period = WMI_ROAM_SCAN_PERIOD,
+	.roam_scan_rssi_change_threshold = WMI_ROAM_SCAN_RSSI_CHANGE_THRESHOLD,
+	.roam_ap_profile = WMI_ROAM_AP_PROFILE,
+	.ofl_scan_add_ap_profile = WMI_ROAM_AP_PROFILE,
+	.ofl_scan_remove_ap_profile = WMI_OFL_SCAN_REMOVE_AP_PROFILE,
+	.ofl_scan_period = WMI_OFL_SCAN_PERIOD,
+	.p2p_dev_set_device_info = WMI_P2P_DEV_SET_DEVICE_INFO,
+	.p2p_dev_set_discoverability = WMI_P2P_DEV_SET_DISCOVERABILITY,
+	.p2p_go_set_beacon_ie = WMI_P2P_GO_SET_BEACON_IE,
+	.p2p_go_set_probe_resp_ie = WMI_P2P_GO_SET_PROBE_RESP_IE,
+	.p2p_set_vendor_ie_data_cmdid = WMI_P2P_SET_VENDOR_IE_DATA_CMDID,
+	.ap_ps_peer_param_cmdid = WMI_AP_PS_PEER_PARAM_CMDID,
+	.ap_ps_peer_uapsd_coex_cmdid = WMI_AP_PS_PEER_UAPSD_COEX_CMDID,
+	.peer_rate_retry_sched_cmdid = WMI_PEER_RATE_RETRY_SCHED_CMDID,
+	.wlan_profile_trigger_cmdid = WMI_WLAN_PROFILE_TRIGGER_CMDID,
+	.wlan_profile_set_hist_intvl_cmdid =
+				WMI_WLAN_PROFILE_SET_HIST_INTVL_CMDID,
+	.wlan_profile_get_profile_data_cmdid =
+				WMI_WLAN_PROFILE_GET_PROFILE_DATA_CMDID,
+	.wlan_profile_enable_profile_id_cmdid =
+				WMI_WLAN_PROFILE_ENABLE_PROFILE_ID_CMDID,
+	.wlan_profile_list_profile_id_cmdid =
+				WMI_WLAN_PROFILE_LIST_PROFILE_ID_CMDID,
+	.pdev_suspend_cmdid = WMI_PDEV_SUSPEND_CMDID,
+	.pdev_resume_cmdid = WMI_PDEV_RESUME_CMDID,
+	.add_bcn_filter_cmdid = WMI_ADD_BCN_FILTER_CMDID,
+	.rmv_bcn_filter_cmdid = WMI_RMV_BCN_FILTER_CMDID,
+	.wow_add_wake_pattern_cmdid = WMI_WOW_ADD_WAKE_PATTERN_CMDID,
+	.wow_del_wake_pattern_cmdid = WMI_WOW_DEL_WAKE_PATTERN_CMDID,
+	.wow_enable_disable_wake_event_cmdid =
+				WMI_WOW_ENABLE_DISABLE_WAKE_EVENT_CMDID,
+	.wow_enable_cmdid = WMI_WOW_ENABLE_CMDID,
+	.wow_hostwakeup_from_sleep_cmdid = WMI_WOW_HOSTWAKEUP_FROM_SLEEP_CMDID,
+	.rtt_measreq_cmdid = WMI_RTT_MEASREQ_CMDID,
+	.rtt_tsf_cmdid = WMI_RTT_TSF_CMDID,
+	.vdev_spectral_scan_configure_cmdid =
+				WMI_VDEV_SPECTRAL_SCAN_CONFIGURE_CMDID,
+	.vdev_spectral_scan_enable_cmdid = WMI_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
+	.request_stats_cmdid = WMI_REQUEST_STATS_CMDID,
+	.set_arp_ns_offload_cmdid = WMI_SET_ARP_NS_OFFLOAD_CMDID,
+	.network_list_offload_config_cmdid =
+				WMI_NETWORK_LIST_OFFLOAD_CONFIG_CMDID,
+	.gtk_offload_cmdid = WMI_GTK_OFFLOAD_CMDID,
+	.csa_offload_enable_cmdid = WMI_CSA_OFFLOAD_ENABLE_CMDID,
+	.csa_offload_chanswitch_cmdid = WMI_CSA_OFFLOAD_CHANSWITCH_CMDID,
+	.chatter_set_mode_cmdid = WMI_CHATTER_SET_MODE_CMDID,
+	.peer_tid_addba_cmdid = WMI_PEER_TID_ADDBA_CMDID,
+	.peer_tid_delba_cmdid = WMI_PEER_TID_DELBA_CMDID,
+	.sta_dtim_ps_method_cmdid = WMI_STA_DTIM_PS_METHOD_CMDID,
+	.sta_uapsd_auto_trig_cmdid = WMI_STA_UAPSD_AUTO_TRIG_CMDID,
+	.sta_keepalive_cmd = WMI_STA_KEEPALIVE_CMD,
+	.echo_cmdid = WMI_ECHO_CMDID,
+	.pdev_utf_cmdid = WMI_PDEV_UTF_CMDID,
+	.dbglog_cfg_cmdid = WMI_DBGLOG_CFG_CMDID,
+	.pdev_qvit_cmdid = WMI_PDEV_QVIT_CMDID,
+	.pdev_ftm_intg_cmdid = WMI_PDEV_FTM_INTG_CMDID,
+	.vdev_set_keepalive_cmdid = WMI_VDEV_SET_KEEPALIVE_CMDID,
+	.vdev_get_keepalive_cmdid = WMI_VDEV_GET_KEEPALIVE_CMDID,
+	.force_fw_hang_cmdid = WMI_FORCE_FW_HANG_CMDID,
+	.gpio_config_cmdid = WMI_GPIO_CONFIG_CMDID,
+	.gpio_output_cmdid = WMI_GPIO_OUTPUT_CMDID,
+};
+
+/* TODO: 10.X WMI cmd track */
+
 int ath10k_wmi_wait_for_service_ready(struct ath10k *ar)
 {
 	int ret;
@@ -64,7 +186,7 @@ static void ath10k_wmi_htc_tx_complete(struct ath10k *ar, struct sk_buff *skb)
 }
 
 static int ath10k_wmi_cmd_send_nowait(struct ath10k *ar, struct sk_buff *skb,
-				      enum wmi_cmd_id cmd_id)
+				      u32 cmd_id)
 {
 	struct ath10k_skb_cb *skb_cb = ATH10K_SKB_CB(skb);
 	struct wmi_cmd_hdr *cmd_hdr;
@@ -144,7 +266,7 @@ static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar)
 }
 
 static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
-			       enum wmi_cmd_id cmd_id)
+			       u32 cmd_id)
 {
 	int ret = -EINVAL;
 
@@ -1055,7 +1177,7 @@ static int ath10k_wmi_ready_event_rx(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
-static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
+static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
 	enum wmi_event_id id;
@@ -1174,14 +1296,31 @@ static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 
+static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
+{
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
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
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
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
@@ -1237,7 +1376,8 @@ int ath10k_wmi_pdev_set_regdomain(struct ath10k *ar, u16 rd, u16 rd2g,
 		   "wmi pdev regdomain rd %x rd2g %x rd5g %x ctl2g %x ctl5g %x\n",
 		   rd, rd2g, rd5g, ctl2g, ctl5g);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_REGDOMAIN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_regdomain_cmdid);
 }
 
 int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
@@ -1267,7 +1407,8 @@ int ath10k_wmi_pdev_set_channel(struct ath10k *ar,
 		   "wmi set channel mode %d freq %d\n",
 		   arg->mode, arg->freq);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_CHANNEL_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_channel_cmdid);
 }
 
 int ath10k_wmi_pdev_suspend_target(struct ath10k *ar)
@@ -1282,7 +1423,7 @@ int ath10k_wmi_pdev_suspend_target(struct ath10k *ar)
 	cmd = (struct wmi_pdev_suspend_cmd *)skb->data;
 	cmd->suspend_opt = WMI_PDEV_SUSPEND;
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SUSPEND_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_suspend_cmdid);
 }
 
 int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
@@ -1293,7 +1434,7 @@ int ath10k_wmi_pdev_resume_target(struct ath10k *ar)
 	if (skb == NULL)
 		return -ENOMEM;
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_RESUME_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_resume_cmdid);
 }
 
 int ath10k_wmi_pdev_set_param(struct ath10k *ar, enum wmi_pdev_param id,
@@ -1312,7 +1453,7 @@ int ath10k_wmi_pdev_set_param(struct ath10k *ar, enum wmi_pdev_param id,
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi pdev set param %d value %d\n",
 		   id, value);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->pdev_set_param_cmdid);
 }
 
 int ath10k_wmi_cmd_init(struct ath10k *ar)
@@ -1382,7 +1523,7 @@ int ath10k_wmi_cmd_init(struct ath10k *ar)
 	memcpy(&cmd->resource_config, &config, sizeof(config));
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi init\n");
-	return ath10k_wmi_cmd_send(ar, buf, WMI_INIT_CMDID);
+	return ath10k_wmi_cmd_send(ar, buf, ar->wmi.cmd->init_cmdid);
 }
 
 static int ath10k_wmi_start_scan_calc_len(const struct wmi_start_scan_arg *arg)
@@ -1543,7 +1684,7 @@ int ath10k_wmi_start_scan(struct ath10k *ar,
 	}
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi start scan\n");
-	return ath10k_wmi_cmd_send(ar, skb, WMI_START_SCAN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->start_scan_cmdid);
 }
 
 void ath10k_wmi_start_scan_init(struct ath10k *ar,
@@ -1603,7 +1744,7 @@ int ath10k_wmi_stop_scan(struct ath10k *ar, const struct wmi_stop_scan_arg *arg)
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi stop scan reqid %d req_type %d vdev/scan_id %d\n",
 		   arg->req_id, arg->req_type, arg->u.scan_id);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_STOP_SCAN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->stop_scan_cmdid);
 }
 
 int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
@@ -1628,7 +1769,7 @@ int ath10k_wmi_vdev_create(struct ath10k *ar, u32 vdev_id,
 		   "WMI vdev create: id %d type %d subtype %d macaddr %pM\n",
 		   vdev_id, type, subtype, macaddr);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_CREATE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_create_cmdid);
 }
 
 int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
@@ -1646,20 +1787,20 @@ int ath10k_wmi_vdev_delete(struct ath10k *ar, u32 vdev_id)
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "WMI vdev delete id %d\n", vdev_id);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_DELETE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_delete_cmdid);
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
+	if (cmd_id != ar->wmi.cmd->vdev_start_request_cmdid &&
+	    cmd_id != ar->wmi.cmd->vdev_restart_request_cmdid)
 		return -EINVAL;
 	if (WARN_ON(arg->ssid && arg->ssid_len == 0))
 		return -EINVAL;
@@ -1668,9 +1809,9 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 	if (WARN_ON(arg->ssid_len > sizeof(cmd->ssid.ssid)))
 		return -EINVAL;
 
-	if (cmd_id == WMI_VDEV_START_REQUEST_CMDID)
+	if (cmd_id == ar->wmi.cmd->vdev_start_request_cmdid)
 		cmdname = "start";
-	else if (cmd_id == WMI_VDEV_RESTART_REQUEST_CMDID)
+	else if (cmd_id == ar->wmi.cmd->vdev_restart_request_cmdid)
 		cmdname = "restart";
 	else
 		return -EINVAL; /* should not happen, we already check cmd_id */
@@ -1721,15 +1862,17 @@ static int ath10k_wmi_vdev_start_restart(struct ath10k *ar,
 int ath10k_wmi_vdev_start(struct ath10k *ar,
 			  const struct wmi_vdev_start_request_arg *arg)
 {
-	return ath10k_wmi_vdev_start_restart(ar, arg,
-					     WMI_VDEV_START_REQUEST_CMDID);
+	u32 cmd_id = ar->wmi.cmd->vdev_start_request_cmdid;
+
+	return ath10k_wmi_vdev_start_restart(ar, arg, cmd_id);
 }
 
 int ath10k_wmi_vdev_restart(struct ath10k *ar,
 		     const struct wmi_vdev_start_request_arg *arg)
 {
-	return ath10k_wmi_vdev_start_restart(ar, arg,
-					     WMI_VDEV_RESTART_REQUEST_CMDID);
+	u32 cmd_id = ar->wmi.cmd->vdev_restart_request_cmdid;
+
+	return ath10k_wmi_vdev_start_restart(ar, arg, cmd_id);
 }
 
 int ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id)
@@ -1746,7 +1889,7 @@ int ath10k_wmi_vdev_stop(struct ath10k *ar, u32 vdev_id)
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi vdev stop id 0x%x\n", vdev_id);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_STOP_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_stop_cmdid);
 }
 
 int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
@@ -1767,7 +1910,7 @@ int ath10k_wmi_vdev_up(struct ath10k *ar, u32 vdev_id, u32 aid, const u8 *bssid)
 		   "wmi mgmt vdev up id 0x%x assoc id %d bssid %pM\n",
 		   vdev_id, aid, bssid);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_UP_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_up_cmdid);
 }
 
 int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
@@ -1785,7 +1928,7 @@ int ath10k_wmi_vdev_down(struct ath10k *ar, u32 vdev_id)
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi mgmt vdev down id 0x%x\n", vdev_id);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_DOWN_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_down_cmdid);
 }
 
 int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
@@ -1807,7 +1950,7 @@ int ath10k_wmi_vdev_set_param(struct ath10k *ar, u32 vdev_id,
 		   "wmi vdev id 0x%x set param %d value %d\n",
 		   vdev_id, param_id, param_value);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_SET_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->vdev_set_param_cmdid);
 }
 
 int ath10k_wmi_vdev_install_key(struct ath10k *ar,
@@ -1842,7 +1985,8 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi vdev install key idx %d cipher %d len %d\n",
 		   arg->key_idx, arg->key_cipher, arg->key_len);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_VDEV_INSTALL_KEY_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->vdev_install_key_cmdid);
 }
 
 int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
@@ -1862,7 +2006,7 @@ int ath10k_wmi_peer_create(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer create vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_CREATE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_create_cmdid);
 }
 
 int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
@@ -1882,7 +2026,7 @@ int ath10k_wmi_peer_delete(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer delete vdev_id %d peer_addr %pM\n",
 		   vdev_id, peer_addr);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_DELETE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_delete_cmdid);
 }
 
 int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
@@ -1903,7 +2047,7 @@ int ath10k_wmi_peer_flush(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer flush vdev_id %d peer_addr %pM tids %08x\n",
 		   vdev_id, peer_addr, tid_bitmap);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_FLUSH_TIDS_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_flush_tids_cmdid);
 }
 
 int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
@@ -1927,7 +2071,7 @@ int ath10k_wmi_peer_set_param(struct ath10k *ar, u32 vdev_id,
 		   "wmi vdev %d peer 0x%pM set param %d value %d\n",
 		   vdev_id, peer_addr, param_id, param_value);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_SET_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_set_param_cmdid);
 }
 
 int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
@@ -1948,7 +2092,8 @@ int ath10k_wmi_set_psmode(struct ath10k *ar, u32 vdev_id,
 		   "wmi set powersave id 0x%x mode %d\n",
 		   vdev_id, psmode);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_STA_POWERSAVE_MODE_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->sta_powersave_mode_cmdid);
 }
 
 int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
@@ -1970,7 +2115,8 @@ int ath10k_wmi_set_sta_ps_param(struct ath10k *ar, u32 vdev_id,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi sta ps param vdev_id 0x%x param %d value %d\n",
 		   vdev_id, param_id, value);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_STA_POWERSAVE_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->sta_powersave_param_cmdid);
 }
 
 int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
@@ -1996,7 +2142,8 @@ int ath10k_wmi_set_ap_ps_param(struct ath10k *ar, u32 vdev_id, const u8 *mac,
 		   "wmi ap ps param vdev_id 0x%X param %d value %d mac_addr %pM\n",
 		   vdev_id, param_id, value, mac);
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_AP_PS_PEER_PARAM_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->ap_ps_peer_param_cmdid);
 }
 
 int ath10k_wmi_scan_chan_list(struct ath10k *ar,
@@ -2049,7 +2196,7 @@ int ath10k_wmi_scan_chan_list(struct ath10k *ar,
 		ci->flags            |= __cpu_to_le32(flags);
 	}
 
-	return ath10k_wmi_cmd_send(ar, skb, WMI_SCAN_CHAN_LIST_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->scan_chan_list_cmdid);
 }
 
 int ath10k_wmi_peer_assoc(struct ath10k *ar,
@@ -2108,7 +2255,7 @@ int ath10k_wmi_peer_assoc(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI,
 		   "wmi peer assoc vdev %d addr %pM\n",
 		   arg->vdev_id, arg->addr);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PEER_ASSOC_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->peer_assoc_cmdid);
 }
 
 int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
@@ -2128,7 +2275,7 @@ int ath10k_wmi_beacon_send_nowait(struct ath10k *ar,
 	cmd->hdr.bcn_len  = __cpu_to_le32(arg->bcn_len);
 	memcpy(cmd->bcn, arg->bcn, arg->bcn_len);
 
-	return ath10k_wmi_cmd_send_nowait(ar, skb, WMI_BCN_TX_CMDID);
+	return ath10k_wmi_cmd_send_nowait(ar, skb, ar->wmi.cmd->bcn_tx_cmdid);
 }
 
 static void ath10k_wmi_pdev_set_wmm_param(struct wmi_wmm_params *params,
@@ -2159,7 +2306,8 @@ int ath10k_wmi_pdev_set_wmm_params(struct ath10k *ar,
 	ath10k_wmi_pdev_set_wmm_param(&cmd->ac_vo, &arg->ac_vo);
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi pdev set wmm params\n");
-	return ath10k_wmi_cmd_send(ar, skb, WMI_PDEV_SET_WMM_PARAMS_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb,
+				   ar->wmi.cmd->pdev_set_wmm_params_cmdid);
 }
 
 int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
@@ -2175,7 +2323,7 @@ int ath10k_wmi_request_stats(struct ath10k *ar, enum wmi_stats_id stats_id)
 	cmd->stats_id = __cpu_to_le32(stats_id);
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi request stats %d\n", (int)stats_id);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_REQUEST_STATS_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->request_stats_cmdid);
 }
 
 int ath10k_wmi_force_fw_hang(struct ath10k *ar,
@@ -2194,5 +2342,5 @@ int ath10k_wmi_force_fw_hang(struct ath10k *ar,
 
 	ath10k_dbg(ATH10K_DBG_WMI, "wmi force fw hang %d delay %d\n",
 		   type, delay_ms);
-	return ath10k_wmi_cmd_send(ar, skb, WMI_FORCE_FW_HANG_CMDID);
+	return ath10k_wmi_cmd_send(ar, skb, ar->wmi.cmd->force_fw_hang_cmdid);
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 2c52c23..b8b446a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -208,6 +208,118 @@ struct wmi_mac_addr {
 	(c_macaddr)[5] = (((pwmi_mac_addr)->word1) >> 8) & 0xff; \
 	} while (0)
 
+struct wmi_cmd_map {
+	u32 init_cmdid;
+	u32 start_scan_cmdid;
+	u32 stop_scan_cmdid;
+	u32 scan_chan_list_cmdid;
+	u32 scan_sch_prio_tbl_cmdid;
+	u32 pdev_set_regdomain_cmdid;
+	u32 pdev_set_channel_cmdid;
+	u32 pdev_set_param_cmdid;
+	u32 pdev_pktlog_enable_cmdid;
+	u32 pdev_pktlog_disable_cmdid;
+	u32 pdev_set_wmm_params_cmdid;
+	u32 pdev_set_ht_cap_ie_cmdid;
+	u32 pdev_set_vht_cap_ie_cmdid;
+	u32 pdev_set_dscp_tid_map_cmdid;
+	u32 pdev_set_quiet_mode_cmdid;
+	u32 pdev_green_ap_ps_enable_cmdid;
+	u32 pdev_get_tpc_config_cmdid;
+	u32 pdev_set_base_macaddr_cmdid;
+	u32 vdev_create_cmdid;
+	u32 vdev_delete_cmdid;
+	u32 vdev_start_request_cmdid;
+	u32 vdev_restart_request_cmdid;
+	u32 vdev_up_cmdid;
+	u32 vdev_stop_cmdid;
+	u32 vdev_down_cmdid;
+	u32 vdev_set_param_cmdid;
+	u32 vdev_install_key_cmdid;
+	u32 peer_create_cmdid;
+	u32 peer_delete_cmdid;
+	u32 peer_flush_tids_cmdid;
+	u32 peer_set_param_cmdid;
+	u32 peer_assoc_cmdid;
+	u32 peer_add_wds_entry_cmdid;
+	u32 peer_remove_wds_entry_cmdid;
+	u32 peer_mcast_group_cmdid;
+	u32 bcn_tx_cmdid;
+	u32 pdev_send_bcn_cmdid;
+	u32 bcn_tmpl_cmdid;
+	u32 bcn_filter_rx_cmdid;
+	u32 prb_req_filter_rx_cmdid;
+	u32 mgmt_tx_cmdid;
+	u32 prb_tmpl_cmdid;
+	u32 addba_clear_resp_cmdid;
+	u32 addba_send_cmdid;
+	u32 addba_status_cmdid;
+	u32 delba_send_cmdid;
+	u32 addba_set_resp_cmdid;
+	u32 send_singleamsdu_cmdid;
+	u32 sta_powersave_mode_cmdid;
+	u32 sta_powersave_param_cmdid;
+	u32 sta_mimo_ps_mode_cmdid;
+	u32 pdev_dfs_enable_cmdid;
+	u32 pdev_dfs_disable_cmdid;
+	u32 roam_scan_mode;
+	u32 roam_scan_rssi_threshold;
+	u32 roam_scan_period;
+	u32 roam_scan_rssi_change_threshold;
+	u32 roam_ap_profile;
+	u32 ofl_scan_add_ap_profile;
+	u32 ofl_scan_remove_ap_profile;
+	u32 ofl_scan_period;
+	u32 p2p_dev_set_device_info;
+	u32 p2p_dev_set_discoverability;
+	u32 p2p_go_set_beacon_ie;
+	u32 p2p_go_set_probe_resp_ie;
+	u32 p2p_set_vendor_ie_data_cmdid;
+	u32 ap_ps_peer_param_cmdid;
+	u32 ap_ps_peer_uapsd_coex_cmdid;
+	u32 peer_rate_retry_sched_cmdid;
+	u32 wlan_profile_trigger_cmdid;
+	u32 wlan_profile_set_hist_intvl_cmdid;
+	u32 wlan_profile_get_profile_data_cmdid;
+	u32 wlan_profile_enable_profile_id_cmdid;
+	u32 wlan_profile_list_profile_id_cmdid;
+	u32 pdev_suspend_cmdid;
+	u32 pdev_resume_cmdid;
+	u32 add_bcn_filter_cmdid;
+	u32 rmv_bcn_filter_cmdid;
+	u32 wow_add_wake_pattern_cmdid;
+	u32 wow_del_wake_pattern_cmdid;
+	u32 wow_enable_disable_wake_event_cmdid;
+	u32 wow_enable_cmdid;
+	u32 wow_hostwakeup_from_sleep_cmdid;
+	u32 rtt_measreq_cmdid;
+	u32 rtt_tsf_cmdid;
+	u32 vdev_spectral_scan_configure_cmdid;
+	u32 vdev_spectral_scan_enable_cmdid;
+	u32 request_stats_cmdid;
+	u32 set_arp_ns_offload_cmdid;
+	u32 network_list_offload_config_cmdid;
+	u32 gtk_offload_cmdid;
+	u32 csa_offload_enable_cmdid;
+	u32 csa_offload_chanswitch_cmdid;
+	u32 chatter_set_mode_cmdid;
+	u32 peer_tid_addba_cmdid;
+	u32 peer_tid_delba_cmdid;
+	u32 sta_dtim_ps_method_cmdid;
+	u32 sta_uapsd_auto_trig_cmdid;
+	u32 sta_keepalive_cmd;
+	u32 echo_cmdid;
+	u32 pdev_utf_cmdid;
+	u32 dbglog_cfg_cmdid;
+	u32 pdev_qvit_cmdid;
+	u32 pdev_ftm_intg_cmdid;
+	u32 vdev_set_keepalive_cmdid;
+	u32 vdev_get_keepalive_cmdid;
+	u32 force_fw_hang_cmdid;
+	u32 gpio_config_cmdid;
+	u32 gpio_output_cmdid;
+};
+
 /*
  * wmi command groups.
  */
-- 
1.7.10

