Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:47013 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760806Ab3DIPFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:05:00 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 10/11] rt2800: add rt2800_normal_mode_setup_3xxx subroutine
Date: Tue,  9 Apr 2013 17:05:29 +0200
Message-Id: <1365519930-3230-11-git-send-email-stf_xl@wp.pl> (sfid-20130409_171304_503588_ECDDFE2C)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  114 ++++++++++++++++---------------
 1 files changed, 58 insertions(+), 56 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 009fe47..f31b9b9 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4452,6 +4452,59 @@ static void rt2800_rx_filter_calibration(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
 }
 
+static void rt2800_normal_mode_setup_3xxx(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u8 rfcsr;
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR17_TX_LO1_EN, 0);
+	if (rt2x00_rt(rt2x00dev, RT3070) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
+	    rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E)) {
+		if (!test_bit(CAPABILITY_EXTERNAL_LNA_BG, &rt2x00dev->cap_flags))
+			rt2x00_set_field8(&rfcsr, RFCSR17_R, 1);
+	}
+	rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
+			  drv_data->txmixer_gain_24g);
+	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+
+	if (rt2x00_rt(rt2x00dev, RT3071) ||
+	    rt2x00_rt(rt2x00dev, RT3090) ||
+	    rt2x00_rt(rt2x00dev, RT3390)) {
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
+	} else if (rt2x00_rt(rt2x00dev, RT3070)) {
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
+}
+
 static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
 {
 	u8 reg;
@@ -4604,6 +4657,7 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4664,8 +4718,8 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
-
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
@@ -4735,8 +4789,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
-
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
@@ -4786,6 +4840,7 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
 
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -4840,8 +4895,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
-
 	rt2800_led_open_drain_enable(rt2x00dev);
+	rt2800_normal_mode_setup_3xxx(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
@@ -5099,59 +5154,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-	    !rt2x00_rt(rt2x00dev, RT5392)) {
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
-		rt2x00_set_field8(&rfcsr, RFCSR17_TXMIXER_GAIN,
-				  drv_data->txmixer_gain_24g);
-		rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
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
 	return 0;
 }
 
-- 
1.7.4.4

