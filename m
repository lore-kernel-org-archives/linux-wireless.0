Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-04.rdc-kc.rr.com ([24.94.166.116]:53322 "EHLO
	ms-smtp-04.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893AbXCTUuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2007 16:50:52 -0400
Date: Tue, 20 Mar 2007 15:49:53 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: Michael Buesch <mb@bu3sch.de>, Bcm43xx-dev@lists.berlios.de,
	linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx-mac80211: Change radio_init2050 to match specs
Message-ID: <460048f1.Sz+VinhM/N8KG294%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code in the mac80211 version of radio_init2050 differs from the specs
in two places.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-mb.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
+++ wireless-mb/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
@@ -3444,9 +3444,9 @@ static u16 radio2050_rfover_val(struct b
 			if (phy_register == BCM43xx_PHY_RFOVER) {
 				return 0x9B3;
 			} else if (phy_register == BCM43xx_PHY_RFOVERVAL) {
-				extlna |= (i << 8);
 				if (extlna)
 					extlna |= 0x8000;
+				extlna |= (i << 8);
 				switch (lpd) {
 				case LPD(0, 1, 1):
 					return 0x8F92;
@@ -3724,9 +3724,10 @@ u16 bcm43xx_radio_init2050(struct bcm43x
 		bcm43xx_phy_stackrestore(stack, BCM43xx_PHY_ANALOGOVERVAL);
 		bcm43xx_phy_stackrestore(stack, BCM43xx_PHY_CRS0);
 		bcm43xx_phy_stackrestore(stack, BCM43xx_PHY_CLASSCTL);
-		bcm43xx_write16(dev, BCM43xx_MMIO_PHY_RADIO,
-				bcm43xx_read16(dev, BCM43xx_MMIO_PHY_RADIO)
-				& 0x7FFF);
+		if (has_loopback_gain(phy)) {
+			bcm43xx_phy_stackrestore(stack, BCM43xx_PHY_LO_MASK);
+			bcm43xx_phy_stackrestore(stack, BCM43xx_PHY_LO_CTL);
+		}
 	}
 	if (i > 15)
 		ret = radio78;
