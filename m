Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:30753 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201AbcAMPrI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 10:47:08 -0500
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
To: <ath10k@lists.infradead.org>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Subject: [PATCH 1/7] ath10k: Add support for parsing per STA rx_duration for 10.2.4
Date: Wed, 13 Jan 2016 21:16:28 +0530
Message-ID: <1452699994-5078-2-git-send-email-mohammed@qca.qualcomm.com> (sfid-20160113_164719_325969_15B04DEC)
In-Reply-To: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1452699994-5078-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>

Add support for parsing 'peer_rx_duration' as part
of 10.2.4 peer_stats. Also register PEER_STATS service
for parsing 'rx_duration' (and for any new fields to be added
as part of peer_stats). Have checks for backward compatibility with
older 10.2.4 firmware incase PEER_STATS service is not enabled

Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    1 +
 drivers/net/wireless/ath/ath10k/wmi.c  |   22 ++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.h  |   12 ++++++++++++
 3 files changed, 33 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 7840cf3..d47a085 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -159,6 +159,7 @@ struct ath10k_fw_stats_peer {
 	u32 peer_rssi;
 	u32 peer_tx_rate;
 	u32 peer_rx_rate; /* 10x only */
+	u32 rx_duration;
 };
 
 struct ath10k_fw_stats_vdev {
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index a7c3d29..c610d17 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2862,11 +2862,20 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
 	/* fw doesn't implement vdev stats */
 
 	for (i = 0; i < num_peer_stats; i++) {
-		const struct wmi_10_2_4_peer_stats *src;
+		const struct wmi_10_2_4_ext_peer_stats *src;
 		struct ath10k_fw_stats_peer *dst;
+		int stats_len;
+		bool ext_peer_stats_support;
+
+		ext_peer_stats_support = test_bit(WMI_SERVICE_PEER_STATS,
+						  ar->wmi.svc_map);
+		if (ext_peer_stats_support)
+			stats_len = sizeof(struct wmi_10_2_4_ext_peer_stats);
+		else
+			stats_len = sizeof(struct wmi_10_2_4_peer_stats);
 
 		src = (void *)skb->data;
-		if (!skb_pull(skb, sizeof(*src)))
+		if (!skb_pull(skb, stats_len))
 			return -EPROTO;
 
 		dst = kzalloc(sizeof(*dst), GFP_ATOMIC);
@@ -2876,6 +2885,9 @@ static int ath10k_wmi_10_2_4_op_pull_fw_stats(struct ath10k *ar,
 		ath10k_wmi_pull_peer_stats(&src->common.old, dst);
 
 		dst->peer_rx_rate = __le32_to_cpu(src->common.peer_rx_rate);
+
+		if (ext_peer_stats_support)
+			dst->rx_duration = __le32_to_cpu(src->rx_duration);
 		/* FIXME: expose 10.2 specific values */
 
 		list_add_tail(&dst->list, &stats->peers);
@@ -5517,6 +5529,9 @@ static struct sk_buff *ath10k_wmi_10_2_op_gen_init(struct ath10k *ar)
 	    test_bit(WMI_SERVICE_COEX_GPIO, ar->wmi.svc_map))
 		features |= WMI_10_2_COEX_GPIO;
 
+	if (test_bit(WMI_SERVICE_PEER_STATS, ar->wmi.svc_map))
+		features |= WMI_10_2_PEER_STATS;
+
 	cmd->resource_config.feature_mask = __cpu_to_le32(features);
 
 	memcpy(&cmd->resource_config.common, &config, sizeof(config));
@@ -7126,6 +7141,9 @@ ath10k_wmi_fw_peer_stats_fill(const struct ath10k_fw_stats_peer *peer,
 			"Peer TX rate", peer->peer_tx_rate);
 	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
 			"Peer RX rate", peer->peer_rx_rate);
+	len += scnprintf(buf + len, buf_len - len, "%30s %u\n",
+			"Peer RX duration", peer->rx_duration);
+
 	len += scnprintf(buf + len, buf_len - len, "\n");
 	*length = len;
 }
diff --git a/drivers/net/wireless/ath/ath10k/wmi.h b/drivers/net/wireless/ath/ath10k/wmi.h
index d85ad78..e1bb02b 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.h
+++ b/drivers/net/wireless/ath/ath10k/wmi.h
@@ -177,6 +177,7 @@ enum wmi_service {
 	WMI_SERVICE_BSS_CHANNEL_INFO_64,
 	WMI_SERVICE_EXT_RES_CFG_SUPPORT,
 	WMI_SERVICE_MESH,
+	WMI_SERVICE_PEER_STATS,
 
 	/* keep last */
 	WMI_SERVICE_MAX,
@@ -213,6 +214,7 @@ enum wmi_10x_service {
 	WMI_10X_SERVICE_BSS_CHANNEL_INFO_64,
 	WMI_10X_SERVICE_MESH,
 	WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
+	WMI_10X_SERVICE_PEER_STATS,
 };
 
 enum wmi_main_service {
@@ -386,6 +388,7 @@ static inline char *wmi_service_name(int service_id)
 	SVCSTR(WMI_SERVICE_BSS_CHANNEL_INFO_64);
 	SVCSTR(WMI_SERVICE_EXT_RES_CFG_SUPPORT);
 	SVCSTR(WMI_SERVICE_MESH);
+	SVCSTR(WMI_SERVICE_PEER_STATS);
 	default:
 		return NULL;
 	}
@@ -463,6 +466,8 @@ static inline void wmi_10x_svc_map(const __le32 *in, unsigned long *out,
 	       WMI_SERVICE_MESH, len);
 	SVCMAP(WMI_10X_SERVICE_EXT_RES_CFG_SUPPORT,
 	       WMI_SERVICE_EXT_RES_CFG_SUPPORT, len);
+	SVCMAP(WMI_10X_SERVICE_PEER_STATS,
+	       WMI_SERVICE_PEER_STATS, len);
 }
 
 static inline void wmi_main_svc_map(const __le32 *in, unsigned long *out,
@@ -2417,6 +2422,7 @@ enum wmi_10_2_feature_mask {
 	WMI_10_2_RX_BATCH_MODE = BIT(0),
 	WMI_10_2_ATF_CONFIG    = BIT(1),
 	WMI_10_2_COEX_GPIO     = BIT(3),
+	WMI_10_2_PEER_STATS    = BIT(7),
 };
 
 struct wmi_resource_config_10_2 {
@@ -4230,6 +4236,12 @@ struct wmi_10_2_4_peer_stats {
 	__le32 unknown_value; /* FIXME: what is this word? */
 } __packed;
 
+struct wmi_10_2_4_ext_peer_stats {
+	struct wmi_10_2_peer_stats common;
+	__le32 peer_rssi_changed;
+	__le32 rx_duration;
+} __packed;
+
 struct wmi_10_4_peer_stats {
 	struct wmi_mac_addr peer_macaddr;
 	__le32 peer_rssi;
-- 
1.7.9.5

