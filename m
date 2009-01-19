Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:37215 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753946AbZASX2U (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2009 18:28:20 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 14/15] iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series
Date: Mon, 19 Jan 2009 15:30:34 -0800
Message-Id: <1232407835-19451-15-git-send-email-reinette.chatre@intel.com> (sfid-20090120_003051_399866_7436A6F3)
In-Reply-To: <1232407835-19451-14-git-send-email-reinette.chatre@intel.com>
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
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

add configuration for new Intel WiFi Link Series as part of the iwlagn
driver under the umbrella of 5000 family of devices.

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile      |    1 +
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h |   81 +++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-6000.c    |  130 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-agn.c     |   12 +++
 drivers/net/wireless/iwlwifi/iwl-dev.h     |    5 +
 5 files changed, 229 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-6000-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-6000.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 0be9e6b..1347d0c 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -12,6 +12,7 @@ iwlagn-objs		:= iwl-agn.o iwl-agn-rs.o iwl-agn-hcmd-check.o
 
 iwlagn-$(CONFIG_IWL4965) += iwl-4965.o
 iwlagn-$(CONFIG_IWL5000) += iwl-5000.o
+iwlagn-$(CONFIG_IWL5000) += iwl-6000.o
 
 obj-$(CONFIG_IWL3945)	+= iwl3945.o
 iwl3945-objs		:= iwl3945-base.o iwl-3945.o iwl-3945-rs.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
