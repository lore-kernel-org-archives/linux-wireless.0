Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34380 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaHER7A (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2014 13:59:00 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath10k@lists.infradead.org, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath10k:  Support 32+ stations.
Date: Tue,  5 Aug 2014 10:58:57 -0700
Message-Id: <1407261537-11308-1-git-send-email-greearb@candelatech.com> (sfid-20140805_195905_121551_6D663BA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

Implement 64-bit vdev map to support larger numbers
of virtual devices.  Support up to 32 stations
(actual limit will be determined when loading firmware,
as different firmwares have different limits)

Enable larger limits when using Candela Technologies
firmware.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---

NOTE:  The 10.2 firmware uses the bit that used to be used
by CT firmware, so existing CT firmware will not actually
work with this patch (or any kernel with the 10.2 firmware patch).
If I can get acceptance of this patch or even a simpler patch
that just adds the enum for CT firmware feature,
I can immediately re-do CT firmware with the proper bit
set.  If there is absolutely no way that even minimal
CT firmware support can be accepted upstream, then I
will just choose a large feature flag and hope it is not
re-used by upstream code any time soon.

 drivers/net/wireless/ath/ath10k/core.c |  8 +++--
 drivers/net/wireless/ath/ath10k/core.h |  5 ++-
 drivers/net/wireless/ath/ath10k/hw.h   |  6 ++++
 drivers/net/wireless/ath/ath10k/mac.c  | 65 ++++++++++++++++++++++++++++------
 drivers/net/wireless/ath/ath10k/wmi.c  | 25 ++++++++++---
 5 files changed, 89 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/core.c b/drivers/net/wireless/ath/ath10k/core.c
index 27d027d..030bef1 100644
--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -844,10 +844,12 @@ int ath10k_core_start(struct ath10k *ar)
 	if (status)
 		goto err_htc_stop;
 
-	if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
-		ar->free_vdev_map = (1 << TARGET_10X_NUM_VDEVS) - 1;
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features))
+		ar->free_vdev_map = (1LL << TARGET_10X_NUM_VDEVS_CT) - 1;
+	else if (test_bit(ATH10K_FW_FEATURE_WMI_10X, ar->fw_features))
+		ar->free_vdev_map = (1LL << TARGET_10X_NUM_VDEVS) - 1;
 	else
-		ar->free_vdev_map = (1 << TARGET_NUM_VDEVS) - 1;
+		ar->free_vdev_map = (1LL << TARGET_NUM_VDEVS) - 1;
 
 	INIT_LIST_HEAD(&ar->arvifs);
 
diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index 58c6348..777957e 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -425,6 +425,9 @@ enum ath10k_fw_features {
 	 */
 	ATH10K_FW_FEATURE_WMI_10_2 = 4,
 
+	/* Firmware from Candela Technologies, enables more VIFs, etc */
+	ATH10K_FW_FEATURE_WMI_10X_CT = 5,
+
 	/* keep last */
 	ATH10K_FW_FEATURE_COUNT,
 };
@@ -526,7 +529,7 @@ struct ath10k {
 	/* current operating channel definition */
 	struct cfg80211_chan_def chandef;
 
-	int free_vdev_map;
+	unsigned long long free_vdev_map;
 	bool promisc;
 	bool monitor;
 	int monitor_vdev_id;
diff --git a/drivers/net/wireless/ath/ath10k/hw.h b/drivers/net/wireless/ath/ath10k/hw.h
index 291ad23..0bb3744 100644
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
index 33a66b9..e67137a 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -602,9 +602,9 @@ static int ath10k_monitor_vdev_create(struct ath10k *ar)
 		return -ENOMEM;
 	}
 
-	bit = ffs(ar->free_vdev_map);
+	bit = __ffs64(ar->free_vdev_map);
 
-	ar->monitor_vdev_id = bit - 1;
+	ar->monitor_vdev_id = bit;
 
 	ret = ath10k_wmi_vdev_create(ar, ar->monitor_vdev_id,
 				     WMI_VDEV_TYPE_MONITOR,
@@ -615,7 +615,8 @@ static int ath10k_monitor_vdev_create(struct ath10k *ar)
 		return ret;
 	}
 
-	ar->free_vdev_map &= ~(1 << ar->monitor_vdev_id);
+	ar->free_vdev_map &= ~(1LL << ar->monitor_vdev_id);
+
 	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d created\n",
 		   ar->monitor_vdev_id);
 
@@ -635,7 +636,7 @@ static int ath10k_monitor_vdev_delete(struct ath10k *ar)
 		return ret;
 	}
 
