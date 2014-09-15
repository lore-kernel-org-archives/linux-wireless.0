Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:63442 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaIOFNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:13:47 -0400
Received: by mail-wi0-f172.google.com with SMTP id e4so3473042wiv.5
        for <linux-wireless@vger.kernel.org>; Sun, 14 Sep 2014 22:13:45 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 28/28] iwlwifi: mvm: align CSA GO NOA time event naming with the firmware
Date: Mon, 15 Sep 2014 08:13:00 +0300
Message-Id: <1410757980-2138-28-git-send-email-egrumbach@gmail.com> (sfid-20140915_073113_971682_B85BEFA1)
In-Reply-To: <5416742C.3070804@gmail.com>
References: <5416742C.3070804@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

The time event used for CSA GO will also be used by CSA client.
Rename the symbols to something more generic and aligned with the
firmware code.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c   | 10 +++++-----
 drivers/net/wireless/iwlwifi/mvm/mvm.h        |  8 ++++----
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 10 +++++-----
 drivers/net/wireless/iwlwifi/mvm/time-event.h |  8 ++++----
 5 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index fbcc036..a2c6628 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -554,7 +554,7 @@ enum iwl_time_event_type {
 	TE_WIDI_TX_SYNC,
 
 	/* Channel Switch NoA */
-	TE_P2P_GO_CSA_NOA,
+	TE_CHANNEL_SWITCH_PERIOD,
 
 	TE_MAX
 }; /* MAC_EVENT_TYPE_API_E_VER_1 */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
index 158aed5..8342671 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac-ctxt.c
@@ -1234,13 +1234,13 @@ static void iwl_mvm_csa_count_down(struct iwl_mvm *mvm,
 		    !iwl_mvm_te_scheduled(&mvmvif->time_event_data) && gp2) {
 			u32 rel_time = (c + 1) *
 				       csa_vif->bss_conf.beacon_int -
-				       IWL_MVM_CHANNEL_SWITCH_TIME;
+				       IWL_MVM_CHANNEL_SWITCH_TIME_GO;
 			u32 apply_time = gp2 + rel_time * 1024;
 
-			iwl_mvm_schedule_csa_noa(mvm, csa_vif,
-						 IWL_MVM_CHANNEL_SWITCH_TIME -
-						 IWL_MVM_CHANNEL_SWITCH_MARGIN,
-						 apply_time);
+			iwl_mvm_schedule_csa_period(mvm, csa_vif,
+					 IWL_MVM_CHANNEL_SWITCH_TIME_GO -
+					 IWL_MVM_CHANNEL_SWITCH_MARGIN,
+					 apply_time);
 		}
 	} else if (!iwl_mvm_te_scheduled(&mvmvif->time_event_data)) {
 		/* we don't have CSA NoA scheduled yet, switch now */
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index efdafa1..5529958 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -87,11 +87,11 @@
 /* A TimeUnit is 1024 microsecond */
 #define MSEC_TO_TU(_msec)	(_msec*1000/1024)
 
-/*
- * The CSA NoA is scheduled IWL_MVM_CHANNEL_SWITCH_TIME TUs before "beacon 0"
- * TBTT. This value should be big enough to ensure that we switch in time.
+/* This value represents the number of TUs before CSA "beacon 0" TBTT
+ * when the CSA time-event needs to be scheduled to start.  It must be
+ * big enough to ensure that we switch in time.
  */
-#define IWL_MVM_CHANNEL_SWITCH_TIME 40
+#define IWL_MVM_CHANNEL_SWITCH_TIME_GO		40
 
 /*
  * This value (in TUs) is used to fine tune the CSA NoA end time which should
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 447d3b1..b7f9e61 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -700,9 +700,9 @@ void iwl_mvm_stop_p2p_roc(struct iwl_mvm *mvm)
 	iwl_mvm_roc_finished(mvm);
 }
 
-int iwl_mvm_schedule_csa_noa(struct iwl_mvm *mvm,
-			      struct ieee80211_vif *vif,
-			      u32 duration, u32 apply_time)
+int iwl_mvm_schedule_csa_period(struct iwl_mvm *mvm,
+				struct ieee80211_vif *vif,
+				u32 duration, u32 apply_time)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
@@ -711,14 +711,14 @@ int iwl_mvm_schedule_csa_noa(struct iwl_mvm *mvm,
 	lockdep_assert_held(&mvm->mutex);
 
 	if (te_data->running) {
-		IWL_DEBUG_TE(mvm, "CS NOA is already scheduled\n");
+		IWL_DEBUG_TE(mvm, "CS period is already scheduled\n");
 		return -EBUSY;
 	}
 
 	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_ADD);
 	time_cmd.id_and_color =
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
-	time_cmd.id = cpu_to_le32(TE_P2P_GO_CSA_NOA);
+	time_cmd.id = cpu_to_le32(TE_CHANNEL_SWITCH_PERIOD);
 	time_cmd.apply_time = cpu_to_le32(apply_time);
 	time_cmd.max_frags = TE_V2_FRAG_NONE;
 	time_cmd.duration = cpu_to_le32(duration);
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index bee3b24..b350e47 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -219,7 +219,7 @@ void iwl_mvm_te_clear_data(struct iwl_mvm *mvm,
 void iwl_mvm_roc_done_wk(struct work_struct *wk);
 
 /**
- * iwl_mvm_schedule_csa_noa - request NoA for channel switch
+ * iwl_mvm_schedule_csa_period - request channel switch absence period
  * @mvm: the mvm component
  * @vif: the virtual interface for which the channel switch is issued
  * @duration: the duration of the NoA in TU.
@@ -228,9 +228,9 @@ void iwl_mvm_roc_done_wk(struct work_struct *wk);
  * This function is used to schedule NoA time event and is used to perform
  * the channel switch flow.
  */
-int iwl_mvm_schedule_csa_noa(struct iwl_mvm *mvm,
-			     struct ieee80211_vif *vif,
-			     u32 duration, u32 apply_time);
+int iwl_mvm_schedule_csa_period(struct iwl_mvm *mvm,
+				struct ieee80211_vif *vif,
+				u32 duration, u32 apply_time);
 
 /**
  * iwl_mvm_te_scheduled - check if the fw received the TE cmd
-- 
1.9.1

