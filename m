Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2132 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752426Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 23/23] brcm80211: smac: use bcma core access functions
 in nicpci.c
Date: Thu, 8 Dec 2011 15:06:59 -0800
Message-ID: <1323385619-7454-24-git-send-email-frankyl@broadcom.com> (sfid-20111209_000738_946364_E46DB1D2)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Code in nicpci.c now uses the PCI(E) core as provided by the BCMA
bus driver to configure that core.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   11 +-
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |  179 ++++++++++-----------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h  |   11 +-
 3 files changed, 90 insertions(+), 111 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index a68f24a..8d3829a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -633,8 +633,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 
 	/* fixup necessary chip/core configurations */
 	if (!sii->pch) {
-		sii->pch = pcicore_init(&sii->pub, sii->pcibus,
-					sii->curmap + PCI_16KB0_PCIREGS_OFFSET);
+		sii->pch = pcicore_init(&sii->pub, sii->icbus->drv_pci.core);
 		if (sii->pch == NULL)
 			return false;
 	}
@@ -1385,7 +1384,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 	}
 
 	if (PCI(sih)) {
-		pcicore_pci_setup(sii->pch, regs);
+		pcicore_pci_setup(sii->pch);
 
 		/* switch back to previous core */
 		ai_setcoreidx(sih, idx);
@@ -1408,11 +1407,7 @@ int ai_pci_fixcfg(struct si_pub *sih)
 
 	/* check 'pi' is correct and fix it if not */
 	regs = ai_setcore(&sii->pub, ai_get_buscoretype(sih), 0);
-	if (ai_get_buscoretype(sih) == PCIE_CORE_ID)
-		pcicore_fixcfg_pcie(sii->pch,
-				    (struct sbpcieregs __iomem *)regs);
-	else if (ai_get_buscoretype(sih) == PCI_CORE_ID)
-		pcicore_fixcfg_pci(sii->pch, (struct sbpciregs __iomem *)regs);
+	pcicore_fixcfg(sii->pch);
 
 	/* restore the original index */
 	ai_setcoreidx(&sii->pub, origidx);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 6c3a9f9..a433041 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -139,6 +139,9 @@
 #define SRSH_PI_MASK	0xf000	/* bit 15:12 */
 #define SRSH_PI_SHIFT	12	/* bit 15:12 */
 
+#define PCIREGOFFS(field)	offsetof(struct sbpciregs, field)
+#define PCIEREGOFFS(field)	offsetof(struct sbpcieregs, field)
+
 /* Sonics side: PCI core and host control registers */
 struct sbpciregs {
 	u32 control;		/* PCI control */
@@ -205,11 +208,7 @@ struct sbpcieregs {
 };
 
 struct pcicore_info {
-	union {
-		struct sbpcieregs __iomem *pcieregs;
-		struct sbpciregs __iomem *pciregs;
-	} regs;			/* Memory mapped register to the core */
-
+	struct bcma_device *core;
 	struct si_pub *sih;	/* System interconnect handle */
 	struct pci_dev *dev;
 	u8 pciecap_lcreg_offset;/* PCIE capability LCreg offset
@@ -238,8 +237,7 @@ static void pr28829_delay(void)
 /* Initialize the PCI core.
  * It's caller's responsibility to make sure that this is done only once
  */
-struct pcicore_info *pcicore_init(struct si_pub *sih, struct pci_dev *pdev,
-				  void __iomem *regs)
+struct pcicore_info *pcicore_init(struct si_pub *sih, struct bcma_device *core)
 {
 	struct pcicore_info *pi;
 
@@ -249,17 +247,15 @@ struct pcicore_info *pcicore_init(struct si_pub *sih, struct pci_dev *pdev,
 		return NULL;
 
 	pi->sih = sih;
-	pi->dev = pdev;
+	pi->dev = core->bus->host_pci;
+	pi->core = core;
 
-	if (ai_get_buscoretype(sih) == PCIE_CORE_ID) {
+	if (core->id.id == PCIE_CORE_ID) {
 		u8 cap_ptr;
-		pi->regs.pcieregs = regs;
 		cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
 						      NULL, NULL);
 		pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
-	} else
-		pi->regs.pciregs = regs;
-
+	}
 	return pi;
 }
 
@@ -334,37 +330,37 @@ end:
 
 /* ***** Register Access API */
 static uint
-pcie_readreg(struct sbpcieregs __iomem *pcieregs, uint addrtype, uint offset)
+pcie_readreg(struct bcma_device *core, uint addrtype, uint offset)
 {
 	uint retval = 0xFFFFFFFF;
 
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
-		W_REG(&pcieregs->configaddr, offset);
-		(void)R_REG((&pcieregs->configaddr));
-		retval = R_REG(&pcieregs->configdata);
+		bcma_write32(core, PCIEREGOFFS(configaddr), offset);
+		(void)bcma_read32(core, PCIEREGOFFS(configaddr));
+		retval = bcma_read32(core, PCIEREGOFFS(configdata));
 		break;
 	case PCIE_PCIEREGS:
-		W_REG(&pcieregs->pcieindaddr, offset);
-		(void)R_REG(&pcieregs->pcieindaddr);
-		retval = R_REG(&pcieregs->pcieinddata);
+		bcma_write32(core, PCIEREGOFFS(pcieindaddr), offset);
+		(void)bcma_read32(core, PCIEREGOFFS(pcieindaddr));
+		retval = bcma_read32(core, PCIEREGOFFS(pcieinddata));
 		break;
 	}
 
 	return retval;
 }
 
-static uint pcie_writereg(struct sbpcieregs __iomem *pcieregs, uint addrtype,
+static uint pcie_writereg(struct bcma_device *core, uint addrtype,
 			  uint offset, uint val)
 {
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
-		W_REG((&pcieregs->configaddr), offset);
-		W_REG((&pcieregs->configdata), val);
+		bcma_write32(core, PCIEREGOFFS(configaddr), offset);
+		bcma_write32(core, PCIEREGOFFS(configdata), val);
 		break;
 	case PCIE_PCIEREGS:
-		W_REG((&pcieregs->pcieindaddr), offset);
-		W_REG((&pcieregs->pcieinddata), val);
+		bcma_write32(core, PCIEREGOFFS(pcieindaddr), offset);
+		bcma_write32(core, PCIEREGOFFS(pcieinddata), val);
 		break;
 	default:
 		break;
@@ -374,7 +370,6 @@ static uint pcie_writereg(struct sbpcieregs __iomem *pcieregs, uint addrtype,
 
 static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 {
-	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	uint mdiodata, i = 0;
 	uint pcie_serdes_spinwait = 200;
 
@@ -382,12 +377,13 @@ static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 		    (MDIODATA_DEV_ADDR << MDIODATA_DEVADDR_SHF) |
 		    (MDIODATA_BLK_ADDR << MDIODATA_REGADDR_SHF) |
 		    (blk << 4));
-	W_REG(&pcieregs->mdiodata, mdiodata);
+	bcma_write32(pi->core, PCIEREGOFFS(mdiodata), mdiodata);
 
 	pr28829_delay();
 	/* retry till the transaction is complete */
 	while (i < pcie_serdes_spinwait) {
-		if (R_REG(&pcieregs->mdiocontrol) & MDIOCTL_ACCESS_DONE)
+		if (bcma_read32(pi->core, PCIEREGOFFS(mdiocontrol)) &
+		    MDIOCTL_ACCESS_DONE)
 			break;
 
 		udelay(1000);
@@ -404,13 +400,13 @@ static int
 pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 	    uint *val)
 {
-	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	uint mdiodata;
 	uint i = 0;
 	uint pcie_serdes_spinwait = 10;
 
 	/* enable mdio access to SERDES */
-	W_REG(&pcieregs->mdiocontrol, MDIOCTL_PREAM_EN | MDIOCTL_DIVISOR_VAL);
+	bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol),
+		     MDIOCTL_PREAM_EN | MDIOCTL_DIVISOR_VAL);
 
 	if (pi->sih->buscorerev >= 10) {
 		/* new serdes is slower in rw,
@@ -432,20 +428,22 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 		mdiodata |= (MDIODATA_START | MDIODATA_WRITE | MDIODATA_TA |
 			     *val);
 
-	W_REG(&pcieregs->mdiodata, mdiodata);
+	bcma_write32(pi->core, PCIEREGOFFS(mdiodata), mdiodata);
 
 	pr28829_delay();
 
 	/* retry till the transaction is complete */
 	while (i < pcie_serdes_spinwait) {
-		if (R_REG(&pcieregs->mdiocontrol) & MDIOCTL_ACCESS_DONE) {
+		if (bcma_read32(pi->core, PCIEREGOFFS(mdiocontrol)) &
+		    MDIOCTL_ACCESS_DONE) {
 			if (!write) {
 				pr28829_delay();
-				*val = (R_REG(&pcieregs->mdiodata) &
+				*val = (bcma_read32(pi->core,
+						    PCIEREGOFFS(mdiodata)) &
 					MDIODATA_MASK);
 			}
 			/* Disable mdio access to SERDES */
-			W_REG(&pcieregs->mdiocontrol, 0);
+			bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol), 0);
 			return 0;
 		}
 		udelay(1000);
@@ -453,7 +451,7 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 	}
 
 	/* Timed out. Disable mdio access to SERDES. */
-	W_REG(&pcieregs->mdiocontrol, 0);
+	bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol), 0);
 	return 1;
 }
 
@@ -502,19 +500,18 @@ static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 {
 	u32 w;
 	struct si_pub *sih = pi->sih;
-	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 
 	if (ai_get_buscoretype(sih) != PCIE_CORE_ID ||
 	    ai_get_buscorerev(sih) < 7)
 		return;
 
-	w = pcie_readreg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
+	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
 	if (extend)
 		w |= PCIE_ASPMTIMER_EXTEND;
 	else
 		w &= ~PCIE_ASPMTIMER_EXTEND;
-	pcie_writereg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG, w);
-	w = pcie_readreg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
+	pcie_writereg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG, w);
+	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_PMTHRESHREG);
 }
 
 /* centralized clkreq control policy */
