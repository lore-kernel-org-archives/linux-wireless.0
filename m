Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47715 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933241Ab3BLQCk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Feb 2013 11:02:40 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 13/15] iwlwifi: mvm: don't wait for session protection to start
Date: Tue, 12 Feb 2013 17:02:05 +0100
Message-Id: <1360684927-1367-13-git-send-email-johannes@sipsolutions.net> (sfid-20130212_170255_559067_45600253)
In-Reply-To: <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
References: <1360684891.29913.4.camel@jlt4.sipsolutions.net>
 <1360684927-1367-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that mac80211 no longer starts the auth/assoc
timeouts when it transmits the frame, but only when
the frame status arrives, we no longer need to wait
for the session protection time event to start, we
can schedule it and enqueue the auth/assoc frame
right away. This reduces the amount of time we block
mac80211's workqueue.

Also, since now we no longer need different behavior
for session protection and P2P time events, refactor
the code to have just a common implementation.

Reviewed-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 215 +++++++++-----------------
 1 file changed, 73 insertions(+), 142 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 194bfb7..c09b71f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -230,57 +230,86 @@ int iwl_mvm_rx_time_event_notif(struct iwl_mvm *mvm,
 	return 0;
 }
 
-static bool iwl_mvm_time_event_notif(struct iwl_notif_wait_data *notif_wait,
-				     struct iwl_rx_packet *pkt, void *data)
+static bool iwl_mvm_time_event_response(struct iwl_notif_wait_data *notif_wait,
+					struct iwl_rx_packet *pkt, void *data)
 {
 	struct iwl_mvm *mvm =
 		container_of(notif_wait, struct iwl_mvm, notif_wait);
 	struct iwl_mvm_time_event_data *te_data = data;
-	struct ieee80211_vif *vif = te_data->vif;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
-	struct iwl_time_event_notif *notif;
 	struct iwl_time_event_resp *resp;
+	int resp_len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 
-	u32 mac_id_n_color = FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color);
+	if (WARN_ON(pkt->hdr.cmd != TIME_EVENT_CMD))
+		return true;
 
-	/* until we do something else */
-	WARN_ON(te_data->id != TE_BSS_STA_AGGRESSIVE_ASSOC);
+	if (WARN_ON_ONCE(resp_len != sizeof(pkt->hdr) + sizeof(*resp))) {
+		IWL_ERR(mvm, "Invalid TIME_EVENT_CMD response\n");
+		return true;
+	}
 
-	switch (pkt->hdr.cmd) {
-	case TIME_EVENT_CMD:
-		resp = (void *)pkt->data;
-		/* TODO: I can't check that since the fw is buggy - it doesn't
-		 * put the right values when we remove a TE. We can be here
-		 * when we remove a TE because the remove TE command is sent in
-		 * ASYNC...
-		 * WARN_ON(mac_id_n_color != le32_to_cpu(resp->id_and_color));
-		 */
-		te_data->uid = le32_to_cpu(resp->unique_id);
-		IWL_DEBUG_TE(mvm, "Got response - UID = 0x%x\n", te_data->uid);
-		return false;
-
-	case TIME_EVENT_NOTIFICATION:
-		notif = (void *)pkt->data;
-		WARN_ON(le32_to_cpu(notif->status) != 1);
-		WARN_ON(mac_id_n_color != le32_to_cpu(notif->id_and_color));
-		/* check if this is our Time Event that is starting */
-		if (le32_to_cpu(notif->unique_id) != te_data->uid)
-			return false;
-		IWL_DEBUG_TE(mvm, "Event %d is starting - time is %d\n",
-			     te_data->uid, le32_to_cpu(notif->timestamp));
-
-		WARN_ONCE(!le32_to_cpu(notif->status),
-			  "Failed to schedule protected session TE\n");
+	resp = (void *)pkt->data;
+	te_data->uid = le32_to_cpu(resp->unique_id);
+	IWL_DEBUG_TE(mvm, "TIME_EVENT_CMD response - UID = 0x%x\n",
+		     te_data->uid);
+	return true;
+}
 
