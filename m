Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41661 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3A1JhZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jan 2013 04:37:25 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 01/37] iwlwifi: add 7000 series device configuration
Date: Mon, 28 Jan 2013 10:37:08 +0100
Message-Id: <1359365864-4259-2-git-send-email-johannes@sipsolutions.net> (sfid-20130128_103729_258061_29DB9CBA)
In-Reply-To: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
References: <1359365864-4259-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add configuration and detection code for the new
7000 series, with 7260 and 3160 devices.

Change-Id: Idc662a2079dfa84f2cd64e34c107b009db5cce78
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile     |   1 +
 drivers/net/wireless/iwlwifi/iwl-config.h |   1 +
 drivers/net/wireless/iwlwifi/iwl-fh.h     |   1 +
 drivers/net/wireless/iwlwifi/iwl-prph.h   |   3 +
 drivers/net/wireless/iwlwifi/pcie/7000.c  | 111 ++++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/pcie/cfg.h   |   2 +
 drivers/net/wireless/iwlwifi/pcie/drv.c   |   6 ++
 7 files changed, 125 insertions(+)
 create mode 100644 drivers/net/wireless/iwlwifi/pcie/7000.c

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index 170ec33..98cb8e8 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -7,6 +7,7 @@ iwlwifi-objs		+= iwl-notif-wait.o
 iwlwifi-objs		+= iwl-eeprom-read.o iwl-eeprom-parse.o
 iwlwifi-objs		+= pcie/drv.o pcie/rx.o pcie/tx.o pcie/trans.o
 iwlwifi-objs		+= pcie/1000.o pcie/2000.o pcie/5000.o pcie/6000.o
+iwlwifi-objs		+= pcie/7000.o
 
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
 iwlwifi-$(CONFIG_IWLWIFI_DEVICE_TESTMODE) += iwl-test.o
diff --git a/drivers/net/wireless/iwlwifi/iwl-config.h b/drivers/net/wireless/iwlwifi/iwl-config.h
index 61a7a35..743b483 100644
--- a/drivers/net/wireless/iwlwifi/iwl-config.h
+++ b/drivers/net/wireless/iwlwifi/iwl-config.h
@@ -83,6 +83,7 @@ enum iwl_device_family {
 	IWL_DEVICE_FAMILY_6030,
 	IWL_DEVICE_FAMILY_6050,
 	IWL_DEVICE_FAMILY_6150,
+	IWL_DEVICE_FAMILY_7000,
 };
 
 /*
diff --git a/drivers/net/wireless/iwlwifi/iwl-fh.h b/drivers/net/wireless/iwlwifi/iwl-fh.h
index 39c79ec..f5592fb 100644
--- a/drivers/net/wireless/iwlwifi/iwl-fh.h
+++ b/drivers/net/wireless/iwlwifi/iwl-fh.h
@@ -414,6 +414,7 @@ static inline unsigned int FH_MEM_CBBC_QUEUE(unsigned int chnl)
  *	uCode/driver must write "1" in order to clear this flag
  */
 #define FH_TSSR_TX_ERROR_REG		(FH_TSSR_LOWER_BOUND + 0x018)
+#define FH_TSSR_TX_MSG_CONFIG_REG	(FH_TSSR_LOWER_BOUND + 0x008)
 
 #define FH_TSSR_TX_STATUS_REG_MSK_CHNL_IDLE(_chnl) ((1 << (_chnl)) << 16)
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-prph.h b/drivers/net/wireless/iwlwifi/iwl-prph.h
index f46a3f2..f76e9ca 100644
--- a/drivers/net/wireless/iwlwifi/iwl-prph.h
+++ b/drivers/net/wireless/iwlwifi/iwl-prph.h
@@ -97,6 +97,9 @@
 
 #define APMG_PCIDEV_STT_VAL_L1_ACT_DIS		(0x00000800)
 
