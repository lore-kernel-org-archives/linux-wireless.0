Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:34404 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752743AbdFVVWT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Jun 2017 17:22:19 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org,
        Gregory Greenman <gregory.greenman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 23 Jun 2017 00:20:52 +0300
Message-Id: <20170622212101.16422-17-luca@coelho.fi> (sfid-20170622_232225_903578_51D65275)
In-Reply-To: <20170622212101.16422-1-luca@coelho.fi>
References: <20170622212101.16422-1-luca@coelho.fi>
Subject: [PATCH 16/25] iwlwifi: mvm: rs: add logs for the wrong antenna case
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gregory Greenman <gregory.greenman@intel.com>

In case that rate's antenna is wrong at the init stage, it's
very hard to say what went wrong. Add debug data to the already
existing WARN_ON_ONCE.

Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-config.h | 1 +
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c     | 6 +++++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index f3236ea7edb5..127017efdd87 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -131,6 +131,7 @@ enum iwl_led_mode {
 
 /* Antenna presence definitions */
 #define	ANT_NONE	0x0
+#define	ANT_INVALID	0xff
 #define	ANT_A		BIT(0)
 #define	ANT_B		BIT(1)
 #define ANT_C		BIT(2)
diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index aa785cf3cf68..a02dda8d9ea3 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -2836,7 +2836,11 @@ static void rs_initialize_lq(struct iwl_mvm *mvm,
 	rs_get_initial_rate(mvm, sta, lq_sta, band, rate);
 	rs_init_optimal_rate(mvm, sta, lq_sta);
 
-	WARN_ON_ONCE(rate->ant != ANT_A && rate->ant != ANT_B);
+	WARN_ONCE(rate->ant != ANT_A && rate->ant != ANT_B,
+		  "ant: 0x%x, chains 0x%x, fw tx ant: 0x%x, nvm tx ant: 0x%x\n",
+		  rate->ant, lq_sta->pers.chains, mvm->fw->valid_tx_ant,
+		  mvm->nvm_data ? mvm->nvm_data->valid_tx_ant : ANT_INVALID);
+
 	tbl->column = rs_get_column_from_rate(rate);
 
 	rs_set_expected_tpt_table(lq_sta, tbl);
-- 
2.11.0
