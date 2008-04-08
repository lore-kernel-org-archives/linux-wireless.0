Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vs166246.vserver.de ([62.75.166.246]:60027 "EHLO
	vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbYDHJSj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Apr 2008 05:18:39 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] ssb-mipscore: Fix interrupt vectors
Date: Tue, 8 Apr 2008 11:17:29 +0200
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200804081117.29738.mb@bu3sch.de> (sfid-20080408_101842_395974_2532F8A5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes assignment of the interrupt vectors on the SSB MIPS core.

Signed-off-by: Michael Buesch <mb@bu3sch.de>

---

John, please apply this bugfix to 2.6.25.


Index: wireless-testing/drivers/ssb/driver_mipscore.c
===================================================================
--- wireless-testing.orig/drivers/ssb/driver_mipscore.c	2008-03-22 17:51:22.000000000 +0100
+++ wireless-testing/drivers/ssb/driver_mipscore.c	2008-04-08 11:14:38.000000000 +0200
@@ -106,18 +106,19 @@ static void set_irq(struct ssb_device *d
 	if (oldirq == 0)
 		ssb_write32(mdev, SSB_INTVEC, (~(1 << irqflag) & ssb_read32(mdev, SSB_INTVEC)));
 	else
 		clear_irq(bus, oldirq);
 
 	/* assign the new one */
-	if (irq == 0)
-		ssb_write32(mdev, SSB_INTVEC, ((1 << irqflag) & ssb_read32(mdev, SSB_INTVEC)));
-
-	irqflag <<= ipsflag_irq_shift[irq];
-	irqflag |= (ssb_read32(mdev, SSB_IPSFLAG) & ~ipsflag_irq_mask[irq]);
-	ssb_write32(mdev, SSB_IPSFLAG, irqflag);
+	if (irq == 0) {
+		ssb_write32(mdev, SSB_INTVEC, ((1 << irqflag) | ssb_read32(mdev, SSB_INTVEC)));
+	} else {
+		irqflag <<= ipsflag_irq_shift[irq];
+		irqflag |= (ssb_read32(mdev, SSB_IPSFLAG) & ~ipsflag_irq_mask[irq]);
+		ssb_write32(mdev, SSB_IPSFLAG, irqflag);
+	}
 }
 
 static void ssb_mips_serial_init(struct ssb_mipscore *mcore)
 {
 	struct ssb_bus *bus = mcore->dev->bus;
 
