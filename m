Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45788 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756198AbbIUVBn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 17:01:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:54 +0300
Message-Id: <1442869141-31637-14-git-send-email-luca@coelho.fi> (sfid-20150921_230148_533159_30864F3D)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 14/21] iwlwifi: mvm: remove IWL_UCODE_TLV_API_STATS_V10 TLV flag
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This flag is set in all supported firmwares.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-fw-file.h      |  2 --
 drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h | 33 -----------------
 drivers/net/wireless/iwlwifi/mvm/rx.c           | 47 ++++++++-----------------
 3 files changed, 15 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-fw-file.h b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
index 104468b..352d245 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fw-file.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fw-file.h
@@ -249,7 +249,6 @@ typedef unsigned int __bitwise__ iwl_ucode_tlv_api_t;
  * @IWL_UCODE_TLV_API_WIFI_MCC_UPDATE: ucode supports MCC updates with source.
  * @IWL_UCODE_TLV_API_WIDE_CMD_HDR: ucode supports wide command header
  * @IWL_UCODE_TLV_API_LQ_SS_PARAMS: Configure STBC/BFER via LQ CMD ss_params
- * @IWL_UCODE_TLV_API_STATS_V10: uCode supports/uses statistics API version 10
  * @IWL_UCODE_TLV_API_NEW_VERSION: new versioning format
  * @IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY: scan APIs use 8-level priority
  *	instead of 3.
@@ -262,7 +261,6 @@ enum iwl_ucode_tlv_api {
 	IWL_UCODE_TLV_API_WIFI_MCC_UPDATE	= (__force iwl_ucode_tlv_api_t)9,
 	IWL_UCODE_TLV_API_WIDE_CMD_HDR		= (__force iwl_ucode_tlv_api_t)14,
 	IWL_UCODE_TLV_API_LQ_SS_PARAMS		= (__force iwl_ucode_tlv_api_t)18,
-	IWL_UCODE_TLV_API_STATS_V10		= (__force iwl_ucode_tlv_api_t)19,
 	IWL_UCODE_TLV_API_NEW_VERSION		= (__force iwl_ucode_tlv_api_t)20,
 	IWL_UCODE_TLV_API_EXT_SCAN_PRIORITY	= (__force iwl_ucode_tlv_api_t)24,
 	IWL_UCODE_TLV_API_TX_POWER_CHAIN	= (__force iwl_ucode_tlv_api_t)27,
diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
index 4ca4bce..0c321f6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
@@ -219,32 +219,6 @@ struct mvm_statistics_bt_activity {
 	__le32 lo_priority_rx_denied_cnt;
 } __packed;  /* STATISTICS_BT_ACTIVITY_API_S_VER_1 */
 
-struct mvm_statistics_general_v5 {
-	__le32 radio_temperature;
-	__le32 radio_voltage;
-	struct mvm_statistics_dbg dbg;
-	__le32 sleep_time;
-	__le32 slots_out;
-	__le32 slots_idle;
-	__le32 ttl_timestamp;
-	struct mvm_statistics_div slow_div;
-	__le32 rx_enable_counter;
-	/*
-	 * num_of_sos_states:
-	 *  count the number of times we have to re-tune
-	 *  in order to get out of bad PHY status
-	 */
-	__le32 num_of_sos_states;
-	__le32 beacon_filtered;
-	__le32 missed_beacons;
-	u8 beacon_filter_average_energy;
-	u8 beacon_filter_reason;
-	u8 beacon_filter_current_energy;
-	u8 beacon_filter_reserved;
-	__le32 beacon_filter_delta_time;
-	struct mvm_statistics_bt_activity bt_activity;
-} __packed; /* STATISTICS_GENERAL_API_S_VER_5 */
-
 struct mvm_statistics_general_v8 {
 	__le32 radio_temperature;
 	__le32 radio_voltage;
@@ -293,13 +267,6 @@ struct mvm_statistics_rx {
  * STATISTICS_CMD (0x9c), below.
  */
 
-struct iwl_notif_statistics_v8 {
-	__le32 flag;
-	struct mvm_statistics_rx rx;
-	struct mvm_statistics_tx tx;
-	struct mvm_statistics_general_v5 general;
-} __packed; /* STATISTICS_NTFY_API_S_VER_8 */
-
 struct iwl_notif_statistics_v10 {
 	__le32 flag;
 	struct mvm_statistics_rx rx;
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index b620142..c203a1b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -577,47 +577,30 @@ iwl_mvm_rx_stats_check_trigger(struct iwl_mvm *mvm, struct iwl_rx_packet *pkt)
 void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 				  struct iwl_rx_packet *pkt)
 {
-	size_t v8_len = sizeof(struct iwl_notif_statistics_v8);
-	size_t v10_len = sizeof(struct iwl_notif_statistics_v10);
+	struct iwl_notif_statistics_v10 *stats = (void *)&pkt->data;
 	struct iwl_mvm_stat_data data = {
 		.mvm = mvm,
 	};
 	u32 temperature;
 
-	if (fw_has_api(&mvm->fw->ucode_capa, IWL_UCODE_TLV_API_STATS_V10)) {
-		struct iwl_notif_statistics_v10 *stats = (void *)&pkt->data;
+	if (iwl_rx_packet_payload_len(pkt) != sizeof(*stats))
+		goto invalid;
 
-		if (iwl_rx_packet_payload_len(pkt) != v10_len)
-			goto invalid;
+	temperature = le32_to_cpu(stats->general.radio_temperature);
+	data.mac_id = stats->rx.general.mac_id;
+	data.beacon_filter_average_energy =
+		stats->general.beacon_filter_average_energy;
 
-		temperature = le32_to_cpu(stats->general.radio_temperature);
-		data.mac_id = stats->rx.general.mac_id;
-		data.beacon_filter_average_energy =
-			stats->general.beacon_filter_average_energy;
+	iwl_mvm_update_rx_statistics(mvm, &stats->rx);
 
-		iwl_mvm_update_rx_statistics(mvm, &stats->rx);
+	mvm->radio_stats.rx_time = le64_to_cpu(stats->general.rx_time);
+	mvm->radio_stats.tx_time = le64_to_cpu(stats->general.tx_time);
+	mvm->radio_stats.on_time_rf =
+		le64_to_cpu(stats->general.on_time_rf);
+	mvm->radio_stats.on_time_scan =
+		le64_to_cpu(stats->general.on_time_scan);
 
-		mvm->radio_stats.rx_time = le64_to_cpu(stats->general.rx_time);
-		mvm->radio_stats.tx_time = le64_to_cpu(stats->general.tx_time);
-		mvm->radio_stats.on_time_rf =
-			le64_to_cpu(stats->general.on_time_rf);
-		mvm->radio_stats.on_time_scan =
-			le64_to_cpu(stats->general.on_time_scan);
-
-		data.general = &stats->general;
-	} else {
-		struct iwl_notif_statistics_v8 *stats = (void *)&pkt->data;
-
-		if (iwl_rx_packet_payload_len(pkt) != v8_len)
-			goto invalid;
-
-		temperature = le32_to_cpu(stats->general.radio_temperature);
-		data.mac_id = stats->rx.general.mac_id;
-		data.beacon_filter_average_energy =
-			stats->general.beacon_filter_average_energy;
-
-		iwl_mvm_update_rx_statistics(mvm, &stats->rx);
-	}
+	data.general = &stats->general;
 
 	iwl_mvm_rx_stats_check_trigger(mvm, pkt);
 
-- 
2.5.1

