Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f53.google.com ([74.125.83.53]:43076 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab3LQUo5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:44:57 -0500
Received: by mail-ee0-f53.google.com with SMTP id b57so3139621eek.40
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:44:56 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 08/36] iwlwifi: mvm: Change power management dependency on multi MAC
Date: Tue, 17 Dec 2013 22:44:11 +0200
Message-Id: <1387313079-28123-8-git-send-email-egrumbach@gmail.com> (sfid-20131217_214641_991294_9B2FCC4E)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

FW still does not support power management on multiple MAC interfaces.
Currently the driver enforce this limitation by disabling PM if second
interface is added. Change this behavior to allow PM on a single interface
even if other interfaces exist but not bound to any specific PHY.
PM will be enabled if only one single interface is bound.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c |   63 +++++++--------------------
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |   19 +++++---
 drivers/net/wireless/iwlwifi/mvm/power.c    |   36 ++++++++++-----
 3 files changed, 53 insertions(+), 65 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 8d80728..e1c379a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -494,17 +494,6 @@ static void iwl_mvm_mac_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&mvm->async_handlers_wk);
 }
 
-static void iwl_mvm_pm_disable_iterator(void *data, u8 *mac,
-					struct ieee80211_vif *vif)
-{
-	struct iwl_mvm *mvm = data;
-	int ret;
-
-	ret = iwl_mvm_power_disable(mvm, vif);
-	if (ret)
-		IWL_ERR(mvm, "failed to disable power management\n");
-}
-
 static void iwl_mvm_power_update_iterator(void *data, u8 *mac,
 					  struct ieee80211_vif *vif)
 {
@@ -547,26 +536,9 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_unlock;
 
-	/*
-	 * TODO: remove this temporary code.
-	 * Currently MVM FW supports power management only on single MAC.
-	 * If new interface added, disable PM on existing interface.
-	 * P2P device is a special case, since it is handled by FW similary to
-	 * scan. If P2P deviced is added, PM remains enabled on existing
-	 * interface.
-	 * Note: the method below does not count the new interface being added
-	 * at this moment.
-	 */
+	/* Counting number of interfaces is needed for legacy PM */
 	if (vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count++;
-	if (mvm->vif_count > 1) {
-		IWL_DEBUG_MAC80211(mvm,
-				   "Disable power on existing interfaces\n");
-		ieee80211_iterate_active_interfaces_atomic(
-					    mvm->hw,
-					    IEEE80211_IFACE_ITER_NORMAL,
-					    iwl_mvm_pm_disable_iterator, mvm);
-	}
 
 	/*
 	 * The AP binding flow can be done only after the beacon
@@ -597,11 +569,7 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	if (ret)
 		goto out_release;
 
-	/*
-	 * Update power state on the new interface. Admittedly, based on
-	 * mac80211 logics this power update will disable power management
-	 */
-	iwl_mvm_power_update_mode(mvm, vif);
+	iwl_mvm_power_disable(mvm, vif);
 
 	/* beacon filtering */
 	ret = iwl_mvm_disable_beacon_filter(mvm, vif);
@@ -662,9 +630,12 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
  out_release:
 	if (vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count--;
+
+	/* TODO: remove this when legacy PM will be discarded */
 	ieee80211_iterate_active_interfaces(
 		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
 		iwl_mvm_power_update_iterator, mvm);
+
 	iwl_mvm_mac_ctxt_release(mvm, vif);
  out_unlock:
 	mutex_unlock(&mvm->mutex);
@@ -750,21 +721,13 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 		mvmvif->phy_ctxt = NULL;
 	}
 
-	/*
-	 * TODO: remove this temporary code.
-	 * Currently MVM FW supports power management only on single MAC.
-	 * Check if only one additional interface remains after removing
-	 * current one. Update power mode on the remaining interface.
-	 */
 	if (mvm->vif_count && vif->type != NL80211_IFTYPE_P2P_DEVICE)
 		mvm->vif_count--;
-	IWL_DEBUG_MAC80211(mvm, "Currently %d interfaces active\n",
-			   mvm->vif_count);
-	if (mvm->vif_count == 1) {
-		ieee80211_iterate_active_interfaces(
-					mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
-					iwl_mvm_power_update_iterator, mvm);
-	}
+
+	/* TODO: remove this when legacy PM will be discarded */
+	ieee80211_iterate_active_interfaces(
+		mvm->hw, IEEE80211_IFACE_ITER_NORMAL,
+		iwl_mvm_power_update_iterator, mvm);
 
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
 
@@ -1658,6 +1621,9 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 			goto out_remove_binding;
 	}
 
+	mvm->bound_vif_cnt++;
+	iwl_mvm_power_update_binding(mvm, vif);
+
 	goto out_unlock;
 
  out_remove_binding:
@@ -1695,6 +1661,9 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	iwl_mvm_binding_remove_vif(mvm, vif);
 out_unlock:
 	mvmvif->phy_ctxt = NULL;
+	mvm->bound_vif_cnt--;
+	iwl_mvm_power_update_binding(mvm, vif);
+
 	mutex_unlock(&mvm->mutex);
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5da5e2d..51b0e9a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -163,6 +163,8 @@ struct iwl_mvm_power_ops {
 				 struct ieee80211_vif *vif);
 	int (*power_update_device_mode)(struct iwl_mvm *mvm);
 	int (*power_disable)(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
+	void (*power_update_binding)(struct iwl_mvm *mvm,
+				     struct ieee80211_vif *vif);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	int (*power_dbgfs_read)(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 				char *buf, int bufsz);
@@ -336,6 +338,8 @@ struct iwl_mvm_vif {
 
 	/* FW identified misbehaving AP */
 	u8 uapsd_misbehaving_bssid[ETH_ALEN];
+
+	bool pm_prevented;
 };
 
 static inline struct iwl_mvm_vif *
@@ -520,12 +524,6 @@ struct iwl_mvm {
 	 */
 	unsigned long fw_key_table[BITS_TO_LONGS(STA_KEY_MAX_NUM)];
 
-	/*
-	 * This counter of created interfaces is referenced only in conjunction
-	 * with FW limitation related to power management. Currently PM is
-	 * supported only on a single interface.
-	 * IMPORTANT: this variable counts all interfaces except P2P device.
-	 */
 	u8 vif_count;
 
 	/* -1 for always, 0 for never, >0 for that many times */
@@ -568,6 +566,8 @@ struct iwl_mvm {
 	u8 aux_queue;
 	u8 first_agg_queue;
 	u8 last_agg_queue;
+
+	u8 bound_vif_cnt;
 };
 
 /* Extract MVM priv from op_mode and _hw */
@@ -786,6 +786,13 @@ static inline int iwl_mvm_power_update_device_mode(struct iwl_mvm *mvm)
 	return 0;
 }
 
+static inline void iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
+						struct ieee80211_vif *vif)
+{
+	if (mvm->pm_ops->power_update_binding)
+		mvm->pm_ops->power_update_binding(mvm, vif);
+}
+
 void iwl_mvm_power_vif_assoc(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 					     struct iwl_rx_cmd_buffer *rxb,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 1817b2a..d5d4935 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -311,7 +311,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 	    mvmvif->dbgfs_pm.disable_power_off)
 		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
 #endif
-	if (!vif->bss_conf.ps)
+	if (!vif->bss_conf.ps || mvmvif->pm_prevented)
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
@@ -406,17 +406,6 @@ static int iwl_mvm_power_mac_update_mode(struct iwl_mvm *mvm,
 	if (vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
-	/*
-	 * TODO: The following vif_count verification is temporary condition.
-	 * Avoid power mode update if more than one interface is currently
-	 * active. Remove this condition when FW will support power management
-	 * on multiple MACs.
-	 */
-	IWL_DEBUG_POWER(mvm, "Currently %d interfaces active\n",
-			mvm->vif_count);
-	if (mvm->vif_count > 1)
-		return 0;
-
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	iwl_mvm_power_log(mvm, &cmd);
 
@@ -522,6 +511,28 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
+static void iwl_mvm_power_binding_iterator(void *_data, u8 *mac,
+					   struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm *mvm = _data;
+	int ret;
+
+	mvmvif->pm_prevented = (mvm->bound_vif_cnt <= 1) ? false : true;
+
+	ret = iwl_mvm_power_mac_update_mode(mvm, vif);
+	WARN_ONCE(ret, "Failed to update power parameters on a specific vif\n");
+}
+
+static void _iwl_mvm_power_update_binding(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif)
+{
+	ieee80211_iterate_active_interfaces(mvm->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    iwl_mvm_power_binding_iterator,
+					    mvm);
+}
+
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 static int iwl_mvm_power_mac_dbgfs_read(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif, char *buf,
@@ -692,6 +703,7 @@ const struct iwl_mvm_power_ops pm_mac_ops = {
 	.power_update_mode = iwl_mvm_power_mac_update_mode,
 	.power_update_device_mode = iwl_mvm_power_update_device,
 	.power_disable = iwl_mvm_power_mac_disable,
+	.power_update_binding = _iwl_mvm_power_update_binding,
 #ifdef CONFIG_IWLWIFI_DEBUGFS
 	.power_dbgfs_read = iwl_mvm_power_mac_dbgfs_read,
 #endif
-- 
1.7.9.5

