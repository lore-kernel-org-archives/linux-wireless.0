Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:45327 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753825AbYD0RLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Apr 2008 13:11:45 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix dual-PHY devices
Date: Sun, 27 Apr 2008 19:06:18 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Richard Jonsson <richie@coderworld.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804271906.18856.mb@bu3sch.de> (sfid-20080427_191156_002067_FFD4180E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes operation of dual-PHY (A/B/G) devices.
Do not anounce the A-PHY to mac80211, as that's not supported, yet.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, this is 2.6.26 material.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-04-27 17:47:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-04-27 17:47:50.000000000 +0200
@@ -4308,12 +4308,20 @@ static int b43_wireless_core_attach(stru
 	if (dev->phy.type == B43_PHYTYPE_A) {
 		/* FIXME */
 		b43err(wl, "IEEE 802.11a devices are unsupported\n");
 		err = -EOPNOTSUPP;
 		goto err_powerdown;
 	}
+	if (1 /* disable A-PHY */) {
+		/* FIXME: For now we disable the A-PHY on multi-PHY devices. */
+		if (dev->phy.type != B43_PHYTYPE_N) {
+			have_2ghz_phy = 1;
+			have_5ghz_phy = 0;
+		}
+	}
+
 	dev->phy.gmode = have_2ghz_phy;
 	tmp = dev->phy.gmode ? B43_TMSLOW_GMODE : 0;
 	b43_wireless_core_reset(dev, tmp);
 
 	err = b43_validate_chipaccess(dev);
 	if (err)
