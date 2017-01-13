Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fudo.makrotopia.org ([185.142.180.71]:45773 "EHLO
        fudo.makrotopia.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750908AbdAMVdw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 16:33:52 -0500
Date: Fri, 13 Jan 2017 22:33:44 +0100
From: Daniel Golle <daniel@makrotopia.org>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Stanislaw Gruszka <sgruszka@redhat.com>, roman@advem.lv,
        michel.stempin@wanadoo.fr, c.mignanti@gmail.com, evaxige@qq.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 38/40] rt2x00: add support for RT5350 WiSoC
Message-ID: <20170113213339.GA3662@makrotopia.org> (sfid-20170113_223355_719148_2A9CE1A7)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Michel Stempin <michel.stempin@wanadoo.fr>

Support for the RT5350 WiSoC was added to OpenWrt after having a
lengthy debate about the legality of the original submission, see
https://lists.openwrt.org/pipermail/openwrt-devel/2013-January/018224.html
MTK/Ralink Acked replied and says we can merge this patch under the GPL.
https://dev.openwrt.org/changeset/36177

Signed-off-by: Serge Vasilugin <vasilugin@yandex.ru>
Tested-by: Michel Stempin <michel.stempin@wanadoo.fr>
Acked-by: John Crispin <blogic@openwrt.org>
[daniel@makrotopia.org: added commit message, fixed code formatting]
---
 drivers/net/wireless/ralink/rt2x00/rt2800.h    |   1 +
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c | 131 +++++++++++++++++++++++--
 drivers/net/wireless/ralink/rt2x00/rt2x00.h    |   1 +
 3 files changed, 126 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800.h b/drivers/net/wireless/ralink/rt2x00/rt2800.h
index 14c94034a707..f49babf2fbee 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800.h
@@ -74,6 +74,7 @@
 #define RF3070				0x3070
 #define RF3290				0x3290
 #define RF3853				0x3853
+#define RF5350				0x5350
 #define RF5360				0x5360
 #define RF5362				0x5362
 #define RF5370				0x5370
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index 6a24892476c3..5f49117b9035 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -3050,6 +3050,13 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 
 				rt2800_rfcsr_write(rt2x00dev, 59,
 						   r59_non_bt[idx]);
+			} else if (rt2x00_rt(rt2x00dev, RT5350)) {
+				static const char r59_non_bt[] = {0x0b, 0x0b,
+					0x0b, 0x0b, 0x0b, 0x0b, 0x0b, 0x0a,
+					0x0a, 0x09, 0x08, 0x07, 0x07, 0x06};
+
+				rt2800_rfcsr_write(rt2x00dev, 59,
+						   r59_non_bt[idx]);
 			}
 		}
 	}
@@ -3528,6 +3535,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 		rt2800_config_channel_rf3853(rt2x00dev, conf, rf, info);
 		break;
 	case RF3070:
+	case RF5350:
 	case RF5360:
 	case RF5362:
 	case RF5370:
@@ -3546,6 +3554,7 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_rf(rt2x00dev, RF3070) ||
 	    rt2x00_rf(rt2x00dev, RF3290) ||
 	    rt2x00_rf(rt2x00dev, RF3322) ||
+	    rt2x00_rf(rt2x00dev, RF5350) ||
 	    rt2x00_rf(rt2x00dev, RF5360) ||
 	    rt2x00_rf(rt2x00dev, RF5362) ||
 	    rt2x00_rf(rt2x00dev, RF5370) ||
@@ -3824,7 +3833,8 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	/*
 	 * Clear update flag
 	 */
