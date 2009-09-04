Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34180 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934284AbZIDU6R (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Sep 2009 16:58:17 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH 5/5] b43: remove SHM spinlock
Date: Fri, 4 Sep 2009 22:57:26 +0200
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	"linux-wireless" <linux-wireless@vger.kernel.org>,
	Albert Herranz <albert_herranz@yahoo.es>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200909042257.26810.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This removes the SHM spinlock.
SHM is protected by wl->mutex.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-testing/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/b43.h	2009-09-04 22:18:48.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/b43.h	2009-09-04 22:18:58.000000000 +0200
@@ -635,8 +635,6 @@ struct b43_wl {
 	rwlock_t tx_lock;
 	/* Lock for LEDs access. */
 	spinlock_t leds_lock;
-	/* Lock for SHM access. */
-	spinlock_t shm_lock;
 
 	/* We can only have one operating interface (802.11 core)
 	 * at a time. General information about this interface follows.
Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2009-09-04 22:18:42.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2009-09-04 22:18:58.000000000 +0200
@@ -125,7 +125,6 @@ static int shm16write__write_file(struct
 	unsigned int routing, addr, mask, set;
 	u16 val;
 	int res;
-	unsigned long flags;
 
 	res = sscanf(buf, "0x%X 0x%X 0x%X 0x%X",
 		     &routing, &addr, &mask, &set);
@@ -142,15 +141,13 @@ static int shm16write__write_file(struct
 	if ((mask > 0xFFFF) || (set > 0xFFFF))
 		return -E2BIG;
 
-	spin_lock_irqsave(&dev->wl->shm_lock, flags);
 	if (mask == 0)
 		val = 0;
 	else
-		val = __b43_shm_read16(dev, routing, addr);
+		val = b43_shm_read16(dev, routing, addr);
 	val &= mask;
 	val |= set;
-	__b43_shm_write16(dev, routing, addr, val);
-	spin_unlock_irqrestore(&dev->wl->shm_lock, flags);
+	b43_shm_write16(dev, routing, addr, val);
 
 	return 0;
 }
@@ -204,7 +201,6 @@ static int shm32write__write_file(struct
 	unsigned int routing, addr, mask, set;
 	u32 val;
 	int res;
-	unsigned long flags;
 
 	res = sscanf(buf, "0x%X 0x%X 0x%X 0x%X",
 		     &routing, &addr, &mask, &set);
@@ -221,15 +217,13 @@ static int shm32write__write_file(struct
 	if ((mask > 0xFFFFFFFF) || (set > 0xFFFFFFFF))
 		return -E2BIG;
 
-	spin_lock_irqsave(&dev->wl->shm_lock, flags);
 	if (mask == 0)
 		val = 0;
 	else
-		val = __b43_shm_read32(dev, routing, addr);
+		val = b43_shm_read32(dev, routing, addr);
 	val &= mask;
 	val |= set;
-	__b43_shm_write32(dev, routing, addr, val);
-	spin_unlock_irqrestore(&dev->wl->shm_lock, flags);
+	b43_shm_write32(dev, routing, addr, val);
 
 	return 0;
 }
Index: wireless-testing/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.c	2009-09-04 22:18:54.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.c	2009-09-04 22:18:58.000000000 +0200
@@ -390,7 +390,7 @@ static inline void b43_shm_control_word(
 	b43_write32(dev, B43_MMIO_SHM_CONTROL, control);
 }
 
-u32 __b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset)
+u32 b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset)
 {
 	u32 ret;
 
@@ -413,20 +413,7 @@ out:
 	return ret;
 }
 
-u32 b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset)
-{
-	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
-	u32 ret;
-
-	spin_lock_irqsave(&wl->shm_lock, flags);
-	ret = __b43_shm_read32(dev, routing, offset);
-	spin_unlock_irqrestore(&wl->shm_lock, flags);
-
-	return ret;
-}
-
-u16 __b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset)
+u16 b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset)
 {
 	u16 ret;
 
@@ -447,20 +434,7 @@ out:
 	return ret;
 }
 
-u16 b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset)
-{
-	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
-	u16 ret;
-
-	spin_lock_irqsave(&wl->shm_lock, flags);
-	ret = __b43_shm_read16(dev, routing, offset);
-	spin_unlock_irqrestore(&wl->shm_lock, flags);
-
-	return ret;
-}
-
-void __b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value)
+void b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value)
 {
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
@@ -480,17 +454,7 @@ void __b43_shm_write32(struct b43_wldev 
 	b43_write32(dev, B43_MMIO_SHM_DATA, value);
 }
 
-void b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value)
-{
-	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
-
-	spin_lock_irqsave(&wl->shm_lock, flags);
-	__b43_shm_write32(dev, routing, offset, value);
-	spin_unlock_irqrestore(&wl->shm_lock, flags);
-}
-
-void __b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
+void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
 {
 	if (routing == B43_SHM_SHARED) {
 		B43_WARN_ON(offset & 0x0001);
@@ -506,16 +470,6 @@ void __b43_shm_write16(struct b43_wldev 
 	b43_write16(dev, B43_MMIO_SHM_DATA, value);
 }
 
-void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value)
-{
-	struct b43_wl *wl = dev->wl;
-	unsigned long flags;
-
-	spin_lock_irqsave(&wl->shm_lock, flags);
-	__b43_shm_write16(dev, routing, offset, value);
-	spin_unlock_irqrestore(&wl->shm_lock, flags);
-}
-
 /* Read HostFlags */
 u64 b43_hf_read(struct b43_wldev *dev)
 {
@@ -4866,7 +4820,6 @@ static int b43_wireless_init(struct ssb_
 	/* Initialize struct b43_wl */
 	wl->hw = hw;
 	spin_lock_init(&wl->leds_lock);
-	spin_lock_init(&wl->shm_lock);
 	mutex_init(&wl->mutex);
 	spin_lock_init(&wl->hardirq_lock);
 	INIT_LIST_HEAD(&wl->devlist);
Index: wireless-testing/drivers/net/wireless/b43/main.h
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/main.h	2009-09-04 22:15:29.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/main.h	2009-09-04 22:18:58.000000000 +0200
@@ -112,13 +112,9 @@ void b43_tsf_read(struct b43_wldev *dev,
 void b43_tsf_write(struct b43_wldev *dev, u64 tsf);
 
 u32 b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset);
-u32 __b43_shm_read32(struct b43_wldev *dev, u16 routing, u16 offset);
 u16 b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset);
-u16 __b43_shm_read16(struct b43_wldev *dev, u16 routing, u16 offset);
 void b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value);
-void __b43_shm_write32(struct b43_wldev *dev, u16 routing, u16 offset, u32 value);
 void b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value);
-void __b43_shm_write16(struct b43_wldev *dev, u16 routing, u16 offset, u16 value);
 
 u64 b43_hf_read(struct b43_wldev *dev);
 void b43_hf_write(struct b43_wldev *dev, u64 value);

-- 
Greetings, Michael.
