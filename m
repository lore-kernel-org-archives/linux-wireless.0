Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:4998 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753535AbZASX2V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:21 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 15/15] iwlwifi: add recognition of Intel WiFi Link 100 Series
Date: Mon, 19 Jan 2009 15:30:35 -0800
Message-Id: <1232407835-19451-16-git-send-email-reinette.chatre@intel.com> (sfid-20090120_003051_689830_B66FF185)
In-Reply-To: <1232407835-19451-15-git-send-email-reinette.chatre@intel.com>
References: <>
 <1232407835-19451-1-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-2-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-3-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-4-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-5-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-6-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-7-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-8-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-9-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-10-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-11-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-12-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-13-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-14-git-send-email-reinette.chatre@intel.com>
 <1232407835-19451-15-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

add configuration for new Intel WiFi Link 100 series as part of the
iwlagn driver under the umbrella of 5000 family of devices.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile  |    1 +
 drivers/net/wireless/iwlwifi/iwl-100.c |   70 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c |    3 +
 drivers/net/wireless/iwlwifi/iwl-dev.h |    1 +
 4 files changed, 75 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-100.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 1347d0c..fec2fbf 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -13,6 +13,7 @@ iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-hcmd-check.o
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
 iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
+iwlagn-$(CONFIG_IWL5000) += iwl-100.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-100.c b/drivers/net/wireless/iwlwifi/iwl-100.c
new file mode 100644
index 0000000..dbadaf4
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-100.c
@@ -0,0 +1,70 @@
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
+#define IWL100_UCODE_API_MAX 1
+
+/* Lowest firmware API version supported */
+#define IWL100_UCODE_API_MIN 1
+
+#define IWL100_FW_PRE "iwlwifi-100-"
+#define _IWL100_MODULE_FIRMWARE(api) IWL100_FW_PRE #api ".ucode"
+#define IWL100_MODULE_FIRMWARE(api) _IWL100_MODULE_FIRMWARE(api)
+
+struct iwl_cfg iwl100_bgn_cfg = {
+	.name = "100 Series BGN",
+	.fw_name_pre = IWL100_FW_PRE,
+	.ucode_api_max = IWL100_UCODE_API_MAX,
+	.ucode_api_min = IWL100_UCODE_API_MIN,
+	.sku = IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+};
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index 00f73a6..fc6f639 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4183,6 +4183,9 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x0087, PCI_ANY_ID, iwl6050_2agn_cfg)},
 	{IWL_PCI_DEVICE(0x0088, PCI_ANY_ID, iwl6050_3agn_cfg)},
 	{IWL_PCI_DEVICE(0x0089, PCI_ANY_ID, iwl6050_2agn_cfg)},
+/* 100 Series WiFi */
+	{IWL_PCI_DEVICE(0x0083, PCI_ANY_ID, iwl100_bgn_cfg)},
+	{IWL_PCI_DEVICE(0x0084, PCI_ANY_ID, iwl100_bgn_cfg)},
 #endif /* CONFIG_IWL5000 */
 
 	{0}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 199e331..79f2d45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -62,6 +62,7 @@ extern struct iwl_cfg iwl6000_2agn_cfg;
 extern struct iwl_cfg iwl6000_3agn_cfg;
 extern struct iwl_cfg iwl6050_2agn_cfg;
 extern struct iwl_cfg iwl6050_3agn_cfg;
+extern struct iwl_cfg iwl100_bgn_cfg;
 
 /* shared structures from iwl-5000.c */
 extern struct iwl_mod_params iwl50_mod_params;
-- 
1.5.4.3

