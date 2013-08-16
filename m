Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38873 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab3HPLHR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:07:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Eytan Lifshitz <eytan.lifshitz@intel.com>
Subject: [PATCH 06/20] iwlwifi: mvm: add support to the new FW time event API
Date: Fri, 16 Aug 2013 13:06:56 +0200
Message-Id: <1376651230-1060-6-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130732_828221_5C67DBDC)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eytan Lifshitz <eytan.lifshitz@intel.com>

The time event firmware API will change, add the support for that.
Use the new API throughout and convert to the old where needed.

Signed-off-by: Eytan Lifshitz <eytan.lifshitz@intel.com>
Reviewed-by: Guy Cohen <guy.cohen@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw.h         |   2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api.h     | 226 ++++++++++++++++++++------
 drivers/net/wireless/iwlwifi/mvm/time-event.c |  96 ++++++++---
 3 files changed, 251 insertions(+), 73 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw.h b/drivers/net/wireless/iwlwifi/iwl-fw.h
index bd335f0..1705d24 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw.h
@@ -76,6 +76,7 @@
  * @IWL_UCODE_TLV_FLAGS_DW_BC_TABLE: The SCD byte count table is in DWORDS
  * @IWL_UCODE_TLV_FLAGS_UAPSD: This uCode image supports uAPSD
  * @IWL_UCODE_TLV_FLAGS_RX_ENERGY_API: supports rx signal strength api
+ * @IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2: using the new time event API.
  * @IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS: D3 image supports up to six
  *	(rather than two) IPv6 addresses
  * @IWL_UCODE_TLV_FLAGS_BF_UPDATED: new beacon filtering API
