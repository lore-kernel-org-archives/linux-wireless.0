Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24100 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbbCATc0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:26 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 17/31] iwlwifi: mvm: support beacon statistics for BSS client
Date: Sun,  1 Mar 2015 21:31:30 +0200
Message-Id: <1425238304-498-17-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203418_534398_33CF5129)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Report the average beacon signal and the number of received beacons as
measured by the firmware.

Since the firmware just counts, and doesn't reset the counter at all,
clear it in the firmware whenever we associate. However, accumulate it
over firmware restart.

Since clearing the statistics in the firmware will also clear the ones
for the radio statistics, add those to the accumulator when cleared.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 53 ++++++++++++++++++++++++++++-
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 10 +++++-
 drivers/net/wireless/iwlwifi/mvm/rx.c       | 14 ++++++++
 drivers/net/wireless/iwlwifi/mvm/utils.c    |  9 +++--
 4 files changed, 82 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 0f986d7..ce5a5ff 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -1322,6 +1322,11 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 
 	mutex_lock(&mvm->mutex);
 
+	/* make sure that beacon statistics don't go backwards with FW reset */
+	if (test_bit(IWL_MVM_STATUS_IN_HW_RESTART, &mvm->status))
+		mvmvif->beacon_stats.accu_num_beacons +=
+			mvmvif->beacon_stats.num_beacons;
+
 	/* Allocate resources for the MAC context, and add it to the fw  */
 	ret = iwl_mvm_mac_ctxt_init(mvm, vif);
 	if (ret)
