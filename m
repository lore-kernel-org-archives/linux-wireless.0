Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17934 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbbFVOxv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Jun 2015 10:53:51 -0400
From: Raja Mani <rmani@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>,
	Raja Mani <rmani@qti.qualcomm.com>
Subject: [PATCH v2 4/8] ath10k: add scan support for 10.4 fw
Date: Mon, 22 Jun 2015 20:22:23 +0530
Message-ID: <1434984747-24294-5-git-send-email-rmani@qti.qualcomm.com> (sfid-20150622_165357_326829_A80F8E5C)
In-Reply-To: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
References: <1434984747-24294-1-git-send-email-rmani@qti.qualcomm.com>
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
WMI_SCAN_REASON_INTERNAL_FAILURE and new scan event
WMI_SCAN_EVENT_FOREIGN_CHANNEL_EXIT compared to previous firmware
versions. These things are added in respective enum.

Signed-off-by: Raja Mani <rmani@qti.qualcomm.com>
---
v2 changes:
 - WMI_SCAN_EVENT_FOREIGN_CHANNEL_EXIT is added newly.
 - BIT() macro is used to define the values of "enum wmi_scan_event_type"
 - New member rx_frame_count is added in struct wmi_10_4_chan_info_event

 drivers/net/wireless/ath/ath10k/wmi.c | 42 +++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h | 36 ++++++++++++++++++++++--------
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index c4d777d..fffdae1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -1923,6 +1923,8 @@ ath10k_wmi_event_scan_type_str(enum wmi_scan_event_type type,
 			return "completed [preempted]";
 		case WMI_SCAN_REASON_TIMEDOUT:
 			return "completed [timedout]";
+		case WMI_SCAN_REASON_INTERNAL_FAILURE:
+			return "completed [internal err]";
 		case WMI_SCAN_REASON_MAX:
 			break;
 		}
@@ -1937,6 +1939,10 @@ ath10k_wmi_event_scan_type_str(enum wmi_scan_event_type type,
 		return "preempted";
 	case WMI_SCAN_EVENT_START_FAILED:
 		return "start failed";
+	case WMI_SCAN_EVENT_RESTARTED:
+		return "restarted";
+	case WMI_SCAN_EVENT_FOREIGN_CHANNEL_EXIT:
+		return "foreign channel exit";
 	default:
 		return "unknown";
 	}
@@ -2012,6 +2018,8 @@ int ath10k_wmi_event_scan(struct ath10k *ar, struct sk_buff *skb)
 		break;
 	case WMI_SCAN_EVENT_DEQUEUED:
 	case WMI_SCAN_EVENT_PREEMPTED:
+	case WMI_SCAN_EVENT_RESTARTED:
+	case WMI_SCAN_EVENT_FOREIGN_CHANNEL_EXIT:
 	default:
 		break;
 	}
@@ -2318,6 +2326,29 @@ static int ath10k_wmi_op_pull_ch_info_ev(struct ath10k *ar, struct sk_buff *skb,
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
+	arg->rx_frame_count = ev->rx_frame_count;
+
+	return 0;
+}
+
 void ath10k_wmi_event_chan_info(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_ch_info_ev_arg arg = {};
@@ -4427,6 +4458,12 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
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
@@ -6382,7 +6419,10 @@ static const struct wmi_ops wmi_10_2_4_ops = {
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
@@ -6394,6 +6434,8 @@ static const struct wmi_ops wmi_10_4_ops = {
 	.gen_pdev_set_rd = ath10k_wmi_10x_op_gen_pdev_set_rd,
 	.gen_pdev_set_param = ath10k_wmi_op_gen_pdev_set_param,
 	.gen_init = ath10k_wmi_10_4_op_gen_init,
+	.gen_start_scan = ath10k_wmi_op_gen_start_scan,
+	.gen_stop_scan = ath10k_wmi_op_gen_stop_scan,
 	.gen_vdev_create = ath10k_wmi_op_gen_vdev_create,
 	.gen_vdev_delete = ath10k_wmi_op_gen_vdev_delete,
 	.gen_vdev_start = ath10k_wmi_op_gen_vdev_start,
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 395742d..6e806cb 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -2879,15 +2879,17 @@ enum wmi_bss_filter {
 };
 
 enum wmi_scan_event_type {
-	WMI_SCAN_EVENT_STARTED         = 0x1,
-	WMI_SCAN_EVENT_COMPLETED       = 0x2,
-	WMI_SCAN_EVENT_BSS_CHANNEL     = 0x4,
-	WMI_SCAN_EVENT_FOREIGN_CHANNEL = 0x8,
-	WMI_SCAN_EVENT_DEQUEUED        = 0x10,
-	WMI_SCAN_EVENT_PREEMPTED       = 0x20, /* possibly by high-prio scan */
-	WMI_SCAN_EVENT_START_FAILED    = 0x40,
-	WMI_SCAN_EVENT_RESTARTED       = 0x80,
-	WMI_SCAN_EVENT_MAX             = 0x8000
+	WMI_SCAN_EVENT_STARTED              = BIT(0),
+	WMI_SCAN_EVENT_COMPLETED            = BIT(1),
+	WMI_SCAN_EVENT_BSS_CHANNEL          = BIT(2),
+	WMI_SCAN_EVENT_FOREIGN_CHANNEL      = BIT(3),
+	WMI_SCAN_EVENT_DEQUEUED             = BIT(4),
+	/* possibly by high-prio scan */
+	WMI_SCAN_EVENT_PREEMPTED            = BIT(5),
+	WMI_SCAN_EVENT_START_FAILED         = BIT(6),
+	WMI_SCAN_EVENT_RESTARTED            = BIT(7),
+	WMI_SCAN_EVENT_FOREIGN_CHANNEL_EXIT = BIT(8),
+	WMI_SCAN_EVENT_MAX                  = BIT(15),
 };
 
 enum wmi_scan_completion_reason {
@@ -2895,6 +2897,7 @@ enum wmi_scan_completion_reason {
 	WMI_SCAN_REASON_CANCELLED,
 	WMI_SCAN_REASON_PREEMPTED,
 	WMI_SCAN_REASON_TIMEDOUT,
+	WMI_SCAN_REASON_INTERNAL_FAILURE,
 	WMI_SCAN_REASON_MAX,
 };
 
@@ -5564,6 +5567,18 @@ struct wmi_chan_info_event {
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
+	__le32 rx_frame_count;
+} __packed;
+
 struct wmi_peer_sta_kickout_event {
 	struct wmi_mac_addr peer_macaddr;
 } __packed;
@@ -5744,6 +5759,9 @@ struct wmi_ch_info_ev_arg {
 	__le32 noise_floor;
 	__le32 rx_clear_count;
 	__le32 cycle_count;
+	__le32 chan_tx_pwr_range;
+	__le32 chan_tx_pwr_tp;
+	__le32 rx_frame_count;
 };
 
 struct wmi_vdev_start_ev_arg {
-- 
1.8.1.2

--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