@@ -88,6 +89,7 @@ enum iwl_ucode_tlv_flag {
 	IWL_UCODE_TLV_FLAGS_DW_BC_TABLE		= BIT(4),
 	IWL_UCODE_TLV_FLAGS_UAPSD		= BIT(6),
 	IWL_UCODE_TLV_FLAGS_RX_ENERGY_API	= BIT(8),
+	IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2	= BIT(9),
 	IWL_UCODE_TLV_FLAGS_D3_6_IPV6_ADDRS	= BIT(10),
 	IWL_UCODE_TLV_FLAGS_BF_UPDATED		= BIT(11),
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 55854a3..b104710 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -499,71 +499,199 @@ enum iwl_time_event_type {
 	TE_MAX
 }; /* MAC_EVENT_TYPE_API_E_VER_1 */
 
+
+
+/* Time event - defines for command API v1 */
+
+/*
+ * @TE_V1_FRAG_NONE: fragmentation of the time event is NOT allowed.
+ * @TE_V1_FRAG_SINGLE: fragmentation of the time event is allowed, but only
+ *	the first fragment is scheduled.
+ * @TE_V1_FRAG_DUAL: fragmentation of the time event is allowed, but only
+ *	the first 2 fragments are scheduled.
+ * @TE_V1_FRAG_ENDLESS: fragmentation of the time event is allowed, and any
+ *	number of fragments are valid.
+ *
+ * Other than the constant defined above, specifying a fragmentation value 'x'
+ * means that the event can be fragmented but only the first 'x' will be
+ * scheduled.
+ */
+enum {
+	TE_V1_FRAG_NONE = 0,
+	TE_V1_FRAG_SINGLE = 1,
+	TE_V1_FRAG_DUAL = 2,
+	TE_V1_FRAG_ENDLESS = 0xffffffff
+};
+
+/* If a Time Event can be fragmented, this is the max number of fragments */
+#define TE_V1_FRAG_MAX_MSK	0x0fffffff
+/* Repeat the time event endlessly (until removed) */
+#define TE_V1_REPEAT_ENDLESS	0xffffffff
+/* If a Time Event has bounded repetitions, this is the maximal value */
+#define TE_V1_REPEAT_MAX_MSK_V1	0x0fffffff
+
 /* Time Event dependencies: none, on another TE, or in a specific time */
 enum {
-	TE_INDEPENDENT		= 0,
-	TE_DEP_OTHER		= 1,
-	TE_DEP_TSF		= 2,
-	TE_EVENT_SOCIOPATHIC	= 4,
+	TE_V1_INDEPENDENT		= 0,
+	TE_V1_DEP_OTHER			= BIT(0),
+	TE_V1_DEP_TSF			= BIT(1),
+	TE_V1_EVENT_SOCIOPATHIC		= BIT(2),
 }; /* MAC_EVENT_DEPENDENCY_POLICY_API_E_VER_2 */
+
 /*
+ * @TE_V1_NOTIF_NONE: no notifications
+ * @TE_V1_NOTIF_HOST_EVENT_START: request/receive notification on event start
+ * @TE_V1_NOTIF_HOST_EVENT_END:request/receive notification on event end
+ * @TE_V1_NOTIF_INTERNAL_EVENT_START: internal FW use
+ * @TE_V1_NOTIF_INTERNAL_EVENT_END: internal FW use.
+ * @TE_V1_NOTIF_HOST_FRAG_START: request/receive notification on frag start
+ * @TE_V1_NOTIF_HOST_FRAG_END:request/receive notification on frag end
+ * @TE_V1_NOTIF_INTERNAL_FRAG_START: internal FW use.
+ * @TE_V1_NOTIF_INTERNAL_FRAG_END: internal FW use.
+ *
  * Supported Time event notifications configuration.
  * A notification (both event and fragment) includes a status indicating weather
  * the FW was able to schedule the event or not. For fragment start/end
  * notification the status is always success. There is no start/end fragment
  * notification for monolithic events.
- *
- * @TE_NOTIF_NONE: no notifications
- * @TE_NOTIF_HOST_EVENT_START: request/receive notification on event start
- * @TE_NOTIF_HOST_EVENT_END:request/receive notification on event end
- * @TE_NOTIF_INTERNAL_EVENT_START: internal FW use
- * @TE_NOTIF_INTERNAL_EVENT_END: internal FW use.
- * @TE_NOTIF_HOST_FRAG_START: request/receive notification on frag start
- * @TE_NOTIF_HOST_FRAG_END:request/receive notification on frag end
- * @TE_NOTIF_INTERNAL_FRAG_START: internal FW use.
- * @TE_NOTIF_INTERNAL_FRAG_END: internal FW use.
  */
 enum {
-	TE_NOTIF_NONE = 0,
-	TE_NOTIF_HOST_EVENT_START = 0x1,
-	TE_NOTIF_HOST_EVENT_END = 0x2,
-	TE_NOTIF_INTERNAL_EVENT_START = 0x4,
-	TE_NOTIF_INTERNAL_EVENT_END = 0x8,
-	TE_NOTIF_HOST_FRAG_START = 0x10,
-	TE_NOTIF_HOST_FRAG_END = 0x20,
-	TE_NOTIF_INTERNAL_FRAG_START = 0x40,
-	TE_NOTIF_INTERNAL_FRAG_END = 0x80
+	TE_V1_NOTIF_NONE = 0,
+	TE_V1_NOTIF_HOST_EVENT_START = BIT(0),
+	TE_V1_NOTIF_HOST_EVENT_END = BIT(1),
+	TE_V1_NOTIF_INTERNAL_EVENT_START = BIT(2),
+	TE_V1_NOTIF_INTERNAL_EVENT_END = BIT(3),
+	TE_V1_NOTIF_HOST_FRAG_START = BIT(4),
+	TE_V1_NOTIF_HOST_FRAG_END = BIT(5),
+	TE_V1_NOTIF_INTERNAL_FRAG_START = BIT(6),
+	TE_V1_NOTIF_INTERNAL_FRAG_END = BIT(7),
 }; /* MAC_EVENT_ACTION_API_E_VER_2 */
 
+
+/**
+ * struct iwl_time_event_cmd_api_v1 - configuring Time Events
+ * with struct MAC_TIME_EVENT_DATA_API_S_VER_1 (see also
+ * with version 2. determined by IWL_UCODE_TLV_FLAGS)
+ * ( TIME_EVENT_CMD = 0x29 )
+ * @id_and_color: ID and color of the relevant MAC
+ * @action: action to perform, one of FW_CTXT_ACTION_*
+ * @id: this field has two meanings, depending on the action:
+ *	If the action is ADD, then it means the type of event to add.
+ *	For all other actions it is the unique event ID assigned when the
+ *	event was added by the FW.
+ * @apply_time: When to start the Time Event (in GP2)
+ * @max_delay: maximum delay to event's start (apply time), in TU
+ * @depends_on: the unique ID of the event we depend on (if any)
+ * @interval: interval between repetitions, in TU
+ * @interval_reciprocal: 2^32 / interval
+ * @duration: duration of event in TU
+ * @repeat: how many repetitions to do, can be TE_REPEAT_ENDLESS
+ * @dep_policy: one of TE_V1_INDEPENDENT, TE_V1_DEP_OTHER, TE_V1_DEP_TSF
+ *	and TE_V1_EVENT_SOCIOPATHIC
+ * @is_present: 0 or 1, are we present or absent during the Time Event
+ * @max_frags: maximal number of fragments the Time Event can be divided to
+ * @notify: notifications using TE_V1_NOTIF_* (whom to notify when)
+ */
+struct iwl_time_event_cmd_v1 {
+	/* COMMON_INDEX_HDR_API_S_VER_1 */
+	__le32 id_and_color;
+	__le32 action;
+	__le32 id;
+	/* MAC_TIME_EVENT_DATA_API_S_VER_1 */
+	__le32 apply_time;
+	__le32 max_delay;
+	__le32 dep_policy;
+	__le32 depends_on;
+	__le32 is_present;
+	__le32 max_frags;
+	__le32 interval;
+	__le32 interval_reciprocal;
+	__le32 duration;
+	__le32 repeat;
+	__le32 notify;
+} __packed; /* MAC_TIME_EVENT_CMD_API_S_VER_1 */
+
+
+/* Time event - defines for command API v2 */
+
 /*
- * @TE_FRAG_NONE: fragmentation of the time event is NOT allowed.
- * @TE_FRAG_SINGLE: fragmentation of the time event is allowed, but only
+ * @TE_V2_FRAG_NONE: fragmentation of the time event is NOT allowed.
+ * @TE_V2_FRAG_SINGLE: fragmentation of the time event is allowed, but only
  *  the first fragment is scheduled.
- * @TE_FRAG_DUAL: fragmentation of the time event is allowed, but only
+ * @TE_V2_FRAG_DUAL: fragmentation of the time event is allowed, but only
  *  the first 2 fragments are scheduled.
- * @TE_FRAG_ENDLESS: fragmentation of the time event is allowed, and any number
- *  of fragments are valid.
+ * @TE_V2_FRAG_ENDLESS: fragmentation of the time event is allowed, and any
+ *  number of fragments are valid.
  *
  * Other than the constant defined above, specifying a fragmentation value 'x'
  * means that the event can be fragmented but only the first 'x' will be
  * scheduled.
  */
 enum {
-	TE_FRAG_NONE = 0,
-	TE_FRAG_SINGLE = 1,
-	TE_FRAG_DUAL = 2,
-	TE_FRAG_ENDLESS = 0xffffffff
+	TE_V2_FRAG_NONE = 0,
+	TE_V2_FRAG_SINGLE = 1,
+	TE_V2_FRAG_DUAL = 2,
+	TE_V2_FRAG_MAX = 0xfe,
+	TE_V2_FRAG_ENDLESS = 0xff
 };
 
 /* Repeat the time event endlessly (until removed) */
-#define TE_REPEAT_ENDLESS	(0xffffffff)
+#define TE_V2_REPEAT_ENDLESS	0xff
 /* If a Time Event has bounded repetitions, this is the maximal value */
-#define TE_REPEAT_MAX_MSK	(0x0fffffff)
-/* If a Time Event can be fragmented, this is the max number of fragments */
-#define TE_FRAG_MAX_MSK		(0x0fffffff)
+#define TE_V2_REPEAT_MAX	0xfe
+
+#define TE_V2_PLACEMENT_POS	12
+#define TE_V2_ABSENCE_POS	15
+
+/* Time event policy values (for time event cmd api v2)
+ * A notification (both event and fragment) includes a status indicating weather
+ * the FW was able to schedule the event or not. For fragment start/end
+ * notification the status is always success. There is no start/end fragment
+ * notification for monolithic events.
+ *
+ * @TE_V2_DEFAULT_POLICY: independent, social, present, unoticable
+ * @TE_V2_NOTIF_HOST_EVENT_START: request/receive notification on event start
+ * @TE_V2_NOTIF_HOST_EVENT_END:request/receive notification on event end
+ * @TE_V2_NOTIF_INTERNAL_EVENT_START: internal FW use
+ * @TE_V2_NOTIF_INTERNAL_EVENT_END: internal FW use.
+ * @TE_V2_NOTIF_HOST_FRAG_START: request/receive notification on frag start
+ * @TE_V2_NOTIF_HOST_FRAG_END:request/receive notification on frag end
+ * @TE_V2_NOTIF_INTERNAL_FRAG_START: internal FW use.
+ * @TE_V2_NOTIF_INTERNAL_FRAG_END: internal FW use.
+ * @TE_V2_DEP_OTHER: depends on another time event
+ * @TE_V2_DEP_TSF: depends on a specific time
+ * @TE_V2_EVENT_SOCIOPATHIC: can't co-exist with other events of tha same MAC
+ * @TE_V2_ABSENCE: are we present or absent during the Time Event.
+ */
+enum {
+	TE_V2_DEFAULT_POLICY = 0x0,
+
+	/* notifications (event start/stop, fragment start/stop) */
+	TE_V2_NOTIF_HOST_EVENT_START = BIT(0),
+	TE_V2_NOTIF_HOST_EVENT_END = BIT(1),
+	TE_V2_NOTIF_INTERNAL_EVENT_START = BIT(2),
+	TE_V2_NOTIF_INTERNAL_EVENT_END = BIT(3),
+
+	TE_V2_NOTIF_HOST_FRAG_START = BIT(4),
+	TE_V2_NOTIF_HOST_FRAG_END = BIT(5),
+	TE_V2_NOTIF_INTERNAL_FRAG_START = BIT(6),
+	TE_V2_NOTIF_INTERNAL_FRAG_END = BIT(7),
+
+	TE_V2_NOTIF_MSK = 0xff,
+
+	/* placement characteristics */
+	TE_V2_DEP_OTHER = BIT(TE_V2_PLACEMENT_POS),
+	TE_V2_DEP_TSF = BIT(TE_V2_PLACEMENT_POS + 1),
+	TE_V2_EVENT_SOCIOPATHIC = BIT(TE_V2_PLACEMENT_POS + 2),
+
+	/* are we present or absent during the Time Event. */
+	TE_V2_ABSENCE = BIT(TE_V2_ABSENCE_POS),
+};
 
 /**
- * struct iwl_time_event_cmd - configuring Time Events
+ * struct iwl_time_event_cmd_api_v2 - configuring Time Events
+ * with struct MAC_TIME_EVENT_DATA_API_S_VER_2 (see also
+ * with version 1. determined by IWL_UCODE_TLV_FLAGS)
  * ( TIME_EVENT_CMD = 0x29 )
  * @id_and_color: ID and color of the relevant MAC
  * @action: action to perform, one of FW_CTXT_ACTION_*
@@ -575,32 +703,30 @@ enum {
  * @max_delay: maximum delay to event's start (apply time), in TU
  * @depends_on: the unique ID of the event we depend on (if any)
  * @interval: interval between repetitions, in TU
- * @interval_reciprocal: 2^32 / interval
  * @duration: duration of event in TU
  * @repeat: how many repetitions to do, can be TE_REPEAT_ENDLESS
- * @dep_policy: one of TE_INDEPENDENT, TE_DEP_OTHER, TE_DEP_TSF
- * @is_present: 0 or 1, are we present or absent during the Time Event
  * @max_frags: maximal number of fragments the Time Event can be divided to
- * @notify: notifications using TE_NOTIF_* (whom to notify when)
+ * @policy: defines whether uCode shall notify the host or other uCode modules
+ *	on event and/or fragment start and/or end
+ *	using one of TE_INDEPENDENT, TE_DEP_OTHER, TE_DEP_TSF
+ *	TE_EVENT_SOCIOPATHIC
+ *	using TE_ABSENCE and using TE_NOTIF_*
  */
-struct iwl_time_event_cmd {
+struct iwl_time_event_cmd_v2 {
 	/* COMMON_INDEX_HDR_API_S_VER_1 */
 	__le32 id_and_color;
 	__le32 action;
 	__le32 id;
-	/* MAC_TIME_EVENT_DATA_API_S_VER_1 */
+	/* MAC_TIME_EVENT_DATA_API_S_VER_2 */
 	__le32 apply_time;
 	__le32 max_delay;
-	__le32 dep_policy;
 	__le32 depends_on;
-	__le32 is_present;
-	__le32 max_frags;
 	__le32 interval;
-	__le32 interval_reciprocal;
 	__le32 duration;
-	__le32 repeat;
-	__le32 notify;
-} __packed; /* MAC_TIME_EVENT_CMD_API_S_VER_1 */
+	u8 repeat;
+	u8 max_frags;
+	__le16 policy;
+} __packed; /* MAC_TIME_EVENT_CMD_API_S_VER_2 */
 
 /**
  * struct iwl_time_event_resp - response structure to iwl_time_event_cmd
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index ad9bbca..7ed94a0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -166,7 +166,7 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 	WARN_ONCE(!le32_to_cpu(notif->status),
 		  "Failed to schedule time event\n");
 
-	if (le32_to_cpu(notif->action) & TE_NOTIF_HOST_EVENT_END) {
+	if (le32_to_cpu(notif->action) & TE_V2_NOTIF_HOST_EVENT_END) {
 		IWL_DEBUG_TE(mvm,
 			     "TE ended - current time %lu, estimated end %lu\n",
 			     jiffies, te_data->end_jiffies);
@@ -189,7 +189,7 @@ static void iwl_mvm_te_handle_notif(struct iwl_mvm *mvm,
 		}
 
 		iwl_mvm_te_clear_data(mvm, te_data);
-	} else if (le32_to_cpu(notif->action) & TE_NOTIF_HOST_EVENT_START) {
+	} else if (le32_to_cpu(notif->action) & TE_V2_NOTIF_HOST_EVENT_START) {
 		te_data->running = true;
 		te_data->end_jiffies = jiffies +
 			TU_TO_JIFFIES(te_data->duration);
@@ -257,10 +257,67 @@ static bool iwl_mvm_time_event_response(struct iwl_notif_wait_data *notif_wait,
 	return true;
 }
 
+/* used to convert from time event API v2 to v1 */
+#define TE_V2_DEP_POLICY_MSK (TE_V2_DEP_OTHER | TE_V2_DEP_TSF |\
+			     TE_V2_EVENT_SOCIOPATHIC)
+static inline u16 te_v2_get_notify(__le16 policy)
+{
+	return le16_to_cpu(policy) & TE_V2_NOTIF_MSK;
+}
+
+static inline u16 te_v2_get_dep_policy(__le16 policy)
+{
+	return (le16_to_cpu(policy) & TE_V2_DEP_POLICY_MSK) >>
+		TE_V2_PLACEMENT_POS;
+}
+
+static inline u16 te_v2_get_absence(__le16 policy)
+{
+	return (le16_to_cpu(policy) & TE_V2_ABSENCE) >> TE_V2_ABSENCE_POS;
+}
+
+static void iwl_mvm_te_v2_to_v1(const struct iwl_time_event_cmd_v2 *cmd_v2,
+				struct iwl_time_event_cmd_v1 *cmd_v1)
+{
+	cmd_v1->id_and_color = cmd_v2->id_and_color;
+	cmd_v1->action = cmd_v2->action;
+	cmd_v1->id = cmd_v2->id;
+	cmd_v1->apply_time = cmd_v2->apply_time;
+	cmd_v1->max_delay = cmd_v2->max_delay;
+	cmd_v1->depends_on = cmd_v2->depends_on;
+	cmd_v1->interval = cmd_v2->interval;
+	cmd_v1->duration = cmd_v2->duration;
+	if (cmd_v2->repeat == TE_V2_REPEAT_ENDLESS)
+		cmd_v1->repeat = cpu_to_le32(TE_V1_REPEAT_ENDLESS);
+	else
+		cmd_v1->repeat = cpu_to_le32(cmd_v2->repeat);
+	cmd_v1->max_frags = cpu_to_le32(cmd_v2->max_frags);
+	cmd_v1->interval_reciprocal = 0; /* unused */
+
+	cmd_v1->dep_policy = cpu_to_le32(te_v2_get_dep_policy(cmd_v2->policy));
+	cmd_v1->is_present = cpu_to_le32(!te_v2_get_absence(cmd_v2->policy));
+	cmd_v1->notify = cpu_to_le32(te_v2_get_notify(cmd_v2->policy));
+}
+
+static int iwl_mvm_send_time_event_cmd(struct iwl_mvm *mvm,
+				       const struct iwl_time_event_cmd_v2 *cmd)
+{
+	struct iwl_time_event_cmd_v1 cmd_v1;
+
+	if (mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_TIME_EVENT_API_V2)
+		return iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
+					    sizeof(*cmd), cmd);
+
+	iwl_mvm_te_v2_to_v1(cmd, &cmd_v1);
+	return iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
+				    sizeof(cmd_v1), &cmd_v1);
+}
+
+
 static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
 				       struct ieee80211_vif *vif,
 				       struct iwl_mvm_time_event_data *te_data,