@@ -1815,6 +1820,11 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 
 	if (changes & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
+			/* clear statistics to get clean beacon counter */
+			iwl_mvm_request_statistics(mvm, true);
+			memset(&mvmvif->beacon_stats, 0,
+			       sizeof(mvmvif->beacon_stats));
+
 			/* add quota for this interface */
 			ret = iwl_mvm_update_quotas(mvm, NULL);
 			if (ret) {
@@ -3597,7 +3607,7 @@ static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
 	mutex_lock(&mvm->mutex);
 
 	if (mvm->ucode_loaded) {
-		ret = iwl_mvm_request_statistics(mvm);
+		ret = iwl_mvm_request_statistics(mvm, false);
 		if (ret)
 			goto out;
 	}
@@ -3627,6 +3637,46 @@ static int iwl_mvm_mac_get_survey(struct ieee80211_hw *hw, int idx,
 	return ret;
 }
 
+static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
+				       struct ieee80211_vif *vif,
+				       struct ieee80211_sta *sta,
+				       struct station_info *sinfo)
+{
+	struct iwl_mvm *mvm = IWL_MAC80211_GET_MVM(hw);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
+
+	if (!(mvm->fw->ucode_capa.capa[0] &
+				IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
+		return;
+
+	/* if beacon filtering isn't on mac80211 does it anyway */
+	if (!(vif->driver_flags & IEEE80211_VIF_BEACON_FILTER))
+		return;
+
+	if (!vif->bss_conf.assoc)
+		return;
+
+	mutex_lock(&mvm->mutex);
+
+	if (mvmvif->ap_sta_id != mvmsta->sta_id)
+		goto unlock;
+
+	if (iwl_mvm_request_statistics(mvm, false))
+		goto unlock;
+
+	sinfo->rx_beacon = mvmvif->beacon_stats.num_beacons +
+			   mvmvif->beacon_stats.accu_num_beacons;
+	sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_RX);
+	if (mvmvif->beacon_stats.avg_signal) {
+		/* firmware only reports a value after RXing a few beacons */
+		sinfo->rx_beacon_signal_avg = mvmvif->beacon_stats.avg_signal;
+		sinfo->filled |= BIT(NL80211_STA_INFO_BEACON_SIGNAL_AVG);
+	}
+ unlock:
+	mutex_unlock(&mvm->mutex);
+}
+
 const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.tx = iwl_mvm_mac_tx,
 	.ampdu_action = iwl_mvm_mac_ampdu_action,
@@ -3694,4 +3744,5 @@ const struct ieee80211_ops iwl_mvm_hw_ops = {
 	.set_default_unicast_key = iwl_mvm_set_default_unicast_key,
 #endif
 	.get_survey = iwl_mvm_mac_get_survey,
+	.sta_statistics = iwl_mvm_mac_sta_statistics,
 };
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 90a1ea3..5e383db 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -337,6 +337,9 @@ struct iwl_mvm_vif_bf_data {
  * @beacon_skb: the skb used to hold the AP/GO beacon template
  * @smps_requests: the SMPS requests of differents parts of the driver,
  *	combined on update to yield the overall request to mac80211.
+ * @beacon_stats: beacon statistics, containing the # of received beacons,
+ *	# of received beacons accumulated over FW restart, and the current
+ *	average signal of beacons retrieved from the firmware
  */
 struct iwl_mvm_vif {
 	u16 id;
@@ -354,6 +357,11 @@ struct iwl_mvm_vif {
 	bool ps_disabled;
 	struct iwl_mvm_vif_bf_data bf_data;
 
+	struct {
+		u32 num_beacons, accu_num_beacons;
+		u8 avg_signal;
+	} beacon_stats;
+
 	u32 ap_beacon_time;
 
 	enum iwl_tsf_id tsf_id;
@@ -963,7 +971,7 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 			  struct iwl_rx_cmd_buffer *rxb,
 			  struct iwl_device_cmd *cmd);
-int iwl_mvm_request_statistics(struct iwl_mvm *mvm);
+int iwl_mvm_request_statistics(struct iwl_mvm *mvm, bool clear);
 void iwl_mvm_accu_radio_stats(struct iwl_mvm *mvm);
 
 /* NVM */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 2486931..b86ff66 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -427,6 +427,7 @@ struct iwl_mvm_stat_data {
 	struct iwl_mvm *mvm;
 	__le32 mac_id;
 	__s8 beacon_filter_average_energy;
+	struct mvm_statistics_general_v8 *general;
 };
 
 static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
@@ -441,6 +442,17 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 	u16 id = le32_to_cpu(data->mac_id);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
+	/* This doesn't need the MAC ID check since it's not taking the
+	 * data copied into the "data" struct, but rather the data from
+	 * the notification directly.
+	 */
+	if (data->general) {
+		mvmvif->beacon_stats.num_beacons =
+			le32_to_cpu(data->general->beacon_counter[mvmvif->id]);
+		mvmvif->beacon_stats.avg_signal =
+			-data->general->beacon_average_energy[mvmvif->id];
+	}
+
 	if (mvmvif->id != id)
 		return;
 
@@ -525,6 +537,8 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 			le64_to_cpu(stats->general.on_time_rf);
 		mvm->radio_stats.on_time_scan =
 			le64_to_cpu(stats->general.on_time_scan);
+
+		data.general = &stats->general;
 	} else {
 		struct iwl_notif_statistics_v8 *stats = (void *)&pkt->data;
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/utils.c b/drivers/net/wireless/iwlwifi/mvm/utils.c
index 8bdfb8b..a501223 100644
--- a/drivers/net/wireless/iwlwifi/mvm/utils.c
+++ b/drivers/net/wireless/iwlwifi/mvm/utils.c
@@ -643,9 +643,11 @@ void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
 	ieee80211_request_smps(vif, smps_mode);
 }
 
-int iwl_mvm_request_statistics(struct iwl_mvm *mvm)
+int iwl_mvm_request_statistics(struct iwl_mvm *mvm, bool clear)
 {
-	struct iwl_statistics_cmd scmd = {};
+	struct iwl_statistics_cmd scmd = {
+		.flags = clear ? cpu_to_le32(IWL_STATISTICS_FLG_CLEAR) : 0,
+	};
 	struct iwl_host_cmd cmd = {
 		.id = STATISTICS_CMD,
 		.len[0] = sizeof(scmd),
@@ -661,6 +663,9 @@ int iwl_mvm_request_statistics(struct iwl_mvm *mvm)
 	iwl_mvm_handle_rx_statistics(mvm, cmd.resp_pkt);
 	iwl_free_resp(&cmd);
 
+	if (clear)
+		iwl_mvm_accu_radio_stats(mvm);
+
 	return 0;
 }
 
-- 
1.9.1

