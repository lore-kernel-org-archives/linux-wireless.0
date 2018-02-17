Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:59262 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751032AbeBQIeE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Feb 2018 03:34:04 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat, 17 Feb 2018 10:33:48 +0200
Message-Id: <20180217083354.31160-4-luca@coelho.fi> (sfid-20180217_093424_945491_E8F9F196)
In-Reply-To: <20180217083354.31160-1-luca@coelho.fi>
References: <20180217083354.31160-1-luca@coelho.fi>
Subject: [PATCH 3/9] iwlwifi: mvm: Fix channel switch for count 0 and 1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

It was assumed that apply_time==0 implies immediate scheduling, which is
wrong. Instead, the fw expects the START_IMMEDIATELY flag to be set.
Otherwise, this resulted in 0x3063 assert.
Fix that.
While at it rename the T2_V2_START_IMMEDIATELY to
TE_V2_START_IMMEDIATELY.

Fixes: f5d8f50f271d ("iwlwifi: mvm: Fix channel switch in case of count <= 1")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h | 4 ++--
 drivers/net/wireless/intel/iwlwifi/mvm/time-event.c    | 6 ++++--
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h b/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
index 3721a3ed358b..f824bebceb06 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/time-event.h
@@ -211,7 +211,7 @@ enum {
  * @TE_V2_NOTIF_HOST_FRAG_END:request/receive notification on frag end
  * @TE_V2_NOTIF_INTERNAL_FRAG_START: internal FW use.
  * @TE_V2_NOTIF_INTERNAL_FRAG_END: internal FW use.
- * @T2_V2_START_IMMEDIATELY: start time event immediately
+ * @TE_V2_START_IMMEDIATELY: start time event immediately
  * @TE_V2_DEP_OTHER: depends on another time event
  * @TE_V2_DEP_TSF: depends on a specific time
  * @TE_V2_EVENT_SOCIOPATHIC: can't co-exist with other events of tha same MAC
@@ -230,7 +230,7 @@ enum iwl_time_event_policy {
 	TE_V2_NOTIF_HOST_FRAG_END = BIT(5),
 	TE_V2_NOTIF_INTERNAL_FRAG_START = BIT(6),
 	TE_V2_NOTIF_INTERNAL_FRAG_END = BIT(7),
-	T2_V2_START_IMMEDIATELY = BIT(11),
+	TE_V2_START_IMMEDIATELY = BIT(11),
 
 	/* placement characteristics */
 	TE_V2_DEP_OTHER = BIT(TE_V2_PLACEMENT_POS),
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
index 200ab50ec86b..acb217e666db 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/time-event.c
@@ -616,7 +616,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 	time_cmd.repeat = 1;
 	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
 				      TE_V2_NOTIF_HOST_EVENT_END |
-				      T2_V2_START_IMMEDIATELY);
+				      TE_V2_START_IMMEDIATELY);
 
 	if (!wait_for_notif) {
 		iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
@@ -803,7 +803,7 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	time_cmd.repeat = 1;
 	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
 				      TE_V2_NOTIF_HOST_EVENT_END |
-				      T2_V2_START_IMMEDIATELY);
+				      TE_V2_START_IMMEDIATELY);
 
 	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
@@ -913,6 +913,8 @@ int iwl_mvm_schedule_csa_period(struct iwl_mvm *mvm,
 	time_cmd.interval = cpu_to_le32(1);
 	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
 				      TE_V2_ABSENCE);
+	if (!apply_time)
+		time_cmd.policy |= cpu_to_le16(TE_V2_START_IMMEDIATELY);
 
 	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
-- 
2.15.1
