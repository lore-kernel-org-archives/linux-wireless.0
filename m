Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f177.google.com ([74.125.82.177]:62109 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756011AbaICT4z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:55 -0400
Received: by mail-we0-f177.google.com with SMTP id u56so9133607wes.36
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:54 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/36] iwlwifi: mvm: add option that allows a vif to disable PS
Date: Wed,  3 Sep 2014 22:56:05 +0300
Message-Id: <1409774184-24665-17-git-send-email-egrumbach@gmail.com> (sfid-20140903_220113_907402_AF333437)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

We need to disable PS when a monitor vif is active or, in the future,
when a channel switch is happening.  Add a boolean to mvmvif that
allows PS to be disabled generically.  Additionally, make the monitor
interface use this new flag when it gets activated.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |  4 ++++
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/iwlwifi/mvm/power.c    | 25 +++++++++++++++++++------
 3 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 531540c..98e14f9 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2708,7 +2708,10 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 		ret = 0;
 		goto out;
 	case NL80211_IFTYPE_STATION:
+		break;
 	case NL80211_IFTYPE_MONITOR:
+		/* always disable PS when a monitor interface is active */
+		mvmvif->ps_disabled = true;
 		break;
 	default:
 		ret = -EINVAL;
@@ -2784,6 +2787,7 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		goto out;
 	case NL80211_IFTYPE_MONITOR:
 		mvmvif->monitor_active = false;
+		mvmvif->ps_disabled = false;
 		break;
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 108ef16..ffb5093 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -326,6 +326,7 @@ struct iwl_mvm_vif_bf_data {
  *	interface should get quota etc.
  * @low_latency: indicates that this interface is in low-latency mode
  *	(VMACLowLatencyMode)
+ * @ps_disabled: indicates that this interface requires PS to be disabled
  * @queue_params: QoS params for this MAC
  * @bcast_sta: station used for broadcast packets. Used by the following
  *  vifs: P2P_DEVICE, GO and AP.
@@ -343,6 +344,7 @@ struct iwl_mvm_vif {
 	bool pm_enabled;
 	bool monitor_active;
 	bool low_latency;
+	bool ps_disabled;
 	struct iwl_mvm_vif_bf_data bf_data;
 
 	u32 ap_beacon_time;
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 18f887aa..b552183 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -512,6 +512,17 @@ static void iwl_mvm_power_disable_pm_iterator(void *_data, u8* mac,
 	mvmvif->pm_enabled = false;
 }
 
+static void iwl_mvm_power_ps_disabled_iterator(void *_data, u8* mac,
+					       struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	bool *disable_ps = _data;
+
+	if (mvmvif->phy_ctxt)
+		if (mvmvif->phy_ctxt->id < MAX_PHYS)
+			*disable_ps |= mvmvif->ps_disabled;
+}
+
 static void iwl_mvm_power_get_vifs_iterator(void *_data, u8 *mac,
 					    struct ieee80211_vif *vif)
 {
@@ -831,16 +842,18 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	return ret;
 }
 
-static int iwl_mvm_power_set_ps(struct iwl_mvm *mvm,
-				struct iwl_power_vifs *vifs)
+static int iwl_mvm_power_set_ps(struct iwl_mvm *mvm)
 {
 	bool disable_ps;
 	int ret;
 
 	/* disable PS if CAM */
 	disable_ps = (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM);
-	/* ...or if there is an active monitor vif */
-	disable_ps |= (vifs->monitor_vif && vifs->monitor_active);
+	/* ...or if any of the vifs require PS to be off */
+	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
+					IEEE80211_IFACE_ITER_NORMAL,
+					iwl_mvm_power_ps_disabled_iterator,
+					&disable_ps);
 
 	/* update device power state if it has changed */
 	if (mvm->ps_disabled != disable_ps) {
@@ -889,7 +902,7 @@ int iwl_mvm_power_update_ps(struct iwl_mvm *mvm)
 					IEEE80211_IFACE_ITER_NORMAL,
 					iwl_mvm_power_get_vifs_iterator, &vifs);
 
-	ret = iwl_mvm_power_set_ps(mvm, &vifs);
+	ret = iwl_mvm_power_set_ps(mvm);
 	if (ret)
 		return ret;
 
@@ -912,7 +925,7 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm)
 
 	iwl_mvm_power_set_pm(mvm, &vifs);
 
-	ret = iwl_mvm_power_set_ps(mvm, &vifs);
+	ret = iwl_mvm_power_set_ps(mvm);
 	if (ret)
 		return ret;
 
-- 
1.9.1

