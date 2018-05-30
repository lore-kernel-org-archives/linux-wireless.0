Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:47000 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934600AbeE3HVS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 May 2018 03:21:18 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Erel Geron <erelx.geron@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 May 2018 10:20:05 +0300
Message-Id: <20180530072005.633-11-luca@coelho.fi> (sfid-20180530_092207_303897_3AA062F0)
In-Reply-To: <20180530072005.633-1-luca@coelho.fi>
References: <20180530072005.633-1-luca@coelho.fi>
Subject: [PATCH 10/10] iwlwifi: fix non_shared_ant for 9000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erel Geron <erelx.geron@intel.com>

The non-shared antenna was wrong for 9000 device series.  Fix it to
ANT_B for correct antenna preference by coex in MVM driver.

Fixes: 89374fe60bfb ("iwlwifi: Add new PCI IDs for 9260 and 5165 series")
Signed-off-by: Erel Geron <erelx.geron@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 9706624911f8..e20c30b29c03 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -137,7 +137,7 @@ static const struct iwl_tt_params iwl9000_tt_params = {
 	.base_params = &iwl9000_base_params,				\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_9000,		\
-	.non_shared_ant = ANT_A,					\
+	.non_shared_ant = ANT_B,					\
 	.dccm_offset = IWL9000_DCCM_OFFSET,				\
 	.dccm_len = IWL9000_DCCM_LEN,					\
 	.dccm2_offset = IWL9000_DCCM2_OFFSET,				\
-- 
2.17.0
