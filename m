Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:55836 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S935780AbcISHal (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Sep 2016 03:30:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Aviya Erenfeld <aviya.erenfeld@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Mon, 19 Sep 2016 10:30:08 +0300
Message-Id: <20160919073028.22065-5-luca@coelho.fi> (sfid-20160919_093048_312728_4F5C29C9)
In-Reply-To: <1474270071.5664.89.camel@coelho.fi>
References: <1474270071.5664.89.camel@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: mvm: add support for MU-MIMO air sniffer
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aviya Erenfeld <aviya.erenfeld@intel.com>

enable MU-MIMO air sniffer if it's supported by the NIC

Signed-off-by: Aviya Erenfeld <aviya.erenfeld@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 9506e65..b7d80b5 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -720,6 +720,10 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (ret)
 		iwl_mvm_leds_exit(mvm);
 
+	if (mvm->cfg->vht_mu_mimo_supported)
+		wiphy_ext_feature_set(hw->wiphy,
+				      NL80211_EXT_FEATURE_MU_MIMO_AIR_SNIFFER);
+
 	return ret;
 }
 
@@ -2229,6 +2233,10 @@ static void iwl_mvm_bss_info_changed(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_ADHOC:
 		iwl_mvm_bss_info_changed_ap_ibss(mvm, vif, bss_conf, changes);
 		break;
+	case NL80211_IFTYPE_MONITOR:
+		if (changes & BSS_CHANGED_MU_GROUPS)
+			iwl_mvm_update_mu_groups(mvm, vif);
+		break;
 	default:
 		/* shouldn't happen */
 		WARN_ON_ONCE(1);
-- 
2.9.3
