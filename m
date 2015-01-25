Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:44136 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbbAYVCZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 25 Jan 2015 16:02:25 -0500
Received: by mail-wg0-f54.google.com with SMTP id b13so5930224wgh.13
        for <linux-wireless@vger.kernel.org>; Sun, 25 Jan 2015 13:02:23 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: b43-dev@lists.infradead.org, Hauke Mehrtens <hauke@hauke-m.de>,
	brcm80211-dev-list@broadcom.com,
	Arend van Spriel <arend@broadcom.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH RFC] bcma: add helper function bringing PCIe hosted bus up
Date: Sun, 25 Jan 2015 22:02:08 +0100
Message-Id: <1422219728-593-1-git-send-email-zajec5@gmail.com> (sfid-20150125_220233_744991_42819DD5)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Bringing PCIe hosted bus up requires operating on host-related core.
Since we plan to support PCIe Gen 2 devices we should provide a helper
picking the correct core (PCIE or PCIE2).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
What do you think about this? Any comments?
Do you think putting such a helper in host_pci.c is OK?
I plan to provide similar changes for bcma_core_pci_down & bcma_core_pci_irq_ctl
---
 drivers/bcma/bcma_private.h                    |  1 +
 drivers/bcma/driver_pci.c                      | 10 +---------
 drivers/bcma/host_pci.c                        | 17 +++++++++++++++++
 drivers/net/wireless/b43/main.c                |  2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |  2 +-
 include/linux/bcma/bcma.h                      |  2 ++
 include/linux/bcma/bcma_driver_pci.h           |  1 -
 7 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index ac6c5fc..9123741 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -101,6 +101,7 @@ static inline void __exit bcma_host_soc_unregister_driver(void)
 
 /* driver_pci.c */
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
+void bcma_core_pci_up(struct bcma_drv_pci *pc);
 
 extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
 
diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index 7866664..1014ab4 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -328,18 +328,10 @@ static void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
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
 
 void bcma_core_pci_down(struct bcma_bus *bus)
 {
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index 53c6a8a..9a89f3d 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -310,3 +310,20 @@ void __exit bcma_host_pci_exit(void)
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
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index edf535e..f59c25d 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4847,7 +4847,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	case B43_BUS_BCMA:
 		bcma_core_pci_irq_ctl(&dev->dev->bdev->bus->drv_pci[0],
 				      dev->dev->bdev, true);
-		bcma_core_pci_up(dev->dev->bdev->bus);
+		bcma_host_pci_up(dev->dev->bdev->bus);
 		break;
 #endif
 #ifdef CONFIG_B43_SSB
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index eb8584a..aa7629f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4974,7 +4974,7 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 		return -ENOMEDIUM;
 	}
 
-	bcma_core_pci_up(wlc_hw->d11core->bus);
+	bcma_host_pci_up(wlc_hw->d11core->bus);
 
 	/* reset the d11 core */
 	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 994739d..6f0c734 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -434,6 +434,8 @@ static inline struct bcma_device *bcma_find_core(struct bcma_bus *bus,
 	return bcma_find_core_unit(bus, coreid, 0);
 }
 
+extern void bcma_host_pci_up(struct bcma_bus *bus);
+
 extern bool bcma_core_is_enabled(struct bcma_device *core);
 extern void bcma_core_disable(struct bcma_device *core, u32 flags);
 extern int bcma_core_enable(struct bcma_device *core, u32 flags);
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 3f809ae..c7a7db5 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -242,7 +242,6 @@ extern void bcma_core_pci_early_init(struct bcma_drv_pci *pc);
 extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
 				 struct bcma_device *core, bool enable);
-extern void bcma_core_pci_up(struct bcma_bus *bus);
 extern void bcma_core_pci_down(struct bcma_bus *bus);
 extern void bcma_core_pci_power_save(struct bcma_bus *bus, bool up);
 
-- 
1.8.4.5

