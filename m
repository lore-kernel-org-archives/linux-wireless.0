Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:49841 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932296AbaKXOgb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:36:31 -0500
Received: by mail-wi0-f174.google.com with SMTP id h11so5899164wiw.1
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:36:30 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>
Subject: [PATCH 57/75] iwlwifi: mvm: add CSA absent time event for clients
Date: Mon, 24 Nov 2014 16:34:33 +0200
Message-Id: <1416839691-28533-57-git-send-email-egrumbach@gmail.com> (sfid-20141124_153849_082739_61F8E402)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

Add an absent time event when pre_channel_switch is called and use the
time event started indication to set the disable_tx bit instead of
doing it in unassign_vif().  This is done so that the firmware queues
are stopped before the actual switch takes place to avoid losing
packets while the AP/GO is performing its actual switch.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   | 19 +++++++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h        | 27 ++++++++++++++++---
 drivers/net/wireless/iwlwifi/mvm/sta.c        | 15 +++++++++++
 drivers/net/wireless/iwlwifi/mvm/sta.h        |  1 +
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 37 +++++++++++++++++++++------
 5 files changed, 81 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index fdeaab3..ac1cef6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2891,7 +2891,6 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct ieee80211_vif *disabled_vif = NULL;
-	struct iwl_mvm_sta *mvmsta;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -2925,12 +2924,6 @@ static void __iwl_mvm_unassign_vif_chanctx(struct iwl_mvm *mvm,
 
 		disabled_vif = vif;
 
-		mvmsta = iwl_mvm_sta_from_staid_protected(mvm,
-							  mvmvif->ap_sta_id);
-
-		if (!WARN_ON(!mvmsta))
-			iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, true);
-
 		iwl_mvm_mac_ctxt_changed(mvm, vif, true, NULL);
 		break;
 	default:
@@ -3167,6 +3160,7 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
 	struct ieee80211_vif *csa_vif;
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	u32 apply_time;
 	int ret;
 
 	mutex_lock(&mvm->mutex);
@@ -3194,6 +3188,17 @@ static int iwl_mvm_pre_channel_switch(struct ieee80211_hw *hw,
 		}
 
 		break;
+	case NL80211_IFTYPE_STATION:
+		apply_time = chsw->timestamp +
+			(vif->bss_conf.beacon_int * chsw->count * 1024);
+
+		if (chsw->block_tx)
+			iwl_mvm_csa_client_absent(mvm, vif);
+
+		iwl_mvm_schedule_csa_period(mvm, vif,
+					    IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT,
+					    apply_time);
+		break;
 	default:
 		break;
 	}
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 2c54c52..2816c6b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -87,11 +87,12 @@
 /* A TimeUnit is 1024 microsecond */
 #define MSEC_TO_TU(_msec)	(_msec*1000/1024)
 
-/* This value represents the number of TUs before CSA "beacon 0" TBTT
- * when the CSA time-event needs to be scheduled to start.  It must be
- * big enough to ensure that we switch in time.
+/* These values represent the number of TUs before CSA "beacon 0" TBTT
+ * when the CSA time-event needs to be scheduled to start.  They must
+ * be big enough to ensure that we switch in time.
  */
 #define IWL_MVM_CHANNEL_SWITCH_TIME_GO		40
