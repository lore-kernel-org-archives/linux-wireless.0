Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:45596 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751832AbYCNRsk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Mar 2008 13:48:40 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Reinette Chatre <reinette.chatre@intel.com>,
	Michael Buesch <mb@bu3sch.de>,
	Assaf Krauss <assaf.krauss@intel.com>
Subject: [PATCH 1/5] iwlwifi: remove macros containing offsets from eeprom struct
Date: Fri, 14 Mar 2008 10:38:45 -0700
Message-Id: <1205516329-22172-2-git-send-email-reinette.chatre@intel.com> (sfid-20080314_174956_516774_A02EF0D4)
In-Reply-To: <1205516329-22172-1-git-send-email-reinette.chatre@intel.com>
References: <1205516329-22172-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A user needing to access these fields can use offsetof() for
access. The comments still contain the offset to assist with
debugging.

Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
CC: Michael Buesch <mb@bu3sch.de>
Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |   32 ----------------------------
 drivers/net/wireless/iwlwifi/iwl-eeprom.h  |   32 ----------------------------
 2 files changed, 0 insertions(+), 64 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 1ca6fa4..368da98 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -198,43 +198,27 @@ struct iwl3945_eeprom_temperature_corr {
  */
 struct iwl3945_eeprom {
 	u8 reserved0[16];
-#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
 	u16 device_id;	/* abs.ofs: 16 */
 	u8 reserved1[2];
-#define EEPROM_PMC                          (2*0x0A)	/* 2 bytes */
 	u16 pmc;		/* abs.ofs: 20 */
 	u8 reserved2[20];
-#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
 	u8 mac_address[6];	/* abs.ofs: 42 */
 	u8 reserved3[58];
-#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
 	u16 board_revision;	/* abs.ofs: 106 */
 	u8 reserved4[11];
-#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
 	u8 board_pba_number[9];	/* abs.ofs: 119 */
 	u8 reserved5[8];
-#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
 	u16 version;		/* abs.ofs: 136 */
-#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
 	u8 sku_cap;		/* abs.ofs: 138 */
-#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
 	u8 leds_mode;		/* abs.ofs: 139 */
-#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
 	u16 oem_mode;
-#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
 	u16 wowlan_mode;	/* abs.ofs: 142 */
-#define EEPROM_LEDS_TIME_INTERVAL           (2*0x48)	/* 2  bytes */
 	u16 leds_time_interval;	/* abs.ofs: 144 */
-#define EEPROM_LEDS_OFF_TIME                (2*0x49)	/* 1  bytes */
 	u8 leds_off_time;	/* abs.ofs: 146 */
-#define EEPROM_LEDS_ON_TIME                 (2*0x49+1)	/* 1  bytes */
 	u8 leds_on_time;	/* abs.ofs: 147 */
-#define EEPROM_ALMGOR_M_VERSION             (2*0x4A)	/* 1  bytes */
 	u8 almgor_m_version;	/* abs.ofs: 148 */
-#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
 	u8 antenna_switch_type;	/* abs.ofs: 149 */
 	u8 reserved6[42];
-#define EEPROM_REGULATORY_SKU_ID            (2*0x60)	/* 4  bytes */
 	u8 sku_id[4];		/* abs.ofs: 192 */
 
 /*
@@ -249,9 +233,7 @@ struct iwl3945_eeprom {
  *
  * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  */
-#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
 	u16 band_1_count;	/* abs.ofs: 196 */
-#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
 	struct iwl3945_eeprom_channel band_1_channels[14];  /* abs.ofs: 196 */
 
 /*
@@ -259,36 +241,28 @@ struct iwl3945_eeprom {
  * 5.0 GHz channels 7, 8, 11, 12, 16
  * (4915-5080MHz) (none of these is ever supported)
  */
-#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
 	u16 band_2_count;	/* abs.ofs: 226 */
-#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
 	struct iwl3945_eeprom_channel band_2_channels[13];  /* abs.ofs: 228 */
 
 /*
  * 5.2 GHz channels 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
  * (5170-5320MHz)
  */
-#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
 	u16 band_3_count;	/* abs.ofs: 254 */
-#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
 	struct iwl3945_eeprom_channel band_3_channels[12];  /* abs.ofs: 256 */
 
 /*
  * 5.5 GHz channels 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
  * (5500-5700MHz)
  */
-#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
 	u16 band_4_count;	/* abs.ofs: 280 */
-#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
 	struct iwl3945_eeprom_channel band_4_channels[11];  /* abs.ofs: 282 */
 
 /*
  * 5.7 GHz channels 145, 149, 153, 157, 161, 165
  * (5725-5825MHz)
  */
-#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
 	u16 band_5_count;	/* abs.ofs: 304 */
-#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
 	struct iwl3945_eeprom_channel band_5_channels[6];  /* abs.ofs: 306 */
 
 	u8 reserved9[194];
@@ -296,15 +270,9 @@ struct iwl3945_eeprom {
 /*
  * 3945 Txpower calibration data.
  */
-#define EEPROM_TXPOWER_CALIB_GROUP0 0x200
-#define EEPROM_TXPOWER_CALIB_GROUP1 0x240
-#define EEPROM_TXPOWER_CALIB_GROUP2 0x280
-#define EEPROM_TXPOWER_CALIB_GROUP3 0x2c0
-#define EEPROM_TXPOWER_CALIB_GROUP4 0x300
 #define IWL_NUM_TX_CALIB_GROUPS 5
 	struct iwl3945_eeprom_txpower_group groups[IWL_NUM_TX_CALIB_GROUPS];
 /* abs.ofs: 512 */
-#define EEPROM_CALIB_TEMPERATURE_CORRECT 0x340
 	struct iwl3945_eeprom_temperature_corr corrections;  /* abs.ofs: 832 */
 	u8 reserved16[172];	/* fill out to full 1024 byte block */
 } __attribute__ ((packed));
diff --git a/drivers/net/wireless/iwlwifi/iwl-eeprom.h b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
index ad486fe..404c700 100644
--- a/drivers/net/wireless/iwlwifi/iwl-eeprom.h
+++ b/drivers/net/wireless/iwlwifi/iwl-eeprom.h
@@ -228,49 +228,31 @@ struct iwl4965_eeprom_calib_info {
  */
 struct iwl4965_eeprom {
 	u8 reserved0[16];
-#define EEPROM_DEVICE_ID                    (2*0x08)	/* 2 bytes */
 	u16 device_id;		/* abs.ofs: 16 */
 	u8 reserved1[2];
-#define EEPROM_PMC                          (2*0x0A)	/* 2 bytes */
 	u16 pmc;		/* abs.ofs: 20 */
 	u8 reserved2[20];
-#define EEPROM_MAC_ADDRESS                  (2*0x15)	/* 6  bytes */
 	u8 mac_address[6];	/* abs.ofs: 42 */
 	u8 reserved3[58];
-#define EEPROM_BOARD_REVISION               (2*0x35)	/* 2  bytes */
 	u16 board_revision;	/* abs.ofs: 106 */
 	u8 reserved4[11];
-#define EEPROM_BOARD_PBA_NUMBER             (2*0x3B+1)	/* 9  bytes */
 	u8 board_pba_number[9];	/* abs.ofs: 119 */
 	u8 reserved5[8];
-#define EEPROM_VERSION                      (2*0x44)	/* 2  bytes */
 	u16 version;		/* abs.ofs: 136 */
-#define EEPROM_SKU_CAP                      (2*0x45)	/* 1  bytes */
 	u8 sku_cap;		/* abs.ofs: 138 */
-#define EEPROM_LEDS_MODE                    (2*0x45+1)	/* 1  bytes */
 	u8 leds_mode;		/* abs.ofs: 139 */
-#define EEPROM_OEM_MODE                     (2*0x46)	/* 2  bytes */
 	u16 oem_mode;
-#define EEPROM_WOWLAN_MODE                  (2*0x47)	/* 2  bytes */
 	u16 wowlan_mode;	/* abs.ofs: 142 */
-#define EEPROM_LEDS_TIME_INTERVAL           (2*0x48)	/* 2  bytes */
 	u16 leds_time_interval;	/* abs.ofs: 144 */
-#define EEPROM_LEDS_OFF_TIME                (2*0x49)	/* 1  bytes */
 	u8 leds_off_time;	/* abs.ofs: 146 */
-#define EEPROM_LEDS_ON_TIME                 (2*0x49+1)	/* 1  bytes */
 	u8 leds_on_time;	/* abs.ofs: 147 */
-#define EEPROM_ALMGOR_M_VERSION             (2*0x4A)	/* 1  bytes */
 	u8 almgor_m_version;	/* abs.ofs: 148 */
-#define EEPROM_ANTENNA_SWITCH_TYPE          (2*0x4A+1)	/* 1  bytes */
 	u8 antenna_switch_type;	/* abs.ofs: 149 */
 	u8 reserved6[8];
-#define EEPROM_4965_BOARD_REVISION          (2*0x4F)	/* 2 bytes */
 	u16 board_revision_4965;	/* abs.ofs: 158 */
 	u8 reserved7[13];
-#define EEPROM_4965_BOARD_PBA               (2*0x56+1)	/* 9 bytes */
 	u8 board_pba_number_4965[9];	/* abs.ofs: 173 */
 	u8 reserved8[10];
-#define EEPROM_REGULATORY_SKU_ID            (2*0x60)	/* 4  bytes */
 	u8 sku_id[4];		/* abs.ofs: 192 */
 
 /*
@@ -285,9 +267,7 @@ struct iwl4965_eeprom {
  *
  * 2.4 GHz channels 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14
  */
-#define EEPROM_REGULATORY_BAND_1            (2*0x62)	/* 2  bytes */
 	u16 band_1_count;	/* abs.ofs: 196 */
-#define EEPROM_REGULATORY_BAND_1_CHANNELS   (2*0x63)	/* 28 bytes */
 	struct iwl4965_eeprom_channel band_1_channels[14]; /* abs.ofs: 196 */
 
 /*
@@ -295,36 +275,28 @@ struct iwl4965_eeprom {
  * 5.0 GHz channels 7, 8, 11, 12, 16
  * (4915-5080MHz) (none of these is ever supported)
  */
-#define EEPROM_REGULATORY_BAND_2            (2*0x71)	/* 2  bytes */
 	u16 band_2_count;	/* abs.ofs: 226 */
-#define EEPROM_REGULATORY_BAND_2_CHANNELS   (2*0x72)	/* 26 bytes */
 	struct iwl4965_eeprom_channel band_2_channels[13]; /* abs.ofs: 228 */
 
 /*
  * 5.2 GHz channels 34, 36, 38, 40, 42, 44, 46, 48, 52, 56, 60, 64
  * (5170-5320MHz)
  */
-#define EEPROM_REGULATORY_BAND_3            (2*0x7F)	/* 2  bytes */
 	u16 band_3_count;	/* abs.ofs: 254 */
-#define EEPROM_REGULATORY_BAND_3_CHANNELS   (2*0x80)	/* 24 bytes */
 	struct iwl4965_eeprom_channel band_3_channels[12]; /* abs.ofs: 256 */
 
 /*
  * 5.5 GHz channels 100, 104, 108, 112, 116, 120, 124, 128, 132, 136, 140
  * (5500-5700MHz)
  */
-#define EEPROM_REGULATORY_BAND_4            (2*0x8C)	/* 2  bytes */
 	u16 band_4_count;	/* abs.ofs: 280 */
-#define EEPROM_REGULATORY_BAND_4_CHANNELS   (2*0x8D)	/* 22 bytes */
 	struct iwl4965_eeprom_channel band_4_channels[11]; /* abs.ofs: 282 */
 
 /*
  * 5.7 GHz channels 145, 149, 153, 157, 161, 165
  * (5725-5825MHz)
  */
-#define EEPROM_REGULATORY_BAND_5            (2*0x98)	/* 2  bytes */
 	u16 band_5_count;	/* abs.ofs: 304 */
-#define EEPROM_REGULATORY_BAND_5_CHANNELS   (2*0x99)	/* 12 bytes */
 	struct iwl4965_eeprom_channel band_5_channels[6]; /* abs.ofs: 306 */
 
 	u8 reserved10[2];
@@ -345,7 +317,6 @@ struct iwl4965_eeprom {
  *
  * NOTE:  4965 does not support FAT channels on 2.4 GHz.
  */
-#define EEPROM_REGULATORY_BAND_24_FAT_CHANNELS (2*0xA0)	/* 14 bytes */
 	struct iwl4965_eeprom_channel band_24_channels[7]; /* abs.ofs: 320 */
 	u8 reserved11[2];
 
@@ -353,7 +324,6 @@ struct iwl4965_eeprom {
  * 5.2 GHz FAT channels 36 (40), 44 (48), 52 (56), 60 (64),
  * 100 (104), 108 (112), 116 (120), 124 (128), 132 (136), 149 (153), 157 (161)
  */
-#define EEPROM_REGULATORY_BAND_52_FAT_CHANNELS (2*0xA8)	/* 22 bytes */
 	struct iwl4965_eeprom_channel band_52_channels[11]; /* abs.ofs: 336 */
 	u8 reserved12[6];
 
@@ -362,7 +332,6 @@ struct iwl4965_eeprom {
  * Driver does not work with txpower calibration version < 5.
  * This value is simply a 16-bit number, no major/minor versions here.
  */
-#define EEPROM_CALIB_VERSION_OFFSET            (2*0xB6)	/* 2 bytes */
 	u16 calib_version;	/* abs.ofs: 364 */
 	u8 reserved13[2];
 	u8 reserved14[96];	/* abs.ofs: 368 */
@@ -370,7 +339,6 @@ struct iwl4965_eeprom {
 /*
  * 4965 Txpower calibration data.
  */
-#define EEPROM_IWL_CALIB_TXPOWER_OFFSET        (2*0xE8)	/* 48  bytes */
 	struct iwl4965_eeprom_calib_info calib_info;	/* abs.ofs: 464 */
 
 	u8 reserved16[140];	/* fill out to full 1024 byte block */
-- 
1.5.3.4

