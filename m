Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:26672 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758177AbZJBUtu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Oct 2009 16:49:50 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 02/13] iwlwifi: fix EEPROM enhance tx power offset
Date: Fri,  2 Oct 2009 13:43:56 -0700
Message-Id: <1254516247-4085-3-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
References: <1254516247-4085-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Set the correct EEPROM offset for enhance tx power for 6000 series

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-eeprom.h |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index 75fe022..3bcd600 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -220,35 +220,35 @@ struct iwl_eeprom_enhanced_txpwr {
  * Section 10: 2.4 GHz 40MHz channels: 132, 44 (_above_)
  */
 /* 2.4 GHz band: CCK */
-#define EEPROM_LB_CCK_20_COMMON       ((0xAA)\
+#define EEPROM_LB_CCK_20_COMMON       ((0xA8)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 8 bytes */
 /* 2.4 GHz band: 20MHz-Legacy, 20MHz-HT, 40MHz-HT */
-#define EEPROM_LB_OFDM_COMMON       ((0xB2)\
+#define EEPROM_LB_OFDM_COMMON       ((0xB0)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
 /* 5.2 GHz band: 20MHz-Legacy, 20MHz-HT, 40MHz-HT */
-#define EEPROM_HB_OFDM_COMMON       ((0xCA)\
+#define EEPROM_HB_OFDM_COMMON       ((0xC8)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
 /* 2.4GHz band channels:
  *	1Legacy, 1HT, 2Legacy, 2HT, 10Legacy, 10HT, 11Legacy, 11HT */
-#define EEPROM_LB_OFDM_20_BAND       ((0xE2)\
+#define EEPROM_LB_OFDM_20_BAND       ((0xE0)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 64 bytes */
 /* 2.4 GHz band HT40 channels: (1,+1) (2,+1) (6,+1) (7,+1) (9,+1) */
-#define EEPROM_LB_OFDM_HT40_BAND       ((0x122)\
+#define EEPROM_LB_OFDM_HT40_BAND       ((0x120)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 40 bytes */
 /* 5.2GHz band channels: 36Legacy, 36HT, 64Legacy, 64HT, 100Legacy, 100HT */
-#define EEPROM_HB_OFDM_20_BAND       ((0x14A)\
+#define EEPROM_HB_OFDM_20_BAND       ((0x148)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 48 bytes */
 /* 5.2 GHz band HT40 channels: (36,+1) (60,+1) (100,+1) */
-#define EEPROM_HB_OFDM_HT40_BAND       ((0x17A)\
+#define EEPROM_HB_OFDM_HT40_BAND       ((0x178)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 24 bytes */
 /* 2.4 GHz band, channnel 13: Legacy, HT */
-#define EEPROM_LB_OFDM_20_CHANNEL_13       ((0x192)\
+#define EEPROM_LB_OFDM_20_CHANNEL_13       ((0x190)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
 /* 5.2 GHz band, channnel 140: Legacy, HT */
-#define EEPROM_HB_OFDM_20_CHANNEL_140       ((0x1A2)\
+#define EEPROM_HB_OFDM_20_CHANNEL_140       ((0x1A0)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
 /* 5.2 GHz band, HT40 channnels (132,+1) (44,+1) */
-#define EEPROM_HB_OFDM_HT40_BAND_1       ((0x1B2)\
+#define EEPROM_HB_OFDM_HT40_BAND_1       ((0x1B0)\
 		| INDIRECT_ADDRESS | INDIRECT_REGULATORY)   /* 16 bytes */
 
 
-- 
1.5.6.3

