Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:37548 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754778AbZCaKbt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Mar 2009 06:31:49 -0400
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Do radio lock assertion in software
Date: Tue, 31 Mar 2009 12:27:32 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200903311227.32684.mb@bu3sch.de> (sfid-20090331_123154_572855_DDC497F7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The assertion of the lock-bit in the hardware register is unreliable,
because there are devices with quirks that will randomly set the bit.

Do the assertion in software, only.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue this bugfix.


Index: wireless-testing/drivers/net/wireless/b43/phy_common.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.c	2009-03-31 12:03:22.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.c	2009-03-31 12:08:00.000000000 +0200
@@ -131,12 +131,16 @@ void b43_radio_lock(struct b43_wldev *de
 {
 	u32 macctl;
 
+#if B43_DEBUG
+	B43_WARN_ON(dev->phy.radio_locked);
+	dev->phy.radio_locked = 1;
+#endif
+
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
-	B43_WARN_ON(macctl & B43_MACCTL_RADIOLOCK);
 	macctl |= B43_MACCTL_RADIOLOCK;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
-	/* Commit the write and wait for the device
-	 * to exit any radio register access. */
+	/* Commit the write and wait for the firmware
+	 * to finish any radio register access. */
 	b43_read32(dev, B43_MMIO_MACCTL);
 	udelay(10);
 }
@@ -145,11 +149,15 @@ void b43_radio_unlock(struct b43_wldev *
 {
 	u32 macctl;
 
+#if B43_DEBUG
+	B43_WARN_ON(!dev->phy.radio_locked);
+	dev->phy.radio_locked = 0;
+#endif
+
 	/* Commit any write */
 	b43_read16(dev, B43_MMIO_PHY_VER);
 	/* unlock */
 	macctl = b43_read32(dev, B43_MMIO_MACCTL);
-	B43_WARN_ON(!(macctl & B43_MACCTL_RADIOLOCK));
 	macctl &= ~B43_MACCTL_RADIOLOCK;
 	b43_write32(dev, B43_MMIO_MACCTL, macctl);
 }
Index: wireless-testing/drivers/net/wireless/b43/phy_common.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/phy_common.h	2009-03-31 12:02:58.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/phy_common.h	2009-03-31 12:05:54.000000000 +0200
@@ -245,8 +245,10 @@ struct b43_phy {
 	atomic_t txerr_cnt;
 
 #ifdef CONFIG_B43_DEBUG
-	/* PHY registers locked by b43_phy_lock()? */
+	/* PHY registers locked (w.r.t. firmware) */
 	bool phy_locked;
+	/* Radio registers locked (w.r.t. firmware) */
+	bool radio_locked;
 #endif /* B43_DEBUG */
 };
 
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-03-31 12:12:53.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-03-31 12:14:45.000000000 +0200
@@ -3980,6 +3980,11 @@ static void setup_struct_phy_for_init(st
 	phy->next_txpwr_check_time = jiffies;
 	/* PHY TX errors counter. */
 	atomic_set(&phy->txerr_cnt, B43_PHY_TX_BADNESS_LIMIT);
+
+#if B43_DEBUG
+	phy->phy_locked = 0;
+	phy->radio_locked = 0;
+#endif
 }
 
 static void setup_struct_wldev_for_init(struct b43_wldev *dev)

-- 
Greetings, Michael.
