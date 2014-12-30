Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:12344 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751636AbaL3OTn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Dec 2014 09:19:43 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 01/33] iwlwifi: remove MODULE_VERSION
Date: Tue, 30 Dec 2014 16:18:36 +0200
Message-Id: <1419949148-24046-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20141230_151945_929325_91F7E8D0)
In-Reply-To: <1419948357.21410.4.camel@egrumbacBox>
References: <1419948357.21410.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The module version "in-tree:" or "in-tree:d" is useless; there
should be better (functional) ways to detect whether debugging
is enabled and other than that the version says nothing.

Therefore remove the driver version completely.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/dvm/main.c | 14 --------------
 drivers/net/wireless/iwlwifi/iwl-drv.c  | 15 +--------------
 drivers/net/wireless/iwlwifi/iwl-drv.h  |  1 -
 drivers/net/wireless/iwlwifi/mvm/ops.c  |  7 -------
 4 files changed, 1 insertion(+), 36 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/dvm/main.c b/drivers/net/wireless/iwlwifi/dvm/main.c
index 0b7f46f..fcdc128 100644
--- a/drivers/net/wireless/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/iwlwifi/dvm/main.c
@@ -64,22 +64,8 @@
  *
  ******************************************************************************/
 
-/*
- * module name, copyright, version, etc.
- */
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi Link AGN driver for Linux"
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-#define VD "d"
-#else
-#define VD
-#endif
-
-#define DRV_VERSION     IWLWIFI_VERSION VD
-
-
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.c b/drivers/net/wireless/iwlwifi/iwl-drv.c
index 38de151..36ae191 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.c
@@ -84,21 +84,8 @@
  *
  ******************************************************************************/
 
-/*
- * module name, copyright, version, etc.
- */
 #define DRV_DESCRIPTION	"Intel(R) Wireless WiFi driver for Linux"
-
-#ifdef CONFIG_IWLWIFI_DEBUG
-#define VD "d"
-#else
-#define VD
-#endif
-
-#define DRV_VERSION     IWLWIFI_VERSION VD
-
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
@@ -1492,7 +1479,7 @@ static int __init iwl_drv_init(void)
 	for (i = 0; i < ARRAY_SIZE(iwlwifi_opmode_table); i++)
 		INIT_LIST_HEAD(&iwlwifi_opmode_table[i].drv);
 
-	pr_info(DRV_DESCRIPTION ", " DRV_VERSION "\n");
+	pr_info(DRV_DESCRIPTION "\n");
 	pr_info(DRV_COPYRIGHT "\n");
 
 #ifdef CONFIG_IWLWIFI_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/iwl-drv.h b/drivers/net/wireless/iwlwifi/iwl-drv.h
index be4f897..adf522c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-drv.h
+++ b/drivers/net/wireless/iwlwifi/iwl-drv.h
@@ -68,7 +68,6 @@
 
 /* for all modules */
 #define DRV_NAME        "iwlwifi"
-#define IWLWIFI_VERSION "in-tree:"
 #define DRV_COPYRIGHT	"Copyright(c) 2003- 2014 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
diff --git a/drivers/net/wireless/iwlwifi/mvm/ops.c b/drivers/net/wireless/iwlwifi/mvm/ops.c
index 97dfba5..552a776 100644
--- a/drivers/net/wireless/iwlwifi/mvm/ops.c
+++ b/drivers/net/wireless/iwlwifi/mvm/ops.c
@@ -84,15 +84,8 @@
 #include "time-event.h"
 #include "iwl-fw-error-dump.h"
 
-/*
- * module name, copyright, version, etc.
- */
 #define DRV_DESCRIPTION	"The new Intel(R) wireless AGN driver for Linux"
-
-#define DRV_VERSION     IWLWIFI_VERSION
-
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
-- 
1.9.1

