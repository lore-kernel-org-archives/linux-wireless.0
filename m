Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:38901 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754418Ab3HPLJR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Aug 2013 07:09:17 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Subject: [PATCH 19/20] iwlwifi: mvm: Implement CQM offloading
Date: Fri, 16 Aug 2013 13:07:09 +0200
Message-Id: <1376651230-1060-19-git-send-email-johannes@sipsolutions.net> (sfid-20130816_130920_884072_408681EC)
In-Reply-To: <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
References: <1376651161.15299.24.camel@jlt4.sipsolutions.net>
 <1376651230-1060-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

Use beacon statistics notification to track RSSI.
Notify mac80211 when the tresholds are crossed.
The roaming treshold is configured to be
equal to cqm_thold. If the beacon filtering command
is not supported by fw fall back and use mac80211
mechanism.

Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/debugfs.c  |  2 +-
 drivers/net/wireless/iwlwifi/mvm/fw-api.h   |  2 +-
 drivers/net/wireless/iwlwifi/mvm/mac80211.c | 22 +++++++++--
 drivers/net/wireless/iwlwifi/mvm/mvm.h      | 20 +++++++++-
 drivers/net/wireless/iwlwifi/mvm/power.c    | 37 +++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/rx.c       | 61 ++++++++++++++++++++++++++++-
 6 files changed, 133 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/debugfs.c b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
index 14811a5..c67b17a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/debugfs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/debugfs.c
@@ -920,7 +920,7 @@ static ssize_t iwl_dbgfs_bf_params_read(struct file *file,
 	};
 
 	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
-	if (mvmvif->bf_enabled)
+	if (mvmvif->bf_data.bf_enabled)
 		cmd.bf_enable_beacon_filter = cpu_to_le32(1);
 	else
 		cmd.bf_enable_beacon_filter = 0;
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index b104710..66264cc 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1321,7 +1321,7 @@ struct mvm_statistics_general {
 	struct mvm_statistics_general_common common;
 	__le32 beacon_filtered;
 	__le32 missed_beacons;
-	__s8 beacon_filter_everage_energy;
+	__s8 beacon_filter_average_energy;
 	__s8 beacon_filter_reason;
 	__s8 beacon_filter_current_energy;
 	__s8 beacon_filter_reserved;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
index 66803b9..692d2ea 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/iwlwifi/mvm/mac80211.c
@@ -575,7 +575,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
 	    vif->type == NL80211_IFTYPE_STATION && !vif->p2p &&
 	    mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_BF_UPDATED){
 		mvm->bf_allowed_vif = mvmvif;
-		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER;
+		vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
+				     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
 	}
 
 	/*
@@ -615,7 +616,8 @@ static int iwl_mvm_mac_add_interface(struct ieee80211_hw *hw,
  out_free_bf:
 	if (mvm->bf_allowed_vif == mvmvif) {
 		mvm->bf_allowed_vif = NULL;
-		vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
+		vif->driver_flags &= ~(IEEE80211_VIF_BEACON_FILTER |
+				       IEEE80211_VIF_SUPPORTS_CQM_RSSI);
 	}
  out_remove_mac:
 	mvmvif->phy_ctxt = NULL;
@@ -681,7 +683,8 @@ static void iwl_mvm_mac_remove_interface(struct ieee80211_hw *hw,
 
 	if (mvm->bf_allowed_vif == mvmvif) {
 		mvm->bf_allowed_vif = NULL;
-		vif->driver_flags &= ~IEEE80211_VIF_BEACON_FILTER;
+		vif->driver_flags &= ~(IEEE80211_VIF_BEACON_FILTER |
+				       IEEE80211_VIF_SUPPORTS_CQM_RSSI);
 	}
 
 	iwl_mvm_vif_dbgfs_clean(mvm, vif);
@@ -799,6 +802,10 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 			if (ret)
 				IWL_ERR(mvm, "failed to update quotas\n");
 		}
+
+		/* reset rssi values */
+		mvmvif->bf_data.ave_beacon_signal = 0;
+
 		if (!(mvm->fw->ucode_capa.flags & IWL_UCODE_TLV_FLAGS_UAPSD)) {
 			/* Workaround for FW bug, otherwise FW disables device
 			 * power save upon disassociation
@@ -825,6 +832,15 @@ static void iwl_mvm_bss_info_changed_station(struct iwl_mvm *mvm,
 				bss_conf->txpower);
 		iwl_mvm_set_tx_power(mvm, vif, bss_conf->txpower);
 	}
+
+	if (changes & BSS_CHANGED_CQM) {
+		IWL_DEBUG_MAC80211(mvm, "cqm info_changed");
+		/* reset cqm events tracking */
+		mvmvif->bf_data.last_cqm_event = 0;
+		ret = iwl_mvm_update_beacon_filter(mvm, vif);
+		if (ret)
+			IWL_ERR(mvm, "failed to update CQM thresholds\n");
+	}
 }
 
 static int iwl_mvm_start_ap(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index 014d779..ee46dea 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -233,6 +233,21 @@ enum iwl_mvm_smps_type_request {
 };
 
 /**
+* struct iwl_mvm_vif_bf_data - beacon filtering related data
+* @bf_enabled: indicates if beacon filtering is enabled
+* @ba_enabled: indicated if beacon abort is enabled
+* @last_beacon_signal: last beacon rssi signal in dbm
+* @ave_beacon_signal: average beacon signal
+* @last_cqm_event: rssi of the last cqm event
+*/
+struct iwl_mvm_vif_bf_data {
+	bool bf_enabled;
+	bool ba_enabled;
+	s8 ave_beacon_signal;
+	s8 last_cqm_event;
+};
+
+/**
  * struct iwl_mvm_vif - data per Virtual Interface, it is a MAC context
  * @id: between 0 and 3
  * @color: to solve races upon MAC addition and removal
@@ -257,8 +272,7 @@ struct iwl_mvm_vif {
 	bool uploaded;
 	bool ap_active;
 	bool monitor_active;
-	/* indicate whether beacon filtering is enabled */
-	bool bf_enabled;
+	struct iwl_mvm_vif_bf_data bf_data;
 
 	u32 ap_beacon_time;
 
@@ -758,6 +772,8 @@ int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 				   struct iwl_beacon_filter_cmd *cmd);
 int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif, bool enable);
