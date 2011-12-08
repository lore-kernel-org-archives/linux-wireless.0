Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1522 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224Ab1LHXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:12 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/23] brcm80211: smac: change from pci device driver to
 bcma device driver
Date: Thu, 8 Dec 2011 15:06:46 -0800
Message-ID: <1323385619-7454-11-git-send-email-frankyl@broadcom.com> (sfid-20111209_000757_160095_1914CBD1)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

A new bus driver called "bcma" has been introduced into the kernel tree
which considers the Broadcom AMBA chip interconnect as a bus. Each core in
the chip is a bcma device. This commit changes brcms_mac80211.c into
a bcma device driver.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/Kconfig             |    3 +-
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.c  |  168 ++++++++------------
 .../net/wireless/brcm80211/brcmsmac/mac80211_if.h  |    2 -
 3 files changed, 64 insertions(+), 109 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/Kconfig b/drivers/net/wireless/brcm80211/Kconfig
index 2069fc8..8f54c2e 100644
--- a/drivers/net/wireless/brcm80211/Kconfig
+++ b/drivers/net/wireless/brcm80211/Kconfig
@@ -3,9 +3,8 @@ config BRCMUTIL
 
 config BRCMSMAC
 	tristate "Broadcom IEEE802.11n PCIe SoftMAC WLAN driver"
-	depends on PCI
 	depends on MAC80211
-	depends on BCMA=n
+	depends on BCMA
 	select BRCMUTIL
 	select FW_LOADER
 	select CRC_CCITT
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
index 76376eb..9e07dc4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c
@@ -17,11 +17,11 @@
 #define __UNDEF_NO_VERSION__
 
 #include <linux/etherdevice.h>
-#include <linux/pci.h>
 #include <linux/sched.h>
 #include <linux/firmware.h>
 #include <linux/interrupt.h>
 #include <linux/module.h>
+#include <linux/bcma/bcma.h>
 #include <net/mac80211.h>
 #include <defs.h>
 #include "nicpci.h"
@@ -87,16 +87,14 @@ MODULE_DESCRIPTION("Broadcom 802.11n wireless LAN driver.");
 MODULE_SUPPORTED_DEVICE("Broadcom 802.11n WLAN cards");
 MODULE_LICENSE("Dual BSD/GPL");
 
-/* recognized PCI IDs */
-static DEFINE_PCI_DEVICE_TABLE(brcms_pci_id_table) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4357) }, /* 43225 2G */
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4353) }, /* 43224 DUAL */
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4727) }, /* 4313 DUAL */
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x0576) }, /* 43224 Ven */
-	{0}
-};
 
-MODULE_DEVICE_TABLE(pci, brcms_pci_id_table);
+/* recognized BCMA Core IDs */
+static struct bcma_device_id brcms_coreid_table[] = {
+	BCMA_CORE(BCMA_MANUF_BCM, BCMA_CORE_80211,
+		  BCMA_ANY_REV, BCMA_ANY_CLASS),
+	BCMA_CORETABLE_END
+};
+MODULE_DEVICE_TABLE(bcma, brcms_coreid_table);
 
 #ifdef BCMDBG
 static int msglevel = 0xdeadbeef;
@@ -724,7 +722,7 @@ static const struct ieee80211_ops brcms_ops = {
 };
 
 /*
- * is called in brcms_pci_probe() context, therefore no locking required.
+ * is called in brcms_bcma_probe() context, therefore no locking required.
  */
 static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
 {
@@ -864,25 +862,15 @@ static void brcms_free(struct brcms_info *wl)
 #endif
 		kfree(t);
 	}
-
-	/*
-	 * unregister_netdev() calls get_stats() which may read chip
-	 * registers so we cannot unmap the chip registers until
-	 * after calling unregister_netdev() .
-	 */
-	if (wl->regsva)
-		iounmap(wl->regsva);
-
-	wl->regsva = NULL;
 }
 
 /*
 * called from both kernel as from this kernel module (error flow on attach)
 * precondition: perimeter lock is not acquired.
 */
