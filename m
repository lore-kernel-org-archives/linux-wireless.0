Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45168 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709AbbCDNZT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 08:25:19 -0500
Received: by wivz2 with SMTP id z2so11187932wiv.4
        for <linux-wireless@vger.kernel.org>; Wed, 04 Mar 2015 05:25:17 -0800 (PST)
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH next] bcma: move internal function declarations to private header
Date: Wed,  4 Mar 2015 14:24:52 +0100
Message-Id: <1425475492-16259-1-git-send-email-zajec5@gmail.com> (sfid-20150304_142523_444121_C8AE4D65)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

These functions are not exported nor used anywhere, so there is no
reason to put them in public headers.
Also drop unused bcma_chipco_(suspend|resume).

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
I hope my logic is OK about that?
---
 drivers/bcma/bcma_private.h                 | 41 +++++++++++++++++++++++++++++
 include/linux/bcma/bcma_driver_chipcommon.h | 11 --------
 include/linux/bcma/bcma_driver_gmac_cmn.h   |  6 -----
 include/linux/bcma/bcma_driver_mips.h       | 15 -----------
 include/linux/bcma/bcma_driver_pci.h        |  2 --
 include/linux/bcma/bcma_driver_pcie2.h      |  2 --
 6 files changed, 41 insertions(+), 36 deletions(-)

diff --git a/drivers/bcma/bcma_private.h b/drivers/bcma/bcma_private.h
index 29565e3..5a1d224 100644
--- a/drivers/bcma/bcma_private.h
+++ b/drivers/bcma/bcma_private.h
@@ -43,6 +43,9 @@ int bcma_bus_scan(struct bcma_bus *bus);
 int bcma_sprom_get(struct bcma_bus *bus);
 
 /* driver_chipcommon.c */
+void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc);
+void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
+void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable);
 #ifdef CONFIG_BCMA_DRIVER_MIPS
 void bcma_chipco_serial_init(struct bcma_drv_cc *cc);
 extern struct platform_device bcma_pflash_dev;
@@ -53,6 +56,8 @@ int bcma_core_chipcommon_b_init(struct bcma_drv_cc_b *ccb);
 void bcma_core_chipcommon_b_free(struct bcma_drv_cc_b *ccb);
 
 /* driver_chipcommon_pmu.c */
+void bcma_pmu_early_init(struct bcma_drv_cc *cc);
+void bcma_pmu_init(struct bcma_drv_cc *cc);
 u32 bcma_pmu_get_alp_clock(struct bcma_drv_cc *cc);
 u32 bcma_pmu_get_cpu_clock(struct bcma_drv_cc *cc);
 
@@ -102,10 +107,13 @@ static inline void __exit bcma_host_soc_unregister_driver(void)
 
 /* driver_pci.c */
 u32 bcma_pcie_read(struct bcma_drv_pci *pc, u32 address);
+void bcma_core_pci_early_init(struct bcma_drv_pci *pc);
+void bcma_core_pci_init(struct bcma_drv_pci *pc);
 void bcma_core_pci_up(struct bcma_drv_pci *pc);
 void bcma_core_pci_down(struct bcma_drv_pci *pc);
 
 /* driver_pcie2.c */
+void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2);
 void bcma_core_pcie2_up(struct bcma_drv_pcie2 *pcie2);
 
 extern int bcma_chipco_watchdog_register(struct bcma_drv_cc *cc);
@@ -123,6 +131,39 @@ static inline void bcma_core_pci_hostmode_init(struct bcma_drv_pci *pc)
 }
 #endif /* CONFIG_BCMA_DRIVER_PCI_HOSTMODE */
 
+/**************************************************
+ * driver_mips.c
+ **************************************************/
+
+#ifdef CONFIG_BCMA_DRIVER_MIPS
+unsigned int bcma_core_mips_irq(struct bcma_device *dev);
+void bcma_core_mips_early_init(struct bcma_drv_mips *mcore);
+void bcma_core_mips_init(struct bcma_drv_mips *mcore);
+#else
+static inline unsigned int bcma_core_mips_irq(struct bcma_device *dev)
+{
+	return 0;
+}
+static inline void bcma_core_mips_early_init(struct bcma_drv_mips *mcore)
+{
+}
+static inline void bcma_core_mips_init(struct bcma_drv_mips *mcore)
+{
+}
+#endif
+
+/**************************************************
+ * driver_gmac_cmn.c
+ **************************************************/
+
+#ifdef CONFIG_BCMA_DRIVER_GMAC_CMN
+void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc);
+#else
+static inline void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc)
+{
+}
+#endif
+
 #ifdef CONFIG_BCMA_DRIVER_GPIO
 /* driver_gpio.c */
 int bcma_gpio_init(struct bcma_drv_cc *cc);
