Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:51492 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1755109AbdDMP2L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Apr 2017 11:28:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        "Goodstein, Mordechay" <mordechay.goodstein@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 13 Apr 2017 18:24:58 +0300
Message-Id: <20170413152507.9648-18-luca@coelho.fi> (sfid-20170413_172856_866994_C436E973)
In-Reply-To: <20170413152507.9648-1-luca@coelho.fi>
References: <20170413152507.9648-1-luca@coelho.fi>
Subject: [PATCH 17/26] iwlwifi: mvm: move new API code to the end
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: "Goodstein, Mordechay" <mordechay.goodstein@intel.com>

By moving all the code that depends on the new API
we avoid unnecessary indentation in the code.

Signed-off-by: Mordechai Goodstein <mordechay.goodstein@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rx.c | 69 +++++++++++++++--------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
index 861d54641d1e..655bd1384158 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rx.c
@@ -7,7 +7,7 @@
  *
  * Copyright(c) 2012 - 2014 Intel Corporation. All rights reserved.
  * Copyright(c) 2013 - 2015 Intel Mobile Communications GmbH
- * Copyright(c) 2016 Intel Deutschland GmbH
+ * Copyright(c) 2016 - 2017 Intel Deutschland GmbH
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of version 2 of the GNU General Public License as
@@ -649,6 +649,9 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		.mvm = mvm,
 	};
 	int expected_size;
+	int i;
+	u8 *energy;
+	__le32 *bytes, *air_time;
 
 	if (iwl_mvm_is_cdb_supported(mvm))
 		expected_size = sizeof(*stats);
@@ -674,38 +677,6 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 		le64_to_cpu(stats->general.common.on_time_scan);
 
 	data.general = &stats->general;
-	if (iwl_mvm_has_new_rx_api(mvm)) {
-		int i;
-		u8 *energy;
-		__le32 *bytes, *air_time;
-
-		if (!iwl_mvm_is_cdb_supported(mvm)) {
-			struct iwl_notif_statistics_v11 *v11 =
-				(void *)&pkt->data;
-
-			energy = (void *)&v11->load_stats.avg_energy;
-			bytes = (void *)&v11->load_stats.byte_count;
-			air_time = (void *)&v11->load_stats.air_time;
-		} else {
-			energy = (void *)&stats->load_stats.avg_energy;
-			bytes = (void *)&stats->load_stats.byte_count;
-			air_time = (void *)&stats->load_stats.air_time;
-		}
-
-		rcu_read_lock();
-		for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
-			struct iwl_mvm_sta *sta;
-
-			if (!energy[i])
-				continue;
-
-			sta = iwl_mvm_sta_from_staid_rcu(mvm, i);
-			if (!sta)
-				continue;
-			sta->avg_energy = energy[i];
-		}
-		rcu_read_unlock();
-	}
 
 	iwl_mvm_rx_stats_check_trigger(mvm, pkt);
 
@@ -713,7 +684,39 @@ void iwl_mvm_handle_rx_statistics(struct iwl_mvm *mvm,
 					    IEEE80211_IFACE_ITER_NORMAL,
 					    iwl_mvm_stat_iterator,
 					    &data);
+
+	if (!iwl_mvm_has_new_rx_api(mvm))
+		return;
+
+	if (!iwl_mvm_is_cdb_supported(mvm)) {
+		struct iwl_notif_statistics_v11 *v11 =
+			(void *)&pkt->data;
+
+		energy = (void *)&v11->load_stats.avg_energy;
+		bytes = (void *)&v11->load_stats.byte_count;
+		air_time = (void *)&v11->load_stats.air_time;
+	} else {
+		energy = (void *)&stats->load_stats.avg_energy;
+		bytes = (void *)&stats->load_stats.byte_count;
+		air_time = (void *)&stats->load_stats.air_time;
+	}
+
+	rcu_read_lock();
+	for (i = 0; i < ARRAY_SIZE(mvm->fw_id_to_mac_id); i++) {
+		struct iwl_mvm_sta *sta;
+
+		if (!energy[i])
+			continue;
+
+		sta = iwl_mvm_sta_from_staid_rcu(mvm, i);
+		if (!sta)
+			continue;
+		sta->avg_energy = energy[i];
+	}
+	rcu_read_unlock();
+
 	return;
+
  invalid:
 	IWL_ERR(mvm, "received invalid statistics size (%d)!\n",
 		iwl_rx_packet_payload_len(pkt));
-- 
2.11.0
