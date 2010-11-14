Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50423 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755276Ab0KNLgp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Nov 2010 06:36:45 -0500
Received: by mail-ww0-f44.google.com with SMTP id 29so387874wwb.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Nov 2010 03:36:45 -0800 (PST)
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Brett Rudley <brudley@broadcom.com>,
	Henry Ptasinski <henryp@broadcom.com>,
	Dowan Kim <dowan@broadcom.com>, linux-wireless@vger.kernel.org,
	Mike Rapoport <mike.rapoport@gmail.com>
Subject: [PATCH 2/4] staging: brcm80211: brcmfmac: remove PCI SDIO controller binding
Date: Sun, 14 Nov 2010 13:36:22 +0200
Message-Id: <df8061ebab7c953f3f4aa438d426dce7aa1bd8e1.1289734125.git.mike.rapoport@gmail.com>
In-Reply-To: <cover.1289734125.git.mike.rapoport@gmail.com>
References: <cover.1289734125.git.mike.rapoport@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Mike Rapoport <mike.rapoport@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c |  229 ---------------------
 1 files changed, 0 insertions(+), 229 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
index 9028cd0..523034b 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_linux.c
@@ -291,224 +291,6 @@ int bcmsdh_remove(struct device *dev)
 
 	return 0;
 }
-
-#else				/* BCMPLATFORM_BUS */
-
-#if !defined(BCMLXSDMMC)
-/* forward declarations for PCI probe and remove functions. */
-static int __devinit bcmsdh_pci_probe(struct pci_dev *pdev,
-				      const struct pci_device_id *ent);
-static void __devexit bcmsdh_pci_remove(struct pci_dev *pdev);
-
-/**
- * pci id table
- */
-static struct pci_device_id bcmsdh_pci_devid[] __devinitdata = {
-{
-	.vendor = PCI_ANY_ID,
-	.device = PCI_ANY_ID,
-	.subvendor = PCI_ANY_ID,
-	.subdevice = PCI_ANY_ID,
-	.class = 0,
-	.class_mask = 0,
-	.driver_data = 0,
-},
-{0,}
-};
-
-MODULE_DEVICE_TABLE(pci, bcmsdh_pci_devid);
-
-/**
- * SDIO Host Controller pci driver info
- */
-static struct pci_driver bcmsdh_pci_driver = {
-	.node = {},
-	.name = "bcmsdh",
-	.id_table = bcmsdh_pci_devid,
-	.probe = bcmsdh_pci_probe,
-	.remove = bcmsdh_pci_remove,
-	.suspend = NULL,
-	.resume = NULL,
-};
-
-extern uint sd_pci_slot;	/* Force detection to a particular PCI */
-				/* slot only . Allows for having multiple */
-				/* WL devices at once in a PC */
-				/* Only one instance of dhd will be */
-				/* usable at a time */
-				/* Upper word is bus number, */
-				/* lower word is slot number */
-				/* Default value of 0xFFFFffff turns this */
-				/* off */
-module_param(sd_pci_slot, uint, 0);
-
-/**
- * Detect supported SDIO Host Controller and attach if found.
- *
- * Determine if the device described by pdev is a supported SDIO Host
- * Controller.  If so, attach to it and attach to the target device.
- */
-static int __devinit
-bcmsdh_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
-{
-	osl_t *osh = NULL;
-	bcmsdh_hc_t *sdhc = NULL;
-	unsigned long regs;
-	bcmsdh_info_t *sdh = NULL;
-	int rc;
-
-	if (sd_pci_slot != 0xFFFFffff) {
-		if (pdev->bus->number != (sd_pci_slot >> 16) ||
-		    PCI_SLOT(pdev->devfn) != (sd_pci_slot & 0xffff)) {
-			SDLX_MSG(("%s: %s: bus %X, slot %X, vend %X, dev %X\n",
-				  __func__,
-				  bcmsdh_chipmatch(pdev->vendor, pdev->device) ?
-				  "Found compatible SDIOHC" :
-				  "Probing unknown device",
-				  pdev->bus->number, PCI_SLOT(pdev->devfn),
-				  pdev->vendor, pdev->device));
-			return -ENODEV;
-		}
-		SDLX_MSG(("%s: %s: bus %X, slot %X, vendor %X, device %X "
-			"(good PCI location)\n", __func__,
-			bcmsdh_chipmatch(pdev->vendor, pdev->device) ?
-			"Using compatible SDIOHC" : "WARNING, forced use "
-			"of unkown device",
-		pdev->bus->number, PCI_SLOT(pdev->devfn), pdev->vendor,
-		pdev->device));
-	}
-
-	if ((pdev->vendor == VENDOR_TI)
-	    && ((pdev->device == PCIXX21_FLASHMEDIA_ID)
-		|| (pdev->device == PCIXX21_FLASHMEDIA0_ID))) {
-		u32 config_reg;
-
-		SDLX_MSG(("%s: Disabling TI FlashMedia Controller.\n",
-			  __func__));
-		osh = osl_attach(pdev, PCI_BUS, false);
-		if (!osh) {
-			SDLX_MSG(("%s: osl_attach failed\n", __func__));
-			goto err;
-		}
-
-		config_reg = OSL_PCI_READ_CONFIG(osh, 0x4c, 4);
-
-		/*
-		 * Set MMC_SD_DIS bit in FlashMedia Controller.
-		 * Disbling the SD/MMC Controller in the FlashMedia Controller
-		 * allows the Standard SD Host Controller to take over control
-		 * of the SD Slot.
-		 */
-		config_reg |= 0x02;
-		OSL_PCI_WRITE_CONFIG(osh, 0x4c, 4, config_reg);
-		osl_detach(osh);
-	}
-	/* match this pci device with what we support */
-	/* we can't solely rely on this to believe it is
-		our SDIO Host Controller! */
-	if (!bcmsdh_chipmatch(pdev->vendor, pdev->device))
-		return -ENODEV;
-
-	/* this is a pci device we might support */
-	SDLX_MSG(("%s: Found possible SDIO Host Controller: "
-		"bus %d slot %d func %d irq %d\n", __func__,
-		pdev->bus->number, PCI_SLOT(pdev->devfn),
-		PCI_FUNC(pdev->devfn), pdev->irq));
-
-	/* use bcmsdh_query_device() to get the vendor ID of the target device
-	 * so it will eventually appear in the Broadcom string on the console
-	 */
-
-	/* allocate SDIO Host Controller state info */
-	osh = osl_attach(pdev, PCI_BUS, false);
-	if (!osh) {
-		SDLX_MSG(("%s: osl_attach failed\n", __func__));
-		goto err;
-	}
-	sdhc = kzalloc(sizeof(bcmsdh_hc_t), GFP_ATOMIC);
-	if (!sdhc) {
-		SDLX_MSG(("%s: out of memory\n", __func__));
-		goto err;
-	}
-	sdhc->osh = osh;
-
-	sdhc->dev = pdev;
-
-	/* map to address where host can access */
-	pci_set_master(pdev);
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		SDLX_MSG(("%s: Cannot enable PCI device\n", __func__));
-		goto err;
-	}
-	sdh = bcmsdh_attach(osh, (void *)(unsigned long)pci_resource_start(pdev, 0),
-			(void **)&regs, pdev->irq);
-	if (!sdh) {
-		SDLX_MSG(("%s: bcmsdh_attach failed\n", __func__));
-		goto err;
-	}
-
-	sdhc->sdh = sdh;
-
-	/* try to attach to the target device */
-	sdhc->ch = drvinfo.attach(VENDOR_BROADCOM, /* pdev->vendor, */
-				bcmsdh_query_device(sdh) & 0xFFFF, 0, 0, 0, 0,
-				(void *)regs, NULL, sdh);
-	if (!sdhc->ch) {
-		SDLX_MSG(("%s: device attach failed\n", __func__));
-		goto err;
-	}
-
-	/* chain SDIO Host Controller info together */
-	sdhc->next = sdhcinfo;
-	sdhcinfo = sdhc;
-
-	return 0;
-
-	/* error handling */
-err:
-	if (sdhc->sdh)
-		bcmsdh_detach(sdhc->osh, sdhc->sdh);
-	if (sdhc)
-		kfree(sdhc);
-	if (osh)
-		osl_detach(osh);
-	return -ENODEV;
-}
-
-/**
- * Detach from target devices and SDIO Host Controller
- */
-static void __devexit bcmsdh_pci_remove(struct pci_dev *pdev)
-{
-	bcmsdh_hc_t *sdhc, *prev;
-	osl_t *osh;
-
-	/* find the SDIO Host Controller state for this
-		 pdev and take it out from the list */
-	for (sdhc = sdhcinfo, prev = NULL; sdhc; sdhc = sdhc->next) {
-		if (sdhc->dev == pdev) {
-			if (prev)
-				prev->next = sdhc->next;
-			else
-				sdhcinfo = NULL;
-			break;
-		}
-		prev = sdhc;
-	}
-	if (!sdhc)
-		return;
-
-	drvinfo.detach(sdhc->ch);
-
-	bcmsdh_detach(sdhc->osh, sdhc->sdh);
-
-	/* release SDIO Host Controller info */
-	osh = sdhc->osh;
-	kfree(sdhc);
-	osl_detach(osh);
-}
-#endif				/* BCMLXSDMMC */
 #endif				/* BCMPLATFORM_BUS */
 
 extern int sdio_function_init(void);
@@ -530,14 +312,6 @@ int bcmsdh_register(bcmsdh_driver_t *driver)
 	return error;
 #endif				/* defined(BCMPLATFORM_BUS) */
 
-#if !defined(BCMPLATFORM_BUS) && !defined(BCMLXSDMMC)
-	error = pci_register_driver(&bcmsdh_pci_driver);
-	if (!error)
-		return 0;
-
-	SDLX_MSG(("%s: pci_register_driver failed 0x%x\n", __func__, error));
-#endif				/* BCMPLATFORM_BUS */
-
 	return error;
 }
 
@@ -551,9 +325,6 @@ void bcmsdh_unregister(void)
 #if defined(BCMLXSDMMC)
 	sdio_function_cleanup();
 #endif				/* BCMLXSDMMC */
-#if !defined(BCMPLATFORM_BUS) && !defined(BCMLXSDMMC)
-	pci_unregister_driver(&bcmsdh_pci_driver);
-#endif				/* BCMPLATFORM_BUS */
 }
 
 #if defined(OOB_INTR_ONLY)
-- 
1.6.4.4

