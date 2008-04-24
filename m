Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:51290 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757949AbYDXSzo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2008 14:55:44 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Tomas Winkler <tomas.winkler@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/21] iwlwifi-5000: EEPROM settings for 5000
Date: Thu, 24 Apr 2008 11:55:27 -0700
Message-Id: <1209063338-6572-11-git-send-email-reinette.chatre@intel.com> (sfid-20080424_205622_544277_A6D8E78F)
In-Reply-To: <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
References: <1209063338-6572-1-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-2-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-3-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-4-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-5-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-6-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-7-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-8-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-9-git-send-email-reinette.chatre@intel.com>
 <1209063338-6572-10-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Tomas Winkler <tomas.winkler@intel.com>

This patch adds eeprom handlers and values for 5000 HW family

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |    3 +
 drivers/net/wireless/iwlwifi/iwl-5000.c    |   62 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwlwifi/iwl-eeprom.h  |   30 +++++++++++++
 3 files changed, 95 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 72a2665..5cf8a68 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -68,6 +68,9 @@
 #ifndef __iwl_5000_hw_h__
 #define __iwl_5000_hw_h__
 
+/* EERPROM */
+#define IWL_5000_EEPROM_IMG_SIZE			2048
+
 
 #define IWL50_MAX_WIN_SIZE                64
 #define IWL50_QUEUE_SIZE                 256
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index 58a35cb..91b3e56 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -86,6 +86,55 @@ static int iwl5000_apm_init(struct iwl_priv *priv)
 	return ret;
 }
 
+/*
+ * EEPROM
+ */
+static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
+{
+	u16 offset = 0;
+
+	if ((address & INDIRECT_ADDRESS) == 0)
+		return address;
+
+	switch (address & INDIRECT_TYPE_MSK) {
+	case INDIRECT_HOST:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_HOST);
+		break;
+	case INDIRECT_GENERAL:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_GENERAL);
+		break;
+	case INDIRECT_REGULATORY:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_REGULATORY);
+		break;
+	case INDIRECT_CALIBRATION:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_CALIBRATION);
+		break;
+	case INDIRECT_PROCESS_ADJST:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_PROCESS_ADJST);
+		break;
+	case INDIRECT_OTHERS:
+		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_OTHERS);
+		break;
+	default:
+		IWL_ERROR("illegal indirect type: 0x%X\n",
+		address & INDIRECT_TYPE_MSK);
+		break;
+	}
+
+	/* translate the offset from words to byte */
+	return (address & ADDRESS_MSK) + (offset << 1);
+}
+
+static const u8 *iwl5000_eeprom_query_addr(const struct iwl_priv *priv,
+					   size_t offset)
+{
+	u32 address = eeprom_indirect_address(priv, offset);
+	BUG_ON(address >= priv->cfg->eeprom_size);
+	return &priv->eeprom[address];
+}
+
+
+
 static struct iwl_hcmd_ops iwl5000_hcmd = {
 };
 
@@ -98,9 +147,19 @@ static struct iwl_lib_ops iwl5000_lib = {
 		.set_pwr_src = iwl4965_set_pwr_src,
 	},
 	.eeprom_ops = {
+		.regulatory_bands = {
+			EEPROM_5000_REG_BAND_1_CHANNELS,
+			EEPROM_5000_REG_BAND_2_CHANNELS,
+			EEPROM_5000_REG_BAND_3_CHANNELS,
+			EEPROM_5000_REG_BAND_4_CHANNELS,
+			EEPROM_5000_REG_BAND_5_CHANNELS,
+			EEPROM_5000_REG_BAND_24_FAT_CHANNELS,
+			EEPROM_5000_REG_BAND_52_FAT_CHANNELS
+		},
 		.verify_signature  = iwlcore_eeprom_verify_signature,
 		.acquire_semaphore = iwlcore_eeprom_acquire_semaphore,
 		.release_semaphore = iwlcore_eeprom_release_semaphore,
+		.query_addr = iwl5000_eeprom_query_addr,
 	},
 };
 
@@ -123,6 +182,7 @@ struct iwl_cfg iwl5300_agn_cfg = {
 	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -131,6 +191,7 @@ struct iwl_cfg iwl5100_agn_cfg = {
 	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.mod_params = &iwl50_mod_params,
 };
 
@@ -139,6 +200,7 @@ struct iwl_cfg iwl5350_agn_cfg = {
 	.fw_name = "iwlwifi-5000" IWL5000_UCODE_API ".ucode",
 	.sku = IWL_SKU_A|IWL_SKU_G|IWL_SKU_N,
 	.ops = &iwl5000_ops,
+	.eeprom_size = IWL_5000_EEPROM_IMG_SIZE,
 	.mod_params = &iwl50_mod_params,
 };
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 0c42e5a..56e0a07 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -140,6 +140,36 @@ struct iwl_eeprom_channel {
 #define EEPROM_4965_BOARD_REVISION             (2*0x4F) /* 2 bytes */
 #define EEPROM_4965_BOARD_PBA                  (2*0x56+1) /* 9 bytes */
 
+/*5000 calibrations */
+#define EEPROM_5000_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
+
+/* 5000 links */
+#define EEPROM_5000_LINK_HOST             (2*0x64)
+#define EEPROM_5000_LINK_GENERAL          (2*0x65)
+#define EEPROM_5000_LINK_REGULATORY       (2*0x66)
+#define EEPROM_5000_LINK_CALIBRATION      (2*0x67)
+#define EEPROM_5000_LINK_PROCESS_ADJST    (2*0x68)
+#define EEPROM_5000_LINK_OTHERS           (2*0x69)
+
+/* 5000 regulatory - indirect access */
+#define EEPROM_5000_REG_SKU_ID ((0x02)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 4  bytes */
+#define EEPROM_5000_REG_BAND_1_CHANNELS       ((0x08)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 28 bytes */
+#define EEPROM_5000_REG_BAND_2_CHANNELS       ((0x26)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 26 bytes */
+#define EEPROM_5000_REG_BAND_3_CHANNELS       ((0x42)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
+#define EEPROM_5000_REG_BAND_4_CHANNELS       ((0x5C)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22 bytes */
+#define EEPROM_5000_REG_BAND_5_CHANNELS       ((0x74)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 12 bytes */
+#define EEPROM_5000_REG_BAND_24_FAT_CHANNELS  ((0x82)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 14  bytes */
+#define EEPROM_5000_REG_BAND_52_FAT_CHANNELS  ((0x92)\
+		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 22  bytes */
+
+
 /* 2.4 GHz */
 extern const u8 iwl_eeprom_band_1[14];
 
-- 
1.5.3.4

