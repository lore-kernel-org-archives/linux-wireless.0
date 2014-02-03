Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39995 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984AbaBCU6U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:58:20 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so3983707eae.33
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:58:18 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Eran Harary <eran.harary@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 02/62] iwlwifi: Add 8000 HW family support
Date: Mon,  3 Feb 2014 22:57:08 +0200
Message-Id: <1391461088-8082-2-git-send-email-egrumbach@gmail.com> (sfid-20140203_215823_592910_95890538)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eran Harary <eran.harary@intel.com>

add 8000-family configuration to iwl_cfg struct.

Signed-off-by: Eran Harary <eran.harary@intel.com>
Reviewed-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile     |    2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c   |  120 +++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-config.h |    2 +
 drivers/net/wireless/iwlwifi/pcie/drv.c   |    4 +
 4 files changed, 127 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/iwlwifi/iwl-8000.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 1fa6442..3d32f41 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -8,7 +8,7 @@ iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-$(CONFIG_IWLDVM) += iwl-1000.o iwl-2000.o iwl-5000.o iwl-6000.o
-iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o
+iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o
 
 iwlwifi-objs += $(iwlwifi-m)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
new file mode 100644
index 0000000..feca7a7
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -0,0 +1,120 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2014 Intel Corporation. All rights reserved.
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
+ * in the file called COPYING.
+ *
+ * Contact Information:
+ *  Intel Linux Wireless <ilw@linux.intel.com>
+ * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
+ *
+ * BSD LICENSE
+ *
+ * Copyright(c) 2014 Intel Corporation. All rights reserved.
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
+
+#include <linux/module.h>
+#include <linux/stringify.h>
+#include "iwl-config.h"
+#include "iwl-agn-hw.h"
+
+/* Highest firmware API version supported */
+#define IWL8000_UCODE_API_MAX	8
+
+/* Oldest version we won't warn about */
+#define IWL8000_UCODE_API_OK	8
+
+/* Lowest firmware API version supported */
+#define IWL8000_UCODE_API_MIN	8
+
+/* NVM versions */
+#define IWL8000_NVM_VERSION		0x0a1d
+#define IWL8000_TX_POWER_VERSION	0xffff /* meaningless */
+
+#define IWL8000_FW_PRE "iwlwifi-8000-"
+#define IWL8000_MODULE_FIRMWARE(api) IWL8000_FW_PRE __stringify(api) ".ucode"
+
+static const struct iwl_base_params iwl8000_base_params = {
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.pll_cfg_val = 0,
+	.shadow_ram_support = true,
+	.led_compensation = 57,
+	.wd_timeout = IWL_LONG_WD_TIMEOUT,
+	.max_event_log_size = 512,
+	.shadow_reg_enable = true,
+	.pcie_l1_allowed = true,
+};
+
+static const struct iwl_ht_params iwl8000_ht_params = {
+	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+};
+
+#define IWL_DEVICE_8000						\
+	.ucode_api_max = IWL8000_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL8000_UCODE_API_OK,			\
+	.ucode_api_min = IWL8000_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_8000,		\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.base_params = &iwl8000_base_params,			\
+	.led_mode = IWL_LED_RF_STATE
+
+const struct iwl_cfg iwl8260_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC 8260",
+	.fw_name_pre = IWL8000_FW_PRE,
+	IWL_DEVICE_8000,
+	.ht_params = &iwl8000_ht_params,
+	.nvm_ver = IWL8000_NVM_VERSION,
+	.nvm_calib_ver = IWL8000_TX_POWER_VERSION,
+};
+
+MODULE_FIRMWARE(IWL8000_MODULE_FIRMWARE(IWL8000_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 1ced525..5b74924 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -84,6 +84,7 @@ enum iwl_device_family {
 	IWL_DEVICE_FAMILY_6050,
 	IWL_DEVICE_FAMILY_6150,
 	IWL_DEVICE_FAMILY_7000,
+	IWL_DEVICE_FAMILY_8000,
 };
 
 /*
@@ -307,6 +308,7 @@ extern const struct iwl_cfg iwl3160_n_cfg;
 extern const struct iwl_cfg iwl7265_2ac_cfg;
 extern const struct iwl_cfg iwl7265_2n_cfg;
 extern const struct iwl_cfg iwl7265_n_cfg;
+extern const struct iwl_cfg iwl8260_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 3040924..4b3a49b 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -385,6 +385,10 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x095A, 0x5590, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095B, 0x5290, iwl7265_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x095A, 0x5490, iwl7265_2ac_cfg)},
+
+/* 8000 Series */
+	{IWL_PCI_DEVICE(0x24F3, 0x0010, iwl8260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x24F4, 0x0030, iwl8260_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
1.7.9.5

