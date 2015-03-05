Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39316 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbCER2U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 12:28:20 -0500
Received: by wiwl15 with SMTP id l15so4798024wiw.4
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2015 09:28:18 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>,
	Chen Gang <xili_gchen_5257@hotmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 1/3] bcma: move PCI IRQ control function to host specific code
Date: Thu,  5 Mar 2015 18:25:10 +0100
Message-Id: <1425576312-2779-1-git-send-email-zajec5@gmail.com> (sfid-20150305_182834_446698_178429B8)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This function isn't really related to any bus core. It touches PCI
device config registers only, so move it to the (PCI) host file.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci.c                      | 33 -------------------------
 drivers/bcma/host_pci.c                        | 34 ++++++++++++++++++++++++++
 drivers/net/wireless/b43/main.c                |  2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c |  2 +-
 include/linux/bcma/bcma.h                      |  9 +++++++
 include/linux/bcma/bcma_driver_pci.h           |  2 --
 6 files changed, 45 insertions(+), 37 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index cfd35bc..f499a46 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -282,39 +282,6 @@ void bcma_core_pci_power_save(struct bcma_bus *bus, bool up)
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_power_save);
 
-int bcma_core_pci_irq_ctl(struct bcma_bus *bus, struct bcma_device *core,
-			  bool enable)
-{
-	struct pci_dev *pdev;
-	u32 coremask, tmp;
-	int err = 0;
-
-	if (bus->hosttype != BCMA_HOSTTYPE_PCI) {
-		/* This bcma device is not on a PCI host-bus. So the IRQs are
-		 * not routed through the PCI core.
-		 * So we must not enable routing through the PCI core. */
-		goto out;
-	}
-
-	pdev = bus->host_pci;
-
-	err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK, &tmp);
-	if (err)
-		goto out;
-
-	coremask = BIT(core->core_index) << 8;
-	if (enable)
-		tmp |= coremask;
-	else
-		tmp &= ~coremask;
-
-	err = pci_write_config_dword(pdev, BCMA_PCI_IRQMASK, tmp);
-
-out:
-	return err;
-}
-EXPORT_SYMBOL_GPL(bcma_core_pci_irq_ctl);
-
 static void bcma_core_pci_extend_L1timer(struct bcma_drv_pci *pc, bool extend)
 {
 	u32 w;
diff --git a/drivers/bcma/host_pci.c b/drivers/bcma/host_pci.c
index a62a2f9..0856189 100644
--- a/drivers/bcma/host_pci.c
+++ b/drivers/bcma/host_pci.c
@@ -351,3 +351,37 @@ void bcma_host_pci_down(struct bcma_bus *bus)
 		bcma_core_pci_down(&bus->drv_pci[0]);
 }
 EXPORT_SYMBOL_GPL(bcma_host_pci_down);
+
+/* See also si_pci_setup */
+int bcma_host_pci_irq_ctl(struct bcma_bus *bus, struct bcma_device *core,
+			  bool enable)
+{
+	struct pci_dev *pdev;
+	u32 coremask, tmp;
+	int err = 0;
+
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI) {
+		/* This bcma device is not on a PCI host-bus. So the IRQs are
+		 * not routed through the PCI core.
+		 * So we must not enable routing through the PCI core. */
+		goto out;
+	}
+
+	pdev = bus->host_pci;
+
+	err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK, &tmp);
+	if (err)
+		goto out;
+
+	coremask = BIT(core->core_index) << 8;
+	if (enable)
+		tmp |= coremask;
+	else
+		tmp &= ~coremask;
+
+	err = pci_write_config_dword(pdev, BCMA_PCI_IRQMASK, tmp);
+
+out:
+	return err;
+}
+EXPORT_SYMBOL_GPL(bcma_host_pci_irq_ctl);
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index f34aa67..a13be80 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4866,7 +4866,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		bcma_core_pci_irq_ctl(dev->dev->bdev->bus,
+		bcma_host_pci_irq_ctl(dev->dev->bdev->bus,
 				      dev->dev->bdev, true);
 		bcma_host_pci_up(dev->dev->bdev->bus);
 		break;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index c84af1d..369527e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4959,7 +4959,7 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 * Configure pci/pcmcia here instead of in brcms_c_attach()
 	 * to allow mfg hotswap:  down, hotswap (chip power cycle), up.
 	 */
-	bcma_core_pci_irq_ctl(wlc_hw->d11core->bus, wlc_hw->d11core,
+	bcma_host_pci_irq_ctl(wlc_hw->d11core->bus, wlc_hw->d11core,
 			      true);
 
 	/*
diff --git a/include/linux/bcma/bcma.h b/include/linux/bcma/bcma.h
index 44057b4..e34f906 100644
--- a/include/linux/bcma/bcma.h
+++ b/include/linux/bcma/bcma.h
@@ -437,6 +437,8 @@ static inline struct bcma_device *bcma_find_core(struct bcma_bus *bus,
 #ifdef CONFIG_BCMA_HOST_PCI
 extern void bcma_host_pci_up(struct bcma_bus *bus);
 extern void bcma_host_pci_down(struct bcma_bus *bus);
+extern int bcma_host_pci_irq_ctl(struct bcma_bus *bus,
+				 struct bcma_device *core, bool enable);
 #else
 static inline void bcma_host_pci_up(struct bcma_bus *bus)
 {
@@ -444,6 +446,13 @@ static inline void bcma_host_pci_up(struct bcma_bus *bus)
 static inline void bcma_host_pci_down(struct bcma_bus *bus)
 {
 }
+static inline int bcma_host_pci_irq_ctl(struct bcma_bus *bus,
+					struct bcma_device *core, bool enable)
+{
+	if (bus->hosttype == BCMA_HOSTTYPE_PCI)
+		return -ENOTSUPP;
+	return 0;
+}
 #endif
 
 extern bool bcma_core_is_enabled(struct bcma_device *core);
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 8e90004..3a46868 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -238,8 +238,6 @@ struct bcma_drv_pci {
 #define pcicore_write16(pc, offset, val)	bcma_write16((pc)->core, offset, val)
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
-extern int bcma_core_pci_irq_ctl(struct bcma_bus *bus,
-				 struct bcma_device *core, bool enable);
 extern void bcma_core_pci_power_save(struct bcma_bus *bus, bool up);
 
 extern int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev);
-- 
1.8.4.5

