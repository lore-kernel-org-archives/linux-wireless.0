Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:55576 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbZDTVbH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 17:31:07 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/11] iwlwifi: remove radio disable parameter.
Date: Mon, 20 Apr 2009 14:37:03 -0700
Message-Id: <1240263424-8495-11-git-send-email-reinette.chatre@intel.com> (sfid-20090420_233348_404789_D24C2B6D)
In-Reply-To: <1240263424-8495-10-git-send-email-reinette.chatre@intel.com>
References: <1240263424-8495-1-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-2-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-3-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-4-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-5-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-6-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-7-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-8-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-9-git-send-email-reinette.chatre@intel.com>
 <1240263424-8495-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>

Patch removes the "manual radio disable" parameter
as there is no usage scenario of disabling radio using this module parameter.
User can use iwconfig's txpower to enable and disable radio.

This module parameter also does not work as expected. During module load
the status of radio is set, the radio is not actually disabled. Even so,
the moment mac80211 requests the interface to be up the radio will be
enabled again.

Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c     |    2 --
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    3 ---
 drivers/net/wireless/iwlwifi/iwl-agn.c      |   14 ++------------
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |   18 ++----------------
 5 files changed, 4 insertions(+), 34 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index e4762e5..a98ff4e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2361,8 +2361,6 @@ MODULE_FIRMWARE(IWL4965_MODULE_FIRMWARE(IWL4965_UCODE_API_MAX));
 
 module_param_named(antenna, iwl4965_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(disable, iwl4965_mod_params.disable, int, 0444);
-MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 module_param_named(swcrypto, iwl4965_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(swcrypto, "using crypto in software (default 0 [hardware])");
 module_param_named(debug, iwl4965_mod_params.debug, uint, 0444);
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 5bbb4f9..d731a83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -1655,9 +1655,6 @@ struct iwl_cfg iwl5150_agn_cfg = {
 MODULE_FIRMWARE(IWL5000_MODULE_FIRMWARE(IWL5000_UCODE_API_MAX));
 MODULE_FIRMWARE(IWL5150_MODULE_FIRMWARE(IWL5150_UCODE_API_MAX));
 
-module_param_named(disable50, iwl50_mod_params.disable, int, 0444);
-MODULE_PARM_DESC(disable50,
-		  "manually disable the 50XX radio (default 0 [radio on])");
 module_param_named(swcrypto50, iwl50_mod_params.sw_crypto, bool, 0444);
 MODULE_PARM_DESC(swcrypto50,
 		  "using software crypto engine (default 0 [hardware])\n");
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index fc52d32..9e41e1b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -2774,18 +2774,8 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto out_free_eeprom;
 	/* At this point both hw and priv are initialized. */
 
-	/**********************************
-	 * 7. Initialize module parameters
-	 **********************************/
-
-	/* Disable radio (SW RF KILL) via parameter when loading driver */
-	if (priv->cfg->mod_params->disable) {
-		set_bit(STATUS_RF_KILL_SW, &priv->status);
-		IWL_DEBUG_INFO(priv, "Radio disabled.\n");
-	}
-
 	/********************
-	 * 8. Setup services
+	 * 7. Setup services
 	 ********************/
 	spin_lock_irqsave(&priv->lock, flags);
 	iwl_disable_interrupts(priv);
@@ -2809,7 +2799,7 @@ static int iwl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	iwl_setup_rx_handlers(priv);
 
 	/**********************************
-	 * 9. Setup and register mac80211
+	 * 8. Setup and register mac80211
 	 **********************************/
 
 	/* enable interrupts if needed: hw bug w/a */
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 3bc2f6c..d4c60af 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -176,7 +176,6 @@ struct iwl_ops {
 };
 
 struct iwl_mod_params {
-	int disable;		/* def: 0 = enable radio */
 	int sw_crypto;		/* def: 0 = using hardware encryption */
 	u32 debug;		/* def: 0 = minimal debug log messages */
 	int disable_hw_scan;	/* def: 0 = use h/w scan */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index a776326..34c53ef 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4309,20 +4309,8 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	IWL_INFO(priv, "Detected Intel Wireless WiFi Link %s\n",
 		priv->cfg->name);
 
-	/***********************************
-	 * 7. Initialize Module Parameters
-	 * **********************************/
-
-	/* Initialize module parameter values here */
-	/* Disable radio (SW RF KILL) via parameter when loading driver */
-	if (iwl3945_mod_params.disable) {
-		set_bit(STATUS_RF_KILL_SW, &priv->status);
-		IWL_DEBUG_INFO(priv, "Radio disabled.\n");
-	}
-
-
 	/***********************
-	 * 8. Setup Services
+	 * 7. Setup Services
 	 * ********************/
 
 	spin_lock_irqsave(&priv->lock, flags);
@@ -4350,7 +4338,7 @@ static int iwl3945_pci_probe(struct pci_dev *pdev, const struct pci_device_id *e
 	iwl3945_setup_rx_handlers(priv);
 
 	/*********************************
-	 * 9. Setup and Register mac80211
+	 * 8. Setup and Register mac80211
 	 * *******************************/
 
 	iwl_enable_interrupts(priv);
@@ -4528,8 +4516,6 @@ MODULE_FIRMWARE(IWL3945_MODULE_FIRMWARE(IWL3945_UCODE_API_MAX));
 
 module_param_named(antenna, iwl3945_mod_params.antenna, int, 0444);
 MODULE_PARM_DESC(antenna, "select antenna (1=Main, 2=Aux, default 0 [both])");
-module_param_named(disable, iwl3945_mod_params.disable, int, 0444);
-MODULE_PARM_DESC(disable, "manually disable the radio (default 0 [radio on])");
 module_param_named(swcrypto, iwl3945_mod_params.sw_crypto, int, 0444);
 MODULE_PARM_DESC(swcrypto,
 		 "using software crypto (default 1 [software])\n");
-- 
1.5.6.3

