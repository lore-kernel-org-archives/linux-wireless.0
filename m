Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1181 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751066Ab1IAJRg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Sep 2011 05:17:36 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 26/30] staging: brcm80211: macro cleanup in softmac
 aiutils.h
Date: Thu, 1 Sep 2011 11:17:16 +0200
Message-ID: <1314868640-9425-27-git-send-email-rvossen@broadcom.com> (sfid-20110901_111756_322502_72D5400D)
In-Reply-To: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
References: <1314868640-9425-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Moved, deleted or substituted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |  160 ++++++++++++--------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |  207 +++++---------------------
 drivers/staging/brcm80211/brcmsmac/main.c    |   45 +++----
 drivers/staging/brcm80211/brcmsmac/pmu.c     |    4 +-
 4 files changed, 151 insertions(+), 265 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 48489ce..9510d83 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -285,6 +285,80 @@
 /* resetctrl */
 #define	AIRC_RESET		1
 
+#define	NOREV		-1	/* Invalid rev */
+
+/* GPIO Based LED powersave defines */
+#define DEFAULT_GPIO_ONTIME	10	/* Default: 10% on */
+#define DEFAULT_GPIO_OFFTIME	90	/* Default: 10% on */
+
+/* When Srom support present, fields in sromcontrol */
+#define	SRC_START		0x80000000
+#define	SRC_BUSY		0x80000000
+#define	SRC_OPCODE		0x60000000
+#define	SRC_OP_READ		0x00000000
+#define	SRC_OP_WRITE		0x20000000
+#define	SRC_OP_WRDIS		0x40000000
+#define	SRC_OP_WREN		0x60000000
+#define	SRC_OTPSEL		0x00000010
+#define	SRC_LOCK		0x00000008
+#define	SRC_SIZE_MASK		0x00000006
+#define	SRC_SIZE_1K		0x00000000
+#define	SRC_SIZE_4K		0x00000002
+#define	SRC_SIZE_16K		0x00000004
+#define	SRC_SIZE_SHIFT		1
+#define	SRC_PRESENT		0x00000001
+
+/* External PA enable mask */
+#define GPIO_CTRL_EPA_EN_MASK 0x40
+
+#define DEFAULT_GPIOTIMERVAL \
+	((DEFAULT_GPIO_ONTIME << GPIO_ONTIME_SHIFT) | DEFAULT_GPIO_OFFTIME)
+
+#define	BADIDX		(SI_MAXCORES + 1)
+
+/* Newer chips can access PCI/PCIE and CC core without requiring to change
+ * PCI BAR0 WIN
+ */
+#define SI_FAST(si) (((si)->pub.buscoretype == PCIE_CORE_ID) ||	\
+		     (((si)->pub.buscoretype == PCI_CORE_ID) && \
+		      (si)->pub.buscorerev >= 13))
+
+#define CCREGS_FAST(si) (((char *)((si)->curmap) + PCI_16KB0_CCREGS_OFFSET))
+
+#define	IS_SIM(chippkg)	\
+	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
+
+/*
+ * Macros to disable/restore function core(D11, ENET, ILINE20, etc) interrupts
+ * before after core switching to avoid invalid register accesss inside ISR.
+ */
+#define INTR_OFF(si, intr_val) \
+	if ((si)->intrsoff_fn && \
+	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
+		intr_val = (*(si)->intrsoff_fn)((si)->intr_arg)
+
+#define INTR_RESTORE(si, intr_val) \
+	if ((si)->intrsrestore_fn && \
+	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
+		(*(si)->intrsrestore_fn)((si)->intr_arg, intr_val)
+
+#define PCI(si)		((si)->pub.buscoretype == PCI_CORE_ID)
+#define PCIE(si)	((si)->pub.buscoretype == PCIE_CORE_ID)
+
+#define PCI_FORCEHT(si)	(PCIE(si) && (si->pub.chip == BCM4716_CHIP_ID))
+
+#ifdef BCMDBG
+#define	SI_MSG(args)	printk args
+#else
+#define	SI_MSG(args)
+#endif				/* BCMDBG */
+
+#define	GOODCOREADDR(x, b) \
+	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
+		IS_ALIGNED((x), SI_CORE_SIZE))
+
+#define PCIEREGS(si) (((char *)((si)->curmap) + PCI_16KB0_PCIREGS_OFFSET))
+
 struct aidmp {
 	u32 oobselina30;	/* 0x000 */
 	u32 oobselina74;	/* 0x004 */
@@ -435,11 +509,6 @@ get_erom_ent(struct si_pub *sih, u32 **eromptr, u32 mask, u32 match)
 		nom++;
 	}
 
-	SI_VMSG(("%s: Returning ent 0x%08x\n", __func__, ent));
-	if (inv + nom)
-		SI_VMSG(("  after %d invalid and %d non-matching entries\n",
-			 inv, nom));
-
 	return ent;
 }
 
