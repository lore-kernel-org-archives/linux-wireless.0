Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44374 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756498AbaEILMN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 May 2014 07:12:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, michal.kazior@tieto.com,
	andrei.otcheretianski@intel.com
Date: Fri,  9 May 2014 14:11:48 +0300
Message-Id: <1399633911-12788-6-git-send-email-luca@coelho.fi> (sfid-20140509_131222_716558_954B23C0)
In-Reply-To: <1399633911-12788-1-git-send-email-luca@coelho.fi>
References: <1399633911-12788-1-git-send-email-luca@coelho.fi>
Subject: [PATCH 5/8] iwlwifi: mvm: Add AP/GO channel switch support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Publish WIPHY_FLAG_HAS_CHANNEL_SWITCH if the fw supports
newly introduced IWL_UCODE_TLV_API_CSA_FLOW.
When CSA starts, save the switching vif inside mvm and during the CSA period
configure fw with a new beacon after each beacon transmission in order to
update the csa counters.
Also, handle correctly the CSA unbind-bind flow which is triggered by mac80211
when the actual channel switch happens.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h       |  2 ++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c | 12 ++++++++
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 44 ++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      |  2 ++
 drivers/net/wireless/iwlwifi/mvm/ops.c      |  2 +-
 5 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index d14f193..946c13d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -128,9 +128,11 @@ enum iwl_ucode_tlv_flag {
 /**
  * enum iwl_ucode_tlv_api - ucode api
  * @IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID: wowlan config includes tid field.
+ * @IWL_UCODE_TLV_API_CSA_FLOW: ucode can do unbind-bind flow for CSA.
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WOWLAN_CONFIG_TID	= BIT(0),
+	IWL_UCODE_TLV_API_CSA_FLOW		= BIT(4),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 9ccec10..25901ad 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1240,11 +1240,23 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 	u32 rate __maybe_unused =
 		le32_to_cpu(beacon->beacon_notify_hdr.initial_rate);
 
+	lockdep_assert_held(&mvm->mutex);
+
 	IWL_DEBUG_RX(mvm, "beacon status %#x retries:%d tsf:0x%16llX rate:%d\n",
 		     status & TX_STATUS_MSK,
 		     beacon->beacon_notify_hdr.failure_frame,
 		     le64_to_cpu(beacon->tsf),
 		     rate);
+
+	if (unlikely(mvm->csa_vif && mvm->csa_vif->csa_active)) {
+		if (!ieee80211_csa_is_complete(mvm->csa_vif)) {
+			iwl_mvm_mac_ctxt_beacon_changed(mvm, mvm->csa_vif);
+		} else {
+			ieee80211_csa_finish(mvm->csa_vif);
+			mvm->csa_vif = NULL;
+		}
+	}
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 4dd9ff4..af1d9da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -322,6 +322,9 @@ int iwl_mvm_mac_setup_register(struct iwl_mvm *mvm)
 	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_GO_UAPSD)
 		hw->wiphy->flags |= WIPHY_FLAG_AP_UAPSD;
 
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_CSA_FLOW)
+		hw->wiphy->flags |= WIPHY_FLAG_HAS_CHANNEL_SWITCH;
+
 	hw->wiphy->iface_combinations = iwl_mvm_iface_combinations;
 	hw->wiphy->n_iface_combinations =
 		ARRAY_SIZE(iwl_mvm_iface_combinations);
@@ -2178,6 +2181,11 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 
 	switch (vif->type) {
 	case NL80211_IFTYPE_AP:
+		/* Unless it's a CSA flow we have nothing to do here */
+		if (vif->csa_active) {
+			mvmvif->ap_ibss_active = true;
+			break;
+		}
 	case NL80211_IFTYPE_ADHOC:
 		/*
 		 * The AP binding flow is handled as part of the start_ap flow
@@ -2214,6 +2222,12 @@ static int iwl_mvm_assign_vif_chanctx(struct ieee80211_hw *hw,
 			goto out_remove_binding;
 	}
 
+	/* Handle binding during CSA */
+	if (vif->type == NL80211_IFTYPE_AP) {
+		iwl_mvm_update_quotas(mvm, vif);
+		iwl_mvm_mac_ctxt_changed(mvm, vif);
+	}
+
 	goto out_unlock;
 
  out_remove_binding:
@@ -2238,13 +2252,20 @@ static void iwl_mvm_unassign_vif_chanctx(struct ieee80211_hw *hw,
 	iwl_mvm_remove_time_event(mvm, mvmvif, &mvmvif->time_event_data);
 
 	switch (vif->type) {
-	case NL80211_IFTYPE_AP:
 	case NL80211_IFTYPE_ADHOC:
 		goto out_unlock;
 	case NL80211_IFTYPE_MONITOR:
 		mvmvif->monitor_active = false;
 		iwl_mvm_update_quotas(mvm, NULL);
 		break;
+	case NL80211_IFTYPE_AP:
+		/* This part is triggered only during CSA */
+		if (!vif->csa_active || !mvmvif->ap_ibss_active)
+			goto out_unlock;
+
+		mvmvif->ap_ibss_active = false;
+		iwl_mvm_update_quotas(mvm, NULL);
+		/*TODO: bt_coex notification here? */
 	default:
 		break;
 	}
@@ -2340,6 +2361,25 @@ static int iwl_mvm_mac_testmode_cmd(struct ieee80211_hw *hw,
 }
 #endif
 
+static void iwl_mvm_channel_switch_beacon(struct ieee80211_hw *hw,
+					  struct ieee80211_vif *vif,
+					  struct cfg80211_chan_def *chandef)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+
+	mutex_lock(&mvm->mutex);
+	if (WARN(mvm->csa_vif && mvm->csa_vif->csa_active,
+		 "Another CSA is already in progress"))
+		goto out_unlock;
+
+	IWL_DEBUG_MAC80211(mvm, "CSA started to freq %d\n",
+			   chandef->center_freq1);
+	mvm->csa_vif = vif;
+
+out_unlock:
+	mutex_unlock(&mvm->mutex);
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
@@ -2382,6 +2422,8 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 
 	.set_tim = iwl_mvm_set_tim,
 
+	.channel_switch_beacon = iwl_mvm_channel_switch_beacon,
+
 	CFG80211_TESTMODE_CMD(iwl_mvm_mac_testmode_cmd)
 
 #ifdef CONFIG_PM_SLEEP
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index d564233..87f2105 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -631,6 +631,8 @@ struct iwl_mvm {
 	bool ps_disabled;
 	/* Indicate if device power management is allowed */
 	bool pm_disabled;
+
+	struct ieee80211_vif *csa_vif;
 };
 
 /* Extract MVM priv from op_mode and _hw */
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 9545d7f..729a857 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -220,7 +220,7 @@ static const struct iwl_rx_handlers iwl_mvm_rx_handlers[] = {
 	RX_HANDLER(BA_NOTIF, iwl_mvm_rx_ba_notif, false),
 
 	RX_HANDLER(BT_PROFILE_NOTIFICATION, iwl_mvm_rx_bt_coex_notif, true),
-	RX_HANDLER(BEACON_NOTIFICATION, iwl_mvm_rx_beacon_notif, false),
+	RX_HANDLER(BEACON_NOTIFICATION, iwl_mvm_rx_beacon_notif, true),
 	RX_HANDLER(STATISTICS_NOTIFICATION, iwl_mvm_rx_statistics, true),
 	RX_HANDLER(ANTENNA_COUPLING_NOTIFICATION,
 		   iwl_mvm_rx_ant_coupling_notif, true),
-- 
2.0.0.rc0

