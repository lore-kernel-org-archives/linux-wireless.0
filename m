Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:53485 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3IYJi2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 05:38:28 -0400
From: Bartosz Markowski <bartosz.markowski@tieto.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Bartosz Markowski <bartosz.markowski@tieto.com>
Subject: [PATCH 04/13] ath10k: implement WMI events handling frame for both firmwares
Date: Wed, 25 Sep 2013 11:38:02 +0200
Message-ID: <1380101891-18312-5-git-send-email-bartosz.markowski@tieto.com> (sfid-20130925_114831_845040_C8E4DD79)
In-Reply-To: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
References: <1380101891-18312-1-git-send-email-bartosz.markowski@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We still use the same function handlers for both main and 10.X
paths. Next step is to track down and make the split needed.

Signed-off-by: Bartosz Markowski <bartosz.markowski@tieto.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c |  131 ++++++++++++++++++++++++++++++++-
 1 file changed, 130 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index ed137b8..7bbe51f 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1220,6 +1220,24 @@ static void ath10k_wmi_event_vdev_install_key_complete(struct ath10k *ar,
 	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_INSTALL_KEY_COMPLETE_EVENTID\n");
 }
 
+static void ath10k_wmi_event_inst_rssi_stats(struct ath10k *ar,
+					     struct sk_buff *skb)
+{
+	ath10k_dbg(ATH10K_DBG_WMI, "WMI_INST_RSSI_STATS_EVENTID\n");
+}
+
+static void ath10k_wmi_event_vdev_standby_req(struct ath10k *ar,
+					      struct sk_buff *skb)
+{
+	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_STANDBY_REQ_EVENTID\n");
+}
+
+static void ath10k_wmi_event_vdev_resume_req(struct ath10k *ar,
+					     struct sk_buff *skb)
+{
+	ath10k_dbg(ATH10K_DBG_WMI, "WMI_VDEV_RESUME_REQ_EVENTID\n");
+}
+
 static void ath10k_wmi_service_ready_event_rx(struct ath10k *ar,
 					      struct sk_buff *skb)
 {
@@ -1430,10 +1448,121 @@ static void ath10k_wmi_main_process_rx(struct ath10k *ar, struct sk_buff *skb)
 	dev_kfree_skb(skb);
 }
 
