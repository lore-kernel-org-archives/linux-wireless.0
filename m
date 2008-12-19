Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:48124 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754601AbYLSV4E (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Dec 2008 16:56:04 -0500
From: Michael Buesch <mb@bu3sch.de>
To: linville@tuxdriver.com
Subject: [PATCH] b43: Use 64bit atomic register access for TSF
Date: Fri, 19 Dec 2008 22:51:57 +0100
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de
MIME-Version: 1.0
Message-Id: <200812192251.57673.mb@bu3sch.de> (sfid-20081219_225622_592066_0BB31D6B)
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On modern b43 devices with core rev >=3, the hardware guarantees us an
atomic 64bit read/write of the TSF, if we access the lower 32bits first.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

For 2.6.29


Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2008-12-19 21:17:44.000000000 +0100
+++ wireless-testing/drivers/net/wireless/b43/main.c	2008-12-19 22:19:22.000000000 +0100
@@ -523,58 +523,26 @@ void b43_hf_write(struct b43_wldev *dev,
 	hi = (value & 0xFFFF00000000ULL) >> 32;
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFLO, lo);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFMI, mi);
 	b43_shm_write16(dev, B43_SHM_SHARED, B43_SHM_SH_HOSTFHI, hi);
 }
 
-void b43_tsf_read(struct b43_wldev *dev, u64 * tsf)
+void b43_tsf_read(struct b43_wldev *dev, u64 *tsf)
 {
-	/* We need to be careful. As we read the TSF from multiple
-	 * registers, we should take care of register overflows.
-	 * In theory, the whole tsf read process should be atomic.
-	 * We try to be atomic here, by restaring the read process,
-	 * if any of the high registers changed (overflew).
-	 */
-	if (dev->dev->id.revision >= 3) {
-		u32 low, high, high2;
+	u32 low, high;
 
-		do {
-			high = b43_read32(dev, B43_MMIO_REV3PLUS_TSF_HIGH);
-			low = b43_read32(dev, B43_MMIO_REV3PLUS_TSF_LOW);
-			high2 = b43_read32(dev, B43_MMIO_REV3PLUS_TSF_HIGH);
-		} while (unlikely(high != high2));
-
-		*tsf = high;
-		*tsf <<= 32;
-		*tsf |= low;
-	} else {
-		u64 tmp;
-		u16 v0, v1, v2, v3;
-		u16 test1, test2, test3;
-
-		do {
-			v3 = b43_read16(dev, B43_MMIO_TSF_3);
-			v2 = b43_read16(dev, B43_MMIO_TSF_2);
-			v1 = b43_read16(dev, B43_MMIO_TSF_1);
-			v0 = b43_read16(dev, B43_MMIO_TSF_0);
-
-			test3 = b43_read16(dev, B43_MMIO_TSF_3);
-			test2 = b43_read16(dev, B43_MMIO_TSF_2);
-			test1 = b43_read16(dev, B43_MMIO_TSF_1);
-		} while (v3 != test3 || v2 != test2 || v1 != test1);
-
-		*tsf = v3;
-		*tsf <<= 48;
-		tmp = v2;
-		tmp <<= 32;
-		*tsf |= tmp;
-		tmp = v1;
-		tmp <<= 16;
-		*tsf |= tmp;
-		*tsf |= v0;
-	}
+	B43_WARN_ON(dev->dev->id.revision < 3);
+
+	/* The hardware guarantees us an atomic read, if we
+	 * read the low register first. */
+	low = b43_read32(dev, B43_MMIO_REV3PLUS_TSF_LOW);
+	high = b43_read32(dev, B43_MMIO_REV3PLUS_TSF_HIGH);
+
+	*tsf = high;
+	*tsf <<= 32;
+	*tsf |= low;
 }
 
 static void b43_time_lock(struct b43_wldev *dev)
 {
 	u32 macctl;
 
@@ -595,41 +563,24 @@ static void b43_time_unlock(struct b43_w
 	/* Commit the write */
 	b43_read32(dev, B43_MMIO_MACCTL);
 }
 
 static void b43_tsf_write_locked(struct b43_wldev *dev, u64 tsf)
 {
-	/* Be careful with the in-progress timer.
-	 * First zero out the low register, so we have a full
-	 * register-overflow duration to complete the operation.
-	 */
-	if (dev->dev->id.revision >= 3) {
-		u32 lo = (tsf & 0x00000000FFFFFFFFULL);
-		u32 hi = (tsf & 0xFFFFFFFF00000000ULL) >> 32;
+	u32 low, high;
 
-		b43_write32(dev, B43_MMIO_REV3PLUS_TSF_LOW, 0);
-		mmiowb();
-		b43_write32(dev, B43_MMIO_REV3PLUS_TSF_HIGH, hi);
-		mmiowb();
-		b43_write32(dev, B43_MMIO_REV3PLUS_TSF_LOW, lo);
-	} else {
-		u16 v0 = (tsf & 0x000000000000FFFFULL);
-		u16 v1 = (tsf & 0x00000000FFFF0000ULL) >> 16;
-		u16 v2 = (tsf & 0x0000FFFF00000000ULL) >> 32;
-		u16 v3 = (tsf & 0xFFFF000000000000ULL) >> 48;
+	B43_WARN_ON(dev->dev->id.revision < 3);
 
-		b43_write16(dev, B43_MMIO_TSF_0, 0);
-		mmiowb();
-		b43_write16(dev, B43_MMIO_TSF_3, v3);
-		mmiowb();
-		b43_write16(dev, B43_MMIO_TSF_2, v2);
-		mmiowb();
-		b43_write16(dev, B43_MMIO_TSF_1, v1);
-		mmiowb();
-		b43_write16(dev, B43_MMIO_TSF_0, v0);
-	}
+	low = tsf;
+	high = (tsf >> 32);
+	/* The hardware guarantees us an atomic write, if we
+	 * write the low register first. */
+	b43_write32(dev, B43_MMIO_REV3PLUS_TSF_LOW, low);
+	mmiowb();
+	b43_write32(dev, B43_MMIO_REV3PLUS_TSF_HIGH, high);
+	mmiowb();
 }
 
 void b43_tsf_write(struct b43_wldev *dev, u64 tsf)
 {
 	b43_time_lock(dev);
 	b43_tsf_write_locked(dev, tsf);

-- 
Greetings, Michael.