-static void brcms_remove(struct pci_dev *pdev)
+static void brcms_remove(struct bcma_device *pdev)
 {
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = bcma_get_drvdata(pdev);
 	struct brcms_info *wl = hw->priv;
 
 	if (wl->wlc) {
@@ -890,11 +878,10 @@ static void brcms_remove(struct pci_dev *pdev)
 		wiphy_rfkill_stop_polling(wl->pub->ieee_hw->wiphy);
 		ieee80211_unregister_hw(hw);
 	}
-	pci_disable_device(pdev);
 
 	brcms_free(wl);
 
-	pci_set_drvdata(pdev, NULL);
+	bcma_set_drvdata(pdev, NULL);
 	ieee80211_free_hw(hw);
 }
 
@@ -1002,11 +989,9 @@ static int ieee_hw_init(struct ieee80211_hw *hw)
  * it as static.
  *
  *
- * is called in brcms_pci_probe() context, therefore no locking required.
+ * is called in brcms_bcma_probe() context, therefore no locking required.
  */
-static struct brcms_info *brcms_attach(u16 vendor, u16 device,
-				       resource_size_t regs,
-				       struct pci_dev *btparam, uint irq)
+static struct brcms_info *brcms_attach(struct bcma_device *pdev)
 {
 	struct brcms_info *wl = NULL;
 	int unit, err;
@@ -1020,7 +1005,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 		return NULL;
 
 	/* allocate private info */
-	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
+	hw = bcma_get_drvdata(pdev);
 	if (hw != NULL)
 		wl = hw->priv;
 	if (WARN_ON(hw == NULL) || WARN_ON(wl == NULL))
@@ -1032,26 +1017,22 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	/* setup the bottom half handler */
 	tasklet_init(&wl->tasklet, brcms_dpc, (unsigned long) wl);
 
-	wl->regsva = ioremap_nocache(regs, PCI_BAR0_WINSZ);
-	if (wl->regsva == NULL) {
-		wiphy_err(wl->wiphy, "wl%d: ioremap() failed\n", unit);
-		goto fail;
-	}
 	spin_lock_init(&wl->lock);
 	spin_lock_init(&wl->isr_lock);
 
 	/* prepare ucode */
-	if (brcms_request_fw(wl, btparam) < 0) {
+	if (brcms_request_fw(wl, pdev->bus->host_pci) < 0) {
 		wiphy_err(wl->wiphy, "%s: Failed to find firmware usually in "
 			  "%s\n", KBUILD_MODNAME, "/lib/firmware/brcm");
 		brcms_release_fw(wl);
-		brcms_remove(btparam);
+		brcms_remove(pdev);
 		return NULL;
 	}
 
 	/* common load-time initialization */
-	wl->wlc = brcms_c_attach(wl, vendor, device, unit, false,
-				 wl->regsva, btparam, &err);
+	wl->wlc = brcms_c_attach((void *)wl, pdev->bus->host_pci->vendor,
+				 pdev->bus->host_pci->device, unit, false,
+				 pdev->bus->mmio, pdev->bus->host_pci, &err);
 	brcms_release_fw(wl);
 	if (!wl->wlc) {
 		wiphy_err(wl->wiphy, "%s: attach() failed with code %d\n",
@@ -1063,11 +1044,12 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	wl->pub->ieee_hw = hw;
 
 	/* register our interrupt handler */
-	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
+	if (request_irq(pdev->bus->host_pci->irq, brcms_isr,
+			IRQF_SHARED, KBUILD_MODNAME, wl)) {
 		wiphy_err(wl->wiphy, "wl%d: request_irq() failed\n", unit);
 		goto fail;
 	}
-	wl->irq = irq;
+	wl->irq = pdev->bus->host_pci->irq;
 
 	/* register module */
 	brcms_c_module_register(wl->pub, "linux", wl, NULL);
@@ -1114,37 +1096,18 @@ fail:
  *
  * Perimeter lock is initialized in the course of this function.
  */
-static int __devinit
-brcms_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+static int __devinit brcms_bcma_probe(struct bcma_device *pdev)
 {
-	int rc;
 	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
-	u32 val;
-
-	dev_info(&pdev->dev, "bus %d slot %d func %d irq %d\n",
-	       pdev->bus->number, PCI_SLOT(pdev->devfn),
-	       PCI_FUNC(pdev->devfn), pdev->irq);
 
-	if ((pdev->vendor != PCI_VENDOR_ID_BROADCOM) ||
-	    ((pdev->device != 0x0576) &&
-	     ((pdev->device & 0xff00) != 0x4300) &&
-	     ((pdev->device & 0xff00) != 0x4700) &&
-	     ((pdev->device < 43000) || (pdev->device > 43999))))
-		return -ENODEV;
+	dev_info(&pdev->dev, "mfg %x core %x rev %d class %d irq %d\n",
+		 pdev->id.manuf, pdev->id.id, pdev->id.rev, pdev->id.class,
+		 pdev->bus->host_pci->irq);
 
-	rc = pci_enable_device(pdev);
-	if (rc) {
-		pr_err("%s: Cannot enable device %d-%d_%d\n",
-		       __func__, pdev->bus->number, PCI_SLOT(pdev->devfn),
-		       PCI_FUNC(pdev->devfn));
+	if ((pdev->id.manuf != BCMA_MANUF_BCM) ||
+	    (pdev->id.id != BCMA_CORE_80211))
 		return -ENODEV;
-	}
-	pci_set_master(pdev);
-
-	pci_read_config_dword(pdev, 0x40, &val);
-	if ((val & 0x0000ff00) != 0)
-		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
 	hw = ieee80211_alloc_hw(sizeof(struct brcms_info), &brcms_ops);
 	if (!hw) {
@@ -1154,14 +1117,11 @@ brcms_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 
 	SET_IEEE80211_DEV(hw, &pdev->dev);
 
-	pci_set_drvdata(pdev, hw);
+	bcma_set_drvdata(pdev, hw);
 
 	memset(hw->priv, 0, sizeof(*wl));
 
-	wl = brcms_attach(pdev->vendor, pdev->device,
-			  pci_resource_start(pdev, 0), pdev,
-			  pdev->irq);
-
+	wl = brcms_attach(pdev);
 	if (!wl) {
 		pr_err("%s: %s: brcms_attach failed!\n", KBUILD_MODNAME,
 		       __func__);
@@ -1170,16 +1130,23 @@ brcms_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	return 0;
 }
 
-static int brcms_suspend(struct pci_dev *pdev, pm_message_t state)
+static int brcms_pci_suspend(struct pci_dev *pdev)
+{
+	pci_save_state(pdev);
+	pci_disable_device(pdev);
+	return pci_set_power_state(pdev, PCI_D3hot);
+}
+
+static int brcms_suspend(struct bcma_device *pdev, pm_message_t state)
 {
 	struct brcms_info *wl;
 	struct ieee80211_hw *hw;
 
-	hw = pci_get_drvdata(pdev);
+	hw = bcma_get_drvdata(pdev);
 	wl = hw->priv;
 	if (!wl) {
 		wiphy_err(wl->wiphy,
-			  "brcms_suspend: pci_get_drvdata failed\n");
+			  "brcms_suspend: bcma_get_drvdata failed\n");
 		return -ENODEV;
 	}
 
@@ -1188,25 +1155,14 @@ static int brcms_suspend(struct pci_dev *pdev, pm_message_t state)
 	wl->pub->hw_up = false;
 	spin_unlock_bh(&wl->lock);
 
-	pci_save_state(pdev);
-	pci_disable_device(pdev);
-	return pci_set_power_state(pdev, PCI_D3hot);
+	/* temporarily do suspend ourselves */
+	return brcms_pci_suspend(pdev->bus->host_pci);
 }
 
-static int brcms_resume(struct pci_dev *pdev)
+static int brcms_pci_resume(struct pci_dev *pdev)
 {
-	struct brcms_info *wl;
-	struct ieee80211_hw *hw;
 	int err = 0;
-	u32 val;
-
-	hw = pci_get_drvdata(pdev);
-	wl = hw->priv;
-	if (!wl) {
-		wiphy_err(wl->wiphy,
-			  "wl: brcms_resume: pci_get_drvdata failed\n");
-		return -ENODEV;
-	}
+	uint val;
 
 	err = pci_set_power_state(pdev, PCI_D0);
 	if (err)
@@ -1224,24 +1180,28 @@ static int brcms_resume(struct pci_dev *pdev)
 	if ((val & 0x0000ff00) != 0)
 		pci_write_config_dword(pdev, 0x40, val & 0xffff00ff);
 
+	return 0;
+}
+
+static int brcms_resume(struct bcma_device *pdev)
+{
 	/*
-	*  done. driver will be put in up state
-	*  in brcms_ops_add_interface() call.
+	*  just do pci resume for now until bcma supports it.
 	*/
-	return err;
+	return brcms_pci_resume(pdev->bus->host_pci);
 }
 
-static struct pci_driver brcms_pci_driver = {
+static struct bcma_driver brcms_bcma_driver = {
 	.name     = KBUILD_MODNAME,
-	.probe    = brcms_pci_probe,
+	.probe    = brcms_bcma_probe,
 	.suspend  = brcms_suspend,
 	.resume   = brcms_resume,
 	.remove   = __devexit_p(brcms_remove),
-	.id_table = brcms_pci_id_table,
+	.id_table = brcms_coreid_table,
 };
 
 /**
- * This is the main entry point for the WL driver.
+ * This is the main entry point for the brcmsmac driver.
  *
  * This function determines if a device pointed to by pdev is a WL device,
  * and if so, performs a brcms_attach() on it.
@@ -1256,26 +1216,24 @@ static int __init brcms_module_init(void)
 		brcm_msg_level = msglevel;
 #endif				/* BCMDBG */
 
-	error = pci_register_driver(&brcms_pci_driver);
+	error = bcma_driver_register(&brcms_bcma_driver);
+	printk(KERN_ERR "%s: register returned %d\n", __func__, error);
 	if (!error)
 		return 0;
 
-
-
 	return error;
 }
 
 /**
- * This function unloads the WL driver from the system.
+ * This function unloads the brcmsmac driver from the system.
  *
- * This function unconditionally unloads the WL driver module from the
+ * This function unconditionally unloads the brcmsmac driver module from the
  * system.
  *
  */
 static void __exit brcms_module_exit(void)
 {
-	pci_unregister_driver(&brcms_pci_driver);
-
+	bcma_driver_unregister(&brcms_bcma_driver);
 }
 
 module_init(brcms_module_init);
@@ -1562,7 +1520,7 @@ fail:
 }
 
 /*
- * Precondition: Since this function is called in brcms_pci_probe() context,
+ * Precondition: Since this function is called in brcms_bcma_probe() context,
  * no locking is required.
  */
 int brcms_ucode_init_uint(struct brcms_info *wl, size_t *n_bytes, u32 idx)
@@ -1602,7 +1560,7 @@ void brcms_ucode_free_buf(void *p)
 /*
  * checks validity of all firmware images loaded from user space
  *
- * Precondition: Since this function is called in brcms_pci_probe() context,
+ * Precondition: Since this function is called in brcms_bcma_probe() context,
  * no locking is required.
  */
 int brcms_check_firmwares(struct brcms_info *wl)
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
index 6242f18..8f60419 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.h
@@ -68,8 +68,6 @@ struct brcms_info {
 	spinlock_t lock;	/* per-device perimeter lock */
 	spinlock_t isr_lock;	/* per-device ISR synchronization lock */
 
-	/* regsva for unmap in brcms_free() */
-	void __iomem *regsva;	/* opaque chip registers virtual address */
 
 	/* timer related fields */
 	atomic_t callbacks;	/* # outstanding callback functions */
-- 
1.7.5.4


