Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbbAVUeL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:34:11 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 18/38] iwlwifi: mvm: sync statistics firmware API
Date: Thu, 22 Jan 2015 22:33:09 +0200
Message-Id: <1421958809-3371-18-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_214446_194043_A851122F)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The firmware API structs are split differently, synchronize
the struct splits with the current firmware definitions.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 70 +++++++++++++++----------------
 drivers/net/wireless/iwlwifi/mvm/rx.c     |  4 +-
 2 files changed, 37 insertions(+), 37 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index b3badec..1a934a6 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1400,24 +1400,6 @@ struct mvm_statistics_div {
 	__le32 reserved2;
 } __packed; /* STATISTICS_SLOW_DIV_API_S_VER_2 */
 
-struct mvm_statistics_general_common {
-	__le32 temperature;   /* radio temperature */
-	__le32 temperature_m; /* radio voltage */
-	struct mvm_statistics_dbg dbg;
-	__le32 sleep_time;
-	__le32 slots_out;
-	__le32 slots_idle;
-	__le32 ttl_timestamp;
-	struct mvm_statistics_div div;
-	__le32 rx_enable_counter;
-	/*
-	 * num_of_sos_states:
-	 *  count the number of times we have to re-tune
-	 *  in order to get out of bad PHY status
-	 */
-	__le32 num_of_sos_states;
-} __packed; /* STATISTICS_GENERAL_API_S_VER_5 */
-
 struct mvm_statistics_rx_non_phy {
 	__le32 bogus_cts;	/* CTS received when not expecting CTS */
 	__le32 bogus_ack;	/* ACK received when not expecting ACK */
@@ -1490,6 +1472,23 @@ struct mvm_statistics_rx_ht_phy {
 	__le32 unsupport_mcs;
 } __packed;  /* STATISTICS_HT_RX_PHY_API_S_VER_1 */
 
+struct mvm_statistics_tx_non_phy {
+	__le32 preamble_cnt;
+	__le32 rx_detected_cnt;
+	__le32 bt_prio_defer_cnt;
+	__le32 bt_prio_kill_cnt;
+	__le32 few_bytes_cnt;
+	__le32 cts_timeout;
+	__le32 ack_timeout;
+	__le32 expected_ack_cnt;
+	__le32 actual_ack_cnt;
+	__le32 dump_msdu_cnt;
+	__le32 burst_abort_next_frame_mismatch_cnt;
+	__le32 burst_abort_missing_next_frame_cnt;
+	__le32 cts_timeout_collision;
+	__le32 ack_or_ba_timeout_collision;
+} __packed; /* STATISTICS_TX_NON_PHY_API_S_VER_3 */
+
 #define MAX_CHAINS 3
 
 struct mvm_statistics_tx_non_phy_agg {
@@ -1520,20 +1519,7 @@ struct mvm_statistics_tx_channel_width {
 }; /* STATISTICS_TX_CHANNEL_WIDTH_API_S_VER_1 */
 
 struct mvm_statistics_tx {
-	__le32 preamble_cnt;
-	__le32 rx_detected_cnt;
-	__le32 bt_prio_defer_cnt;
-	__le32 bt_prio_kill_cnt;
-	__le32 few_bytes_cnt;
-	__le32 cts_timeout;
-	__le32 ack_timeout;
-	__le32 expected_ack_cnt;
-	__le32 actual_ack_cnt;
-	__le32 dump_msdu_cnt;
-	__le32 burst_abort_next_frame_mismatch_cnt;
-	__le32 burst_abort_missing_next_frame_cnt;
-	__le32 cts_timeout_collision;
-	__le32 ack_or_ba_timeout_collision;
+	struct mvm_statistics_tx_non_phy general;
 	struct mvm_statistics_tx_non_phy_agg agg;
 	struct mvm_statistics_tx_channel_width channel_width;
 } __packed; /* STATISTICS_TX_API_S_VER_4 */
@@ -1551,7 +1537,21 @@ struct mvm_statistics_bt_activity {
 } __packed;  /* STATISTICS_BT_ACTIVITY_API_S_VER_1 */
 
 struct mvm_statistics_general {
-	struct mvm_statistics_general_common common;
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
 	__le32 beacon_filtered;
 	__le32 missed_beacons;
 	__s8 beacon_filter_average_energy;
@@ -1585,12 +1585,12 @@ struct mvm_statistics_rx {
  * one channel that has just been scanned.
  */
 
-struct iwl_notif_statistics { /* STATISTICS_NTFY_API_S_VER_8 */
+struct iwl_notif_statistics {
 	__le32 flag;
 	struct mvm_statistics_rx rx;
 	struct mvm_statistics_tx tx;
 	struct mvm_statistics_general general;
-} __packed;
+} __packed; /* STATISTICS_NTFY_API_S_VER_8 */
 
 /***********************************
  * Smart Fifo API
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index 94b6e72..02e0f37 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -511,13 +511,13 @@ int iwl_mvm_rx_statistics(struct iwl_mvm *mvm,
 {
 	struct iwl_rx_packet *pkt = rxb_addr(rxb);
 	struct iwl_notif_statistics *stats = (void *)&pkt->data;
-	struct mvm_statistics_general_common *common = &stats->general.common;
 	struct iwl_mvm_stat_data data = {
 		.stats = stats,
 		.mvm = mvm,
 	};
 
-	iwl_mvm_tt_temp_changed(mvm, le32_to_cpu(common->temperature));
+	iwl_mvm_tt_temp_changed(mvm,
+				le32_to_cpu(stats->general.radio_temperature));
 
 	iwl_mvm_update_rx_statistics(mvm, stats);
 
-- 
1.9.1