-		te_data->running = true;
-		te_data->end_jiffies = jiffies +
-				       TU_TO_JIFFIES(te_data->duration);
-		return true;
+static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
+				       struct ieee80211_vif *vif,
+				       struct iwl_mvm_time_event_data *te_data,
+				       struct iwl_time_event_cmd *te_cmd)
+{
+	static const u8 time_event_response[] = { TIME_EVENT_CMD };
+	struct iwl_notification_wait wait_time_event;
+	int ret;
+
+	lockdep_assert_held(&mvm->mutex);
+
+	spin_lock_bh(&mvm->time_event_lock);
+	if (WARN_ON(te_data->id != TE_MAX)) {
+		spin_unlock_bh(&mvm->time_event_lock);
+		return -EIO;
+	}
+	te_data->vif = vif;
+	te_data->duration = le32_to_cpu(te_cmd->duration);
+	te_data->id = le32_to_cpu(te_cmd->id);
+	list_add_tail(&te_data->list, &mvm->time_event_list);
+	spin_unlock_bh(&mvm->time_event_lock);
+
+	/*
+	 * Use a notification wait, which really just processes the
+	 * command response and doesn't wait for anything, in order
+	 * to be able to process the response and get the UID inside
+	 * the RX path. Using CMD_WANT_SKB doesn't work because it
+	 * stores the buffer and then wakes up this thread, by which
+	 * time another notification (that the time event started)
+	 * might already be processed unsuccessfully.
+	 */
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_time_event,
+				   time_event_response,
+				   ARRAY_SIZE(time_event_response),
+				   iwl_mvm_time_event_response, te_data);
+
+	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
+				   sizeof(*te_cmd), te_cmd);
+	if (ret) {
+		IWL_ERR(mvm, "Couldn't send TIME_EVENT_CMD: %d\n", ret);
+		iwl_remove_notification(&mvm->notif_wait, &wait_time_event);
+		goto out_clear_te;
+	}
 
-	default:
-		WARN_ON(1);
-		return false;
-	};
+	/* No need to wait for anything, so just pass 1 (0 isn't valid) */
+	ret = iwl_wait_notification(&mvm->notif_wait, &wait_time_event, 1);
+	/* should never fail */
+	WARN_ON_ONCE(ret);
+
+	if (ret) {
+ out_clear_te:
+		spin_lock_bh(&mvm->time_event_lock);
+		iwl_mvm_te_clear_data(mvm, te_data);
+		spin_unlock_bh(&mvm->time_event_lock);
+	}
+	return ret;
 }
 
 void iwl_mvm_protect_session(struct iwl_mvm *mvm,
@@ -289,11 +318,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-	static const u8 time_event_notif[] = { TIME_EVENT_CMD,
-					       TIME_EVENT_NOTIFICATION };
-	struct iwl_notification_wait wait_time_event;
 	struct iwl_time_event_cmd time_cmd = {};
-	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 
@@ -320,12 +345,6 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 		iwl_mvm_stop_session_protection(mvm, vif);
 	}
 
-	iwl_init_notification_wait(&mvm->notif_wait, &wait_time_event,
-				   time_event_notif,
-				   ARRAY_SIZE(time_event_notif),
-				   iwl_mvm_time_event_notif,
-				   &mvmvif->time_event_data);
-
 	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_ADD);
 	time_cmd.id_and_color =
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
@@ -333,6 +352,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 
 	time_cmd.apply_time =
 		cpu_to_le32(iwl_read_prph(mvm->trans, DEVICE_SYSTEM_TIME_REG));
+
 	time_cmd.dep_policy = TE_INDEPENDENT;
 	time_cmd.is_present = cpu_to_le32(1);
 	time_cmd.max_frags = cpu_to_le32(TE_FRAG_NONE);
@@ -344,33 +364,7 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 	time_cmd.repeat = cpu_to_le32(1);
 	time_cmd.notify = cpu_to_le32(TE_NOTIF_HOST_START | TE_NOTIF_HOST_END);
 
