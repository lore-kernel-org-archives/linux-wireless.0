Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1495 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389Ab1GEWDV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:21 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 11/31] staging: brcm80211: replaced various typedefs in
 softmac
Date: Wed, 6 Jul 2011 00:02:38 +0200
Message-ID: <1309903378-29021-12-git-send-email-arend@broadcom.com> (sfid-20110706_000342_069173_0CCE17F6)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

typedefs are undesirable according to documentation/CodingStyle.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  134 +++++-----
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |    2 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c         |   30 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |   73 +++---
 drivers/staging/brcm80211/brcmsmac/ampdu.h         |    2 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |    8 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c          |   20 +-
 drivers/staging/brcm80211/brcmsmac/bmac.h          |    2 +-
 drivers/staging/brcm80211/brcmsmac/channel.c       |  205 +++++++-------
 drivers/staging/brcm80211/brcmsmac/channel.h       |   15 +-
 drivers/staging/brcm80211/brcmsmac/d11.h           |    6 +-
 drivers/staging/brcm80211/brcmsmac/dma.c           |  300 ++++++++++----------
 drivers/staging/brcm80211/brcmsmac/dma.h           |    8 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |  117 ++++----
 drivers/staging/brcm80211/brcmsmac/main.h          |   61 +++--
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |  103 ++++----
 drivers/staging/brcm80211/brcmsmac/otp.c           |   45 ++--
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |   32 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h   |    6 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |   85 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  239 ++++++++--------
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     |  293 ++++++++++----------
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.c    |   29 +-
 .../staging/brcm80211/brcmsmac/phy/phytbl_lcn.h    |   28 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c  |   18 +-
 drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h  |    8 +-
 drivers/staging/brcm80211/brcmsmac/phy_shim.c      |   68 +++---
 drivers/staging/brcm80211/brcmsmac/phy_shim.h      |   64 ++--
 drivers/staging/brcm80211/brcmsmac/pub.h           |   21 +-
 drivers/staging/brcm80211/brcmsmac/rate.c          |   24 +-
 drivers/staging/brcm80211/brcmsmac/rate.h          |   58 ++--
 drivers/staging/brcm80211/brcmsmac/scb.h           |    5 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |   26 +-
 drivers/staging/brcm80211/brcmsmac/types.h         |   87 +-----
 36 files changed, 1110 insertions(+), 1116 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 2018664..a25901e 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -239,7 +239,7 @@
 /* resetctrl */
 #define	AIRC_RESET		1
 
