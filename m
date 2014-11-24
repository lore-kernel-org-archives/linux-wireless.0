Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55551 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932323AbaKXOgl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:41 -0500
Received: by mail-wg0-f48.google.com with SMTP id y19so12671022wgg.35
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:40 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 64/75] iwlwifi: mvm: add support for net detect
Date: Mon, 24 Nov 2014 16:34:40 +0200
Message-Id: <1416839691-28533-64-git-send-email-egrumbach@gmail.com> (sfid-20141124_153727_722943_A99ECF52)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add the net detect WoWLAN flag to indicate support and use the
nd_config from the WoWLAN configuration to start net detect, if it is
set.  The WoWLAN configuration takes precedence over the debugfs
configuration.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/d3.c       | 8 +++++---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 4 +++-
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/d3.c b/drivers/net/wireless/iwlwifi/mvm/d3.c
index 0fc72fc..3c66028 100644
--- a/drivers/net/wireless/iwlwifi/mvm/d3.c
+++ b/drivers/net/wireless/iwlwifi/mvm/d3.c
@@ -1030,13 +1030,15 @@ static int __iwl_mvm_suspend(struct ieee80211_hw *hw,
 					    vif, mvmvif, ap_sta);
 		if (ret)
 			goto out;
-	} else if (mvm->nd_config) {
+	} else if (wowlan->nd_config || mvm->nd_config) {
 		ret = iwl_mvm_switch_to_d3(mvm);
 		if (ret)
 			goto out;
 
-		ret = iwl_mvm_scan_offload_start(mvm, vif, mvm->nd_config,
-						 &mvm->nd_ies);
+		ret = iwl_mvm_scan_offload_start(
+			mvm, vif,
+			wowlan->nd_config ?: mvm->nd_config,
+			&mvm->nd_ies);
 		if (ret)
 			goto out;
 	} else {
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 6214133..d9d8d30 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -467,7 +467,8 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		mvm->wowlan.flags = WIPHY_WOWLAN_MAGIC_PKT |
 				    WIPHY_WOWLAN_DISCONNECT |
 				    WIPHY_WOWLAN_EAP_IDENTITY_REQ |
-				    WIPHY_WOWLAN_RFKILL_RELEASE;
+				    WIPHY_WOWLAN_RFKILL_RELEASE |
+				    WIPHY_WOWLAN_NET_DETECT;
 		if (!iwlwifi_mod_params.sw_crypto)
 			mvm->wowlan.flags |= WIPHY_WOWLAN_SUPPORTS_GTK_REKEY |
 					     WIPHY_WOWLAN_GTK_REKEY_FAILURE |
@@ -476,6 +477,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		mvm->wowlan.n_patterns = IWL_WOWLAN_MAX_PATTERNS;
 		mvm->wowlan.pattern_min_len = IWL_WOWLAN_MIN_PATTERN_LEN;
 		mvm->wowlan.pattern_max_len = IWL_WOWLAN_MAX_PATTERN_LEN;
+		mvm->wowlan.max_nd_match_sets = IWL_SCAN_MAX_PROFILES;
 		mvm->wowlan.tcp = &iwl_mvm_wowlan_tcp_support;
 		hw->wiphy->wowlan = &mvm->wowlan;
 	}
-- 
1.9.1

