Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:5408 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbZIQRny (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Sep 2009 13:43:54 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 04/13] iwlwifi: use S_IRUGO and S_IWUSR in module parameters
Date: Thu, 17 Sep 2009 10:43:47 -0700
Message-Id: <1253209436-2309-5-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
References: <1253209436-2309-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Instead of hardcode module parameter's permissions, use pre-defined.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |   15 ++++++++-------
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   11 ++++++-----
 drivers/net/wireless/iwlwifi/iwl-agn.c      |    4 ++--
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   11 ++++++-----
 4 files changed, 22 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index d61d5a3..021e855 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2353,21 +2353,22 @@ struct iwl_cfg iwl4965_agn_cfg = {
 /* Module firmware */
 MODULE_FIRMWARE(IWL4965_MODULE_FIRMWARE(IWL4965_UCODE_API_MAX));
 
-module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
+module_param_named(antenna, iwl4965_mod_params.antenna, int, S_IRUGO);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, 0444);
+module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(
-	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, 0444);
+	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, S_IRUGO);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
 
-module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, 0444);
+module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, S_IRUGO);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
 /* 11n */
-module_param_named(11n_disable, iwl4965_mod_params.disable_11n, int, 0444);
+module_param_named(11n_disable, iwl4965_mod_params.disable_11n, int, S_IRUGO);
 MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
-module_param_named(amsdu_size_8K, iwl4965_mod_params.amsdu_size_8K, int, 0444);
+module_param_named(amsdu_size_8K, iwl4965_mod_params.amsdu_size_8K,
+		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
 
-module_param_named(fw_restart4965, iwl4965_mod_params.restart_fw, int, 0444);
+module_param_named(fw_restart4965, iwl4965_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart4965, "restart firmware in case of error");
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index c31bde3..00b07f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1742,14 +1742,15 @@ struct iwl_cfg iwl5150_agn_cfg = {
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
 
-module_param_named(swcrypto50, iwl50_mod_params.sw_crypto, bool, 0444);
+module_param_named(swcrypto50, iwl50_mod_params.sw_crypto, bool, S_IRUGO);
 MODULE_PARM_DESC(swcrypto50,
 		  "using software crypto engine (default 0 [hardware])\n");
-module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, 0444);
+module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, S_IRUGO);
 MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
-module_param_named(11n_disable50, iwl50_mod_params.disable_11n, int, 0444);
+module_param_named(11n_disable50, iwl50_mod_params.disable_11n, int, S_IRUGO);
 MODULE_PARM_DESC(11n_disable50, "disable 50XX 11n functionality");
-module_param_named(amsdu_size_8K50, iwl50_mod_params.amsdu_size_8K, int, 0444);
+module_param_named(amsdu_size_8K50, iwl50_mod_params.amsdu_size_8K,
+		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K50, "enable 8K amsdu size in 50XX series");
-module_param_named(fw_restart50, iwl50_mod_params.restart_fw, int, 0444);
+module_param_named(fw_restart50, iwl50_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart50, "restart firmware in case of error");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 0b2a1d4..f726b42 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3137,9 +3137,9 @@ module_exit(iwl_exit);
 module_init(iwl_init);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-module_param_named(debug50, iwl_debug_level, uint, 0444);
+module_param_named(debug50, iwl_debug_level, uint, S_IRUGO);
 MODULE_PARM_DESC(debug50, "50XX debug output mask (deprecated)");
-module_param_named(debug, iwl_debug_level, uint, 0644);
+module_param_named(debug, iwl_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 0909668..3b31bd5 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4223,18 +4223,19 @@ static void __exit iwl3945_exit(void)
 
 MODULE_FIRMWARE(IWL3945_MODULE_FIRMWARE(IWL3945_UCODE_API_MAX));
 
-module_param_named(antenna, iwl3945_mod_params.antenna, int, 0444);
+module_param_named(antenna, iwl3945_mod_params.antenna, int, S_IRUGO);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(swcrypto, iwl3945_mod_params.sw_crypto, int, 0444);
+module_param_named(swcrypto, iwl3945_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto,
 		 "using software crypto (default 1 [software])\n");
 #ifdef CONFIG_IWLWIFI_DEBUG
-module_param_named(debug, iwl_debug_level, uint, 0644);
+module_param_named(debug, iwl_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
-module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan, int, 0444);
+module_param_named(disable_hw_scan, iwl3945_mod_params.disable_hw_scan,
+		   int, S_IRUGO);
 MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
-module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, 0444);
+module_param_named(fw_restart3945, iwl3945_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart3945, "restart firmware in case of error");
 
 module_exit(iwl3945_exit);
-- 
1.5.6.3

