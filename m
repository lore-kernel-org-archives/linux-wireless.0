Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4350 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932398Ab1GNV34 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:56 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 16/35] staging: brcm80211: replaced all volatile
 typedefs
Date: Thu, 14 Jul 2011 14:29:12 -0700
Message-ID: <1310678971-28952-17-git-send-email-frankyl@broadcom.com> (sfid-20110714_233014_291142_A651D783)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Volatile keyword is not needed, hardware is accessed using native Linux
calls that provide synchronization.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c    |    3 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |   64 ++++++++++---------
 drivers/staging/brcm80211/brcmsmac/d11.h         |   24 ++++----
 drivers/staging/brcm80211/brcmsmac/dma.c         |   16 +++--
 drivers/staging/brcm80211/brcmsmac/main.c        |   73 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/main.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c      |   10 ++--
 drivers/staging/brcm80211/brcmsmac/otp.c         |   16 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   33 +++++-----
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |   10 ++--
 drivers/staging/brcm80211/brcmsmac/pmu.c         |   42 +++++++------
 drivers/staging/brcm80211/brcmsmac/types.h       |   12 ----
 drivers/staging/brcm80211/include/chipcommon.h   |    4 +-
 14 files changed, 157 insertions(+), 156 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index acad298..ddd781e 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -475,7 +475,8 @@ BRCMF_SPINWAIT_SLEEP_INIT(sdioh_spinwait_sleep);
  * Core reg address translation.
  * Both macro's returns a 32 bits byte address on the backplane bus.
  */
-#define CORE_CC_REG(base, field)	(base + offsetof(chipcregs_t, field))
+#define CORE_CC_REG(base, field) \
+		(base + offsetof(struct chipcregs, field))
 #define CORE_BUS_REG(base, field) \
 		(base + offsetof(struct sdpcmd_regs, field))
 #define CORE_SB(base, field) \
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 5a5fc4b..58a5cfc 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -437,7 +437,7 @@ static void ai_hwfixup(struct si_info *sii)
 void ai_scan(struct si_pub *sih, void *regs)
 {
 	struct si_info *sii = SI_INFO(sih);
-	chipcregs_t *cc = (chipcregs_t *) regs;
+	struct chipcregs *cc = (struct chipcregs *) regs;
 	u32 erombase, *eromptr, *eromlim;
 
 	erombase = R_REG(&cc->eromptr);
@@ -854,8 +854,9 @@ static struct si_info *ai_doattach(struct si_info *sii, void *regs,
 			      uint bustype, void *sdh, char **vars,
 			      uint *varsz);
 static bool ai_buscore_prep(struct si_info *sii, uint bustype);
-static bool ai_buscore_setup(struct si_info *sii, chipcregs_t *cc, uint bustype,
-			     u32 savewin, uint *origidx, void *regs);
+static bool ai_buscore_setup(struct si_info *sii, struct chipcregs *cc,
+			     uint bustype, u32 savewin, uint *origidx,
+			     void *regs);
 static void ai_nvram_process(struct si_info *sii, char *pvars);
 
 /* dev path concatenation util */
@@ -910,8 +911,9 @@ static bool ai_buscore_prep(struct si_info *sii, uint bustype)
 	return true;
 }
 
-static bool ai_buscore_setup(struct si_info *sii, chipcregs_t *cc, uint bustype,
-			     u32 savewin, uint *origidx, void *regs)
+static bool
+ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, uint bustype,
+		 u32 savewin, uint *origidx, void *regs)
 {
 	bool pci, pcie;
 	uint i;
@@ -1074,7 +1076,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 {
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	char *pvars = NULL;
 	uint socitype;
 	uint origidx;
@@ -1106,9 +1108,9 @@ static struct si_info *ai_doattach(struct si_info *sii,
 			savewin = SI_ENUM_BASE;
 		pci_write_config_dword(sii->pbus, PCI_BAR0_WIN,
 				       SI_ENUM_BASE);
-		cc = (chipcregs_t *) regs;
+		cc = (struct chipcregs *) regs;
 	} else {
-		cc = (chipcregs_t *) REG_MAP(SI_ENUM_BASE, SI_CORE_SIZE);
+		cc = (struct chipcregs *) REG_MAP(SI_ENUM_BASE, SI_CORE_SIZE);
 	}
 
 	sih->bustype = bustype;
@@ -1167,7 +1169,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_nvram_process(sii, pvars);
 
 	/* === NVRAM, clock is ready === */
-	cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
+	cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
 	W_REG(&cc->gpiopullup, 0);
 	W_REG(&cc->gpiopulldown, 0);
 	ai_setcoreidx(sih, origidx);
@@ -1190,7 +1192,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	w = getintvar(pvars, "leddc");
 	if (w == 0)
 		w = DEFAULT_GPIOTIMERVAL;
-	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, gpiotimerval), ~0, w);
+	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, gpiotimerval),
+		   ~0, w);
 
 	if (PCIE(sii)) {
 		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
@@ -1204,7 +1207,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		if (sih->chiprev == 0) {
 			SI_MSG(("Applying 43224A0 WARs\n"));
 			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol),
+				   offsetof(struct chipcregs, chipcontrol),
 				   CCTRL43224_GPIO_TOGGLE,
 				   CCTRL43224_GPIO_TOGGLE);
 			si_pmu_chipcontrol(sih, 0, CCTRL_43224A0_12MA_LED_DRIVE,
@@ -1556,7 +1559,7 @@ void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits)
 /* return the slow clock source - LPO, XTAL, or PCI */
 static uint ai_slowclk_src(struct si_info *sii)
 {
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	u32 val;
 
 	if (sii->pub.ccrev < 6) {
@@ -1568,7 +1571,7 @@ static uint ai_slowclk_src(struct si_info *sii)
 		}
 		return SCC_SS_XTAL;
 	} else if (sii->pub.ccrev < 10) {
-		cc = (chipcregs_t *) ai_setcoreidx(&sii->pub, sii->curidx);
+		cc = (struct chipcregs *) ai_setcoreidx(&sii->pub, sii->curidx);
 		return R_REG(&cc->slow_clk_ctl) & SCC_SS_MASK;
 	} else			/* Insta-clock */
 		return SCC_SS_XTAL;
