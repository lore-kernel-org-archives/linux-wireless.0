Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbbCATcO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:14 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/31] iwlwifi: mvm: add statistics API version 10
Date: Sun,  1 Mar 2015 21:31:25 +0200
Message-Id: <1425238304-498-12-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203418_979288_2C559656)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

New firmware versions will report statistics using a new version 10
of the API, instead of the current version 8. Add support for this.
This enables getting beacon and radio statistics.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  2 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h   |  1 +
 drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h | 47 +++++++++++++++++--
 drivers/net/wireless/iwlwifi/mvm/rx.c           | 62 +++++++++++++++++--------
 4 files changed, 90 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 016d913..4602e3c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -250,6 +250,7 @@ enum iwl_ucode_tlv_flag {
  * @IWL_UCODE_TLV_API_SINGLE_SCAN_EBS: EBS is supported for single scans too.
  * @IWL_UCODE_TLV_API_ASYNC_DTM: Async temperature notifications are supported.
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
+ * @IWL_UCODE_TLV_API_STATS_V10: uCode supports/uses statistics API version 10
  */
 enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_BT_COEX_SPLIT         = BIT(3),
@@ -263,6 +264,7 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_SINGLE_SCAN_EBS	= BIT(16),
 	IWL_UCODE_TLV_API_ASYNC_DTM		= BIT(17),
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= BIT(18),
+	IWL_UCODE_TLV_API_STATS_V10		= BIT(19),
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
index c405cda..aabaedd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-mac.h
@@ -70,6 +70,7 @@
 #define MAC_INDEX_AUX		4
 #define MAC_INDEX_MIN_DRIVER	0
 #define NUM_MAC_INDEX_DRIVER	MAC_INDEX_AUX
+#define NUM_MAC_INDEX		(MAC_INDEX_AUX + 1)
 
 enum iwl_ac {
 	AC_BK,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
index 928168b..5a9dfe0 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
@@ -65,6 +65,7 @@
 
 #ifndef __fw_api_stats_h__
 #define __fw_api_stats_h__
+#include "fw-api-mac.h"
 
 struct mvm_statistics_dbg {
 	__le32 burst_check;
@@ -218,7 +219,7 @@ struct mvm_statistics_bt_activity {
 	__le32 lo_priority_rx_denied_cnt;
 } __packed;  /* STATISTICS_BT_ACTIVITY_API_S_VER_1 */
 
-struct mvm_statistics_general {
+struct mvm_statistics_general_v5 {
 	__le32 radio_temperature;
 	__le32 radio_voltage;
 	struct mvm_statistics_dbg dbg;
@@ -244,6 +245,39 @@ struct mvm_statistics_general {
 	struct mvm_statistics_bt_activity bt_activity;
 } __packed; /* STATISTICS_GENERAL_API_S_VER_5 */
 
+struct mvm_statistics_general_v8 {
+	__le32 radio_temperature;
+	__le32 radio_voltage;
+	struct mvm_statistics_dbg dbg;
+	__le32 sleep_time;
+	__le32 slots_out;
+	__le32 slots_idle;
+	__le32 ttl_timestamp;
+	struct mvm_statistics_div slow_div;
+	__le32 rx_enable_counter;
+	/*
+	 * num_of_sos_states:
+	 *  count the number of times we have to re-tune
+	 *  in order to get out of bad PHY status
+	 */
+	__le32 num_of_sos_states;
+	__le32 beacon_filtered;
+	__le32 missed_beacons;
+	__s8 beacon_filter_average_energy;
+	__s8 beacon_filter_reason;
+	__s8 beacon_filter_current_energy;
+	__s8 beacon_filter_reserved;
+	__le32 beacon_filter_delta_time;
+	struct mvm_statistics_bt_activity bt_activity;
+	__le64 rx_time;
+	__le64 on_time_rf;
+	__le64 on_time_scan;
+	__le64 tx_time;
+	__le32 beacon_counter[NUM_MAC_INDEX];
+	u8 beacon_average_energy[NUM_MAC_INDEX];
+	u8 reserved[4 - (NUM_MAC_INDEX % 4)];
+} __packed; /* STATISTICS_GENERAL_API_S_VER_8 */
+
 struct mvm_statistics_rx {
 	struct mvm_statistics_rx_phy ofdm;
 	struct mvm_statistics_rx_phy cck;
@@ -267,11 +301,18 @@ struct mvm_statistics_rx {
  * one channel that has just been scanned.
  */
 
-struct iwl_notif_statistics {
+struct iwl_notif_statistics_v8 {
 	__le32 flag;
 	struct mvm_statistics_rx rx;
 	struct mvm_statistics_tx tx;
-	struct mvm_statistics_general general;
+	struct mvm_statistics_general_v5 general;
 } __packed; /* STATISTICS_NTFY_API_S_VER_8 */
 
+struct iwl_notif_statistics_v10 {
+	__le32 flag;
+	struct mvm_statistics_rx rx;
+	struct mvm_statistics_tx tx;
+	struct mvm_statistics_general_v8 general;
+} __packed; /* STATISTICS_NTFY_API_S_VER_10 */
+
 #endif /* __fw_api_stats_h__ */
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index f922131..fffd89d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -6,7 +6,7 @@
  * GPL LICENSE SUMMARY
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -32,7 +32,7 @@
  * BSD LICENSE
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
- * Copyright(c) 2013 - 2014 Intel Mobile Communications GmbH
+ * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
  * All rights reserved.
  *
  * Redistribution and use in source and binary forms, with or without
@@ -416,33 +416,29 @@ int iwl_mvm_rx_rx_mpdu(struct iwl_mvm *mvm, struct iwl_rx_cmd_buffer *rxb,
 }
 
 static void iwl_mvm_update_rx_statistics(struct iwl_mvm *mvm,
-					 struct iwl_notif_statistics *stats)
+					 struct mvm_statistics_rx *rx_stats)
 {
-	/*
-	 * NOTE FW aggregates the statistics - BUT the statistics are cleared
-	 * when the driver issues REPLY_STATISTICS_CMD 0x9c with CLEAR_STATS
-	 * bit set.
-	 */
 	lockdep_assert_held(&mvm->mutex);
-	memcpy(&mvm->rx_stats, &stats->rx, sizeof(struct mvm_statistics_rx));
+
+	mvm->rx_stats = *rx_stats;
 }
 
 struct iwl_mvm_stat_data {
-	struct iwl_notif_statistics *stats;
 	struct iwl_mvm *mvm;
+	__le32 mac_id;
+	__s8 beacon_filter_average_energy;
 };
 
 static void iwl_mvm_stat_iterator(void *_data, u8 *mac,
 				  struct ieee80211_vif *vif)
 {
 	struct iwl_mvm_stat_data *data = _data;
-	struct iwl_notif_statistics *stats = data->stats;
 	struct iwl_mvm *mvm = data->mvm;
-	int sig = -stats->general.beacon_filter_average_energy;
+	int sig = -data->beacon_filter_average_energy;
 	int last_event;
 	int thold = vif->bss_conf.cqm_rssi_thold;
 	int hyst = vif->bss_conf.cqm_rssi_hyst;
-	u16 id = le32_to_cpu(stats->rx.general.mac_id);
+	u16 id = le32_to_cpu(data->mac_id);
 	struct iwl_mvm_vif *mvmvif = iwl_mvm_vif_from_mac80211(vif);
 
 	if (mvmvif->id != id)
@@ -510,24 +506,52 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 			  struct iwl_device_cmd *cmd)
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
-	struct iwl_notif_statistics *stats = (void *)&pkt->data;
+	size_t v8_len = sizeof(struct iwl_notif_statistics_v8);
+	size_t v10_len = sizeof(struct iwl_notif_statistics_v10);
 	struct iwl_mvm_stat_data data = {
-		.stats = stats,
 		.mvm = mvm,
 	};
+	u32 temperature;
+
+	if (mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_STATS_V10) {
+		struct iwl_notif_statistics_v10 *stats = (void *)&pkt->data;
+
+		if (iwl_rx_packet_payload_len(pkt) != v10_len)
+			goto invalid;
+
+		temperature = le32_to_cpu(stats->general.radio_temperature);
+		data.mac_id = stats->rx.general.mac_id;
+		data.beacon_filter_average_energy =
+			stats->general.beacon_filter_average_energy;
+
+		iwl_mvm_update_rx_statistics(mvm, &stats->rx);
+	} else {
+		struct iwl_notif_statistics_v8 *stats = (void *)&pkt->data;
+
+		if (iwl_rx_packet_payload_len(pkt) != v8_len)
+			goto invalid;
+
+		temperature = le32_to_cpu(stats->general.radio_temperature);
+		data.mac_id = stats->rx.general.mac_id;
+		data.beacon_filter_average_energy =
+			stats->general.beacon_filter_average_energy;
+
+		iwl_mvm_update_rx_statistics(mvm, &stats->rx);
+	}
 
 	/* Only handle rx statistics temperature changes if async temp
 	 * notifications are not supported
 	 */
 	if (!(mvm->fw->ucode_capa.api[0] & IWL_UCODE_TLV_API_ASYNC_DTM))
-		iwl_mvm_tt_temp_changed(mvm,
-				le32_to_cpu(stats->general.radio_temperature));
-
-	iwl_mvm_update_rx_statistics(mvm, stats);
+		iwl_mvm_tt_temp_changed(mvm, temperature);
 
 	ieee80211_iterate_active_interfaces(mvm->hw,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_stat_iterator,
 					    &data);
 	return 0;
+ invalid:
+	IWL_ERR(mvm, "received invalid statistics size (%d)!\n",
+		iwl_rx_packet_payload_len(pkt));
+	return 0;
 }
-- 
1.9.1

