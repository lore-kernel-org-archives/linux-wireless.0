Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:28518 "EHLO mga04.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757320AbcAaLG4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 31 Jan 2016 06:06:56 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 25/31] iwlwifi: mvm: Remove iwl_mvm_update_beacon_abort
Date: Sun, 31 Jan 2016 13:06:20 +0200
Message-Id: <1454238386-27032-25-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160131_123654_197429_B9D14642)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9F363A@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

It is only called from iwl_mvm_power_set_ba() so simplify things
by removing it.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/power.c | 37 +++++++++-----------------
 1 file changed, 12 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/power.c b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
index 83e686d..f313910 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/power.c
@@ -877,26 +877,6 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 	return _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd, flags, false);
 }
 
-static int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
-				       struct ieee80211_vif *vif,
-				       bool enable)
-{
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_beacon_filter_cmd cmd = {
-		IWL_BF_CMD_CONFIG_DEFAULTS,
-		.bf_enable_beacon_filter = cpu_to_le32(1),
-	};
-
-	if (!mvmvif->bf_data.bf_enabled)
-		return 0;
-
-	if (mvm->cur_ucode == IWL_UCODE_WOWLAN)
-		cmd.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_D3);
-
-	mvmvif->bf_data.ba_enabled = enable;
-	return _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd, 0, false);
-}
-
 static int _iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 					  struct ieee80211_vif *vif,
 					  u32 flags, bool d0i3)
@@ -956,16 +936,23 @@ static int iwl_mvm_power_set_ba(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	bool ba_enable;
+	struct iwl_beacon_filter_cmd cmd = {
+		IWL_BF_CMD_CONFIG_DEFAULTS,
+		.bf_enable_beacon_filter = cpu_to_le32(1),
+	};
 
 	if (!mvmvif->bf_data.bf_enabled)
 		return 0;
 
-	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
-		      !vif->bss_conf.ps ||
-		      iwl_mvm_vif_low_latency(mvmvif));
+	if (mvm->cur_ucode == IWL_UCODE_WOWLAN)
+		cmd.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_D3);
+
+	mvmvif->bf_data.ba_enabled = !(!mvmvif->pm_enabled ||
+				       mvm->ps_disabled ||
+				       !vif->bss_conf.ps ||
+				       iwl_mvm_vif_low_latency(mvmvif));
 
-	return iwl_mvm_update_beacon_abort(mvm, vif, ba_enable);
+	return _iwl_mvm_enable_beacon_filter(mvm, vif, &cmd, 0, false);
 }
 
 int iwl_mvm_power_update_ps(struct iwl_mvm *mvm)
-- 
2.5.0