-typedef volatile struct _aidmp {
+struct aidmp {
 	u32 oobselina30;	/* 0x000 */
 	u32 oobselina74;	/* 0x004 */
 	u32 PAD[6];
@@ -355,7 +355,7 @@ typedef volatile struct _aidmp {
 	u32 componentid1;	/* 0xff4 */
 	u32 componentid2;	/* 0xff8 */
 	u32 componentid3;	/* 0xffc */
-} aidmp_t;
+};
 
 /* EROM parsing */
 
@@ -429,14 +429,14 @@ get_asd(struct si_pub *sih, u32 **eromptr, uint sp, uint ad, uint st,
 	return asd;
 }
 
-static void ai_hwfixup(si_info_t *sii)
+static void ai_hwfixup(struct si_info *sii)
 {
 }
 
 /* parse the enumeration rom to identify all cores */
 void ai_scan(struct si_pub *sih, void *regs)
 {
-	si_info_t *sii = SI_INFO(sih);
+	struct si_info *sii = SI_INFO(sih);
 	chipcregs_t *cc = (chipcregs_t *) regs;
 	u32 erombase, *eromptr, *eromlim;
 
@@ -639,7 +639,7 @@ void ai_scan(struct si_pub *sih, void *regs)
  */
 void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 {
-	si_info_t *sii = SI_INFO(sih);
+	struct si_info *sii = SI_INFO(sih);
 	u32 addr = sii->coresba[coreidx];
 	u32 wrap = sii->wrapba[coreidx];
 	void *regs;
@@ -694,7 +694,7 @@ int ai_numaddrspaces(struct si_pub *sih)
 /* Return the address of the nth address space in the current core */
 u32 ai_addrspace(struct si_pub *sih, uint asidx)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	uint cidx;
 
 	sii = SI_INFO(sih);
@@ -713,7 +713,7 @@ u32 ai_addrspace(struct si_pub *sih, uint asidx)
 /* Return the size of the nth address space in the current core */
 u32 ai_addrspacesize(struct si_pub *sih, uint asidx)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	uint cidx;
 
 	sii = SI_INFO(sih);
@@ -731,8 +731,8 @@ u32 ai_addrspacesize(struct si_pub *sih, uint asidx)
 
 uint ai_flag(struct si_pub *sih)
 {
-	si_info_t *sii;
-	aidmp_t *ai;
+	struct si_info *sii;
+	struct aidmp *ai;
 
 	sii = SI_INFO(sih);
 	if (BCM47162_DMP()) {
@@ -750,7 +750,7 @@ void ai_setint(struct si_pub *sih, int siflag)
 
 uint ai_corevendor(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	u32 cia;
 
 	sii = SI_INFO(sih);
@@ -760,7 +760,7 @@ uint ai_corevendor(struct si_pub *sih)
 
 uint ai_corerev(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	u32 cib;
 
 	sii = SI_INFO(sih);
@@ -770,8 +770,8 @@ uint ai_corerev(struct si_pub *sih)
 
 bool ai_iscoreup(struct si_pub *sih)
 {
-	si_info_t *sii;
-	aidmp_t *ai;
+	struct si_info *sii;
+	struct aidmp *ai;
 
 	sii = SI_INFO(sih);
 	ai = sii->curwrap;
@@ -783,8 +783,8 @@ bool ai_iscoreup(struct si_pub *sih)
 
 void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val)
 {
-	si_info_t *sii;
-	aidmp_t *ai;
+	struct si_info *sii;
+	struct aidmp *ai;
 	u32 w;
 
 	sii = SI_INFO(sih);
@@ -805,8 +805,8 @@ void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val)
 
 u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
 {
-	si_info_t *sii;
-	aidmp_t *ai;
+	struct si_info *sii;
+	struct aidmp *ai;
 	u32 w;
 
 	sii = SI_INFO(sih);
@@ -828,8 +828,8 @@ u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
 
 u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 {
-	si_info_t *sii;
-	aidmp_t *ai;
+	struct si_info *sii;
+	struct aidmp *ai;
 	u32 w;
 
 	sii = SI_INFO(sih);
@@ -850,19 +850,19 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 
 /* *************** from siutils.c ************** */
 /* local prototypes */
-static si_info_t *ai_doattach(si_info_t *sii, void *regs,
+static struct si_info *ai_doattach(struct si_info *sii, void *regs,
 			      uint bustype, void *sdh, char **vars,
 			      uint *varsz);
-static bool ai_buscore_prep(si_info_t *sii, uint bustype);
-static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
+static bool ai_buscore_prep(struct si_info *sii, uint bustype);
+static bool ai_buscore_setup(struct si_info *sii, chipcregs_t *cc, uint bustype,
 			     u32 savewin, uint *origidx, void *regs);
-static void ai_nvram_process(si_info_t *sii, char *pvars);
+static void ai_nvram_process(struct si_info *sii, char *pvars);
 
 /* dev path concatenation util */
 static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
 			   const char *name);
-static bool _ai_clkctl_cc(si_info_t *sii, uint mode);
-static bool ai_ispcie(si_info_t *sii);
+static bool _ai_clkctl_cc(struct si_info *sii, uint mode);
+static bool ai_ispcie(struct si_info *sii);
 
 /* global variable to indicate reservation/release of gpio's */
 static u32 ai_gpioreservation;
@@ -879,10 +879,10 @@ static u32 ai_gpioreservation;
 struct si_pub *ai_attach(void *regs, uint bustype,
 		void *sdh, char **vars, uint *varsz)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
-	/* alloc si_info_t */
-	sii = kmalloc(sizeof(si_info_t), GFP_ATOMIC);
+	/* alloc struct si_info */
+	sii = kmalloc(sizeof(struct si_info), GFP_ATOMIC);
 	if (sii == NULL) {
 		SI_ERROR(("si_attach: malloc failed!\n"));
 		return NULL;
@@ -900,9 +900,9 @@ struct si_pub *ai_attach(void *regs, uint bustype,
 }
 
 /* global kernel resource */
-static si_info_t ksii;
+static struct si_info ksii;
 
-static bool ai_buscore_prep(si_info_t *sii, uint bustype)
+static bool ai_buscore_prep(struct si_info *sii, uint bustype)
 {
 	/* kludge to enable the clock on the 4306 which lacks a slowclock */
 	if (bustype == PCI_BUS && !ai_ispcie(sii))
@@ -910,7 +910,7 @@ static bool ai_buscore_prep(si_info_t *sii, uint bustype)
 	return true;
 }
 
-static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
+static bool ai_buscore_setup(struct si_info *sii, chipcregs_t *cc, uint bustype,
 			     u32 savewin, uint *origidx, void *regs)
 {
 	bool pci, pcie;
@@ -1019,7 +1019,7 @@ static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 	return true;
 }
 
-static __used void ai_nvram_process(si_info_t *sii, char *pvars)
+static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 {
 	uint w = 0;
 
@@ -1068,7 +1068,7 @@ static __used void ai_nvram_process(si_info_t *sii, char *pvars)
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
 }
 
-static si_info_t *ai_doattach(si_info_t *sii,
+static struct si_info *ai_doattach(struct si_info *sii,
 			      void *regs, uint bustype, void *pbus,
 			      char **vars, uint *varsz)
 {
@@ -1079,7 +1079,7 @@ static si_info_t *ai_doattach(si_info_t *sii,
 	uint socitype;
 	uint origidx;
 
-	memset((unsigned char *) sii, 0, sizeof(si_info_t));
+	memset((unsigned char *) sii, 0, sizeof(struct si_info));
 
 	savewin = 0;
 
@@ -1241,7 +1241,7 @@ static si_info_t *ai_doattach(si_info_t *sii,
 /* may be called with core in reset */
 void ai_detach(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	uint idx;
 
 	struct si_pub *si_local = NULL;
@@ -1275,7 +1275,7 @@ ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
 			  void *intrsrestore_fn,
 			  void *intrsenabled_fn, void *intr_arg)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 	sii->intr_arg = intr_arg;
@@ -1290,7 +1290,7 @@ ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
 
 void ai_deregister_intr_callback(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 	sii->intrsoff_fn = NULL;
@@ -1298,7 +1298,7 @@ void ai_deregister_intr_callback(struct si_pub *sih)
 
 uint ai_coreid(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 	return sii->coreid[sii->curidx];
@@ -1306,7 +1306,7 @@ uint ai_coreid(struct si_pub *sih)
 
 uint ai_coreidx(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 	return sii->curidx;
@@ -1320,7 +1320,7 @@ bool ai_backplane64(struct si_pub *sih)
 /* return index of coreid or BADIDX if not found */
 uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	uint found;
 	uint i;
 
@@ -1360,7 +1360,7 @@ void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 		     uint *intr_val)
 {
 	void *cc;
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -1384,7 +1384,7 @@ void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 /* restore coreidx and restore interrupt */
 void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 	if (SI_FAST(sii)
@@ -1397,7 +1397,7 @@ void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 
 void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val)
 {
-	si_info_t *sii = SI_INFO(sih);
+	struct si_info *sii = SI_INFO(sih);
 	u32 *w = (u32 *) sii->curwrap;
 	W_REG(w + (offset / 4), val);
 	return;
@@ -1421,7 +1421,7 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	uint w;
 	uint intr_val = 0;
 	bool fast = false;
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -1500,9 +1500,9 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 
 void ai_core_disable(struct si_pub *sih, u32 bits)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	u32 dummy;
-	aidmp_t *ai;
+	struct aidmp *ai;
 
 	sii = SI_INFO(sih);
 
@@ -1527,8 +1527,8 @@ void ai_core_disable(struct si_pub *sih, u32 bits)
  */
 void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits)
 {
-	si_info_t *sii;
-	aidmp_t *ai;
+	struct si_info *sii;
+	struct aidmp *ai;
 	u32 dummy;
 
 	sii = SI_INFO(sih);
@@ -1554,7 +1554,7 @@ void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits)
 }
 
 /* return the slow clock source - LPO, XTAL, or PCI */
-static uint ai_slowclk_src(si_info_t *sii)
+static uint ai_slowclk_src(struct si_info *sii)
 {
 	chipcregs_t *cc;
 	u32 val;
@@ -1578,7 +1578,7 @@ static uint ai_slowclk_src(si_info_t *sii)
 * return the ILP (slowclock) min or max frequency
 * precondition: we've established the chip has dynamic clk control
 */
-static uint ai_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
+static uint ai_slowclk_freq(struct si_info *sii, bool max_freq, chipcregs_t *cc)
 {
 	u32 slowclk;
 	uint div;
@@ -1612,7 +1612,7 @@ static uint ai_slowclk_freq(si_info_t *sii, bool max_freq, chipcregs_t *cc)
 	return 0;
 }
 
-static void ai_clkctl_setdelay(si_info_t *sii, void *chipcregs)
+static void ai_clkctl_setdelay(struct si_info *sii, void *chipcregs)
 {
 	chipcregs_t *cc = (chipcregs_t *) chipcregs;
 	uint slowmaxfreq, pll_delay, slowclk;
@@ -1644,7 +1644,7 @@ static void ai_clkctl_setdelay(si_info_t *sii, void *chipcregs)
 /* initialize power control delay registers */
 void ai_clkctl_init(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	uint origidx = 0;
 	chipcregs_t *cc;
 	bool fast;
@@ -1682,7 +1682,7 @@ void ai_clkctl_init(struct si_pub *sih)
  */
 u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	uint origidx = 0;
 	chipcregs_t *cc;
 	uint slowminfreq;
@@ -1730,7 +1730,7 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 /* turn primary xtal and/or pll off/on */
 int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	u32 in, out, outen;
 
 	sii = SI_INFO(sih);
@@ -1807,7 +1807,7 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
  */
 bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -1822,7 +1822,7 @@ bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 }
 
 /* clk control mechanism through chipcommon, no policy checking */
-static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
+static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 {
 	uint origidx = 0;
 	chipcregs_t *cc;
@@ -2001,7 +2001,7 @@ static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
 }
 
 /* return true if PCIE capability exists in the pci config space */
-static bool ai_ispcie(si_info_t *sii)
+static bool ai_ispcie(struct si_info *sii)
 {
 	u8 cap_ptr;
 
@@ -2019,7 +2019,7 @@ static bool ai_ispcie(si_info_t *sii)
 
 bool ai_pci_war16165(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -2028,7 +2028,7 @@ bool ai_pci_war16165(struct si_pub *sih)
 
 void ai_pci_up(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -2047,7 +2047,7 @@ void ai_pci_up(struct si_pub *sih)
 /* Unconfigure and/or apply various WARs when system is going to sleep mode */
 void ai_pci_sleep(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -2057,7 +2057,7 @@ void ai_pci_sleep(struct si_pub *sih)
 /* Unconfigure and/or apply various WARs when going down */
 void ai_pci_down(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -2078,7 +2078,7 @@ void ai_pci_down(struct si_pub *sih)
  */
 void ai_pci_setup(struct si_pub *sih, uint coremask)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	void *regs = NULL;
 	u32 siflag = 0, w;
 	uint idx = 0;
@@ -2130,7 +2130,7 @@ int ai_pci_fixcfg(struct si_pub *sih)
 	uint origidx;
 	void *regs = NULL;
 
-	si_info_t *sii = SI_INFO(sih);
+	struct si_info *sii = SI_INFO(sih);
 
 	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
 	/* save the current index */
@@ -2170,7 +2170,7 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 
 void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	chipcregs_t *cc;
 	uint origidx;
 	u32 val;
@@ -2204,7 +2204,7 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 /* Enable BT-COEX & Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih)
 {
-	si_info_t *sii;
+	struct si_info *sii;
 	chipcregs_t *cc;
 	uint origidx;
 
@@ -2224,7 +2224,7 @@ void ai_epa_4313war(struct si_pub *sih)
 bool ai_deviceremoved(struct si_pub *sih)
 {
 	u32 w;
-	si_info_t *sii;
+	struct si_info *sii;
 
 	sii = SI_INFO(sih);
 
@@ -2241,7 +2241,7 @@ bool ai_deviceremoved(struct si_pub *sih)
 bool ai_is_sprom_available(struct si_pub *sih)
 {
 	if (sih->ccrev >= 31) {
-		si_info_t *sii;
+		struct si_info *sii;
 		uint origidx;
 		chipcregs_t *cc;
 		u32 sromctrl;
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index b00780d..e245c27 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -278,7 +278,7 @@
 #define	BCM5357_CHIP_ID		0x5357	/* 5357 chipcommon chipid */
 
 
-#define	SI_INFO(sih)	((si_info_t *)sih)
+#define	SI_INFO(sih)	((struct si_info *)sih)
 
 #define	GOODCOREADDR(x, b) \
 	(((x) >= (b)) && ((x) < ((b) + SI_MAXCORES * SI_CORE_SIZE)) && \
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 34eafbe..62770b3 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -22,12 +22,12 @@
 
 static struct brcms_c_bsscfg *brcms_c_bsscfg_malloc(uint unit);
 static void brcms_c_bsscfg_mfree(struct brcms_c_bsscfg *cfg);
-static struct wlc_pub *brcms_c_pub_malloc(uint unit,
+static struct brcms_pub *brcms_c_pub_malloc(uint unit,
 				      uint *err, uint devid);
-static void brcms_c_pub_mfree(struct wlc_pub *pub);
-static void brcms_c_tunables_init(wlc_tunables_t *tunables, uint devid);
+static void brcms_c_pub_mfree(struct brcms_pub *pub);
+static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid);
 
-static void brcms_c_tunables_init(wlc_tunables_t *tunables, uint devid)
+static void brcms_c_tunables_init(struct brcms_tunables *tunables, uint devid)
 {
 	tunables->ntxd = NTXD;
 	tunables->nrxd = NRXD;
@@ -45,17 +45,17 @@ static void brcms_c_tunables_init(wlc_tunables_t *tunables, uint devid)
 	tunables->txsbnd = TXSBND;
 }
 
-static struct wlc_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
+static struct brcms_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
 {
-	struct wlc_pub *pub;
+	struct brcms_pub *pub;
 
-	pub = kzalloc(sizeof(struct wlc_pub), GFP_ATOMIC);
+	pub = kzalloc(sizeof(struct brcms_pub), GFP_ATOMIC);
 	if (pub == NULL) {
 		*err = 1001;
 		goto fail;
 	}
 
-	pub->tunables = kzalloc(sizeof(wlc_tunables_t), GFP_ATOMIC);
+	pub->tunables = kzalloc(sizeof(struct brcms_tunables), GFP_ATOMIC);
 	if (pub->tunables == NULL) {
 		*err = 1028;
 		goto fail;
@@ -77,7 +77,7 @@ static struct wlc_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
 	return NULL;
 }
 
-static void brcms_c_pub_mfree(struct wlc_pub *pub)
+static void brcms_c_pub_mfree(struct brcms_pub *pub)
 {
 	if (pub == NULL)
 		return;
@@ -95,7 +95,7 @@ static struct brcms_c_bsscfg *brcms_c_bsscfg_malloc(uint unit)
 	if (cfg == NULL)
 		goto fail;
 
-	cfg->current_bss = kzalloc(sizeof(wlc_bss_info_t), GFP_ATOMIC);
+	cfg->current_bss = kzalloc(sizeof(struct brcms_bss_info), GFP_ATOMIC);
 	if (cfg->current_bss == NULL)
 		goto fail;
 
@@ -175,7 +175,7 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		goto fail;
 	}
 
-	wlc->default_bss = kzalloc(sizeof(wlc_bss_info_t), GFP_ATOMIC);
+	wlc->default_bss = kzalloc(sizeof(struct brcms_bss_info), GFP_ATOMIC);
 	if (wlc->default_bss == NULL) {
 		*err = 1010;
 		goto fail;
@@ -189,16 +189,16 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	brcms_c_bsscfg_ID_assign(wlc, wlc->cfg);
 
 	wlc->wsec_def_keys[0] =
-		kzalloc(sizeof(wsec_key_t) * WLC_DEFAULT_KEYS, GFP_ATOMIC);
+		kzalloc(sizeof(struct wsec_key) * WLC_DEFAULT_KEYS, GFP_ATOMIC);
 	if (wlc->wsec_def_keys[0] == NULL) {
 		*err = 1015;
 		goto fail;
 	} else {
 		int i;
 		for (i = 1; i < WLC_DEFAULT_KEYS; i++) {
-			wlc->wsec_def_keys[i] = (wsec_key_t *)
+			wlc->wsec_def_keys[i] = (struct wsec_key *)
 			    ((unsigned long)wlc->wsec_def_keys[0] +
-			     (sizeof(wsec_key_t) * i));
+			     (sizeof(struct wsec_key) * i));
 		}
 	}
 
@@ -237,7 +237,7 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	}
 
 	wlc->corestate->macstat_snapshot =
-		kzalloc(sizeof(macstat_t), GFP_ATOMIC);
+		kzalloc(sizeof(struct macstat), GFP_ATOMIC);
 	if (wlc->corestate->macstat_snapshot == NULL) {
 		*err = 1027;
 		goto fail;
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 6271ad1..4060ee2 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -60,7 +60,7 @@
  * This allows to maintain a specific state independently of
  * how often and/or when the wlc counters are updated.
  */
-typedef struct wlc_fifo_info {
+struct brcms_fifo_info {
 	u16 ampdu_pld_size;	/* number of bytes to be pre-loaded */
 	u8 mcs2ampdu_table[FFPLD_MAX_MCS + 1];	/* per-mcs max # of mpdus in an ampdu */
 	u16 prev_txfunfl;	/* num of underflows last read from the HW macstats counter */
@@ -68,7 +68,7 @@ typedef struct wlc_fifo_info {
 	u32 accum_txampdu;	/* num of tx ampdu since we modified pld params  */
 	u32 prev_txampdu;	/* previous reading of tx ampdu */
 	u32 dmaxferrate;	/* estimated dma avg xfer rate in kbits/sec */
-} wlc_fifo_info_t;
+};
 
 /* AMPDU module specific state */
 struct ampdu_info {
@@ -94,7 +94,8 @@ struct ampdu_info {
 	u32 tx_max_funl;	/* underflows should be kept such that
 				 * (tx_max_funfl*underflows) < tx frames
 				 */
-	wlc_fifo_info_t fifo_tb[NUM_FFPLD_FIFO];	/* table of fifo infos  */
+	/* table of fifo infos */
+	struct brcms_fifo_info fifo_tb[NUM_FFPLD_FIFO];
 
 };
 
@@ -122,10 +123,12 @@ static void brcms_c_scb_ampdu_update_config_all(struct ampdu_info *ampdu);
 
 #define brcms_c_ampdu_txflowcontrol(a, b, c)	do {} while (0)
 
-static void brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu,
-					  struct scb *scb,
-					  struct sk_buff *p, tx_status_t *txs,
-					  u32 frmtxstatus, u32 frmtxstatus2);
+static void
+brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu,
+				  struct scb *scb,
+				  struct sk_buff *p, struct tx_status *txs,
+				  u32 frmtxstatus, u32 frmtxstatus2);
+
 static bool brcms_c_ampdu_cap(struct ampdu_info *ampdu);
 static int brcms_c_ampdu_set(struct ampdu_info *ampdu, bool on);
 
@@ -203,7 +206,7 @@ void brcms_c_ampdu_detach(struct ampdu_info *ampdu)
 static void brcms_c_scb_ampdu_update_config(struct ampdu_info *ampdu,
 					    struct scb *scb)
 {
-	scb_ampdu_t *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
+	struct scb_ampdu *scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
 	int i;
 
 	scb_ampdu->max_pdu = (u8) ampdu->wlc->pub->tunables->ampdunummpdu;
@@ -237,7 +240,7 @@ static void brcms_c_scb_ampdu_update_config_all(struct ampdu_info *ampdu)
 static void brcms_c_ffpld_init(struct ampdu_info *ampdu)
 {
 	int i, j;
-	wlc_fifo_info_t *fifo;
+	struct brcms_fifo_info *fifo;
 
 	for (j = 0; j < NUM_FFPLD_FIFO; j++) {
 		fifo = (ampdu->fifo_tb + j);
@@ -267,14 +270,14 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 	u32 current_ampdu_cnt = 0;
 	u16 max_pld_size;
 	u32 new_txunfl;
-	wlc_fifo_info_t *fifo = (ampdu->fifo_tb + fid);
+	struct brcms_fifo_info *fifo = (ampdu->fifo_tb + fid);
 	uint xmtfifo_sz;
 	u16 cur_txunfl;
 
 	/* return if we got here for a different reason than underflows */
-	cur_txunfl =
-	    brcms_c_read_shm(wlc,
-			 M_UCODE_MACSTAT + offsetof(macstat_t, txfunfl[fid]));
+	cur_txunfl = brcms_c_read_shm(wlc,
+				      M_UCODE_MACSTAT +
+				      offsetof(struct macstat, txfunfl[fid]));
 	new_txunfl = (u16) (cur_txunfl - fifo->prev_txfunfl);
 	if (new_txunfl == 0) {
 		BCMMSG(wlc->wiphy, "TX status FRAG set but no tx underflows\n");
@@ -381,7 +384,7 @@ static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 	int i;
 	u32 phy_rate, dma_rate, tmp;
 	u8 max_mpdu;
-	wlc_fifo_info_t *fifo = (ampdu->fifo_tb + f);
+	struct brcms_fifo_info *fifo = (ampdu->fifo_tb + f);
 
 	/* recompute the dma rate */
 	/* note : we divide/multiply by 100 to avoid integer overflows */
@@ -413,8 +416,8 @@ brcms_c_ampdu_tx_operational(struct brcms_c_info *wlc, u8 tid,
 	u8 ba_wsize,		/* negotiated ba window size (in pdu) */
 	uint max_rx_ampdu_bytes) /* from ht_cap in beacon */
 {
-	scb_ampdu_t *scb_ampdu;
-	scb_ampdu_tid_ini_t *ini;
+	struct scb_ampdu *scb_ampdu;
+	struct scb_ampdu_tid_ini *ini;
 	struct ampdu_info *ampdu = wlc->ampdu;
 	struct scb *scb = wlc->pub->global_scb;
 	scb_ampdu = SCB_AMPDU_CUBBY(ampdu, scb);
@@ -449,12 +452,12 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 	uint i, count = 0, fifo, seg_cnt = 0;
 	u16 plen, len, seq = 0, mcl, mch, index, frameid, dma_len = 0;
 	u32 ampdu_len, max_ampdu_bytes = 0;
-	d11txh_t *txh = NULL;
+	struct d11txh *txh = NULL;
 	u8 *plcp;
 	struct ieee80211_hdr *h;
 	struct scb *scb;
-	scb_ampdu_t *scb_ampdu;
-	scb_ampdu_tid_ini_t *ini;
+	struct scb_ampdu *scb_ampdu;
+	struct scb_ampdu_tid_ini *ini;
 	u8 mcs = 0;
 	bool use_rts = false, use_cts = false;
 	ratespec_t rspec = 0, rspec_fallback = 0;
@@ -462,7 +465,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 	u16 mimo_ctlchbw = PHY_TXC1_BW_20MHZ;
 	struct ieee80211_rts *rts;
 	u8 rr_retry_limit;
-	wlc_fifo_info_t *f;
+	struct brcms_fifo_info *f;
 	bool fbr_iscck;
 	struct ieee80211_tx_info *tx_info;
 	u16 qlen;
@@ -524,7 +527,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 		}
 
 		/* pkt is good to be aggregated */
-		txh = (d11txh_t *) p->data;
+		txh = (struct d11txh *) p->data;
 		plcp = (u8 *) (txh + 1);
 		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
 		seq = le16_to_cpu(h->seq_ctrl) >> SEQNUM_SHIFT;
@@ -701,7 +704,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 
 	if (count) {
 		/* patch up the last txh */
-		txh = (d11txh_t *) pkt[count - 1]->data;
+		txh = (struct d11txh *) pkt[count - 1]->data;
 		mcl = le16_to_cpu(txh->MacTxControlLow);
 		mcl &= ~TXC_AMPDU_MASK;
 		mcl |= (TXC_AMPDU_LAST << TXC_AMPDU_SHIFT);
@@ -719,7 +722,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 		ampdu_len -= roundup(len, 4) - len;
 
 		/* patch up the first txh & plcp */
-		txh = (d11txh_t *) pkt[0]->data;
+		txh = (struct d11txh *) pkt[0]->data;
 		plcp = (u8 *) (txh + 1);
 
 		WLC_SET_MIMO_PLCP_LEN(plcp, ampdu_len);
@@ -809,11 +812,11 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 
 void
 brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
-		     struct sk_buff *p, tx_status_t *txs)
+		     struct sk_buff *p, struct tx_status *txs)
 {
-	scb_ampdu_t *scb_ampdu;
+	struct scb_ampdu *scb_ampdu;
 	struct brcms_c_info *wlc = ampdu->wlc;
-	scb_ampdu_tid_ini_t *ini;
+	struct scb_ampdu_tid_ini *ini;
 	u32 s1 = 0, s2 = 0;
 	struct ieee80211_tx_info *tx_info;
 
@@ -845,11 +848,11 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 	} else {
 		/* loop through all pkts and free */
 		u8 queue = txs->frameid & TXFID_QUEUE_MASK;
-		d11txh_t *txh;
+		struct d11txh *txh;
 		u16 mcl;
 		while (p) {
 			tx_info = IEEE80211_SKB_CB(p);
-			txh = (d11txh_t *) p->data;
+			txh = (struct d11txh *) p->data;
 			mcl = le16_to_cpu(txh->MacTxControlLow);
 			brcmu_pkt_buf_free_skb(p);
 			/* break out if last packet of ampdu */
@@ -866,7 +869,7 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 static void
 brcms_c_ampdu_rate_status(struct brcms_c_info *wlc,
 			  struct ieee80211_tx_info *tx_info,
-			  tx_status_t *txs, u8 mcs)
+			  struct tx_status *txs, u8 mcs)
 {
 	struct ieee80211_tx_rate *txrate = tx_info->status.rates;
 	int i;
@@ -882,14 +885,14 @@ brcms_c_ampdu_rate_status(struct brcms_c_info *wlc,
 
 static void
 brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
-			      struct sk_buff *p, tx_status_t *txs,
+			      struct sk_buff *p, struct tx_status *txs,
 			      u32 s1, u32 s2)
 {
-	scb_ampdu_t *scb_ampdu;
+	struct scb_ampdu *scb_ampdu;
 	struct brcms_c_info *wlc = ampdu->wlc;
-	scb_ampdu_tid_ini_t *ini;
+	struct scb_ampdu_tid_ini *ini;
 	u8 bitmap[8], queue, tid;
-	d11txh_t *txh;
+	struct d11txh *txh;
 	u8 *plcp;
 	struct ieee80211_hdr *h;
 	u16 seq, start_seq = 0, bindex, index, mcl;
@@ -982,7 +985,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 
 			if (WL_ERROR_ON()) {
 				brcmu_prpkt("txpkt (AMPDU)", p);
-				brcms_c_print_txdesc((d11txh_t *) p->data);
+				brcms_c_print_txdesc((struct d11txh *) p->data);
 			}
 			brcms_c_print_txstatus(txs);
 		}
@@ -991,7 +994,7 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	/* loop through all pkts and retry if not acked */
 	while (p) {
 		tx_info = IEEE80211_SKB_CB(p);
-		txh = (d11txh_t *) p->data;
+		txh = (struct d11txh *) p->data;
 		mcl = le16_to_cpu(txh->MacTxControlLow);
 		plcp = (u8 *) (txh + 1);
 		h = (struct ieee80211_hdr *)(plcp + D11_PHY_HDR_LEN);
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.h b/drivers/staging/brcm80211/brcmsmac/ampdu.h
index 5fba4ae..07b53fc 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.h
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.h
@@ -23,7 +23,7 @@ extern int brcms_c_sendampdu(struct ampdu_info *ampdu,
 			     struct brcms_c_txq_info *qi,
 			     struct sk_buff **aggp, int prec);
 extern void brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
-				 struct sk_buff *p, tx_status_t *txs);
+				 struct sk_buff *p, struct tx_status *txs);
 extern void brcms_c_ampdu_macaddr_upd(struct brcms_c_info *wlc);
 extern void brcms_c_ampdu_shm_upd(struct ampdu_info *ampdu);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 2cfda7f..e93d8ae 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -51,11 +51,11 @@
 
 /* static functions */
 static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
-				 wlc_antselcfg_t *antsel);
+				 struct brcms_antselcfg *antsel);
 static u8 brcms_c_antsel_id2antcfg(struct antsel_info *asi, u8 id);
 static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg);
 static void brcms_c_antsel_init_cfg(struct antsel_info *asi,
-				wlc_antselcfg_t *antsel,
+				struct brcms_antselcfg *antsel,
 				bool auto_sel);
 
 const u16 mimo_2x4_div_antselpat_tbl[] = {
@@ -160,7 +160,7 @@ void brcms_c_antsel_init(struct antsel_info *asi)
 
 /* boardlevel antenna selection: init antenna selection structure */
 static void
-brcms_c_antsel_init_cfg(struct antsel_info *asi, wlc_antselcfg_t *antsel,
+brcms_c_antsel_init_cfg(struct antsel_info *asi, struct brcms_antselcfg *antsel,
 		    bool auto_sel)
 {
 	if (asi->antsel_type == ANTSEL_2x3) {
@@ -282,7 +282,7 @@ static u16 brcms_c_antsel_antcfg2antsel(struct antsel_info *asi, u8 ant_cfg)
 
 /* boardlevel antenna selection: ucode interface control */
 static int brcms_c_antsel_cfgupd(struct antsel_info *asi,
-				 wlc_antselcfg_t *antsel)
+				 struct brcms_antselcfg *antsel)
 {
 	struct brcms_c_info *wlc = asi->wlc;
 	u8 ant_cfg;
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 4a220d4..b506d16 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -83,8 +83,8 @@ static void brcms_ucode_download(struct brcms_c_hw_info *wlc);
 static void brcms_c_ucode_txant_set(struct brcms_c_hw_info *wlc_hw);
 
 /* used by brcms_c_dpc() */
-static bool brcms_b_dotxstatus(struct brcms_c_hw_info *wlc, tx_status_t *txs,
-				u32 s2);
+static bool brcms_b_dotxstatus(struct brcms_c_hw_info *wlc,
+			       struct tx_status *txs, u32 s2);
 static bool brcms_b_txstatus(struct brcms_c_hw_info *wlc, bool bound,
 			     bool *fatal);
 static bool brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound);
@@ -246,7 +246,7 @@ brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound)
 	struct sk_buff *tail = NULL;
 	uint n = 0;
 	uint bound_limit = bound ? wlc_hw->wlc->pub->tunables->rxbnd : -1;
-	wlc_d11rxhdr_t *wlc_rxhdr = NULL;
+	struct brcms_d11rxhdr *wlc_rxhdr = NULL;
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 	/* gather received frames */
@@ -272,7 +272,7 @@ brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound)
 		head = head->prev;
 		p->prev = NULL;
 
-		wlc_rxhdr = (wlc_d11rxhdr_t *) p->data;
+		wlc_rxhdr = (struct brcms_d11rxhdr *) p->data;
 
 		/* compute the RSSI from d11rxhdr and record it in wlc_rxd11hr */
 		wlc_phy_rssi_compute(wlc_hw->band->pi, wlc_rxhdr);
@@ -457,7 +457,8 @@ brcms_b_set_chanspec(struct brcms_c_hw_info *wlc_hw, chanspec_t chanspec,
 	}
 }
 
-int brcms_b_state_get(struct brcms_c_hw_info *wlc_hw, brcms_b_state_t *state)
+int brcms_b_state_get(struct brcms_c_hw_info *wlc_hw,
+		      struct brcms_b_state *state)
 {
 	state->machwcap = wlc_hw->machwcap;
 
@@ -472,7 +473,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	u16 pio_mhf2 = 0;
 	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	uint unit = wlc_hw->unit;
-	wlc_tunables_t *tune = wlc->pub->tunables;
+	struct brcms_tunables *tune = wlc->pub->tunables;
 	struct wiphy *wiphy = wlc->wiphy;
 
 	/* name and offsets for dma_attach */
@@ -589,7 +590,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	uint err = 0;
 	uint j;
 	bool wme = false;
-	shared_phy_params_t sha_params;
+	struct shared_phy_params sha_params;
 	struct wiphy *wiphy = wlc->wiphy;
 
 	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
@@ -2959,7 +2960,8 @@ bool brcms_c_isr(struct brcms_c_info *wlc, bool *wantdpc)
 }
 
 static bool
-brcms_b_dotxstatus(struct brcms_c_hw_info *wlc_hw, tx_status_t *txs, u32 s2)
+brcms_b_dotxstatus(struct brcms_c_hw_info *wlc_hw, struct tx_status *txs,
+		   u32 s2)
 {
 	/* discard intermediate indications for ucode with one legitimate case:
 	 *   e.g. if "useRTS" is set. ucode did a successful rts/cts exchange, but the subsequent
@@ -2983,7 +2985,7 @@ brcms_b_txstatus(struct brcms_c_hw_info *wlc_hw, bool bound, bool *fatal)
 	bool morepending = false;
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 	d11regs_t *regs;
-	tx_status_t txstatus, *txs;
+	struct tx_status txstatus, *txs;
 	u32 s1, s2;
 	uint n = 0;
 	/*
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
index 3a1ee78..af4afa9 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.h
@@ -119,7 +119,7 @@ extern u16 brcms_b_get_txant(struct brcms_c_hw_info *wlc_hw);
 extern void brcms_b_antsel_type_set(struct brcms_c_hw_info *wlc_hw,
 				     u8 antsel_type);
 extern int brcms_b_state_get(struct brcms_c_hw_info *wlc_hw,
-			      brcms_b_state_t *state);
+			      struct brcms_b_state *state);
 extern void brcms_b_write_shm(struct brcms_c_hw_info *wlc_hw, uint offset,
 			      u16 v);
 extern u16 brcms_b_read_shm(struct brcms_c_hw_info *wlc_hw, uint offset);
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 6b28a35..6cf8ca1 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -30,69 +30,77 @@
 	brcms_c_valid_channel20_in_band((wlc)->cmi, bandunit, val)
 #define	VALID_CHANNEL20(wlc, val) brcms_c_valid_channel20((wlc)->cmi, val)
 
-typedef struct wlc_cm_band {
-	u8 locale_flags;	/* locale_info_t flags */
+struct brcms_cm_band {
+	u8 locale_flags;	/* struct locale_info flags */
 	chanvec_t valid_channels;	/* List of valid channels in the country */
 	const chanvec_t *restricted_channels;	/* List of restricted use channels */
 	const chanvec_t *radar_channels;	/* List of radar sensitive channels */
 	u8 PAD[8];
-} wlc_cm_band_t;
+};
 
-struct wlc_cm_info {
-	struct wlc_pub *pub;
+struct brcms_cm_info {
+	struct brcms_pub *pub;
 	struct brcms_c_info *wlc;
 	char srom_ccode[WLC_CNTRY_BUF_SZ];	/* Country Code in SROM */
 	uint srom_regrev;	/* Regulatory Rev for the SROM ccode */
-	const country_info_t *country;	/* current country def */
+	const struct country_info *country;	/* current country def */
 	char ccode[WLC_CNTRY_BUF_SZ];	/* current internal Country Code */
 	uint regrev;		/* current Regulatory Revision */
 	char country_abbrev[WLC_CNTRY_BUF_SZ];	/* current advertised ccode */
-	wlc_cm_band_t bandstate[MAXBANDS];	/* per-band state (one per phy/radio) */
+	/* per-band state (one per phy/radio) */
+	struct brcms_cm_band bandstate[MAXBANDS];
 	/* quiet channels currently for radar sensitivity or 11h support */
 	chanvec_t quiet_channels;	/* channels on which we cannot transmit */
 };
 
-static int brcms_c_channels_init(wlc_cm_info_t *wlc_cm,
-			     const country_info_t *country);
-static void brcms_c_set_country_common(wlc_cm_info_t *wlc_cm,
+static int brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
+			     const struct country_info *country);
+static void brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 				   const char *country_abbrev,
 				   const char *ccode, uint regrev,
-				   const country_info_t *country);
-static int brcms_c_set_countrycode(wlc_cm_info_t *wlc_cm, const char *ccode);
-static int brcms_c_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
+				   const struct country_info *country);
+static int brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm,
+				   const char *ccode);
+static int brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
 				   const char *country_abbrev,
 				   const char *ccode, int regrev);
-static int brcms_c_country_aggregate_map(wlc_cm_info_t *wlc_cm,
+static int brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm,
 				const char *ccode,
 				char *mapped_ccode, uint *mapped_regrev);
-static const country_info_t *brcms_c_country_lookup_direct(const char *ccode,
-						       uint regrev);
-static const country_info_t *brcms_c_countrycode_map(wlc_cm_info_t *wlc_cm,
-						 const char *ccode,
-						 char *mapped_ccode,
-						 uint *mapped_regrev);
-static void brcms_c_channels_commit(wlc_cm_info_t *wlc_cm);
-static void brcms_c_quiet_channels_reset(wlc_cm_info_t *wlc_cm);
-static bool brcms_c_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec);
-static bool brcms_c_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val);
-static bool brcms_c_valid_channel20_in_band(wlc_cm_info_t *wlc_cm,
+
+static const struct country_info *
+brcms_c_country_lookup_direct(const char *ccode, uint regrev);
+
+static const struct country_info *
+brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm,
+			const char *ccode, char *mapped_ccode,
+			uint *mapped_regrev);
+
+static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm);
+static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm);
+static bool brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm,
+				   chanspec_t chspec);
+static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val);
+static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
 					    uint bandunit, uint val);
-static bool brcms_c_valid_channel20(wlc_cm_info_t *wlc_cm, uint val);
-static const country_info_t *brcms_c_country_lookup(struct brcms_c_info *wlc,
-						const char *ccode);
-static void brcms_c_locale_get_channels(const locale_info_t *locale,
+static bool brcms_c_valid_channel20(struct brcms_cm_info *wlc_cm, uint val);
+
+static const struct country_info *
+brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode);
+
+static void brcms_c_locale_get_channels(const struct locale_info *locale,
 				    chanvec_t *valid_channels);
-static const locale_info_t *brcms_c_get_locale_2g(u8 locale_idx);
-static const locale_info_t *brcms_c_get_locale_5g(u8 locale_idx);
+static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx);
+static const struct locale_info *brcms_c_get_locale_5g(u8 locale_idx);
 static bool brcms_c_japan(struct brcms_c_info *wlc);
 static bool brcms_c_japan_ccode(const char *ccode);
 static void brcms_c_channel_min_txpower_limits_with_local_constraint(
-	wlc_cm_info_t *wlc_cm, struct txpwr_limits *txpwr,
+	struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
 	u8 local_constraint_qdbm);
 static void brcms_c_locale_add_channels(chanvec_t *target,
 				    const chanvec_t *channels);
-static const locale_mimo_info_t *brcms_c_get_mimo_2g(u8 locale_idx);
-static const locale_mimo_info_t *brcms_c_get_mimo_5g(u8 locale_idx);
+static const struct locale_mimo_info *brcms_c_get_mimo_2g(u8 locale_idx);
+static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx);
 
 /* QDB() macro takes a dB value and converts to a quarter dB value */
 #ifdef QDB
@@ -389,7 +397,7 @@ static void brcms_c_locale_add_channels(chanvec_t *target,
 	}
 }
 
-static void brcms_c_locale_get_channels(const locale_info_t *locale,
+static void brcms_c_locale_get_channels(const struct locale_info *locale,
 				    chanvec_t *channels)
 {
 	u8 i;
@@ -407,7 +415,7 @@ static void brcms_c_locale_get_channels(const locale_info_t *locale,
 /*
  * Locale Definitions - 2.4 GHz
  */
-static const locale_info_t locale_i = {	/* locale i. channel 1 - 13 */
+static const struct locale_info locale_i = {	/* locale i. channel 1 - 13 */
 	LOCALE_CHAN_01_11 | LOCALE_CHAN_12_13,
 	LOCALE_RADAR_SET_NONE,
 	LOCALE_RESTRICTED_SET_2G_SHORT,
@@ -420,7 +428,7 @@ static const locale_info_t locale_i = {	/* locale i. channel 1 - 13 */
 /*
  * Locale Definitions - 5 GHz
  */
-static const locale_info_t locale_11 = {
+static const struct locale_info locale_11 = {
 	/* locale 11. channel 36 - 48, 52 - 64, 100 - 140, 149 - 165 */
 	LOCALE_CHAN_36_64 | LOCALE_CHAN_100_140 | LOCALE_CHAN_149_165,
 	LOCALE_RADAR_SET_1,
@@ -431,19 +439,19 @@ static const locale_info_t locale_11 = {
 };
 
 #define LOCALE_2G_IDX_i			0
-static const locale_info_t *g_locale_2g_table[] = {
+static const struct locale_info *g_locale_2g_table[] = {
 	&locale_i
 };
 
 #define LOCALE_5G_IDX_11	0
-static const locale_info_t *g_locale_5g_table[] = {
+static const struct locale_info *g_locale_5g_table[] = {
 	&locale_11
 };
 
 /*
  * MIMO Locale Definitions - 2.4 GHz
  */
-static const locale_mimo_info_t locale_bn = {
+static const struct locale_mimo_info locale_bn = {
 	{QDB(13), QDB(13), QDB(13), QDB(13), QDB(13),
 	 QDB(13), QDB(13), QDB(13), QDB(13), QDB(13),
 	 QDB(13), QDB(13), QDB(13)},
@@ -456,21 +464,21 @@ static const locale_mimo_info_t locale_bn = {
 /* locale mimo 2g indexes */
 #define LOCALE_MIMO_IDX_bn			0
 
-static const locale_mimo_info_t *g_mimo_2g_table[] = {
+static const struct locale_mimo_info *g_mimo_2g_table[] = {
 	&locale_bn
 };
 
 /*
  * MIMO Locale Definitions - 5 GHz
  */
-static const locale_mimo_info_t locale_11n = {
+static const struct locale_mimo_info locale_11n = {
 	{ /* 12.5 dBm */ 50, 50, 50, QDB(15), QDB(15)},
 	{QDB(14), QDB(15), QDB(15), QDB(15), QDB(15)},
 	0
 };
 
 #define LOCALE_MIMO_IDX_11n			0
-static const locale_mimo_info_t *g_mimo_5g_table[] = {
+static const struct locale_mimo_info *g_mimo_5g_table[] = {
 	&locale_11n
 };
 
@@ -493,7 +501,7 @@ static const locale_mimo_info_t *g_mimo_5g_table[] = {
 
 static const struct {
 	char abbrev[WLC_CNTRY_BUF_SZ];	/* country abbreviation */
-	country_info_t country;
+	struct country_info country;
 } cntry_locales[] = {
 	{
 	"X2", LOCALES(i, 11, bn, 11n)},	/* Worldwide RoW 2 */
@@ -576,7 +584,7 @@ struct chan20_info chan20_info[] = {
 };
 #endif				/* SUPPORT_40MHZ */
 
-static const locale_info_t *brcms_c_get_locale_2g(u8 locale_idx)
+static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table)) {
 		return NULL; /* error condition */
@@ -584,7 +592,7 @@ static const locale_info_t *brcms_c_get_locale_2g(u8 locale_idx)
 	return g_locale_2g_table[locale_idx];
 }
 
-static const locale_info_t *brcms_c_get_locale_5g(u8 locale_idx)
+static const struct locale_info *brcms_c_get_locale_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table)) {
 		return NULL; /* error condition */
@@ -592,7 +600,7 @@ static const locale_info_t *brcms_c_get_locale_5g(u8 locale_idx)
 	return g_locale_5g_table[locale_idx];
 }
 
-static const locale_mimo_info_t *brcms_c_get_mimo_2g(u8 locale_idx)
+static const struct locale_mimo_info *brcms_c_get_mimo_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table)) {
 		return NULL;
@@ -600,7 +608,7 @@ static const locale_mimo_info_t *brcms_c_get_mimo_2g(u8 locale_idx)
 	return g_mimo_2g_table[locale_idx];
 }
 
-static const locale_mimo_info_t *brcms_c_get_mimo_5g(u8 locale_idx)
+static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_mimo_5g_table)) {
 		return NULL;
@@ -608,17 +616,17 @@ static const locale_mimo_info_t *brcms_c_get_mimo_5g(u8 locale_idx)
 	return g_mimo_5g_table[locale_idx];
 }
 
-wlc_cm_info_t *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
+struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 {
-	wlc_cm_info_t *wlc_cm;
+	struct brcms_cm_info *wlc_cm;
 	char country_abbrev[WLC_CNTRY_BUF_SZ];
-	const country_info_t *country;
-	struct wlc_pub *pub = wlc->pub;
+	const struct country_info *country;
+	struct brcms_pub *pub = wlc->pub;
 	char *ccode;
 
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
-	wlc_cm = kzalloc(sizeof(wlc_cm_info_t), GFP_ATOMIC);
+	wlc_cm = kzalloc(sizeof(struct brcms_cm_info), GFP_ATOMIC);
 	if (wlc_cm == NULL) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: out of memory", pub->unit,
 			  __func__);
@@ -650,12 +658,14 @@ wlc_cm_info_t *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 	return wlc_cm;
 }
 
-void brcms_c_channel_mgr_detach(wlc_cm_info_t *wlc_cm)
+void brcms_c_channel_mgr_detach(struct brcms_cm_info *wlc_cm)
 {
 	kfree(wlc_cm);
 }
 
-u8 brcms_c_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm, uint bandunit)
+u8
+brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
+				     uint bandunit)
 {
 	return wlc_cm->bandstate[bandunit].locale_flags;
 }
@@ -663,7 +673,8 @@ u8 brcms_c_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm, uint bandunit)
 /* set the driver's current country and regulatory information using a country code
  * as the source. Lookup built in country information found with the country code.
  */
-static int brcms_c_set_countrycode(wlc_cm_info_t *wlc_cm, const char *ccode)
+static int
+brcms_c_set_countrycode(struct brcms_cm_info *wlc_cm, const char *ccode)
 {
 	char country_abbrev[WLC_CNTRY_BUF_SZ];
 	strncpy(country_abbrev, ccode, WLC_CNTRY_BUF_SZ);
@@ -671,11 +682,11 @@ static int brcms_c_set_countrycode(wlc_cm_info_t *wlc_cm, const char *ccode)
 }
 
 static int
-brcms_c_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
+brcms_c_set_countrycode_rev(struct brcms_cm_info *wlc_cm,
 			const char *country_abbrev,
 			const char *ccode, int regrev)
 {
-	const country_info_t *country;
+	const struct country_info *country;
 	char mapped_ccode[WLC_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
@@ -708,13 +719,13 @@ brcms_c_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
  * as the source. Look up built in country information found with the country code.
  */
 static void
-brcms_c_set_country_common(wlc_cm_info_t *wlc_cm,
+brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 		       const char *country_abbrev,
 		       const char *ccode, uint regrev,
-		       const country_info_t *country)
+		       const struct country_info *country)
 {
-	const locale_mimo_info_t *li_mimo;
-	const locale_info_t *locale;
+	const struct locale_mimo_info *li_mimo;
+	const struct locale_info *locale;
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	char prev_country_abbrev[WLC_CNTRY_BUF_SZ];
 
@@ -758,10 +769,10 @@ brcms_c_set_country_common(wlc_cm_info_t *wlc_cm,
 /* Lookup a country info structure from a null terminated country code
  * The lookup is case sensitive.
  */
-static const country_info_t *brcms_c_country_lookup(struct brcms_c_info *wlc,
-					 const char *ccode)
+static const struct country_info *
+brcms_c_country_lookup(struct brcms_c_info *wlc, const char *ccode)
 {
-	const country_info_t *country;
+	const struct country_info *country;
 	char mapped_ccode[WLC_CNTRY_BUF_SZ];
 	uint mapped_regrev;
 
@@ -772,13 +783,12 @@ static const country_info_t *brcms_c_country_lookup(struct brcms_c_info *wlc,
 	return country;
 }
 
-static const country_info_t *brcms_c_countrycode_map(wlc_cm_info_t *wlc_cm,
-						 const char *ccode,
-						 char *mapped_ccode,
-						 uint *mapped_regrev)
+static const struct country_info *
+brcms_c_countrycode_map(struct brcms_cm_info *wlc_cm, const char *ccode,
+			char *mapped_ccode, uint *mapped_regrev)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
-	const country_info_t *country;
+	const struct country_info *country;
 	uint srom_regrev = wlc_cm->srom_regrev;
 	const char *srom_ccode = wlc_cm->srom_ccode;
 	int mapped;
@@ -822,7 +832,7 @@ static const country_info_t *brcms_c_countrycode_map(wlc_cm_info_t *wlc_cm,
 }
 
 static int
-brcms_c_country_aggregate_map(wlc_cm_info_t *wlc_cm, const char *ccode,
+brcms_c_country_aggregate_map(struct brcms_cm_info *wlc_cm, const char *ccode,
 			  char *mapped_ccode, uint *mapped_regrev)
 {
 	return false;
@@ -831,8 +841,8 @@ brcms_c_country_aggregate_map(wlc_cm_info_t *wlc_cm, const char *ccode,
 /* Lookup a country info structure from a null terminated country
  * abbreviation and regrev directly with no translation.
  */
-static const country_info_t *brcms_c_country_lookup_direct(const char *ccode,
-						       uint regrev)
+static const struct country_info *
+brcms_c_country_lookup_direct(const char *ccode, uint regrev)
 {
 	uint size, i;
 
@@ -854,14 +864,15 @@ static const country_info_t *brcms_c_country_lookup_direct(const char *ccode,
 }
 
 static int
-brcms_c_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
+brcms_c_channels_init(struct brcms_cm_info *wlc_cm,
+		      const struct country_info *country)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
 	struct brcms_c_band *band;
-	const locale_info_t *li;
+	const struct locale_info *li;
 	chanvec_t sup_chan;
-	const locale_mimo_info_t *li_mimo;
+	const struct locale_mimo_info *li_mimo;
 
 	band = wlc->band;
 	for (i = 0; i < NBANDS(wlc);
@@ -906,7 +917,7 @@ brcms_c_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 /* Update the radio state (enable/disable) and tx power targets
  * based on a new set of channel/regulatory information
  */
-static void brcms_c_channels_commit(wlc_cm_info_t *wlc_cm)
+static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint chan;
@@ -955,7 +966,7 @@ static void brcms_c_channels_commit(wlc_cm_info_t *wlc_cm)
 }
 
 /* reset the quiet channels vector to the union of the restricted and radar channel sets */
-static void brcms_c_quiet_channels_reset(wlc_cm_info_t *wlc_cm)
+static void brcms_c_quiet_channels_reset(struct brcms_cm_info *wlc_cm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i, j;
@@ -976,7 +987,8 @@ static void brcms_c_quiet_channels_reset(wlc_cm_info_t *wlc_cm)
 	}
 }
 
-static bool brcms_c_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
+static bool
+brcms_c_quiet_chanspec(struct brcms_cm_info *wlc_cm, chanspec_t chspec)
 {
 	return N_ENAB(wlc_cm->wlc->pub) && CHSPEC_IS40(chspec) ?
 		(isset
@@ -993,7 +1005,7 @@ static bool brcms_c_quiet_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
 /* Is the channel valid for the current locale? (but don't consider channels not
  *   available due to bandlocking)
  */
-static bool brcms_c_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val)
+static bool brcms_c_valid_channel20_db(struct brcms_cm_info *wlc_cm, uint val)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 
@@ -1003,15 +1015,15 @@ static bool brcms_c_valid_channel20_db(wlc_cm_info_t *wlc_cm, uint val)
 }
 
 /* Is the channel valid for the current locale and specified band? */
-static bool
-brcms_c_valid_channel20_in_band(wlc_cm_info_t *wlc_cm, uint bandunit, uint val)
+static bool brcms_c_valid_channel20_in_band(struct brcms_cm_info *wlc_cm,
+					    uint bandunit, uint val)
 {
 	return ((val < MAXCHANNEL)
 		&& isset(wlc_cm->bandstate[bandunit].valid_channels.vec, val));
 }
 
 /* Is the channel valid for the current locale and current band? */
-static bool brcms_c_valid_channel20(wlc_cm_info_t *wlc_cm, uint val)
+static bool brcms_c_valid_channel20(struct brcms_cm_info *wlc_cm, uint val)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 
@@ -1021,10 +1033,9 @@ static bool brcms_c_valid_channel20(wlc_cm_info_t *wlc_cm, uint val)
 }
 
 static void
-brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *wlc_cm,
-						     struct txpwr_limits *txpwr,
-						     u8
-						     local_constraint_qdbm)
+brcms_c_channel_min_txpower_limits_with_local_constraint(
+		struct brcms_cm_info *wlc_cm, struct txpwr_limits *txpwr,
+		u8 local_constraint_qdbm)
 {
 	int j;
 
@@ -1108,7 +1119,7 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(wlc_cm_info_t *wlc_cm,
 }
 
 void
-brcms_c_channel_set_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
+brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
 			 u8 local_constraint_qdbm)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -1125,7 +1136,7 @@ brcms_c_channel_set_chanspec(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
 }
 
 #ifdef POWER_DBG
-static void wlc_phy_txpower_limits_dump(txpwr_limits_t *txpwr)
+static void wlc_phy_txpower_limits_dump(struct txpwr_limits *txpwr)
 {
 	int i;
 	char buf[80];
@@ -1242,25 +1253,25 @@ static void wlc_phy_txpower_limits_dump(txpwr_limits_t *txpwr)
 #endif				/* POWER_DBG */
 
 void
-brcms_c_channel_reg_limits(wlc_cm_info_t *wlc_cm, chanspec_t chanspec,
-		       txpwr_limits_t *txpwr)
+brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, chanspec_t chanspec,
+		       struct txpwr_limits *txpwr)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
 	uint i;
 	uint chan;
 	int maxpwr;
 	int delta;
-	const country_info_t *country;
+	const struct country_info *country;
 	struct brcms_c_band *band;
-	const locale_info_t *li;
+	const struct locale_info *li;
 	int conducted_max;
 	int conducted_ofdm_max;
-	const locale_mimo_info_t *li_mimo;
+	const struct locale_mimo_info *li_mimo;
 	int maxpwr20, maxpwr40;
 	int maxpwr_idx;
 	uint j;
 
-	memset(txpwr, 0, sizeof(txpwr_limits_t));
+	memset(txpwr, 0, sizeof(struct txpwr_limits));
 
 	if (!brcms_c_valid_chanspec_db(wlc_cm, chanspec)) {
 		country = brcms_c_country_lookup(wlc, wlc->autocountry_default);
@@ -1472,7 +1483,7 @@ static bool brcms_c_japan_ccode(const char *ccode)
  * are valid 20MZH channels in this locale and they are also a legal HT combination
  */
 static bool
-brcms_c_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec,
+brcms_c_valid_chanspec_ext(struct brcms_cm_info *wlc_cm, chanspec_t chspec,
 			   bool dualband)
 {
 	struct brcms_c_info *wlc = wlc_cm->wlc;
@@ -1534,7 +1545,7 @@ brcms_c_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec,
 	return false;
 }
 
-bool brcms_c_valid_chanspec_db(wlc_cm_info_t *wlc_cm, chanspec_t chspec)
+bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm, chanspec_t chspec)
 {
 	return brcms_c_valid_chanspec_ext(wlc_cm, chspec, true);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.h b/drivers/staging/brcm80211/brcmsmac/channel.h
index 6fe8050..ff7123c 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.h
+++ b/drivers/staging/brcm80211/brcmsmac/channel.h
@@ -103,18 +103,21 @@ struct country_info {
 	const u8 locale_mimo_5G;	/* 5G mimo info */
 };
 
-extern wlc_cm_info_t *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc);
-extern void brcms_c_channel_mgr_detach(wlc_cm_info_t *wlc_cm);
+extern struct brcms_cm_info *
+brcms_c_channel_mgr_attach(struct brcms_c_info *wlc);
 
-extern u8 brcms_c_channel_locale_flags_in_band(wlc_cm_info_t *wlc_cm,
+extern void brcms_c_channel_mgr_detach(struct brcms_cm_info *wlc_cm);
+
+extern u8 brcms_c_channel_locale_flags_in_band(struct brcms_cm_info *wlc_cm,
 					   uint bandunit);
 
-extern bool brcms_c_valid_chanspec_db(wlc_cm_info_t *wlc_cm, chanspec_t chspec);
+extern bool brcms_c_valid_chanspec_db(struct brcms_cm_info *wlc_cm,
+				      chanspec_t chspec);
 
-extern void brcms_c_channel_reg_limits(wlc_cm_info_t *wlc_cm,
+extern void brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm,
 				   chanspec_t chanspec,
 				   struct txpwr_limits *txpwr);
-extern void brcms_c_channel_set_chanspec(wlc_cm_info_t *wlc_cm,
+extern void brcms_c_channel_set_chanspec(struct brcms_cm_info *wlc_cm,
 				     chanspec_t chanspec,
 				     u8 local_constraint_qdbm);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/d11.h b/drivers/staging/brcm80211/brcmsmac/d11.h
index bb8bb38..37629bf 100644
--- a/drivers/staging/brcm80211/brcmsmac/d11.h
+++ b/drivers/staging/brcm80211/brcmsmac/d11.h
@@ -1308,11 +1308,11 @@ struct d11rxhdr {
 	u16 RxChan;		/* gain code, channel radio code, and phy type */
 } __attribute__((packed));
 
-#define	RXHDR_LEN		24	/* sizeof d11rxhdr_t */
+#define	RXHDR_LEN		24	/* sizeof struct d11rxhdr */
 #define	FRAMELEN(h)		((h)->RxFrameSize)
 
-struct wlc_d11rxhdr {
-	d11rxhdr_t rxhdr;
+struct brcms_d11rxhdr {
+	struct d11rxhdr rxhdr;
 	u32 tsf_l;		/* TSF_L reading */
 	s8 rssi;		/* computed instanteneous rssi in BMAC */
 	s8 rxpwr0;		/* obsoleted, place holder for legacy ROM code. use rxpwr[] */
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 5cdbfe9..ea17671 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -34,7 +34,7 @@
 #define	D64MAXRINGSZ		(1 << D64RINGALIGN_BITS)
 #define	D64RINGALIGN		(1 << D64RINGALIGN_BITS)
 
-#define	D64MAXDD	(D64MAXRINGSZ / sizeof(dma64dd_t))
+#define	D64MAXDD	(D64MAXRINGSZ / sizeof(struct dma64desc))
 
 /* transmit channel control */
 #define	D64_XC_XE		0x00000001	/* transmit enable */
@@ -205,31 +205,31 @@ static uint dma_msg_level;
 #define W_SM(r, v)	(*(r) = (v))
 
 /* One physical DMA segment */
-typedef struct {
+struct dma_seg {
 	dmaaddr_t addr;
 	u32 length;
-} dma_seg_t;
+};
 
-typedef struct {
+struct dma_seg_map {
 	void *oshdmah;		/* Opaque handle for OSL to store its information */
 	uint origsize;		/* Size of the virtual packet */
 	uint nsegs;
-	dma_seg_t segs[MAX_DMA_SEGS];
-} dma_seg_map_t;
+	struct dma_seg segs[MAX_DMA_SEGS];
+};
 
 /*
  * DMA Descriptor
  * Descriptors are only read by the hardware, never written back.
  */
-typedef volatile struct {
+struct dma64desc {
 	u32 ctrl1;		/* misc control bits & bufcount */
 	u32 ctrl2;		/* buffer count and address extension */
 	u32 addrlow;		/* memory address of the date buffer, bits 31:0 */
 	u32 addrhigh;	/* memory address of the date buffer, bits 63:32 */
-} dma64dd_t;
+};
 
 /* dma engine software state */
-typedef struct dma_info {
+struct dma_info {
 	struct dma_pub dma; /* exported structure */
 	uint *msg_level;	/* message level pointer */
 	char name[MAXNAMEL];	/* callers name for diag msgs */
@@ -243,8 +243,10 @@ typedef struct dma_info {
 		struct {
 			dma64regs_t *txregs_64;	/* 64-bit dma tx engine registers */
 			dma64regs_t *rxregs_64;	/* 64-bit dma rx engine registers */
-			dma64dd_t *txd_64;	/* pointer to dma64 tx descriptor ring */
-			dma64dd_t *rxd_64;	/* pointer to dma64 rx descriptor ring */
+			/* pointer to dma64 tx descriptor ring */
+			struct dma64desc *txd_64;
+			/* pointer to dma64 rx descriptor ring */
+			struct dma64desc *rxd_64;
 		} d64_u;
 	} dregs;
 
@@ -254,7 +256,7 @@ typedef struct dma_info {
 	u16 txin;		/* index of next descriptor to reclaim */
 	u16 txout;		/* index of next descriptor to post */
 	void **txp;		/* pointer to parallel array of pointers to packets */
-	dma_seg_map_t *txp_dmah;	/* DMA MAP meta-data handle */
+	struct dma_seg_map *txp_dmah;	/* DMA MAP meta-data handle */
 	dmaaddr_t txdpa;	/* Aligned physical address of descriptor ring */
 	dmaaddr_t txdpaorig;	/* Original physical address of descriptor ring */
 	u16 txdalign;	/* #bytes added to alloc'd mem to align txd */
@@ -268,7 +270,7 @@ typedef struct dma_info {
 	u16 rxin;		/* index of next descriptor to reclaim */
 	u16 rxout;		/* index of next descriptor to post */
 	void **rxp;		/* pointer to parallel array of pointers to packets */
-	dma_seg_map_t *rxp_dmah;	/* DMA MAP meta-data handle */
+	struct dma_seg_map *rxp_dmah;	/* DMA MAP meta-data handle */
 	dmaaddr_t rxdpa;	/* Aligned physical address of descriptor ring */
 	dmaaddr_t rxdpaorig;	/* Original physical address of descriptor ring */
 	u16 rxdalign;	/* #bytes added to alloc'd mem to align rxd */
@@ -292,7 +294,7 @@ typedef struct dma_info {
 	uint dataoffsetlow;	/* add to get dma address of data buffer, low 32 bits */
 	uint dataoffsethigh;	/*   high 32 bits */
 	bool aligndesc_4k;	/* descriptor base need to be aligned or not */
-} dma_info_t;
+};
 
 /* DMA Scatter-gather list is supported. Note this is limited to TX direction only */
 #ifdef BCMDMASGLISTOSL
@@ -324,65 +326,67 @@ typedef struct dma_info {
 #define	PCI64ADDR_HIGH_SHIFT	31	/* address[63] */
 
 /* Common prototypes */
-static bool _dma_isaddrext(dma_info_t *di);
-static bool _dma_descriptor_align(dma_info_t *di);
-static bool _dma_alloc(dma_info_t *di, uint direction);
-static void _dma_detach(dma_info_t *di);
-static void _dma_ddtable_init(dma_info_t *di, uint direction, dmaaddr_t pa);
-static void _dma_rxinit(dma_info_t *di);
-static void *_dma_rx(dma_info_t *di);
-static bool _dma_rxfill(dma_info_t *di);
-static void _dma_rxreclaim(dma_info_t *di);
-static void _dma_rxenable(dma_info_t *di);
-static void *_dma_getnextrxp(dma_info_t *di, bool forceall);
-static void _dma_rx_param_get(dma_info_t *di, u16 *rxoffset,
+static bool _dma_isaddrext(struct dma_info *di);
+static bool _dma_descriptor_align(struct dma_info *di);
+static bool _dma_alloc(struct dma_info *di, uint direction);
+static void _dma_detach(struct dma_info *di);
+static void _dma_ddtable_init(struct dma_info *di, uint direction,
+			      dmaaddr_t pa);
+static void _dma_rxinit(struct dma_info *di);
+static void *_dma_rx(struct dma_info *di);
+static bool _dma_rxfill(struct dma_info *di);
+static void _dma_rxreclaim(struct dma_info *di);
+static void _dma_rxenable(struct dma_info *di);
+static void *_dma_getnextrxp(struct dma_info *di, bool forceall);
+static void _dma_rx_param_get(struct dma_info *di, u16 *rxoffset,
 			      u16 *rxbufsize);
 
-static void _dma_txblock(dma_info_t *di);
-static void _dma_txunblock(dma_info_t *di);
-static uint _dma_txactive(dma_info_t *di);
-static uint _dma_rxactive(dma_info_t *di);
-static uint _dma_txpending(dma_info_t *di);
-static uint _dma_txcommitted(dma_info_t *di);
-
-static void *_dma_peeknexttxp(dma_info_t *di);
-static void *_dma_peeknextrxp(dma_info_t *di);
-static unsigned long _dma_getvar(dma_info_t *di, const char *name);
-static void _dma_counterreset(dma_info_t *di);
-static void _dma_fifoloopbackenable(dma_info_t *di);
-static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags);
+static void _dma_txblock(struct dma_info *di);
+static void _dma_txunblock(struct dma_info *di);
+static uint _dma_txactive(struct dma_info *di);
+static uint _dma_rxactive(struct dma_info *di);
+static uint _dma_txpending(struct dma_info *di);
+static uint _dma_txcommitted(struct dma_info *di);
+
+static void *_dma_peeknexttxp(struct dma_info *di);
+static void *_dma_peeknextrxp(struct dma_info *di);
+static unsigned long _dma_getvar(struct dma_info *di, const char *name);
+static void _dma_counterreset(struct dma_info *di);
+static void _dma_fifoloopbackenable(struct dma_info *di);
+static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags);
 static u8 dma_align_sizetobits(uint size);
-static void *dma_ringalloc(dma_info_t *di, u32 boundary, uint size,
+static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 			   u16 *alignbits, uint *alloced,
 			   dmaaddr_t *descpa);
 
 /* Prototypes for 64-bit routines */
-static bool dma64_alloc(dma_info_t *di, uint direction);
-static bool dma64_txreset(dma_info_t *di);
-static bool dma64_rxreset(dma_info_t *di);
-static bool dma64_txsuspendedidle(dma_info_t *di);
-static int dma64_txfast(dma_info_t *di, struct sk_buff *p0, bool commit);
-static int dma64_txunframed(dma_info_t *di, void *p0, uint len, bool commit);
-static void *dma64_getpos(dma_info_t *di, bool direction);
-static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range);
-static void *dma64_getnextrxp(dma_info_t *di, bool forceall);
-static void dma64_txrotate(dma_info_t *di);
-
-static bool dma64_rxidle(dma_info_t *di);
-static void dma64_txinit(dma_info_t *di);
-static bool dma64_txenabled(dma_info_t *di);
-static void dma64_txsuspend(dma_info_t *di);
-static void dma64_txresume(dma_info_t *di);
-static bool dma64_txsuspended(dma_info_t *di);
-static void dma64_txreclaim(dma_info_t *di, txd_range_t range);
-static bool dma64_txstopped(dma_info_t *di);
-static bool dma64_rxstopped(dma_info_t *di);
-static bool dma64_rxenabled(dma_info_t *di);
+static bool dma64_alloc(struct dma_info *di, uint direction);
+static bool dma64_txreset(struct dma_info *di);
+static bool dma64_rxreset(struct dma_info *di);
+static bool dma64_txsuspendedidle(struct dma_info *di);
+static int dma64_txfast(struct dma_info *di, struct sk_buff *p0, bool commit);
+static int dma64_txunframed(struct dma_info *di, void *p0, uint len,
+			    bool commit);
+static void *dma64_getpos(struct dma_info *di, bool direction);
+static void *dma64_getnexttxp(struct dma_info *di, enum txd_range range);
+static void *dma64_getnextrxp(struct dma_info *di, bool forceall);
+static void dma64_txrotate(struct dma_info *di);
+
+static bool dma64_rxidle(struct dma_info *di);
+static void dma64_txinit(struct dma_info *di);
+static bool dma64_txenabled(struct dma_info *di);
+static void dma64_txsuspend(struct dma_info *di);
+static void dma64_txresume(struct dma_info *di);
+static bool dma64_txsuspended(struct dma_info *di);
+static void dma64_txreclaim(struct dma_info *di, enum txd_range range);
+static bool dma64_txstopped(struct dma_info *di);
+static bool dma64_rxstopped(struct dma_info *di);
+static bool dma64_rxenabled(struct dma_info *di);
 static bool _dma64_addrext(dma64regs_t *dma64regs);
 
 static inline u32 parity32(u32 data);
 
-const di_fcn_t dma64proc = {
+const struct di_fcn_s dma64proc = {
 	(di_detach_t) _dma_detach,
 	(di_txinit_t) dma64_txinit,
 	(di_txreset_t) dma64_txreset,
@@ -434,11 +438,11 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		     uint nrxd, uint rxbufsize, int rxextheadroom,
 		     uint nrxpost, uint rxoffset, uint *msg_level)
 {
-	dma_info_t *di;
+	struct dma_info *di;
 	uint size;
 
 	/* allocate private info structure */
-	di = kzalloc(sizeof(dma_info_t), GFP_ATOMIC);
+	di = kzalloc(sizeof(struct dma_info), GFP_ATOMIC);
 	if (di == NULL) {
 #ifdef BCMDBG
 		printk(KERN_ERR "dma_attach: out of memory\n");
@@ -454,7 +458,7 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	/* init dma reg pointer */
 	di->d64txregs = (dma64regs_t *) dmaregstx;
 	di->d64rxregs = (dma64regs_t *) dmaregsrx;
-	di->dma.di_fn = (const di_fcn_t *)&dma64proc;
+	di->dma.di_fn = (const struct di_fcn_s *)&dma64proc;
 
 	/* Default flags (which can be changed by the driver calling dma_ctrlflags
 	 * before enable): For backwards compatibility both Rx Overflow Continue
@@ -582,14 +586,14 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	/* allocate DMA mapping vectors */
 	if (DMASGLIST_ENAB) {
 		if (ntxd) {
-			size = ntxd * sizeof(dma_seg_map_t);
+			size = ntxd * sizeof(struct dma_seg_map);
 			di->txp_dmah = kzalloc(size, GFP_ATOMIC);
 			if (di->txp_dmah == NULL)
 				goto fail;
 		}
 
 		if (nrxd) {
-			size = nrxd * sizeof(dma_seg_map_t);
+			size = nrxd * sizeof(struct dma_seg_map);
 			di->rxp_dmah = kzalloc(size, GFP_ATOMIC);
 			if (di->rxp_dmah == NULL)
 				goto fail;
@@ -618,8 +622,8 @@ static inline u32 parity32(u32 data)
 #define DMA64_DD_PARITY(dd)  parity32((dd)->addrlow ^ (dd)->addrhigh ^ (dd)->ctrl1 ^ (dd)->ctrl2)
 
 static inline void
-dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
-	     u32 *flags, u32 bufcount)
+dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
+	     dmaaddr_t pa, uint outidx, u32 *flags, u32 bufcount)
 {
 	u32 ctrl2 = bufcount & D64_CTRL2_BC_MASK;
 
@@ -660,7 +664,7 @@ dma64_dd_upd(dma_info_t *di, dma64dd_t *ddring, dmaaddr_t pa, uint outidx,
 	}
 }
 
-static bool _dma_alloc(dma_info_t *di, uint direction)
+static bool _dma_alloc(struct dma_info *di, uint direction)
 {
 	return dma64_alloc(di, direction);
 }
@@ -678,7 +682,7 @@ void *dma_alloc_consistent(struct pci_dev *pdev, uint size, u16 align_bits,
 }
 
 /* !! may be called with core in reset */
-static void _dma_detach(dma_info_t *di)
+static void _dma_detach(struct dma_info *di)
 {
 
 	DMA_TRACE(("%s: dma_detach\n", di->name));
@@ -708,7 +712,7 @@ static void _dma_detach(dma_info_t *di)
 
 }
 
-static bool _dma_descriptor_align(dma_info_t *di)
+static bool _dma_descriptor_align(struct dma_info *di)
 {
 	u32 addrl;
 
@@ -728,7 +732,7 @@ static bool _dma_descriptor_align(dma_info_t *di)
 }
 
 /* return true if this dma engine supports DmaExtendedAddrChanges, otherwise false */
-static bool _dma_isaddrext(dma_info_t *di)
+static bool _dma_isaddrext(struct dma_info *di)
 {
 	/* DMA64 supports full 32- or 64-bit operation. AE is always valid */
 
@@ -750,7 +754,7 @@ static bool _dma_isaddrext(dma_info_t *di)
 }
 
 /* initialize descriptor table base address */
-static void _dma_ddtable_init(dma_info_t *di, uint direction, dmaaddr_t pa)
+static void _dma_ddtable_init(struct dma_info *di, uint direction, dmaaddr_t pa)
 {
 	if (!di->aligndesc_4k) {
 		if (direction == DMA_TX)
@@ -799,14 +803,14 @@ static void _dma_ddtable_init(dma_info_t *di, uint direction, dmaaddr_t pa)
 	}
 }
 
-static void _dma_fifoloopbackenable(dma_info_t *di)
+static void _dma_fifoloopbackenable(struct dma_info *di)
 {
 	DMA_TRACE(("%s: dma_fifoloopbackenable\n", di->name));
 
 	OR_REG(&di->d64txregs->control, D64_XC_LE);
 }
 
-static void _dma_rxinit(dma_info_t *di)
+static void _dma_rxinit(struct dma_info *di)
 {
 	DMA_TRACE(("%s: dma_rxinit\n", di->name));
 
@@ -817,7 +821,7 @@ static void _dma_rxinit(dma_info_t *di)
 
 	/* clear rx descriptor ring */
 	memset((void *)di->rxd64, '\0',
-		(di->nrxd * sizeof(dma64dd_t)));
+		(di->nrxd * sizeof(struct dma64desc)));
 
 	/* DMA engine with out alignment requirement requires table to be inited
 	 * before enabling the engine
@@ -831,7 +835,7 @@ static void _dma_rxinit(dma_info_t *di)
 		_dma_ddtable_init(di, DMA_RX, di->rxdpa);
 }
 
-static void _dma_rxenable(dma_info_t *di)
+static void _dma_rxenable(struct dma_info *di)
 {
 	uint dmactrlflags = di->dma.dmactrlflags;
 	u32 control;
@@ -853,7 +857,7 @@ static void _dma_rxenable(dma_info_t *di)
 }
 
 static void
-_dma_rx_param_get(dma_info_t *di, u16 *rxoffset, u16 *rxbufsize)
+_dma_rx_param_get(struct dma_info *di, u16 *rxoffset, u16 *rxbufsize)
 {
 	/* the normal values fit into 16 bits */
 	*rxoffset = (u16) di->rxoffset;
@@ -869,7 +873,7 @@ _dma_rx_param_get(dma_info_t *di, u16 *rxoffset, u16 *rxbufsize)
  *   After it reaches the max size of buffer, the data continues in next DMA descriptor
  *   buffer WITHOUT DMA header
  */
-static void *_dma_rx(dma_info_t *di)
+static void *_dma_rx(struct dma_info *di)
 {
 	struct sk_buff *p, *head, *tail;
 	uint len;
@@ -909,7 +913,7 @@ static void *_dma_rx(dma_info_t *di)
 			    B2I(((R_REG(&di->d64rxregs->status0) &
 				  D64_RS0_CD_MASK) -
 				 di->rcvptrbase) & D64_RS0_CD_MASK,
-				dma64dd_t);
+				struct dma64desc);
 			DMA_ERROR(("_dma_rx, rxin %d rxout %d, hw_curr %d\n",
 				   di->rxin, di->rxout, cur));
 		}
@@ -932,7 +936,7 @@ static void *_dma_rx(dma_info_t *di)
  *  this will stall the rx dma and user might want to call rxfill again asap
  *  This unlikely happens on memory-rich NIC, but often on memory-constrained dongle
  */
-static bool _dma_rxfill(dma_info_t *di)
+static bool _dma_rxfill(struct dma_info *di)
 {
 	struct sk_buff *p;
 	u16 rxin, rxout;
@@ -990,7 +994,7 @@ static bool _dma_rxfill(dma_info_t *di)
 
 		if (DMASGLIST_ENAB)
 			memset(&di->rxp_dmah[rxout], 0,
-				sizeof(dma_seg_map_t));
+				sizeof(struct dma_seg_map));
 
 		pa = pci_map_single(di->pbus, p->data,
 			di->rxbufsize, PCI_DMA_FROMDEVICE);
@@ -1012,13 +1016,13 @@ static bool _dma_rxfill(dma_info_t *di)
 
 	/* update the chip lastdscr pointer */
 	W_REG(&di->d64rxregs->ptr,
-	      di->rcvptrbase + I2B(rxout, dma64dd_t));
+	      di->rcvptrbase + I2B(rxout, struct dma64desc));
 
 	return ring_empty;
 }
 
 /* like getnexttxp but no reclaim */
-static void *_dma_peeknexttxp(dma_info_t *di)
+static void *_dma_peeknexttxp(struct dma_info *di)
 {
 	uint end, i;
 
@@ -1028,7 +1032,7 @@ static void *_dma_peeknexttxp(dma_info_t *di)
 	end =
 	    B2I(((R_REG(&di->d64txregs->status0) &
 		  D64_XS0_CD_MASK) - di->xmtptrbase) & D64_XS0_CD_MASK,
-		  dma64dd_t);
+		  struct dma64desc);
 
 	for (i = di->txin; i != end; i = NEXTTXD(i))
 		if (di->txp[i])
@@ -1038,7 +1042,7 @@ static void *_dma_peeknexttxp(dma_info_t *di)
 }
 
 /* like getnextrxp but not take off the ring */
-static void *_dma_peeknextrxp(dma_info_t *di)
+static void *_dma_peeknextrxp(struct dma_info *di)
 {
 	uint end, i;
 
@@ -1048,7 +1052,7 @@ static void *_dma_peeknextrxp(dma_info_t *di)
 	end =
 	    B2I(((R_REG(&di->d64rxregs->status0) &
 		  D64_RS0_CD_MASK) - di->rcvptrbase) & D64_RS0_CD_MASK,
-		  dma64dd_t);
+		  struct dma64desc);
 
 	for (i = di->rxin; i != end; i = NEXTRXD(i))
 		if (di->rxp[i])
@@ -1057,7 +1061,7 @@ static void *_dma_peeknextrxp(dma_info_t *di)
 	return NULL;
 }
 
-static void _dma_rxreclaim(dma_info_t *di)
+static void _dma_rxreclaim(struct dma_info *di)
 {
 	void *p;
 
@@ -1067,7 +1071,7 @@ static void _dma_rxreclaim(dma_info_t *di)
 		brcmu_pkt_buf_free_skb(p);
 }
 
-static void *_dma_getnextrxp(dma_info_t *di, bool forceall)
+static void *_dma_getnextrxp(struct dma_info *di, bool forceall)
 {
 	if (di->nrxd == 0)
 		return NULL;
@@ -1075,34 +1079,34 @@ static void *_dma_getnextrxp(dma_info_t *di, bool forceall)
 	return dma64_getnextrxp(di, forceall);
 }
 
-static void _dma_txblock(dma_info_t *di)
+static void _dma_txblock(struct dma_info *di)
 {
 	di->dma.txavail = 0;
 }
 
-static void _dma_txunblock(dma_info_t *di)
+static void _dma_txunblock(struct dma_info *di)
 {
 	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
 }
 
-static uint _dma_txactive(dma_info_t *di)
+static uint _dma_txactive(struct dma_info *di)
 {
 	return NTXDACTIVE(di->txin, di->txout);
 }
 
-static uint _dma_txpending(dma_info_t *di)
+static uint _dma_txpending(struct dma_info *di)
 {
 	uint curr;
 
 	curr =
 	    B2I(((R_REG(&di->d64txregs->status0) &
 		  D64_XS0_CD_MASK) - di->xmtptrbase) & D64_XS0_CD_MASK,
-		  dma64dd_t);
+		  struct dma64desc);
 
 	return NTXDACTIVE(curr, di->txout);
 }
 
-static uint _dma_txcommitted(dma_info_t *di)
+static uint _dma_txcommitted(struct dma_info *di)
 {
 	uint ptr;
 	uint txin = di->txin;
@@ -1110,17 +1114,17 @@ static uint _dma_txcommitted(dma_info_t *di)
 	if (txin == di->txout)
 		return 0;
 
-	ptr = B2I(R_REG(&di->d64txregs->ptr), dma64dd_t);
+	ptr = B2I(R_REG(&di->d64txregs->ptr), struct dma64desc);
 
 	return NTXDACTIVE(di->txin, ptr);
 }
 
-static uint _dma_rxactive(dma_info_t *di)
+static uint _dma_rxactive(struct dma_info *di)
 {
 	return NRXDACTIVE(di->rxin, di->rxout);
 }
 
-static void _dma_counterreset(dma_info_t *di)
+static void _dma_counterreset(struct dma_info *di)
 {
 	/* reset all software counter */
 	di->dma.rxgiants = 0;
@@ -1128,7 +1132,7 @@ static void _dma_counterreset(dma_info_t *di)
 	di->dma.txnobuf = 0;
 }
 
-static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags)
+static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 {
 	uint dmactrlflags = di->dma.dmactrlflags;
 
@@ -1165,7 +1169,7 @@ static uint _dma_ctrlflags(dma_info_t *di, uint mask, uint flags)
 }
 
 /* get the address of the var in order to change later */
-static unsigned long _dma_getvar(dma_info_t *di, const char *name)
+static unsigned long _dma_getvar(struct dma_info *di, const char *name)
 {
 	if (!strcmp(name, "&txavail"))
 		return (unsigned long)&(di->dma.txavail);
@@ -1188,7 +1192,7 @@ u8 dma_align_sizetobits(uint size)
  * descriptor ring size aligned location. This will ensure that the ring will
  * not cross page boundary
  */
-static void *dma_ringalloc(dma_info_t *di, u32 boundary, uint size,
+static void *dma_ringalloc(struct dma_info *di, u32 boundary, uint size,
 			   u16 *alignbits, uint *alloced,
 			   dmaaddr_t *descpa)
 {
@@ -1214,7 +1218,7 @@ static void *dma_ringalloc(dma_info_t *di, u32 boundary, uint size,
 
 /* 64-bit DMA functions */
 
-static void dma64_txinit(dma_info_t *di)
+static void dma64_txinit(struct dma_info *di)
 {
 	u32 control = D64_XC_XE;
 
@@ -1227,7 +1231,7 @@ static void dma64_txinit(dma_info_t *di)
 	di->dma.txavail = di->ntxd - 1;
 
 	/* clear tx descriptor ring */
-	memset((void *)di->txd64, '\0', (di->ntxd * sizeof(dma64dd_t)));
+	memset((void *)di->txd64, '\0', (di->ntxd * sizeof(struct dma64desc)));
 
 	/* DMA engine with out alignment requirement requires table to be inited
 	 * before enabling the engine
@@ -1246,7 +1250,7 @@ static void dma64_txinit(dma_info_t *di)
 		_dma_ddtable_init(di, DMA_TX, di->txdpa);
 }
 
-static bool dma64_txenabled(dma_info_t *di)
+static bool dma64_txenabled(struct dma_info *di)
 {
 	u32 xc;
 
@@ -1255,7 +1259,7 @@ static bool dma64_txenabled(dma_info_t *di)
 	return (xc != 0xffffffff) && (xc & D64_XC_XE);
 }
 
-static void dma64_txsuspend(dma_info_t *di)
+static void dma64_txsuspend(struct dma_info *di)
 {
 	DMA_TRACE(("%s: dma_txsuspend\n", di->name));
 
@@ -1265,7 +1269,7 @@ static void dma64_txsuspend(dma_info_t *di)
 	OR_REG(&di->d64txregs->control, D64_XC_SE);
 }
 
-static void dma64_txresume(dma_info_t *di)
+static void dma64_txresume(struct dma_info *di)
 {
 	DMA_TRACE(("%s: dma_txresume\n", di->name));
 
@@ -1275,14 +1279,14 @@ static void dma64_txresume(dma_info_t *di)
 	AND_REG(&di->d64txregs->control, ~D64_XC_SE);
 }
 
-static bool dma64_txsuspended(dma_info_t *di)
+static bool dma64_txsuspended(struct dma_info *di)
 {
 	return (di->ntxd == 0) ||
 	    ((R_REG(&di->d64txregs->control) & D64_XC_SE) ==
 	     D64_XC_SE);
 }
 
-static void dma64_txreclaim(dma_info_t *di, txd_range_t range)
+static void dma64_txreclaim(struct dma_info *di, enum txd_range range)
 {
 	void *p;
 
@@ -1302,19 +1306,19 @@ static void dma64_txreclaim(dma_info_t *di, txd_range_t range)
 	}
 }
 
-static bool dma64_txstopped(dma_info_t *di)
+static bool dma64_txstopped(struct dma_info *di)
 {
 	return ((R_REG(&di->d64txregs->status0) & D64_XS0_XS_MASK) ==
 		D64_XS0_XS_STOPPED);
 }
 
-static bool dma64_rxstopped(dma_info_t *di)
+static bool dma64_rxstopped(struct dma_info *di)
 {
 	return ((R_REG(&di->d64rxregs->status0) & D64_RS0_RS_MASK) ==
 		D64_RS0_RS_STOPPED);
 }
 
-static bool dma64_alloc(dma_info_t *di, uint direction)
+static bool dma64_alloc(struct dma_info *di, uint direction)
 {
 	u16 size;
 	uint ddlen;
@@ -1323,7 +1327,7 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
 	u16 align;
 	u16 align_bits;
 
-	ddlen = sizeof(dma64dd_t);
+	ddlen = sizeof(struct dma64desc);
 
 	size = (direction == DMA_TX) ? (di->ntxd * ddlen) : (di->nrxd * ddlen);
 	align_bits = di->dmadesc_align;
@@ -1337,7 +1341,8 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
 			return false;
 		}
 		align = (1 << align_bits);
-		di->txd64 = (dma64dd_t *) roundup((unsigned long)va, align);
+		di->txd64 = (struct dma64desc *)
+					roundup((unsigned long)va, align);
 		di->txdalign = (uint) ((s8 *)di->txd64 - (s8 *) va);
 		PHYSADDRLOSET(di->txdpa,
 			      PHYSADDRLO(di->txdpaorig) + di->txdalign);
@@ -1351,7 +1356,8 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
 			return false;
 		}
 		align = (1 << align_bits);
-		di->rxd64 = (dma64dd_t *) roundup((unsigned long)va, align);
+		di->rxd64 = (struct dma64desc *)
+					roundup((unsigned long)va, align);
 		di->rxdalign = (uint) ((s8 *)di->rxd64 - (s8 *) va);
 		PHYSADDRLOSET(di->rxdpa,
 			      PHYSADDRLO(di->rxdpaorig) + di->rxdalign);
@@ -1362,7 +1368,7 @@ static bool dma64_alloc(dma_info_t *di, uint direction)
 	return true;
 }
 
-static bool dma64_txreset(dma_info_t *di)
+static bool dma64_txreset(struct dma_info *di)
 {
 	u32 status;
 
@@ -1387,7 +1393,7 @@ static bool dma64_txreset(dma_info_t *di)
 	return status == D64_XS0_XS_DISABLED;
 }
 
-static bool dma64_rxidle(dma_info_t *di)
+static bool dma64_rxidle(struct dma_info *di)
 {
 	DMA_TRACE(("%s: dma_rxidle\n", di->name));
 
@@ -1398,7 +1404,7 @@ static bool dma64_rxidle(dma_info_t *di)
 		(R_REG(&di->d64rxregs->ptr) & D64_RS0_CD_MASK));
 }
 
-static bool dma64_rxreset(dma_info_t *di)
+static bool dma64_rxreset(struct dma_info *di)
 {
 	u32 status;
 
@@ -1413,7 +1419,7 @@ static bool dma64_rxreset(dma_info_t *di)
 	return status == D64_RS0_RS_DISABLED;
 }
 
-static bool dma64_rxenabled(dma_info_t *di)
+static bool dma64_rxenabled(struct dma_info *di)
 {
 	u32 rc;
 
@@ -1421,7 +1427,7 @@ static bool dma64_rxenabled(dma_info_t *di)
 	return (rc != 0xffffffff) && (rc & D64_RC_RE);
 }
 
-static bool dma64_txsuspendedidle(dma_info_t *di)
+static bool dma64_txsuspendedidle(struct dma_info *di)
 {
 
 	if (di->ntxd == 0)
@@ -1441,7 +1447,7 @@ static bool dma64_txsuspendedidle(dma_info_t *di)
  * We return a pointer to the beginning of the DATA buffer of the current descriptor.
  * If DMA is idle, we return NULL.
  */
-static void *dma64_getpos(dma_info_t *di, bool direction)
+static void *dma64_getpos(struct dma_info *di, bool direction)
 {
 	void *va;
 	bool idle;
@@ -1451,12 +1457,12 @@ static void *dma64_getpos(dma_info_t *di, bool direction)
 		cd_offset =
 		    R_REG(&di->d64txregs->status0) & D64_XS0_CD_MASK;
 		idle = !NTXDACTIVE(di->txin, di->txout);
-		va = di->txp[B2I(cd_offset, dma64dd_t)];
+		va = di->txp[B2I(cd_offset, struct dma64desc)];
 	} else {
 		cd_offset =
 		    R_REG(&di->d64rxregs->status0) & D64_XS0_CD_MASK;
 		idle = !NRXDACTIVE(di->rxin, di->rxout);
-		va = di->rxp[B2I(cd_offset, dma64dd_t)];
+		va = di->rxp[B2I(cd_offset, struct dma64desc)];
 	}
 
 	/* If DMA is IDLE, return NULL */
@@ -1476,7 +1482,8 @@ static void *dma64_getpos(dma_info_t *di, bool direction)
  * Each call to this is results in a single descriptor being added for "len" bytes of
  * data starting at "buf", it doesn't handle chained buffers.
  */
-static int dma64_txunframed(dma_info_t *di, void *buf, uint len, bool commit)
+static int
+dma64_txunframed(struct dma_info *di, void *buf, uint len, bool commit)
 {
 	u16 txout;
 	u32 flags = 0;
@@ -1510,7 +1517,7 @@ static int dma64_txunframed(dma_info_t *di, void *buf, uint len, bool commit)
 	/* kick the chip */
 	if (commit) {
 		W_REG(&di->d64txregs->ptr,
-		      di->xmtptrbase + I2B(txout, dma64dd_t));
+		      di->xmtptrbase + I2B(txout, struct dma64desc));
 	}
 
 	/* tx flow control */
@@ -1529,7 +1536,7 @@ static int dma64_txunframed(dma_info_t *di, void *buf, uint len, bool commit)
  * WARNING: call must check the return value for error.
  *   the error(toss frames) could be fatal and cause many subsequent hard to debug problems
  */
-static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
+static int dma64_txfast(struct dma_info *di, struct sk_buff *p0,
 				    bool commit)
 {
 	struct sk_buff *p, *next;
@@ -1549,7 +1556,7 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 	 */
 	for (p = p0; p; p = next) {
 		uint nsegs, j;
-		dma_seg_map_t *map;
+		struct dma_seg_map *map;
 
 		data = p->data;
 		len = p->len;
@@ -1565,7 +1572,7 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 		/* get physical address of buffer start */
 		if (DMASGLIST_ENAB)
 			memset(&di->txp_dmah[txout], 0,
-				sizeof(dma_seg_map_t));
+				sizeof(struct dma_seg_map));
 
 		pa = pci_map_single(di->pbus, data, len, PCI_DMA_TODEVICE);
 
@@ -1626,7 +1633,7 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
 	/* kick the chip */
 	if (commit)
 		W_REG(&di->d64txregs->ptr,
-		      di->xmtptrbase + I2B(txout, dma64dd_t));
+		      di->xmtptrbase + I2B(txout, struct dma64desc));
 
 	/* tx flow control */
 	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
@@ -1651,7 +1658,7 @@ static int dma64_txfast(dma_info_t *di, struct sk_buff *p0,
  * If range is DMA_RANGE_ALL, reclaim all txd(s) posted to the ring and
  * return associated packet regardless of the value of hardware pointers.
  */
-static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
+static void *dma64_getnexttxp(struct dma_info *di, enum txd_range range)
 {
 	u16 start, end, i;
 	u16 active_desc;
@@ -1674,11 +1681,10 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 	else {
 		dma64regs_t *dregs = di->d64txregs;
 
-		end =
-		    (u16) (B2I
-			      (((R_REG(&dregs->status0) &
+		end = (u16) (B2I(((R_REG(&dregs->status0) &
 				 D64_XS0_CD_MASK) -
-				di->xmtptrbase) & D64_XS0_CD_MASK, dma64dd_t));
+				 di->xmtptrbase) & D64_XS0_CD_MASK,
+				 struct dma64desc));
 
 		if (range == DMA_RANGE_TRANSFERED) {
 			active_desc =
@@ -1686,7 +1692,7 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 				      D64_XS1_AD_MASK);
 			active_desc =
 			    (active_desc - di->xmtptrbase) & D64_XS0_CD_MASK;
-			active_desc = B2I(active_desc, dma64dd_t);
+			active_desc = B2I(active_desc, struct dma64desc);
 			if (end != active_desc)
 				end = PREVTXD(active_desc);
 		}
@@ -1697,7 +1703,7 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 
 	for (i = start; i != end && !txp; i = NEXTTXD(i)) {
 		dmaaddr_t pa;
-		dma_seg_map_t *map = NULL;
+		struct dma_seg_map *map = NULL;
 		uint size, j, nsegs;
 
 		PHYSADDRLOSET(pa,
@@ -1743,7 +1749,7 @@ static void *dma64_getnexttxp(dma_info_t *di, txd_range_t range)
 	return NULL;
 }
 
-static void *dma64_getnextrxp(dma_info_t *di, bool forceall)
+static void *dma64_getnextrxp(struct dma_info *di, bool forceall)
 {
 	uint i, curr;
 	void *rxp;
@@ -1757,7 +1763,7 @@ static void *dma64_getnextrxp(dma_info_t *di, bool forceall)
 
 	curr =
 	    B2I(((R_REG(&di->d64rxregs->status0) & D64_RS0_CD_MASK) -
-		 di->rcvptrbase) & D64_RS0_CD_MASK, dma64dd_t);
+		 di->rcvptrbase) & D64_RS0_CD_MASK, struct dma64desc);
 
 	/* ignore curr if forceall */
 	if (!forceall && (i == curr))
@@ -1797,7 +1803,7 @@ static bool _dma64_addrext(dma64regs_t *dma64regs)
 /*
  * Rotate all active tx dma ring entries "forward" by (ActiveDescriptor - txin).
  */
-static void dma64_txrotate(dma_info_t *di)
+static void dma64_txrotate(struct dma_info *di)
 {
 	u16 ad;
 	uint nactive;
@@ -1807,10 +1813,9 @@ static void dma64_txrotate(dma_info_t *di)
 	u16 first, last;
 
 	nactive = _dma_txactive(di);
-	ad = (u16) (B2I
-		       ((((R_REG(&di->d64txregs->status1) &
-			   D64_XS1_AD_MASK)
-			  - di->xmtptrbase) & D64_XS1_AD_MASK), dma64dd_t));
+	ad = (u16) (B2I((((R_REG(&di->d64txregs->status1) &
+			   D64_XS1_AD_MASK) - di->xmtptrbase) &
+			   D64_XS1_AD_MASK), struct dma64desc));
 	rot = TXD(ad - di->txin);
 
 	/* full-ring case is a lot harder - don't worry about this */
@@ -1851,8 +1856,9 @@ static void dma64_txrotate(dma_info_t *di)
 		/* Move the map */
 		if (DMASGLIST_ENAB) {
 			memcpy(&di->txp_dmah[new], &di->txp_dmah[old],
-			       sizeof(dma_seg_map_t));
-			memset(&di->txp_dmah[old], 0, sizeof(dma_seg_map_t));
+			       sizeof(struct dma_seg_map));
+			memset(&di->txp_dmah[old], 0,
+			       sizeof(struct dma_seg_map));
 		}
 
 		di->txp[old] = NULL;
@@ -1865,7 +1871,7 @@ static void dma64_txrotate(dma_info_t *di)
 
 	/* kick the chip */
 	W_REG(&di->d64txregs->ptr,
-	      di->xmtptrbase + I2B(di->txout, dma64dd_t));
+	      di->xmtptrbase + I2B(di->txout, struct dma64desc));
 }
 
 uint dma_addrwidth(struct si_pub *sih, void *dmaregs)
@@ -1894,7 +1900,7 @@ uint dma_addrwidth(struct si_pub *sih, void *dmaregs)
 void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a)
 {
-	dma_info_t *di = (dma_info_t *) dmah;
+	struct dma_info *di = (struct dma_info *) dmah;
 	uint i =   di->txin;
 	uint end = di->txout;
 	struct sk_buff *skb;
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.h b/drivers/staging/brcm80211/brcmsmac/dma.h
index ae411a5..9c8b9a6 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.h
+++ b/drivers/staging/brcm80211/brcmsmac/dma.h
@@ -82,11 +82,11 @@ typedef bool(*di_rxenable_t) (struct dma_pub *dmah);
 typedef bool(*di_rxenabled_t) (struct dma_pub *dmah);
 typedef void *(*di_rx_t) (struct dma_pub *dmah);
 typedef bool(*di_rxfill_t) (struct dma_pub *dmah);
-typedef void (*di_txreclaim_t) (struct dma_pub *dmah, txd_range_t range);
+typedef void (*di_txreclaim_t) (struct dma_pub *dmah, enum txd_range range);
 typedef void (*di_rxreclaim_t) (struct dma_pub *dmah);
 typedef unsigned long (*di_getvar_t) (struct dma_pub *dmah,
 				      const char *name);
-typedef void *(*di_getnexttxp_t) (struct dma_pub *dmah, txd_range_t range);
+typedef void *(*di_getnexttxp_t) (struct dma_pub *dmah, enum txd_range range);
 typedef void *(*di_getnextrxp_t) (struct dma_pub *dmah, bool forceall);
 typedef void *(*di_peeknexttxp_t) (struct dma_pub *dmah);
 typedef void *(*di_peeknextrxp_t) (struct dma_pub *dmah);
@@ -161,7 +161,7 @@ struct di_fcn_s {
  */
 /* export structure */
 struct dma_pub {
-	const di_fcn_t *di_fn;	/* DMA function pointers */
+	const struct di_fcn_s *di_fn;	/* DMA function pointers */
 	uint txavail;		/* # free tx descriptors */
 	uint dmactrlflags;	/* dma control flags */
 
@@ -177,7 +177,7 @@ extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 			    uint nrxd, uint rxbufsize, int rxextheadroom,
 			    uint nrxpost, uint rxoffset, uint *msg_level);
 
-extern const di_fcn_t dma64proc;
+extern const struct di_fcn_s dma64proc;
 
 #define dma_detach(di)			(dma64proc.detach(di))
 #define dma_txreset(di)			(dma64proc.txreset(di))
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 26a0a30..42fc04c 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -56,7 +56,7 @@ struct brcms_firmware {
 };
 
 struct brcms_info {
-	struct wlc_pub *pub;		/* pointer to public wlc state */
+	struct brcms_pub *pub;		/* pointer to public wlc state */
 	void *wlc;		/* pointer to private common os-independent data */
 	u32 magic;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 7c91b0b..f9e134a 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -304,7 +304,7 @@ static u16 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc,
 					       struct scb *scb, uint frag,
 					       uint nfrags, uint queue,
 					       uint next_frag_len,
-					       wsec_key_t *key,
+					       struct wsec_key *key,
 					       ratespec_t rspec_override);
 static void brcms_c_bss_default_init(struct brcms_c_info *wlc);
 static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc);
@@ -333,9 +333,9 @@ static void brcms_c_compute_mimo_plcp(ratespec_t rate, uint length, u8 *plcp);
 static u16 brcms_c_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
 				    u8 preamble_type, uint next_frag_len);
 static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
-			     struct wlc_d11rxhdr *rxh);
+			     struct brcms_d11rxhdr *rxh);
 static void brcms_c_recvctl(struct brcms_c_info *wlc,
-			d11rxhdr_t *rxh, struct sk_buff *p);
+			struct d11rxhdr *rxh, struct sk_buff *p);
 static uint brcms_c_calc_frame_len(struct brcms_c_info *wlc, ratespec_t rate,
 			       u8 preamble_type, uint dur);
 static uint brcms_c_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rate,
@@ -417,7 +417,7 @@ void brcms_c_reset(struct brcms_c_info *wlc)
 
 	/* reset our snapshot of macstat counters */
 	memset((char *)wlc->core->macstat_snapshot, 0,
-		sizeof(macstat_t));
+		sizeof(struct macstat));
 
 	brcms_b_reset(wlc->hw);
 }
@@ -1072,9 +1072,10 @@ static void WLBANDINITFN(brcms_c_setband) (struct brcms_c_info *wlc,
 }
 
 /* Initialize a WME Parameter Info Element with default STA parameters from WMM Spec, Table 12 */
-void brcms_c_wme_initparams_sta(struct brcms_c_info *wlc, wme_param_ie_t *pe)
+void
+brcms_c_wme_initparams_sta(struct brcms_c_info *wlc, struct wme_param_ie *pe)
 {
-	static const wme_param_ie_t stadef = {
+	static const struct wme_param_ie stadef = {
 		WME_OUI,
 		WME_TYPE,
 		WME_SUBTYPE_PARAM_IE,
@@ -1100,7 +1101,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 		       bool suspend)
 {
 	int i;
-	shm_acparams_t acp_shm;
+	struct shm_acparams acp_shm;
 	u16 *shm_entry;
 
 	/* Only apply params if the core is out of reset and has clocks */
@@ -1111,7 +1112,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 	}
 
 	do {
-		memset((char *)&acp_shm, 0, sizeof(shm_acparams_t));
+		memset((char *)&acp_shm, 0, sizeof(struct shm_acparams));
 		/* fill in shm ac params struct */
 		acp_shm.txop = le16_to_cpu(params->txop);
 		/* convert from units of 32us to us for ucode */
@@ -1145,7 +1146,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 
 		/* Fill in shm acparam table */
 		shm_entry = (u16 *) &acp_shm;
-		for (i = 0; i < (int)sizeof(shm_acparams_t); i += 2)
+		for (i = 0; i < (int)sizeof(struct shm_acparams); i += 2)
 			brcms_c_write_shm(wlc,
 				      M_EDCF_QINFO +
 				      wme_shmemacindex(aci) * M_EDCF_QLEN + i,
@@ -1165,7 +1166,7 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 {
 	u16 aci;
 	int i_ac;
-	edcf_acparam_t *edcf_acp;
+	struct edcf_acparam *edcf_acp;
 
 	struct ieee80211_tx_queue_params txq_pars;
 	struct ieee80211_tx_queue_params *params = &txq_pars;
@@ -1176,7 +1177,7 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 	 * STA uses AC params from wme_param_ie.
 	 */
 
-	edcf_acp = (edcf_acparam_t *) &wlc->wme_param_ie.acparam[0];
+	edcf_acp = (struct edcf_acparam *) &wlc->wme_param_ie.acparam[0];
 
 	for (i_ac = 0; i_ac < AC_COUNT; i_ac++, edcf_acp++) {
 		/* find out which ac this set of params applies to */
@@ -1307,7 +1308,7 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 
 static bool brcms_c_state_bmac_sync(struct brcms_c_info *wlc)
 {
-	brcms_b_state_t state_bmac;
+	struct brcms_b_state state_bmac;
 
 	if (brcms_b_state_get(wlc->hw, &state_bmac) != 0)
 		return false;
@@ -1351,7 +1352,7 @@ static uint brcms_c_attach_module(struct brcms_c_info *wlc)
 	return err;
 }
 
-struct wlc_pub *brcms_c_pub(void *wlc)
+struct brcms_pub *brcms_c_pub(void *wlc)
 {
 	return ((struct brcms_c_info *) wlc)->pub;
 }
@@ -1368,7 +1369,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	struct brcms_c_info *wlc;
 	uint err = 0;
 	uint j;
-	struct wlc_pub *pub;
+	struct brcms_pub *pub;
 	uint n_disabled;
 
 	/* allocate struct brcms_c_info state and its substructures */
@@ -2531,7 +2532,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 	bool ta_ok;
 	uint band;
 	struct brcms_c_bsscfg *bsscfg;
-	wlc_bss_info_t *current_bss;
+	struct brcms_bss_info *current_bss;
 
 	/* update bsscfg pointer */
 	bsscfg = wlc->cfg;
@@ -2770,7 +2771,7 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 /*
  * register watchdog and down handlers.
  */
-int brcms_c_module_register(struct wlc_pub *pub,
+int brcms_c_module_register(struct brcms_pub *pub,
 			const char *name, void *hdl,
 			watchdog_fn_t w_fn, down_fn_t d_fn)
 {
@@ -2793,7 +2794,8 @@ int brcms_c_module_register(struct wlc_pub *pub,
 }
 
 /* unregister module callbacks */
-int brcms_c_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
+int
+brcms_c_module_unregister(struct brcms_pub *pub, const char *name, void *hdl)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) pub->wlc;
 	int i;
@@ -2855,7 +2857,7 @@ static void brcms_c_print_txs_status(u16 s)
 }
 #endif				/* BCMDBG */
 
-void brcms_c_print_txstatus(tx_status_t *txs)
+void brcms_c_print_txstatus(struct tx_status *txs)
 {
 #if defined(BCMDBG)
 	u16 s = txs->status;
@@ -2883,7 +2885,7 @@ void brcms_c_print_txstatus(tx_status_t *txs)
 void brcms_c_statsupd(struct brcms_c_info *wlc)
 {
 	int i;
-	macstat_t macstats;
+	struct macstat macstats;
 #ifdef BCMDBG
 	u16 delta;
 	u16 rxf0ovfl;
@@ -2905,7 +2907,7 @@ void brcms_c_statsupd(struct brcms_c_info *wlc)
 
 	/* Read mac stats from contiguous shared memory */
 	brcms_b_copyfrom_shm(wlc->hw, M_UCODE_MACSTAT,
-			     &macstats, sizeof(macstat_t));
+			     &macstats, sizeof(struct macstat));
 
 #ifdef BCMDBG
 	/* check for rx fifo 0 overflow */
@@ -2954,7 +2956,7 @@ bool brcms_c_chipmatch(u16 vendor, u16 device)
 }
 
 #if defined(BCMDBG)
-void brcms_c_print_txdesc(d11txh_t *txh)
+void brcms_c_print_txdesc(struct d11txh *txh)
 {
 	u16 mtcl = le16_to_cpu(txh->MacTxControlLow);
 	u16 mtch = le16_to_cpu(txh->MacTxControlHigh);
@@ -2990,7 +2992,7 @@ void brcms_c_print_txdesc(d11txh_t *txh)
 	/* add plcp header along with txh descriptor */
 	printk(KERN_DEBUG "Raw TxDesc + plcp header:\n");
 	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET,
-			     txh, sizeof(d11txh_t) + 48);
+			     txh, sizeof(struct d11txh) + 48);
 
 	printk(KERN_DEBUG "TxCtlLow: %04x ", mtcl);
 	printk(KERN_DEBUG "TxCtlHigh: %04x ", mtch);
@@ -3040,7 +3042,7 @@ void brcms_c_print_txdesc(d11txh_t *txh)
 #endif				/* defined(BCMDBG) */
 
 #if defined(BCMDBG)
-void brcms_c_print_rxh(d11rxhdr_t *rxh)
+void brcms_c_print_rxh(struct d11rxhdr *rxh)
 {
 	u16 len = rxh->RxFrameSize;
 	u16 phystatus_0 = rxh->PhyRxStatus_0;
@@ -3062,7 +3064,8 @@ void brcms_c_print_rxh(d11rxhdr_t *rxh)
 	};
 
 	printk(KERN_DEBUG "Raw RxDesc:\n");
-	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, rxh, sizeof(d11rxhdr_t));
+	print_hex_dump_bytes("", DUMP_PREFIX_OFFSET, rxh,
+			     sizeof(struct d11rxhdr));
 
 	brcmu_format_flags(macstat_flags, macstatus1, flagstr, 64);
 
@@ -3286,7 +3289,7 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
  */
 static inline u16
 bcmc_fid_generate(struct brcms_c_info *wlc, struct brcms_c_bsscfg *bsscfg,
-		  d11txh_t *txh)
+		  struct d11txh *txh)
 {
 	u16 frameid;
 
@@ -3305,9 +3308,9 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	       bool commit, s8 txpktpend)
 {
 	u16 frameid = INVALIDFID;
-	d11txh_t *txh;
+	struct d11txh *txh;
 
-	txh = (d11txh_t *) (p->data);
+	txh = (struct d11txh *) (p->data);
 
 	/* When a BC/MC frame is being committed to the BCMC fifo via DMA (NOT PIO), update
 	 * ucode or BSS info as appropriate.
@@ -3378,7 +3381,7 @@ brcms_c_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
 	/* encode rate per 802.11a-1999 sec 17.3.4.1, with lsb transmitted first */
 	rate_signal = rate_info[rate] & WLC_RATE_MASK;
 	memset(plcp, 0, D11_PHY_HDR_LEN);
-	D11A_PHY_HDR_SRATE((ofdm_phy_hdr_t *) plcp, rate_signal);
+	D11A_PHY_HDR_SRATE((struct ofdm_phy_hdr *) plcp, rate_signal);
 
 	tmp = (length & 0xfff) << 5;
 	plcp[2] |= (tmp >> 16) & 0xff;
@@ -3622,7 +3625,7 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, ratespec_t rspec,
 }
 
 /*
- * Add d11txh_t, cck_phy_hdr_t.
+ * Add struct d11txh, struct cck_phy_hdr.
  *
  * 'p' data must start with 802.11 MAC header
  * 'p' must allow enough bytes of local headers to be "pushed" onto the packet
@@ -3634,10 +3637,10 @@ static u16
 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		     struct sk_buff *p, struct scb *scb, uint frag,
 		     uint nfrags, uint queue, uint next_frag_len,
-		     wsec_key_t *key, ratespec_t rspec_override)
+		     struct wsec_key *key, ratespec_t rspec_override)
 {
 	struct ieee80211_hdr *h;
-	d11txh_t *txh;
+	struct d11txh *txh;
 	u8 *plcp, plcp_fallback[D11_PHY_HDR_LEN];
 	int len, phylen, rts_phylen;
 	u16 mch, phyctl, xfts, mainrates;
@@ -3693,7 +3696,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	plcp = skb_push(p, D11_PHY_HDR_LEN);
 
 	/* add Broadcom tx descriptor header */
-	txh = (d11txh_t *) skb_push(p, D11_TXH_LEN);
+	txh = (struct d11txh *) skb_push(p, D11_TXH_LEN);
 	memset(txh, 0, D11_TXH_LEN);
 
 	/* setup frameid */
@@ -3912,7 +3915,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	    (phylen > wlc->RTSThresh) && !is_multicast_ether_addr(h->addr1))
 		use_rts = true;
 
-	/* (3) PLCP: determine PLCP header and MAC duration, fill d11txh_t */
+	/* (3) PLCP: determine PLCP header and MAC duration,
+	 * fill struct d11txh */
 	brcms_c_compute_plcp(wlc, rspec[0], phylen, plcp);
 	brcms_c_compute_plcp(wlc, rspec[1], phylen, plcp_fallback);
 	memcpy(&txh->FragPLCPFallback,
@@ -3925,9 +3929,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	}
 
 	/* MIMO-RATE: need validation ?? */
-	mainrates =
-	    IS_OFDM(rspec[0]) ? D11A_PHY_HDR_GRATE((ofdm_phy_hdr_t *) plcp) :
-	    plcp[0];
+	mainrates = IS_OFDM(rspec[0]) ?
+			D11A_PHY_HDR_GRATE((struct ofdm_phy_hdr *) plcp) :
+			plcp[0];
 
 	/* DUR field for main rate */
 	if (!ieee80211_is_pspoll(h->frame_control) &&
@@ -4011,7 +4015,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	txh->MaxABytes_FBR = cpu_to_le16(0);
 	txh->MinMBytes = cpu_to_le16(0);
 
-	/* (5) RTS/CTS: determine RTS/CTS PLCP header and MAC duration, furnish d11txh_t */
+	/* (5) RTS/CTS: determine RTS/CTS PLCP header and MAC duration,
+	 * furnish struct d11txh */
 	/* RTS PLCP header and RTS frame */
 	if (use_rts || use_cts) {
 		if (use_rts && use_cts)
@@ -4091,8 +4096,9 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		 *    high 8 bits: rts/cts rate/mcs
 		 */
 		mainrates |= (IS_OFDM(rts_rspec[0]) ?
-			      D11A_PHY_HDR_GRATE((ofdm_phy_hdr_t *) rts_plcp) :
-			      rts_plcp[0]) << 8;
+				D11A_PHY_HDR_GRATE(
+					(struct ofdm_phy_hdr *) rts_plcp) :
+				rts_plcp[0]) << 8;
 	} else {
 		memset((char *)txh->RTSPhyHeader, 0, D11_PHY_HDR_LEN);
 		memset((char *)&txh->rts_frame, 0,
@@ -4283,14 +4289,14 @@ static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
 	}
 }
 
-/* process an individual tx_status_t */
+/* process an individual struct tx_status */
 /* WLC_HIGH_API */
 bool
-brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs, u32 frm_tx2)
+brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 {
 	struct sk_buff *p;
 	uint queue;
-	d11txh_t *txh;
+	struct d11txh *txh;
 	struct scb *scb = NULL;
 	bool free_pdu;
 	int tx_rts, tx_frame_count, tx_rts_count;
@@ -4328,7 +4334,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs, u32 frm_tx2)
 	if (p == NULL)
 		goto fatal;
 
-	txh = (d11txh_t *) (p->data);
+	txh = (struct d11txh *) (p->data);
 	mcl = le16_to_cpu(txh->MacTxControlLow);
 
 	if (txs->phyerr) {
@@ -4495,7 +4501,7 @@ void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
  * are used. Finally, the tsf_h is read from the tsf register.
  */
 static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
-				 struct wlc_d11rxhdr *rxh)
+				 struct brcms_d11rxhdr *rxh)
 {
 	u32 tsf_h, tsf_l;
 	u16 rx_tsf_0_15, rx_tsf_16_31;
@@ -4519,11 +4525,11 @@ static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
 }
 
 static void
-prep_mac80211_status(struct brcms_c_info *wlc, d11rxhdr_t *rxh,
+prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		     struct sk_buff *p,
 		     struct ieee80211_rx_status *rx_status)
 {
-	wlc_d11rxhdr_t *wlc_rxh = (wlc_d11rxhdr_t *) rxh;
+	struct brcms_d11rxhdr *wlc_rxh = (struct brcms_d11rxhdr *) rxh;
 	int preamble;
 	int channel;
 	ratespec_t rspec;
@@ -4630,7 +4636,8 @@ prep_mac80211_status(struct brcms_c_info *wlc, d11rxhdr_t *rxh,
 }
 
 static void
-brcms_c_recvctl(struct brcms_c_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
+brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
+		struct sk_buff *p)
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
@@ -4656,7 +4663,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 /* WLC_HIGH_API */
 void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 {
-	d11rxhdr_t *rxh;
+	struct d11rxhdr *rxh;
 	struct ieee80211_hdr *h;
 	uint len;
 	bool is_amsdu;
@@ -4664,7 +4671,7 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* frame starts with rxhdr */
-	rxh = (d11rxhdr_t *) (p->data);
+	rxh = (struct d11rxhdr *) (p->data);
 
 	/* strip off rxhdr */
 	skb_pull(p, WL_HWRXOFF);
@@ -5245,7 +5252,7 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 			 struct brcms_c_bsscfg *cfg, u16 *buf, int *len)
 {
 	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
-	cck_phy_hdr_t *plcp;
+	struct cck_phy_hdr *plcp;
 	struct ieee80211_mgmt *h;
 	int hdr_len, body_len;
 
@@ -5260,7 +5267,7 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	/* format PHY and MAC headers */
 	memset((char *)buf, 0, hdr_len);
 
-	plcp = (cck_phy_hdr_t *) buf;
+	plcp = (struct cck_phy_hdr *) buf;
 
 	/* PLCP for Probe Response frames are filled in from core's rate table */
 	if (type == IEEE80211_STYPE_BEACON && !MBSS_BCN_ENAB(cfg)) {
@@ -5440,11 +5447,11 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 {
 	uint fifo;
-	d11txh_t *txh;
+	struct d11txh *txh;
 	struct ieee80211_hdr *h;
 	struct scb *scb;
 
-	txh = (d11txh_t *) (pdu->data);
+	txh = (struct d11txh *) (pdu->data);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
 	/* get the pkt queue info. This was put at brcms_c_sendctl or
@@ -5495,10 +5502,10 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 {
 	chanspec_t chanspec;
 	struct brcms_c_band *band;
-	wlc_bss_info_t *bi = wlc->default_bss;
+	struct brcms_bss_info *bi = wlc->default_bss;
 
 	/* init default and target BSS with some sane initial values */
-	memset((char *)(bi), 0, sizeof(wlc_bss_info_t));
+	memset((char *)(bi), 0, sizeof(struct brcms_bss_info));
 	bi->beacon_period = BEACON_INTERVAL_DEFAULT;
 	bi->dtim_period = DTIM_INTERVAL_DEFAULT;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 323f210..1501a4b 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -77,7 +77,7 @@
 struct brcms_c_bss_list {
 	uint count;
 	bool beacon;		/* set for beacon, cleared for probe response */
-	wlc_bss_info_t *ptrs[MAXBSS];
+	struct brcms_bss_info *ptrs[MAXBSS];
 };
 
 #define	SW_TIMER_MAC_STAT_UPD		30	/* periodic MAC stats update */
@@ -292,7 +292,7 @@ struct brcms_c_stf {
 #define WLC_CHAN_CHANNEL(x)     (((x) & RXS_CHAN_ID_MASK) >> RXS_CHAN_ID_SHIFT)
 #define WLC_RX_CHANNEL(rxh)	(WLC_CHAN_CHANNEL((rxh)->RxChan))
 
-/* wlc_bss_info flag bit values */
+/* brcms_bss_info flag bit values */
 #define WLC_BSS_HT		0x0020	/* BSS is HT (MIMO) capable */
 
 /* Flags used in brcms_c_txq_info.stopped */
@@ -341,8 +341,8 @@ struct wsec_key {
 	u32 len;		/* key length..don't move this var */
 	/* data is 4byte aligned */
 	u8 data[WLAN_MAX_KEY_LEN];	/* key data */
-	wsec_iv_t rxiv[WLC_NUMRXIVS];	/* Rx IV (one per TID) */
-	wsec_iv_t txiv;		/* Tx IV */
+	struct wsec_iv rxiv[WLC_NUMRXIVS];	/* Rx IV (one per TID) */
+	struct wsec_iv txiv;		/* Tx IV */
 };
 
 /*
@@ -355,7 +355,7 @@ struct brcms_c_core {
 	uint *txavail[NFIFO];	/* # tx descriptors available */
 	s16 txpktpend[NFIFO];	/* tx admission control */
 
-	macstat_t *macstat_snapshot;	/* mac hw prev read values */
+	struct macstat *macstat_snapshot;	/* mac hw prev read values */
 };
 
 /*
@@ -437,7 +437,7 @@ struct wme_param_ie {
 	u8 version;
 	u8 qosinfo;
 	u8 rsvd;
-	edcf_acparam_t acparam[AC_COUNT];
+	struct edcf_acparam acparam[AC_COUNT];
 } __attribute__((packed));
 
 /* virtual interface */
@@ -571,7 +571,7 @@ struct brcms_c_txq_info {
  * Principal common (os-independent) software data structure.
  */
 struct brcms_c_info {
-	struct wlc_pub *pub;		/* pointer to wlc public state */
+	struct brcms_pub *pub;		/* pointer to wlc public state */
 	struct brcms_info *wl;	/* pointer to os-specific private state */
 	d11regs_t *regs;	/* pointer to device registers */
 
@@ -615,7 +615,7 @@ struct brcms_c_info {
 
 	struct ampdu_info *ampdu;	/* ampdu module handler */
 	struct antsel_info *asi;	/* antsel module handler */
-	wlc_cm_info_t *cmi;	/* channel manager module handler */
+	struct brcms_cm_info *cmi;	/* channel manager module handler */
 
 	uint vars_size;		/* size of vars, free vars on detach */
 
@@ -664,11 +664,13 @@ struct brcms_c_info {
 	/* WME */
 	ac_bitmap_t wme_dp;	/* Discard (oldest first) policy per AC */
 	u16 edcf_txop[AC_COUNT];	/* current txop for each ac */
-	wme_param_ie_t wme_param_ie;	/* WME parameter info element, which on STA
-					 * contains parameters in use locally, and on
-					 * AP contains parameters advertised to STA
-					 * in beacons and assoc responses.
-					 */
+
+	/*
+	 * WME parameter info element, which on STA contains parameters in use
+	 * locally, and on AP contains parameters advertised to STA in beacons
+	 * and assoc responses.
+	 */
+	struct wme_param_ie wme_param_ie;
 	u16 wme_retries[AC_COUNT];	/* per-AC retry limits */
 
 	u16 tx_prec_map;	/* Precedence map based on HW FIFO space */
@@ -685,8 +687,9 @@ struct brcms_c_info {
 	struct brcms_c_txq_info *tx_queues;	/* common TX Queue list */
 
 	/* security */
-	wsec_key_t *wsec_keys[WSEC_MAX_KEYS];	/* dynamic key storage */
-	wsec_key_t *wsec_def_keys[WLC_DEFAULT_KEYS];	/* default key storage */
+	struct wsec_key *wsec_keys[WSEC_MAX_KEYS]; /* dynamic key storage */
+	/* default key storage */
+	struct wsec_key *wsec_def_keys[WLC_DEFAULT_KEYS];
 	bool wsec_swkeys;	/* indicates that all keys should be
 				 * treated as sw keys (used for debugging)
 				 */
@@ -699,7 +702,7 @@ struct brcms_c_info {
 	/* HT CAP IE being advertised by this node: */
 	struct ieee80211_ht_cap ht_cap;
 
-	wlc_bss_info_t *default_bss;	/* configured BSS parameters */
+	struct brcms_bss_info *default_bss;	/* configured BSS parameters */
 
 	u16 mc_fid_counter;	/* BC/MC FIFO frame ID counter */
 
@@ -761,14 +764,14 @@ struct brcms_c_info {
 /* antsel module specific state */
 struct antsel_info {
 	struct brcms_c_info *wlc;	/* pointer to main wlc structure */
-	struct wlc_pub *pub;		/* pointer to public fn */
+	struct brcms_pub *pub;		/* pointer to public fn */
 	u8 antsel_type;	/* Type of boardlevel mimo antenna switch-logic
 				 * 0 = N/A, 1 = 2x4 board, 2 = 2x3 CB2 board
 				 */
 	u8 antsel_antswitch;	/* board level antenna switch type */
 	bool antsel_avail;	/* Ant selection availability (SROM based) */
-	wlc_antselcfg_t antcfg_11n;	/* antenna configuration */
-	wlc_antselcfg_t antcfg_cur;	/* current antenna config (auto) */
+	struct brcms_antselcfg antcfg_11n; /* antenna configuration */
+	struct brcms_antselcfg antcfg_cur; /* current antenna config (auto) */
 };
 
 /* BSS configuration state */
@@ -800,9 +803,11 @@ struct brcms_c_bsscfg {
 	u16 WPA_auth;	/* WPA: authenticated key management */
 	bool wpa2_preauth;	/* default is true, wpa_cap sets value */
 	bool wsec_portopen;	/* indicates keys are plumbed */
-	wsec_iv_t wpa_none_txiv;	/* global txiv for WPA_NONE, tkip and aes */
+	/* global txiv for WPA_NONE, tkip and aes */
+	struct wsec_iv wpa_none_txiv;
 	int wsec_index;		/* 0-3: default tx key, -1: not set */
-	wsec_key_t *bss_def_keys[WLC_DEFAULT_KEYS];	/* default key storage */
+	/* default key storage: */
+	struct wsec_key *bss_def_keys[WLC_DEFAULT_KEYS];
 
 	/* TKIP countermeasures */
 	bool tkip_countermeasures;	/* flags TKIP no-assoc period */
@@ -829,7 +834,7 @@ struct brcms_c_bsscfg {
 	pmkid_t pmkid[MAXPMKID];	/* PMKID cache */
 	uint npmkid;		/* num cached PMKIDs */
 
-	wlc_bss_info_t *current_bss;	/* BSS parms in ASSOCIATED state */
+	struct brcms_bss_info *current_bss; /* BSS parms in ASSOCIATED state */
 
 	/* PM states */
 	bool PMawakebcn;	/* bcn recvd during current waking state */
@@ -840,7 +845,7 @@ struct brcms_c_bsscfg {
 	/* BSSID entry in RCMTA, use the wsec key management infrastructure to
 	 * manage the RCMTA entries.
 	 */
-	wsec_key_t *rcmta;
+	struct wsec_key *rcmta;
 
 	/* 'unique' ID of this bsscfg, assigned at bsscfg allocation */
 	u16 ID;
@@ -874,7 +879,7 @@ struct brcms_c_bsscfg {
 extern void brcms_c_fatal_error(struct brcms_c_info *wlc);
 extern void brcms_b_rpc_watchdog(struct brcms_c_info *wlc);
 extern void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p);
-extern bool brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs,
+extern bool brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs,
 			       u32 frm_tx2);
 extern void brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo,
 			   struct sk_buff *p,
@@ -884,7 +889,7 @@ extern void brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo,
 extern void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 			    uint prec);
 extern void brcms_c_info_init(struct brcms_c_info *wlc, int unit);
-extern void brcms_c_print_txstatus(tx_status_t *txs);
+extern void brcms_c_print_txstatus(struct tx_status *txs);
 extern int brcms_c_xmtfifo_sz_get(struct brcms_c_info *wlc, uint fifo,
 				  uint *blocks);
 extern void brcms_c_write_template_ram(struct brcms_c_info *wlc, int offset,
@@ -895,8 +900,8 @@ extern void brcms_c_pllreq(struct brcms_c_info *wlc, bool set, mbool req_bit);
 extern void brcms_c_reset_bmac_done(struct brcms_c_info *wlc);
 
 #if defined(BCMDBG)
-extern void brcms_c_print_rxh(d11rxhdr_t *rxh);
-extern void brcms_c_print_txdesc(d11txh_t *txh);
+extern void brcms_c_print_rxh(struct d11rxhdr *rxh);
+extern void brcms_c_print_txdesc(struct d11txh *txh);
 #else
 #define brcms_c_print_txdesc(a)
 #endif
@@ -1007,6 +1012,6 @@ extern void brcms_c_set_home_chanspec(struct brcms_c_info *wlc,
 extern bool brcms_c_ps_allowed(struct brcms_c_info *wlc);
 extern bool brcms_c_stay_awake(struct brcms_c_info *wlc);
 extern void brcms_c_wme_initparams_sta(struct brcms_c_info *wlc,
-				       wme_param_ie_t *pe);
+				       struct wme_param_ie *pe);
 
 #endif				/* _BRCM_MAIN_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index a5eebf3..4915592 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -145,7 +145,7 @@ struct sbpciregs {
 };
 
 /* SB side: PCIE core and host control registers */
-typedef struct sbpcieregs {
+struct sbpcieregs {
 	u32 control;		/* host mode only */
 	u32 PAD[2];
 	u32 biststatus;	/* bist Status: 0x00C */
@@ -177,11 +177,11 @@ typedef struct sbpcieregs {
 	u32 PAD[177];
 	u32 pciecfg[4][64];	/* 0x400 - 0x7FF, PCIE Cfg Space */
 	u16 sprom[64];	/* SPROM shadow Area */
-} sbpcieregs_t;
+};
 
-typedef struct {
+struct pcicore_info {
 	union {
-		sbpcieregs_t *pcieregs;
+		struct sbpcieregs *pcieregs;
 		struct sbpciregs *pciregs;
 	} regs;			/* Memory mapped register to the core */
 
@@ -194,7 +194,7 @@ typedef struct {
 
 	u8 pmecap_offset;	/* PM Capability offset in the config space */
 	bool pmecap;		/* Capable of generating PME */
-} pcicore_info_t;
+};
 
 /* debug/trace */
 #define	PCI_ERROR(args)
@@ -202,22 +202,22 @@ typedef struct {
 	(((sih)->bustype == PCI_BUS) && ((sih)->buscoretype == PCIE_CORE_ID))
 
 /* routines to access mdio slave device registers */
-static bool pcie_mdiosetblock(pcicore_info_t *pi, uint blk);
-static int pcie_mdioop(pcicore_info_t *pi, uint physmedia, uint regaddr,
+static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk);
+static int pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr,
 		       bool write, uint *val);
-static int pcie_mdiowrite(pcicore_info_t *pi, uint physmedia, uint readdr,
+static int pcie_mdiowrite(struct pcicore_info *pi, uint physmedia, uint readdr,
 			  uint val);
-static int pcie_mdioread(pcicore_info_t *pi, uint physmedia, uint readdr,
+static int pcie_mdioread(struct pcicore_info *pi, uint physmedia, uint readdr,
 			 uint *ret_val);
 
-static void pcie_extendL1timer(pcicore_info_t *pi, bool extend);
-static void pcie_clkreq_upd(pcicore_info_t *pi, uint state);
+static void pcie_extendL1timer(struct pcicore_info *pi, bool extend);
+static void pcie_clkreq_upd(struct pcicore_info *pi, uint state);
 
-static void pcie_war_aspm_clkreq(pcicore_info_t *pi);
-static void pcie_war_serdes(pcicore_info_t *pi);
-static void pcie_war_noplldown(pcicore_info_t *pi);
-static void pcie_war_polarity(pcicore_info_t *pi);
-static void pcie_war_pci_setup(pcicore_info_t *pi);
+static void pcie_war_aspm_clkreq(struct pcicore_info *pi);
+static void pcie_war_serdes(struct pcicore_info *pi);
+static void pcie_war_noplldown(struct pcicore_info *pi);
+static void pcie_war_polarity(struct pcicore_info *pi);
+static void pcie_war_pci_setup(struct pcicore_info *pi);
 
 #define PCIE_ASPM(sih)	((PCIE_PUB(sih)) && (((sih)->buscorerev >= 3) && ((sih)->buscorerev <= 5)))
 
@@ -230,10 +230,10 @@ static void pcie_war_pci_setup(pcicore_info_t *pi);
  */
 void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
 {
-	pcicore_info_t *pi;
+	struct pcicore_info *pi;
 
-	/* alloc pcicore_info_t */
-	pi = kzalloc(sizeof(pcicore_info_t), GFP_ATOMIC);
+	/* alloc struct pcicore_info */
+	pi = kzalloc(sizeof(struct pcicore_info), GFP_ATOMIC);
 	if (pi == NULL) {
 		PCI_ERROR(("pci_attach: malloc failed!\n"));
 		return NULL;
@@ -244,7 +244,7 @@ void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
 
 	if (sih->buscoretype == PCIE_CORE_ID) {
 		u8 cap_ptr;
-		pi->regs.pcieregs = (sbpcieregs_t *) regs;
+		pi->regs.pcieregs = (struct sbpcieregs *) regs;
 		cap_ptr = pcicore_find_pci_capability(pi->dev, PCI_CAP_ID_EXP,
 						      NULL, NULL);
 		pi->pciecap_lcreg_offset = cap_ptr + PCIE_CAP_LINKCTRL_OFFSET;
@@ -256,7 +256,7 @@ void *pcicore_init(struct si_pub *sih, void *pdev, void *regs)
 
 void pcicore_deinit(void *pch)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 
 	if (pi == NULL)
 		return;
@@ -327,7 +327,7 @@ pcicore_find_pci_capability(void *dev, u8 req_cap_id,
 
 /* ***** Register Access API */
 static uint
-pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
+pcie_readreg(struct sbpcieregs *pcieregs, uint addrtype,
 	     uint offset)
 {
 	uint retval = 0xFFFFFFFF;
@@ -351,7 +351,7 @@ pcie_readreg(sbpcieregs_t *pcieregs, uint addrtype,
 }
 
 static uint
-pcie_writereg(sbpcieregs_t *pcieregs, uint addrtype,
+pcie_writereg(struct sbpcieregs *pcieregs, uint addrtype,
 	      uint offset, uint val)
 {
 	switch (addrtype) {
@@ -369,9 +369,9 @@ pcie_writereg(sbpcieregs_t *pcieregs, uint addrtype,
 	return 0;
 }
 
-static bool pcie_mdiosetblock(pcicore_info_t *pi, uint blk)
+static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 {
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 	uint mdiodata, i = 0;
 	uint pcie_serdes_spinwait = 200;
 
@@ -402,10 +402,10 @@ static bool pcie_mdiosetblock(pcicore_info_t *pi, uint blk)
 }
 
 static int
-pcie_mdioop(pcicore_info_t *pi, uint physmedia, uint regaddr, bool write,
+pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 	    uint *val)
 {
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 	uint mdiodata;
 	uint i = 0;
 	uint pcie_serdes_spinwait = 10;
@@ -462,14 +462,15 @@ pcie_mdioop(pcicore_info_t *pi, uint physmedia, uint regaddr, bool write,
 
 /* use the mdio interface to read from mdio slaves */
 static int
-pcie_mdioread(pcicore_info_t *pi, uint physmedia, uint regaddr, uint *regval)
+pcie_mdioread(struct pcicore_info *pi, uint physmedia, uint regaddr,
+	      uint *regval)
 {
 	return pcie_mdioop(pi, physmedia, regaddr, false, regval);
 }
 
 /* use the mdio interface to write to mdio slaves */
 static int
-pcie_mdiowrite(pcicore_info_t *pi, uint physmedia, uint regaddr, uint val)
+pcie_mdiowrite(struct pcicore_info *pi, uint physmedia, uint regaddr, uint val)
 {
 	return pcie_mdioop(pi, physmedia, regaddr, true, &val);
 }
@@ -477,7 +478,7 @@ pcie_mdiowrite(pcicore_info_t *pi, uint physmedia, uint regaddr, uint val)
 /* ***** Support functions ***** */
 static u8 pcie_clkreq(void *pch, u32 mask, u32 val)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 	u32 reg_val;
 	u8 offset;
 
@@ -501,11 +502,11 @@ static u8 pcie_clkreq(void *pch, u32 mask, u32 val)
 		return 0;
 }
 
-static void pcie_extendL1timer(pcicore_info_t *pi, bool extend)
+static void pcie_extendL1timer(struct pcicore_info *pi, bool extend)
 {
 	u32 w;
 	struct si_pub *sih = pi->sih;
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 
 	if (!PCIE_PUB(sih) || sih->buscorerev < 7)
 		return;
@@ -520,7 +521,7 @@ static void pcie_extendL1timer(pcicore_info_t *pi, bool extend)
 }
 
 /* centralized clkreq control policy */
-static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
+static void pcie_clkreq_upd(struct pcicore_info *pi, uint state)
 {
 	struct si_pub *sih = pi->sih;
 
@@ -560,7 +561,7 @@ static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 
 /* ***** PCI core WARs ***** */
 /* Done only once at attach time */
-static void pcie_war_polarity(pcicore_info_t *pi)
+static void pcie_war_polarity(struct pcicore_info *pi)
 {
 	u32 w;
 
@@ -585,9 +586,9 @@ static void pcie_war_polarity(pcicore_info_t *pi)
  *   : Coming out of 'standby'/'hibernate'
  *   : If pcie_war_aspm_ovr state changed
  */
-static void pcie_war_aspm_clkreq(pcicore_info_t *pi)
+static void pcie_war_aspm_clkreq(struct pcicore_info *pi)
 {
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 	struct si_pub *sih = pi->sih;
 	u16 val16, *reg16;
 	u32 w;
@@ -628,7 +629,7 @@ static void pcie_war_aspm_clkreq(pcicore_info_t *pi)
 
 /* Apply the polarity determined at the start */
 /* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_war_serdes(pcicore_info_t *pi)
+static void pcie_war_serdes(struct pcicore_info *pi)
 {
 	u32 w = 0;
 
@@ -645,9 +646,9 @@ static void pcie_war_serdes(pcicore_info_t *pi)
 
 /* Fix MISC config to allow coming out of L2/L3-Ready state w/o PRST */
 /* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_misc_config_fixup(pcicore_info_t *pi)
+static void pcie_misc_config_fixup(struct pcicore_info *pi)
 {
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 	u16 val16, *reg16;
 
 	reg16 = &pcieregs->sprom[SRSH_PCIE_MISC_CONFIG];
@@ -661,9 +662,9 @@ static void pcie_misc_config_fixup(pcicore_info_t *pi)
 
 /* quick hack for testing */
 /* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_war_noplldown(pcicore_info_t *pi)
+static void pcie_war_noplldown(struct pcicore_info *pi)
 {
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 	u16 *reg16;
 
 	/* turn off serdes PLL down */
@@ -676,10 +677,10 @@ static void pcie_war_noplldown(pcicore_info_t *pi)
 }
 
 /* Needs to happen when coming out of 'standby'/'hibernate' */
-static void pcie_war_pci_setup(pcicore_info_t *pi)
+static void pcie_war_pci_setup(struct pcicore_info *pi)
 {
 	struct si_pub *sih = pi->sih;
-	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
+	struct sbpcieregs *pcieregs = pi->regs.pcieregs;
 	u32 w;
 
 	if ((sih->buscorerev == 0) || (sih->buscorerev == 1)) {
@@ -723,7 +724,7 @@ static void pcie_war_pci_setup(pcicore_info_t *pi)
 /* ***** Functions called during driver state changes ***** */
 void pcicore_attach(void *pch, char *pvars, int state)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 	struct si_pub *sih = pi->sih;
 
 	/* Determine if this board needs override */
@@ -748,7 +749,7 @@ void pcicore_attach(void *pch, char *pvars, int state)
 
 void pcicore_hwup(void *pch)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
@@ -758,7 +759,7 @@ void pcicore_hwup(void *pch)
 
 void pcicore_up(void *pch, int state)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
@@ -772,7 +773,7 @@ void pcicore_up(void *pch, int state)
 /* When the device is going to enter D3 state (or the system is going to enter S3/S4 states */
 void pcicore_sleep(void *pch)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 	u32 w;
 
 	if (!pi || !PCIE_ASPM(pi->sih))
@@ -787,7 +788,7 @@ void pcicore_sleep(void *pch)
 
 void pcicore_down(void *pch, int state)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 
 	if (!pi || !PCIE_PUB(pi->sih))
 		return;
@@ -803,10 +804,10 @@ void pcicore_down(void *pch, int state)
  */
 void pcicore_fixcfg(void *pch, void *regs)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 	struct si_info *sii = SI_INFO(pi->sih);
 	struct sbpciregs *pciregs = regs;
-	sbpcieregs_t *pcieregs = regs;
+	struct sbpcieregs *pcieregs = regs;
 	u16 val16, *reg16 = NULL;
 	uint pciidx;
 
@@ -831,7 +832,7 @@ void pcicore_fixcfg(void *pch, void *regs)
  */
 void pcicore_pci_setup(void *pch, void *regs)
 {
-	pcicore_info_t *pi = (pcicore_info_t *) pch;
+	struct pcicore_info *pi = (struct pcicore_info *) pch;
 	struct sbpciregs *pciregs = regs;
 	u32 w;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index 7edc435..34253cf 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -69,18 +69,18 @@ typedef int (*otp_read_region_t) (struct si_pub *sih, int region, u16 *data,
 typedef int (*otp_nvread_t) (void *oh, char *data, uint *len);
 
 /* OTP function struct */
-typedef struct otp_fn_s {
+struct otp_fn_s {
 	otp_size_t size;
 	otp_read_bit_t read_bit;
 	otp_init_t init;
 	otp_read_region_t read_region;
 	otp_nvread_t nvread;
 	otp_status_t status;
-} otp_fn_t;
+};
 
-typedef struct {
+struct otpinfo {
 	uint ccrev;		/* chipc revision */
-	otp_fn_t *fn;		/* OTP functions */
+	struct otp_fn_s *fn;		/* OTP functions */
 	struct si_pub *sih;		/* Saved sb handle */
 
 	/* IPX OTP section */
@@ -97,9 +97,9 @@ typedef struct {
 	u16 fbase;		/* fuse subregion offset */
 	u16 flim;		/* fuse subregion boundary */
 	int otpgu_base;		/* offset to General Use Region */
-} otpinfo_t;
+};
 
-static otpinfo_t otpinfo;
+static struct otpinfo otpinfo;
 
 /*
  * IPX OTP Code
@@ -153,29 +153,29 @@ static otpinfo_t otpinfo;
 
 static int ipxotp_status(void *oh)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 	return (int)(oi->status);
 }
 
 /* Return size in bytes */
 static int ipxotp_size(void *oh)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 	return (int)oi->wsize * 2;
 }
 
 static u16 ipxotp_otpr(void *oh, chipcregs_t *cc, uint wn)
 {
-	otpinfo_t *oi;
+	struct otpinfo *oi;
 
-	oi = (otpinfo_t *) oh;
+	oi = (struct otpinfo *) oh;
 
 	return R_REG(&cc->sromotp[wn]);
 }
 
 static u16 ipxotp_read_bit(void *oh, chipcregs_t *cc, uint off)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint k, row, col;
 	u32 otpp, st;
 
@@ -225,7 +225,7 @@ static int ipxotp_max_rgnsz(struct si_pub *sih, int osizew)
 	return ret;
 }
 
-static void _ipxotp_init(otpinfo_t *oi, chipcregs_t *cc)
+static void _ipxotp_init(struct otpinfo *oi, chipcregs_t *cc)
 {
 	uint k;
 	u32 otpp, st;
@@ -300,7 +300,7 @@ static void *ipxotp_init(struct si_pub *sih)
 {
 	uint idx;
 	chipcregs_t *cc;
-	otpinfo_t *oi;
+	struct otpinfo *oi;
 
 	/* Make sure we're running IPX OTP */
 	if (!OTPTYPE_IPX(sih->ccrev))
@@ -356,7 +356,7 @@ static void *ipxotp_init(struct si_pub *sih)
 
 static int ipxotp_read_region(void *oh, int region, u16 *data, uint *wlen)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint idx;
 	chipcregs_t *cc;
 	uint base, i, sz;
@@ -444,7 +444,7 @@ static int ipxotp_nvread(void *oh, char *data, uint *len)
 	return -ENOTSUPP;
 }
 
-static otp_fn_t ipxotp_fn = {
+static struct otp_fn_s ipxotp_fn = {
 	(otp_size_t) ipxotp_size,
 	(otp_read_bit_t) ipxotp_read_bit,
 
@@ -466,21 +466,21 @@ static otp_fn_t ipxotp_fn = {
 
 int otp_status(void *oh)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 
 	return oi->fn->status(oh);
 }
 
 int otp_size(void *oh)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 
 	return oi->fn->size(oh);
 }
 
 u16 otp_read_bit(void *oh, uint offset)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 	uint idx = ai_coreidx(oi->sih);
 	chipcregs_t *cc = ai_setcoreidx(oi->sih, SI_CC_IDX);
 	u16 readBit = (u16) oi->fn->read_bit(oh, cc, offset);
@@ -490,11 +490,11 @@ u16 otp_read_bit(void *oh, uint offset)
 
 void *otp_init(struct si_pub *sih)
 {
-	otpinfo_t *oi;
+	struct otpinfo *oi;
 	void *ret = NULL;
 
 	oi = &otpinfo;
-	memset(oi, 0, sizeof(otpinfo_t));
+	memset(oi, 0, sizeof(struct otpinfo));
 
 	oi->ccrev = sih->ccrev;
 
@@ -529,7 +529,8 @@ otp_read_region(struct si_pub *sih, int region, u16 *data,
 		goto out;
 	}
 
-	err = (((otpinfo_t *) oh)->fn->read_region) (oh, region, data, wlen);
+	err = (((struct otpinfo *) oh)->fn->read_region)
+						(oh, region, data, wlen);
 
  out:
 	return err;
@@ -537,7 +538,7 @@ otp_read_region(struct si_pub *sih, int region, u16 *data,
 
 int otp_nvread(void *oh, char *data, uint *len)
 {
-	otpinfo_t *oi = (otpinfo_t *) oh;
+	struct otpinfo *oi = (struct otpinfo *) oh;
 
 	return oi->fn->nvread(oh, data, len);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index b527e5f..57195a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -29,13 +29,12 @@
 
 u32 phyhal_msg_level = PHYHAL_ERROR;
 
-typedef struct _chan_info_basic {
+struct chan_info_basic {
 	u16 chan;
 	u16 freq;
-} chan_info_basic_t;
-
-static chan_info_basic_t chan_info_all[] = {
+};
 
+static struct chan_info_basic chan_info_all[] = {
 	{1, 2412},
 	{2, 2417},
 	{3, 2422},
@@ -469,11 +468,11 @@ static void WLBANDINITFN(wlc_set_phy_uninitted) (phy_info_t *pi)
 	}
 }
 
-shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp)
+struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 {
-	shared_phy_t *sh;
+	struct shared_phy *sh;
 
-	sh = kzalloc(sizeof(shared_phy_t), GFP_ATOMIC);
+	sh = kzalloc(sizeof(struct shared_phy), GFP_ATOMIC);
 	if (sh == NULL) {
 		return NULL;
 	}
@@ -506,7 +505,7 @@ shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp)
 	return sh;
 }
 
-wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
+wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 			  char *vars, struct wiphy *wiphy)
 {
 	phy_info_t *pi;
@@ -998,7 +997,7 @@ void wlc_phy_table_data_write(phy_info_t *pi, uint width, u32 val)
 }
 
 void
-wlc_phy_write_table(phy_info_t *pi, const phytbl_info_t *ptbl_info,
+wlc_phy_write_table(phy_info_t *pi, const struct phytbl_info *ptbl_info,
 		    u16 tblAddr, u16 tblDataHi, u16 tblDataLo)
 {
 	uint idx;
@@ -1038,7 +1037,7 @@ wlc_phy_write_table(phy_info_t *pi, const phytbl_info_t *ptbl_info,
 }
 
 void
-wlc_phy_read_table(phy_info_t *pi, const phytbl_info_t *ptbl_info,
+wlc_phy_read_table(phy_info_t *pi, const struct phytbl_info *ptbl_info,
 		   u16 tblAddr, u16 tblDataHi, u16 tblDataLo)
 {
 	uint idx;
@@ -1076,7 +1075,8 @@ wlc_phy_read_table(phy_info_t *pi, const phytbl_info_t *ptbl_info,
 }
 
 uint
-wlc_phy_init_radio_regs_allbands(phy_info_t *pi, radio_20xx_regs_t *radioregs)
+wlc_phy_init_radio_regs_allbands(phy_info_t *pi,
+				 struct radio_20xx_regs *radioregs)
 {
 	uint i = 0;
 
@@ -1093,7 +1093,7 @@ wlc_phy_init_radio_regs_allbands(phy_info_t *pi, radio_20xx_regs_t *radioregs)
 }
 
 uint
-wlc_phy_init_radio_regs(phy_info_t *pi, radio_regs_t *radioregs,
+wlc_phy_init_radio_regs(phy_info_t *pi, struct radio_regs *radioregs,
 			u16 core_offset)
 {
 	uint i = 0;
@@ -2440,7 +2440,7 @@ wlc_phy_noise_sample_request(wlc_phy_t *pih, u8 reason, u8 ch)
 			OR_REG(&pi->regs->maccommand,
 			       MCMD_BG_NOISE);
 		} else {
-			phy_iq_est_t est[PHY_CORE_MAX];
+			struct phy_iq_est est[PHY_CORE_MAX];
 			u32 cmplx_pwr[PHY_CORE_MAX];
 			s8 noise_dbm_ant[PHY_CORE_MAX];
 			u16 log_num_samps, num_samps, classif_state = 0;
@@ -2675,8 +2675,8 @@ void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_cmplx_pwr_dB, u8 core)
 
 void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
 {
-	wlc_d11rxhdr_t *wlc_rxhdr = (wlc_d11rxhdr_t *) ctx;
-	d11rxhdr_t *rxh = &wlc_rxhdr->rxhdr;
+	struct brcms_d11rxhdr *wlc_rxhdr = (struct brcms_d11rxhdr *) ctx;
+	struct d11rxhdr *rxh = &wlc_rxhdr->rxhdr;
 	int rssi = le16_to_cpu(rxh->PhyRxStatus_1) & PRXS1_JSSI_MASK;
 	uint radioid = pih->radioid;
 	phy_info_t *pi = (phy_info_t *) pih;
@@ -2694,7 +2694,7 @@ void wlc_phy_rssi_compute(wlc_phy_t *pih, void *ctx)
 
 	if (ISLCNPHY(pi)) {
 		u8 gidx = (le16_to_cpu(rxh->PhyRxStatus_2) & 0xFC00) >> 10;
-		phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+		struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 		if (rssi > 127)
 			rssi -= 256;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 0ea337b..d1d03a6 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -176,9 +176,9 @@ struct shared_phy_params {
 };
 
 
-extern shared_phy_t *wlc_phy_shared_attach(shared_phy_params_t *shp);
-extern wlc_phy_t *wlc_phy_attach(shared_phy_t *sh, void *regs, int bandtype,
-				 char *vars, struct wiphy *wiphy);
+extern struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp);
+extern wlc_phy_t *wlc_phy_attach(struct shared_phy *sh, void *regs,
+				 int bandtype, char *vars, struct wiphy *wiphy);
 extern void wlc_phy_detach(wlc_phy_t *ppi);
 
 extern bool wlc_phy_get_phyversion(wlc_phy_t *pih, u16 *phytype,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 0019c04..d8c86d9 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -41,7 +41,7 @@ extern u32 phyhal_msg_level;
 
 #define LCNXN_BASEREV		16
 
-struct wlc_phy_srom_fem {
+struct brcms_phy_srom_fem {
 	u8 tssipos;		/* TSSI positive slope, 1: positive, 0: negative */
 	u8 extpagain;	/* Ext PA gain-type: full-gain: 0, pa-lite: 1, no_pa: 2 */
 	u8 pdetrange;	/* support 32 combinations of different Pdet dynamic ranges */
@@ -441,11 +441,11 @@ struct txiqcal_cache {
 
 	u16 txcal_coeffs_2G[8];
 	u16 txcal_radio_regs_2G[8];
-	nphy_iq_comp_t rxcal_coeffs_2G;
+	struct nphy_iq_comp rxcal_coeffs_2G;
 
 	u16 txcal_coeffs_5G[8];
 	u16 txcal_radio_regs_5G[8];
-	nphy_iq_comp_t rxcal_coeffs_5G;
+	struct nphy_iq_comp rxcal_coeffs_5G;
 };
 
 struct nphy_pwrctrl {
@@ -595,12 +595,12 @@ struct phy_func_ptr {
 
 struct phy_info {
 	wlc_phy_t pubpi_ro;
-	shared_phy_t *sh;
-	phy_func_ptr_t pi_fptr;
+	struct shared_phy *sh;
+	struct phy_func_ptr pi_fptr;
 	void *pi_ptr;
 
 	union {
-		phy_info_lcnphy_t *pi_lcnphy;
+		struct phy_info_lcnphy *pi_lcnphy;
 	} u;
 	bool user_txpwr_at_rfport;
 
@@ -650,8 +650,8 @@ struct phy_info {
 	s8 tx_power_offset[TXP_NUM_RATES];
 	u8 tx_power_target[TXP_NUM_RATES];
 
-	wlc_phy_srom_fem_t srom_fem2g;
-	wlc_phy_srom_fem_t srom_fem5g;
+	struct brcms_phy_srom_fem srom_fem2g;
+	struct brcms_phy_srom_fem srom_fem5g;
 
 	u8 tx_power_max;
 	u8 tx_power_max_rate_ind;
@@ -722,7 +722,8 @@ struct phy_info {
 
 	u16 mintxbias;
 	u16 mintxmag;
-	lo_complex_abgphy_info_t gphy_locomp_iq[STATIC_NUM_RF][STATIC_NUM_BB];
+	struct lo_complex_abgphy_info gphy_locomp_iq
+					[STATIC_NUM_RF][STATIC_NUM_BB];
 	s8 stats_11b_txpower[STATIC_NUM_RF][STATIC_NUM_BB];
 	u16 gain_table[TX_GAIN_TABLE_LENGTH];
 	bool loopback_gain;
@@ -780,8 +781,8 @@ struct phy_info {
 	u32 nphy_bb_mult_save;
 	u16 nphy_txiqlocal_bestc[11];
 	bool nphy_txiqlocal_coeffsvalid;
-	phy_txpwrindex_t nphy_txpwrindex[PHY_CORE_NUM_2];
-	phy_pwrctrl_t nphy_pwrctrl_info[PHY_CORE_NUM_2];
+	struct nphy_txpwrindex nphy_txpwrindex[PHY_CORE_NUM_2];
+	struct nphy_pwrctrl nphy_pwrctrl_info[PHY_CORE_NUM_2];
 	u16 cck2gpo;
 	u32 ofdm2gpo;
 	u32 ofdm5gpo;
@@ -849,8 +850,8 @@ struct phy_info {
 	bool internal_tx_iqlo_cal_tapoff_intpa_nphy;
 	s16 nphy_lastcal_temp;
 
-	txiqcal_cache_t calibration_cache;
-	rssical_cache_t rssical_cache;
+	struct txiqcal_cache calibration_cache;
+	struct rssical_cache rssical_cache;
 
 	u8 nphy_txpwr_idx[2];
 	u8 nphy_papd_cal_type;
@@ -881,7 +882,7 @@ struct phy_info {
 	u8 nphy_txcal_pwr_idx[2];
 	u8 nphy_rxcal_pwr_idx[2];
 	u16 nphy_cal_orig_tx_gain[2];
-	nphy_txgains_t nphy_cal_target_gain;
+	struct nphy_txgains nphy_cal_target_gain;
 	u16 nphy_txcal_bbmult;
 	u16 nphy_gmval;
 
@@ -892,7 +893,7 @@ struct phy_info {
 	bool nphy_aband_spurwar_en;
 	u16 nphy_rccal_value;
 	u16 nphy_crsminpwr[3];
-	phy_noisevar_buf_t nphy_saved_noisevars;
+	struct nphy_noisevar_buf nphy_saved_noisevars;
 	bool nphy_anarxlpf_adjusted;
 	bool nphy_crsminpwr_adjusted;
 	bool nphy_noisevars_adjusted;
@@ -963,21 +964,23 @@ struct lcnphy_radio_regs {
 	u8 do_init_g;
 };
 
-extern lcnphy_radio_regs_t lcnphy_radio_regs_2064[];
-extern lcnphy_radio_regs_t lcnphy_radio_regs_2066[];
-extern radio_regs_t regs_2055[], regs_SYN_2056[], regs_TX_2056[],
+extern struct lcnphy_radio_regs lcnphy_radio_regs_2064[];
+extern struct lcnphy_radio_regs lcnphy_radio_regs_2066[];
+extern struct radio_regs regs_2055[], regs_SYN_2056[], regs_TX_2056[],
 	regs_RX_2056[];
-extern radio_regs_t regs_SYN_2056_A1[], regs_TX_2056_A1[], regs_RX_2056_A1[];
-extern radio_regs_t regs_SYN_2056_rev5[], regs_TX_2056_rev5[],
+extern struct radio_regs regs_SYN_2056_A1[], regs_TX_2056_A1[],
+	      regs_RX_2056_A1[];
+extern struct radio_regs regs_SYN_2056_rev5[], regs_TX_2056_rev5[],
 	regs_RX_2056_rev5[];
-extern radio_regs_t regs_SYN_2056_rev6[], regs_TX_2056_rev6[],
+extern struct radio_regs regs_SYN_2056_rev6[], regs_TX_2056_rev6[],
 	regs_RX_2056_rev6[];
-extern radio_regs_t regs_SYN_2056_rev7[], regs_TX_2056_rev7[],
+extern struct radio_regs regs_SYN_2056_rev7[], regs_TX_2056_rev7[],
 	regs_RX_2056_rev7[];
-extern radio_regs_t regs_SYN_2056_rev8[], regs_TX_2056_rev8[],
+extern struct radio_regs regs_SYN_2056_rev8[], regs_TX_2056_rev8[],
 	regs_RX_2056_rev8[];
-extern radio_20xx_regs_t regs_2057_rev4[], regs_2057_rev5[], regs_2057_rev5v1[];
-extern radio_20xx_regs_t regs_2057_rev7[], regs_2057_rev8[];
+extern struct radio_20xx_regs regs_2057_rev4[], regs_2057_rev5[],
+	      regs_2057_rev5v1[];
+extern struct radio_20xx_regs regs_2057_rev7[], regs_2057_rev8[];
 
 extern char *phy_getvar(phy_info_t *pi, const char *name);
 extern int phy_getintvar(phy_info_t *pi, const char *name);
@@ -1004,12 +1007,13 @@ extern void wlc_phyreg_exit(wlc_phy_t *pih);
 extern void wlc_radioreg_enter(wlc_phy_t *pih);
 extern void wlc_radioreg_exit(wlc_phy_t *pih);
 
-extern void wlc_phy_read_table(phy_info_t *pi, const phytbl_info_t *ptbl_info,
+extern void wlc_phy_read_table(phy_info_t *pi,
+			       const struct phytbl_info *ptbl_info,
 			       u16 tblAddr, u16 tblDataHi,
 			       u16 tblDatalo);
 extern void wlc_phy_write_table(phy_info_t *pi,
-				const phytbl_info_t *ptbl_info, u16 tblAddr,
-				u16 tblDataHi, u16 tblDatalo);
+				const struct phytbl_info *ptbl_info,
+				u16 tblAddr, u16 tblDataHi, u16 tblDatalo);
 extern void wlc_phy_table_addr(phy_info_t *pi, uint tbl_id, uint tbl_offset,
 			       u16 tblAddr, u16 tblDataHi,
 			       u16 tblDataLo);
@@ -1023,8 +1027,9 @@ extern u8 wlc_phy_nbits(s32 value);
 extern void wlc_phy_compute_dB(u32 *cmplx_pwr, s8 *p_dB, u8 core);
 
 extern uint wlc_phy_init_radio_regs_allbands(phy_info_t *pi,
-					     radio_20xx_regs_t *radioregs);
-extern uint wlc_phy_init_radio_regs(phy_info_t *pi, radio_regs_t *radioregs,
+					     struct radio_20xx_regs *radioregs);
+extern uint wlc_phy_init_radio_regs(phy_info_t *pi,
+				    struct radio_regs *radioregs,
 				    u16 core_offset);
 
 extern void wlc_phy_txpower_ipa_upd(phy_info_t *pi);
@@ -1101,8 +1106,9 @@ extern void wlc_phy_txpower_recalc_target(phy_info_t *pi);
 
 #define LCNPHY_TX_PWR_CTRL_TEMPBASED	0xE001
 
-extern void wlc_lcnphy_write_table(phy_info_t *pi, const phytbl_info_t *pti);
-extern void wlc_lcnphy_read_table(phy_info_t *pi, phytbl_info_t *pti);
+extern void wlc_lcnphy_write_table(phy_info_t *pi,
+				   const struct phytbl_info *pti);
+extern void wlc_lcnphy_read_table(phy_info_t *pi, struct phytbl_info *pti);
 extern void wlc_lcnphy_set_tx_iqcc(phy_info_t *pi, u16 a, u16 b);
 extern void wlc_lcnphy_set_tx_locc(phy_info_t *pi, u16 didq);
 extern void wlc_lcnphy_get_tx_iqcc(phy_info_t *pi, u16 *a, u16 *b);
@@ -1167,12 +1173,12 @@ extern s16 wlc_phy_tempsense_nphy(phy_info_t *pi);
 
 extern u16 wlc_phy_classifier_nphy(phy_info_t *pi, u16 mask, u16 val);
 
-extern void wlc_phy_rx_iq_est_nphy(phy_info_t *pi, phy_iq_est_t *est,
+extern void wlc_phy_rx_iq_est_nphy(phy_info_t *pi, struct phy_iq_est *est,
 				   u16 num_samps, u8 wait_time,
 				   u8 wait_for_crs);
 
 extern void wlc_phy_rx_iq_coeffs_nphy(phy_info_t *pi, u8 write,
-				      nphy_iq_comp_t *comp);
+				      struct nphy_iq_comp *comp);
 extern void wlc_phy_aci_and_noise_reduction_nphy(phy_info_t *pi);
 
 extern void wlc_phy_rxcore_setstate_nphy(wlc_phy_t *pih, u8 rxcore_bitmask);
@@ -1184,10 +1190,12 @@ extern void wlc_phy_txpwr_apply_nphy(phy_info_t *pi);
 extern void wlc_phy_txpwr_papd_cal_nphy(phy_info_t *pi);
 extern u16 wlc_phy_txpwr_idx_get_nphy(phy_info_t *pi);
 
-extern nphy_txgains_t wlc_phy_get_tx_gain_nphy(phy_info_t *pi);
-extern int wlc_phy_cal_txiqlo_nphy(phy_info_t *pi, nphy_txgains_t target_gain,
+extern struct nphy_txgains wlc_phy_get_tx_gain_nphy(phy_info_t *pi);
+extern int wlc_phy_cal_txiqlo_nphy(phy_info_t *pi,
+				   struct nphy_txgains target_gain,
 				   bool full, bool m);
-extern int wlc_phy_cal_rxiq_nphy(phy_info_t *pi, nphy_txgains_t target_gain,
+extern int wlc_phy_cal_rxiq_nphy(phy_info_t *pi,
+				 struct nphy_txgains target_gain,
 				 u8 type, bool d);
 extern void wlc_phy_txpwr_index_nphy(phy_info_t *pi, u8 core_mask,
 				     s8 txpwrindex, bool res);
@@ -1205,7 +1213,8 @@ extern void wlc_phy_est_tonepwr_nphy(phy_info_t *pi, s32 *qdBm_pwrbuf,
 				     u8 num_samps);
 extern void wlc_phy_radio205x_vcocal_nphy(phy_info_t *pi);
 
-extern int wlc_phy_rssi_compute_nphy(phy_info_t *pi, wlc_d11rxhdr_t *wlc_rxh);
+extern int wlc_phy_rssi_compute_nphy(phy_info_t *pi,
+				     struct brcms_d11rxhdr *wlc_rxh);
 
 #define NPHY_TESTPATTERN_BPHY_EVM   0
 #define NPHY_TESTPATTERN_BPHY_RFCS  1
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index 3b61beb..47a0a1a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -136,60 +136,55 @@
 	(0 != (read_phy_reg((pi), 0x43b) & (0x1 << 6)))
 
 #define wlc_lcnphy_total_tx_frames(pi) \
-	wlapi_bmac_read_shm((pi)->sh->physhim, M_UCODE_MACSTAT + offsetof(macstat_t, txallfrm))
+	wlapi_bmac_read_shm((pi)->sh->physhim, \
+		M_UCODE_MACSTAT + offsetof(struct macstat, txallfrm))
 
-typedef struct {
+struct lcnphy_txgains {
 	u16 gm_gain;
 	u16 pga_gain;
 	u16 pad_gain;
 	u16 dac_gain;
-} lcnphy_txgains_t;
+};
 
-typedef enum {
+enum lcnphy_cal_mode {
 	LCNPHY_CAL_FULL,
 	LCNPHY_CAL_RECAL,
 	LCNPHY_CAL_CURRECAL,
 	LCNPHY_CAL_DIGCAL,
 	LCNPHY_CAL_GCTRL
-} lcnphy_cal_mode_t;
-
-typedef struct {
-	lcnphy_txgains_t gains;
-	bool useindex;
-	u8 index;
-} lcnphy_txcalgains_t;
+};
 
-typedef struct {
+struct lcnphy_rx_iqcomp {
 	u8 chan;
 	s16 a;
 	s16 b;
-} lcnphy_rx_iqcomp_t;
+};
 
-typedef struct {
+struct lcnphy_spb_tone {
 	s16 re;
 	s16 im;
-} lcnphy_spb_tone_t;
+};
 
-typedef struct {
+struct lcnphy_unsign16_struct {
 	u16 re;
 	u16 im;
-} lcnphy_unsign16_struct;
+};
 
-typedef struct {
+struct lcnphy_iq_est {
 	u32 iq_prod;
 	u32 i_pwr;
 	u32 q_pwr;
-} lcnphy_iq_est_t;
+};
 
-typedef struct {
+struct lcnphy_sfo_cfg {
 	u16 ptcentreTs20;
 	u16 ptcentreFactor;
-} lcnphy_sfo_cfg_t;
+};
 
-typedef enum {
+enum lcnphy_papd_cal_type {
 	LCNPHY_PAPD_CAL_CW,
 	LCNPHY_PAPD_CAL_OFDM
-} lcnphy_papd_cal_type_t;
+};
 
 typedef u16 iqcal_gain_params_lcnphy[9];
 
@@ -206,7 +201,7 @@ static const u16 iqcal_gainparams_numgains_lcnphy[1] = {
 	    sizeof(*tbl_iqcal_gainparams_lcnphy_2G),
 };
 
-static const lcnphy_sfo_cfg_t lcnphy_sfo_cfg[] = {
+static const struct lcnphy_sfo_cfg lcnphy_sfo_cfg[] = {
 	{965, 1087},
 	{967, 1085},
 	{969, 1082},
@@ -272,7 +267,7 @@ u16 lcnphy_iqcal_ir_gainladder[] = {
 };
 
 static const
-lcnphy_spb_tone_t lcnphy_spb_tone_3750[] = {
+struct lcnphy_spb_tone lcnphy_spb_tone_3750[] = {
 	{88, 0},
 	{73, 49},
 	{34, 81},
@@ -365,7 +360,7 @@ u16 rxiq_cal_rf_reg[11] = {
 };
 
 static const
-lcnphy_rx_iqcomp_t lcnphy_rx_iqcomp_table_rev0[] = {
+struct lcnphy_rx_iqcomp lcnphy_rx_iqcomp_table_rev0[] = {
 	{1, 0, 0},
 	{2, 0, 0},
 	{3, 0, 0},
@@ -542,11 +537,11 @@ static const s8 lcnphy_gain_index_offset_for_rssi[] = {
 
 extern const u8 spur_tbl_rev0[];
 extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev1;
-extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev1[];
-extern const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
-extern const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250;
+extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev1[];
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250;
 
-typedef struct _chan_info_2064_lcnphy {
+struct chan_info_2064_lcnphy {
 	uint chan;
 	uint freq;
 	u8 logen_buftune;
@@ -557,9 +552,9 @@ typedef struct _chan_info_2064_lcnphy {
 	u8 pa_rxrf_lna1_freq_tune;
 	u8 pa_rxrf_lna2_freq_tune;
 	u8 rxrf_rxrf_spare1;
-} chan_info_2064_lcnphy_t;
+};
 
-static chan_info_2064_lcnphy_t chan_info_2064_lcnphy[] = {
+static struct chan_info_2064_lcnphy chan_info_2064_lcnphy[] = {
 	{1, 2412, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 	{2, 2417, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 	{3, 2422, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
@@ -576,7 +571,7 @@ static chan_info_2064_lcnphy_t chan_info_2064_lcnphy[] = {
 	{14, 2484, 0x0B, 0x0A, 0x00, 0x07, 0x0A, 0x88, 0x88, 0x80},
 };
 
-lcnphy_radio_regs_t lcnphy_radio_regs_2064[] = {
+struct lcnphy_radio_regs lcnphy_radio_regs_2064[] = {
 	{0x00, 0, 0, 0, 0},
 	{0x01, 0x64, 0x64, 0, 0},
 	{0x02, 0x20, 0x20, 0, 0},
@@ -982,14 +977,15 @@ static void wlc_lcnphy_set_pa_gain(phy_info_t *pi, u16 gain);
 static void wlc_lcnphy_set_trsw_override(phy_info_t *pi, bool tx, bool rx);
 static void wlc_lcnphy_set_bbmult(phy_info_t *pi, u8 m0);
 static u8 wlc_lcnphy_get_bbmult(phy_info_t *pi);
-static void wlc_lcnphy_get_tx_gain(phy_info_t *pi, lcnphy_txgains_t *gains);
+static void wlc_lcnphy_get_tx_gain(phy_info_t *pi,
+				   struct lcnphy_txgains *gains);
 static void wlc_lcnphy_set_tx_gain_override(phy_info_t *pi, bool bEnable);
 static void wlc_lcnphy_toggle_afe_pwdn(phy_info_t *pi);
 static void wlc_lcnphy_rx_gain_override_enable(phy_info_t *pi, bool enable);
 static void wlc_lcnphy_set_tx_gain(phy_info_t *pi,
-				   lcnphy_txgains_t *target_gains);
+				   struct lcnphy_txgains *target_gains);
 static bool wlc_lcnphy_rx_iq_est(phy_info_t *pi, u16 num_samps,
-				 u8 wait_time, lcnphy_iq_est_t *iq_est);
+				 u8 wait_time, struct lcnphy_iq_est *iq_est);
 static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps);
 static u16 wlc_lcnphy_get_pa_gain(phy_info_t *pi);
 static void wlc_lcnphy_afe_clk_init(phy_info_t *pi, u8 mode);
@@ -998,7 +994,7 @@ static void wlc_lcnphy_radio_2064_channel_tune_4313(phy_info_t *pi,
 						    u8 channel);
 
 static void wlc_lcnphy_load_tx_gain_table(phy_info_t *pi,
-					  const lcnphy_tx_gain_tbl_entry *g);
+				  const struct lcnphy_tx_gain_tbl_entry *g);
 
 static void wlc_lcnphy_samp_cap(phy_info_t *pi, int clip_detect_algo,
 				u16 thresh, s16 *ptr, int mode);
@@ -1009,7 +1005,8 @@ static void wlc_lcnphy_tx_iqlo_loopback_cleanup(phy_info_t *pi,
 						u16 *values_to_save);
 static void wlc_lcnphy_set_cc(phy_info_t *pi, int cal_type, s16 coeff_x,
 			      s16 coeff_y);
-static lcnphy_unsign16_struct wlc_lcnphy_get_cc(phy_info_t *pi, int cal_type);
+static struct lcnphy_unsign16_struct wlc_lcnphy_get_cc(phy_info_t *pi,
+						       int cal_type);
 static void wlc_lcnphy_a1(phy_info_t *pi, int cal_type,
 			  int num_levels, int step_size_lg2);
 static void wlc_lcnphy_tx_iqlo_soft_cal_full(phy_info_t *pi);
@@ -1028,12 +1025,12 @@ static int wlc_lcnphy_load_tx_iir_filter(phy_info_t *pi, bool is_ofdm,
 					 s16 filt_type);
 static void wlc_lcnphy_set_rx_iq_comp(phy_info_t *pi, u16 a, u16 b);
 
-void wlc_lcnphy_write_table(phy_info_t *pi, const phytbl_info_t *pti)
+void wlc_lcnphy_write_table(phy_info_t *pi, const struct phytbl_info *pti)
 {
 	wlc_phy_write_table(pi, pti, 0x455, 0x457, 0x456);
 }
 
-void wlc_lcnphy_read_table(phy_info_t *pi, phytbl_info_t *pti)
+void wlc_lcnphy_read_table(phy_info_t *pi, struct phytbl_info *pti)
 {
 	wlc_phy_read_table(pi, pti, 0x455, 0x457, 0x456);
 }
@@ -1043,7 +1040,7 @@ wlc_lcnphy_common_read_table(phy_info_t *pi, u32 tbl_id,
 			     const void *tbl_ptr, u32 tbl_len,
 			     u32 tbl_width, u32 tbl_offset)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	tab.tbl_id = tbl_id;
 	tab.tbl_ptr = tbl_ptr;
 	tab.tbl_len = tbl_len;
@@ -1058,7 +1055,7 @@ wlc_lcnphy_common_write_table(phy_info_t *pi, u32 tbl_id,
 			      u32 tbl_width, u32 tbl_offset)
 {
 
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	tab.tbl_id = tbl_id;
 	tab.tbl_ptr = tbl_ptr;
 	tab.tbl_len = tbl_len;
@@ -1116,7 +1113,7 @@ static int wlc_lcnphy_calc_floor(s16 coeff_x, int type)
 s8 wlc_lcnphy_get_current_tx_pwr_idx(phy_info_t *pi)
 {
 	s8 index;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (txpwrctrl_off(pi))
 		index = pi_lcn->lcnphy_current_index;
@@ -1131,7 +1128,7 @@ s8 wlc_lcnphy_get_current_tx_pwr_idx(phy_info_t *pi)
 
 static u32 wlc_lcnphy_measure_digital_power(phy_info_t *pi, u16 nsamples)
 {
-	lcnphy_iq_est_t iq_est = { 0, 0, 0 };
+	struct lcnphy_iq_est iq_est = { 0, 0, 0 };
 
 	if (!wlc_lcnphy_rx_iq_est(pi, nsamples, 32, &iq_est))
 		return 0;
@@ -1276,7 +1273,7 @@ static u16 wlc_lcnphy_get_pa_gain(phy_info_t *pi)
 }
 
 static void
-wlc_lcnphy_set_tx_gain(phy_info_t *pi, lcnphy_txgains_t *target_gains)
+wlc_lcnphy_set_tx_gain(phy_info_t *pi, struct lcnphy_txgains *target_gains)
 {
 	u16 pa_gain = wlc_lcnphy_get_pa_gain(pi);
 
@@ -1304,7 +1301,7 @@ wlc_lcnphy_set_tx_gain(phy_info_t *pi, lcnphy_txgains_t *target_gains)
 static void wlc_lcnphy_set_bbmult(phy_info_t *pi, u8 m0)
 {
 	u16 m0m1 = (u16) m0 << 8;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 
 	tab.tbl_ptr = &m0m1;
 	tab.tbl_len = 1;
@@ -1317,7 +1314,7 @@ static void wlc_lcnphy_set_bbmult(phy_info_t *pi, u8 m0)
 static void wlc_lcnphy_clear_tx_power_offsets(phy_info_t *pi)
 {
 	u32 data_buf[64];
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 
 	memset(data_buf, 0, sizeof(data_buf));
 
@@ -1337,13 +1334,13 @@ static void wlc_lcnphy_clear_tx_power_offsets(phy_info_t *pi)
 	wlc_lcnphy_write_table(pi, &tab);
 }
 
-typedef enum {
+enum lcnphy_tssi_mode {
 	LCNPHY_TSSI_PRE_PA,
 	LCNPHY_TSSI_POST_PA,
 	LCNPHY_TSSI_EXT
-} lcnphy_tssi_mode_t;
+};
 
-static void wlc_lcnphy_set_tssi_mux(phy_info_t *pi, lcnphy_tssi_mode_t pos)
+static void wlc_lcnphy_set_tssi_mux(phy_info_t *pi, enum lcnphy_tssi_mode pos)
 {
 	mod_phy_reg(pi, 0x4d7, (0x1 << 0), (0x1) << 0);
 
@@ -1406,7 +1403,7 @@ static u16 wlc_lcnphy_rfseq_tbl_adc_pwrup(phy_info_t *pi)
 static void wlc_lcnphy_pwrctrl_rssiparams(phy_info_t *pi)
 {
 	u16 auxpga_vmid, auxpga_vmid_temp, auxpga_gain_temp;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	auxpga_vmid =
 	    (2 << 8) | (pi_lcn->lcnphy_rssi_vc << 4) | pi_lcn->lcnphy_rssi_vf;
@@ -1449,7 +1446,7 @@ static void wlc_lcnphy_pwrctrl_rssiparams(phy_info_t *pi)
 
 static void wlc_lcnphy_tssi_setup(phy_info_t *pi)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 rfseq, ind;
 
 	tab.tbl_id = LCNPHY_TBL_ID_TXPWRCTL;
@@ -1564,7 +1561,7 @@ static void wlc_lcnphy_tssi_setup(phy_info_t *pi)
 void wlc_lcnphy_tx_pwr_update_npt(phy_info_t *pi)
 {
 	u16 tx_cnt, tx_total, npt;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	tx_total = wlc_lcnphy_total_tx_frames(pi);
 	tx_cnt = tx_total - pi_lcn->lcnphy_tssi_tx_cnt;
@@ -1593,7 +1590,7 @@ s32 wlc_lcnphy_tssi2dbm(s32 tssi, s32 a1, s32 b0, s32 b1)
 
 static void wlc_lcnphy_txpower_reset_npt(phy_info_t *pi)
 {
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
 		return;
 
@@ -1603,7 +1600,7 @@ static void wlc_lcnphy_txpower_reset_npt(phy_info_t *pi)
 
 void wlc_lcnphy_txpower_recalc_target(phy_info_t *pi)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 rate_table[WLC_NUM_RATES_CCK + WLC_NUM_RATES_OFDM +
 			  WLC_NUM_RATES_MCS_1_STREAM];
 	uint i, j;
@@ -1638,7 +1635,7 @@ static void wlc_lcnphy_set_tx_pwr_soft_ctrl(phy_info_t *pi, s8 index)
 	u32 ofdm_offset, reg_offset_cck;
 	int i;
 	u16 index2;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 
 	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
 		return;
@@ -1691,7 +1688,7 @@ static s8 wlc_lcnphy_tempcompensated_txpwrctrl(phy_info_t *pi)
 	s16 manp, meas_temp, temp_diff;
 	bool neg = 0;
 	u16 temp;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi))
 		return pi_lcn->lcnphy_current_index;
@@ -1767,7 +1764,7 @@ void wlc_lcnphy_set_tx_pwr_ctrl(phy_info_t *pi, u16 mode)
 {
 	u16 old_mode = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	s8 index;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, mode);
 	old_mode = wlc_lcnphy_set_tx_pwr_ctrl_mode(pi, old_mode);
@@ -1831,11 +1828,11 @@ static bool wlc_lcnphy_iqcal_wait(phy_info_t *pi)
 
 static void
 wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
-		       lcnphy_txgains_t *target_gains,
-		       lcnphy_cal_mode_t cal_mode, bool keep_tone)
+		       struct lcnphy_txgains *target_gains,
+		       enum lcnphy_cal_mode cal_mode, bool keep_tone)
 {
 
-	lcnphy_txgains_t cal_gains, temp_gains;
+	struct lcnphy_txgains cal_gains, temp_gains;
 	u16 hash;
 	u8 band_idx;
 	int j;
@@ -1861,10 +1858,10 @@ wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
 	u16 tx_pwr_ctrl_old, save_txpwrctrlrfctrl2;
 	u16 save_sslpnCalibClkEnCtrl, save_sslpnRxFeClkEnCtrl;
 	bool tx_gain_override_old;
-	lcnphy_txgains_t old_gains;
+	struct lcnphy_txgains old_gains;
 	uint i, n_cal_cmds = 0, n_cal_start = 0;
 	u16 *values_to_save;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -2068,7 +2065,7 @@ wlc_lcnphy_tx_iqlo_cal(phy_info_t *pi,
 static void wlc_lcnphy_idle_tssi_est(wlc_phy_t *ppi)
 {
 	bool suspend, tx_gain_override_old;
-	lcnphy_txgains_t old_gains;
+	struct lcnphy_txgains old_gains;
 	phy_info_t *pi = (phy_info_t *) ppi;
 	u16 idleTssi, idleTssi0_2C, idleTssi0_OB, idleTssi0_regvalue_OB,
 	    idleTssi0_regvalue_2C;
@@ -2137,14 +2134,14 @@ static void wlc_lcnphy_vbat_temp_sense_setup(phy_info_t *pi, u8 mode)
 	u16 save_txpwrCtrlEn;
 	u8 auxpga_vmidcourse, auxpga_vmidfine, auxpga_gain;
 	u16 auxpga_vmid;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 val;
 	u8 save_reg007, save_reg0FF, save_reg11F, save_reg005, save_reg025,
 	    save_reg112;
 	u16 values_to_save[14];
 	s8 index;
 	int i;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	udelay(999);
 
 	save_reg007 = (u8) read_radio_reg(pi, RADIO_2064_REG007);
@@ -2275,9 +2272,9 @@ static void wlc_lcnphy_vbat_temp_sense_setup(phy_info_t *pi, u8 mode)
 
 void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (wlc_phy_t *ppi)
 {
-	lcnphy_txgains_t tx_gains;
+	struct lcnphy_txgains tx_gains;
 	u8 bbmult;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	s32 a1, b0, b1;
 	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
 	bool suspend;
@@ -2354,7 +2351,7 @@ void WLBANDINITFN(wlc_lcnphy_tx_pwr_ctrl_init) (wlc_phy_t *ppi)
 static u8 wlc_lcnphy_get_bbmult(phy_info_t *pi)
 {
 	u16 m0m1;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 
 	tab.tbl_ptr = &m0m1;
 	tab.tbl_len = 1;
@@ -2386,7 +2383,7 @@ wlc_lcnphy_get_radio_loft(phy_info_t *pi,
 	*fq0 = LCNPHY_IQLOCC_READ(read_radio_reg(pi, RADIO_2064_REG08C));
 }
 
-static void wlc_lcnphy_get_tx_gain(phy_info_t *pi, lcnphy_txgains_t *gains)
+static void wlc_lcnphy_get_tx_gain(phy_info_t *pi, struct lcnphy_txgains *gains)
 {
 	u16 dac_gain;
 
@@ -2407,7 +2404,7 @@ static void wlc_lcnphy_get_tx_gain(phy_info_t *pi, lcnphy_txgains_t *gains)
 
 void wlc_lcnphy_set_tx_iqcc(phy_info_t *pi, u16 a, u16 b)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u16 iqcc[2];
 
 	iqcc[0] = a;
@@ -2423,7 +2420,7 @@ void wlc_lcnphy_set_tx_iqcc(phy_info_t *pi, u16 a, u16 b)
 
 void wlc_lcnphy_set_tx_locc(phy_info_t *pi, u16 didq)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 
 	tab.tbl_id = LCNPHY_TBL_ID_IQLOCAL;
 	tab.tbl_width = 16;
@@ -2435,12 +2432,12 @@ void wlc_lcnphy_set_tx_locc(phy_info_t *pi, u16 didq)
 
 void wlc_lcnphy_set_tx_pwr_by_index(phy_info_t *pi, int index)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u16 a, b;
 	u8 bb_mult;
 	u32 bbmultiqcomp, txgain, locoeffs, rfpower;
-	lcnphy_txgains_t gains;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct lcnphy_txgains gains;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	pi_lcn->lcnphy_tx_power_idx_override = (s8) index;
 	pi_lcn->lcnphy_current_index = (u8) index;
@@ -2505,7 +2502,7 @@ static void wlc_lcnphy_set_trsw_override(phy_info_t *pi, bool tx, bool rx)
 static void wlc_lcnphy_clear_papd_comptable(phy_info_t *pi)
 {
 	u32 j;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 temp_offset[128];
 	tab.tbl_ptr = temp_offset;
 	tab.tbl_len = 128;
@@ -2720,8 +2717,8 @@ wlc_lcnphy_start_tx_tone(phy_info_t *pi, s32 f_kHz, u16 max_val,
 	cs32 tone_samp;
 	u32 data_buf[64];
 	u16 i_samp, q_samp;
-	phytbl_info_t tab;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phytbl_info tab;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	pi->phy_tx_tone_freq = f_kHz;
 
@@ -2776,7 +2773,7 @@ wlc_lcnphy_start_tx_tone(phy_info_t *pi, s32 f_kHz, u16 max_val,
 void wlc_lcnphy_stop_tx_tone(phy_info_t *pi)
 {
 	s16 playback_status;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	pi->phy_tx_tone_freq = 0;
 	if (pi_lcn->lcnphy_spurmod) {
@@ -2813,7 +2810,7 @@ static void wlc_lcnphy_clear_trsw_override(phy_info_t *pi)
 void wlc_lcnphy_get_tx_iqcc(phy_info_t *pi, u16 *a, u16 *b)
 {
 	u16 iqcc[2];
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 
 	tab.tbl_ptr = iqcc;
 	tab.tbl_len = 2;
@@ -2828,7 +2825,7 @@ void wlc_lcnphy_get_tx_iqcc(phy_info_t *pi, u16 *a, u16 *b)
 
 u16 wlc_lcnphy_get_tx_locc(phy_info_t *pi)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u16 didq;
 
 	tab.tbl_id = 0;
@@ -2844,15 +2841,15 @@ u16 wlc_lcnphy_get_tx_locc(phy_info_t *pi)
 static void wlc_lcnphy_txpwrtbl_iqlo_cal(phy_info_t *pi)
 {
 
-	lcnphy_txgains_t target_gains, old_gains;
+	struct lcnphy_txgains target_gains, old_gains;
 	u8 save_bb_mult;
 	u16 a, b, didq, save_pa_gain = 0;
 	uint idx, SAVE_txpwrindex = 0xFF;
 	u32 val;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u8 ei0, eq0, fi0, fq0;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	wlc_lcnphy_get_tx_gain(pi, &old_gains);
 	save_pa_gain = wlc_lcnphy_get_pa_gain(pi);
@@ -3006,7 +3003,7 @@ u16 wlc_lcnphy_tempsense(phy_info_t *pi, bool mode)
 	s32 avg = 0;
 	bool suspend = 0;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return -1;
@@ -3123,7 +3120,7 @@ static void wlc_lcnphy_afe_clk_init(phy_info_t *pi, u8 mode)
 static bool
 wlc_lcnphy_rx_iq_est(phy_info_t *pi,
 		     u16 num_samps,
-		     u8 wait_time, lcnphy_iq_est_t *iq_est)
+		     u8 wait_time, struct lcnphy_iq_est *iq_est)
 {
 	int wait_count = 0;
 	bool result = true;
@@ -3172,12 +3169,12 @@ static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps)
 #define LCNPHY_MIN_RXIQ_PWR 2
 	bool result;
 	u16 a0_new, b0_new;
-	lcnphy_iq_est_t iq_est = { 0, 0, 0 };
+	struct lcnphy_iq_est iq_est = { 0, 0, 0 };
 	s32 a, b, temp;
 	s16 iq_nbits, qq_nbits, arsh, brsh;
 	s32 iq;
 	u32 ii, qq;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	a0_new = ((read_phy_reg(pi, 0x645) & (0x3ff << 0)) >> 0);
 	b0_new = ((read_phy_reg(pi, 0x646) & (0x3ff << 0)) >> 0);
@@ -3253,11 +3250,11 @@ static bool wlc_lcnphy_calc_rx_iq_comp(phy_info_t *pi, u16 num_samps)
 }
 
 static bool
-wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const lcnphy_rx_iqcomp_t *iqcomp,
+wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const struct lcnphy_rx_iqcomp *iqcomp,
 		     int iqcomp_sz, bool tx_switch, bool rx_switch, int module,
 		     int tx_gain_idx)
 {
-	lcnphy_txgains_t old_gains;
+	struct lcnphy_txgains old_gains;
 	u16 tx_pwr_ctrl;
 	u8 tx_gain_index_old = 0;
 	bool result = false, tx_gain_override_old = false;
@@ -3270,7 +3267,7 @@ wlc_lcnphy_rx_iq_cal(phy_info_t *pi, const lcnphy_rx_iqcomp_t *iqcomp,
 	u16 old_sslpnCalibClkEnCtrl, old_sslpnRxFeClkEnCtrl;
 	u16 values_to_save[11];
 	s16 *ptr;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
 	if (NULL == ptr) {
@@ -3432,7 +3429,7 @@ static void wlc_lcnphy_glacial_timer_based_cal(phy_info_t *pi)
 	bool suspend;
 	s8 index;
 	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	suspend =
 	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend)
@@ -3455,14 +3452,14 @@ static void wlc_lcnphy_glacial_timer_based_cal(phy_info_t *pi)
 static void wlc_lcnphy_periodic_cal(phy_info_t *pi)
 {
 	bool suspend, full_cal;
-	const lcnphy_rx_iqcomp_t *rx_iqcomp;
+	const struct lcnphy_rx_iqcomp *rx_iqcomp;
 	int rx_iqcomp_sz;
 	u16 SAVE_pwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	s8 index;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	s32 a1, b0, b1;
 	s32 tssi, pwr, maxtargetpwr, mintargetpwr;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -3528,7 +3525,7 @@ void wlc_lcnphy_calib_modes(phy_info_t *pi, uint mode)
 {
 	u16 temp_new;
 	int temp1, temp2, temp_diff;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	switch (mode) {
 	case PHY_PERICAL_CHAN:
@@ -3594,7 +3591,7 @@ void WLBANDINITFN(wlc_phy_cal_init_lcnphy) (phy_info_t *pi)
 static void wlc_lcnphy_set_chanspec_tweaks(phy_info_t *pi, chanspec_t chanspec)
 {
 	u8 channel = CHSPEC_CHANNEL(chanspec);
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -3648,7 +3645,7 @@ void wlc_lcnphy_tx_power_adjustment(wlc_phy_t *ppi)
 	s8 index;
 	u16 index2;
 	phy_info_t *pi = (phy_info_t *) ppi;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	u16 SAVE_txpwrctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi) && SAVE_txpwrctrl) {
 		index = wlc_lcnphy_tempcompensated_txpwrctrl(pi);
@@ -3679,7 +3676,7 @@ static void wlc_lcnphy_set_rx_iq_comp(phy_info_t *pi, u16 a, u16 b)
 void WLBANDINITFN(wlc_phy_init_lcnphy) (phy_info_t *pi)
 {
 	u8 phybw40;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
 	pi_lcn->lcnphy_cal_counter = 0;
@@ -3826,7 +3823,7 @@ wlc_lcnphy_samp_cap(phy_info_t *pi, int clip_detect_algo, u16 thresh,
 	u16 sslpnCalibClkEnCtrl, timer;
 	u16 old_sslpnCalibClkEnCtrl;
 	s16 imag, real;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	timer = 0;
 	old_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
@@ -3897,7 +3894,7 @@ wlc_lcnphy_samp_cap(phy_info_t *pi, int clip_detect_algo, u16 thresh,
 
 static void wlc_lcnphy_tx_iqlo_soft_cal_full(phy_info_t *pi)
 {
-	lcnphy_unsign16_struct iqcc0, locc2, locc3, locc4;
+	struct lcnphy_unsign16_struct iqcc0, locc2, locc3, locc4;
 
 	wlc_lcnphy_set_cc(pi, 0, 0, 0);
 	wlc_lcnphy_set_cc(pi, 2, 0, 0);
@@ -3962,11 +3959,12 @@ wlc_lcnphy_set_cc(phy_info_t *pi, int cal_type, s16 coeff_x, s16 coeff_y)
 	}
 }
 
-static lcnphy_unsign16_struct wlc_lcnphy_get_cc(phy_info_t *pi, int cal_type)
+static struct lcnphy_unsign16_struct
+wlc_lcnphy_get_cc(phy_info_t *pi, int cal_type)
 {
 	u16 a, b, didq;
 	u8 di0, dq0, ei, eq, fi, fq;
-	lcnphy_unsign16_struct cc;
+	struct lcnphy_unsign16_struct cc;
 	cc.re = 0;
 	cc.im = 0;
 	switch (cal_type) {
@@ -3999,9 +3997,9 @@ static lcnphy_unsign16_struct wlc_lcnphy_get_cc(phy_info_t *pi, int cal_type)
 static void
 wlc_lcnphy_a1(phy_info_t *pi, int cal_type, int num_levels, int step_size_lg2)
 {
-	const lcnphy_spb_tone_t *phy_c1;
-	lcnphy_spb_tone_t phy_c2;
-	lcnphy_unsign16_struct phy_c3;
+	const struct lcnphy_spb_tone *phy_c1;
+	struct lcnphy_spb_tone phy_c2;
+	struct lcnphy_unsign16_struct phy_c3;
 	int phy_c4, phy_c5, k, l, j, phy_c6;
 	u16 phy_c7, phy_c8, phy_c9;
 	s16 phy_c10, phy_c11, phy_c12, phy_c13, phy_c14, phy_c15, phy_c16;
@@ -4211,10 +4209,9 @@ wlc_lcnphy_tx_iqlo_loopback_cleanup(phy_info_t *pi, u16 *values_to_save)
 
 static void
 WLBANDINITFN(wlc_lcnphy_load_tx_gain_table) (phy_info_t *pi,
-					     const lcnphy_tx_gain_tbl_entry *
-					     gain_table) {
+			const struct lcnphy_tx_gain_tbl_entry *gain_table) {
 	u32 j;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 val;
 	u16 pa_gain;
 	u16 gm_gain;
@@ -4248,7 +4245,7 @@ WLBANDINITFN(wlc_lcnphy_load_tx_gain_table) (phy_info_t *pi,
 
 static void wlc_lcnphy_load_rfpower(phy_info_t *pi)
 {
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 val, bbmult, rfgain;
 	u8 index;
 	u8 scale_factor = 1;
@@ -4299,7 +4296,7 @@ static void WLBANDINITFN(wlc_lcnphy_tbl_init) (phy_info_t *pi)
 {
 	uint idx;
 	u8 phybw40;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 val;
 
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
@@ -4393,7 +4390,7 @@ static void WLBANDINITFN(wlc_lcnphy_tbl_init) (phy_info_t *pi)
 static void WLBANDINITFN(wlc_lcnphy_rev0_baseband_init) (phy_info_t *pi)
 {
 	u16 afectrl1;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	write_radio_reg(pi, RADIO_2064_REG11C, 0x0);
 
@@ -4449,9 +4446,9 @@ static void WLBANDINITFN(wlc_lcnphy_rev2_baseband_init) (phy_info_t *pi)
 static void wlc_lcnphy_agc_temp_init(phy_info_t *pi)
 {
 	s16 temp;
-	phytbl_info_t tab;
+	struct phytbl_info tab;
 	u32 tableBuffer[2];
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
@@ -4575,7 +4572,7 @@ static void WLBANDINITFN(wlc_lcnphy_baseband_init) (phy_info_t *pi)
 static void WLBANDINITFN(wlc_radio_2064_init) (phy_info_t *pi)
 {
 	u32 i;
-	lcnphy_radio_regs_t *lcnphyregs = NULL;
+	struct lcnphy_radio_regs *lcnphyregs = NULL;
 
 	lcnphyregs = lcnphy_radio_regs_2064;
 
@@ -4699,7 +4696,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(phy_info_t *pi)
 {
 	s8 txpwr = 0;
 	int i;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		u16 cckpo = 0;
@@ -4836,7 +4833,7 @@ static void
 wlc_lcnphy_radio_2064_channel_tune_4313(phy_info_t *pi, u8 channel)
 {
 	uint i;
-	const chan_info_2064_lcnphy_t *ci;
+	const struct chan_info_2064_lcnphy *ci;
 	u8 rfpll_doubler = 0;
 	u8 pll_pwrup, pll_pwrup_ovr;
 	fixed qFxtal, qFref, qFvco, qFcal;
@@ -5030,9 +5027,9 @@ void wlc_phy_detach_lcnphy(phy_info_t *pi)
 
 bool wlc_phy_attach_lcnphy(phy_info_t *pi)
 {
-	phy_info_lcnphy_t *pi_lcn;
+	struct phy_info_lcnphy *pi_lcn;
 
-	pi->u.pi_lcnphy = kzalloc(sizeof(phy_info_lcnphy_t), GFP_ATOMIC);
+	pi->u.pi_lcnphy = kzalloc(sizeof(struct phy_info_lcnphy), GFP_ATOMIC);
 	if (pi->u.pi_lcnphy == NULL) {
 		return false;
 	}
@@ -5110,7 +5107,7 @@ static u32 wlc_lcnphy_get_receive_power(phy_info_t *pi, s32 *gain_index)
 	u32 received_power = 0;
 	s32 max_index = 0;
 	u32 gain_code = 0;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	max_index = 36;
 	if (*gain_index >= 0)
@@ -5149,7 +5146,7 @@ s32 wlc_lcnphy_rx_signal_power(phy_info_t *pi, s32 gain_index)
 	    input_power_db;
 	s32 received_power, temperature;
 	uint freq;
-	phy_info_lcnphy_t *pi_lcn = pi->u.pi_lcnphy;
+	struct phy_info_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	received_power = wlc_lcnphy_get_receive_power(pi, &gain_index);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
index d360714..b21a29b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.h
@@ -100,7 +100,7 @@ struct phy_info_lcnphy {
 	u16 lcnphy_extstxctrl1;
 	s16 lcnphy_cck_dig_filt_type;
 	s16 lcnphy_ofdm_dig_filt_type;
-	lcnphy_cal_results_t lcnphy_cal_results;
+	struct lcnphy_cal_results lcnphy_cal_results;
 
 	u8 lcnphy_psat_pwr;
 	u8 lcnphy_psat_indx;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index c79c047..e6fe8b7 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -141,7 +141,7 @@
 #define CCTRL5357_EXTPA                 (1<<14)	/* extPA in ChipControl 1, bit 14 */
 #define CCTRL5357_ANT_MUX_2o3		(1<<15)	/* 2o3 in ChipControl 1, bit 15 */
 
-typedef struct _nphy_iqcal_params {
+struct nphy_iqcal_params {
 	u16 txlpf;
 	u16 txgm;
 	u16 pga;
@@ -149,20 +149,20 @@ typedef struct _nphy_iqcal_params {
 	u16 ipa;
 	u16 cal_gain;
 	u16 ncorr[5];
-} nphy_iqcal_params_t;
+};
 
-typedef struct _nphy_txiqcal_ladder {
+struct nphy_txiqcal_ladder {
 	u8 percent;
 	u8 g_env;
-} nphy_txiqcal_ladder_t;
+};
 
-typedef struct {
-	nphy_txgains_t gains;
+struct nphy_ipa_txcalgains {
+	struct nphy_txgains gains;
 	bool useindex;
 	u8 index;
-} nphy_ipa_txcalgains_t;
+};
 
-typedef struct nphy_papd_restore_state_t {
+struct nphy_papd_restore_state {
 	u16 fbmix[2];
 	u16 vga_master[2];
 	u16 intpa_master[2];
@@ -171,20 +171,20 @@ typedef struct nphy_papd_restore_state_t {
 	u16 pwrup[2];
 	u16 atten[2];
 	u16 mm;
-} nphy_papd_restore_state;
+};
 
-typedef struct _nphy_ipa_txrxgain {
+struct nphy_ipa_txrxgain {
 	u16 hpvga;
 	u16 lpf_biq1;
 	u16 lpf_biq0;
 	u16 lna2;
 	u16 lna1;
 	s8 txpwrindex;
-} nphy_ipa_txrxgain_t;
+};
 
 #define NPHY_IPA_RXCAL_MAXGAININDEX (6 - 1)
 
-nphy_ipa_txrxgain_t nphy_ipa_rxcal_gaintbl_5GHz[] = { {0, 0, 0, 0, 0, 100},
+struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz[] = { {0, 0, 0, 0, 0, 100},
 {0, 0, 0, 0, 0, 50},
 {0, 0, 0, 0, 0, -1},
 {0, 0, 0, 3, 0, -1},
@@ -192,7 +192,7 @@ nphy_ipa_txrxgain_t nphy_ipa_rxcal_gaintbl_5GHz[] = { {0, 0, 0, 0, 0, 100},
 {0, 2, 3, 3, 0, -1}
 };
 
-nphy_ipa_txrxgain_t nphy_ipa_rxcal_gaintbl_2GHz[] = { {0, 0, 0, 0, 0, 128},
+struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz[] = { {0, 0, 0, 0, 0, 128},
 {0, 0, 0, 0, 0, 70},
 {0, 0, 0, 0, 0, 20},
 {0, 0, 0, 3, 0, 20},
@@ -200,7 +200,8 @@ nphy_ipa_txrxgain_t nphy_ipa_rxcal_gaintbl_2GHz[] = { {0, 0, 0, 0, 0, 128},
 {0, 2, 3, 3, 0, 20}
 };
 
-nphy_ipa_txrxgain_t nphy_ipa_rxcal_gaintbl_5GHz_rev7[] = { {0, 0, 0, 0, 0, 100},
+struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_5GHz_rev7[] = {
+{0, 0, 0, 0, 0, 100},
 {0, 0, 0, 0, 0, 50},
 {0, 0, 0, 0, 0, -1},
 {0, 0, 0, 3, 0, -1},
@@ -208,7 +209,8 @@ nphy_ipa_txrxgain_t nphy_ipa_rxcal_gaintbl_5GHz_rev7[] = { {0, 0, 0, 0, 0, 100},
 {0, 0, 5, 3, 0, -1}
 };
 
-nphy_ipa_txrxgain_t nphy_ipa_rxcal_gaintbl_2GHz_rev7[] = { {0, 0, 0, 0, 0, 10},
+struct nphy_ipa_txrxgain nphy_ipa_rxcal_gaintbl_2GHz_rev7[] = {
+{0, 0, 0, 0, 0, 10},
 {0, 0, 0, 1, 0, 10},
 {0, 0, 1, 2, 0, 10},
 {0, 0, 1, 3, 0, 10},
@@ -255,7 +257,7 @@ u16 NPHY_IPA_REV4_txdigi_filtcoeffs[][NPHY_NUM_DIG_FILT_COEFFS] = {
 	 0x97, 0x12d, 0x97, 0x25a, 0xd10, 0x25a}
 };
 
-typedef struct _chan_info_nphy_2055 {
+struct chan_info_nphy_2055 {
 	u16 chan;
 	u16 freq;
 	uint unknown;
@@ -287,9 +289,9 @@ typedef struct _chan_info_nphy_2055 {
 	u16 PHY_BW4;
 	u16 PHY_BW5;
 	u16 PHY_BW6;
-} chan_info_nphy_2055_t;
+};
 
-typedef struct _chan_info_nphy_radio205x {
+struct chan_info_nphy_radio205x {
 	u16 chan;
 	u16 freq;
 	u8 RF_SYN_pll_vcocal1;
@@ -335,9 +337,9 @@ typedef struct _chan_info_nphy_radio205x {
 	u16 PHY_BW4;
 	u16 PHY_BW5;
 	u16 PHY_BW6;
-} chan_info_nphy_radio205x_t;
+};
 
-typedef struct _chan_info_nphy_radio2057 {
+struct chan_info_nphy_radio2057 {
 	u16 chan;
 	u16 freq;
 	u8 RF_vcocal_countval0;
@@ -374,9 +376,9 @@ typedef struct _chan_info_nphy_radio2057 {
 	u16 PHY_BW4;
 	u16 PHY_BW5;
 	u16 PHY_BW6;
-} chan_info_nphy_radio2057_t;
+};
 
-typedef struct _chan_info_nphy_radio2057_rev5 {
+struct chan_info_nphy_radio2057_rev5 {
 	u16 chan;
 	u16 freq;
 	u8 RF_vcocal_countval0;
@@ -403,18 +405,18 @@ typedef struct _chan_info_nphy_radio2057_rev5 {
 	u16 PHY_BW4;
 	u16 PHY_BW5;
 	u16 PHY_BW6;
-} chan_info_nphy_radio2057_rev5_t;
+};
 
-typedef struct nphy_sfo_cfg {
+struct nphy_sfo_cfg {
 	u16 PHY_BW1a;
 	u16 PHY_BW2;
 	u16 PHY_BW3;
 	u16 PHY_BW4;
 	u16 PHY_BW5;
 	u16 PHY_BW6;
-} nphy_sfo_cfg_t;
+};
 
-static chan_info_nphy_2055_t chan_info_nphy_2055[] = {
+static struct chan_info_nphy_2055 chan_info_nphy_2055[] = {
 	{
 	 184, 4920, 3280, 0x71, 0x01, 0xEC, 0x0F, 0xFF, 0x01, 0x04, 0x0A,
 	 0x00, 0x8F, 0xFF, 0xFF, 0xFF, 0x00, 0x0F, 0x0F, 0x8F, 0xFF, 0x00, 0x0F,
@@ -913,7 +915,7 @@ static chan_info_nphy_2055_t chan_info_nphy_2055[] = {
 	 0x01, 0x80, 0x3E6, 0x3E2, 0x3DE, 0x41B, 0x41F, 0x424}
 };
 
-static chan_info_nphy_radio205x_t chan_info_nphyrev3_2056[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev3_2056[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x08, 0x00, 0x7f,
@@ -1536,7 +1538,7 @@ static chan_info_nphy_radio205x_t chan_info_nphyrev3_2056[] = {
 	 0x0f, 0x00, 0x0d, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio205x_t chan_info_nphyrev4_2056_A1[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev4_2056_A1[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0e, 0x00, 0x7f,
@@ -2159,7 +2161,7 @@ static chan_info_nphy_radio205x_t chan_info_nphyrev4_2056_A1[] = {
 	 0x0f, 0x00, 0x0e, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio205x_t chan_info_nphyrev5_2056v5[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev5_2056v5[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0b, 0x00, 0x70,
@@ -2782,7 +2784,7 @@ static chan_info_nphy_radio205x_t chan_info_nphyrev5_2056v5[] = {
 	 0x0d, 0x00, 0x08, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio205x_t chan_info_nphyrev6_2056v6[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v6[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -3405,7 +3407,7 @@ static chan_info_nphy_radio205x_t chan_info_nphyrev6_2056v6[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio205x_t chan_info_nphyrev5n6_2056v7[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev5n6_2056v7[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xff, 0x00, 0x0b, 0x00, 0x70,
@@ -4028,7 +4030,7 @@ static chan_info_nphy_radio205x_t chan_info_nphyrev5n6_2056v7[] = {
 	 0x0d, 0x00, 0x08, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio205x_t chan_info_nphyrev6_2056v8[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v8[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x04, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -4651,7 +4653,7 @@ static chan_info_nphy_radio205x_t chan_info_nphyrev6_2056v8[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio205x_t chan_info_nphyrev6_2056v11[] = {
+static struct chan_info_nphy_radio205x chan_info_nphyrev6_2056v11[] = {
 	{
 	 184, 4920, 0xff, 0x01, 0x01, 0x01, 0xec, 0x05, 0x05, 0x02, 0x0c, 0x01,
 	 0x00, 0x00, 0x00, 0x8f, 0x0f, 0x00, 0xff, 0xfe, 0x00, 0x09, 0x00, 0x77,
@@ -5274,7 +5276,7 @@ static chan_info_nphy_radio205x_t chan_info_nphyrev6_2056v11[] = {
 	 0x09, 0x00, 0x09, 0x03e6, 0x03e2, 0x03de, 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio2057_t chan_info_nphyrev7_2057_rev4[] = {
+static struct chan_info_nphy_radio2057 chan_info_nphyrev7_2057_rev4[] = {
 	{
 	 184, 4920, 0x68, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xec, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0x00, 0x0f, 0x0f, 0xf3, 0x00, 0xef, 0x00,
@@ -6137,7 +6139,7 @@ static chan_info_nphy_radio2057_t chan_info_nphyrev7_2057_rev4[] = {
 	 0x0424}
 };
 
-static chan_info_nphy_radio2057_rev5_t chan_info_nphyrev8_2057_rev5[] = {
+static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev8_2057_rev5[] = {
 	{
 	 1, 2412, 0x48, 0x16, 0x30, 0x1b, 0x0a, 0x0a, 0x30, 0x6c, 0x09, 0x0d,
 	 0x08, 0x0e, 0x61, 0x03, 0xff, 0x61, 0x03, 0xff, 0x03c9, 0x03c5, 0x03c1,
@@ -6196,7 +6198,7 @@ static chan_info_nphy_radio2057_rev5_t chan_info_nphyrev8_2057_rev5[] = {
 	 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio2057_rev5_t chan_info_nphyrev9_2057_rev5v1[] = {
+static struct chan_info_nphy_radio2057_rev5 chan_info_nphyrev9_2057_rev5v1[] = {
 	{
 	 1, 2412, 0x48, 0x16, 0x30, 0x1b, 0x0a, 0x0a, 0x30, 0x6c, 0x09, 0x0d,
 	 0x08, 0x0e, 0x61, 0x03, 0xff, 0x61, 0x03, 0xff, 0x03c9, 0x03c5, 0x03c1,
@@ -6255,7 +6257,7 @@ static chan_info_nphy_radio2057_rev5_t chan_info_nphyrev9_2057_rev5v1[] = {
 	 0x041b, 0x041f, 0x0424}
 };
 
-static chan_info_nphy_radio2057_t chan_info_nphyrev8_2057_rev7[] = {
+static struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev7[] = {
 	{
 	 184, 4920, 0x68, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xec, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0xd3, 0x0f, 0x0f, 0xd3, 0x00, 0xff, 0x00,
@@ -6996,7 +6998,7 @@ static chan_info_nphy_radio2057_t chan_info_nphyrev8_2057_rev7[] = {
 	 0x0424}
 };
 
-static chan_info_nphy_radio2057_t chan_info_nphyrev8_2057_rev8[] = {
+static struct chan_info_nphy_radio2057 chan_info_nphyrev8_2057_rev8[] = {
 	{
 	 186, 4930, 0x6b, 0x16, 0x10, 0x0c, 0x0c, 0x0c, 0x30, 0xed, 0x01, 0x0f,
 	 0x00, 0x0f, 0x00, 0xff, 0x00, 0xd3, 0x0f, 0x0f, 0xd3, 0x00, 0xff, 0x00,
@@ -7731,7 +7733,7 @@ static chan_info_nphy_radio2057_t chan_info_nphyrev8_2057_rev8[] = {
 	 0x0424}
 };
 
-radio_regs_t regs_2055[] = {
+struct radio_regs regs_2055[] = {
 	{0x02, 0x80, 0x80, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0x27, 0x27, 0, 0},
@@ -7960,7 +7962,7 @@ radio_regs_t regs_2055[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_SYN_2056[] = {
+struct radio_regs regs_SYN_2056[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8145,7 +8147,7 @@ radio_regs_t regs_SYN_2056[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_TX_2056[] = {
+struct radio_regs regs_TX_2056[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8294,7 +8296,7 @@ radio_regs_t regs_TX_2056[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_RX_2056[] = {
+struct radio_regs regs_RX_2056[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8445,7 +8447,7 @@ radio_regs_t regs_RX_2056[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_SYN_2056_A1[] = {
+struct radio_regs regs_SYN_2056_A1[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8630,7 +8632,7 @@ radio_regs_t regs_SYN_2056_A1[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_TX_2056_A1[] = {
+struct radio_regs regs_TX_2056_A1[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8779,7 +8781,7 @@ radio_regs_t regs_TX_2056_A1[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_RX_2056_A1[] = {
+struct radio_regs regs_RX_2056_A1[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -8930,7 +8932,7 @@ radio_regs_t regs_RX_2056_A1[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_SYN_2056_rev5[] = {
+struct radio_regs regs_SYN_2056_rev5[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9115,7 +9117,7 @@ radio_regs_t regs_SYN_2056_rev5[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_TX_2056_rev5[] = {
+struct radio_regs regs_TX_2056_rev5[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9272,7 +9274,7 @@ radio_regs_t regs_TX_2056_rev5[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_RX_2056_rev5[] = {
+struct radio_regs regs_RX_2056_rev5[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9423,7 +9425,7 @@ radio_regs_t regs_RX_2056_rev5[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_SYN_2056_rev6[] = {
+struct radio_regs regs_SYN_2056_rev6[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9608,7 +9610,7 @@ radio_regs_t regs_SYN_2056_rev6[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_TX_2056_rev6[] = {
+struct radio_regs regs_TX_2056_rev6[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9765,7 +9767,7 @@ radio_regs_t regs_TX_2056_rev6[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_RX_2056_rev6[] = {
+struct radio_regs regs_RX_2056_rev6[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -9916,7 +9918,7 @@ radio_regs_t regs_RX_2056_rev6[] = {
 	{0xFFFF, 0, 0, 0, 0}
 };
 
-radio_regs_t regs_SYN_2056_rev7[] = {
+struct radio_regs regs_SYN_2056_rev7[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10101,7 +10103,7 @@ radio_regs_t regs_SYN_2056_rev7[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_TX_2056_rev7[] = {
+struct radio_regs regs_TX_2056_rev7[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10258,7 +10260,7 @@ radio_regs_t regs_TX_2056_rev7[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_RX_2056_rev7[] = {
+struct radio_regs regs_RX_2056_rev7[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10409,7 +10411,7 @@ radio_regs_t regs_RX_2056_rev7[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_SYN_2056_rev8[] = {
+struct radio_regs regs_SYN_2056_rev8[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10594,7 +10596,7 @@ radio_regs_t regs_SYN_2056_rev8[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_TX_2056_rev8[] = {
+struct radio_regs regs_TX_2056_rev8[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10751,7 +10753,7 @@ radio_regs_t regs_TX_2056_rev8[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_RX_2056_rev8[] = {
+struct radio_regs regs_RX_2056_rev8[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -10902,7 +10904,7 @@ radio_regs_t regs_RX_2056_rev8[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_SYN_2056_rev11[] = {
+struct radio_regs regs_SYN_2056_rev11[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -11087,7 +11089,7 @@ radio_regs_t regs_SYN_2056_rev11[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_TX_2056_rev11[] = {
+struct radio_regs regs_TX_2056_rev11[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -11244,7 +11246,7 @@ radio_regs_t regs_TX_2056_rev11[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_regs_t regs_RX_2056_rev11[] = {
+struct radio_regs regs_RX_2056_rev11[] = {
 	{0x02, 0, 0, 0, 0},
 	{0x03, 0, 0, 0, 0},
 	{0x04, 0, 0, 0, 0},
@@ -11395,7 +11397,7 @@ radio_regs_t regs_RX_2056_rev11[] = {
 	{0xFFFF, 0, 0, 0, 0},
 };
 
-radio_20xx_regs_t regs_2057_rev4[] = {
+struct radio_20xx_regs regs_2057_rev4[] = {
 	{0x00, 0x84, 0},
 	{0x01, 0, 0},
 	{0x02, 0x60, 0},
@@ -11785,7 +11787,7 @@ radio_20xx_regs_t regs_2057_rev4[] = {
 	{0xFFFF, 0, 0},
 };
 
-radio_20xx_regs_t regs_2057_rev5[] = {
+struct radio_20xx_regs regs_2057_rev5[] = {
 	{0x00, 0, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
@@ -12117,7 +12119,7 @@ radio_20xx_regs_t regs_2057_rev5[] = {
 	{0xFFFF, 0, 0}
 };
 
-radio_20xx_regs_t regs_2057_rev5v1[] = {
+struct radio_20xx_regs regs_2057_rev5v1[] = {
 	{0x00, 0x15, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
@@ -12449,7 +12451,7 @@ radio_20xx_regs_t regs_2057_rev5v1[] = {
 	{0xFFFF, 0, 0}
 };
 
-radio_20xx_regs_t regs_2057_rev7[] = {
+struct radio_20xx_regs regs_2057_rev7[] = {
 	{0x00, 0, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
@@ -12865,7 +12867,7 @@ radio_20xx_regs_t regs_2057_rev7[] = {
 	{0xFFFF, 0, 0}
 };
 
-radio_20xx_regs_t regs_2057_rev8[] = {
+struct radio_20xx_regs regs_2057_rev8[] = {
 	{0x00, 0x8, 1},
 	{0x01, 0x57, 1},
 	{0x02, 0x20, 1},
@@ -14084,12 +14086,12 @@ static u8 ant_sw_ctrl_tbl_rev8_2057v7_core1[] = {
 	0x09, 0x0a, 0x09, 0x0a, 0x15, 0x16 };
 
 static bool wlc_phy_chan2freq_nphy(phy_info_t *pi, uint channel, int *f,
-				   chan_info_nphy_radio2057_t **t0,
-				   chan_info_nphy_radio205x_t **t1,
-				   chan_info_nphy_radio2057_rev5_t **t2,
-				   chan_info_nphy_2055_t **t3);
+				   struct chan_info_nphy_radio2057 **t0,
+				   struct chan_info_nphy_radio205x **t1,
+				   struct chan_info_nphy_radio2057_rev5 **t2,
+				   struct chan_info_nphy_2055 **t3);
 static void wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chans,
-					const nphy_sfo_cfg_t *c);
+					const struct nphy_sfo_cfg *c);
 
 static void wlc_phy_adjust_rx_analpfbw_nphy(phy_info_t *pi,
 					    u16 reduction_factr);
@@ -14116,7 +14118,7 @@ static void wlc_phy_adjust_lnagaintbl_nphy(phy_info_t *pi);
 static void wlc_phy_restore_rssical_nphy(phy_info_t *pi);
 static void wlc_phy_reapply_txcal_coeffs_nphy(phy_info_t *pi);
 static void wlc_phy_tx_iq_war_nphy(phy_info_t *pi);
-static int wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, nphy_txgains_t tg,
+static int wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, struct nphy_txgains tg,
 				      u8 type, bool d);
 static void wlc_phy_rxcal_gainctrl_nphy_rev5(phy_info_t *pi, u8 rxcore,
 					     u16 *rg, u8 type);
@@ -14140,12 +14142,12 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(phy_info_t *pi);
 static void wlc_phy_a1_nphy(phy_info_t *pi, u8 core, u32 winsz, u32,
 			    u32 e);
 static u8 wlc_phy_a3_nphy(phy_info_t *pi, u8 start_gain, u8 core);
-static void wlc_phy_a2_nphy(phy_info_t *pi, nphy_ipa_txcalgains_t *,
-			    phy_cal_mode_t, u8);
+static void wlc_phy_a2_nphy(phy_info_t *pi, struct nphy_ipa_txcalgains *,
+			    enum phy_cal_mode, u8);
 static void wlc_phy_papd_cal_cleanup_nphy(phy_info_t *pi,
-					  nphy_papd_restore_state *state);
+				struct nphy_papd_restore_state *state);
 static void wlc_phy_papd_cal_setup_nphy(phy_info_t *pi,
-					nphy_papd_restore_state *state, u8);
+				struct nphy_papd_restore_state *state, u8);
 
 static void wlc_phy_clip_det_nphy(phy_info_t *pi, u8 write, u16 *vals);
 
@@ -14246,7 +14248,7 @@ void
 wlc_phy_table_write_nphy(phy_info_t *pi, u32 id, u32 len, u32 offset,
 			 u32 width, const void *data)
 {
-	mimophytbl_info_t tbl;
+	struct phytbl_info tbl;
 
 	tbl.tbl_id = id;
 	tbl.tbl_len = len;
@@ -14260,7 +14262,7 @@ void
 wlc_phy_table_read_nphy(phy_info_t *pi, u32 id, u32 len, u32 offset,
 			u32 width, void *data)
 {
-	mimophytbl_info_t tbl;
+	struct phytbl_info tbl;
 
 	tbl.tbl_id = id;
 	tbl.tbl_len = len;
@@ -14525,7 +14527,7 @@ void WLBANDINITFN(wlc_phy_init_nphy) (phy_info_t *pi)
 {
 	u16 val;
 	u16 clip1_ths[2];
-	nphy_txgains_t target_gain;
+	struct nphy_txgains target_gain;
 	u8 tx_pwr_ctrl_state;
 	bool do_nphy_cal = false;
 	uint core;
@@ -17442,9 +17444,9 @@ static void wlc_phy_radio_preinit_205x(phy_info_t *pi)
 
 static void wlc_phy_radio_init_2056(phy_info_t *pi)
 {
-	radio_regs_t *regs_SYN_2056_ptr = NULL;
-	radio_regs_t *regs_TX_2056_ptr = NULL;
-	radio_regs_t *regs_RX_2056_ptr = NULL;
+	struct radio_regs *regs_SYN_2056_ptr = NULL;
+	struct radio_regs *regs_TX_2056_ptr = NULL;
+	struct radio_regs *regs_RX_2056_ptr = NULL;
 
 	if (NREV_IS(pi->pubpi.phy_rev, 3)) {
 		regs_SYN_2056_ptr = regs_SYN_2056;
@@ -17530,7 +17532,7 @@ static void wlc_phy_radio_postinit_2056(phy_info_t *pi)
 
 static void wlc_phy_radio_init_2057(phy_info_t *pi)
 {
-	radio_20xx_regs_t *regs_2057_ptr = NULL;
+	struct radio_20xx_regs *regs_2057_ptr = NULL;
 
 	if (NREV_IS(pi->pubpi.phy_rev, 7)) {
 
@@ -17590,15 +17592,15 @@ static void wlc_phy_radio_postinit_2057(phy_info_t *pi)
 
 static bool
 wlc_phy_chan2freq_nphy(phy_info_t *pi, uint channel, int *f,
-		       chan_info_nphy_radio2057_t **t0,
-		       chan_info_nphy_radio205x_t **t1,
-		       chan_info_nphy_radio2057_rev5_t **t2,
-		       chan_info_nphy_2055_t **t3)
+		       struct chan_info_nphy_radio2057 **t0,
+		       struct chan_info_nphy_radio205x **t1,
+		       struct chan_info_nphy_radio2057_rev5 **t2,
+		       struct chan_info_nphy_2055 **t3)
 {
 	uint i;
-	chan_info_nphy_radio2057_t *chan_info_tbl_p_0 = NULL;
-	chan_info_nphy_radio205x_t *chan_info_tbl_p_1 = NULL;
-	chan_info_nphy_radio2057_rev5_t *chan_info_tbl_p_2 = NULL;
+	struct chan_info_nphy_radio2057 *chan_info_tbl_p_0 = NULL;
+	struct chan_info_nphy_radio205x *chan_info_tbl_p_1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *chan_info_tbl_p_2 = NULL;
 	u32 tbl_len = 0;
 
 	int freq = 0;
@@ -17760,10 +17762,10 @@ wlc_phy_chan2freq_nphy(phy_info_t *pi, uint channel, int *f,
 u8 wlc_phy_get_chan_freq_range_nphy(phy_info_t *pi, uint channel)
 {
 	int freq;
-	chan_info_nphy_radio2057_t *t0 = NULL;
-	chan_info_nphy_radio205x_t *t1 = NULL;
-	chan_info_nphy_radio2057_rev5_t *t2 = NULL;
-	chan_info_nphy_2055_t *t3 = NULL;
+	struct chan_info_nphy_radio2057 *t0 = NULL;
+	struct chan_info_nphy_radio205x *t1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	struct chan_info_nphy_2055 *t3 = NULL;
 
 	if (NORADIO_ENAB(pi->pubpi))
 		return WL_CHAN_FREQ_RANGE_2G;
@@ -17786,7 +17788,7 @@ u8 wlc_phy_get_chan_freq_range_nphy(phy_info_t *pi, uint channel)
 }
 
 static void
-wlc_phy_chanspec_radio2055_setup(phy_info_t *pi, chan_info_nphy_2055_t *ci)
+wlc_phy_chanspec_radio2055_setup(phy_info_t *pi, struct chan_info_nphy_2055 *ci)
 {
 
 	write_radio_reg(pi, RADIO_2055_PLL_REF, ci->RF_pll_ref);
@@ -17849,9 +17851,9 @@ wlc_phy_chanspec_radio2055_setup(phy_info_t *pi, chan_info_nphy_2055_t *ci)
 
 static void
 wlc_phy_chanspec_radio2056_setup(phy_info_t *pi,
-				 const chan_info_nphy_radio205x_t *ci)
+				 const struct chan_info_nphy_radio205x *ci)
 {
-	radio_regs_t *regs_SYN_2056_ptr = NULL;
+	struct radio_regs *regs_SYN_2056_ptr = NULL;
 
 	write_radio_reg(pi,
 			RADIO_2056_SYN_PLL_VCOCAL1 | RADIO_2056_SYN,
@@ -18292,8 +18294,8 @@ static u16 wlc_phy_radio205x_rcal(phy_info_t *pi)
 
 static void
 wlc_phy_chanspec_radio2057_setup(phy_info_t *pi,
-				 const chan_info_nphy_radio2057_t *ci,
-				 const chan_info_nphy_radio2057_rev5_t *ci2)
+			const struct chan_info_nphy_radio2057 *ci,
+			const struct chan_info_nphy_radio2057_rev5 *ci2)
 {
 	int coreNum;
 	u16 txmix2g_tune_boost_pu = 0;
@@ -18910,7 +18912,7 @@ static void wlc_phy_spurwar_nphy(phy_info_t *pi)
 
 static void
 wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chanspec,
-			    const nphy_sfo_cfg_t *ci)
+			    const struct nphy_sfo_cfg *ci)
 {
 	u16 val;
 
@@ -19047,10 +19049,10 @@ wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chanspec,
 void wlc_phy_chanspec_set_nphy(phy_info_t *pi, chanspec_t chanspec)
 {
 	int freq;
-	chan_info_nphy_radio2057_t *t0 = NULL;
-	chan_info_nphy_radio205x_t *t1 = NULL;
-	chan_info_nphy_radio2057_rev5_t *t2 = NULL;
-	chan_info_nphy_2055_t *t3 = NULL;
+	struct chan_info_nphy_radio2057 *t0 = NULL;
+	struct chan_info_nphy_radio205x *t1 = NULL;
+	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
+	struct chan_info_nphy_2055 *t3 = NULL;
 
 	if (NORADIO_ENAB(pi->pubpi)) {
 		return;
@@ -19097,12 +19099,9 @@ void wlc_phy_chanspec_set_nphy(phy_info_t *pi, chanspec_t chanspec)
 
 			wlc_phy_chanspec_radio2057_setup(pi, t0, t2);
 			wlc_phy_chanspec_nphy_setup(pi, chanspec,
-						    (pi->pubpi.radiorev ==
-						     5) ? (const nphy_sfo_cfg_t
-							   *)&(t2->
-							       PHY_BW1a)
-						    : (const nphy_sfo_cfg_t *)
-						    &(t0->PHY_BW1a));
+				(pi->pubpi.radiorev == 5) ?
+				(const struct nphy_sfo_cfg *)&(t2->PHY_BW1a) :
+				(const struct nphy_sfo_cfg *)&(t0->PHY_BW1a));
 
 		} else {
 
@@ -19113,8 +19112,7 @@ void wlc_phy_chanspec_set_nphy(phy_info_t *pi, chanspec_t chanspec)
 			wlc_phy_chanspec_radio2056_setup(pi, t1);
 
 			wlc_phy_chanspec_nphy_setup(pi, chanspec,
-						    (const nphy_sfo_cfg_t *)
-						    &(t1->PHY_BW1a));
+				(const struct nphy_sfo_cfg *) &(t1->PHY_BW1a));
 		}
 
 	} else {
@@ -19125,7 +19123,7 @@ void wlc_phy_chanspec_set_nphy(phy_info_t *pi, chanspec_t chanspec)
 
 		wlc_phy_chanspec_radio2055_setup(pi, t3);
 		wlc_phy_chanspec_nphy_setup(pi, chanspec,
-					    (const nphy_sfo_cfg_t *)&(t3->
+					    (const struct nphy_sfo_cfg *)&(t3->
 								      PHY_BW1a));
 	}
 
@@ -21369,9 +21367,9 @@ static void wlc_phy_rssi_cal_nphy_rev2(phy_info_t *pi, u8 rssi_type)
 }
 
 int
-wlc_phy_rssi_compute_nphy(phy_info_t *pi, wlc_d11rxhdr_t *wlc_rxh)
+wlc_phy_rssi_compute_nphy(phy_info_t *pi, struct brcms_d11rxhdr *wlc_rxh)
 {
-	d11rxhdr_t *rxh = &wlc_rxh->rxhdr;
+	struct d11rxhdr *rxh = &wlc_rxh->rxhdr;
 	s16 rxpwr, rxpwr0, rxpwr1;
 	s16 phyRx0_l, phyRx2_l;
 
@@ -22464,11 +22462,11 @@ void wlc_phy_stopplayback_nphy(phy_info_t *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
-nphy_txgains_t wlc_phy_get_tx_gain_nphy(phy_info_t *pi)
+struct nphy_txgains wlc_phy_get_tx_gain_nphy(phy_info_t *pi)
 {
 	u16 base_idx[2], curr_gain[2];
 	u8 core_no;
-	nphy_txgains_t target_gain;
+	struct nphy_txgains target_gain;
 	u32 *tx_pwrctrl_tbl = NULL;
 
 	if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF) {
@@ -22623,8 +22621,8 @@ nphy_txgains_t wlc_phy_get_tx_gain_nphy(phy_info_t *pi)
 
 static void
 wlc_phy_iqcal_gainparams_nphy(phy_info_t *pi, u16 core_no,
-			      nphy_txgains_t target_gain,
-			      nphy_iqcal_params_t *params)
+			      struct nphy_txgains target_gain,
+			      struct nphy_iqcal_params *params)
 {
 	u8 k;
 	int idx;
@@ -23700,13 +23698,13 @@ static void wlc_phy_update_txcal_ladder_nphy(phy_info_t *pi, u16 core)
 	u16 bbmult;
 	u16 tblentry;
 
-	nphy_txiqcal_ladder_t ladder_lo[] = {
+	struct nphy_txiqcal_ladder ladder_lo[] = {
 		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
 		{25, 0}, {25, 1}, {25, 2}, {25, 3}, {25, 4}, {25, 5},
 		{25, 6}, {25, 7}, {35, 7}, {50, 7}, {71, 7}, {100, 7}
 	};
 
-	nphy_txiqcal_ladder_t ladder_iq[] = {
+	struct nphy_txiqcal_ladder ladder_iq[] = {
 		{3, 0}, {4, 0}, {6, 0}, {9, 0}, {13, 0}, {18, 0},
 		{25, 0}, {35, 0}, {50, 0}, {71, 0}, {100, 0}, {100, 1},
 		{100, 2}, {100, 3}, {100, 4}, {100, 5}, {100, 6}, {100, 7}
@@ -23737,7 +23735,7 @@ static void wlc_phy_update_txcal_ladder_nphy(phy_info_t *pi, u16 core)
 
 void wlc_phy_cal_perical_nphy_run(phy_info_t *pi, u8 caltype)
 {
-	nphy_txgains_t target_gain;
+	struct nphy_txgains target_gain;
 	u8 tx_pwr_ctrl_state;
 	bool fullcal = true;
 	bool restore_tx_gain = false;
@@ -23987,7 +23985,7 @@ void wlc_phy_cal_perical_nphy_run(phy_info_t *pi, u8 caltype)
 }
 
 int
-wlc_phy_cal_txiqlo_nphy(phy_info_t *pi, nphy_txgains_t target_gain,
+wlc_phy_cal_txiqlo_nphy(phy_info_t *pi, struct nphy_txgains target_gain,
 			bool fullcal, bool mphase)
 {
 	u16 val;
@@ -24002,7 +24000,7 @@ wlc_phy_cal_txiqlo_nphy(phy_info_t *pi, nphy_txgains_t target_gain,
 	u16 tone_freq;
 	u16 gain_save[2];
 	u16 cal_gain[2];
-	nphy_iqcal_params_t cal_params[2];
+	struct nphy_iqcal_params cal_params[2];
 	u32 tbl_len;
 	void *tbl_ptr;
 	bool ladder_updated[2];
@@ -24394,7 +24392,7 @@ static void wlc_phy_reapply_txcal_coeffs_nphy(phy_info_t *pi)
 
 static void wlc_phy_tx_iq_war_nphy(phy_info_t *pi)
 {
-	nphy_iq_comp_t tx_comp;
+	struct nphy_iq_comp tx_comp;
 
 	wlc_phy_table_read_nphy(pi, 15, 4, 0x50, 16, (void *)&tx_comp);
 
@@ -24405,7 +24403,7 @@ static void wlc_phy_tx_iq_war_nphy(phy_info_t *pi)
 }
 
 void
-wlc_phy_rx_iq_coeffs_nphy(phy_info_t *pi, u8 write, nphy_iq_comp_t *pcomp)
+wlc_phy_rx_iq_coeffs_nphy(phy_info_t *pi, u8 write, struct nphy_iq_comp *pcomp)
 {
 	if (write) {
 		write_phy_reg(pi, 0x9a, pcomp->a0);
@@ -24421,7 +24419,7 @@ wlc_phy_rx_iq_coeffs_nphy(phy_info_t *pi, u8 write, nphy_iq_comp_t *pcomp)
 }
 
 void
-wlc_phy_rx_iq_est_nphy(phy_info_t *pi, phy_iq_est_t *est, u16 num_samps,
+wlc_phy_rx_iq_est_nphy(phy_info_t *pi, struct phy_iq_est *est, u16 num_samps,
 		       u8 wait_time, u8 wait_for_crs)
 {
 	u8 core;
@@ -24458,8 +24456,8 @@ wlc_phy_rx_iq_est_nphy(phy_info_t *pi, phy_iq_est_t *est, u16 num_samps,
 static void wlc_phy_calc_rx_iq_comp_nphy(phy_info_t *pi, u8 core_mask)
 {
 	u8 curr_core;
-	phy_iq_est_t est[PHY_CORE_MAX];
-	nphy_iq_comp_t old_comp, new_comp;
+	struct phy_iq_est est[PHY_CORE_MAX];
+	struct nphy_iq_comp old_comp, new_comp;
 	s32 iq = 0;
 	u32 ii = 0, qq = 0;
 	s16 iq_nbits, qq_nbits, brsh, arsh;
@@ -25205,9 +25203,9 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(phy_info_t *pi, u8 rx_core,
 {
 
 	u16 num_samps;
-	phy_iq_est_t est[PHY_CORE_MAX];
+	struct phy_iq_est est[PHY_CORE_MAX];
 	u8 tx_core;
-	nphy_iq_comp_t save_comp, zero_comp;
+	struct nphy_iq_comp save_comp, zero_comp;
 	u32 i_pwr, q_pwr, curr_pwr, optim_pwr = 0, prev_pwr = 0, thresh_pwr =
 	    10000;
 	s16 desired_log2_pwr, actual_log2_pwr, delta_pwr;
@@ -25216,7 +25214,7 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(phy_info_t *pi, u8 rx_core,
 	s8 optim_gaintbl_index = 0, prev_gaintbl_index = 0;
 	s8 curr_gaintbl_index = 3;
 	u8 gainctrl_dirn = NPHY_RXCAL_GAIN_INIT;
-	nphy_ipa_txrxgain_t *nphy_rxcal_gaintbl;
+	struct nphy_ipa_txrxgain *nphy_rxcal_gaintbl;
 	u16 hpvga, lpf_biq1, lpf_biq0, lna2, lna1;
 	int fine_gain_idx;
 	s8 txpwrindex;
@@ -25447,7 +25445,7 @@ wlc_phy_rc_sweep_nphy(phy_info_t *pi, u8 core_idx, u8 loopback_type)
 	u16 rccal_val, last_rccal_val = 0, best_rccal_val = 0;
 	u32 ref_iq_vals = 0, target_iq_vals = 0;
 	u16 num_samps, log_num_samps = 10;
-	phy_iq_est_t est[PHY_CORE_MAX];
+	struct phy_iq_est est[PHY_CORE_MAX];
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		return 0;
@@ -25656,7 +25654,7 @@ wlc_phy_rc_sweep_nphy(phy_info_t *pi, u8 core_idx, u8 loopback_type)
 
 #define WAIT_FOR_SCOPE	4000
 static int
-wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, nphy_txgains_t target_gain,
+wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, struct nphy_txgains target_gain,
 			   u8 cal_type, bool debug)
 {
 	u16 orig_BBConfig;
@@ -25664,7 +25662,7 @@ wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, nphy_txgains_t target_gain,
 	u8 best_rccal[2];
 	u16 gain_save[2];
 	u16 cal_gain[2];
-	nphy_iqcal_params_t cal_params[2];
+	struct nphy_iqcal_params cal_params[2];
 	u8 rxcore_state;
 	s8 rxlpf_rccal_hpc, txlpf_rccal_lpc;
 	s8 txlpf_idac;
@@ -25813,10 +25811,10 @@ wlc_phy_cal_rxiq_nphy_rev3(phy_info_t *pi, nphy_txgains_t target_gain,
 }
 
 static int
-wlc_phy_cal_rxiq_nphy_rev2(phy_info_t *pi, nphy_txgains_t target_gain,
+wlc_phy_cal_rxiq_nphy_rev2(phy_info_t *pi, struct nphy_txgains target_gain,
 			   bool debug)
 {
-	phy_iq_est_t est[PHY_CORE_MAX];
+	struct phy_iq_est est[PHY_CORE_MAX];
 	u8 core_num, rx_core, tx_core;
 	u16 lna_vals[] = { 0x3, 0x3, 0x1 };
 	u16 hpf1_vals[] = { 0x7, 0x2, 0x0 };
@@ -25832,7 +25830,7 @@ wlc_phy_cal_rxiq_nphy_rev2(phy_info_t *pi, nphy_txgains_t target_gain,
 	u16 core_no;
 	u16 gain_save[2];
 	u16 cal_gain[2];
-	nphy_iqcal_params_t cal_params[2];
+	struct nphy_iqcal_params cal_params[2];
 	u8 phy_bw;
 	int bcmerror = 0;
 	bool first_playtone = true;
@@ -26039,7 +26037,7 @@ wlc_phy_cal_rxiq_nphy_rev2(phy_info_t *pi, nphy_txgains_t target_gain,
 }
 
 int
-wlc_phy_cal_rxiq_nphy(phy_info_t *pi, nphy_txgains_t target_gain,
+wlc_phy_cal_rxiq_nphy(phy_info_t *pi, struct nphy_txgains target_gain,
 		      u8 cal_type, bool debug)
 {
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
@@ -26200,8 +26198,8 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(phy_info_t *pi)
 }
 
 static void
-wlc_phy_papd_cal_setup_nphy(phy_info_t *pi, nphy_papd_restore_state *state,
-			    u8 core)
+wlc_phy_papd_cal_setup_nphy(phy_info_t *pi,
+			    struct nphy_papd_restore_state *state, u8 core)
 {
 	s32 tone_freq;
 	u8 off_core;
@@ -26470,7 +26468,8 @@ wlc_phy_papd_cal_setup_nphy(phy_info_t *pi, nphy_papd_restore_state *state,
 }
 
 static void
-wlc_phy_papd_cal_cleanup_nphy(phy_info_t *pi, nphy_papd_restore_state *state)
+wlc_phy_papd_cal_cleanup_nphy(phy_info_t *pi,
+			      struct nphy_papd_restore_state *state)
 {
 	u8 core;
 
@@ -26648,15 +26647,15 @@ wlc_phy_a1_nphy(phy_info_t *pi, u8 core, u32 winsz, u32 start,
 }
 
 static void
-wlc_phy_a2_nphy(phy_info_t *pi, nphy_ipa_txcalgains_t *txgains,
-		phy_cal_mode_t cal_mode, u8 core)
+wlc_phy_a2_nphy(phy_info_t *pi, struct nphy_ipa_txcalgains *txgains,
+		enum phy_cal_mode cal_mode, u8 core)
 {
 	u16 phy_a1, phy_a2, phy_a3;
 	u16 phy_a4, phy_a5;
 	bool phy_a6;
 	u8 phy_a7, m[2];
 	u32 phy_a8 = 0;
-	nphy_txgains_t phy_a9;
+	struct nphy_txgains phy_a9;
 
 	if (NREV_LT(pi->pubpi.phy_rev, 3))
 		return;
@@ -26942,7 +26941,7 @@ static u8 wlc_phy_a3_nphy(phy_info_t *pi, u8 start_gain, u8 core)
 	int phy_a1;
 	int phy_a2;
 	bool phy_a3;
-	nphy_ipa_txcalgains_t phy_a4;
+	struct nphy_ipa_txcalgains phy_a4;
 	bool phy_a5 = false;
 	bool phy_a6 = true;
 	s32 phy_a7, phy_a8;
@@ -27100,8 +27099,8 @@ static u8 wlc_phy_a3_nphy(phy_info_t *pi, u8 start_gain, u8 core)
 
 static void wlc_phy_a4(phy_info_t *pi, bool full_cal)
 {
-	nphy_ipa_txcalgains_t phy_b1[2];
-	nphy_papd_restore_state phy_b2;
+	struct nphy_ipa_txcalgains phy_b1[2];
+	struct nphy_papd_restore_state phy_b2;
 	bool phy_b3;
 	u8 phy_b4;
 	u8 phy_b5;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
index 5b6538f..023d05a 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.c
@@ -1505,7 +1505,7 @@ const u32 dot11lcn_gain_tbl_5G[] = {
 	0x00000000
 };
 
-const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev0[] = {
+const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[] = {
 	{&dot11lcn_gain_tbl_rev0,
 	 sizeof(dot11lcn_gain_tbl_rev0) / sizeof(dot11lcn_gain_tbl_rev0[0]), 18,
 	 0, 32}
@@ -1520,7 +1520,7 @@ const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev0[] = {
 	,
 };
 
-const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev1[] = {
+const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev1[] = {
 	{&dot11lcn_gain_tbl_rev1,
 	 sizeof(dot11lcn_gain_tbl_rev1) / sizeof(dot11lcn_gain_tbl_rev1[0]), 18,
 	 0, 32}
@@ -1535,7 +1535,7 @@ const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev1[] = {
 	,
 };
 
-const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_2G_rev2[] = {
+const struct phytbl_info dot11lcnphytbl_rx_gain_info_2G_rev2[] = {
 	{&dot11lcn_gain_tbl_2G,
 	 sizeof(dot11lcn_gain_tbl_2G) / sizeof(dot11lcn_gain_tbl_2G[0]), 18, 0,
 	 32}
@@ -1553,7 +1553,7 @@ const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_2G_rev2[] = {
 	 17, 0, 8}
 };
 
-const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_5G_rev2[] = {
+const struct phytbl_info dot11lcnphytbl_rx_gain_info_5G_rev2[] = {
 	{&dot11lcn_gain_tbl_5G,
 	 sizeof(dot11lcn_gain_tbl_5G) / sizeof(dot11lcn_gain_tbl_5G[0]), 18, 0,
 	 32}
@@ -1571,7 +1571,7 @@ const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_5G_rev2[] = {
 	 17, 0, 8}
 };
 
-const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_2G_rev2[] = {
+const struct phytbl_info dot11lcnphytbl_rx_gain_info_extlna_2G_rev2[] = {
 	{&dot11lcn_gain_tbl_extlna_2G,
 	 sizeof(dot11lcn_gain_tbl_extlna_2G) /
 	 sizeof(dot11lcn_gain_tbl_extlna_2G[0]), 18, 0, 32}
@@ -1589,7 +1589,7 @@ const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_2G_rev2[] = {
 	 sizeof(dot11lcn_gain_val_tbl_extlna_2G[0]), 17, 0, 8}
 };
 
-const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_5G_rev2[] = {
+const struct phytbl_info dot11lcnphytbl_rx_gain_info_extlna_5G_rev2[] = {
 	{&dot11lcn_gain_tbl_5G,
 	 sizeof(dot11lcn_gain_tbl_5G) / sizeof(dot11lcn_gain_tbl_5G[0]), 18, 0,
 	 32}
@@ -2773,7 +2773,7 @@ const u32 dot11lcn_papd_compdelta_tbl_rev0[] = {
 	0x00080000,
 };
 
-const dot11lcnphytbl_info_t dot11lcnphytbl_info_rev0[] = {
+const struct phytbl_info dot11lcnphytbl_info_rev0[] = {
 	{&dot11lcn_min_sig_sq_tbl_rev0,
 	 sizeof(dot11lcn_min_sig_sq_tbl_rev0) /
 	 sizeof(dot11lcn_min_sig_sq_tbl_rev0[0]), 2, 0, 16}
@@ -2832,25 +2832,25 @@ const dot11lcnphytbl_info_t dot11lcnphytbl_info_rev0[] = {
 	,
 };
 
-const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313 = {
+const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313 = {
 	&dot11lcn_sw_ctrl_tbl_4313_rev0,
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0) /
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_rev0[0]), 15, 0, 16
 };
 
-const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_epa = {
+const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0,
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0) /
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0[0]), 15, 0, 16
 };
 
-const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_bt_epa = {
+const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa = {
 	&dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo,
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo) /
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_epa_rev0_combo[0]), 15, 0, 16
 };
 
-const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250 = {
+const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250 = {
 	&dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0,
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0) /
 	    sizeof(dot11lcn_sw_ctrl_tbl_4313_bt_epa_p250_rev0[0]), 15, 0, 16
@@ -2859,7 +2859,8 @@ const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_bt_epa_p250 = {
 const u32 dot11lcnphytbl_info_sz_rev0 =
 	sizeof(dot11lcnphytbl_info_rev0) / sizeof(dot11lcnphytbl_info_rev0[0]);
 
-const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_extPA_gaintable_rev0[128] = {
+const struct lcnphy_tx_gain_tbl_entry
+dot11lcnphy_2GHz_extPA_gaintable_rev0[128] = {
 	{3, 0, 31, 0, 72,}
 	,
 	{3, 0, 31, 0, 70,}
@@ -3118,7 +3119,7 @@ const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_extPA_gaintable_rev0[128] = {
 	,
 };
 
-const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[128] = {
+const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[128] = {
 	{7, 0, 31, 0, 72,}
 	,
 	{7, 0, 31, 0, 70,}
@@ -3377,7 +3378,7 @@ const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[128] = {
 	,
 };
 
-const lcnphy_tx_gain_tbl_entry dot11lcnphy_5GHz_gaintable_rev0[128] = {
+const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_5GHz_gaintable_rev0[128] = {
 	{255, 255, 0xf0, 0, 152,}
 	,
 	{255, 255, 0xf0, 0, 147,}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
index 96f5a68..644389f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_lcn.h
@@ -17,26 +17,26 @@
 #include <types.h>
 #include "phy_int.h"
 
-extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_rev0[];
+extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_rev0[];
 extern const u32 dot11lcnphytbl_rx_gain_info_sz_rev0;
-extern const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313;
-extern const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_epa;
-extern const dot11lcnphytbl_info_t dot11lcn_sw_ctrl_tbl_info_4313_epa_combo;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa;
+extern const struct phytbl_info dot11lcn_sw_ctrl_tbl_info_4313_epa_combo;
 
-extern const dot11lcnphytbl_info_t dot11lcnphytbl_info_rev0[];
+extern const struct phytbl_info dot11lcnphytbl_info_rev0[];
 extern const u32 dot11lcnphytbl_info_sz_rev0;
 
-extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_2G_rev2[];
+extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_2G_rev2[];
 extern const u32 dot11lcnphytbl_rx_gain_info_2G_rev2_sz;
 
-extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_5G_rev2[];
+extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_5G_rev2[];
 extern const u32 dot11lcnphytbl_rx_gain_info_5G_rev2_sz;
 
-extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_2G_rev2[];
+extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_extlna_2G_rev2[];
 
-extern const dot11lcnphytbl_info_t dot11lcnphytbl_rx_gain_info_extlna_5G_rev2[];
+extern const struct phytbl_info dot11lcnphytbl_rx_gain_info_extlna_5G_rev2[];
 
-struct _lcnphy_tx_gain_tbl_entry {
+struct lcnphy_tx_gain_tbl_entry {
 	unsigned char gm;
 	unsigned char pga;
 	unsigned char pad;
@@ -44,7 +44,9 @@ struct _lcnphy_tx_gain_tbl_entry {
 	unsigned char bb_mult;
 };
 
-extern const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[];
-extern const lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_extPA_gaintable_rev0[];
+extern const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_gaintable_rev0[];
 
-extern const lcnphy_tx_gain_tbl_entry dot11lcnphy_5GHz_gaintable_rev0[];
+extern const struct
+lcnphy_tx_gain_tbl_entry dot11lcnphy_2GHz_extPA_gaintable_rev0[];
+
+extern const struct lcnphy_tx_gain_tbl_entry dot11lcnphy_5GHz_gaintable_rev0[];
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
index 8835367..7f741f4 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.c
@@ -4436,7 +4436,7 @@ const u16 loft_lut_core1_rev0[] = {
 	0x0103,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev0_volatile[] = {
+const struct phytbl_info mimophytbl_info_rev0_volatile[] = {
 	{&bdi_tbl_rev0, sizeof(bdi_tbl_rev0) / sizeof(bdi_tbl_rev0[0]), 21, 0,
 	 16}
 	,
@@ -4484,7 +4484,7 @@ const mimophytbl_info_t mimophytbl_info_rev0_volatile[] = {
 	,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev0[] = {
+const struct phytbl_info mimophytbl_info_rev0[] = {
 	{&frame_struct_rev0,
 	 sizeof(frame_struct_rev0) / sizeof(frame_struct_rev0[0]), 10, 0, 32}
 	,
@@ -9361,34 +9361,34 @@ const u32 papd_cal_scalars_tbl_core1_rev3[] = {
 	0x002606a4,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev3_volatile[] = {
+const struct phytbl_info mimophytbl_info_rev3_volatile[] = {
 	{&ant_swctrl_tbl_rev3,
 	 sizeof(ant_swctrl_tbl_rev3) / sizeof(ant_swctrl_tbl_rev3[0]), 9, 0, 16}
 	,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev3_volatile1[] = {
+const struct phytbl_info mimophytbl_info_rev3_volatile1[] = {
 	{&ant_swctrl_tbl_rev3_1,
 	 sizeof(ant_swctrl_tbl_rev3_1) / sizeof(ant_swctrl_tbl_rev3_1[0]), 9, 0,
 	 16}
 	,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev3_volatile2[] = {
+const struct phytbl_info mimophytbl_info_rev3_volatile2[] = {
 	{&ant_swctrl_tbl_rev3_2,
 	 sizeof(ant_swctrl_tbl_rev3_2) / sizeof(ant_swctrl_tbl_rev3_2[0]), 9, 0,
 	 16}
 	,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev3_volatile3[] = {
+const struct phytbl_info mimophytbl_info_rev3_volatile3[] = {
 	{&ant_swctrl_tbl_rev3_3,
 	 sizeof(ant_swctrl_tbl_rev3_3) / sizeof(ant_swctrl_tbl_rev3_3[0]), 9, 0,
 	 16}
 	,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev3[] = {
+const struct phytbl_info mimophytbl_info_rev3[] = {
 	{&frame_struct_rev3,
 	 sizeof(frame_struct_rev3) / sizeof(frame_struct_rev3[0]), 10, 0, 32}
 	,
@@ -10467,7 +10467,7 @@ const u32 papd_cal_scalars_tbl_core1_rev7[] = {
 	0x004e068c,
 };
 
-const mimophytbl_info_t mimophytbl_info_rev7[] = {
+const struct phytbl_info mimophytbl_info_rev7[] = {
 	{&frame_struct_rev3,
 	 sizeof(frame_struct_rev3) / sizeof(frame_struct_rev3[0]), 10, 0, 32}
 	,
@@ -10581,7 +10581,7 @@ const mimophytbl_info_t mimophytbl_info_rev7[] = {
 const u32 mimophytbl_info_sz_rev7 =
 	sizeof(mimophytbl_info_rev7) / sizeof(mimophytbl_info_rev7[0]);
 
-const mimophytbl_info_t mimophytbl_info_rev16[] = {
+const struct phytbl_info mimophytbl_info_rev16[] = {
 	{&noise_var_tbl_rev7,
 	 sizeof(noise_var_tbl_rev7) / sizeof(noise_var_tbl_rev7[0]), 16, 0, 32}
 	,
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
index 4b2a04d..c5266cf 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phytbl_n.h
@@ -19,11 +19,11 @@
 #include <types.h>
 #include "phy_int.h"
 
-extern const mimophytbl_info_t mimophytbl_info_rev0[],
+extern const struct phytbl_info mimophytbl_info_rev0[],
 	mimophytbl_info_rev0_volatile[];
 extern const u32 mimophytbl_info_sz_rev0, mimophytbl_info_sz_rev0_volatile;
 
-extern const mimophytbl_info_t mimophytbl_info_rev3[],
+extern const struct phytbl_info mimophytbl_info_rev3[],
 	mimophytbl_info_rev3_volatile[], mimophytbl_info_rev3_volatile1[],
 	mimophytbl_info_rev3_volatile2[], mimophytbl_info_rev3_volatile3[];
 extern const u32 mimophytbl_info_sz_rev3, mimophytbl_info_sz_rev3_volatile,
@@ -32,9 +32,9 @@ extern const u32 mimophytbl_info_sz_rev3, mimophytbl_info_sz_rev3_volatile,
 
 extern const u32 noise_var_tbl_rev3[];
 
-extern const mimophytbl_info_t mimophytbl_info_rev7[];
+extern const struct phytbl_info mimophytbl_info_rev7[];
 extern const u32 mimophytbl_info_sz_rev7;
 extern const u32 noise_var_tbl_rev7[];
 
-extern const mimophytbl_info_t mimophytbl_info_rev16[];
+extern const struct phytbl_info mimophytbl_info_rev16[];
 extern const u32 mimophytbl_info_sz_rev16;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 915efdf..e681f83 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -29,17 +29,17 @@
 #include "phy_shim.h"
 
 /* PHY SHIM module specific state */
-struct wlc_phy_shim_info {
+struct phy_shim_info {
 	struct brcms_c_hw_info *wlc_hw;	/* pointer to main wlc_hw structure */
 	void *wlc;		/* pointer to main wlc structure */
 	void *wl;		/* pointer to os-specific private state */
 };
 
-wlc_phy_shim_info_t *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
+struct phy_shim_info *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
 						       void *wl, void *wlc) {
-	wlc_phy_shim_info_t *physhim = NULL;
+	struct phy_shim_info *physhim = NULL;
 
-	physhim = kzalloc(sizeof(wlc_phy_shim_info_t), GFP_ATOMIC);
+	physhim = kzalloc(sizeof(struct phy_shim_info), GFP_ATOMIC);
 	if (!physhim) {
 		wiphy_err(wlc_hw->wlc->wiphy,
 			  "wl%d: wlc_phy_shim_attach: out of mem\n",
@@ -53,12 +53,12 @@ wlc_phy_shim_info_t *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
 	return physhim;
 }
 
-void wlc_phy_shim_detach(wlc_phy_shim_info_t *physhim)
+void wlc_phy_shim_detach(struct phy_shim_info *physhim)
 {
 	kfree(physhim);
 }
 
-struct wlapi_timer *wlapi_init_timer(wlc_phy_shim_info_t *physhim,
+struct wlapi_timer *wlapi_init_timer(struct phy_shim_info *physhim,
 				     void (*fn) (void *arg), void *arg,
 				     const char *name)
 {
@@ -66,152 +66,152 @@ struct wlapi_timer *wlapi_init_timer(wlc_phy_shim_info_t *physhim,
 			brcms_init_timer(physhim->wl, fn, arg, name);
 }
 
-void wlapi_free_timer(wlc_phy_shim_info_t *physhim, struct wlapi_timer *t)
+void wlapi_free_timer(struct phy_shim_info *physhim, struct wlapi_timer *t)
 {
 	brcms_free_timer(physhim->wl, (struct brcms_timer *)t);
 }
 
 void
-wlapi_add_timer(wlc_phy_shim_info_t *physhim, struct wlapi_timer *t, uint ms,
+wlapi_add_timer(struct phy_shim_info *physhim, struct wlapi_timer *t, uint ms,
 		int periodic)
 {
 	brcms_add_timer(physhim->wl, (struct brcms_timer *)t, ms, periodic);
 }
 
-bool wlapi_del_timer(wlc_phy_shim_info_t *physhim, struct wlapi_timer *t)
+bool wlapi_del_timer(struct phy_shim_info *physhim, struct wlapi_timer *t)
 {
 	return brcms_del_timer(physhim->wl, (struct brcms_timer *)t);
 }
 
-void wlapi_intrson(wlc_phy_shim_info_t *physhim)
+void wlapi_intrson(struct phy_shim_info *physhim)
 {
 	brcms_intrson(physhim->wl);
 }
 
-u32 wlapi_intrsoff(wlc_phy_shim_info_t *physhim)
+u32 wlapi_intrsoff(struct phy_shim_info *physhim)
 {
 	return brcms_intrsoff(physhim->wl);
 }
 
-void wlapi_intrsrestore(wlc_phy_shim_info_t *physhim, u32 macintmask)
+void wlapi_intrsrestore(struct phy_shim_info *physhim, u32 macintmask)
 {
 	brcms_intrsrestore(physhim->wl, macintmask);
 }
 
-void wlapi_bmac_write_shm(wlc_phy_shim_info_t *physhim, uint offset, u16 v)
+void wlapi_bmac_write_shm(struct phy_shim_info *physhim, uint offset, u16 v)
 {
 	brcms_b_write_shm(physhim->wlc_hw, offset, v);
 }
 
-u16 wlapi_bmac_read_shm(wlc_phy_shim_info_t *physhim, uint offset)
+u16 wlapi_bmac_read_shm(struct phy_shim_info *physhim, uint offset)
 {
 	return brcms_b_read_shm(physhim->wlc_hw, offset);
 }
 
 void
-wlapi_bmac_mhf(wlc_phy_shim_info_t *physhim, u8 idx, u16 mask,
+wlapi_bmac_mhf(struct phy_shim_info *physhim, u8 idx, u16 mask,
 	       u16 val, int bands)
 {
 	brcms_b_mhf(physhim->wlc_hw, idx, mask, val, bands);
 }
 
-void wlapi_bmac_corereset(wlc_phy_shim_info_t *physhim, u32 flags)
+void wlapi_bmac_corereset(struct phy_shim_info *physhim, u32 flags)
 {
 	brcms_b_corereset(physhim->wlc_hw, flags);
 }
 
-void wlapi_suspend_mac_and_wait(wlc_phy_shim_info_t *physhim)
+void wlapi_suspend_mac_and_wait(struct phy_shim_info *physhim)
 {
 	brcms_c_suspend_mac_and_wait(physhim->wlc);
 }
 
-void wlapi_switch_macfreq(wlc_phy_shim_info_t *physhim, u8 spurmode)
+void wlapi_switch_macfreq(struct phy_shim_info *physhim, u8 spurmode)
 {
 	brcms_b_switch_macfreq(physhim->wlc_hw, spurmode);
 }
 
-void wlapi_enable_mac(wlc_phy_shim_info_t *physhim)
+void wlapi_enable_mac(struct phy_shim_info *physhim)
 {
 	brcms_c_enable_mac(physhim->wlc);
 }
 
-void wlapi_bmac_mctrl(wlc_phy_shim_info_t *physhim, u32 mask, u32 val)
+void wlapi_bmac_mctrl(struct phy_shim_info *physhim, u32 mask, u32 val)
 {
 	brcms_b_mctrl(physhim->wlc_hw, mask, val);
 }
 
-void wlapi_bmac_phy_reset(wlc_phy_shim_info_t *physhim)
+void wlapi_bmac_phy_reset(struct phy_shim_info *physhim)
 {
 	brcms_b_phy_reset(physhim->wlc_hw);
 }
 
-void wlapi_bmac_bw_set(wlc_phy_shim_info_t *physhim, u16 bw)
+void wlapi_bmac_bw_set(struct phy_shim_info *physhim, u16 bw)
 {
 	brcms_b_bw_set(physhim->wlc_hw, bw);
 }
 
-u16 wlapi_bmac_get_txant(wlc_phy_shim_info_t *physhim)
+u16 wlapi_bmac_get_txant(struct phy_shim_info *physhim)
 {
 	return brcms_b_get_txant(physhim->wlc_hw);
 }
 
-void wlapi_bmac_phyclk_fgc(wlc_phy_shim_info_t *physhim, bool clk)
+void wlapi_bmac_phyclk_fgc(struct phy_shim_info *physhim, bool clk)
 {
 	brcms_b_phyclk_fgc(physhim->wlc_hw, clk);
 }
 
-void wlapi_bmac_macphyclk_set(wlc_phy_shim_info_t *physhim, bool clk)
+void wlapi_bmac_macphyclk_set(struct phy_shim_info *physhim, bool clk)
 {
 	brcms_b_macphyclk_set(physhim->wlc_hw, clk);
 }
 
-void wlapi_bmac_core_phypll_ctl(wlc_phy_shim_info_t *physhim, bool on)
+void wlapi_bmac_core_phypll_ctl(struct phy_shim_info *physhim, bool on)
 {
 	brcms_b_core_phypll_ctl(physhim->wlc_hw, on);
 }
 
-void wlapi_bmac_core_phypll_reset(wlc_phy_shim_info_t *physhim)
+void wlapi_bmac_core_phypll_reset(struct phy_shim_info *physhim)
 {
 	brcms_b_core_phypll_reset(physhim->wlc_hw);
 }
 
-void wlapi_bmac_ucode_wake_override_phyreg_set(wlc_phy_shim_info_t *physhim)
+void wlapi_bmac_ucode_wake_override_phyreg_set(struct phy_shim_info *physhim)
 {
 	brcms_c_ucode_wake_override_set(physhim->wlc_hw,
 					WLC_WAKE_OVERRIDE_PHYREG);
 }
 
-void wlapi_bmac_ucode_wake_override_phyreg_clear(wlc_phy_shim_info_t *physhim)
+void wlapi_bmac_ucode_wake_override_phyreg_clear(struct phy_shim_info *physhim)
 {
 	brcms_c_ucode_wake_override_clear(physhim->wlc_hw,
 					  WLC_WAKE_OVERRIDE_PHYREG);
 }
 
 void
-wlapi_bmac_write_template_ram(wlc_phy_shim_info_t *physhim, int offset,
+wlapi_bmac_write_template_ram(struct phy_shim_info *physhim, int offset,
 			      int len, void *buf)
 {
 	brcms_b_write_template_ram(physhim->wlc_hw, offset, len, buf);
 }
 
-u16 wlapi_bmac_rate_shm_offset(wlc_phy_shim_info_t *physhim, u8 rate)
+u16 wlapi_bmac_rate_shm_offset(struct phy_shim_info *physhim, u8 rate)
 {
 	return brcms_b_rate_shm_offset(physhim->wlc_hw, rate);
 }
 
-void wlapi_ucode_sample_init(wlc_phy_shim_info_t *physhim)
+void wlapi_ucode_sample_init(struct phy_shim_info *physhim)
 {
 }
 
 void
-wlapi_copyfrom_objmem(wlc_phy_shim_info_t *physhim, uint offset, void *buf,
+wlapi_copyfrom_objmem(struct phy_shim_info *physhim, uint offset, void *buf,
 		      int len, u32 sel)
 {
 	brcms_b_copyfrom_objmem(physhim->wlc_hw, offset, buf, len, sel);
 }
 
 void
-wlapi_copyto_objmem(wlc_phy_shim_info_t *physhim, uint offset, const void *buf,
+wlapi_copyto_objmem(struct phy_shim_info *physhim, uint offset, const void *buf,
 		    int l, u32 sel)
 {
 	brcms_b_copyto_objmem(physhim->wlc_hw, offset, buf, l, sel);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index 61b3720..a4550ed 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -108,57 +108,57 @@
 #define WLC_N_TXRX_CHAIN0		0
 #define WLC_N_TXRX_CHAIN1		1
 
-extern wlc_phy_shim_info_t *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
+extern struct phy_shim_info *wlc_phy_shim_attach(struct brcms_c_hw_info *wlc_hw,
 						void *wl, void *wlc);
-extern void wlc_phy_shim_detach(wlc_phy_shim_info_t *physhim);
+extern void wlc_phy_shim_detach(struct phy_shim_info *physhim);
 
 /* PHY to WL utility functions */
-extern struct wlapi_timer *wlapi_init_timer(wlc_phy_shim_info_t *physhim,
+extern struct wlapi_timer *wlapi_init_timer(struct phy_shim_info *physhim,
 					    void (*fn) (void *arg), void *arg,
 					    const char *name);
-extern void wlapi_free_timer(wlc_phy_shim_info_t *physhim,
+extern void wlapi_free_timer(struct phy_shim_info *physhim,
 			     struct wlapi_timer *t);
-extern void wlapi_add_timer(wlc_phy_shim_info_t *physhim,
+extern void wlapi_add_timer(struct phy_shim_info *physhim,
 			    struct wlapi_timer *t, uint ms, int periodic);
-extern bool wlapi_del_timer(wlc_phy_shim_info_t *physhim,
+extern bool wlapi_del_timer(struct phy_shim_info *physhim,
 			    struct wlapi_timer *t);
-extern void wlapi_intrson(wlc_phy_shim_info_t *physhim);
-extern u32 wlapi_intrsoff(wlc_phy_shim_info_t *physhim);
-extern void wlapi_intrsrestore(wlc_phy_shim_info_t *physhim,
+extern void wlapi_intrson(struct phy_shim_info *physhim);
+extern u32 wlapi_intrsoff(struct phy_shim_info *physhim);
+extern void wlapi_intrsrestore(struct phy_shim_info *physhim,
 			       u32 macintmask);
 
-extern void wlapi_bmac_write_shm(wlc_phy_shim_info_t *physhim, uint offset,
+extern void wlapi_bmac_write_shm(struct phy_shim_info *physhim, uint offset,
 				 u16 v);
-extern u16 wlapi_bmac_read_shm(wlc_phy_shim_info_t *physhim, uint offset);
-extern void wlapi_bmac_mhf(wlc_phy_shim_info_t *physhim, u8 idx,
+extern u16 wlapi_bmac_read_shm(struct phy_shim_info *physhim, uint offset);
+extern void wlapi_bmac_mhf(struct phy_shim_info *physhim, u8 idx,
 			   u16 mask, u16 val, int bands);
-extern void wlapi_bmac_corereset(wlc_phy_shim_info_t *physhim, u32 flags);
-extern void wlapi_suspend_mac_and_wait(wlc_phy_shim_info_t *physhim);
-extern void wlapi_switch_macfreq(wlc_phy_shim_info_t *physhim, u8 spurmode);
-extern void wlapi_enable_mac(wlc_phy_shim_info_t *physhim);
-extern void wlapi_bmac_mctrl(wlc_phy_shim_info_t *physhim, u32 mask,
+extern void wlapi_bmac_corereset(struct phy_shim_info *physhim, u32 flags);
+extern void wlapi_suspend_mac_and_wait(struct phy_shim_info *physhim);
+extern void wlapi_switch_macfreq(struct phy_shim_info *physhim, u8 spurmode);
+extern void wlapi_enable_mac(struct phy_shim_info *physhim);
+extern void wlapi_bmac_mctrl(struct phy_shim_info *physhim, u32 mask,
 			     u32 val);
-extern void wlapi_bmac_phy_reset(wlc_phy_shim_info_t *physhim);
-extern void wlapi_bmac_bw_set(wlc_phy_shim_info_t *physhim, u16 bw);
-extern void wlapi_bmac_phyclk_fgc(wlc_phy_shim_info_t *physhim, bool clk);
-extern void wlapi_bmac_macphyclk_set(wlc_phy_shim_info_t *physhim, bool clk);
-extern void wlapi_bmac_core_phypll_ctl(wlc_phy_shim_info_t *physhim, bool on);
-extern void wlapi_bmac_core_phypll_reset(wlc_phy_shim_info_t *physhim);
-extern void wlapi_bmac_ucode_wake_override_phyreg_set(wlc_phy_shim_info_t *
+extern void wlapi_bmac_phy_reset(struct phy_shim_info *physhim);
+extern void wlapi_bmac_bw_set(struct phy_shim_info *physhim, u16 bw);
+extern void wlapi_bmac_phyclk_fgc(struct phy_shim_info *physhim, bool clk);
+extern void wlapi_bmac_macphyclk_set(struct phy_shim_info *physhim, bool clk);
+extern void wlapi_bmac_core_phypll_ctl(struct phy_shim_info *physhim, bool on);
+extern void wlapi_bmac_core_phypll_reset(struct phy_shim_info *physhim);
+extern void wlapi_bmac_ucode_wake_override_phyreg_set(struct phy_shim_info *
 						      physhim);
-extern void wlapi_bmac_ucode_wake_override_phyreg_clear(wlc_phy_shim_info_t *
+extern void wlapi_bmac_ucode_wake_override_phyreg_clear(struct phy_shim_info *
 							physhim);
-extern void wlapi_bmac_write_template_ram(wlc_phy_shim_info_t *physhim, int o,
+extern void wlapi_bmac_write_template_ram(struct phy_shim_info *physhim, int o,
 					  int len, void *buf);
-extern u16 wlapi_bmac_rate_shm_offset(wlc_phy_shim_info_t *physhim,
+extern u16 wlapi_bmac_rate_shm_offset(struct phy_shim_info *physhim,
 					 u8 rate);
-extern void wlapi_ucode_sample_init(wlc_phy_shim_info_t *physhim);
-extern void wlapi_copyfrom_objmem(wlc_phy_shim_info_t *physhim, uint,
+extern void wlapi_ucode_sample_init(struct phy_shim_info *physhim);
+extern void wlapi_copyfrom_objmem(struct phy_shim_info *physhim, uint,
 				  void *buf, int, u32 sel);
-extern void wlapi_copyto_objmem(wlc_phy_shim_info_t *physhim, uint,
+extern void wlapi_copyto_objmem(struct phy_shim_info *physhim, uint,
 				const void *buf, int, u32);
 
-extern void wlapi_high_update_phy_mode(wlc_phy_shim_info_t *physhim,
+extern void wlapi_high_update_phy_mode(struct phy_shim_info *physhim,
 				       u32 phy_mode);
-extern u16 wlapi_bmac_get_txant(wlc_phy_shim_info_t *physhim);
+extern u16 wlapi_bmac_get_txant(struct phy_shim_info *physhim);
 #endif				/* _BRCM_PHY_SHIM_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 58ae61d..c1f2fdc 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -106,7 +106,7 @@
 #define	WL_SPURAVOID_ON1	1
 #define	WL_SPURAVOID_ON2	2
 
-struct wlc_tunables {
+struct brcms_tunables {
 	int ntxd;		/* size of tx descriptor table */
 	int nrxd;		/* size of rx descriptor table */
 	int rxbufsz;		/* size of rx buffers to post */
@@ -124,7 +124,7 @@ struct wlc_tunables {
 	int memreserved;	/* memory reserved for BMAC's USB dma rx */
 };
 
-struct wlc_rateset {
+struct brcms_rateset {
 	uint count;		/* number of rates in rates[] */
 	u8 rates[WLC_NUMRATES];	/* rates in 500kbps units w/hi bit set if basic */
 	u8 htphy_membership;	/* HT PHY Membership */
@@ -160,7 +160,7 @@ struct rsn_parms {
 	IEEE80211_HT_CAP_MAX_AMSDU | IEEE80211_HT_CAP_DSSSCCK40)
 
 /* wlc internal bss_info */
-struct wlc_bss_info {
+struct brcms_bss_info {
 	u8 BSSID[ETH_ALEN];	/* network BSSID */
 	u16 flags;		/* flags for internal attributes */
 	u8 SSID_len;		/* the length of SSID */
@@ -242,12 +242,12 @@ typedef int (*iovar_fn_t) (void *handle, const struct brcmu_iovar *vi,
  * Public portion of "common" os-independent state structure.
  * The wlc handle points at this.
  */
-struct wlc_pub {
+struct brcms_pub {
 	void *wlc;
 
 	struct ieee80211_hw *ieee_hw;
 	struct scb *global_scb;
-	scb_ampdu_t *global_ampdu;
+	struct scb_ampdu *global_ampdu;
 	uint mac80211_state;
 	uint unit;		/* device instance number */
 	uint corerev;		/* core revision */
@@ -255,7 +255,8 @@ struct wlc_pub {
 	char *vars;		/* "environment" name=value */
 	bool up;		/* interface up and running */
 	bool hw_off;		/* HW is off */
-	wlc_tunables_t *tunables;	/* tunables: ntxd, nrxd, maxscb, etc. */
+	/* tunables: ntxd, nrxd, maxscb, etc. */
+	struct brcms_tunables *tunables;
 	bool hw_up;		/* one time hw up/down(from boot or hibernation) */
 	bool _piomode;		/* true if pio mode *//* BMAC_NOTE: NEED In both */
 	uint _nbands;		/* # bands supported */
@@ -570,7 +571,7 @@ extern const u8 wme_fifo2ac[];
 
 #define HIGHEST_SINGLE_STREAM_MCS	7	/* MCS values greater than this enable multiple streams */
 
-struct wlc_antselcfg {
+struct brcms_antselcfg {
 	u8 ant_config[ANT_SELCFG_MAX];	/* antenna configuration */
 	u8 num_antcfg;	/* number of available antenna configurations */
 };
@@ -615,7 +616,7 @@ extern void brcms_c_set_addrmatch(struct brcms_c_info *wlc,
 extern void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 			      const struct ieee80211_tx_queue_params *arg,
 			      bool suspend);
-extern struct wlc_pub *brcms_c_pub(void *wlc);
+extern struct brcms_pub *brcms_c_pub(void *wlc);
 
 /* common functions for every port */
 extern void brcms_c_mhf(struct brcms_c_info *wlc, u8 idx, u16 mask, u16 val,
@@ -639,10 +640,10 @@ extern int getintvar(char *vars, const char *name);
 extern void brcms_c_set_ps_ctrl(struct brcms_c_info *wlc);
 extern void brcms_c_mctrl(struct brcms_c_info *wlc, u32 mask, u32 val);
 
-extern int brcms_c_module_register(struct wlc_pub *pub,
+extern int brcms_c_module_register(struct brcms_pub *pub,
 			       const char *name, void *hdl,
 			       watchdog_fn_t watchdog_fn, down_fn_t down_fn);
-extern int brcms_c_module_unregister(struct wlc_pub *pub, const char *name,
+extern int brcms_c_module_unregister(struct brcms_pub *pub, const char *name,
 				 void *hdl);
 extern void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc);
 extern void brcms_c_enable_mac(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index dec508d..487523e 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -38,7 +38,7 @@ const u8 rate_info[WLC_MAXRATE + 1] = {
 };
 
 /* rates are in units of Kbps */
-const mcs_info_t mcs_table[MCS_TABLE_SIZE] = {
+const struct brcms_mcs_info mcs_table[MCS_TABLE_SIZE] = {
 	/* MCS  0: SS 1, MOD: BPSK,  CR 1/2 */
 	{6500, 13500, CEIL(6500 * 10, 9), CEIL(13500 * 10, 9), 0x00,
 	 WLC_RATE_6M},
@@ -143,17 +143,18 @@ const mcs_info_t mcs_table[MCS_TABLE_SIZE] = {
  *   Number of spatial streams: always 1
  *   other fields: refer to table 78 of section 17.3.2.2 of the original .11a standard
  */
-typedef struct legacy_phycfg {
+struct legacy_phycfg {
 	u32 rate_ofdm;	/* ofdm mac rate */
 	u8 tx_phy_ctl3;	/* phy ctl byte 3, code rate, modulation type, # of streams */
-} legacy_phycfg_t;
+};
 
 #define LEGACY_PHYCFG_TABLE_SIZE	12	/* Number of legacy_rate_cfg entries in the table */
 
 /* In CCK mode LPPHY overloads OFDM Modulation bits with CCK Data Rate */
 /* Eventually MIMOPHY would also be converted to this format */
 /* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
-static const legacy_phycfg_t legacy_phycfg_table[LEGACY_PHYCFG_TABLE_SIZE] = {
+static const struct
+legacy_phycfg legacy_phycfg_table[LEGACY_PHYCFG_TABLE_SIZE] = {
 	{WLC_RATE_1M, 0x00},	/* CCK  1Mbps,  data rate  0 */
 	{WLC_RATE_2M, 0x08},	/* CCK  2Mbps,  data rate  1 */
 	{WLC_RATE_5M5, 0x10},	/* CCK  5.5Mbps,  data rate  2 */
@@ -320,7 +321,7 @@ brcms_c_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 }
 
 /* calculate the rate of a rx'd frame and return it as a ratespec */
-ratespec_t brcms_c_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
+ratespec_t brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
 {
 	int phy_type;
 	ratespec_t rspec = PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT;
@@ -333,12 +334,13 @@ ratespec_t brcms_c_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
 		switch (rxh->PhyRxStatus_0 & PRXS0_FT_MASK) {
 		case PRXS0_CCK:
 			rspec =
-			    CCK_PHY2MAC_RATE(((cck_phy_hdr_t *) plcp)->signal);
+			    CCK_PHY2MAC_RATE(
+				((struct cck_phy_hdr *) plcp)->signal);
 			break;
 		case PRXS0_OFDM:
 			rspec =
-			    OFDM_PHY2MAC_RATE(((ofdm_phy_hdr_t *) plcp)->
-					      rlpt[0]);
+			    OFDM_PHY2MAC_RATE(
+				((struct ofdm_phy_hdr *) plcp)->rlpt[0]);
 			break;
 		case PRXS0_PREN:
 			rspec = (plcp[0] & MIMO_PLCP_MCS_MASK) | RSPEC_MIMORATE;
@@ -358,9 +360,11 @@ ratespec_t brcms_c_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
 			rspec |= RSPEC_SHORT_GI;
 	} else
 	    if ((phy_type == PHY_TYPE_A) || (rxh->PhyRxStatus_0 & PRXS0_OFDM))
-		rspec = OFDM_PHY2MAC_RATE(((ofdm_phy_hdr_t *) plcp)->rlpt[0]);
+		rspec = OFDM_PHY2MAC_RATE(
+				((struct ofdm_phy_hdr *) plcp)->rlpt[0]);
 	else
-		rspec = CCK_PHY2MAC_RATE(((cck_phy_hdr_t *) plcp)->signal);
+		rspec = CCK_PHY2MAC_RATE(
+				((struct cck_phy_hdr *) plcp)->signal);
 
 	return rspec;
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index 268125f..c3dec35 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -20,16 +20,16 @@
 #include "types.h"
 
 extern const u8 rate_info[];
-extern const struct wlc_rateset cck_ofdm_mimo_rates;
-extern const struct wlc_rateset ofdm_mimo_rates;
-extern const struct wlc_rateset cck_ofdm_rates;
-extern const struct wlc_rateset ofdm_rates;
-extern const struct wlc_rateset cck_rates;
-extern const struct wlc_rateset gphy_legacy_rates;
-extern const struct wlc_rateset wlc_lrs_rates;
-extern const struct wlc_rateset rate_limit_1_2;
-
-struct mcs_info {
+extern const struct brcms_rateset cck_ofdm_mimo_rates;
+extern const struct brcms_rateset ofdm_mimo_rates;
+extern const struct brcms_rateset cck_ofdm_rates;
+extern const struct brcms_rateset ofdm_rates;
+extern const struct brcms_rateset cck_rates;
+extern const struct brcms_rateset gphy_legacy_rates;
+extern const struct brcms_rateset wlc_lrs_rates;
+extern const struct brcms_rateset rate_limit_1_2;
+
+struct brcms_mcs_info {
 	u32 phy_rate_20;	/* phy rate in kbps [20Mhz] */
 	u32 phy_rate_40;	/* phy rate in kbps [40Mhz] */
 	u32 phy_rate_20_sgi;	/* phy rate in kbps [20Mhz] with SGI */
@@ -40,7 +40,7 @@ struct mcs_info {
 
 #define WLC_MAXMCS	32	/* max valid mcs index */
 #define MCS_TABLE_SIZE	33	/* Number of mcs entries in the table */
-extern const mcs_info_t mcs_table[];
+extern const struct brcms_mcs_info mcs_table[];
 
 #define MCS_INVALID	0xFF
 #define MCS_CR_MASK	0x07	/* Code Rate bit mask */
@@ -139,31 +139,33 @@ extern const u8 ofdm_rate_lookup[];
 #define WLC_RATES_OFDM		2
 
 /* sanitize, and sort a rateset with the basic bit(s) preserved, validate rateset */
-extern bool brcms_c_rate_hwrs_filter_sort_validate(struct wlc_rateset *rs,
-					       const struct wlc_rateset *hw_rs,
-					       bool check_brate,
-					       u8 txstreams);
+extern bool
+brcms_c_rate_hwrs_filter_sort_validate(struct brcms_rateset *rs,
+				       const struct brcms_rateset *hw_rs,
+				       bool check_brate, u8 txstreams);
 /* copy rateset src to dst as-is (no masking or sorting) */
-extern void brcms_c_rateset_copy(const struct wlc_rateset *src,
-			     struct wlc_rateset *dst);
+extern void brcms_c_rateset_copy(const struct brcms_rateset *src,
+			     struct brcms_rateset *dst);
 
 /* would be nice to have these documented ... */
-extern ratespec_t brcms_c_compute_rspec(d11rxhdr_t *rxh, u8 *plcp);
+extern ratespec_t brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp);
 
-extern void brcms_c_rateset_filter(struct wlc_rateset *src,
-	struct wlc_rateset *dst, bool basic_only, u8 rates, uint xmask,
+extern void brcms_c_rateset_filter(struct brcms_rateset *src,
+	struct brcms_rateset *dst, bool basic_only, u8 rates, uint xmask,
 	bool mcsallow);
 
-extern void brcms_c_rateset_default(struct wlc_rateset *rs_tgt,
-				const struct wlc_rateset *rs_hw, uint phy_type,
-				int bandtype, bool cck_only, uint rate_mask,
-				bool mcsallow, u8 bw, u8 txstreams);
+extern void
+brcms_c_rateset_default(struct brcms_rateset *rs_tgt,
+			const struct brcms_rateset *rs_hw, uint phy_type,
+			int bandtype, bool cck_only, uint rate_mask,
+			bool mcsallow, u8 bw, u8 txstreams);
+
 extern s16 brcms_c_rate_legacy_phyctl(uint rate);
 
-extern void brcms_c_rateset_mcs_upd(struct wlc_rateset *rs, u8 txstreams);
-extern void brcms_c_rateset_mcs_clear(struct wlc_rateset *rateset);
-extern void brcms_c_rateset_mcs_build(struct wlc_rateset *rateset,
+extern void brcms_c_rateset_mcs_upd(struct brcms_rateset *rs, u8 txstreams);
+extern void brcms_c_rateset_mcs_clear(struct brcms_rateset *rateset);
+extern void brcms_c_rateset_mcs_build(struct brcms_rateset *rateset,
 				      u8 txstreams);
-extern void brcms_c_rateset_bw_mcs_filter(struct wlc_rateset *rateset, u8 bw);
+extern void brcms_c_rateset_bw_mcs_filter(struct brcms_rateset *rateset, u8 bw);
 
 #endif				/* _WLC_RATE_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/scb.h b/drivers/staging/brcm80211/brcmsmac/scb.h
index e814e5e..d6c8328 100644
--- a/drivers/staging/brcm80211/brcmsmac/scb.h
+++ b/drivers/staging/brcm80211/brcmsmac/scb.h
@@ -47,7 +47,8 @@ struct scb_ampdu {
 	 * of having mac80211 hold it for us.  Also could be made dynamic per tid instead of
 	 * static.
 	 */
-	scb_ampdu_tid_ini_t ini[AMPDU_MAX_SCB_TID];	/* initiator info - per tid (NUMPRIO) */
+	/* initiator info - per tid (NUMPRIO): */
+	struct scb_ampdu_tid_ini ini[AMPDU_MAX_SCB_TID];
 };
 
 #define SCB_MAGIC	0xbeefcafe
@@ -68,7 +69,7 @@ struct scb {
 				 */
 	u16 seqnum[NUMPRIO];	/* WME: driver maintained sw seqnum per priority */
 
-	scb_ampdu_t scb_ampdu;	/* AMPDU state including per tid info */
+	struct scb_ampdu scb_ampdu;	/* AMPDU state including per tid info */
 };
 
 /* scb flags */
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index de3e703..f39442e 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -361,19 +361,19 @@
 /* Max. nvram variable table size */
 #define	MAXSZ_NVRAM_VARS	4096
 
-typedef struct {
+struct brcms_sromvar {
 	const char *name;
 	u32 revmask;
 	u32 flags;
 	u16 off;
 	u16 mask;
-} sromvar_t;
+};
 
-typedef struct varbuf {
+struct brcms_varbuf {
 	char *base;		/* pointer to buffer base */
 	char *buf;		/* pointer to current position */
 	unsigned int size;	/* current (residual) size in bytes */
-} varbuf_t;
+};
 
 /* Assumptions:
  * - Ethernet address spans across 3 consective words
@@ -387,7 +387,7 @@ typedef struct varbuf {
  * - The last entry's name field must be NULL to indicate the end of the table. Other
  *   entries must have non-NULL name.
  */
-static const sromvar_t pci_sromvars[] = {
+static const struct brcms_sromvar pci_sromvars[] = {
 	{"devid", 0xffffff00, SRFL_PRHEX | SRFL_NOVAR, PCI_F0DEVID, 0xffff},
 	{"boardrev", 0x0000000e, SRFL_PRHEX, SROM_AABREV, SROM_BR_MASK},
 	{"boardrev", 0x000000f0, SRFL_PRHEX, SROM4_BREV, 0xffff},
@@ -731,7 +731,7 @@ static const sromvar_t pci_sromvars[] = {
 	{NULL, 0, 0, 0, 0}
 };
 
-static const sromvar_t perpath_pci_sromvars[] = {
+static const struct brcms_sromvar perpath_pci_sromvars[] = {
 	{"maxp2ga", 0x000000f0, 0, SROM4_2G_ITT_MAXP, 0x00ff},
 	{"itt2ga", 0x000000f0, 0, SROM4_2G_ITT_MAXP, 0xff00},
 	{"itt5ga", 0x000000f0, 0, SROM4_5G_ITT_MAXP, 0xff00},
@@ -775,7 +775,8 @@ static const sromvar_t perpath_pci_sromvars[] = {
 	{NULL, 0, 0, 0, 0}
 };
 
-static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b);
+static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off,
+			       struct brcms_varbuf *b);
 static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 			     uint *count);
 static int sprom_read_pci(struct si_pub *sih, u16 *sprom,
@@ -788,14 +789,14 @@ static int initvars_table(char *start, char *end,
 			  char **vars, uint *count);
 
 /* Initialization of varbuf structure */
-static void varbuf_init(varbuf_t *b, char *buf, uint size)
+static void varbuf_init(struct brcms_varbuf *b, char *buf, uint size)
 {
 	b->size = size;
 	b->base = b->buf = buf;
 }
 
 /* append a null terminated var=value string */
-static int varbuf_append(varbuf_t *b, const char *fmt, ...)
+static int varbuf_append(struct brcms_varbuf *b, const char *fmt, ...)
 {
 	va_list ap;
 	int r;
@@ -1011,11 +1012,12 @@ static uint mask_width(u16 mask)
 	return 0;
 }
 
-static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b)
+static void
+_initvars_srom_pci(u8 sromrev, u16 *srom, uint off, struct brcms_varbuf *b)
 {
 	u16 w;
 	u32 val;
-	const sromvar_t *srv;
+	const struct brcms_sromvar *srv;
 	uint width;
 	uint flags;
 	u32 sr = (1 << sromrev);
@@ -1153,7 +1155,7 @@ static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
 	u16 *srom, *sromwindow;
 	u8 sromrev = 0;
 	u32 sr;
-	varbuf_t b;
+	struct brcms_varbuf b;
 	char *vp, *base = NULL;
 	int err = 0;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index b1370be..9ab7fe2 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -206,7 +206,7 @@
  * Defaults for tunables (e.g. sizing constants)
  *
  * For each new tunable, add a member to the end
- * of wlc_tunables_t in brcms_c_pub.h to enable
+ * of struct brcms_tunables in brcms_c_pub.h to enable
  * runtime checks of tunable values. (Directly
  * using the macros in code invalidates ROM code)
  *
@@ -353,105 +353,42 @@ typedef u32 mbool;
 #define	mboolmaskset(mb, mask, val)	((mb) = (((mb) & ~(mask)) | (val)))
 
 /* forward declarations */
-struct sk_buff;
+struct wiphy;
+struct ieee80211_sta;
+struct ieee80211_tx_queue_params;
 struct brcms_info;
 struct brcms_c_info;
 struct brcms_c_hw_info;
 struct brcms_c_if;
-struct brcms_if;
-struct ampdu_info;
-struct antsel_info;
-struct bmac_pmq;
-struct d11init;
-struct dma_pub;
-struct brcms_c_bsscfg;
-struct brcmu_strbuf;
-struct si_pub;
-struct wiphy;
 struct brcmu_iovar;
+struct brcmu_strbuf;
 struct brcms_c_txq_info;
 struct brcms_c_band;
-struct ieee80211_tx_queue_params;
-struct ieee80211_sta;
+struct dma_pub;
+struct si_pub;
+struct tx_status;
+struct d11rxhdr;
+struct brcms_d11rxhdr;
+struct txpwr_limits;
 
-typedef struct gpioh_item gpioh_item_t;
-typedef struct si_info si_info_t;
-typedef struct brcms_b_state brcms_b_state_t;
-typedef struct locale_info locale_info_t;
-typedef struct locale_mimo_info locale_mimo_info_t;
-typedef struct country_info country_info_t;
-typedef struct wlc_cm_info wlc_cm_info_t;
 typedef volatile struct intctrlregs intctrlregs_t;
 typedef volatile struct pio2regs pio2regs_t;
 typedef volatile struct pio2regp pio2regp_t;
-typedef struct ofdm_phy_hdr ofdm_phy_hdr_t;
-typedef struct cck_phy_hdr cck_phy_hdr_t;
-typedef struct d11txh d11txh_t;
-typedef struct tx_status tx_status_t;
-typedef struct shm_acparams shm_acparams_t;
-typedef struct d11rxhdr d11rxhdr_t;
-typedef struct wlc_d11rxhdr wlc_d11rxhdr_t;
 typedef volatile struct pio4regs pio4regs_t;
 typedef volatile struct pio4regp pio4regp_t;
 typedef volatile struct fifo64 fifo64_t;
 typedef volatile struct d11regs d11regs_t;
-typedef struct macstat macstat_t;
-typedef struct d11cnt d11cnt_t;
 typedef volatile struct dma32diag dma32diag_t;
 typedef volatile struct dma64regs dma64regs_t;
-typedef enum txd_range txd_range_t;
-typedef struct di_fcn_s di_fcn_t;
-typedef struct wsec_iv wsec_iv_t;
-typedef struct wsec_key wsec_key_t;
-typedef struct edcf_acparam edcf_acparam_t;
-typedef struct wme_param_ie wme_param_ie_t;
-typedef struct wlc_phy_shim_info wlc_phy_shim_info_t;
-typedef struct wlc_tunables wlc_tunables_t;
-typedef struct wlc_rateset wlc_rateset_t;
-typedef struct wlc_bss_info  wlc_bss_info_t;
-typedef struct wl_rxsts wl_rxsts_t;
-typedef struct wlc_antselcfg wlc_antselcfg_t;
-typedef struct mcs_info mcs_info_t;
+typedef struct brcms_rateset wlc_rateset_t;
 typedef u32 ratespec_t;
-typedef struct scb_ampdu_tid_ini scb_ampdu_tid_ini_t;
-typedef struct scb_ampdu scb_ampdu_t;
-typedef struct txpwr_limits txpwr_limits_t;
 typedef struct tx_power tx_power_t;
-typedef struct tx_inst_power tx_inst_power_t;
 typedef struct chanvec chanvec_t;
-typedef struct shared_phy shared_phy_t;
-typedef struct shared_phy_params shared_phy_params_t;
 typedef struct phy_pub wlc_phy_t;
-typedef struct wlc_phy_srom_fem wlc_phy_srom_fem_t;
 typedef struct phy_info phy_info_t;
-typedef enum phy_cal_mode phy_cal_mode_t;
-typedef struct phy_table_info phy_table_info_t;
-typedef struct phytbl_info phytbl_info_t;
-typedef struct interference_info interference_info_t;
-typedef struct aci_save_gphy  aci_save_gphy_t;
-typedef struct lo_complex_abgphy_info lo_complex_abgphy_info_t;
-typedef struct nphy_iq_comp nphy_iq_comp_t;
-typedef struct nphy_txpwrindex phy_txpwrindex_t;
-typedef struct txiqcal_cache txiqcal_cache_t;
-typedef struct nphy_pwrctrl  phy_pwrctrl_t;
-typedef struct nphy_txgains nphy_txgains_t;
-typedef struct nphy_noisevar_buf phy_noisevar_buf_t;
-typedef struct rssical_cache rssical_cache_t;
-typedef struct lcnphy_cal_results lcnphy_cal_results_t;
-typedef struct phy_info_nphy phy_info_nphy_t;
-typedef struct phy_info_lcnphy phy_info_lcnphy_t;
-typedef struct phy_func_ptr phy_func_ptr_t;
 typedef s32 fixed;
 typedef struct _cs32 cs32;
-typedef struct radio_regs radio_regs_t;
-typedef struct radio_20xx_regs radio_20xx_regs_t;
-typedef struct lcnphy_radio_regs lcnphy_radio_regs_t;
-typedef struct phy_iq_est phy_iq_est_t;
-typedef phytbl_info_t dot11lcnphytbl_info_t;
-typedef struct _lcnphy_tx_gain_tbl_entry lcnphy_tx_gain_tbl_entry;
-typedef phytbl_info_t mimophytbl_info_t;
 typedef volatile union pmqreg pmqreg_t;
-typedef enum _ePsmScratchPadRegDefinitions  ePsmScratchPadRegDefinitions;
 
 /* brcm_msg_level is a bit vector with defs in defs.h */
 extern u32 brcm_msg_level;
-- 
1.7.4.1


