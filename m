Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:62122 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756083AbbLAKAM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2015 05:00:12 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Matti Gottlieb <matti.gottlieb@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 40/41] iwlwifi: mvm: ROC: Extend the ROC max delay duration & limit ROC duration
Date: Tue,  1 Dec 2015 11:59:06 +0200
Message-Id: <1448963947-24302-40-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151201_112252_193373_797C8D49)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E905B07@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Matti Gottlieb <matti.gottlieb@intel.com>

When associated to an AP and a ROC event with a long duration is scheduled
the FW may have a hard time scheduling a consecutive time event, since it
has to remain on the connection channel to hear the AP's DTIM.
In addition, when associated and a ROC is requested with a duration
greater than the DTIM interval, the FW will not be able to schedule
the ROC event, since it needs to wake up for the DTIM.

Increasing the "max delay" duration to the DTIM period will allow the FW to
wait until after the DTIM and then schedule the ROC time event.
Limiting the ROC to be less than the DTIM interval will assure that the
time event will be scheduled for at least part of the time (instead of
automatically failing)

Extend the ROC max delay duration to min(dtim_interval * 3, 600TU),
and limit the duration to be less than the DTIM interval.

Signed-off-by: Matti Gottlieb <matti.gottlieb@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 42 ++++++++++++++++++++---
 1 file changed, 38 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 327703d..a90f1ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -2707,7 +2707,11 @@ static bool iwl_mvm_rx_aux_roc(struct iwl_notif_wait_data *notif_wait,
 	return true;
 }
 
-#define AUX_ROC_MAX_DELAY_ON_CHANNEL 200
+#define AUX_ROC_MIN_DURATION MSEC_TO_TU(100)
+#define AUX_ROC_MIN_DELAY MSEC_TO_TU(200)
+#define AUX_ROC_MAX_DELAY MSEC_TO_TU(600)
+#define AUX_ROC_SAFETY_BUFFER MSEC_TO_TU(20)
+#define AUX_ROC_MIN_SAFETY_BUFFER MSEC_TO_TU(10)
 static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 				    struct ieee80211_channel *channel,
 				    struct ieee80211_vif *vif,
@@ -2718,6 +2722,9 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 	struct iwl_mvm_time_event_data *te_data = &mvmvif->hs_time_event_data;
 	static const u16 time_event_response[] = { HOT_SPOT_CMD };
 	struct iwl_notification_wait wait_time_event;
+	u32 dtim_interval = vif->bss_conf.dtim_period *
+		vif->bss_conf.beacon_int;
+	u32 req_dur, delay;
 	struct iwl_hs20_roc_req aux_roc_req = {
 		.action = cpu_to_le32(FW_CTXT_ACTION_ADD),
 		.id_and_color =
@@ -2730,11 +2737,38 @@ static int iwl_mvm_send_aux_roc_cmd(struct iwl_mvm *mvm,
 		.channel_info.width = PHY_VHT_CHANNEL_MODE20,
 		/* Set the time and duration */
 		.apply_time = cpu_to_le32(iwl_read_prph(mvm->trans, time_reg)),
-		.apply_time_max_delay =
-			cpu_to_le32(MSEC_TO_TU(AUX_ROC_MAX_DELAY_ON_CHANNEL)),
-		.duration = cpu_to_le32(MSEC_TO_TU(duration)),
 	 };
 
+	delay = AUX_ROC_MIN_DELAY;
+	req_dur = MSEC_TO_TU(duration);
+
+	/*
+	 * If we are associated we want the delay time to be at least one
+	 * dtim interval so that the FW can wait until after the DTIM and
+	 * then start the time event, this will potentially allow us to
+	 * remain off-channel for the max duration.
+	 * Since we want to use almost a whole dtim interval we would also
+	 * like the delay to be for 2-3 dtim intervals, in case there are
+	 * other time events with higher priority.
+	 */
+	if (vif->bss_conf.assoc) {
+		delay = min_t(u32, dtim_interval * 3, AUX_ROC_MAX_DELAY);
+		/* We cannot remain off-channel longer than the DTIM interval */
+		if (dtim_interval <= req_dur) {
+			req_dur = dtim_interval - AUX_ROC_SAFETY_BUFFER;
+			if (req_dur <= AUX_ROC_MIN_DURATION)
+				req_dur = dtim_interval -
+					AUX_ROC_MIN_SAFETY_BUFFER;
+		}
+	}
+
+	aux_roc_req.duration = cpu_to_le32(req_dur);
+	aux_roc_req.apply_time_max_delay = cpu_to_le32(delay);
+
+	IWL_DEBUG_TE(mvm,
+		     "ROC: Requesting to remain on channel %u for %ums (requested = %ums, max_delay = %ums, dtim_interval = %ums)\n",
+		     channel->hw_value, req_dur, duration, delay,
+		     dtim_interval);
 	/* Set the node address */
 	memcpy(aux_roc_req.node_addr, vif->addr, ETH_ALEN);
 
-- 
2.5.0

