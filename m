Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26815 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755577Ab1E0QIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2011 12:08:01 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 07/10] iwlagn: advertise interface combinations
Date: Fri, 27 May 2011 08:40:30 -0700
Message-Id: <1306510833-32049-8-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110527_180820_945474_3B1CFE81)
In-Reply-To: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1306510833-32049-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With this, iwlwifi will advertise the limits on
concurrency of virtual interfaces.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c |   83 ++++++++++++++++++++++++++++++++
 1 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index a90cb1b..1631c44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2420,6 +2420,77 @@ unlock:
  *
  *****************************************************************************/
 
+static const struct ieee80211_iface_limit iwlagn_sta_ap_limits[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_AP),
+	},
+};
+
+static const struct ieee80211_iface_limit iwlagn_2sta_limits[] = {
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+};
+
+static const struct ieee80211_iface_limit iwlagn_p2p_sta_go_limits[] = {
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_GO) |
+			 BIT(NL80211_IFTYPE_AP),
+	},
+};
+
+static const struct ieee80211_iface_limit iwlagn_p2p_2sta_limits[] = {
+	{
+		.max = 2,
+		.types = BIT(NL80211_IFTYPE_STATION),
+	},
+	{
+		.max = 1,
+		.types = BIT(NL80211_IFTYPE_P2P_CLIENT),
+	},
+};
+
+static const struct ieee80211_iface_combination
+iwlagn_iface_combinations_dualmode[] = {
+	{ .num_different_channels = 1,
+	  .max_interfaces = 2,
+	  .beacon_int_infra_match = true,
+	  .limits = iwlagn_sta_ap_limits,
+	  .n_limits = ARRAY_SIZE(iwlagn_sta_ap_limits),
+	},
+	{ .num_different_channels = 1,
+	  .max_interfaces = 2,
+	  .limits = iwlagn_2sta_limits,
+	  .n_limits = ARRAY_SIZE(iwlagn_2sta_limits),
+	},
+};
+
+static const struct ieee80211_iface_combination
+iwlagn_iface_combinations_p2p[] = {
+	{ .num_different_channels = 1,
+	  .max_interfaces = 2,
+	  .beacon_int_infra_match = true,
+	  .limits = iwlagn_p2p_sta_go_limits,
+	  .n_limits = ARRAY_SIZE(iwlagn_p2p_sta_go_limits),
+	},
+	{ .num_different_channels = 1,
+	  .max_interfaces = 2,
+	  .limits = iwlagn_p2p_2sta_limits,
+	  .n_limits = ARRAY_SIZE(iwlagn_p2p_2sta_limits),
+	},
+};
+
 /*
  * Not a mac80211 entry point function, but it fits in with all the
  * other mac80211 functions grouped here.
@@ -2460,6 +2531,18 @@ static int iwl_mac_setup_register(struct iwl_priv *priv,
 		hw->wiphy->interface_modes |= ctx->exclusive_interface_modes;
 	}
 
+	BUILD_BUG_ON(NUM_IWL_RXON_CTX != 2);
+
+	if (hw->wiphy->interface_modes & NL80211_IFTYPE_P2P_CLIENT) {
+		hw->wiphy->iface_combinations = iwlagn_iface_combinations_p2p;
+		hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(iwlagn_iface_combinations_p2p);
+	} else if (hw->wiphy->interface_modes & NL80211_IFTYPE_AP) {
+		hw->wiphy->iface_combinations = iwlagn_iface_combinations_dualmode;
+		hw->wiphy->n_iface_combinations =
+			ARRAY_SIZE(iwlagn_iface_combinations_dualmode);
+	}
+
 	hw->wiphy->max_remain_on_channel_duration = 1000;
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
-- 
1.7.0.4

