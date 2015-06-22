Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:16711 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbbFVOxf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:53:35 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 3/8] ath10k: enable vdev and peer related operations for 10.4 fw
Date: Mon, 22 Jun 2015 20:22:22 +0530
Message-ID: <1434984747-24294-4-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_165338_976970_B891452D)
In-Reply-To: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Most of existing vdev and peer related functions (vdev create,
vdev delete, vdev start, peer create, peer delete, peer flush, etc)
are reusable for 10.4 firmware. Link those general vdev and peer
functions to 10.4 wmi function table.

Existing general pktlog enable/disable, dbglog configuration functions
are reusable for 10.4 and add them also in wmi function table.

Also handle few wmi events (sevice rdy, echo, dbg msg, tbtt offset
update, dbg print) in ath10k_wmi_10_4_op_rx(). wow event is not
applicable in 10.4 firmware, have it under not implemented print.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 62 +++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 48ea442..c4d777d 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4418,12 +4418,40 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_mgmt_rx(ar, skb);
 		/* mgmt_rx() owns the skb now! */
 		return;
+	case WMI_10_4_ECHO_EVENTID:
+		ath10k_wmi_event_echo(ar, skb);
+		break;
+	case WMI_10_4_DEBUG_MESG_EVENTID:
+		ath10k_wmi_event_debug_mesg(ar, skb);
+		break;
+	case WMI_10_4_SERVICE_READY_EVENTID:
+		ath10k_wmi_event_service_ready(ar, skb);
+		break;
 	case WMI_10_4_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
+	case WMI_10_4_PEER_STA_KICKOUT_EVENTID:
+		ath10k_wmi_event_peer_sta_kickout(ar, skb);
+		break;
 	case WMI_10_4_HOST_SWBA_EVENTID:
 		ath10k_wmi_event_host_swba(ar, skb);
 		break;
+	case WMI_10_4_TBTTOFFSET_UPDATE_EVENTID:
+		ath10k_wmi_event_tbttoffset_update(ar, skb);
+		break;
+	case WMI_10_4_DEBUG_PRINT_EVENTID:
+		ath10k_wmi_event_debug_print(ar, skb);
+		break;
+	case WMI_10_4_VDEV_START_RESP_EVENTID:
+		ath10k_wmi_event_vdev_start_resp(ar, skb);
+		break;
+	case WMI_10_4_VDEV_STOPPED_EVENTID:
+		ath10k_wmi_event_vdev_stopped(ar, skb);
+		break;
+	case WMI_10_4_WOW_WAKEUP_HOST_EVENTID:
+		ath10k_dbg(ar, ATH10K_DBG_WMI,
+			   "received event id %d not implemented\n", id);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
@@ -6355,10 +6383,44 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.rx = ath10k_wmi_10_4_op_rx,
 	.map_svc = wmi_10_4_svc_map,
 	.pull_mgmt_rx = ath10k_wmi_10_4_op_pull_mgmt_rx_ev,
+	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
+	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_10_4_op_pull_swba_ev,
 	.pull_svc_rdy = ath10k_wmi_main_op_pull_svc_rdy_ev,
 	.pull_rdy = ath10k_wmi_op_pull_rdy_ev,
+
+	.gen_pdev_suspend = ath10k_wmi_op_gen_pdev_suspend,
+	.gen_pdev_resume = ath10k_wmi_op_gen_pdev_resume,
+	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
+	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
 	.gen_init = ath10k_wmi_10_4_op_gen_init,
+	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
+	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
+	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
+	.gen_vdev_stop = ath10k_wmi_op_gen_vdev_stop,
+	.gen_vdev_up = ath10k_wmi_op_gen_vdev_up,
+	.gen_vdev_down = ath10k_wmi_op_gen_vdev_down,
+	.gen_vdev_set_param = ath10k_wmi_op_gen_vdev_set_param,
+	.gen_vdev_install_key = ath10k_wmi_op_gen_vdev_install_key,
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
+	.gen_force_fw_hang = ath10k_wmi_op_gen_force_fw_hang,
+	.gen_mgmt_tx = ath10k_wmi_op_gen_mgmt_tx,
+	.gen_dbglog_cfg = ath10k_wmi_op_gen_dbglog_cfg,
+	.gen_pktlog_enable = ath10k_wmi_op_gen_pktlog_enable,
+	.gen_pktlog_disable = ath10k_wmi_op_gen_pktlog_disable,
+	.gen_pdev_set_quiet_mode = ath10k_wmi_op_gen_pdev_set_quiet_mode,
+
+	/* shared with 10.2 */
+	.gen_peer_assoc = ath10k_wmi_10_2_op_gen_peer_assoc,
 };
 
 int ath10k_wmi_attach(struct ath10k *ar)
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
