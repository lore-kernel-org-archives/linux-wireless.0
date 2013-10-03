Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:50096 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754150Ab3JCSAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 14:00:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 2/4] rt2x00: rt2800lib: fix VGC adjustment for RT3572 and RT3593
Date: Thu,  3 Oct 2013 20:00:41 +0200
Message-Id: <1380823243-11149-2-git-send-email-juhosg@openwrt.org> (sfid-20131003_200057_418796_019B28F9)
In-Reply-To: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
References: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Ralink DPO_RT5572_LinuxSTA_2.6.1.3_20121022
reference driver uses different RSSI threshold
and VGC adjustment values for the RT3572 and
RT3593 chipsets.

Update the rt2800_link_tuner function to use the
same values. Also change the comment in the function
to make it more generic.

References:

  RT35xx_ChipAGCAdjust function in chips/rt35xx.c
  RSSI_FOR_MID_LOW_SENSIBILITY constant in include/chip/rtmp_phy.h
  RT3593_R66_MID_LOW_SENS_GET macro in include/chip/rt3593.h
  RT3593_R66_NON_MID_LOW_SEMS_GET macro in include/chips/rt3593.h

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 2690081..a619f2c 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4462,19 +4462,34 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 
 	if (rt2x00_rt_rev(rt2x00dev, RT2860, REV_RT2860C))
 		return;
-	/*
-	 * When RSSI is better then -80 increase VGC level with 0x10, except
-	 * for rt5592 chip.
+
+	/* When RSSI is better than a certain threshold, increase VGC
+	 * with a chip specific value in order to improve the balance
+	 * between sensibility and noise isolation.
 	 */
 
 	vgc = rt2800_get_default_vgc(rt2x00dev);
 
-	if (rt2x00_rt(rt2x00dev, RT5592)) {
+	switch (rt2x00dev->chip.rt) {
+	case RT3572:
+	case RT3593:
+		if (qual->rssi > -65) {
+			if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ)
+				vgc += 0x20;
+			else
+				vgc += 0x10;
+		}
+		break;
+
+	case RT5592:
 		if (qual->rssi > -65)
 			vgc += 0x20;
-	} else {
+		break;
+
+	default:
 		if (qual->rssi > -80)
 			vgc += 0x10;
+		break;
 	}
 
 	rt2800_set_vgc(rt2x00dev, qual, vgc);
-- 
1.7.10
