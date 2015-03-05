Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:33706 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbbCER2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Mar 2015 12:28:23 -0500
Received: by wghb13 with SMTP id b13so54908364wgh.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2015 09:28:22 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>, Arnd Bergmann <arnd@arndb.de>,
	Chen Gang <xili_gchen_5257@hotmail.com>,
	Jim Davis <jim.epost@gmail.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH 2/3] bcma: allow disabling (not building) PCI driver
Date: Thu,  5 Mar 2015 18:25:11 +0100
Message-Id: <1425576312-2779-2-git-send-email-zajec5@gmail.com> (sfid-20150305_182850_812640_5A277AE3)
In-Reply-To: <1425576312-2779-1-git-send-email-zajec5@gmail.com>
References: <1425576312-2779-1-git-send-email-zajec5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It isn't required for bcma bus on SoCs, so provide some empty functions
and allow disabling it.

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
 drivers/bcma/Kconfig                 |  4 ++--
 drivers/bcma/bcma_private.h          | 20 ++++++++++++++++++++
 include/linux/bcma/bcma_driver_pci.h |  6 ++++++
 3 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/drivers/bcma/Kconfig b/drivers/bcma/Kconfig
index 9be17d3..1500b71 100644
--- a/drivers/bcma/Kconfig
+++ b/drivers/bcma/Kconfig
@@ -45,9 +45,9 @@ config BCMA_HOST_SOC
 
 	  If unsure, say N
 
-# TODO: make it depend on PCI when ready
 config BCMA_DRIVER_PCI
-	bool
+	bool "BCMA Broadcom PCI core driver"
+	depends on BCMA && PCI
 	default y
 	help
 	  BCMA bus may have many versions of PCIe core. This driver
diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 5a1d224..15f2b2e 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -106,15 +106,35 @@ static inline void __exit bcma_host_soc_unregister_driver(void)
 #endif /* CONFIG_BCMA_HOST_SOC && CONFIG_OF */
 
 /* driver_pci.c */
+#ifdef CONFIG_BCMA_DRIVER_PCI
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
 void bcma_core_pci_early_init(struct bcma_drv_pci *pc);
 void bcma_core_pci_init(struct bcma_drv_pci *pc);
 void bcma_core_pci_up(struct bcma_drv_pci *pc);
 void bcma_core_pci_down(struct bcma_drv_pci *pc);
+#else
+static inline void bcma_core_pci_early_init(struct bcma_drv_pci *pc)
+{
+	WARN_ON(pc->core->bus->hosttype == BCMA_HOSTTYPE_PCI);
+}
+static inline void bcma_core_pci_init(struct bcma_drv_pci *pc)
+{
+	/* Initialization is required for PCI hosted bus */
+	WARN_ON(pc->core->bus->hosttype == BCMA_HOSTTYPE_PCI);
+}
+#endif
 
 /* driver_pcie2.c */
+#ifdef CONFIG_BCMA_DRIVER_PCI
 void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2);
 void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2);
+#else
+static inline void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2)
+{
+	/* Initialization is required for PCI hosted bus */
+	WARN_ON(pcie2->core->bus->hosttype == BCMA_HOSTTYPE_PCI);
+}
+#endif
 
 extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
 
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 3a46868..5ba6918 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -238,7 +238,13 @@ struct bcma_drv_pci {
 #define pcicore_write16(pc, offset, val)	bcma_write16((pc)->core, offset, val)
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
+#ifdef CONFIG_BCMA_DRIVER_PCI
 extern void bcma_core_pci_power_save(struct bcma_bus *bus, bool up);
+#else
+static inline void bcma_core_pci_power_save(struct bcma_bus *bus, bool up)
+{
+}
+#endif
 
 extern int bcma_core_pci_pcibios_map_irq(const struct pci_dev *dev);
 extern int bcma_core_pci_plat_dev_init(struct pci_dev *dev);
-- 
1.8.4.5

