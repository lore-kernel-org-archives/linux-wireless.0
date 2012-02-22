Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59639 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2BVK6K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Feb 2012 05:58:10 -0500
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: [PATCH 3/5] ath6kl: Refactor ath6kl_wmi_control_rx()
Date: Wed, 22 Feb 2012 16:27:30 +0530
Message-ID: <1329908252-16645-3-git-send-email-vthiagar@qca.qualcomm.com> (sfid-20120222_115815_087115_9904B641)
In-Reply-To: <1329908252-16645-1-git-send-email-vthiagar@qca.qualcomm.com>
References: <1329908252-16645-1-git-send-email-vthiagar@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split the wmi event processing into the one which needs to be
vif specific and the reset. This is a step towards avoiding
the need for wiphy and a netdev registration before getting
any message from firmware.

Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/wmi.c |  200 ++++++++++++++++-----------------
 1 files changed, 99 insertions(+), 101 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/wmi.c b/drivers/net/wireless/ath/ath6kl/wmi.c
index bbbe0a7..0527933 100644
--- a/drivers/net/wireless/ath/ath6kl/wmi.c
+++ b/drivers/net/wireless/ath/ath6kl/wmi.c
@@ -3369,32 +3369,101 @@ static int ath6kl_wmi_roam_tbl_event_rx(struct wmi *wmi, u8 *datap, int len)
 	return ath6kl_debug_roam_tbl_event(wmi->parent_dev, datap, len);
 }
 
-/* Control Path */
-int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
+/* Process interface specific wmi events, caller would free the datap */
+static int ath6kl_wmi_proc_events_iface(struct wmi *wmi, u16 if_idx, u16 cmd_id,
+					u8 *datap, u32 len)
 {
-	struct wmi_cmd_hdr *cmd;
 	struct ath6kl_vif *vif;
-	u32 len;
-	u16 id;
-	u8 if_idx;
-	u8 *datap;
-	int ret = 0;
 
-	if (WARN_ON(skb == NULL))
+	vif = ath6kl_get_vif_by_index(wmi->parent_dev, if_idx);
+	if (!vif) {
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "Wmi event for unavailable vif, vif_index:%d\n",
+			    if_idx);
 		return -EINVAL;
+	}
 
-	if (skb->len < sizeof(struct wmi_cmd_hdr)) {
-		ath6kl_err("bad packet 1\n");
-		dev_kfree_skb(skb);
+	switch (cmd_id) {
+	case WMI_CONNECT_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CONNECT_EVENTID\n");
+		return ath6kl_wmi_connect_event_rx(wmi, datap, len, vif);
+	case WMI_DISCONNECT_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DISCONNECT_EVENTID\n");
+		return ath6kl_wmi_disconnect_event_rx(wmi, datap, len, vif);
+	case WMI_TKIP_MICERR_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TKIP_MICERR_EVENTID\n");
+		return ath6kl_wmi_tkip_micerr_event_rx(wmi, datap, len, vif);
+	case WMI_BSSINFO_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_BSSINFO_EVENTID\n");
+		return ath6kl_wmi_bssinfo_event_rx(wmi, datap, len, vif);
+	case WMI_NEIGHBOR_REPORT_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_NEIGHBOR_REPORT_EVENTID\n");
+		return ath6kl_wmi_neighbor_report_event_rx(wmi, datap, len,
+							   vif);
+	case WMI_SCAN_COMPLETE_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_SCAN_COMPLETE_EVENTID\n");
+		return ath6kl_wmi_scan_complete_rx(wmi, datap, len, vif);
+	case WMI_REPORT_STATISTICS_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REPORT_STATISTICS_EVENTID\n");
+		return ath6kl_wmi_stats_event_rx(wmi, datap, len, vif);
+	case WMI_CAC_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CAC_EVENTID\n");
+		return ath6kl_wmi_cac_event_rx(wmi, datap, len, vif);
+	case WMI_PSPOLL_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_PSPOLL_EVENTID\n");
+		return ath6kl_wmi_pspoll_event_rx(wmi, datap, len, vif);
+	case WMI_DTIMEXPIRY_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DTIMEXPIRY_EVENTID\n");
+		return ath6kl_wmi_dtimexpiry_event_rx(wmi, datap, len, vif);
+	case WMI_ADDBA_REQ_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_ADDBA_REQ_EVENTID\n");
+		return ath6kl_wmi_addba_req_event_rx(wmi, datap, len, vif);
+	case WMI_DELBA_REQ_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DELBA_REQ_EVENTID\n");
+		return ath6kl_wmi_delba_req_event_rx(wmi, datap, len, vif);
+	case WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID");
+		return ath6kl_wmi_host_sleep_mode_cmd_prcd_evt_rx(wmi, vif);
+	case WMI_REMAIN_ON_CHNL_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REMAIN_ON_CHNL_EVENTID\n");
+		return ath6kl_wmi_remain_on_chnl_event_rx(wmi, datap, len, vif);
+	case WMI_CANCEL_REMAIN_ON_CHNL_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI,
+			   "WMI_CANCEL_REMAIN_ON_CHNL_EVENTID\n");
+		return ath6kl_wmi_cancel_remain_on_chnl_event_rx(wmi, datap,
+								 len, vif);
+	case WMI_TX_STATUS_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_STATUS_EVENTID\n");
+		return ath6kl_wmi_tx_status_event_rx(wmi, datap, len, vif);
+	case WMI_RX_PROBE_REQ_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_PROBE_REQ_EVENTID\n");
+		return ath6kl_wmi_rx_probe_req_event_rx(wmi, datap, len, vif);
+	case WMI_RX_ACTION_EVENTID:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_ACTION_EVENTID\n");
+		return ath6kl_wmi_rx_action_event_rx(wmi, datap, len, vif);
+	default:
+		ath6kl_dbg(ATH6KL_DBG_WMI, "unknown cmd id 0x%x\n", cmd_id);
 		return -EINVAL;
 	}
 