+/* Device system time */
+#define DEVICE_SYSTEM_TIME_REG 0xA0206C
+
 /**
  * Tx Scheduler
  *
diff --git a/drivers/net/wireless/iwlwifi/pcie/7000.c b/drivers/net/wireless/iwlwifi/pcie/7000.c
new file mode 100644
index 0000000..6e35b2b
--- /dev/null
+++ b/drivers/net/wireless/iwlwifi/pcie/7000.c
@@ -0,0 +1,111 @@
+/******************************************************************************
+ *
+ * Copyright(c) 2008 - 2013 Intel Corporation. All rights reserved.
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
+#include <linux/module.h>
+#include <linux/stringify.h>
+#include "iwl-config.h"
+#include "iwl-agn-hw.h"
+#include "cfg.h"
+
+/* Highest firmware API version supported */
+#define IWL7260_UCODE_API_MAX	6
+#define IWL3160_UCODE_API_MAX	6
+
+/* Oldest version we won't warn about */
+#define IWL7260_UCODE_API_OK	6
+#define IWL3160_UCODE_API_OK	6
+
+/* Lowest firmware API version supported */
+#define IWL7260_UCODE_API_MIN	6
+#define IWL3160_UCODE_API_MIN	6
+
+/* NVM versions */
+#define IWL7260_NVM_VERSION		0x0a1d
+#define IWL7260_TX_POWER_VERSION	0xffff /* meaningless */
+#define IWL3160_NVM_VERSION		0x709
+#define IWL3160_TX_POWER_VERSION	0xffff /* meaningless */
+
+#define IWL7260_FW_PRE "iwlwifi-7260-"
+#define IWL7260_MODULE_FIRMWARE(api) IWL7260_FW_PRE __stringify(api) ".ucode"
+
+#define IWL3160_FW_PRE "iwlwifi-3160-"
+#define IWL3160_MODULE_FIRMWARE(api) IWL3160_FW_PRE __stringify(api) ".ucode"
+
+static const struct iwl_base_params iwl7000_base_params = {
+	.eeprom_size = OTP_LOW_IMAGE_SIZE,
+	.num_of_queues = IWLAGN_NUM_QUEUES,
+	.pll_cfg_val = 0,
+	.shadow_ram_support = true,
+	.led_compensation = 57,
+	.adv_thermal_throttle = true,
+	.support_ct_kill_exit = true,
+	.plcp_delta_threshold = IWL_MAX_PLCP_ERR_THRESHOLD_DEF,
+	.chain_noise_scale = 1000,
+	.wd_timeout = IWL_LONG_WD_TIMEOUT,
+	.max_event_log_size = 512,
+	.shadow_reg_enable = false, /* TODO: fix bugs using this feature */
+};
+
+static const struct iwl_ht_params iwl7000_ht_params = {
+	.ht_greenfield_support = true,
+	.use_rts_for_aggregation = true, /* use rts/cts protection */
+	.ht40_bands = BIT(IEEE80211_BAND_2GHZ) | BIT(IEEE80211_BAND_5GHZ),
+};
+
+#define IWL_DEVICE_7000						\
+	.ucode_api_max = IWL7260_UCODE_API_MAX,			\
+	.ucode_api_ok = IWL7260_UCODE_API_OK,			\
+	.ucode_api_min = IWL7260_UCODE_API_MIN,			\
+	.device_family = IWL_DEVICE_FAMILY_7000,		\
+	.max_inst_size = IWL60_RTC_INST_SIZE,			\
+	.max_data_size = IWL60_RTC_DATA_SIZE,			\
+	.base_params = &iwl7000_base_params,			\
+	/* TODO: .bt_params? */					\
+	.need_temp_offset_calib = true,				\
+	.led_mode = IWL_LED_RF_STATE,				\
+	.adv_pm = true						\
+
+
+const struct iwl_cfg iwl7260_2ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC7260",
+	.fw_name_pre = IWL7260_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL7260_NVM_VERSION,
+	.nvm_calib_ver = IWL7260_TX_POWER_VERSION,
+};
+
+const struct iwl_cfg iwl3160_ac_cfg = {
+	.name = "Intel(R) Dual Band Wireless AC3160",
+	.fw_name_pre = IWL3160_FW_PRE,
+	IWL_DEVICE_7000,
+	.ht_params = &iwl7000_ht_params,
+	.nvm_ver = IWL3160_NVM_VERSION,
+	.nvm_calib_ver = IWL3160_TX_POWER_VERSION,
+};
+
+MODULE_FIRMWARE(IWL7260_MODULE_FIRMWARE(IWL7260_UCODE_API_OK));
+MODULE_FIRMWARE(IWL3160_MODULE_FIRMWARE(IWL3160_UCODE_API_OK));
diff --git a/drivers/net/wireless/iwlwifi/pcie/cfg.h b/drivers/net/wireless/iwlwifi/pcie/cfg.h
index 3061063..c6f8e83 100644
--- a/drivers/net/wireless/iwlwifi/pcie/cfg.h
+++ b/drivers/net/wireless/iwlwifi/pcie/cfg.h
@@ -109,5 +109,7 @@ extern const struct iwl_cfg iwl6035_2agn_cfg;
 extern const struct iwl_cfg iwl105_bgn_cfg;
 extern const struct iwl_cfg iwl105_bgn_d_cfg;
 extern const struct iwl_cfg iwl135_bgn_cfg;
+extern const struct iwl_cfg iwl7260_2ac_cfg;
+extern const struct iwl_cfg iwl3160_ac_cfg;
 
 #endif /* __iwl_pci_h__ */
diff --git a/drivers/net/wireless/iwlwifi/pcie/drv.c b/drivers/net/wireless/iwlwifi/pcie/drv.c
index 5651d31..7bc0fb9 100644
--- a/drivers/net/wireless/iwlwifi/pcie/drv.c
+++ b/drivers/net/wireless/iwlwifi/pcie/drv.c
@@ -255,6 +255,12 @@ static DEFINE_PCI_DEVICE_TABLE(iwl_hw_card_ids) = {
 	{IWL_PCI_DEVICE(0x0893, 0x0262, iwl135_bgn_cfg)},
 	{IWL_PCI_DEVICE(0x0892, 0x0462, iwl135_bgn_cfg)},
 
+/* 7000 Series */
+	{IWL_PCI_DEVICE(0x08B1, 0x4070, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B1, 0xC070, iwl7260_2ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x0070, iwl3160_ac_cfg)},
+	{IWL_PCI_DEVICE(0x08B3, 0x8070, iwl3160_ac_cfg)},
+
 	{0}
 };
 MODULE_DEVICE_TABLE(pci, iwl_hw_card_ids);
-- 
1.8.0