+int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
+				  struct ieee80211_vif *vif);
 
 /* SMPS */
 void iwl_mvm_update_smps(struct iwl_mvm *mvm, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/iwlwifi/mvm/power.c b/drivers/net/wireless/iwlwifi/mvm/power.c
index 9c9b5ba..a5529b8 100644
--- a/drivers/net/wireless/iwlwifi/mvm/power.c
+++ b/drivers/net/wireless/iwlwifi/mvm/power.c
@@ -110,6 +110,23 @@ int iwl_mvm_beacon_filter_send_cmd(struct iwl_mvm *mvm,
 	return ret;
 }
 
+static
+void iwl_mvm_beacon_filter_set_cqm_params(struct iwl_mvm *mvm,
+					  struct ieee80211_vif *vif,
+					  struct iwl_beacon_filter_cmd *cmd)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (vif->bss_conf.cqm_rssi_thold) {
+		cmd->bf_energy_delta =
+			cpu_to_le32(vif->bss_conf.cqm_rssi_hyst);
+		/* fw uses an absolute value for this */
+		cmd->bf_roaming_state =
+			cpu_to_le32(-vif->bss_conf.cqm_rssi_thold);
+	}
+	cmd->ba_enable_beacon_abort = cpu_to_le32(mvmvif->bf_data.ba_enabled);
+}
+
 int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 				struct ieee80211_vif *vif, bool enable)
 {
@@ -120,12 +137,14 @@ int iwl_mvm_update_beacon_abort(struct iwl_mvm *mvm,
 		.ba_enable_beacon_abort = cpu_to_le32(enable),
 	};
 
-	if (!mvmvif->bf_enabled)
+	if (!mvmvif->bf_data.bf_enabled)
 		return 0;
 
 	if (mvm->cur_ucode == IWL_UCODE_WOWLAN)
 		cmd.ba_escape_timer = cpu_to_le32(IWL_BA_ESCAPE_TIMER_D3);
 
+	mvmvif->bf_data.ba_enabled = enable;
+	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, &cmd);
 	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
 	return iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
 }
@@ -510,11 +529,12 @@ int iwl_mvm_enable_beacon_filter(struct iwl_mvm *mvm,
 	    vif->type != NL80211_IFTYPE_STATION || vif->p2p)
 		return 0;
 
+	iwl_mvm_beacon_filter_set_cqm_params(mvm, vif, &cmd);
 	iwl_mvm_beacon_filter_debugfs_parameters(vif, &cmd);
 	ret = iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
 
 	if (!ret)
