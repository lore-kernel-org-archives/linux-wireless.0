Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f179.google.com ([74.125.82.179]:57658 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaGFJhI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:08 -0400
Received: by mail-we0-f179.google.com with SMTP id w62so3125932wes.24
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:07 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 30/40] iwlwifi: mvm: CSA unbind-bind flow support for client
Date: Sun,  6 Jul 2014 12:36:06 +0300
Message-Id: <1404639376-3792-30-git-send-email-egrumbach@gmail.com> (sfid-20140706_115956_528353_AC25F348)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Implement support for unbind-bind flow for the client roles.  This
includes telling the firmware that we are not associated, removing
time-events, removing quotas and updating power management during the
actual switch, and redoing everything in the new channel.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 35 ++++++++++++++++++++---------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 24cc569..78a78c0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -293,6 +293,7 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 		    IEEE80211_HW_AMPDU_AGGREGATION |
 		    IEEE80211_HW_TIMING_BEACON_ONLY |
 		    IEEE80211_HW_CONNECTION_MONITOR |
+		    IEEE80211_HW_CHANCTX_STA_CSA |
 		    IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS |
 		    IEEE80211_HW_SUPPORTS_STATIC_SMPS;
 
@@ -2374,7 +2375,8 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 
 static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
-					struct ieee80211_chanctx_conf *ctx)
+					struct ieee80211_chanctx_conf *ctx,
+					bool switching_chanctx)
 {
 	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
 	struct iwl_mvm_phy_ctxt *phy_ctxt = &mvm->phy_ctxts[*phy_ctxt_id];
@@ -2429,7 +2431,8 @@ static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
 	}
 
 	/* Handle binding during CSA */
-	if (vif->type == NL80211_IFTYPE_AP) {
+	if ((vif->type == NL80211_IFTYPE_AP) ||
+	    (switching_chanctx && (vif->type == NL80211_IFTYPE_STATION))) {
 		iwl_mvm_update_quotas(mvm, NULL);
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	}
@@ -2452,7 +2455,7 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 	int ret;
 
 	mutex_lock(&mvm->mutex);
-	ret = __iwl_mvm_assign_vif_chanctx(mvm, vif, ctx);
+	ret = __iwl_mvm_assign_vif_chanctx(mvm, vif, ctx, false);
 	mutex_unlock(&mvm->mutex);
 
 	return ret;
@@ -2460,9 +2463,11 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 					   struct ieee80211_vif *vif,
-					   struct ieee80211_chanctx_conf *ctx)
+					   struct ieee80211_chanctx_conf *ctx,
+					   bool switching_chanctx)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct ieee80211_vif *disabled_vif = NULL;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -2473,7 +2478,6 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 		goto out;
 	case NL80211_IFTYPE_MONITOR:
 		mvmvif->monitor_active = false;
-		iwl_mvm_update_quotas(mvm, NULL);
 		break;
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
@@ -2481,11 +2485,20 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 			goto out;
 
 		mvmvif->ap_ibss_active = false;
-		iwl_mvm_update_quotas(mvm, NULL);
+		break;
+	case NL80211_IFTYPE_STATION:
+		if (!switching_chanctx)
+			break;
+
+		disabled_vif = vif;
+
+		iwl_mvm_mac_ctxt_changed(mvm, vif, true);
+		break;
 	default:
 		break;
 	}
 
+	iwl_mvm_update_quotas(mvm, disabled_vif);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
 out:
@@ -2500,7 +2513,7 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 
 	mutex_lock(&mvm->mutex);
-	__iwl_mvm_unassign_vif_chanctx(mvm, vif, ctx);
+	__iwl_mvm_unassign_vif_chanctx(mvm, vif, ctx, false);
 	mutex_unlock(&mvm->mutex);
 }
 
@@ -2517,7 +2530,7 @@ static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
 		return -EOPNOTSUPP;
 
 	mutex_lock(&mvm->mutex);
-	__iwl_mvm_unassign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx);
+	__iwl_mvm_unassign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx, true);
 	__iwl_mvm_remove_chanctx(mvm, vifs[0].old_ctx);
 
 	ret = __iwl_mvm_add_chanctx(mvm, vifs[0].new_ctx);
@@ -2526,7 +2539,8 @@ static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
 		goto out_reassign;
 	}
 
-	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].new_ctx);
+	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].new_ctx,
+					   true);
 	if (ret) {
 		IWL_ERR(mvm,
 			"failed to assign new_ctx during channel switch\n");
@@ -2545,7 +2559,8 @@ out_reassign:
 		goto out_restart;
 	}
 
-	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx);
+	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx,
+					   true);
 	if (ret) {
 		IWL_ERR(mvm, "failed to reassign old_ctx after failure.\n");
 		goto out_restart;
-- 
1.8.3.2

