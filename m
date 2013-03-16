Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37032 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932540Ab3CPSUD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:03 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 16/25] rt2800: 5592: more channel switch registers settings (BBP & GLRT)
Date: Sat, 16 Mar 2013 19:19:44 +0100
Message-Id: <1363457993-15541-17-git-send-email-stf_xl@wp.pl> (sfid-20130316_192035_506471_2580A008)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
RT5592_ChipSwitchChannel()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   32 +++++++++++++++++++++++++++++++
 1 files changed, 32 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 1650cf4..c990ab8 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -2430,6 +2430,30 @@ static void rt2800_config_channel_rf55xx(struct rt2x00_dev *rt2x00dev,
 	rt2800_rfcsr_read(rt2x00dev, 3, &rfcsr);
 	rt2x00_set_field8(&rfcsr, RFCSR3_VCOCAL_EN, 1);
 	rt2800_rfcsr_write(rt2x00dev, 3, rfcsr);
+
+	/* BBP settings */
+	rt2800_bbp_write(rt2x00dev, 62, 0x37 - rt2x00dev->lna_gain);
+	rt2800_bbp_write(rt2x00dev, 63, 0x37 - rt2x00dev->lna_gain);
+	rt2800_bbp_write(rt2x00dev, 64, 0x37 - rt2x00dev->lna_gain);
+
+	rt2800_bbp_write(rt2x00dev, 79, (rf->channel <= 14) ? 0x1C : 0x18);
+	rt2800_bbp_write(rt2x00dev, 80, (rf->channel <= 14) ? 0x0E : 0x08);
+	rt2800_bbp_write(rt2x00dev, 81, (rf->channel <= 14) ? 0x3A : 0x38);
+	rt2800_bbp_write(rt2x00dev, 82, (rf->channel <= 14) ? 0x62 : 0x92);
+
+	/* GLRT band configuration */
+	rt2800_bbp_write(rt2x00dev, 195, 128);
+	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0xE0 : 0xF0);
+	rt2800_bbp_write(rt2x00dev, 195, 129);
+	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x1F : 0x1E);
+	rt2800_bbp_write(rt2x00dev, 195, 130);
+	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x38 : 0x28);
+	rt2800_bbp_write(rt2x00dev, 195, 131);
+	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x32 : 0x20);
+	rt2800_bbp_write(rt2x00dev, 195, 133);
+	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x28 : 0x7F);
+	rt2800_bbp_write(rt2x00dev, 195, 124);
+	rt2800_bbp_write(rt2x00dev, 196, (rf->channel <= 14) ? 0x19 : 0x7F);
 }
 
 static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
@@ -2577,6 +2601,14 @@ static void rt2800_config_channel(struct rt2x00_dev *rt2x00dev,
 	if (rt2x00_rt(rt2x00dev, RT3572))
 		rt2800_rfcsr_write(rt2x00dev, 8, 0x80);
 
+	if (rt2x00_rt(rt2x00dev, RT5592)) {
+		rt2800_bbp_write(rt2x00dev, 195, 141);
+		rt2800_bbp_write(rt2x00dev, 196, conf_is_ht40(conf) ? 0x10 : 0x1a);
+
+		/* TODO AGC adjust */
+		/* TODO IQ calibration */
+	}
+
 	rt2800_bbp_read(rt2x00dev, 4, &bbp);
 	rt2x00_set_field8(&bbp, BBP4_BANDWIDTH, 2 * conf_is_ht40(conf));
 	rt2800_bbp_write(rt2x00dev, 4, bbp);
-- 
1.7.4.4

