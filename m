Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:49930 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752624Ab3F1TNS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Jun 2013 15:13:18 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 14/19] rt2x00: rt2800lib: add channel configuration for RF3053
Date: Fri, 28 Jun 2013 21:12:28 +0200
Message-Id: <1372446753-11408-15-git-send-email-juhosg@openwrt.org> (sfid-20130628_211359_168254_08DFC6E7)
In-Reply-To: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
References: <1372446753-11408-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

Reference:
  RT3593_ChipSwitchChannel in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800.h    |   46 +++-
 drivers/net/wireless/rt2x00/rt2800lib.c |  366 ++++++++++++++++++++++++++++++-
 2 files changed, 409 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 7688e15..1ba797b 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -2092,6 +2092,10 @@ struct mac_iveiv_entry {
 #define BBP109_TX0_POWER		FIELD8(0x0f)
 #define BBP109_TX1_POWER		FIELD8(0xf0)
 
+/* BBP 110 */
+#define BBP110_TX2_POWER		FIELD8(0x0f)
+
+
 /*
  * BBP 138: Unknown
  */
@@ -2141,6 +2145,12 @@ struct mac_iveiv_entry {
 #define RFCSR3_PA2_CASCODE_BIAS_CCKK	FIELD8(0x80)
 /* Bits for RF3290/RF5360/RF5370/RF5372/RF5390/RF5392 */
 #define RFCSR3_VCOCAL_EN		FIELD8(0x80)
+/* Bits for RF3050 */
+#define RFCSR3_BIT1			FIELD8(0x02)
+#define RFCSR3_BIT2			FIELD8(0x04)
+#define RFCSR3_BIT3			FIELD8(0x08)
+#define RFCSR3_BIT4			FIELD8(0x10)
+#define RFCSR3_BIT5			FIELD8(0x20)
 
 /*
  * FRCSR 5:
@@ -2153,6 +2163,8 @@ struct mac_iveiv_entry {
 #define RFCSR6_R1			FIELD8(0x03)
 #define RFCSR6_R2			FIELD8(0x40)
 #define RFCSR6_TXDIV		FIELD8(0x0c)
+/* bits for RF3053 */
+#define RFCSR6_VCO_IC			FIELD8(0xc0)
 
 /*
  * RFCSR 7:
@@ -2177,7 +2189,12 @@ struct mac_iveiv_entry {
  * RFCSR 11:
  */
 #define RFCSR11_R			FIELD8(0x03)
+#define RFCSR11_PLL_MOD			FIELD8(0x0c)
 #define RFCSR11_MOD			FIELD8(0xc0)
+/* bits for RF3053 */
+/* TODO: verify RFCSR11_MOD usage on other chips */
+#define RFCSR11_PLL_IDOH		FIELD8(0x40)
+
 
 /*
  * RFCSR 12:
@@ -2273,6 +2290,12 @@ struct mac_iveiv_entry {
 #define RFCSR31_RX_H20M			FIELD8(0x20)
 #define RFCSR31_RX_CALIB		FIELD8(0x7f)
 
+/* RFCSR 32 bits for RF3053 */
+#define RFCSR32_TX_AGC_FC		FIELD8(0xf8)
+
+/* RFCSR 36 bits for RF3053 */
+#define RFCSR36_RF_BS			FIELD8(0x80)
+
 /*
  * RFCSR 38:
  */
@@ -2281,6 +2304,7 @@ struct mac_iveiv_entry {
 /*
  * RFCSR 39:
  */
+#define RFCSR39_RX_DIV			FIELD8(0x40)
 #define RFCSR39_RX_LO2_EN		FIELD8(0x80)
 
 /*
@@ -2288,18 +2312,36 @@ struct mac_iveiv_entry {
  */
 #define RFCSR49_TX			FIELD8(0x3f)
 #define RFCSR49_EP			FIELD8(0xc0)
+/* bits for RT3593 */
+#define RFCSR49_TX_LO1_IC		FIELD8(0x1c)
+#define RFCSR49_TX_DIV			FIELD8(0x20)
 
 /*
  * RFCSR 50:
  */
 #define RFCSR50_TX			FIELD8(0x3f)
 #define RFCSR50_EP			FIELD8(0xc0)
-/* bits for RT3593*/
+/* bits for RT3593 */
+#define RFCSR50_TX_LO1_EN		FIELD8(0x20)
 #define RFCSR50_TX_LO2_EN		FIELD8(0x10)
 
 /* RFCSR 51 */
-/* bits for RT3593*/
+/* bits for RT3593 */
+#define RFCSR51_BITS01			FIELD8(0x03)
 #define RFCSR51_BITS24			FIELD8(0x1c)
+#define RFCSR51_BITS57			FIELD8(0xe0)
+
+#define RFCSR53_TX_POWER		FIELD8(0x3f)
+#define RFCSR53_UNKNOWN			FIELD8(0xc0)
+
+#define RFCSR54_TX_POWER		FIELD8(0x3f)
+#define RFCSR54_UNKNOWN			FIELD8(0xc0)
+
+#define RFCSR55_TX_POWER		FIELD8(0x3f)
+#define RFCSR55_UNKNOWN			FIELD8(0xc0)
+
+#define RFCSR57_DRV_CC			FIELD8(0xfc)
+
 
 /*
  * RF registers
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6dcf03a..ab67dba 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2169,6 +2169,303 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, 7, rfcsr);
 }
 
+static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_conf *conf,
+					 struct rf_channel *rf,
+					 struct channel_info *info)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u8 txrx_agc_fc;
+	u8 txrx_h20m;
+	u8 rfcsr;
+	u8 bbp;
+	const bool txbf_enabled = false; /* TODO */
+
+	/* TODO: use TX{0,1,2}FinePowerControl values from EEPROM */
+	rt2800_bbp_read(rt2x00dev, 109, &bbp);
+	rt2x00_set_field8(&bbp, BBP109_TX0_POWER, 0);
+	rt2x00_set_field8(&bbp, BBP109_TX1_POWER, 0);
+	rt2800_bbp_write(rt2x00dev, 109, bbp);
+
+	rt2800_bbp_read(rt2x00dev, 110, &bbp);
+	rt2x00_set_field8(&bbp, BBP110_TX2_POWER, 0);
+	rt2800_bbp_write(rt2x00dev, 110, bbp);
+
+	if (rf->channel <= 14) {
+		/* Restore BBP 25 & 26 for 2.4 GHz */
+		rt2800_bbp_write(rt2x00dev, 25, drv_data->bbp25);
+		rt2800_bbp_write(rt2x00dev, 26, drv_data->bbp26);
+	} else {
+		/* Hard code BBP 25 & 26 for 5GHz */
+
+		/* Enable IQ Phase correction */
+		rt2800_bbp_write(rt2x00dev, 25, 0x09);
+		/* Setup IQ Phase correction value */
+		rt2800_bbp_write(rt2x00dev, 26, 0xff);
+	}
+
+	rt2800_rfcsr_write(rt2x00dev, 8, rf->rf1);
+	rt2800_rfcsr_write(rt2x00dev, 9, rf->rf3 & 0xf);
+
+	rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR11_R, (rf->rf2 & 0x3));
+	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 11, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR11_PLL_IDOH, 1);
+	if (rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR11_PLL_MOD, 1);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR11_PLL_MOD, 2);
+	rt2800_rfcsr_write(rt2x00dev, 11, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 53, &rfcsr);
+	if (rf->channel <= 14) {
+		rfcsr = 0;
+		rt2x00_set_field8(&rfcsr, RFCSR53_TX_POWER,
+				  info->default_power1 & 0x1f);
+	} else {
+		if (rt2x00_is_usb(rt2x00dev))
+			rfcsr = 0x40;
+
+		rt2x00_set_field8(&rfcsr, RFCSR53_TX_POWER,
+				  ((info->default_power1 & 0x18) << 1) |
+				  (info->default_power1 & 7));
+	}
+	rt2800_rfcsr_write(rt2x00dev, 53, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 55, &rfcsr);
+	if (rf->channel <= 14) {
+		rfcsr = 0;
+		rt2x00_set_field8(&rfcsr, RFCSR55_TX_POWER,
+				  info->default_power2 & 0x1f);
+	} else {
+		if (rt2x00_is_usb(rt2x00dev))
+			rfcsr = 0x40;
+
+		rt2x00_set_field8(&rfcsr, RFCSR55_TX_POWER,
+				  ((info->default_power2 & 0x18) << 1) |
+				  (info->default_power2 & 7));
+	}
+	rt2800_rfcsr_write(rt2x00dev, 55, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 54, &rfcsr);
+	if (rf->channel <= 14) {
+		rfcsr = 0;
+		rt2x00_set_field8(&rfcsr, RFCSR54_TX_POWER,
+				  info->default_power3 & 0x1f);
+	} else {
+		if (rt2x00_is_usb(rt2x00dev))
+			rfcsr = 0x40;
+
+		rt2x00_set_field8(&rfcsr, RFCSR54_TX_POWER,
+				  ((info->default_power3 & 0x18) << 1) |
+				  (info->default_power3 & 7));
+	}
+	rt2800_rfcsr_write(rt2x00dev, 54, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 0);
+	rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+	rt2x00_set_field8(&rfcsr, RFCSR1_PLL_PD, 1);
+
+	switch (rt2x00dev->default_ant.tx_chain_num) {
+	case 3:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX2_PD, 1);
+		/* fallthrough */
+	case 2:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
+		/* fallthrough */
+	case 1:
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
+		break;
+	}
+
+	switch (rt2x00dev->default_ant.rx_chain_num) {
+	case 3:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX2_PD, 1);
+		/* fallthrough */
+	case 2:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
+		/* fallthrough */
+	case 1:
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
+		break;
+	}
+	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+	/* TODO: frequency calibration? */
+
+	if (conf_is_ht40(conf)) {
+		txrx_agc_fc = rt2x00_get_field8(drv_data->calibration_bw40,
+						RFCSR24_TX_AGC_FC);
+		txrx_h20m = rt2x00_get_field8(drv_data->calibration_bw40,
+					      RFCSR24_TX_H20M);
+	} else {
+		txrx_agc_fc = rt2x00_get_field8(drv_data->calibration_bw20,
+						RFCSR24_TX_AGC_FC);
+		txrx_h20m = rt2x00_get_field8(drv_data->calibration_bw20,
+					      RFCSR24_TX_H20M);
+	}
+
+	/* NOTE: the reference driver does not writes the new value
+	 * back to RFCSR 32
+	 */
+	rt2800_rfcsr_read(rt2x00dev, 32, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR32_TX_AGC_FC, txrx_agc_fc);
+
+	if (rf->channel <= 14)
+		rfcsr = 0xa0;
+	else
+		rfcsr = 0x80;
+	rt2800_rfcsr_write(rt2x00dev, 31, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR30_TX_H20M, txrx_h20m);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RX_H20M, txrx_h20m);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
+	/* Band selection */
+	rt2800_rfcsr_read(rt2x00dev, 36, &rfcsr);
+	if (rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 1);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR36_RF_BS, 0);
+	rt2800_rfcsr_write(rt2x00dev, 36, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 34, &rfcsr);
+	if (rf->channel <= 14)
+		rfcsr = 0x3c;
+	else
+		rfcsr = 0x20;
+	rt2800_rfcsr_write(rt2x00dev, 34, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 12, &rfcsr);
+	if (rf->channel <= 14)
+		rfcsr = 0x1a;
+	else
+		rfcsr = 0x12;
+	rt2800_rfcsr_write(rt2x00dev, 12, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
+	if (rf->channel >= 1 && rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
+	else if (rf->channel >= 36 && rf->channel <= 64)
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
+	else if (rf->channel >= 100 && rf->channel <= 128)
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 2);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR6_VCO_IC, 1);
+	rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
+	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
+
+	rt2800_rfcsr_write(rt2x00dev, 46, 0x60);
+
+	if (rf->channel <= 14) {
+		rt2800_rfcsr_write(rt2x00dev, 10, 0xd3);
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x12);
+	} else {
+		rt2800_rfcsr_write(rt2x00dev, 10, 0xd8);
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x23);
+	}
+
+	rt2800_rfcsr_read(rt2x00dev, 51, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR51_BITS01, 1);
+	rt2800_rfcsr_write(rt2x00dev, 51, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 51, &rfcsr);
+	if (rf->channel <= 14) {
+		rt2x00_set_field8(&rfcsr, RFCSR51_BITS24, 5);
+		rt2x00_set_field8(&rfcsr, RFCSR51_BITS57, 3);
+	} else {
+		rt2x00_set_field8(&rfcsr, RFCSR51_BITS24, 4);
+		rt2x00_set_field8(&rfcsr, RFCSR51_BITS57, 2);
+	}
+	rt2800_rfcsr_write(rt2x00dev, 51, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 49, &rfcsr);
+	if (rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX_LO1_IC, 3);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX_LO1_IC, 2);
+
+	if (txbf_enabled)
+		rt2x00_set_field8(&rfcsr, RFCSR49_TX_DIV, 1);
+
+	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 50, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR50_TX_LO1_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 50, rfcsr);
+
+	rt2800_rfcsr_read(rt2x00dev, 57, &rfcsr);
+	if (rf->channel <= 14)
+		rt2x00_set_field8(&rfcsr, RFCSR57_DRV_CC, 0x1b);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR57_DRV_CC, 0x0f);
+	rt2800_rfcsr_write(rt2x00dev, 57, rfcsr);
+
+	if (rf->channel <= 14) {
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x93);
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x45);
+	} else {
+		rt2800_rfcsr_write(rt2x00dev, 44, 0x9b);
+		rt2800_rfcsr_write(rt2x00dev, 52, 0x05);
+	}
+
+	/* Initiate VCO calibration */
+	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
+	if (rf->channel <= 14) {
+		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	} else {
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT1, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT2, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT3, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT4, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_BIT5, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
+	}
+	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+
+	if (rf->channel >= 1 && rf->channel <= 14) {
+		rfcsr = 0x23;
+		if (txbf_enabled)
+			rt2x00_set_field8(&rfcsr, RFCSR39_RX_DIV, 1);
+		rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
+
+		rt2800_rfcsr_write(rt2x00dev, 45, 0xbb);
+	} else if (rf->channel >= 36 && rf->channel <= 64) {
+		rfcsr = 0x36;
+		if (txbf_enabled)
+			rt2x00_set_field8(&rfcsr, RFCSR39_RX_DIV, 1);
+		rt2800_rfcsr_write(rt2x00dev, 39, 0x36);
+
+		rt2800_rfcsr_write(rt2x00dev, 45, 0xeb);
+	} else if (rf->channel >= 100 && rf->channel <= 128) {
+		rfcsr = 0x32;
+		if (txbf_enabled)
+			rt2x00_set_field8(&rfcsr, RFCSR39_RX_DIV, 1);
+		rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
+
+		rt2800_rfcsr_write(rt2x00dev, 45, 0xb3);
+	} else {
+		rfcsr = 0x30;
+		if (txbf_enabled)
+			rt2x00_set_field8(&rfcsr, RFCSR39_RX_DIV, 1);
+		rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
+
+		rt2800_rfcsr_write(rt2x00dev, 45, 0x9b);
+	}
+}
+
 #define POWER_BOUND		0x27
 #define POWER_BOUND_5G		0x2b
 #define FREQ_OFFSET_BOUND	0x5f
