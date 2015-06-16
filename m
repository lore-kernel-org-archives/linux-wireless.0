Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:45147 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183AbbFPFyy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2015 01:54:54 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH 4/8] ath10k: add scan support for 10.4 fw
Date: Tue, 16 Jun 2015 11:23:11 +0530
Message-ID: <1434433995-8451-5-git-send-email-rmani@qti.qualcomm.com> (sfid-20150616_075458_050490_20C09081)
In-Reply-To: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434433995-8451-1-git-send-email-rmani@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Existing non 10.4 firmware scan related events and commands are
matching with 10.4 firmware (except chan info event). Link general
start scan,stop scan, scan channel list configuration functions
to 10.4 wmi function table and add a new handler to parse 10.4
specific chan info event.

10.4 firmware has extra scan completion reason
WMI_SCAN_REASON_INTERNAL_FAILURE compared to previous firmware
versions. This is added in scan completion reason enum.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 35 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h | 14 ++++++++++++++
 2 files changed, 49 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index da21597..00201eb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1837,6 +1837,8 @@ ath10k_wmi_event_scan_type_str(enum wmi_scan_event_type type,
 			return "completed [preempted]";
 		case WMI_SCAN_REASON_TIMEDOUT:
 			return "completed [timedout]";
+		case WMI_SCAN_REASON_INTERNAL_FAILURE:
+			return "completed [internal err]";
 		case WMI_SCAN_REASON_MAX:
 			break;
 		}
@@ -2232,6 +2234,28 @@ static int ath10k_wmi_op_pull_ch_info_ev(struct ath10k *ar, struct sk_buff *skb,
 	return 0;
 }
 
+static int ath10k_wmi_10_4_op_pull_ch_info_ev(struct ath10k *ar,
+					      struct sk_buff *skb,
+					      struct wmi_ch_info_ev_arg *arg)
+{
+	struct wmi_10_4_chan_info_event *ev = (void *)skb->data;
+
+	if (skb->len < sizeof(*ev))
+		return -EPROTO;
+
+	skb_pull(skb, sizeof(*ev));
+	arg->err_code = ev->err_code;
+	arg->freq = ev->freq;
+	arg->cmd_flags = ev->cmd_flags;
+	arg->noise_floor = ev->noise_floor;
+	arg->rx_clear_count = ev->rx_clear_count;
+	arg->cycle_count = ev->cycle_count;
+	arg->chan_tx_pwr_range = ev->chan_tx_pwr_range;
+	arg->chan_tx_pwr_tp = ev->chan_tx_pwr_tp;
+
+	return 0;
+}
+
 void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_ch_info_ev_arg arg = {};
@@ -4341,6 +4365,12 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_SERVICE_READY_EVENTID:
 		ath10k_wmi_event_service_ready(ar, skb);
 		break;
+	case WMI_10_4_SCAN_EVENTID:
+		ath10k_wmi_event_scan(ar, skb);
+		break;
+	case WMI_10_4_CHAN_INFO_EVENTID:
+		ath10k_wmi_event_chan_info(ar, skb);
+		break;
 	case WMI_10_4_READY_EVENTID:
 		ath10k_wmi_event_ready(ar, skb);
 		break;
@@ -6296,7 +6326,10 @@ static const struct wmi_ops wmi_10_2_4_ops = {
 static const struct wmi_ops wmi_10_4_ops = {
 	.rx = ath10k_wmi_10_4_op_rx,
 	.map_svc = wmi_10_4_svc_map,
+
+	.pull_scan = ath10k_wmi_op_pull_scan_ev,
 	.pull_mgmt_rx = ath10k_wmi_10_4_op_pull_mgmt_rx_ev,
+	.pull_ch_info = ath10k_wmi_10_4_op_pull_ch_info_ev,
 	.pull_vdev_start = ath10k_wmi_op_pull_vdev_start_ev,
 	.pull_peer_kick = ath10k_wmi_op_pull_peer_kick_ev,
 	.pull_swba = ath10k_wmi_10_4_op_pull_swba_ev,
@@ -6308,6 +6341,8 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
 	.gen_init = ath10k_wmi_10_4_op_gen_init,
+	.gen_start_scan = ath10k_wmi_op_gen_start_scan,
+	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
 	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
 	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
 	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index df66581..90c872c 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2850,6 +2850,7 @@ enum wmi_scan_completion_reason {
 	WMI_SCAN_REASON_CANCELLED,
 	WMI_SCAN_REASON_PREEMPTED,
 	WMI_SCAN_REASON_TIMEDOUT,
+	WMI_SCAN_REASON_INTERNAL_FAILURE,
 	WMI_SCAN_REASON_MAX,
 };
 
@@ -5497,6 +5498,17 @@ struct wmi_chan_info_event {
 	__le32 cycle_count;
 } __packed;
 
+struct wmi_10_4_chan_info_event {
+	__le32 err_code;
+	__le32 freq;
+	__le32 cmd_flags;
+	__le32 noise_floor;
+	__le32 rx_clear_count;
+	__le32 cycle_count;
+	__le32 chan_tx_pwr_range;
+	__le32 chan_tx_pwr_tp;
+} __packed;
+
 struct wmi_peer_sta_kickout_event {
 	struct wmi_mac_addr peer_macaddr;
 } __packed;
@@ -5677,6 +5689,8 @@ struct wmi_ch_info_ev_arg {
 	__le32 noise_floor;
 	__le32 rx_clear_count;
 	__le32 cycle_count;
+	__le32 chan_tx_pwr_range;
+	__le32 chan_tx_pwr_tp;
 };
 
 struct wmi_vdev_start_ev_arg {
-- 
1.8.1.2

