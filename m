Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54630 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751323AbdIOMrl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 08:47:41 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Fri, 15 Sep 2017 15:47:04 +0300
Message-Id: <20170915124704.9032-11-luca@coelho.fi> (sfid-20170915_144743_976234_698AFF3D)
In-Reply-To: <20170915124704.9032-1-luca@coelho.fi>
References: <20170915124704.9032-1-luca@coelho.fi>
Subject: [PATCH 10/10] iwlwifi: remove redundant reading from NVM file
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>

The driver reads xtal_calib from NVM file, but actually never uses it.
This is only used in dvm driver.

Signed-off-by: Chaya Rachel Ivgi <chaya.rachel.ivgi@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 3014beef4873..4574a126c1ae 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -89,10 +89,6 @@ enum wkp_nvm_offsets {
 	SKU = 2,
 	N_HW_ADDRS = 3,
 	NVM_CHANNELS = 0x1E0 - NVM_SW_SECTION,
-
-	/* NVM calibration section offset (in words) definitions */
-	NVM_CALIB_SECTION = 0x2B8,
-	XTAL_CALIB = 0x316 - NVM_CALIB_SECTION
 };
 
 enum ext_nvm_offsets {
@@ -748,9 +744,6 @@ iwl_parse_nvm_data(struct iwl_trans *trans, const struct iwl_cfg *cfg,
 			kfree(data);
 			return NULL;
 		}
-		/* in family 8000 Xtal calibration values moved to OTP */
-		data->xtal_calib[0] = *(nvm_calib + XTAL_CALIB);
-		data->xtal_calib[1] = *(nvm_calib + XTAL_CALIB + 1);
 		lar_enabled = true;
 		ch_section = &nvm_sw[NVM_CHANNELS];
 	} else {
-- 
2.14.1
