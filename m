Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbcAaLGz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 24/31] iwlwifi: mvm: Remove bf_vif from iwl_power_vifs
Date: Sun, 31 Jan 2016 13:06:19 +0200
Message-Id: <1454238386-27032-24-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123654_323527_98ECF277)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

This member is actually not needed as beacon abort
is only allowed for a bss station.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c | 28 ++++++++++++--------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 0d03b3e..83e686d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -577,7 +577,6 @@ void iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 
 struct iwl_power_vifs {
 	struct iwl_mvm *mvm;
-	struct ieee80211_vif *bf_vif;
 	struct ieee80211_vif *bss_vif;
 	struct ieee80211_vif *p2p_vif;
 	struct ieee80211_vif *ap_vif;
@@ -650,11 +649,6 @@ static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 		if (mvmvif->phy_ctxt)
 			if (mvmvif->phy_ctxt->id < MAX_PHYS)
 				power_iterator->bss_active = true;
-
-		if (mvmvif->bf_data.bf_enabled &&
-		    !WARN_ON(power_iterator->bf_vif))
-			power_iterator->bf_vif = vif;
-
 		break;
 
 	default:
@@ -959,21 +953,19 @@ static int iwl_mvm_power_set_ps(struct iwl_mvm *mvm)
 }
 
 static int iwl_mvm_power_set_ba(struct iwl_mvm *mvm,
-				struct iwl_power_vifs *vifs)
+				struct ieee80211_vif *vif)
 {
-	struct iwl_mvm_vif *mvmvif;
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	bool ba_enable;
 
-	if (!vifs->bf_vif)
+	if (!mvmvif->bf_data.bf_enabled)
 		return 0;
 
-	mvmvif = iwl_mvm_vif_from_mac80211(vifs->bf_vif);
-
 	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
-		      !vifs->bf_vif->bss_conf.ps ||
+		      !vif->bss_conf.ps ||
 		      iwl_mvm_vif_low_latency(mvmvif));
 
-	return iwl_mvm_update_beacon_abort(mvm, vifs->bf_vif, ba_enable);
+	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
 }
 
 int iwl_mvm_power_update_ps(struct iwl_mvm *mvm)
@@ -994,7 +986,10 @@ int iwl_mvm_power_update_ps(struct iwl_mvm *mvm)
 	if (ret)
 		return ret;
 
-	return iwl_mvm_power_set_ba(mvm, &vifs);
+	if (vifs.bss_vif)
+		return iwl_mvm_power_set_ba(mvm, vifs.bss_vif);
+
+	return 0;
 }
 
 int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
@@ -1029,7 +1024,10 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 			return ret;
 	}
 
-	return iwl_mvm_power_set_ba(mvm, &vifs);
+	if (vifs.bss_vif)
+		return iwl_mvm_power_set_ba(mvm, vifs.bss_vif);
+
+	return 0;
 }
 
 int iwl_mvm_update_d0i3_power_mode(struct iwl_mvm *mvm,
-- 
2.5.0