+static void ath10k_wmi_10x_process_rx(struct ath10k *ar, struct sk_buff *skb)
+{
+	struct wmi_cmd_hdr *cmd_hdr;
+	enum wmi_10x_event_id id;
+	u16 len;
+
+	cmd_hdr = (struct wmi_cmd_hdr *)skb->data;
+	id = MS(__le32_to_cpu(cmd_hdr->cmd_id), WMI_CMD_HDR_CMD_ID);
+
+	if (skb_pull(skb, sizeof(struct wmi_cmd_hdr)) == NULL)
+		return;
+
+	len = skb->len;
+
+	trace_ath10k_wmi_event(id, skb->data, skb->len);
+
+	switch (id) {
+	case WMI_10X_MGMT_RX_EVENTID:
+		ath10k_wmi_event_mgmt_rx(ar, skb);
+		/* mgmt_rx() owns the skb now! */
+		return;
+	case WMI_10X_SCAN_EVENTID:
+		ath10k_wmi_event_scan(ar, skb);
+		break;
+	case WMI_10X_CHAN_INFO_EVENTID:
+		ath10k_wmi_event_chan_info(ar, skb);
+		break;
+	case WMI_10X_ECHO_EVENTID:
+		ath10k_wmi_event_echo(ar, skb);
+		break;
+	case WMI_10X_DEBUG_MESG_EVENTID:
+		ath10k_wmi_event_debug_mesg(ar, skb);
+		break;
+	case WMI_10X_UPDATE_STATS_EVENTID:
+		ath10k_wmi_event_update_stats(ar, skb);
+		break;
+	case WMI_10X_VDEV_START_RESP_EVENTID:
+		ath10k_wmi_event_vdev_start_resp(ar, skb);
+		break;
+	case WMI_10X_VDEV_STOPPED_EVENTID:
+		ath10k_wmi_event_vdev_stopped(ar, skb);
+		break;
+	case WMI_10X_PEER_STA_KICKOUT_EVENTID:
+		ath10k_wmi_event_peer_sta_kickout(ar, skb);
+		break;
+	case WMI_10X_HOST_SWBA_EVENTID:
+		ath10k_wmi_event_host_swba(ar, skb);
+		break;
+	case WMI_10X_TBTTOFFSET_UPDATE_EVENTID:
+		ath10k_wmi_event_tbttoffset_update(ar, skb);
+		break;
+	case WMI_10X_PHYERR_EVENTID:
+		ath10k_wmi_event_phyerr(ar, skb);
+		break;
+	case WMI_10X_ROAM_EVENTID:
+		ath10k_wmi_event_roam(ar, skb);
+		break;
+	case WMI_10X_PROFILE_MATCH:
+		ath10k_wmi_event_profile_match(ar, skb);
+		break;
+	case WMI_10X_DEBUG_PRINT_EVENTID:
+		ath10k_wmi_event_debug_print(ar, skb);
+		break;
+	case WMI_10X_PDEV_QVIT_EVENTID:
+		ath10k_wmi_event_pdev_qvit(ar, skb);
+		break;
+	case WMI_10X_WLAN_PROFILE_DATA_EVENTID:
+		ath10k_wmi_event_wlan_profile_data(ar, skb);
+		break;
+	case WMI_10X_RTT_MEASUREMENT_REPORT_EVENTID:
+		ath10k_wmi_event_rtt_measurement_report(ar, skb);
+		break;
+	case WMI_10X_TSF_MEASUREMENT_REPORT_EVENTID:
+		ath10k_wmi_event_tsf_measurement_report(ar, skb);
+		break;
+	case WMI_10X_RTT_ERROR_REPORT_EVENTID:
+		ath10k_wmi_event_rtt_error_report(ar, skb);
+		break;
+	case WMI_10X_WOW_WAKEUP_HOST_EVENTID:
+		ath10k_wmi_event_wow_wakeup_host(ar, skb);
+		break;
+	case WMI_10X_DCS_INTERFERENCE_EVENTID:
+		ath10k_wmi_event_dcs_interference(ar, skb);
+		break;
+	case WMI_10X_PDEV_TPC_CONFIG_EVENTID:
+		ath10k_wmi_event_pdev_tpc_config(ar, skb);
+		break;
+	case WMI_10X_INST_RSSI_STATS_EVENTID:
+		ath10k_wmi_event_inst_rssi_stats(ar, skb);
+		break;
+	case WMI_10X_VDEV_STANDBY_REQ_EVENTID:
+		ath10k_wmi_event_vdev_standby_req(ar, skb);
+		break;
+	case WMI_10X_VDEV_RESUME_REQ_EVENTID:
+		ath10k_wmi_event_vdev_resume_req(ar, skb);
+		break;
+	case WMI_10X_SERVICE_READY_EVENTID:
+		ath10k_wmi_service_ready_event_rx(ar, skb);
+		break;
+	case WMI_10X_READY_EVENTID:
+		ath10k_wmi_ready_event_rx(ar, skb);
+		break;
+	default:
+		ath10k_warn("Unknown eventid: %d\n", id);
+		break;
+	}
+
+	dev_kfree_skb(skb);
+}
+
+
 static void ath10k_wmi_process_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	if (test_bit(ATH10K_FW_FEATURE_10X, ar->fw_features))
-		ath10k_warn("Firmware 10.X is not yet supported\n");
+		ath10k_wmi_10x_process_rx(ar, skb);
 	else
 		ath10k_wmi_main_process_rx(ar, skb);
 }
-- 
1.7.10

