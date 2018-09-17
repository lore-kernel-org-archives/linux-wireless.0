Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr1-f65.google.com ([209.85.221.65]:34389 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728065AbeIQWBN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Sep 2018 18:01:13 -0400
Received: by mail-wr1-f65.google.com with SMTP id g33-v6so18022977wrd.1
        for <linux-wireless@vger.kernel.org>; Mon, 17 Sep 2018 09:33:04 -0700 (PDT)
Received: from localhost.localdomain ([31.147.208.18])
        by smtp.googlemail.com with ESMTPSA id c3-v6sm17807307wrm.56.2018.09.17.09.33.01
        for <linux-wireless@vger.kernel.org>
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 17 Sep 2018 09:33:02 -0700 (PDT)
From: =?UTF-8?q?Tomislav=20Po=C5=BEega?= <pozega.tomislav@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] rt2x00: set registers based on current band
Date: Mon, 17 Sep 2018 18:32:51 +0200
Message-Id: <1537201975-3032-1-git-send-email-pozega.tomislav@gmail.com> (sfid-20180917_183317_652831_48F92ACC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use curr_band instead of rf->channel among various subroutines -
mostly for 2.4GHz band but in some circumstances for 5GHz band too.

Signed-off-by: Tomislav Požega <pozega.tomislav@gmail.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |  130 +++++++++++++-----------
 1 files changed, 72 insertions(+), 58 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a567bc2..33968ab 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -2033,7 +2033,7 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	u16 eeprom;
 	short lna_gain;
 
-	if (libconf->rf.channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		eeprom = rt2800_eeprom_read(rt2x00dev, EEPROM_LNA);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_LNA_BG);
 	} else if (libconf->rf.channel <= 64) {
@@ -2122,7 +2122,7 @@ static void rt2800_config_channel_rf2xxx(struct rt2x00_dev *rt2x00dev,
 	} else if (rt2x00dev->default_ant.rx_chain_num == 2)
 		rt2x00_set_field32(&rf->rf2, RF2_ANTENNA_RX2, 1);
 
-	if (rf->channel > 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		/*
 		 * When TX power is below 0, we should increase it by 7 to
 		 * make it a positive value (Minimum value is -7).
@@ -2271,21 +2271,21 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 6);
 	rt2x00_set_field8(&rfcsr, RFCSR6_R1, rf->rf2);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field8(&rfcsr, RFCSR6_TXDIV, 2);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR6_TXDIV, 1);
 	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 5);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field8(&rfcsr, RFCSR5_R1, 1);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR5_R1, 2);
 	rt2800_rfcsr_write(rt2x00dev, 5, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 12);
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2x00_set_field8(&rfcsr, RFCSR12_DR0, 3);
 		rt2x00_set_field8(&rfcsr, RFCSR12_TX_POWER,
 				  info->default_power1);
@@ -2298,7 +2298,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 13);
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2x00_set_field8(&rfcsr, RFCSR13_DR0, 3);
 		rt2x00_set_field8(&rfcsr, RFCSR13_TX_POWER,
 				  info->default_power2);
@@ -2318,7 +2318,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
 	if (rt2x00_has_cap_bt_coexist(rt2x00dev)) {
-		if (rf->channel <= 14) {
+		if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 			rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
 			rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
 		}
@@ -2355,7 +2355,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 31, drv_data->calibration_bw20);
 	}
 
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2800_rfcsr_write(rt2x00dev, 7, 0xd8);
 		rt2800_rfcsr_write(rt2x00dev, 9, 0xc3);
 		rt2800_rfcsr_write(rt2x00dev, 10, 0xf1);
@@ -2408,7 +2408,7 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 
 	reg = rt2800_register_read(rt2x00dev, GPIO_CTRL);
 	rt2x00_set_field32(&reg, GPIO_CTRL_DIR7, 0);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field32(&reg, GPIO_CTRL_VAL7, 1);
 	else
 		rt2x00_set_field32(&reg, GPIO_CTRL_VAL7, 0);
@@ -2441,7 +2441,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&bbp, BBP110_TX2_POWER, 0);
 	rt2800_bbp_write(rt2x00dev, 110, bbp);
 
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		/* Restore BBP 25 & 26 for 2.4 GHz */
 		rt2800_bbp_write(rt2x00dev, 25, drv_data->bbp25);
 		rt2800_bbp_write(rt2x00dev, 26, drv_data->bbp26);
@@ -2463,14 +2463,14 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 11);
 	rt2x00_set_field8(&rfcsr, RFCSR11_PLL_IDOH, 1);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field8(&rfcsr, RFCSR11_PLL_MOD, 1);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR11_PLL_MOD, 2);
 	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 53);
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rfcsr = 0;
 		rt2x00_set_field8(&rfcsr, RFCSR53_TX_POWER,
 				  info->default_power1 & 0x1f);
