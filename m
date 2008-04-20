Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:43180 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934AbYDTOaF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 20 Apr 2008 10:30:05 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Remove some dead code
Date: Sun, 20 Apr 2008 16:23:26 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804201623.26816.mb@bu3sch.de> (sfid-20080420_153010_168086_9FA37BB4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes some dead code from the driver.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/lo.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/lo.c	2008-04-20 15:24:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/lo.c	2008-04-20 16:21:36.000000000 +0200
@@ -55,28 +55,26 @@ static struct b43_lo_calib * b43_find_lo
 
 /* Write the LocalOscillator Control (adjust) value-pair. */
 static void b43_lo_write(struct b43_wldev *dev, struct b43_loctl *control)
 {
 	struct b43_phy *phy = &dev->phy;
 	u16 value;
-	u16 reg;
 
 	if (B43_DEBUG) {
 		if (unlikely(abs(control->i) > 16 || abs(control->q) > 16)) {
 			b43dbg(dev->wl, "Invalid LO control pair "
 			       "(I: %d, Q: %d)\n", control->i, control->q);
 			dump_stack();
 			return;
 		}
 	}
+	B43_WARN_ON(phy->type != B43_PHYTYPE_G);
 
 	value = (u8) (control->q);
 	value |= ((u8) (control->i)) << 8;
-
-	reg = (phy->type == B43_PHYTYPE_B) ? 0x002F : B43_PHY_LO_CTL;
-	b43_phy_write(dev, reg, value);
+	b43_phy_write(dev, B43_PHY_LO_CTL, value);
 }
 
 static u16 lo_measure_feedthrough(struct b43_wldev *dev,
 				  u16 lna, u16 pga, u16 trsw_rx)
 {
 	struct b43_phy *phy = &dev->phy;
Index: wireless-testing/drivers/net/wireless/b43/phy.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy.c	2008-04-20 15:41:46.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy.c	2008-04-20 16:21:36.000000000 +0200
@@ -887,115 +887,12 @@ static void b43_phy_inita(struct b43_wld
 		b43_phy_write(dev, B43_PHY_OFDM(0x6E),
 				  (b43_phy_read(dev, B43_PHY_OFDM(0x6E))
 				   & 0xE000) | 0x3CF);
 	}
 }
 
-static void b43_phy_initb2(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	u16 offset, val;
-
-	b43_write16(dev, 0x03EC, 0x3F22);
-	b43_phy_write(dev, 0x0020, 0x301C);
-	b43_phy_write(dev, 0x0026, 0x0000);
-	b43_phy_write(dev, 0x0030, 0x00C6);
-	b43_phy_write(dev, 0x0088, 0x3E00);
-	val = 0x3C3D;
-	for (offset = 0x0089; offset < 0x00A7; offset++) {
-		b43_phy_write(dev, offset, val);
-		val -= 0x0202;
-	}
-	b43_phy_write(dev, 0x03E4, 0x3000);
-	b43_radio_selectchannel(dev, phy->channel, 0);
-	if (phy->radio_ver != 0x2050) {
-		b43_radio_write16(dev, 0x0075, 0x0080);
-		b43_radio_write16(dev, 0x0079, 0x0081);
-	}
-	b43_radio_write16(dev, 0x0050, 0x0020);
-	b43_radio_write16(dev, 0x0050, 0x0023);
-	if (phy->radio_ver == 0x2050) {
-		b43_radio_write16(dev, 0x0050, 0x0020);
-		b43_radio_write16(dev, 0x005A, 0x0070);
-		b43_radio_write16(dev, 0x005B, 0x007B);
-		b43_radio_write16(dev, 0x005C, 0x00B0);
-		b43_radio_write16(dev, 0x007A, 0x000F);
-		b43_phy_write(dev, 0x0038, 0x0677);
-		b43_radio_init2050(dev);
-	}
-	b43_phy_write(dev, 0x0014, 0x0080);
-	b43_phy_write(dev, 0x0032, 0x00CA);
-	b43_phy_write(dev, 0x0032, 0x00CC);
-	b43_phy_write(dev, 0x0035, 0x07C2);
-//XXX won't trigger	b43_lo_b_measure(dev);
-	b43_phy_write(dev, 0x0026, 0xCC00);
-	if (phy->radio_ver != 0x2050)
-		b43_phy_write(dev, 0x0026, 0xCE00);
-	b43_write16(dev, B43_MMIO_CHANNEL_EXT, 0x1000);
-	b43_phy_write(dev, 0x002A, 0x88A3);
-	if (phy->radio_ver != 0x2050)
-		b43_phy_write(dev, 0x002A, 0x88C2);
-	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
-	b43_phy_init_pctl(dev);
-}
-
-static void b43_phy_initb4(struct b43_wldev *dev)
-{
-	struct b43_phy *phy = &dev->phy;
-	u16 offset, val;
-
-	b43_write16(dev, 0x03EC, 0x3F22);
-	b43_phy_write(dev, 0x0020, 0x301C);
-	b43_phy_write(dev, 0x0026, 0x0000);
-	b43_phy_write(dev, 0x0030, 0x00C6);
-	b43_phy_write(dev, 0x0088, 0x3E00);
-	val = 0x3C3D;
-	for (offset = 0x0089; offset < 0x00A7; offset++) {
-		b43_phy_write(dev, offset, val);
-		val -= 0x0202;
-	}
-	b43_phy_write(dev, 0x03E4, 0x3000);
-	b43_radio_selectchannel(dev, phy->channel, 0);
-	if (phy->radio_ver != 0x2050) {
-		b43_radio_write16(dev, 0x0075, 0x0080);
-		b43_radio_write16(dev, 0x0079, 0x0081);
-	}
-	b43_radio_write16(dev, 0x0050, 0x0020);
-	b43_radio_write16(dev, 0x0050, 0x0023);
-	if (phy->radio_ver == 0x2050) {
-		b43_radio_write16(dev, 0x0050, 0x0020);
-		b43_radio_write16(dev, 0x005A, 0x0070);
-		b43_radio_write16(dev, 0x005B, 0x007B);
-		b43_radio_write16(dev, 0x005C, 0x00B0);
-		b43_radio_write16(dev, 0x007A, 0x000F);
-		b43_phy_write(dev, 0x0038, 0x0677);
-		b43_radio_init2050(dev);
-	}
-	b43_phy_write(dev, 0x0014, 0x0080);
-	b43_phy_write(dev, 0x0032, 0x00CA);
-	if (phy->radio_ver == 0x2050)
-		b43_phy_write(dev, 0x0032, 0x00E0);
-	b43_phy_write(dev, 0x0035, 0x07C2);
-
-//XXX won't trigger	b43_lo_b_measure(dev);
-
-	b43_phy_write(dev, 0x0026, 0xCC00);
-	if (phy->radio_ver == 0x2050)
-		b43_phy_write(dev, 0x0026, 0xCE00);
-	b43_write16(dev, B43_MMIO_CHANNEL_EXT, 0x1100);
-	b43_phy_write(dev, 0x002A, 0x88A3);
-	if (phy->radio_ver == 0x2050)
-		b43_phy_write(dev, 0x002A, 0x88C2);
-	b43_set_txpower_g(dev, &phy->bbatt, &phy->rfatt, phy->tx_control);
-	if (dev->dev->bus->sprom.boardflags_lo & B43_BFL_RSSI) {
-		b43_calc_nrssi_slope(dev);
-		b43_calc_nrssi_threshold(dev);
-	}
-	b43_phy_init_pctl(dev);
-}
-
 static void b43_phy_initb5(struct b43_wldev *dev)
 {
 	struct ssb_bus *bus = dev->dev->bus;
 	struct b43_phy *phy = &dev->phy;
 	u16 offset, value;
 	u8 old_channel;
@@ -1947,30 +1844,12 @@ int b43_phy_init(struct b43_wldev *dev)
 	case B43_PHYTYPE_A:
 		if (phy->rev == 2 || phy->rev == 3)
 			b43_phy_inita(dev);
 		else
 			unsupported = 1;
 		break;
-	case B43_PHYTYPE_B:
-		switch (phy->rev) {
-		case 2:
-			b43_phy_initb2(dev);
-			break;
-		case 4:
-			b43_phy_initb4(dev);
-			break;
-		case 5:
-			b43_phy_initb5(dev);
-			break;
-		case 6:
-			b43_phy_initb6(dev);
-			break;
-		default:
-			unsupported = 1;
-		}
-		break;
 	case B43_PHYTYPE_G:
 		b43_phy_initg(dev);
 		break;
 	case B43_PHYTYPE_N:
 		err = b43_phy_initn(dev);
 		break;
