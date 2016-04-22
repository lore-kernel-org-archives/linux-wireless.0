Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:61079 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315AbcDVFrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Apr 2016 01:47:14 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>, <rmanohar@codeaurora.org>,
	"Rajkumar Manoharan" <rmanohar@qti.qualcomm.com>
Subject: [PATCH 3/4] ath10k: handle pdev_chan_info wmi event
Date: Fri, 22 Apr 2016 11:16:31 +0530
Message-ID: <1461303992-9913-3-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20160422_074717_394161_281ABB48)
In-Reply-To: <1461303992-9913-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1461303992-9913-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add handler to process bss channel information wmi event that
will be received upon sending pdev_chan_info_request wmi command.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 32 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.h | 11 +++++++++++
 2 files changed, 43 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index d6157d3587c5..0f6b8c73a562 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -4796,6 +4796,32 @@ static int ath10k_wmi_event_temperature(struct ath10k *ar, struct sk_buff *skb)
 	return 0;
 }
 
+static int ath10k_wmi_event_pdev_bss_chan_info(struct ath10k *ar,
+					       struct sk_buff *skb)
+{
+	struct wmi_pdev_bss_chan_info_event *ev;
+	u64 busy, total, tx, rx, rx_bss;
+	u32 freq, noise_floor;
+
+	ev = (struct wmi_pdev_bss_chan_info_event *)skb->data;
+	if (WARN_ON(skb->len < sizeof(*ev)))
+		return -EPROTO;
+
+	freq        = __le32_to_cpu(ev->freq);
+	noise_floor = __le32_to_cpu(ev->noise_floor);
+	busy        = __le64_to_cpu(ev->cycle_busy);
+	total       = __le64_to_cpu(ev->cycle_total);
+	tx          = __le64_to_cpu(ev->cycle_tx);
+	rx          = __le64_to_cpu(ev->cycle_rx);
+	rx_bss      = __le64_to_cpu(ev->cycle_rx_bss);
+
+	ath10k_dbg(ar, ATH10K_DBG_WMI,
+		   "wmi event pdev bss chan info:\n freq: %d noise: %d cycle: busy %llu total %llu tx %llu rx %llu rx_bss %llu\n",
+		   freq, noise_floor, busy, total, tx, rx, rx_bss);
+
+	return 0;
+}
+
 static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 {
 	struct wmi_cmd_hdr *cmd_hdr;
@@ -5139,6 +5165,9 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_2_PDEV_TEMPERATURE_EVENTID:
 		ath10k_wmi_event_temperature(ar, skb);
 		break;
+	case WMI_10_2_PDEV_BSS_CHAN_INFO_EVENTID:
+		ath10k_wmi_event_pdev_bss_chan_info(ar, skb);
+		break;
 	case WMI_10_2_RTT_KEEPALIVE_EVENTID:
 	case WMI_10_2_GPIO_INPUT_EVENTID:
 	case WMI_10_2_PEER_RATECODE_LIST_EVENTID:
@@ -5225,6 +5254,9 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10_4_PDEV_TEMPERATURE_EVENTID:
 		ath10k_wmi_event_temperature(ar, skb);
 		break;
+	case WMI_10_4_PDEV_BSS_CHAN_INFO_EVENTID:
+		ath10k_wmi_event_pdev_bss_chan_info(ar, skb);
+		break;
 	default:
 		ath10k_warn(ar, "Unknown eventid: %d\n", id);
 		break;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 4cdf216ae999..e1043b81a6e6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -6284,6 +6284,17 @@ struct wmi_pdev_temperature_event {
 	__le32 temperature;
 } __packed;
 
+struct wmi_pdev_bss_chan_info_event {
+	__le32 freq;
+	__le32 noise_floor;
+	__le64 cycle_busy;
+	__le64 cycle_total;
+	__le64 cycle_tx;
+	__le64 cycle_rx;
+	__le64 cycle_rx_bss;
+	__le32 reserved;
+} __packed;
+
 /* WOW structures */
 enum wmi_wow_wakeup_event {
 	WOW_BMISS_EVENT = 0,
-- 
2.8.0

