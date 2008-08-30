Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:58586 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbYH3JwI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Aug 2008 05:52:08 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add LP-PHY read/write phyops
Date: Sat, 30 Aug 2008 11:49:45 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200808301149.45597.mb@bu3sch.de> (sfid-20080830_115212_995610_65D82A70)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds read/write phyops for the LP-PHY and LP-PHY radios.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue for the next merge window.


Index: wireless-testing/drivers/net/wireless/b43/phy_lp.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_lp.c	2008-08-30 10:50:49.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_lp.c	2008-08-30 11:33:50.000000000 +0200
@@ -63,33 +63,44 @@ static void b43_lpphy_op_exit(struct b43
 	kfree(lpphy);
 	dev->phy.lp = NULL;
 }
 
 static u16 b43_lpphy_op_read(struct b43_wldev *dev, u16 reg)
 {
-	//TODO
-	return 0;
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	return b43_read16(dev, B43_MMIO_PHY_DATA);
 }
 
 static void b43_lpphy_op_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
-	//TODO
+	b43_write16(dev, B43_MMIO_PHY_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_PHY_DATA, value);
 }
 
 static u16 b43_lpphy_op_radio_read(struct b43_wldev *dev, u16 reg)
 {
-	//TODO
-	return 0;
+	/* Register 1 is a 32-bit register. */
+	B43_WARN_ON(reg == 1);
+	/* LP-PHY needs a special bit set for read access */
+	if (dev->phy.rev < 2) {
+		if (reg != 0x4001)
+			reg |= 0x100;
+	} else
+		reg |= 0x200;
+
+	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	return b43_read16(dev, B43_MMIO_RADIO_DATA_LOW);
 }
 
 static void b43_lpphy_op_radio_write(struct b43_wldev *dev, u16 reg, u16 value)
 {
 	/* Register 1 is a 32-bit register. */
 	B43_WARN_ON(reg == 1);
 
-	//TODO
+	b43_write16(dev, B43_MMIO_RADIO_CONTROL, reg);
+	b43_write16(dev, B43_MMIO_RADIO_DATA_LOW, value);
 }
 
 static void b43_lpphy_op_software_rfkill(struct b43_wldev *dev,
 					 enum rfkill_state state)
 {
 	//TODO
