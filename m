Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:2403 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751067Ab0DKMbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 08:31:25 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 6/9] rt2x00: Finish rt3070 support in rt2800 register initialization.
Date: Sun, 11 Apr 2010 14:31:12 +0200
Message-Id: <1270989075-2267-7-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

rt2x00 had preliminary support for RT3070 based devices, but the support was
incomplete.
Update the RT3070 register initialization to be similar to the latest Ralink
vendor driver.

With this patch my rt3070 based devices start showing a sign of life.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  133 ++++++++++++++++--------------
 1 files changed, 71 insertions(+), 62 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1890b9a..7d1cb7e 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1042,8 +1042,7 @@ EXPORT_SYMBOL_GPL(rt2800_link_stats);
 static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
-		if (rt2x00_is_usb(rt2x00dev) &&
-		    rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E))
+		if (rt2x00_rt(rt2x00dev, RT3070))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1191,11 +1190,16 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
-	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E)) {
+	if (rt2x00_rt(rt2x00dev, RT3070)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
-		rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
+			rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+			rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x0000002c);
+		} else {
+			rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
+			rt2800_register_write(rt2x00dev, TX_SW_CFG2, 0x00000000);
+		}
 	} else {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000000);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00080606);
@@ -1535,7 +1539,15 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	}
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-	rt2800_bbp_write(rt2x00dev, 81, 0x37);
+
+	if (rt2x00_rt(rt2x00dev, RT3070)) {
+		rt2800_bbp_write(rt2x00dev, 79, 0x13);
+		rt2800_bbp_write(rt2x00dev, 80, 0x05);
+		rt2800_bbp_write(rt2x00dev, 81, 0x33);
+	} else {
+		rt2800_bbp_write(rt2x00dev, 81, 0x37);
+	}
+
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 
@@ -1548,7 +1560,12 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 86, 0x00);
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
-	rt2800_bbp_write(rt2x00dev, 103, 0x00);
+
+	if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F))
+		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
+	else
+		rt2800_bbp_write(rt2x00dev, 103, 0x00);
+
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
@@ -1558,13 +1575,6 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 80, 0x08);
 	}
 
-	if (rt2x00_is_usb(rt2x00dev) &&
-	    rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E)) {
-		rt2800_bbp_write(rt2x00dev, 70, 0x0a);
-		rt2800_bbp_write(rt2x00dev, 84, 0x99);
-		rt2800_bbp_write(rt2x00dev, 105, 0x05);
-	}
-
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
@@ -1643,18 +1653,12 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 {
 	u8 rfcsr;
 	u8 bbp;
+	u32 reg;
+	u16 eeprom;
 
-	if (rt2x00_is_usb(rt2x00dev) &&
-	    !rt2x00_rt_rev(rt2x00dev, RT3070, REV_RT3070E))
+	if (!rt2x00_rt(rt2x00dev, RT3070))
 		return 0;
 
-	if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
-		if (!rt2x00_rf(rt2x00dev, RF3020) &&
-		    !rt2x00_rf(rt2x00dev, RF3021) &&
-		    !rt2x00_rf(rt2x00dev, RF3022))
-			return 0;
-	}
-
 	/*
 	 * Init RF calibration.
 	 */
@@ -1665,13 +1669,13 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
-	if (rt2x00_is_usb(rt2x00dev)) {
+	if (rt2x00_rt(rt2x00dev, RT3070)) {
 		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
 		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
 		rt2800_rfcsr_write(rt2x00dev, 7, 0x70);
 		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x71);
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x41);
 		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
 		rt2800_rfcsr_write(rt2x00dev, 12, 0x7b);
 		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
@@ -1684,48 +1688,25 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
 		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
 		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
-	} else if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) {
-		rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
-		rt2800_rfcsr_write(rt2x00dev, 1, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 2, 0xf7);
-		rt2800_rfcsr_write(rt2x00dev, 3, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
-		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
-		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 7, 0x50);
-		rt2800_rfcsr_write(rt2x00dev, 8, 0x39);
-		rt2800_rfcsr_write(rt2x00dev, 9, 0x0f);
-		rt2800_rfcsr_write(rt2x00dev, 10, 0x60);
-		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
-		rt2800_rfcsr_write(rt2x00dev, 12, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 13, 0x75);
-		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
-		rt2800_rfcsr_write(rt2x00dev, 15, 0x58);
-		rt2800_rfcsr_write(rt2x00dev, 16, 0xb3);
-		rt2800_rfcsr_write(rt2x00dev, 17, 0x92);
-		rt2800_rfcsr_write(rt2x00dev, 18, 0x2c);
-		rt2800_rfcsr_write(rt2x00dev, 19, 0x02);
-		rt2800_rfcsr_write(rt2x00dev, 20, 0xba);
-		rt2800_rfcsr_write(rt2x00dev, 21, 0xdb);
-		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
-		rt2800_rfcsr_write(rt2x00dev, 23, 0x31);
-		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
-		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
-		rt2800_rfcsr_write(rt2x00dev, 26, 0x25);
-		rt2800_rfcsr_write(rt2x00dev, 27, 0x23);
-		rt2800_rfcsr_write(rt2x00dev, 28, 0x13);
-		rt2800_rfcsr_write(rt2x00dev, 29, 0x83);
+	}
+
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
+		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
+		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
+		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 	}
 
 	/*
 	 * Set RX Filter calibration for 20MHz and 40MHz
 	 */
-	rt2x00dev->calibration[0] =
-	    rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
-	rt2x00dev->calibration[1] =
-	    rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
+	if (rt2x00_rt(rt2x00dev, RT3070)) {
+		rt2x00dev->calibration[0] =
+			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
+		rt2x00dev->calibration[1] =
+			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
+	}
 
 	/*
 	 * Set back to initial state
@@ -1743,6 +1724,34 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F))
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+
+	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
+	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
+	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_TXMIXER_GAIN_BG, &eeprom);
+	if (rt2x00_get_field16(eeprom, EEPROM_TXMIXER_GAIN_BG_VAL) >= 1)
+		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+				  rt2x00_get_field16(eeprom,
+						   EEPROM_TXMIXER_GAIN_BG_VAL));
+	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+	if (rt2x00_rt(rt2x00dev, RT3070)) {
+		rt2800_rfcsr_read(rt2x00dev, 27, &rfcsr);
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F))
+			rt2x00_set_field8(&rfcsr, RFCSR27_R1, 3);
+		else
+			rt2x00_set_field8(&rfcsr, RFCSR27_R1, 0);
+		rt2x00_set_field8(&rfcsr, RFCSR27_R2, 0);
+		rt2x00_set_field8(&rfcsr, RFCSR27_R3, 0);
+		rt2x00_set_field8(&rfcsr, RFCSR27_R4, 0);
+		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
+	}
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(rt2800_init_rfcsr);
-- 
1.7.0.4

