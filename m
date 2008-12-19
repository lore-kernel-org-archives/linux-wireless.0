Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:54843 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752554AbYLSCpK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 21:45:10 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Samuel Ortiz <sameo@linux.intel.com>,
	Samuel Ortiz <samuel.ortiz@intel.com>,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 10/43] iwl3945: Getting rid of iwl3945_eeprom_channel
Date: Fri, 19 Dec 2008 10:37:10 +0800
Message-Id: <1229654263-21454-11-git-send-email-yi.zhu@intel.com> (sfid-20081219_040900_764442_87360707)
In-Reply-To: <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
References: <1229654263-21454-1-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-2-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-3-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-4-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-5-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-6-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-7-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-8-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-9-git-send-email-yi.zhu@intel.com>
 <1229654263-21454-10-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Samuel Ortiz <sameo@linux.intel.com>

The corresponding iwl structure is identical.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h  |   59 +++-----------------------
 drivers/net/wireless/iwlwifi/iwl-3945.h     |    4 +-
 drivers/net/wireless/iwlwifi/iwl3945-base.c |    4 +-
 3 files changed, 11 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 21719eb..b6145b0 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -69,6 +69,8 @@
 #ifndef __iwl_3945_hw__
 #define __iwl_3945_hw__
 
+#include "iwl-eeprom.h"
+
 /*
  * uCode queue management definitions ...
  * Queue #4 is the command queue for 3945 and 4965.
@@ -85,55 +87,8 @@
 /*
  * EEPROM related constants, enums, and structures.
  */
-
-/*
- * EEPROM access time values:
- *
- * Driver initiates EEPROM read by writing byte address << 1 to CSR_EEPROM_REG,
- *   then clearing (with subsequent read/modify/write) CSR_EEPROM_REG bit
- *   CSR_EEPROM_REG_BIT_CMD (0x2).
- * Driver then polls CSR_EEPROM_REG for CSR_EEPROM_REG_READ_VALID_MSK (0x1).
- * When polling, wait 10 uSec between polling loops, up to a maximum 5000 uSec.
- * Driver reads 16-bit value from bits 31-16 of CSR_EEPROM_REG.
- */
-#define IWL_EEPROM_ACCESS_TIMEOUT	5000 /* uSec */
-
-/*
- * Regulatory channel usage flags in EEPROM struct iwl_eeprom_channel.flags.
- *
- * IBSS and/or AP operation is allowed *only* on those channels with
- * (VALID && IBSS && ACTIVE && !RADAR).  This restriction is in place because
- * RADAR detection is not supported by the 3945 driver, but is a
- * requirement for establishing a new network for legal operation on channels
- * requiring RADAR detection or restricting ACTIVE scanning.
- *
- * NOTE:  "WIDE" flag indicates that 20 MHz channel is supported;
- *        3945 does not support FAT 40 MHz-wide channels.
- *
- * NOTE:  Using a channel inappropriately will result in a uCode error!
- */
-enum {
-	EEPROM_CHANNEL_VALID = (1 << 0),	/* usable for this SKU/geo */
-	EEPROM_CHANNEL_IBSS = (1 << 1),		/* usable as an IBSS channel */
-	/* Bit 2 Reserved */
-	EEPROM_CHANNEL_ACTIVE = (1 << 3),	/* active scanning allowed */
-	EEPROM_CHANNEL_RADAR = (1 << 4),	/* radar detection required */
-	EEPROM_CHANNEL_WIDE = (1 << 5),		/* 20 MHz channel okay */
-	/* Bit 6 Reserved (was Narrow Channel) */
-	EEPROM_CHANNEL_DFS = (1 << 7),	/* dynamic freq selection candidate */
-};
-
-/* SKU Capabilities */
-#define EEPROM_SKU_CAP_SW_RF_KILL_ENABLE                (1 << 0)
-#define EEPROM_SKU_CAP_HW_RF_KILL_ENABLE                (1 << 1)
 #define EEPROM_SKU_CAP_OP_MODE_MRC                      (1 << 7)
 
