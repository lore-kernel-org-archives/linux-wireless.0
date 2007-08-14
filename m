Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:50349
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765511AbXHNRA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Aug 2007 13:00:57 -0400
Message-Id: <20070814165748.759286000@bu3sch.de>
References: <20070814165746.863593000@bu3sch.de>
Date: Tue, 14 Aug 2007 18:57:50 +0200
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, bcm43xx-dev@lists.berlios.de,
	Aurelien Jarno <aurelien@aurel32.net>
Subject: [patch 4/7] ssb: Fix a warning in PCI core driver
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Aurelien Jarno <aurelien@aurel32.net>

The patch below fixes a warning spotted a few days ago by Andrew Morton
while releasing 2.6.23-rc2-mm1.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>
Signed-off-by: Michael Buesch <mb@bu3sch.de>

Index: ssb-merge-new/include/linux/ssb/ssb_regs.h
===================================================================
--- ssb-merge-new.orig/include/linux/ssb/ssb_regs.h	2007-08-11 01:57:44.000000000 +0200
+++ ssb-merge-new/include/linux/ssb/ssb_regs.h	2007-08-13 14:17:30.000000000 +0200
@@ -5,24 +5,24 @@
 /* SiliconBackplane Address Map.
  * All regions may not exist on all chips.
  */
-#define SSB_SDRAM_BASE		0x00000000	/* Physical SDRAM */
-#define SSB_PCI_MEM		0x08000000	/* Host Mode sb2pcitranslation0 (64 MB) */
-#define SSB_PCI_CFG		0x0c000000	/* Host Mode sb2pcitranslation1 (64 MB) */
-#define	SSB_SDRAM_SWAPPED	0x10000000	/* Byteswapped Physical SDRAM */
-#define SSB_ENUM_BASE    	0x18000000	/* Enumeration space base */
-#define	SSB_ENUM_LIMIT		0x18010000	/* Enumeration space limit */
-
-#define	SSB_FLASH2		0x1c000000	/* Flash Region 2 (region 1 shadowed here) */
-#define	SSB_FLASH2_SZ		0x02000000	/* Size of Flash Region 2 */
-
-#define	SSB_EXTIF_BASE		0x1f000000	/* External Interface region base address */
-#define	SSB_FLASH1		0x1fc00000	/* Flash Region 1 */
-#define	SSB_FLASH1_SZ		0x00400000	/* Size of Flash Region 1 */
-
-#define SSB_PCI_DMA		0x40000000	/* Client Mode sb2pcitranslation2 (1 GB) */
-#define SSB_PCI_DMA_SZ		0x40000000	/* Client Mode sb2pcitranslation2 size in bytes */
-#define SSB_PCIE_DMA_L32	0x00000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), low 32 bits */
-#define SSB_PCIE_DMA_H32	0x80000000	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
+#define SSB_SDRAM_BASE		0x00000000U	/* Physical SDRAM */
+#define SSB_PCI_MEM		0x08000000U	/* Host Mode sb2pcitranslation0 (64 MB) */
+#define SSB_PCI_CFG		0x0c000000U	/* Host Mode sb2pcitranslation1 (64 MB) */
+#define	SSB_SDRAM_SWAPPED	0x10000000U	/* Byteswapped Physical SDRAM */
+#define SSB_ENUM_BASE    	0x18000000U	/* Enumeration space base */
+#define	SSB_ENUM_LIMIT		0x18010000U	/* Enumeration space limit */
+
+#define	SSB_FLASH2		0x1c000000U	/* Flash Region 2 (region 1 shadowed here) */
+#define	SSB_FLASH2_SZ		0x02000000U	/* Size of Flash Region 2 */
+
+#define	SSB_EXTIF_BASE		0x1f000000U	/* External Interface region base address */
+#define	SSB_FLASH1		0x1fc00000U	/* Flash Region 1 */
+#define	SSB_FLASH1_SZ		0x00400000U	/* Size of Flash Region 1 */
+
+#define SSB_PCI_DMA		0x40000000U	/* Client Mode sb2pcitranslation2 (1 GB) */
+#define SSB_PCI_DMA_SZ		0x40000000U	/* Client Mode sb2pcitranslation2 size in bytes */
+#define SSB_PCIE_DMA_L32	0x00000000U	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), low 32 bits */
+#define SSB_PCIE_DMA_H32	0x80000000U	/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
 #define	SSB_EUART		(SSB_EXTIF_BASE + 0x00800000)
 #define	SSB_LED			(SSB_EXTIF_BASE + 0x00900000)
 

-- 