@@ -472,9 +541,6 @@ get_asd(struct si_pub *sih, u32 **eromptr, uint sp, uint ad, uint st,
 	} else
 		*sizel = AD_SZ_BASE << (sz >> AD_SZ_SHIFT);
 
-	SI_VMSG(("  SP %d, ad %d: st = %d, 0x%08x_0x%08x @ 0x%08x_0x%08x\n",
-		 sp, ad, st, *sizeh, *sizel, *addrh, *addrl));
-
 	return asd;
 }
 
@@ -500,8 +566,6 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 	eromptr = regs;
 	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
 
-	SI_VMSG(("ai_scan: regs = 0x%p, erombase = 0x%08x, eromptr = 0x%p, "
-		 "eromlim = 0x%p\n", regs, erombase, eromptr, eromlim));
 	while (eromptr < eromlim) {
 		u32 cia, cib, cid, mfg, crev, nmw, nsw, nmp, nsp;
 		u32 mpd, asd, addrl, addrh, sizel, sizeh;
@@ -514,8 +578,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 		/* Grok a component */
 		cia = get_erom_ent(sih, &eromptr, ER_TAG, ER_CI);
 		if (cia == (ER_END | ER_VALID)) {
-			SI_VMSG(("Found END of erom after %d cores\n",
-				 sii->numcores));
+			/*  Found END of erom */
 			ai_hwfixup(sii);
 			return;
 		}
@@ -523,7 +586,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 		cib = get_erom_ent(sih, &eromptr, 0, 0);
 
 		if ((cib & ER_TAG) != ER_CI) {
-			SI_ERROR(("CIA not followed by CIB\n"));
+			/* CIA not followed by CIB */
 			goto error;
 		}
 
@@ -535,10 +598,6 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 		nmp = (cib & CIB_NMP_MASK) >> CIB_NMP_SHIFT;
 		nsp = (cib & CIB_NSP_MASK) >> CIB_NSP_SHIFT;
 
-		SI_VMSG(("Found component 0x%04x/0x%04x rev %d at erom addr "
-			 "0x%p, with nmw = %d, nsw = %d, nmp = %d & nsp = %d\n",
-			 mfg, cid, crev, base, nmw, nsw, nmp, nsp));
-
 		if (((mfg == MFGID_ARM) && (cid == DEF_AI_COMP)) || (nsp == 0))
 			continue;
 		if ((nmw + nsw == 0)) {
@@ -561,13 +620,9 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 		for (i = 0; i < nmp; i++) {
 			mpd = get_erom_ent(sih, &eromptr, ER_VALID, ER_VALID);
 			if ((mpd & ER_TAG) != ER_MP) {
-				SI_ERROR(("Not enough MP entries for "
-					  "component 0x%x\n", cid));
+				/* Not enough MP entries for component */
 				goto error;
 			}
-			SI_VMSG(("  Master port %d, mp: %d id: %d\n", i,
-				 (mpd & MPD_MP_MASK) >> MPD_MP_SHIFT,
-				 (mpd & MPD_MUI_MASK) >> MPD_MUI_SHIFT));
 		}
 
 		/* First Slave Address Descriptor should be port 0:
@@ -585,8 +640,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 				br = true;
 			else if ((addrh != 0) || (sizeh != 0)
 				 || (sizel != SI_CORE_SIZE)) {
-				SI_ERROR(("First Slave ASD for core 0x%04x "
-					  "malformed (0x%08x)\n", cid, asd));
+				/* First Slave ASD for core malformed */
 				goto error;
 			}
 		}
@@ -614,8 +668,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 					    &addrl, &addrh, &sizel, &sizeh);
 			} while (asd != 0);
 			if (j == 0) {
-				SI_ERROR((" SP %d has no address descriptors\n",
-					  i));
+				/* SP has no address descriptors */
 				goto error;
 			}
 		}
@@ -626,11 +679,11 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 			    get_asd(sih, &eromptr, i, 0, AD_ST_MWRAP, &addrl,
 				    &addrh, &sizel, &sizeh);
 			if (asd == 0) {
-				SI_ERROR(("Missing descriptor for MW %d\n", i));
+				/* Missing descriptor for MW */
 				goto error;
 			}
 			if ((sizeh != 0) || (sizel != SI_CORE_SIZE)) {
-				SI_ERROR(("Master wrapper %d is not 4KB\n", i));
+				/* Master wrapper %d is not 4KB */
 				goto error;
 			}
 			if (i == 0)
