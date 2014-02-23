Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:44063 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751547AbaBWT5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Feb 2014 14:57:23 -0500
Received: by mail-wg0-f49.google.com with SMTP id y10so3961491wgg.28
        for <linux-wireless@vger.kernel.org>; Sun, 23 Feb 2014 11:57:21 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Alexander Bondar <alexander.bondar@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/17] iwlwifi: mvm: Enable power save on BSS and P2P client in DCM
Date: Sun, 23 Feb 2014 21:56:57 +0200
Message-Id: <1393185428-8524-6-git-send-email-egrumbach@gmail.com> (sfid-20140223_205731_991374_274CFA14)
In-Reply-To: <530A51A4.6000007@gmail.com>
References: <530A51A4.6000007@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alexander Bondar <alexander.bondar@intel.com>

New FW enables support for power save on BSS and P2P client MACs
simultaneously when they function on different channels (DCM).
Enable this case in the driver after examining new TLV flag -
IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM. Still power management is not
allowed on both MACs if they function on a same channel.
Remove another redundant TLV flag - IWL_UCODE_TLV_FLAGS_P2P_PS that
is not in use anymore. Remove bound_vif_cnt as redundant.

Signed-off-by: Alexander Bondar <alexander.bondar@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h          |    6 +--
 drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c |    2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c    |    6 ---
 drivers/net/wireless/iwlwifi/mvm/mvm.h         |    2 -
 drivers/net/wireless/iwlwifi/mvm/power.c       |   48 ++++++++++++++++++++----
 5 files changed, 44 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index f80ba58..b0d0998 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -92,8 +92,8 @@
  * @IWL_UCODE_TLV_FLAGS_STA_KEY_CMD: new ADD_STA and ADD_STA_KEY command API
  * @IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD: support device wide power command
  *	containing CAM (Continuous Active Mode) indication.
- * @IWL_UCODE_TLV_FLAGS_P2P_PS: P2P client power save is supported (only on a
- *	single bound interface).
+ * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_DCM: support power save on BSS station and
+ *	P2P client interfaces simultaneously if they are in different bindings.
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
  * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
  * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
@@ -118,7 +118,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_SCHED_SCAN		= BIT(17),
 	IWL_UCODE_TLV_FLAGS_STA_KEY_CMD		= BIT(19),
 	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
-	IWL_UCODE_TLV_FLAGS_P2P_PS		= BIT(21),
+	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
 	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
index 29b4396..f64e972 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs-vif.c
@@ -591,7 +591,7 @@ void iwl_mvm_vif_dbgfs_register(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	    iwlmvm_mod_params.power_scheme != IWL_POWER_SCHEME_CAM &&
 	    ((vif->type == NL80211_IFTYPE_STATION && !vif->p2p) ||
 	     (vif->type == NL80211_IFTYPE_STATION && vif->p2p &&
-	      mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS)))
+	      mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)))
 		MVM_DEBUGFS_ADD_FILE_VIF(pm_params, mvmvif->dbgfs_dir, S_IWUSR |
 					 S_IRUSR);
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 2a1b4b6..83da68c 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1305,7 +1305,6 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	mvmvif->ap_ibss_active = true;
 
 	/* power updated needs to be done before quotas */
-	mvm->bound_vif_cnt++;
 	iwl_mvm_power_update_mac(mvm, vif);
 
 	ret = iwl_mvm_update_quotas(mvm, vif);
