Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:51990 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751430AbeEKVmV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 11 May 2018 17:42:21 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath10k:  Support survey dump for ath10k-ct 10.1 firmware.
Date: Fri, 11 May 2018 14:42:11 -0700
Message-Id: <1526074931-23885-3-git-send-email-greearb@candelatech.com> (sfid-20180511_234225_537373_19DC27B5)
In-Reply-To: <1526074931-23885-1-git-send-email-greearb@candelatech.com>
References: <1526074931-23885-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Recent ath10k-ct 10.1 firmware supports survey results, and
advertises the appropriate service flags.  This confuses
the ath10k driver because the 10.1 wmi commands are not set up
for survey information.  So, this patch adds support for
handling survey information.  Example output:

Survey data from wlan0
	frequency:			5180 MHz [in use]
	noise:				-97 dBm
	channel active time:		44 ms
	channel busy time:		15 ms
	channel receive time:		7 ms
	channel transmit time:		7 ms
Survey data from wlan0
	frequency:			5200 MHz
	noise:				-98 dBm
	channel active time:		46 ms
	channel busy time:		2 ms
...

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/wmi.c | 54 +++++++++++++++++++++++++++++++----
 drivers/net/wireless/ath/ath10k/wmi.h |  8 ++++++
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index df2e92a..3497873 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -365,7 +365,8 @@ static struct wmi_cmd_map wmi_10x_cmd_map = {
 	.vdev_filter_neighbor_rx_packets_cmdid = WMI_CMD_UNSUPPORTED,
 	.mu_cal_start_cmdid = WMI_CMD_UNSUPPORTED,
 	.set_cca_params_cmdid = WMI_CMD_UNSUPPORTED,
-	.pdev_bss_chan_info_request_cmdid = WMI_CMD_UNSUPPORTED,
+	.pdev_bss_chan_info_request_cmdid =
+		WMI_10_2_PDEV_BSS_CHAN_INFO_REQUEST_CMDID,
 	.pdev_get_tpc_table_cmdid = WMI_CMD_UNSUPPORTED,
 };
 
@@ -2830,9 +2831,15 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
 	for (i = 0; i < num_peer_stats; i++) {
 		const struct wmi_10x_peer_stats *src;
 		struct ath10k_fw_stats_peer *dst;
+		int stats_len;
+
+		if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map))
+			stats_len = sizeof(struct wmi_10x_peer_stats_ct_ext);
+		else
+			stats_len = sizeof(*src);
 
 		src = (void *)skb->data;
-		if (!skb_pull(skb, sizeof(*src)))
+		if (!skb_pull(skb, stats_len))
 			return -EPROTO;
 
 		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
@@ -2843,6 +2850,12 @@ static int ath10k_wmi_10x_op_pull_fw_stats(struct ath10k *ar,
 
 		dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
 
+		if (ath10k_peer_stats_enabled(ar)) {
+			struct wmi_10x_peer_stats_ct_ext *src2 = (void *)(src);
+
+			dst->rx_duration = __le32_to_cpu(src2->rx_duration);
+		}
+
 		list_add_tail(&dst->list, &stats->peers);
 	}
 
@@ -5488,7 +5501,7 @@ static void ath10k_wmi_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_service_available(ar, skb);
 		break;
 	default:
-		ath10k_warn(ar, "Unknown eventid: %d\n", id);
+		ath10k_warn(ar, "Unknown (main) eventid: %d\n", id);
 		break;
 	}
 
@@ -5618,8 +5631,11 @@ static void ath10k_wmi_10_1_op_rx(struct ath10k *ar, struct sk_buff *skb)
 	case WMI_10X_PDEV_UTF_EVENTID:
 		/* ignore utf events */
 		break;
+	case WMI_10_1_PDEV_BSS_CHAN_INFO_EVENTID: /* Newer CT 10.1 firmware */
+		ath10k_wmi_event_pdev_bss_chan_info(ar, skb);
+		break;
 	default:
-		ath10k_warn(ar, "Unknown eventid: %d\n", id);
+		ath10k_warn(ar, "Unknown (10.1) eventid: %d\n", id);
 		break;
 	}
 
@@ -5765,7 +5781,7 @@ static void ath10k_wmi_10_2_op_rx(struct ath10k *ar, struct sk_buff *skb)
 			   "received event id %d not implemented\n", id);
 		break;
 	default:
-		ath10k_warn(ar, "Unknown eventid: %d\n", id);
+		ath10k_warn(ar, "Unknown (10.2) eventid: %d\n", id);
 		break;
 	}
 
@@ -5879,7 +5895,7 @@ static void ath10k_wmi_10_4_op_rx(struct ath10k *ar, struct sk_buff *skb)
 		ath10k_wmi_event_tpc_final_table(ar, skb);
 		break;
 	default:
-		ath10k_warn(ar, "Unknown eventid: %d\n", id);
+		ath10k_warn(ar, "Unknown (10.4) eventid: %d\n", id);
 		break;
 	}
 
@@ -6174,6 +6190,26 @@ static struct sk_buff *ath10k_wmi_10_1_op_gen_init(struct ath10k *ar)
 	config.num_msdu_desc = __cpu_to_le32(TARGET_10X_NUM_MSDU_DESC);
 	config.max_frag_entries = __cpu_to_le32(TARGET_10X_MAX_FRAG_ENTRIES);
 
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT,
+		     ar->running_fw->fw_file.fw_features)) {
+		u32 features = 0;
+
+		if (test_bit(ATH10K_FLAG_BTCOEX, &ar->dev_flags) &&
+		    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
+			features |= WMI_10_2_COEX_GPIO;
+
+		if (ath10k_peer_stats_enabled(ar))
+			features |= WMI_10_2_PEER_STATS;
+
+		if (test_bit(WMI_SERVICE_BSS_CHANNEL_INFO_64, ar->wmi.svc_map))
+			features |= WMI_10_2_BSS_CHAN_INFO;
+
+		/* CT firmware uses high 8 bits of rx_decap_mode to pass the
+		 * features flags
+		 */
+		config.rx_decap_mode |= __cpu_to_le32(features << 24);
+	}
+
 	len = sizeof(*cmd) +
 	      (sizeof(struct host_memory_chunk) * ar->wmi.num_mem_chunks);
 
@@ -8642,6 +8678,12 @@ static const struct wmi_ops wmi_10_1_ops = {
 	/* .gen_p2p_go_bcn_ie not implemented */
 	/* .gen_adaptive_qcs not implemented */
 	/* .gen_pdev_enable_adaptive_cca not implemented */
+
+	/* Some CT 10.1 firmware supports this.  Non-CT 10.1 firmware will not
+	 * advertise WMI_SERVICE_BSS_CHANNEL_INFO_64, so it will never be called
+	 * in the first place.
+	 */
+	.gen_pdev_bss_chan_info_req = ath10k_wmi_10_2_op_gen_pdev_bss_chan_info,
 };
 
 static const struct wmi_ops wmi_10_2_ops = {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 16a3924..645da12 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -1463,6 +1463,8 @@ enum wmi_10x_event_id {
 	WMI_10X_PDEV_TPC_CONFIG_EVENTID,
 
 	WMI_10X_GPIO_INPUT_EVENTID,
+
+	WMI_10_1_PDEV_BSS_CHAN_INFO_EVENTID = 36900, /* Newer CT firmware */
 	WMI_10X_PDEV_UTF_EVENTID = WMI_10X_END_EVENTID - 1,
 };
 
@@ -4616,6 +4618,12 @@ struct wmi_10x_peer_stats {
 	__le32 peer_rx_rate;
 } __packed;
 
+struct wmi_10x_peer_stats_ct_ext {
+	struct wmi_peer_stats old;
+	__le32 peer_rx_rate;
+	__le32 rx_duration;
+} __packed;
+
 struct wmi_10_2_peer_stats {
 	struct wmi_peer_stats old;
 	__le32 peer_rx_rate;
-- 
2.4.11