@@ -2785,6 +3082,9 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	case RF3052:
 		rt2800_config_channel_rf3052(rt2x00dev, conf, rf, info);
 		break;
+	case RF3053:
+		rt2800_config_channel_rf3053(rt2x00dev, conf, rf, info);
+		break;
 	case RF3290:
 		rt2800_config_channel_rf3290(rt2x00dev, conf, rf, info);
 		break;
@@ -2830,6 +3130,23 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 27, 0x20);
 		rt2800_bbp_write(rt2x00dev, 66, 0x26 + rt2x00dev->lna_gain);
+	} else if (rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rf->channel > 14) {
+			/* Disable CCK Packet detection on 5GHz */
+			rt2800_bbp_write(rt2x00dev, 70, 0x00);
+		} else {
+			rt2800_bbp_write(rt2x00dev, 70, 0x0a);
+		}
+
+		if (conf_is_ht40(conf))
+			rt2800_bbp_write(rt2x00dev, 105, 0x04);
+		else
+			rt2800_bbp_write(rt2x00dev, 105, 0x34);
+
+		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
+		rt2800_bbp_write(rt2x00dev, 77, 0x98);
 	} else {
 		rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
 		rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
@@ -2845,16 +3162,27 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 				rt2800_bbp_write(rt2x00dev, 82, 0x62);
 				rt2800_bbp_write(rt2x00dev, 75, 0x46);
 			} else {
-				rt2800_bbp_write(rt2x00dev, 82, 0x84);
+				if (rt2x00_rt(rt2x00dev, RT3593))
+					rt2800_bbp_write(rt2x00dev, 82, 0x62);
+				else
+					rt2800_bbp_write(rt2x00dev, 82, 0x84);
 				rt2800_bbp_write(rt2x00dev, 75, 0x50);
 			}
