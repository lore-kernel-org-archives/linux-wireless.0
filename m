Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33362 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751832AbcGFKoN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:13 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:21 +0300
Message-Id: <1467801651-1816-26-git-send-email-luca@coelho.fi> (sfid-20160706_124425_990426_4C0B6DE9)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 26/56] iwlwifi: mvm: support new statistics notification
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

For 9000 family we will get extended statistics notification
with averaged data for RSSI, TCM and rogue AP detection.
Support it. Future patches will added the required algorithms.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 .../net/wireless/intel/iwlwifi/mvm/fw-api-mac.h    |  3 +++
 .../net/wireless/intel/iwlwifi/mvm/fw-api-stats.h  | 24 +++++++++++++++++++-
 drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h    |  3 ---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  5 +++++
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c        | 26 ++++++++++++++++++++--
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h       |  1 +
 6 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
index 95ac59d..0246506 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-mac.h
@@ -72,6 +72,9 @@
 #define NUM_MAC_INDEX_DRIVER	MAC_INDEX_AUX
 #define NUM_MAC_INDEX		(MAC_INDEX_AUX + 1)
 
+#define IWL_MVM_STATION_COUNT	16
+#define IWL_MVM_TDLS_STA_COUNT	4
+
 enum iwl_ac {
 	AC_BK,
 	AC_BE,
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
index 438665a..4e638a4 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api-stats.h
@@ -7,6 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
+ * Copyright(c) 2016 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -252,6 +253,20 @@ struct mvm_statistics_general_v8 {
 	u8 reserved[4 - (NUM_MAC_INDEX % 4)];
 } __packed; /* STATISTICS_GENERAL_API_S_VER_8 */
 
+/**
+ * struct mvm_statistics_load - RX statistics for multi-queue devices
+ * @air_time: accumulated air time, per mac
+ * @byte_count: accumulated byte count, per mac
+ * @pkt_count: accumulated packet count, per mac
+ * @avg_energy: average RSSI, per station
+ */
+struct mvm_statistics_load {
+	__le32 air_time[NUM_MAC_INDEX];
+	__le32 byte_count[NUM_MAC_INDEX];
+	__le32 pkt_count[NUM_MAC_INDEX];
+	u8 avg_energy[IWL_MVM_STATION_COUNT];
+} __packed; /* STATISTICS_RX_MAC_STATION_S_VER_1 */
+
 struct mvm_statistics_rx {
 	struct mvm_statistics_rx_phy ofdm;
 	struct mvm_statistics_rx_phy cck;
@@ -266,7 +281,6 @@ struct mvm_statistics_rx {
  * while associated.  To disable this behavior, set DISABLE_NOTIF flag in the
  * STATISTICS_CMD (0x9c), below.
  */
-
 struct iwl_notif_statistics_v10 {
 	__le32 flag;
 	struct mvm_statistics_rx rx;
@@ -274,6 +288,14 @@ struct iwl_notif_statistics_v10 {
 	struct mvm_statistics_general_v8 general;
 } __packed; /* STATISTICS_NTFY_API_S_VER_10 */
 
+struct iwl_notif_statistics_v11 {
+	__le32 flag;
+	struct mvm_statistics_rx rx;
+	struct mvm_statistics_tx tx;
+	struct mvm_statistics_general_v8 general;
+	struct mvm_statistics_load load_stats;
+} __packed; /* STATISTICS_NTFY_API_S_VER_11 */
+
 #define IWL_STATISTICS_FLG_CLEAR		0x1
 #define IWL_STATISTICS_FLG_DISABLE_NOTIF	0x2
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
index eea03ec..71076f0 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw-api.h
@@ -129,9 +129,6 @@ enum iwl_mvm_tx_fifo {
 	IWL_MVM_TX_FIFO_CMD = 7,
 };
 
-#define IWL_MVM_STATION_COUNT	16
-
-#define IWL_MVM_TDLS_STA_COUNT	4
 
 /* commands */
 enum {
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index 6b158f0..5c044ea 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -3922,6 +3922,11 @@ static void iwl_mvm_mac_sta_statistics(struct ieee80211_hw *hw,
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 	struct iwl_mvm_sta *mvmsta = iwl_mvm_sta_from_mac80211(sta);
 
+	if (mvmsta->avg_energy) {
+		sinfo->signal_avg = mvmsta->avg_energy;
+		sinfo->filled |= BIT(NL80211_STA_INFO_SIGNAL_AVG);
+	}
+
 	if (fw_has_capa(&mvm->fw->ucode_capa,
 			IWL_UCODE_TLV_CAPA_RADIO_BEACON_STATS))
 		return;
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 2d5a7cc..0e60e38 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -498,6 +498,7 @@ struct iwl_mvm_stat_data {
 	__le32 mac_id;
 	u8 beacon_filter_average_energy;
 	struct mvm_statistics_general_v8 *general;
+	struct mvm_statistics_load *load;
 };
 
 static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
@@ -614,13 +615,15 @@ iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 				  struct iwl_rx_packet *pkt)
 {
-	struct iwl_notif_statistics_v10 *stats = (void *)&pkt->data;
+	struct iwl_notif_statistics_v11 *stats = (void *)&pkt->data;
 	struct iwl_mvm_stat_data data = {
 		.mvm = mvm,
 	};
+	int expected_size = iwl_mvm_has_new_rx_api(mvm) ? sizeof(*stats) :
+			    sizeof(struct iwl_notif_statistics_v10);
 	u32 temperature;
 
-	if (iwl_rx_packet_payload_len(pkt) != sizeof(*stats))
+	if (iwl_rx_packet_payload_len(pkt) != expected_size)
 		goto invalid;
 
 	temperature = le32_to_cpu(stats->general.radio_temperature);
@@ -638,6 +641,25 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		le64_to_cpu(stats->general.on_time_scan);
 
 	data.general = &stats->general;
+	if (iwl_mvm_has_new_rx_api(mvm)) {
+		int i;
+
+		data.load = &stats->load_stats;
+
+		rcu_read_lock();
+		for (i = 0; i < IWL_MVM_STATION_COUNT; i++) {
+			struct iwl_mvm_sta *sta;
+
+			if (!data.load->avg_energy[i])
+				continue;
+
+			sta = iwl_mvm_sta_from_staid_rcu(mvm, i);
+			if (!sta)
+				continue;
+			sta->avg_energy = data.load->avg_energy[i];
+		}
+		rcu_read_unlock();
+	}
 
 	iwl_mvm_rx_stats_check_trigger(mvm, pkt);
 
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 1588eb6..bbc1cab 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -438,6 +438,7 @@ struct iwl_mvm_sta {
 	bool tlc_amsdu;
 	u8 agg_tids;
 	u8 sleep_tx_count;
+	u8 avg_energy;
 };
 
 static inline struct iwl_mvm_sta *
-- 
2.8.1

