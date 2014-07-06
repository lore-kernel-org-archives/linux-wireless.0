Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:41647 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622AbaGFJhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Jul 2014 05:37:14 -0400
Received: by mail-we0-f172.google.com with SMTP id u57so3074650wes.3
        for <linux-wireless@vger.kernel.org>; Sun, 06 Jul 2014 02:37:13 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 33/40] iwlwifi: mvm: Reflect GO channel switch in NoA
Date: Sun,  6 Jul 2014 12:36:09 +0300
Message-Id: <1404639376-3792-33-git-send-email-egrumbach@gmail.com> (sfid-20140706_115954_142628_43C34733)
In-Reply-To: <53B917DC.5050902@gmail.com>
References: <53B917DC.5050902@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

According to the spec, GO/AP should perform the channel switch just
before "beacon 0". However, since the exact timing isn't defined,
it may result in a sudden GO disappearance from the channel.
Prevent potential packet loss when performing the CS by scheduling
NoA time event and executing the channel switch flow when a notification
from fw is received.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |  3 ++
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   | 41 +++++++++++----
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |  5 +-
 drivers/net/wireless/iwlwifi/mvm/mvm.h        | 12 +++++
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 73 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/mvm/time-event.h | 29 +++++++++++
 6 files changed, 153 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 6c479de..99329ed 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -538,6 +538,9 @@ enum iwl_time_event_type {
 	/* WiDi Sync Events */
 	TE_WIDI_TX_SYNC,
 
+	/* Channel Switch NoA */
+	TE_P2P_GO_CSA_NOA,
+
 	TE_MAX
 }; /* MAC_EVENT_TYPE_API_E_VER_1 */
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 19bd696..a176d00 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -67,6 +67,7 @@
 #include "iwl-prph.h"
 #include "fw-api.h"
 #include "mvm.h"
+#include "time-event.h"
 
 const u8 iwl_mvm_ac_to_tx_fifo[] = {
 	IWL_MVM_TX_FIFO_VO,
@@ -1200,6 +1201,35 @@ int iwl_mvm_mac_ctxt_remove(struct iwl_mvm *mvm, struct ieee80211_vif *vif)
 	return 0;
 }
 
+static void iwl_mvm_csa_count_down(struct iwl_mvm *mvm,
+				   struct ieee80211_vif *csa_vif, u32 gp2)
+{
+	struct iwl_mvm_vif *mvmvif =
+			iwl_mvm_vif_from_mac80211(csa_vif);
+
+	if (!ieee80211_csa_is_complete(csa_vif)) {
+		int c = ieee80211_csa_update_counter(csa_vif);
+
+		iwl_mvm_mac_ctxt_beacon_changed(mvm, csa_vif);
+		if (csa_vif->p2p &&
+		    !iwl_mvm_te_scheduled(&mvmvif->time_event_data) && gp2) {
+			u32 rel_time = (c + 1) *
+				       csa_vif->bss_conf.beacon_int -
+				       IWL_MVM_CHANNEL_SWITCH_TIME;
+			u32 apply_time = gp2 + rel_time * 1024;
+
+			iwl_mvm_schedule_csa_noa(mvm, csa_vif,
+						 IWL_MVM_CHANNEL_SWITCH_TIME -
+						 IWL_MVM_CHANNEL_SWITCH_MARGIN,
+						 apply_time);
+		}
+	} else if (!iwl_mvm_te_scheduled(&mvmvif->time_event_data)) {
+		/* we don't have CSA NoA scheduled yet, switch now */
+		ieee80211_csa_finish(csa_vif);
+		RCU_INIT_POINTER(mvm->csa_vif, NULL);
+	}
+}
+
 int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 			    struct iwl_rx_cmd_buffer *rxb,
 			    struct iwl_device_cmd *cmd)
