Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab3GOLqu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:46:50 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH RESEND 3.9 2/4] iwlwifi: mvm: support BSS only
Date: Mon, 15 Jul 2013 14:46:42 +0300
Message-Id: <1373888804-3077-3-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130715_134655_659612_25E20E96)
In-Reply-To: <1373888804-3077-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1373888804-3077-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Only BSS is support in 3.9. In later kernels, other modes
have been fixed and tested to work.
This will at least allow user to use the regular wifi
functionality.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   24 +-----------------------
 1 file changed, 1 insertion(+), 23 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8572358..c9569a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -76,23 +76,6 @@
 #include "fw-api-scan.h"
 #include "iwl-phy-db.h"
 
-static const struct ieee80211_iface_limit iwl_mvm_limits[] = {
-	{
-		.max = 1,
-		.types = BIT(NL80211_IFTYPE_STATION) |
-			BIT(NL80211_IFTYPE_AP),
-	},
-};
-
-static const struct ieee80211_iface_combination iwl_mvm_iface_combinations[] = {
-	{
-		.num_different_channels = 1,
-		.max_interfaces = 3,
-		.limits = iwl_mvm_limits,
-		.n_limits = ARRAY_SIZE(iwl_mvm_limits),
-	},
-};
-
 int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 {
 	struct ieee80211_hw *hw = mvm->hw;
@@ -126,17 +109,12 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	hw->vif_data_size = sizeof(struct iwl_mvm_vif);
 	hw->chanctx_data_size = sizeof(struct iwl_mvm_phy_ctxt);
 
-	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION) |
-		BIT(NL80211_IFTYPE_AP);
+	hw->wiphy->interface_modes = BIT(NL80211_IFTYPE_STATION);
 
 	hw->wiphy->flags |= WIPHY_FLAG_CUSTOM_REGULATORY |
 			    WIPHY_FLAG_DISABLE_BEACON_HINTS |
 			    WIPHY_FLAG_IBSS_RSN;
 
-	hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
-	hw->wiphy->n_iface_combinations =
-		ARRAY_SIZE(iwl_mvm_iface_combinations);
-
 	hw->wiphy->max_remain_on_channel_duration = 500;
 	hw->max_listen_interval = IWL_CONN_MAX_LISTEN_INTERVAL;
 
-- 
1.7.10.4

