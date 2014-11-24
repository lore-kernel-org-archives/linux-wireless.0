Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:44059 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204AbaKXOfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Nov 2014 09:35:54 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so12519711wgh.34
        for <linux-wireless@vger.kernel.org>; Mon, 24 Nov 2014 06:35:53 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 35/75] iwlwifi: mvm: add remove flow for AUX ROC time events
Date: Mon, 24 Nov 2014 16:34:11 +0200
Message-Id: <1416839691-28533-35-git-send-email-egrumbach@gmail.com> (sfid-20141124_154347_378789_828E2383)
In-Reply-To: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
References: <CANUX_P32q7EFvuOvm+c=yYP9okVEfSUvdDg0gDHHCSg2G+gA0g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

Add a flow that handles the requests to cancel the roc time event,
that has been triggered via the aux framework.

The roc for bss is different than the roc for p2p devices, and  is done
via the aux framework using the aux queue, thus requires a different flow
to cancel the time event.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |   2 +-
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 107 +++++++++++++++++++++-----
 drivers/net/wireless/iwlwifi/mvm/time-event.h |   4 +-
 3 files changed, 89 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index d37d5a8..f3379d7 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -2652,7 +2652,7 @@ static int iwl_mvm_cancel_roc(struct ieee80211_hw *hw)
 	IWL_DEBUG_MAC80211(mvm, "enter\n");
 
 	mutex_lock(&mvm->mutex);
-	iwl_mvm_stop_p2p_roc(mvm);
+	iwl_mvm_stop_roc(mvm);
 	mutex_unlock(&mvm->mutex);
 
 	IWL_DEBUG_MAC80211(mvm, "leave\n");
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 6dfad23..8cf246b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -549,18 +549,11 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 	}
 }
 
-/*
- * Explicit request to remove a time event. The removal of a time event needs to
- * be synchronized with the flow of a time event's end notification, which also
- * removes the time event from the op mode data structures.
- */
-void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
-			       struct iwl_mvm_vif *mvmvif,
-			       struct iwl_mvm_time_event_data *te_data)
+static bool __iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
+					struct iwl_mvm_time_event_data *te_data,
+					u32 *uid)
 {
-	struct iwl_time_event_cmd time_cmd = {};
-	u32 id, uid;
-	int ret;
+	u32 id;
 
 	/*
 	 * It is possible that by the time we got to this point the time
@@ -569,7 +562,7 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 	spin_lock_bh(&mvm->time_event_lock);
 
 	/* Save time event uid before clearing its data */
-	uid = te_data->uid;
+	*uid = te_data->uid;
 	id = te_data->id;
 
 	/*
@@ -584,10 +577,59 @@ void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
 	 * send a removal command.
 	 */
 	if (id == TE_MAX) {
-		IWL_DEBUG_TE(mvm, "TE 0x%x has already ended\n", uid);
-		return;
+		IWL_DEBUG_TE(mvm, "TE 0x%x has already ended\n", *uid);
+		return false;
 	}
 
+	return true;
+}
+
+/*
+ * Explicit request to remove a aux roc time event. The removal of a time
+ * event needs to be synchronized with the flow of a time event's end
+ * notification, which also removes the time event from the op mode
+ * data structures.
+ */
+static void iwl_mvm_remove_aux_roc_te(struct iwl_mvm *mvm,
+				      struct iwl_mvm_vif *mvmvif,
+				      struct iwl_mvm_time_event_data *te_data)
+{
+	struct iwl_hs20_roc_req aux_cmd = {};
+	u32 uid;
+	int ret;
+
+	if (!__iwl_mvm_remove_time_event(mvm, te_data, &uid))
+		return;
+
+	aux_cmd.event_unique_id = cpu_to_le32(uid);
+	aux_cmd.action = cpu_to_le32(FW_CTXT_ACTION_REMOVE);
+	aux_cmd.id_and_color =
+		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
+	IWL_DEBUG_TE(mvm, "Removing BSS AUX ROC TE 0x%x\n",
+		     le32_to_cpu(aux_cmd.event_unique_id));
+	ret = iwl_mvm_send_cmd_pdu(mvm, HOT_SPOT_CMD, 0,
+				   sizeof(aux_cmd), &aux_cmd);
+
+	if (WARN_ON(ret))
+		return;
+}
+
+/*
+ * Explicit request to remove a time event. The removal of a time event needs to
+ * be synchronized with the flow of a time event's end notification, which also
+ * removes the time event from the op mode data structures.
+ */
+void iwl_mvm_remove_time_event(struct iwl_mvm *mvm,
+			       struct iwl_mvm_vif *mvmvif,
+			       struct iwl_mvm_time_event_data *te_data)
+{
+	struct iwl_time_event_cmd time_cmd = {};
+	u32 uid;
+	int ret;
+
+	if (!__iwl_mvm_remove_time_event(mvm, te_data, &uid))
+		return;
+
 	/* When we remove a TE, the UID is to be set in the id field */
 	time_cmd.id = cpu_to_le32(uid);
 	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_REMOVE);
