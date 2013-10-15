Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:49754 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751782Ab3JOHzr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Oct 2013 03:55:47 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 1/2] ath10k: rename WMI_CMD_UNDEFINED
Date: Tue, 15 Oct 2013 09:55:31 +0200
Message-ID: <1381823732-10128-1-git-send-email-bartosz.markowski@tieto.com> (sfid-20131015_095551_457788_59AB8661)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rename WMI_CMD_UNDEFINED to WMI_CMD_UNSUPPORTED. This is more
accurate here. Also return -EOPNOTSUPP instead of -EINVAL in
wmi_cmd_send().

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |   46 ++++++++++++++++-----------------
 drivers/net/wireless/ath/ath10k/wmi.h |    2 +-
 2 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index f9766fa..ea2669b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -149,7 +149,7 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.start_scan_cmdid = WMI_10X_START_SCAN_CMDID,
 	.stop_scan_cmdid = WMI_10X_STOP_SCAN_CMDID,
 	.scan_chan_list_cmdid = WMI_10X_SCAN_CHAN_LIST_CMDID,
-	.scan_sch_prio_tbl_cmdid = WMI_CMD_UNDEFINED,
+	.scan_sch_prio_tbl_cmdid = WMI_CMD_UNSUPPORTED,
 	.pdev_set_regdomain_cmdid = WMI_10X_PDEV_SET_REGDOMAIN_CMDID,
 	.pdev_set_channel_cmdid = WMI_10X_PDEV_SET_CHANNEL_CMDID,
 	.pdev_set_param_cmdid = WMI_10X_PDEV_SET_PARAM_CMDID,
@@ -182,11 +182,11 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.peer_mcast_group_cmdid = WMI_10X_PEER_MCAST_GROUP_CMDID,
 	.bcn_tx_cmdid = WMI_10X_BCN_TX_CMDID,
 	.pdev_send_bcn_cmdid = WMI_10X_PDEV_SEND_BCN_CMDID,
-	.bcn_tmpl_cmdid = WMI_CMD_UNDEFINED,
+	.bcn_tmpl_cmdid = WMI_CMD_UNSUPPORTED,
 	.bcn_filter_rx_cmdid = WMI_10X_BCN_FILTER_RX_CMDID,
 	.prb_req_filter_rx_cmdid = WMI_10X_PRB_REQ_FILTER_RX_CMDID,
 	.mgmt_tx_cmdid = WMI_10X_MGMT_TX_CMDID,
-	.prb_tmpl_cmdid = WMI_CMD_UNDEFINED,
+	.prb_tmpl_cmdid = WMI_CMD_UNSUPPORTED,
 	.addba_clear_resp_cmdid = WMI_10X_ADDBA_CLEAR_RESP_CMDID,
 	.addba_send_cmdid = WMI_10X_ADDBA_SEND_CMDID,
 	.addba_status_cmdid = WMI_10X_ADDBA_STATUS_CMDID,
@@ -211,9 +211,9 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.p2p_dev_set_discoverability = WMI_10X_P2P_DEV_SET_DISCOVERABILITY,
 	.p2p_go_set_beacon_ie = WMI_10X_P2P_GO_SET_BEACON_IE,
 	.p2p_go_set_probe_resp_ie = WMI_10X_P2P_GO_SET_PROBE_RESP_IE,
-	.p2p_set_vendor_ie_data_cmdid = WMI_CMD_UNDEFINED,
-	.ap_ps_peer_param_cmdid = WMI_CMD_UNDEFINED,
-	.ap_ps_peer_uapsd_coex_cmdid = WMI_CMD_UNDEFINED,
+	.p2p_set_vendor_ie_data_cmdid = WMI_CMD_UNSUPPORTED,
+	.ap_ps_peer_param_cmdid = WMI_CMD_UNSUPPORTED,
+	.ap_ps_peer_uapsd_coex_cmdid = WMI_CMD_UNSUPPORTED,
 	.peer_rate_retry_sched_cmdid = WMI_10X_PEER_RATE_RETRY_SCHED_CMDID,
 	.wlan_profile_trigger_cmdid = WMI_10X_WLAN_PROFILE_TRIGGER_CMDID,
 	.wlan_profile_set_hist_intvl_cmdid =