-		mvmvif->bf_enabled = true;
+		mvmvif->bf_data.bf_enabled = true;
 
 	return ret;
 }
@@ -533,11 +553,22 @@ int iwl_mvm_disable_beacon_filter(struct iwl_mvm *mvm,
 	ret = iwl_mvm_beacon_filter_send_cmd(mvm, &cmd);
 
 	if (!ret)
-		mvmvif->bf_enabled = false;
+		mvmvif->bf_data.bf_enabled = false;
 
 	return ret;
 }
 
+int iwl_mvm_update_beacon_filter(struct iwl_mvm *mvm,
+				 struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (!mvmvif->bf_data.bf_enabled)
+		return 0;
+
+	return iwl_mvm_enable_beacon_filter(mvm, vif);
+}
+
 const struct iwl_mvm_power_ops pm_mac_ops = {
 	.power_update_mode = iwl_mvm_power_mac_update_mode,
 	.power_disable = iwl_mvm_power_mac_disable,
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index ee6547d..2a8cb5a 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -396,11 +396,62 @@ static void iwl_mvm_update_rx_statistics(struct iwl_mvm *mvm,
 	memcpy(&mvm->rx_stats, &stats->rx, sizeof(struct mvm_statistics_rx));
 }
 
+struct iwl_mvm_stat_data {
+	struct iwl_notif_statistics *stats;
+	struct iwl_mvm *mvm;
+};
+
+static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
+				  struct ieee80211_vif *vif)
+{
+	struct iwl_mvm_stat_data *data = _data;
+	struct iwl_notif_statistics *stats = data->stats;
+	struct iwl_mvm *mvm = data->mvm;
+	int sig = -stats->general.beacon_filter_average_energy;
+	int last_event;
+	int thold = vif->bss_conf.cqm_rssi_thold;
+	int hyst = vif->bss_conf.cqm_rssi_hyst;
+	u16 id = le32_to_cpu(stats->rx.general.mac_id);
+	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
+
+	if (mvmvif->id != id)
+		return;
+
+	if (vif->type != NL80211_IFTYPE_STATION)
+		return;
+
+	mvmvif->bf_data.ave_beacon_signal = sig;
+
+	if (!(vif->driver_flags & IEEE80211_VIF_SUPPORTS_CQM_RSSI))
+		return;
+
+	/* CQM Notification */
+	last_event = mvmvif->bf_data.last_cqm_event;
+	if (thold && sig < thold && (last_event == 0 ||
+				     sig < last_event - hyst)) {
+		mvmvif->bf_data.last_cqm_event = sig;
+		IWL_DEBUG_RX(mvm, "cqm_iterator cqm low %d\n",
+			     sig);
+		ieee80211_cqm_rssi_notify(
+			vif,
+			NL80211_CQM_RSSI_THRESHOLD_EVENT_LOW,
+			GFP_KERNEL);
+	} else if (sig > thold &&
+		   (last_event == 0 || sig > last_event + hyst)) {
+		mvmvif->bf_data.last_cqm_event = sig;
+		IWL_DEBUG_RX(mvm, "cqm_iterator cqm high %d\n",
+			     sig);
+		ieee80211_cqm_rssi_notify(
+			vif,
+			NL80211_CQM_RSSI_THRESHOLD_EVENT_HIGH,
+			GFP_KERNEL);
+	}
+}
+
 /*
  * iwl_mvm_rx_statistics - STATISTICS_NOTIFICATION handler
  *
  * TODO: This handler is implemented partially.
- * It only gets the NIC's temperature.
  */
 int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 			  struct iwl_rx_cmd_buffer *rxb,
@@ -409,6 +460,10 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_notif_statistics *stats = (void *)&pkt->data;
 	struct mvm_statistics_general_common *common = &stats->general.common;
+	struct iwl_mvm_stat_data data = {
+		.stats = stats,
+		.mvm = mvm,
+	};
 
 	if (mvm->temperature != le32_to_cpu(common->temperature)) {
 		mvm->temperature = le32_to_cpu(common->temperature);
@@ -416,5 +471,9 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 	}
 	iwl_mvm_update_rx_statistics(mvm, stats);
 
+	ieee80211_iterate_active_interfaces(mvm->hw,
+					    IEEE80211_IFACE_ITER_NORMAL,
+					    iwl_mvm_stat_iterator,
+					    &data);
 	return 0;
 }
-- 
1.8.4.rc2

