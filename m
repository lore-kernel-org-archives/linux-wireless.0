Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:46727 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756419Ab1FUS3O (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Jun 2011 14:29:14 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mb@bu3sch.de, linville@tuxdriver.com
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org,
	linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] ssb: add __devinit to some functions
Date: Tue, 21 Jun 2011 20:28:09 +0200
Message-Id: <1308680889-4217-1-git-send-email-hauke@hauke-m.de> (sfid-20110621_202918_387342_DD62E1CF)
In-Reply-To: <20110621150227.GB14197@linux-mips.org>
References: <20110621150227.GB14197@linux-mips.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two functions in ssb are using register_pci_controller() which is
__devinit. The functions ssb_pcicore_init_hostmode() and
ssb_gige_probe() should also be __devinit.

This fixes the following warning:
WARNING: vmlinux.o(.text+0x2727b8): Section mismatch in reference from the function ssb_pcicore_init_hostmode() to the function .devinit.text:register_pci_controller()
The function ssb_pcicore_init_hostmode() references
the function __devinit register_pci_controller().
This is often because ssb_pcicore_init_hostmode lacks a __devinit
annotation or the annotation of register_pci_controller is wrong.

WARNING: vmlinux.o(.text+0x273398): Section mismatch in reference from the function ssb_gige_probe() to the function .devinit.text:register_pci_controller()
The function ssb_gige_probe() references
the function __devinit register_pci_controller().
This is often because ssb_gige_probe lacks a __devinit
annotation or the annotation of register_pci_controller is wrong.

Reported-by: Ralf Baechle <ralf@linux-mips.org>
---
 drivers/net/b44.c               |    4 ++--
 drivers/net/wireless/b43/sdio.c |    6 +++---
 drivers/ssb/driver_gige.c       |   10 +++++-----
 drivers/ssb/driver_pcicore.c    |   10 +++++-----
 drivers/ssb/main.c              |   29 +++++++++++++++--------------
 drivers/ssb/pcihost_wrapper.c   |    6 +++---
 6 files changed, 33 insertions(+), 32 deletions(-)

diff --git a/drivers/net/b44.c b/drivers/net/b44.c
index 085560e..cced4fd 100644
--- a/drivers/net/b44.c
+++ b/drivers/net/b44.c
@@ -2336,7 +2336,7 @@ static struct ssb_driver b44_ssb_driver = {
 	.resume		= b44_resume,
 };
 
-static inline int b44_pci_init(void)
+static inline int __init b44_pci_init(void)
 {
 	int err = 0;
 #ifdef CONFIG_B44_PCI
@@ -2345,7 +2345,7 @@ static inline int b44_pci_init(void)
 	return err;
 }
 
-static inline void b44_pci_exit(void)
+static inline void __exit b44_pci_exit(void)
 {
 #ifdef CONFIG_B44_PCI
 	ssb_pcihost_unregister(&b44_pci_driver);
diff --git a/drivers/net/wireless/b43/sdio.c b/drivers/net/wireless/b43/sdio.c
index e6c733d..4fd6775 100644
--- a/drivers/net/wireless/b43/sdio.c
+++ b/drivers/net/wireless/b43/sdio.c
@@ -93,8 +93,8 @@ void b43_sdio_free_irq(struct b43_wldev *dev)
 	sdio->irq_handler = NULL;
 }
 
-static int b43_sdio_probe(struct sdio_func *func,
-			  const struct sdio_device_id *id)
+static int __devinit b43_sdio_probe(struct sdio_func *func,
+				    const struct sdio_device_id *id)
 {
 	struct b43_sdio *sdio;
 	struct sdio_func_tuple *tuple;
@@ -171,7 +171,7 @@ out:
 	return error;
 }
 
