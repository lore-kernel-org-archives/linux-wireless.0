Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35479
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755145AbXISQy1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Sep 2007 12:54:27 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb: Use ioreadX() and iowriteX() for PCI.
Date: Wed, 19 Sep 2007 18:53:44 +0200
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200709191853.44334.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On a PCI bus use ioreadX() and iowriteX().
We map the I/O space with pci_iomap(), so we must use the correct
accessor functions, too.
readX() and writeX() are not guaranteed to accept the cookie returned
from pci_iomap() (though, it currently works on most architectures).

Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: wireless-dev/drivers/ssb/pci.c
===================================================================
--- wireless-dev.orig/drivers/ssb/pci.c	2007-09-19 17:15:58.000000000 +0200
+++ wireless-dev/drivers/ssb/pci.c	2007-09-19 17:31:44.000000000 +0200
@@ -531,7 +531,7 @@ static u16 ssb_pci_read16(struct ssb_dev
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return 0xFFFF;
 	}
-	return readw(bus->mmio + offset);
+	return ioread16(bus->mmio + offset);
 }
 
 static u32 ssb_pci_read32(struct ssb_device *dev, u16 offset)
@@ -544,7 +544,7 @@ static u32 ssb_pci_read32(struct ssb_dev
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return 0xFFFFFFFF;
 	}
-	return readl(bus->mmio + offset);
+	return ioread32(bus->mmio + offset);
 }
 
 static void ssb_pci_write16(struct ssb_device *dev, u16 offset, u16 value)
@@ -557,7 +557,7 @@ static void ssb_pci_write16(struct ssb_d
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return;
 	}
-	writew(value, bus->mmio + offset);
+	iowrite16(value, bus->mmio + offset);
 }
 
 static void ssb_pci_write32(struct ssb_device *dev, u16 offset, u32 value)
@@ -570,7 +570,7 @@ static void ssb_pci_write32(struct ssb_d
 		if (unlikely(ssb_pci_switch_core(bus, dev)))
 			return;
 	}
-	writel(value, bus->mmio + offset);
+	iowrite32(value, bus->mmio + offset);
 }
 
 /* Not "static", as it's used in main.c */