diff --git a/include/linux/bcma/bcma_driver_chipcommon.h b/include/linux/bcma/bcma_driver_chipcommon.h
index db6fa21..6cceedf 100644
--- a/include/linux/bcma/bcma_driver_chipcommon.h
+++ b/include/linux/bcma/bcma_driver_chipcommon.h
@@ -663,14 +663,6 @@ struct bcma_drv_cc_b {
 #define bcma_cc_maskset32(cc, offset, mask, set) \
 	bcma_cc_write32(cc, offset, (bcma_cc_read32(cc, offset) & (mask)) | (set))
 
-extern void bcma_core_chipcommon_init(struct bcma_drv_cc *cc);
-extern void bcma_core_chipcommon_early_init(struct bcma_drv_cc *cc);
-
-extern void bcma_chipco_suspend(struct bcma_drv_cc *cc);
-extern void bcma_chipco_resume(struct bcma_drv_cc *cc);
-
-void bcma_chipco_bcm4331_ext_pa_lines_ctl(struct bcma_drv_cc *cc, bool enable);
-
 extern u32 bcma_chipco_watchdog_timer_set(struct bcma_drv_cc *cc, u32 ticks);
 
 extern u32 bcma_chipco_get_alp_clock(struct bcma_drv_cc *cc);
@@ -690,9 +682,6 @@ u32 bcma_chipco_gpio_pullup(struct bcma_drv_cc *cc, u32 mask, u32 value);
 u32 bcma_chipco_gpio_pulldown(struct bcma_drv_cc *cc, u32 mask, u32 value);
 
 /* PMU support */
-extern void bcma_pmu_init(struct bcma_drv_cc *cc);
-extern void bcma_pmu_early_init(struct bcma_drv_cc *cc);
-
 extern void bcma_chipco_pll_write(struct bcma_drv_cc *cc, u32 offset,
 				  u32 value);
 extern void bcma_chipco_pll_maskset(struct bcma_drv_cc *cc, u32 offset,
diff --git a/include/linux/bcma/bcma_driver_gmac_cmn.h b/include/linux/bcma/bcma_driver_gmac_cmn.h
index 4dd1f33..4354d4e 100644
--- a/include/linux/bcma/bcma_driver_gmac_cmn.h
+++ b/include/linux/bcma/bcma_driver_gmac_cmn.h
@@ -91,10 +91,4 @@ struct bcma_drv_gmac_cmn {
 #define gmac_cmn_write16(gc, offset, val)	bcma_write16((gc)->core, offset, val)
 #define gmac_cmn_write32(gc, offset, val)	bcma_write32((gc)->core, offset, val)
 
-#ifdef CONFIG_BCMA_DRIVER_GMAC_CMN
-extern void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc);
-#else
-static inline void bcma_core_gmac_cmn_init(struct bcma_drv_gmac_cmn *gc) { }
-#endif
-
 #endif /* LINUX_BCMA_DRIVER_GMAC_CMN_H_ */
diff --git a/include/linux/bcma/bcma_driver_mips.h b/include/linux/bcma/bcma_driver_mips.h
index 0b3b32a..8eea7f9 100644
--- a/include/linux/bcma/bcma_driver_mips.h
+++ b/include/linux/bcma/bcma_driver_mips.h
@@ -39,21 +39,6 @@ struct bcma_drv_mips {
 	u8 early_setup_done:1;
 };
 
-#ifdef CONFIG_BCMA_DRIVER_MIPS
-extern void bcma_core_mips_init(struct bcma_drv_mips *mcore);
-extern void bcma_core_mips_early_init(struct bcma_drv_mips *mcore);
-
-extern unsigned int bcma_core_mips_irq(struct bcma_device *dev);
-#else
-static inline void bcma_core_mips_init(struct bcma_drv_mips *mcore) { }
-static inline void bcma_core_mips_early_init(struct bcma_drv_mips *mcore) { }
-
-static inline unsigned int bcma_core_mips_irq(struct bcma_device *dev)
-{
-	return 0;
-}
-#endif
-
 extern u32 bcma_cpu_clock(struct bcma_drv_mips *mcore);
 
 #endif /* LINUX_BCMA_DRIVER_MIPS_H_ */
diff --git a/include/linux/bcma/bcma_driver_pci.h b/include/linux/bcma/bcma_driver_pci.h
index 6b8bca6..8e90004 100644
--- a/include/linux/bcma/bcma_driver_pci.h
+++ b/include/linux/bcma/bcma_driver_pci.h
@@ -238,8 +238,6 @@ struct bcma_drv_pci {
 #define pcicore_write16(pc, offset, val)	bcma_write16((pc)->core, offset, val)
 #define pcicore_write32(pc, offset, val)	bcma_write32((pc)->core, offset, val)
 
-extern void bcma_core_pci_early_init(struct bcma_drv_pci *pc);
-extern void bcma_core_pci_init(struct bcma_drv_pci *pc);
 extern int bcma_core_pci_irq_ctl(struct bcma_bus *bus,
 				 struct bcma_device *core, bool enable);
 extern void bcma_core_pci_power_save(struct bcma_bus *bus, bool up);
diff --git a/include/linux/bcma/bcma_driver_pcie2.h b/include/linux/bcma/bcma_driver_pcie2.h
index d8c4329..31e6d17 100644
--- a/include/linux/bcma/bcma_driver_pcie2.h
+++ b/include/linux/bcma/bcma_driver_pcie2.h
@@ -155,6 +155,4 @@ struct bcma_drv_pcie2 {
 #define pcie2_set32(pcie2, offset, set)		bcma_set32((pcie2)->core, offset, set)
 #define pcie2_mask32(pcie2, offset, mask)	bcma_mask32((pcie2)->core, offset, mask)
 
-void bcma_core_pcie2_init(struct bcma_drv_pcie2 *pcie2);
-
 #endif /* LINUX_BCMA_DRIVER_PCIE2_H_ */
-- 
1.8.4.5

