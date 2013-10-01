Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:60930 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751117Ab3JASD2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Oct 2013 14:03:28 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] rt2x00: rt2800lib: fix VGC level adjustment for RT3572 and RT3593
Date: Tue,  1 Oct 2013 20:03:15 +0200
Message-Id: <1380650596-18659-2-git-send-email-juhosg@openwrt.org> (sfid-20131001_200341_872957_07CEA8EE)
In-Reply-To: <1380650596-18659-1-git-send-email-juhosg@openwrt.org>
References: <1380650596-18659-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The Ralink DPO_RT5572_LinuxSTA_2.6.1.3_20121022
reference driver uses different RSSI threshold
and VGC adjustment values for the RT3572 and for
the RT3593 chipsets.

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
 drivers/net/wireless/rt2x00/rt2800lib.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index 25c550a..0dd15b2 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4465,17 +4465,25 @@ void rt2800_link_tuner(struct rt2x00_dev *rt2x00dev, struct link_qual *qual,
 
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
 
-	if (rt2x00_rt(rt2x00dev, RT5592) && qual->rssi > -65)
+	if ((rt2x00_rt(rt2x00dev, RT3572) ||
+	     rt2x00_rt(rt2x00dev, RT3593)) && qual->rssi > -65) {
+		if (rt2x00dev->curr_band == IEEE80211_BAND_2GHZ)
+			vgc += 0x20;
+		else
+			vgc += 0x10;
+	} else if (rt2x00_rt(rt2x00dev, RT5592) && qual->rssi > -65) {
 		vgc += 0x20;
-	else if (qual->rssi > -80)
+	} else if (qual->rssi > -80) {
 		vgc += 0x10;
+	}
 
 	rt2800_set_vgc(rt2x00dev, qual, vgc);
 }
-- 
1.7.10
