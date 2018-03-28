Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37010 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753116AbeC1OZz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 10:25:55 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 28 Mar 2018 17:25:50 +0300
Message-Id: <20180328142550.9101-1-luca@coelho.fi> (sfid-20180328_162558_113660_AEEFE981)
In-Reply-To: <20180328141157.5427-1-luca@coelho.fi>
References: <20180328141157.5427-1-luca@coelho.fi>
Subject: [PATCH 08/14] iwlwifi: mvm: Allow iwl_mvm_mac_mgd_prepare_tx() when associated
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ilan Peer <ilan.peer@intel.com>

The FW does not allocate quota air time for the binding of a station
MAC before iwlmvm indicates that it is associated. Currently iwlmvm
indicates that the MAC is associated only after hearing a beacon from
the AP. In case a deauthentication frame is sent before the MAC is
associated, the frame might not be sent as the corresponding binding
is not scheduled.

To handle such cases, set IEEE80211_HW_DEAUTH_NEED_MGD_TX_PREP in the
HW flags, requesting mac80211 to call the mgd_prepare_tx() callback
before transmitting a deauthentication frame if associated but no
beacon was heard from the AP.

In addition, do not warn in iwl_mvm_mac_mgd_prepare_tx() when already
associated as now the callback can be called also when associated.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 82dc9dec4160..51b30424575b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -421,6 +421,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	ieee80211_hw_set(hw, SUPPORTS_CLONED_SKBS);
 	ieee80211_hw_set(hw, SUPPORTS_AMSDU_IN_AMPDU);
 	ieee80211_hw_set(hw, NEEDS_UNIQUE_STA_ADDR);
+	ieee80211_hw_set(hw, DEAUTH_NEED_MGD_TX_PREP);
 
 	if (iwl_mvm_has_tlc_offload(mvm)) {
 		ieee80211_hw_set(hw, TX_AMPDU_SETUP_IN_HW);
@@ -2815,9 +2816,6 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 	u32 duration = IWL_MVM_TE_SESSION_PROTECTION_MAX_TIME_MS;
 	u32 min_duration = IWL_MVM_TE_SESSION_PROTECTION_MIN_TIME_MS;
 
-	if (WARN_ON_ONCE(vif->bss_conf.assoc))
-		return;
-
 	/*
 	 * iwl_mvm_protect_session() reads directly from the device
 	 * (the system time), so make sure it is available.
-- 
2.16.2
