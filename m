Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:41899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721Ab1CYObk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 10:31:40 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 12/12] iwlagn: remove deprecated module parameters
Date: Fri, 25 Mar 2011 07:14:16 -0700
Message-Id: <1301062456-17249-13-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1301062456-17249-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Number of deprecated module parameters need to be remove for 2.6.40 kernel

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.c  |   30 ------------------------------
 drivers/net/wireless/iwlwifi/iwl-core.h |    1 -
 2 files changed, 0 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 9251c68..39a05e3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3771,14 +3771,6 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	 * 1. Allocating HW data
 	 ************************/
 
-	/* Disabling hardware scan means that mac80211 will perform scans
-	 * "the hard way", rather than using device's scan. */
-	if (cfg->mod_params->disable_hw_scan) {
-		dev_printk(KERN_DEBUG, &(pdev->dev),
-			"sw scan support is deprecated\n");
-		iwlagn_hw_ops.hw_scan = NULL;
-	}
-
 	hw = iwl_alloc_all(cfg);
 	if (!hw) {
 		err = -ENOMEM;
@@ -4388,43 +4380,21 @@ module_exit(iwl_exit);
 module_init(iwl_init);
 
 #ifdef CONFIG_IWLWIFI_DEBUG
-module_param_named(debug50, iwl_debug_level, uint, S_IRUGO);
-MODULE_PARM_DESC(debug50, "50XX debug output mask (deprecated)");
 module_param_named(debug, iwl_debug_level, uint, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(debug, "debug output mask");
 #endif
 
-module_param_named(swcrypto50, iwlagn_mod_params.sw_crypto, bool, S_IRUGO);
-MODULE_PARM_DESC(swcrypto50,
-		 "using crypto in software (default 0 [hardware]) (deprecated)");
 module_param_named(swcrypto, iwlagn_mod_params.sw_crypto, int, S_IRUGO);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
-module_param_named(queues_num50,
-		   iwlagn_mod_params.num_of_queues, int, S_IRUGO);
-MODULE_PARM_DESC(queues_num50,
-		 "number of hw queues in 50xx series (deprecated)");
 module_param_named(queues_num, iwlagn_mod_params.num_of_queues, int, S_IRUGO);
 MODULE_PARM_DESC(queues_num, "number of hw queues.");
-module_param_named(11n_disable50, iwlagn_mod_params.disable_11n, int, S_IRUGO);
-MODULE_PARM_DESC(11n_disable50, "disable 50XX 11n functionality (deprecated)");
 module_param_named(11n_disable, iwlagn_mod_params.disable_11n, int, S_IRUGO);
 MODULE_PARM_DESC(11n_disable, "disable 11n functionality");
-module_param_named(amsdu_size_8K50, iwlagn_mod_params.amsdu_size_8K,
-		   int, S_IRUGO);
-MODULE_PARM_DESC(amsdu_size_8K50,
-		 "enable 8K amsdu size in 50XX series (deprecated)");
 module_param_named(amsdu_size_8K, iwlagn_mod_params.amsdu_size_8K,
 		   int, S_IRUGO);
 MODULE_PARM_DESC(amsdu_size_8K, "enable 8K amsdu size");
-module_param_named(fw_restart50, iwlagn_mod_params.restart_fw, int, S_IRUGO);
-MODULE_PARM_DESC(fw_restart50,
-		 "restart firmware in case of error (deprecated)");
 module_param_named(fw_restart, iwlagn_mod_params.restart_fw, int, S_IRUGO);
 MODULE_PARM_DESC(fw_restart, "restart firmware in case of error");
-module_param_named(
-	disable_hw_scan, iwlagn_mod_params.disable_hw_scan, int, S_IRUGO);
-MODULE_PARM_DESC(disable_hw_scan,
-		 "disable hardware scanning (default 0) (deprecated)");
 
 module_param_named(ucode_alternative, iwlagn_wanted_ucode_alternative, int,
 		   S_IRUGO);
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3a4e9b4..967b4c0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -247,7 +247,6 @@ struct iwl_ops {
 
 struct iwl_mod_params {
 	int sw_crypto;		/* def: 0 = using hardware encryption */
-	int disable_hw_scan;	/* def: 0 = use h/w scan */
 	int num_of_queues;	/* def: HW dependent */
 	int disable_11n;	/* def: 0 = 11n capabilities enabled */
 	int amsdu_size_8K;	/* def: 1 = enable 8K amsdu size */
-- 
1.7.0.4