-				       struct iwl_time_event_cmd *te_cmd)
+				       struct iwl_time_event_cmd_v2 *te_cmd)
 {
 	static const u8 time_event_response[] = { TIME_EVENT_CMD };
 	struct iwl_notification_wait wait_time_event;
@@ -296,8 +353,7 @@ static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
 				   ARRAY_SIZE(time_event_response),
 				   iwl_mvm_time_event_response, te_data);
 
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
-				   sizeof(*te_cmd), te_cmd);
+	ret = iwl_mvm_send_time_event_cmd(mvm, te_cmd);
 	if (ret) {
 		IWL_ERR(mvm, "Couldn't send TIME_EVENT_CMD: %d\n", ret);
 		iwl_remove_notification(&mvm->notif_wait, &wait_time_event);
@@ -324,7 +380,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-	struct iwl_time_event_cmd time_cmd = {};
+	struct iwl_time_event_cmd_v2 time_cmd = {};
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -359,17 +415,14 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 	time_cmd.apply_time =
 		cpu_to_le32(iwl_read_prph(mvm->trans, DEVICE_SYSTEM_TIME_REG));
 
-	time_cmd.dep_policy = TE_INDEPENDENT;
-	time_cmd.is_present = cpu_to_le32(1);
-	time_cmd.max_frags = cpu_to_le32(TE_FRAG_NONE);
+	time_cmd.max_frags = TE_V2_FRAG_NONE;
 	time_cmd.max_delay = cpu_to_le32(500);
 	/* TODO: why do we need to interval = bi if it is not periodic? */
 	time_cmd.interval = cpu_to_le32(1);
-	time_cmd.interval_reciprocal = cpu_to_le32(iwl_mvm_reciprocal(1));
 	time_cmd.duration = cpu_to_le32(duration);
-	time_cmd.repeat = cpu_to_le32(1);
-	time_cmd.notify = cpu_to_le32(TE_NOTIF_HOST_EVENT_START |
-				      TE_NOTIF_HOST_EVENT_END);
+	time_cmd.repeat = 1;
+	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
+				      TE_V2_NOTIF_HOST_EVENT_END);
 
 	iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
