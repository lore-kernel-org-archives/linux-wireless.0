Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45716 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752762AbbIUU7I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:08 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Sara Sharon <sara.sharon@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:42 +0300
Message-Id: <1442869141-31637-2-git-send-email-luca@coelho.fi> (sfid-20150921_225913_361667_63CCC9C1)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 02/21] iwlwifi: mvm: fix statistics variables type
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sara Sharon <sara.sharon@intel.com>

When receiving statistics notification there is a field of average energy.
This is defines as signed 8 bit, while FW refers to it as unsigned.
when the energy is higher than 127 this causes in iwl_mvm_stat_iterator
a wrong computation of the signal
     int sig = -stats->general.beacon_filter_average_energy;
resulting in incorrect CQM event (change from low to high).

While at it - update the rest of the fields to the correct type.

Signed-off-by: Sara Sharon <sara.sharon@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h | 16 ++++++++--------
 drivers/net/wireless/iwlwifi/mvm/mvm.h          | 10 +++++-----
 drivers/net/wireless/iwlwifi/mvm/rx.c           |  2 +-
 3 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
index 709e28d..4ca4bce 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-stats.h
@@ -237,10 +237,10 @@ struct mvm_statistics_general_v5 {
 	__le32 num_of_sos_states;
 	__le32 beacon_filtered;
 	__le32 missed_beacons;
-	__s8 beacon_filter_average_energy;
-	__s8 beacon_filter_reason;
-	__s8 beacon_filter_current_energy;
-	__s8 beacon_filter_reserved;
+	u8 beacon_filter_average_energy;
+	u8 beacon_filter_reason;
+	u8 beacon_filter_current_energy;
+	u8 beacon_filter_reserved;
 	__le32 beacon_filter_delta_time;
 	struct mvm_statistics_bt_activity bt_activity;
 } __packed; /* STATISTICS_GENERAL_API_S_VER_5 */
@@ -263,10 +263,10 @@ struct mvm_statistics_general_v8 {
 	__le32 num_of_sos_states;
 	__le32 beacon_filtered;
 	__le32 missed_beacons;
-	__s8 beacon_filter_average_energy;
-	__s8 beacon_filter_reason;
-	__s8 beacon_filter_current_energy;
-	__s8 beacon_filter_reserved;
+	u8 beacon_filter_average_energy;
+	u8 beacon_filter_reason;
+	u8 beacon_filter_current_energy;
+	u8 beacon_filter_reserved;
 	__le32 beacon_filter_delta_time;
 	struct mvm_statistics_bt_activity bt_activity;
 	__le64 rx_time;
diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index b95a07e..72cd67e 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -323,11 +323,11 @@ enum iwl_bt_force_ant_mode {
 struct iwl_mvm_vif_bf_data {
 	bool bf_enabled;
 	bool ba_enabled;
-	s8 ave_beacon_signal;
-	s8 last_cqm_event;
-	s8 bt_coex_min_thold;
-	s8 bt_coex_max_thold;
-	s8 last_bt_coex_event;
+	int ave_beacon_signal;
+	int last_cqm_event;
+	int bt_coex_min_thold;
+	int bt_coex_max_thold;
+	int last_bt_coex_event;
 };
 
 /**
diff --git a/drivers/net/wireless/iwlwifi/mvm/rx.c b/drivers/net/wireless/iwlwifi/mvm/rx.c
index c37c10a..2ad814d 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rx.c
@@ -459,7 +459,7 @@ static void iwl_mvm_update_rx_statistics(struct iwl_mvm *mvm,
 struct iwl_mvm_stat_data {
 	struct iwl_mvm *mvm;
 	__le32 mac_id;
-	__s8 beacon_filter_average_energy;
+	u8 beacon_filter_average_energy;
 	struct mvm_statistics_general_v8 *general;
 };
 
-- 
2.5.1

