Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2348 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758843Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 78/83] staging: brcm80211: removed unused definitions
 from include/soc.h
Date: Wed, 1 Jun 2011 13:46:03 +0200
Message-ID: <1306928768-7501-78-git-send-email-rvossen@broadcom.com> (sfid-20110601_134909_820484_4DAB0D1D)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/include/soc.h |  100 -------------------------------
 1 files changed, 0 insertions(+), 100 deletions(-)

diff --git a/drivers/staging/brcm80211/include/soc.h b/drivers/staging/brcm80211/include/soc.h
index ccbd58f..3e59377 100644
--- a/drivers/staging/brcm80211/include/soc.h
+++ b/drivers/staging/brcm80211/include/soc.h
@@ -17,54 +17,12 @@
 #ifndef	_BRCM_SOC_H
 #define	_BRCM_SOC_H
 
-/*
- * SOC Interconnect Address Map.
- * All regions may not exist on all chips.
- */
-#define SI_SDRAM_BASE		0x00000000	/* Physical SDRAM */
-#define SI_PCI_MEM		0x08000000	/* Host Mode sb2pcitranslation0 (64 MB) */
-#define SI_PCI_MEM_SZ		(64 * 1024 * 1024)
-#define SI_PCI_CFG		0x0c000000	/* Host Mode sb2pcitranslation1 (64 MB) */
-#define	SI_SDRAM_SWAPPED	0x10000000	/* Byteswapped Physical SDRAM */
-#define SI_SDRAM_R2		0x80000000	/* Region 2 for sdram (512 MB) */
-
 #ifdef SI_ENUM_BASE_VARIABLE
 #define SI_ENUM_BASE		(sii->pub.si_enum_base)
 #else
 #define SI_ENUM_BASE    	0x18000000	/* Enumeration space base */
 #endif				/* SI_ENUM_BASE_VARIABLE */
 
-#define SI_WRAP_BASE    	0x18100000	/* Wrapper space base */
-#define SI_CORE_SIZE    	0x1000	/* each core gets 4Kbytes for registers */
-#define	SI_MAXCORES		16	/* Max cores (this is arbitrary, for software
-					 * convenience and could be changed if we
-					 * make any larger chips
-					 */
-
-#define	SI_FASTRAM		0x19000000	/* On-chip RAM on chips that also have DDR */
-#define	SI_FASTRAM_SWAPPED	0x19800000
-
-#define	SI_FLASH2		0x1c000000	/* Flash Region 2 (region 1 shadowed here) */
-#define	SI_FLASH2_SZ		0x02000000	/* Size of Flash Region 2 */
-#define	SI_ARMCM3_ROM		0x1e000000	/* ARM Cortex-M3 ROM */
-#define	SI_FLASH1		0x1fc00000	/* MIPS Flash Region 1 */
-#define	SI_FLASH1_SZ		0x00400000	/* MIPS Size of Flash Region 1 */
-#define	SI_ARM7S_ROM		0x20000000	/* ARM7TDMI-S ROM */
-#define	SI_ARMCM3_SRAM2		0x60000000	/* ARM Cortex-M3 SRAM Region 2 */
-#define	SI_ARM7S_SRAM2		0x80000000	/* ARM7TDMI-S SRAM Region 2 */
-#define	SI_ARM_FLASH1		0xffff0000	/* ARM Flash Region 1 */
-#define	SI_ARM_FLASH1_SZ	0x00010000	/* ARM Size of Flash Region 1 */
-
-#define SI_PCI_DMA		0x40000000	/* Client Mode sb2pcitranslation2 (1 GB) */
-#define SI_PCI_DMA2		0x80000000	/* Client Mode sb2pcitranslation2 (1 GB) */
-#define SI_PCI_DMA_SZ		0x40000000	/* Client Mode sb2pcitranslation2 size in bytes */
-#define SI_PCIE_DMA_L32		0x00000000	/* PCIE Client Mode sb2pcitranslation2
-						 * (2 ZettaBytes), low 32 bits
-						 */
-#define SI_PCIE_DMA_H32		0x80000000	/* PCIE Client Mode sb2pcitranslation2
-						 * (2 ZettaBytes), high 32 bits
-						 */
-
 /* core codes */
 #define	NODEV_CORE_ID		0x700	/* Invalid coreid */
 #define	CC_CORE_ID		0x800	/* chipcommon core */
