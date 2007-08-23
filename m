Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55227
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764928AbXHWW1F (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Aug 2007 18:27:05 -0400
Message-Id: <20070823222156.637315000@bu3sch.de>
References: <20070823222153.073035000@bu3sch.de>
Date: Fri, 24 Aug 2007 00:21:59 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
Subject: [patch 6/7] b43: Add missing stuff to pwork
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds missing stuff for new cards to pwork.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev-new/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-dev-new.orig/drivers/net/wireless/b43/main.c	2007-08-23 23:40:23.000000000 +0200
+++ wireless-dev-new/drivers/net/wireless/b43/main.c	2007-08-23 23:41:00.000000000 +0200
@@ -2308,14 +2308,29 @@ static void b43_periodic_every120sec(str
 	b43_mac_suspend(dev);
 	b43_lo_g_measure(dev);
 	b43_mac_enable(dev);
+	if (b43_has_hardware_pctl(phy))
+		b43_lo_g_ctl_mark_all_unused(dev);
 }
 
 static void b43_periodic_every60sec(struct b43_wldev *dev)
 {
-	b43_lo_g_ctl_mark_all_unused(dev);
+	struct b43_phy *phy = &dev->phy;
+
+	if (!b43_has_hardware_pctl(phy))
+		b43_lo_g_ctl_mark_all_unused(dev);
 	if (dev->dev->bus->sprom.r1.boardflags_lo & B43_BFL_RSSI) {
 		b43_mac_suspend(dev);
 		b43_calc_nrssi_slope(dev);
+		if ((phy->radio_ver == 0x2050) && (phy->radio_rev == 8)) {
+			u8 old_chan = phy->channel;
+
+			/* VCO Calibration */
+			if (old_chan >= 8)
+				b43_radio_selectchannel(dev, 1, 0);
+			else
+				b43_radio_selectchannel(dev, 13, 0);
+			b43_radio_selectchannel(dev, old_chan, 0);
+		}
 		b43_mac_enable(dev);
 	}
 }

-- 