-	if (rt2x00_rt(rt2x00dev, RT3352)) {
+	if (rt2x00_rt(rt2x00dev, RT3352) ||
+	    rt2x00_rt(rt2x00dev, RT5350)) {
 		rt2800_bbp_read(rt2x00dev, 49, &bbp);
 		rt2x00_set_field8(&bbp, BBP49_UPDATE_FLAG, 0);
 		rt2800_bbp_write(rt2x00dev, 49, bbp);
@@ -4710,6 +4720,7 @@ void rt2800_vco_calibration(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF3853:
+	case RF5350:
 	case RF5360:
 	case RF5362:
 	case RF5370:
@@ -5129,6 +5140,8 @@ static int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000404);
 	} else {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
@@ -5788,9 +5801,13 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 
-	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
-
-	rt2800_bbp_write(rt2x00dev, 84, 0x99);
+	if (rt2x00_rt(rt2x00dev, RT5350)) {
+		rt2800_bbp_write(rt2x00dev, 83, 0x7a);
+		rt2800_bbp_write(rt2x00dev, 84, 0x9a);
+	} else {
+		rt2800_bbp_write(rt2x00dev, 83, 0x6a);
+		rt2800_bbp_write(rt2x00dev, 84, 0x99);
+	}
 
 	rt2800_bbp_write(rt2x00dev, 86, 0x38);
 
@@ -5804,9 +5821,13 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 104, 0x92);
 
-	rt2800_bbp_write(rt2x00dev, 105, 0x34);
-
-	rt2800_bbp_write(rt2x00dev, 106, 0x05);
+	if (rt2x00_rt(rt2x00dev, RT5350)) {
+		rt2800_bbp_write(rt2x00dev, 105, 0x3c);
+		rt2800_bbp_write(rt2x00dev, 106, 0x03);
+	} else {
+		rt2800_bbp_write(rt2x00dev, 105, 0x34);
+		rt2800_bbp_write(rt2x00dev, 106, 0x05);
+	}
 
 	rt2800_bbp_write(rt2x00dev, 120, 0x50);
 
@@ -5831,6 +5852,16 @@ static void rt2800_init_bbp_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 143, 0xa2);
 
 	rt2800_bbp_write(rt2x00dev, 148, 0xc8);
+
+	if (rt2x00_rt(rt2x00dev, RT5350)) {
+		/* Antenna Software OFDM */
+		rt2800_bbp_write(rt2x00dev, 150, 0x40);
+		/* Antenna Software CCK */
+		rt2800_bbp_write(rt2x00dev, 151, 0x30);
+		rt2800_bbp_write(rt2x00dev, 152, 0xa3);
+		/* Clear previously selected antenna */
+		rt2800_bbp_write(rt2x00dev, 154, 0);
+	}
 }
 
 static void rt2800_init_bbp_3390(struct rt2x00_dev *rt2x00dev)
@@ -6172,6 +6203,7 @@ static void rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_init_bbp_3290(rt2x00dev);
 		break;
 	case RT3352:
+	case RT5350:
 		rt2800_init_bbp_3352(rt2x00dev);
 		break;
 	case RT3390:
@@ -7123,6 +7155,76 @@ static void rt2800_init_rfcsr_3883(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
 }
 
+static void rt2800_init_rfcsr_5350(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 0, 0xf0);
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x23);
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x50);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 4, 0x49);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0xe0);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 8, 0xf1);
+	rt2800_rfcsr_write(rt2x00dev, 9, 0x02);
+	rt2800_rfcsr_write(rt2x00dev, 10, 0x53);
+	rt2800_rfcsr_write(rt2x00dev, 11, 0x4a);
+	rt2800_rfcsr_write(rt2x00dev, 12, 0x46);
+	if (rt2x00dev->spec.clk_is_20mhz)
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x1f);
+	else
+		rt2800_rfcsr_write(rt2x00dev, 13, 0x9f);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0xc0);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 22, 0x20);
+	rt2800_rfcsr_write(rt2x00dev, 23, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 24, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 25, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0xd0);
+	rt2800_rfcsr_write(rt2x00dev, 30, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 31, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 32, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 36, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 37, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 38, 0x85);
+	rt2800_rfcsr_write(rt2x00dev, 39, 0x1b);
+	rt2800_rfcsr_write(rt2x00dev, 40, 0x0b);
+	rt2800_rfcsr_write(rt2x00dev, 41, 0xbb);
+	rt2800_rfcsr_write(rt2x00dev, 42, 0xd5);
+	rt2800_rfcsr_write(rt2x00dev, 43, 0x9b);
+	rt2800_rfcsr_write(rt2x00dev, 44, 0x0c);
+	rt2800_rfcsr_write(rt2x00dev, 45, 0xa6);
+	rt2800_rfcsr_write(rt2x00dev, 46, 0x73);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 48, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 49, 0x80);
+	rt2800_rfcsr_write(rt2x00dev, 50, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 51, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 52, 0x38);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 54, 0x38);
+	rt2800_rfcsr_write(rt2x00dev, 55, 0x43);
+	rt2800_rfcsr_write(rt2x00dev, 56, 0x82);
+	rt2800_rfcsr_write(rt2x00dev, 57, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 58, 0x39);
+	rt2800_rfcsr_write(rt2x00dev, 59, 0x0b);
+	rt2800_rfcsr_write(rt2x00dev, 60, 0x45);
+	rt2800_rfcsr_write(rt2x00dev, 61, 0xd1);
+	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
+}
+
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_rf_init_calibration(rt2x00dev, 2);
@@ -7363,6 +7465,9 @@ static void rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	case RT3593:
 		rt2800_init_rfcsr_3593(rt2x00dev);
 		break;
