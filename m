Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:34514 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752841AbYFSRlD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 13:41:03 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] b43: Add mask/set capability to debugfs MMIO interface
Date: Thu, 19 Jun 2008 19:38:32 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200806191938.33048.mb@bu3sch.de> (sfid-20080619_194107_922352_7816675B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds an atomic mask/set capability to the debugfs MMIO interface.
This is needed to support mask and/or set operations from the userspace
debugging tools.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please queue this for 2.6.27


Index: wireless-testing/drivers/net/wireless/b43/debugfs.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/b43/debugfs.c	2008-06-19 12:49:10.000000000 +0200
+++ wireless-testing/drivers/net/wireless/b43/debugfs.c	2008-06-19 16:02:54.000000000 +0200
@@ -264,32 +264,43 @@ static int mmio16read__write_file(struct
 
 	res = sscanf(buf, "0x%X", &addr);
 	if (res != 1)
 		return -EINVAL;
 	if (addr > B43_MAX_MMIO_ACCESS)
 		return -EADDRNOTAVAIL;
+	if ((addr % 2) != 0)
+		return -EINVAL;
 
 	dev->dfsentry->mmio16read_next = addr;
 
 	return 0;
 }
 
 static int mmio16write__write_file(struct b43_wldev *dev,
 				   const char *buf, size_t count)
 {
-	unsigned int addr, val;
+	unsigned int addr, mask, set;
 	int res;
+	u16 val;
 
-	res = sscanf(buf, "0x%X = 0x%X", &addr, &val);
-	if (res != 2)
+	res = sscanf(buf, "0x%X 0x%X 0x%X", &addr, &mask, &set);
+	if (res != 3)
 		return -EINVAL;
 	if (addr > B43_MAX_MMIO_ACCESS)
 		return -EADDRNOTAVAIL;
-	if (val > 0xFFFF)
+	if ((mask > 0xFFFF) || (set > 0xFFFF))
 		return -E2BIG;
+	if ((addr % 2) != 0)
+		return -EINVAL;
 
+	if (mask == 0)
+		val = 0;
+	else
+		val = b43_read16(dev, addr);
+	val &= mask;
+	val |= set;
 	b43_write16(dev, addr, val);
 
 	return 0;
 }
 
 static ssize_t mmio32read__read_file(struct b43_wldev *dev,
@@ -317,32 +328,43 @@ static int mmio32read__write_file(struct
 
 	res = sscanf(buf, "0x%X", &addr);
 	if (res != 1)
 		return -EINVAL;
 	if (addr > B43_MAX_MMIO_ACCESS)
 		return -EADDRNOTAVAIL;
+	if ((addr % 4) != 0)
+		return -EINVAL;
 
 	dev->dfsentry->mmio32read_next = addr;
 
 	return 0;
 }
 
 static int mmio32write__write_file(struct b43_wldev *dev,
 				   const char *buf, size_t count)
 {
-	unsigned int addr, val;
+	unsigned int addr, mask, set;
 	int res;
+	u32 val;
 
-	res = sscanf(buf, "0x%X = 0x%X", &addr, &val);
-	if (res != 2)
+	res = sscanf(buf, "0x%X 0x%X 0x%X", &addr, &mask, &set);
+	if (res != 3)
 		return -EINVAL;
 	if (addr > B43_MAX_MMIO_ACCESS)
 		return -EADDRNOTAVAIL;
-	if (val > 0xFFFFFFFF)
+	if ((mask > 0xFFFFFFFF) || (set > 0xFFFFFFFF))
 		return -E2BIG;
+	if ((addr % 4) != 0)
+		return -EINVAL;
 
+	if (mask == 0)
+		val = 0;
+	else
+		val = b43_read32(dev, addr);
+	val &= mask;
+	val |= set;
 	b43_write32(dev, addr, val);
 
 	return 0;
 }
 
 /* wl->irq_lock is locked */
