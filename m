Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:45338 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764934Ab3DIPE6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Apr 2013 11:04:58 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 09/11] rt2800: add rt2800_led_open_drain_enable subroutine
Date: Tue,  9 Apr 2013 17:05:28 +0200
Message-Id: <1365519930-3230-10-git-send-email-stf_xl@wp.pl> (sfid-20130409_170505_761131_082EFB33)
In-Reply-To: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
References: <1365519930-3230-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index fe0df88..009fe47 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4332,6 +4332,15 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 	return 0;
 }
 
+static void rt2800_led_open_drain_enable(struct rt2x00_dev *rt2x00dev)
+{
+	u32 reg;
+
+	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
+	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
+	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
+}
+
 static u8 rt2800_init_rx_filter(struct rt2x00_dev *rt2x00dev, bool bw40,
 				u8 filter_target)
 {
@@ -4593,6 +4602,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4653,6 +4664,8 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
@@ -4722,6 +4735,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
@@ -4769,6 +4784,8 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -4823,6 +4840,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
@@ -4911,6 +4930,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 
 	rt2800_normal_mode_setup_5xxx(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
@@ -4978,6 +4999,8 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
 
 	rt2800_normal_mode_setup_5xxx(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
@@ -5018,6 +5041,8 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
@@ -5074,10 +5099,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
-	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
-	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
-
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
 	    !rt2x00_rt(rt2x00dev, RT5392)) {
 		rt2800_rfcsr_read(rt2x00dev, 17, &rfcsr);
-- 
1.7.4.4

