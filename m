Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48229 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751900Ab3GHOIp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jul 2013 10:08:45 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v3 05/20] rt2x00: rt2800lib: add TX power configuration for RT3593
Date: Mon,  8 Jul 2013 16:08:20 +0200
Message-Id: <1373292515-21332-6-git-send-email-juhosg@openwrt.org> (sfid-20130708_162039_784870_F3292214)
In-Reply-To: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
References: <1373292515-21332-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Based on the Ralink DPO_RT5572_LinuxSTA_2.6.0.1_20120629
driver.

References:
  RTMPReadTxPwrPerRateExt in chips/rt3593.c
  RT3593_AsicGetTxPowerOffset in chips/rt3593.c

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
Changes since v2: ---
---
 drivers/net/wireless/rt2x00/rt2800.h    |  116 +++++++++
 drivers/net/wireless/rt2x00/rt2800lib.c |  425 ++++++++++++++++++++++++++++++-
 2 files changed, 538 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800.h b/drivers/net/wireless/rt2x00/rt2800.h
index 47aceae..7b7caeb 100644
--- a/drivers/net/wireless/rt2x00/rt2800.h
+++ b/drivers/net/wireless/rt2x00/rt2800.h
@@ -1083,6 +1083,15 @@
 #define TX_PWR_CFG_0_9MBS		FIELD32(0x00f00000)
 #define TX_PWR_CFG_0_12MBS		FIELD32(0x0f000000)
 #define TX_PWR_CFG_0_18MBS		FIELD32(0xf0000000)
+/* bits for 3T devices */
+#define TX_PWR_CFG_0_CCK1_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_0_CCK1_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_0_CCK5_CH0		FIELD32(0x00000f00)
+#define TX_PWR_CFG_0_CCK5_CH1		FIELD32(0x0000f000)
+#define TX_PWR_CFG_0_OFDM6_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_0_OFDM6_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_0_OFDM12_CH0		FIELD32(0x0f000000)
+#define TX_PWR_CFG_0_OFDM12_CH1		FIELD32(0xf0000000)
 
 /*
  * TX_PWR_CFG_1:
@@ -1096,6 +1105,15 @@
 #define TX_PWR_CFG_1_MCS1		FIELD32(0x00f00000)
 #define TX_PWR_CFG_1_MCS2		FIELD32(0x0f000000)
 #define TX_PWR_CFG_1_MCS3		FIELD32(0xf0000000)
+/* bits for 3T devices */
+#define TX_PWR_CFG_1_OFDM24_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_1_OFDM24_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_1_OFDM48_CH0		FIELD32(0x00000f00)
+#define TX_PWR_CFG_1_OFDM48_CH1		FIELD32(0x0000f000)
+#define TX_PWR_CFG_1_MCS0_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_1_MCS0_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_1_MCS2_CH0		FIELD32(0x0f000000)
+#define TX_PWR_CFG_1_MCS2_CH1		FIELD32(0xf0000000)
 
 /*
  * TX_PWR_CFG_2:
@@ -1109,6 +1127,15 @@
 #define TX_PWR_CFG_2_MCS9		FIELD32(0x00f00000)
 #define TX_PWR_CFG_2_MCS10		FIELD32(0x0f000000)
 #define TX_PWR_CFG_2_MCS11		FIELD32(0xf0000000)
+/* bits for 3T devices */
+#define TX_PWR_CFG_2_MCS4_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_2_MCS4_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_2_MCS6_CH0		FIELD32(0x00000f00)
+#define TX_PWR_CFG_2_MCS6_CH1		FIELD32(0x0000f000)
+#define TX_PWR_CFG_2_MCS8_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_2_MCS8_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_2_MCS10_CH0		FIELD32(0x0f000000)
+#define TX_PWR_CFG_2_MCS10_CH1		FIELD32(0xf0000000)
 
 /*
  * TX_PWR_CFG_3:
@@ -1122,6 +1149,15 @@
 #define TX_PWR_CFG_3_UKNOWN2		FIELD32(0x00f00000)
 #define TX_PWR_CFG_3_UKNOWN3		FIELD32(0x0f000000)
 #define TX_PWR_CFG_3_UKNOWN4		FIELD32(0xf0000000)
+/* bits for 3T devices */
+#define TX_PWR_CFG_3_MCS12_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_3_MCS12_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_3_MCS14_CH0		FIELD32(0x00000f00)
+#define TX_PWR_CFG_3_MCS14_CH1		FIELD32(0x0000f000)
+#define TX_PWR_CFG_3_STBC0_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_3_STBC0_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_3_STBC2_CH0		FIELD32(0x0f000000)
+#define TX_PWR_CFG_3_STBC2_CH1		FIELD32(0xf0000000)
 
 /*
  * TX_PWR_CFG_4:
@@ -1131,6 +1167,11 @@
 #define TX_PWR_CFG_4_UKNOWN6		FIELD32(0x000000f0)
 #define TX_PWR_CFG_4_UKNOWN7		FIELD32(0x00000f00)
 #define TX_PWR_CFG_4_UKNOWN8		FIELD32(0x0000f000)
+/* bits for 3T devices */
+#define TX_PWR_CFG_3_STBC4_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_3_STBC4_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_3_STBC6_CH0		FIELD32(0x00000f00)
+#define TX_PWR_CFG_3_STBC6_CH1		FIELD32(0x0000f000)
 
 /*
  * TX_PIN_CFG:
@@ -1452,6 +1493,81 @@
  */
 #define EXP_ACK_TIME			0x1380
 
