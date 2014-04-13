Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:37432 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbaDMTU7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Apr 2014 15:20:59 -0400
Received: by mail-wi0-f175.google.com with SMTP id cc10so3139759wib.2
        for <linux-wireless@vger.kernel.org>; Sun, 13 Apr 2014 12:20:58 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 32/47] iwlwifi: remove IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2 flag
Date: Sun, 13 Apr 2014 22:19:47 +0300
Message-Id: <1397416802-32403-32-git-send-email-egrumbach@gmail.com> (sfid-20140413_213514_552584_FA1BAAAD)
In-Reply-To: <534AE330.2020805@gmail.com>
References: <534AE330.2020805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

All the supported firmwares have this flag set.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h         |  2 -
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     | 53 ++------------------
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 71 +++------------------------
 3 files changed, 12 insertions(+), 114 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index 7d5e7ba..04eac6e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -77,7 +77,6 @@
  * @IWL_UCODE_TLV_FLAGS_UAPSD: This uCode image supports uAPSD
  * @IWL_UCODE_TLV_FLAGS_SHORT_BL: 16 entries of black list instead of 64 in scan
  *	offload profile config command.
- * @IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2: using the new time event API.
  * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
  *	(rather than two) IPv6 addresses
  * @IWL_UCODE_TLV_FLAGS_BF_UPDATED: new beacon filtering API
@@ -107,7 +106,6 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_P2P			= BIT(3),
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
 	IWL_UCODE_TLV_FLAGS_SHORT_BL		= BIT(7),
-	IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2	= BIT(9),
 	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
 	IWL_UCODE_TLV_FLAGS_BF_UPDATED		= BIT(11),
 	IWL_UCODE_TLV_FLAGS_NO_BASIC_SSID	= BIT(12),
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 6e75b52..48554da 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -604,52 +604,7 @@ enum {
 	TE_V1_NOTIF_INTERNAL_FRAG_END = BIT(7),
 }; /* MAC_EVENT_ACTION_API_E_VER_2 */
 
-
-/**
- * struct iwl_time_event_cmd_api_v1 - configuring Time Events
- * with struct MAC_TIME_EVENT_DATA_API_S_VER_1 (see also
- * with version 2. determined by IWL_UCODE_TLV_FLAGS)
- * ( TIME_EVENT_CMD = 0x29 )
- * @id_and_color: ID and color of the relevant MAC
- * @action: action to perform, one of FW_CTXT_ACTION_*
- * @id: this field has two meanings, depending on the action:
- *	If the action is ADD, then it means the type of event to add.
- *	For all other actions it is the unique event ID assigned when the
- *	event was added by the FW.
- * @apply_time: When to start the Time Event (in GP2)
- * @max_delay: maximum delay to event's start (apply time), in TU
- * @depends_on: the unique ID of the event we depend on (if any)
- * @interval: interval between repetitions, in TU
- * @interval_reciprocal: 2^32 / interval
- * @duration: duration of event in TU
- * @repeat: how many repetitions to do, can be TE_REPEAT_ENDLESS
- * @dep_policy: one of TE_V1_INDEPENDENT, TE_V1_DEP_OTHER, TE_V1_DEP_TSF
- *	and TE_V1_EVENT_SOCIOPATHIC
- * @is_present: 0 or 1, are we present or absent during the Time Event
- * @max_frags: maximal number of fragments the Time Event can be divided to
- * @notify: notifications using TE_V1_NOTIF_* (whom to notify when)
- */
-struct iwl_time_event_cmd_v1 {
-	/* COMMON_INDEX_HDR_API_S_VER_1 */
-	__le32 id_and_color;
-	__le32 action;
-	__le32 id;
-	/* MAC_TIME_EVENT_DATA_API_S_VER_1 */
-	__le32 apply_time;
-	__le32 max_delay;
-	__le32 dep_policy;
-	__le32 depends_on;
-	__le32 is_present;
-	__le32 max_frags;
-	__le32 interval;
-	__le32 interval_reciprocal;
-	__le32 duration;
-	__le32 repeat;
-	__le32 notify;
-} __packed; /* MAC_TIME_EVENT_CMD_API_S_VER_1 */
-
-
-/* Time event - defines for command API v2 */
+/* Time event - defines for command API */
 
 /*
  * @TE_V2_FRAG_NONE: fragmentation of the time event is NOT allowed.
@@ -680,7 +635,7 @@ enum {
 #define TE_V2_PLACEMENT_POS	12
 #define TE_V2_ABSENCE_POS	15
 
-/* Time event policy values (for time event cmd api v2)
+/* Time event policy values
  * A notification (both event and fragment) includes a status indicating weather
  * the FW was able to schedule the event or not. For fragment start/end
  * notification the status is always success. There is no start/end fragment
@@ -727,7 +682,7 @@ enum {
 };
 
 /**
- * struct iwl_time_event_cmd_api_v2 - configuring Time Events
+ * struct iwl_time_event_cmd_api - configuring Time Events
  * with struct MAC_TIME_EVENT_DATA_API_S_VER_2 (see also
  * with version 1. determined by IWL_UCODE_TLV_FLAGS)
  * ( TIME_EVENT_CMD = 0x29 )
@@ -750,7 +705,7 @@ enum {
  *	TE_EVENT_SOCIOPATHIC
  *	using TE_ABSENCE and using TE_NOTIF_*
  */
