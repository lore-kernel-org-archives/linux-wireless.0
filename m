Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:29646 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754099Ab0DBUi6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Apr 2010 16:38:58 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/7] iwlwifi: merge module parameters into single place
Date: Fri,  2 Apr 2010 13:38:48 -0700
Message-Id: <1270240734-12825-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
References: <1270240734-12825-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Module parameters used to be defined in both iwl-5000.c and iwl-4965.c,
after the code re-structure, merge into iwl-agn.c for easy to read and
maintenance.

Number of module parameters are deprecated after this merge. These are also
scheduled for removal by 2.6.40.

The current supported parameters are:

 parm: debug50:50XX debug output mask (deprecated) (uint)
 parm: debug:debug output mask (uint)
 parm: swcrypto50:using crypto in software (default 0 [hardware])
(deprecated) (bool)
 parm: swcrypto:using crypto in software (default 0 [hardware]) (int)
 parm: queues_num50:number of hw queues in 50xx series (deprecated)
(int)
 parm: queues_num:number of hw queues. (int)
 parm: 11n_disable50:disable 50XX 11n functionality (deprecated) (int)
 parm: 11n_disable:disable 11n functionality (int)
 parm: amsdu_size_8K50:enable 8K amsdu size in 50XX series (deprecated)
(int)
 parm: amsdu_size_8K:enable 8K amsdu size (int)
 parm: fw_restart50:restart firmware in case of error (deprecated) (int)
 parm: fw_restart:restart firmware in case of error (int)
 parm: disable_hw_scan:disable hardware scanning (default 0) (int)

Remove "antenna" module parameter, it is not being used in "agn" driver.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 Documentation/feature-removal-schedule.txt |   11 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-4965.c    |   29 +--------------------------
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   13 ------------
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   30 ++++++++++++++++++++++++++++
 4 files changed, 42 insertions(+), 41 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index a841e79..4e78611 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -545,3 +545,14 @@ Why:	udev fully replaces this special file system that only contains CAPI
 	NCCI TTY device nodes. User space (pppdcapiplugin) works without
 	noticing the difference.
 Who:	Jan Kiszka <jan.kiszka@web.de>
+
+----------------------------
+
+What:	iwlwifi 50XX module parameters
+When:	2.6.40
+Why:	The "..50" modules parameters were used to configure 5000 series and
+	up devices; different set of module parameters also available for 4965
+	with same functionalities. Consolidate both set into single place
+	in drivers/net/wireless/iwlwifi/iwl-agn.c
+
+Who:	Wey-Yi Guy <wey-yi.w.guy@intel.com>
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 1808c97..083983a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -61,14 +61,6 @@ static int iwl4965_hw_get_temperature(struct iwl_priv *priv);
 #define _IWL4965_MODULE_FIRMWARE(api) IWL4965_FW_PRE #api ".ucode"
 #define IWL4965_MODULE_FIRMWARE(api) _IWL4965_MODULE_FIRMWARE(api)
 