-static void b43_sdio_remove(struct sdio_func *func)
+static void __devexit b43_sdio_remove(struct sdio_func *func)
 {
 	struct b43_sdio *sdio = sdio_get_drvdata(func);
 
diff --git a/drivers/ssb/driver_gige.c b/drivers/ssb/driver_gige.c
index 5ba92a2..0de23df 100644
--- a/drivers/ssb/driver_gige.c
+++ b/drivers/ssb/driver_gige.c
@@ -106,8 +106,8 @@ void gige_pcicfg_write32(struct ssb_gige *dev,
 	gige_write32(dev, SSB_GIGE_PCICFG + offset, value);
 }
 
-static int ssb_gige_pci_read_config(struct pci_bus *bus, unsigned int devfn,
-				    int reg, int size, u32 *val)
+static int __devinit ssb_gige_pci_read_config(struct pci_bus *bus, unsigned int devfn,
+					      int reg, int size, u32 *val)
 {
 	struct ssb_gige *dev = container_of(bus->ops, struct ssb_gige, pci_ops);
 	unsigned long flags;
@@ -136,8 +136,8 @@ static int ssb_gige_pci_read_config(struct pci_bus *bus, unsigned int devfn,
 	return PCIBIOS_SUCCESSFUL;
 }
 
-static int ssb_gige_pci_write_config(struct pci_bus *bus, unsigned int devfn,
-				     int reg, int size, u32 val)
+static int __devinit ssb_gige_pci_write_config(struct pci_bus *bus, unsigned int devfn,
+					       int reg, int size, u32 val)
 {
 	struct ssb_gige *dev = container_of(bus->ops, struct ssb_gige, pci_ops);
 	unsigned long flags;
@@ -166,7 +166,7 @@ static int ssb_gige_pci_write_config(struct pci_bus *bus, unsigned int devfn,
 	return PCIBIOS_SUCCESSFUL;
 }
 
-static int ssb_gige_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
+static int __devinit ssb_gige_probe(struct ssb_device *sdev, const struct ssb_device_id *id)
 {
 	struct ssb_gige *dev;
 	u32 base, tmslow, tmshigh;
diff --git a/drivers/ssb/driver_pcicore.c b/drivers/ssb/driver_pcicore.c
index 2a20dab..21b9465 100644
--- a/drivers/ssb/driver_pcicore.c
+++ b/drivers/ssb/driver_pcicore.c
@@ -314,7 +314,7 @@ int ssb_pcicore_pcibios_map_irq(const struct pci_dev *dev, u8 slot, u8 pin)
 	return ssb_mips_irq(extpci_core->dev) + 2;
 }
 
-static void ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
+static void __devinit ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
 {
 	u32 val;
 
@@ -379,7 +379,7 @@ static void ssb_pcicore_init_hostmode(struct ssb_pcicore *pc)
 	register_pci_controller(&ssb_pcicore_controller);
 }
 
-static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
+static int __devinit pcicore_is_in_hostmode(struct ssb_pcicore *pc)
 {
 	struct ssb_bus *bus = pc->dev->bus;
 	u16 chipid_top;
@@ -412,7 +412,7 @@ static int pcicore_is_in_hostmode(struct ssb_pcicore *pc)
  * Workarounds.
  **************************************************/
 
-static void ssb_pcicore_fix_sprom_core_index(struct ssb_pcicore *pc)
+static void __devinit ssb_pcicore_fix_sprom_core_index(struct ssb_pcicore *pc)
 {
 	u16 tmp = pcicore_read16(pc, SSB_PCICORE_SPROM(0));
 	if (((tmp & 0xF000) >> 12) != pc->dev->core_index) {
@@ -514,13 +514,13 @@ static void ssb_pcicore_pcie_setup_workarounds(struct ssb_pcicore *pc)
  * Generic and Clientmode operation code.
  **************************************************/
 
-static void ssb_pcicore_init_clientmode(struct ssb_pcicore *pc)
+static void __devinit ssb_pcicore_init_clientmode(struct ssb_pcicore *pc)
 {
 	/* Disable PCI interrupts. */
 	ssb_write32(pc->dev, SSB_INTVEC, 0);
 }
 
-void ssb_pcicore_init(struct ssb_pcicore *pc)
+void __devinit ssb_pcicore_init(struct ssb_pcicore *pc)
 {
 	struct ssb_device *dev = pc->dev;
 
diff --git a/drivers/ssb/main.c b/drivers/ssb/main.c
index f8a13f8..e568664 100644
--- a/drivers/ssb/main.c
+++ b/drivers/ssb/main.c
@@ -557,7 +557,7 @@ error:
 }
 
 /* Needs ssb_buses_lock() */
-static int ssb_attach_queued_buses(void)
+static int __devinit ssb_attach_queued_buses(void)
 {
 	struct ssb_bus *bus, *n;
 	int err = 0;
@@ -768,9 +768,9 @@ out:
 	return err;
 }
 
-static int ssb_bus_register(struct ssb_bus *bus,
-			    ssb_invariants_func_t get_invariants,
-			    unsigned long baseaddr)
+static int __devinit ssb_bus_register(struct ssb_bus *bus,
+				      ssb_invariants_func_t get_invariants,
+				      unsigned long baseaddr)
 {
 	int err;
 
@@ -851,8 +851,8 @@ err_disable_xtal:
 }
 
 #ifdef CONFIG_SSB_PCIHOST
-int ssb_bus_pcibus_register(struct ssb_bus *bus,
-			    struct pci_dev *host_pci)
+int __devinit ssb_bus_pcibus_register(struct ssb_bus *bus,
+				      struct pci_dev *host_pci)
 {
 	int err;
 
@@ -875,9 +875,9 @@ EXPORT_SYMBOL(ssb_bus_pcibus_register);
 #endif /* CONFIG_SSB_PCIHOST */
 
 #ifdef CONFIG_SSB_PCMCIAHOST
-int ssb_bus_pcmciabus_register(struct ssb_bus *bus,
-			       struct pcmcia_device *pcmcia_dev,
-			       unsigned long baseaddr)
+int __devinit ssb_bus_pcmciabus_register(struct ssb_bus *bus,
+					 struct pcmcia_device *pcmcia_dev,
+					 unsigned long baseaddr)
 {
 	int err;
 
@@ -897,8 +897,9 @@ EXPORT_SYMBOL(ssb_bus_pcmciabus_register);
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
 #ifdef CONFIG_SSB_SDIOHOST
-int ssb_bus_sdiobus_register(struct ssb_bus *bus, struct sdio_func *func,
-			     unsigned int quirks)
+int __devinit ssb_bus_sdiobus_register(struct ssb_bus *bus,
+				       struct sdio_func *func,
+				       unsigned int quirks)
 {
 	int err;
 
@@ -918,9 +919,9 @@ int ssb_bus_sdiobus_register(struct ssb_bus *bus, struct sdio_func *func,
 EXPORT_SYMBOL(ssb_bus_sdiobus_register);
 #endif /* CONFIG_SSB_PCMCIAHOST */
 
-int ssb_bus_ssbbus_register(struct ssb_bus *bus,
-			    unsigned long baseaddr,
-			    ssb_invariants_func_t get_invariants)
+int __devinit ssb_bus_ssbbus_register(struct ssb_bus *bus,
+				      unsigned long baseaddr,
+				      ssb_invariants_func_t get_invariants)
 {
 	int err;
 
diff --git a/drivers/ssb/pcihost_wrapper.c b/drivers/ssb/pcihost_wrapper.c
index f6c8c81..d7a9813 100644
--- a/drivers/ssb/pcihost_wrapper.c
+++ b/drivers/ssb/pcihost_wrapper.c
@@ -53,8 +53,8 @@ static int ssb_pcihost_resume(struct pci_dev *dev)
 # define ssb_pcihost_resume	NULL
 #endif /* CONFIG_PM */
 
-static int ssb_pcihost_probe(struct pci_dev *dev,
-			     const struct pci_device_id *id)
+static int __devinit ssb_pcihost_probe(struct pci_dev *dev,
+				       const struct pci_device_id *id)
 {
 	struct ssb_bus *ssb;
 	int err = -ENOMEM;
@@ -110,7 +110,7 @@ static void ssb_pcihost_remove(struct pci_dev *dev)
 	pci_set_drvdata(dev, NULL);
 }
 
-int ssb_pcihost_register(struct pci_driver *driver)
+int __devinit ssb_pcihost_register(struct pci_driver *driver)
 {
 	driver->probe = ssb_pcihost_probe;
 	driver->remove = ssb_pcihost_remove;
-- 
1.7.4.1

