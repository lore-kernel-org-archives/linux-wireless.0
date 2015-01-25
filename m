Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:62277 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564AbbAYKL2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 05:11:28 -0500
Received: by mail-we0-f173.google.com with SMTP id w62so4489674wes.4
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 02:11:26 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/2] bcma: add early_init function for PCIe core and move some fix into it
Date: Sun, 25 Jan 2015 11:11:14 +0100
Message-Id: <1422180674-9592-2-git-send-email-zajec5@gmail.com> (sfid-20150125_111151_452981_EC0FFDB5)
In-Reply-To: <1422180674-9592-1-git-send-email-zajec5@gmail.com>
References: <1422180674-9592-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are some PCIe core fixes that need to be applied before accessing
SPROM, otherwise reading it may fail.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
This patch may make checkpatch.pl complain about line over 80 columns, but I
only moved this line from another place and it's a bit hard to make it fit 80
columns anyway.
---
 drivers/bcma/driver_pci.c            | 66 ++++++++++++++++++++++++------------
 drivers/bcma/main.c                  |  7 ++++
 include/linux/bcma/bcma_driver_pci.h |  2 ++
 3 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index b85a505..7866664 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -145,6 +145,47 @@ static u16 bcma_pcie_mdio_writeread(struct bcma_drv_pci *pc, u16 device,
 }
 
 /**************************************************
+ * Early init.
+ **************************************************/
+
+static void bcma_core_pci_fixcfg(struct bcma_drv_pci *pc)
+{
+	struct bcma_device *core = pc->core;
+	u16 val16, core_index;
+	uint regoff;
+
+	regoff = BCMA_CORE_PCI_SPROM(BCMA_CORE_PCI_SPROM_PI_OFFSET);
+	core_index = (u16)core->core_index;
+
+	val16 = pcicore_read16(pc, regoff);
+	if (((val16 & BCMA_CORE_PCI_SPROM_PI_MASK) >> BCMA_CORE_PCI_SPROM_PI_SHIFT)
+	     != core_index) {
+		val16 = (core_index << BCMA_CORE_PCI_SPROM_PI_SHIFT) |
+			(val16 & ~BCMA_CORE_PCI_SPROM_PI_MASK);
+		pcicore_write16(pc, regoff, val16);
+	}
+}
+
+/*
+ * Apply some early fixes required before accessing SPROM.
+ * See also si_pci_fixcfg.
+ */
+void bcma_core_pci_early_init(struct bcma_drv_pci *pc)
+{
+	if (pc->early_setup_done)
+		return;
+
+	pc->hostmode = bcma_core_pci_is_in_hostmode(pc);
+	if (pc->hostmode)
+		goto out;
+
+	bcma_core_pci_fixcfg(pc);
+
+out:
+	pc->early_setup_done = true;
+}
+
+/**************************************************
  * Workarounds.
  **************************************************/
 
@@ -175,24 +216,6 @@ static void bcma_pcicore_serdes_workaround(struct bcma_drv_pci *pc)
 		                     tmp & ~BCMA_CORE_PCI_PLL_CTRL_FREQDET_EN);
 }
 
-static void bcma_core_pci_fixcfg(struct bcma_drv_pci *pc)
-{
-	struct bcma_device *core = pc->core;
-	u16 val16, core_index;
-	uint regoff;
-
-	regoff = BCMA_CORE_PCI_SPROM(BCMA_CORE_PCI_SPROM_PI_OFFSET);
-	core_index = (u16)core->core_index;
-
-	val16 = pcicore_read16(pc, regoff);
-	if (((val16 & BCMA_CORE_PCI_SPROM_PI_MASK) >> BCMA_CORE_PCI_SPROM_PI_SHIFT)
-	     != core_index) {
-		val16 = (core_index << BCMA_CORE_PCI_SPROM_PI_SHIFT) |
-			(val16 & ~BCMA_CORE_PCI_SPROM_PI_MASK);
-		pcicore_write16(pc, regoff, val16);
-	}
-}
-
 /* Fix MISC config to allow coming out of L2/L3-Ready state w/o PRST */
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void bcma_core_pci_config_fixup(struct bcma_drv_pci *pc)
@@ -216,7 +239,6 @@ static void bcma_core_pci_config_fixup(struct bcma_drv_pci *pc)
 
 static void bcma_core_pci_clientmode_init(struct bcma_drv_pci *pc)
 {
-	bcma_core_pci_fixcfg(pc);
 	bcma_pcicore_serdes_workaround(pc);
 	bcma_core_pci_config_fixup(pc);
 }
@@ -226,11 +248,11 @@ void bcma_core_pci_init(struct bcma_drv_pci *pc)
 	if (pc->setup_done)
 		return;
 
-	pc->hostmode = bcma_core_pci_is_in_hostmode(pc);
+	bcma_core_pci_early_init(pc);
+
 	if (pc->hostmode)
 		bcma_core_pci_hostmode_init(pc);
-
-	if (!pc->hostmode)
+	else
 		bcma_core_pci_clientmode_init(pc);
 }
 
diff --git a/drivers/bcma/main.c b/drivers/bcma/main.c
index 73b2ee3..38bde6e 100644
--- a/drivers/bcma/main.c
+++ b/drivers/bcma/main.c
@@ -402,6 +402,13 @@ int bcma_bus_register(struct bcma_bus *bus)
 		bcma_core_chipcommon_early_init(&bus->drv_cc);
 	}
 
+	/* Early init PCIE core */
+	core = bcma_find_core(bus, BCMA_CORE_PCIE);
+	if (core) {
+		bus->drv_pci[0].core = core;
+		bcma_core_pci_early_init(&bus->drv_pci[0]);
+	}
+
 	/* Cores providing flash access go before SPROM init */
 	list_for_each_entry(core, &bus->cores, list) {
 		if (bcma_is_core_needed_early(core->id.id))
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 0333e60..3f809ae 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -223,6 +223,7 @@ struct bcma_drv_pci_host {
 
 struct bcma_drv_pci {
 	struct bcma_device *core;
+	u8 early_setup_done:1;
 	u8 setup_done:1;
 	u8 hostmode:1;
 
@@ -237,6 +238,7 @@ struct bcma_drv_pci {
 #define pcicore_write16(pc, offset, val)	bcma_write16((pc)->core, offset, val)
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
+extern void bcma_core_pci_early_init(struct bcma_drv_pci *pc);
 extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
-- 
1.8.4.5