@@ -1578,7 +1581,8 @@ static uint ai_slowclk_src(struct si_info *sii)
 * return the ILP (slowclock) min or max frequency
 * precondition: we've established the chip has dynamic clk control
 */
-static uint ai_slowclk_freq(struct si_info *sii, bool max_freq, chipcregs_t *cc)
+static uint
+ai_slowclk_freq(struct si_info *sii, bool max_freq, struct chipcregs *cc)
 {
 	u32 slowclk;
 	uint div;
@@ -1614,7 +1618,7 @@ static uint ai_slowclk_freq(struct si_info *sii, bool max_freq, chipcregs_t *cc)
 
 static void ai_clkctl_setdelay(struct si_info *sii, void *chipcregs)
 {
-	chipcregs_t *cc = (chipcregs_t *) chipcregs;
+	struct chipcregs *cc = (struct chipcregs *) chipcregs;
 	uint slowmaxfreq, pll_delay, slowclk;
 	uint pll_on_delay, fref_sel_delay;
 
@@ -1646,7 +1650,7 @@ void ai_clkctl_init(struct si_pub *sih)
 {
 	struct si_info *sii;
 	uint origidx = 0;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	bool fast;
 
 	if (!CCCTL_ENAB(sih))
@@ -1656,11 +1660,11 @@ void ai_clkctl_init(struct si_pub *sih)
 	fast = SI_FAST(sii);
 	if (!fast) {
 		origidx = sii->curidx;
-		cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
+		cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
 		if (cc == NULL)
 			return;
 	} else {
-		cc = (chipcregs_t *) CCREGS_FAST(sii);
+		cc = (struct chipcregs *) CCREGS_FAST(sii);
 		if (cc == NULL)
 			return;
 	}
@@ -1684,7 +1688,7 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 {
 	struct si_info *sii;
 	uint origidx = 0;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint slowminfreq;
 	u16 fpdelay;
 	uint intr_val = 0;
@@ -1706,11 +1710,11 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 	if (!fast) {
 		origidx = sii->curidx;
 		INTR_OFF(sii, intr_val);
-		cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
+		cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
 		if (cc == NULL)
 			goto done;
 	} else {
-		cc = (chipcregs_t *) CCREGS_FAST(sii);
+		cc = (struct chipcregs *) CCREGS_FAST(sii);
 		if (cc == NULL)
 			goto done;
 	}
@@ -1825,7 +1829,7 @@ bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 {
 	uint origidx = 0;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	u32 scc;
 	uint intr_val = 0;
 	bool fast = SI_FAST(sii);
@@ -1843,9 +1847,9 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 		    (ai_corerev(&sii->pub) <= 7) && (sii->pub.ccrev >= 10))
 			goto done;
 
-		cc = (chipcregs_t *) ai_setcore(&sii->pub, CC_CORE_ID, 0);
+		cc = (struct chipcregs *) ai_setcore(&sii->pub, CC_CORE_ID, 0);
 	} else {
-		cc = (chipcregs_t *) CCREGS_FAST(sii);
+		cc = (struct chipcregs *) CCREGS_FAST(sii);
 		if (cc == NULL)
 			goto done;
 	}
@@ -2164,21 +2168,21 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 		val &= mask;
 	}
 
-	regoff = offsetof(chipcregs_t, gpiocontrol);
+	regoff = offsetof(struct chipcregs, gpiocontrol);
 	return ai_corereg(sih, SI_CC_IDX, regoff, mask, val);
 }
 
 void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 {
 	struct si_info *sii;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx;
 	u32 val;
 
 	sii = SI_INFO(sih);
 	origidx = ai_coreidx(sih);
 
-	cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
+	cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
 
 	val = R_REG(&cc->chipcontrol);
 
@@ -2205,13 +2209,13 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 void ai_epa_4313war(struct si_pub *sih)
 {
 	struct si_info *sii;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx;
 
 	sii = SI_INFO(sih);
 	origidx = ai_coreidx(sih);
 
-	cc = (chipcregs_t *) ai_setcore(sih, CC_CORE_ID, 0);
+	cc = (struct chipcregs *) ai_setcore(sih, CC_CORE_ID, 0);
 
 	/* EPA Fix */
 	W_REG(&cc->gpiocontrol,
@@ -2243,7 +2247,7 @@ bool ai_is_sprom_available(struct si_pub *sih)
 	if (sih->ccrev >= 31) {
 		struct si_info *sii;
 		uint origidx;
-		chipcregs_t *cc;
+		struct chipcregs *cc;
 		u32 sromctrl;
 
 		if ((sih->cccaps & CC_CAP_SROM) == 0)
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index e7ff0e6..4dc7340 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -73,8 +73,8 @@ struct pio2regs {
 
 /* a pair of pio channels(tx and rx) */
 struct pio2regp {
-	pio2regs_t tx;
-	pio2regs_t rx;
+	struct pio2regs tx;
+	struct pio2regs rx;
 };
 
 /* 4byte-wide pio register set per channel(xmt or rcv) */
@@ -85,8 +85,8 @@ struct pio4regs {
 
 /* a pair of pio channels(tx and rx) */
 struct pio4regp {
-	pio4regs_t tx;
-	pio4regs_t rx;
+	struct pio4regs tx;
+	struct pio4regs rx;
 };
 
 /* read: 32-bit register that can be read as 32-bit or as 2 16-bit
@@ -101,10 +101,10 @@ union pmqreg {
 };
 
 struct fifo64 {
-	dma64regs_t dmaxmt;	/* dma tx */
-	pio4regs_t piotx;	/* pio tx */
-	dma64regs_t dmarcv;	/* dma rx */
-	pio4regs_t piorx;	/* pio rx */
+	struct dma64regs dmaxmt;	/* dma tx */
+	struct pio4regs piotx;	/* pio tx */
+	struct dma64regs dmarcv;	/* dma rx */
+	struct pio4regs piorx;	/* pio rx */
 };
 
 /*
@@ -120,7 +120,7 @@ struct d11regs {
 	u32 usectimer;	/* 0x1c *//* for corerev >= 26 */
 
 	/* Interrupt Control *//* 0x20 */
-	intctrlregs_t intctrlregs[8];
+	struct intctrlregs intctrlregs[8];
 
 	u32 PAD[40];		/* 0x60 - 0xFC */
 
@@ -139,7 +139,7 @@ struct d11regs {
 	u32 PAD[2];		/* 0x138 - 0x13C */
 
 	/* PMQ registers */
-	pmqreg_t pmqreg;	/* 0x140 */
+	union pmqreg pmqreg;	/* 0x140 */
 	u32 pmqpatl;		/* 0x144 */
 	u32 pmqpath;		/* 0x148 */
 	u32 PAD;		/* 0x14C */
@@ -179,10 +179,10 @@ struct d11regs {
 	u32 PAD[5];		/* 0x1ec - 0x1fc */
 
 	/* 0x200-0x37F dma/pio registers */
-	fifo64_t fifo64regs[6];
+	struct fifo64 fifo64regs[6];
 
 	/* FIFO diagnostic port access */
-	dma32diag_t dmafifo;	/* 0x380 - 0x38C */
+	struct dma32diag dmafifo;	/* 0x380 - 0x38C */
 
 	u32 aggfifocnt;	/* 0x390 */
 	u32 aggfifodata;	/* 0x394 */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 84b5d80..6fabb09 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -240,8 +240,10 @@ struct dma_info {
 
 	union {
 		struct {
-			dma64regs_t *txregs_64;	/* 64-bit dma tx engine registers */
-			dma64regs_t *rxregs_64;	/* 64-bit dma rx engine registers */
+			/* 64-bit dma tx engine registers */
+			struct dma64regs *txregs_64;
+			/* 64-bit dma rx engine registers */
+			struct dma64regs *rxregs_64;
 			/* pointer to dma64 tx descriptor ring */
 			struct dma64desc *txd_64;
 			/* pointer to dma64 rx descriptor ring */
@@ -385,7 +387,7 @@ static void dma64_txreclaim(struct dma_info *di, enum txd_range range);
 static bool dma64_txstopped(struct dma_info *di);
 static bool dma64_rxstopped(struct dma_info *di);
 static bool dma64_rxenabled(struct dma_info *di);
-static bool _dma64_addrext(dma64regs_t *dma64regs);
+static bool _dma64_addrext(struct dma64regs *dma64regs);
 
 static inline u32 parity32(u32 data);
 
@@ -459,8 +461,8 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->dma64 = ((ai_core_sflags(sih, 0, 0) & SISF_DMA64) == SISF_DMA64);
 
 	/* init dma reg pointer */
-	di->d64txregs = (dma64regs_t *) dmaregstx;
-	di->d64rxregs = (dma64regs_t *) dmaregsrx;
+	di->d64txregs = (struct dma64regs *) dmaregstx;
+	di->d64rxregs = (struct dma64regs *) dmaregsrx;
 	di->dma.di_fn = (const struct di_fcn_s *)&dma64proc;
 
 	/* Default flags (which can be changed by the driver calling dma_ctrlflags
@@ -1683,7 +1685,7 @@ static void *dma64_getnexttxp(struct dma_info *di, enum txd_range range)
 	if (range == DMA_RANGE_ALL)
 		end = di->txout;
 	else {
-		dma64regs_t *dregs = di->d64txregs;
+		struct dma64regs *dregs = di->d64txregs;
 
 		end = (u16) (B2I(((R_REG(&dregs->status0) &
 				 D64_XS0_CD_MASK) -
@@ -1795,7 +1797,7 @@ static void *dma64_getnextrxp(struct dma_info *di, bool forceall)
 	return rxp;
 }
 
-static bool _dma64_addrext(dma64regs_t *dma64regs)
+static bool _dma64_addrext(struct dma64regs *dma64regs)
 {
 	u32 w;
 	OR_REG(&dma64regs->control, D64_XC_AE);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index c96f43a..d3c325c 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -516,7 +516,7 @@ static struct brcms_c_info *wlc_info_dbg = (struct brcms_c_info *) (NULL);
 static void brcms_b_update_slot_timing(struct brcms_hardware *wlc_hw,
 					bool shortslot)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 
 	regs = wlc_hw->regs;
 
@@ -661,7 +661,7 @@ brcms_b_txstatus(struct brcms_hardware *wlc_hw, bool bound, bool *fatal)
 {
 	bool morepending = false;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
-	d11regs_t *regs;
+	struct d11regs *regs;
 	struct tx_status txstatus, *txs;
 	u32 s1, s2;
 	uint n = 0;
@@ -719,7 +719,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 {
 	u32 macintstatus;
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	bool fatal = false;
 	struct wiphy *wiphy = wlc->wiphy;
 
@@ -1270,7 +1270,7 @@ void
 brcms_b_set_addrmatch(struct brcms_hardware *wlc_hw, int match_reg_offset,
 		       const u8 *addr)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u16 mac_l;
 	u16 mac_m;
 	u16 mac_h;
@@ -1295,7 +1295,7 @@ void
 brcms_b_write_template_ram(struct brcms_hardware *wlc_hw, int offset, int len,
 			    void *buf)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u32 word;
 	bool be_bit;
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -1365,7 +1365,7 @@ static void
 brcms_c_write_hw_bcntemplate0(struct brcms_hardware *wlc_hw, void *bcn,
 			      int len)
 {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 
 	brcms_b_write_template_ram(wlc_hw, T_BCN0_TPL_BASE, (len + 3) & ~3,
 				    bcn);
@@ -1379,7 +1379,7 @@ static void
 brcms_c_write_hw_bcntemplate1(struct brcms_hardware *wlc_hw, void *bcn,
 			      int len)
 {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 
 	brcms_b_write_template_ram(wlc_hw, T_BCN1_TPL_BASE, (len + 3) & ~3,
 				    bcn);
@@ -1469,16 +1469,16 @@ void brcms_b_core_phypll_reset(struct brcms_hardware *wlc_hw)
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(chipcregs_t, chipcontrol_addr), ~0, 0);
+		   offsetof(struct chipcregs, chipcontrol_addr), ~0, 0);
 	udelay(1);
 	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(chipcregs_t, chipcontrol_data), 0x4, 0);
+		   offsetof(struct chipcregs, chipcontrol_data), 0x4, 0);
 	udelay(1);
 	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(chipcregs_t, chipcontrol_data), 0x4, 4);
+		   offsetof(struct chipcregs, chipcontrol_data), 0x4, 4);
 	udelay(1);
 	ai_corereg(wlc_hw->sih, SI_CC_IDX,
-		   offsetof(chipcregs_t, chipcontrol_data), 0x4, 0);
+		   offsetof(struct chipcregs, chipcontrol_data), 0x4, 0);
 	udelay(1);
 }
 
@@ -1697,9 +1697,8 @@ bool brcms_b_radio_read_hwdisabled(struct brcms_hardware *wlc_hw)
 		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
-			wlc_hw->regs =
-			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
-						     0);
+			wlc_hw->regs = (struct d11regs *)
+					ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 		ai_core_reset(wlc_hw->sih, flags, resetbits);
 		brcms_c_mctrl_reset(wlc_hw);
 	}
@@ -1732,7 +1731,7 @@ static bool wlc_dma_rxreset(struct brcms_hardware *wlc_hw, uint fifo)
  */
 void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 	uint i;
 	bool fastclk;
 	u32 resetbits = 0;
@@ -1815,7 +1814,7 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
  */
 static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	u16 fifo_nu;
 	u16 txfifo_startblk = TXFIFO_START_BLK, txfifo_endblk;
 	u16 txfifo_def, txfifo_def1;
@@ -1875,7 +1874,7 @@ static void brcms_b_corerev_fifofixup(struct brcms_hardware *wlc_hw)
 
 void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 	regs = wlc_hw->regs;
 
 	if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
@@ -1905,7 +1904,7 @@ void brcms_b_switch_macfreq(struct brcms_hardware *wlc_hw, u8 spurmode)
 static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u32 gc, gm;
 
 	regs = wlc_hw->regs;
@@ -1996,7 +1995,7 @@ static void brcms_ucode_download(struct brcms_hardware *wlc_hw)
 
 static void brcms_ucode_write(struct brcms_hardware *wlc_hw, const u32 ucode[],
 			      const uint nbytes) {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	uint i;
 	uint count;
 
@@ -2077,7 +2076,7 @@ void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 	bool fatal = false;
 	uint unit;
 	uint intstatus, idx;
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	unit = wlc_hw->unit;
@@ -2324,7 +2323,7 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	u32 macintstatus;
 
 	/* macintstatus includes a DMA interrupt summary bit */
@@ -2434,7 +2433,7 @@ bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	u32 mc, mi;
 	struct wiphy *wiphy = wlc->wiphy;
 
@@ -2503,7 +2502,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 void brcms_c_enable_mac(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	u32 mc, mi;
 
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
@@ -2614,7 +2613,7 @@ void brcms_b_band_stf_ss_set(struct brcms_hardware *wlc_hw, u8 stf_mode)
 
 static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u32 w, val;
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
@@ -2679,7 +2678,7 @@ static bool brcms_b_validate_chip_access(struct brcms_hardware *wlc_hw)
 
 void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u32 tmp;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
@@ -2818,7 +2817,7 @@ void brcms_b_write_shm(struct brcms_hardware *wlc_hw, uint offset, u16 v)
 static u16
 brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
 	volatile u16 *objdata_hi = objdata_lo + 1;
 	u16 v;
@@ -2838,7 +2837,7 @@ static void
 brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 		     u32 sel)
 {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 	volatile u16 *objdata_lo = (volatile u16 *)&regs->objdata;
 	volatile u16 *objdata_hi = objdata_lo + 1;
 
@@ -3061,7 +3060,7 @@ static void brcms_c_init_scb(struct brcms_c_info *wlc, struct scb *scb)
 static void brcms_b_coreinit(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u32 sflags;
 	uint bcnint_us;
 	uint i = 0;
@@ -3289,7 +3288,7 @@ brcms_b_init(struct brcms_hardware *wlc_hw, u16 chanspec,
 
 void brcms_c_init(struct brcms_c_info *wlc)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u16 chanspec;
 	int i;
 	struct brcms_bss_cfg *bsscfg;
@@ -4261,7 +4260,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		    bool piomode, void *regsva, uint bustype, void *btparam)
 {
 	struct brcms_hardware *wlc_hw;
-	d11regs_t *regs;
+	struct d11regs *regs;
 	char *macaddr = NULL;
 	char *vars;
 	uint err = 0;
@@ -4340,7 +4339,8 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->deviceid = device;
 
 	/* set bar0 window to point at D11 core */
-	wlc_hw->regs = (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
+	wlc_hw->regs = (struct d11regs *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
+						     0);
 	wlc_hw->corerev = ai_corerev(wlc_hw->sih);
 
 	regs = wlc_hw->regs;
@@ -5354,9 +5354,8 @@ void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 		/* AI chip doesn't restore bar0win2 on hibernation/resume, need sw fixup */
 		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
 		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
-			wlc_hw->regs =
-			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
-						     0);
+			wlc_hw->regs = (struct d11regs *)
+					ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 	}
 
 	/* Inform phy that a POR reset has occurred so it does a complete phy init */
@@ -8011,7 +8010,7 @@ void
 brcms_b_read_tsf(struct brcms_hardware *wlc_hw, u32 *tsf_l_ptr,
 		  u32 *tsf_h_ptr)
 {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 
 	/* read the tsf timer low, then high to get an atomic read */
 	*tsf_l_ptr = R_REG(&regs->tsf_timerlow);
@@ -8846,7 +8845,7 @@ void
 brcms_b_write_hw_bcntemplates(struct brcms_hardware *wlc_hw, void *bcn,
 			      int len, bool both)
 {
-	d11regs_t *regs = wlc_hw->regs;
+	struct d11regs *regs = wlc_hw->regs;
 
 	if (both) {
 		brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
@@ -8884,7 +8883,7 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 		/* Hardware beaconing for this config */
 		u16 bcn[BCN_TMPL_LEN / 2];
 		u32 both_valid = MCMD_BCN0VLD | MCMD_BCN1VLD;
-		d11regs_t *regs = wlc->regs;
+		struct d11regs *regs = wlc->regs;
 
 		/* Check if both templates are in use, if so sched. an interrupt
 		 *      that will call back into this routine
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 8cbb2d6..e797bf0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -543,7 +543,7 @@ struct brcms_hardware {
 	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
 	char *vars;		/* "environment" name=value */
 	uint vars_size;		/* size of vars, free vars on detach */
-	d11regs_t *regs;	/* pointer to device registers */
+	struct d11regs *regs;	/* pointer to device registers */
 	void *physhim;		/* phy shim layer handler */
 	void *phy_sh;		/* pointer to shared phy state */
 	struct brcms_hw_band *band;/* pointer to active per-band state */
@@ -613,7 +613,7 @@ struct brcms_txq_info {
 struct brcms_c_info {
 	struct brcms_pub *pub;		/* pointer to wlc public state */
 	struct brcms_info *wl;	/* pointer to os-specific private state */
-	d11regs_t *regs;	/* pointer to device registers */
+	struct d11regs *regs;	/* pointer to device registers */
 
 	/* HW related state used primarily by BMAC */
 	struct brcms_hardware *hw;
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 3d71c59..6d6e7d3 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -542,10 +542,10 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 	case SI_PCIDOWN:
 		if (sih->buscorerev == 6) {	/* turn on serdes PLL down */
 			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol_addr),
+				   offsetof(struct chipcregs, chipcontrol_addr),
 				   ~0, 0);
 			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol_data),
+				   offsetof(struct chipcregs, chipcontrol_data),
 				   ~0x40, 0);
 		} else if (pi->pcie_pr42767) {
 			pcie_clkreq((void *)pi, 1, 1);
@@ -554,10 +554,10 @@ static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 	case SI_PCIUP:
 		if (sih->buscorerev == 6) {	/* turn off serdes PLL down */
 			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol_addr),
+				   offsetof(struct chipcregs, chipcontrol_addr),
 				   ~0, 0);
 			ai_corereg(sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol_data),
+				   offsetof(struct chipcregs, chipcontrol_data),
 				   ~0x40, 0x40);
 		} else if (PCIE_ASPM(sih)) {	/* disable clkreq */
 			pcie_clkreq((void *)pi, 1, 0);
@@ -674,7 +674,7 @@ static void pcie_war_noplldown(struct pcicore_info *pi)
 	u16 *reg16;
 
 	/* turn off serdes PLL down */
-	ai_corereg(pi->sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol),
+	ai_corereg(pi->sih, SI_CC_IDX, offsetof(struct chipcregs, chipcontrol),
 		   CHIPCTRL_4321_PLL_DOWN, CHIPCTRL_4321_PLL_DOWN);
 
 	/* clear srom shadow backdoor */
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index a257ed8..d09424d 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -62,7 +62,7 @@
 /* OTP function struct */
 struct otp_fn_s {
 	int (*size)(void *oh);
-	u16 (*read_bit)(void *oh, chipcregs_t *cc, uint off);
+	u16 (*read_bit)(void *oh, struct chipcregs *cc, uint off);
 	void *(*init)(struct si_pub *sih);
 	int (*read_region)(struct si_pub *sih, int region, u16 *data,
 			   uint *wlen);
@@ -156,7 +156,7 @@ static int ipxotp_size(void *oh)
 	return (int)oi->wsize * 2;
 }
 
-static u16 ipxotp_otpr(void *oh, chipcregs_t *cc, uint wn)
+static u16 ipxotp_otpr(void *oh, struct chipcregs *cc, uint wn)
 {
 	struct otpinfo *oi;
 
@@ -165,7 +165,7 @@ static u16 ipxotp_otpr(void *oh, chipcregs_t *cc, uint wn)
 	return R_REG(&cc->sromotp[wn]);
 }
 
-static u16 ipxotp_read_bit(void *oh, chipcregs_t *cc, uint off)
+static u16 ipxotp_read_bit(void *oh, struct chipcregs *cc, uint off)
 {
 	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint k, row, col;
@@ -217,7 +217,7 @@ static int ipxotp_max_rgnsz(struct si_pub *sih, int osizew)
 	return ret;
 }
 
-static void _ipxotp_init(struct otpinfo *oi, chipcregs_t *cc)
+static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
 {
 	uint k;
 	u32 otpp, st;
@@ -291,7 +291,7 @@ static void _ipxotp_init(struct otpinfo *oi, chipcregs_t *cc)
 static void *ipxotp_init(struct si_pub *sih)
 {
 	uint idx;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	struct otpinfo *oi;
 
 	/* Make sure we're running IPX OTP */
@@ -350,7 +350,7 @@ static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 {
 	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint idx;
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint base, i, sz;
 
 	/* Validate region selection */
@@ -438,7 +438,7 @@ static int ipxotp_nvread(void *oh, char *data, uint *len)
 
 static struct otp_fn_s ipxotp_fn = {
 	(int (*)(void *)) ipxotp_size,
-	(u16 (*)(void *, chipcregs_t *, uint)) ipxotp_read_bit,
+	(u16 (*)(void *, struct chipcregs *, uint)) ipxotp_read_bit,
 
 	(void *(*)(struct si_pub *)) ipxotp_init,
 	(int (*)(struct si_pub *, int, u16 *, uint *)) ipxotp_read_region,
@@ -474,7 +474,7 @@ u16 otp_read_bit(void *oh, uint offset)
 {
 	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint idx = ai_coreidx(oi->sih);
-	chipcregs_t *cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
+	struct chipcregs *cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
 	u16 readBit = (u16) oi->fn->read_bit(oh, cc, offset);
 	ai_setcoreidx(oi->sih, idx);
 	return readBit;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 13a447f..940f76b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -365,7 +365,7 @@ void write_phy_channel_reg(struct brcms_phy *pi, uint val)
 
 u16 read_phy_reg(struct brcms_phy *pi, u16 addr)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 
 	regs = pi->regs;
 
@@ -377,7 +377,7 @@ u16 read_phy_reg(struct brcms_phy *pi, u16 addr)
 
 void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 
 	regs = pi->regs;
 
@@ -400,7 +400,7 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 
 void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 
 	regs = pi->regs;
 
@@ -412,7 +412,7 @@ void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 
 void or_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 
 	regs = pi->regs;
 
@@ -424,7 +424,7 @@ void or_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 
 void mod_phy_reg(struct brcms_phy *pi, u16 addr, u16 mask, u16 val)
 {
-	d11regs_t *regs;
+	struct d11regs *regs;
 
 	regs = pi->regs;
 
@@ -543,7 +543,7 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 		return NULL;
 	}
 	pi->wiphy = wiphy;
-	pi->regs = (d11regs_t *) regs;
+	pi->regs = (struct d11regs *) regs;
 	pi->sh = sh;
 	pi->phy_init_por = true;
 	pi->phy_wreg_limit = PHY_WREG_LIMIT;
@@ -1134,7 +1134,7 @@ wlc_phy_init_radio_regs(struct brcms_phy *pi, struct radio_regs *radioregs,
 void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 {
 #define	DUMMY_PKT_LEN	20
-	d11regs_t *regs = pi->regs;
+	struct d11regs *regs = pi->regs;
 	int i, count;
 	u8 ofdmpkt[DUMMY_PKT_LEN] = {
 		0xcc, 0x01, 0x02, 0x00, 0x00, 0x00, 0xd4, 0x00, 0x00, 0x00,
@@ -3134,12 +3134,13 @@ void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode)
 
 			}
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, gpiocontrol), ~0x0,
-				   0x0);
+				   offsetof(struct chipcregs, gpiocontrol),
+				   ~0x0, 0x0);
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, gpioout), 0x40, 0x40);
+				   offsetof(struct chipcregs, gpioout), 0x40,
+				   0x40);
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, gpioouten), 0x40,
+				   offsetof(struct chipcregs, gpioouten), 0x40,
 				   0x40);
 		} else {
 			mod_phy_reg(pi, 0x44c, (0x1 << 2), (0) << 2);
@@ -3147,12 +3148,14 @@ void wlc_lcnphy_epa_switch(struct brcms_phy *pi, bool mode)
 			mod_phy_reg(pi, 0x44d, (0x1 << 2), (0) << 2);
 
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, gpioout), 0x40, 0x00);
+				   offsetof(struct chipcregs, gpioout), 0x40,
+				   0x00);
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, gpioouten), 0x40, 0x0);
+				   offsetof(struct chipcregs, gpioouten), 0x40,
+				   0x0);
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, gpiocontrol), ~0x0,
-				   0x40);
+				   offsetof(struct chipcregs, gpiocontrol),
+				   ~0x0, 0x40);
 		}
 	}
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 6d468e7..1276084 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -593,7 +593,7 @@ struct brcms_phy {
 	} u;
 	bool user_txpwr_at_rfport;
 
-	d11regs_t *regs;
+	struct d11regs *regs;
 	struct brcms_phy *next;
 	char *vars;
 	struct brcms_phy_pub pubpi;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index b4ac0d1..f758812 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14533,7 +14533,7 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	bool do_nphy_cal = false;
 	uint core;
 	uint origidx, intr_val;
-	d11regs_t *regs;
+	struct d11regs *regs;
 	u32 d11_clk_ctl_st;
 
 	core = 0;
@@ -14548,16 +14548,16 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 		if ((pi->sh->boardflags & BFL_EXTLNA) &&
 		    (CHSPEC_IS2G(pi->radio_chanspec))) {
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
-				   offsetof(chipcregs_t, chipcontrol), 0x40,
-				   0x40);
+				   offsetof(struct chipcregs, chipcontrol),
+				   0x40, 0x40);
 		}
 	}
 
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
-		regs = (d11regs_t *) ai_switch_core(pi->sh->sih, D11_CORE_ID,
-						    &origidx, &intr_val);
+		regs = (struct d11regs *) ai_switch_core(pi->sh->sih,
+					D11_CORE_ID, &origidx, &intr_val);
 		d11_clk_ctl_st = R_REG(&regs->clk_ctl_st);
 		AND_REG(&regs->clk_ctl_st,
 			~(CCS_FORCEHT | CCS_HTAREQ));
