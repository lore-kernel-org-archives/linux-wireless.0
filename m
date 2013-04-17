Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:56192 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966017Ab3DQMHq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Apr 2013 08:07:46 -0400
From: stf_xl@wp.pl
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH v2 09/11] rt2800: add rt2800_led_open_drain_enable subroutine
Date: Wed, 17 Apr 2013 14:08:18 +0200
Message-Id: <1366200500-4661-10-git-send-email-stf_xl@wp.pl> (sfid-20130417_140751_365953_CE8FB50F)
In-Reply-To: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
References: <1366200500-4661-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Acked-by: Gertjan van Wingerde <gwingerde@gmail.com>
Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index cf757ca..86d8ebc 100644
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
@@ -4588,6 +4597,8 @@ static void rt2800_init_rfcsr_30xx(struct rt2x00_dev *rt2x00dev)
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3071, REV_RT3071E) ||
 	    rt2x00_rt_rev_lt(rt2x00dev, RT3090, REV_RT3090E))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
@@ -4646,6 +4657,8 @@ static void rt2800_init_rfcsr_3290(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_read(rt2x00dev, 29, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR29_RSSI_GAIN, 3);
 	rt2800_rfcsr_write(rt2x00dev, 29, rfcsr);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
@@ -4717,6 +4730,8 @@ static void rt2800_init_rfcsr_3352(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
@@ -4766,6 +4781,8 @@ static void rt2800_init_rfcsr_3390(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT3390, REV_RT3390E))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
@@ -4822,6 +4839,8 @@ static void rt2800_init_rfcsr_3572(struct rt2x00_dev *rt2x00dev)
 	rt2800_register_write(rt2x00dev, LDO_CFG0, reg);
 
 	rt2800_rx_filter_calibration(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
@@ -4910,6 +4929,8 @@ static void rt2800_init_rfcsr_5390(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x00);
 
 	rt2800_normal_mode_setup_5xxx(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
@@ -4977,6 +4998,8 @@ static void rt2800_init_rfcsr_5392(struct rt2x00_dev *rt2x00dev)
 	rt2800_rfcsr_write(rt2x00dev, 63, 0x07);
 
 	rt2800_normal_mode_setup_5xxx(rt2x00dev);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
@@ -5019,6 +5042,8 @@ static void rt2800_init_rfcsr_5592(struct rt2x00_dev *rt2x00dev)
 
 	if (rt2x00_rt_rev_lt(rt2x00dev, RT5592, REV_RT5592C))
 		rt2800_rfcsr_write(rt2x00dev, 27, 0x03);
+
+	rt2800_led_open_drain_enable(rt2x00dev);
 }
 
 static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
@@ -5077,10 +5102,6 @@ static int rt2800_init_rfcsr(struct rt2x00_dev *rt2x00dev)
 		return 0;
 	}
 
-	rt2800_register_read(rt2x00dev, OPT_14_CSR, &reg);
-	rt2x00_set_field32(&reg, OPT_14_CSR_BIT0, 1);
-	rt2800_register_write(rt2x00dev, OPT_14_CSR, reg);
-
 	if (!rt2x00_rt(rt2x00dev, RT5390) &&
 	    !rt2x00_rt(rt2x00dev, RT5392)) {
 		u8 min_gain = rt2x00_rt(rt2x00dev, RT3070) ? 1 : 2;
-- 
1.7.4.4