@@ -666,13 +708,17 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
 
-void iwl_mvm_stop_p2p_roc(struct iwl_mvm *mvm)
+void iwl_mvm_stop_roc(struct iwl_mvm *mvm)
 {
 	struct iwl_mvm_vif *mvmvif;
 	struct iwl_mvm_time_event_data *te_data;
+	bool is_p2p = false;
 
 	lockdep_assert_held(&mvm->mutex);
 
+	mvmvif = NULL;
+	spin_lock_bh(&mvm->time_event_lock);
+
 	/*
 	 * Iterate over the list of time events and find the time event that is
 	 * associated with a P2P_DEVICE interface.
@@ -680,22 +726,41 @@ void iwl_mvm_stop_p2p_roc(struct iwl_mvm *mvm)
 	 * event at any given time and this time event coresponds to a ROC
 	 * request
 	 */
-	mvmvif = NULL;
-	spin_lock_bh(&mvm->time_event_lock);
 	list_for_each_entry(te_data, &mvm->time_event_list, list) {
-		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE) {
+		if (te_data->vif->type == NL80211_IFTYPE_P2P_DEVICE &&
+		    te_data->running) {
 			mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
-			break;
+			is_p2p = true;
+			goto remove_te;
+		}
+	}
+
+	/*
+	 * Iterate over the list of aux roc time events and find the time
+	 * event that is associated with a BSS interface.
+	 * This assumes that a BSS interface can have only a single time
+	 * event at any given time and this time event coresponds to a ROC
+	 * request
+	 */
+	list_for_each_entry(te_data, &mvm->aux_roc_te_list, list) {
+		if (te_data->running) {
+			mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
+			goto remove_te;
 		}
 	}
+
+remove_te:
 	spin_unlock_bh(&mvm->time_event_lock);
 
 	if (!mvmvif) {
-		IWL_WARN(mvm, "P2P_DEVICE no remain on channel event\n");
+		IWL_WARN(mvm, "No remain on channel event\n");
 		return;
 	}
 
-	iwl_mvm_remove_time_event(mvm, mvmvif, te_data);
+	if (is_p2p)
+		iwl_mvm_remove_time_event(mvm, mvmvif, te_data);
+	else
+		iwl_mvm_remove_aux_roc_te(mvm, mvmvif, te_data);
 
 	iwl_mvm_roc_finished(mvm);
 }
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index b350e47..6f6b35d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -182,14 +182,14 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			  int duration, enum ieee80211_roc_type type);
 
 /**
- * iwl_mvm_stop_p2p_roc - stop remain on channel for p2p device functionlity
+ * iwl_mvm_stop_roc - stop remain on channel functionality
  * @mvm: the mvm component
  *
  * This function can be used to cancel an ongoing ROC session.
  * The function is async, it will instruct the FW to stop serving the ROC
  * session, but will not wait for the actual stopping of the session.
  */
-void iwl_mvm_stop_p2p_roc(struct iwl_mvm *mvm);
+void iwl_mvm_stop_roc(struct iwl_mvm *mvm);
 
 /**
  * iwl_mvm_remove_time_event - general function to clean up of time event
-- 
1.9.1

