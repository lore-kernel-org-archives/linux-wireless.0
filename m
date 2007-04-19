Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-03.rdc-kc.rr.com ([24.94.166.129]:43061 "EHLO
	ms-smtp-03.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1766705AbXDSNpE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2007 09:45:04 -0400
Date: Thu, 19 Apr 2007 08:46:44 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] bcm43xx-mac80211: Fix machine check on PPC for  phy->rev == 1
Message-ID: <462772c4.i/6WywXw5chGDs/l%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Patch 1/3: Fix some typos and a logic error involving phy->gmode that caused
machine checks on PPC architecture with phy->rev == 1 chips.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

John,

This patch is for the wireless-dev tree. A separate one will be prepared
for the mb tree.

Larry


Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_phy.c
@@ -655,7 +660,7 @@ static void bcm43xx_phy_agcsetup(struct 
 				   & 0xFFF0) | 0x0004);
 	}
 
-	if (phy->rev < 6) {
+	if (phy->rev >= 6) {
 		bcm43xx_phy_write(dev, 0x0422, 0x287A);
 		bcm43xx_phy_write(dev, 0x0420,
 				  (bcm43xx_phy_read(dev, 0x0420)
@@ -3239,7 +3265,7 @@ bcm43xx_radio_interference_mitigation_di
 			                  bcm43xx_phy_read(dev, BCM43xx_PHY_G_CRS) | 0x4000);
 			break;
 		}
-		phy_stackrestore(0x0078);
+		radio_stackrestore(0x0078);
 		bcm43xx_calc_nrssi_threshold(dev);
 		phy_stackrestore(0x0406);
 		bcm43xx_phy_write(dev, 0x042B,

Index: wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-dev.orig/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
+++ wireless-dev/drivers/net/wireless/mac80211/bcm43xx/bcm43xx_main.c
@@ -830,6 +830,7 @@ static void bcm43xx_switch_analog(struct
 
 void bcm43xx_wireless_core_reset(struct bcm43xx_wldev *dev, u32 flags)
 {
+	struct bcm43xx_phy *phy = &dev->phy;
 	u32 tmslow;
 	u32 macctl;
 
@@ -853,10 +854,13 @@ void bcm43xx_wireless_core_reset(struct 
 	/* Turn Analog ON */
 	bcm43xx_switch_analog(dev, 1);
 
-	macctl = bcm43xx_read32(dev, BCM43xx_MMIO_MACCTL);
+	macctl = bcm43xx_read32(dev, BCM43xx_MMIO_MACCTL) & ~BCM43xx_MACCTL_GMODE;
 	macctl |= BCM43xx_MACCTL_IHR_ENABLED;
-	if (flags & BCM43xx_TMSLOW_GMODE)
+	if (flags & BCM43xx_TMSLOW_GMODE) {
 		macctl |= BCM43xx_MACCTL_GMODE;
+		phy->gmode = 1;
+	} else
+		phy->gmode = 0;
 	bcm43xx_write32(dev, BCM43xx_MMIO_MACCTL, macctl);
 }
 
