Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f181.google.com ([74.125.82.181]:43274 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752892AbbBHQMA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Feb 2015 11:12:00 -0500
Received: by mail-we0-f181.google.com with SMTP id w62so4993384wes.12
        for <linux-wireless@vger.kernel.org>; Sun, 08 Feb 2015 08:11:59 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, brcm80211-dev-list@broadcom.com,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH V3 2/4] bcma: change IRQ control function to accept bus as an argument
Date: Sun,  8 Feb 2015 17:11:48 +0100
Message-Id: <1423411910-22399-2-git-send-email-zajec5@gmail.com> (sfid-20150208_171205_126613_52323AFC)
In-Reply-To: <1423411910-22399-1-git-send-email-zajec5@gmail.com>
References: <1423409504-16435-1-git-send-email-zajec5@gmail.com>
 <1423411910-22399-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It doesn't operate on PCI core, but PCI host device, so there is no
point of passing core related struct.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/driver_pci.c                      | 6 +++---
 drivers/net/wireless/b43/main.c                | 2 +-
 drivers/net/wireless/brcm80211/brcmsmac/main.c | 2 +-
 include/linux/bcma/bcma_driver_pci.h           | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/bcma/driver_pci.c b/drivers/bcma/driver_pci.c
index cf92bfa..cfd35bc 100644
--- a/drivers/bcma/driver_pci.c
+++ b/drivers/bcma/driver_pci.c
@@ -282,21 +282,21 @@ void bcma_core_pci_power_save(struct bcma_bus *bus, bool up)
 }
 EXPORT_SYMBOL_GPL(bcma_core_pci_power_save);
 
-int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc, struct bcma_device *core,
+int bcma_core_pci_irq_ctl(struct bcma_bus *bus, struct bcma_device *core,
 			  bool enable)
 {
 	struct pci_dev *pdev;
 	u32 coremask, tmp;
 	int err = 0;
 
-	if (!pc || core->bus->hosttype != BCMA_HOSTTYPE_PCI) {
+	if (bus->hosttype != BCMA_HOSTTYPE_PCI) {
 		/* This bcma device is not on a PCI host-bus. So the IRQs are
 		 * not routed through the PCI core.
 		 * So we must not enable routing through the PCI core. */
 		goto out;
 	}
 
-	pdev = pc->core->bus->host_pci;
+	pdev = bus->host_pci;
 
 	err = pci_read_config_dword(pdev, BCMA_PCI_IRQMASK, &tmp);
 	if (err)
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index e129b4c..44794d2 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4866,7 +4866,7 @@ static int b43_wireless_core_init(struct b43_wldev *dev)
 	switch (dev->dev->bus_type) {
 #ifdef CONFIG_B43_BCMA
 	case B43_BUS_BCMA:
-		bcma_core_pci_irq_ctl(&dev->dev->bdev->bus->drv_pci[0],
+		bcma_core_pci_irq_ctl(dev->dev->bdev->bus,
 				      dev->dev->bdev, true);
 		bcma_host_pci_up(dev->dev->bdev->bus);
 		break;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index bcbfc6e..c84af1d 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4959,7 +4959,7 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 * Configure pci/pcmcia here instead of in brcms_c_attach()
 	 * to allow mfg hotswap:  down, hotswap (chip power cycle), up.
 	 */
-	bcma_core_pci_irq_ctl(&wlc_hw->d11core->bus->drv_pci[0], wlc_hw->d11core,
+	bcma_core_pci_irq_ctl(wlc_hw->d11core->bus, wlc_hw->d11core,
 			      true);
 
 	/*
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 23af893..6b8bca6 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -240,7 +240,7 @@ struct bcma_drv_pci {
 
 extern void bcma_core_pci_early_init(struct bcma_drv_pci *pc);
 extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
-extern int bcma_core_pci_irq_ctl(struct bcma_drv_pci *pc,
+extern int bcma_core_pci_irq_ctl(struct bcma_bus *bus,
 				 struct bcma_device *core, bool enable);
 extern void bcma_core_pci_power_save(struct bcma_bus *bus, bool up);
 
-- 
1.8.4.5

