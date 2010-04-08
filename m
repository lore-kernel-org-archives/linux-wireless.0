Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3435 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933318Ab0DHVut (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:50:49 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville <linville"@tuxdriver.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 7/9] rt2x00: Add rt3071 support in rt2800 register initialization.
Date: Thu,  8 Apr 2010 23:50:35 +0200
Message-Id: <1270763437-29526-8-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add RT3071 specific register initializations to rt2x00, based on the latest
Ralink rt3070 vendor driver.

With this patch my RT3071 based devices start showing a sign of life.

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  105 +++++++++++++++++++++++++++---
 1 files changed, 94 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 52e2422..209fd85 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1036,7 +1036,8 @@ EXPORT_SYMBOL_GPL(rt2800_link_stats);
 static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
-		if (rt2x00_rt(rt2x00dev, RT3070))
+		if (rt2x00_rt(rt2x00dev, RT3070) ||
+		    rt2x00_rt(rt2x00dev, RT3071))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1085,6 +1086,7 @@ EXPORT_SYMBOL_GPL(rt2800_link_tuner);
 int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 {
 	u32 reg, reg2;
+	u16 eeprom;
 	unsigned int i;
 
 	rt2800_register_read(rt2x00dev, WPDMA_GLO_CFG, &reg);
@@ -1202,7 +1204,20 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
-	if (rt2x00_rt(rt2x00dev, RT3070)) {
+	if (rt2x00_rt(rt2x00dev, RT3071)) {
+		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
+		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
+		if (rt2x00_rev(rt2x00dev) < 0x0211) {
+			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
+			if (rt2x00_get_field16(eeprom, EEPROM_NIC_DAC_TEST))
+				reg = 0x0000002c;
+			else
+				reg = 0x0000000f;
+		} else {
+			reg = 0x00000000;
+		}
+		rt2800_register_write(rt2x00dev, TX_SW_CFG2, reg);
+	} else if (rt2x00_rt(rt2x00dev, RT3070)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 
 		if (rt2x00_rev(rt2x00dev) < 0x0201) {
@@ -1543,7 +1558,9 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
-	if (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) >= 0x0211) {
+	if ((rt2x00_rt(rt2x00dev, RT3070) ||
+	     rt2x00_rt(rt2x00dev, RT3071)) &&
+	    rt2x00_rev(rt2x00dev) >= 0x0211) {
 		rt2800_bbp_read(rt2x00dev, 31, &value);
 		value &= ~0x03;
 		rt2800_bbp_write(rt2x00dev, 31, value);
@@ -1562,7 +1579,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 
-	if (rt2x00_rt(rt2x00dev, RT3070)) {
+	if (rt2x00_rt(rt2x00dev, RT3070) ||
+	    rt2x00_rt(rt2x00dev, RT3071)) {
 		rt2800_bbp_write(rt2x00dev, 79, 0x13);
 		rt2800_bbp_write(rt2x00dev, 80, 0x05);
 		rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -1573,7 +1591,9 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 82, 0x62);
 	rt2800_bbp_write(rt2x00dev, 83, 0x6a);
 
-	if (!rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) == 0x101)
+	if (!rt2x00_rt(rt2x00dev, RT3070) &&
+	    !rt2x00_rt(rt2x00dev, RT3071) &&
+	    rt2x00_rev(rt2x00dev) == 0x101)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	else
 		rt2800_bbp_write(rt2x00dev, 84, 0x99);
@@ -1582,7 +1602,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 91, 0x04);
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
-	if (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) >= 0x0201)
+	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) >= 0x0201) ||
+	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) >= 0x0211))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
@@ -1590,6 +1611,18 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
+	if (rt2x00_rt(rt2x00dev, RT3071)) {
+		rt2800_bbp_read(rt2x00dev, 138, &value);
+
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
+		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) == 1)
+			value |= 0x20;
+		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH) == 1)
+			value &= ~0x02;
+
+		rt2800_bbp_write(rt2x00dev, 138, value);
+	}
+
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_BBP_START + i, &eeprom);
 
@@ -1671,7 +1704,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u32 reg;
 	u16 eeprom;
 
-	if (!rt2x00_rt(rt2x00dev, RT3070))
+	if (!rt2x00_rt(rt2x00dev, RT3070) &&
+	    !rt2x00_rt(rt2x00dev, RT3071))
 		return 0;
 
 	/*
@@ -1684,7 +1718,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field8(&rfcsr, RFCSR30_RF_CALIBRATION, 0);
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
-	if (rt2x00_rt(rt2x00dev, RT3070)) {
+	if (rt2x00_rt(rt2x00dev, RT3070) ||
+	    rt2x00_rt(rt2x00dev, RT3071)) {
 		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
 		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
@@ -1711,6 +1746,23 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+	} else if (rt2x00_rt(rt2x00dev, RT3071)) {
+		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
+		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
+
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x14);
+
+		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
+		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
+		if (rt2x00_rev(rt2x00dev) < 0x211) {
+			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
+			if (rt2x00_get_field16(eeprom, EEPROM_NIC_DAC_TEST))
+				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
+			else
+				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
+		}
+		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 	}
 
 	/*
@@ -1721,6 +1773,11 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
 		rt2x00dev->calibration[1] =
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
+	} else if (rt2x00_rt(rt2x00dev, RT3071)) {
+		rt2x00dev->calibration[0] =
+			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x13);
+		rt2x00dev->calibration[1] =
+			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
 	}
 
 	/*
@@ -1739,7 +1796,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
-	if (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201)
+	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201) ||
+	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
@@ -1748,15 +1806,40 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR17_R2, 0);
+	if (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211) {
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
+			rt2x00_set_field8(&rfcsr, RFCSR17_R3, 1);
+	}
 	rt2x00_eeprom_read(rt2x00dev, EEPROM_RSSI_BG2, &eeprom);
 	if ((eeprom & 0x07) >= 1)
 		rt2x00_set_field8(&rfcsr, RFCSR17_R1, eeprom & 0x07);
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 
-	if (rt2x00_rt(rt2x00dev, RT3070)) {
+	if (rt2x00_rt(rt2x00dev, RT3071)) {
+		rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+		rfcsr &= ~0x0c;
+		rfcsr |= 0x31;
+		rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+		rt2800_rfcsr_read(rt2x00dev, 15, &rfcsr);
+		rfcsr &= ~0x08;
+		rt2800_rfcsr_write(rt2x00dev, 15, rfcsr);
+
+		rt2800_rfcsr_read(rt2x00dev, 20, &rfcsr);
+		rfcsr &= ~0x08;
+		rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
+
+		rt2800_rfcsr_read(rt2x00dev, 21, &rfcsr);
+		rfcsr &= ~0x08;
+		rt2800_rfcsr_write(rt2x00dev, 21, rfcsr);
+	}
+
+	if (rt2x00_rt(rt2x00dev, RT3070) || rt2x00_rt(rt2x00dev, RT3071)) {
 		rt2800_rfcsr_read(rt2x00dev, 27, &rfcsr);
 		rfcsr &= 0x77;
-		if (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201)
+		if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201) ||
+		    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211))
 			rfcsr |= 0x03;
 		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
 	}
-- 
1.7.0.4

