Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:36968 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932476Ab3CPSTu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:50 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 08/25] rt2800: 5592: RF early registers initialization
Date: Sat, 16 Mar 2013 19:19:36 +0100
Message-Id: <1363457993-15541-9-git-send-email-stf_xl@wp.pl> (sfid-20130316_191954_131387_71E0515E)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
NICInitRT5592RFRegisters()
RF5592Reg_2G_5G[]

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

This patch also merge common frequency adjustment (RF_R17 settings)
code. Further work is needed, to setup more RF/BBP/MAC registers after
that.

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   76 +++++++++++++++++++++----------
 1 files changed, 51 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 9ac6f20..57afd6b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -1991,6 +1991,18 @@ static void rt2800_config_channel_rf3052(struct rt2x00_dev *rt2x00dev,
 #define POWER_BOUND_5G		0x2b
 #define FREQ_OFFSET_BOUND	0x5f
 
+static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
+{
+	u8 rfcsr;
+
+	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
+	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
+	else
+		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
+	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+}
+
 static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 					 struct ieee80211_conf *conf,
 					 struct rf_channel *rf,
@@ -2011,12 +2023,7 @@ static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
 
-	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
-	else
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
-	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+	rt2800_adjust_freq_offset(rt2x00dev);
 
 	if (rf->channel <= 14) {
 		if (rf->channel == 6)
@@ -2057,13 +2064,7 @@ static void rt2800_config_channel_rf3322(struct rt2x00_dev *rt2x00dev,
 	else
 		rt2800_rfcsr_write(rt2x00dev, 48, info->default_power2);
 
-	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
-	else
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
-
-	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+	rt2800_adjust_freq_offset(rt2x00dev);
 
 	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
@@ -2128,12 +2129,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
-	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
-	else
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
-	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+	rt2800_adjust_freq_offset(rt2x00dev);
 
 	if (rf->channel <= 14) {
 		int idx = rf->channel-1;
@@ -2423,12 +2419,7 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/* TODO proper frequency adjustment */
-	rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-	if (rt2x00dev->freq_offset > FREQ_OFFSET_BOUND)
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, FREQ_OFFSET_BOUND);
-	else
-		rt2x00_set_field8(&rfcsr, RFCSR17_CODE, rt2x00dev->freq_offset);
-	rt2800_rfcsr_write(rt2x00dev, 17, rfcsr);
+	rt2800_adjust_freq_offset(rt2x00dev);
 
 	/* TODO merge with others */
 	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
@@ -4638,6 +4629,37 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
 }
 
+static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_rfcsr_write(rt2x00dev, 1, 0x3F);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 3, 0x08);
+	rt2800_rfcsr_write(rt2x00dev, 5, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 6, 0xE4);
+	rt2800_rfcsr_write(rt2x00dev, 7, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 14, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 15, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 16, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 18, 0x03);
+	rt2800_rfcsr_write(rt2x00dev, 19, 0x4D);
+	rt2800_rfcsr_write(rt2x00dev, 20, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 21, 0x8D);
+	rt2800_rfcsr_write(rt2x00dev, 26, 0x82);
+	rt2800_rfcsr_write(rt2x00dev, 28, 0x00);
+	rt2800_rfcsr_write(rt2x00dev, 29, 0x10);
+	rt2800_rfcsr_write(rt2x00dev, 33, 0xC0);
+	rt2800_rfcsr_write(rt2x00dev, 34, 0x07);
+	rt2800_rfcsr_write(rt2x00dev, 35, 0x12);
+	rt2800_rfcsr_write(rt2x00dev, 47, 0x0C);
+	rt2800_rfcsr_write(rt2x00dev, 53, 0x22);
+	rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
+
+	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
+	msleep(1);
+
+	rt2800_adjust_freq_offset(rt2x00dev);
+}
+
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 {
 	struct rt2800_drv_data *drv_data = rt2x00dev->drv_data;
@@ -4655,6 +4677,7 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	    !rt2x00_rt(rt2x00dev, RT3572) &&
 	    !rt2x00_rt(rt2x00dev, RT5390) &&
 	    !rt2x00_rt(rt2x00dev, RT5392) &&
+	    !rt2x00_rt(rt2x00dev, RT5392) &&
 	    !rt2800_is_305x_soc(rt2x00dev))
 		return 0;
 
@@ -4709,6 +4732,9 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 	case RT5392:
 		rt2800_init_rfcsr_5392(rt2x00dev);
 		break;
+	case RT5592:
+		rt2800_init_rfcsr_5592(rt2x00dev);
+		break;
 	}
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3070, REV_RT3070F)) {
-- 
1.7.4.4