@@ -1234,15 +1264,8 @@ int iwl_mvm_rx_beacon_notif(struct iwl_mvm *mvm,
 
 	csa_vif = rcu_dereference_protected(mvm->csa_vif,
 					    lockdep_is_held(&mvm->mutex));
-	if (unlikely(csa_vif && csa_vif->csa_active)) {
-		if (!ieee80211_csa_is_complete(csa_vif)) {
-			ieee80211_csa_update_counter(csa_vif);
-			iwl_mvm_mac_ctxt_beacon_changed(mvm, csa_vif);
-		} else {
-			ieee80211_csa_finish(csa_vif);
-			RCU_INIT_POINTER(mvm->csa_vif, NULL);
-		}
-	}
+	if (unlikely(csa_vif && csa_vif->csa_active))
+		iwl_mvm_csa_count_down(mvm, csa_vif, mvm->ap_last_beacon_gp2);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 984a1e7..4a0350f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1608,8 +1608,11 @@ static void iwl_mvm_stop_ap_ibss(struct ieee80211_hw *hw,
 	mutex_lock(&mvm->mutex);
 
 	/* Handle AP stop while in CSA */
-	if (rcu_access_pointer(mvm->csa_vif) == vif)
+	if (rcu_access_pointer(mvm->csa_vif) == vif) {
+		iwl_mvm_remove_time_event(mvm, mvmvif,
+					  &mvmvif->time_event_data);
 		RCU_INIT_POINTER(mvm->csa_vif, NULL);
+	}
 
 	mvmvif->ap_ibss_active = false;
 	mvm->ap_last_beacon_gp2 = 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 5bb42af..db496c5 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -83,6 +83,18 @@
 #define IWL_RSSI_OFFSET 50
 #define IWL_MVM_MISSED_BEACONS_THRESHOLD 8
 
+/*
+ * The CSA NoA is scheduled IWL_MVM_CHANNEL_SWITCH_TIME TUs before "beacon 0"
+ * TBTT. This value should be big enough to ensure that we switch in time.
+ */
+#define IWL_MVM_CHANNEL_SWITCH_TIME 40
+
+/*
+ * This value (in TUs) is used to fine tune the CSA NoA end time which should
+ * be just before "beacon 0" TBTT.
+ */
+#define IWL_MVM_CHANNEL_SWITCH_MARGIN 4
+
 enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_BK = 0,
 	IWL_MVM_TX_FIFO_BE,
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 80100f6..ae52613 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -138,6 +138,41 @@ static void iwl_mvm_roc_finished(struct iwl_mvm *mvm)
 	schedule_work(&mvm->roc_done_wk);
 }
 
+static void iwl_mvm_csa_noa_start(struct iwl_mvm *mvm)
+{
+	struct ieee80211_vif *csa_vif;
+
+	rcu_read_lock();
+
+	csa_vif = rcu_dereference(mvm->csa_vif);
+	if (!csa_vif || !csa_vif->csa_active)
+		goto out_unlock;
+
+	IWL_DEBUG_TE(mvm, "CSA NOA started\n");
+
+	/*
+	 * CSA NoA is started but we still have beacons to
+	 * transmit on the current channel.
+	 * So we just do nothing here and the switch
+	 * will be performed on the last TBTT.
+	 */
+	if (!ieee80211_csa_is_complete(csa_vif)) {
+		IWL_WARN(mvm, "CSA NOA started too early\n");
+		goto out_unlock;
+	}
+
+	ieee80211_csa_finish(csa_vif);
+
+	rcu_read_unlock();
+
+	RCU_INIT_POINTER(mvm->csa_vif, NULL);
+
+	return;
+
+out_unlock:
+	rcu_read_unlock();
+}
+
 static bool iwl_mvm_te_check_disconnect(struct iwl_mvm *mvm,
 					struct ieee80211_vif *vif,
 					const char *errmsg)
@@ -213,6 +248,14 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 			set_bit(IWL_MVM_STATUS_ROC_RUNNING, &mvm->status);
 			iwl_mvm_ref(mvm, IWL_MVM_REF_ROC);
 			ieee80211_ready_on_channel(mvm->hw);
+		} else if (te_data->vif->type == NL80211_IFTYPE_AP) {
+			if (le32_to_cpu(notif->status))
+				iwl_mvm_csa_noa_start(mvm);
+			else
+				IWL_DEBUG_TE(mvm, "CSA NOA failed to start\n");
+
+			/* we don't need it anymore */
+			iwl_mvm_te_clear_data(mvm, te_data);
 		}
 	} else {
 		IWL_WARN(mvm, "Got TE with unknown action\n");
@@ -538,3 +581,33 @@ void iwl_mvm_stop_p2p_roc(struct iwl_mvm *mvm)
 
 	iwl_mvm_roc_finished(mvm);
 }
+
+int iwl_mvm_schedule_csa_noa(struct iwl_mvm *mvm,
+			      struct ieee80211_vif *vif,
+			      u32 duration, u32 apply_time)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
+	struct iwl_time_event_cmd time_cmd = {};
+
+	lockdep_assert_held(&mvm->mutex);
+
+	if (te_data->running) {
+		IWL_DEBUG_TE(mvm, "CS NOA is already scheduled\n");
+		return -EBUSY;
+	}
+
+	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_ADD);
+	time_cmd.id_and_color =
+		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
+	time_cmd.id = cpu_to_le32(TE_P2P_GO_CSA_NOA);
+	time_cmd.apply_time = cpu_to_le32(apply_time);
+	time_cmd.max_frags = TE_V2_FRAG_NONE;
+	time_cmd.duration = cpu_to_le32(duration);
+	time_cmd.repeat = 1;
+	time_cmd.interval = cpu_to_le32(1);
+	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
+				      TE_V2_ABSENCE);
+
+	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
+}
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index 4a61c8c..2f48a90 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -214,4 +214,33 @@ void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 
 void iwl_mvm_roc_done_wk(struct work_struct *wk);
 
+/**
+ * iwl_mvm_schedule_csa_noa - request NoA for channel switch
+ * @mvm: the mvm component
+ * @vif: the virtual interface for which the channel switch is issued
+ * @duration: the duration of the NoA in TU.
+ * @apply_time: NoA start time in GP2.
+ *
+ * This function is used to schedule NoA time event and is used to perform
+ * the channel switch flow.
+ */
+int iwl_mvm_schedule_csa_noa(struct iwl_mvm *mvm,
+			     struct ieee80211_vif *vif,
+			     u32 duration, u32 apply_time);
+
+/**
+ * iwl_mvm_te_scheduled - check if the fw received the TE cmd
+ * @te_data: the time event data that corresponds to that time event
+ *
+ * This function returns true iff this TE is added to the fw.
+ */
+static inline bool
+iwl_mvm_te_scheduled(struct iwl_mvm_time_event_data *te_data)
+{
+	if (!te_data)
+		return false;
+
+	return !!te_data->uid;
+}
+
 #endif /* __time_event_h__ */
-- 
1.8.3.2

