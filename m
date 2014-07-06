Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:57759 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaGFJhH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:07 -0400
Received: by mail-we0-f181.google.com with SMTP id q59so3181227wes.12
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:06 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 29/40] iwlwifi: mvm: add switch_vif_chanctx operation
Date: Sun,  6 Jul 2014 12:36:05 +0300
Message-Id: <1404639376-3792-29-git-send-email-egrumbach@gmail.com> (sfid-20140706_115955_031568_14DD0FDD)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Implement the switch_vif_chanctx operation with support for a
single-vif and SWAP mode.  The REASSIGN mode and multi-vifs are not
supported yet.

This operation needs to implement 4 steps, namely unassign, remove,
add and assign the chanctx.  In order to do this, split out these
operations into locked and non-locked parts, thus allowing us to call
them while locked.

Additionally, in order to allow us to restart the hardware when
something fails, add a boolean to the iwl_mvm_nic_restart() function
that tells whether the restart was triggered by a FW error or
something else.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 154 +++++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   2 +
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  11 +-
 3 files changed, 135 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 72f82a3..24cc569 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2282,17 +2282,17 @@ static int iwl_mvm_cancel_roc(struct ieee80211_hw *hw)
 	return 0;
 }
 
-static int iwl_mvm_add_chanctx(struct ieee80211_hw *hw,
-			       struct ieee80211_chanctx_conf *ctx)
+static int __iwl_mvm_add_chanctx(struct iwl_mvm *mvm,
+				 struct ieee80211_chanctx_conf *ctx)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
 	struct iwl_mvm_phy_ctxt *phy_ctxt;
 	int ret;
 
+	lockdep_assert_held(&mvm->mutex);
+
 	IWL_DEBUG_MAC80211(mvm, "Add channel context\n");
 
-	mutex_lock(&mvm->mutex);
 	phy_ctxt = iwl_mvm_get_free_phy_ctxt(mvm);
 	if (!phy_ctxt) {
 		ret = -ENOSPC;
@@ -2310,19 +2310,40 @@ static int iwl_mvm_add_chanctx(struct ieee80211_hw *hw,
 	iwl_mvm_phy_ctxt_ref(mvm, phy_ctxt);
 	*phy_ctxt_id = phy_ctxt->id;
 out:
+	return ret;
+}
+
+static int iwl_mvm_add_chanctx(struct ieee80211_hw *hw,
+			       struct ieee80211_chanctx_conf *ctx)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	mutex_lock(&mvm->mutex);
+	ret = __iwl_mvm_add_chanctx(mvm, ctx);
 	mutex_unlock(&mvm->mutex);
+
 	return ret;
 }
 
+static void __iwl_mvm_remove_chanctx(struct iwl_mvm *mvm,
+				     struct ieee80211_chanctx_conf *ctx)
+{
+	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
+	struct iwl_mvm_phy_ctxt *phy_ctxt = &mvm->phy_ctxts[*phy_ctxt_id];
+
+	lockdep_assert_held(&mvm->mutex);
+
+	iwl_mvm_phy_ctxt_unref(mvm, phy_ctxt);
+}
+
 static void iwl_mvm_remove_chanctx(struct ieee80211_hw *hw,
 				   struct ieee80211_chanctx_conf *ctx)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
-	struct iwl_mvm_phy_ctxt *phy_ctxt = &mvm->phy_ctxts[*phy_ctxt_id];
 
 	mutex_lock(&mvm->mutex);
-	iwl_mvm_phy_ctxt_unref(mvm, phy_ctxt);
+	__iwl_mvm_remove_chanctx(mvm, ctx);
 	mutex_unlock(&mvm->mutex);
 }
 
@@ -2351,17 +2372,16 @@ static void iwl_mvm_change_chanctx(struct ieee80211_hw *hw,
 	mutex_unlock(&mvm->mutex);
 }
 