-struct iwl_time_event_cmd_v2 {
+struct iwl_time_event_cmd {
 	/* COMMON_INDEX_HDR_API_S_VER_1 */
 	__le32 id_and_color;
 	__le32 action;
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 6133124..a940293 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -273,67 +273,10 @@ static bool iwl_mvm_time_event_response(struct iwl_notif_wait_data *notif_wait,
 	return true;
 }
 
-/* used to convert from time event API v2 to v1 */
-#define TE_V2_DEP_POLICY_MSK (TE_V2_DEP_OTHER | TE_V2_DEP_TSF |\
-			     TE_V2_EVENT_SOCIOPATHIC)
-static inline u16 te_v2_get_notify(__le16 policy)
-{
-	return le16_to_cpu(policy) & TE_V2_NOTIF_MSK;
-}
-
-static inline u16 te_v2_get_dep_policy(__le16 policy)
-{
-	return (le16_to_cpu(policy) & TE_V2_DEP_POLICY_MSK) >>
-		TE_V2_PLACEMENT_POS;
-}
-
-static inline u16 te_v2_get_absence(__le16 policy)
-{
-	return (le16_to_cpu(policy) & TE_V2_ABSENCE) >> TE_V2_ABSENCE_POS;
-}
-
-static void iwl_mvm_te_v2_to_v1(const struct iwl_time_event_cmd_v2 *cmd_v2,
-				struct iwl_time_event_cmd_v1 *cmd_v1)
-{
-	cmd_v1->id_and_color = cmd_v2->id_and_color;
-	cmd_v1->action = cmd_v2->action;
-	cmd_v1->id = cmd_v2->id;
-	cmd_v1->apply_time = cmd_v2->apply_time;
-	cmd_v1->max_delay = cmd_v2->max_delay;
-	cmd_v1->depends_on = cmd_v2->depends_on;
-	cmd_v1->interval = cmd_v2->interval;
-	cmd_v1->duration = cmd_v2->duration;
-	if (cmd_v2->repeat == TE_V2_REPEAT_ENDLESS)
-		cmd_v1->repeat = cpu_to_le32(TE_V1_REPEAT_ENDLESS);
-	else
-		cmd_v1->repeat = cpu_to_le32(cmd_v2->repeat);
-	cmd_v1->max_frags = cpu_to_le32(cmd_v2->max_frags);
-	cmd_v1->interval_reciprocal = 0; /* unused */
-
-	cmd_v1->dep_policy = cpu_to_le32(te_v2_get_dep_policy(cmd_v2->policy));
-	cmd_v1->is_present = cpu_to_le32(!te_v2_get_absence(cmd_v2->policy));
-	cmd_v1->notify = cpu_to_le32(te_v2_get_notify(cmd_v2->policy));
-}
-
-static int iwl_mvm_send_time_event_cmd(struct iwl_mvm *mvm,
-				       const struct iwl_time_event_cmd_v2 *cmd)
-{
-	struct iwl_time_event_cmd_v1 cmd_v1;
-
-	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2)
-		return iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
-					    sizeof(*cmd), cmd);
-
-	iwl_mvm_te_v2_to_v1(cmd, &cmd_v1);
-	return iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
-				    sizeof(cmd_v1), &cmd_v1);
-}
-
-
 static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif,
 				       struct iwl_mvm_time_event_data *te_data,
-				       struct iwl_time_event_cmd_v2 *te_cmd)
+				       struct iwl_time_event_cmd *te_cmd)
 {
 	static const u8 time_event_response[] = { TIME_EVENT_CMD };
 	struct iwl_notification_wait wait_time_event;
@@ -369,7 +312,8 @@ static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
 				   ARRAY_SIZE(time_event_response),
 				   iwl_mvm_time_event_response, te_data);
 
-	ret = iwl_mvm_send_time_event_cmd(mvm, te_cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
+					    sizeof(*te_cmd), te_cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Couldn't send TIME_EVENT_CMD: %d\n", ret);
 		iwl_remove_notification(&mvm->notif_wait, &wait_time_event);
@@ -397,7 +341,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-	struct iwl_time_event_cmd_v2 time_cmd = {};
+	struct iwl_time_event_cmd time_cmd = {};
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -453,7 +397,7 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 			       struct iwl_mvm_vif *mvmvif,
 			       struct iwl_mvm_time_event_data *te_data)
 {
-	struct iwl_time_event_cmd_v2 time_cmd = {};
+	struct iwl_time_event_cmd time_cmd = {};
 	u32 id, uid;
 	int ret;
 
@@ -490,7 +434,8 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
 
 	IWL_DEBUG_TE(mvm, "Removing TE 0x%x\n", le32_to_cpu(time_cmd.id));
-	ret = iwl_mvm_send_time_event_cmd(mvm, &time_cmd);
+	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
+				   sizeof(time_cmd), &time_cmd);
 	if (WARN_ON(ret))
 		return;
 }
@@ -510,7 +455,7 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-	struct iwl_time_event_cmd_v2 time_cmd = {};
+	struct iwl_time_event_cmd time_cmd = {};
 
 	lockdep_assert_held(&mvm->mutex);
 	if (te_data->running) {
-- 
1.8.3.2