-
-/* module parameters */
-static struct iwl_mod_params iwl4965_mod_params = {
-	.amsdu_size_8K = 1,
-	.restart_fw = 1,
-	/* the rest are 0 by default */
-};
-
 /* check contents of special bootstrap uCode SRAM */
 static int iwl4965_verify_bsm(struct iwl_priv *priv)
 {
@@ -2245,7 +2237,7 @@ struct iwl_cfg iwl4965_agn_cfg = {
 	.ops = &iwl4965_ops,
 	.num_of_queues = IWL49_NUM_QUEUES,
 	.num_of_ampdu_queues = IWL49_NUM_AMPDU_QUEUES,
-	.mod_params = &iwl4965_mod_params,
+	.mod_params = &iwlagn_mod_params,
 	.valid_tx_ant = ANT_AB,
 	.valid_rx_ant = ANT_ABC,
 	.pll_cfg_val = 0,
@@ -2265,22 +2257,3 @@ struct iwl_cfg iwl4965_agn_cfg = {
 /* Module firmware */
 MODULE_FIRMWARE(IWL4965_MODULE_FIRMWARE(IWL4965_UCODE_API_MAX));
 
-module_param_named(antenna, iwl4965_mod_params.antenna, int, S_IRUGO);
-MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, S_IRUGO);
-MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(
-	disable_hw_scan, iwl4965_mod_params.disable_hw_scan, int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
-
-module_param_named(queues_num, iwl4965_mod_params.num_of_queues, int, S_IRUGO);
-MODULE_PARM_DESC(queues_num, "number of hw queues.");
-/* 11n */
-module_param_named(11n_disable, iwl4965_mod_params.disable_11n, int, S_IRUGO);
-MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
-module_param_named(amsdu_size_8K, iwl4965_mod_params.amsdu_size_8K,
-		   int, S_IRUGO);
-MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
-
-module_param_named(fw_restart4965, iwl4965_mod_params.restart_fw, int, S_IRUGO);
-MODULE_PARM_DESC(fw_restart4965, "restart firmware in case of error");
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5ca4517..ecc302e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -585,16 +585,3 @@ struct iwl_cfg iwl5150_abg_cfg = {
 
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
-
-module_param_named(swcrypto50, iwlagn_mod_params.sw_crypto, bool, S_IRUGO);
-MODULE_PARM_DESC(swcrypto50,
-		  "using software crypto engine (default 0 [hardware])\n");
-module_param_named(queues_num50, iwlagn_mod_params.num_of_queues, int, S_IRUGO);
-MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
-module_param_named(11n_disable50, iwlagn_mod_params.disable_11n, int, S_IRUGO);
-MODULE_PARM_DESC(11n_disable50, "disable 50XX 11n functionality");
-module_param_named(amsdu_size_8K50, iwlagn_mod_params.amsdu_size_8K,
-		   int, S_IRUGO);
-MODULE_PARM_DESC(amsdu_size_8K50, "enable 8K amsdu size in 50XX series");
-module_param_named(fw_restart50, iwlagn_mod_params.restart_fw, int, S_IRUGO);
-MODULE_PARM_DESC(fw_restart50, "restart firmware in case of error");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index b431e92..8262f43 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3921,3 +3921,33 @@ module_param_named(debug, iwl_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
+module_param_named(swcrypto50, iwlagn_mod_params.sw_crypto, bool, S_IRUGO);
+MODULE_PARM_DESC(swcrypto50,
+		 "using crypto in software (default 0 [hardware]) (deprecated)");
+module_param_named(swcrypto, iwlagn_mod_params.sw_crypto, int, S_IRUGO);
+MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
+module_param_named(queues_num50,
+		   iwlagn_mod_params.num_of_queues, int, S_IRUGO);
+MODULE_PARM_DESC(queues_num50,
+		 "number of hw queues in 50xx series (deprecated)");
+module_param_named(queues_num, iwlagn_mod_params.num_of_queues, int, S_IRUGO);
+MODULE_PARM_DESC(queues_num, "number of hw queues.");
+module_param_named(11n_disable50, iwlagn_mod_params.disable_11n, int, S_IRUGO);
+MODULE_PARM_DESC(11n_disable50, "disable 50XX 11n functionality (deprecated)");
+module_param_named(11n_disable, iwlagn_mod_params.disable_11n, int, S_IRUGO);
+MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
+module_param_named(amsdu_size_8K50, iwlagn_mod_params.amsdu_size_8K,
+		   int, S_IRUGO);
+MODULE_PARM_DESC(amsdu_size_8K50,
+		 "enable 8K amsdu size in 50XX series (deprecated)");
+module_param_named(amsdu_size_8K, iwlagn_mod_params.amsdu_size_8K,
+		   int, S_IRUGO);
+MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
+module_param_named(fw_restart50, iwlagn_mod_params.restart_fw, int, S_IRUGO);
+MODULE_PARM_DESC(fw_restart50,
+		 "restart firmware in case of error (deprecated)");
+module_param_named(fw_restart, iwlagn_mod_params.restart_fw, int, S_IRUGO);
+MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
+module_param_named(
+	disable_hw_scan, iwlagn_mod_params.disable_hw_scan, int, S_IRUGO);
+MODULE_PARM_DESC(disable_hw_scan, "disable hardware scanning (default 0)");
-- 
1.6.3.3

