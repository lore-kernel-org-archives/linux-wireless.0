Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:39348 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754792AbdBHPxM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Feb 2017 10:53:12 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Avraham Stern <avraham.stern@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  8 Feb 2017 17:51:46 +0200
Message-Id: <20170208155149.1704-6-luca@coelho.fi> (sfid-20170208_165326_082637_FD74E21E)
In-Reply-To: <20170208155149.1704-1-luca@coelho.fi>
References: <20170208112322.29413-1-luca@coelho.fi>
 <20170208155149.1704-1-luca@coelho.fi>
Subject: [PATCH 14/17] iwlwifi: mvm: Fix CSA received immediately after association
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avraham Stern <avraham.stern@intel.com>

The session protection set for association is only removed when
BSS_CHANGED_BEACON_INFO is set and BSS_CHANGED_ASSOC is not set.

However, mac80211 may set both on association (in case a beacon was
already received). In this case, mac80211 will not set
BSS_CHANGED_BEACON_INFO on the next beacons because it has already
notified the beacon change, so the session protection is never removed
(until the session protection ends).

When a CSA is received within this time, the station will fail to
folllow the channel switch because it cannot schedule the time event.

Fix this by removing the session protection when
BSS_CHANGED_BEACON_INFO and BSS_CHANGED_ASSOC are both set.

Signed-off-by: Avraham Stern <avraham.stern@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 15ecd3aba71b..7253b92792bf 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2008,16 +2008,16 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 		if (fw_has_capa(&mvm->fw->ucode_capa,
 				IWL_UCODE_TLV_CAPA_UMAC_SCAN))
 			iwl_mvm_config_scan(mvm);
-	} else if (changes & BSS_CHANGED_BEACON_INFO) {
+	}
+
+	if (changes & BSS_CHANGED_BEACON_INFO) {
 		/*
-		 * We received a beacon _after_ association so
+		 * We received a beacon from the associated AP so
 		 * remove the session protection.
 		 */
 		iwl_mvm_remove_time_event(mvm, mvmvif,
 					  &mvmvif->time_event_data);
-	}
 
-	if (changes & BSS_CHANGED_BEACON_INFO) {
 		iwl_mvm_sf_update(mvm, vif, false);
 		WARN_ON(iwl_mvm_enable_beacon_filter(mvm, vif, 0));
 	}
-- 
2.11.0