-	ar->free_vdev_map |= 1 << ar->monitor_vdev_id;
+	ar->free_vdev_map |= 1LL << ar->monitor_vdev_id;
 
 	ath10k_dbg(ATH10K_DBG_MAC, "mac monitor vdev %d deleted\n",
 		   ar->monitor_vdev_id);
@@ -2742,9 +2743,13 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		ret = -EBUSY;
 		goto err;
 	}
-	bit = ffs(ar->free_vdev_map);
 
-	arvif->vdev_id = bit - 1;
+	bit = __ffs64(ar->free_vdev_map);
+
+	ath10k_warn("Creating vdev id: %i  map: %llu\n",
+		    bit, ar->free_vdev_map);
+
+	arvif->vdev_id = bit;
 	arvif->vdev_subtype = WMI_VDEV_SUBTYPE_NONE;
 
 	if (ar->p2p)
@@ -2785,7 +2790,7 @@ static int ath10k_add_interface(struct ieee80211_hw *hw,
 		goto err;
 	}
 
-	ar->free_vdev_map &= ~(1 << arvif->vdev_id);
+	ar->free_vdev_map &= ~(1LL << arvif->vdev_id);
 	list_add(&arvif->list, &ar->arvifs);
 
 	vdev_param = ar->wmi.vdev_param->def_keyid;
@@ -2878,7 +2883,7 @@ err_peer_delete:
 
 err_vdev_delete:
 	ath10k_wmi_vdev_delete(ar, arvif->vdev_id);
-	ar->free_vdev_map |= 1 << arvif->vdev_id;
+	ar->free_vdev_map |= 1LL << arvif->vdev_id;
 	list_del(&arvif->list);
 
 err:
@@ -2914,7 +2919,7 @@ static void ath10k_remove_interface(struct ieee80211_hw *hw,
 		ath10k_warn("failed to stop spectral for vdev %i: %d\n",
 			    arvif->vdev_id, ret);
 
-	ar->free_vdev_map |= 1 << arvif->vdev_id;
+	ar->free_vdev_map |= 1LL << arvif->vdev_id;
 	list_del(&arvif->list);
 
 	if (arvif->vdev_type == WMI_VDEV_TYPE_AP) {
@@ -3465,7 +3470,9 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
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
@@ -4552,6 +4559,22 @@ static const struct ieee80211_iface_limit ath10k_10x_if_limits[] = {
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
@@ -4578,6 +4601,22 @@ static const struct ieee80211_iface_combination ath10k_10x_if_comb[] = {
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
@@ -4814,7 +4853,11 @@ int ath10k_mac_register(struct ath10k *ar)
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
index a1037f7..0aee639 100644
--- a/drivers/net/wireless/ath/ath10k/wmi.c
+++ b/drivers/net/wireless/ath/ath10k/wmi.c
@@ -2160,6 +2160,13 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 	u32 num_units, req_id, unit_size, num_mem_reqs, num_unit_info, i;
 	int ret;
 	struct wmi_service_ready_event_10x *ev = (void *)skb->data;
+	int my_num_peers = TARGET_10X_NUM_PEERS;
+	int my_num_vdevs = TARGET_10X_NUM_VDEVS;
+
+	if (test_bit(ATH10K_FW_FEATURE_WMI_10X_CT, ar->fw_features)) {
+		my_num_peers = TARGET_10X_NUM_PEERS_CT;
+		my_num_vdevs = TARGET_10X_NUM_VDEVS_CT;
+	}
 
 	if (skb->len < sizeof(*ev)) {
 		ath10k_warn("Service ready event was %d B but expected %zu B. Wrong firmware version?\n",
@@ -2222,9 +2229,9 @@ static void ath10k_wmi_10x_service_ready_event_rx(struct ath10k *ar,
 			 * peers, 1 extra for self peer on target */
 			/* this needs to be tied, host and target
 			 * can get out of sync */
-			num_units = TARGET_10X_NUM_PEERS + 1;
+			num_units = my_num_peers + 1;
 		else if (num_unit_info & NUM_UNITS_IS_NUM_VDEVS)
-			num_units = TARGET_10X_NUM_VDEVS + 1;
+			num_units = my_num_vdevs + 1;
 
 		ath10k_dbg(ATH10K_DBG_WMI,
 			   "wmi mem_req_id %d num_units %d num_unit_info %d unit size %d actual units %d\n",
@@ -2952,12 +2959,20 @@ static int ath10k_wmi_10x_cmd_init(struct ath10k *ar)
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

