Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:6919 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760013AbYDXSzp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:45 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>
Subject: [PATCH 06/21] iwlwifi-5000: adding initial recognition for the 5000 family
Date: Thu, 24 Apr 2008 11:55:23 -0700
Message-Id: <1209063338-6572-7-git-send-email-reinette.chatre@intel.com> (sfid-20080424_210548_525628_C1CC6A58)
In-Reply-To: <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds initial support for recognizing the iwl 5000 family of NICs
ID

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
---
 drivers/net/wireless/iwlwifi/Kconfig        |    8 ++
 drivers/net/wireless/iwlwifi/Makefile       |    5 ++
 drivers/net/wireless/iwlwifi/iwl-4965.h     |    3 +
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h  |   79 +++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-5000.c     |   93 +++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl4965-base.c |    5 ++
 6 files changed, 193 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-5000-hw.h
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-5000.c

diff --git a/drivers/net/wireless/iwlwifi/Kconfig b/drivers/net/wireless/iwlwifi/Kconfig
index 7b43578..4b829d3 100644
--- a/drivers/net/wireless/iwlwifi/Kconfig
+++ b/drivers/net/wireless/iwlwifi/Kconfig
@@ -105,6 +105,14 @@ config IWLWIFI_DEBUG
 	  as the debug information can assist others in helping you resolve
 	  any problems you may encounter.
 
+config IWL5000
+	bool "Intel Wireless WiFi 5000AGN"
+	depends on IWL4965
+	---help---
+	  This option enables support for Intel Wireless WiFi Link 5000AGN Family
+	  Dependency on 4965 is temporary
+
+
 config IWLWIFI_DEBUGFS
         bool "Iwlwifi debugfs support"
         depends on IWLCORE && IWLWIFI_DEBUG && MAC80211_DEBUGFS
diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index e83dd68..f733673 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -12,3 +12,8 @@ iwl3945-$(CONFIG_IWL3945_LEDS) += iwl-3945-led.o
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
 iwl4965-objs		:= iwl4965-base.o iwl-4965.o iwl-4965-rs.o iwl-sta.o
 
+ifeq ($(CONFIG_IWL5000),y)
+	iwl4965-objs += iwl-5000.o
+endif
+
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.h b/drivers/net/wireless/iwlwifi/iwl-4965.h
index 7b7c620..78fe8b7 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.h
@@ -48,6 +48,9 @@
 
 /* configuration for the iwl4965 */
 extern struct iwl_cfg iwl4965_agn_cfg;
+extern struct iwl_cfg iwl5300_agn_cfg;
+extern struct iwl_cfg iwl5100_agn_cfg;
+extern struct iwl_cfg iwl5350_agn_cfg;
 
 /* Change firmware file name, using "-" and incrementing number,
  *   *only* when uCode interface or architecture changes so that it
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
new file mode 100644
index 0000000..72a2665
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -0,0 +1,79 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2007 - 2008 Intel Corporation. All rights reserved.
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
+ * James P. Ketrenos <ipw2100-admin@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2005 - 2008 Intel Corporation. All rights reserved.
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
+ * Please use this file (iwl-5000-hw.h) only for hardware-related definitions.
+ * Use iwl-5000-commands.h for uCode API definitions.
+ */
+
+#ifndef __iwl_5000_hw_h__
+#define __iwl_5000_hw_h__
+
+
+#define IWL50_MAX_WIN_SIZE                64
+#define IWL50_QUEUE_SIZE                 256
+#define IWL50_CMD_FIFO_NUM                 7
+#define IWL50_NUM_QUEUES                  20
+#define IWL50_BACK_QUEUE_FIRST_ID         10
+
+#endif /* __iwl_5000_hw_h__ */
+
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
new file mode 100644
index 0000000..2314e31
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -0,0 +1,93 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2007-2008 Intel Corporation. All rights reserved.
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
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ *****************************************************************************/
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/version.h>
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
+#include "iwl-4965.h"
+#include "iwl-core.h"
+#include "iwl-io.h"
+#include "iwl-helpers.h"
+#include "iwl-5000-hw.h"
+
+#define IWL5000_UCODE_API  "-1"
+
+static struct iwl_mod_params iwl50_mod_params = {
+	.num_of_queues = IWL50_NUM_QUEUES,
+	.enable_qos = 1,
+	.amsdu_size_8K = 1,
+	/* the rest are 0 by default */
+};
+
+
+struct iwl_cfg iwl5300_agn_cfg = {
+	.name = "5300AGN",
+	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.mod_params = &iwl50_mod_params,
+};
+
+struct iwl_cfg iwl5100_agn_cfg = {
+	.name = "5100AGN",
+	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.mod_params = &iwl50_mod_params,
+};
+
+struct iwl_cfg iwl5350_agn_cfg = {
+	.name = "5350AGN",
+	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
+	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
+	.mod_params = &iwl50_mod_params,
+};
+
+module_param_named(disable50, iwl50_mod_params.disable, int, 0444);
+MODULE_PARM_DESC(disable50,
+		  "manually disable the 50XX radio (default 0 [radio on])");
+module_param_named(swcrypto50, iwl50_mod_params.sw_crypto, bool, 0444);
+MODULE_PARM_DESC(swcrypto50,
+		  "using software crypto engine (default 0 [hardware])\n");
+module_param_named(debug50, iwl50_mod_params.debug, int, 0444);
+MODULE_PARM_DESC(debug50, "50XX debug output mask");
+module_param_named(queues_num50, iwl50_mod_params.num_of_queues, int, 0444);
+MODULE_PARM_DESC(queues_num50, "number of hw queues in 50xx series");
+module_param_named(qos_enable50, iwl50_mod_params.enable_qos, int, 0444);
+MODULE_PARM_DESC(qos_enable50, "enable all 50XX QoS functionality");
+module_param_named(amsdu_size_8K50, iwl50_mod_params.amsdu_size_8K, int, 0444);
+MODULE_PARM_DESC(amsdu_size_8K50, "enable 8K amsdu size in 50XX series");
+
+
diff --git a/drivers/net/wireless/iwlwifi/iwl4965-base.c b/drivers/net/wireless/iwlwifi/iwl4965-base.c
index 5f99ef6..73657d9 100644
--- a/drivers/net/wireless/iwlwifi/iwl4965-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl4965-base.c
@@ -7389,6 +7389,11 @@ static int iwl4965_pci_resume(struct pci_dev *pdev)
 static struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x4229, PCI_ANY_ID, iwl4965_agn_cfg)},
 	{IWL_PCI_DEVICE(0x4230, PCI_ANY_ID, iwl4965_agn_cfg)},
+#ifdef CONFIG_IWL5000
+	{IWL_PCI_DEVICE(0x4235, PCI_ANY_ID, iwl5300_agn_cfg)},
+	{IWL_PCI_DEVICE(0x4232, PCI_ANY_ID, iwl5100_agn_cfg)},
+	{IWL_PCI_DEVICE(0x423A, PCI_ANY_ID, iwl5350_agn_cfg)},
+#endif /* CONFIG_IWL5000 */
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
-- 
1.5.3.4

