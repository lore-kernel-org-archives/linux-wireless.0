Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38698 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab3ACXvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 18:51:47 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 3/6] bcma: mips: make some info messages debug messages
Date: Fri,  4 Jan 2013 00:51:22 +0100
Message-Id: <1357257085-11822-4-git-send-email-hauke@hauke-m.de> (sfid-20130104_005153_714092_4144F685)
In-Reply-To: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 171be0f..486aa2d 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -143,8 +143,8 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 			     1 << irqflag);
 	}
 
-	bcma_info(bus, "set_irq: core 0x%04x, irq %d => %d\n",
-		  dev->id.id, oldirq + 2, irq + 2);
+	bcma_debug(bus, "set_irq: core 0x%04x, irq %d => %d\n",
+		   dev->id.id, oldirq + 2, irq + 2);
 }
 
 static void bcma_core_mips_set_irq_name(struct bcma_bus *bus, unsigned int irq,
@@ -167,7 +167,7 @@ static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
 {
 	int i;
 	static const char *irq_name[] = {"2(S)", "3", "4", "5", "6", "D", "I"};
-	printk(KERN_INFO KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
+	printk(KERN_DEBUG KBUILD_MODNAME ": core 0x%04x, irq :", dev->id.id);
 	for (i = 0; i <= 6; i++)
 		printk(" %s%s", irq_name[i], i == irq ? "*" : " ");
 	printk("\n");
@@ -252,7 +252,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 	if (mcore->setup_done)
 		return;
 
-	bcma_info(bus, "Initializing MIPS core...\n");
+	bcma_debug(bus, "Initializing MIPS core...\n");
 
 	bcma_core_mips_early_init(mcore);
 
@@ -300,7 +300,7 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 			 "Unknown device (0x%x) found, can not configure IRQs\n",
 			 bus->chipinfo.id);
 	}
-	bcma_info(bus, "IRQ reconfiguration done\n");
+	bcma_debug(bus, "IRQ reconfiguration done\n");
 	bcma_core_mips_dump_irq(bus);
 
 	mcore->setup_done = true;
-- 
1.7.10.4