@@ -242,25 +242,25 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.vdev_spectral_scan_enable_cmdid =
 				WMI_10X_VDEV_SPECTRAL_SCAN_ENABLE_CMDID,
 	.request_stats_cmdid = WMI_10X_REQUEST_STATS_CMDID,
-	.set_arp_ns_offload_cmdid = WMI_CMD_UNDEFINED,
-	.network_list_offload_config_cmdid = WMI_CMD_UNDEFINED,
-	.gtk_offload_cmdid = WMI_CMD_UNDEFINED,
-	.csa_offload_enable_cmdid = WMI_CMD_UNDEFINED,
-	.csa_offload_chanswitch_cmdid = WMI_CMD_UNDEFINED,
-	.chatter_set_mode_cmdid = WMI_CMD_UNDEFINED,
-	.peer_tid_addba_cmdid = WMI_CMD_UNDEFINED,
-	.peer_tid_delba_cmdid = WMI_CMD_UNDEFINED,
-	.sta_dtim_ps_method_cmdid = WMI_CMD_UNDEFINED,
-	.sta_uapsd_auto_trig_cmdid = WMI_CMD_UNDEFINED,
-	.sta_keepalive_cmd = WMI_CMD_UNDEFINED,
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
 	.echo_cmdid = WMI_10X_ECHO_CMDID,
 	.pdev_utf_cmdid = WMI_10X_PDEV_UTF_CMDID,
 	.dbglog_cfg_cmdid = WMI_10X_DBGLOG_CFG_CMDID,
 	.pdev_qvit_cmdid = WMI_10X_PDEV_QVIT_CMDID,
-	.pdev_ftm_intg_cmdid = WMI_CMD_UNDEFINED,
-	.vdev_set_keepalive_cmdid = WMI_CMD_UNDEFINED,
-	.vdev_get_keepalive_cmdid = WMI_CMD_UNDEFINED,
-	.force_fw_hang_cmdid = WMI_CMD_UNDEFINED,
+	.pdev_ftm_intg_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_set_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.vdev_get_keepalive_cmdid = WMI_CMD_UNSUPPORTED,
+	.force_fw_hang_cmdid = WMI_CMD_UNSUPPORTED,
 	.gpio_config_cmdid = WMI_10X_GPIO_CONFIG_CMDID,
 	.gpio_output_cmdid = WMI_10X_GPIO_OUTPUT_CMDID,
 };
@@ -611,9 +611,9 @@ static void ath10k_wmi_op_ep_tx_credits(struct ath10k *ar)
 static int ath10k_wmi_cmd_send(struct ath10k *ar, struct sk_buff *skb,
 			       u32 cmd_id)
 {
-	int ret = -EINVAL;
+	int ret = -EOPNOTSUPP;
 
-	if (cmd_id == WMI_CMD_UNDEFINED) {
+	if (cmd_id == WMI_CMD_UNSUPPORTED) {
 		ath10k_warn("wmi command %d is not supported by firmware\n",
 			    cmd_id);
 		return ret;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 7692c14..78c991a 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -359,7 +359,7 @@ enum wmi_cmd_group {
 #define WMI_CMD_GRP(grp_id) (((grp_id) << 12) | 0x1)
 #define WMI_EVT_GRP_START_ID(grp_id) (((grp_id) << 12) | 0x1)
 
-#define WMI_CMD_UNDEFINED 0
+#define WMI_CMD_UNSUPPORTED 0
 
 /* Command IDs and command events for MAIN FW. */
 enum wmi_cmd_id {
-- 
1.7.10

