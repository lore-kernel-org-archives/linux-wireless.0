Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:38693 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab3ACXvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jan 2013 18:51:47 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	nlhintz@hotmail.com, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/6] bcma: mips: explicit assign IRQ numbers
Date: Fri,  4 Jan 2013 00:51:21 +0100
Message-Id: <1357257085-11822-3-git-send-email-hauke@hauke-m.de> (sfid-20130104_005152_864440_1291B6C5)
In-Reply-To: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
References: <1357257085-11822-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The assignment of the IRQs to the cores of the chips by iterating over
the cores is complicated and causes problems with SoC like the BCM4706
with two GMAC core where just one should get a dedicated IRQ number.
Now the code assigns the same IRQs to the cores as the code from the
Broadcom SDK does. If the SoC is not know the current assigned IRQs are
only read out and an error message is printed.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/bcma/driver_mips.c |   84 +++++++++++++++++++++++++++++---------------
 1 file changed, 56 insertions(+), 28 deletions(-)

diff --git a/drivers/bcma/driver_mips.c b/drivers/bcma/driver_mips.c
index 792daad..171be0f 100644
--- a/drivers/bcma/driver_mips.c
+++ b/drivers/bcma/driver_mips.c
@@ -147,6 +147,22 @@ static void bcma_core_mips_set_irq(struct bcma_device *dev, unsigned int irq)
 		  dev->id.id, oldirq + 2, irq + 2);
 }
 
+static void bcma_core_mips_set_irq_name(struct bcma_bus *bus, unsigned int irq,
+					u16 coreid, u8 unit)
+{
+	struct bcma_device *core;
+
+	core = bcma_find_core_unit(bus, coreid, unit);
+	if (!core) {
+		bcma_warn(bus,
+			  "Can not find core (id: 0x%x, unit %i) for IRQ configuration.\n",
+			  coreid, unit);
+		return;
+	}
+
+	bcma_core_mips_set_irq(core, irq);
+}
+
 static void bcma_core_mips_print_irq(struct bcma_device *dev, unsigned int irq)
 {
 	int i;
@@ -242,35 +258,47 @@ void bcma_core_mips_init(struct bcma_drv_mips *mcore)
 
 	mcore->assigned_irqs = 1;
 
-	/* Assign IRQs to all cores on the bus */
-	list_for_each_entry(core, &bus->cores, list) {
-		int mips_irq;
-		if (core->irq)
-			continue;
-
-		mips_irq = bcma_core_mips_irq(core);
-		if (mips_irq > 4)
-			core->irq = 0;
-		else
-			core->irq = mips_irq + 2;
-		if (core->irq > 5)
-			continue;
-		switch (core->id.id) {
-		case BCMA_CORE_PCI:
-		case BCMA_CORE_PCIE:
-		case BCMA_CORE_ETHERNET:
-		case BCMA_CORE_ETHERNET_GBIT:
-		case BCMA_CORE_MAC_GBIT:
-		case BCMA_CORE_80211:
-		case BCMA_CORE_USB20_HOST:
-			/* These devices get their own IRQ line if available,
-			 * the rest goes on IRQ0
-			 */
-			if (mcore->assigned_irqs <= 4)
-				bcma_core_mips_set_irq(core,
-						       mcore->assigned_irqs++);
-			break;
+	switch (bus->chipinfo.id) {
+	case BCMA_CHIP_ID_BCM4716:
+	case BCMA_CHIP_ID_BCM4748:
+		bcma_core_mips_set_irq_name(bus, 1, BCMA_CORE_80211, 0);
+		bcma_core_mips_set_irq_name(bus, 2, BCMA_CORE_MAC_GBIT, 0);
+		bcma_core_mips_set_irq_name(bus, 3, BCMA_CORE_USB20_HOST, 0);
+		bcma_core_mips_set_irq_name(bus, 4, BCMA_CORE_PCIE, 0);
+		bcma_core_mips_set_irq_name(bus, 0, BCMA_CORE_CHIPCOMMON, 0);
+		bcma_core_mips_set_irq_name(bus, 0, BCMA_CORE_I2S, 0);
+		break;
+	case BCMA_CHIP_ID_BCM5356:
+	case BCMA_CHIP_ID_BCM47162:
+	case BCMA_CHIP_ID_BCM53572:
+		bcma_core_mips_set_irq_name(bus, 1, BCMA_CORE_80211, 0);
+		bcma_core_mips_set_irq_name(bus, 2, BCMA_CORE_MAC_GBIT, 0);
+		bcma_core_mips_set_irq_name(bus, 0, BCMA_CORE_CHIPCOMMON, 0);
+		break;
+	case BCMA_CHIP_ID_BCM5357:
+	case BCMA_CHIP_ID_BCM4749:
+		bcma_core_mips_set_irq_name(bus, 1, BCMA_CORE_80211, 0);
+		bcma_core_mips_set_irq_name(bus, 2, BCMA_CORE_MAC_GBIT, 0);
+		bcma_core_mips_set_irq_name(bus, 3, BCMA_CORE_USB20_HOST, 0);
+		bcma_core_mips_set_irq_name(bus, 0, BCMA_CORE_CHIPCOMMON, 0);
+		bcma_core_mips_set_irq_name(bus, 0, BCMA_CORE_I2S, 0);
+		break;
+	case BCMA_CHIP_ID_BCM4706:
+		bcma_core_mips_set_irq_name(bus, 1, BCMA_CORE_PCIE, 0);
+		bcma_core_mips_set_irq_name(bus, 2, BCMA_CORE_4706_MAC_GBIT,
+					    0);
+		bcma_core_mips_set_irq_name(bus, 3, BCMA_CORE_PCIE, 1);
+		bcma_core_mips_set_irq_name(bus, 4, BCMA_CORE_USB20_HOST, 0);
+		bcma_core_mips_set_irq_name(bus, 0, BCMA_CORE_4706_CHIPCOMMON,
+					    0);
+		break;
+	default:
+		list_for_each_entry(core, &bus->cores, list) {
+			core->irq = bcma_core_irq(core);
 		}
+		bcma_err(bus,
+			 "Unknown device (0x%x) found, can not configure IRQs\n",
+			 bus->chipinfo.id);
 	}
 	bcma_info(bus, "IRQ reconfiguration done\n");
 	bcma_core_mips_dump_irq(bus);
-- 
1.7.10.4