@@ -1324,7 +1323,6 @@ static int iwl_mvm_start_ap_ibss(struct ieee80211_hw *hw,
 	return 0;
 
 out_quota_failed:
-	mvm->bound_vif_cnt--;
 	iwl_mvm_power_update_mac(mvm, vif);
 	mvmvif->ap_ibss_active = false;
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
@@ -1361,7 +1359,6 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	iwl_mvm_send_rm_bcast_sta(mvm, &mvmvif->bcast_sta);
 	iwl_mvm_binding_remove_vif(mvm, vif);
 
-	mvm->bound_vif_cnt--;
 	iwl_mvm_power_update_mac(mvm, vif);
 
 	iwl_mvm_mac_ctxt_remove(mvm, vif);
@@ -2095,7 +2092,6 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 	 * Power state must be updated before quotas,
 	 * otherwise fw will complain.
 	 */
-	mvm->bound_vif_cnt++;
 	iwl_mvm_power_update_mac(mvm, vif);
 
 	/* Setting the quota at this stage is only required for monitor
@@ -2113,7 +2109,6 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 
  out_remove_binding:
 	iwl_mvm_binding_remove_vif(mvm, vif);
-	mvm->bound_vif_cnt--;
 	iwl_mvm_power_update_mac(mvm, vif);
  out_unlock:
 	mutex_unlock(&mvm->mutex);
@@ -2146,7 +2141,6 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	}
 
 	iwl_mvm_binding_remove_vif(mvm, vif);
-	mvm->bound_vif_cnt--;
 	iwl_mvm_power_update_mac(mvm, vif);
 
 out_unlock:
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 29d11d9..823765e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -587,8 +587,6 @@ struct iwl_mvm {
 	u8 first_agg_queue;
 	u8 last_agg_queue;
 
-	u8 bound_vif_cnt;
-
 	/* Indicate if device power save is allowed */
 	bool ps_disabled;
 	/* Indicate if device power management is allowed */
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 4da1ea4..def6ec5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -425,7 +425,7 @@ static int iwl_mvm_power_send_cmd(struct iwl_mvm *mvm,
 		return 0;
 
 	if (vif->p2p &&
-	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PS))
+	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM))
 		return 0;
 
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
@@ -511,8 +511,11 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 struct iwl_power_constraint {
 	struct ieee80211_vif *bf_vif;
 	struct ieee80211_vif *bss_vif;
+	u16 bss_phyctx_id;
+	u16 p2p_phyctx_id;
 	bool pm_disabled;
 	bool ps_disabled;
+	struct iwl_mvm *mvm;
 };
 
 static void iwl_mvm_power_iterator(void *_data, u8 *mac,
@@ -520,6 +523,7 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_power_constraint *power_iterator = _data;
+	struct iwl_mvm *mvm = power_iterator->mvm;
 
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_DEVICE:
@@ -539,11 +543,28 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
-		/* no BSS power mgmt if we have a P2P client*/
-		power_iterator->pm_disabled = true;
+		if (mvmvif->phy_ctxt)
+			power_iterator->p2p_phyctx_id = mvmvif->phy_ctxt->id;
+
+		IWL_DEBUG_POWER(mvm, "p2p: p2p_id=%d, bss_id=%d\n",
+				power_iterator->p2p_phyctx_id,
+				power_iterator->bss_phyctx_id);
+		if (!(mvm->fw->ucode_capa.flags &
+		      IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)) {
+			/* no BSS power mgmt if we have a P2P client*/
+			power_iterator->pm_disabled = true;
+		} else if (power_iterator->p2p_phyctx_id < MAX_PHYS &&
+			   power_iterator->bss_phyctx_id < MAX_PHYS &&
+			   power_iterator->p2p_phyctx_id ==
+			   power_iterator->bss_phyctx_id) {
+			power_iterator->pm_disabled = true;
+		}
 		break;
 
 	case NL80211_IFTYPE_STATION:
+		if (mvmvif->phy_ctxt)
+			power_iterator->bss_phyctx_id = mvmvif->phy_ctxt->id;
+
 		/* we should have only one BSS vif */
 		WARN_ON(power_iterator->bss_vif);
 		power_iterator->bss_vif = vif;
@@ -551,6 +572,17 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 		if (mvmvif->bf_data.bf_enabled &&
 		    !WARN_ON(power_iterator->bf_vif))
 			power_iterator->bf_vif = vif;
+
+		IWL_DEBUG_POWER(mvm, "bss: p2p_id=%d, bss_id=%d\n",
+				power_iterator->p2p_phyctx_id,
+				power_iterator->bss_phyctx_id);
+		if (mvm->fw->ucode_capa.flags &
+		    IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM &&
+			(power_iterator->p2p_phyctx_id < MAX_PHYS &&
+			 power_iterator->bss_phyctx_id < MAX_PHYS &&
+			 power_iterator->p2p_phyctx_id ==
+			 power_iterator->bss_phyctx_id))
+			power_iterator->pm_disabled = true;
 		break;
 
 	default:
@@ -572,16 +604,16 @@ iwl_mvm_power_get_global_constraint(struct iwl_mvm *mvm,
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_power_iterator, constraint);
-
-	/* TODO: remove this and determine this variable in the iterator */
-	if (mvm->bound_vif_cnt > 1)
-		constraint->pm_disabled = true;
 }
 
 int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_power_constraint constraint = {};
+	struct iwl_power_constraint constraint = {
+		    .p2p_phyctx_id = MAX_PHYS,
+		    .bss_phyctx_id = MAX_PHYS,
+		    .mvm = mvm,
+	};
 	bool ba_enable;
 	int ret;
 
-- 
1.7.9.5

