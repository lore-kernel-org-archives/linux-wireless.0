Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ms-smtp-01.rdc-kc.rr.com ([24.94.166.115]:51234 "EHLO
	ms-smtp-01.rdc-kc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767567AbXEDBCo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 May 2007 21:02:44 -0400
Date: Thu, 03 May 2007 20:01:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
To: John Linville <linville@tuxdriver.com>
Cc: Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: [PATCH] bcm43xx: Remove dead configuration variable CONFIG_947XX
Message-ID: <463a85ce.UNBcSKi9Miz2B6RG%Larry.Finger@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The CONFIG_BCM947XX configuration variable was designed for use by the
embedded device used by the OpenWRT project. The device has been shifted
to the ssb driver in bcm43xx-mac80211 and will not be used with SoftMAC.
Accordingly, this "dead" configuration variable is removed.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

 bcm43xx.h      |   18 ++----------
 bcm43xx_dma.c  |    4 --
 bcm43xx_main.c |   81 ---------------------------------------------------------
 bcm43xx_main.h |   19 -------------
 4 files changed, 4 insertions(+), 118 deletions(-)

Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx.h
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx.h
@@ -658,12 +658,6 @@ struct bcm43xx_pio {
 
 #define BCM43xx_MAX_80211_CORES		2
 
-#ifdef CONFIG_BCM947XX
-#define core_offset(bcm) (bcm)->current_core_offset
-#else
-#define core_offset(bcm) 0
-#endif
-
 /* Generic information about a core. */
 struct bcm43xx_coreinfo {
 	u8 available:1,
@@ -789,10 +783,6 @@ struct bcm43xx_private {
 
 	/* The currently active core. */
 	struct bcm43xx_coreinfo *current_core;
-#ifdef CONFIG_BCM947XX
-	/** current core memory offset */
-	u32 current_core_offset;
-#endif
 	struct bcm43xx_coreinfo *active_80211_core;
 	/* coreinfo structs for all possible cores follow.
 	 * Note that a core might not exist.
@@ -943,25 +933,25 @@ struct bcm43xx_lopair * bcm43xx_get_lopa
 static inline
 u16 bcm43xx_read16(struct bcm43xx_private *bcm, u16 offset)
 {
-	return ioread16(bcm->mmio_addr + core_offset(bcm) + offset);
+	return ioread16(bcm->mmio_addr + offset);
 }
 
 static inline
 void bcm43xx_write16(struct bcm43xx_private *bcm, u16 offset, u16 value)
 {
-	iowrite16(value, bcm->mmio_addr + core_offset(bcm) + offset);
+	iowrite16(value, bcm->mmio_addr + offset);
 }
 
 static inline
 u32 bcm43xx_read32(struct bcm43xx_private *bcm, u16 offset)
 {
-	return ioread32(bcm->mmio_addr + core_offset(bcm) + offset);
+	return ioread32(bcm->mmio_addr + offset);
 }
 
 static inline
 void bcm43xx_write32(struct bcm43xx_private *bcm, u16 offset, u32 value)
 {
-	iowrite32(value, bcm->mmio_addr + core_offset(bcm) + offset);
+	iowrite32(value, bcm->mmio_addr + offset);
 }
 
 static inline
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_dma.c
@@ -660,10 +660,6 @@ struct bcm43xx_dmaring * bcm43xx_setup_d
 	ring->routing = BCM43xx_DMA32_CLIENTTRANS;
 	if (dma64)
 		ring->routing = BCM43xx_DMA64_CLIENTTRANS;
-#ifdef CONFIG_BCM947XX
-	if (bcm->pci_dev->bus->number == 0)
-		ring->routing = dma64 ? BCM43xx_DMA64_NOTRANS : BCM43xx_DMA32_NOTRANS;
-#endif
 
 	ring->bcm = bcm;
 	ring->nr_slots = nr_slots;
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.c
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.c
@@ -61,10 +61,6 @@ MODULE_AUTHOR("Stefano Brivio");
 MODULE_AUTHOR("Michael Buesch");
 MODULE_LICENSE("GPL");
 
-#ifdef CONFIG_BCM947XX
-extern char *nvram_get(char *name);
-#endif
-
 #if defined(CONFIG_BCM43XX_DMA) && defined(CONFIG_BCM43XX_PIO)
 static int modparam_pio;
 module_param_named(pio, modparam_pio, int, 0444);
@@ -142,10 +138,6 @@ MODULE_PARM_DESC(fwpostfix, "Postfix for
 	{ PCI_VENDOR_ID_BROADCOM, 0x4324, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
 	/* Broadcom 43XG 802.11b/g */
 	{ PCI_VENDOR_ID_BROADCOM, 0x4325, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-#ifdef CONFIG_BCM947XX
-	/* SB bus on BCM947xx */
-	{ PCI_VENDOR_ID_BROADCOM, 0x0800, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
-#endif
 	{ 0 },
 };
 MODULE_DEVICE_TABLE(pci, bcm43xx_pci_tbl);
@@ -786,9 +778,6 @@ static int bcm43xx_sprom_extract(struct 
 {
 	u16 value;
 	u16 *sprom;
-#ifdef CONFIG_BCM947XX
-	char *c;
-#endif
 
 	sprom = kzalloc(BCM43xx_SPROM_SIZE * sizeof(u16),
 			GFP_KERNEL);
@@ -796,28 +785,7 @@ static int bcm43xx_sprom_extract(struct 
 		printk(KERN_ERR PFX "sprom_extract OOM\n");
 		return -ENOMEM;
 	}
-#ifdef CONFIG_BCM947XX
-	sprom[BCM43xx_SPROM_BOARDFLAGS2] = atoi(nvram_get("boardflags2"));
-	sprom[BCM43xx_SPROM_BOARDFLAGS] = atoi(nvram_get("boardflags"));
-
-	if ((c = nvram_get("il0macaddr")) != NULL)
-		e_aton(c, (char *) &(sprom[BCM43xx_SPROM_IL0MACADDR]));
-
-	if ((c = nvram_get("et1macaddr")) != NULL)
-		e_aton(c, (char *) &(sprom[BCM43xx_SPROM_ET1MACADDR]));
-
-	sprom[BCM43xx_SPROM_PA0B0] = atoi(nvram_get("pa0b0"));
-	sprom[BCM43xx_SPROM_PA0B1] = atoi(nvram_get("pa0b1"));
-	sprom[BCM43xx_SPROM_PA0B2] = atoi(nvram_get("pa0b2"));
-
-	sprom[BCM43xx_SPROM_PA1B0] = atoi(nvram_get("pa1b0"));
-	sprom[BCM43xx_SPROM_PA1B1] = atoi(nvram_get("pa1b1"));
-	sprom[BCM43xx_SPROM_PA1B2] = atoi(nvram_get("pa1b2"));
-
-	sprom[BCM43xx_SPROM_BOARDREV] = atoi(nvram_get("boardrev"));
-#else
 	bcm43xx_sprom_read(bcm, sprom);
-#endif
 
 	/* boardflags2 */
 	value = sprom[BCM43xx_SPROM_BOARDFLAGS2];
@@ -1225,12 +1193,6 @@ static int _switch_core(struct bcm43xx_p
 			goto error;
 		udelay(10);
 	}
-#ifdef CONFIG_BCM947XX
-	if (bcm->pci_dev->bus->number == 0)
-		bcm->current_core_offset = 0x1000 * core;
-	else
-		bcm->current_core_offset = 0;
-#endif
 
 	return 0;
 error:
@@ -1387,19 +1349,6 @@ void bcm43xx_wireless_core_reset(struct 
 
 	if ((bcm43xx_core_enabled(bcm)) &&
 	    !bcm43xx_using_pio(bcm)) {
-//FIXME: Do we _really_ want #ifndef CONFIG_BCM947XX here?
-#if 0
-#ifndef CONFIG_BCM947XX
-		/* reset all used DMA controllers. */
-		bcm43xx_dmacontroller_tx_reset(bcm, BCM43xx_MMIO_DMA1_BASE);
-		bcm43xx_dmacontroller_tx_reset(bcm, BCM43xx_MMIO_DMA2_BASE);
-		bcm43xx_dmacontroller_tx_reset(bcm, BCM43xx_MMIO_DMA3_BASE);
-		bcm43xx_dmacontroller_tx_reset(bcm, BCM43xx_MMIO_DMA4_BASE);
-		bcm43xx_dmacontroller_rx_reset(bcm, BCM43xx_MMIO_DMA1_BASE);
-		if (bcm->current_core->rev < 5)
-			bcm43xx_dmacontroller_rx_reset(bcm, BCM43xx_MMIO_DMA4_BASE);
-#endif
-#endif
 	}
 	if (bcm43xx_status(bcm) == BCM43xx_STAT_SHUTTINGDOWN) {
 		bcm43xx_write32(bcm, BCM43xx_MMIO_STATUS_BITFIELD,
@@ -2140,32 +2089,11 @@ out:
 	return err;
 }
 
-#ifdef CONFIG_BCM947XX
-static struct pci_device_id bcm43xx_47xx_ids[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_BROADCOM, 0x4324) },
-	{ 0 }
-};
-#endif
-
 static int bcm43xx_initialize_irq(struct bcm43xx_private *bcm)
 {
 	int err;
 
 	bcm->irq = bcm->pci_dev->irq;
-#ifdef CONFIG_BCM947XX
-	if (bcm->pci_dev->bus->number == 0) {
-		struct pci_dev *d;
-		struct pci_device_id *id;
-		for (id = bcm43xx_47xx_ids; id->vendor; id++) {
-			d = pci_get_device(id->vendor, id->device, NULL);
-			if (d != NULL) {
-				bcm->irq = d->irq;
-				pci_dev_put(d);
-				break;
-			}
-		}
-	}
-#endif
 	err = request_irq(bcm->irq, bcm43xx_interrupt_handler,
 			  IRQF_SHARED, KBUILD_MODNAME, bcm);
 	if (err)
@@ -2645,10 +2573,6 @@ static int bcm43xx_probe_cores(struct bc
 			chip_id_16 = 0x4610;
 		else if ((pci_device >= 0x4710) && (pci_device <= 0x4715))
 			chip_id_16 = 0x4710;
-#ifdef CONFIG_BCM947XX
-		else if ((pci_device >= 0x4320) && (pci_device <= 0x4325))
-			chip_id_16 = 0x4309;
-#endif
 		else {
 			printk(KERN_ERR PFX "Could not determine Chip ID\n");
 			return -ENODEV;
@@ -4144,11 +4068,6 @@ static int __devinit bcm43xx_init_one(st
 	struct bcm43xx_private *bcm;
 	int err;
 
-#ifdef CONFIG_BCM947XX
-	if ((pdev->bus->number == 0) && (pdev->device != 0x0800))
-		return -ENODEV;
-#endif
-
 #ifdef DEBUG_SINGLE_DEVICE_ONLY
 	if (strcmp(pci_name(pdev), DEBUG_SINGLE_DEVICE_ONLY))
 		return -ENODEV;
Index: wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.h
===================================================================
--- wireless-2.6.orig/drivers/net/wireless/bcm43xx/bcm43xx_main.h
+++ wireless-2.6/drivers/net/wireless/bcm43xx/bcm43xx_main.h
@@ -33,25 +33,6 @@
 
 #include "bcm43xx.h"
 
-#ifdef CONFIG_BCM947XX
-#define atoi(str) simple_strtoul(((str != NULL) ? str : ""), NULL, 0)
-
-static inline void e_aton(char *str, char *dest)
-{
-	int i = 0;
-	u16 *d = (u16 *) dest;
-
-	for (;;) {
-		dest[i++] = (char) simple_strtoul(str, NULL, 16);
-		str += 2;
-		if (!*str++ || i == 6)
-			break;
-	}
-	for (i = 0; i < 3; i++)
-		d[i] = cpu_to_be16(d[i]);
-}
-#endif
-
 #define P4D_BYT3S(magic, nr_bytes)	u8 __p4dding##magic[nr_bytes]
 #define P4D_BYTES(line, nr_bytes)	P4D_BYT3S(line, nr_bytes)
 /* Magic helper macro to pad structures. Ignore those above. It's magic. */
