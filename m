Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:50100 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174Ab3JCSAt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Oct 2013 14:00:49 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH v2 3/4] rt2x00: rt2800lib: fix default VGC values for RT3593
Date: Thu,  3 Oct 2013 20:00:42 +0200
Message-Id: <1380823243-11149-3-git-send-email-juhosg@openwrt.org> (sfid-20131003_200101_802340_9D4DDCF7)
In-Reply-To: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
References: <1380823243-11149-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update the rt2800_get_default_vgc function to use the same VGC
values that the DPO_RT5572_LinuxSTA_2.6.1.3_20121022 reference
driver uses.

References:
  RT35xx_ChipAGCAdjust in chips/rt35xx.c
  RT3593_R66_MID_LOW_SENS_GET macro in include/chip/rt3593.h
  RT3593_R66_NON_MID_LOW_SEMS_GET macro in include/chips/rt3593.h

Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/rt2x00/rt2800lib.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c
index a619f2c..55b421f 100644
--- a/drivers/net/wireless/rt2x00/rt2800lib.c
+++ b/drivers/net/wireless/rt2x00/rt2800lib.c
@@ -4413,6 +4413,7 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 		    rt2x00_rt(rt2x00dev, RT3290) ||
 		    rt2x00_rt(rt2x00dev, RT3390) ||
 		    rt2x00_rt(rt2x00dev, RT3572) ||
+		    rt2x00_rt(rt2x00dev, RT3593) ||
 		    rt2x00_rt(rt2x00dev, RT5390) ||
 		    rt2x00_rt(rt2x00dev, RT5392) ||
 		    rt2x00_rt(rt2x00dev, RT5592))
@@ -4422,6 +4423,8 @@ static u8 rt2800_get_default_vgc(struct rt2x00_dev *rt2x00dev)
 	} else { /* 5GHZ band */
 		if (rt2x00_rt(rt2x00dev, RT3572))
 			vgc = 0x22 + (rt2x00dev->lna_gain * 5) / 3;
+		else if (rt2x00_rt(rt2x00dev, RT3593))
+			vgc = 0x20 + (rt2x00dev->lna_gain * 5) / 3;
 		else if (rt2x00_rt(rt2x00dev, RT5592))
 			vgc = 0x24 + (2 * rt2x00dev->lna_gain);
 		else {
-- 
1.7.10
