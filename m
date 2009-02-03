Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48101 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949AbZBCSik (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Feb 2009 13:38:40 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Port spec bugfixes for the LP baseband init
Date: Tue, 3 Feb 2009 19:36:45 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200902031936.45439.mb@bu3sch.de> (sfid-20090203_193845_705517_D359025C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A few bugs were fixed in the LP baseband init specs.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

Please queue on top of the other LP-PHY patches.

Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2009-02-03 19:30:33.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2009-02-03 19:33:18.000000000 +0100
@@ -70,6 +70,7 @@ static void lpphy_baseband_rev0_1_init(s
 
 static void lpphy_baseband_rev2plus_init(struct b43_wldev *dev)
 {
+	struct ssb_bus *bus = dev->dev->bus;
 	struct b43_phy_lp *lpphy = dev->phy.lp;
 
 	b43_phy_write(dev, B43_LPPHY_AFE_DAC_CTL, 0x50);
@@ -89,7 +90,7 @@ static void lpphy_baseband_rev2plus_init
 	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x4000);
 	b43_phy_mask(dev, B43_LPPHY_CRSGAIN_CTL, ~0x2000);
 	b43_phy_set(dev, B43_PHY_OFDM(0x10A), 0x1);
-	b43_phy_maskset(dev, B43_LPPHY_CCKLMSSTEPSIZE, 0xFF01, 0x10);
+	b43_phy_maskset(dev, B43_PHY_OFDM(0x10A), 0xFF01, 0x10);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0xDF), 0xFF00, 0xF4);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0xDF), 0x00FF, 0xF100);
 	b43_phy_write(dev, B43_LPPHY_CLIPTHRESH, 0x48);
@@ -101,8 +102,13 @@ static void lpphy_baseband_rev2plus_init
 	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xF81F, 0xA0);
 	b43_phy_maskset(dev, B43_LPPHY_GAINDIRECTMISMATCH, 0xE0FF, 0x300);
 	b43_phy_maskset(dev, B43_LPPHY_HIGAINDB, 0x00FF, 0x2A00);
-	b43_phy_maskset(dev, B43_LPPHY_LOWGAINDB, 0x00FF, 0x1E00);
-	b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0xFF00, 0xD);
+	if ((bus->chip_id == 0x4325) && (bus->chip_rev == 0)) {
+		b43_phy_maskset(dev, B43_LPPHY_LOWGAINDB, 0x00FF, 0x2100);
+		b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0xFF00, 0xA);
+	} else {
+		b43_phy_maskset(dev, B43_LPPHY_LOWGAINDB, 0x00FF, 0x1E00);
+		b43_phy_maskset(dev, B43_LPPHY_VERYLOWGAINDB, 0xFF00, 0xD);
+	}
 	b43_phy_maskset(dev, B43_PHY_OFDM(0xFE), 0xFFE0, 0x1F);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0xFF), 0xFFE0, 0xC);
 	b43_phy_maskset(dev, B43_PHY_OFDM(0x100), 0xFF00, 0x19);
@@ -114,17 +120,8 @@ static void lpphy_baseband_rev2plus_init
 	b43_phy_maskset(dev, B43_LPPHY_CLIPCTRTHRESH, 0xFFE0, 0x12);
 	b43_phy_maskset(dev, B43_LPPHY_GAINMISMATCH, 0x0FFF, 0x9000);
 
-	if (dev->phy.rev < 2) {
-		//FIXME this will never execute.
-
-		//FIXME 32bit?
-		b43_lptab_write(dev, B43_LPTAB32(0x11, 0x14), 0);
-		b43_lptab_write(dev, B43_LPTAB32(0x08, 0x12), 0x40);
-	} else {
-		//FIXME 32bit?
-		b43_lptab_write(dev, B43_LPTAB32(0x08, 0x14), 0);
-		b43_lptab_write(dev, B43_LPTAB32(0x08, 0x12), 0x40);
-	}
+	b43_lptab_write(dev, B43_LPTAB16(0x08, 0x14), 0);
+	b43_lptab_write(dev, B43_LPTAB16(0x08, 0x12), 0x40);
 
 	if (b43_current_band(dev->wl) == IEEE80211_BAND_2GHZ) {
 		b43_phy_set(dev, B43_LPPHY_CRSGAIN_CTL, 0x40);

-- 
Greetings, Michael.
