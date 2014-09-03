Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:42466 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaICT4w (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:52 -0400
Received: by mail-we0-f181.google.com with SMTP id x48so9168697wes.40
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:51 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/36] iwlwifi: mvm: refactor iwl_mvm_power_set_pm() to spin the ps part off
Date: Wed,  3 Sep 2014 22:56:03 +0300
Message-Id: <1409774184-24665-15-git-send-email-egrumbach@gmail.com> (sfid-20140903_215656_533514_F8E23F58)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Separate the ps part of iwl_mvm_power_set_pm() into a new
iwl_mvm_power_set_ps() function.  This will enable us to update the ps
part independently from the rest, which is needed by CSA (at least).

This required a bit of refactoring and the creation of a new iterator
function.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/power.c | 60 +++++++++++++++++++++++---------
 1 file changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 754f2b3..42aaf57 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -504,13 +504,20 @@ struct iwl_power_vifs {
 	bool p2p_tdls;
 };
 
-static void iwl_mvm_power_iterator(void *_data, u8 *mac,
-				   struct ieee80211_vif *vif)
+static void iwl_mvm_power_disable_pm_iterator(void *_data, u8* mac,
+					      struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_power_vifs *power_iterator = _data;
 
 	mvmvif->pm_enabled = false;
+}
+
+static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
+					    struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_power_vifs *power_iterator = _data;
+
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
@@ -577,10 +584,11 @@ static void iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
 
 	lockdep_assert_held(&mvm->mutex);
 
-	/* get vifs info + set pm_enable to false */
+	/* set pm_enable to false */
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
-					    IEEE80211_IFACE_ITER_NORMAL,
-					    iwl_mvm_power_iterator, vifs);
+					IEEE80211_IFACE_ITER_NORMAL,
+					iwl_mvm_power_disable_pm_iterator,
+					NULL);
 
 	if (vifs->bss_vif)
 		bss_mvmvif = iwl_mvm_vif_from_mac80211(vifs->bss_vif);
@@ -823,23 +831,16 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	return ret;
 }
 
-int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
+static int iwl_mvm_power_set_ps(struct iwl_mvm *mvm,
+				struct iwl_power_vifs *vifs)
 {
-	struct iwl_mvm_vif *mvmvif;
-	struct iwl_power_vifs vifs = {
-		.mvm = mvm,
-	};
-	bool ba_enable, disable_ps;
+	bool disable_ps;
 	int ret;
 
-	lockdep_assert_held(&mvm->mutex);
-
-	iwl_mvm_power_set_pm(mvm, &vifs);
-
 	/* disable PS if CAM */
 	disable_ps = (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM);
 	/* ...or if there is an active monitor vif */
-	disable_ps |= (vifs.monitor_vif && vifs.monitor_active);
+	disable_ps |= (vifs->monitor_vif && vifs->monitor_active);
 
 	/* update device power state if it has changed */
 	if (mvm->ps_disabled != disable_ps) {
@@ -853,6 +854,31 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 		}
 	}
 
+	return 0;
+}
+
+int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
+{
+	struct iwl_mvm_vif *mvmvif;
+	struct iwl_power_vifs vifs = {
+		.mvm = mvm,
+	};
+	bool ba_enable;
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	/* get vifs info */
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					iwl_mvm_power_get_vifs_iterator, &vifs);
+
+	iwl_mvm_power_set_pm(mvm, &vifs);
+
+	ret = iwl_mvm_power_set_ps(mvm, &vifs);
+	if (ret)
+		return ret;
+
 	if (vifs.bss_vif) {
 		ret = iwl_mvm_power_send_cmd(mvm, vifs.bss_vif);
 		if (ret)
-- 
1.9.1