-	te_data->vif = vif;
-	te_data->duration = duration;
-
-	spin_lock_bh(&mvm->time_event_lock);
-	te_data->id = le32_to_cpu(time_cmd.id);
-	list_add_tail(&te_data->list, &mvm->time_event_list);
-	spin_unlock_bh(&mvm->time_event_lock);
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
-				   sizeof(time_cmd), &time_cmd);
-	if (ret) {
-		IWL_ERR(mvm, "Couldn't send TIME_EVENT_CMD: %d\n", ret);
-		goto out_remove_notif;
-	}
-
-	ret = iwl_wait_notification(&mvm->notif_wait, &wait_time_event, 1 * HZ);
-	if (ret) {
-		IWL_ERR(mvm, "%s - failed on timeout\n", __func__);
-		spin_lock_bh(&mvm->time_event_lock);
-		iwl_mvm_te_clear_data(mvm, te_data);
-		spin_unlock_bh(&mvm->time_event_lock);
-	}
-
-	return;
-
-out_remove_notif:
-	iwl_remove_notification(&mvm->notif_wait, &wait_time_event);
+	iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
 
 /*
@@ -435,43 +429,12 @@ void iwl_mvm_stop_session_protection(struct iwl_mvm *mvm,
 	iwl_mvm_remove_time_event(mvm, mvmvif, te_data);
 }
 
-static bool iwl_mvm_roc_te_notif(struct iwl_notif_wait_data *notif_wait,
-				 struct iwl_rx_packet *pkt, void *data)
-{
-	struct iwl_mvm *mvm =
-		container_of(notif_wait, struct iwl_mvm, notif_wait);
-	struct iwl_mvm_time_event_data *te_data = data;
-	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(te_data->vif);
-	struct iwl_time_event_resp *resp;
-
-	u32 mac_id_n_color = FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color);
-
-	/* until we do something else */
-	WARN_ON(te_data->id != IWL_MVM_ROC_TE_TYPE);
-
-	switch (pkt->hdr.cmd) {
-	case TIME_EVENT_CMD:
-		resp = (void *)pkt->data;
-		WARN_ON(mac_id_n_color != le32_to_cpu(resp->id_and_color));
-		te_data->uid = le32_to_cpu(resp->unique_id);
-		IWL_DEBUG_TE(mvm, "Got response - UID = 0x%x\n", te_data->uid);
-		return true;
-
-	default:
-		WARN_ON(1);
-		return false;
-	};
-}
-
 int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 			  int duration)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
-	static const u8 roc_te_notif[] = { TIME_EVENT_CMD };
-	struct iwl_notification_wait wait_time_event;
 	struct iwl_time_event_cmd time_cmd = {};
-	int ret;
 
 	lockdep_assert_held(&mvm->mutex);
 	if (te_data->running) {
@@ -485,12 +448,6 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	 */
 	flush_work(&mvm->roc_done_wk);
 
-	iwl_init_notification_wait(&mvm->notif_wait, &wait_time_event,
-				   roc_te_notif,
-				   ARRAY_SIZE(roc_te_notif),
-				   iwl_mvm_roc_te_notif,
-				   &mvmvif->time_event_data);
-
 	time_cmd.action = cpu_to_le32(FW_CTXT_ACTION_ADD);
 	time_cmd.id_and_color =
 		cpu_to_le32(FW_CMD_ID_AND_COLOR(mvmvif->id, mvmvif->color));
@@ -516,33 +473,7 @@ int iwl_mvm_start_p2p_roc(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	time_cmd.repeat = cpu_to_le32(1);
 	time_cmd.notify = cpu_to_le32(TE_NOTIF_HOST_START | TE_NOTIF_HOST_END);
 
-	/* Push the te data to the tracked te list */
-	te_data->vif = vif;
-	te_data->duration = MSEC_TO_TU(duration);
-
-	spin_lock_bh(&mvm->time_event_lock);
-	te_data->id = le32_to_cpu(time_cmd.id);
-	list_add_tail(&te_data->list, &mvm->time_event_list);
-	spin_unlock_bh(&mvm->time_event_lock);
-
-	ret = iwl_mvm_send_cmd_pdu(mvm, TIME_EVENT_CMD, CMD_SYNC,
-				   sizeof(time_cmd), &time_cmd);
-	if (ret) {
-		IWL_ERR(mvm, "Couldn't send TIME_EVENT_CMD: %d\n", ret);
-		goto out_remove_notif;
-	}
-
-	ret = iwl_wait_notification(&mvm->notif_wait, &wait_time_event, 1 * HZ);
-	if (ret) {
-		IWL_ERR(mvm, "%s - failed on timeout\n", __func__);
-		iwl_mvm_te_clear_data(mvm, te_data);
-	}
-
-	return ret;
-
-out_remove_notif:
-	iwl_remove_notification(&mvm->notif_wait, &wait_time_event);
-	return ret;
+	return iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
 }
 
 void iwl_mvm_stop_p2p_roc(struct iwl_mvm *mvm)
-- 
1.8.0