@@ -565,7 +562,7 @@ static void pcie_war_polarity(struct pcicore_info *pi)
 	if (pi->pcie_polarity != 0)
 		return;
 
-	w = pcie_readreg(pi->regs.pcieregs, PCIE_PCIEREGS, PCIE_PLP_STATUSREG);
+	w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_PLP_STATUSREG);
 
 	/* Detect the current polarity at attach and force that polarity and
 	 * disable changing the polarity
@@ -584,18 +581,15 @@ static void pcie_war_polarity(struct pcicore_info *pi)
  */
 static void pcie_war_aspm_clkreq(struct pcicore_info *pi)
 {
-	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	struct si_pub *sih = pi->sih;
 	u16 val16;
-	u16 __iomem *reg16;
 	u32 w;
 
 	if (!PCIE_ASPM(sih))
 		return;
 
 	/* bypass this on QT or VSIM */
-	reg16 = &pcieregs->sprom[SRSH_ASPM_OFFSET];
-	val16 = R_REG(reg16);
+	val16 = bcma_read16(pi->core, PCIEREGOFFS(sprom[SRSH_ASPM_OFFSET]));
 
 	val16 &= ~SRSH_ASPM_ENB;
 	if (pi->pcie_war_aspm_ovr == PCIE_ASPM_ENAB)
@@ -605,15 +599,15 @@ static void pcie_war_aspm_clkreq(struct pcicore_info *pi)
 	else if (pi->pcie_war_aspm_ovr == PCIE_ASPM_L0s_ENAB)
 		val16 |= SRSH_ASPM_L0s_ENB;
 
-	W_REG(reg16, val16);
+	bcma_write16(pi->core, PCIEREGOFFS(sprom[SRSH_ASPM_OFFSET]), val16);
 
 	pci_read_config_dword(pi->dev, pi->pciecap_lcreg_offset, &w);
 	w &= ~PCIE_ASPM_ENAB;
 	w |= pi->pcie_war_aspm_ovr;
 	pci_write_config_dword(pi->dev, pi->pciecap_lcreg_offset, w);
 
-	reg16 = &pcieregs->sprom[SRSH_CLKREQ_OFFSET_REV5];
-	val16 = R_REG(reg16);
+	val16 = bcma_read16(pi->core,
+			    PCIEREGOFFS(sprom[SRSH_CLKREQ_OFFSET_REV5]));
 
 	if (pi->pcie_war_aspm_ovr != PCIE_ASPM_DISAB) {
 		val16 |= SRSH_CLKREQ_ENB;
@@ -621,7 +615,8 @@ static void pcie_war_aspm_clkreq(struct pcicore_info *pi)
 	} else
 		val16 &= ~SRSH_CLKREQ_ENB;
 
-	W_REG(reg16, val16);
+	bcma_write16(pi->core, PCIEREGOFFS(sprom[SRSH_CLKREQ_OFFSET_REV5]),
+		     val16);
 }
 
 /* Apply the polarity determined at the start */
