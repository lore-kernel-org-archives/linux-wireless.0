Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:56629 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab0KKO55 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Nov 2010 09:57:57 -0500
Date: Thu, 11 Nov 2010 15:57:51 +0100 (CET)
From: Wojciech Dubowik <dubowoj@neratec.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Message-ID: <20828465.1051289487469083.JavaMail.wlan@CHBU500181>
In-Reply-To: <21800237.971289487370894.JavaMail.wlan@CHBU500181>
Subject: [PATCH 3/9] ath5k: AHB port. Move pci related functions to separate
 file.
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Separate PCI related functions from base into own file.

Signed-off-by: Wojciech Dubowik <Wojciech.Dubowik@neratec.com>
---
 drivers/net/wireless/ath/ath5k/Makefile |    1 +
 drivers/net/wireless/ath/ath5k/ath5k.h  |    6 +
 drivers/net/wireless/ath/ath5k/base.c   |  269 +-----------------------------
 drivers/net/wireless/ath/ath5k/pci.c    |  285 +++++++++++++++++++++++++++++++
 4 files changed, 294 insertions(+), 267 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath5k/pci.c

diff --git a/drivers/net/wireless/ath/ath5k/Makefile b/drivers/net/wireless/ath/ath5k/Makefile
index 2242a14..dae881c 100644
--- a/drivers/net/wireless/ath/ath5k/Makefile
+++ b/drivers/net/wireless/ath/ath5k/Makefile
@@ -15,4 +15,5 @@ ath5k-y				+= rfkill.o
 ath5k-y				+= ani.o
 ath5k-y				+= sysfs.o
 ath5k-$(CONFIG_ATH5K_DEBUG)	+= debug.o
+ath5k-y				+= pci.o
 obj-$(CONFIG_ATH5K)		+= ath5k.o
diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 09c3ede..2524a6c 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1131,14 +1131,20 @@ struct ath5k_hw {
 /*
  * Prototypes
  */
+extern const struct ieee80211_ops ath5k_hw_ops;
 
 /* Attach/Detach Functions */
+int ath5k_attach(struct ath5k_softc *sc, const struct ath_bus_ops *bus_ops);
+void ath5k_detach(struct ath5k_softc *sc);
 int ath5k_hw_attach(struct ath5k_softc *sc);
 void ath5k_hw_detach(struct ath5k_hw *ah);
 
 int ath5k_sysfs_register(struct ath5k_softc *sc);
 void ath5k_sysfs_unregister(struct ath5k_softc *sc);
 
+/*chip id helper function */
+const char * ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val);
+
 /* LED functions */
 int ath5k_init_leds(struct ath5k_softc *sc);
 void ath5k_led_enable(struct ath5k_softc *sc);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index fbe82be..22464e2 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -47,8 +47,6 @@
 #include <linux/io.h>
 #include <linux/netdevice.h>
 #include <linux/cache.h>
-#include <linux/pci.h>
-#include <linux/pci-aspm.h>
 #include <linux/ethtool.h>
 #include <linux/uaccess.h>
 #include <linux/slab.h>
@@ -86,30 +84,6 @@ static int ath5k_beacon_update(struct ieee80211_hw *hw,
 		struct ieee80211_vif *vif);
 static void ath5k_beacon_update_timers(struct ath5k_softc *sc, u64 bc_tsf);
 
