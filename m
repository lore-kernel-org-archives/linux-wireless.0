Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f46.google.com ([74.125.82.46]:59647 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbaDMTUM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:12 -0400
Received: by mail-wg0-f46.google.com with SMTP id b13so7252141wgh.17
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:10 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Avri Altman <avri.altman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/47] iwlwifi: mvm: Handle power management constraints for additional use-cases
Date: Sun, 13 Apr 2014 22:19:16 +0300
Message-Id: <1397416802-32403-1-git-send-email-egrumbach@gmail.com> (sfid-20140413_212016_483491_B8E4C584)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Avri Altman <avri.altman@intel.com>

Today, the driver logic looks for the conditions to disable
power management albeit power management should be enabled
in a very few distinct cases.
This patch changes the driver logic to enable power
management once the required conditions met.
While at it, make some housekeeping and support a few
additional use cases:

a) Add support for a standalone p2p client:
   Power management should be enabled for a P2P client
   MAC only if the firmware supports it (TLV flag is set).
   Instead we used the DCM flag, therefore we didn't cover
   use cases that did not include the DCM flag.

b) Add support to Same-Channel-Mode (SCM):
   If both clients share the same channel (SCM), and there
   are no other active vifs in the system, power management
   should be enabled only if the firmware supports this
   (TLV flag is set).

c) Fix power management logic for GO/AP:
   Today, when we detect an active GO / AP MAC - we disable
   power management for all the vifs altogether.
   Actually, the correct behavior is to enable power
   management on a client if on a different channel
   (based on the firmware capabilities).

d) Housekeeping - Along with that, this patch includes some
   code-reorganizing: Today the logic of disabling power is
   scattered across several functions, specifically in the
   iterator. For the sake of both readability and
   scalability, we moved this logic to its applicable
   function, leaving the iterator gather information only.
   Furthermore, as power management is a MAC-related
   attribute, we moved the power management member to the
   iwl_mvm_vif structure.

Signed-off-by: Avri Altman <avri.altman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h    |   5 +
 drivers/net/wireless/iwlwifi/mvm/mvm.h   |   4 +-
 drivers/net/wireless/iwlwifi/mvm/power.c | 193 ++++++++++++++++++-------------
 3 files changed, 117 insertions(+), 85 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index d14f193..de70919 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -92,8 +92,11 @@
  * @IWL_UCODE_TLV_FLAGS_STA_KEY_CMD: new ADD_STA and ADD_STA_KEY command API
  * @IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD: support device wide power command
  *	containing CAM (Continuous Active Mode) indication.
+ * @IWL_UCODE_TLV_FLAGS_P2P_PM: P2P client supports PM as a stand alone MAC
  * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_DCM: support power save on BSS station and
  *	P2P client interfaces simultaneously if they are in different bindings.
+ * @IWL_UCODE_TLV_FLAGS_P2P_BSS_PS_SCM: support power save on BSS station and
+ *	P2P client interfaces simultaneously if they are in same bindings.
  * @IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD: P2P client supports uAPSD power save
  * @IWL_UCODE_TLV_FLAGS_BCAST_FILTERING: uCode supports broadcast filtering.
  * @IWL_UCODE_TLV_FLAGS_GO_UAPSD: AP/GO interfaces support uAPSD clients
@@ -118,7 +121,9 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_SCHED_SCAN		= BIT(17),
 	IWL_UCODE_TLV_FLAGS_STA_KEY_CMD		= BIT(19),
 	IWL_UCODE_TLV_FLAGS_DEVICE_PS_CMD	= BIT(20),
+	IWL_UCODE_TLV_FLAGS_P2P_PM		= BIT(21),
 	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM	= BIT(22),
