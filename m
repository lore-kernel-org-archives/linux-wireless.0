Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:33302 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934077AbXGZQeM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jul 2007 12:34:12 -0400
Date: Thu, 26 Jul 2007 11:33:01 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>,
	Michael Buesch <mb@bu3sch.de>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Fix specs typo for baseband attenuation
Message-ID: <46a8ccbd.wNQamvQ9e0RJ0XZK%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A typo in the specs interchanges the branches in an if statement, which
breaks operations for a BCM4306/rev 2 that has phy->analog == 1.

Signed-off-by: Larry Finger<Larry.Finger@lwfinger.net>
---

John and Michael,

This patch is made for the wireless-dev tree after the bcm43xx-mac80211
directory has been moved into drivers/net/wireless, but it needs to be
applied to the wireless-mb tree as well.

Larry

Index: wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
===================================================================
--- wireless-dev/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
+++ wireless-dev/drivers/net/wireless/bcm43xx-mac80211/bcm43xx_phy.c
@@ -1895,7 +1895,7 @@ void bcm43xx_phy_set_baseband_attenuatio
 		bcm43xx_write16(dev, BCM43xx_MMIO_PHY0,
 				(bcm43xx_read16(dev, BCM43xx_MMIO_PHY0)
 				 & 0xFFF0) | baseband_attenuation);
-	} else if (phy->analog == 1) {
+	} else if (phy->analog != 1) {
 		bcm43xx_phy_write(dev, BCM43xx_PHY_DACCTL,
 				  (bcm43xx_phy_read(dev, BCM43xx_PHY_DACCTL)
 				   & 0xFFC3) | (baseband_attenuation << 2));
