Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:57168 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752235AbbJEPB1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 5 Oct 2015 11:01:27 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Mon,  5 Oct 2015 17:36:53 +0300
Message-Id: <1444055820-27506-22-git-send-email-luca@coelho.fi> (sfid-20151005_170130_334280_70EC0679)
In-Reply-To: <1444050759.27220.15.camel@coelho.fi>
References: <1444050759.27220.15.camel@coelho.fi>
Subject: [PATCH 22/29] iwlwifi: remove IWL3165_UCODE_API_OK and _MIN
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

As the 3165 device uses the same firmware as 7265-D and currently
all 7000 series (including 3160/3165) use the same API versions
remove IWL3165_UCODE_API_OK and _MIN. We might have to put them
back if firmware support ever splits, but in that case might also
have to add a different MODULE_FIRMWARE statement.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 5b25f36..d561181 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -73,11 +73,9 @@
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	13
-#define IWL3165_UCODE_API_OK	13
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	13
-#define IWL3165_UCODE_API_MIN	13
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
@@ -269,11 +267,6 @@ const struct iwl_cfg iwl3165_2ac_cfg = {
 	.name = "Intel(R) Dual Band Wireless AC 3165",
 	.fw_name_pre = IWL7265D_FW_PRE,
 	IWL_DEVICE_7000,
-	/* sparse doens't like the re-assignment but it is safe */
-#ifndef __CHECKER__
-	.ucode_api_ok = IWL3165_UCODE_API_OK,
-	.ucode_api_min = IWL3165_UCODE_API_MIN,
-#endif
 	.ht_params = &iwl7000_ht_params,
 	.nvm_ver = IWL3165_NVM_VERSION,
 	.nvm_calib_ver = IWL3165_TX_POWER_VERSION,
-- 
2.5.3