+	IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM	= BIT(23),
 	IWL_UCODE_TLV_FLAGS_UAPSD_SUPPORT	= BIT(24),
 	IWL_UCODE_TLV_FLAGS_P2P_PS_UAPSD	= BIT(26),
 	IWL_UCODE_TLV_FLAGS_BCAST_FILTERING	= BIT(29),
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d564233..b032511 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -265,6 +265,7 @@ struct iwl_mvm_vif_bf_data {
  * @uploaded: indicates the MAC context has been added to the device
  * @ap_ibss_active: indicates that AP/IBSS is configured and that the interface
  *	should get quota etc.
+ * @pm_enabled - Indicate if MAC power management is allowed
  * @monitor_active: indicates that monitor context is configured, and that the
  *	interface should get quota etc.
  * @low_latency: indicates that this interface is in low-latency mode
@@ -283,6 +284,7 @@ struct iwl_mvm_vif {
 
 	bool uploaded;
 	bool ap_ibss_active;
+	bool pm_enabled;
 	bool monitor_active;
 	bool low_latency;
 	struct iwl_mvm_vif_bf_data bf_data;
@@ -629,8 +631,6 @@ struct iwl_mvm {
 
 	/* Indicate if device power save is allowed */
 	bool ps_disabled;
-	/* Indicate if device power management is allowed */
-	bool pm_disabled;
 };
 
 /* Extract MVM priv from op_mode and _hw */
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 6b636ea..a1ce8d2 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -309,7 +309,7 @@ static void iwl_mvm_power_build_cmd(struct iwl_mvm *mvm,
 		cmd->flags &= cpu_to_le16(~POWER_FLAGS_POWER_SAVE_ENA_MSK);
 #endif
 	if (!vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif) ||
-	    mvm->pm_disabled)
+	    !mvmvif->pm_enabled)
 		return;
 
 	cmd->flags |= cpu_to_le16(POWER_FLAGS_POWER_MANAGEMENT_ENA_MSK);
@@ -421,13 +421,6 @@ static int iwl_mvm_power_send_cmd(struct iwl_mvm *mvm,
 {
 	struct iwl_mac_power_cmd cmd = {};
 
-	if (vif->type != NL80211_IFTYPE_STATION)
-		return 0;
-
-	if (vif->p2p &&
-	    !(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM))
-		return 0;
-
 	iwl_mvm_power_build_cmd(mvm, vif, &cmd);
 	iwl_mvm_power_log(mvm, &cmd);
 #ifdef CONFIG_IWLWIFI_DEBUGFS
@@ -508,86 +501,69 @@ int iwl_mvm_power_uapsd_misbehaving_ap_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-struct iwl_power_constraint {
+struct iwl_power_vifs {
 	struct ieee80211_vif *bf_vif;
 	struct ieee80211_vif *bss_vif;
 	struct ieee80211_vif *p2p_vif;
-	u16 bss_phyctx_id;
-	u16 p2p_phyctx_id;
-	bool pm_disabled;
-	bool ps_disabled;
-	struct iwl_mvm *mvm;
+	struct ieee80211_vif *ap_vif;
+	struct ieee80211_vif *monitor_vif;
+	bool p2p_active;
+	bool bss_active;
+	bool ap_active;
+	bool monitor_active;
 };
 
 static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 				   struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_power_constraint *power_iterator = _data;
-	struct iwl_mvm *mvm = power_iterator->mvm;
+	struct iwl_power_vifs *power_iterator = _data;
 
+	mvmvif->pm_enabled = false;
 	switch (ieee80211_vif_type_p2p(vif)) {
 	case NL80211_IFTYPE_P2P_DEVICE:
 		break;
 
 	case NL80211_IFTYPE_P2P_GO:
 	case NL80211_IFTYPE_AP:
-		/* no BSS power mgmt if we have an active AP */
-		if (mvmvif->ap_ibss_active)
-			power_iterator->pm_disabled = true;
+		/* only a single MAC of the same type */
+		WARN_ON(power_iterator->ap_vif);
+		power_iterator->ap_vif = vif;
+		if (mvmvif->phy_ctxt)
+			if (mvmvif->phy_ctxt->id < MAX_PHYS)
+				power_iterator->ap_active = true;
 		break;
 
 	case NL80211_IFTYPE_MONITOR:
-		/* no BSS power mgmt and no device power save */
-		power_iterator->pm_disabled = true;
-		power_iterator->ps_disabled = true;
+		/* only a single MAC of the same type */
+		WARN_ON(power_iterator->monitor_vif);
+		power_iterator->monitor_vif = vif;
+		if (mvmvif->phy_ctxt)
+			if (mvmvif->phy_ctxt->id < MAX_PHYS)
+				power_iterator->monitor_active = true;
 		break;
 
 	case NL80211_IFTYPE_P2P_CLIENT:
-		if (mvmvif->phy_ctxt)
-			power_iterator->p2p_phyctx_id = mvmvif->phy_ctxt->id;
-
-		/* we should have only one P2P vif */
+		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->p2p_vif);
 		power_iterator->p2p_vif = vif;
-
-		IWL_DEBUG_POWER(mvm, "p2p: p2p_id=%d, bss_id=%d\n",
-				power_iterator->p2p_phyctx_id,
-				power_iterator->bss_phyctx_id);
-		if (!(mvm->fw->ucode_capa.flags &
-		      IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)) {
-			/* no BSS power mgmt if we have a P2P client*/
-			power_iterator->pm_disabled = true;
-		} else if (power_iterator->p2p_phyctx_id < MAX_PHYS &&
-			   power_iterator->bss_phyctx_id < MAX_PHYS &&
-			   power_iterator->p2p_phyctx_id ==
-			   power_iterator->bss_phyctx_id) {
-			power_iterator->pm_disabled = true;
-		}
+		if (mvmvif->phy_ctxt)
+			if (mvmvif->phy_ctxt->id < MAX_PHYS)
+				power_iterator->p2p_active = true;
 		break;
 
 	case NL80211_IFTYPE_STATION:
-		if (mvmvif->phy_ctxt)
-			power_iterator->bss_phyctx_id = mvmvif->phy_ctxt->id;
-
-		/* we should have only one BSS vif */
+		/* only a single MAC of the same type */
 		WARN_ON(power_iterator->bss_vif);
 		power_iterator->bss_vif = vif;
+		if (mvmvif->phy_ctxt)
+			if (mvmvif->phy_ctxt->id < MAX_PHYS)
+				power_iterator->bss_active = true;
 
 		if (mvmvif->bf_data.bf_enabled &&
 		    !WARN_ON(power_iterator->bf_vif))
 			power_iterator->bf_vif = vif;
 
-		IWL_DEBUG_POWER(mvm, "bss: p2p_id=%d, bss_id=%d\n",
-				power_iterator->p2p_phyctx_id,
-				power_iterator->bss_phyctx_id);
-		if (mvm->fw->ucode_capa.flags &
-		    IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM &&
-			(power_iterator->p2p_phyctx_id < MAX_PHYS &&
-			 power_iterator->bss_phyctx_id < MAX_PHYS &&
-			 power_iterator->p2p_phyctx_id ==
-			 power_iterator->bss_phyctx_id))
-			power_iterator->pm_disabled = true;
 		break;
 
 	default:
@@ -596,29 +572,75 @@ static void iwl_mvm_power_iterator(void *_data, u8 *mac,
 }
 
 static void
-iwl_mvm_power_get_global_constraint(struct iwl_mvm *mvm,
-				    struct iwl_power_constraint *constraint)
+iwl_mvm_power_set_pm(struct iwl_mvm *mvm,
+				    struct iwl_power_vifs *vifs)
 {
-	lockdep_assert_held(&mvm->mutex);
+	struct iwl_mvm_vif *bss_mvmvif = NULL;
+	struct iwl_mvm_vif *p2p_mvmvif = NULL;
+	struct iwl_mvm_vif *ap_mvmvif = NULL;
+	bool client_same_channel = false;
+	bool ap_same_channel = false;
 
-	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM) {
-		constraint->pm_disabled = true;
-		constraint->ps_disabled = true;
-	}
+	lockdep_assert_held(&mvm->mutex);
 
+	/* get vifs info + set pm_enable to false */
 	ieee80211_iterate_active_interfaces_atomic(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
-					    iwl_mvm_power_iterator, constraint);
+					    iwl_mvm_power_iterator, vifs);
+
+	if (vifs->bss_vif)
+		bss_mvmvif = iwl_mvm_vif_from_mac80211(vifs->bss_vif);
+
+	if (vifs->p2p_vif)
+		p2p_mvmvif = iwl_mvm_vif_from_mac80211(vifs->p2p_vif);
+
+	if (vifs->ap_vif)
+		ap_mvmvif = iwl_mvm_vif_from_mac80211(vifs->ap_vif);
+
+	/* enable PM on bss if bss stand alone */
+	if (vifs->bss_active && !vifs->p2p_active && !vifs->ap_active) {
+		bss_mvmvif->pm_enabled = true;
+		return;
+	}
+
+	/* enable PM on p2p if p2p stand alone */
+	if (vifs->p2p_active && !vifs->bss_active && !vifs->ap_active) {
+		if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM)
+			p2p_mvmvif->pm_enabled = true;
+		return;
+	}
+
+	if (vifs->bss_active && vifs->p2p_active)
+		client_same_channel = (bss_mvmvif->phy_ctxt->id ==
+				       p2p_mvmvif->phy_ctxt->id);
+	if (vifs->bss_active && vifs->ap_active)
+		ap_same_channel = (bss_mvmvif->phy_ctxt->id ==
+				   ap_mvmvif->phy_ctxt->id);
+
+	/* bss is not stand alone: enable PM if alone on its channel */
+	if (vifs->bss_active && !(client_same_channel || ap_same_channel) &&
+	    (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_DCM)) {
+			bss_mvmvif->pm_enabled = true;
+			return;
+	}
+
+	/*
+	 * There is only one channel in the system and there are only
+	 * bss and p2p clients that share it
+	 */
+	if (client_same_channel && !vifs->ap_active &&
+	    (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BSS_P2P_PS_SCM)) {
+		/* share same channel*/
+		bss_mvmvif->pm_enabled = true;
+		if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_P2P_PM)
+			p2p_mvmvif->pm_enabled = true;
+	}
 }
 
 int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 {
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_power_constraint constraint = {
-		    .p2p_phyctx_id = MAX_PHYS,
-		    .bss_phyctx_id = MAX_PHYS,
-		    .mvm = mvm,
-	};
+	struct iwl_mvm_vif *mvmvif;
+	struct iwl_power_vifs vifs = {};
 	bool ba_enable;
 	int ret;
 
@@ -627,39 +649,44 @@ int iwl_mvm_power_update_mac(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_PM_CMD_SUPPORT))
 		return 0;
 
