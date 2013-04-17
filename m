Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:23658 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966200Ab3DQMHw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:52 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 10/11] rt2800: add rt2800_normal_mode_setup_3xxx subroutine
Date: Wed, 17 Apr 2013 14:08:19 +0200
Message-Id: <1366200500-4661-11-git-send-email-stf_xl@wp.pl> (sfid-20130417_140805_540934_5851071D)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  154 +++++++++++++++---------------
 1 files changed, 77 insertions(+), 77 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 86d8ebc..ca587ba 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4465,6 +4465,77 @@ static void rt2800_rx_filter_calibration(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 }
 
+static void rt2800_normal_mode_setup_3xxx(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u8 min_gain, rfcsr, bbp;
+	u16 eeprom;
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+
+	rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
+	if (rt2x00_rt(rt2x00dev, RT3070) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
+		if (!test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
+			rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
+	}
+
+	min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
+	if (drv_data->txmixer_gain_24g >= min_gain) {
+		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+				  drv_data->txmixer_gain_24g);
+	}
+
+	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+	if (rt2x00_rt(rt2x00dev, RT3090)) {
+		/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
+		rt2800_bbp_read(rt2x00dev, 138, &bbp);
+		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
+			rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
+		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
+			rt2x00_set_field8(&bbp, BBP138_TX_DAC1, 1);
+		rt2800_bbp_write(rt2x00dev, 138, bbp);
+	}
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
+	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
+		   rt2x00_rt(rt2x00dev, RT3090) ||
+		   rt2x00_rt(rt2x00dev, RT3390)) {
+		rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
+		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
+		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
+		rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
+
+		rt2800_rfcsr_read(rt2x00dev, 15, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR15_TX_LO2_EN, 0);
+		rt2800_rfcsr_write(rt2x00dev, 15, rfcsr);
+
+		rt2800_rfcsr_read(rt2x00dev, 20, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR20_RX_LO1_EN, 0);
+		rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
+
+		rt2800_rfcsr_read(rt2x00dev, 21, &rfcsr);
+		rt2x00_set_field8(&rfcsr, RFCSR21_RX_LO2_EN, 0);
+		rt2800_rfcsr_write(rt2x00dev, 21, rfcsr);
+	}
+}
+
 static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
 {
 	u8 reg;
@@ -4599,6 +4670,7 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4659,6 +4731,7 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
 
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
@@ -4730,8 +4803,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
-
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
@@ -4783,6 +4856,7 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -4839,8 +4913,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
-
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
@@ -5048,12 +5122,6 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 {
-	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
-	u8 rfcsr;
-	u8 bbp;
-	u32 reg;
-	u16 eeprom;
-
 	if (!rt2x00_rt(rt2x00dev, RT3070) &&
 	    !rt2x00_rt(rt2x00dev, RT3071) &&
 	    !rt2x00_rt(rt2x00dev, RT3090) &&
@@ -5102,75 +5170,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-	    !rt2x00_rt(rt2x00dev, RT5392)) {
-		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
-
-		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
-		if (rt2x00_rt(rt2x00dev, RT3070) ||
-		    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
-		    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
-		    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
-			if (!test_bit(CAPABILITY_EXTERNAL_LNA_BG,
-				      &rt2x00dev->cap_flags))
-				rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
-		}
-		if (drv_data->txmixer_gain_24g >= min_gain) {
-			rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-					  drv_data->txmixer_gain_24g);
-		}
-		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
-	}
-
-	if (rt2x00_rt(rt2x00dev, RT3090)) {
-		/*  Turn off unused DAC1 and ADC1 to reduce power consumption */
-		rt2800_bbp_read(rt2x00dev, 138, &bbp);
-		rt2x00_eeprom_read(rt2x00dev, EEPROM_NIC_CONF0, &eeprom);
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_RXPATH) == 1)
-			rt2x00_set_field8(&bbp, BBP138_RX_ADC1, 0);
-		if (rt2x00_get_field16(eeprom, EEPROM_NIC_CONF0_TXPATH) == 1)
-			rt2x00_set_field8(&bbp, BBP138_TX_DAC1, 1);
-		rt2800_bbp_write(rt2x00dev, 138, bbp);
-	}
-
-	if (rt2x00_rt(rt2x00dev, RT3071) ||
-	    rt2x00_rt(rt2x00dev, RT3090) ||
-	    rt2x00_rt(rt2x00dev, RT3390)) {
-		rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR1_RF_BLOCK_EN, 1);
-		rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR1_RX1_PD, 1);
-		rt2x00_set_field8(&rfcsr, RFCSR1_TX1_PD, 1);
-		rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
-
-		rt2800_rfcsr_read(rt2x00dev, 15, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR15_TX_LO2_EN, 0);
-		rt2800_rfcsr_write(rt2x00dev, 15, rfcsr);
-
-		rt2800_rfcsr_read(rt2x00dev, 20, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR20_RX_LO1_EN, 0);
-		rt2800_rfcsr_write(rt2x00dev, 20, rfcsr);
-
-		rt2800_rfcsr_read(rt2x00dev, 21, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR21_RX_LO2_EN, 0);
-		rt2800_rfcsr_write(rt2x00dev, 21, rfcsr);
-	}
-
-	if (rt2x00_rt(rt2x00dev, RT3070)) {
-		rt2800_rfcsr_read(rt2x00dev, 27, &rfcsr);
-		if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F))
-			rt2x00_set_field8(&rfcsr, RFCSR27_R1, 3);
-		else
-			rt2x00_set_field8(&rfcsr, RFCSR27_R1, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR27_R2, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR27_R3, 0);
-		rt2x00_set_field8(&rfcsr, RFCSR27_R4, 0);
-		rt2800_rfcsr_write(rt2x00dev, 27, rfcsr);
-	}
-
-	return 0;
+		return 0;
 }
 
 int rt2800_enable_radio(struct rt2x00_dev *rt2x00dev)
-- 
1.7.4.4