-/* *regulatory* channel data from eeprom, one for each channel */
-struct iwl3945_eeprom_channel {
-	u8 flags;		/* flags copied from EEPROM */
-	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
-} __attribute__ ((packed));
-
 /*
  * Mapping of a Tx power level, at factory calibration temperature,
  *   to a radio/DSP gain table index.
@@ -227,7 +182,7 @@ struct iwl3945_eeprom {
  * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  */
 	u16 band_1_count;	/* abs.ofs: 196 */
-	struct iwl3945_eeprom_channel band_1_channels[14];  /* abs.ofs: 196 */
+	struct iwl_eeprom_channel band_1_channels[14];  /* abs.ofs: 196 */
 
 /*
  * 4.9 GHz channels 183, 184, 185, 187, 188, 189, 192, 196,
@@ -235,28 +190,28 @@ struct iwl3945_eeprom {
  * (4915-5080MHz) (none of these is ever supported)
  */
 	u16 band_2_count;	/* abs.ofs: 226 */
-	struct iwl3945_eeprom_channel band_2_channels[13];  /* abs.ofs: 228 */
+	struct iwl_eeprom_channel band_2_channels[13];  /* abs.ofs: 228 */
 
 /*
  * 5.2 GHz channels 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
  * (5170-5320MHz)
  */
 	u16 band_3_count;	/* abs.ofs: 254 */
-	struct iwl3945_eeprom_channel band_3_channels[12];  /* abs.ofs: 256 */
+	struct iwl_eeprom_channel band_3_channels[12];  /* abs.ofs: 256 */
 
 /*
  * 5.5 GHz channels 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
  * (5500-5700MHz)
  */
 	u16 band_4_count;	/* abs.ofs: 280 */
-	struct iwl3945_eeprom_channel band_4_channels[11];  /* abs.ofs: 282 */
+	struct iwl_eeprom_channel band_4_channels[11];  /* abs.ofs: 282 */
 
 /*
  * 5.7 GHz channels 145, 149, 153, 157, 161, 165
  * (5725-5825MHz)
  */
 	u16 band_5_count;	/* abs.ofs: 304 */
-	struct iwl3945_eeprom_channel band_5_channels[6];  /* abs.ofs: 306 */
+	struct iwl_eeprom_channel band_5_channels[6];  /* abs.ofs: 306 */
 
 	u8 reserved9[194];
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.h b/drivers/net/wireless/iwlwifi/iwl-3945.h
index 7e9ba54..3295244 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.h
@@ -203,8 +203,8 @@ struct iwl3945_scan_power_info {
 struct iwl3945_channel_info {
 	struct iwl3945_channel_tgd_info tgd;
 	struct iwl3945_channel_tgh_info tgh;
-	struct iwl3945_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct iwl3945_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
+	struct iwl_eeprom_channel eeprom;	/* EEPROM regulatory limit */
+	struct iwl_eeprom_channel fat_eeprom;	/* EEPROM regulatory limit for
 						 * FAT channel */
 
 	u8 channel;	  /* channel number */
diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
index 142d89d..49ac18f 100644
--- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
+++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
@@ -4493,7 +4493,7 @@ static const u8 iwl3945_eeprom_band_5[] = {	/* 5725-5825MHz */
 
 static void iwl3945_init_band_reference(const struct iwl3945_priv *priv, int band,
 				    int *eeprom_ch_count,
-				    const struct iwl3945_eeprom_channel
+				    const struct iwl_eeprom_channel
 				    **eeprom_ch_info,
 				    const u8 **eeprom_ch_index)
 {
@@ -4568,7 +4568,7 @@ static int iwl3945_init_channel_map(struct iwl3945_priv *priv)
 {
 	int eeprom_ch_count = 0;
 	const u8 *eeprom_ch_index = NULL;
-	const struct iwl3945_eeprom_channel *eeprom_ch_info = NULL;
+	const struct iwl_eeprom_channel *eeprom_ch_info = NULL;
 	int band, ch;
 	struct iwl3945_channel_info *ch_info;
 
-- 
1.5.3.6