diff --git a/drivers/staging/brcm80211/brcmsmac/pmu.c b/drivers/staging/brcm80211/brcmsmac/pmu.c
index e8b2b81..ec53a08 100644
--- a/drivers/staging/brcm80211/brcmsmac/pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/pmu.c
@@ -137,7 +137,8 @@ static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 }
 
 static void
-si_pmu_spuravoid_pllupdate(struct si_pub *sih, chipcregs_t *cc, u8 spuravoid)
+si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct chipcregs *cc,
+			   u8 spuravoid)
 {
 	u32 tmp = 0;
 
@@ -209,7 +210,7 @@ u32 si_pmu_ilp_clock(struct si_pub *sih)
 	if (ilpcycles_per_sec == 0) {
 		u32 start, end, delta;
 		u32 origidx = ai_coreidx(sih);
-		chipcregs_t *cc = ai_setcoreidx(sih, SI_CC_IDX);
+		struct chipcregs *cc = ai_setcoreidx(sih, SI_CC_IDX);
 		start = R_REG(&cc->pmutimer);
 		mdelay(ILP_CALC_DUR);
 		end = R_REG(&cc->pmutimer);
@@ -240,7 +241,7 @@ u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 
 void si_pmu_sprom_enable(struct si_pub *sih, bool enable)
 {
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx;
 
 	/* Remember original core before switch to chipc */
@@ -254,34 +255,37 @@ void si_pmu_sprom_enable(struct si_pub *sih, bool enable)
 /* Read/write a chipcontrol reg */
 u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol_addr), ~0,
-		   reg);
+	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, chipcontrol_addr),
+		   ~0, reg);
 	return ai_corereg(sih, SI_CC_IDX,
-			  offsetof(chipcregs_t, chipcontrol_data), mask, val);
+			  offsetof(struct chipcregs, chipcontrol_data), mask,
+			  val);
 }
 
 /* Read/write a regcontrol reg */
 u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr), ~0,
