Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:60344 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753991AbaICT4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 15:56:44 -0400
Received: by mail-wi0-f176.google.com with SMTP id bs8so1604189wib.15
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 12:56:43 -0700 (PDT)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 10/36] iwlwifi: make U-APSD default configurable at compile time
Date: Wed,  3 Sep 2014 22:55:58 +0300
Message-Id: <1409774184-24665-10-git-send-email-egrumbach@gmail.com> (sfid-20140903_215649_311177_31E62374)
In-Reply-To: <540771E5.6080908@gmail.com>
References: <540771E5.6080908@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

With a significant number of deployed APs, enabling uAPSD leads to the
AP never using aggregation sessions (likely due to the complexities
involved in handling uAPSD in those.) This obviously results in a large
drop in throughput with such APs.

On the other hand, uAPSD can result in some power consumption benefits,
but for now just disable it to get performance with affected APs back
up.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig   | 10 ++++++++++
 drivers/net/wireless/iwlwifi/iwl-drv.c |  8 +++++++-
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 6451d2b..760e96f 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -87,6 +87,16 @@ config IWLWIFI_BCAST_FILTERING
 	  If unsure, don't enable this option, as some programs might
 	  expect incoming broadcasts for their normal operations.
 
+config IWLWIFI_UAPSD
+	bool "enable U-APSD by default"
+	depends on IWLMVM
+	help
+	  Say Y here to enable U-APSD by default. This may cause
+	  interoperability problems with some APs, manifesting in lower than
+	  expected throughput due to those APs not enabling aggregation
+
+	  If unsure, say N.
+
 menu "Debugging Options"
 
 config IWLWIFI_DEBUG
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 77e3178..283aee0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -1254,7 +1254,9 @@ struct iwl_mod_params iwlwifi_mod_params = {
 	.bt_coex_active = true,
 	.power_level = IWL_POWER_INDEX_1,
 	.wd_disable = true,
-	.uapsd_disable = false,
+#ifndef CONFIG_IWLWIFI_UAPSD
+	.uapsd_disable = true,
+#endif /* CONFIG_IWLWIFI_UAPSD */
 	/* the rest are 0 by default */
 };
 IWL_EXPORT_SYMBOL(iwlwifi_mod_params);
@@ -1370,7 +1372,11 @@ MODULE_PARM_DESC(nvm_file, "NVM file name");
 
 module_param_named(uapsd_disable, iwlwifi_mod_params.uapsd_disable,
 		   bool, S_IRUGO);
+#ifdef CONFIG_IWLWIFI_UAPSD
 MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: N)");
+#else
+MODULE_PARM_DESC(uapsd_disable, "disable U-APSD functionality (default: Y)");
+#endif
 
 /*
  * set bt_coex_active to true, uCode will do kill/defer
-- 
1.9.1

