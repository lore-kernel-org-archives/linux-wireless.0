Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1863 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753407Ab1HHN7j (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 74/82] staging: brcm80211: removed unused bus code
 from softmac
Date: Mon, 8 Aug 2011 15:58:58 +0200
Message-ID: <1312811946-16713-75-git-send-email-arend@broadcom.com> (sfid-20110808_160003_469480_2DD891FD)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. For the softmac, the 'bustype' in use is always PCI_BUS. Hence
code related to dealing with different bus types (eg: PCI_BUS, JTAG_BUS,
SI_BUS) could be removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |  480 +++++++---------------
 drivers/staging/brcm80211/brcmsmac/aiutils.h     |   12 +-
 drivers/staging/brcm80211/brcmsmac/dma.c         |   13 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |   17 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.h |    3 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |  111 ++---
 drivers/staging/brcm80211/brcmsmac/nicpci.c      |    4 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   17 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h |    1 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    3 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |    2 +-
 drivers/staging/brcm80211/brcmsmac/srom.c        |    5 +-
 drivers/staging/brcm80211/brcmsmac/srom.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/types.h       |    5 +-
 14 files changed, 227 insertions(+), 450 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 4b1c60f..37edd1c 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -12,7 +12,10 @@
  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
  * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
  * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ *
+ * File contents: support functions for PCI/PCIe
  */
+
 #include <linux/delay.h>
 #include <linux/pci.h>
 
@@ -488,30 +491,12 @@ void ai_scan(struct si_pub *sih, void *regs)
 
 	erombase = R_REG(&cc->eromptr);
 
-	switch (sih->bustype) {
-	case SI_BUS:
-		eromptr = (u32 *) REG_MAP(erombase, SI_CORE_SIZE);
-		break;
-
-	case PCI_BUS:
-		/* Set wrappers address */
-		sii->curwrap = (void *)((unsigned long)regs + SI_CORE_SIZE);
-
-		/* Now point the window at the erom */
-		pci_write_config_dword(sii->pbus, PCI_BAR0_WIN, erombase);
-		eromptr = regs;
-		break;
-
-	case SPI_BUS:
-	case SDIO_BUS:
-		eromptr = (u32 *)(unsigned long)erombase;
-		break;
+	/* Set wrappers address */
+	sii->curwrap = (void *)((unsigned long)regs + SI_CORE_SIZE);
 
-	default:
-		SI_ERROR(("Don't know how to do AXI enumertion on bus %d\n",
-			  sih->bustype));
-		return;
-	}
+	/* Now point the window at the erom */
+	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN, erombase);
+	eromptr = regs;
 	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
 
 	SI_VMSG(("ai_scan: regs = 0x%p, erombase = 0x%08x, eromptr = 0x%p, "
@@ -684,7 +669,8 @@ void ai_scan(struct si_pub *sih, void *regs)
 	return;
 }
 
-/* This function changes the logical "focus" to the indicated core.
+/*
+ * This function changes the logical "focus" to the indicated core.
  * Return the current core's virtual address.
  */
 void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
@@ -692,47 +678,17 @@ void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 	struct si_info *sii = SI_INFO(sih);
 	u32 addr = sii->coresba[coreidx];
 	u32 wrap = sii->wrapba[coreidx];
-	void *regs;
 
 	if (coreidx >= sii->numcores)
 		return NULL;
 
-	switch (sih->bustype) {
-	case SI_BUS:
-		/* map new one */
-		if (!sii->regs[coreidx])
-			sii->regs[coreidx] = REG_MAP(addr, SI_CORE_SIZE);
-
-		sii->curmap = regs = sii->regs[coreidx];
-		if (!sii->wrappers[coreidx])
-			sii->wrappers[coreidx] = REG_MAP(wrap, SI_CORE_SIZE);
-
-		sii->curwrap = sii->wrappers[coreidx];
-		break;
-
-	case PCI_BUS:
-		/* point bar0 window */
-		pci_write_config_dword(sii->pbus, PCI_BAR0_WIN, addr);
-		regs = sii->curmap;
-		/* point bar0 2nd 4KB window */
-		pci_write_config_dword(sii->pbus, PCI_BAR0_WIN2, wrap);
-		break;
-
-	case SPI_BUS:
-	case SDIO_BUS:
-		sii->curmap = regs = (void *)(unsigned long)addr;
-		sii->curwrap = (void *)(unsigned long)wrap;
-		break;
-
-	default:
-		regs = NULL;
-		break;
-	}
-
-	sii->curmap = regs;
+	/* point bar0 window */
+	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN, addr);
+	/* point bar0 2nd 4KB window */
+	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN2, wrap);
 	sii->curidx = coreidx;
 
-	return regs;
+	return sii->curmap;
 }
 
 /* Return the number of address spaces in current core */
@@ -905,12 +861,10 @@ u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 /* *************** from siutils.c ************** */
 /* local prototypes */
 static struct si_info *ai_doattach(struct si_info *sii, void *regs,
-			      uint bustype, void *sdh, char **vars,
-			      uint *varsz);
-static bool ai_buscore_prep(struct si_info *sii, uint bustype);
+				   void *sdh, char **vars, uint *varsz);
+static bool ai_buscore_prep(struct si_info *sii);
 static bool ai_buscore_setup(struct si_info *sii, struct chipcregs *cc,
-			     uint bustype, u32 savewin, uint *origidx,
-			     void *regs);
+			     u32 savewin, uint *origidx, void *regs);
 static void ai_nvram_process(struct si_info *sii, char *pvars);
 
 /* dev path concatenation util */
@@ -919,20 +873,15 @@ static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
 static bool _ai_clkctl_cc(struct si_info *sii, uint mode);
 static bool ai_ispcie(struct si_info *sii);
 
-/* global variable to indicate reservation/release of gpio's */
-static u32 ai_gpioreservation;
-
 /*
  * Allocate a si handle.
  * devid - pci device id (used to determine chip#)
  * osh - opaque OS handle
  * regs - virtual address of initial core registers
- * bustype - pci/sb/sdio/etc
  * vars - pointer to a pointer area for "environment" variables
  * varsz - pointer to int to return the size of the vars
  */
