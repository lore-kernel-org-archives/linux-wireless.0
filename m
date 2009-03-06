Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:32671 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202AbZCFVsE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2009 16:48:04 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 2/2] iwlwifi: correct device name for 1000 series
Date: Fri,  6 Mar 2009 13:52:55 -0800
Message-Id: <1236376375-27927-3-git-send-email-reinette.chatre@intel.com> (sfid-20090306_224809_655547_C3D9E194)
In-Reply-To: <1236376375-27927-2-git-send-email-reinette.chatre@intel.com>
References: <1236376375-27927-1-git-send-email-reinette.chatre@intel.com>
 <1236376375-27927-2-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

device name was changed from 100 to 1000

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig    |    2 +-
 drivers/net/wireless/iwlwifi/Makefile   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-100.c  |   73 -------------------------------
 drivers/net/wireless/iwlwifi/iwl-1000.c |   73 +++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c  |    6 +-
 drivers/net/wireless/iwlwifi/iwl-csr.h  |    2 +-
 drivers/net/wireless/iwlwifi/iwl-dev.h  |    2 +-
 7 files changed, 80 insertions(+), 80 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlwifi/iwl-100.c
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-1000.c

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 6cc5a54..a894deb 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -87,7 +87,7 @@ config IWL4965
 	  This option enables support for Intel Wireless WiFi Link 4965AGN
 
 config IWL5000
-	bool "Intel Wireless WiFi 5000AGN; Intel WiFi Link 100, 6000, and 6050 Series"
+	bool "Intel Wireless WiFi 5000AGN; Intel WiFi Link 1000, 6000, and 6050 Series"
 	depends on IWLAGN
 	---help---
 	  This option enables support for Intel Wireless WiFi Link 5000AGN Family
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 48af523..d5f8009 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -13,7 +13,7 @@ iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
-iwlagn-$(CONFIG_IWL5000) += iwl-100.o
+iwlagn-$(CONFIG_IWL5000) += iwl-1000.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-100.c b/drivers/net/wireless/iwlwifi/iwl-100.c
deleted file mode 100644
index 11d206a..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-100.c
+++ /dev/null
@@ -1,73 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2008-2009 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#include <linux/kernel.h>
-#include <linux/module.h>
-#include <linux/init.h>
-#include <linux/pci.h>
-#include <linux/dma-mapping.h>
-#include <linux/delay.h>
-#include <linux/skbuff.h>
-#include <linux/netdevice.h>
-#include <linux/wireless.h>
-#include <net/mac80211.h>
-#include <linux/etherdevice.h>
-#include <asm/unaligned.h>
-
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
-#include "iwl-core.h"
-#include "iwl-io.h"
-#include "iwl-sta.h"
-#include "iwl-helpers.h"
-#include "iwl-5000-hw.h"
-
-/* Highest firmware API version supported */
-#define IWL100_UCODE_API_MAX 2
-
-/* Lowest firmware API version supported */
-#define IWL100_UCODE_API_MIN 1
-
-#define IWL100_FW_PRE "iwlwifi-100-"
-#define _IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE #api ".ucode"
-#define IWL100_MODULE_FIRMWARE(api) _IWL100_MODULE_FIRMWARE(api)
-
-struct iwl_cfg iwl100_bgn_cfg = {
-	.name = "100 Series BGN",
-	.fw_name_pre = IWL100_FW_PRE,
-	.ucode_api_max = IWL100_UCODE_API_MAX,
-	.ucode_api_min = IWL100_UCODE_API_MIN,
-	.sku = IWL_SKU_G|IWL_SKU_N,
-	.ops = &iwl5000_ops,
-	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
-	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
-	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
-	.mod_params = &iwl50_mod_params,
-	.valid_tx_ant = ANT_A,
-	.valid_rx_ant = ANT_AB,
-	.need_pll_cfg = true,
-};
-
diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
new file mode 100644
index 0000000..7da52f1
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -0,0 +1,73 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2008-2009 Intel Corporation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ *
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
+ *
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/pci.h>
+#include <linux/dma-mapping.h>
+#include <linux/delay.h>
+#include <linux/skbuff.h>
+#include <linux/netdevice.h>
+#include <linux/wireless.h>
+#include <net/mac80211.h>
+#include <linux/etherdevice.h>
+#include <asm/unaligned.h>
+
+#include "iwl-eeprom.h"
+#include "iwl-dev.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-sta.h"
+#include "iwl-helpers.h"
+#include "iwl-5000-hw.h"
+
+/* Highest firmware API version supported */
+#define IWL1000_UCODE_API_MAX 2
+
+/* Lowest firmware API version supported */
+#define IWL1000_UCODE_API_MIN 1
+
+#define IWL1000_FW_PRE "iwlwifi-1000-"
+#define _IWL1000_MODULE_FIRMWARE(api) IWL1000_FW_PRE #api ".ucode"
+#define IWL1000_MODULE_FIRMWARE(api) _IWL1000_MODULE_FIRMWARE(api)
+
+struct iwl_cfg iwl1000_bgn_cfg = {
+	.name = "1000 Series BGN",
+	.fw_name_pre = IWL1000_FW_PRE,
+	.ucode_api_max = IWL1000_UCODE_API_MAX,
+	.ucode_api_min = IWL1000_UCODE_API_MIN,
+	.sku = IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+	.valid_tx_ant = ANT_A,
+	.valid_rx_ant = ANT_AB,
+	.need_pll_cfg = true,
+};
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 7902d22..da98886 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -3643,9 +3643,9 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x0087, PCI_ANY_ID, iwl6050_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0088, PCI_ANY_ID, iwl6050_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0089, PCI_ANY_ID, iwl6050_2agn_cfg)},
-/* 100 Series WiFi */
-	{IWL_PCI_DEVICE(0x0083, PCI_ANY_ID, iwl100_bgn_cfg)},
-	{IWL_PCI_DEVICE(0x0084, PCI_ANY_ID, iwl100_bgn_cfg)},
+/* 1000 Series WiFi */
+	{IWL_PCI_DEVICE(0x0083, PCI_ANY_ID, iwl1000_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0084, PCI_ANY_ID, iwl1000_bgn_cfg)},
 #endif /* CONFIG_IWL5000 */
 
 	{0}
diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index 5028c78..2f12424 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -211,7 +211,7 @@
 #define CSR_HW_REV_TYPE_5350           (0x0000030)
 #define CSR_HW_REV_TYPE_5100           (0x0000050)
 #define CSR_HW_REV_TYPE_5150           (0x0000040)
-#define CSR_HW_REV_TYPE_100            (0x0000060)
+#define CSR_HW_REV_TYPE_1000           (0x0000060)
 #define CSR_HW_REV_TYPE_6x00           (0x0000070)
 #define CSR_HW_REV_TYPE_6x50           (0x0000080)
 #define CSR_HW_REV_TYPE_NONE           (0x00000F0)
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index b3e23ab..2176494 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -62,7 +62,7 @@ extern struct iwl_cfg iwl6000_2agn_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_3agn_cfg;
-extern struct iwl_cfg iwl100_bgn_cfg;
+extern struct iwl_cfg iwl1000_bgn_cfg;
 
 /* shared structures from iwl-5000.c */
 extern struct iwl_mod_params iwl50_mod_params;
-- 
1.5.6.3

