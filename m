Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:56517 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751413AbYEAKcu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 May 2008 06:32:50 -0400
From: Michael Buesch <mb@bu3sch.de>
To: stable@kernel.org
Subject: [PATCH stable] b43: Fix dual-PHY devices
Date: Thu, 1 May 2008 12:31:44 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805011231.44784.mb@bu3sch.de> (sfid-20080501_123236_378128_28AF18A8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes operation of dual-PHY (A/B/G) devices.
Do not anounce the A-PHY to mac80211, as that's not supported, yet.

This patch is in wireless-testing.git, commit
123082c124276b5e30b6a87ebe544a776c0ead7b

Signed-off-by: Michael Buesch <mb@bu3sch.de>


Index: linux-2.6.25/drivers/net/wireless/b43/main.c
===================================================================
--- linux-2.6.25.orig/drivers/net/wireless/b43/main.c	2008-05-01 12:29:44.000000000 +0200
+++ linux-2.6.25/drivers/net/wireless/b43/main.c	2008-05-01 12:29:47.000000000 +0200
@@ -3909,12 +3909,20 @@ static int b43_wireless_core_attach(stru
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
