Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:2366 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933316Ab0DHVus (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 17:50:48 -0400
From: Gertjan van Wingerde <gwingerde@gmail.com>
To: "John W. Linville <linville"@tuxdriver.com
Cc: Ivo van Doorn <IvDoorn@gmail.com>,
	<linux-wireless@vger.kernel.org>, <users@rt2x00.serialmonkey.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>
Subject: [PATCH 9/9] rt2x00: Add rt3390 support in rt2800 register initialization.
Date: Thu,  8 Apr 2010 23:50:37 +0200
Message-Id: <1270763437-29526-10-git-send-email-gwingerde@gmail.com>
In-Reply-To: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
References: <1270763437-29526-1-git-send-email-gwingerde@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add RT3390 specific register initializations to rt2x00, based on the latest
Ralink rt3390 vendor driver.

Untested as I don't actually own an RT3390 based device, but given experiences
on rt3070/rt3071 very hopeful that this will actually work..

Signed-off-by: Gertjan van Wingerde <gwingerde@gmail.com>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   71 ++++++++++++++++++++++++++-----
 1 files changed, 60 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 00f058a..59542af 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1038,7 +1038,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 	if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ) {
 		if (rt2x00_rt(rt2x00dev, RT3070) ||
 		    rt2x00_rt(rt2x00dev, RT3071) ||
-		    rt2x00_rt(rt2x00dev, RT3090))
+		    rt2x00_rt(rt2x00dev, RT3090) ||
+		    rt2x00_rt(rt2x00dev, RT3390))
 			return 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			return 0x2e + rt2x00dev->lna_gain;
@@ -1206,7 +1207,8 @@ int rt2800_init_registers(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, BKOFF_SLOT_CFG, reg);
 
 	if (rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090)) {
+	    rt2x00_rt(rt2x00dev, RT3090) ||
+	    rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_register_write(rt2x00dev, TX_SW_CFG0, 0x00000400);
 		rt2800_register_write(rt2x00dev, TX_SW_CFG1, 0x00000000);
 		if (rt2x00_rev(rt2x00dev) < 0x0211) {
@@ -1562,7 +1564,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
 	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
-	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) >= 0x0211)) {
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3390) && rt2x00_rev(rt2x00dev) >= 0x0211)) {
 		rt2800_bbp_read(rt2x00dev, 31, &value);
 		value &= ~0x03;
 		rt2800_bbp_write(rt2x00dev, 31, value);
@@ -1583,7 +1586,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt(rt2x00dev, RT3070) ||
 	    rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090)) {
+	    rt2x00_rt(rt2x00dev, RT3090) ||
+	    rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_bbp_write(rt2x00dev, 79, 0x13);
 		rt2800_bbp_write(rt2x00dev, 80, 0x05);
 		rt2800_bbp_write(rt2x00dev, 81, 0x33);
@@ -1597,6 +1601,7 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
 	    !rt2x00_rt(rt2x00dev, RT3090) &&
+	    !rt2x00_rt(rt2x00dev, RT3390) &&
 	    rt2x00_rev(rt2x00dev) == 0x101)
 		rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	else
@@ -1608,7 +1613,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 
 	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) >= 0x0201) ||
 	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
-	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) >= 0x0211))
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) >= 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3390) && rt2x00_rev(rt2x00dev) >= 0x0211))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 	else
 		rt2800_bbp_write(rt2x00dev, 103, 0x00);
