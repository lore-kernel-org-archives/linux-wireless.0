Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:39010 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbBHQL6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 11:11:58 -0500
Received: by mail-we0-f171.google.com with SMTP id k11so22463576wes.2
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 08:11:57 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V3 1/4] bcma: add helpers bringing PCIe hosted bus up / down
Date: Sun,  8 Feb 2015 17:11:47 +0100
Message-Id: <1423411910-22399-1-git-send-email-zajec5@gmail.com> (sfid-20150208_171202_706238_AB59C929)
In-Reply-To: <1423409504-16435-1-git-send-email-zajec5@gmail.com>
References: <1423409504-16435-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bringing PCIe hosted bus up requires operating on host-related core.
Since we plan to support PCIe Gen 2 devices we should provide a helper
picking the correct one (PCIE or PCIE2).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/bcma_private.h                    |  2 ++
 drivers/bcma/driver_pci.c                      | 20 ++----------------
 drivers/bcma/host_pci.c                        | 28 ++++++++++++++++++++++++++
 drivers/net/wireless/b43/main.c                |  4 ++--
 drivers/net/wireless/brcm80211/brcmsmac/main.c |  8 ++++----
 include/linux/bcma/bcma.h                      |  3 +++
 include/linux/bcma/bcma_driver_pci.h           |  2 --
 7 files changed, 41 insertions(+), 26 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index ac6c5fc..351f4af 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -101,6 +101,8 @@ static inline void __exit bcma_host_soc_unregister_driver(void)
 
 /* driver_pci.c */
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
+void bcma_core_pci_up(struct bcma_drv_pci *pc);
+void bcma_core_pci_down(struct bcma_drv_pci *pc);
 
 extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
 
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 7866664..cf92bfa 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -328,28 +328,12 @@ static void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
 	bcma_pcie_read(pc, BCMA_CORE_PCI_DLLP_PMTHRESHREG);
 }
 
-void bcma_core_pci_up(struct bcma_bus *bus)
+void bcma_core_pci_up(struct bcma_drv_pci *pc)
 {
-	struct bcma_drv_pci *pc;
-
-	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
-		return;
-
-	pc = &bus->drv_pci[0];
-
 	bcma_core_pci_extend_L1timer(pc, true);
 }
-EXPORT_SYMBOL_GPL(bcma_core_pci_up);
 
-void bcma_core_pci_down(struct bcma_bus *bus)
+void bcma_core_pci_down(struct bcma_drv_pci *pc)
 {
-	struct bcma_drv_pci *pc;
-
-	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
-		return;
-
-	pc = &bus->drv_pci[0];
-
 	bcma_core_pci_extend_L1timer(pc, false);
 }
-EXPORT_SYMBOL_GPL(bcma_core_pci_down);
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 53c6a8a..8dd37dc 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -310,3 +310,31 @@ void __exit bcma_host_pci_exit(void)
 {
 	pci_unregister_driver(&bcma_pci_bridge_driver);
 }
+
+/**************************************************
+ * Runtime ops for drivers.
+ **************************************************/
+
+/* See also pcicore_up */
+void bcma_host_pci_up(struct bcma_bus *bus)
+{
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
+		return;
+
+	if (bus->host_is_pcie2)
+		pr_warn("Bringing up bus with PCIe Gen 2 host is unsupported yet\n");
+	else
+		bcma_core_pci_up(&bus->drv_pci[0]);
+}
+EXPORT_SYMBOL_GPL(bcma_host_pci_up);
+
+/* See also pcicore_down */
+void bcma_host_pci_down(struct bcma_bus *bus)
+{
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI)
+		return;
+
+	if (!bus->host_is_pcie2)
+		bcma_core_pci_down(&bus->drv_pci[0]);
+}
+EXPORT_SYMBOL_GPL(bcma_host_pci_down);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 2c90886..e129b4c 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4819,7 +4819,7 @@ static void b43_wireless_core_exit(struct b43_wldev *dev)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		bcma_core_pci_down(dev->dev->bdev->bus);
+		bcma_host_pci_down(dev->dev->bdev->bus);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
@@ -4868,7 +4868,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	case B43_BUS_BCMA:
 		bcma_core_pci_irq_ctl(&dev->dev->bdev->bus->drv_pci[0],
 				      dev->dev->bdev, true);
-		bcma_core_pci_up(dev->dev->bdev->bus);
+		bcma_host_pci_up(dev->dev->bdev->bus);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index eb8584a..bcbfc6e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4668,7 +4668,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	brcms_c_coredisable(wlc_hw);
 
 	/* Match driver "down" state */
-	bcma_core_pci_down(wlc_hw->d11core->bus);
+	bcma_host_pci_down(wlc_hw->d11core->bus);
 
 	/* turn off pll and xtal to match driver "down" state */
 	brcms_b_xtal(wlc_hw, OFF);
@@ -4969,12 +4969,12 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 */
 	if (brcms_b_radio_read_hwdisabled(wlc_hw)) {
 		/* put SB PCI in down state again */
-		bcma_core_pci_down(wlc_hw->d11core->bus);
+		bcma_host_pci_down(wlc_hw->d11core->bus);
 		brcms_b_xtal(wlc_hw, OFF);
 		return -ENOMEDIUM;
 	}
 
-	bcma_core_pci_up(wlc_hw->d11core->bus);
+	bcma_host_pci_up(wlc_hw->d11core->bus);
 
 	/* reset the d11 core */
 	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
@@ -5171,7 +5171,7 @@ static int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 
 		/* turn off primary xtal and pll */
 		if (!wlc_hw->noreset) {
-			bcma_core_pci_down(wlc_hw->d11core->bus);
+			bcma_host_pci_down(wlc_hw->d11core->bus);
 			brcms_b_xtal(wlc_hw, OFF);
 		}
 	}
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 994739d..037620b 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -434,6 +434,9 @@ static inline struct bcma_device *bcma_find_core(struct bcma_bus *bus,
 	return bcma_find_core_unit(bus, coreid, 0);
 }
 
+extern void bcma_host_pci_up(struct bcma_bus *bus);
+extern void bcma_host_pci_down(struct bcma_bus *bus);
+
 extern bool bcma_core_is_enabled(struct bcma_device *core);
 extern void bcma_core_disable(struct bcma_device *core, u32 flags);
 extern int bcma_core_enable(struct bcma_device *core, u32 flags);
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 3f809ae..23af893 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -242,8 +242,6 @@ extern void bcma_core_pci_early_init(struct bcma_drv_pci *pc);
 extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
-extern void bcma_core_pci_up(struct bcma_bus *bus);
-extern void bcma_core_pci_down(struct bcma_bus *bus);
 extern void bcma_core_pci_power_save(struct bcma_bus *bus, bool up);
 
 extern int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev);
-- 
1.8.4.5

