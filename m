Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43860 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726969AbeHXOE3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 10:04:29 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, Ido Yariv <idox.yariv@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 24 Aug 2018 13:30:08 +0300
Message-Id: <20180824103018.15011-7-luca@coelho.fi> (sfid-20180824_123035_801609_9AA5F329)
In-Reply-To: <20180824103018.15011-1-luca@coelho.fi>
References: <20180824103018.15011-1-luca@coelho.fi>
Subject: [PATCH 06/16] iwlwifi: Add missing 11n disable module parameter check
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <idox.yariv@intel.com>

In the new method of parsing the NVM the disable_11n module parameter
isn't consulted when setting up HT capabilities. Fix this.

Signed-off-by: Ido Yariv <idox.yariv@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
index 2fee4392be7f..4e3422a1c7bb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-eeprom-parse.c
@@ -742,7 +742,9 @@ void iwl_init_ht_hw_capab(const struct iwl_cfg *cfg,
 	else
 		rx_chains = hweight8(rx_chains);
 
-	if (!(data->sku_cap_11n_enable) || !cfg->ht_params) {
+	if (!(data->sku_cap_11n_enable) ||
+	    (iwlwifi_mod_params.disable_11n & IWL_DISABLE_HT_ALL) ||
+	    !cfg->ht_params) {
 		ht_info->ht_supported = false;
 		return;
 	}
-- 
2.18.0
