Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33466 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753708AbcGFKot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2016 06:44:49 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Haim Dreyfuss <haim.dreyfuss@intel.com>,
	Luca Coelho <luciano.coelho@intel.com>
Date: Wed,  6 Jul 2016 13:40:22 +0300
Message-Id: <1467801651-1816-27-git-send-email-luca@coelho.fi> (sfid-20160706_124453_893536_6D5198E0)
In-Reply-To: <1467801452.25088.20.camel@coelho.fi>
References: <1467801452.25088.20.camel@coelho.fi>
Subject: [PATCH 27/56] iwlwifi: Add a000 HW family support
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Haim Dreyfuss <haim.dreyfuss@intel.com>

Add a000 family configuration to iwl-cfg struct

Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/Makefile     |   2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c   | 130 ++++++++++++++++++++++++
 drivers/net/wireless/intel/iwlwifi/iwl-config.h |   2 +
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c   |   3 +
 4 files changed, 136 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/wireless/intel/iwlwifi/iwl-a000.c

diff --git a/drivers/net/wireless/intel/iwlwifi/Makefile b/drivers/net/wireless/intel/iwlwifi/Makefile
index 05828c6..6e7ed90 100644
--- a/drivers/net/wireless/intel/iwlwifi/Makefile
+++ b/drivers/net/wireless/intel/iwlwifi/Makefile
@@ -8,7 +8,7 @@ iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= iwl-phy-db.o iwl-nvm-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-$(CONFIG_IWLDVM) += iwl-1000.o iwl-2000.o iwl-5000.o iwl-6000.o
-iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o iwl-9000.o
+iwlwifi-$(CONFIG_IWLMVM) += iwl-7000.o iwl-8000.o iwl-9000.o iwl-a000.o
 iwlwifi-objs		+= iwl-trans.o
 
 iwlwifi-objs += $(iwlwifi-m)
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
new file mode 100644
index 0000000..220767e
--- /dev/null
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -0,0 +1,130 @@
+/******************************************************************************
+ *
+ * This file is provided under a dual BSD/GPLv2 license.  When using or
+ * redistributing this file, you may do so under either license.
+ *
+ * GPL LICENSE SUMMARY
+ *
+ * Copyright(c) 2015-2016 Intel Deutschland GmbH
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
+ * BSD LICENSE
+ *
+ * Copyright(c) 2015-2016 Intel Deutschland GmbH
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
+#define IWL_A000_UCODE_API_MAX	24
+
+/* Lowest firmware API version supported */
+#define IWL_A000_UCODE_API_MIN	24
+
+/* NVM versions */
+#define IWL_A000_NVM_VERSION		0x0a1d
+#define IWL_A000_TX_POWER_VERSION	0xffff /* meaningless */
+
+/* Memory offsets and lengths */
+#define IWL_A000_DCCM_OFFSET		0x800000
+#define IWL_A000_DCCM_LEN		0x18000
+#define IWL_A000_DCCM2_OFFSET		0x880000
+#define IWL_A000_DCCM2_LEN		0x8000
+#define IWL_A000_SMEM_OFFSET		0x400000
+#define IWL_A000_SMEM_LEN		0x68000
+
+#define IWL_A000_FW_PRE "iwlwifi-Qu-a0-jf-b0-"
+#define IWL_A000_MODULE_FIRMWARE(api) \
+	IWL_A000_FW_PRE "-" __stringify(api) ".ucode"
+
+#define NVM_HW_SECTION_NUM_FAMILY_A000		10
+
+static const struct iwl_base_params iwl_a000_base_params = {
+	.eeprom_size = OTP_LOW_IMAGE_SIZE_FAMILY_A000,
+	.num_of_queues = 31,
+	.shadow_ram_support = true,
+	.led_compensation = 57,
+	.wd_timeout = IWL_LONG_WD_TIMEOUT,
+	.max_event_log_size = 512,
+	.shadow_reg_enable = true,
+	.pcie_l1_allowed = true,
+};
+
+static const struct iwl_ht_params iwl_a000_ht_params = {
+	.stbc = true,
+	.ldpc = true,
+	.ht40_bands = BIT(NL80211_BAND_2GHZ) | BIT(NL80211_BAND_5GHZ),
+};
+
+#define IWL_DEVICE_A000							\
+	.ucode_api_max = IWL_A000_UCODE_API_MAX,			\
+	.ucode_api_min = IWL_A000_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_8000,			\
+	.max_inst_size = IWL60_RTC_INST_SIZE,				\
+	.max_data_size = IWL60_RTC_DATA_SIZE,				\
+	.base_params = &iwl_a000_base_params,				\
+	.led_mode = IWL_LED_RF_STATE,					\
+	.nvm_hw_section_num = NVM_HW_SECTION_NUM_FAMILY_A000,		\
+	.non_shared_ant = ANT_A,					\
+	.dccm_offset = IWL_A000_DCCM_OFFSET,				\
+	.dccm_len = IWL_A000_DCCM_LEN,					\
+	.dccm2_offset = IWL_A000_DCCM2_OFFSET,				\
+	.dccm2_len = IWL_A000_DCCM2_LEN,				\
+	.smem_offset = IWL_A000_SMEM_OFFSET,				\
+	.smem_len = IWL_A000_SMEM_LEN,					\
+	.features = IWL_TX_CSUM_NETIF_FLAGS | NETIF_F_RXCSUM,		\
+	.apmg_not_supported = true,					\
+	.mq_rx_supported = true,					\
+	.vht_mu_mimo_supported = true,					\
+	.mac_addr_from_csr = true
+
+const struct iwl_cfg iwla000_2ac_cfg = {
+		.name = "Intel(R) Dual Band Wireless AC a000",
+		.fw_name_pre = IWL_A000_FW_PRE,
+		IWL_DEVICE_A000,
+		.ht_params = &iwl_a000_ht_params,
+		.nvm_ver = IWL_A000_NVM_VERSION,
+		.nvm_calib_ver = IWL_A000_TX_POWER_VERSION,
+		.max_ht_ampdu_exponent = IEEE80211_HT_MAX_AMPDU_64K,
+};
+
+MODULE_FIRMWARE(IWL_A000_MODULE_FIRMWARE(IWL_A000_UCODE_API_MAX));
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-config.h b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
index 57b14f4..122e895 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-config.h
@@ -261,6 +261,7 @@ struct iwl_tt_params {
 #define OTP_LOW_IMAGE_SIZE_FAMILY_7000	(16 * 512 * sizeof(u16)) /* 16 KB */
 #define OTP_LOW_IMAGE_SIZE_FAMILY_8000	(32 * 512 * sizeof(u16)) /* 32 KB */
 #define OTP_LOW_IMAGE_SIZE_FAMILY_9000	OTP_LOW_IMAGE_SIZE_FAMILY_8000
+#define OTP_LOW_IMAGE_SIZE_FAMILY_A000	OTP_LOW_IMAGE_SIZE_FAMILY_9000
 
 struct iwl_eeprom_params {
 	const u8 regulatory_bands[7];
@@ -450,6 +451,7 @@ extern const struct iwl_cfg iwl4165_2ac_sdio_cfg;
 extern const struct iwl_cfg iwl9260_2ac_cfg;
 extern const struct iwl_cfg iwl9260lc_2ac_cfg;
 extern const struct iwl_cfg iwl5165_2ac_cfg;
+extern const struct iwl_cfg iwla000_2ac_cfg;
 #endif /* CONFIG_IWLMVM */
 
 #endif /* __IWL_CONFIG_H__ */
diff --git a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
index 6f020e4..f70c3e2 100644
--- a/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/pcie/drv.c
@@ -516,6 +516,9 @@ static const struct pci_device_id iwl_hw_card_ids[] = {
 	{IWL_PCI_DEVICE(0x2526, 0x1420, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x0710, iwl5165_2ac_cfg)},
 	{IWL_PCI_DEVICE(0x9DF0, 0x2A10, iwl5165_2ac_cfg)},
+
+/* a000 Series */
+	{IWL_PCI_DEVICE(0x2720, 0x0A10, iwla000_2ac_cfg)},
 #endif /* CONFIG_IWLMVM */
 
 	{0}
-- 
2.8.1