new file mode 100644
index 0000000..9018577
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
@@ -0,0 +1,81 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2009 Intel Corporation. All rights reserved.
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
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2009 Intel Corporation. All rights reserved.
+ * All rights reserved.
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ *
+ *  * Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions and the following disclaimer.
+ *  * Redistributions in binary form must reproduce the above copyright
+ *    notice, this list of conditions and the following disclaimer in
+ *    the documentation and/or other materials provided with the
+ *    distribution.
+ *  * Neither the name Intel Corporation nor the names of its
+ *    contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
+ * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
+ * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
+ * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
+ * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
+ * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
+ * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
+ *
+ *****************************************************************************/
+/*
+ * Please use this file (iwl-6000-hw.h) only for hardware-related definitions.
+ * Use iwl-5000-commands.h for uCode API definitions.
+ */
+
+#ifndef __iwl_6000_hw_h__
+#define __iwl_6000_hw_h__
+
+#define IWL60_RTC_INST_LOWER_BOUND		(0x000000)
+#define IWL60_RTC_INST_UPPER_BOUND		(0x040000)
+#define IWL60_RTC_DATA_LOWER_BOUND		(0x800000)
+#define IWL60_RTC_DATA_UPPER_BOUND		(0x814000)
+#define IWL60_RTC_INST_SIZE \
+	(IWL60_RTC_INST_UPPER_BOUND - IWL60_RTC_INST_LOWER_BOUND)
+#define IWL60_RTC_DATA_SIZE \
+	(IWL60_RTC_DATA_UPPER_BOUND - IWL60_RTC_DATA_LOWER_BOUND)
+
+#endif /* __iwl_6000_hw_h__ */
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
new file mode 100644
index 0000000..4515a60
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -0,0 +1,130 @@
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
+#define IWL6000_UCODE_API_MAX 1
+#define IWL6050_UCODE_API_MAX 1
+
+/* Lowest firmware API version supported */
+#define IWL6000_UCODE_API_MIN 1
+#define IWL6050_UCODE_API_MIN 1
+
+#define IWL6000_FW_PRE "iwlwifi-6000-"
+#define _IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
+#define IWL6000_MODULE_FIRMWARE(api) _IWL6000_MODULE_FIRMWARE(api)
+
+#define IWL6050_FW_PRE "iwlwifi-6050-"
+#define _IWL6050_MODULE_FIRMWARE(api) IWL6050_FW_PRE #api ".ucode"
+#define IWL6050_MODULE_FIRMWARE(api) _IWL6050_MODULE_FIRMWARE(api)
+
+struct iwl_cfg iwl6000_2ag_cfg = {
+	.name = "6000 Series 2x2 AG",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+};
+
+struct iwl_cfg iwl6000_2agn_cfg = {
+	.name = "6000 Series 2x2 AGN",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+};
+
+struct iwl_cfg iwl6050_2agn_cfg = {
+	.name = "6050 Series 2x2 AGN",
+	.fw_name_pre = IWL6050_FW_PRE,
+	.ucode_api_max = IWL6050_UCODE_API_MAX,
+	.ucode_api_min = IWL6050_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+};
+
+struct iwl_cfg iwl6000_3agn_cfg = {
+	.name = "6000 Series 3x3 AGN",
+	.fw_name_pre = IWL6000_FW_PRE,
+	.ucode_api_max = IWL6000_UCODE_API_MAX,
+	.ucode_api_min = IWL6000_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+};
+
+struct iwl_cfg iwl6050_3agn_cfg = {
+	.name = "6050 Series 3x3 AGN",
+	.fw_name_pre = IWL6050_FW_PRE,
+	.ucode_api_max = IWL6050_UCODE_API_MAX,
+	.ucode_api_min = IWL6050_UCODE_API_MIN,
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
+	.eeprom_ver = EEPROM_5000_EEPROM_VERSION,
+	.eeprom_calib_ver = EEPROM_5000_TX_POWER_VERSION,
+	.mod_params = &iwl50_mod_params,
+};
+
+MODULE_FIRMWARE(IWL6000_MODULE_FIRMWARE(IWL6000_UCODE_API_MAX));
+MODULE_FIRMWARE(IWL6050_MODULE_FIRMWARE(IWL6050_UCODE_API_MAX));
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.c b/drivers/net/wireless/iwlwifi/iwl-agn.c
index f3f00ce..00f73a6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.c
@@ -4171,6 +4171,18 @@ static struct pci_device_id iwl_hw_card_ids[] = {
 /* 5150 Wifi/WiMax */
 	{IWL_PCI_DEVICE(0x423C, PCI_ANY_ID, iwl5150_agn_cfg)},
 	{IWL_PCI_DEVICE(0x423D, PCI_ANY_ID, iwl5150_agn_cfg)},
+/* 6000/6050 Series */
+	{IWL_PCI_DEVICE(0x0082, 0x1102, iwl6000_2ag_cfg)},
+	{IWL_PCI_DEVICE(0x0085, 0x1112, iwl6000_2ag_cfg)},
+	{IWL_PCI_DEVICE(0x0082, 0x1122, iwl6000_2ag_cfg)},
+	{IWL_PCI_DEVICE(0x422B, PCI_ANY_ID, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x4238, PCI_ANY_ID, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x0082, PCI_ANY_ID, iwl6000_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0085, PCI_ANY_ID, iwl6000_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x0086, PCI_ANY_ID, iwl6050_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x0087, PCI_ANY_ID, iwl6050_2agn_cfg)},
+	{IWL_PCI_DEVICE(0x0088, PCI_ANY_ID, iwl6050_3agn_cfg)},
+	{IWL_PCI_DEVICE(0x0089, PCI_ANY_ID, iwl6050_2agn_cfg)},
 #endif /* CONFIG_IWL5000 */
 
 	{0}
diff --git a/drivers/net/wireless/iwlwifi/iwl-dev.h b/drivers/net/wireless/iwlwifi/iwl-dev.h
index 2602944..199e331 100644
--- a/drivers/net/wireless/iwlwifi/iwl-dev.h
+++ b/drivers/net/wireless/iwlwifi/iwl-dev.h
@@ -57,6 +57,11 @@ extern struct iwl_cfg iwl5350_agn_cfg;
 extern struct iwl_cfg iwl5100_bg_cfg;
 extern struct iwl_cfg iwl5100_abg_cfg;
 extern struct iwl_cfg iwl5150_agn_cfg;
+extern struct iwl_cfg iwl6000_2ag_cfg;
+extern struct iwl_cfg iwl6000_2agn_cfg;
+extern struct iwl_cfg iwl6000_3agn_cfg;
+extern struct iwl_cfg iwl6050_2agn_cfg;
+extern struct iwl_cfg iwl6050_3agn_cfg;
 
 /* shared structures from iwl-5000.c */
 extern struct iwl_mod_params iwl50_mod_params;
-- 
1.5.4.3

