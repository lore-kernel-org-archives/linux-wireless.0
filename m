Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:50222 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752860AbZGaS5l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 31 Jul 2009 14:57:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John W Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix unaligned 32bit SHM-shared access
Date: Fri, 31 Jul 2009 20:51:41 +0200
Cc: bcm43xx-dev@lists.berlios.de,
	wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200907312051.41457.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes unaligned 32bit SHM-shared read/write access.
The low and high 16 bits were swapped.
It also adds a testcase for this to the chipaccess validation.

(Thanks to Albert Herranz for tracking down this bug.)

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

This patch does _not_ need to be pushed as a bugfix, because we currently
do not use unaligned 32bit SHM-shared access.


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-07-31 20:36:18.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-07-31 20:42:48.000000000 +0200
@@ -392,15 +392,14 @@ u32 __b43_shm_read32(struct b43_wldev *d
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
 		if (offset & 0x0003) {
 			/* Unaligned access */
 			b43_shm_control_word(dev, routing, offset >> 2);
 			ret = b43_read16(dev, B43_MMIO_SHM_DATA_UNALIGNED);
-			ret <<= 16;
 			b43_shm_control_word(dev, routing, (offset >> 2) + 1);
-			ret |= b43_read16(dev, B43_MMIO_SHM_DATA);
+			ret |= ((u32)b43_read16(dev, B43_MMIO_SHM_DATA)) << 16;
 
 			goto out;
 		}
 		offset >>= 2;
 	}
 	b43_shm_control_word(dev, routing, offset);
@@ -461,15 +460,16 @@ void __b43_shm_write32(struct b43_wldev 
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
 		if (offset & 0x0003) {
 			/* Unaligned access */
 			b43_shm_control_word(dev, routing, offset >> 2);
 			b43_write16(dev, B43_MMIO_SHM_DATA_UNALIGNED,
-				    (value >> 16) & 0xffff);
+				    value & 0xFFFF);
 			b43_shm_control_word(dev, routing, (offset >> 2) + 1);
-			b43_write16(dev, B43_MMIO_SHM_DATA, value & 0xffff);
+			b43_write16(dev, B43_MMIO_SHM_DATA,
+				    (value >> 16) & 0xFFFF);
 			return;
 		}
 		offset >>= 2;
 	}
 	b43_shm_control_word(dev, routing, offset);
 	b43_write32(dev, B43_MMIO_SHM_DATA, value);
@@ -2928,25 +2928,42 @@ static void b43_periodic_tasks_setup(str
 	queue_delayed_work(dev->wl->hw->workqueue, work, 0);
 }
 
 /* Check if communication with the device works correctly. */
 static int b43_validate_chipaccess(struct b43_wldev *dev)
 {
-	u32 v, backup;
+	u32 v, backup0, backup4;
 
-	backup = b43_shm_read32(dev, B43_SHM_SHARED, 0);
+	backup0 = b43_shm_read32(dev, B43_SHM_SHARED, 0);
+	backup4 = b43_shm_read32(dev, B43_SHM_SHARED, 4);
 
 	/* Check for read/write and endianness problems. */
 	b43_shm_write32(dev, B43_SHM_SHARED, 0, 0x55AAAA55);
 	if (b43_shm_read32(dev, B43_SHM_SHARED, 0) != 0x55AAAA55)
 		goto error;
 	b43_shm_write32(dev, B43_SHM_SHARED, 0, 0xAA5555AA);
 	if (b43_shm_read32(dev, B43_SHM_SHARED, 0) != 0xAA5555AA)
 		goto error;
 
-	b43_shm_write32(dev, B43_SHM_SHARED, 0, backup);
+	/* Check if unaligned 32bit SHM_SHARED access works properly.
+	 * However, don't bail out on failure, because it's noncritical. */
+	b43_shm_write16(dev, B43_SHM_SHARED, 0, 0x1122);
+	b43_shm_write16(dev, B43_SHM_SHARED, 2, 0x3344);
+	b43_shm_write16(dev, B43_SHM_SHARED, 4, 0x5566);
+	b43_shm_write16(dev, B43_SHM_SHARED, 6, 0x7788);
+	if (b43_shm_read32(dev, B43_SHM_SHARED, 2) != 0x55663344)
+		b43warn(dev->wl, "Unaligned 32bit SHM read access is broken\n");
+	b43_shm_write32(dev, B43_SHM_SHARED, 2, 0xAABBCCDD);
+	if (b43_shm_read16(dev, B43_SHM_SHARED, 0) != 0x1122 ||
+	    b43_shm_read16(dev, B43_SHM_SHARED, 2) != 0xCCDD ||
+	    b43_shm_read16(dev, B43_SHM_SHARED, 4) != 0xAABB ||
+	    b43_shm_read16(dev, B43_SHM_SHARED, 6) != 0x7788)
+		b43warn(dev->wl, "Unaligned 32bit SHM write access is broken\n");
+
+	b43_shm_write32(dev, B43_SHM_SHARED, 0, backup0);
+	b43_shm_write32(dev, B43_SHM_SHARED, 4, backup4);
 
 	if ((dev->dev->id.revision >= 3) && (dev->dev->id.revision <= 10)) {
 		/* The 32bit register shadows the two 16bit registers
 		 * with update sideeffects. Validate this. */
 		b43_write16(dev, B43_MMIO_TSF_CFP_START, 0xAAAA);
 		b43_write32(dev, B43_MMIO_TSF_CFP_START, 0xCCCCBBBB);

-- 
Greetings, Michael.
