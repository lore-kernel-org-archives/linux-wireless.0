Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx3.wp.pl ([212.77.101.7]:41913 "EHLO mx3.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755957Ab3CPSUM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 16 Mar 2013 14:20:12 -0400
From: stf_xl@wp.pl
To: "John W. Linville\"" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Stanislaw Gruszka <stf_xl@wp.pl>
Subject: [PATCH 21/25] rt2800: 5592: add chip specific vgc calculations
Date: Sat, 16 Mar 2013 19:19:49 +0100
Message-Id: <1363457993-15541-22-git-send-email-stf_xl@wp.pl> (sfid-20130316_192019_994346_DA422CA6)
In-Reply-To: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
References: <1363457993-15541-1-git-send-email-stf_xl@wp.pl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Stanislaw Gruszka <stf_xl@wp.pl>

Based on:
RT5592_ChipAGCAdjust()

from:
DPO_RT5572_LinuxSTA_2.6.1.3_20121022/chips/rt5592.c

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   29 ++++++++++++++++++++++-------
 1 files changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index f2446de..5adb92b 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -3277,13 +3277,16 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		    rt2x00_rt(rt2x00dev, RT3390) ||
 		    rt2x00_rt(rt2x00dev, RT3572) ||
 		    rt2x00_rt(rt2x00dev, RT5390) ||
-		    rt2x00_rt(rt2x00dev, RT5392))
+		    rt2x00_rt(rt2x00dev, RT5392) ||
+		    rt2x00_rt(rt2x00dev, RT5592))
 			vgc = 0x1c + (2 * rt2x00dev->lna_gain);
 		else
 			vgc = 0x2e + rt2x00dev->lna_gain;
 	} else { /* 5GHZ band */
 		if (rt2x00_rt(rt2x00dev, RT3572))
 			vgc = 0x22 + (rt2x00dev->lna_gain * 5) / 3;
+		else if (rt2x00_rt(rt2x00dev, RT5592))
+			vgc = 0x24 + (2 * rt2x00dev->lna_gain);
 		else {
 			if (!test_bit(CONFIG_CHANNEL_HT40, &rt2x00dev->flags))
 				vgc = 0x32 + (rt2x00dev->lna_gain * 5) / 3;
@@ -3299,7 +3302,11 @@ static inline void rt2800_set_vgc(struct rt2x00_dev *rt2x00dev,
 				  struct link_qual *qual, u8 vgc_level)
 {
 	if (qual->vgc_level != vgc_level) {
-		rt2800_bbp_write(rt2x00dev, 66, vgc_level);
+		if (rt2x00_rt(rt2x00dev, RT5592)) {
+			rt2800_bbp_write(rt2x00dev, 83, qual->rssi > -65 ? 0x4a : 0x7a);
+			rt2800_bbp_write_with_rx_chain(rt2x00dev, 66, vgc_level);
+		} else
+			rt2800_bbp_write(rt2x00dev, 66, vgc_level);
 		qual->vgc_level = vgc_level;
 		qual->vgc_level_reg = vgc_level;
 	}
@@ -3314,15 +3321,23 @@ EXPORT_SYMBOL_GPL(rt2800_reset_tuner);
 void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 		       const u32 count)
 {
+	u8 vgc;
+
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C))
 		return;
-
 	/*
-	 * When RSSI is better then -80 increase VGC level with 0x10
+	 * When RSSI is better then -80 increase VGC level with 0x10, except
+	 * for rt5592 chip.
 	 */
-	rt2800_set_vgc(rt2x00dev, qual,
-		       rt2800_get_default_vgc(rt2x00dev) +
-		       ((qual->rssi > -80) * 0x10));
+
+	vgc = rt2800_get_default_vgc(rt2x00dev);
+
+	if (rt2x00_rt(rt2x00dev, RT5592) && qual->rssi > -65)
+		vgc += 0x20;
+	else if (qual->rssi > -80)
+		vgc += 0x10;
+
+	rt2800_set_vgc(rt2x00dev, qual, vgc);
 }
 EXPORT_SYMBOL_GPL(rt2800_link_tuner);
 
-- 
1.7.4.4