@@ -2485,7 +2485,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 53, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 55);
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rfcsr = 0;
 		rt2x00_set_field8(&rfcsr, RFCSR55_TX_POWER,
 				  info->default_power2 & 0x1f);
@@ -2500,7 +2500,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 55, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 54);
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rfcsr = 0;
 		rt2x00_set_field8(&rfcsr, RFCSR54_TX_POWER,
 				  info->default_power3 & 0x1f);
@@ -2569,7 +2569,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 32);
 	rt2x00_set_field8(&rfcsr, RFCSR32_TX_AGC_FC, txrx_agc_fc);
 
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rfcsr = 0xa0;
 	else
 		rfcsr = 0x80;
@@ -2582,28 +2582,28 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 	/* Band selection */
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 36);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 1);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 0);
 	rt2800_rfcsr_write(rt2x00dev, 36, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 34);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rfcsr = 0x3c;
 	else
 		rfcsr = 0x20;
 	rt2800_rfcsr_write(rt2x00dev, 34, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 12);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rfcsr = 0x1a;
 	else
 		rfcsr = 0x12;
 	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 6);
-	if (rf->channel >= 1 && rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
 	else if (rf->channel >= 36 && rf->channel <= 64)
 		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
@@ -2619,7 +2619,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_rfcsr_write(rt2x00dev, 46, 0x60);
 
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2800_rfcsr_write(rt2x00dev, 10, 0xd3);
 		rt2800_rfcsr_write(rt2x00dev, 13, 0x12);
 	} else {
@@ -2632,7 +2632,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 51, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 51);
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2x00_set_field8(&rfcsr, RFCSR51_BITS24, 5);
 		rt2x00_set_field8(&rfcsr, RFCSR51_BITS57, 3);
 	} else {
@@ -2642,7 +2642,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 51, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 49);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX_LO1_IC, 3);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX_LO1_IC, 2);
@@ -2657,13 +2657,13 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
 
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 57);
-	if (rf->channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		rt2x00_set_field8(&rfcsr, RFCSR57_DRV_CC, 0x1b);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR57_DRV_CC, 0x0f);
 	rt2800_rfcsr_write(rt2x00dev, 57, rfcsr);
 
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2800_rfcsr_write(rt2x00dev, 44, 0x93);
 		rt2800_rfcsr_write(rt2x00dev, 52, 0x45);
 	} else {
@@ -2673,7 +2673,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 
 	/* Initiate VCO calibration */
 	rfcsr = rt2800_rfcsr_read(rt2x00dev, 3);
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
 	} else {
 		rt2x00_set_field8(&rfcsr, RFCSR3_BIT1, 1);
@@ -2685,7 +2685,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	}
 	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
 
-	if (rf->channel >= 1 && rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rfcsr = 0x23;
 		if (txbf_enabled)
 			rt2x00_set_field8(&rfcsr, RFCSR39_RX_DIV, 1);
@@ -2741,7 +2741,7 @@ static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 
 	rt2800_freq_cal_mode1(rt2x00dev);
 
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		if (rf->channel == 6)
 			rt2800_bbp_write(rt2x00dev, 68, 0x0c);
 		else
@@ -2786,12 +2786,12 @@ static void rt2800_config_channel_rf3322(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
 
-	if ( rt2x00dev->default_ant.tx_chain_num == 2 )
+	if (rt2x00dev->default_ant.tx_chain_num == 2)
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
 
-	if ( rt2x00dev->default_ant.rx_chain_num == 2 )
+	if (rt2x00dev->default_ant.rx_chain_num == 2)
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
 	else
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
@@ -2920,7 +2920,8 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 
 	reg = rt2800_register_read(rt2x00dev, LDO_CFG0);
 	rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL,
-			   (rf->channel > 14 || conf_is_ht40(conf)) ? 5 : 0);
+			   (rt2x00dev->curr_band == NL80211_BAND_5GHZ ||
+			   			conf_is_ht40(conf)) ? 5 : 0);
 	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 
 	/* Order of values on rf_channel entry: N, K, mod, R */
