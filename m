Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:36010 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab0AEWA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jan 2010 17:00:27 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: Zhu Yi <yi.zhu@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] iwlwifi: remove IWLWIFI_VERSION
Date: Tue,  5 Jan 2010 16:54:59 -0500
Message-Id: <1262728499-31006-1-git-send-email-linville@tuxdriver.com>
In-Reply-To: <DA586906BA1FFC4384FCFD6429ECE860302D216F@shzsmsx502.ccr.corp.intel.com>
References: <DA586906BA1FFC4384FCFD6429ECE860302D216F@shzsmsx502.ccr.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also remove the MODULE_VERSION macros using IWLWIFI_VERSION.  Those
places using IWLWIFI_VERSION at runtime are modified to use
init_utsname()->release instead.

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
How about this as a compromise?

 drivers/net/wireless/iwlwifi/iwl-agn.c      |    7 ++++---
 drivers/net/wireless/iwlwifi/iwl-core.c     |    1 -
 drivers/net/wireless/iwlwifi/iwl-core.h     |    1 -
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    7 ++++---
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 771b03c..f5522f0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -40,6 +40,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/utsname.h>
 
 #include <net/mac80211.h>
 
@@ -79,11 +80,10 @@
 #define VS
 #endif
 
-#define DRV_VERSION     IWLWIFI_VERSION VD VS
+#define DRV_VERSION     VD VS
 
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("iwl4965");
@@ -3884,7 +3884,8 @@ static int __init iwl_init(void)
 {
 
 	int ret;
-	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
+	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", %s-" DRV_VERSION "\n",
+		init_utsname()->release);
 	printk(KERN_INFO DRV_NAME ": " DRV_COPYRIGHT "\n");
 
 	ret = iwlagn_rate_control_register();
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
index 14f4829..756c49a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.c
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -43,7 +43,6 @@
 
 
 MODULE_DESCRIPTION("iwl core");
-MODULE_VERSION(IWLWIFI_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 1728f96..106651b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -72,7 +72,6 @@ struct iwl_host_cmd;
 struct iwl_cmd;
 
 
-#define IWLWIFI_VERSION UTS_RELEASE "-k"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 10b0aa8..8b5ffff 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -40,6 +40,7 @@
 #include <linux/firmware.h>
 #include <linux/etherdevice.h>
 #include <linux/if_arp.h>
+#include <linux/utsname.h>
 
 #include <net/ieee80211_radiotap.h>
 #include <net/mac80211.h>
@@ -76,12 +77,11 @@
 #define VS
 #endif
 
-#define DRV_VERSION  IWLWIFI_VERSION VD VS
+#define DRV_VERSION  VD VS
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2009 Intel Corporation"
 #define DRV_AUTHOR     "<ilw@linux.intel.com>"
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-MODULE_VERSION(DRV_VERSION);
 MODULE_AUTHOR(DRV_COPYRIGHT " " DRV_AUTHOR);
 MODULE_LICENSE("GPL");
 
@@ -4279,7 +4279,8 @@ static int __init iwl3945_init(void)
 {
 
 	int ret;
-	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", " DRV_VERSION "\n");
+	printk(KERN_INFO DRV_NAME ": " DRV_DESCRIPTION ", %s-" DRV_VERSION "\n",
+		init_utsname()->release);
 	printk(KERN_INFO DRV_NAME ": " DRV_COPYRIGHT "\n");
 
 	ret = iwl3945_rate_control_register();
-- 
1.6.2.5

