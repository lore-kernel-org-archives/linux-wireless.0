Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:22653 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765454Ab3DIPEo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:04:44 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 01/11] rt2800: merge 5xxx normal mode setup
Date: Tue,  9 Apr 2013 17:05:20 +0200
Message-Id: <1365519930-3230-2-git-send-email-stf_xl@wp.pl> (sfid-20130409_170447_019982_B6184A2D)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Merge code which program the same registes at the end of rfcsr
initialization for 5592, 5392 and 5390 chips.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   91 ++++++++++++-------------------
 1 files changed, 34 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 7deac4d..d092b47 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4396,6 +4396,35 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
 	return rfcsr24;
 }
 
+static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
+{
+	u8 reg;
+	u16 eeprom;
+
+	rt2800_bbp_read(rt2x00dev, 138, &reg);
+	/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
+	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
+		rt2x00_set_field8(&reg, BBP138_RX_ADC1, 0);
+	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
+		rt2x00_set_field8(&reg, BBP138_TX_DAC1, 1);
+	rt2800_bbp_write(rt2x00dev, 138, reg);
+
+	rt2800_rfcsr_read(rt2x00dev, 38, &reg);
+	rt2x00_set_field8(&reg, RFCSR38_RX_LO1_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 38, reg);
+
+	rt2800_rfcsr_read(rt2x00dev, 39, &reg);
+	rt2x00_set_field8(&reg, RFCSR39_RX_LO2_EN, 0);
+	rt2800_rfcsr_write(rt2x00dev, 39, reg);
+
+	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
+
+	rt2800_rfcsr_read(rt2x00dev, 30, &reg);
+	rt2x00_set_field8(&reg, RFCSR30_RX_VCM, 2);
+	rt2800_rfcsr_write(rt2x00dev, 30, reg);
+}
+
 static void rt2800_init_rfcsr_305x_soc(struct rt2x00_dev *rt2x00dev)
 {
 	rt2800_rfcsr_write(rt2x00dev, 0, 0x50);
@@ -4725,6 +4754,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 61, 0xdd);
 	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
+
+	rt2800_normal_mode_setup_5xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
@@ -4788,13 +4819,12 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 61, 0x91);
 	rt2800_rfcsr_write(rt2x00dev, 62, 0x39);
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
+
+	rt2800_normal_mode_setup_5xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 {
-	u8 reg;
-	u16 eeprom;
-
 	rt2800_rfcsr_write(rt2x00dev, 1, 0x3F);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
 	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
@@ -4823,34 +4853,11 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 
 	rt2800_adjust_freq_offset(rt2x00dev);
 
-	rt2800_bbp_read(rt2x00dev, 138, &reg);
-
-	/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
-	rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
-		rt2x00_set_field8(&reg, BBP138_RX_ADC1, 0);
-	if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
-		rt2x00_set_field8(&reg, BBP138_TX_DAC1, 1);
-
-	rt2800_bbp_write(rt2x00dev, 138, reg);
-
 	/* Enable DC filter */
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT5592, REV_RT5592C))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
 
-	rt2800_rfcsr_read(rt2x00dev, 38, &reg);
-	rt2x00_set_field8(&reg, RFCSR38_RX_LO1_EN, 0);
-	rt2800_rfcsr_write(rt2x00dev, 38, reg);
-
-	rt2800_rfcsr_read(rt2x00dev, 39, &reg);
-	rt2x00_set_field8(&reg, RFCSR39_RX_LO2_EN, 0);
-	rt2800_rfcsr_write(rt2x00dev, 39, reg);
-
-	rt2800_bbp4_mac_if_ctrl(rt2x00dev);
-
-	rt2800_rfcsr_read(rt2x00dev, 30, &reg);
-	rt2x00_set_field8(&reg, RFCSR30_RX_VCM, 2);
-	rt2800_rfcsr_write(rt2x00dev, 30, reg);
+	rt2800_normal_mode_setup_5xxx(rt2x00dev);
 }
 
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
@@ -5051,20 +5058,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT3090) ||
-	    rt2x00_rt(rt2x00dev, RT5592)) {
-		rt2800_bbp_read(rt2x00dev, 138, &bbp);
-
-		/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
-			rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
-			rt2x00_set_field8(&bbp, BBP138_TX_DAC1, 1);
-
-		rt2800_bbp_write(rt2x00dev, 138, bbp);
-	}
-
 	if (rt2x00_rt(rt2x00dev, RT3071) ||
 	    rt2x00_rt(rt2x00dev, RT3090) ||
 	    rt2x00_rt(rt2x00dev, RT3390)) {
@@ -5107,22 +5100,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
 	}
 
-	if (rt2x00_rt(rt2x00dev, RT5390) ||
-	    rt2x00_rt(rt2x00dev, RT5392) ||
-	    rt2x00_rt(rt2x00dev, RT5592)) {
-		rt2800_rfcsr_read(rt2x00dev, 38, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR38_RX_LO1_EN, 0);
-		rt2800_rfcsr_write(rt2x00dev, 38, rfcsr);
-
-		rt2800_rfcsr_read(rt2x00dev, 39, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR39_RX_LO2_EN, 0);
-		rt2800_rfcsr_write(rt2x00dev, 39, rfcsr);
-
-		rt2800_rfcsr_read(rt2x00dev, 30, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR30_RX_VCM, 2);
-		rt2800_rfcsr_write(rt2x00dev, 30, rfcsr);
-	}
-
 	return 0;
 }
 
-- 
1.7.4.4

