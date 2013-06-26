Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:41251 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251Ab3FZRzZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 13:55:25 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/5] rt2x00: rt2800lib: introduce local EEPROM access functions
Date: Wed, 26 Jun 2013 19:55:15 +0200
Message-Id: <1372269318-30233-3-git-send-email-juhosg@openwrt.org> (sfid-20130626_195532_077478_C1BB24FC)
In-Reply-To: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
References: <1372269318-30233-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The patch adds rt2800 specific functions for
EEPROM data access and changes the code to use
these instead of the generic rt2x00_eeprom_*
variants.

To avoid functional changes, the new functions
are wrappers around the corresponding generic
rt2x00_eeprom_* routines for now. Functional
changes will be implemented in additional patches.

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  165 ++++++++++++++++++-------------
 1 file changed, 95 insertions(+), 70 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1f80ea5..522f0b1 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -221,6 +221,24 @@ static void rt2800_rf_write(struct rt2x00_dev *rt2x00dev,
 	mutex_unlock(&rt2x00dev->csr_mutex);
 }
 
+static void *rt2800_eeprom_addr(struct rt2x00_dev *rt2x00dev,
+				const enum rt2800_eeprom_word word)
+{
+	return rt2x00_eeprom_addr(rt2x00dev, word);
+}
+
+static void rt2800_eeprom_read(struct rt2x00_dev *rt2x00dev,
+			       const enum rt2800_eeprom_word word, u16 *data)
+{
+	rt2x00_eeprom_read(rt2x00dev, word, data);
+}
+
+static void rt2800_eeprom_write(struct rt2x00_dev *rt2x00dev,
+				const enum rt2800_eeprom_word word, u16 data)
+{
+	rt2x00_eeprom_write(rt2x00dev, word, data);
+}
+
 static int rt2800_enable_wlan_rt3290(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg;
@@ -609,16 +627,16 @@ static int rt2800_agc_to_rssi(struct rt2x00_dev *rt2x00dev, u32 rxwi_w2)
 	u8 offset2;
 
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &eeprom);
 		offset0 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET0);
 		offset1 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG_OFFSET1);
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
 		offset2 = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG2_OFFSET2);
 	} else {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &eeprom);
 		offset0 = rt2x00_get_field16(eeprom, EEPROM_RSSI_A_OFFSET0);
 		offset1 = rt2x00_get_field16(eeprom, EEPROM_RSSI_A_OFFSET1);
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &eeprom);
 		offset2 = rt2x00_get_field16(eeprom, EEPROM_RSSI_A2_OFFSET2);
 	}
 
@@ -890,6 +908,9 @@ const struct rt2x00debug rt2800_rt2x00debug = {
 		.word_count	= CSR_REG_SIZE / sizeof(u32),
 	},
 	.eeprom	= {
+		/* NOTE: The local EEPROM access functions can't
+		 * be used here, use the generic versions instead.
+		 */
 		.read		= rt2x00_eeprom_read,
 		.write		= rt2x00_eeprom_write,
 		.word_base	= EEPROM_BASE,
@@ -1547,7 +1568,7 @@ static void rt2800_config_3572bt_ant(struct rt2x00_dev *rt2x00dev)
 	led_r_mode = rt2x00_get_field32(reg, LED_CFG_LED_POLAR) ? 0 : 3;
 	if (led_g_mode != rt2x00_get_field32(reg, LED_CFG_G_LED_MODE) ||
 	    led_r_mode != rt2x00_get_field32(reg, LED_CFG_R_LED_MODE)) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
 		led_ctrl = rt2x00_get_field16(eeprom, EEPROM_FREQ_LED_MODE);
 		if (led_ctrl == 0 || led_ctrl > 0x40) {
 			rt2x00_set_field32(&reg, LED_CFG_G_LED_MODE, led_g_mode);
@@ -1622,7 +1643,7 @@ void rt2800_config_ant(struct rt2x00_dev *rt2x00dev, struct antenna_setup *ant)
 		    rt2x00_rt(rt2x00dev, RT3090) ||
 		    rt2x00_rt(rt2x00dev, RT3352) ||
 		    rt2x00_rt(rt2x00dev, RT3390)) {
-			rt2x00_eeprom_read(rt2x00dev,
+			rt2800_eeprom_read(rt2x00dev,
 					   EEPROM_NIC_CONF1, &eeprom);
 			if (rt2x00_get_field16(eeprom,
 						EEPROM_NIC_CONF1_ANT_DIVERSITY))
@@ -1659,16 +1680,16 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 	short lna_gain;
 
 	if (libconf->rf.channel <= 14) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_LNA, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_LNA, &eeprom);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_LNA_BG);
 	} else if (libconf->rf.channel <= 64) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_LNA, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_LNA, &eeprom);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_LNA_A0);
 	} else if (libconf->rf.channel <= 128) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_RSSI_BG2_LNA_A1);
 	} else {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &eeprom);
 		lna_gain = rt2x00_get_field16(eeprom, EEPROM_RSSI_A2_LNA_A2);
 	}
 
