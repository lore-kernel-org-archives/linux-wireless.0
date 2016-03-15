Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2940 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbcCOObz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 10:31:55 -0400
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>, <kvalo@codeaurora.org>,
	<mohammed@codeaurora.org>, <linux-wireless@vger.kernel.org>,
	"Mohammed Shafi Shajakhan" <mohammed@qti.qualcomm.com>
Subject: [PATCH 2/2] ath10k: Enable parsing per station rx duration for 10.4
Date: Tue, 15 Mar 2016 20:00:50 +0530
Message-ID: <1458052250-2529-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160315_153208_741723_39AC7C3E)
In-Reply-To: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1458052250-2529-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Rx duration support for per station is part of extended peer
stats, enable provision to parse the same and provide backward
compatibility based on the 'stats_id' event

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.c |   19 ++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/wmi.c  |   30 ++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/wmi.h  |   16 ++++++++++++++++
 3 files changed, 58 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 2389c07..5e37e61 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1534,7 +1534,8 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->num_active_peers = TARGET_10_4_ACTIVE_PEERS;
 		ar->max_num_vdevs = TARGET_10_4_NUM_VDEVS;
 		ar->num_tids = TARGET_10_4_TGT_NUM_TIDS;
-		ar->fw_stats_req_mask = WMI_STAT_PEER;
+		ar->fw_stats_req_mask = WMI_10_4_STAT_PEER |
+					WMI_10_4_STAT_PEER_EXTD;
 		ar->max_spatial_stream = ar->hw_params.max_spatial_stream;
 
 		if (test_bit(ATH10K_FW_FEATURE_PEER_FLOW_CONTROL,
@@ -1579,6 +1580,7 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 {
 	int status;
+	u32 val;
 
 	lockdep_assert_held(&ar->conf_mutex);
 
@@ -1699,6 +1701,21 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 	ath10k_dbg(ar, ATH10K_DBG_BOOT, "firmware %s booted\n",
 		   ar->hw->wiphy->fw_version);
 
+	if (test_bit(WMI_SERVICE_EXT_RES_CFG_SUPPORT, ar->wmi.svc_map)) {
+		val = 0;
+		if (ath10k_peer_stats_enabled(ar))
+			val = WMI_10_4_PEER_STATS;
+
+		status = ath10k_wmi_ext_resource_config(ar,
+							WMI_HOST_PLATFORM_HIGH_PERF, val);
+		if (status) {
+			ath10k_err(ar,
+				   "failed to send ext resource cfg command : %d\n",
+				   status);
+			goto err_hif_stop;
+		}
+	}
+
 	status = ath10k_wmi_cmd_init(ar);
 	if (status) {
 		ath10k_err(ar, "could not send WMI init command (%d)\n",
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index fcef9a0..7542ed8 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2632,6 +2632,16 @@ void ath10k_wmi_pull_peer_stats(const struct wmi_peer_stats *src,
 	dst->peer_tx_rate = __le32_to_cpu(src->peer_tx_rate);
 }
 
+static void
+ath10k_wmi_10_4_pull_peer_stats(const struct wmi_10_4_peer_stats *src,
+				struct ath10k_fw_stats_peer *dst)
+{
+	ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
+	dst->peer_rssi = __le32_to_cpu(src->peer_rssi);
+	dst->peer_tx_rate = __le32_to_cpu(src->peer_tx_rate);
+	dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
+}
+
 static int ath10k_wmi_main_op_pull_fw_stats(struct ath10k *ar,
 					    struct sk_buff *skb,
 					    struct ath10k_fw_stats *stats)
@@ -2925,6 +2935,7 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 	u32 num_pdev_ext_stats;
 	u32 num_vdev_stats;
 	u32 num_peer_stats;
+	u32 stats_id;
 	int i;
 
 	if (!skb_pull(skb, sizeof(*ev)))
@@ -2934,6 +2945,7 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 	num_pdev_ext_stats = __le32_to_cpu(ev->num_pdev_ext_stats);
 	num_vdev_stats = __le32_to_cpu(ev->num_vdev_stats);
 	num_peer_stats = __le32_to_cpu(ev->num_peer_stats);
+	stats_id = __le32_to_cpu(ev->stats_id);
 
 	for (i = 0; i < num_pdev_stats; i++) {
 		const struct wmi_10_4_pdev_stats *src;
@@ -2973,22 +2985,28 @@ static int ath10k_wmi_10_4_op_pull_fw_stats(struct ath10k *ar,
 	/* fw doesn't implement vdev stats */
 
 	for (i = 0; i < num_peer_stats; i++) {
-		const struct wmi_10_4_peer_stats *src;
+		const struct wmi_10_4_peer_extd_stats *src;
 		struct ath10k_fw_stats_peer *dst;
+		int stats_len;
+		bool extd_peer_stats = !!(stats_id & WMI_10_4_STAT_PEER_EXTD);
+
+		if (extd_peer_stats)
+			stats_len = sizeof(struct wmi_10_4_peer_extd_stats);
+		else
+			stats_len = sizeof(struct wmi_10_4_peer_stats);
 
 		src = (void *)skb->data;
-		if (!skb_pull(skb, sizeof(*src)))
+		if (!skb_pull(skb, stats_len))
 			return -EPROTO;
 
 		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
 		if (!dst)
 			continue;
 
-		ether_addr_copy(dst->peer_macaddr, src->peer_macaddr.addr);
-		dst->peer_rssi = __le32_to_cpu(src->peer_rssi);
-		dst->peer_tx_rate = __le32_to_cpu(src->peer_tx_rate);
-		dst->peer_rx_rate = __le32_to_cpu(src->peer_rx_rate);
+		ath10k_wmi_10_4_pull_peer_stats(&src->common, dst);
 		/* FIXME: expose 10.4 specific values */
+		if (extd_peer_stats)
+			dst->rx_duration = src->rx_duration;
 
 		list_add_tail(&dst->list, &stats->peers);
 	}
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index 1d3e085..8626bb1 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -4104,6 +4104,13 @@ enum wmi_stats_id {
 	WMI_STAT_VDEV_RATE = BIT(5),
 };
 
+enum wmi_10_4_stats_id {
+	WMI_10_4_STAT_PEER		= BIT(0),
+	WMI_10_4_STAT_AP		= BIT(1),
+	WMI_10_4_STAT_INST		= BIT(2),
+	WMI_10_4_STAT_PEER_EXTD		= BIT(3),
+};
+
 struct wlan_inst_rssi_args {
 	__le16 cfg_retry_count;
 	__le16 retry_count;
@@ -4303,6 +4310,15 @@ struct wmi_10_4_peer_stats {
 	__le32 peer_rssi_changed;
 } __packed;
 
+struct wmi_10_4_peer_extd_stats {
+	struct wmi_10_4_peer_stats common;
+	struct wmi_mac_addr peer_macaddr;
+	__le32 inactive_time;
+	__le32 peer_chain_rssi;
+	__le32 rx_duration;
+	__le32 reserved[10];
+} __packed;
+
 struct wmi_10_2_pdev_ext_stats {
 	__le32 rx_rssi_comb;
 	__le32 rx_rssi[4];
-- 
1.7.9.5