@@ -127,14 +85,6 @@
 					 * unused address ranges
 					 */
 
-/* There are TWO constants on all Broadcom chips: SI_ENUM_BASE above,
- * and chipcommon being the first core:
- */
-#define	SI_CC_IDX		0
-
-/* SOC Interconnect types (aka chip types) */
-#define	SOCI_AI			1
-
 /* Common core control flags */
 #define	SICF_BIST_EN		0x8000
 #define	SICF_PME_EN		0x4000
@@ -142,54 +92,4 @@
 #define	SICF_FGC		0x0002
 #define	SICF_CLOCK_EN		0x0001
 
-/* Common core status flags */
-#define	SISF_BIST_DONE		0x8000
-#define	SISF_BIST_ERROR		0x4000
-#define	SISF_GATED_CLK		0x2000
-#define	SISF_DMA64		0x1000
-#define	SISF_CORE_BITS		0x0fff
-
-/* A register that is common to all cores to
- * communicate w/PMU regarding clock control.
- */
-#define SI_CLK_CTL_ST		0x1e0	/* clock control and status */
-
-/* clk_ctl_st register */
-#define	CCS_FORCEALP		0x00000001	/* force ALP request */
-#define	CCS_FORCEHT		0x00000002	/* force HT request */
-#define	CCS_FORCEILP		0x00000004	/* force ILP request */
-#define	CCS_ALPAREQ		0x00000008	/* ALP Avail Request */
-#define	CCS_HTAREQ		0x00000010	/* HT Avail Request */
-#define	CCS_FORCEHWREQOFF	0x00000020	/* Force HW Clock Request Off */
-#define CCS_ERSRC_REQ_MASK	0x00000700	/* external resource requests */
-#define CCS_ERSRC_REQ_SHIFT	8
-#define	CCS_ALPAVAIL		0x00010000	/* ALP is available */
-#define	CCS_HTAVAIL		0x00020000	/* HT is available */
-#define CCS_BP_ON_APL		0x00040000	/* RO: Backplane is running on ALP clock */
-#define CCS_BP_ON_HT		0x00080000	/* RO: Backplane is running on HT clock */
-#define CCS_ERSRC_STS_MASK	0x07000000	/* external resource status */
-#define CCS_ERSRC_STS_SHIFT	24
-
-#define	CCS0_HTAVAIL		0x00010000	/* HT avail in chipc and pcmcia on 4328a0 */
-#define	CCS0_ALPAVAIL		0x00020000	/* ALP avail in chipc and pcmcia on 4328a0 */
-
-/* Not really related to SOC Interconnect, but a couple of software
- * conventions for the use the flash space:
- */
-
-/* Minimum amount of flash we support */
-#define FLASH_MIN		0x00020000	/* Minimum flash size */
-
-/* A boot/binary may have an embedded block that describes its size  */
-#define	BISZ_OFFSET		0x3e0	/* At this offset into the binary */
-#define	BISZ_MAGIC		0x4249535a	/* Marked with this value: 'BISZ' */
-#define	BISZ_MAGIC_IDX		0	/* Word 0: magic */
-#define	BISZ_TXTST_IDX		1	/*      1: text start */
-#define	BISZ_TXTEND_IDX		2	/*      2: text end */
-#define	BISZ_DATAST_IDX		3	/*      3: data start */
-#define	BISZ_DATAEND_IDX	4	/*      4: data end */
-#define	BISZ_BSSST_IDX		5	/*      5: bss start */
-#define	BISZ_BSSEND_IDX		6	/*      6: bss end */
-#define BISZ_SIZE		7	/* descriptor size in 32-bit integers */
-
 #endif				/* _BRCM_SOC_H */
-- 
1.7.4.1


