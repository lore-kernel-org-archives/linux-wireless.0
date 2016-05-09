Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:49981 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753458AbcEIXL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 May 2016 19:11:28 -0400
From: greearb@candelatech.com
To: ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org,
	Ben Greear <greearb@candelatech.com>
Subject: [PATCH 16/21] ath10k: Support 32+ stations.
Date: Mon,  9 May 2016 16:11:10 -0700
Message-Id: <1462835475-11079-17-git-send-email-greearb@candelatech.com> (sfid-20160510_011143_271887_2266F9C8)
In-Reply-To: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
References: <1462835475-11079-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Support up to 32 stations when using CT firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c | 14 +++++++++++
 drivers/net/wireless/ath/ath10k/hw.h   |  6 +++++
 drivers/net/wireless/ath/ath10k/mac.c  | 43 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/ath/ath10k/wmi.c  | 16 ++++++++++---
 4 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 49c85c3..3869edd 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -1567,6 +1567,20 @@ static int ath10k_core_init_firmware_features(struct ath10k *ar)
 		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
+		if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT,
+			     fw_file->fw_features)) {
+			ar->max_num_peers = TARGET_10X_NUM_PEERS_CT;
+			ar->max_num_stations = TARGET_10X_NUM_STATIONS;
+			ar->max_num_vdevs = TARGET_10X_NUM_VDEVS_CT;
+		} else {
+			ar->max_num_peers = TARGET_10X_NUM_PEERS;
+			ar->max_num_stations = TARGET_10X_NUM_STATIONS;
+			ar->max_num_vdevs = TARGET_10X_NUM_VDEVS;
+		}
+		ar->htt.max_num_pending_tx = TARGET_10X_NUM_MSDU_DESC;
+		ar->fw_stats_req_mask = WMI_STAT_PEER;
+		ar->max_spatial_stream = WMI_MAX_SPATIAL_STREAM;
+		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		if (ath10k_peer_stats_enabled(ar)) {
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 7b80e29..d3f37d5 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -370,6 +370,12 @@ enum ath10k_hw_4addr_pad {
 						 (TARGET_10X_NUM_VDEVS))
 #define TARGET_10X_TX_STATS_NUM_PEERS		((TARGET_10X_TX_STATS_NUM_STATIONS) + \
 						 (TARGET_10X_NUM_VDEVS))
+
+/* Over-rides for Candela Technologies firmware */
+#define TARGET_10X_NUM_VDEVS_CT			32
+#define TARGET_10X_NUM_PEERS_CT			(32 + (TARGET_10X_NUM_VDEVS_CT))
+#define TARGET_10X_AST_SKID_LIMIT_CT		(TARGET_10X_NUM_PEERS_CT * TARGET_10X_NUM_PEER_AST)
+
 #define TARGET_10X_NUM_OFFLOAD_PEERS		0
 #define TARGET_10X_NUM_OFFLOAD_REORDER_BUFS	0
 #define TARGET_10X_NUM_PEER_KEYS		2
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 42cac32..2169337 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -7451,6 +7451,22 @@ static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
 	},
 };
 
+static const struct ieee80211_iface_limit ath10k_10x_ct_if_limits[] = {
+	{
+	.max	= TARGET_10X_NUM_VDEVS_CT,
+	.types	= BIT(NL80211_IFTYPE_STATION)
+		| BIT(NL80211_IFTYPE_P2P_CLIENT)
+	},
+	{
+	.max	= 3,
+	.types	= BIT(NL80211_IFTYPE_P2P_GO)
+	},
+	{
+	.max	= 7,
+	.types	= BIT(NL80211_IFTYPE_AP)
+	},
+};
+
 static const struct ieee80211_iface_combination ath10k_if_comb[] = {
 	{
 		.limits = ath10k_if_limits,
@@ -7531,6 +7547,22 @@ static const struct ieee80211_iface_limit ath10k_tlv_if_limit_ibss[] = {
 	},
 };
 
+static const struct ieee80211_iface_combination ath10k_10x_ct_if_comb[] = {
+	{
+		.limits = ath10k_10x_ct_if_limits,
+		.n_limits = ARRAY_SIZE(ath10k_10x_ct_if_limits),
+		.max_interfaces = TARGET_10X_NUM_VDEVS_CT,
+		.num_different_channels = 1,
+		.beacon_int_infra_match = true,
+#ifdef CONFIG_ATH10K_DFS_CERTIFIED
+		.radar_detect_widths =	BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+					BIT(NL80211_CHAN_WIDTH_20) |
+					BIT(NL80211_CHAN_WIDTH_40) |
+					BIT(NL80211_CHAN_WIDTH_80),
+#endif
+	},
+};
+
 /* FIXME: This is not thouroughly tested. These combinations may over- or
  * underestimate hw/fw capabilities.
  */
@@ -7808,6 +7840,17 @@ int ath10k_mac_register(struct ath10k *ar)
 		ar->hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_ADHOC);
 		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_1:
+		if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT,
+			     ar->normal_mode_fw.fw_file.fw_features)) {
+			ar->hw->wiphy->iface_combinations = ath10k_10x_ct_if_comb;
+			ar->hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(ath10k_10x_ct_if_comb);
+		} else {
+			ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
+			ar->hw->wiphy->n_iface_combinations =
+				ARRAY_SIZE(ath10k_10x_if_comb);
+		}
+		break;
 	case ATH10K_FW_WMI_OP_VERSION_10_2:
 	case ATH10K_FW_WMI_OP_VERSION_10_2_4:
 		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 6cfba41..9ee2648 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -5497,12 +5497,22 @@ static struct sk_buff *ath10k_wmi_10_1_op_gen_init(struct ath10k *ar)
 	struct sk_buff *buf;
 	struct wmi_resource_config_10x config = {};
 	u32 len, val;
+	u32 skid_limit;
+
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT,
+		     ar->running_fw->fw_file.fw_features)) {
+		config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS_CT);
+		config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS_CT);
+		skid_limit = TARGET_10X_AST_SKID_LIMIT_CT;
+	} else {
+		config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
+		config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
+		skid_limit = TARGET_10X_AST_SKID_LIMIT;
+	}
+	config.ast_skid_limit = __cpu_to_le32(skid_limit);
 
-	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
-	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
 	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
 	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
-	config.ast_skid_limit = __cpu_to_le32(TARGET_10X_AST_SKID_LIMIT);
 	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
 	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
 	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
-- 
2.4.3

