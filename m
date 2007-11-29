Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:4135 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755198AbXK2DKg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2007 22:10:36 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Ben Cahill <ben.m.cahill@intel.com>, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 06/36] iwl-4965-hw.h: clean up unused eeprom structures and definitions
Date: Thu, 29 Nov 2007 11:09:46 +0800
Message-Id: <1196305816-23023-7-git-send-email-yi.zhu@intel.com> (sfid-20071129_033532_933810_00ABFB22)
In-Reply-To: <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
References: <1196305816-23023-1-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-2-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-3-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-4-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-5-git-send-email-yi.zhu@intel.com>
 <1196305816-23023-6-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

Clean up unused eeprom structures and definitions in iwl-4965-hw.h.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965-hw.h |   58 +---------------------------
 1 files changed, 1 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
index 1c44459..e106ec1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-4965-hw.h
@@ -169,57 +169,6 @@ struct iwl4965_eeprom_channel {
 	s8 max_power_avg;	/* max power (dBm) on this chnl, limit 31 */
 } __attribute__ ((packed));
 
-/*
- * Mapping of a Tx power level, at factory calibration temperature,
- *   to a radio/DSP gain table index.
- * One for each of 5 "sample" power levels in each band.
- * v_det is measured at the factory, using the 3945's built-in power amplifier
- *   (PA) output voltage detector.  This same detector is used during Tx of
- *   long packets in normal operation to provide feedback as to proper output
- *   level.
- * Data copied from EEPROM.
- */
-struct iwl4965_eeprom_txpower_sample {
-	u8 gain_index;		/* index into power (gain) setup table ... */
-	s8 power;		/* ... for this pwr level for this chnl group */
-	u16 v_det;		/* PA output voltage */
-} __attribute__ ((packed));
-
-/*
- * Mappings of Tx power levels -> nominal radio/DSP gain table indexes.
- * One for each channel group (a.k.a. "band") (1 for BG, 4 for A).
- * Tx power setup code interpolates between the 5 "sample" power levels
- *    to determine the nominal setup for a requested power level.
- * Data copied from EEPROM.
- * DO NOT ALTER THIS STRUCTURE!!!
- */
-struct iwl4965_eeprom_txpower_group {
-	struct iwl4965_eeprom_txpower_sample samples[5];	/* 5 power levels */
-	s32 a, b, c, d, e;	/* coefficients for voltage->power
-				 * formula (signed) */
-	s32 Fa, Fb, Fc, Fd, Fe;	/* these modify coeffs based on
-					 * frequency (signed) */
-	s8 saturation_power;	/* highest power possible by h/w in this
-				 * band */
-	u8 group_channel;	/* "representative" channel # in this band */
-	s16 temperature;	/* h/w temperature at factory calib this band
-				 * (signed) */
-} __attribute__ ((packed));
-
-/*
- * Temperature-based Tx-power compensation data, not band-specific.
- * These coefficients are use to modify a/b/c/d/e coeffs based on
- *   difference between current temperature and factory calib temperature.
- * Data copied from EEPROM.
- */
-struct iwl4965_eeprom_temperature_corr {
-	u32 Ta;
-	u32 Tb;
-	u32 Tc;
-	u32 Td;
-	u32 Te;
-} __attribute__ ((packed));
-
 /* 4965 has two radio transmitters (and 3 radio receivers) */
 #define EEPROM_TX_POWER_TX_CHAINS      (2)
 
@@ -230,8 +179,6 @@ struct iwl4965_eeprom_temperature_corr {
  * each of 3 target output levels */
 #define EEPROM_TX_POWER_MEASUREMENTS   (3)
 
-#define EEPROM_TX_POWER_VERSION        (2)
-
 /* 4965 driver does not work with txpower calibration version < 5.
  * Look for this in calib_version member of struct iwl4965_eeprom. */
 #define EEPROM_TX_POWER_VERSION_NEW    (5)
@@ -461,10 +408,7 @@ struct iwl4965_eeprom {
 #define EEPROM_CALIB_VERSION_OFFSET            (2*0xB6)	/* 2 bytes */
 	u16 calib_version;	/* abs.ofs: 364 */
 	u8 reserved13[2];
-
-#define EEPROM_SATURATION_POWER_OFFSET         (2*0xB8)	/* 2 bytes */
-	u16 satruation_power;	/* abs.ofs: 368 */
-	u8 reserved14[94];
+	u8 reserved14[96];	/* abs.ofs: 368 */
 
 /*
  * 4965 Txpower calibration data.
-- 
1.5.3.6
