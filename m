Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2131 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752414Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/23] brcm80211: smac: use inline access functions for
 struct si_pub fields
Date: Thu, 8 Dec 2011 15:06:45 -0800
Message-ID: <1323385619-7454-10-git-send-email-frankyl@broadcom.com> (sfid-20111209_000736_679455_458BD784)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Instead of directly accessing the fields in struct si_pub the driver
now uses inline access functions. This is in preparation of the bcma
integration as a lot of information will be provided by bcma module.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |  118 ++++++++++----------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |   46 ++++++++
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |   56 +++++-----
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c   |   35 +++---
 drivers/net/wireless/brcm80211/brcmsmac/otp.c      |   20 ++--
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |    2 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_hal.h  |    2 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_int.h  |    2 -
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   20 ++--
 drivers/net/wireless/brcm80211/brcmsmac/srom.c     |    4 +-
 10 files changed, 174 insertions(+), 131 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 8586ab7..83a0138 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -321,9 +321,9 @@
 /* Newer chips can access PCI/PCIE and CC core without requiring to change
  * PCI BAR0 WIN
  */
-#define SI_FAST(si) (((si)->pub.buscoretype == PCIE_CORE_ID) ||	\
-		     (((si)->pub.buscoretype == PCI_CORE_ID) && \
-		      (si)->pub.buscorerev >= 13))
+#define SI_FAST(sih) ((ai_get_buscoretype(sih) == PCIE_CORE_ID) || \
+		     ((ai_get_buscoretype(sih) == PCI_CORE_ID) && \
+		      ai_get_buscorerev(sih) >= 13))
 
 #define CCREGS_FAST(si) (((char __iomem *)((si)->curmap) + \
 			  PCI_16KB0_CCREGS_OFFSET))
@@ -345,10 +345,10 @@
 	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
 		(*(si)->intrsrestore_fn)((si)->intr_arg, intr_val)
 
-#define PCI(si)		((si)->pub.buscoretype == PCI_CORE_ID)
-#define PCIE(si)	((si)->pub.buscoretype == PCIE_CORE_ID)
+#define PCI(sih)	(ai_get_buscoretype(sih) == PCI_CORE_ID)
+#define PCIE(sih)	(ai_get_buscoretype(sih) == PCIE_CORE_ID)
 
-#define PCI_FORCEHT(si)	(PCIE(si) && (si->pub.chip == BCM4716_CHIP_ID))
+#define PCI_FORCEHT(sih) (PCIE(sih) && (ai_get_chip_id(sih) == BCM4716_CHIP_ID))
 
 #ifdef BCMDBG
 #define	SI_MSG(fmt, ...)	pr_debug(fmt, ##__VA_ARGS__)
@@ -927,14 +927,14 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	sii->pub.ccrev = (int)ai_corerev(&sii->pub);
 
 	/* get chipcommon chipstatus */
-	if (sii->pub.ccrev >= 11)
+	if (ai_get_ccrev(&sii->pub) >= 11)
 		sii->chipst = R_REG(&cc->chipstatus);
 
 	/* get chipcommon capabilites */
 	sii->pub.cccaps = R_REG(&cc->capabilities);
 
 	/* get pmu rev and caps */
-	if (sii->pub.cccaps & CC_CAP_PMU) {
+	if (ai_get_cccaps(&sii->pub) & CC_CAP_PMU) {
 		sii->pub.pmucaps = R_REG(&cc->pmucapabilities);
 		sii->pub.pmurev = sii->pub.pmucaps & PCAP_REV_MASK;
 	}
@@ -988,7 +988,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	}
 
 	/* fixup necessary chip/core configurations */
