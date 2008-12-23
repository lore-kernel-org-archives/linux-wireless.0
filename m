Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:22695 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358AbYLWX7m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2008 18:59:42 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2008 15:59:42 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v3 16/16] ath9k: fix sparse warnings
Date: Tue, 23 Dec 2008 15:58:51 -0800
Message-ID: <1230076731-22946-17-git-send-email-lrodriguez@atheros.com> (sfid-20081224_010847_060532_A37867F6)
In-Reply-To: <1230076731-22946-16-git-send-email-lrodriguez@atheros.com>
References: <1230076731-22946-1-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-2-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-3-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-4-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-5-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-6-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-7-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-8-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-9-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-10-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-11-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-12-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-13-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-14-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-15-git-send-email-lrodriguez@atheros.com>
 <1230076731-22946-16-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix sparse warnings:

drivers/net/wireless/ath9k/hw.c:1850:17: warning: symbol 'tmp' shadows an earlier one
drivers/net/wireless/ath9k/hw.c:1713:6: originally declared here
drivers/net/wireless/ath9k/hw.c:2051:17: warning: symbol 'tmp' shadows an earlier one
drivers/net/wireless/ath9k/hw.c:1961:6: originally declared here

drivers/net/wireless/ath9k/eeprom.c:195:6: warning: symbol 'ath9k_fill_eeprom' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:463:5: warning: symbol 'ath9k_check_eeprom' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:1219:6: warning: symbol 'ath9k_hw_set_def_power_per_rate_table' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:1510:6: warning: symbol 'ath9k_hw_set_4k_power_per_rate_table' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2007:5: warning: symbol 'ath9k_set_txpower' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2106:6: warning: symbol 'ath9k_set_addac' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2543:6: warning: symbol 'ath9k_eeprom_set_board_values' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2606:5: warning: symbol 'ath9k_get_eeprom_antenna_cfg' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2622:4: warning: symbol 'ath9k_hw_get_4k_num_ant_config' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2628:4: warning: symbol 'ath9k_hw_get_def_num_ant_config' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2647:4: warning: symbol 'ath9k_get_num_ant_config' was not declared. Should it be static?
drivers/net/wireless/ath9k/eeprom.c:2790:5: warning: symbol 'ath9k_get_eeprom' was not declared. Should it be static?

drivers/net/wireless/ath9k/calib.c:962:30: warning: symbol 'iq_cal_multi_sample' was not declared. Should it be static?
drivers/net/wireless/ath9k/calib.c:969:30: warning: symbol 'iq_cal_single_sample' was not declared. Should it be static?
drivers/net/wireless/ath9k/calib.c:976:30: warning: symbol 'adc_gain_cal_multi_sample' was not declared. Should it be static?
drivers/net/wireless/ath9k/calib.c:983:30: warning: symbol 'adc_gain_cal_single_sample' was not declared. Should it be static?
drivers/net/wireless/ath9k/calib.c:990:30: warning: symbol 'adc_dc_cal_multi_sample' was not declared. Should it be static?
drivers/net/wireless/ath9k/calib.c:997:30: warning: symbol 'adc_dc_cal_single_sample' was not declared. Should it be static?
drivers/net/wireless/ath9k/calib.c:1004:30: warning: symbol 'adc_init_dc_cal' was not declared. Should it be static?

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/eeprom.c |   30 ++++++++++++++++--------------
 drivers/net/wireless/ath9k/hw.c     |   16 ++++------------
 drivers/net/wireless/ath9k/hw.h     |    8 ++++++++
 3 files changed, 28 insertions(+), 26 deletions(-)

diff --git a/drivers/net/wireless/ath9k/eeprom.c b/drivers/net/wireless/ath9k/eeprom.c
index 14f8d40..ccf57c3 100644
--- a/drivers/net/wireless/ath9k/eeprom.c
+++ b/drivers/net/wireless/ath9k/eeprom.c
@@ -192,7 +192,7 @@ static bool ath9k_hw_fill_def_eeprom(struct ath_hal *ah)
 #undef SIZE_EEPROM_DEF
 }
 