-/* Known PCI ids */
-static DEFINE_PCI_DEVICE_TABLE(ath5k_pci_id_table) = {
-	{ PCI_VDEVICE(ATHEROS, 0x0207) }, /* 5210 early */
-	{ PCI_VDEVICE(ATHEROS, 0x0007) }, /* 5210 */
-	{ PCI_VDEVICE(ATHEROS, 0x0011) }, /* 5311 - this is on AHB bus !*/
-	{ PCI_VDEVICE(ATHEROS, 0x0012) }, /* 5211 */
-	{ PCI_VDEVICE(ATHEROS, 0x0013) }, /* 5212 */
-	{ PCI_VDEVICE(3COM_2,  0x0013) }, /* 3com 5212 */
-	{ PCI_VDEVICE(3COM,    0x0013) }, /* 3com 3CRDAG675 5212 */
-	{ PCI_VDEVICE(ATHEROS, 0x1014) }, /* IBM minipci 5212 */
-	{ PCI_VDEVICE(ATHEROS, 0x0014) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0015) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0016) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0017) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0018) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x0019) }, /* 5212 combatible */
-	{ PCI_VDEVICE(ATHEROS, 0x001a) }, /* 2413 Griffin-lite */
-	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
-	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
-	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
-	{ 0 }
-};
-MODULE_DEVICE_TABLE(pci, ath5k_pci_id_table);
-
 /* Known SREVs */
 static const struct ath5k_srev_name srev_names[] = {
 	{ "5210",	AR5K_VERSION_MAC,	AR5K_SREV_AR5210 },
@@ -192,32 +166,6 @@ static const struct ieee80211_rate ath5k_rates[] = {
 	/* XR missing */
 };
 
-/* return bus cachesize in 4B word units */
-static void ath5k_pci_read_cachesize(struct ath_common *common, int *csz)
-{
-	struct ath5k_softc *sc = (struct ath5k_softc *) common->priv;
-	u8 u8tmp;
-
-	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, &u8tmp);
-	*csz = (int)u8tmp;
-
-	/*
-	 * This check was put in to avoid "unplesant" consequences if
-	 * the bootrom has not fully initialized all PCI devices.
-	 * Sometimes the cache line size register is not set
-	 */
-
-	if (*csz == 0)
-		*csz = L1_CACHE_BYTES >> 2;   /* Use the default size */
-}
-
-/* Common ath_bus_opts structure */
-static const struct ath_bus_ops ath_pci_bus_ops = {
-	.ath_bus_type = ATH_PCI,
-	.read_cachesize = ath5k_pci_read_cachesize,
-};
-
-
 static inline void ath5k_txbuf_free_skb(struct ath5k_softc *sc,
 				struct ath5k_buf *bf)
 {
@@ -260,7 +208,7 @@ static inline u64 ath5k_extend_tsf(struct ath5k_hw *ah, u32 rstamp)
 	return (tsf & ~0x7fff) | rstamp;
 }
 
-static const char *
+const char *
 ath5k_chip_name(enum ath5k_srev_type type, u_int16_t val)
 {
 	const char *name = "xxxxx";
@@ -2929,7 +2877,7 @@ err:
 	return ret;
 }
 
