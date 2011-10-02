Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1725 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753695Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 04/20] staging: brcm80211: various __iomem additions to
 softmac.
Date: Sun, 2 Oct 2011 10:14:29 -0700
Message-ID: <1317575685-3156-5-git-send-email-frankyl@broadcom.com> (sfid-20111002_191536_588932_25579CD5)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

So it is clear to the reader what memory is IO mapped

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |  107 ++++++++++++++------------
 drivers/staging/brcm80211/brcmsmac/aiutils.h |   16 ++--
 drivers/staging/brcm80211/brcmsmac/main.c    |    2 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c  |   45 ++++++-----
 drivers/staging/brcm80211/brcmsmac/nicpci.h  |    9 +-
 drivers/staging/brcm80211/brcmsmac/otp.c     |    9 +-
 drivers/staging/brcm80211/brcmsmac/pmu.c     |   16 ++--
 drivers/staging/brcm80211/brcmsmac/srom.c    |   20 +++--
 drivers/staging/brcm80211/brcmsmac/srom.h    |    2 +-
 9 files changed, 123 insertions(+), 103 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 790fdce..0b3ba6a 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -323,7 +323,8 @@
 		     (((si)->pub.buscoretype == PCI_CORE_ID) && \
 		      (si)->pub.buscorerev >= 13))
 
-#define CCREGS_FAST(si) (((char *)((si)->curmap) + PCI_16KB0_CCREGS_OFFSET))
+#define CCREGS_FAST(si) (((char __iomem *)((si)->curmap) + \
+			  PCI_16KB0_CCREGS_OFFSET))
 
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
@@ -357,7 +358,8 @@
 	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
 		IS_ALIGNED((x), SI_CORE_SIZE))
 
