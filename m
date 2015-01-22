Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42471 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753473AbbAVUdg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2015 15:33:36 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Eyal Shapira <eyal@wizery.com>,
	Eyal Shapira <eyalx.shapira@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/38] iwlwifi: mvm: rs: repeat initial legacy rates in LQ table
Date: Thu, 22 Jan 2015 22:32:53 +0200
Message-Id: <1421958809-3371-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150122_213341_465602_A68442F2)
In-Reply-To: <1421958313.6424.2.camel@egrumbacBox>
References: <1421958313.6424.2.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

Repeating the legacy rates avoids degrading quickly to
lower rates due to collisions which is common when doing
TCP Tx traffic in legacy.
This slightly improves TCP Tx throughput while working
in legacy in different scenarios.

Signed-off-by: Eyal Shapira <eyalx.shapira@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h |  5 +++--
 drivers/net/wireless/iwlwifi/mvm/rs.c        | 19 ++++++++++---------
 2 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 7cd1de8..2d8e7e3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -103,12 +103,13 @@
 #define IWL_MVM_RS_RSSI_BASED_INIT_RATE         0
 #define IWL_MVM_RS_DISABLE_MIMO			0
 #define IWL_MVM_RS_NUM_TRY_BEFORE_ANT_TOGGLE    1
-#define IWL_MVM_RS_LEGACY_RETRIES_PER_RATE      1
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE      2
 #define IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE_TW   1
 #define IWL_MVM_RS_INITIAL_MIMO_NUM_RATES       3
 #define IWL_MVM_RS_INITIAL_SISO_NUM_RATES       3
-#define IWL_MVM_RS_INITIAL_LEGACY_NUM_RATES     16
+#define IWL_MVM_RS_INITIAL_LEGACY_NUM_RATES     2
+#define IWL_MVM_RS_INITIAL_LEGACY_RETRIES       2
+#define IWL_MVM_RS_SECONDARY_LEGACY_RETRIES	1
 #define IWL_MVM_RS_SECONDARY_LEGACY_NUM_RATES   16
 #define IWL_MVM_RS_SECONDARY_SISO_NUM_RATES     3
 #define IWL_MVM_RS_SECONDARY_SISO_RETRIES       1
diff --git a/drivers/net/wireless/iwlwifi/mvm/rs.c b/drivers/net/wireless/iwlwifi/mvm/rs.c
index 7ba6e5d..4747224 100644
--- a/drivers/net/wireless/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/iwlwifi/mvm/rs.c
@@ -2862,12 +2862,13 @@ static void rs_fill_rates_for_column(struct iwl_mvm *mvm,
 	int index = *rs_table_index;
 
 	for (i = 0; i < num_rates && index < end; i++) {
-		ucode_rate = cpu_to_le32(ucode_rate_from_rs_rate(mvm, rate));
-		for (j = 0; j < num_retries && index < end; j++, index++)
+		for (j = 0; j < num_retries && index < end; j++, index++) {
+			ucode_rate = cpu_to_le32(ucode_rate_from_rs_rate(mvm,
+									 rate));
 			rs_table[index] = ucode_rate;
-
-		if (toggle_ant)
-			rs_toggle_antenna(valid_tx_ant, rate);
+			if (toggle_ant)
+				rs_toggle_antenna(valid_tx_ant, rate);
+		}
 
 		prev_rate_idx = rate->index;
 		bottom_reached = rs_get_lower_rate_in_column(lq_sta, rate);
@@ -2875,7 +2876,7 @@ static void rs_fill_rates_for_column(struct iwl_mvm *mvm,
 			break;
 	}
 
-	if (!bottom_reached)
+	if (!bottom_reached && !is_legacy(rate))
 		rate->index = prev_rate_idx;
 
 	*rs_table_index = index;
@@ -2925,7 +2926,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 		num_retries = IWL_MVM_RS_HT_VHT_RETRIES_PER_RATE;
 	} else {
 		num_rates = IWL_MVM_RS_INITIAL_LEGACY_NUM_RATES;
-		num_retries = IWL_MVM_RS_LEGACY_RETRIES_PER_RATE;
+		num_retries = IWL_MVM_RS_INITIAL_LEGACY_RETRIES;
 		toggle_ant = true;
 	}
 
@@ -2941,7 +2942,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 		lq_cmd->mimo_delim = index;
 	} else if (is_legacy(&rate)) {
 		num_rates = IWL_MVM_RS_SECONDARY_LEGACY_NUM_RATES;
-		num_retries = IWL_MVM_RS_LEGACY_RETRIES_PER_RATE;
+		num_retries = IWL_MVM_RS_SECONDARY_LEGACY_RETRIES;
 	} else {
 		WARN_ON_ONCE(1);
 	}
@@ -2955,7 +2956,7 @@ static void rs_build_rates_table(struct iwl_mvm *mvm,
 	rs_get_lower_rate_down_column(lq_sta, &rate);
 
 	num_rates = IWL_MVM_RS_SECONDARY_LEGACY_NUM_RATES;
-	num_retries = IWL_MVM_RS_LEGACY_RETRIES_PER_RATE;
+	num_retries = IWL_MVM_RS_SECONDARY_LEGACY_RETRIES;
 
 	rs_fill_rates_for_column(mvm, lq_sta, &rate, lq_cmd->rs_table, &index,
 				 num_rates, num_retries, valid_tx_ant,
-- 
1.9.1