-struct si_pub *ai_attach(void *regs, uint bustype,
-		void *sdh, char **vars, uint *varsz)
+struct si_pub *ai_attach(void *regs, void *sdh, char **vars, uint *varsz)
 {
 	struct si_info *sii;
 
@@ -943,8 +892,7 @@ struct si_pub *ai_attach(void *regs, uint bustype,
 		return NULL;
 	}
 
-	if (ai_doattach(sii, regs, bustype, sdh, vars, varsz) ==
-	    NULL) {
+	if (ai_doattach(sii, regs, sdh, vars, varsz) == NULL) {
 		kfree(sii);
 		return NULL;
 	}
@@ -957,17 +905,17 @@ struct si_pub *ai_attach(void *regs, uint bustype,
 /* global kernel resource */
 static struct si_info ksii;
 
-static bool ai_buscore_prep(struct si_info *sii, uint bustype)
+static bool ai_buscore_prep(struct si_info *sii)
 {
 	/* kludge to enable the clock on the 4306 which lacks a slowclock */
-	if (bustype == PCI_BUS && !ai_ispcie(sii))
+	if (!ai_ispcie(sii))
 		ai_clkctl_xtal(&sii->pub, XTAL | PLL, ON);
 	return true;
 }
 
 static bool
-ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, uint bustype,
-		 u32 savewin, uint *origidx, void *regs)
+ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, u32 savewin,
+		 uint *origidx, void *regs)
 {
 	bool pci, pcie;
 	uint i;
@@ -1015,16 +963,14 @@ ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, uint bustype,
 		SI_VMSG(("CORE[%d]: id 0x%x rev %d base 0x%x regs 0x%p\n",
 			 i, cid, crev, sii->coresba[i], sii->regs[i]));
 
-		if (bustype == PCI_BUS) {
-			if (cid == PCI_CORE_ID) {
-				pciidx = i;
-				pcirev = crev;
-				pci = true;
-			} else if (cid == PCIE_CORE_ID) {
-				pcieidx = i;
-				pcierev = crev;
-				pcie = true;
-			}
+		if (cid == PCI_CORE_ID) {
+			pciidx = i;
+			pcirev = crev;
+			pci = true;
+		} else if (cid == PCIE_CORE_ID) {
+			pcieidx = i;
+			pcierev = crev;
+			pcie = true;
 		}
 
 		/* find the core idx before entering this func. */
@@ -1053,21 +999,19 @@ ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, uint bustype,
 		 sii->pub.buscoretype, sii->pub.buscorerev));
 
 	/* fixup necessary chip/core configurations */
-	if (sii->pub.bustype == PCI_BUS) {
-		if (SI_FAST(sii)) {
-			if (!sii->pch) {
-				sii->pch = (void *)pcicore_init(
-					&sii->pub, sii->pbus,
-					(void *)PCIEREGS(sii));
-				if (sii->pch == NULL)
-					return false;
-			}
-		}
-		if (ai_pci_fixcfg(&sii->pub)) {
-			SI_ERROR(("si_doattach: si_pci_fixcfg failed\n"));
-			return false;
+	if (SI_FAST(sii)) {
+		if (!sii->pch) {
+			sii->pch = (void *)pcicore_init(
+				&sii->pub, sii->pbus,
+				(void *)PCIEREGS(sii));
+			if (sii->pch == NULL)
+				return false;
 		}
 	}
+	if (ai_pci_fixcfg(&sii->pub)) {
+		SI_ERROR(("si_doattach: si_pci_fixcfg failed\n"));
+		return false;
+	}
 
 	/* return to the original core */
 	ai_setcoreidx(&sii->pub, *origidx);
@@ -1075,47 +1019,31 @@ ai_buscore_setup(struct si_info *sii, struct chipcregs *cc, uint bustype,
 	return true;
 }
 
+/*
+ * get boardtype and boardrev
+ */
 static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 {
 	uint w = 0;
 
-	/* get boardtype and boardrev */
-	switch (sii->pub.bustype) {
-	case PCI_BUS:
-		/* do a pci config read to get subsystem id and subvendor id */
-		pci_read_config_dword(sii->pbus, PCI_SUBSYSTEM_VENDOR_ID, &w);
-		/* Let nvram variables override subsystem Vend/ID */
-		sii->pub.boardvendor = (u16)ai_getdevpathintvar(&sii->pub,
-			"boardvendor");
-		if (sii->pub.boardvendor == 0)
-			sii->pub.boardvendor = w & 0xffff;
-		else
-			SI_ERROR(("Overriding boardvendor: 0x%x instead of "
-				  "0x%x\n", sii->pub.boardvendor, w & 0xffff));
-		sii->pub.boardtype = (u16)ai_getdevpathintvar(&sii->pub,
-			"boardtype");
-		if (sii->pub.boardtype == 0)
-			sii->pub.boardtype = (w >> 16) & 0xffff;
-		else
-			SI_ERROR(("Overriding boardtype: 0x%x instead of 0x%x\n"
-				  , sii->pub.boardtype, (w >> 16) & 0xffff));
-		break;
-
-		sii->pub.boardvendor = getintvar(pvars, "manfid");
-		sii->pub.boardtype = getintvar(pvars, "prodid");
-		break;
+	/* do a pci config read to get subsystem id and subvendor id */
+	pci_read_config_dword(sii->pbus, PCI_SUBSYSTEM_VENDOR_ID, &w);
+	/* Let nvram variables override subsystem Vend/ID */
+	sii->pub.boardvendor = (u16)ai_getdevpathintvar(&sii->pub,
+							"boardvendor");
+	if (sii->pub.boardvendor == 0)
+		sii->pub.boardvendor = w & 0xffff;
+	else
+		SI_ERROR(("Overriding boardvendor: 0x%x instead of "
+			  "0x%x\n", sii->pub.boardvendor, w & 0xffff));
 
-	case SI_BUS:
-	case JTAG_BUS:
-		sii->pub.boardvendor = PCI_VENDOR_ID_BROADCOM;
-		sii->pub.boardtype = getintvar(pvars, "prodid");
-		if (pvars == NULL || (sii->pub.boardtype == 0)) {
-			sii->pub.boardtype = getintvar(NULL, "boardtype");
-			if (sii->pub.boardtype == 0)
-				sii->pub.boardtype = 0xffff;
-		}
-		break;
-	}
+	sii->pub.boardtype = (u16)ai_getdevpathintvar(&sii->pub,
+		"boardtype");
+	if (sii->pub.boardtype == 0)
+		sii->pub.boardtype = (w >> 16) & 0xffff;
+	else
+		SI_ERROR(("Overriding boardtype: 0x%x instead of 0x%x\n"
+			  , sii->pub.boardtype, (w >> 16) & 0xffff));
 
 	if (sii->pub.boardtype == 0)
 		SI_ERROR(("si_doattach: unknown board type\n"));
@@ -1124,8 +1052,8 @@ static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
-			      void *regs, uint bustype, void *pbus,
-			      char **vars, uint *varsz)
+				   void *regs, void *pbus,
+				   char **vars, uint *varsz)
 {
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
@@ -1143,35 +1071,18 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sii->curmap = regs;
 	sii->pbus = pbus;
 
-	/* check to see if we are a si core mimic'ing a pci core */
-	if (bustype == PCI_BUS) {
-		pci_read_config_dword(sii->pbus, PCI_SPROM_CONTROL,  &w);
-		if (w == 0xffffffff) {
-			SI_ERROR(("%s: incoming bus is PCI but it's a lie, "
-				" switching to SI devid:0x%x\n",
-				__func__, devid));
-			bustype = SI_BUS;
-		}
-	}
-
 	/* find Chipcommon address */
-	if (bustype == PCI_BUS) {
-		pci_read_config_dword(sii->pbus, PCI_BAR0_WIN, &savewin);
-		if (!GOODCOREADDR(savewin, SI_ENUM_BASE))
-			savewin = SI_ENUM_BASE;
-		pci_write_config_dword(sii->pbus, PCI_BAR0_WIN,
-				       SI_ENUM_BASE);
-		cc = (struct chipcregs *) regs;
-	} else {
-		cc = (struct chipcregs *) REG_MAP(SI_ENUM_BASE, SI_CORE_SIZE);
-	}
+	pci_read_config_dword(sii->pbus, PCI_BAR0_WIN, &savewin);
+	if (!GOODCOREADDR(savewin, SI_ENUM_BASE))
+		savewin = SI_ENUM_BASE;
 
-	sih->bustype = bustype;
+	pci_write_config_dword(sii->pbus, PCI_BAR0_WIN,
+			       SI_ENUM_BASE);
+	cc = (struct chipcregs *) regs;
 
 	/* bus/core/clk setup for register access */
-	if (!ai_buscore_prep(sii, bustype)) {
-		SI_ERROR(("si_doattach: si_core_clk_prep failed %d\n",
-			  bustype));
+	if (!ai_buscore_prep(sii)) {
+		SI_ERROR(("si_doattach: si_core_clk_prep failed\n"));
 		return NULL;
 	}
 
@@ -1207,14 +1118,13 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	}
 	/* bus/core/clk setup */
 	origidx = SI_CC_IDX;
-	if (!ai_buscore_setup(sii, cc, bustype, savewin, &origidx, regs)) {
+	if (!ai_buscore_setup(sii, cc, savewin, &origidx, regs)) {
 		SI_ERROR(("si_doattach: si_buscore_setup failed\n"));
 		goto exit;
 	}
 
 	/* Init nvram from sprom/otp if they exist */
-	if (srom_var_init
-	    (&sii->pub, bustype, regs, vars, varsz)) {
+	if (srom_var_init(&sii->pub, regs, vars, varsz)) {
 		SI_ERROR(("si_doattach: srom_var_init failed: bad srom\n"));
 		goto exit;
 	}
@@ -1283,12 +1193,11 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	}
 
 	return sii;
+
  exit:
-	if (sih->bustype == PCI_BUS) {
-		if (sii->pch)
-			pcicore_deinit(sii->pch);
-		sii->pch = NULL;
-	}
+	if (sii->pch)
+		pcicore_deinit(sii->pch);
+	sii->pch = NULL;
 
 	return NULL;
 }
@@ -1297,7 +1206,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 void ai_detach(struct si_pub *sih)
 {
 	struct si_info *sii;
-	uint idx;
 
 	struct si_pub *si_local = NULL;
 	memcpy(&si_local, &sih, sizeof(struct si_pub **));
@@ -1307,18 +1215,9 @@ void ai_detach(struct si_pub *sih)
 	if (sii == NULL)
 		return;
 
-	if (sih->bustype == SI_BUS)
-		for (idx = 0; idx < SI_MAXCORES; idx++)
-			if (sii->regs[idx]) {
-				iounmap(sii->regs[idx]);
-				sii->regs[idx] = NULL;
-			}
-
-	if (sih->bustype == PCI_BUS) {
-		if (sii->pch)
-			pcicore_deinit(sii->pch);
-		sii->pch = NULL;
-	}
+	if (sii->pch)
+		pcicore_deinit(sii->pch);
+	sii->pch = NULL;
 
 	if (sii != &ksii)
 		kfree(sii);
@@ -1483,43 +1382,29 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 	if (coreidx >= SI_MAXCORES)
 		return 0;
 
-	if (sih->bustype == SI_BUS) {
-		/* If internal bus, we can always get at everything */
+	/*
+	 * If pci/pcie, we can get at pci/pcie regs
+	 * and on newer cores to chipc
+	 */
+	if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sii)) {
+		/* Chipc registers are mapped at 12KB */
 		fast = true;
-		/* map if does not exist */
-		if (!sii->regs[coreidx])
-			sii->regs[coreidx] = REG_MAP(sii->coresba[coreidx],
-						     SI_CORE_SIZE);
-
-		r = (u32 *) ((unsigned char *) sii->regs[coreidx] + regoff);
-	} else if (sih->bustype == PCI_BUS) {
+		r = (u32 *)((char *)sii->curmap +
+			    PCI_16KB0_CCREGS_OFFSET + regoff);
+	} else if (sii->pub.buscoreidx == coreidx) {
 		/*
-		 * If pci/pcie, we can get at pci/pcie regs
-		 * and on newer cores to chipc
+		 * pci registers are at either in the last 2KB of
+		 * an 8KB window or, in pcie and pci rev 13 at 8KB
 		 */
-		if ((sii->coreid[coreidx] == CC_CORE_ID) && SI_FAST(sii)) {
-			/* Chipc registers are mapped at 12KB */
-
-			fast = true;
-			r = (u32 *) ((char *)sii->curmap +
-					PCI_16KB0_CCREGS_OFFSET + regoff);
-		} else if (sii->pub.buscoreidx == coreidx) {
-			/*
-			 * pci registers are at either in the last 2KB of
-			 * an 8KB window or, in pcie and pci rev 13 at 8KB
-			 */
-			fast = true;
-			if (SI_FAST(sii))
-				r = (u32 *) ((char *)sii->curmap +
-						PCI_16KB0_PCIREGS_OFFSET +
-						regoff);
-			else
-				r = (u32 *) ((char *)sii->curmap +
-						((regoff >= SBCONFIGOFF) ?
-						 PCI_BAR0_PCISBR_OFFSET :
-						 PCI_BAR0_PCIREGS_OFFSET) +
-						regoff);
-		}
+		fast = true;
+		if (SI_FAST(sii))
+			r = (u32 *)((char *)sii->curmap +
+				    PCI_16KB0_PCIREGS_OFFSET + regoff);
+		else
+			r = (u32 *)((char *)sii->curmap +
+				    ((regoff >= SBCONFIGOFF) ?
+				      PCI_BAR0_PCISBR_OFFSET :
+				      PCI_BAR0_PCIREGS_OFFSET) + regoff);
 	}
 
 	if (!fast) {
@@ -1615,12 +1500,10 @@ static uint ai_slowclk_src(struct si_info *sii)
 	u32 val;
 
 	if (sii->pub.ccrev < 6) {
-		if (sii->pub.bustype == PCI_BUS) {
-			pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
-					      &val);
-			if (val & PCI_CFG_GPIO_SCS)
-				return SCC_SS_PCI;
-		}
+		pci_read_config_dword(sii->pbus, PCI_GPIO_OUT,
+				      &val);
+		if (val & PCI_CFG_GPIO_SCS)
+			return SCC_SS_PCI;
 		return SCC_SS_XTAL;
 	} else if (sii->pub.ccrev < 10) {
 		cc = (struct chipcregs *) ai_setcoreidx(&sii->pub, sii->curidx);
@@ -1791,63 +1674,56 @@ int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 
 	sii = SI_INFO(sih);
 
-	switch (sih->bustype) {
-
-	case PCI_BUS:
-		/* pcie core doesn't have any mapping to control the xtal pu */
-		if (PCIE(sii))
-			return -1;
+	/* pcie core doesn't have any mapping to control the xtal pu */
+	if (PCIE(sii))
+		return -1;
 
-		pci_read_config_dword(sii->pbus, PCI_GPIO_IN, &in);
-		pci_read_config_dword(sii->pbus, PCI_GPIO_OUT, &out);
-		pci_read_config_dword(sii->pbus, PCI_GPIO_OUTEN, &outen);
+	pci_read_config_dword(sii->pbus, PCI_GPIO_IN, &in);
+	pci_read_config_dword(sii->pbus, PCI_GPIO_OUT, &out);
+	pci_read_config_dword(sii->pbus, PCI_GPIO_OUTEN, &outen);
 
-		/*
-		 * Avoid glitching the clock if GPRS is already using it.
-		 * We can't actually read the state of the PLLPD so we infer it
-		 * by the value of XTAL_PU which *is* readable via gpioin.
-		 */
-		if (on && (in & PCI_CFG_GPIO_XTAL))
-			return 0;
+	/*
+	 * Avoid glitching the clock if GPRS is already using it.
+	 * We can't actually read the state of the PLLPD so we infer it
+	 * by the value of XTAL_PU which *is* readable via gpioin.
+	 */
+	if (on && (in & PCI_CFG_GPIO_XTAL))
+		return 0;
 
-		if (what & XTAL)
-			outen |= PCI_CFG_GPIO_XTAL;
-		if (what & PLL)
-			outen |= PCI_CFG_GPIO_PLL;
-
-		if (on) {
-			/* turn primary xtal on */
-			if (what & XTAL) {
-				out |= PCI_CFG_GPIO_XTAL;
-				if (what & PLL)
-					out |= PCI_CFG_GPIO_PLL;
-				pci_write_config_dword(sii->pbus,
-						       PCI_GPIO_OUT, out);
-				pci_write_config_dword(sii->pbus,
-						       PCI_GPIO_OUTEN, outen);
-				udelay(XTAL_ON_DELAY);
-			}
+	if (what & XTAL)
+		outen |= PCI_CFG_GPIO_XTAL;
+	if (what & PLL)
+		outen |= PCI_CFG_GPIO_PLL;
 
-			/* turn pll on */
-			if (what & PLL) {
-				out &= ~PCI_CFG_GPIO_PLL;
-				pci_write_config_dword(sii->pbus,
-						       PCI_GPIO_OUT, out);
-				mdelay(2);
-			}
-		} else {
-			if (what & XTAL)
-				out &= ~PCI_CFG_GPIO_XTAL;
+	if (on) {
+		/* turn primary xtal on */
+		if (what & XTAL) {
+			out |= PCI_CFG_GPIO_XTAL;
 			if (what & PLL)
 				out |= PCI_CFG_GPIO_PLL;
 			pci_write_config_dword(sii->pbus,
 					       PCI_GPIO_OUT, out);
 			pci_write_config_dword(sii->pbus,
 					       PCI_GPIO_OUTEN, outen);
+			udelay(XTAL_ON_DELAY);
 		}
 
-	default:
-		return -1;
+		/* turn pll on */
+		if (what & PLL) {
+			out &= ~PCI_CFG_GPIO_PLL;
+			pci_write_config_dword(sii->pbus,
+					       PCI_GPIO_OUT, out);
+			mdelay(2);
+		}
+	} else {
+		if (what & XTAL)
+			out &= ~PCI_CFG_GPIO_XTAL;
+		if (what & PLL)
+			out |= PCI_CFG_GPIO_PLL;
+		pci_write_config_dword(sii->pbus,
+				       PCI_GPIO_OUT, out);
+		pci_write_config_dword(sii->pbus,
+				       PCI_GPIO_OUTEN, outen);
 	}
 
 	return 0;
@@ -1893,12 +1769,6 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	if (!fast) {
 		INTR_OFF(sii, intr_val);
 		origidx = sii->curidx;
-
-		if ((sii->pub.bustype == SI_BUS) &&
-		    ai_setcore(&sii->pub, MIPS33_CORE_ID, 0) &&
-		    (ai_corerev(&sii->pub) <= 7) && (sii->pub.ccrev >= 10))
-			goto done;
-
 		cc = (struct chipcregs *) ai_setcore(&sii->pub, CC_CORE_ID, 0);
 	} else {
 		cc = (struct chipcregs *) CCREGS_FAST(sii);
@@ -1969,7 +1839,7 @@ static bool _ai_clkctl_cc(struct si_info *sii, uint mode)
 	return mode == CLK_FAST;
 }
 
-/* Build device path. Support SI, PCI, and JTAG for now. */
+/* Build device path */
 int ai_devpath(struct si_pub *sih, char *path, int size)
 {
 	int slen;
@@ -1977,22 +1847,9 @@ int ai_devpath(struct si_pub *sih, char *path, int size)
 	if (!path || size <= 0)
 		return -1;
 
-	switch (sih->bustype) {
-	case SI_BUS:
-	case JTAG_BUS:
-		slen = snprintf(path, (size_t) size, "sb/%u/", ai_coreidx(sih));
-		break;
-	case PCI_BUS:
-		slen = snprintf(path, (size_t) size, "pci/%u/%u/",
-			((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
-			PCI_SLOT(
-			    ((struct pci_dev *)((SI_INFO(sih))->pbus))->devfn));
-		break;
-
-	default:
-		slen = -1;
-		break;
-	}
+	slen = snprintf(path, (size_t) size, "pci/%u/%u/",
+		((struct pci_dev *)((SI_INFO(sih))->pbus))->bus->number,
+		PCI_SLOT(((struct pci_dev *)((SI_INFO(sih))->pbus))->devfn));
 
 	if (slen < 0 || slen >= size) {
 		path[0] = '\0';
@@ -2015,15 +1872,11 @@ char *ai_getdevpathvar(struct si_pub *sih, const char *name)
 /* Get a variable, but only if it has a devpath prefix */
 int ai_getdevpathintvar(struct si_pub *sih, const char *name)
 {
-#if defined(BCMBUSTYPE) && (BCMBUSTYPE == SI_BUS)
-	return getintvar(NULL, name);
-#else
 	char varname[SI_DEVPATH_BUFSZ + 32];
 
 	ai_devpathvar(sih, varname, sizeof(varname), name);
 
 	return getintvar(NULL, varname);
-#endif
 }
 
 char *ai_getnvramflvar(struct si_pub *sih, const char *name)
@@ -2061,9 +1914,6 @@ static bool ai_ispcie(struct si_info *sii)
 {
 	u8 cap_ptr;
 
-	if (sii->pub.bustype != PCI_BUS)
-		return false;
-
 	cap_ptr =
 	    pcicore_find_pci_capability(sii->pbus, PCI_CAP_ID_EXP, NULL,
 					NULL);
@@ -2088,10 +1938,6 @@ void ai_pci_up(struct si_pub *sih)
 
 	sii = SI_INFO(sih);
 
-	/* if not pci bus, we're done */
-	if (sih->bustype != PCI_BUS)
-		return;
-
 	if (PCI_FORCEHT(sii))
 		_ai_clkctl_cc(sii, CLK_FAST);
 
@@ -2117,10 +1963,6 @@ void ai_pci_down(struct si_pub *sih)
 
 	sii = SI_INFO(sih);
 
-	/* if not pci bus, we're done */
-	if (sih->bustype != PCI_BUS)
-		return;
-
 	/* release FORCEHT since chip is going to "down" state */
 	if (PCI_FORCEHT(sii))
 		_ai_clkctl_cc(sii, CLK_DYNAMIC);
@@ -2141,9 +1983,6 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 
 	sii = SI_INFO(sih);
 
-	if (sii->pub.bustype != PCI_BUS)
-		return;
-
 	if (PCI(sii)) {
 		/* get current core index */
 		idx = sii->curidx;
@@ -2208,18 +2047,6 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 {
 	uint regoff;
 
-	regoff = 0;
-
-	/* gpios could be shared on router platforms
-	 * ignore reservation if it's high priority (e.g., test apps)
-	 */
-	if ((priority != GPIO_HI_PRIORITY) &&
-	    (sih->bustype == SI_BUS) && (val || mask)) {
-		mask = priority ? (ai_gpioreservation & mask) :
-		    ((ai_gpioreservation | mask) & ~(ai_gpioreservation));
-		val &= mask;
-	}
-
 	regoff = offsetof(struct chipcregs, gpiocontrol);
 	return ai_corereg(sih, SI_CC_IDX, regoff, mask, val);
 }
@@ -2283,13 +2110,10 @@ bool ai_deviceremoved(struct si_pub *sih)
 
 	sii = SI_INFO(sih);
 
-	switch (sih->bustype) {
-	case PCI_BUS:
-		pci_read_config_dword(sii->pbus, PCI_VENDOR_ID, &w);
-		if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
-			return true;
-		break;
-	}
+	pci_read_config_dword(sii->pbus, PCI_VENDOR_ID, &w);
+	if ((w & 0xFFFF) != PCI_VENDOR_ID_BROADCOM)
+		return true;
+
 	return false;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index 4c682a5..076b4c8 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -330,10 +330,8 @@
 #define	ILP_DIV_5MHZ		0	/* ILP = 5 MHz */
 #define	ILP_DIV_1MHZ		4	/* ILP = 1 MHz */
 
-#define PCI(si)		(((si)->pub.bustype == PCI_BUS) &&	\
-			 ((si)->pub.buscoretype == PCI_CORE_ID))
-#define PCIE(si)	(((si)->pub.bustype == PCI_BUS) &&	\
-			 ((si)->pub.buscoretype == PCIE_CORE_ID))
+#define PCI(si)		((si)->pub.buscoretype == PCI_CORE_ID)
+#define PCIE(si)	((si)->pub.buscoretype == PCIE_CORE_ID)
 #define PCI_FORCEHT(si)	\
 	(PCIE(si) && (si->pub.chip == BCM4716_CHIP_ID))
 
@@ -351,7 +349,6 @@
  *   public (read-only) portion of aiutils handle returned by si_attach()
  */
 struct si_pub {
-	uint bustype;		/* SI_BUS, PCI_BUS */
 	uint buscoretype;	/* PCI_CORE_ID, PCIE_CORE_ID, PCMCIA_CORE_ID */
 	uint buscorerev;	/* buscore rev */
 	uint buscoreidx;	/* buscore index */
@@ -518,9 +515,8 @@ extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
 extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern struct si_pub *ai_attach(void *regs, uint bustype,
-		       void *sdh, char **vars, uint *varsz);
-
+extern struct si_pub *ai_attach(void *regs, void *sdh, char **vars,
+				uint *varsz);
 extern void ai_detach(struct si_pub *sih);
 extern bool ai_pci_war16165(struct si_pub *sih);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 48a053c..64d7639 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -451,14 +451,11 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	 */
 	di->ddoffsetlow = 0;
 	di->dataoffsetlow = 0;
-	/* for pci bus, add offset */
-	if (sih->bustype == PCI_BUS) {
-		/* pcie with DMA64 */
-		di->ddoffsetlow = 0;
-		di->ddoffsethigh = SI_PCIE_DMA_H32;
-		di->dataoffsetlow = di->ddoffsetlow;
-		di->dataoffsethigh = di->ddoffsethigh;
-	}
+	/* add offset for pcie with DMA64 bus */
+	di->ddoffsetlow = 0;
+	di->ddoffsethigh = SI_PCIE_DMA_H32;
+	di->dataoffsetlow = di->ddoffsetlow;
+	di->dataoffsethigh = di->ddoffsethigh;
 #if defined(__mips__) && defined(IL_BIGENDIAN)
 	di->dataoffsetlow = di->dataoffsetlow + SI_SDRAM_SWAPPED;
 #endif				/* defined(__mips__) && defined(IL_BIGENDIAN) */
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index c66b67f..6bcb7ea 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -755,7 +755,7 @@ static int brcms_set_hint(struct brcms_info *wl, char *abbrev)
  */
 static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 				       unsigned long regs,
-			    uint bustype, void *btparam, uint irq)
+				       void *btparam, uint irq)
 {
 	struct brcms_info *wl = NULL;
 	int unit, err;
@@ -786,14 +786,6 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 
 	base_addr = regs;
 
-	if (bustype == PCI_BUS || bustype == RPC_BUS) {
-		/* Do nothing */
-	} else {
-		bustype = PCI_BUS;
-		BCMMSG(wl->wiphy, "force to PCI\n");
-	}
-	wl->bcm_bustype = bustype;
-
 	wl->regsva = ioremap_nocache(base_addr, PCI_BAR0_WINSZ);
 	if (wl->regsva == NULL) {
 		wiphy_err(wl->wiphy, "wl%d: ioremap() failed\n", unit);
@@ -813,7 +805,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 
 	/* common load-time initialization */
 	wl->wlc = brcms_c_attach((void *)wl, vendor, device, unit, false,
-			     wl->regsva, wl->bcm_bustype, btparam, &err);
+				 wl->regsva, btparam, &err);
 	brcms_release_fw(wl);
 	if (!wl->wlc) {
 		wiphy_err(wl->wiphy, "%s: attach() failed with code %d\n",
@@ -1156,7 +1148,7 @@ brcms_pci_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	memset(hw->priv, 0, sizeof(*wl));
 
 	wl = brcms_attach(pdev->vendor, pdev->device,
-			  pci_resource_start(pdev, 0), PCI_BUS, pdev,
+			  pci_resource_start(pdev, 0), pdev,
 			  pdev->irq);
 
 	if (!wl) {
@@ -1373,8 +1365,7 @@ static void brcms_free(struct brcms_info *wl)
 	 * registers so we cannot unmap the chip registers until
 	 * after calling unregister_netdev() .
 	 */
-	if (wl->regsva && wl->bcm_bustype != SDIO_BUS &&
-	    wl->bcm_bustype != JTAG_BUS)
+	if (wl->regsva)
 		iounmap((void *)wl->regsva);
 
 	wl->regsva = NULL;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
index 01fce54..c574723 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.h
@@ -60,8 +60,7 @@ struct brcms_info {
 	spinlock_t lock;	/* per-device perimeter lock */
 	spinlock_t isr_lock;	/* per-device ISR synchronization lock */
 
-	/* bus type and regsva for unmap in brcms_free() */
-	uint bcm_bustype;	/* bus type */
+	/* regsva for unmap in brcms_free() */
 	void *regsva;		/* opaque chip registers virtual address */
 
 	/* timer related fields */
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 2a139aa..fb9f13f 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -181,8 +181,7 @@
  */
 #define BCMCFID(wlc, fid) brcms_b_write_shm((wlc)->hw, M_BCMC_FID, (fid))
 
-#define BRCMS_WAR16165(wlc) (wlc->pub->sih->bustype == PCI_BUS && \
-				(!AP_ENAB(wlc->pub)) && (wlc->war16165))
+#define BRCMS_WAR16165(wlc) ((!AP_ENAB(wlc->pub)) && (wlc->war16165))
 
 /* Find basic rate for a given rate */
 #define BRCMS_BASIC_RATE(wlc, rspec) \
@@ -313,8 +312,8 @@ static void brcms_b_tx_fifo_resume(struct brcms_hardware *wlc_hw,
 struct brcms_b_state;
 
 static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
-			   uint unit, bool piomode, void *regsva, uint bustype,
-			   void *btparam);
+			  uint unit, bool piomode, void *regsva,
+			  void *btparam);
 
 /* up/down, reset, clk */
 static void brcms_b_reset(struct brcms_hardware *wlc_hw);
@@ -4302,7 +4301,7 @@ struct brcms_pub *brcms_c_pub(void *wlc)
  *    put the whole chip in reset(driver down state), no clock
  */
 int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
-		    bool piomode, void *regsva, uint bustype, void *btparam)
+		   bool piomode, void *regsva, void *btparam)
 {
 	struct brcms_hardware *wlc_hw;
 	struct d11regs *regs;
@@ -4313,6 +4312,8 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	bool wme = false;
 	struct shared_phy_params sha_params;
 	struct wiphy *wiphy = wlc->wiphy;
+	char *var;
+	unsigned long res;
 
 	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
 		device);
@@ -4332,7 +4333,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	 * Do the hardware portion of the attach. Also initialize software
 	 * state that depends on the particular hardware we are running.
 	 */
-	wlc_hw->sih = ai_attach(regsva, bustype, btparam,
+	wlc_hw->sih = ai_attach(regsva, btparam,
 				&wlc_hw->vars, &wlc_hw->vars_size);
 	if (wlc_hw->sih == NULL) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: si_attach failed\n",
@@ -4347,37 +4348,29 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	 * than those the BIOS recognizes for devices on PCMCIA_BUS,
 	 * SDIO_BUS, and SROMless devices on PCI_BUS.
 	 */
-#ifdef BCMBUSTYPE
-	bustype = BCMBUSTYPE;
-#endif
-	if (bustype != SI_BUS) {
-		char *var;
-		unsigned long res;
-
-		var = getvar(vars, "vendid");
-		if (var && !kstrtoul(var, 0, &res)) {
-			vendor = (u16)res;
-			wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
-				  vendor);
-		}
-		var = getvar(vars, "devid");
-		if (var && !kstrtoul(var, 0, &res)) {
-			u16 devid = (u16)res;
-			if (devid != 0xffff) {
-				device = devid;
-				wiphy_err(wiphy, "Overriding device id = 0x%x"
-					  "\n", device);
-			}
+	var = getvar(vars, "vendid");
+	if (var && !kstrtoul(var, 0, &res)) {
+		vendor = (u16)res;
+		wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
+			  vendor);
+	}
+	var = getvar(vars, "devid");
+	if (var && !kstrtoul(var, 0, &res)) {
+		u16 devid = (u16)res;
+		if (devid != 0xffff) {
+			device = devid;
+			wiphy_err(wiphy, "Overriding device id = 0x%x"
+				  "\n", device);
 		}
+	}
 
-		/* verify again the device is supported */
-		if (!brcms_c_chipmatch(vendor, device)) {
-			wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
-				"vendor/device (0x%x/0x%x)\n",
-				 unit, vendor, device);
-			err = 12;
-			goto fail;
-		}
+	/* verify again the device is supported */
+	if (!brcms_c_chipmatch(vendor, device)) {
+		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
+			"vendor/device (0x%x/0x%x)\n",
+			 unit, vendor, device);
+		err = 12;
+		goto fail;
 	}
 
 	wlc_hw->vendorid = vendor;
@@ -4437,8 +4430,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	if (wlc_hw->boardflags & BFL_NOPLLDOWN)
 		brcms_b_pllreq(wlc_hw, true, BRCMS_PLLREQ_SHARED);
 
-	if ((wlc_hw->sih->bustype == PCI_BUS)
-	    && (ai_pci_war16165(wlc_hw->sih)))
+	if (ai_pci_war16165(wlc_hw->sih))
 		wlc->war16165 = true;
 
 	/* check device id(srom, nvram etc.) to set bands */
@@ -4491,7 +4483,6 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	sha_params.boardvendor = wlc_hw->sih->boardvendor;
 	sha_params.boardflags = wlc_hw->boardflags;
 	sha_params.boardflags2 = wlc_hw->boardflags2;
-	sha_params.bustype = wlc_hw->sih->bustype;
 	sha_params.buscorerev = wlc_hw->sih->buscorerev;
 
 	/* alloc and save pointer to shared phy state area */
@@ -4601,8 +4592,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	brcms_c_coredisable(wlc_hw);
 
 	/* Match driver "down" state */
-	if (wlc_hw->sih->bustype == PCI_BUS)
-		ai_pci_down(wlc_hw->sih);
+	ai_pci_down(wlc_hw->sih);
 
 	/* register sb interrupt callback functions */
 	ai_register_intr_callback(wlc_hw->sih, (void *)brcms_c_wlintrsoff,
@@ -4655,8 +4645,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
  * The common driver entry routine. Error codes should be unique
  */
 void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
-		 bool piomode, void *regsva, uint bustype, void *btparam,
-		 uint *perr)
+		 bool piomode, void *regsva, void *btparam, uint *perr)
 {
 	struct brcms_c_info *wlc;
 	uint err = 0;
@@ -4696,7 +4685,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	 * inside, no more in rest of the attach)
 	 */
 	err = brcms_b_attach(wlc, vendor, device, unit, piomode, regsva,
-			      bustype, btparam);
+			     btparam);
 	if (err)
 		goto fail;
 
@@ -5030,9 +5019,7 @@ int brcms_b_detach(struct brcms_c_info *wlc)
 		 * be done before sb core switch
 		 */
 		ai_deregister_intr_callback(wlc_hw->sih);
-
-		if (wlc_hw->sih->bustype == PCI_BUS)
-			ai_pci_sleep(wlc_hw->sih);
+		ai_pci_sleep(wlc_hw->sih);
 	}
 
 	brcms_b_detach_dmapio(wlc_hw);
@@ -5416,18 +5403,16 @@ void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	ai_clkctl_init(wlc_hw->sih);
 	brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
 
-	if (wlc_hw->sih->bustype == PCI_BUS) {
-		ai_pci_fixcfg(wlc_hw->sih);
+	ai_pci_fixcfg(wlc_hw->sih);
 
-		/*
-		 * AI chip doesn't restore bar0win2 on
-		 * hibernation/resume, need sw fixup
-		 */
-		if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
-		    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
-			wlc_hw->regs = (struct d11regs *)
-					ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
-	}
+	/*
+	 * AI chip doesn't restore bar0win2 on
+	 * hibernation/resume, need sw fixup
+	 */
+	if ((wlc_hw->sih->chip == BCM43224_CHIP_ID) ||
+	    (wlc_hw->sih->chip == BCM43225_CHIP_ID))
+		wlc_hw->regs = (struct d11regs *)
+				ai_setcore(wlc_hw->sih, D11_CORE_ID, 0);
 
 	/*
 	 * Inform phy that a POR reset has occurred so
@@ -5467,8 +5452,7 @@ int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 */
 	coremask = (1 << wlc_hw->wlc->core->coreidx);
 
-	if (wlc_hw->sih->bustype == PCI_BUS)
-		ai_pci_setup(wlc_hw->sih, coremask);
+	ai_pci_setup(wlc_hw->sih, coremask);
 
 	/*
 	 * Need to read the hwradio status here to cover the case where the
@@ -5477,14 +5461,12 @@ int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 */
 	if (brcms_b_radio_read_hwdisabled(wlc_hw)) {
 		/* put SB PCI in down state again */
-		if (wlc_hw->sih->bustype == PCI_BUS)
-			ai_pci_down(wlc_hw->sih);
+		ai_pci_down(wlc_hw->sih);
 		brcms_b_xtal(wlc_hw, OFF);
 		return -ENOMEDIUM;
 	}
 
-	if (wlc_hw->sih->bustype == PCI_BUS)
-		ai_pci_up(wlc_hw->sih);
+	ai_pci_up(wlc_hw->sih);
 
 	/* reset the d11 core */
 	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
@@ -5707,8 +5689,7 @@ int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 
 		/* turn off primary xtal and pll */
 		if (!wlc_hw->noreset) {
-			if (wlc_hw->sih->bustype == PCI_BUS)
-				ai_pci_down(wlc_hw->sih);
+			ai_pci_down(wlc_hw->sih);
 			brcms_b_xtal(wlc_hw, OFF);
 		}
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index ab67546..8249ea9 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -213,9 +213,7 @@ struct pcicore_info {
 
 /* debug/trace */
 #define	PCI_ERROR(args)
-#define PCIE_PUB(sih)							\
-	(((sih)->bustype == PCI_BUS) &&					\
-	 ((sih)->buscoretype == PCIE_CORE_ID))
+#define PCIE_PUB(sih) ((sih)->buscoretype == PCIE_CORE_ID)
 
 /* routines to access mdio slave device registers */
 static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 831c2fe..c00178d 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -279,11 +279,9 @@ void write_radio_reg(struct brcms_phy *pi, u16 addr, u16 val)
 		W_REG(&pi->regs->phy4wdatalo, val);
 	}
 
-	if (pi->sh->bustype == PCI_BUS) {
-		if (++pi->phy_wreg >= pi->phy_wreg_limit) {
-			(void)R_REG(&pi->regs->maccontrol);
-			pi->phy_wreg = 0;
-		}
+	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
+		(void)R_REG(&pi->regs->maccontrol);
+		pi->phy_wreg = 0;
 	}
 }
 
@@ -390,11 +388,9 @@ void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val)
 #else
 	W_REG((u32 *)(&regs->phyregaddr),
 	      addr | (val << 16));
-	if (pi->sh->bustype == PCI_BUS) {
-		if (++pi->phy_wreg >= pi->phy_wreg_limit) {
-			pi->phy_wreg = 0;
-			(void)R_REG(&regs->phyversion);
-		}
+	if (++pi->phy_wreg >= pi->phy_wreg_limit) {
+		pi->phy_wreg = 0;
+		(void)R_REG(&regs->phyversion);
 	}
 #endif
 }
@@ -496,7 +492,6 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 	sh->boardvendor = shp->boardvendor;
 	sh->boardflags = shp->boardflags;
 	sh->boardflags2 = shp->boardflags2;
-	sh->bustype = shp->bustype;
 	sh->buscorerev = shp->buscorerev;
 
 	sh->fast_timer = PHY_SW_TIMER_FAST;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
index 42e0cf0..1dbfaa3 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_hal.h
@@ -166,7 +166,6 @@ struct shared_phy_params {
 	struct phy_shim_info *physhim;
 	uint unit;
 	uint corerev;
-	uint bustype;
 	uint buscorerev;
 	char *vars;
 	u16 vid;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index bcc6d83..b98d76b 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -565,7 +565,6 @@ struct shared_phy {
 	uint boardvendor;
 	u32 boardflags;
 	u32 boardflags2;
-	uint bustype;
 	uint buscorerev;
 	uint fast_timer;
 	uint slow_timer;
@@ -1182,7 +1181,7 @@ extern void wlc_phy_table_write_nphy(struct brcms_phy *pi, u32, u32, u32,
 	 (pi->ipa5g_on && CHSPEC_IS5G(pi->radio_chanspec)))
 
 #define BRCMS_PHY_WAR_PR51571(pi) \
-	if (((pi)->sh->bustype == PCI_BUS) && NREV_LT((pi)->pubpi.phy_rev, 3)) \
+	if (NREV_LT((pi)->pubpi.phy_rev, 3)) \
 		(void)R_REG(&(pi)->regs->maccontrol)
 
 extern void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype);
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 8da7250..5e15c67 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -550,7 +550,7 @@ struct brcms_antselcfg {
 
 /* common functions for every port */
 extern void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device,
-			uint unit, bool piomode, void *regsva, uint bustype,
+			uint unit, bool piomode, void *regsva,
 			void *btparam, uint *perr);
 extern uint brcms_c_detach(struct brcms_c_info *wlc);
 extern int brcms_c_up(struct brcms_c_info *wlc);
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index 40a3156..060f06f 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -860,8 +860,7 @@ static int varbuf_append(struct brcms_varbuf *b, const char *fmt, ...)
  * Initialize local vars from the right source for this platform.
  * Return 0 on success, nonzero on error.
  */
-int srom_var_init(struct si_pub *sih, uint bustype, void *curmap,
-		  char **vars, uint *count)
+int srom_var_init(struct si_pub *sih, void *curmap, char **vars, uint *count)
 {
 	uint len;
 
@@ -873,7 +872,7 @@ int srom_var_init(struct si_pub *sih, uint bustype, void *curmap,
 	*vars = NULL;
 	*count = 0;
 
-	if (curmap != NULL && bustype == PCI_BUS)
+	if (curmap != NULL)
 		return initvars_srom_pci(sih, curmap, vars, count);
 
 	return -EINVAL;
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.h b/drivers/staging/brcm80211/brcmsmac/srom.h
index efc4d1e..dd51156 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.h
+++ b/drivers/staging/brcm80211/brcmsmac/srom.h
@@ -20,8 +20,8 @@
 #include "types.h"
 
 /* Prototypes */
-extern int srom_var_init(struct si_pub *sih, uint bus, void *curmap,
-			 char **vars, uint *count);
+extern int srom_var_init(struct si_pub *sih, void *curmap, char **vars,
+			 uint *count);
 
 extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
 		     uint byteoff, uint nbytes, u16 *buf, bool check_crc);
diff --git a/drivers/staging/brcm80211/brcmsmac/types.h b/drivers/staging/brcm80211/brcmsmac/types.h
index 16a1c6a..c0d41cc 100644
--- a/drivers/staging/brcm80211/brcmsmac/types.h
+++ b/drivers/staging/brcm80211/brcmsmac/types.h
@@ -20,14 +20,13 @@
 #include <linux/types.h>
 #include <linux/io.h>
 
+#if 0
 /* Bus types */
-#define	SI_BUS			0	/* SOC Interconnect */
-#define	PCI_BUS			1	/* PCI target */
 #define SDIO_BUS		3	/* SDIO target */
-#define JTAG_BUS		4	/* JTAG */
 #define USB_BUS			5	/* USB (does not support R/W REG) */
 #define SPI_BUS			6	/* gSPI target */
 #define RPC_BUS			7	/* RPC target */
+#endif
 
 #define WL_CHAN_FREQ_RANGE_2G      0
 #define WL_CHAN_FREQ_RANGE_5GL     1
-- 
1.7.4.1