-#define PCIEREGS(si) (((char *)((si)->curmap) + PCI_16KB0_PCIREGS_OFFSET))
+#define PCIEREGS(si) ((__iomem char *)((si)->curmap) + \
+			PCI_16KB0_PCIREGS_OFFSET)
 
 struct aidmp {
 	u32 oobselina30;	/* 0x000 */
@@ -480,7 +482,7 @@ struct aidmp {
 /* EROM parsing */
 
 static u32
-get_erom_ent(struct si_pub *sih, u32 **eromptr, u32 mask, u32 match)
+get_erom_ent(struct si_pub *sih, u32 __iomem **eromptr, u32 mask, u32 match)
 {
 	u32 ent;
 	uint inv = 0, nom = 0;
@@ -510,7 +512,7 @@ get_erom_ent(struct si_pub *sih, u32 **eromptr, u32 mask, u32 match)
 }
 
 static u32
-get_asd(struct si_pub *sih, u32 **eromptr, uint sp, uint ad, uint st,
+get_asd(struct si_pub *sih, u32 __iomem **eromptr, uint sp, uint ad, uint st,
 	u32 *addrl, u32 *addrh, u32 *sizel, u32 *sizeh)
 {
 	u32 asd, sz, szd;
@@ -546,12 +548,13 @@ static void ai_hwfixup(struct si_info *sii)
 }
 
 /* parse the enumeration rom to identify all cores */
-static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
+static void ai_scan(struct si_pub *sih, struct chipcregs __iomem *cc)
 {
 	struct si_info *sii = (struct si_info *)sih;
 
-	u32 erombase, *eromptr, *eromlim;
-	void *regs = cc;
+	u32 erombase;
+	u32 __iomem *eromptr, *eromlim;
+	void __iomem *regs = cc;
 
 	erombase = R_REG(&cc->eromptr);
 
@@ -566,7 +569,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
 	while (eromptr < eromlim) {
 		u32 cia, cib, cid, mfg, crev, nmw, nsw, nmp, nsp;
 		u32 mpd, asd, addrl, addrh, sizel, sizeh;
-		u32 *base;
+		u32 __iomem *base;
 		uint i, j, idx;
 		bool br;
 
@@ -726,7 +729,7 @@ static void ai_scan(struct si_pub *sih, struct chipcregs *cc)
  * contains the first register of this 'common' register block (not to be
  * confused with 'common core').
  */
-void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
+void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 {
 	struct si_info *sii = (struct si_info *)sih;
 	u32 addr = sii->coresba[coreidx];
@@ -914,7 +917,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	bool pci, pcie;
 	uint i;
 	uint pciidx, pcieidx, pcirev, pcierev;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 
 	cc = ai_setcoreidx(&sii->pub, SI_CC_IDX);
 
@@ -990,7 +993,7 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 	if (SI_FAST(sii)) {
 		if (!sii->pch) {
 			sii->pch = pcicore_init(&sii->pub, sii->pbus,
-						(void *)PCIEREGS(sii));
+						(__iomem void *)PCIEREGS(sii));
 			if (sii->pch == NULL)
 				return false;
 		}
@@ -1022,12 +1025,12 @@ static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
-				   void *regs, struct pci_dev *pbus,
+				   void __iomem *regs, struct pci_dev *pbus,
 				   char **vars, uint *varsz)
 {
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	char *pvars = NULL;
 	uint socitype;
 	uint origidx;
@@ -1048,7 +1051,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 
 	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN,
 			       SI_ENUM_BASE);
-	cc = (struct chipcregs *) regs;
+	cc = (struct chipcregs __iomem *) regs;
 
 	/* bus/core/clk setup for register access */
 	if (!ai_buscore_prep(sii)) {
@@ -1098,7 +1101,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_nvram_process(sii, pvars);
 
 	/* === NVRAM, clock is ready === */
-	cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
+	cc = (struct chipcregs __iomem *) ai_setcore(sih, CC_CORE_ID, 0);
 	W_REG(&cc->gpiopullup, 0);
 	W_REG(&cc->gpiopulldown, 0);
 	ai_setcoreidx(sih, origidx);
@@ -1177,7 +1180,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
  * varsz - pointer to int to return the size of the vars
  */
 struct si_pub *
-ai_attach(void *regs, struct pci_dev *sdh, char **vars, uint *varsz)
+ai_attach(void __iomem *regs, struct pci_dev *sdh, char **vars, uint *varsz)
 {
 	struct si_info *sii;
 
@@ -1291,7 +1294,7 @@ uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
  * Moreover, callers should keep interrupts off during switching
  * out of and back to d11 core.
  */
-void *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
+void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
 {
 	uint idx;
 
@@ -1303,10 +1306,10 @@ void *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
 }
 
 /* Turn off interrupt as required by ai_setcore, before switch core */
-void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
-		     uint *intr_val)
+void __iomem *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
+			     uint *intr_val)
 {
-	void *cc;
+	void __iomem *cc;
 	struct si_info *sii;
 
 	sii = (struct si_info *)sih;
@@ -1364,7 +1367,7 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		uint val)
 {
 	uint origidx = 0;
-	u32 *r = NULL;
+	u32 __iomem *r = NULL;
 	uint w;
 	uint intr_val = 0;
 	bool fast = false;
@@ -1382,8 +1385,8 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sii)) {
 		/* Chipc registers are mapped at 12KB */
 		fast = true;
-		r = (u32 *)((char *)sii->curmap +
-			    PCI_16KB0_CCREGS_OFFSET + regoff);
+		r = (u32 __iomem *)((__iomem char *)sii->curmap +
+				    PCI_16KB0_CCREGS_OFFSET + regoff);
 	} else if (sii->pub.buscoreidx == coreidx) {
 		/*
 		 * pci registers are at either in the last 2KB of
@@ -1391,10 +1394,10 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		 */
 		fast = true;
 		if (SI_FAST(sii))
-			r = (u32 *)((char *)sii->curmap +
+			r = (u32 __iomem *)((__iomem char *)sii->curmap +
 				    PCI_16KB0_PCIREGS_OFFSET + regoff);
 		else
-			r = (u32 *)((char *)sii->curmap +
+			r = (u32 __iomem *)((__iomem char *)sii->curmap +
 				    ((regoff >= SBCONFIGOFF) ?
 				      PCI_BAR0_PCISBR_OFFSET :
 				      PCI_BAR0_PCIREGS_OFFSET) + regoff);
@@ -1407,8 +1410,8 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		origidx = ai_coreidx(&sii->pub);
 
 		/* switch core */
-		r = (u32 *) ((unsigned char *) ai_setcoreidx(&sii->pub, coreidx)
-				+ regoff);
+		r = (u32 __iomem *) ((unsigned char __iomem *)
+			ai_setcoreidx(&sii->pub, coreidx) + regoff);
 	}
 
 	/* mask and set */
@@ -1489,7 +1492,7 @@ void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits)
 /* return the slow clock source - LPO, XTAL, or PCI */
 static uint ai_slowclk_src(struct si_info *sii)
 {
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	u32 val;
 
 	if (sii->pub.ccrev < 6) {
@@ -1499,7 +1502,8 @@ static uint ai_slowclk_src(struct si_info *sii)
 			return SCC_SS_PCI;
 		return SCC_SS_XTAL;
 	} else if (sii->pub.ccrev < 10) {
-		cc = (struct chipcregs *) ai_setcoreidx(&sii->pub, sii->curidx);
+		cc = (struct chipcregs __iomem *)
+			ai_setcoreidx(&sii->pub, sii->curidx);
 		return R_REG(&cc->slow_clk_ctl) & SCC_SS_MASK;
 	} else			/* Insta-clock */
 		return SCC_SS_XTAL;
@@ -1509,8 +1513,8 @@ static uint ai_slowclk_src(struct si_info *sii)
 * return the ILP (slowclock) min or max frequency
 * precondition: we've established the chip has dynamic clk control
 */
-static uint
-ai_slowclk_freq(struct si_info *sii, bool max_freq, struct chipcregs *cc)
+static uint ai_slowclk_freq(struct si_info *sii, bool max_freq,
+			    struct chipcregs __iomem *cc)
 {
 	u32 slowclk;
 	uint div;
@@ -1544,7 +1548,8 @@ ai_slowclk_freq(struct si_info *sii, bool max_freq, struct chipcregs *cc)
 	return 0;
 }
 
-static void ai_clkctl_setdelay(struct si_info *sii, struct chipcregs *cc)
+static void
+ai_clkctl_setdelay(struct si_info *sii, struct chipcregs __iomem *cc)
 {
 	uint slowmaxfreq, pll_delay, slowclk;
 	uint pll_on_delay, fref_sel_delay;
@@ -1577,7 +1582,7 @@ void ai_clkctl_init(struct si_pub *sih)
 {
 	struct si_info *sii;
 	uint origidx = 0;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	bool fast;
 
 	if (!(sih->cccaps & CC_CAP_PWR_CTL))
@@ -1587,11 +1592,12 @@ void ai_clkctl_init(struct si_pub *sih)
 	fast = SI_FAST(sii);
 	if (!fast) {
 		origidx = sii->curidx;
-		cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
+		cc = (struct chipcregs __iomem *)
+			ai_setcore(sih, CC_CORE_ID, 0);
 		if (cc == NULL)
 			return;
 	} else {
-		cc = (struct chipcregs *) CCREGS_FAST(sii);
+		cc = (struct chipcregs __iomem *) CCREGS_FAST(sii);
 		if (cc == NULL)
 			return;
 	}
@@ -1615,7 +1621,7 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 {
 	struct si_info *sii;
 	uint origidx = 0;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint slowminfreq;
 	u16 fpdelay;
 	uint intr_val = 0;
@@ -1637,11 +1643,12 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	if (!fast) {
 		origidx = sii->curidx;
 		INTR_OFF(sii, intr_val);
-		cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
+		cc = (struct chipcregs __iomem *)
+			ai_setcore(sih, CC_CORE_ID, 0);
 		if (cc == NULL)
 			goto done;
 	} else {
-		cc = (struct chipcregs *) CCREGS_FAST(sii);
+		cc = (struct chipcregs __iomem *) CCREGS_FAST(sii);
 		if (cc == NULL)
 			goto done;
 	}
@@ -1725,7 +1732,7 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 {
 	uint origidx = 0;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	u32 scc;
 	uint intr_val = 0;
 	bool fast = SI_FAST(sii);
@@ -1737,9 +1744,10 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	if (!fast) {
 		INTR_OFF(sii, intr_val);
 		origidx = sii->curidx;
-		cc = (struct chipcregs *) ai_setcore(&sii->pub, CC_CORE_ID, 0);
+		cc = (struct chipcregs __iomem *)
+					ai_setcore(&sii->pub, CC_CORE_ID, 0);
 	} else {
-		cc = (struct chipcregs *) CCREGS_FAST(sii);
+		cc = (struct chipcregs __iomem *) CCREGS_FAST(sii);
 		if (cc == NULL)
 			goto done;
 	}
@@ -1897,7 +1905,7 @@ void ai_pci_down(struct si_pub *sih)
 void ai_pci_setup(struct si_pub *sih, uint coremask)
 {
 	struct si_info *sii;
-	struct sbpciregs *regs = NULL;
+	struct sbpciregs __iomem *regs = NULL;
 	u32 siflag = 0, w;
 	uint idx = 0;
 
@@ -1943,7 +1951,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 int ai_pci_fixcfg(struct si_pub *sih)
 {
 	uint origidx;
-	void *regs = NULL;
+	void __iomem *regs = NULL;
 	struct si_info *sii = (struct si_info *)sih;
 
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
@@ -1953,9 +1961,10 @@ int ai_pci_fixcfg(struct si_pub *sih)
 	/* check 'pi' is correct and fix it if not */
 	regs = ai_setcore(&sii->pub, sii->pub.buscoretype, 0);
 	if (sii->pub.buscoretype == PCIE_CORE_ID)
-		pcicore_fixcfg_pcie(sii->pch, (struct sbpcieregs *)regs);
+		pcicore_fixcfg_pcie(sii->pch,
+				    (struct sbpcieregs __iomem *)regs);
 	else if (sii->pub.buscoretype == PCI_CORE_ID)
-		pcicore_fixcfg_pci(sii->pch, (struct sbpciregs *)regs);
+		pcicore_fixcfg_pci(sii->pch, (struct sbpciregs __iomem *)regs);
 
 	/* restore the original index */
 	ai_setcoreidx(&sii->pub, origidx);
@@ -1976,14 +1985,14 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 {
 	struct si_info *sii;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx;
 	u32 val;
 
 	sii = (struct si_info *)sih;
 	origidx = ai_coreidx(sih);
 
-	cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
+	cc = (struct chipcregs __iomem *) ai_setcore(sih, CC_CORE_ID, 0);
 
 	val = R_REG(&cc->chipcontrol);
 
@@ -2009,7 +2018,7 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 void ai_epa_4313war(struct si_pub *sih)
 {
 	struct si_info *sii;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx;
 
 	sii = (struct si_info *)sih;
@@ -2044,7 +2053,7 @@ bool ai_is_sprom_available(struct si_pub *sih)
 	if (sih->ccrev >= 31) {
 		struct si_info *sii;
 		uint origidx;
-		struct chipcregs *cc;
+		struct chipcregs __iomem *cc;
 		u32 sromctrl;
 
 		if ((sih->cccaps & CC_CAP_SROM) == 0)
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 3917192..4a3f98e 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -269,8 +269,8 @@ struct si_info {
 	char *vars;
 	uint varsz;
 
-	void *curmap;		/* current regs va */
-	void *regs[SI_MAXCORES];	/* other regs va */
+	void __iomem *curmap;			/* current regs va */
+	void __iomem *regs[SI_MAXCORES];	/* other regs va */
 
 	uint curidx;		/* current core index */
 	uint numcores;		/* # discovered cores */
@@ -319,8 +319,8 @@ extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
 extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern struct si_pub *ai_attach(void *regs, struct pci_dev *sdh, char **vars,
-				uint *varsz);
+extern struct si_pub *ai_attach(void __iomem *regs, struct pci_dev *sdh,
+				char **vars, uint *varsz);
 extern void ai_detach(struct si_pub *sih);
 extern uint ai_coreid(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
@@ -331,10 +331,10 @@ extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
 extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
 extern bool ai_iscoreup(struct si_pub *sih);
 extern uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit);
-extern void *ai_setcoreidx(struct si_pub *sih, uint coreidx);
-extern void *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit);
-extern void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
-			    uint *intr_val);
+extern void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx);
+extern void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit);
+extern void __iomem *ai_switch_core(struct si_pub *sih, uint coreid,
+				    uint *origidx, uint *intr_val);
 extern void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val);
 extern void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits);
 extern void ai_core_disable(struct si_pub *sih, u32 bits);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 10f1de2..f8bc42f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4678,7 +4678,7 @@ struct brcms_pub *brcms_c_pub(struct brcms_c_info *wlc)
  *    put the whole chip in reset(driver down state), no clock
  */
 static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
-			  uint unit, bool piomode, void *regsva,
+			  uint unit, bool piomode, void __iomem *regsva,
 			  struct pci_dev *btparam)
 {
 	struct brcms_hardware *wlc_hw;
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index f5a2695..e3cce29 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -206,8 +206,8 @@ struct sbpcieregs {
 
 struct pcicore_info {
 	union {
-		struct sbpcieregs *pcieregs;
-		struct sbpciregs *pciregs;
+		struct sbpcieregs __iomem *pcieregs;
+		struct sbpciregs __iomem *pciregs;
 	} regs;			/* Memory mapped register to the core */
 
 	struct si_pub *sih;	/* System interconnect handle */
@@ -239,7 +239,7 @@ static void pr28829_delay(void)
  * It's caller's responsibility to make sure that this is done only once
  */
 struct pcicore_info *pcicore_init(struct si_pub *sih, struct pci_dev *pdev,
-				  void *regs)
+				  void __iomem *regs)
 {
 	struct pcicore_info *pi;
 
@@ -334,7 +334,7 @@ end:
 
 /* ***** Register Access API */
 static uint
-pcie_readreg(struct sbpcieregs *pcieregs, uint addrtype, uint offset)
+pcie_readreg(struct sbpcieregs __iomem *pcieregs, uint addrtype, uint offset)
 {
 	uint retval = 0xFFFFFFFF;
 
@@ -354,8 +354,8 @@ pcie_readreg(struct sbpcieregs *pcieregs, uint addrtype, uint offset)
 	return retval;
 }
 
-static uint
-pcie_writereg(struct sbpcieregs *pcieregs, uint addrtype, uint offset, uint val)
+static uint pcie_writereg(struct sbpcieregs __iomem *pcieregs, uint addrtype,
+			  uint offset, uint val)
 {
 	switch (addrtype) {
 	case PCIE_CONFIGREGS:
@@ -374,7 +374,7 @@ pcie_writereg(struct sbpcieregs *pcieregs, uint addrtype, uint offset, uint val)
 
 static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 {
-	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	uint mdiodata, i = 0;
 	uint pcie_serdes_spinwait = 200;
 
@@ -405,7 +405,7 @@ static int
 pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 	    uint *val)
 {
-	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	uint mdiodata;
 	uint i = 0;
 	uint pcie_serdes_spinwait = 10;
@@ -503,7 +503,7 @@ static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 {
 	u32 w;
 	struct si_pub *sih = pi->sih;
-	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 
 	if (sih->buscoretype != PCIE_CORE_ID || sih->buscorerev < 7)
 		return;
@@ -582,9 +582,10 @@ static void pcie_war_polarity(struct pcicore_info *pi)
  */
 static void pcie_war_aspm_clkreq(struct pcicore_info *pi)
 {
-	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	struct si_pub *sih = pi->sih;
-	u16 val16, *reg16;
+	u16 val16;
+	u16 __iomem *reg16;
 	u32 w;
 
 	if (!PCIE_ASPM(sih))
@@ -642,8 +643,9 @@ static void pcie_war_serdes(struct pcicore_info *pi)
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_misc_config_fixup(struct pcicore_info *pi)
 {
-	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
-	u16 val16, *reg16;
+	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
+	u16 val16;
+	u16 __iomem *reg16;
 
 	reg16 = &pcieregs->sprom[SRSH_PCIE_MISC_CONFIG];
 	val16 = R_REG(reg16);
@@ -658,8 +660,8 @@ static void pcie_misc_config_fixup(struct pcicore_info *pi)
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_war_noplldown(struct pcicore_info *pi)
 {
-	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
-	u16 *reg16;
+	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
+	u16 __iomem *reg16;
 
 	/* turn off serdes PLL down */
 	ai_corereg(pi->sih, SI_CC_IDX, offsetof(struct chipcregs, chipcontrol),
@@ -674,7 +676,7 @@ static void pcie_war_noplldown(struct pcicore_info *pi)
 static void pcie_war_pci_setup(struct pcicore_info *pi)
 {
 	struct si_pub *sih = pi->sih;
-	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs __iomem *pcieregs = pi->regs.pcieregs;
 	u32 w;
 
 	if (sih->buscorerev == 0 || sih->buscorerev == 1) {
@@ -789,7 +791,7 @@ void pcicore_down(struct pcicore_info *pi, int state)
 }
 
 /* precondition: current core is sii->buscoretype */
-static void pcicore_fixcfg(struct pcicore_info *pi, u16 *reg16)
+static void pcicore_fixcfg(struct pcicore_info *pi, u16 __iomem *reg16)
 {
 	struct si_info *sii = (struct si_info *)(pi->sih);
 	u16 val16;
@@ -804,18 +806,21 @@ static void pcicore_fixcfg(struct pcicore_info *pi, u16 *reg16)
 	}
 }
 
-void pcicore_fixcfg_pci(struct pcicore_info *pi, struct sbpciregs *pciregs)
+void
+pcicore_fixcfg_pci(struct pcicore_info *pi, struct sbpciregs __iomem *pciregs)
 {
 	pcicore_fixcfg(pi, &pciregs->sprom[SRSH_PI_OFFSET]);
 }
 
-void pcicore_fixcfg_pcie(struct pcicore_info *pi, struct sbpcieregs *pcieregs)
+void pcicore_fixcfg_pcie(struct pcicore_info *pi,
+			 struct sbpcieregs __iomem *pcieregs)
 {
 	pcicore_fixcfg(pi, &pcieregs->sprom[SRSH_PI_OFFSET]);
 }
 
 /* precondition: current core is pci core */
-void pcicore_pci_setup(struct pcicore_info *pi, struct sbpciregs *pciregs)
+void
+pcicore_pci_setup(struct pcicore_info *pi, struct sbpciregs __iomem *pciregs)
 {
 	u32 w;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.h b/drivers/staging/brcm80211/brcmsmac/nicpci.h
index 4995203..2d41aab 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.h
@@ -62,7 +62,8 @@ struct sbpciregs;
 struct sbpcieregs;
 
 extern struct pcicore_info *pcicore_init(struct si_pub *sih,
-					 struct pci_dev *pdev, void *regs);
+					 struct pci_dev *pdev,
+					 void __iomem *regs);
 extern void pcicore_deinit(struct pcicore_info *pch);
 extern void pcicore_attach(struct pcicore_info *pch, char *pvars, int state);
 extern void pcicore_hwup(struct pcicore_info *pch);
@@ -72,10 +73,10 @@ extern void pcicore_down(struct pcicore_info *pch, int state);
 extern u8 pcicore_find_pci_capability(struct pci_dev *dev, u8 req_cap_id,
 				      unsigned char *buf, u32 *buflen);
 extern void pcicore_fixcfg_pci(struct pcicore_info *pch,
-			       struct sbpciregs *pciregs);
+			       struct sbpciregs __iomem *pciregs);
 extern void pcicore_fixcfg_pcie(struct pcicore_info *pch,
-				struct sbpcieregs *pciregs);
+				struct sbpcieregs __iomem *pciregs);
 extern void pcicore_pci_setup(struct pcicore_info *pch,
-			      struct sbpciregs *pciregs);
+			      struct sbpciregs __iomem *pciregs);
 
 #endif /* _BRCM_NICPCI_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index f15e8be..edf5515 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -132,7 +132,8 @@ struct otpinfo {
 #define OTP4315_SWREG_SZ	178	/* 178 bytes */
 #define OTP_SZ_FU_144		(144/8)	/* 144 bits */
 
-static u16 ipxotp_otpr(struct otpinfo *oi, struct chipcregs *cc, uint wn)
+static u16
+ipxotp_otpr(struct otpinfo *oi, struct chipcregs __iomem *cc, uint wn)
 {
 	return R_REG(&cc->sromotp[wn]);
 }
@@ -160,7 +161,7 @@ static int ipxotp_max_rgnsz(struct si_pub *sih, int osizew)
 	return ret;
 }
 
-static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
+static void _ipxotp_init(struct otpinfo *oi, struct chipcregs __iomem *cc)
 {
 	uint k;
 	u32 otpp, st;
@@ -240,7 +241,7 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
 static int ipxotp_init(struct si_pub *sih, struct otpinfo *oi)
 {
 	uint idx;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 
 	/* Make sure we're running IPX OTP */
 	if (!OTPTYPE_IPX(sih->ccrev))
@@ -295,7 +296,7 @@ static int
 ipxotp_read_region(struct otpinfo *oi, int region, u16 *data, uint *wlen)
 {
 	uint idx;
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint base, i, sz;
 
 	/* Validate region selection */
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index 6d4cd9f..3b36e3a 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -139,7 +139,7 @@ static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 }
 
 static void
-si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct chipcregs *cc,
+si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct chipcregs __iomem *cc,
 			   u8 spuravoid)
 {
 	u32 tmp = 0;
@@ -221,7 +221,7 @@ u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 
 void si_pmu_sprom_enable(struct si_pub *sih, bool enable)
 {
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx;
 
 	/* Remember original core before switch to chipc */
@@ -294,11 +294,11 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 
 void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 {
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx, intr_val;
 
 	/* Remember original core before switch to chipc */
-	cc = (struct chipcregs *)
+	cc = (struct chipcregs __iomem *)
 			ai_switch_core(sih, CC_CORE_ID, &origidx, &intr_val);
 
 	/* update the pll changes */
@@ -311,7 +311,7 @@ void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 /* initialize PMU */
 void si_pmu_init(struct si_pub *sih)
 {
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx;
 
 	/* Remember original core before switch to chipc */
@@ -350,7 +350,7 @@ void si_pmu_swreg_init(struct si_pub *sih)
 /* initialize PLL */
 void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
 {
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx;
 
 	/* Remember original core before switch to chipc */
@@ -374,7 +374,7 @@ void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
 /* initialize PMU resources */
 void si_pmu_res_init(struct si_pub *sih)
 {
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx;
 	u32 min_mask = 0, max_mask = 0;
 
@@ -406,7 +406,7 @@ void si_pmu_res_init(struct si_pub *sih)
 
 u32 si_pmu_measure_alpclk(struct si_pub *sih)
 {
-	struct chipcregs *cc;
+	struct chipcregs __iomem *cc;
 	uint origidx;
 	u32 alp_khz;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 0105306..6f3b12c 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -782,12 +782,14 @@ static const struct brcms_sromvar perpath_pci_sromvars[] = {
  * shared between devices. */
 static u8 brcms_srom_crc8_table[CRC8_TABLE_SIZE];
 
-static u16 *srom_window_address(struct si_pub *sih, u8 *curmap)
+static u16 __iomem *
+srom_window_address(struct si_pub *sih, u8 __iomem *curmap)
 {
 	if (sih->ccrev < 32)
-		return (u16 *)(curmap + PCI_BAR0_SPROM_OFFSET);
+		return (u16 __iomem *)(curmap + PCI_BAR0_SPROM_OFFSET);
 	if (sih->cccaps & CC_CAP_SROM)
-		return (u16 *)(curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP);
+		return (u16 __iomem *)
+		       (curmap + PCI_16KB0_CCREGS_OFFSET + CC_SROM_OTP);
 
 	return NULL;
 }
@@ -1032,7 +1034,7 @@ _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
  * Return 0 on success, nonzero on error.
  */
 static int
-sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
+sprom_read_pci(struct si_pub *sih, u16 __iomem *sprom, uint wordoff,
 	       u16 *buf, uint nwords, bool check_crc)
 {
 	int err = 0;
@@ -1131,10 +1133,11 @@ static int initvars_table(char *start, char *end,
  * Initialize nonvolatile variable table from sprom.
  * Return 0 on success, nonzero on error.
  */
-static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
-			     uint *count)
+static int initvars_srom_pci(struct si_pub *sih, void __iomem *curmap,
+			     char **vars, uint *count)
 {
-	u16 *srom, *sromwindow;
+	u16 *srom;
+	u16 __iomem *sromwindow;
 	u8 sromrev = 0;
 	u32 sr;
 	struct brcms_varbuf b;
@@ -1222,7 +1225,8 @@ errout:
  * Initialize local vars from the right source for this platform.
  * Return 0 on success, nonzero on error.
  */
-int srom_var_init(struct si_pub *sih, void *curmap, char **vars, uint *count)
+int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
+		  uint *count)
 {
 	uint len;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.h b/drivers/staging/brcm80211/brcmsmac/srom.h
index dd51156..826c2cd 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.h
+++ b/drivers/staging/brcm80211/brcmsmac/srom.h
@@ -20,7 +20,7 @@
 #include "types.h"
 
 /* Prototypes */
-extern int srom_var_init(struct si_pub *sih, void *curmap, char **vars,
+extern int srom_var_init(struct si_pub *sih, void __iomem *curmap, char **vars,
 			 uint *count);
 
 extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
-- 
1.7.1