-static void
+void
 ath5k_detach(struct ath5k_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -3620,216 +3568,3 @@ const struct ieee80211_ops ath5k_hw_ops = {
 	.sw_scan_complete = ath5k_sw_scan_complete,
 	.set_coverage_class = ath5k_set_coverage_class,
 };
-
-/********************\
-* PCI Initialization *
-\********************/
-
-static int __devinit
-ath5k_pci_probe(struct pci_dev *pdev,
-		const struct pci_device_id *id)
-{
-	void __iomem *mem;
-	struct ath5k_softc *sc;
-	struct ieee80211_hw *hw;
-	int ret;
-	u8 csz;
-
-	/*
-	 * L0s needs to be disabled on all ath5k cards.
-	 *
-	 * For distributions shipping with CONFIG_PCIEASPM (this will be enabled
-	 * by default in the future in 2.6.36) this will also mean both L1 and
-	 * L0s will be disabled when a pre 1.1 PCIe device is detected. We do
-	 * know L1 works correctly even for all ath5k pre 1.1 PCIe devices
-	 * though but cannot currently undue the effect of a blacklist, for
-	 * details you can read pcie_aspm_sanity_check() and see how it adjusts
-	 * the device link capability.
-	 *
-	 * It may be possible in the future to implement some PCI API to allow
-	 * drivers to override blacklists for pre 1.1 PCIe but for now it is
-	 * best to accept that both L0s and L1 will be disabled completely for
-	 * distributions shipping with CONFIG_PCIEASPM rather than having this
-	 * issue present. Motivation for adding this new API will be to help
-	 * with power consumption for some of these devices.
-	 */
-	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
-
-	ret = pci_enable_device(pdev);
-	if (ret) {
-		dev_err(&pdev->dev, "can't enable device\n");
-		goto err;
-	}
-
-	/* XXX 32-bit addressing only */
-	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
-	if (ret) {
-		dev_err(&pdev->dev, "32-bit DMA not available\n");
-		goto err_dis;
-	}
-
-	/*
-	 * Cache line size is used to size and align various
-	 * structures used to communicate with the hardware.
-	 */
-	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
-	if (csz == 0) {
-		/*
-		 * Linux 2.4.18 (at least) writes the cache line size
-		 * register as a 16-bit wide register which is wrong.
-		 * We must have this setup properly for rx buffer
-		 * DMA to work so force a reasonable value here if it
-		 * comes up zero.
-		 */
-		csz = L1_CACHE_BYTES >> 2;
-		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
-	}
-	/*
-	 * The default setting of latency timer yields poor results,
-	 * set it to the value used by other systems.  It may be worth
-	 * tweaking this setting more.
-	 */
-	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
-
-	/* Enable bus mastering */
-	pci_set_master(pdev);
-
-	/*
-	 * Disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state.
-	 */
-	pci_write_config_byte(pdev, 0x41, 0);
-
-	ret = pci_request_region(pdev, 0, "ath5k");
-	if (ret) {
-		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
-		goto err_dis;
-	}
-
-	mem = pci_iomap(pdev, 0, 0);
-	if (!mem) {
-		dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
-		ret = -EIO;
-		goto err_reg;
-	}
-
-	/*
-	 * Allocate hw (mac80211 main struct)
-	 * and hw->priv (driver private data)
-	 */
-	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
-	if (hw == NULL) {
-		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
-		ret = -ENOMEM;
-		goto err_map;
-	}
-
-	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
-
-	sc = hw->priv;
-	sc->hw = hw;
-	sc->pdev = pdev;
-	sc->dev = &pdev->dev;
-	sc->irq = pdev->irq;
-	sc->devid = id->device;
-	sc->iobase = mem; /* So we can unmap it on detach */
-
-	/* Initialize */
-	ret = ath5k_attach(sc, &ath_pci_bus_ops);
-	if (ret) {
-		goto err_free;
-	}
-
-	/* Set private data */
-	pci_set_drvdata(pdev, hw);
-
-	return 0;
-err_free:
-	ieee80211_free_hw(hw);
-err_map:
-	pci_iounmap(pdev, mem);
-err_reg:
-	pci_release_region(pdev, 0);
-err_dis:
-	pci_disable_device(pdev);
-err:
-	return ret;
-}
-
-static void __devexit
-ath5k_pci_remove(struct pci_dev *pdev)
-{
-	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
-	struct ath5k_softc *sc = hw->priv;
-
-	ath5k_detach(sc);
-	pci_iounmap(pdev, sc->iobase);
-	pci_release_region(pdev, 0);
-	pci_disable_device(pdev);
-	ieee80211_free_hw(hw);
-}
-
-#ifdef CONFIG_PM_SLEEP
-static int ath5k_pci_suspend(struct device *dev)
-{
-	struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
-
-	ath5k_led_off(sc);
-	return 0;
-}
-
-static int ath5k_pci_resume(struct device *dev)
-{
-	struct pci_dev *pdev = to_pci_dev(dev);
-	struct ath5k_softc *sc = pci_get_drvdata(pdev);
-
-	/*
-	 * Suspend/Resume resets the PCI configuration space, so we have to
-	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
-	 * PCI Tx retries from interfering with C3 CPU state
-	 */
-	pci_write_config_byte(pdev, 0x41, 0);
-
-	ath5k_led_enable(sc);
-	return 0;
-}
-
-static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
-#define ATH5K_PM_OPS	(&ath5k_pm_ops)
-#else
-#define ATH5K_PM_OPS	NULL
-#endif /* CONFIG_PM_SLEEP */
-
-static struct pci_driver ath5k_pci_driver = {
-	.name		= KBUILD_MODNAME,
-	.id_table	= ath5k_pci_id_table,
-	.probe		= ath5k_pci_probe,
-	.remove		= __devexit_p(ath5k_pci_remove),
-	.driver.pm	= ATH5K_PM_OPS,
-};
-
-/*
- * Module init/exit functions
- */
-static int __init
-init_ath5k_pci(void)
-{
-	int ret;
-
-	ret = pci_register_driver(&ath5k_pci_driver);
-	if (ret) {
-		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
-		return ret;
-	}
-
-	return 0;
-}
-
-static void __exit
-exit_ath5k_pci(void)
-{
-	pci_unregister_driver(&ath5k_pci_driver);
-}
-
-module_init(init_ath5k_pci);
-module_exit(exit_ath5k_pci);
diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
new file mode 100644
index 0000000..0653659
--- /dev/null
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -0,0 +1,285 @@
+/*
+ * Copyright (c) 2008-2009 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#include <linux/nl80211.h>
+#include <linux/pci.h>
+#include <linux/pci-aspm.h>
+#include "../ath.h"
+#include "ath5k.h"
+#include "debug.h"
+#include "base.h"
+#include "reg.h"
+
+/* Known PCI ids */
+static DEFINE_PCI_DEVICE_TABLE(ath5k_pci_id_table) = {
+	{ PCI_VDEVICE(ATHEROS, 0x0207) }, /* 5210 early */
+	{ PCI_VDEVICE(ATHEROS, 0x0007) }, /* 5210 */
+	{ PCI_VDEVICE(ATHEROS, 0x0011) }, /* 5311 - this is on AHB bus !*/
+	{ PCI_VDEVICE(ATHEROS, 0x0012) }, /* 5211 */
+	{ PCI_VDEVICE(ATHEROS, 0x0013) }, /* 5212 */
+	{ PCI_VDEVICE(3COM_2,  0x0013) }, /* 3com 5212 */
+	{ PCI_VDEVICE(3COM,    0x0013) }, /* 3com 3CRDAG675 5212 */
+	{ PCI_VDEVICE(ATHEROS, 0x1014) }, /* IBM minipci 5212 */
+	{ PCI_VDEVICE(ATHEROS, 0x0014) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0015) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0016) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0017) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0018) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x0019) }, /* 5212 combatible */
+	{ PCI_VDEVICE(ATHEROS, 0x001a) }, /* 2413 Griffin-lite */
+	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
+	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
+	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
+	{ 0 }
+};
+
+/* return bus cachesize in 4B word units */
+static void ath5k_pci_read_cachesize(struct ath_common *common, int *csz)
+{
+	struct ath5k_softc *sc = (struct ath5k_softc *) common->priv;
+	u8 u8tmp;
+
+	pci_read_config_byte(sc->pdev, PCI_CACHE_LINE_SIZE, &u8tmp);
+	*csz = (int)u8tmp;
+
+	/*
+	 * This check was put in to avoid "unplesant" consequences if
+	 * the bootrom has not fully initialized all PCI devices.
+	 * Sometimes the cache line size register is not set
+	 */
+
+	if (*csz == 0)
+		*csz = L1_CACHE_BYTES >> 2;   /* Use the default size */
+}
+
+/* Common ath_bus_opts structure */
+static const struct ath_bus_ops ath_pci_bus_ops = {
+	.ath_bus_type = ATH_PCI,
+	.read_cachesize = ath5k_pci_read_cachesize,
+};
+
+/********************\
+* PCI Initialization *
+\********************/
+
+static int __devinit
+ath5k_pci_probe(struct pci_dev *pdev,
+		const struct pci_device_id *id)
+{
+	void __iomem *mem;
+	struct ath5k_softc *sc;
+	struct ieee80211_hw *hw;
+	int ret;
+	u8 csz;
+
+	/*
+	 * L0s needs to be disabled on all ath5k cards.
+	 *
+	 * For distributions shipping with CONFIG_PCIEASPM (this will be enabled
+	 * by default in the future in 2.6.36) this will also mean both L1 and
+	 * L0s will be disabled when a pre 1.1 PCIe device is detected. We do
+	 * know L1 works correctly even for all ath5k pre 1.1 PCIe devices
+	 * though but cannot currently undue the effect of a blacklist, for
+	 * details you can read pcie_aspm_sanity_check() and see how it adjusts
+	 * the device link capability.
+	 *
+	 * It may be possible in the future to implement some PCI API to allow
+	 * drivers to override blacklists for pre 1.1 PCIe but for now it is
+	 * best to accept that both L0s and L1 will be disabled completely for
+	 * distributions shipping with CONFIG_PCIEASPM rather than having this
+	 * issue present. Motivation for adding this new API will be to help
+	 * with power consumption for some of these devices.
+	 */
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S);
+
+	ret = pci_enable_device(pdev);
+	if (ret) {
+		dev_err(&pdev->dev, "can't enable device\n");
+		goto err;
+	}
+
+	/* XXX 32-bit addressing only */
+	ret = pci_set_dma_mask(pdev, DMA_BIT_MASK(32));
+	if (ret) {
+		dev_err(&pdev->dev, "32-bit DMA not available\n");
+		goto err_dis;
+	}
+
+	/*
+	 * Cache line size is used to size and align various
+	 * structures used to communicate with the hardware.
+	 */
+	pci_read_config_byte(pdev, PCI_CACHE_LINE_SIZE, &csz);
+	if (csz == 0) {
+		/*
+		 * Linux 2.4.18 (at least) writes the cache line size
+		 * register as a 16-bit wide register which is wrong.
+		 * We must have this setup properly for rx buffer
+		 * DMA to work so force a reasonable value here if it
+		 * comes up zero.
+		 */
+		csz = L1_CACHE_BYTES >> 2;
+		pci_write_config_byte(pdev, PCI_CACHE_LINE_SIZE, csz);
+	}
+	/*
+	 * The default setting of latency timer yields poor results,
+	 * set it to the value used by other systems.  It may be worth
+	 * tweaking this setting more.
+	 */
+	pci_write_config_byte(pdev, PCI_LATENCY_TIMER, 0xa8);
+
+	/* Enable bus mastering */
+	pci_set_master(pdev);
+
+	/*
+	 * Disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state.
+	 */
+	pci_write_config_byte(pdev, 0x41, 0);
+
+	ret = pci_request_region(pdev, 0, "ath5k");
+	if (ret) {
+		dev_err(&pdev->dev, "cannot reserve PCI memory region\n");
+		goto err_dis;
+	}
+
+	mem = pci_iomap(pdev, 0, 0);
+	if (!mem) {
+		dev_err(&pdev->dev, "cannot remap PCI memory region\n") ;
+		ret = -EIO;
+		goto err_reg;
+	}
+
+	/*
+	 * Allocate hw (mac80211 main struct)
+	 * and hw->priv (driver private data)
+	 */
+	hw = ieee80211_alloc_hw(sizeof(*sc), &ath5k_hw_ops);
+	if (hw == NULL) {
+		dev_err(&pdev->dev, "cannot allocate ieee80211_hw\n");
+		ret = -ENOMEM;
+		goto err_map;
+	}
+
+	dev_info(&pdev->dev, "registered as '%s'\n", wiphy_name(hw->wiphy));
+
+	sc = hw->priv;
+	sc->hw = hw;
+	sc->pdev = pdev;
+	sc->dev = &pdev->dev;
+	sc->irq = pdev->irq;
+	sc->devid = id->device;
+	sc->iobase = mem; /* So we can unmap it on detach */
+
+	/* Initialize */
+	ret = ath5k_attach(sc, &ath_pci_bus_ops);
+	if (ret) {
+		goto err_free;
+	}
+
+	/* Set private data */
+	pci_set_drvdata(pdev, hw);
+
+	return 0;
+err_free:
+	ieee80211_free_hw(hw);
+err_map:
+	pci_iounmap(pdev, mem);
+err_reg:
+	pci_release_region(pdev, 0);
+err_dis:
+	pci_disable_device(pdev);
+err:
+	return ret;
+}
+
+static void __devexit
+ath5k_pci_remove(struct pci_dev *pdev)
+{
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
+	struct ath5k_softc *sc = hw->priv;
+
+	ath5k_detach(sc);
+	pci_iounmap(pdev, sc->iobase);
+	pci_release_region(pdev, 0);
+	pci_disable_device(pdev);
+	ieee80211_free_hw(hw);
+}
+
+#ifdef CONFIG_PM_SLEEP
+static int ath5k_pci_suspend(struct device *dev)
+{
+	struct ath5k_softc *sc = pci_get_drvdata(to_pci_dev(dev));
+
+	ath5k_led_off(sc);
+	return 0;
+}
+
+static int ath5k_pci_resume(struct device *dev)
+{
+	struct pci_dev *pdev = to_pci_dev(dev);
+	struct ath5k_softc *sc = pci_get_drvdata(pdev);
+
+	/*
+	 * Suspend/Resume resets the PCI configuration space, so we have to
+	 * re-disable the RETRY_TIMEOUT register (0x41) to keep
+	 * PCI Tx retries from interfering with C3 CPU state
+	 */
+	pci_write_config_byte(pdev, 0x41, 0);
+
+	ath5k_led_enable(sc);
+	return 0;
+}
+
+static SIMPLE_DEV_PM_OPS(ath5k_pm_ops, ath5k_pci_suspend, ath5k_pci_resume);
+#define ATH5K_PM_OPS	(&ath5k_pm_ops)
+#else
+#define ATH5K_PM_OPS	NULL
+#endif /* CONFIG_PM_SLEEP */
+
+static struct pci_driver ath5k_pci_driver = {
+	.name		= KBUILD_MODNAME,
+	.id_table	= ath5k_pci_id_table,
+	.probe		= ath5k_pci_probe,
+	.remove		= __devexit_p(ath5k_pci_remove),
+	.driver.pm	= ATH5K_PM_OPS,
+};
+
+/*
+ * Module init/exit functions
+ */
+static int __init
+init_ath5k_pci(void)
+{
+	int ret;
+
+	ret = pci_register_driver(&ath5k_pci_driver);
+	if (ret) {
+		printk(KERN_ERR "ath5k_pci: can't register pci driver\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit
+exit_ath5k_pci(void)
+{
+	pci_unregister_driver(&ath5k_pci_driver);
+}
+
+module_init(init_ath5k_pci);
+module_exit(exit_ath5k_pci);
-- 
1.7.1