+#define IWL_MVM_CHANNEL_SWITCH_TIME_CLIENT	110
 
 /*
  * This value (in TUs) is used to fine tune the CSA NoA end time which should
@@ -797,6 +798,26 @@ static inline bool iwl_mvm_is_radio_killed(struct iwl_mvm *mvm)
 	       test_bit(IWL_MVM_STATUS_HW_CTKILL, &mvm->status);
 }
 
+/* Must be called with rcu_read_lock() held and it can only be
+ * released when mvmsta is not needed anymore.
+ */
+static inline struct iwl_mvm_sta *
+iwl_mvm_sta_from_staid_rcu(struct iwl_mvm *mvm, u8 sta_id)
+{
+	struct ieee80211_sta *sta;
+
+	if (sta_id >= ARRAY_SIZE(mvm->fw_id_to_mac_id))
+		return NULL;
+
+	sta = rcu_dereference(mvm->fw_id_to_mac_id[sta_id]);
+
+	/* This can happen if the station has been removed right now */
+	if (IS_ERR_OR_NULL(sta))
+		return NULL;
+
+	return iwl_mvm_sta_from_mac80211(sta);
+}
+
 static inline struct iwl_mvm_sta *
 iwl_mvm_sta_from_staid_protected(struct iwl_mvm *mvm, u8 sta_id)
 {
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.c b/drivers/net/wireless/iwlwifi/mvm/sta.c
index a38f1f1..d86fe43 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.c
@@ -1732,3 +1732,18 @@ void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 		iwl_mvm_sta_modify_disable_tx_ap(mvm, sta, disable);
 	}
 }
+
+void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_sta *mvmsta;
+
+	rcu_read_lock();
+
+	mvmsta = iwl_mvm_sta_from_staid_rcu(mvm, mvmvif->ap_sta_id);
+
+	if (!WARN_ON(!mvmsta))
+		iwl_mvm_sta_modify_disable_tx(mvm, mvmsta, true);
+
+	rcu_read_unlock();
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/sta.h b/drivers/net/wireless/iwlwifi/mvm/sta.h
index 2c869bc..d8f48975 100644
--- a/drivers/net/wireless/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/sta.h
@@ -422,5 +422,6 @@ void iwl_mvm_sta_modify_disable_tx_ap(struct iwl_mvm *mvm,
 void iwl_mvm_modify_all_sta_disable_tx(struct iwl_mvm *mvm,
 				       struct iwl_mvm_vif *mvmvif,
 				       bool disable);
+void iwl_mvm_csa_client_absent(struct iwl_mvm *mvm, struct ieee80211_vif *vif);
 
 #endif /* __sta_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 8cf246b..1a537be 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -191,6 +191,33 @@ static bool iwl_mvm_te_check_disconnect(struct iwl_mvm *mvm,
 	return true;
 }
 
+static void
+iwl_mvm_te_handle_notify_csa(struct iwl_mvm *mvm,
+			     struct iwl_mvm_time_event_data *te_data,
+			     struct iwl_time_event_notif *notif)
+{
+	if (!le32_to_cpu(notif->status)) {
+		IWL_DEBUG_TE(mvm, "CSA time event failed to start\n");
+		return;
+	}
+
+	switch (te_data->vif->type) {
+	case NL80211_IFTYPE_AP:
+		iwl_mvm_csa_noa_start(mvm);
+		break;
+	case NL80211_IFTYPE_STATION:
+		iwl_mvm_csa_client_absent(mvm, te_data->vif);
+		break;
+	default:
+		/* should never happen */
+		WARN_ON_ONCE(1);
+		break;
+	}
+
+	/* we don't need it anymore */
+	iwl_mvm_te_clear_data(mvm, te_data);
+}
+
 /*
  * Handles a FW notification for an event that is known to the driver.
  *
@@ -252,14 +279,8 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			set_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
 			iwl_mvm_ref(mvm, IWL_MVM_REF_ROC);
 			ieee80211_ready_on_channel(mvm->hw);
-		} else if (te_data->vif->type == NL80211_IFTYPE_AP) {
-			if (le32_to_cpu(notif->status))
-				iwl_mvm_csa_noa_start(mvm);
-			else
-				IWL_DEBUG_TE(mvm, "CSA NOA failed to start\n");
-
-			/* we don't need it anymore */
-			iwl_mvm_te_clear_data(mvm, te_data);
+		} else if (te_data->id == TE_CHANNEL_SWITCH_PERIOD) {
+			iwl_mvm_te_handle_notify_csa(mvm, te_data, notif);
 		}
 	} else {
 		IWL_WARN(mvm, "Got TE with unknown action\n");
-- 
1.9.1

