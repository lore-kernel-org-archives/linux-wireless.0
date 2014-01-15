Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38401 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaAOOBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Jan 2014 09:01:06 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] mac80211_hwsim: make P2P-Device support optional
Date: Wed, 15 Jan 2014 15:01:01 +0100
Message-Id: <1389794461-30686-1-git-send-email-johannes@sipsolutions.net> (sfid-20140115_150117_489379_FFA0449D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When creating new devices, allow P2P-Device support to be
turned off to be able to test default behaviour with and
without the support.

Also add a module parameter for the default setting.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 53 ++++++++++++++++++++++++++++++-----
 drivers/net/wireless/mac80211_hwsim.h |  2 ++
 2 files changed, 48 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index e53a50a..9ddc751 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -57,6 +57,10 @@ static bool rctbl = false;
 module_param(rctbl, bool, 0444);
 MODULE_PARM_DESC(rctbl, "Handle rate control table");
 
+static bool support_p2p_device = true;
+module_param(support_p2p_device, bool, 0444);
+MODULE_PARM_DESC(support_p2p_device, "Support P2P-Device interface type");
+
 /**
  * enum hwsim_regtest - the type of regulatory tests we offer
  *
@@ -335,7 +339,8 @@ static const struct ieee80211_iface_limit hwsim_if_limits[] = {
 #endif
 				 BIT(NL80211_IFTYPE_AP) |
 				 BIT(NL80211_IFTYPE_P2P_GO) },
-	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) },
+	/* must be last, see hwsim_if_comb */
+	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) }
 };
 
 static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
@@ -345,6 +350,27 @@ static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
 static const struct ieee80211_iface_combination hwsim_if_comb[] = {
 	{
 		.limits = hwsim_if_limits,
+		/* remove the last entry which is P2P_DEVICE */
+		.n_limits = ARRAY_SIZE(hwsim_if_limits) - 1,
+		.max_interfaces = 2048,
+		.num_different_channels = 1,
+	},
+	{
+		.limits = hwsim_if_dfs_limits,
+		.n_limits = ARRAY_SIZE(hwsim_if_dfs_limits),
+		.max_interfaces = 8,
+		.num_different_channels = 1,
+		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
+				       BIT(NL80211_CHAN_WIDTH_20) |
+				       BIT(NL80211_CHAN_WIDTH_40) |
+				       BIT(NL80211_CHAN_WIDTH_80) |
+				       BIT(NL80211_CHAN_WIDTH_160),
+	}
+};
+
+static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
+	{
+		.limits = hwsim_if_limits,
 		.n_limits = ARRAY_SIZE(hwsim_if_limits),
 		.max_interfaces = 2048,
 		.num_different_channels = 1,
@@ -473,6 +499,7 @@ static struct nla_policy hwsim_genl_policy[HWSIM_ATTR_MAX + 1] = {
 	[HWSIM_ATTR_REG_HINT_ALPHA2] = { .type = NLA_STRING, .len = 2 },
 	[HWSIM_ATTR_REG_CUSTOM_REG] = { .type = NLA_U32 },
 	[HWSIM_ATTR_REG_STRICT_REG] = { .type = NLA_FLAG },
+	[HWSIM_ATTR_SUPPORT_P2P_DEVICE] = { .type = NLA_FLAG },
 };
 
 static void mac80211_hwsim_tx_frame(struct ieee80211_hw *hw,
@@ -1982,7 +2009,7 @@ static struct ieee80211_ops mac80211_hwsim_mchan_ops;
 
 static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				       const struct ieee80211_regdomain *regd,
-				       bool reg_strict)
+				       bool reg_strict, bool p2p_device)
 {
 	int err;
 	u8 addr[ETH_ALEN];
@@ -2046,8 +2073,15 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 		/* For channels > 1 DFS is not allowed */
 		hw->wiphy->n_iface_combinations = 1;
 		hw->wiphy->iface_combinations = &data->if_combination;
-		data->if_combination = hwsim_if_comb[0];
 		data->if_combination.num_different_channels = data->channels;
+		if (p2p_device)
+			data->if_combination = hwsim_if_comb_p2p_dev[0];
+		else
+			data->if_combination = hwsim_if_comb[0];
+	} else if (p2p_device) {
+		hw->wiphy->iface_combinations = hwsim_if_comb_p2p_dev;
+		hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(hwsim_if_comb_p2p_dev);
 	} else {
 		hw->wiphy->iface_combinations = hwsim_if_comb;
 		hw->wiphy->n_iface_combinations = ARRAY_SIZE(hwsim_if_comb);
@@ -2063,8 +2097,10 @@ static int mac80211_hwsim_create_radio(int channels, const char *reg_alpha2,
 				     BIT(NL80211_IFTYPE_P2P_CLIENT) |
 				     BIT(NL80211_IFTYPE_P2P_GO) |
 				     BIT(NL80211_IFTYPE_ADHOC) |
-				     BIT(NL80211_IFTYPE_MESH_POINT) |
-				     BIT(NL80211_IFTYPE_P2P_DEVICE);
+				     BIT(NL80211_IFTYPE_MESH_POINT);
+
+	if (p2p_device)
+		hw->wiphy->interface_modes |= BIT(NL80211_IFTYPE_P2P_DEVICE);
 
 	hw->flags = IEEE80211_HW_MFP_CAPABLE |
 		    IEEE80211_HW_SIGNAL_DBM |
@@ -2453,6 +2489,7 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 	const char *alpha2 = NULL;
 	const struct ieee80211_regdomain *regd = NULL;
 	bool reg_strict = info->attrs[HWSIM_ATTR_REG_STRICT_REG];
+	bool p2p_device = info->attrs[HWSIM_ATTR_SUPPORT_P2P_DEVICE];
 
 	if (info->attrs[HWSIM_ATTR_CHANNELS])
 		chans = nla_get_u32(info->attrs[HWSIM_ATTR_CHANNELS]);
@@ -2468,7 +2505,8 @@ static int hwsim_create_radio_nl(struct sk_buff *msg, struct genl_info *info)
 		regd = hwsim_world_regdom_custom[idx];
 	}
 
-	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict);
+	return mac80211_hwsim_create_radio(chans, alpha2, regd, reg_strict,
+					   p2p_device);
 }
 
 static int hwsim_destroy_radio_nl(struct sk_buff *msg, struct genl_info *info)