@@ -1617,7 +1623,8 @@ int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 106, 0x35);
 
 	if (rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090)) {
+	    rt2x00_rt(rt2x00dev, RT3090) ||
+	    rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_bbp_read(rt2x00dev, 138, &value);
 
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_ANTENNA, &eeprom);
@@ -1712,7 +1719,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
-	    !rt2x00_rt(rt2x00dev, RT3090))
+	    !rt2x00_rt(rt2x00dev, RT3090) &&
+	    !rt2x00_rt(rt2x00dev, RT3390))
 		return 0;
 
 	/*
@@ -1747,6 +1755,39 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 24, 0x16);
 		rt2800_rfcsr_write(rt2x00dev, 25, 0x01);
 		rt2800_rfcsr_write(rt2x00dev, 29, 0x1f);
+	} else if (rt2x00_rt(rt2x00dev, RT3390)) {
+		rt2800_rfcsr_write(rt2x00dev, 0, 0xa0);
+		rt2800_rfcsr_write(rt2x00dev, 1, 0xe1);
+		rt2800_rfcsr_write(rt2x00dev, 2, 0xf1);
+		rt2800_rfcsr_write(rt2x00dev, 3, 0x62);
+		rt2800_rfcsr_write(rt2x00dev, 4, 0x40);
+		rt2800_rfcsr_write(rt2x00dev, 5, 0x8b);
+		rt2800_rfcsr_write(rt2x00dev, 6, 0x42);
+		rt2800_rfcsr_write(rt2x00dev, 7, 0x34);
+		rt2800_rfcsr_write(rt2x00dev, 8, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 9, 0xc0);
+		rt2800_rfcsr_write(rt2x00dev, 10, 0x61);
+		rt2800_rfcsr_write(rt2x00dev, 11, 0x21);
+		rt2800_rfcsr_write(rt2x00dev, 12, 0x3b);
+		rt2800_rfcsr_write(rt2x00dev, 13, 0xe0);
+		rt2800_rfcsr_write(rt2x00dev, 14, 0x90);
+		rt2800_rfcsr_write(rt2x00dev, 15, 0x53);
+		rt2800_rfcsr_write(rt2x00dev, 16, 0xe0);
+		rt2800_rfcsr_write(rt2x00dev, 17, 0x94);
+		rt2800_rfcsr_write(rt2x00dev, 18, 0x5c);
+		rt2800_rfcsr_write(rt2x00dev, 19, 0x4a);
+		rt2800_rfcsr_write(rt2x00dev, 20, 0xb2);
+		rt2800_rfcsr_write(rt2x00dev, 21, 0xf6);
+		rt2800_rfcsr_write(rt2x00dev, 22, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 23, 0x14);
+		rt2800_rfcsr_write(rt2x00dev, 24, 0x08);
+		rt2800_rfcsr_write(rt2x00dev, 25, 0x3d);
+		rt2800_rfcsr_write(rt2x00dev, 26, 0x85);
+		rt2800_rfcsr_write(rt2x00dev, 27, 0x00);
+		rt2800_rfcsr_write(rt2x00dev, 28, 0x41);
+		rt2800_rfcsr_write(rt2x00dev, 29, 0x8f);
+		rt2800_rfcsr_write(rt2x00dev, 30, 0x20);
+		rt2800_rfcsr_write(rt2x00dev, 31, 0x0f);
 	}
 
 	if (rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201) {
@@ -1771,6 +1812,10 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 				rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
 		}
 		rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+	} else if (rt2x00_rt(rt2x00dev, RT3390)) {
+		rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
+		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
+		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
 	}
 
 	/*
@@ -1782,7 +1827,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2x00dev->calibration[1] =
 			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
 	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
-		   rt2x00_rt(rt2x00dev, RT3090)) {
+		   rt2x00_rt(rt2x00dev, RT3090) ||
+		   rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2x00dev->calibration[0] =
 			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x13);
 		rt2x00dev->calibration[1] =
@@ -1807,7 +1853,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 
 	if ((rt2x00_rt(rt2x00dev, RT3070) && rt2x00_rev(rt2x00dev) < 0x0201) ||
 	    (rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211) ||
-	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) < 0x0211))
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) < 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3390) && rt2x00_rev(rt2x00dev) < 0x0211))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
@@ -1817,7 +1864,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR17_R2, 0);
 	if ((rt2x00_rt(rt2x00dev, RT3071) && rt2x00_rev(rt2x00dev) < 0x0211) ||
-	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) < 0x0211)) {
+	    (rt2x00_rt(rt2x00dev, RT3090) && rt2x00_rev(rt2x00dev) < 0x0211) ||
+	    (rt2x00_rt(rt2x00dev, RT3390) && rt2x00_rev(rt2x00dev) < 0x0211)) {
 		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC, &eeprom);
 		if (rt2x00_get_field16(eeprom, EEPROM_NIC_EXTERNAL_LNA_BG))
 			rt2x00_set_field8(&rfcsr, RFCSR17_R3, 1);
@@ -1840,7 +1888,8 @@ int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	}
 
 	if (rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090)) {
+	    rt2x00_rt(rt2x00dev, RT3090) ||
+	    rt2x00_rt(rt2x00dev, RT3390)) {
 		rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
 		rfcsr &= ~0x0c;
 		rfcsr |= 0x31;
-- 
1.7.0.4