+/* TX_PWR_CFG_5 */
+#define TX_PWR_CFG_5			0x1384
+#define TX_PWR_CFG_5_MCS16_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_5_MCS16_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_5_MCS16_CH2		FIELD32(0x00000f00)
+#define TX_PWR_CFG_5_MCS18_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_5_MCS18_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_5_MCS18_CH2		FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_6 */
+#define TX_PWR_CFG_6			0x1388
+#define TX_PWR_CFG_6_MCS20_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_6_MCS20_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_6_MCS20_CH2		FIELD32(0x00000f00)
+#define TX_PWR_CFG_6_MCS22_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_6_MCS22_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_6_MCS22_CH2		FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_0_EXT */
+#define TX_PWR_CFG_0_EXT		0x1390
+#define TX_PWR_CFG_0_EXT_CCK1_CH2	FIELD32(0x0000000f)
+#define TX_PWR_CFG_0_EXT_CCK5_CH2	FIELD32(0x00000f00)
+#define TX_PWR_CFG_0_EXT_OFDM6_CH2	FIELD32(0x000f0000)
+#define TX_PWR_CFG_0_EXT_OFDM12_CH2	FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_1_EXT */
+#define TX_PWR_CFG_1_EXT		0x1394
+#define TX_PWR_CFG_1_EXT_OFDM24_CH2	FIELD32(0x0000000f)
+#define TX_PWR_CFG_1_EXT_OFDM48_CH2	FIELD32(0x00000f00)
+#define TX_PWR_CFG_1_EXT_MCS0_CH2	FIELD32(0x000f0000)
+#define TX_PWR_CFG_1_EXT_MCS2_CH2	FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_2_EXT */
+#define TX_PWR_CFG_2_EXT		0x1398
+#define TX_PWR_CFG_2_EXT_MCS4_CH2	FIELD32(0x0000000f)
+#define TX_PWR_CFG_2_EXT_MCS6_CH2	FIELD32(0x00000f00)
+#define TX_PWR_CFG_2_EXT_MCS8_CH2	FIELD32(0x000f0000)
+#define TX_PWR_CFG_2_EXT_MCS10_CH2	FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_3_EXT */
+#define TX_PWR_CFG_3_EXT		0x139c
+#define TX_PWR_CFG_3_EXT_MCS12_CH2	FIELD32(0x0000000f)
+#define TX_PWR_CFG_3_EXT_MCS14_CH2	FIELD32(0x00000f00)
+#define TX_PWR_CFG_3_EXT_STBC0_CH2	FIELD32(0x000f0000)
+#define TX_PWR_CFG_3_EXT_STBC2_CH2	FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_4_EXT */
+#define TX_PWR_CFG_4_EXT		0x13a0
+#define TX_PWR_CFG_4_EXT_STBC4_CH2	FIELD32(0x0000000f)
+#define TX_PWR_CFG_4_EXT_STBC6_CH2	FIELD32(0x00000f00)
+
+/* TX_PWR_CFG_7 */
+#define TX_PWR_CFG_7			0x13d4
+#define TX_PWR_CFG_7_OFDM54_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_7_OFDM54_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_7_OFDM54_CH2		FIELD32(0x00000f00)
+#define TX_PWR_CFG_7_MCS7_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_7_MCS7_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_7_MCS7_CH2		FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_8 */
+#define TX_PWR_CFG_8			0x13d8
+#define TX_PWR_CFG_8_MCS15_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_8_MCS15_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_8_MCS15_CH2		FIELD32(0x00000f00)
+#define TX_PWR_CFG_8_MCS23_CH0		FIELD32(0x000f0000)
+#define TX_PWR_CFG_8_MCS23_CH1		FIELD32(0x00f00000)
+#define TX_PWR_CFG_8_MCS23_CH2		FIELD32(0x0f000000)
+
+/* TX_PWR_CFG_9 */
+#define TX_PWR_CFG_9			0x13dc
+#define TX_PWR_CFG_9_STBC7_CH0		FIELD32(0x0000000f)
+#define TX_PWR_CFG_9_STBC7_CH1		FIELD32(0x000000f0)
+#define TX_PWR_CFG_9_STBC7_CH2		FIELD32(0x00000f00)
+
 /*
  * RX_FILTER_CFG: RX configuration register.
  */
diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7b5c593..e817278 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3120,6 +3120,9 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 	u8 eirp_txpower_criterion;
 	u8 reg_limit;
 
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		return min_t(u8, txpower, 0xc);
+
 	if (test_bit(CAPABILITY_POWER_LIMIT, &rt2x00dev->cap_flags)) {
 		/*
 		 * Check if eirp txpower exceed txpower_limit.
@@ -3155,6 +3158,412 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
 	return min_t(u8, txpower, 0xc);
 }
 
+
+enum {
+	TX_PWR_CFG_0_IDX,
+	TX_PWR_CFG_1_IDX,
+	TX_PWR_CFG_2_IDX,
+	TX_PWR_CFG_3_IDX,
+	TX_PWR_CFG_4_IDX,
+	TX_PWR_CFG_5_IDX,
+	TX_PWR_CFG_6_IDX,
+	TX_PWR_CFG_7_IDX,
+	TX_PWR_CFG_8_IDX,
+	TX_PWR_CFG_9_IDX,
+	TX_PWR_CFG_0_EXT_IDX,
+	TX_PWR_CFG_1_EXT_IDX,
+	TX_PWR_CFG_2_EXT_IDX,
+	TX_PWR_CFG_3_EXT_IDX,
+	TX_PWR_CFG_4_EXT_IDX,
+	TX_PWR_CFG_IDX_COUNT,
+};
+
+static void rt2800_config_txpower_rt3593(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_channel *chan,
+					 int power_level)
+{
+	u8 txpower;
+	u16 eeprom;
+	u32 regs[TX_PWR_CFG_IDX_COUNT];
+	unsigned int offset;
+	enum ieee80211_band band = chan->band;
+	int delta;
+	int i;
+
+	memset(regs, '\0', sizeof(regs));
+
+	/* TODO: adapt TX power reduction from the rt28xx code */
+
+	/* calculate temperature compensation delta */
+	delta = rt2800_get_gain_calibration_delta(rt2x00dev);
+
+	if (band == IEEE80211_BAND_5GHZ)
+		offset = 16;
+	else
+		offset = 0;
+
+	if (test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
+		offset += 8;
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset, &eeprom);
+
+	/* CCK 1MBS,2MBS */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 1, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_CCK1_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_CCK1_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_EXT_IDX],
+			   TX_PWR_CFG_0_EXT_CCK1_CH2, txpower);
+
+	/* CCK 5.5MBS,11MBS */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE1);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 1, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_CCK5_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_CCK5_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_EXT_IDX],
+			   TX_PWR_CFG_0_EXT_CCK5_CH2, txpower);
+
+	/* OFDM 6MBS,9MBS */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE2);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_OFDM6_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_OFDM6_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_EXT_IDX],
+			   TX_PWR_CFG_0_EXT_OFDM6_CH2, txpower);
+
+	/* OFDM 12MBS,18MBS */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE3);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_OFDM12_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_IDX],
+			   TX_PWR_CFG_0_OFDM12_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_0_EXT_IDX],
+			   TX_PWR_CFG_0_EXT_OFDM12_CH2, txpower);
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset + 1, &eeprom);
+
+	/* OFDM 24MBS,36MBS */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_OFDM24_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_OFDM24_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_EXT_IDX],
+			   TX_PWR_CFG_1_EXT_OFDM24_CH2, txpower);
+
+	/* OFDM 48MBS */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE1);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_OFDM48_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_OFDM48_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_EXT_IDX],
+			   TX_PWR_CFG_1_EXT_OFDM48_CH2, txpower);
+
+	/* OFDM 54MBS */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE2);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_7_IDX],
+			   TX_PWR_CFG_7_OFDM54_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_7_IDX],
+			   TX_PWR_CFG_7_OFDM54_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_7_IDX],
+			   TX_PWR_CFG_7_OFDM54_CH2, txpower);
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset + 2, &eeprom);
+
+	/* MCS 0,1 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_MCS0_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_MCS0_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_EXT_IDX],
+			   TX_PWR_CFG_1_EXT_MCS0_CH2, txpower);
+
+	/* MCS 2,3 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE1);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_MCS2_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_IDX],
+			   TX_PWR_CFG_1_MCS2_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_1_EXT_IDX],
+			   TX_PWR_CFG_1_EXT_MCS2_CH2, txpower);
+
+	/* MCS 4,5 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE2);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS4_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS4_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_EXT_IDX],
+			   TX_PWR_CFG_2_EXT_MCS4_CH2, txpower);
+
+	/* MCS 6 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE3);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS6_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS6_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_EXT_IDX],
+			   TX_PWR_CFG_2_EXT_MCS6_CH2, txpower);
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset + 3, &eeprom);
+
+	/* MCS 7 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_7_IDX],
+			   TX_PWR_CFG_7_MCS7_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_7_IDX],
+			   TX_PWR_CFG_7_MCS7_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_7_IDX],
+			   TX_PWR_CFG_7_MCS7_CH2, txpower);
+
+	/* MCS 8,9 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE1);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS8_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS8_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_EXT_IDX],
+			   TX_PWR_CFG_2_EXT_MCS8_CH2, txpower);
+
+	/* MCS 10,11 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE2);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS10_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_IDX],
+			   TX_PWR_CFG_2_MCS10_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_2_EXT_IDX],
+			   TX_PWR_CFG_2_EXT_MCS10_CH2, txpower);
+
+	/* MCS 12,13 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE3);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_MCS12_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_MCS12_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_EXT_IDX],
+			   TX_PWR_CFG_3_EXT_MCS12_CH2, txpower);
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset + 4, &eeprom);
+
+	/* MCS 14 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_MCS14_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_MCS14_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_EXT_IDX],
+			   TX_PWR_CFG_3_EXT_MCS14_CH2, txpower);
+
+	/* MCS 15 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE1);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_8_IDX],
+			   TX_PWR_CFG_8_MCS15_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_8_IDX],
+			   TX_PWR_CFG_8_MCS15_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_8_IDX],
+			   TX_PWR_CFG_8_MCS15_CH2, txpower);
+
+	/* MCS 16,17 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE2);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_5_IDX],
+			   TX_PWR_CFG_5_MCS16_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_5_IDX],
+			   TX_PWR_CFG_5_MCS16_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_5_IDX],
+			   TX_PWR_CFG_5_MCS16_CH2, txpower);
+
+	/* MCS 18,19 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE3);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_5_IDX],
+			   TX_PWR_CFG_5_MCS18_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_5_IDX],
+			   TX_PWR_CFG_5_MCS18_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_5_IDX],
+			   TX_PWR_CFG_5_MCS18_CH2, txpower);
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset + 5, &eeprom);
+
+	/* MCS 20,21 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_6_IDX],
+			   TX_PWR_CFG_6_MCS20_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_6_IDX],
+			   TX_PWR_CFG_6_MCS20_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_6_IDX],
+			   TX_PWR_CFG_6_MCS20_CH2, txpower);
+
+	/* MCS 22 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE1);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_6_IDX],
+			   TX_PWR_CFG_6_MCS22_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_6_IDX],
+			   TX_PWR_CFG_6_MCS22_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_6_IDX],
+			   TX_PWR_CFG_6_MCS22_CH2, txpower);
+
+	/* MCS 23 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE2);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_8_IDX],
+			   TX_PWR_CFG_8_MCS23_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_8_IDX],
+			   TX_PWR_CFG_8_MCS23_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_8_IDX],
+			   TX_PWR_CFG_8_MCS23_CH2, txpower);
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset + 6, &eeprom);
+
+	/* STBC, MCS 0,1 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_STBC0_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_STBC0_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_EXT_IDX],
+			   TX_PWR_CFG_3_EXT_STBC0_CH2, txpower);
+
+	/* STBC, MCS 2,3 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE1);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_STBC2_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_IDX],
+			   TX_PWR_CFG_3_STBC2_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_3_EXT_IDX],
+			   TX_PWR_CFG_3_EXT_STBC2_CH2, txpower);
+
+	/* STBC, MCS 4,5 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE2);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_4_IDX], TX_PWR_CFG_RATE0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_4_IDX], TX_PWR_CFG_RATE1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_4_EXT_IDX], TX_PWR_CFG_RATE0,
+			   txpower);
+
+	/* STBC, MCS 6 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE3);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_4_IDX], TX_PWR_CFG_RATE2, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_4_IDX], TX_PWR_CFG_RATE3, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_4_EXT_IDX], TX_PWR_CFG_RATE2,
+			   txpower);
+
+	/* read the next four txpower values */
+	rt2800_eeprom_read_from_array(rt2x00dev, EEPROM_TXPOWER_BYRATE,
+				      offset + 7, &eeprom);
+
+	/* STBC, MCS 7 */
+	txpower = rt2x00_get_field16(eeprom, EEPROM_TXPOWER_BYRATE_RATE0);
+	txpower = rt2800_compensate_txpower(rt2x00dev, 0, band, power_level,
+					    txpower, delta);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_9_IDX],
+			   TX_PWR_CFG_9_STBC7_CH0, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_9_IDX],
+			   TX_PWR_CFG_9_STBC7_CH1, txpower);
+	rt2x00_set_field32(&regs[TX_PWR_CFG_9_IDX],
+			   TX_PWR_CFG_9_STBC7_CH2, txpower);
+
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_0, regs[TX_PWR_CFG_0_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_1, regs[TX_PWR_CFG_1_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_2, regs[TX_PWR_CFG_2_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_3, regs[TX_PWR_CFG_3_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_4, regs[TX_PWR_CFG_4_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_5, regs[TX_PWR_CFG_5_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_6, regs[TX_PWR_CFG_6_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_7, regs[TX_PWR_CFG_7_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_8, regs[TX_PWR_CFG_8_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_9, regs[TX_PWR_CFG_9_IDX]);
+
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_0_EXT,
+			      regs[TX_PWR_CFG_0_EXT_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_1_EXT,
+			      regs[TX_PWR_CFG_1_EXT_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_2_EXT,
+			      regs[TX_PWR_CFG_2_EXT_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_3_EXT,
+			      regs[TX_PWR_CFG_3_EXT_IDX]);
+	rt2800_register_write(rt2x00dev, TX_PWR_CFG_4_EXT,
+			      regs[TX_PWR_CFG_4_EXT_IDX]);
+
+	for (i = 0; i < TX_PWR_CFG_IDX_COUNT; i++)
+		rt2x00_dbg(rt2x00dev,
+			   "band:%cGHz, BW:%c0MHz, TX_PWR_CFG_%d%s = %08lx\n",
+			   (band == IEEE80211_BAND_5GHZ) ? '5' : '2',
+			   (test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags)) ?
+								'4' : '2',
+			   (i > TX_PWR_CFG_9_IDX) ?
+					(i - TX_PWR_CFG_9_IDX - 1) : i,
+			   (i > TX_PWR_CFG_9_IDX) ? "_EXT" : "",
+			   (unsigned long) regs[i]);
+}
+
 /*
  * We configure transmit power using MAC TX_PWR_CFG_{0,...,N} registers and
  * BBP R1 register. TX_PWR_CFG_X allow to configure per rate TX power values,
@@ -3164,9 +3573,9 @@ static u8 rt2800_compensate_txpower(struct rt2x00_dev *rt2x00dev, int is_rate_b,
  * EEPROM_TXPOWER_BYRATE offset. We adjust them and BBP R1 settings according to
  * current conditions (i.e. band, bandwidth, temperature, user settings).
  */
-static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
-				  struct ieee80211_channel *chan,
-				  int power_level)
+static void rt2800_config_txpower_rt28xx(struct rt2x00_dev *rt2x00dev,
+					 struct ieee80211_channel *chan,
+					 int power_level)
 {
 	u8 txpower, r1;
 	u16 eeprom;
@@ -3338,6 +3747,16 @@ static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
 	}
 }
 
+static void rt2800_config_txpower(struct rt2x00_dev *rt2x00dev,
+				  struct ieee80211_channel *chan,
+				  int power_level)
+{
+	if (rt2x00_rt(rt2x00dev, RT3593))
+		rt2800_config_txpower_rt3593(rt2x00dev, chan, power_level);
+	else
+		rt2800_config_txpower_rt28xx(rt2x00dev, chan, power_level);
+}
+
 void rt2800_gain_calibration(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_config_txpower(rt2x00dev, rt2x00dev->hw->conf.chandef.chan,
-- 
1.7.10

