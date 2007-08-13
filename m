Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hall.aurel32.net ([88.191.38.19]:43221 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759740AbXHMJHN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 05:07:13 -0400
Date: Mon, 13 Aug 2007 11:07:10 +0200
From: Aurelien Jarno <aurelien@aurel32.net>
To: Michael Buesch <mb@bu3sch.de>
Cc: linux-wireless@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH][SSB] Fix a warning in PCI core driver
Message-ID: <20070813090710.GA25439@hall.aurel32.net>
References: <20070812235058.GA4966@hall.aurel32.net> <200708130202.28030.mb@bu3sch.de> <20070813001849.GC4966@hall.aurel32.net> <200708130421.31904.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <200708130421.31904.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 13, 2007 at 04:21:31AM +0200, Michael Buesch wrote:
> > Yes it is overflow warning. The compiler thinks that those constant are
> > signed values and thus generate an overflow.
> > 
> > Another fix would be to postfix those constants by U.
> > 
> 
> Can you please do this?
> 

Please find a patch below. I did the same for the whole address map for
consistency.

Aurelien



The patch below fixes a warning spotted a few days ago by Andrew Morton
while releasing 2.6.23-rc2-mm1.

Signed-off-by: Aurelien Jarno <aurelien@aurel32.net>

--- a/include/linux/ssb/ssb_regs.h
+++ a/include/linux/ssb/ssb_regs.h
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
  .''`.  Aurelien Jarno	            | GPG: 1024D/F1BCDB73
 : :' :  Debian developer           | Electrical Engineer
 `. `'   aurel32@debian.org         | aurelien@aurel32.net
   `-    people.debian.org/~aurel32 | www.aurel32.net
