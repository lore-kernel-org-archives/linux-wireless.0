Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:42061 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757178AbaISSFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Sep 2014 14:05:03 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH 3/3] ath10k: support 32+ stations.
Date: Fri, 19 Sep 2014 11:04:50 -0700
Message-Id: <1411149890-12618-3-git-send-email-greearb@candelatech.com> (sfid-20140919_200511_131860_C777A455)
In-Reply-To: <1411149890-12618-1-git-send-email-greearb@candelatech.com>
References: <1411149890-12618-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Support up to 32 stations when using CT firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/ath/ath10k/core.c |  4 +++-
 drivers/net/wireless/ath/ath10k/hw.h   |  6 +++++
 drivers/net/wireless/ath/ath10k/mac.c  | 42 ++++++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath10k/wmi.c  | 25 ++++++++++++++++----
 4 files changed, 69 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 37e3166..507f31a 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -845,7 +845,9 @@ int ath10k_core_start(struct ath10k *ar, enum ath10k_firmware_mode mode)
 	if (status)
 		goto err_hif_stop;
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
+		ar->free_vdev_map = (1LL << TARGET_10X_NUM_VDEVS_CT) - 1;
+	else if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
 		ar->free_vdev_map = (1LL << TARGET_10X_NUM_VDEVS) - 1;
 	else
 		ar->free_vdev_map = (1LL << TARGET_NUM_VDEVS) - 1;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 3cf5702..9583555 100644
--- a/drivers/net/wireless/ath/ath10k/hw.h
+++ b/drivers/net/wireless/ath/ath10k/hw.h
@@ -122,6 +122,12 @@ enum ath10k_mcast2ucast_mode {
 #define TARGET_10X_AST_SKID_LIMIT		16
 #define TARGET_10X_NUM_PEERS			(128 + (TARGET_10X_NUM_VDEVS))
 #define TARGET_10X_NUM_PEERS_MAX		128
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
index e1ddac4..b517f71 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -3497,7 +3497,9 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
 		/*
 		 * New station addition.
 		 */
-		if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
+			max_num_peers = TARGET_10X_NUM_PEERS_CT - 1;
+		else if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
 			max_num_peers = TARGET_10X_NUM_PEERS_MAX - 1;
 		else
 			max_num_peers = TARGET_NUM_PEERS;
@@ -4601,6 +4603,22 @@ static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
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
@@ -4627,6 +4645,22 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
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
 static struct ieee80211_sta_vht_cap ath10k_create_vht_cap(struct ath10k *ar)
 {
 	struct ieee80211_sta_vht_cap vht_cap = {0};
@@ -4863,7 +4897,11 @@ int ath10k_mac_register(struct ath10k *ar)
 	 */
 	ar->hw->queues = 4;
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features)) {
+		ar->hw->wiphy->iface_combinations = ath10k_10x_ct_if_comb;
+		ar->hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(ath10k_10x_ct_if_comb);
+	} else if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features)) {
 		ar->hw->wiphy->iface_combinations = ath10k_10x_if_comb;
 		ar->hw->wiphy->n_iface_combinations =
 			ARRAY_SIZE(ath10k_10x_if_comb);
diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
index 2c42bd5..76abdd7 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2245,6 +2245,13 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	int ret;
 	struct wmi_service_ready_event_10x *ev = (void *)skb->data;
 	DECLARE_BITMAP(svc_bmap, WMI_SERVICE_MAX) = {};
+	int my_num_peers = TARGET_10X_NUM_PEERS;
+	int my_num_vdevs = TARGET_10X_NUM_VDEVS;
+
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features)) {
+		my_num_peers = TARGET_10X_NUM_PEERS_CT;
+		my_num_vdevs = TARGET_10X_NUM_VDEVS_CT;
+	}
 
 	if (skb->len < sizeof(*ev)) {
 		ath10k_warn(ar, "Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
@@ -2309,9 +2316,9 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 			 * peers, 1 extra for self peer on target */
 			/* this needs to be tied, host and target
 			 * can get out of sync */
-			num_units = TARGET_10X_NUM_PEERS + 1;
+			num_units = my_num_peers + 1;
 		else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
-			num_units = TARGET_10X_NUM_VDEVS + 1;
+			num_units = my_num_vdevs + 1;
 
 		ath10k_dbg(ar, ATH10K_DBG_WMI,
 			   "wmi mem_req_id %d num_units %d num_unit_info %d unit size %d actual units %d\n",
@@ -3057,12 +3064,20 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
 	struct wmi_resource_config_10x config = {};
 	u32 len, val;
 	int i;
+	u32 skid_limit;
 
-	config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
-	config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features)) {
+		config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS_CT);
+		config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS_CT);
+		skid_limit = TARGET_10X_AST_SKID_LIMIT_CT;
+	} else {
+		config.num_vdevs = __cpu_to_le32(TARGET_10X_NUM_VDEVS);
+		config.num_peers = __cpu_to_le32(TARGET_10X_NUM_PEERS);
+		skid_limit = TARGET_10X_AST_SKID_LIMIT;
+	}
+	config.ast_skid_limit = __cpu_to_le32(skid_limit);
 	config.num_peer_keys = __cpu_to_le32(TARGET_10X_NUM_PEER_KEYS);
 	config.num_tids = __cpu_to_le32(TARGET_10X_NUM_TIDS);
-	config.ast_skid_limit = __cpu_to_le32(TARGET_10X_AST_SKID_LIMIT);
 	config.tx_chain_mask = __cpu_to_le32(TARGET_10X_TX_CHAIN_MASK);
 	config.rx_chain_mask = __cpu_to_le32(TARGET_10X_RX_CHAIN_MASK);
 	config.rx_timeout_pri_vo = __cpu_to_le32(TARGET_10X_RX_TIMEOUT_LO_PRI);
-- 
1.7.11.7