@@ -2937,7 +2938,7 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR11_MOD, (rf->rf3 - 8) & 0x3);
 	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
 
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		rt2800_rfcsr_write(rt2x00dev, 10, 0x90);
 		/* FIXME: RF11 owerwrite ? */
 		rt2800_rfcsr_write(rt2x00dev, 11, 0x4A);
@@ -3160,24 +3161,34 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
 	rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
 
-	rt2800_bbp_write(rt2x00dev, 79, (rf->channel <= 14) ? 0x1C : 0x18);
-	rt2800_bbp_write(rt2x00dev, 80, (rf->channel <= 14) ? 0x0E : 0x08);
-	rt2800_bbp_write(rt2x00dev, 81, (rf->channel <= 14) ? 0x3A : 0x38);
-	rt2800_bbp_write(rt2x00dev, 82, (rf->channel <= 14) ? 0x62 : 0x92);
+	rt2800_bbp_write(rt2x00dev, 79, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x1C : 0x18);
+	rt2800_bbp_write(rt2x00dev, 80, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x0E : 0x08);
+	rt2800_bbp_write(rt2x00dev, 81, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x3A : 0x38);
+	rt2800_bbp_write(rt2x00dev, 82, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x62 : 0x92);
 
 	/* GLRT band configuration */
 	rt2800_bbp_write(rt2x00dev, 195, 128);
-	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0xE0 : 0xF0);
+	rt2800_bbp_write(rt2x00dev, 196, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0xE0 : 0xF0);
 	rt2800_bbp_write(rt2x00dev, 195, 129);
-	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x1F : 0x1E);
+	rt2800_bbp_write(rt2x00dev, 196, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x1F : 0x1E);
 	rt2800_bbp_write(rt2x00dev, 195, 130);
-	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x38 : 0x28);
+	rt2800_bbp_write(rt2x00dev, 196, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x38 : 0x28);
 	rt2800_bbp_write(rt2x00dev, 195, 131);
-	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x32 : 0x20);
+	rt2800_bbp_write(rt2x00dev, 196, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x32 : 0x20);
 	rt2800_bbp_write(rt2x00dev, 195, 133);
-	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x28 : 0x7F);
+	rt2800_bbp_write(rt2x00dev, 196, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x28 : 0x7F);
 	rt2800_bbp_write(rt2x00dev, 195, 124);