+	return 0;
+}
+
+static int ath6kl_wmi_proc_events(struct wmi *wmi, struct sk_buff *skb)
+{
+	struct wmi_cmd_hdr *cmd;
+	int ret = 0;
+	u32 len;
+	u16 id;
+	u8 if_idx;
+	u8 *datap;
+
 	cmd = (struct wmi_cmd_hdr *) skb->data;
 	id = le16_to_cpu(cmd->cmd_id);
 	if_idx = le16_to_cpu(cmd->info1) & WMI_CMD_HDR_IF_ID_MASK;
 
 	skb_pull(skb, sizeof(struct wmi_cmd_hdr));
-
 	datap = skb->data;
 	len = skb->len;
 
@@ -3402,15 +3471,6 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 	ath6kl_dbg_dump(ATH6KL_DBG_WMI_DUMP, NULL, "wmi rx ",
 			datap, len);
 
-	vif = ath6kl_get_vif_by_index(wmi->parent_dev, if_idx);
-	if (!vif) {
-		ath6kl_dbg(ATH6KL_DBG_WMI,
-			   "Wmi event for unavailable vif, vif_index:%d\n",
-			    if_idx);
-		dev_kfree_skb(skb);
-		return -EINVAL;
-	}
-
 	switch (id) {
 	case WMI_GET_BITRATE_CMDID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_GET_BITRATE_CMDID\n");
@@ -3428,26 +3488,10 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_READY_EVENTID\n");
 		ret = ath6kl_wmi_ready_event_rx(wmi, datap, len);
 		break;
-	case WMI_CONNECT_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CONNECT_EVENTID\n");
-		ret = ath6kl_wmi_connect_event_rx(wmi, datap, len, vif);
-		break;
-	case WMI_DISCONNECT_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DISCONNECT_EVENTID\n");
-		ret = ath6kl_wmi_disconnect_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_PEER_NODE_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_PEER_NODE_EVENTID\n");
 		ret = ath6kl_wmi_peer_node_event_rx(wmi, datap, len);
 		break;
-	case WMI_TKIP_MICERR_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TKIP_MICERR_EVENTID\n");
-		ret = ath6kl_wmi_tkip_micerr_event_rx(wmi, datap, len, vif);
-		break;
-	case WMI_BSSINFO_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_BSSINFO_EVENTID\n");
-		ret = ath6kl_wmi_bssinfo_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_REGDOMAIN_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REGDOMAIN_EVENTID\n");
 		ath6kl_wmi_regdomain_event(wmi, datap, len);
@@ -3456,23 +3500,10 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_PSTREAM_TIMEOUT_EVENTID\n");
 		ret = ath6kl_wmi_pstream_timeout_event_rx(wmi, datap, len);
 		break;
-	case WMI_NEIGHBOR_REPORT_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_NEIGHBOR_REPORT_EVENTID\n");
-		ret = ath6kl_wmi_neighbor_report_event_rx(wmi, datap, len,
-							  vif);
-		break;
-	case WMI_SCAN_COMPLETE_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_SCAN_COMPLETE_EVENTID\n");
-		ret = ath6kl_wmi_scan_complete_rx(wmi, datap, len, vif);
-		break;
 	case WMI_CMDERROR_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CMDERROR_EVENTID\n");
 		ret = ath6kl_wmi_error_event_rx(wmi, datap, len);
 		break;
-	case WMI_REPORT_STATISTICS_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REPORT_STATISTICS_EVENTID\n");
-		ret = ath6kl_wmi_stats_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_RSSI_THRESHOLD_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RSSI_THRESHOLD_EVENTID\n");
 		ret = ath6kl_wmi_rssi_threshold_event_rx(wmi, datap, len);
@@ -3492,10 +3523,6 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_EXTENSION_EVENTID\n");
 		ret = ath6kl_wmi_control_rx_xtnd(wmi, skb);
 		break;
-	case WMI_CAC_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CAC_EVENTID\n");
-		ret = ath6kl_wmi_cac_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_CHANNEL_CHANGE_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_CHANNEL_CHANGE_EVENTID\n");
 		break;
@@ -3535,28 +3562,12 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_GET_PMKID_LIST_EVENTID\n");
 		ret = ath6kl_wmi_get_pmkid_list_event_rx(wmi, datap, len);
 		break;
-	case WMI_PSPOLL_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_PSPOLL_EVENTID\n");
-		ret = ath6kl_wmi_pspoll_event_rx(wmi, datap, len, vif);
-		break;
-	case WMI_DTIMEXPIRY_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DTIMEXPIRY_EVENTID\n");
-		ret = ath6kl_wmi_dtimexpiry_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_SET_PARAMS_REPLY_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_SET_PARAMS_REPLY_EVENTID\n");
 		break;
-	case WMI_ADDBA_REQ_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_ADDBA_REQ_EVENTID\n");
-		ret = ath6kl_wmi_addba_req_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_ADDBA_RESP_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_ADDBA_RESP_EVENTID\n");
 		break;
-	case WMI_DELBA_REQ_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_DELBA_REQ_EVENTID\n");
-		ret = ath6kl_wmi_delba_req_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_REPORT_BTCOEX_CONFIG_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI,
 			   "WMI_REPORT_BTCOEX_CONFIG_EVENTID\n");
@@ -3569,52 +3580,39 @@ int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_COMPLETE_EVENTID\n");
 		ret = ath6kl_wmi_tx_complete_event_rx(datap, len);
 		break;
-	case WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI,
-			   "WMI_SET_HOST_SLEEP_MODE_CMD_PROCESSED_EVENTID");
-		ret = ath6kl_wmi_host_sleep_mode_cmd_prcd_evt_rx(wmi, vif);
-		break;
-	case WMI_REMAIN_ON_CHNL_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_REMAIN_ON_CHNL_EVENTID\n");
-		ret = ath6kl_wmi_remain_on_chnl_event_rx(wmi, datap, len, vif);
-		break;
-	case WMI_CANCEL_REMAIN_ON_CHNL_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI,
-			   "WMI_CANCEL_REMAIN_ON_CHNL_EVENTID\n");
-		ret = ath6kl_wmi_cancel_remain_on_chnl_event_rx(wmi, datap,
-								len, vif);
-		break;
-	case WMI_TX_STATUS_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_TX_STATUS_EVENTID\n");
-		ret = ath6kl_wmi_tx_status_event_rx(wmi, datap, len, vif);
-		break;
-	case WMI_RX_PROBE_REQ_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_PROBE_REQ_EVENTID\n");
-		ret = ath6kl_wmi_rx_probe_req_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_P2P_CAPABILITIES_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_CAPABILITIES_EVENTID\n");
 		ret = ath6kl_wmi_p2p_capabilities_event_rx(datap, len);
 		break;
