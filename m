Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20650 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065Ab3CLQfc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 12:35:32 -0400
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes.berg@intel.com>
Cc: linux-wireless@vger.kernel.org, ilw@linux.intel.com,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH] iwlwifi: remove 5ghz_disable option
Date: Tue, 12 Mar 2013 17:35:58 +0100
Message-Id: <1363106158-31904-1-git-send-email-sgruszka@redhat.com> (sfid-20130312_173535_577986_9F870BB6)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

5ghz_disable has no effect any longer, that was changed during
refactoring of EEPROM reading/parsing. Remove it, wpa_supplicant
allow now to specify frequencies, on which device will operate.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-drv.c       | 4 ----
 drivers/net/wireless/iwlwifi/iwl-modparams.h | 2 --
 2 files changed, 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 3ce4e9d..4983005 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1266,7 +1266,3 @@ module_param_named(auto_agg, iwlwifi_mod_params.auto_agg,
 		bool, S_IRUGO);
 MODULE_PARM_DESC(auto_agg,
 		 "enable agg w/o check traffic load (default: enable)");
-
-module_param_named(5ghz_disable, iwlwifi_mod_params.disable_5ghz,
-		bool, S_IRUGO);
-MODULE_PARM_DESC(5ghz_disable, "disable 5GHz band (default: 0 [enabled])");
diff --git a/drivers/net/wireless/iwlwifi/iwl-modparams.h b/drivers/net/wireless/iwlwifi/iwl-modparams.h
index 3cc39ff..d6f6c37 100644
--- a/drivers/net/wireless/iwlwifi/iwl-modparams.h
+++ b/drivers/net/wireless/iwlwifi/iwl-modparams.h
@@ -103,7 +103,6 @@ enum iwl_power_level {
  * @ant_coupling: antenna coupling in dB, default = 0
  * @bt_ch_announce: BT channel inhibition, default = enable
  * @auto_agg: enable agg. without check, default = true
- * @disable_5ghz: disable 5GHz capability, default = false
  */
 struct iwl_mod_params {
 	int sw_crypto;
@@ -120,7 +119,6 @@ struct iwl_mod_params {
 	int ant_coupling;
 	bool bt_ch_announce;
 	bool auto_agg;
-	bool disable_5ghz;
 };
 
 #endif /* #__iwl_modparams_h__ */
-- 
1.7.11.7