-	iwl_mvm_power_get_global_constraint(mvm, &constraint);
-	mvm->ps_disabled = constraint.ps_disabled;
-	mvm->pm_disabled = constraint.pm_disabled;
+	iwl_mvm_power_set_pm(mvm, &vifs);
 
+	/* disable PS if CAM */
+	if (iwlmvm_mod_params.power_scheme == IWL_POWER_SCHEME_CAM) {
+		mvm->ps_disabled = true;
+	} else {
 	/* don't update device power state unless we add / remove monitor */
-	if (vif->type == NL80211_IFTYPE_MONITOR) {
-		ret = iwl_mvm_power_update_device(mvm);
-		if (ret)
-			return ret;
+		if (vifs.monitor_vif) {
+			if (vifs.monitor_active)
+				mvm->ps_disabled = true;
+			ret = iwl_mvm_power_update_device(mvm);
+			if (ret)
+				return ret;
+		}
 	}
 
-	if (constraint.bss_vif) {
-		ret = iwl_mvm_power_send_cmd(mvm, constraint.bss_vif);
+	if (vifs.bss_vif) {
+		ret = iwl_mvm_power_send_cmd(mvm, vifs.bss_vif);
 		if (ret)
 			return ret;
 	}
 
-	if (constraint.p2p_vif) {
-		ret = iwl_mvm_power_send_cmd(mvm, constraint.p2p_vif);
+	if (vifs.p2p_vif) {
+		ret = iwl_mvm_power_send_cmd(mvm, vifs.p2p_vif);
 		if (ret)
 			return ret;
 	}
 
-	if (!constraint.bf_vif)
+	if (!vifs.bf_vif)
 		return 0;
 
-	vif = constraint.bf_vif;
+	vif = vifs.bf_vif;
 	mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
-	ba_enable = !(constraint.pm_disabled || constraint.ps_disabled ||
+	ba_enable = !(!mvmvif->pm_enabled || mvm->ps_disabled ||
 		      !vif->bss_conf.ps || iwl_mvm_vif_low_latency(mvmvif));
 
-	return iwl_mvm_update_beacon_abort(mvm, constraint.bf_vif, ba_enable);
+	return iwl_mvm_update_beacon_abort(mvm, vifs.bf_vif, ba_enable);
 }
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
-- 
1.8.3.2