@@ -2798,62 +2819,62 @@ static int rt2800_get_gain_calibration_delta(struct rt2x00_dev *rt2x00dev)
 	 * Example TSSI bounds  0xF0 0xD0 0xB5 0xA0 0x88 0x45 0x25 0x15 0x00
 	 */
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG1, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG1, &eeprom);
 		tssi_bounds[0] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG1_MINUS4);
 		tssi_bounds[1] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG1_MINUS3);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG2, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG2, &eeprom);
 		tssi_bounds[2] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG2_MINUS2);
 		tssi_bounds[3] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG2_MINUS1);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG3, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG3, &eeprom);
 		tssi_bounds[4] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG3_REF);
 		tssi_bounds[5] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG3_PLUS1);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG4, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG4, &eeprom);
 		tssi_bounds[6] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG4_PLUS2);
 		tssi_bounds[7] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG4_PLUS3);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG5, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_BG5, &eeprom);
 		tssi_bounds[8] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_BG5_PLUS4);
 
 		step = rt2x00_get_field16(eeprom,
 					  EEPROM_TSSI_BOUND_BG5_AGC_STEP);
 	} else {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A1, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A1, &eeprom);
 		tssi_bounds[0] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A1_MINUS4);
 		tssi_bounds[1] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A1_MINUS3);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A2, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A2, &eeprom);
 		tssi_bounds[2] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A2_MINUS2);
 		tssi_bounds[3] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A2_MINUS1);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A3, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A3, &eeprom);
 		tssi_bounds[4] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A3_REF);
 		tssi_bounds[5] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A3_PLUS1);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A4, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A4, &eeprom);
 		tssi_bounds[6] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A4_PLUS2);
 		tssi_bounds[7] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A4_PLUS3);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A5, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TSSI_BOUND_A5, &eeprom);
 		tssi_bounds[8] = rt2x00_get_field16(eeprom,
 					EEPROM_TSSI_BOUND_A5_PLUS4);
 
@@ -2899,7 +2920,7 @@ static int rt2800_get_txpower_bw_comp(struct rt2x00_dev *rt2x00dev,
 	u8 comp_type;
 	int comp_value = 0;
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_DELTA, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_TXPOWER_DELTA, &eeprom);
 
 	/*
 	 * HT40 compensation not required.
@@ -2974,12 +2995,12 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 		 * .11b data rate need add additional 4dbm
 		 * when calculating eirp txpower.
 		 */
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + 1,
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + 1,
 				   &eeprom);
 		criterion = rt2x00_get_field16(eeprom,
 					       EEPROM_TXPOWER_BYRATE_RATE0);
 
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_EIRP_MAX_TX_POWER,
+		rt2800_eeprom_read(rt2x00dev, EEPROM_EIRP_MAX_TX_POWER,
 				   &eeprom);
 
 		if (band == IEEE80211_BAND_2GHZ)
@@ -3080,7 +3101,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		rt2800_register_read(rt2x00dev, offset, &reg);
 
 		/* read the next four txpower values */
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i,
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i,
 				   &eeprom);
 
 		is_rate_b = i ? 0 : 1;
@@ -3129,7 +3150,7 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field32(&reg, TX_PWR_CFG_RATE3, txpower);
 
 		/* read the next four txpower values */
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i + 1,
+		rt2800_eeprom_read(rt2x00dev, EEPROM_TXPOWER_BYRATE + i + 1,
 				   &eeprom);
 
 		is_rate_b = 0;
@@ -3528,7 +3549,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
 		    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
-			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+			rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1,
+					   &eeprom);
 			if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
 				rt2800_register_write(rt2x00dev, TX_SW_CFG2,
 						      0x0000002c);
@@ -3989,7 +4011,7 @@ static void rt2800_disable_unused_dac_adc(struct rt2x00_dev *rt2x00dev)
 	u8 value;
 
 	rt2800_bbp_read(rt2x00dev, 138, &value);
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
 		value |= 0x20;
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
@@ -4402,7 +4424,7 @@ static void rt2800_init_bbp_53xx(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_disable_unused_dac_adc(rt2x00dev);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
 	div_mode = rt2x00_get_field16(eeprom,
 				      EEPROM_NIC_CONF1_ANT_DIVERSITY);
 	ant = (div_mode == 3) ? 1 : 0;
@@ -4488,7 +4510,7 @@ static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
 	div_mode = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_ANT_DIVERSITY);
 	ant = (div_mode == 3) ? 1 : 0;
 	rt2800_bbp_read(rt2x00dev, 152, &value);
