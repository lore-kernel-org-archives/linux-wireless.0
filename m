Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:57284 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT44 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:56 -0400
Received: by mail-wg0-f41.google.com with SMTP id l18so9168581wgh.24
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:55 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Liad Kaufman <liad.kaufman@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/36] iwlwifi: mvm: wait for TE notif when protecting TDLS session
Date: Wed,  3 Sep 2014 22:56:06 +0300
Message-Id: <1409774184-24665-18-git-send-email-egrumbach@gmail.com> (sfid-20140903_220114_212603_3988AF37)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

Make sure that when running the TDLS discovery session
protection - the time event that ensures we remain on channel
has been scheduled and started running before leaving.

Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c   |  6 +--
 drivers/net/wireless/iwlwifi/mvm/time-event.c | 59 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/time-event.h |  6 ++-
 3 files changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 98e14f9..5bc7557 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1480,7 +1480,7 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				 */
 				u32 dur = (11 * vif->bss_conf.beacon_int) / 10;
 				iwl_mvm_protect_session(mvm, vif, dur, dur,
-							5 * dur);
+							5 * dur, false);
 			}
 
 			iwl_mvm_sf_update(mvm, vif, false);
@@ -2149,7 +2149,7 @@ static void iwl_mvm_mac_mgd_prepare_tx(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 	/* Try really hard to protect the session and hear a beacon */
-	iwl_mvm_protect_session(mvm, vif, duration, min_duration, 500);
+	iwl_mvm_protect_session(mvm, vif, duration, min_duration, 500, false);
 	mutex_unlock(&mvm->mutex);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PREPARE_TX);
@@ -2170,7 +2170,7 @@ static void iwl_mvm_mac_mgd_protect_tdls_discover(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 	/* Protect the session to hear the TDLS setup response on the channel */
-	iwl_mvm_protect_session(mvm, vif, duration, duration, 100);
+	iwl_mvm_protect_session(mvm, vif, duration, duration, 100, true);
 	mutex_unlock(&mvm->mutex);
 
 	iwl_mvm_unref(mvm, IWL_MVM_REF_PROTECT_TDLS);
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.c b/drivers/net/wireless/iwlwifi/mvm/time-event.c
index 33e5041..51c610f 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.c
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.c
@@ -348,6 +348,38 @@ unlock:
 	return 0;
 }
 
+static bool iwl_mvm_te_notif(struct iwl_notif_wait_data *notif_wait,
+			     struct iwl_rx_packet *pkt, void *data)
+{
+	struct iwl_mvm *mvm =
+		container_of(notif_wait, struct iwl_mvm, notif_wait);
+	struct iwl_mvm_time_event_data *te_data = data;
+	struct iwl_time_event_notif *resp;
+	int resp_len = iwl_rx_packet_payload_len(pkt);
+
+	if (WARN_ON(pkt->hdr.cmd != TIME_EVENT_NOTIFICATION))
+		return true;
+
+	if (WARN_ON_ONCE(resp_len != sizeof(*resp))) {
+		IWL_ERR(mvm, "Invalid TIME_EVENT_NOTIFICATION response\n");
+		return true;
+	}
+
+	resp = (void *)pkt->data;
+
+	/* te_data->uid is already set in the TIME_EVENT_CMD response */
+	if (le32_to_cpu(resp->unique_id) != te_data->uid)
+		return false;
+
+	IWL_DEBUG_TE(mvm, "TIME_EVENT_NOTIFICATION response - UID = 0x%x\n",
+		     te_data->uid);
+	if (!resp->status)
+		IWL_ERR(mvm,
+			"TIME_EVENT_NOTIFICATION received but not executed\n");
+
+	return true;
+}
+
 static bool iwl_mvm_time_event_response(struct iwl_notif_wait_data *notif_wait,
 					struct iwl_rx_packet *pkt, void *data)
 {
@@ -441,10 +473,12 @@ static int iwl_mvm_time_event_send_add(struct iwl_mvm *mvm,
 void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     u32 duration, u32 min_duration,
-			     u32 max_delay)
+			     u32 max_delay, bool wait_for_notif)
 {
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->time_event_data;
+	const u8 te_notif_response[] = { TIME_EVENT_NOTIFICATION };
+	struct iwl_notification_wait wait_te_notif;
 	struct iwl_time_event_cmd time_cmd = {};
 
 	lockdep_assert_held(&mvm->mutex);
@@ -489,7 +523,28 @@ void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 				      TE_V2_NOTIF_HOST_EVENT_END |
 				      T2_V2_START_IMMEDIATELY);
 
-	iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
+	if (!wait_for_notif) {
+		iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd);
+		return;
+	}
+
+	/*
+	 * Create notification_wait for the TIME_EVENT_NOTIFICATION to use
+	 * right after we send the time event
+	 */
+	iwl_init_notification_wait(&mvm->notif_wait, &wait_te_notif,
+				   te_notif_response,
+				   ARRAY_SIZE(te_notif_response),
+				   iwl_mvm_te_notif, te_data);
+
+	/* If TE was sent OK - wait for the notification that started */
+	if (iwl_mvm_time_event_send_add(mvm, vif, te_data, &time_cmd)) {
+		IWL_ERR(mvm, "Failed to add TE to protect session\n");
+		iwl_remove_notification(&mvm->notif_wait, &wait_te_notif);
+	} else if (iwl_wait_notification(&mvm->notif_wait, &wait_te_notif,
+					 TU_TO_JIFFIES(max_delay))) {
+		IWL_ERR(mvm, "Failed to protect session until TE\n");
+	}
 }
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/mvm/time-event.h b/drivers/net/wireless/iwlwifi/mvm/time-event.h
index 2f48a90..9126379 100644
--- a/drivers/net/wireless/iwlwifi/mvm/time-event.h
+++ b/drivers/net/wireless/iwlwifi/mvm/time-event.h
@@ -124,10 +124,12 @@
  * @min_duration: will start a new session if the current session will end
  *	in less than min_duration.
  * @max_delay: maximum delay before starting the time event (in TU)
+ * @wait_for_notif: true if it is required that a time event notification be
+ *	waited for (that the time event has been scheduled before returning)
  *
  * This function can be used to start a session protection which means that the
  * fw will stay on the channel for %duration_ms milliseconds. This function
- * will block (sleep) until the session starts. This function can also be used
+ * can block (sleep) until the session starts. This function can also be used
  * to extend a currently running session.
  * This function is meant to be used for BSS association for example, where we
  * want to make sure that the fw stays on the channel during the association.
@@ -135,7 +137,7 @@
 void iwl_mvm_protect_session(struct iwl_mvm *mvm,
 			     struct ieee80211_vif *vif,
 			     u32 duration, u32 min_duration,
-			     u32 max_delay);
+			     u32 max_delay, bool wait_for_notif);
 
 /**
  * iwl_mvm_stop_session_protection - cancel the session protection.
-- 
1.9.1