-static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif,
-				      struct ieee80211_chanctx_conf *ctx)
+static int __iwl_mvm_assign_vif_chanctx(struct iwl_mvm *mvm,
+					struct ieee80211_vif *vif,
+					struct ieee80211_chanctx_conf *ctx)
 {
-	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	u16 *phy_ctxt_id = (u16 *)ctx->drv_priv;
 	struct iwl_mvm_phy_ctxt *phy_ctxt = &mvm->phy_ctxts[*phy_ctxt_id];
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	int ret;
 
-	mutex_lock(&mvm->mutex);
+	lockdep_assert_held(&mvm->mutex);
 
 	mvmvif->phy_ctxt = phy_ctxt;
 
@@ -2378,18 +2398,18 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 		 * (in bss_info_changed), similarly for IBSS.
 		 */
 		ret = 0;
-		goto out_unlock;
+		goto out;
 	case NL80211_IFTYPE_STATION:
 	case NL80211_IFTYPE_MONITOR:
 		break;
 	default:
 		ret = -EINVAL;
-		goto out_unlock;
+		goto out;
 	}
 
 	ret = iwl_mvm_binding_add_vif(mvm, vif);
 	if (ret)
-		goto out_unlock;
+		goto out;
 
 	/*
 	 * Power state must be updated before quotas,
@@ -2414,32 +2434,43 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 		iwl_mvm_mac_ctxt_changed(mvm, vif, false);
 	}
 
-	goto out_unlock;
+	goto out;
 
- out_remove_binding:
+out_remove_binding:
 	iwl_mvm_binding_remove_vif(mvm, vif);
 	iwl_mvm_power_update_mac(mvm);
- out_unlock:
-	mutex_unlock(&mvm->mutex);
+out:
 	if (ret)
 		mvmvif->phy_ctxt = NULL;
 	return ret;
 }
-
-static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
-					 struct ieee80211_vif *vif,
-					 struct ieee80211_chanctx_conf *ctx)
+static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
+				      struct ieee80211_vif *vif,
+				      struct ieee80211_chanctx_conf *ctx)
 {
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	int ret;
 
 	mutex_lock(&mvm->mutex);
+	ret = __iwl_mvm_assign_vif_chanctx(mvm, vif, ctx);
+	mutex_unlock(&mvm->mutex);
+
+	return ret;
+}
+
+static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
+					   struct ieee80211_vif *vif,
+					   struct ieee80211_chanctx_conf *ctx)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	lockdep_assert_held(&mvm->mutex);
 
 	iwl_mvm_remove_time_event(mvm, mvmvif, &mvmvif->time_event_data);
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_ADHOC:
-		goto out_unlock;
+		goto out;
 	case NL80211_IFTYPE_MONITOR:
 		mvmvif->monitor_active = false;
 		iwl_mvm_update_quotas(mvm, NULL);
@@ -2447,7 +2478,7 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	case NL80211_IFTYPE_AP:
 		/* This part is triggered only during CSA */
 		if (!vif->csa_active || !mvmvif->ap_ibss_active)
-			goto out_unlock;
+			goto out;
 
 		mvmvif->ap_ibss_active = false;
 		iwl_mvm_update_quotas(mvm, NULL);
@@ -2457,12 +2488,80 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
-out_unlock:
+out:
 	mvmvif->phy_ctxt = NULL;
 	iwl_mvm_power_update_mac(mvm);
+}
+
+static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
+					 struct ieee80211_vif *vif,
+					 struct ieee80211_chanctx_conf *ctx)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	mutex_lock(&mvm->mutex);
+	__iwl_mvm_unassign_vif_chanctx(mvm, vif, ctx);
 	mutex_unlock(&mvm->mutex);
 }
 
