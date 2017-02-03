Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37858 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752641AbdBCOi3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:29 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:52 +0200
Message-Id: <20170203143812.7525-6-luca@coelho.fi> (sfid-20170203_153835_133011_AA9EEB68)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: mvm: cleanup incorrect and redundant define
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

Currently we have up to 3 phy contexts - defined by NUM_PHY_CTX.
However - some code paths validate the ID by using MAX_PHYS define
which is set to 4.
While there is no harm it is incorrect - since the maximum is 3.
Remove the define and use the correct one.
Cleanup the code a bit while at it.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h |  1 -
 drivers/net/wireless/intel/iwlwifi/mvm/power.c  | 26 +++++++++++--------------
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c   |  2 +-
 3 files changed, 12 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index 0b77073e719a..91f53596130b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -713,7 +713,6 @@ struct iwl_error_resp {
 #define MAX_MACS_IN_BINDING	(3)
 #define MAX_BINDINGS		(4)
 #define AUX_BINDING_INDEX	(3)
-#define MAX_PHYS		(4)
 
 /* Used to extract ID and color from the context dword */
 #define FW_CTXT_ID_POS	  (0)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 3a8e9379da2f..e684811f8e8b 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -599,9 +599,8 @@ static void iwl_mvm_power_ps_disabled_iterator(void *_data, u8* mac,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	bool *disable_ps = _data;
 
-	if (mvmvif->phy_ctxt)
-		if (mvmvif->phy_ctxt->id < MAX_PHYS)
-			*disable_ps |= mvmvif->ps_disabled;
+	if (mvmvif->phy_ctxt && mvmvif->phy_ctxt->id < NUM_PHY_CTX)
+		*disable_ps |= mvmvif->ps_disabled;
 }
 
 static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
@@ -609,6 +608,7 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_power_vifs *power_iterator = _data;
+	bool active = mvmvif->phy_ctxt && mvmvif->phy_ctxt->id < NUM_PHY_CTX;
 
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_DEVICE:
@@ -619,34 +619,30 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->ap_vif);
 		power_iterator->ap_vif = vif;
-		if (mvmvif->phy_ctxt)
-			if (mvmvif->phy_ctxt->id < MAX_PHYS)
-				power_iterator->ap_active = true;
+		if (active)
+			power_iterator->ap_active = true;
 		break;
 
 	case NL80211_IFTYPE_MONITOR:
 		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->monitor_vif);
 		power_iterator->monitor_vif = vif;
-		if (mvmvif->phy_ctxt)
-			if (mvmvif->phy_ctxt->id < MAX_PHYS)
-				power_iterator->monitor_active = true;
+		if (active)
+			power_iterator->monitor_active = true;
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
 		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->p2p_vif);
 		power_iterator->p2p_vif = vif;
-		if (mvmvif->phy_ctxt)
-			if (mvmvif->phy_ctxt->id < MAX_PHYS)
-				power_iterator->p2p_active = true;
+		if (active)
+			power_iterator->p2p_active = true;
 		break;
 
 	case NL80211_IFTYPE_STATION:
 		power_iterator->bss_vif = vif;
-		if (mvmvif->phy_ctxt)
-			if (mvmvif->phy_ctxt->id < MAX_PHYS)
-				power_iterator->bss_active = true;
+		if (active)
+			power_iterator->bss_active = true;
 		break;
 
 	default:
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
index fa9743205491..2aaa5ecf97bc 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -197,7 +197,7 @@ static void iwl_mvm_scan_condition_iterator(void *data, u8 *mac,
 	int *global_cnt = data;
 
 	if (vif->type != NL80211_IFTYPE_P2P_DEVICE && mvmvif->phy_ctxt &&
-	    mvmvif->phy_ctxt->id < MAX_PHYS)
+	    mvmvif->phy_ctxt->id < NUM_PHY_CTX)
 		*global_cnt += 1;
 }
 
-- 
2.11.0