+			if (rt2x00_rt(rt2x00dev, RT3593))
+				rt2800_bbp_write(rt2x00dev, 83, 0x8a);
 		}
+
 	} else {
 		if (rt2x00_rt(rt2x00dev, RT3572))
 			rt2800_bbp_write(rt2x00dev, 82, 0x94);
+		else if (rt2x00_rt(rt2x00dev, RT3593))
+			rt2800_bbp_write(rt2x00dev, 82, 0x82);
 		else
 			rt2800_bbp_write(rt2x00dev, 82, 0xf2);
 
+		if (rt2x00_rt(rt2x00dev, RT3593))
+			rt2800_bbp_write(rt2x00dev, 83, 0x9a);
+
 		if (test_bit(CAPABILITY_EXTERNAL_LNA_A, &rt2x00dev->cap_flags))
 			rt2800_bbp_write(rt2x00dev, 75, 0x46);
 		else
@@ -2925,6 +3253,41 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_rt(rt2x00dev, RT3572))
 		rt2800_rfcsr_write(rt2x00dev, 8, 0x80);
 
+	if (rt2x00_rt(rt2x00dev, RT3593)) {
+		if (rt2x00_is_usb(rt2x00dev)) {
+			rt2800_register_read(rt2x00dev, GPIO_CTRL, &reg);
+
+			/* Band selection. GPIO #8 controls all paths */
+			rt2x00_set_field32(&reg, GPIO_CTRL_DIR8, 0);
+			if (rf->channel <= 14)
+				rt2x00_set_field32(&reg, GPIO_CTRL_VAL8, 1);
+			else
+				rt2x00_set_field32(&reg, GPIO_CTRL_VAL8, 0);
+
+			rt2x00_set_field32(&reg, GPIO_CTRL_DIR4, 0);
+			rt2x00_set_field32(&reg, GPIO_CTRL_DIR7, 0);
+
+			/* LNA PE control.
+			* GPIO #4 controls PE0 and PE1,
+			* GPIO #7 controls PE2
+			*/
+			rt2x00_set_field32(&reg, GPIO_CTRL_VAL4, 1);
+			rt2x00_set_field32(&reg, GPIO_CTRL_VAL7, 1);
+
+			rt2800_register_write(rt2x00dev, GPIO_CTRL, reg);
+		}
+
+		/* AGC init */
+		if (rf->channel <= 14)
+			reg = 0x1c + 2 * rt2x00dev->lna_gain;
+		else
+			reg = 0x22 + ((rt2x00dev->lna_gain * 5) / 3);
+
+		rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, reg);
+
+		usleep_range(1000, 1500);
+	}
+
 	if (rt2x00_rt(rt2x00dev, RT5592)) {
 		rt2800_bbp_write(rt2x00dev, 195, 141);
 		rt2800_bbp_write(rt2x00dev, 196, conf_is_ht40(conf) ? 0x10 : 0x1a);
@@ -5884,6 +6247,7 @@ static void rt3593_post_bbp_init(struct rt2x00_dev *rt2x00dev)
 
 	/* FIXME: BBP 105 owerwrite? */
 	rt2800_bbp_write(rt2x00dev, 105, 0x04);
+
 }
 
 static void rt2800_init_rfcsr_3593(struct rt2x00_dev *rt2x00dev)
-- 
1.7.10

