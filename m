Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:32902 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754389AbcGEMXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 08:23:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Tue,  5 Jul 2016 15:23:09 +0300
Message-Id: <1467721394-8195-3-git-send-email-luca@coelho.fi> (sfid-20160705_142328_290455_1939FCCD)
In-Reply-To: <1467721394-8195-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 2/7] mac80211_hwsim: Add radar bandwidths to the P2P Device combination
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

Add radar_detect_widths to the interface combination that allows
concurrent P2P Device dedicated interface and AP interfaces, to enable
testing of radar detection when P2P Device interface is used.

Clear the radar_detect_widths in case of multi channel contexts
as this is not currently supported.

As radar_detect_widths are now supported in all combinations,
remove the hwsim_if_dfs_limits definition since it is no longer
needed.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 25 +++++--------------------
 1 file changed, 5 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 382109bb..97196c4 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -457,10 +457,6 @@ static const struct ieee80211_iface_limit hwsim_if_limits[] = {
 	{ .max = 1, .types = BIT(NL80211_IFTYPE_P2P_DEVICE) }
 };
 
-static const struct ieee80211_iface_limit hwsim_if_dfs_limits[] = {
-	{ .max = 8, .types = BIT(NL80211_IFTYPE_AP) },
-};
-
 static const struct ieee80211_iface_combination hwsim_if_comb[] = {
 	{
 		.limits = hwsim_if_limits,
@@ -468,18 +464,12 @@ static const struct ieee80211_iface_combination hwsim_if_comb[] = {
 		.n_limits = ARRAY_SIZE(hwsim_if_limits) - 1,
 		.max_interfaces = 2048,
 		.num_different_channels = 1,
-	},
-	{
-		.limits = hwsim_if_dfs_limits,
-		.n_limits = ARRAY_SIZE(hwsim_if_dfs_limits),
-		.max_interfaces = 8,
-		.num_different_channels = 1,
 		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 				       BIT(NL80211_CHAN_WIDTH_20) |
 				       BIT(NL80211_CHAN_WIDTH_40) |
 				       BIT(NL80211_CHAN_WIDTH_80) |
 				       BIT(NL80211_CHAN_WIDTH_160),
-	}
+	},
 };
 
 static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
@@ -488,18 +478,12 @@ static const struct ieee80211_iface_combination hwsim_if_comb_p2p_dev[] = {
 		.n_limits = ARRAY_SIZE(hwsim_if_limits),
 		.max_interfaces = 2048,
 		.num_different_channels = 1,
-	},
-	{
-		.limits = hwsim_if_dfs_limits,
-		.n_limits = ARRAY_SIZE(hwsim_if_dfs_limits),
-		.max_interfaces = 8,
-		.num_different_channels = 1,
 		.radar_detect_widths = BIT(NL80211_CHAN_WIDTH_20_NOHT) |
 				       BIT(NL80211_CHAN_WIDTH_20) |
 				       BIT(NL80211_CHAN_WIDTH_40) |
 				       BIT(NL80211_CHAN_WIDTH_80) |
 				       BIT(NL80211_CHAN_WIDTH_160),
-	}
+	},
 };
 
 static spinlock_t hwsim_radio_lock;
@@ -2487,13 +2471,14 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 		hw->wiphy->max_scan_ssids = 255;
 		hw->wiphy->max_scan_ie_len = IEEE80211_MAX_DATA_LEN;
 		hw->wiphy->max_remain_on_channel_duration = 1000;
-		/* For channels > 1 DFS is not allowed */
-		hw->wiphy->n_iface_combinations = 1;
 		hw->wiphy->iface_combinations = &data->if_combination;
 		if (param->p2p_device)
 			data->if_combination = hwsim_if_comb_p2p_dev[0];
 		else
 			data->if_combination = hwsim_if_comb[0];
+		hw->wiphy->n_iface_combinations = 1;
+		/* For channels > 1 DFS is not allowed */
+		data->if_combination.radar_detect_widths = 0;
 		data->if_combination.num_different_channels = data->channels;
 	} else if (param->p2p_device) {
 		hw->wiphy->iface_combinations = hwsim_if_comb_p2p_dev;
-- 
2.8.1

