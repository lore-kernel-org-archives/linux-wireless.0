Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60371 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbXLVU5b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Dec 2007 15:57:31 -0500
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Fix chip access validation for new devices
Date: Sat, 22 Dec 2007 21:56:30 +0100
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200712222156.31112.mb@bu3sch.de> (sfid-20071222_205733_935990_6FA6B0D1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes chip access validation for newer devices
(4318 and up, I think)

This patch fixes probing of a PCMCIA based 4318 device.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-2.6/drivers/net/wireless/b43/b43.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/b43.h	2007-12-12 19:54:27.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/b43.h	2007-12-12 19:55:57.000000000 +0100
@@ -50,6 +50,9 @@
 #define B43_MMIO_XMITSTAT_1		0x174
 #define B43_MMIO_REV3PLUS_TSF_LOW	0x180	/* core rev >= 3 only */
 #define B43_MMIO_REV3PLUS_TSF_HIGH	0x184	/* core rev >= 3 only */
+#define B43_MMIO_TSF_CFP_REP		0x188
+#define B43_MMIO_TSF_CFP_START		0x18C
+#define B43_MMIO_TSF_CFP_MAXDUR		0x190
 
 /* 32-bit DMA */
 #define B43_MMIO_DMA32_BASE0		0x200
@@ -88,6 +91,8 @@
 #define B43_MMIO_RADIO_HWENABLED_LO	0x49A
 #define B43_MMIO_GPIO_CONTROL		0x49C
 #define B43_MMIO_GPIO_MASK		0x49E
+#define B43_MMIO_TSF_CFP_START_LOW	0x604
+#define B43_MMIO_TSF_CFP_START_HIGH	0x606
 #define B43_MMIO_TSF_0			0x632	/* core rev < 3 only */
 #define B43_MMIO_TSF_1			0x634	/* core rev < 3 only */
 #define B43_MMIO_TSF_2			0x636	/* core rev < 3 only */
Index: wireless-2.6/drivers/net/wireless/b43/main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/b43/main.c	2007-12-12 19:55:53.000000000 +0100
+++ wireless-2.6/drivers/net/wireless/b43/main.c	2007-12-12 19:55:57.000000000 +0100
@@ -2408,32 +2408,42 @@ static void b43_periodic_tasks_setup(str
 	queue_delayed_work(dev->wl->hw->workqueue, work, 0);
 }
 
-/* Validate access to the chip (SHM) */
+/* Check if communication with the device works correctly. */
 static int b43_validate_chipaccess(struct b43_wldev *dev)
 {
-	u32 value;
-	u32 shm_backup;
+	u32 v, backup;
 
-	shm_backup = b43_shm_read32(dev, B43_SHM_SHARED, 0);
-	b43_shm_write32(dev, B43_SHM_SHARED, 0, 0xAA5555AA);
-	if (b43_shm_read32(dev, B43_SHM_SHARED, 0) != 0xAA5555AA)
-		goto error;
+	backup = b43_shm_read32(dev, B43_SHM_SHARED, 0);
+
+	/* Check for read/write and endianness problems. */
 	b43_shm_write32(dev, B43_SHM_SHARED, 0, 0x55AAAA55);
 	if (b43_shm_read32(dev, B43_SHM_SHARED, 0) != 0x55AAAA55)
 		goto error;
-	b43_shm_write32(dev, B43_SHM_SHARED, 0, shm_backup);
-
-	value = b43_read32(dev, B43_MMIO_MACCTL);
-	if ((value | B43_MACCTL_GMODE) !=
-	    (B43_MACCTL_GMODE | B43_MACCTL_IHR_ENABLED))
+	b43_shm_write32(dev, B43_SHM_SHARED, 0, 0xAA5555AA);
+	if (b43_shm_read32(dev, B43_SHM_SHARED, 0) != 0xAA5555AA)
 		goto error;
 
-	value = b43_read32(dev, B43_MMIO_GEN_IRQ_REASON);
-	if (value)
+	b43_shm_write32(dev, B43_SHM_SHARED, 0, backup);
+
+	if ((dev->dev->id.revision >= 3) && (dev->dev->id.revision <= 10)) {
+		/* The 32bit register shadows the two 16bit registers
+		 * with update sideeffects. Validate this. */
+		b43_write16(dev, B43_MMIO_TSF_CFP_START, 0xAAAA);
+		b43_write32(dev, B43_MMIO_TSF_CFP_START, 0xCCCCBBBB);
+		if (b43_read16(dev, B43_MMIO_TSF_CFP_START_LOW) != 0xBBBB)
+			goto error;
+		if (b43_read16(dev, B43_MMIO_TSF_CFP_START_HIGH) != 0xCCCC)
+			goto error;
+	}
+	b43_write32(dev, B43_MMIO_TSF_CFP_START, 0);
+
+	v = b43_read32(dev, B43_MMIO_MACCTL);
+	v |= B43_MACCTL_GMODE;
+	if (v != (B43_MACCTL_GMODE | B43_MACCTL_IHR_ENABLED))
 		goto error;
 
 	return 0;
-      error:
+error:
 	b43err(dev->wl, "Failed to validate the chipaccess\n");
 	return -ENODEV;
 }