-	if (SI_FAST(sii)) {
+	if (SI_FAST(&sii->pub)) {
 		if (!sii->pch) {
 			sii->pch = pcicore_init(&sii->pub, sii->pbus,
 						(__iomem void *)PCIEREGS(sii));
@@ -1097,7 +1097,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_setcoreidx(sih, origidx);
 
 	/* PMU specific initializations */
-	if (sih->cccaps & CC_CAP_PMU) {
+	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
 		u32 xtalfreq;
 		si_pmu_init(sih);
 		si_pmu_chip_init(sih);
@@ -1115,15 +1115,15 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, gpiotimerval),
 		   ~0, w);
 
-	if (PCIE(sii))
+	if (PCIE(sih))
 		pcicore_attach(sii->pch, SI_DOATTACH);
 
-	if (sih->chip == BCM43224_CHIP_ID) {
+	if (ai_get_chip_id(sih) == BCM43224_CHIP_ID) {
 		/*
 		 * enable 12 mA drive strenth for 43224 and
 		 * set chipControl register bit 15
 		 */
-		if (sih->chiprev == 0) {
+		if (ai_get_chiprev(sih) == 0) {
 			SI_MSG("Applying 43224A0 WARs\n");
 			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(struct chipcregs, chipcontrol),
@@ -1132,14 +1132,14 @@ static struct si_info *ai_doattach(struct si_info *sii,
 			si_pmu_chipcontrol(sih, 0, CCTRL_43224A0_12MA_LED_DRIVE,
 					   CCTRL_43224A0_12MA_LED_DRIVE);
 		}
-		if (sih->chiprev >= 1) {
+		if (ai_get_chiprev(sih) >= 1) {
 			SI_MSG("Applying 43224B0+ WARs\n");
 			si_pmu_chipcontrol(sih, 0, CCTRL_43224B0_12MA_LED_DRIVE,
 					   CCTRL_43224B0_12MA_LED_DRIVE);
 		}
 	}
 
-	if (sih->chip == BCM4313_CHIP_ID) {
+	if (ai_get_chip_id(sih) == BCM4313_CHIP_ID) {
 		/*
 		 * enable 12 mA drive strenth for 4313 and
 		 * set chipControl register bit 1
@@ -1249,7 +1249,7 @@ uint ai_coreidx(struct si_pub *sih)
 
 bool ai_backplane64(struct si_pub *sih)
 {
-	return (sih->cccaps & CC_CAP_BKPLN64) != 0;
+	return (ai_get_cccaps(sih) & CC_CAP_BKPLN64) != 0;
 }
 
 /* return index of coreid or BADIDX if not found */
@@ -1299,7 +1299,7 @@ void __iomem *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 
 	sii = (struct si_info *)sih;
 
-	if (SI_FAST(sii)) {
+	if (SI_FAST(sih)) {
 		/* Overloading the origidx variable to remember the coreid,
 		 * this works because the core ids cannot be confused with
 		 * core indices.
@@ -1307,7 +1307,7 @@ void __iomem *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 		*origidx = coreid;
 		if (coreid == CC_CORE_ID)
 			return CCREGS_FAST(sii);
-		else if (coreid == sih->buscoretype)
+		else if (coreid == ai_get_buscoretype(sih))
 			return PCIEREGS(sii);
 	}
 	INTR_OFF(sii, *intr_val);
@@ -1322,8 +1322,8 @@ void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 	struct si_info *sii;
 
 	sii = (struct si_info *)sih;
-	if (SI_FAST(sii)
-	    && ((coreid == CC_CORE_ID) || (coreid == sih->buscoretype)))
+	if (SI_FAST(sih)
+	    && ((coreid == CC_CORE_ID) || (coreid == ai_get_buscoretype(sih))))
 		return;
 
 	ai_setcoreidx(sih, coreid);
@@ -1367,7 +1367,7 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	 * If pci/pcie, we can get at pci/pcie regs
 	 * and on newer cores to chipc
 	 */
-	if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sii)) {
+	if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sih)) {
 		/* Chipc registers are mapped at 12KB */
 		fast = true;
 		r = (u32 __iomem *)((__iomem char *)sii->curmap +
@@ -1378,7 +1378,7 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		 * an 8KB window or, in pcie and pci rev 13 at 8KB
 		 */
 		fast = true;
-		if (SI_FAST(sii))
+		if (SI_FAST(sih))
 			r = (u32 __iomem *)((__iomem char *)sii->curmap +
 				    PCI_16KB0_PCIREGS_OFFSET + regoff);
 		else
@@ -1480,13 +1480,13 @@ static uint ai_slowclk_src(struct si_info *sii)
 	struct chipcregs __iomem *cc;
 	u32 val;
 
-	if (sii->pub.ccrev < 6) {
+	if (ai_get_ccrev(&sii->pub) < 6) {
 		pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
 				      &val);
 		if (val & PCI_CFG_GPIO_SCS)
 			return SCC_SS_PCI;
 		return SCC_SS_XTAL;
-	} else if (sii->pub.ccrev < 10) {
+	} else if (ai_get_ccrev(&sii->pub) < 10) {
 		cc = (struct chipcregs __iomem *)
 			ai_setcoreidx(&sii->pub, sii->curidx);
 		return R_REG(&cc->slow_clk_ctl) & SCC_SS_MASK;
@@ -1505,14 +1505,14 @@ static uint ai_slowclk_freq(struct si_info *sii, bool max_freq,
 	uint div;
 
 	slowclk = ai_slowclk_src(sii);
-	if (sii->pub.ccrev < 6) {
+	if (ai_get_ccrev(&sii->pub) < 6) {
 		if (slowclk == SCC_SS_PCI)
 			return max_freq ? (PCIMAXFREQ / 64)
 				: (PCIMINFREQ / 64);
 		else
 			return max_freq ? (XTALMAXFREQ / 32)
 				: (XTALMINFREQ / 32);
-	} else if (sii->pub.ccrev < 10) {
+	} else if (ai_get_ccrev(&sii->pub) < 10) {
 		div = 4 *
 		    (((R_REG(&cc->slow_clk_ctl) & SCC_CD_MASK) >>
 		      SCC_CD_SHIFT) + 1);
@@ -1553,7 +1553,8 @@ ai_clkctl_setdelay(struct si_info *sii, struct chipcregs __iomem *cc)
 
 	/* Starting with 4318 it is ILP that is used for the delays */
 	slowmaxfreq =
-	    ai_slowclk_freq(sii, (sii->pub.ccrev >= 10) ? false : true, cc);
+	    ai_slowclk_freq(sii,
+			    (ai_get_ccrev(&sii->pub) >= 10) ? false : true, cc);
 
 	pll_on_delay = ((slowmaxfreq * pll_delay) + 999999) / 1000000;
 	fref_sel_delay = ((slowmaxfreq * FREF_DELAY) + 999999) / 1000000;
@@ -1570,11 +1571,11 @@ void ai_clkctl_init(struct si_pub *sih)
 	struct chipcregs __iomem *cc;
 	bool fast;
 
-	if (!(sih->cccaps & CC_CAP_PWR_CTL))
+	if (!(ai_get_cccaps(sih) & CC_CAP_PWR_CTL))
 		return;
 
 	sii = (struct si_info *)sih;
-	fast = SI_FAST(sii);
+	fast = SI_FAST(sih);
 	if (!fast) {
 		origidx = sii->curidx;
 		cc = (struct chipcregs __iomem *)
@@ -1588,7 +1589,7 @@ void ai_clkctl_init(struct si_pub *sih)
 	}
 
 	/* set all Instaclk chip ILP to 1 MHz */
-	if (sih->ccrev >= 10)
+	if (ai_get_ccrev(sih) >= 10)
 		SET_REG(&cc->system_clk_ctl, SYCC_CD_MASK,
 			(ILP_DIV_1MHZ << SYCC_CD_SHIFT));
 
@@ -1613,17 +1614,17 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	bool fast;
 
 	sii = (struct si_info *)sih;
-	if (sih->cccaps & CC_CAP_PMU) {
+	if (ai_get_cccaps(sih) & CC_CAP_PMU) {
 		INTR_OFF(sii, intr_val);
 		fpdelay = si_pmu_fast_pwrup_delay(sih);
 		INTR_RESTORE(sii, intr_val);
 		return fpdelay;
 	}
 
-	if (!(sih->cccaps & CC_CAP_PWR_CTL))
+	if (!(ai_get_cccaps(sih) & CC_CAP_PWR_CTL))
 		return 0;
 
-	fast = SI_FAST(sii);
+	fast = SI_FAST(sih);
 	fpdelay = 0;
 	if (!fast) {
 		origidx = sii->curidx;
@@ -1659,7 +1660,7 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 	sii = (struct si_info *)sih;
 
 	/* pcie core doesn't have any mapping to control the xtal pu */
-	if (PCIE(sii))
+	if (PCIE(sih))
 		return -1;
 
 	pci_read_config_dword(sii->pbus, PCI_GPIO_IN, &in);
@@ -1720,10 +1721,10 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	struct chipcregs __iomem *cc;
 	u32 scc;
 	uint intr_val = 0;
-	bool fast = SI_FAST(sii);
+	bool fast = SI_FAST(&sii->pub);
 
 	/* chipcommon cores prior to rev6 don't support dynamic clock control */
-	if (sii->pub.ccrev < 6)
+	if (ai_get_ccrev(&sii->pub) < 6)
 		return false;
 
 	if (!fast) {
@@ -1737,12 +1738,13 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 			goto done;
 	}
 
-	if (!(sii->pub.cccaps & CC_CAP_PWR_CTL) && (sii->pub.ccrev < 20))
+	if (!(ai_get_cccaps(&sii->pub) & CC_CAP_PWR_CTL) &&
+	    (ai_get_ccrev(&sii->pub) < 20))
 		goto done;
 
 	switch (mode) {
 	case CLK_FAST:		/* FORCEHT, fast (pll) clock */
-		if (sii->pub.ccrev < 10) {
+		if (ai_get_ccrev(&sii->pub) < 10) {
 			/*
 			 * don't forget to force xtal back
 			 * on before we clear SCC_DYN_XTAL..
@@ -1750,14 +1752,14 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 			ai_clkctl_xtal(&sii->pub, XTAL, ON);
 			SET_REG(&cc->slow_clk_ctl,
 				(SCC_XC | SCC_FS | SCC_IP), SCC_IP);
-		} else if (sii->pub.ccrev < 20) {
+		} else if (ai_get_ccrev(&sii->pub) < 20) {
 			OR_REG(&cc->system_clk_ctl, SYCC_HR);
 		} else {
 			OR_REG(&cc->clk_ctl_st, CCS_FORCEHT);
 		}
 
 		/* wait for the PLL */
-		if (sii->pub.cccaps & CC_CAP_PMU) {
+		if (ai_get_cccaps(&sii->pub) & CC_CAP_PMU) {
 			u32 htavail = CCS_HTAVAIL;
 			SPINWAIT(((R_REG(&cc->clk_ctl_st) & htavail)
 				  == 0), PMU_MAX_TRANSITION_DLY);
@@ -1767,7 +1769,7 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 		break;
 
 	case CLK_DYNAMIC:	/* enable dynamic clock control */
-		if (sii->pub.ccrev < 10) {
+		if (ai_get_ccrev(&sii->pub) < 10) {
 			scc = R_REG(&cc->slow_clk_ctl);
 			scc &= ~(SCC_FS | SCC_IP | SCC_XC);
 			if ((scc & SCC_SS_MASK) != SCC_SS_XTAL)
@@ -1780,7 +1782,7 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 			 */
 			if (scc & SCC_XC)
 				ai_clkctl_xtal(&sii->pub, XTAL, OFF);
-		} else if (sii->pub.ccrev < 20) {
+		} else if (ai_get_ccrev(&sii->pub) < 20) {
 			/* Instaclock */
 			AND_REG(&cc->system_clk_ctl, ~SYCC_HR);
 		} else {
@@ -1815,10 +1817,10 @@ bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 	sii = (struct si_info *)sih;
 
 	/* chipcommon cores prior to rev6 don't support dynamic clock control */
-	if (sih->ccrev < 6)
+	if (ai_get_ccrev(sih) < 6)
 		return false;
 
-	if (PCI_FORCEHT(sii))
+	if (PCI_FORCEHT(sih))
 		return mode == CLK_FAST;
 
 	return _ai_clkctl_cc(sii, mode);
@@ -1851,10 +1853,10 @@ void ai_pci_up(struct si_pub *sih)
 
 	sii = (struct si_info *)sih;
 
-	if (PCI_FORCEHT(sii))
+	if (PCI_FORCEHT(sih))
 		_ai_clkctl_cc(sii, CLK_FAST);
 
-	if (PCIE(sii))
+	if (PCIE(sih))
 		pcicore_up(sii->pch, SI_PCIUP);
 
 }
@@ -1877,7 +1879,7 @@ void ai_pci_down(struct si_pub *sih)
 	sii = (struct si_info *)sih;
 
 	/* release FORCEHT since chip is going to "down" state */
-	if (PCI_FORCEHT(sii))
+	if (PCI_FORCEHT(sih))
 		_ai_clkctl_cc(sii, CLK_DYNAMIC);
 
 	pcicore_down(sii->pch, SI_PCIDOWN);
@@ -1896,7 +1898,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 
 	sii = (struct si_info *)sih;
 
-	if (PCI(sii)) {
+	if (PCI(sih)) {
 		/* get current core index */
 		idx = sii->curidx;
 
@@ -1911,7 +1913,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 	 * Enable sb->pci interrupts.  Assume
 	 * PCI rev 2.3 support was added in pci core rev 6 and things changed..
 	 */
-	if (PCIE(sii) || (PCI(sii) && ((sii->pub.buscorerev) >= 6))) {
+	if (PCIE(sih) || (PCI(sih) && (ai_get_buscorerev(sih) >= 6))) {
 		/* pci config write to set this core bit in PCIIntMask */
 		pci_read_config_dword(sii->pbus, PCI_INT_MASK, &w);
 		w |= (coremask << PCI_SBIM_SHIFT);
@@ -1921,7 +1923,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 		ai_setint(sih, siflag);
 	}
 
-	if (PCI(sii)) {
+	if (PCI(sih)) {
 		pcicore_pci_setup(sii->pch, regs);
 
 		/* switch back to previous core */
@@ -1944,11 +1946,11 @@ int ai_pci_fixcfg(struct si_pub *sih)
 	origidx = ai_coreidx(&sii->pub);
 
 	/* check 'pi' is correct and fix it if not */
-	regs = ai_setcore(&sii->pub, sii->pub.buscoretype, 0);
-	if (sii->pub.buscoretype == PCIE_CORE_ID)
+	regs = ai_setcore(&sii->pub, ai_get_buscoretype(sih), 0);
+	if (ai_get_buscoretype(sih) == PCIE_CORE_ID)
 		pcicore_fixcfg_pcie(sii->pch,
 				    (struct sbpcieregs __iomem *)regs);
-	else if (sii->pub.buscoretype == PCI_CORE_ID)
+	else if (ai_get_buscoretype(sih) == PCI_CORE_ID)
 		pcicore_fixcfg_pci(sii->pch, (struct sbpciregs __iomem *)regs);
 
 	/* restore the original index */
@@ -1982,7 +1984,7 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 	val = R_REG(&cc->chipcontrol);
 
 	if (on) {
-		if (sih->chippkg == 9 || sih->chippkg == 0xb)
+		if (ai_get_chippkg(sih) == 9 || ai_get_chippkg(sih) == 0xb)
 			/* Ext PA Controls for 4331 12x9 Package */
 			W_REG(&cc->chipcontrol, val |
 			      CCTRL4331_EXTPA_EN |
@@ -2037,12 +2039,12 @@ bool ai_is_sprom_available(struct si_pub *sih)
 {
 	struct si_info *sii = (struct si_info *)sih;
 
-	if (sih->ccrev >= 31) {
+	if (ai_get_ccrev(sih) >= 31) {
 		uint origidx;
 		struct chipcregs __iomem *cc;
 		u32 sromctrl;
 
-		if ((sih->cccaps & CC_CAP_SROM) == 0)
+		if ((ai_get_cccaps(sih) & CC_CAP_SROM) == 0)
 			return false;
 
 		origidx = sii->curidx;
@@ -2052,7 +2054,7 @@ bool ai_is_sprom_available(struct si_pub *sih)
 		return sromctrl & SRC_PRESENT;
 	}
 
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM4313_CHIP_ID:
 		return (sii->chipst & CST4313_SPROM_PRESENT) != 0;
 	default:
@@ -2064,7 +2066,7 @@ bool ai_is_otp_disabled(struct si_pub *sih)
 {
 	struct si_info *sii = (struct si_info *)sih;
 
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM4313_CHIP_ID:
 		return (sii->chipst & CST4313_OTP_PRESENT) == 0;
 		/* These chips always have their OTP on */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index f049179..347b8a2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -292,4 +292,50 @@ extern void ai_chipcontrl_epa4331(struct si_pub *sih, bool on);
 /* Enable Ex-PA for 4313 */
 extern void ai_epa_4313war(struct si_pub *sih);
 
+static inline uint ai_get_buscoretype(struct si_pub *sih)
+{
+	return sih->buscoretype;
+}
+
+static inline uint ai_get_buscorerev(struct si_pub *sih)
+{
+	return sih->buscorerev;
+}
+static inline int ai_get_ccrev(struct si_pub *sih)
+{
+	return sih->ccrev;
+}
+static inline u32 ai_get_cccaps(struct si_pub *sih)
+{
+	return sih->cccaps;
+}
+static inline int ai_get_pmurev(struct si_pub *sih)
+{
+	return sih->pmurev;
+}
+static inline u32 ai_get_pmucaps(struct si_pub *sih)
+{
+	return sih->pmucaps;
+}
+static inline uint ai_get_boardtype(struct si_pub *sih)
+{
+	return sih->boardtype;
+}
+static inline uint ai_get_boardvendor(struct si_pub *sih)
+{
+	return sih->boardvendor;
+}
+static inline uint ai_get_chip_id(struct si_pub *sih)
+{
+	return sih->chip;
+}
+static inline uint ai_get_chiprev(struct si_pub *sih)
+{
+	return sih->chiprev;
+}
+static inline uint ai_get_chippkg(struct si_pub *sih)
+{
+	return sih->chippkg;
+}
+
 #endif				/* _BRCM_AIUTILS_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 87f8f5d..ed8fcb4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -1205,7 +1205,7 @@ static void brcms_b_wait_for_wake(struct brcms_hardware *wlc_hw)
 /* control chip clock to save power, enable dynamic clock or force fast clock */
 static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 {
-	if (wlc_hw->sih->cccaps & CC_CAP_PMU) {
+	if (ai_get_cccaps(wlc_hw->sih) & CC_CAP_PMU) {
 		/* new chips with PMU, CCS_FORCEHT will distribute the HT clock
 		 * on backplane, but mac core will still run on ALP(not HT) when
 		 * it enters powersave mode, which means the FCA bit may not be
@@ -1227,7 +1227,7 @@ static void brcms_b_clkctl_clk(struct brcms_hardware *wlc_hw, uint mode)
 					  (&wlc_hw->regs->
 					   clk_ctl_st) & CCS_HTAVAIL));
 			} else {
-				if ((wlc_hw->sih->pmurev == 0) &&
+				if ((ai_get_pmurev(wlc_hw->sih) == 0) &&
 				    (R_REG
 				     (&wlc_hw->regs->
 				      clk_ctl_st) & (CCS_FORCEHT | CCS_HTAREQ)))
@@ -1843,7 +1843,7 @@ static bool brcms_c_validboardtype(struct brcms_hardware *wlc_hw)
 	uint b2 = boardrev & 0xf;
 
 	/* voards from other vendors are always considered valid */
-	if (wlc_hw->sih->boardvendor != PCI_VENDOR_ID_BROADCOM)
+	if (ai_get_boardvendor(wlc_hw->sih) != PCI_VENDOR_ID_BROADCOM)
 		return true;
 
 	/* do some boardrev sanity checks when boardvendor is Broadcom */
@@ -1935,8 +1935,8 @@ static bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		 * AI chip doesn't restore bar0win2 on
 		 * hibernation/resume, need sw fixup
 		 */
-		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
-		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
+		if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
+		    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
 			wlc_hw->regs = (struct d11regs __iomem *)
 					ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 		ai_core_reset(wlc_hw->sih, flags, resetbits);
@@ -2034,7 +2034,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 
 	brcms_c_mctrl_reset(wlc_hw);
 
-	if (wlc_hw->sih->cccaps & CC_CAP_PMU)
+	if (ai_get_cccaps(wlc_hw->sih) & CC_CAP_PMU)
 		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
 	brcms_b_phy_reset(wlc_hw);
@@ -2117,8 +2117,8 @@ void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 {
 	struct d11regs __iomem *regs = wlc_hw->regs;
 
-	if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
-	    (wlc_hw->sih->chip == BCM43225_CHIP_ID)) {
+	if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
+	    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID)) {
 		if (spurmode == WL_SPURAVOID_ON2) {	/* 126Mhz */
 			W_REG(&regs->tsf_clk_frac_l, 0x2082);
 			W_REG(&regs->tsf_clk_frac_h, 0x8);
@@ -2805,7 +2805,7 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 	regs = wlc_hw->regs;
 
 	if (on) {
-		if ((wlc_hw->sih->chip == BCM4313_CHIP_ID)) {
+		if ((ai_get_chip_id(wlc_hw->sih) == BCM4313_CHIP_ID)) {
 			OR_REG(&regs->clk_ctl_st,
 			       (CCS_ERSRC_REQ_HT | CCS_ERSRC_REQ_D11PLL |
 				CCS_ERSRC_REQ_PHYPLL));
@@ -4530,8 +4530,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	wlc_hw->boardrev = (u16) j;
 	if (!brcms_c_validboardtype(wlc_hw)) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported Broadcom "
-			"board type (0x%x)" " or revision level (0x%x)\n",
-			 unit, wlc_hw->sih->boardtype, wlc_hw->boardrev);
+			  "board type (0x%x)" " or revision level (0x%x)\n",
+			  unit, ai_get_boardtype(wlc_hw->sih),
+			  wlc_hw->boardrev);
 		err = 15;
 		goto fail;
 	}
@@ -4552,7 +4553,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	else
 		wlc_hw->_nbands = 1;
 
-	if ((wlc_hw->sih->chip == BCM43225_CHIP_ID))
+	if ((ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
 		wlc_hw->_nbands = 1;
 
 	/* BMAC_NOTE: remove init of pub values when brcms_c_attach()
@@ -4584,16 +4585,14 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	sha_params.corerev = wlc_hw->corerev;
 	sha_params.vid = wlc_hw->vendorid;
 	sha_params.did = wlc_hw->deviceid;
-	sha_params.chip = wlc_hw->sih->chip;
-	sha_params.chiprev = wlc_hw->sih->chiprev;
-	sha_params.chippkg = wlc_hw->sih->chippkg;
+	sha_params.chip = ai_get_chip_id(wlc_hw->sih);
+	sha_params.chiprev = ai_get_chiprev(wlc_hw->sih);
+	sha_params.chippkg = ai_get_chippkg(wlc_hw->sih);
 	sha_params.sromrev = wlc_hw->sromrev;
-	sha_params.boardtype = wlc_hw->sih->boardtype;
+	sha_params.boardtype = ai_get_boardtype(wlc_hw->sih);
 	sha_params.boardrev = wlc_hw->boardrev;
-	sha_params.boardvendor = wlc_hw->sih->boardvendor;
 	sha_params.boardflags = wlc_hw->boardflags;
 	sha_params.boardflags2 = wlc_hw->boardflags2;
-	sha_params.buscorerev = wlc_hw->sih->buscorerev;
 
 	/* alloc and save pointer to shared phy state area */
 	wlc_hw->phy_sh = wlc_phy_shared_attach(&sha_params);
@@ -4734,10 +4733,9 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 		goto fail;
 	}
 
-	BCMMSG(wlc->wiphy,
-		 "deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
-		 wlc_hw->deviceid, wlc_hw->_nbands,
-		 wlc_hw->sih->boardtype, macaddr);
+	BCMMSG(wlc->wiphy, "deviceid 0x%x nbands %d board 0x%x macaddr: %s\n",
+	       wlc_hw->deviceid, wlc_hw->_nbands, ai_get_boardtype(wlc_hw->sih),
+	       macaddr);
 
 	return err;
 
@@ -5073,8 +5071,8 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	 * AI chip doesn't restore bar0win2 on
 	 * hibernation/resume, need sw fixup
 	 */
-	if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
-	    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
+	if ((ai_get_chip_id(wlc_hw->sih) == BCM43224_CHIP_ID) ||
+	    (ai_get_chip_id(wlc_hw->sih) == BCM43225_CHIP_ID))
 		wlc_hw->regs = (struct d11regs __iomem *)
 				ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 
@@ -5088,7 +5086,7 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	wlc_hw->wlc->pub->hw_up = true;
 
 	if ((wlc_hw->boardflags & BFL_FEM)
-	    && (wlc_hw->sih->chip == BCM4313_CHIP_ID)) {
+	    && (ai_get_chip_id(wlc_hw->sih) == BCM4313_CHIP_ID)) {
 		if (!
 		    (wlc_hw->boardrev >= 0x1250
 		     && (wlc_hw->boardflags & BFL_FEM_BT)))
@@ -5183,7 +5181,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	}
 
 	if ((wlc->pub->boardflags & BFL_FEM)
-	    && (wlc->pub->sih->chip == BCM4313_CHIP_ID)) {
+	    && (ai_get_chip_id(wlc->hw->sih) == BCM4313_CHIP_ID)) {
 		if (wlc->pub->boardrev >= 0x1250
 		    && (wlc->pub->boardflags & BFL_FEM_BT))
 			brcms_b_mhf(wlc->hw, MHF5, MHF5_4313_GPIOCTRL,
@@ -8210,11 +8208,11 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 
 	if (macintstatus & MI_GP0) {
 		wiphy_err(wiphy, "wl%d: PSM microcode watchdog fired at %d "
-			"(seconds). Resetting.\n", wlc_hw->unit, wlc_hw->now);
+			  "(seconds). Resetting.\n", wlc_hw->unit, wlc_hw->now);
 
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
-					__func__, wlc_hw->sih->chip,
-					wlc_hw->sih->chiprev);
+			    __func__, ai_get_chip_id(wlc_hw->sih),
+			    ai_get_chiprev(wlc_hw->sih));
 		brcms_fatal_error(wlc_hw->wlc->wl);
 	}
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 0bcb267..2e8b5a1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -224,9 +224,9 @@ struct pcicore_info {
 };
 
 #define PCIE_ASPM(sih)							\
-	(((sih)->buscoretype == PCIE_CORE_ID) &&			\
-	 (((sih)->buscorerev >= 3) &&					\
-	  ((sih)->buscorerev <= 5)))
+	((ai_get_buscoretype(sih) == PCIE_CORE_ID) &&			\
+	 ((ai_get_buscorerev(sih) >= 3) &&				\
+	  (ai_get_buscorerev(sih) <= 5)))
 
 
 /* delay needed between the mdio control/ mdiodata register data access */
@@ -251,7 +251,7 @@ struct pcicore_info *pcicore_init(struct si_pub *sih, struct pci_dev *pdev,
 	pi->sih = sih;
 	pi->dev = pdev;
 
-	if (sih->buscoretype == PCIE_CORE_ID) {
+	if (ai_get_buscoretype(sih) == PCIE_CORE_ID) {
 		u8 cap_ptr;
 		pi->regs.pcieregs = regs;
 		cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
@@ -504,7 +504,8 @@ static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 	struct si_pub *sih = pi->sih;
 	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 
-	if (sih->buscoretype != PCIE_CORE_ID || sih->buscorerev < 7)
+	if (ai_get_buscoretype(sih) != PCIE_CORE_ID ||
+	    ai_get_buscorerev(sih) < 7)
 		return;
 
 	w = pcie_readreg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
@@ -527,7 +528,8 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 			pcie_clkreq(pi, 1, 0);
 		break;
 	case SI_PCIDOWN:
-		if (sih->buscorerev == 6) {	/* turn on serdes PLL down */
+		/* turn on serdes PLL down */
+		if (ai_get_buscorerev(sih) == 6) {
 			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(struct chipcregs, chipcontrol_addr),
 				   ~0, 0);
@@ -539,7 +541,8 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 		}
 		break;
 	case SI_PCIUP:
-		if (sih->buscorerev == 6) {	/* turn off serdes PLL down */
+		/* turn off serdes PLL down */
+		if (ai_get_buscorerev(sih) == 6) {
 			ai_corereg(sih, SI_CC_IDX,
 				   offsetof(struct chipcregs, chipcontrol_addr),
 				   ~0, 0);
@@ -678,7 +681,7 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	u32 w;
 
-	if (sih->buscorerev == 0 || sih->buscorerev == 1) {
+	if (ai_get_buscorerev(sih) == 0 || ai_get_buscorerev(sih) == 1) {
 		w = pcie_readreg(pcieregs, PCIE_PCIEREGS,
 				 PCIE_TLP_WORKAROUNDSREG);
 		w |= 0x8;
@@ -686,13 +689,13 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 			      PCIE_TLP_WORKAROUNDSREG, w);
 	}
 
-	if (sih->buscorerev == 1) {
+	if (ai_get_buscorerev(sih) == 1) {
 		w = pcie_readreg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_LCREG);
 		w |= 0x40;
 		pcie_writereg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_LCREG, w);
 	}
 
-	if (sih->buscorerev == 0) {
+	if (ai_get_buscorerev(sih) == 0) {
 		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_TIMER1, 0x8128);
 		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_CDR, 0x0100);
 		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_CDRBW, 0x1466);
@@ -708,13 +711,13 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 		pcie_war_serdes(pi);
 
 		pcie_war_aspm_clkreq(pi);
-	} else if (pi->sih->buscorerev == 7)
+	} else if (ai_get_buscorerev(pi->sih) == 7)
 		pcie_war_noplldown(pi);
 
 	/* Note that the fix is actually in the SROM,
 	 * that's why this is open-ended
 	 */
-	if (pi->sih->buscorerev >= 6)
+	if (ai_get_buscorerev(pi->sih) >= 6)
 		pcie_misc_config_fixup(pi);
 }
 
@@ -745,7 +748,7 @@ void pcicore_attach(struct pcicore_info *pi, int state)
 
 void pcicore_hwup(struct pcicore_info *pi)
 {
-	if (!pi || pi->sih->buscoretype != PCIE_CORE_ID)
+	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
 		return;
 
 	pcie_war_pci_setup(pi);
@@ -753,7 +756,7 @@ void pcicore_hwup(struct pcicore_info *pi)
 
 void pcicore_up(struct pcicore_info *pi, int state)
 {
-	if (!pi || pi->sih->buscoretype != PCIE_CORE_ID)
+	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
 		return;
 
 	/* Restore L1 timer for better performance */
@@ -781,7 +784,7 @@ void pcicore_sleep(struct pcicore_info *pi)
 
 void pcicore_down(struct pcicore_info *pi, int state)
 {
-	if (!pi || pi->sih->buscoretype != PCIE_CORE_ID)
+	if (!pi || ai_get_buscoretype(pi->sih) != PCIE_CORE_ID)
 		return;
 
 	pcie_clkreq_upd(pi, state);
@@ -826,7 +829,7 @@ pcicore_pci_setup(struct pcicore_info *pi, struct sbpciregs __iomem *pciregs)
 
 	OR_REG(&pciregs->sbtopci2, SBTOPCI_PREF | SBTOPCI_BURST);
 
-	if (((struct si_info *)(pi->sih))->pub.buscorerev >= 11) {
+	if (ai_get_buscorerev(pi->sih) >= 11) {
 		OR_REG(&pciregs->sbtopci2, SBTOPCI_RC_READMULTI);
 		w = R_REG(&pciregs->clkrun);
 		W_REG(&pciregs->clkrun, w | PCI_CLKRUN_DSBL);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/otp.c b/drivers/net/wireless/brcm80211/brcmsmac/otp.c
index edf5515..612434e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/otp.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/otp.c
@@ -146,7 +146,7 @@ static int ipxotp_max_rgnsz(struct si_pub *sih, int osizew)
 {
 	int ret = 0;
 
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 		ret = osizew * 2 - OTP_SZ_FU_72 - OTP_SZ_CHECKSUM;
@@ -170,10 +170,10 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 	 * record word offset of General Use Region
 	 * for various chipcommon revs
 	 */
-	if (oi->sih->ccrev == 21 || oi->sih->ccrev == 24
-	    || oi->sih->ccrev == 27) {
+	if (oi->ccrev == 21 || oi->ccrev == 24
+	    || oi->ccrev == 27) {
 		oi->otpgu_base = REVA4_OTPGU_BASE;
-	} else if (oi->sih->ccrev == 36) {
+	} else if (oi->ccrev == 36) {
 		/*
 		 * OTP size greater than equal to 2KB (128 words),
 		 * otpgu_base is similar to rev23
@@ -182,7 +182,7 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 			oi->otpgu_base = REVB8_OTPGU_BASE;
 		else
 			oi->otpgu_base = REV36_OTPGU_BASE;
-	} else if (oi->sih->ccrev == 23 || oi->sih->ccrev >= 25) {
+	} else if (oi->ccrev == 23 || oi->ccrev >= 25) {
 		oi->otpgu_base = REVB8_OTPGU_BASE;
 	}
 
@@ -201,8 +201,8 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 	/* Read OTP lock bits and subregion programmed indication bits */
 	oi->status = R_REG(&cc->otpstatus);
 
-	if ((oi->sih->chip == BCM43224_CHIP_ID)
-	    || (oi->sih->chip == BCM43225_CHIP_ID)) {
+	if ((ai_get_chip_id(oi->sih) == BCM43224_CHIP_ID)
+	    || (ai_get_chip_id(oi->sih) == BCM43225_CHIP_ID)) {
 		u32 p_bits;
 		p_bits =
 		    (ipxotp_otpr(oi, cc, oi->otpgu_base + OTPGU_P_OFF) &
@@ -244,7 +244,7 @@ static int ipxotp_init(struct si_pub *sih, struct otpinfo *oi)
 	struct chipcregs __iomem *cc;
 
 	/* Make sure we're running IPX OTP */
-	if (!OTPTYPE_IPX(sih->ccrev))
+	if (!OTPTYPE_IPX(oi->ccrev))
 		return -EBADE;
 
 	/* Make sure OTP is not disabled */
@@ -252,7 +252,7 @@ static int ipxotp_init(struct si_pub *sih, struct otpinfo *oi)
 		return -EBADE;
 
 	/* Check for otp size */
-	switch ((sih->cccaps & CC_CAP_OTPSIZE) >> CC_CAP_OTPSIZE_SHIFT) {
+	switch ((ai_get_cccaps(sih) & CC_CAP_OTPSIZE) >> CC_CAP_OTPSIZE_SHIFT) {
 	case 0:
 		/* Nothing there */
 		return -EBADE;
@@ -389,7 +389,7 @@ static int otp_init(struct si_pub *sih, struct otpinfo *oi)
 
 	memset(oi, 0, sizeof(struct otpinfo));
 
-	oi->ccrev = sih->ccrev;
+	oi->ccrev = ai_get_ccrev(sih);
 
 	if (OTPTYPE_IPX(oi->ccrev))
 		oi->fn = &ipxotp_fn;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index 008aab9..30cc558 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -404,10 +404,8 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 	sh->sromrev = shp->sromrev;
 	sh->boardtype = shp->boardtype;
 	sh->boardrev = shp->boardrev;
-	sh->boardvendor = shp->boardvendor;
 	sh->boardflags = shp->boardflags;
 	sh->boardflags2 = shp->boardflags2;
-	sh->buscorerev = shp->buscorerev;
 
 	sh->fast_timer = PHY_SW_TIMER_FAST;
 	sh->slow_timer = PHY_SW_TIMER_SLOW;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h
index 96e1516..5549c7b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_hal.h
@@ -166,7 +166,6 @@ struct shared_phy_params {
 	struct phy_shim_info *physhim;
 	uint unit;
 	uint corerev;
-	uint buscorerev;
 	u16 vid;
 	u16 did;
 	uint chip;
@@ -175,7 +174,6 @@ struct shared_phy_params {
 	uint sromrev;
 	uint boardtype;
 	uint boardrev;
-	uint boardvendor;
 	u32 boardflags;
 	u32 boardflags2;
 };
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
index 5f9478b..02e6407 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_int.h
@@ -503,10 +503,8 @@ struct shared_phy {
 	uint sromrev;
 	uint boardtype;
 	uint boardrev;
-	uint boardvendor;
 	u32 boardflags;
 	u32 boardflags2;
-	uint buscorerev;
 	uint fast_timer;
 	uint slow_timer;
 	uint glacial_timer;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 12ba575..d4e909a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -115,10 +115,10 @@ static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 	uint rsrcs;
 
 	/* # resources */
-	rsrcs = (sih->pmucaps & PCAP_RC_MASK) >> PCAP_RC_SHIFT;
+	rsrcs = (ai_get_pmucaps(sih) & PCAP_RC_MASK) >> PCAP_RC_SHIFT;
 
 	/* determine min/max rsrc masks */
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 		/* ??? */
@@ -145,7 +145,7 @@ si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct chipcregs __iomem *cc,
 {
 	u32 tmp = 0;
 
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 		if (spuravoid == 1) {
@@ -207,7 +207,7 @@ u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 {
 	uint delay = PMU_MAX_TRANSITION_DLY;
 
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 	case BCM4313_CHIP_ID:
@@ -276,10 +276,10 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 	u32 clock = ALP_CLOCK;
 
 	/* bail out with default */
-	if (!(sih->cccaps & CC_CAP_PMU))
+	if (!(ai_get_cccaps(sih) & CC_CAP_PMU))
 		return clock;
 
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
 	case BCM4313_CHIP_ID:
@@ -319,9 +319,9 @@ void si_pmu_init(struct si_pub *sih)
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
-	if (sih->pmurev == 1)
+	if (ai_get_pmurev(sih) == 1)
 		AND_REG(&cc->pmucontrol, ~PCTL_NOILP_ON_WAIT);
-	else if (sih->pmurev >= 2)
+	else if (ai_get_pmurev(sih) >= 2)
 		OR_REG(&cc->pmucontrol, PCTL_NOILP_ON_WAIT);
 
 	/* Return to original core */
@@ -358,7 +358,7 @@ void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
 	origidx = ai_coreidx(sih);
 	cc = ai_setcoreidx(sih, SI_CC_IDX);
 
-	switch (sih->chip) {
+	switch (ai_get_chip_id(sih)) {
 	case BCM4313_CHIP_ID:
 	case BCM43224_CHIP_ID:
 	case BCM43225_CHIP_ID:
@@ -411,7 +411,7 @@ u32 si_pmu_measure_alpclk(struct si_pub *sih)
 	uint origidx;
 	u32 alp_khz;
 
-	if (sih->pmurev < 10)
+	if (ai_get_pmurev(sih) < 10)
 		return 0;
 
 	/* Remember original core before switch to chipc */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/srom.c b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
index b6987ea..95eb620 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/srom.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/srom.c
@@ -589,9 +589,9 @@ static u8 brcms_srom_crc8_table[CRC8_TABLE_SIZE];
 static u8 __iomem *
 srom_window_address(struct si_pub *sih, u8 __iomem *curmap)
 {
-	if (sih->ccrev < 32)
+	if (ai_get_ccrev(sih) < 32)
 		return curmap + PCI_BAR0_SPROM_OFFSET;
-	if (sih->cccaps & CC_CAP_SROM)
+	if (ai_get_cccaps(sih) & CC_CAP_SROM)
 		return curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP;
 
 	return NULL;
-- 
1.7.5.4