-		   reg);
+	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, regcontrol_addr),
+		   ~0, reg);
 	return ai_corereg(sih, SI_CC_IDX,
-			  offsetof(chipcregs_t, regcontrol_data), mask, val);
+			  offsetof(struct chipcregs, regcontrol_data), mask,
+			  val);
 }
 
 /* Read/write a pllcontrol reg */
 u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pllcontrol_addr), ~0,
-		   reg);
+	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, pllcontrol_addr),
+		   ~0, reg);
 	return ai_corereg(sih, SI_CC_IDX,
-			  offsetof(chipcregs_t, pllcontrol_data), mask, val);
+			  offsetof(struct chipcregs, pllcontrol_data), mask,
+			  val);
 }
 
 /* PMU PLL update */
 void si_pmu_pllupd(struct si_pub *sih)
 {
-	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmucontrol),
+	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, pmucontrol),
 		   PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
 }
 
@@ -310,11 +314,11 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 
 void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 {
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx, intr_val;
 
 	/* Remember original core before switch to chipc */
-	cc = (chipcregs_t *) ai_switch_core(sih, CC_CORE_ID, &origidx,
+	cc = (struct chipcregs *) ai_switch_core(sih, CC_CORE_ID, &origidx,
 					    &intr_val);
 
 	/* update the pll changes */
@@ -327,7 +331,7 @@ void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 /* initialize PMU */
 void si_pmu_init(struct si_pub *sih)
 {
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx;
 
 	/* Remember original core before switch to chipc */
@@ -366,7 +370,7 @@ void si_pmu_swreg_init(struct si_pub *sih)
 /* initialize PLL */
 void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
 {
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx;
 
 	/* Remember original core before switch to chipc */
@@ -390,7 +394,7 @@ void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
 /* initialize PMU resources */
 void si_pmu_res_init(struct si_pub *sih)
 {
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx;
 	u32 min_mask = 0, max_mask = 0;
 
@@ -422,7 +426,7 @@ void si_pmu_res_init(struct si_pub *sih)
 
 u32 si_pmu_measure_alpclk(struct si_pub *sih)
 {
-	chipcregs_t *cc;
+	struct chipcregs *cc;
 	uint origidx;
 	u32 alp_khz;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 5d6fd09..6275160 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -373,18 +373,6 @@ struct tx_status;
 struct d11rxhdr;
 struct brcms_d11rxhdr;
 struct txpwr_limits;
-struct brcms_phy;
-
-typedef volatile struct intctrlregs intctrlregs_t;
-typedef volatile struct pio2regs pio2regs_t;
-typedef volatile struct pio2regp pio2regp_t;
-typedef volatile struct pio4regs pio4regs_t;
-typedef volatile struct pio4regp pio4regp_t;
-typedef volatile struct fifo64 fifo64_t;
-typedef volatile struct d11regs d11regs_t;
-typedef volatile struct dma32diag dma32diag_t;
-typedef volatile struct dma64regs dma64regs_t;
-typedef volatile union pmqreg pmqreg_t;
 
 /* brcm_msg_level is a bit vector with defs in defs.h */
 extern u32 brcm_msg_level;
diff --git a/drivers/staging/brcm80211/include/chipcommon.h b/drivers/staging/brcm80211/include/chipcommon.h
index 296582a..8de5913 100644
--- a/drivers/staging/brcm80211/include/chipcommon.h
+++ b/drivers/staging/brcm80211/include/chipcommon.h
@@ -19,7 +19,7 @@
 
 #include "defs.h"		/* for PAD macro */
 
-typedef volatile struct {
+struct chipcregs {
 	u32 chipid;		/* 0x0 */
 	u32 capabilities;
 	u32 corecontrol;	/* corerev >= 1 */
@@ -214,7 +214,7 @@ typedef volatile struct {
 	u32 pmu_xtalfreq;	/* 0x66C, pmurev >= 10 */
 	u32 PAD[100];
 	u16 sromotp[768];
-} chipcregs_t;
+};
 
 /* chipid */
 #define	CID_ID_MASK		0x0000ffff	/* Chip Id mask */
-- 
1.7.1


