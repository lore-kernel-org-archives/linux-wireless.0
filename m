Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38712 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab3ACXvx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 18:51:53 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 4/6] bcma: mips: show also disabled IRQs
Date: Fri,  4 Jan 2013 00:51:23 +0100
Message-Id: <1357257085-11822-5-git-send-email-hauke@hauke-m.de> (sfid-20130104_005157_327597_E6A5EF6B)
In-Reply-To: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some cores do not have a IRQ assigned and some do not support when an
IRQ is assigned to them, this is now handled and printed out in the
code.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 486aa2d..6981507 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -74,11 +74,16 @@ static u32 bcma_core_mips_irqflag(struct bcma_device *dev)
 		return dev->core_index;
 	flag = bcma_aread32(dev, BCMA_MIPS_OOBSELOUTA30);
 
-	return flag & 0x1F;
+	if (flag)
+		return flag & 0x1F;
+	else
+		return 0x3f;
 }
 
 /* Get the MIPS IRQ assignment for a specified device.
  * If unassigned, 0 is returned.
+ * If disabled, 5 is returned.
+ * If not supported, 6 is returned.
  */
 unsigned int bcma_core_mips_irq(struct bcma_device *dev)
 {
@@ -87,13 +92,15 @@ unsigned int bcma_core_mips_irq(struct bcma_device *dev)
 	unsigned int irq;
 
 	irqflag = bcma_core_mips_irqflag(dev);
+	if (irqflag == 0x3f)
+		return 6;
 
-	for (irq = 1; irq <= 4; irq++)
+	for (irq = 0; irq <= 4; irq++)
 		if (bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(irq)) &
 		    (1 << irqflag))
 			return irq;
 
-	return 0;
+	return 5;
 }
 EXPORT_SYMBOL(bcma_core_mips_irq);
 
@@ -114,7 +121,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0),
 			    bcma_read32(mdev, BCMA_MIPS_MIPS74K_INTMASK(0)) &
 			    ~(1 << irqflag));
-	else
+	else if (oldirq != 5)
 		bcma_write32(mdev, BCMA_MIPS_MIPS74K_INTMASK(oldirq), 0);
 
 	/* assign the new one */
@@ -144,7 +151,7 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 	}
 
 	bcma_debug(bus, "set_irq: core 0x%04x, irq %d => %d\n",
-		   dev->id.id, oldirq + 2, irq + 2);
+		   dev->id.id, oldirq <= 4 ? oldirq + 2 : 0, irq + 2);
 }
 
 static void bcma_core_mips_set_irq_name(struct bcma_bus *bus, unsigned int irq,
-- 
1.7.10.4