+static int iwl_mvm_switch_vif_chanctx(struct ieee80211_hw *hw,
+				      struct ieee80211_vif_chanctx_switch *vifs,
+				      int n_vifs,
+				      enum ieee80211_chanctx_switch_mode mode)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	int ret;
+
+	/* we only support SWAP_CONTEXTS and with a single-vif right now */
+	if (mode != CHANCTX_SWMODE_SWAP_CONTEXTS || n_vifs > 1)
+		return -EOPNOTSUPP;
+
+	mutex_lock(&mvm->mutex);
+	__iwl_mvm_unassign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx);
+	__iwl_mvm_remove_chanctx(mvm, vifs[0].old_ctx);
+
+	ret = __iwl_mvm_add_chanctx(mvm, vifs[0].new_ctx);
+	if (ret) {
+		IWL_ERR(mvm, "failed to add new_ctx during channel switch\n");
+		goto out_reassign;
+	}
+
+	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].new_ctx);
+	if (ret) {
+		IWL_ERR(mvm,
+			"failed to assign new_ctx during channel switch\n");
+		goto out_remove;
+	}
+
+	goto out;
+
+out_remove:
+	__iwl_mvm_remove_chanctx(mvm, vifs[0].new_ctx);
+
+out_reassign:
+	ret = __iwl_mvm_add_chanctx(mvm, vifs[0].old_ctx);
+	if (ret) {
+		IWL_ERR(mvm, "failed to add old_ctx back after failure.\n");
+		goto out_restart;
+	}
+
+	ret = __iwl_mvm_assign_vif_chanctx(mvm, vifs[0].vif, vifs[0].old_ctx);
+	if (ret) {
+		IWL_ERR(mvm, "failed to reassign old_ctx after failure.\n");
+		goto out_restart;
+	}
+
+	goto out;
+
+out_restart:
+	/* things keep failing, better restart the hw */
+	iwl_mvm_nic_restart(mvm, false);
+
+out:
+	mutex_unlock(&mvm->mutex);
+	return ret;
+}
+
 static int iwl_mvm_set_tim(struct ieee80211_hw *hw,
 			   struct ieee80211_sta *sta,
 			   bool set)
@@ -2627,6 +2726,7 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.change_chanctx = iwl_mvm_change_chanctx,
 	.assign_vif_chanctx = iwl_mvm_assign_vif_chanctx,
 	.unassign_vif_chanctx = iwl_mvm_unassign_vif_chanctx,
+	.switch_vif_chanctx = iwl_mvm_switch_vif_chanctx,
 
 	.start_ap = iwl_mvm_start_ap_ibss,
 	.stop_ap = iwl_mvm_stop_ap_ibss,
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5fedd55..fa8fcbc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -1077,4 +1077,6 @@ void iwl_mvm_set_hw_ctkill_state(struct iwl_mvm *mvm, bool state);
 int iwl_mvm_sf_update(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 		      bool added_vif);
 
+void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error);
+
 #endif /* __IWL_MVM_H__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 4e2823f..89a0956 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -764,7 +764,7 @@ static void iwl_mvm_reprobe_wk(struct work_struct *wk)
 	module_put(THIS_MODULE);
 }
 
-static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
+void iwl_mvm_nic_restart(struct iwl_mvm *mvm, bool fw_error)
 {
 	iwl_abort_notification_waits(&mvm->notif_wait);
 
@@ -821,11 +821,12 @@ static void iwl_mvm_nic_restart(struct iwl_mvm *mvm)
 		reprobe->dev = mvm->trans->dev;
 		INIT_WORK(&reprobe->work, iwl_mvm_reprobe_wk);
 		schedule_work(&reprobe->work);
-	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR && mvm->restart_fw) {
+	} else if (mvm->cur_ucode == IWL_UCODE_REGULAR &&
+		   (!fw_error || mvm->restart_fw)) {
 		/* don't let the transport/FW power down */
 		iwl_mvm_ref(mvm, IWL_MVM_REF_UCODE_DOWN);
 
-		if (mvm->restart_fw > 0)
+		if (fw_error && mvm->restart_fw > 0)
 			mvm->restart_fw--;
 		ieee80211_restart_hw(mvm->hw);
 	}
@@ -837,7 +838,7 @@ static void iwl_mvm_nic_error(struct iwl_op_mode *op_mode)
 
 	iwl_mvm_dump_nic_error_log(mvm);
 
-	iwl_mvm_nic_restart(mvm);
+	iwl_mvm_nic_restart(mvm, true);
 }
 
 static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
@@ -845,7 +846,7 @@ static void iwl_mvm_cmd_queue_full(struct iwl_op_mode *op_mode)
 	struct iwl_mvm *mvm = IWL_OP_MODE_GET_MVM(op_mode);
 
 	WARN_ON(1);
-	iwl_mvm_nic_restart(mvm);
+	iwl_mvm_nic_restart(mvm, true);
 }
 
 struct iwl_d0i3_iter_data {
-- 
1.8.3.2

