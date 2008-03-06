Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21744 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721AbYCFSls (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2008 13:41:48 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/2] iwlwifi: add iwl-core module
Date: Thu,  6 Mar 2008 10:40:19 -0800
Message-Id: <1204828820-11768-2-git-send-email-reinette.chatre@intel.com> (sfid-20080306_184153_326352_8B439776)
In-Reply-To: <1204828820-11768-1-git-send-email-reinette.chatre@intel.com>
References: <1204828820-11768-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds iwl-core module to iwlwifi driver.
This module will contain common code and infrastracture for iwlwifi
driver

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    5 +++
 drivers/net/wireless/iwlwifi/Makefile       |    3 ++
 drivers/net/wireless/iwlwifi/iwl-core.c     |   47 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-core.h     |    3 ++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    8 +----
 5 files changed, 59 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-core.c

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 24c3e3d..5b7c016 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -1,7 +1,12 @@
+config IWLCORE
+	tristate "Intel Wireless Wifi Core"
+	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
+
 config IWL4965
 	tristate "Intel Wireless WiFi 4965AGN"
 	depends on PCI && MAC80211 && WLAN_80211 && EXPERIMENTAL
 	select FW_LOADER
+	select IWLCORE
 	---help---
 	  Select to build the driver supporting the:
 
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 3bbd383..6b85cca 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -1,3 +1,6 @@
+obj-$(CONFIG_IWLCORE)	+= iwlcore.o
+iwlcore-objs 		= iwl-core.o
+
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.c b/drivers/net/wireless/iwlwifi/iwl-core.c
new file mode 100644
index 0000000..675b34b
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-core.c
@@ -0,0 +1,47 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2008 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
+ * USA
+ *
+ * The full GNU General Public License is included in this distribution
+ * in the file called LICENSE.GPL.
+ *
+ * Contact Information:
+ * Tomas Winkler <tomas.winkler@intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
+
+#include "iwl-4965-debug.h"
+#include "iwl-core.h"
+
+MODULE_DESCRIPTION("iwl core");
+MODULE_VERSION(IWLWIFI_VERSION);
+MODULE_AUTHOR(DRV_COPYRIGHT);
+MODULE_LICENSE("GPL/BSD");
+
+#ifdef CONFIG_IWL4965_DEBUG
+u32 iwl4965_debug_level;
+EXPORT_SYMBOL(iwl4965_debug_level);
+#endif
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index e6449af..bdd32f8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -63,6 +63,9 @@
 #ifndef __iwl_core_h__
 #define __iwl_core_h__
 
+#define IWLWIFI_VERSION "1.2.26k"
+#define DRV_COPYRIGHT	"Copyright(c) 2003-2008 Intel Corporation"
+
 #define IWL_PCI_DEVICE(dev, subdev, cfg) \
 	.vendor = PCI_VENDOR_ID_INTEL,  .device = (dev), \
 	.subvendor = PCI_ANY_ID, .subdevice = (subdev), \
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5005c95..af95626 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -49,10 +49,6 @@
 #include "iwl-4965.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWL4965_DEBUG
-u32 iwl4965_debug_level;
-#endif
-
 static int iwl4965_tx_queue_update_write_ptr(struct iwl4965_priv *priv,
 				  struct iwl4965_tx_queue *txq);
 
@@ -91,9 +87,7 @@ int iwl4965_param_amsdu_size_8K;   /* def: enable 8K amsdu size */
 #define VS
 #endif
 
-#define IWLWIFI_VERSION "1.2.26k" VD VS
-#define DRV_COPYRIGHT	"Copyright(c) 2003-2007 Intel Corporation"
-#define DRV_VERSION     IWLWIFI_VERSION
+#define DRV_VERSION     IWLWIFI_VERSION VD VS
 
 
 MODULE_DESCRIPTION(DRV_DESCRIPTION);
-- 
1.5.3.4

