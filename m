Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:3366 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933097Ab0DHVuq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:50:46 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville <linville"@tuxdriver.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 8/9] rt2x00: Add rt3090 support in rt2800 register initialization.
Date: Thu,  8 Apr 2010 23:50:36 +0200
Message-Id: <1270763437-29526-9-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add RT3090 specific register initializations to rt2x00, based on the latest
Ralink rt3090 vendor driver.

Untested as I don't actually own an RT3090 based device, but given experiences
on rt3070/rt3071 very hopeful that this will actually work..

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   54 ++++++++++++++++++++++--------
 1 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 209fd85..00f058a 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1037,7 +1037,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 {
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
-		    rt2x00_rt(rt2x00dev, RT3071))
+		    rt2x00_rt(rt2x00dev, RT3071) ||
+		    rt2x00_rt(rt2x00dev, RT3090))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1204,7 +1205,8 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, BKOFF_SLOT_CFG_CC_DELAY_TIME, 2);
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
-	if (rt2x00_rt(rt2x00dev, RT3071)) {
+	if (rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		if (rt2x00_rev(rt2x00dev) < 0x0211) {
@@ -1558,9 +1560,9 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 		     rt2800_wait_bbp_ready(rt2x00dev)))
 		return -EACCES;
 
-	if ((rt2x00_rt(rt2x00dev, RT3070) ||
-	     rt2x00_rt(rt2x00dev, RT3071)) &&
-	    rt2x00_rev(rt2x00dev) >= 0x0211) {
+	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) >= 0x0211)) {
 		rt2800_bbp_read(rt2x00dev, 31, &value);
 		value &= ~0x03;
 		rt2800_bbp_write(rt2x00dev, 31, value);
@@ -1580,7 +1582,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 70, 0x0a);
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt(rt2x00dev, RT3071)) {
+	    rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_bbp_write(rt2x00dev, 79, 0x13);
 		rt2800_bbp_write(rt2x00dev, 80, 0x05);
 		rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -1593,6 +1596,7 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
+	    !rt2x00_rt(rt2x00dev, RT3090) &&
 	    rt2x00_rev(rt2x00dev) == 0x101)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	else
@@ -1603,7 +1607,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 92, 0x00);
 
 	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) >= 0x0201) ||
-	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) >= 0x0211))
+	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) >= 0x0211))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
@@ -1611,7 +1616,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 105, 0x05);
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
-	if (rt2x00_rt(rt2x00dev, RT3071)) {
+	if (rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_bbp_read(rt2x00dev, 138, &value);
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
@@ -1705,7 +1711,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	u16 eeprom;
 
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
-	    !rt2x00_rt(rt2x00dev, RT3071))
+	    !rt2x00_rt(rt2x00dev, RT3071) &&
+	    !rt2x00_rt(rt2x00dev, RT3090))
 		return 0;
 
 	/*
@@ -1719,7 +1726,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
-	    rt2x00_rt(rt2x00dev, RT3071)) {
+	    rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
 		rt2800_rfcsr_write(rt2x00dev, 5, 0x03);
 		rt2800_rfcsr_write(rt2x00dev, 6, 0x02);
@@ -1746,7 +1754,7 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 		rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 3);
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
-	} else if (rt2x00_rt(rt2x00dev, RT3071)) {
+	} else if (rt2x00_rt(rt2x00dev, RT3071) || rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2800_rfcsr_read(rt2x00dev, 6, &rfcsr);
 		rt2x00_set_field8(&rfcsr, RFCSR6_R2, 1);
 		rt2800_rfcsr_write(rt2x00dev, 6, rfcsr);
@@ -1773,7 +1781,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
 		rt2x00dev->calibration[1] =
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
-	} else if (rt2x00_rt(rt2x00dev, RT3071)) {
+	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
+		   rt2x00_rt(rt2x00dev, RT3090)) {
 		rt2x00dev->calibration[0] =
 			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x13);
 		rt2x00dev->calibration[1] =
@@ -1797,7 +1806,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 
 	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201) ||
-	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211))
+	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) < 0x0211))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
@@ -1806,7 +1816,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR17_R2, 0);
-	if (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211) {
+	if ((rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) < 0x0211)) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 		if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
 			rt2x00_set_field8(&rfcsr, RFCSR17_R3, 1);
@@ -1816,7 +1827,20 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field8(&rfcsr, RFCSR17_R1, eeprom & 0x07);
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
 		rfcsr &= ~0x0c;
 		rfcsr |= 0x31;
-- 
1.7.0.4