@@ -644,11 +697,11 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 			    get_asd(sih, &eromptr, fwp + i, 0, AD_ST_SWRAP,
 				    &addrl, &addrh, &sizel, &sizeh);
 			if (asd == 0) {
-				SI_ERROR(("Missing descriptor for SW %d\n", i));
+				/* Missing descriptor for SW */
 				goto error;
 			}
 			if ((sizeh != 0) || (sizel != SI_CORE_SIZE)) {
-				SI_ERROR(("Slave wrapper %d is not 4KB\n", i));
+				/* Slave wrapper is not 4KB */
 				goto error;
 			}
 			if ((nmw == 0) && (i == 0))
@@ -663,9 +716,8 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 		sii->numcores++;
 	}
 
-	SI_ERROR(("Reached end of erom without finding END"));
-
  error:
+	/* Reached end of erom without finding END */
 	sii->numcores = 0;
 	return;
 }
@@ -715,8 +767,7 @@ u32 ai_addrspace(struct si_pub *sih, uint asidx)
 	else if (asidx == 1)
 		return sii->coresba2[cidx];
 	else {
-		SI_ERROR(("%s: Need to parse the erom again to find addr "
-			  "space %d\n", __func__, asidx));
+		/* Need to parse the erom again to find addr space */
 		return 0;
 	}
 }
@@ -735,8 +786,7 @@ u32 ai_addrspacesize(struct si_pub *sih, uint asidx)
 	else if (asidx == 1)
 		return sii->coresba2_size[cidx];
 	else {
-		SI_ERROR(("%s: Need to parse the erom again to find addr "
-			  "space %d\n", __func__, asidx));
+		/* Need to parse the erom again to find addr */
 		return 0;
 	}
 }
@@ -907,10 +957,6 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 		cid = ai_coreid(&sii->pub);
 		crev = ai_corerev(&sii->pub);
 
-		/* Display cores found */
-		SI_VMSG(("CORE[%d]: id 0x%x rev %d base 0x%x regs 0x%p\n",
-			 i, cid, crev, sii->coresba[i], sii->regs[i]));
-
 		if (cid == PCI_CORE_ID) {
 			pciidx = i;
 			pcirev = crev;
@@ -943,9 +989,6 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 		sii->pub.buscoreidx = pcieidx;
 	}
 
-	SI_VMSG(("Buscore id/type/rev %d/0x%x/%d\n", sii->pub.buscoreidx,
-		 sii->pub.buscoretype, sii->pub.buscorerev));
-
 	/* fixup necessary chip/core configurations */
 	if (SI_FAST(sii)) {
 		if (!sii->pch) {
@@ -956,7 +999,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 		}
 	}
 	if (ai_pci_fixcfg(&sii->pub)) {
-		SI_ERROR(("si_doattach: si_pci_fixcfg failed\n"));
+		/* si_doattach: si_pci_fixcfg failed */
 		return false;
 	}
 
@@ -980,20 +1023,11 @@ static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 							"boardvendor");
 	if (sii->pub.boardvendor == 0)
 		sii->pub.boardvendor = w & 0xffff;
-	else
-		SI_ERROR(("Overriding boardvendor: 0x%x instead of "
-			  "0x%x\n", sii->pub.boardvendor, w & 0xffff));
 
 	sii->pub.boardtype = (u16)ai_getdevpathintvar(&sii->pub,
 		"boardtype");
 	if (sii->pub.boardtype == 0)
 		sii->pub.boardtype = (w >> 16) & 0xffff;
-	else
-		SI_ERROR(("Overriding boardtype: 0x%x instead of 0x%x\n"
-			  , sii->pub.boardtype, (w >> 16) & 0xffff));
-
-	if (sii->pub.boardtype == 0)
-		SI_ERROR(("si_doattach: unknown board type\n"));
 
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
 }
@@ -1029,7 +1063,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 
 	/* bus/core/clk setup for register access */
 	if (!ai_buscore_prep(sii)) {
-		SI_ERROR(("si_doattach: si_core_clk_prep failed\n"));
 		return NULL;
 	}
 
@@ -1055,24 +1088,21 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		/* pass chipc address instead of original core base */
 		ai_scan(&sii->pub, cc);
 	} else {
-		SI_ERROR(("Found chip of unknown type (0x%08x)\n", w));
+		/* Found chip of unknown type */
 		return NULL;
 	}
 	/* no cores found, bail out */
 	if (sii->numcores == 0) {
-		SI_ERROR(("si_doattach: could not find any cores\n"));
 		return NULL;
 	}
 	/* bus/core/clk setup */
 	origidx = SI_CC_IDX;
 	if (!ai_buscore_setup(sii, savewin, &origidx)) {
-		SI_ERROR(("si_doattach: si_buscore_setup failed\n"));
 		goto exit;
 	}
 
 	/* Init nvram from sprom/otp if they exist */
 	if (srom_var_init(&sii->pub, cc, vars, varsz)) {
-		SI_ERROR(("si_doattach: srom_var_init failed: bad srom\n"));
 		goto exit;
 	}
 	pvars = vars ? *vars : NULL;