@@ -4557,7 +4579,7 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	}
 
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
 		if (eeprom != 0xffff && eeprom != 0x0000) {
 			reg_id = rt2x00_get_field16(eeprom, EEPROM_BBP_REG_ID);
@@ -4728,7 +4750,7 @@ static void rt2800_normal_mode_setup_3xxx(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT3090)) {
 		/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
 		rt2800_bbp_read(rt2x00dev, 138, &bbp);
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
 			rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
 		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
@@ -4778,7 +4800,7 @@ static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
 
 	/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
 	rt2800_bbp_read(rt2x00dev, 138, &reg);
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
 		rt2x00_set_field8(&reg, BBP138_RX_ADC1, 0);
 	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
@@ -4884,7 +4906,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
-			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+			rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1,
+					   &eeprom);
 			if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF1_DAC_TEST))
 				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
 			else
@@ -5456,15 +5479,15 @@ int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Initialize LED control
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED_AG_CONF, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_LED_AG_CONF, &word);
 	rt2800_mcu_request(rt2x00dev, MCU_LED_AG_CONF, 0xff,
 			   word & 0xff, (word >> 8) & 0xff);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED_ACT_CONF, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_LED_ACT_CONF, &word);
 	rt2800_mcu_request(rt2x00dev, MCU_LED_ACT_CONF, 0xff,
 			   word & 0xff, (word >> 8) & 0xff);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LED_POLARITY, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_LED_POLARITY, &word);
 	rt2800_mcu_request(rt2x00dev, MCU_LED_LED_POLARITY, 0xff,
 			   word & 0xff, (word >> 8) & 0xff);
 
@@ -5578,18 +5601,18 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Start validation of the data that has been read.
 	 */
-	mac = rt2x00_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
+	mac = rt2800_eeprom_addr(rt2x00dev, EEPROM_MAC_ADDR_0);
 	if (!is_valid_ether_addr(mac)) {
 		eth_random_addr(mac);
 		rt2x00_eeprom_dbg(rt2x00dev, "MAC: %pM\n", mac);
 	}
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &word);
 	if (word == 0xffff) {
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 2);
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_TXPATH, 1);
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF2820);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
 		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
 	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
 		   rt2x00_rt(rt2x00dev, RT2872)) {
@@ -5598,10 +5621,10 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		 */
 		if (rt2x00_get_field16(word, EEPROM_NIC_CONF0_RXPATH) > 2)
 			rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 2);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
 	}
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &word);
 	if (word == 0xffff) {
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_HW_RADIO, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_EXTERNAL_TX_ALC, 0);
@@ -5618,24 +5641,24 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_INTERNAL_TX_ALC, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_BT_COEXIST, 0);
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF1_DAC_TEST, 0);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF1, word);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_NIC_CONF1, word);
 		rt2x00_eeprom_dbg(rt2x00dev, "NIC: 0x%04x\n", word);
 	}
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_FREQ, &word);
 	if ((word & 0x00ff) == 0x00ff) {
 		rt2x00_set_field16(&word, EEPROM_FREQ_OFFSET, 0);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
 		rt2x00_eeprom_dbg(rt2x00dev, "Freq: 0x%04x\n", word);
 	}
 	if ((word & 0xff00) == 0xff00) {
 		rt2x00_set_field16(&word, EEPROM_FREQ_LED_MODE,
 				   LED_MODE_TXRX_ACTIVITY);
 		rt2x00_set_field16(&word, EEPROM_FREQ_LED_POLARITY, 0);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED_AG_CONF, 0x5555);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED_ACT_CONF, 0x2221);
-		rt2x00_eeprom_write(rt2x00dev, EEPROM_LED_POLARITY, 0xa9f8);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_FREQ, word);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_LED_AG_CONF, 0x5555);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_LED_ACT_CONF, 0x2221);
+		rt2800_eeprom_write(rt2x00dev, EEPROM_LED_POLARITY, 0xa9f8);
 		rt2x00_eeprom_dbg(rt2x00dev, "Led Mode: 0x%04x\n", word);
 	}
 
@@ -5644,17 +5667,17 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 	 * lna0 as correct value. Note that EEPROM_LNA
 	 * is never validated.
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_LNA, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_LNA, &word);
 	default_lna_gain = rt2x00_get_field16(word, EEPROM_LNA_A0);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET0)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET0, 0);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG_OFFSET1)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG_OFFSET1, 0);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG, word);