+	case RT5350:
+		rt2800_init_rfcsr_5350(rt2x00dev);
+		break;
 	case RT5390:
 		rt2800_init_rfcsr_5390(rt2x00dev);
 		break;
@@ -7618,6 +7723,12 @@ static int rt2800_validate_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF2820);
 		rt2800_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
 		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
+	} else if (rt2x00_rt(rt2x00dev, RT5350)) {
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RXPATH, 1);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_TXPATH, 1);
+		rt2x00_set_field16(&word, EEPROM_NIC_CONF0_RF_TYPE, RF3320);
+		rt2x00_eeprom_write(rt2x00dev, EEPROM_NIC_CONF0, word);
+		rt2x00_eeprom_dbg(rt2x00dev, "Antenna: 0x%04x\n", word);
 	} else if (rt2x00_rt(rt2x00dev, RT2860) ||
 		   rt2x00_rt(rt2x00dev, RT2872)) {
 		/*
@@ -7756,6 +7867,8 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 		rt2800_eeprom_read(rt2x00dev, EEPROM_CHIP_ID, &rf);
 	else if (rt2x00_rt(rt2x00dev, RT3883))
 		rf = RF3853;
+	else if (rt2x00_rt(rt2x00dev, RT5350))
+		rf = RF5350;
 	else
 		rf = rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RF_TYPE);
 
@@ -7775,6 +7888,7 @@ static int rt2800_init_eeprom(struct rt2x00_dev *rt2x00dev)
 	case RF3320:
 	case RF3322:
 	case RF3853:
+	case RF5350:
 	case RF5360:
 	case RF5362:
 	case RF5370:
@@ -8331,6 +8445,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3290:
 	case RF3320:
 	case RF3322:
+	case RF5350:
 	case RF5360:
 	case RF5362:
 	case RF5370:
@@ -8473,6 +8588,7 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
 	case RF3070:
 	case RF3290:
 	case RF3853:
+	case RF5350:
 	case RF5360:
 	case RF5362:
 	case RF5370:
@@ -8514,6 +8630,7 @@ static int rt2800_probe_rt(struct rt2x00_dev *rt2x00dev)
 	case RT3572:
 	case RT3593:
 	case RT3883:
+	case RT5350:
 	case RT5390:
 	case RT5392:
 	case RT5592:
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00.h b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
index b1eec49b0dac..3c447eca4ea2 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00.h
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00.h
@@ -169,6 +169,7 @@ struct rt2x00_chip {
 #define RT3572		0x3572
 #define RT3593		0x3593
 #define RT3883		0x3883	/* WSOC */
+#define RT5350		0x5350  /* WSOC 2.4GHz */
 #define RT5390		0x5390  /* 2.4GHz */
 #define RT5392		0x5392  /* 2.4GHz */
 #define RT5592		0x5592
-- 
2.11.0
