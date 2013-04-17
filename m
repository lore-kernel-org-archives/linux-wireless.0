Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:25851 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966244Ab3DQMHj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:39 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 07/11] rt2800: add rt2800_rx_filter_calibration procedure
Date: Wed, 17 Apr 2013 14:08:16 +0200
Message-Id: <1366200500-4661-8-git-send-email-stf_xl@wp.pl> (sfid-20130417_140749_896993_C0D5878C)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Add procedure for both bands filter calibration and use it on individual
chipset init rfcsr subroutines.

Remove "Set back to initial state" code for 3290 since vendor driver
DPO_RT3290_LinuxSTA_V2600_20120508 does not include it.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |  103 +++++++++++++++++--------------
 1 files changed, 57 insertions(+), 46 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 6907cd3..ad83bcd 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4332,8 +4332,8 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
-static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
-				bool bw40, u8 rfcsr24, u8 filter_target)
+static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev, bool bw40,
+				u8 filter_target)
 {
 	unsigned int i;
 	u8 bbp;
@@ -4341,6 +4341,7 @@ static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev,
 	u8 passband;
 	u8 stopband;
 	u8 overtuned = 0;
+	u8 rfcsr24 = (bw40) ? 0x27 : 0x07;
 
 	rt2800_rfcsr_write(rt2x00dev, 24, rfcsr24);
 
@@ -4409,6 +4410,52 @@ static void rt2800_rf_init_calibration(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_write(rt2x00dev, rf_reg, rfcsr);
 }
 
+static void rt2800_rx_filter_calibration(struct rt2x00_dev *rt2x00dev)
+{
+	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
+	u8 filter_tgt_bw20;
+	u8 filter_tgt_bw40;
+	u8 rfcsr, bbp;
+
+	/*
+	 * TODO: sync filter_tgt values with vendor driver
+	 */
+	if (rt2x00_rt(rt2x00dev, RT3070)) {
+		filter_tgt_bw20 = 0x16;
+		filter_tgt_bw40 = 0x19;
+	} else {
+		filter_tgt_bw20 = 0x13;
+		filter_tgt_bw40 = 0x15;
+	}
+
+	drv_data->calibration_bw20 =
+		rt2800_init_rx_filter(rt2x00dev, false, filter_tgt_bw20);
+	drv_data->calibration_bw40 =
+		rt2800_init_rx_filter(rt2x00dev, true, filter_tgt_bw40);
+
+	/*
+	 * Save BBP 25 & 26 values for later use in channel switching (for 3052)
+	 */
+	rt2800_bbp_read(rt2x00dev, 25, &drv_data->bbp25);
+	rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
+
+	/*
+	 * Set back to initial state
+	 */
+	rt2800_bbp_write(rt2x00dev, 24, 0);
+
+	rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
+	rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
+	rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
+
+	/*
+	 * Set BBP back to BW20
+	 */
+	rt2800_bbp_read(rt2x00dev, 4, &bbp);
+	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
+	rt2800_bbp_write(rt2x00dev, 4, bbp);
+}
+
 static void rt2800_normal_mode_setup_5xxx(struct rt2x00_dev *rt2x00dev)
 {
 	u8 reg;
@@ -4534,6 +4581,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 		rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
 		rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
 	}
+
+	rt2800_rx_filter_calibration(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4661,6 +4710,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 61, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 62, 0x00);
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
+
+	rt2800_rx_filter_calibration(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
@@ -4705,6 +4756,8 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_read(rt2x00dev, GPIO_SWITCH, &reg);
 	rt2x00_set_field32(&reg, GPIO_SWITCH_5, 0);
 	rt2800_register_write(rt2x00dev, GPIO_SWITCH, reg);
+
+	rt2800_rx_filter_calibration(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -4759,6 +4812,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field32(&reg, LDO_CFG0_LDO_CORE_VLEVEL, 0);
 	rt2x00_set_field32(&reg, LDO_CFG0_BGSEL, 1);
 	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
+
+	rt2800_rx_filter_calibration(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
@@ -5011,50 +5066,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-	/*
-	 * Set RX Filter calibration for 20MHz and 40MHz
-	 */
-	if (rt2x00_rt(rt2x00dev, RT3070)) {
-		drv_data->calibration_bw20 =
-			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x16);
-		drv_data->calibration_bw40 =
-			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x19);
-	} else if (rt2x00_rt(rt2x00dev, RT3071) ||
-		   rt2x00_rt(rt2x00dev, RT3090) ||
-		   rt2x00_rt(rt2x00dev, RT3352) ||
-		   rt2x00_rt(rt2x00dev, RT3390) ||
-		   rt2x00_rt(rt2x00dev, RT3572)) {
-		drv_data->calibration_bw20 =
-			rt2800_init_rx_filter(rt2x00dev, false, 0x07, 0x13);
-		drv_data->calibration_bw40 =
-			rt2800_init_rx_filter(rt2x00dev, true, 0x27, 0x15);
-	}
-
-	/*
-	 * Save BBP 25 & 26 values for later use in channel switching
-	 */
-	rt2800_bbp_read(rt2x00dev, 25, &drv_data->bbp25);
-	rt2800_bbp_read(rt2x00dev, 26, &drv_data->bbp26);
-
-	if (!rt2x00_rt(rt2x00dev, RT5390) &&
-	    !rt2x00_rt(rt2x00dev, RT5392)) {
-		/*
-		 * Set back to initial state
-		 */
-		rt2800_bbp_write(rt2x00dev, 24, 0);
-
-		rt2800_rfcsr_read(rt2x00dev, 22, &rfcsr);
-		rt2x00_set_field8(&rfcsr, RFCSR22_BASEBAND_LOOPBACK, 0);
-		rt2800_rfcsr_write(rt2x00dev, 22, rfcsr);
-
-		/*
-		 * Set BBP back to BW20
-		 */
-		rt2800_bbp_read(rt2x00dev, 4, &bbp);
-		rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 0);
-		rt2800_bbp_write(rt2x00dev, 4, bbp);
-	}
-
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E) ||
-- 
1.7.4.4

