Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f50.google.com ([74.125.83.50]:32783 "EHLO
	mail-ee0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab3LQUo7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:59 -0500
Received: by mail-ee0-f50.google.com with SMTP id c41so3192244eek.9
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:57 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 09/36] iwlwifi: mvm: Disable power save for monitor interface
Date: Tue, 17 Dec 2013 22:44:12 +0200
Message-Id: <1387313079-28123-9-git-send-email-egrumbach@gmail.com> (sfid-20131217_214504_657693_DE233B4C)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

When monitor interface is activated device power save needs
to be disabled.
Re-consider power management status on other active
interfaces when monitor interface is bound or unbound.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   15 ++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   10 +++++++---
 drivers/net/wireless/iwlwifi/mvm/power.c    |   22 ++++++++++++++++++----
 3 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index e1c379a..d36105f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1610,7 +1610,13 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 		goto out_unlock;
 
 	/*
-	 * Setting the quota at this stage is only required for monitor
+	 * Power state must be updated before quotas,
+	 * otherwise fw will complain.
+	 */
+	mvm->bound_vif_cnt++;
+	iwl_mvm_power_update_binding(mvm, vif, true);
+
+	/* Setting the quota at this stage is only required for monitor
 	 * interfaces. For the other types, the bss_info changed flow
 	 * will handle quota settings.
 	 */
@@ -1621,13 +1627,12 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 			goto out_remove_binding;
 	}
 
-	mvm->bound_vif_cnt++;
-	iwl_mvm_power_update_binding(mvm, vif);
-
 	goto out_unlock;
 
  out_remove_binding:
 	iwl_mvm_binding_remove_vif(mvm, vif);
+	mvm->bound_vif_cnt--;
+	iwl_mvm_power_update_binding(mvm, vif, false);
  out_unlock:
 	mutex_unlock(&mvm->mutex);
 	if (ret)
@@ -1662,7 +1667,7 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 out_unlock:
 	mvmvif->phy_ctxt = NULL;
 	mvm->bound_vif_cnt--;
-	iwl_mvm_power_update_binding(mvm, vif);
+	iwl_mvm_power_update_binding(mvm, vif, false);
 
 	mutex_unlock(&mvm->mutex);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 51b0e9a..7295f8e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -164,7 +164,7 @@ struct iwl_mvm_power_ops {
 	int (*power_update_device_mode)(struct iwl_mvm *mvm);
 	int (*power_disable)(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 	void (*power_update_binding)(struct iwl_mvm *mvm,
-				     struct ieee80211_vif *vif);
+				     struct ieee80211_vif *vif, bool assign);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	int (*power_dbgfs_read)(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				char *buf, int bufsz);
@@ -568,6 +568,9 @@ struct iwl_mvm {
 	u8 last_agg_queue;
 
 	u8 bound_vif_cnt;
+
+	/* Indicate if device power save is allowed */
+	bool ps_prevented;
 };
 
 /* Extract MVM priv from op_mode and _hw */
@@ -787,10 +790,11 @@ static inline int iwl_mvm_power_update_device_mode(struct iwl_mvm *mvm)
 }
 
 static inline void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
-						struct ieee80211_vif *vif)
+						struct ieee80211_vif *vif,
+						bool assign)
 {
 	if (mvm->pm_ops->power_update_binding)
-		mvm->pm_ops->power_update_binding(mvm, vif);
+		mvm->pm_ops->power_update_binding(mvm, vif, assign);
 }
 
 void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index d5d4935..cfed105 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -301,7 +301,8 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	keep_alive = DIV_ROUND_UP(keep_alive, MSEC_PER_SEC);
 	cmd->keep_alive_seconds = cpu_to_le16(keep_alive);
 
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
+	    mvm->ps_prevented)
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_SAVE_ENA_MSK);
@@ -447,7 +448,7 @@ static int iwl_mvm_power_mac_disable(struct iwl_mvm *mvm,
 				    sizeof(cmd), &cmd);
 }
 
-static int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
+static int _iwl_mvm_power_update_device(struct iwl_mvm *mvm, bool force_disable)
 {
 	struct iwl_device_power_cmd cmd = {
 		.flags = cpu_to_le16(DEVICE_POWER_FLAGS_POWER_SAVE_ENA_MSK),
@@ -456,7 +457,8 @@ static int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD))
 		return 0;
 
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM)
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM ||
+	    force_disable)
 		cmd.flags |= cpu_to_le16(DEVICE_POWER_FLAGS_CAM_MSK);
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -473,6 +475,11 @@ static int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
 				    &cmd);
 }
 
+static int iwl_mvm_power_update_device(struct iwl_mvm *mvm)
+{
+	return _iwl_mvm_power_update_device(mvm, false);
+}
+
 void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
@@ -525,8 +532,15 @@ static void iwl_mvm_power_binding_iterator(void *_data, u8 *mac,
 }
 
 static void _iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
-					  struct ieee80211_vif *vif)
+					  struct ieee80211_vif *vif,
+					  bool assign)
 {
+	if (vif->type == NL80211_IFTYPE_MONITOR) {
+		int ret = _iwl_mvm_power_update_device(mvm, assign);
+		mvm->ps_prevented = assign;
+		WARN_ONCE(ret, "Failed to update power device state\n");
+	}
+
 	ieee80211_iterate_active_interfaces(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_power_binding_iterator,
-- 
1.7.9.5