@@ -1085,7 +1115,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_setcoreidx(sih, origidx);
 
 	/* PMU specific initializations */
-	if (PMUCTL_ENAB(sih)) {
+	if (sih->cccaps & CC_CAP_PMU) {
 		u32 xtalfreq;
 		si_pmu_init(sih);
 		si_pmu_chip_init(sih);
@@ -1278,7 +1308,7 @@ void *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
 	uint idx;
 
 	idx = ai_findcoreidx(sih, coreid, coreunit);
-	if (!GOODIDX(idx))
+	if (idx >= SI_MAXCORES)
 		return NULL;
 
 	return ai_setcoreidx(sih, idx);
@@ -1562,7 +1592,7 @@ void ai_clkctl_init(struct si_pub *sih)
 	struct chipcregs *cc;
 	bool fast;
 
-	if (!CCCTL_ENAB(sih))
+	if (!(sih->cccaps & CC_CAP_PWR_CTL))
 		return;
 
 	sii = (struct si_info *)sih;
@@ -1604,14 +1634,14 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	bool fast;
 
 	sii = (struct si_info *)sih;
-	if (PMUCTL_ENAB(sih)) {
+	if (sih->cccaps & CC_CAP_PMU) {
 		INTR_OFF(sii, intr_val);
 		fpdelay = si_pmu_fast_pwrup_delay(sih);
 		INTR_RESTORE(sii, intr_val);
 		return fpdelay;
 	}
 
-	if (!CCCTL_ENAB(sih))
+	if (!(sih->cccaps & CC_CAP_PWR_CTL))
 		return 0;
 
 	fast = SI_FAST(sii);
@@ -1726,7 +1756,7 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 			goto done;
 	}
 
-	if (!CCCTL_ENAB(&sii->pub) && (sii->pub.ccrev < 20))
+	if (!(sii->pub.cccaps & CC_CAP_PWR_CTL) && (sii->pub.ccrev < 20))
 		goto done;
 
 	switch (mode) {
@@ -1746,7 +1776,7 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 		}
 
 		/* wait for the PLL */
-		if (PMUCTL_ENAB(&sii->pub)) {
+		if (sii->pub.cccaps & CC_CAP_PMU) {
 			u32 htavail = CCS_HTAVAIL;
 			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
 				  == 0), PMU_MAX_TRANSITION_DLY);
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index fcf38b8..0d4fa85 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -23,18 +23,6 @@
  * SOC Interconnect Address Map.
  * All regions may not exist on all chips.
  */
-/* Physical SDRAM */
-#define SI_SDRAM_BASE		0x00000000
-/* Host Mode sb2pcitranslation0 (64 MB) */
-#define SI_PCI_MEM		0x08000000
-#define SI_PCI_MEM_SZ		(64 * 1024 * 1024)
-/* Host Mode sb2pcitranslation1 (64 MB) */
-#define SI_PCI_CFG		0x0c000000
-/* Region 2 for sdram (512 MB) */
-#define SI_SDRAM_R2		0x80000000
-
-/* Wrapper space base */
-#define SI_WRAP_BASE		0x18100000
 /* each core gets 4Kbytes for registers */
 #define SI_CORE_SIZE		0x1000
 /*
@@ -44,39 +32,9 @@
  */
 #define	SI_MAXCORES		16
 
-/* On-chip RAM on chips that also have DDR */
-#define	SI_FASTRAM		0x19000000
-#define	SI_FASTRAM_SWAPPED	0x19800000
-
-/* Flash Region 2 (region 1 shadowed here) */
-#define	SI_FLASH2		0x1c000000
-/* Size of Flash Region 2 */
-#define	SI_FLASH2_SZ		0x02000000
-/* ARM Cortex-M3 ROM */
-#define	SI_ARMCM3_ROM		0x1e000000
-/* MIPS Flash Region 1 */
-#define	SI_FLASH1		0x1fc00000
-/* MIPS Size of Flash Region 1 */
-#define	SI_FLASH1_SZ		0x00400000
-/* ARM7TDMI-S ROM */
-#define	SI_ARM7S_ROM		0x20000000
-/* ARM Cortex-M3 SRAM Region 2 */
-#define	SI_ARMCM3_SRAM2		0x60000000
-/* ARM7TDMI-S SRAM Region 2 */
-#define	SI_ARM7S_SRAM2		0x80000000
-/* ARM Flash Region 1 */
-#define	SI_ARM_FLASH1		0xffff0000
-/* ARM Size of Flash Region 1 */
-#define	SI_ARM_FLASH1_SZ	0x00010000
-
-/* Client Mode sb2pcitranslation2 (1 GB) */
-#define SI_PCI_DMA		0x40000000
-/* Client Mode sb2pcitranslation2 (1 GB) */
-#define SI_PCI_DMA2		0x80000000
 /* Client Mode sb2pcitranslation2 size in bytes */
 #define SI_PCI_DMA_SZ		0x40000000
-/* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), low 32 bits */
-#define SI_PCIE_DMA_L32		0x00000000
+
 /* PCIE Client Mode sb2pcitranslation2 (2 ZettaBytes), high 32 bits */
 #define SI_PCIE_DMA_H32		0x80000000
 
@@ -195,18 +153,6 @@
 /* Minumum amount of flash we support */
 #define FLASH_MIN		0x00020000	/* Minimum flash size */
 
-/* A boot/binary may have an embedded block that describes its size  */
-#define	BISZ_OFFSET		0x3e0	/* At this offset into the binary */
-#define	BISZ_MAGIC		0x4249535a	/* Marked with value: 'BISZ' */
-#define	BISZ_MAGIC_IDX		0	/* Word 0: magic */
-#define	BISZ_TXTST_IDX		1	/*      1: text start */
-#define	BISZ_TXTEND_IDX		2	/*      2: text end */
-#define	BISZ_DATAST_IDX		3	/*      3: data start */
-#define	BISZ_DATAEND_IDX	4	/*      4: data end */
-#define	BISZ_BSSST_IDX		5	/*      5: bss start */
-#define	BISZ_BSSEND_IDX		6	/*      6: bss end */
-#define BISZ_SIZE		7	/* descriptor size in 32-bit integers */
-
 #define	CC_SROM_OTP		0x800	/* SROM/OTP address space */
 
 /* gpiotimerval */
@@ -216,23 +162,6 @@
 #define	CLKD_OTP		0x000f0000
 #define	CLKD_OTP_SHIFT		16
 
-/* When Srom support present, fields in sromcontrol */
-#define	SRC_START		0x80000000
-#define	SRC_BUSY		0x80000000
-#define	SRC_OPCODE		0x60000000
-#define	SRC_OP_READ		0x00000000
-#define	SRC_OP_WRITE		0x20000000
-#define	SRC_OP_WRDIS		0x40000000
-#define	SRC_OP_WREN		0x60000000
-#define	SRC_OTPSEL		0x00000010
-#define	SRC_LOCK		0x00000008
-#define	SRC_SIZE_MASK		0x00000006
-#define	SRC_SIZE_1K		0x00000000
-#define	SRC_SIZE_4K		0x00000002
-#define	SRC_SIZE_16K		0x00000004
-#define	SRC_SIZE_SHIFT		1
-#define	SRC_PRESENT		0x00000001
-
 /* Package IDs */
 #define	BCM4717_PKG_ID		9	/* 4717 package id */
 #define	BCM4718_PKG_ID		10	/* 4718 package id */
@@ -243,38 +172,6 @@
 #define	BCM47162_CHIP_ID	47162	/* 47162 chipcommon chipid */
 #define	BCM4748_CHIP_ID		0x4748	/* 4716 chipcommon chipid (OTP, RBBU) */
 
-#define	GOODCOREADDR(x, b) \
-	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
-		IS_ALIGNED((x), SI_CORE_SIZE))
-#define	GOODREGS(regs) \
-	((regs) != NULL && IS_ALIGNED((unsigned long)(regs), SI_CORE_SIZE))
-#define BADCOREADDR	0
-#define	GOODIDX(idx)	(((uint)idx) < SI_MAXCORES)
-#define	NOREV		-1	/* Invalid rev */
-
-/* Newer chips can access PCI/PCIE and CC core without requiring to change
- * PCI BAR0 WIN
- */
-#define SI_FAST(si) (((si)->pub.buscoretype == PCIE_CORE_ID) ||	\
-		     (((si)->pub.buscoretype == PCI_CORE_ID) && \
-		      (si)->pub.buscorerev >= 13))
-
-#define PCIEREGS(si) (((char *)((si)->curmap) + PCI_16KB0_PCIREGS_OFFSET))
-#define CCREGS_FAST(si) (((char *)((si)->curmap) + PCI_16KB0_CCREGS_OFFSET))
-
-/*
- * Macros to disable/restore function core(D11, ENET, ILINE20, etc) interrupts
- * before after core switching to avoid invalid register accesss inside ISR.
- */
-#define INTR_OFF(si, intr_val) \
-	if ((si)->intrsoff_fn && \
-	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
-		intr_val = (*(si)->intrsoff_fn)((si)->intr_arg)
-#define INTR_RESTORE(si, intr_val) \
-	if ((si)->intrsrestore_fn && \
-	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
-		(*(si)->intrsrestore_fn)((si)->intr_arg, intr_val)
-
 /* dynamic clock control defines */
 #define	LPOMINFREQ		25000	/* low power oscillator min */
 #define	LPOMAXFREQ		43000	/* low power oscillator max */
@@ -286,55 +183,6 @@
 #define	ILP_DIV_5MHZ		0	/* ILP = 5 MHz */
 #define	ILP_DIV_1MHZ		4	/* ILP = 1 MHz */
 
-#define PCI(si)		((si)->pub.buscoretype == PCI_CORE_ID)
-#define PCIE(si)	((si)->pub.buscoretype == PCIE_CORE_ID)
-#define PCI_FORCEHT(si)	\
-	(PCIE(si) && (si->pub.chip == BCM4716_CHIP_ID))
-
-/* GPIO Based LED powersave defines */
-#define DEFAULT_GPIO_ONTIME	10	/* Default: 10% on */
-#define DEFAULT_GPIO_OFFTIME	90	/* Default: 10% on */
-
-#define DEFAULT_GPIOTIMERVAL \
-	((DEFAULT_GPIO_ONTIME << GPIO_ONTIME_SHIFT) | DEFAULT_GPIO_OFFTIME)
-
-/*
- * Data structure to export all chip specific common variables
- *   public (read-only) portion of aiutils handle returned by si_attach()
- */
-struct si_pub {
-	uint buscoretype;	/* PCI_CORE_ID, PCIE_CORE_ID, PCMCIA_CORE_ID */
-	uint buscorerev;	/* buscore rev */
-	uint buscoreidx;	/* buscore index */
-	int ccrev;		/* chip common core rev */
-	u32 cccaps;		/* chip common capabilities */
-	u32 cccaps_ext;	/* chip common capabilities extension */
-	int pmurev;		/* pmu core rev */
-	u32 pmucaps;		/* pmu capabilities */
-	uint boardtype;		/* board type */
-	uint boardvendor;	/* board vendor */
-	uint boardflags;	/* board flags */
-	uint boardflags2;	/* board flags2 */
-	uint chip;		/* chip number */
-	uint chiprev;		/* chip revision */
-	uint chippkg;		/* chip package option */
-	u32 chipst;		/* chip status */
-	bool issim;		/* chip is in simulation or emulation */
-	uint socirev;		/* SOC interconnect rev */
-	bool pci_pr32414;
-
-};
-
-/*
- * Many of the routines below take an 'sih' handle as their first arg.
- * Allocate this by calling si_attach().  Free it by calling si_detach().
- * At any one time, the sih is logically focused on one particular si core
- * (the "current core").
- * Use si_setcore() or si_setcoreidx() to change the association to another core
- */
-
-#define	BADIDX		(SI_MAXCORES + 1)
-
 /* clkctl xtal what flags */
 #define	XTAL			0x1	/* primary crystal oscillator (2050) */
 #define	PLL			0x2	/* main chip pll */
@@ -367,26 +215,32 @@ struct si_pub {
 #define SI_PCIDOWN	2
 #define SI_PCIUP	3
 
-/* PMU clock/power control */
-#define PMUCTL_ENAB(sih)	((sih)->cccaps & CC_CAP_PMU)
-
-/* chipcommon clock/power control (exclusive with PMU's) */
-#define CCCTL_ENAB(sih)		((sih)->cccaps & CC_CAP_PWR_CTL)
-#define CCPLL_ENAB(sih)		((sih)->cccaps & CC_CAP_PLL_MASK)
-
-/* External PA enable mask */
-#define GPIO_CTRL_EPA_EN_MASK 0x40
-
-#define	SI_ERROR(args)
-
-#ifdef BCMDBG
-#define	SI_MSG(args)	printk args
-#else
-#define	SI_MSG(args)
-#endif				/* BCMDBG */
+/*
+ * Data structure to export all chip specific common variables
+ *   public (read-only) portion of aiutils handle returned by si_attach()
+ */
+struct si_pub {
+	uint buscoretype;	/* PCI_CORE_ID, PCIE_CORE_ID, PCMCIA_CORE_ID */
+	uint buscorerev;	/* buscore rev */
+	uint buscoreidx;	/* buscore index */
+	int ccrev;		/* chip common core rev */
+	u32 cccaps;		/* chip common capabilities */
+	u32 cccaps_ext;	/* chip common capabilities extension */
+	int pmurev;		/* pmu core rev */
+	u32 pmucaps;		/* pmu capabilities */
+	uint boardtype;		/* board type */
+	uint boardvendor;	/* board vendor */
+	uint boardflags;	/* board flags */
+	uint boardflags2;	/* board flags2 */
+	uint chip;		/* chip number */
+	uint chiprev;		/* chip revision */
+	uint chippkg;		/* chip package option */
+	u32 chipst;		/* chip status */
+	bool issim;		/* chip is in simulation or emulation */
+	uint socirev;		/* SOC interconnect rev */
+	bool pci_pr32414;
 
-/* Define SI_VMSG to printf for verbose debugging, but don't check it in */
-#define	SI_VMSG(args)
+};
 
 struct pci_dev;
 
@@ -436,6 +290,15 @@ struct si_info {
 	u32 oob_router;	/* oob router registers for axi */
 };
 
+/*
+ * Many of the routines below take an 'sih' handle as their first arg.
+ * Allocate this by calling si_attach().  Free it by calling si_detach().
+ * At any one time, the sih is logically focused on one particular si core
+ * (the "current core").
+ * Use si_setcore() or si_setcoreidx() to change the association to another core
+ */
+
+
 /* AMBA Interconnect exported externs */
 extern uint ai_flag(struct si_pub *sih);
 extern void ai_setint(struct si_pub *sih, int siflag);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 6ded4fb..03985ca 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -168,6 +168,8 @@
 #define AC_VI			2
 #define AC_VO			3
 
+#define	BCN_TMPL_LEN		512	/* length of the BCN template area */
+
 /*
  * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s
  * OS timer(soft watchdog) it is not a wall clock and won't increment when
@@ -927,7 +929,7 @@ static int brcms_b_bandtype(struct brcms_hardware *wlc_hw)
 /* control chip clock to save power, enable dynamic clock or force fast clock */
 static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 {
-	if (PMUCTL_ENAB(wlc_hw->sih)) {
+	if (wlc_hw->sih->cccaps & CC_CAP_PMU) {
 		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock
 		 * on backplane, but mac core will still run on ALP(not HT) when
 		 * it enters powersave mode, which means the FCA bit may not be
@@ -1642,7 +1644,7 @@ static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
 	if (macaddr != NULL)
 		return macaddr;
 
-	if (NBANDS_HW(wlc_hw) > 1)
+	if (wlc_hw->_nbands > 1)
 		varname = "et1macaddr";
 	else
 		varname = "il0macaddr";
@@ -1806,7 +1808,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 
 	brcms_c_mctrl_reset(wlc_hw);
 
-	if (PMUCTL_ENAB(wlc_hw->sih))
+	if (wlc_hw->sih->cccaps & CC_CAP_PMU)
 		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	brcms_b_phy_reset(wlc_hw);
@@ -3204,7 +3206,7 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 	 * We might have been bandlocked during down and the chip
 	 * power-cycled (hibernate). Figure out the right band to park on
 	 */
-	if (wlc->bandlocked || NBANDS(wlc) == 1) {
+	if (wlc->bandlocked || wlc->pub->_nbands == 1) {
 		/* updated in brcms_c_bandlock() */
 		parkband = wlc->band->bandunit;
 		band_order[0] = band_order[1] = parkband;
@@ -3218,7 +3220,7 @@ static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
 	}
 
 	/* make each band operational, software state init */
-	for (i = 0; i < NBANDS(wlc); i++) {
+	for (i = 0; i < wlc->pub->_nbands; i++) {
 		uint j = band_order[i];
 
 		wlc->band = wlc->bandstate[j];
@@ -3659,7 +3661,7 @@ brcms_b_set_chanspec(struct brcms_hardware *wlc_hw, u16 chanspec,
 	wlc_hw->chanspec = chanspec;
 
 	/* Switch bands if necessary */
-	if (NBANDS_HW(wlc_hw) > 1) {
+	if (wlc_hw->_nbands > 1) {
 		bandunit = CHSPEC_BANDUNIT(chanspec);
 		if (wlc_hw->band->bandunit != bandunit) {
 			/* brcms_b_setband disables other bandunit,
@@ -3729,7 +3731,7 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 	}
 
 	/* Switch bands if necessary */
-	if (NBANDS(wlc) > 1) {
+	if (wlc->pub->_nbands > 1) {
 		bandunit = CHSPEC_BANDUNIT(chanspec);
 		if (wlc->band->bandunit != bandunit || wlc->bandinit_pending) {
 			switchband = true;
@@ -4594,16 +4596,12 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	}
 
 	/* initialize software state for each core and band */
-	for (j = 0; j < NBANDS_HW(wlc_hw); j++) {
+	for (j = 0; j < wlc_hw->_nbands; j++) {
 		/*
 		 * band0 is always 2.4Ghz
 		 * band1, if present, is 5Ghz
 		 */
 
-		/* So if this is a single band 11a card, use band 1 */
-		if (IS_SINGLEBAND_5G(wlc_hw->deviceid))
-			j = BAND_5G_INDEX;
-
 		brcms_c_setxband(wlc_hw, j);
 
 		wlc_hw->band->bandunit = j;
@@ -4836,7 +4834,8 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 
 	/* find the band of our default channel */
 	band = wlc->band;
-	if (NBANDS(wlc) > 1 && band->bandunit != CHSPEC_BANDUNIT(chanspec))
+	if (wlc->pub->_nbands > 1 &&
+	    band->bandunit != CHSPEC_BANDUNIT(chanspec))
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 
 	/* init bss rates to the band specific default rate set */
@@ -4905,9 +4904,7 @@ static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 	uint i;
 	struct brcms_band *band;
 
-	for (i = 0; i < NBANDS(wlc); i++) {
-		if (IS_SINGLEBAND_5G(wlc->deviceid))
-			i = BAND_5G_INDEX;
+	for (i = 0; i < wlc->pub->_nbands; i++) {
 		band = wlc->bandstate[i];
 		if (band->bandtype == BRCM_BAND_5G) {
 			if ((bwcap == BRCMS_N_BW_40ALL)
@@ -5016,11 +5013,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 
 	memcpy(&pub->cur_etheraddr, &wlc->perm_etheraddr, ETH_ALEN);
 
-	for (j = 0; j < NBANDS(wlc); j++) {
-		/* Use band 1 for single band 11a */
-		if (IS_SINGLEBAND_5G(wlc->deviceid))
-			j = BAND_5G_INDEX;
-
+	for (j = 0; j < wlc->pub->_nbands; j++) {
 		wlc->band = wlc->bandstate[j];
 
 		if (!brcms_c_attach_stf_ant_init(wlc)) {
@@ -5233,7 +5226,7 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
 	brcms_b_detach_dmapio(wlc_hw);
 
 	band = wlc_hw->band;
-	for (i = 0; i < NBANDS_HW(wlc_hw); i++) {
+	for (i = 0; i < wlc_hw->_nbands; i++) {
 		if (band->pi) {
 			/* Detach this band's phy */
 			wlc_phy_detach(band->pi);
@@ -5780,7 +5773,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	/* verify that we are dealing with 2G band and grab the band pointer */
 	if (wlc->band->bandtype == BRCM_BAND_2G)
 		band = wlc->band;
-	else if ((NBANDS(wlc) > 1) &&
+	else if ((wlc->pub->_nbands > 1) &&
 		 (wlc->bandstate[OTHERBANDUNIT(wlc)]->bandtype == BRCM_BAND_2G))
 		band = wlc->bandstate[OTHERBANDUNIT(wlc)];
 	else
@@ -5942,7 +5935,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 		wlc->default_bss->flags &= ~BRCMS_BSS_HT;
 		/* delete the mcs rates from the default and hw ratesets */
 		brcms_c_rateset_mcs_clear(&wlc->default_bss->rateset);
-		for (i = 0; i < NBANDS(wlc); i++) {
+		for (i = 0; i < wlc->pub->_nbands; i++) {
 			memset(wlc->bandstate[i]->hw_rateset.mcs, 0,
 			       MCSSET_LEN);
 			if (IS_MCS(wlc->band->rspec_override)) {
@@ -5971,7 +5964,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 		/* add the mcs rates to the default and hw ratesets */
 		brcms_c_rateset_mcs_build(&wlc->default_bss->rateset,
 				      wlc->stf->txstreams);
-		for (i = 0; i < NBANDS(wlc); i++)
+		for (i = 0; i < wlc->pub->_nbands; i++)
 			memcpy(wlc->bandstate[i]->hw_rateset.mcs,
 			       wlc->default_bss->rateset.mcs, MCSSET_LEN);
 		break;
@@ -8886,7 +8879,7 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 
 	if ((band == BRCM_BAND_AUTO) || (band == wlc->band->bandtype))
 		hw_rateset = &wlc->band->hw_rateset;
-	else if (NBANDS(wlc) > 1)
+	else if (wlc->pub->_nbands > 1)
 		hw_rateset = &wlc->bandstate[OTHERBANDUNIT(wlc)]->hw_rateset;
 	else
 		/* other band specified and we are a single band device */
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index cdeaa4e..61ba373 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -206,7 +206,7 @@ u32 si_pmu_ilp_clock(struct si_pub *sih)
 {
 	static u32 ilpcycles_per_sec;
 
-	if (!PMUCTL_ENAB(sih))
+	if (!(sih->cccaps & CC_CAP_PMU))
 		return ILP_CLOCK;
 
 	if (ilpcycles_per_sec == 0) {
@@ -297,7 +297,7 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 	u32 clock = ALP_CLOCK;
 
 	/* bail out with default */
-	if (!PMUCTL_ENAB(sih))
+	if (!(sih->cccaps & CC_CAP_PMU))
 		return clock;
 
 	switch (sih->chip) {
-- 
1.7.4.1