+	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_BG, word);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &word);
 	if ((word & 0x00ff) != 0x00ff) {
 		drv_data->txmixer_gain_24g =
 			rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_BG_VAL);
@@ -5662,16 +5685,16 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		drv_data->txmixer_gain_24g = 0;
 	}
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_BG2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_OFFSET2, 0);
 	if (rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0x00 ||
 	    rt2x00_get_field16(word, EEPROM_RSSI_BG2_LNA_A1) == 0xff)
 		rt2x00_set_field16(&word, EEPROM_RSSI_BG2_LNA_A1,
 				   default_lna_gain);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
+	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_BG2, word);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_A, &word);
 	if ((word & 0x00ff) != 0x00ff) {
 		drv_data->txmixer_gain_5g =
 			rt2x00_get_field16(word, EEPROM_TXMIXER_GAIN_A_VAL);
@@ -5679,21 +5702,21 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		drv_data->txmixer_gain_5g = 0;
 	}
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET0)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET0, 0);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A_OFFSET1)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A_OFFSET1, 0);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A, word);
+	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_A, word);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &word);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_RSSI_A2, &word);
 	if (abs(rt2x00_get_field16(word, EEPROM_RSSI_A2_OFFSET2)) > 10)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A2_OFFSET2, 0);
 	if (rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0x00 ||
 	    rt2x00_get_field16(word, EEPROM_RSSI_A2_LNA_A2) == 0xff)
 		rt2x00_set_field16(&word, EEPROM_RSSI_A2_LNA_A2,
 				   default_lna_gain);
-	rt2x00_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
+	rt2800_eeprom_write(rt2x00dev, EEPROM_RSSI_A2, word);
 
 	return 0;
 }
@@ -5707,7 +5730,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Read EEPROM word for configuration.
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 
 	/*
 	 * Identify RF chipset by EEPROM value
@@ -5717,7 +5740,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00_rt(rt2x00dev, RT3290) ||
 	    rt2x00_rt(rt2x00dev, RT5390) ||
 	    rt2x00_rt(rt2x00dev, RT5392))
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
+		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
 	else
 		rf = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 
@@ -5757,7 +5780,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->default_ant.rx_chain_num =
 	    rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH);
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF1, &eeprom);
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
 	    rt2x00_rt(rt2x00dev, RT3090) ||
@@ -5810,7 +5833,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Read frequency offset and RF programming sequence.
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_FREQ, &eeprom);
 	rt2x00dev->freq_offset = rt2x00_get_field16(eeprom, EEPROM_FREQ_OFFSET);
 
 	/*
@@ -5827,7 +5850,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	/*
 	 * Check if support EIRP tx power limit feature.
 	 */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_EIRP_MAX_TX_POWER, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_EIRP_MAX_TX_POWER, &eeprom);
 
 	if (rt2x00_get_field16(eeprom, EEPROM_EIRP_MAX_TX_POWER_2GHZ) <
 					EIRP_MAX_TX_POWER_LIMIT)
@@ -6148,7 +6171,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	SET_IEEE80211_DEV(rt2x00dev->hw, rt2x00dev->dev);
 	SET_IEEE80211_PERM_ADDR(rt2x00dev->hw,
-				rt2x00_eeprom_addr(rt2x00dev,
+				rt2800_eeprom_addr(rt2x00dev,
 						   EEPROM_MAC_ADDR_0));
 
 	/*
@@ -6164,7 +6187,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	rt2x00dev->hw->max_report_rates = 7;
 	rt2x00dev->hw->max_rate_tries = 1;
 
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+	rt2800_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
 
 	/*
 	 * Initialize hw_mode information.
@@ -6264,8 +6287,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 
 	spec->channels_info = info;
 
-	default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
-	default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
+	default_power1 = rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG1);
+	default_power2 = rt2800_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_BG2);
 
 	for (i = 0; i < 14; i++) {
 		info[i].default_power1 = default_power1[i];
@@ -6273,8 +6296,10 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (spec->num_channels > 14) {
-		default_power1 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A1);
-		default_power2 = rt2x00_eeprom_addr(rt2x00dev, EEPROM_TXPOWER_A2);
+		default_power1 = rt2800_eeprom_addr(rt2x00dev,
+						    EEPROM_TXPOWER_A1);
+		default_power2 = rt2800_eeprom_addr(rt2x00dev,
+						    EEPROM_TXPOWER_A2);
 
 		for (i = 14; i < spec->num_channels; i++) {
 			info[i].default_power1 = default_power1[i - 14];
-- 
1.7.10

