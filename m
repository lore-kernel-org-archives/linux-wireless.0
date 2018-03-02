Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33432 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1424003AbeCBMbW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Mar 2018 07:31:22 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Beni Lev <beni.lev@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  2 Mar 2018 14:31:10 +0200
Message-Id: <20180302123112.27416-3-luca@coelho.fi> (sfid-20180302_133126_744999_7A9C6117)
In-Reply-To: <20180302123112.27416-1-luca@coelho.fi>
References: <20180302123112.27416-1-luca@coelho.fi>
Subject: [PATCH 2/4] iwlwifi: mvm: Correctly set IGTK for AP
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Beni Lev <beni.lev@intel.com>

Currently when an IGTK is set for an AP, it is set as a regular key.
Since the cipher is set to CMAC, the STA_KEY_FLG_EXT flag is added to
the host command, which causes assert 0x253D on NICs that do not support
this.

Fixes: 85aeb58cec1a ("iwlwifi: mvm: Enable security on new TX API")
Signed-off-by: Beni Lev <beni.lev@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index 630e23cb0ffb..5be4bae5b70d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -3233,17 +3233,9 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 		}
 		sta_id = mvm_sta->sta_id;
 
-		if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
-		    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
-		    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256) {
-			ret = iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id,
-						    false);
-			goto end;
-		}
-
 		/*
 		 * It is possible that the 'sta' parameter is NULL, and thus
-		 * there is a need to retrieve  the sta from the local station
+		 * there is a need to retrieve the sta from the local station
 		 * table.
 		 */
 		if (!sta) {
@@ -3258,6 +3250,17 @@ int iwl_mvm_set_sta_key(struct iwl_mvm *mvm,
 
 		if (WARN_ON_ONCE(iwl_mvm_sta_from_mac80211(sta)->vif != vif))
 			return -EINVAL;
+	} else {
+		struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+		sta_id = mvmvif->mcast_sta.sta_id;
+	}
+
+	if (keyconf->cipher == WLAN_CIPHER_SUITE_AES_CMAC ||
+	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_128 ||
+	    keyconf->cipher == WLAN_CIPHER_SUITE_BIP_GMAC_256) {
+		ret = iwl_mvm_send_sta_igtk(mvm, keyconf, sta_id, false);
+		goto end;
 	}
 
 	/* If the key_offset is not pre-assigned, we need to find a
-- 
2.16.1