@@ -383,7 +436,7 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 			       struct iwl_mvm_vif *mvmvif,
 			       struct iwl_mvm_time_event_data *te_data)
 {
-	struct iwl_time_event_cmd time_cmd = {};
+	struct iwl_time_event_cmd_v2 time_cmd = {};
 	u32 id, uid;
 	int ret;
 
@@ -420,8 +473,7 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
 
 	IWL_DEBUG_TE(mvm, "Removing TE 0x%x\n", le32_to_cpu(time_cmd.id));
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
-				   sizeof(time_cmd), &time_cmd);
+	ret = iwl_mvm_send_time_event_cmd(mvm, &time_cmd);
 	if (WARN_ON(ret))
 		return;
 }
@@ -441,7 +493,7 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-	struct iwl_time_event_cmd time_cmd = {};
+	struct iwl_time_event_cmd_v2 time_cmd = {};
 
 	lockdep_assert_held(&mvm->mutex);
 	if (te_data->running) {
@@ -472,8 +524,6 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	}
 
 	time_cmd.apply_time = cpu_to_le32(0);
-	time_cmd.dep_policy = cpu_to_le32(TE_INDEPENDENT);
-	time_cmd.is_present = cpu_to_le32(1);
 	time_cmd.interval = cpu_to_le32(1);
 
 	/*
@@ -482,12 +532,12 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 * scheduled. To improve the chances of it being scheduled, allow them
 	 * to be fragmented, and in addition allow them to be delayed.
 	 */
-	time_cmd.max_frags = cpu_to_le32(MSEC_TO_TU(duration)/20);
+	time_cmd.max_frags = min(MSEC_TO_TU(duration)/50, TE_V2_FRAG_ENDLESS);
 	time_cmd.max_delay = cpu_to_le32(MSEC_TO_TU(duration/2));
 	time_cmd.duration = cpu_to_le32(MSEC_TO_TU(duration));
-	time_cmd.repeat = cpu_to_le32(1);
-	time_cmd.notify = cpu_to_le32(TE_NOTIF_HOST_EVENT_START |
-				      TE_NOTIF_HOST_EVENT_END);
+	time_cmd.repeat = 1;
+	time_cmd.policy = cpu_to_le16(TE_V2_NOTIF_HOST_EVENT_START |
+				      TE_V2_NOTIF_HOST_EVENT_END);
 
 	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
-- 
1.8.4.rc2