@@ -645,16 +640,15 @@ static void pcie_war_serdes(struct pcicore_info *pi)
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_misc_config_fixup(struct pcicore_info *pi)
 {
-	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	u16 val16;
-	u16 __iomem *reg16;
 
-	reg16 = &pcieregs->sprom[SRSH_PCIE_MISC_CONFIG];
-	val16 = R_REG(reg16);
+	val16 = bcma_read16(pi->core,
+			    PCIEREGOFFS(sprom[SRSH_PCIE_MISC_CONFIG]));
 
 	if ((val16 & SRSH_L23READY_EXIT_NOPERST) == 0) {
 		val16 |= SRSH_L23READY_EXIT_NOPERST;
-		W_REG(reg16, val16);
+		bcma_write16(pi->core,
+			     PCIEREGOFFS(sprom[SRSH_PCIE_MISC_CONFIG]), val16);
 	}
 }
 
@@ -662,37 +656,32 @@ static void pcie_misc_config_fixup(struct pcicore_info *pi)
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_war_noplldown(struct pcicore_info *pi)
 {
-	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
-	u16 __iomem *reg16;
-
 	/* turn off serdes PLL down */
 	ai_cc_reg(pi->sih, offsetof(struct chipcregs, chipcontrol),
 		  CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
 
 	/* clear srom shadow backdoor */
-	reg16 = &pcieregs->sprom[SRSH_BD_OFFSET];
-	W_REG(reg16, 0);
+	bcma_write16(pi->core, PCIEREGOFFS(sprom[SRSH_BD_OFFSET]), 0);
 }
 
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_war_pci_setup(struct pcicore_info *pi)
 {
 	struct si_pub *sih = pi->sih;
-	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	u32 w;
 
 	if (ai_get_buscorerev(sih) == 0 || ai_get_buscorerev(sih) == 1) {
-		w = pcie_readreg(pcieregs, PCIE_PCIEREGS,
+		w = pcie_readreg(pi->core, PCIE_PCIEREGS,
 				 PCIE_TLP_WORKAROUNDSREG);
 		w |= 0x8;
-		pcie_writereg(pcieregs, PCIE_PCIEREGS,
+		pcie_writereg(pi->core, PCIE_PCIEREGS,
 			      PCIE_TLP_WORKAROUNDSREG, w);
 	}
 
 	if (ai_get_buscorerev(sih) == 1) {
-		w = pcie_readreg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_LCREG);
+		w = pcie_readreg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_LCREG);
 		w |= 0x40;
-		pcie_writereg(pcieregs, PCIE_PCIEREGS, PCIE_DLLP_LCREG, w);
+		pcie_writereg(pi->core, PCIE_PCIEREGS, PCIE_DLLP_LCREG, w);
 	}
 
 	if (ai_get_buscorerev(sih) == 0) {
@@ -701,11 +690,11 @@ static void pcie_war_pci_setup(struct pcicore_info *pi)
 		pcie_mdiowrite(pi, MDIODATA_DEV_RX, SERDES_RX_CDRBW, 0x1466);
 	} else if (PCIE_ASPM(sih)) {
 		/* Change the L1 threshold for better performance */
-		w = pcie_readreg(pcieregs, PCIE_PCIEREGS,
+		w = pcie_readreg(pi->core, PCIE_PCIEREGS,
 				 PCIE_DLLP_PMTHRESHREG);
 		w &= ~PCIE_L1THRESHOLDTIME_MASK;
 		w |= PCIE_L1THRESHOLD_WARVAL << PCIE_L1THRESHOLDTIME_SHIFT;
-		pcie_writereg(pcieregs, PCIE_PCIEREGS,
+		pcie_writereg(pi->core, PCIE_PCIEREGS,
 			      PCIE_DLLP_PMTHRESHREG, w);
 
 		pcie_war_serdes(pi);
@@ -794,45 +783,45 @@ void pcicore_down(struct pcicore_info *pi, int state)
 }
 
 /* precondition: current core is sii->buscoretype */
-static void pcicore_fixcfg(struct pcicore_info *pi, u16 __iomem *reg16)
+void pcicore_fixcfg(struct pcicore_info *pi)
 {
-	struct si_info *sii = (struct si_info *)(pi->sih);
+	struct bcma_device *core = pi->core;
 	u16 val16;
-	uint pciidx;
+	uint regoff;
 
-	pciidx = ai_coreidx(&sii->pub);
-	val16 = R_REG(reg16);
-	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16)pciidx) {
-		val16 = (u16)(pciidx << SRSH_PI_SHIFT) |
-			(val16 & ~SRSH_PI_MASK);
-		W_REG(reg16, val16);
-	}
-}
+	switch (pi->core->id.id) {
+	case BCMA_CORE_PCI:
+		regoff = PCIREGOFFS(sprom[SRSH_PI_OFFSET]);
+		break;
 
-void
-pcicore_fixcfg_pci(struct pcicore_info *pi, struct sbpciregs __iomem *pciregs)
-{
-	pcicore_fixcfg(pi, &pciregs->sprom[SRSH_PI_OFFSET]);
-}
+	case BCMA_CORE_PCIE:
+		regoff = PCIEREGOFFS(sprom[SRSH_PI_OFFSET]);
+		break;
 
-void pcicore_fixcfg_pcie(struct pcicore_info *pi,
-			 struct sbpcieregs __iomem *pcieregs)
-{
-	pcicore_fixcfg(pi, &pcieregs->sprom[SRSH_PI_OFFSET]);
+	default:
+		return;
+	}
+
+	val16 = bcma_read16(pi->core, regoff);
+	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) !=
+	    (u16)core->core_index) {
+		val16 = ((u16)core->core_index << SRSH_PI_SHIFT) |
+			(val16 & ~SRSH_PI_MASK);
+		bcma_write16(pi->core, regoff, val16);
+	}
 }
 
 /* precondition: current core is pci core */
 void