-bool (*ath9k_fill_eeprom[]) (struct ath_hal *) = {
+static bool (*ath9k_fill_eeprom[]) (struct ath_hal *) = {
 	ath9k_hw_fill_def_eeprom,
 	ath9k_hw_fill_4k_eeprom
 };
@@ -460,7 +460,7 @@ static int ath9k_hw_check_4k_eeprom(struct ath_hal *ah)
 #undef EEPROM_4K_SIZE
 }
 
-int (*ath9k_check_eeprom[]) (struct ath_hal *) = {
+static int (*ath9k_check_eeprom[]) (struct ath_hal *) = {
 	ath9k_hw_check_def_eeprom,
 	ath9k_hw_check_4k_eeprom
 };
@@ -1216,7 +1216,7 @@ static bool ath9k_hw_set_4k_power_cal_table(struct ath_hal *ah,
 	return true;
 }
 
-bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
+static bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 				       struct ath9k_channel *chan,
 				       int16_t *ratesArray,
 				       u16 cfgCtl,
@@ -1507,7 +1507,7 @@ bool ath9k_hw_set_def_power_per_rate_table(struct ath_hal *ah,
 	return true;
 }
 
-bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
+static bool ath9k_hw_set_4k_power_per_rate_table(struct ath_hal *ah,
 				       struct ath9k_channel *chan,
 				       int16_t *ratesArray,
 				       u16 cfgCtl,
@@ -2004,7 +2004,7 @@ static int ath9k_hw_4k_set_txpower(struct ath_hal *ah,
 	return 0;
 }
 
-int (*ath9k_set_txpower[]) (struct ath_hal *,
+static int (*ath9k_set_txpower[]) (struct ath_hal *,
 			    struct ath9k_channel *,
 			    u16, u8, u8, u8) = {
 	ath9k_hw_def_set_txpower,
@@ -2103,7 +2103,7 @@ static void ath9k_hw_set_4k_addac(struct ath_hal *ah,
 	}
 }
 
-void (*ath9k_set_addac[]) (struct ath_hal *, struct ath9k_channel *) = {
+static void (*ath9k_set_addac[]) (struct ath_hal *, struct ath9k_channel *) = {
 	ath9k_hw_set_def_addac,
 	ath9k_hw_set_4k_addac
 };
@@ -2540,7 +2540,7 @@ static bool ath9k_hw_eeprom_set_4k_board_values(struct ath_hal *ah,
 	return true;
 }
 
-bool (*ath9k_eeprom_set_board_values[])(struct ath_hal *,
+static bool (*ath9k_eeprom_set_board_values[])(struct ath_hal *,
 					struct ath9k_channel *) = {
 	ath9k_hw_eeprom_set_def_board_values,
 	ath9k_hw_eeprom_set_4k_board_values
@@ -2603,7 +2603,8 @@ static int ath9k_hw_get_4k_eeprom_antenna_cfg(struct ath_hal *ah,
 	return -EINVAL;
 }
 
-int (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hal *, struct ath9k_channel *,
+static int (*ath9k_get_eeprom_antenna_cfg[])(struct ath_hal *,
+				      struct ath9k_channel *,
 				      u8, u16 *) = {
 	ath9k_hw_get_def_eeprom_antenna_cfg,
 	ath9k_hw_get_4k_eeprom_antenna_cfg
@@ -2619,13 +2620,13 @@ int ath9k_hw_get_eeprom_antenna_cfg(struct ath_hal *ah,
 							     index, config);
 }
 
-u8 ath9k_hw_get_4k_num_ant_config(struct ath_hal *ah,
+static u8 ath9k_hw_get_4k_num_ant_config(struct ath_hal *ah,
 			       enum ieee80211_band freq_band)
 {
 	return 1;
 }
 
-u8 ath9k_hw_get_def_num_ant_config(struct ath_hal *ah,
+static u8 ath9k_hw_get_def_num_ant_config(struct ath_hal *ah,
 			       enum ieee80211_band freq_band)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
@@ -2644,9 +2645,10 @@ u8 ath9k_hw_get_def_num_ant_config(struct ath_hal *ah,
 	return num_ant_config;
 }
 
-u8 (*ath9k_get_num_ant_config[])(struct ath_hal *, enum ieee80211_band) = {
-	ath9k_hw_get_def_num_ant_config,
-	ath9k_hw_get_4k_num_ant_config
+static u8 (*ath9k_get_num_ant_config[])(struct ath_hal *,
+	enum ieee80211_band) = {
+	  ath9k_hw_get_def_num_ant_config,
+	  ath9k_hw_get_4k_num_ant_config
 };
 
 u8 ath9k_hw_get_num_ant_config(struct ath_hal *ah,
@@ -2787,7 +2789,7 @@ static u32 ath9k_hw_get_eeprom_def(struct ath_hal *ah,
 	}
 }
 
-u32 (*ath9k_get_eeprom[])(struct ath_hal *, enum eeprom_param) = {
+static u32 (*ath9k_get_eeprom[])(struct ath_hal *, enum eeprom_param) = {
 	ath9k_hw_get_eeprom_def,
 	ath9k_hw_get_eeprom_4k
 };
diff --git a/drivers/net/wireless/ath9k/hw.c b/drivers/net/wireless/ath9k/hw.c
index a6b0301..ff133c4 100644
--- a/drivers/net/wireless/ath9k/hw.c
+++ b/drivers/net/wireless/ath9k/hw.c
@@ -27,14 +27,6 @@
 #define ATH9K_CLOCK_RATE_5GHZ_OFDM	40
 #define ATH9K_CLOCK_RATE_2GHZ_OFDM	44
 
-extern struct hal_percal_data iq_cal_multi_sample;
-extern struct hal_percal_data iq_cal_single_sample;
-extern struct hal_percal_data adc_gain_cal_multi_sample;
-extern struct hal_percal_data adc_gain_cal_single_sample;
-extern struct hal_percal_data adc_dc_cal_multi_sample;
-extern struct hal_percal_data adc_dc_cal_single_sample;
-extern struct hal_percal_data adc_init_dc_cal;
-
 static bool ath9k_hw_set_reset_reg(struct ath_hal *ah, u32 type);
 static void ath9k_hw_set_regs(struct ath_hal *ah, struct ath9k_channel *chan,
 			      enum ath9k_ht_macmode macmode);
@@ -1887,9 +1879,9 @@ static void ath9k_hw_9280_spur_mitigate(struct ath_hal *ah, struct ath9k_channel
 		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
 
 			/* workaround for gcc bug #37014 */
-			volatile int tmp = abs(cur_vit_mask - bin);
+			volatile int tmp_v = abs(cur_vit_mask - bin);
 
-			if (tmp < 75)
+			if (tmp_v < 75)
 				mask_amt = 1;
 			else
 				mask_amt = 0;
@@ -2088,9 +2080,9 @@ static void ath9k_hw_spur_mitigate(struct ath_hal *ah, struct ath9k_channel *cha
 		if ((cur_vit_mask > lower) && (cur_vit_mask < upper)) {
 
 			/* workaround for gcc bug #37014 */
-			volatile int tmp = abs(cur_vit_mask - bin);
+			volatile int tmp_v = abs(cur_vit_mask - bin);
 
-			if (tmp < 75)
+			if (tmp_v < 75)
 				mask_amt = 1;
 			else
 				mask_amt = 0;
diff --git a/drivers/net/wireless/ath9k/hw.h b/drivers/net/wireless/ath9k/hw.h
index 91d8f59..3ae3b88 100644
--- a/drivers/net/wireless/ath9k/hw.h
+++ b/drivers/net/wireless/ath9k/hw.h
@@ -20,6 +20,14 @@
 #include <linux/if_ether.h>
 #include <linux/delay.h>
 
+extern const struct hal_percal_data iq_cal_multi_sample;
+extern const struct hal_percal_data iq_cal_single_sample;
+extern const struct hal_percal_data adc_gain_cal_multi_sample;
+extern const struct hal_percal_data adc_gain_cal_single_sample;
+extern const struct hal_percal_data adc_dc_cal_multi_sample;
+extern const struct hal_percal_data adc_dc_cal_single_sample;
+extern const struct hal_percal_data adc_init_dc_cal;
+
 struct ar5416_desc {
 	u32 ds_link;
 	u32 ds_data;
-- 
1.6.1.rc3.51.g5832d

