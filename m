Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14249 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932585Ab0DPVwm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:52:42 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 08/21] iwlwifi: more generic eeprom defines
Date: Fri, 16 Apr 2010 14:52:25 -0700
Message-Id: <1271454758-14351-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
References: <1271454758-14351-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Some definition for eeprom apply to more than 5000 series device, change
the name to reflect it for easy reading.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn-lib.c   |   14 +++++-----
 drivers/net/wireless/iwlwifi/iwl-agn-ucode.c |    2 +-
 drivers/net/wireless/iwlwifi/iwl-eeprom.h    |   32 +++++++++++++-------------
 3 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
index 048c615..2d00e83 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-lib.c
@@ -331,7 +331,7 @@ u16 iwlagn_eeprom_calib_version(struct iwl_priv *priv)
 	} *hdr;
 
 	hdr = (struct iwl_eeprom_calib_hdr *)iwl_eeprom_query_addr(priv,
-							EEPROM_5000_CALIB_ALL);
+							EEPROM_CALIB_ALL);
 	return hdr->version;
 
 }
@@ -348,22 +348,22 @@ static u32 eeprom_indirect_address(const struct iwl_priv *priv, u32 address)
 
 	switch (address & INDIRECT_TYPE_MSK) {
 	case INDIRECT_HOST:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_HOST);
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_HOST);
 		break;
 	case INDIRECT_GENERAL:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_GENERAL);
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_GENERAL);
 		break;
 	case INDIRECT_REGULATORY:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_REGULATORY);
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_REGULATORY);
 		break;
 	case INDIRECT_CALIBRATION:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_CALIBRATION);
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_CALIBRATION);
 		break;
 	case INDIRECT_PROCESS_ADJST:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_PROCESS_ADJST);
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_PROCESS_ADJST);
 		break;
 	case INDIRECT_OTHERS:
-		offset = iwl_eeprom_query16(priv, EEPROM_5000_LINK_OTHERS);
+		offset = iwl_eeprom_query16(priv, EEPROM_LINK_OTHERS);
 		break;
 	default:
 		IWL_ERR(priv, "illegal indirect type: 0x%X\n",
diff --git a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
index 52ae157..059b70e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
+++ b/drivers/net/wireless/iwlwifi/iwl-agn-ucode.c
@@ -207,7 +207,7 @@ static int iwlagn_set_Xtal_calib(struct iwl_priv *priv)
 {
 	struct iwl_calib_xtal_freq_cmd cmd;
 	__le16 *xtal_calib =
-		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_5000_XTAL);
+		(__le16 *)iwl_eeprom_query_addr(priv, EEPROM_XTAL);
 
 	cmd.hdr.op_code = IWL_PHY_CALIBRATE_CRYSTAL_FRQ_CMD;
 	cmd.hdr.first_group = 0;
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index ef0e325..9977d5e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -172,22 +172,22 @@ struct iwl_eeprom_enhanced_txpwr {
 #define EEPROM_5000_TX_POWER_VERSION    (4)
 #define EEPROM_5000_EEPROM_VERSION	(0x11A)
 
-/*5000 calibrations */
-#define EEPROM_5000_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
-#define EEPROM_5000_XTAL	((2*0x128) | EEPROM_5000_CALIB_ALL)
-#define EEPROM_5000_TEMPERATURE ((2*0x12A) | EEPROM_5000_CALIB_ALL)
-
-/* 5000 links */
-#define EEPROM_5000_LINK_HOST             (2*0x64)
-#define EEPROM_5000_LINK_GENERAL          (2*0x65)
-#define EEPROM_5000_LINK_REGULATORY       (2*0x66)
-#define EEPROM_5000_LINK_CALIBRATION      (2*0x67)
-#define EEPROM_5000_LINK_PROCESS_ADJST    (2*0x68)
-#define EEPROM_5000_LINK_OTHERS           (2*0x69)
-
-/* 5000 regulatory - indirect access */
-#define EEPROM_5000_REG_SKU_ID ((0x02)\
-		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 4  bytes */
+/* 5000 and up calibration */
+#define EEPROM_CALIB_ALL	(INDIRECT_ADDRESS | INDIRECT_CALIBRATION)
+#define EEPROM_XTAL		((2*0x128) | EEPROM_CALIB_ALL)
+
+/* 5000 temperature */
+#define EEPROM_5000_TEMPERATURE ((2*0x12A) | EEPROM_CALIB_ALL)
+
+/* agn links */
+#define EEPROM_LINK_HOST             (2*0x64)
+#define EEPROM_LINK_GENERAL          (2*0x65)
+#define EEPROM_LINK_REGULATORY       (2*0x66)
+#define EEPROM_LINK_CALIBRATION      (2*0x67)
+#define EEPROM_LINK_PROCESS_ADJST    (2*0x68)
+#define EEPROM_LINK_OTHERS           (2*0x69)
+
+/* agn regulatory - indirect access */
 #define EEPROM_REG_BAND_1_CHANNELS       ((0x08)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 28 bytes */
 #define EEPROM_REG_BAND_2_CHANNELS       ((0x26)\
-- 
1.6.3.3