-pcicore_pci_setup(struct pcicore_info *pi, struct sbpciregs __iomem *pciregs)
+pcicore_pci_setup(struct pcicore_info *pi)
 {
-	u32 w;
-
-	OR_REG(&pciregs->sbtopci2, SBTOPCI_PREF | SBTOPCI_BURST);
-
-	if (ai_get_buscorerev(pi->sih) >= 11) {
-		OR_REG(&pciregs->sbtopci2, SBTOPCI_RC_READMULTI);
-		w = R_REG(&pciregs->clkrun);
-		W_REG(&pciregs->clkrun, w | PCI_CLKRUN_DSBL);
-		w = R_REG(&pciregs->clkrun);
+	bcma_set32(pi->core, PCIREGOFFS(sbtopci2),
+		   SBTOPCI_PREF | SBTOPCI_BURST);
+
+	if (pi->core->id.rev >= 11) {
+		bcma_set32(pi->core, PCIREGOFFS(sbtopci2),
+			   SBTOPCI_RC_READMULTI);
+		bcma_set32(pi->core, PCIREGOFFS(clkrun), PCI_CLKRUN_DSBL);
+		(void)bcma_read32(pi->core, PCIREGOFFS(clkrun));
 	}
 }
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
index 58aa80d..9fc3ead 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
@@ -62,8 +62,7 @@ struct sbpciregs;
 struct sbpcieregs;
 
 extern struct pcicore_info *pcicore_init(struct si_pub *sih,
-					 struct pci_dev *pdev,
-					 void __iomem *regs);
+					 struct bcma_device *core);
 extern void pcicore_deinit(struct pcicore_info *pch);
 extern void pcicore_attach(struct pcicore_info *pch, int state);
 extern void pcicore_hwup(struct pcicore_info *pch);
@@ -72,11 +71,7 @@ extern void pcicore_sleep(struct pcicore_info *pch);
 extern void pcicore_down(struct pcicore_info *pch, int state);
 extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
 				      unsigned char *buf, u32 *buflen);
-extern void pcicore_fixcfg_pci(struct pcicore_info *pch,
-			       struct sbpciregs __iomem *pciregs);
-extern void pcicore_fixcfg_pcie(struct pcicore_info *pch,
-				struct sbpcieregs __iomem *pciregs);
-extern void pcicore_pci_setup(struct pcicore_info *pch,
-			      struct sbpciregs __iomem *pciregs);
+extern void pcicore_fixcfg(struct pcicore_info *pch);
+extern void pcicore_pci_setup(struct pcicore_info *pch);
 
 #endif /* _BRCM_NICPCI_H_ */
-- 
1.7.5.4