@@ -2686,7 +2724,8 @@ static int __init init_mac80211_hwsim(void)
 		}
 
 		err = mac80211_hwsim_create_radio(channels, reg_alpha2,
-						  regd, reg_strict);
+						  regd, reg_strict,
+						  support_p2p_device);
 		if (err < 0)
 			goto out_free_radios;
 	}
diff --git a/drivers/net/wireless/mac80211_hwsim.h b/drivers/net/wireless/mac80211_hwsim.h
index 2747cce..6e72996 100644
--- a/drivers/net/wireless/mac80211_hwsim.h
+++ b/drivers/net/wireless/mac80211_hwsim.h
@@ -107,6 +107,7 @@ enum {
  *	(nla string, length 2)
  * @HWSIM_ATTR_REG_CUSTOM_REG: custom regulatory domain index (u32 attribute)
  * @HWSIM_ATTR_REG_STRICT_REG: request REGULATORY_STRICT_REG (flag attribute)
+ * @HWSIM_ATTR_SUPPORT_P2P_DEVICE: support P2P Device virtual interface (flag)
  * @__HWSIM_ATTR_MAX: enum limit
  */
 
@@ -126,6 +127,7 @@ enum {
 	HWSIM_ATTR_REG_HINT_ALPHA2,
 	HWSIM_ATTR_REG_CUSTOM_REG,
 	HWSIM_ATTR_REG_STRICT_REG,
+	HWSIM_ATTR_SUPPORT_P2P_DEVICE,
 	__HWSIM_ATTR_MAX,
 };
 #define HWSIM_ATTR_MAX (__HWSIM_ATTR_MAX - 1)
-- 
1.8.5.1

