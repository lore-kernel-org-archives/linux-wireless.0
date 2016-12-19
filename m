Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51968 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758309AbcLSKzG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Dec 2016 05:55:06 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
        Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 05/11] rt2800: rename adjust_freq_offset function
Date: Mon, 19 Dec 2016 11:52:51 +0100
Message-Id: <1482144777-16760-6-git-send-email-sgruszka@redhat.com> (sfid-20161219_115822_375069_FE17362B)
In-Reply-To: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
References: <1482144777-16760-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We have different modes of adjusting freq offset on different chips.
Call current adjustment similarly like vendor driver - mode1 .

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/ralink/rt2x00/rt2800lib.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
index a6f3f78..65f20ca 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
@@ -1939,7 +1939,7 @@ static void rt2800_config_lna_gain(struct rt2x00_dev *rt2x00dev,
 
 #define FREQ_OFFSET_BOUND	0x5f
 
-static void rt2800_adjust_freq_offset(struct rt2x00_dev *rt2x00dev)
+static void rt2800_freq_cal_mode1(struct rt2x00_dev *rt2x00dev)
 {
 	u8 freq_offset, prev_freq_offset;
 	u8 rfcsr, prev_rfcsr;
@@ -2415,7 +2415,7 @@ static void rt2800_config_channel_rf3053(struct rt2x00_dev *rt2x00dev,
 	}
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
-	rt2800_adjust_freq_offset(rt2x00dev);
+	rt2800_freq_cal_mode1(rt2x00dev);
 
 	if (conf_is_ht40(conf)) {
 		txrx_agc_fc = rt2x00_get_field8(drv_data->calibration_bw40,
@@ -2605,7 +2605,7 @@ static void rt2800_config_channel_rf3290(struct rt2x00_dev *rt2x00dev,
 		rt2x00_set_field8(&rfcsr, RFCSR49_TX, info->default_power1);
 	rt2800_rfcsr_write(rt2x00dev, 49, rfcsr);
 
-	rt2800_adjust_freq_offset(rt2x00dev);
+	rt2800_freq_cal_mode1(rt2x00dev);
 
 	if (rf->channel <= 14) {
 		if (rf->channel == 6)
@@ -2646,7 +2646,7 @@ static void rt2800_config_channel_rf3322(struct rt2x00_dev *rt2x00dev,
 	else
 		rt2800_rfcsr_write(rt2x00dev, 48, info->default_power2);
 
-	rt2800_adjust_freq_offset(rt2x00dev);
+	rt2800_freq_cal_mode1(rt2x00dev);
 
 	rt2800_rfcsr_read(rt2x00dev, 1, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR1_RX0_PD, 1);
@@ -2711,7 +2711,7 @@ static void rt2800_config_channel_rf53xx(struct rt2x00_dev *rt2x00dev,
 	rt2x00_set_field8(&rfcsr, RFCSR1_TX0_PD, 1);
 	rt2800_rfcsr_write(rt2x00dev, 1, rfcsr);
 
-	rt2800_adjust_freq_offset(rt2x00dev);
+	rt2800_freq_cal_mode1(rt2x00dev);
 
 	if (rf->channel <= 14) {
 		int idx = rf->channel-1;
@@ -3006,7 +3006,7 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	}
 
 	/* TODO proper frequency adjustment */
-	rt2800_adjust_freq_offset(rt2x00dev);
+	rt2800_freq_cal_mode1(rt2x00dev);
 
 	/* TODO merge with others */
 	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
@@ -6454,7 +6454,7 @@ static void rt2800_init_rfcsr_3593(struct rt2x00_dev *rt2x00dev)
 	rt2x00_set_field8(&rfcsr, RFCSR2_RESCAL_EN, 1);
 	rt2800_rfcsr_write(rt2x00dev, 2, rfcsr);
 
-	rt2800_adjust_freq_offset(rt2x00dev);
+	rt2800_freq_cal_mode1(rt2x00dev);
 
 	rt2800_rfcsr_read(rt2x00dev, 18, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR18_XO_TUNE_BYPASS, 1);
@@ -6680,7 +6680,7 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 2, 0x80);
 	msleep(1);
 
-	rt2800_adjust_freq_offset(rt2x00dev);
+	rt2800_freq_cal_mode1(rt2x00dev);
 
 	/* Enable DC filter */
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT5592, REV_RT5592C))
-- 
1.7.1