-	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x19 : 0x7F);
+	rt2800_bbp_write(rt2x00dev, 196, (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+								? 0x19 : 0x7F);
 }
 
 static void rt2800_config_channel_rf7620(struct rt2x00_dev *rt2x00dev,
@@ -3438,7 +3449,7 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 
 	/* TX0 IQ Gain */
 	rt2800_bbp_write(rt2x00dev, 158, 0x2c);
-	if (channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX0_2G);
 	else if (channel >= 36 && channel <= 64)
 		cal = rt2x00_eeprom_byte(rt2x00dev,
@@ -3455,7 +3466,7 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 
 	/* TX0 IQ Phase */
 	rt2800_bbp_write(rt2x00dev, 158, 0x2d);
-	if (channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX0_2G);
 	else if (channel >= 36 && channel <= 64)
 		cal = rt2x00_eeprom_byte(rt2x00dev,
@@ -3472,7 +3483,7 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 
 	/* TX1 IQ Gain */
 	rt2800_bbp_write(rt2x00dev, 158, 0x4a);
-	if (channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_GAIN_CAL_TX1_2G);
 	else if (channel >= 36 && channel <= 64)
 		cal = rt2x00_eeprom_byte(rt2x00dev,
@@ -3489,7 +3500,7 @@ static void rt2800_iq_calibrate(struct rt2x00_dev *rt2x00dev, int channel)
 
 	/* TX1 IQ Phase */
 	rt2800_bbp_write(rt2x00dev, 158, 0x4b);
-	if (channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		cal = rt2x00_eeprom_byte(rt2x00dev, EEPROM_IQ_PHASE_CAL_TX1_2G);
 	else if (channel >= 36 && channel <= 64)
 		cal = rt2x00_eeprom_byte(rt2x00dev,
@@ -3525,7 +3536,7 @@ static char rt2800_txpower_to_dev(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_rt(rt2x00dev, RT3593))
 		txpower = rt2x00_get_field8(txpower, EEPROM_TXPOWER_ALC);
 
-	if (channel <= 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 		return clamp_t(char, txpower, MIN_G_TXPOWER, MAX_G_TXPOWER);
 
 	if (rt2x00_rt(rt2x00dev, RT3593))
@@ -3638,7 +3649,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 86, 0x38);
 		rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 	} else if (rt2x00_rt(rt2x00dev, RT3593)) {
-		if (rf->channel > 14) {
+		if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 			/* Disable CCK Packet detection on 5GHz */
 			rt2800_bbp_write(rt2x00dev, 70, 0x00);
 		} else {
@@ -3661,7 +3672,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 86, 0);
 	}
 
-	if (rf->channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		if (!rt2x00_rt(rt2x00dev, RT5390) &&
 		    !rt2x00_rt(rt2x00dev, RT5392) &&
 		    !rt2x00_rt(rt2x00dev, RT6352)) {
@@ -3698,8 +3709,10 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 
 	reg = rt2800_register_read(rt2x00dev, TX_BAND_CFG);
 	rt2x00_set_field32(&reg, TX_BAND_CFG_HT40_MINUS, conf_is_ht40_minus(conf));
-	rt2x00_set_field32(&reg, TX_BAND_CFG_A, rf->channel > 14);
-	rt2x00_set_field32(&reg, TX_BAND_CFG_BG, rf->channel <= 14);
+	rt2x00_set_field32(&reg, TX_BAND_CFG_A, rt2x00dev->curr_band ==
+							NL80211_BAND_5GHZ);
+	rt2x00_set_field32(&reg, TX_BAND_CFG_BG, rt2x00dev->curr_band ==
+							NL80211_BAND_2GHZ);
 	rt2800_register_write(rt2x00dev, TX_BAND_CFG, reg);
 
 	if (rt2x00_rt(rt2x00dev, RT3572))
@@ -3765,7 +3778,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_rfcsr_write(rt2x00dev, 8, 0x80);
 
 		/* AGC init */
-		if (rf->channel <= 14)
+		if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 			reg = 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			reg = 0x22 + ((rt2x00dev->lna_gain * 5) / 3);
@@ -3781,7 +3794,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		    rt2x00_is_pcie(rt2x00dev)) {
 			/* GPIO #8 controls all paths */
 			rt2x00_set_field32(&reg, GPIO_CTRL_DIR8, 0);
-			if (rf->channel <= 14)
+			if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 				rt2x00_set_field32(&reg, GPIO_CTRL_VAL8, 1);
 			else
 				rt2x00_set_field32(&reg, GPIO_CTRL_VAL8, 0);
@@ -3806,7 +3819,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
 
 		/* AGC init */
-		if (rf->channel <= 14)
+		if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
 			reg = 0x1c + 2 * rt2x00dev->lna_gain;
 		else
 			reg = 0x22 + ((rt2x00dev->lna_gain * 5) / 3);
@@ -3833,7 +3846,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		if (rt2x00_rt(rt2x00dev, RT6352))
 			reg = 0x04;
 		else
-			reg = rf->channel <= 14 ? 0x1c : 0x24;
+			reg = rt2x00dev->curr_band == NL80211_BAND_2GHZ ? 0x1c : 0x24;
 
 		reg += 2 * rt2x00dev->lna_gain;
 		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
@@ -4915,7 +4928,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 		usleep_range(min_sleep, min_sleep * 2);
 
 	tx_pin = rt2800_register_read(rt2x00dev, TX_PIN_CFG);
-	if (rt2x00dev->rf_channel <= 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ) {
 		switch (rt2x00dev->default_ant.tx_chain_num) {
 		case 3:
 			rt2x00_set_field32(&tx_pin, TX_PIN_CFG_PA_PE_G2_EN, 1);
@@ -9265,8 +9278,9 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	if (WARN_ON_ONCE(!spec->channels))
 		return -ENODEV;
 
-	spec->supported_bands = SUPPORT_BAND_2GHZ;
-	if (spec->num_channels > 14)
+	if (rt2x00dev->curr_band == NL80211_BAND_2GHZ)
+		spec->supported_bands = SUPPORT_BAND_2GHZ;
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ)
 		spec->supported_bands |= SUPPORT_BAND_5GHZ;
 
 	/*
@@ -9336,7 +9350,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 			info[i].default_power3 = default_power3[i];
 	}
 
-	if (spec->num_channels > 14) {
+	if (rt2x00dev->curr_band == NL80211_BAND_5GHZ) {
 		default_power1 = rt2800_eeprom_addr(rt2x00dev,
 						    EEPROM_TXPOWER_A1);
 		default_power2 = rt2800_eeprom_addr(rt2x00dev,
-- 
1.7.0.4