-	case WMI_RX_ACTION_EVENTID:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_RX_ACTION_EVENTID\n");
-		ret = ath6kl_wmi_rx_action_event_rx(wmi, datap, len, vif);
-		break;
 	case WMI_P2P_INFO_EVENTID:
 		ath6kl_dbg(ATH6KL_DBG_WMI, "WMI_P2P_INFO_EVENTID\n");
 		ret = ath6kl_wmi_p2p_info_event_rx(datap, len);
 		break;
 	default:
-		ath6kl_dbg(ATH6KL_DBG_WMI, "unknown cmd id 0x%x\n", id);
-		ret = -EINVAL;
+		/* may be the event is interface specific */
+		ret = ath6kl_wmi_proc_events_iface(wmi, if_idx, id, datap, len);
 		break;
 	}
 
 	dev_kfree_skb(skb);
-
 	return ret;
 }
 
+/* Control Path */
+int ath6kl_wmi_control_rx(struct wmi *wmi, struct sk_buff *skb)
+{
+	if (WARN_ON(skb == NULL))
+		return -EINVAL;
+
+	if (skb->len < sizeof(struct wmi_cmd_hdr)) {
+		ath6kl_err("bad packet 1\n");
+		dev_kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return ath6kl_wmi_proc_events(wmi, skb);
+}
+
 void ath6kl_wmi_reset(struct wmi *wmi)
 {
 	spin_lock_bh(&wmi->lock);
-- 
1.7.0.4

