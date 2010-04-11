Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:1762 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407Ab0DKMb0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 11 Apr 2010 08:31:26 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 8/9] rt2x00: Add rt3090 support in rt2800 register initialization.
Date: Sun, 11 Apr 2010 14:31:14 +0200
Message-Id: <1270989075-2267-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
References: <1270989075-2267-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add RT3090 specific register initializations to rt2x00, based on the latest
Ralink rt3090 vendor driver.

Untested as I don't actually own an RT3090 based device, but given experiences
on rt3070/rt3071 very hopeful that this will actually work..

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   54 +++++++++++++++++++++++--------
 1 files changed, 40 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index fe7171f..d746082 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1043,7 +1043,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
-		    rt2x00_rt(rt2x00dev, RT3071))
+		    rt2x00_rt(rt2x00dev, RT3071) ||
+		    rt2x00_rt(rt2x00dev, RT3090))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1192,10 +1193,12 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
-	if (rt2x00_rt(rt2x00dev, RT3071)) {
+	if (rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
-		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E)) {
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
 			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 			if (rt2x00_get_field16(eeprom, EEPROM_NIC_DAC_TEST))
 				rt2800_register_write(rt2x00dev, TX_SW_CFG2,
@@ -1558,7 +1561,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt(rt2x00dev, RT3071)) {
+	    rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_bbp_write(rt2x00dev, 79, 0x13);
 		rt2800_bbp_write(rt2x00dev, 80, 0x05);
 		rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -1580,7 +1584,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT3070, REV_RT3070F) ||
-	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E))
+	    rt2x00_rt_rev_gte(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_gte(rt2x00dev, RT3090, REV_RT3090E))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
@@ -1588,7 +1593,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
-	if (rt2x00_rt(rt2x00dev, RT3071)) {
+	if (rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_bbp_read(rt2x00dev, 138, &value);
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
@@ -1688,7 +1694,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u16 eeprom;
 
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
-	    !rt2x00_rt(rt2x00dev, RT3071))
+	    !rt2x00_rt(rt2x00dev, RT3071) &&
+	    !rt2x00_rt(rt2x00dev, RT3090))
 		return 0;
 
 	/*
@@ -1702,7 +1709,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt(rt2x00dev, RT3071)) {
+	    rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
 		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
@@ -1729,7 +1737,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
-	} else if (rt2x00_rt(rt2x00dev, RT3071)) {
+	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
+		   rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
 		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
@@ -1738,7 +1747,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 		rt2800_register_read(rt2x00dev, LDO_CFG0, &reg);
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
-		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E)) {
+		if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
 			rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 			if (rt2x00_get_field16(eeprom, EEPROM_NIC_DAC_TEST))
 				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
@@ -1756,7 +1766,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
 		rt2x00dev->calibration[1] =
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
-	} else if (rt2x00_rt(rt2x00dev, RT3071)) {
+	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
+		   rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2x00dev->calibration[0] =
 			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x13);
 		rt2x00dev->calibration[1] =
@@ -1780,7 +1791,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
-	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E))
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
@@ -1789,7 +1801,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
-	if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E)) {
+	if (rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E)) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 		if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
 			rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
@@ -1801,7 +1814,20 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 						   EEPROM_TXMIXER_GAIN_BG_VAL));
 	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 
-	if (rt2x00_rt(rt2x00dev, RT3071)) {
+	if (rt2x00_rt(rt2x00dev, RT3090)) {
+		rt2800_bbp_read(rt2x00dev, 138, &bbp);
+
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
+		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_RXPATH) == 1)
+			rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
+		if (rt2x00_get_field16(eeprom, EEPROM_ANTENNA_TXPATH) == 1)
+			rt2x00_set_field8(&bbp, BBP138_TX_DAC1, 1);
+
+		rt2800_bbp_write(rt2x00dev, 138, bbp);
+	}
+
+	if (rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
 		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
-- 
1.7.0.4

