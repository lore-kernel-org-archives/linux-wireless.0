Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:37870 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753431AbdBCOia (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Feb 2017 09:38:30 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri,  3 Feb 2017 16:37:53 +0200
Message-Id: <20170203143812.7525-7-luca@coelho.fi> (sfid-20170203_153844_020269_C823E1EE)
In-Reply-To: <20170203143812.7525-1-luca@coelho.fi>
References: <20170203143812.7525-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: support new statistics APIs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For CDB arch there is another auxiliary mac.
Support statistics APIs that were changed to reflect that.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |  7 ++-
 .../net/wireless/intel/iwlwifi/mvm/fw-api-stats.h  | 29 ++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/mvm.h       | 13 ++++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 70 ++++++++++++++++------
 4 files changed, 97 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
index 0246506ab595..480a54af4534 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
@@ -64,13 +64,14 @@
 #define __fw_api_mac_h__
 
 /*
- * The first MAC indices (starting from 0)
- * are available to the driver, AUX follows
+ * The first MAC indices (starting from 0) are available to the driver,
+ * AUX indices follows - 1 for non-CDB, 2 for CDB.
  */
 #define MAC_INDEX_AUX		4
 #define MAC_INDEX_MIN_DRIVER	0
 #define NUM_MAC_INDEX_DRIVER	MAC_INDEX_AUX
-#define NUM_MAC_INDEX		(MAC_INDEX_AUX + 1)
+#define NUM_MAC_INDEX		(NUM_MAC_INDEX_DRIVER + 1)
+#define NUM_MAC_INDEX_CDB	(NUM_MAC_INDEX_DRIVER + 2)
 
 #define IWL_MVM_STATION_COUNT	16
 #define IWL_MVM_TDLS_STA_COUNT	4
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
index 4e638a44babb..6371c342b96d 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
@@ -220,7 +220,7 @@ struct mvm_statistics_bt_activity {
 	__le32 lo_priority_rx_denied_cnt;
 } __packed;  /* STATISTICS_BT_ACTIVITY_API_S_VER_1 */
 
-struct mvm_statistics_general_v8 {
+struct mvm_statistics_general_common {
 	__le32 radio_temperature;
 	__le32 radio_voltage;
 	struct mvm_statistics_dbg dbg;
@@ -248,11 +248,22 @@ struct mvm_statistics_general_v8 {
 	__le64 on_time_rf;
 	__le64 on_time_scan;
 	__le64 tx_time;
+} __packed;
+
+struct mvm_statistics_general_v8 {
+	struct mvm_statistics_general_common common;
 	__le32 beacon_counter[NUM_MAC_INDEX];
 	u8 beacon_average_energy[NUM_MAC_INDEX];
 	u8 reserved[4 - (NUM_MAC_INDEX % 4)];
 } __packed; /* STATISTICS_GENERAL_API_S_VER_8 */
 
+struct mvm_statistics_general_cdb {
+	struct mvm_statistics_general_common common;
+	__le32 beacon_counter[NUM_MAC_INDEX_CDB];
+	u8 beacon_average_energy[NUM_MAC_INDEX_CDB];
+	u8 reserved[4 - (NUM_MAC_INDEX_CDB % 4)];
+} __packed; /* STATISTICS_GENERAL_API_S_VER_9 */
+
 /**
  * struct mvm_statistics_load - RX statistics for multi-queue devices
  * @air_time: accumulated air time, per mac
@@ -267,6 +278,13 @@ struct mvm_statistics_load {
 	u8 avg_energy[IWL_MVM_STATION_COUNT];
 } __packed; /* STATISTICS_RX_MAC_STATION_S_VER_1 */
 
+struct mvm_statistics_load_cdb {
+	__le32 air_time[NUM_MAC_INDEX_CDB];
+	__le32 byte_count[NUM_MAC_INDEX_CDB];
+	__le32 pkt_count[NUM_MAC_INDEX_CDB];
+	u8 avg_energy[IWL_MVM_STATION_COUNT];
+} __packed; /* STATISTICS_RX_MAC_STATION_S_VER_2 */
+
 struct mvm_statistics_rx {
 	struct mvm_statistics_rx_phy ofdm;
 	struct mvm_statistics_rx_phy cck;
@@ -281,6 +299,7 @@ struct mvm_statistics_rx {
  * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
  * STATISTICS_CMD (0x9c), below.
  */
+
 struct iwl_notif_statistics_v10 {
 	__le32 flag;
 	struct mvm_statistics_rx rx;
@@ -296,6 +315,14 @@ struct iwl_notif_statistics_v11 {
 	struct mvm_statistics_load load_stats;
 } __packed; /* STATISTICS_NTFY_API_S_VER_11 */
 
+struct iwl_notif_statistics_cdb {
+	__le32 flag;
+	struct mvm_statistics_rx rx;
+	struct mvm_statistics_tx tx;
+	struct mvm_statistics_general_cdb general;
+	struct mvm_statistics_load_cdb load_stats;
+} __packed; /* STATISTICS_NTFY_API_S_VER_12 */
+
 #define IWL_STATISTICS_FLG_CLEAR		0x1
 #define IWL_STATISTICS_FLG_DISABLE_NOTIF	0x2
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
index 74156b24da16..37a4a980beee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mvm.h
@@ -1218,6 +1218,19 @@ static inline bool iwl_mvm_has_new_tx_api(struct iwl_mvm *mvm)
 	return mvm->trans->cfg->use_tfh;
 }
 
+static inline bool iwl_mvm_is_cdb_supported(struct iwl_mvm *mvm)
+{
+	/*
+	 * TODO:
+	 * The issue of how to determine CDB support is still not well defined.
+	 * It may be that it will be for all next HW devices and it may be per
+	 * FW compilation and it may also differ between different devices.
+	 * For now take a ride on the new TX API and get back to it when
+	 * it is well defined.
+	 */
+	return iwl_mvm_has_new_tx_api(mvm);
+}
+
 static inline bool iwl_mvm_is_tt_in_fw(struct iwl_mvm *mvm)
 {
 #ifdef CONFIG_THERMAL
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index e16687d5afaa..e90c1c12a36c 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -497,8 +497,7 @@ struct iwl_mvm_stat_data {
 	struct iwl_mvm *mvm;
 	__le32 mac_id;
 	u8 beacon_filter_average_energy;
-	struct mvm_statistics_general_v8 *general;
-	struct mvm_statistics_load *load;
+	void *general;
 };
 
 static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
@@ -518,10 +517,26 @@ static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 	 * the notification directly.
 	 */
 	if (data->general) {
-		mvmvif->beacon_stats.num_beacons =
-			le32_to_cpu(data->general->beacon_counter[mvmvif->id]);
-		mvmvif->beacon_stats.avg_signal =
-			-data->general->beacon_average_energy[mvmvif->id];
+		u16 vif_id = mvmvif->id;
+
+		if (iwl_mvm_is_cdb_supported(mvm)) {
+			struct mvm_statistics_general_cdb *general =
+				data->general;
+
+			mvmvif->beacon_stats.num_beacons =
+				le32_to_cpu(general->beacon_counter[vif_id]);
+			mvmvif->beacon_stats.avg_signal =
+				-general->beacon_average_energy[vif_id];
+		} else {
+			struct mvm_statistics_general_v8 *general =
+				data->general;
+
+			mvmvif->beacon_stats.num_beacons =
+				le32_to_cpu(general->beacon_counter[vif_id]);
+			mvmvif->beacon_stats.avg_signal =
+				-general->beacon_average_energy[vif_id];
+		}
+
 	}
 
 	if (mvmvif->id != id)
@@ -615,46 +630,65 @@ iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 				  struct iwl_rx_packet *pkt)
 {
-	struct iwl_notif_statistics_v11 *stats = (void *)&pkt->data;
+	struct iwl_notif_statistics_cdb *stats = (void *)&pkt->data;
 	struct iwl_mvm_stat_data data = {
 		.mvm = mvm,
 	};
-	int expected_size = iwl_mvm_has_new_rx_api(mvm) ? sizeof(*stats) :
-			    sizeof(struct iwl_notif_statistics_v10);
+	int expected_size;
+
+	if (iwl_mvm_is_cdb_supported(mvm))
+		expected_size = sizeof(*stats);
+	else if (iwl_mvm_has_new_rx_api(mvm))
+		expected_size = sizeof(struct iwl_notif_statistics_v11);
+	else
+		expected_size = sizeof(struct iwl_notif_statistics_v10);
 
 	if (iwl_rx_packet_payload_len(pkt) != expected_size)
 		goto invalid;
 
 	data.mac_id = stats->rx.general.mac_id;
 	data.beacon_filter_average_energy =
-		stats->general.beacon_filter_average_energy;
+		stats->general.common.beacon_filter_average_energy;
 
 	iwl_mvm_update_rx_statistics(mvm, &stats->rx);
 
-	mvm->radio_stats.rx_time = le64_to_cpu(stats->general.rx_time);
-	mvm->radio_stats.tx_time = le64_to_cpu(stats->general.tx_time);
+	mvm->radio_stats.rx_time = le64_to_cpu(stats->general.common.rx_time);
+	mvm->radio_stats.tx_time = le64_to_cpu(stats->general.common.tx_time);
 	mvm->radio_stats.on_time_rf =
-		le64_to_cpu(stats->general.on_time_rf);
+		le64_to_cpu(stats->general.common.on_time_rf);
 	mvm->radio_stats.on_time_scan =
-		le64_to_cpu(stats->general.on_time_scan);
+		le64_to_cpu(stats->general.common.on_time_scan);
 
 	data.general = &stats->general;
 	if (iwl_mvm_has_new_rx_api(mvm)) {
 		int i;
-
-		data.load = &stats->load_stats;
+		u8 *energy;
+		__le32 *bytes, *air_time;
+
+		if (!iwl_mvm_is_cdb_supported(mvm)) {
+			struct iwl_notif_statistics_v11 *v11 =
+				(void *)&pkt->data;
+
+			energy = (void *)&v11->load_stats.avg_energy;
+			bytes = (void *)&v11->load_stats.byte_count;
+			air_time = (void *)&v11->load_stats.air_time;
+		} else {
+			energy = (void *)&stats->load_stats.avg_energy;
+			bytes = (void *)&stats->load_stats.byte_count;
+			air_time = (void *)&stats->load_stats.air_time;
+		}
 
 		rcu_read_lock();
 		for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
 			struct iwl_mvm_sta *sta;
 
-			if (!data.load->avg_energy[i])
+			if (!energy[i])
 				continue;
 
 			sta = iwl_mvm_sta_from_staid_rcu(mvm, i);
 			if (!sta)
 				continue;
-			sta->avg_energy = data.load->avg_energy[i];
+			sta->avg_energy = energy[i];
 		}
 		rcu_read_unlock();
 	}
-- 
2.11.0
