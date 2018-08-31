Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45720 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726990AbeHaOFP (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Aug 2018 10:05:15 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Erel Geron <erelx.geron@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 31 Aug 2018 12:56:08 +0300
Message-Id: <20180831095614.14099-11-luca@coelho.fi> (sfid-20180831_115836_159511_FBA549F0)
In-Reply-To: <20180831095614.14099-1-luca@coelho.fi>
References: <20180831095614.14099-1-luca@coelho.fi>
Subject: [PATCH 10/16] iwlwifi: fix non_shared_ant for 22000 devices
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Erel Geron <erelx.geron@intel.com>

The non-shared antenna was wrong for 22000 device series.
Fix it to ANT_B for correct antenna preference by coex in MVM driver.

Fixes: e34d975e40ff ("iwlwifi: Add a000 HW family support")
Signed-off-by: Erel Geron <erelx.geron@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 204a51fd6375..a8acc755a02c 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -143,7 +143,7 @@ static const struct iwl_ht_params iwl_22000_ht_params = {
 	.ucode_api_min = IWL_22000_UCODE_API_MIN,			\
 	.led_mode = IWL_LED_RF_STATE,					\
 	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_22000,		\
-	.non_shared_ant = ANT_A,					\
+	.non_shared_ant = ANT_B,					\
 	.dccm_offset = IWL_22000_DCCM_OFFSET,				\
 	.dccm_len = IWL_22000_DCCM_LEN,					\
 	.dccm2_offset = IWL_22000_DCCM2_OFFSET,				\
-- 
2.18.0
