Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:49826 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142AbcC3OGK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Mar 2016 10:06:10 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 21/43] iwlwifi: remove IWLWIFI_UAPSD Kconfig
Date: Wed, 30 Mar 2016 17:04:53 +0300
Message-Id: <1459346715-7954-21-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160330_160614_798576_F51724BF)
In-Reply-To: <1459346667.4731.9.camel@intel.com>
References: <1459346667.4731.9.camel@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have a module parameter, this is enough.
per platform customizations will be done through the init
script of the platform.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Kconfig   | 10 ----------
 drivers/net/wireless/intel/iwlwifi/iwl-drv.c |  7 -------
 2 files changed, 17 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/Kconfig b/drivers/net/wireless/intel/iwlwifi/Kconfig
index 16c4f38..492035f 100644
--- a/drivers/net/wireless/intel/iwlwifi/Kconfig
+++ b/drivers/net/wireless/intel/iwlwifi/Kconfig
@@ -88,16 +88,6 @@ config IWLWIFI_BCAST_FILTERING
 	  If unsure, don't enable this option, as some programs might
 	  expect incoming broadcasts for their normal operations.
 
-config IWLWIFI_UAPSD
-	bool "enable U-APSD by default"
-	depends on IWLMVM
-	help
-	  Say Y here to enable U-APSD by default. This may cause
-	  interoperability problems with some APs, manifesting in lower than
-	  expected throughput due to those APs not enabling aggregation
-
-	  If unsure, say N.
-
 config IWLWIFI_PCIE_RTPM
        bool "Enable runtime power management mode for PCIe devices"
        depends on IWLMVM && PM
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 2cd9c31..9c2a2fd 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1560,9 +1560,7 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.power_level = IWL_POWER_INDEX_1,
 	.d0i3_disable = true,
 	.d0i3_entry_delay = 1000,
-#ifndef CONFIG_IWLWIFI_UAPSD
 	.uapsd_disable = IWL_DISABLE_UAPSD_BSS | IWL_DISABLE_UAPSD_P2P_CLIENT,
-#endif /* CONFIG_IWLWIFI_UAPSD */
 	/* the rest are 0 by default */
 };
 IWL_EXPORT_SYMBOL(iwlwifi_mod_params);
@@ -1682,13 +1680,8 @@ MODULE_PARM_DESC(lar_disable, "disable LAR functionality (default: N)");
 
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
 		   uint, S_IRUGO | S_IWUSR);
-#ifdef CONFIG_IWLWIFI_UAPSD
-MODULE_PARM_DESC(uapsd_disable,
-		 "disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 0)");
-#else
 MODULE_PARM_DESC(uapsd_disable,
 		 "disable U-APSD functionality bitmap 1: BSS 2: P2P Client (default: 3)");
-#endif
 
 /*
  * set bt_coex_active to true, uCode will do kill/defer
-- 
2.5.0

