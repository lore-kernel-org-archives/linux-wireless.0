Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.8]:37008 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932507Ab3CPST6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:19:58 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 13/25] rt2800: 5592: init frequency calibration
Date: Sat, 16 Mar 2013 19:19:41 +0100
Message-Id: <1363457993-15541-14-git-send-email-stf_xl@wp.pl> (sfid-20130316_192005_219966_E7AF36B4)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
InitFrequencyCalibrationMode()
RT5592_ChipCap

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/common/frq_cal.c
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 54d9089..93b9def 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3744,6 +3744,12 @@ static void rt2800_bbp4_mac_if_ctrl(struct rt2x00_dev *rt2x00dev)
 	rt2800_bbp_write(rt2x00dev, 4, value);
 }
 
+static void rt2800_init_freq_calibration(struct rt2x00_dev *rt2x00dev)
+{
+	rt2800_bbp_write(rt2x00dev, 142, 1);
+	rt2800_bbp_write(rt2x00dev, 143, 57);
+}
+
 static void rt2800_init_bbp_5592_glrt(struct rt2x00_dev *rt2x00dev)
 {
 	const u8 glrt_table[] = {
@@ -3852,6 +3858,8 @@ static void rt2800_init_bbp_5592(struct rt2x00_dev *rt2x00dev)
 		rt2800_bbp_write(rt2x00dev, 254, value);
 	}
 
+	rt2800_init_freq_calibration(rt2x00dev);
+
 	rt2800_bbp_write(rt2x00dev, 84, 0x19);
 	if (rt2x00_rt_rev_gte(rt2x00dev, RT5592, REV_RT5592C))
 		rt2800_bbp_write(rt2x00dev, 103, 0xc0);
@@ -4155,9 +4163,7 @@ static int rt2800_init_bbp(struct rt2x00_dev *rt2x00dev)
 			rt2x00_set_field8(&value, BBP152_RX_DEFAULT_ANT, 0);
 		rt2800_bbp_write(rt2x00dev, 152, value);
 
-		/* Init frequency calibration */
-		rt2800_bbp_write(rt2x00dev, 142, 1);
-		rt2800_bbp_write(rt2x00dev, 143, 57);
+		rt2800_init_freq_calibration(rt2x00dev);
 	}
 
 	for (i = 0; i < EEPROM_BBP_SIZE; i++) {
-- 
1.7.4.4

