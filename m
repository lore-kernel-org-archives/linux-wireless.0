Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4880 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161393Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 44/83] staging: brcm80211: replaced typedef si_t with
 struct si_pub
Date: Wed, 1 Jun 2011 13:45:29 +0200
Message-ID: <1306928768-7501-44-git-send-email-rvossen@broadcom.com> (sfid-20110601_134657_467116_F94FA6A2)
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
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    3 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |  117 +++++++++--------
 drivers/staging/brcm80211/brcmsmac/aiutils.h       |  133 +++++++++----------
 drivers/staging/brcm80211/brcmsmac/bcmdma.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/bcmotp.c        |   16 ++--
 drivers/staging/brcm80211/brcmsmac/bcmotp.h        |    5 +-
 drivers/staging/brcm80211/brcmsmac/bcmsrom.c       |   34 +++---
 drivers/staging/brcm80211/brcmsmac/dma.c           |    4 +-
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |   12 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h   |    2 +-
 .../staging/brcm80211/brcmsmac/phy/wlc_phy_int.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_main.h      |    2 +-
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c       |   75 ++++++------
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.h       |   36 +++---
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h       |    2 +-
 drivers/staging/brcm80211/include/bcmsrom.h        |    4 +-
 16 files changed, 228 insertions(+), 223 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index 2cc9bc7..9819a35 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -27,7 +27,8 @@
 #include <dngl_stats.h>
 #include <dhd.h>
 #include <linux/ieee80211.h>
-typedef const struct si_pub si_t;
+
+struct si_pub;
 
 #include <dngl_stats.h>
 #include <dhd.h>
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 43320b4..e065895 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -167,7 +167,7 @@
 /* EROM parsing */
 
 static u32
-get_erom_ent(si_t *sih, u32 **eromptr, u32 mask, u32 match)
+get_erom_ent(struct si_pub *sih, u32 **eromptr, u32 mask, u32 match)
 {
 	u32 ent;
 	uint inv = 0, nom = 0;
@@ -202,7 +202,7 @@ get_erom_ent(si_t *sih, u32 **eromptr, u32 mask, u32 match)
 }
 
 static u32
-get_asd(si_t *sih, u32 **eromptr, uint sp, uint ad, uint st,
+get_asd(struct si_pub *sih, u32 **eromptr, uint sp, uint ad, uint st,
 	u32 *addrl, u32 *addrh, u32 *sizel, u32 *sizeh)
 {
 	u32 asd, sz, szd;
@@ -241,7 +241,7 @@ static void ai_hwfixup(si_info_t *sii)
 }
 
 /* parse the enumeration rom to identify all cores */
-void ai_scan(si_t *sih, void *regs, uint devid)
+void ai_scan(struct si_pub *sih, void *regs, uint devid)
 {
 	si_info_t *sii = SI_INFO(sih);
 	chipcregs_t *cc = (chipcregs_t *) regs;
@@ -444,7 +444,7 @@ void ai_scan(si_t *sih, void *regs, uint devid)
 /* This function changes the logical "focus" to the indicated core.
  * Return the current core's virtual address.
  */
-void *ai_setcoreidx(si_t *sih, uint coreidx)
+void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 {
 	si_info_t *sii = SI_INFO(sih);
 	u32 addr = sii->coresba[coreidx];
@@ -493,13 +493,13 @@ void *ai_setcoreidx(si_t *sih, uint coreidx)
 }
 
 /* Return the number of address spaces in current core */
-int ai_numaddrspaces(si_t *sih)
+int ai_numaddrspaces(struct si_pub *sih)
 {
 	return 2;
 }
 
 /* Return the address of the nth address space in the current core */
-u32 ai_addrspace(si_t *sih, uint asidx)
+u32 ai_addrspace(struct si_pub *sih, uint asidx)
 {
 	si_info_t *sii;
 	uint cidx;
@@ -518,7 +518,7 @@ u32 ai_addrspace(si_t *sih, uint asidx)
 }
 
 /* Return the size of the nth address space in the current core */
-u32 ai_addrspacesize(si_t *sih, uint asidx)
+u32 ai_addrspacesize(struct si_pub *sih, uint asidx)
 {
 	si_info_t *sii;
 	uint cidx;
@@ -536,7 +536,7 @@ u32 ai_addrspacesize(si_t *sih, uint asidx)
 	}
 }
 
-uint ai_flag(si_t *sih)
+uint ai_flag(struct si_pub *sih)
 {
 	si_info_t *sii;
 	aidmp_t *ai;
@@ -551,11 +551,11 @@ uint ai_flag(si_t *sih)
 	return R_REG(&ai->oobselouta30) & 0x1f;
 }
 
-void ai_setint(si_t *sih, int siflag)
+void ai_setint(struct si_pub *sih, int siflag)
 {
 }
 
-uint ai_corevendor(si_t *sih)
+uint ai_corevendor(struct si_pub *sih)
 {
 	si_info_t *sii;
 	u32 cia;
@@ -565,7 +565,7 @@ uint ai_corevendor(si_t *sih)
 	return (cia & CIA_MFG_MASK) >> CIA_MFG_SHIFT;
 }
 
-uint ai_corerev(si_t *sih)
+uint ai_corerev(struct si_pub *sih)
 {
 	si_info_t *sii;
 	u32 cib;
@@ -575,7 +575,7 @@ uint ai_corerev(si_t *sih)
 	return (cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
 }
 
-bool ai_iscoreup(si_t *sih)
+bool ai_iscoreup(struct si_pub *sih)
 {
 	si_info_t *sii;
 	aidmp_t *ai;
@@ -588,7 +588,7 @@ bool ai_iscoreup(si_t *sih)
 		&& ((R_REG(&ai->resetctrl) & AIRC_RESET) == 0));
 }
 
-void ai_core_cflags_wo(si_t *sih, u32 mask, u32 val)
+void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val)
 {
 	si_info_t *sii;
 	aidmp_t *ai;
@@ -610,7 +610,7 @@ void ai_core_cflags_wo(si_t *sih, u32 mask, u32 val)
 	}
 }
 
-u32 ai_core_cflags(si_t *sih, u32 mask, u32 val)
+u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
 {
 	si_info_t *sii;
 	aidmp_t *ai;
@@ -633,7 +633,7 @@ u32 ai_core_cflags(si_t *sih, u32 mask, u32 val)
 	return R_REG(&ai->ioctrl);
 }
 
-u32 ai_core_sflags(si_t *sih, u32 mask, u32 val)
+u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val)
 {
 	si_info_t *sii;
 	aidmp_t *ai;
@@ -667,7 +667,8 @@ static bool ai_buscore_setup(si_info_t *sii, chipcregs_t *cc, uint bustype,
 static void ai_nvram_process(si_info_t *sii, char *pvars);
 
 /* dev path concatenation util */
-static char *ai_devpathvar(si_t *sih, char *var, int len, const char *name);
+static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
+			   const char *name);
 static bool _ai_clkctl_cc(si_info_t *sii, uint mode);
 static bool ai_ispcie(si_info_t *sii);
 
@@ -683,7 +684,7 @@ static u32 ai_gpioreservation;
  * vars - pointer to a pointer area for "environment" variables
  * varsz - pointer to int to return the size of the vars
  */
-si_t *ai_attach(uint devid, void *regs, uint bustype,
+struct si_pub *ai_attach(uint devid, void *regs, uint bustype,
 		void *sdh, char **vars, uint *varsz)
 {
 	si_info_t *sii;
@@ -703,7 +704,7 @@ si_t *ai_attach(uint devid, void *regs, uint bustype,
 	sii->vars = vars ? *vars : NULL;
 	sii->varsz = varsz ? *varsz : 0;
 
-	return (si_t *) sii;
+	return (struct si_pub *) sii;
 }
 
 /* global kernel resource */
@@ -1075,13 +1076,13 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 }
 
 /* may be called with core in reset */
-void ai_detach(si_t *sih)
+void ai_detach(struct si_pub *sih)
 {
 	si_info_t *sii;
 	uint idx;
 
 	struct si_pub *si_local = NULL;
-	bcopy(&sih, &si_local, sizeof(si_t **));
+	bcopy(&sih, &si_local, sizeof(struct si_pub **));
 
 	sii = SI_INFO(sih);
 
@@ -1109,7 +1110,8 @@ void ai_detach(si_t *sih)
 
 /* register driver interrupt disabling and restoring callback functions */
 void
-ai_register_intr_callback(si_t *sih, void *intrsoff_fn, void *intrsrestore_fn,
+ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
+			  void *intrsrestore_fn,
 			  void *intrsenabled_fn, void *intr_arg)
 {
 	si_info_t *sii;
@@ -1125,7 +1127,7 @@ ai_register_intr_callback(si_t *sih, void *intrsoff_fn, void *intrsrestore_fn,
 	sii->dev_coreid = sii->coreid[sii->curidx];
 }
 
-void ai_deregister_intr_callback(si_t *sih)
+void ai_deregister_intr_callback(struct si_pub *sih)
 {
 	si_info_t *sii;
 
@@ -1133,7 +1135,7 @@ void ai_deregister_intr_callback(si_t *sih)
 	sii->intrsoff_fn = NULL;
 }
 
-uint ai_coreid(si_t *sih)
+uint ai_coreid(struct si_pub *sih)
 {
 	si_info_t *sii;
 
@@ -1141,7 +1143,7 @@ uint ai_coreid(si_t *sih)
 	return sii->coreid[sii->curidx];
 }
 
-uint ai_coreidx(si_t *sih)
+uint ai_coreidx(struct si_pub *sih)
 {
 	si_info_t *sii;
 
@@ -1149,13 +1151,13 @@ uint ai_coreidx(si_t *sih)
 	return sii->curidx;
 }
 
-bool ai_backplane64(si_t *sih)
+bool ai_backplane64(struct si_pub *sih)
 {
 	return (sih->cccaps & CC_CAP_BKPLN64) != 0;
 }
 
 /* return index of coreid or BADIDX if not found */
-uint ai_findcoreidx(si_t *sih, uint coreid, uint coreunit)
+uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
 {
 	si_info_t *sii;
 	uint found;
@@ -1181,7 +1183,7 @@ uint ai_findcoreidx(si_t *sih, uint coreid, uint coreunit)
  * Moreover, callers should keep interrupts off during switching
  * out of and back to d11 core.
  */
-void *ai_setcore(si_t *sih, uint coreid, uint coreunit)
+void *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
 {
 	uint idx;
 
@@ -1193,7 +1195,8 @@ void *ai_setcore(si_t *sih, uint coreid, uint coreunit)
 }
 
 /* Turn off interrupt as required by ai_setcore, before switch core */
-void *ai_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
+void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
+		     uint *intr_val)
 {
 	void *cc;
 	si_info_t *sii;
@@ -1218,7 +1221,7 @@ void *ai_switch_core(si_t *sih, uint coreid, uint *origidx, uint *intr_val)
 }
 
 /* restore coreidx and restore interrupt */
-void ai_restore_core(si_t *sih, uint coreid, uint intr_val)
+void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 {
 	si_info_t *sii;
 
@@ -1231,7 +1234,7 @@ void ai_restore_core(si_t *sih, uint coreid, uint intr_val)
 	INTR_RESTORE(sii, intr_val);
 }
 
-void ai_write_wrapperreg(si_t *sih, u32 offset, u32 val)
+void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val)
 {
 	si_info_t *sii = SI_INFO(sih);
 	u32 *w = (u32 *) sii->curwrap;
@@ -1249,7 +1252,8 @@ void ai_write_wrapperreg(si_t *sih, u32 offset, u32 val)
  * Also, when using pci/pcie, we can optimize away the core switching for pci
  * registers and (on newer pci cores) chipcommon registers.
  */
-uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
+uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
+		uint val)
 {
 	uint origidx = 0;
 	u32 *r = NULL;
@@ -1333,7 +1337,7 @@ uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask, uint val)
 	return w;
 }
 
-void ai_core_disable(si_t *sih, u32 bits)
+void ai_core_disable(struct si_pub *sih, u32 bits)
 {
 	si_info_t *sii;
 	u32 dummy;
@@ -1360,7 +1364,7 @@ void ai_core_disable(si_t *sih, u32 bits)
  * bits - core specific bits that are set during and after reset sequence
  * resetbits - core specific bits that are set only during reset sequence
  */
-void ai_core_reset(si_t *sih, u32 bits, u32 resetbits)
+void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits)
 {
 	si_info_t *sii;
 	aidmp_t *ai;
@@ -1477,7 +1481,7 @@ static void ai_clkctl_setdelay(si_info_t *sii, void *chipcregs)
 }
 
 /* initialize power control delay registers */
-void ai_clkctl_init(si_t *sih)
+void ai_clkctl_init(struct si_pub *sih)
 {
 	si_info_t *sii;
 	uint origidx = 0;
@@ -1515,7 +1519,7 @@ void ai_clkctl_init(si_t *sih)
  * return the value suitable for writing to the
  * dot11 core FAST_PWRUP_DELAY register
  */
-u16 ai_clkctl_fast_pwrup_delay(si_t *sih)
+u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 {
 	si_info_t *sii;
 	uint origidx = 0;
@@ -1563,7 +1567,7 @@ u16 ai_clkctl_fast_pwrup_delay(si_t *sih)
 }
 
 /* turn primary xtal and/or pll off/on */
-int ai_clkctl_xtal(si_t *sih, uint what, bool on)
+int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on)
 {
 	si_info_t *sii;
 	u32 in, out, outen;
@@ -1640,7 +1644,7 @@ int ai_clkctl_xtal(si_t *sih, uint what, bool on)
  *    this is a wrapper over the next internal function
  *      to allow flexible policy settings for outside caller
  */
-bool ai_clkctl_cc(si_t *sih, uint mode)
+bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 {
 	si_info_t *sii;
 
@@ -1749,7 +1753,7 @@ static bool _ai_clkctl_cc(si_info_t *sii, uint mode)
 }
 
 /* Build device path. Support SI, PCI, and JTAG for now. */
-int ai_devpath(si_t *sih, char *path, int size)
+int ai_devpath(struct si_pub *sih, char *path, int size)
 {
 	int slen;
 
@@ -1782,7 +1786,7 @@ int ai_devpath(si_t *sih, char *path, int size)
 }
 
 /* Get a variable, but only if it has a devpath prefix */
-char *ai_getdevpathvar(si_t *sih, const char *name)
+char *ai_getdevpathvar(struct si_pub *sih, const char *name)
 {
 	char varname[SI_DEVPATH_BUFSZ + 32];
 
@@ -1792,7 +1796,7 @@ char *ai_getdevpathvar(si_t *sih, const char *name)
 }
 
 /* Get a variable, but only if it has a devpath prefix */
-int ai_getdevpathintvar(si_t *sih, const char *name)
+int ai_getdevpathintvar(struct si_pub *sih, const char *name)
 {
 #if defined(BCMBUSTYPE) && (BCMBUSTYPE == SI_BUS)
 	return getintvar(NULL, name);
@@ -1805,7 +1809,7 @@ int ai_getdevpathintvar(si_t *sih, const char *name)
 #endif
 }
 
-char *ai_getnvramflvar(si_t *sih, const char *name)
+char *ai_getnvramflvar(struct si_pub *sih, const char *name)
 {
 	return getvar(NULL, name);
 }
@@ -1815,7 +1819,8 @@ char *ai_getnvramflvar(si_t *sih, const char *name)
  * len == 0 or var is NULL, var is still returned. On overflow, the
  * first char will be set to '\0'.
  */
-static char *ai_devpathvar(si_t *sih, char *var, int len, const char *name)
+static char *ai_devpathvar(struct si_pub *sih, char *var, int len,
+			   const char *name)
 {
 	uint path_len;
 
@@ -1851,7 +1856,7 @@ static __used bool ai_ispcie(si_info_t *sii)
 	return true;
 }
 
-bool ai_pci_war16165(si_t *sih)
+bool ai_pci_war16165(struct si_pub *sih)
 {
 	si_info_t *sii;
 
@@ -1860,7 +1865,7 @@ bool ai_pci_war16165(si_t *sih)
 	return PCI(sii) && (sih->buscorerev <= 10);
 }
 
-void ai_pci_up(si_t *sih)
+void ai_pci_up(struct si_pub *sih)
 {
 	si_info_t *sii;
 
@@ -1879,7 +1884,7 @@ void ai_pci_up(si_t *sih)
 }
 
 /* Unconfigure and/or apply various WARs when system is going to sleep mode */
-void ai_pci_sleep(si_t *sih)
+void ai_pci_sleep(struct si_pub *sih)
 {
 	si_info_t *sii;
 
@@ -1889,7 +1894,7 @@ void ai_pci_sleep(si_t *sih)
 }
 
 /* Unconfigure and/or apply various WARs when going down */
-void ai_pci_down(si_t *sih)
+void ai_pci_down(struct si_pub *sih)
 {
 	si_info_t *sii;
 
@@ -1910,7 +1915,7 @@ void ai_pci_down(si_t *sih)
  * Configure the pci core for pci client (NIC) action
  * coremask is the bitvec of cores by index to be enabled.
  */
-void ai_pci_setup(si_t *sih, uint coremask)
+void ai_pci_setup(struct si_pub *sih, uint coremask)
 {
 	si_info_t *sii;
 	void *regs = NULL;
@@ -1959,7 +1964,7 @@ void ai_pci_setup(si_t *sih, uint coremask)
  * Fixup SROMless PCI device's configuration.
  * The current core may be changed upon return.
  */
-int ai_pci_fixcfg(si_t *sih)
+int ai_pci_fixcfg(struct si_pub *sih)
 {
 	uint origidx;
 	void *regs = NULL;
@@ -1982,7 +1987,7 @@ int ai_pci_fixcfg(si_t *sih)
 }
 
 /* mask&set gpiocontrol bits */
-u32 ai_gpiocontrol(si_t *sih, u32 mask, u32 val, u8 priority)
+u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 {
 	uint regoff;
 
@@ -2002,7 +2007,7 @@ u32 ai_gpiocontrol(si_t *sih, u32 mask, u32 val, u8 priority)
 	return ai_corereg(sih, SI_CC_IDX, regoff, mask, val);
 }
 
-void ai_chipcontrl_epa4331(si_t *sih, bool on)
+void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 {
 	si_info_t *sii;
 	chipcregs_t *cc;
@@ -2036,7 +2041,7 @@ void ai_chipcontrl_epa4331(si_t *sih, bool on)
 }
 
 /* Enable BT-COEX & Ex-PA for 4313 */
-void ai_epa_4313war(si_t *sih)
+void ai_epa_4313war(struct si_pub *sih)
 {
 	si_info_t *sii;
 	chipcregs_t *cc;
@@ -2055,7 +2060,7 @@ void ai_epa_4313war(si_t *sih)
 }
 
 /* check if the device is removed */
-bool ai_deviceremoved(si_t *sih)
+bool ai_deviceremoved(struct si_pub *sih)
 {
 	u32 w;
 	si_info_t *sii;
@@ -2072,7 +2077,7 @@ bool ai_deviceremoved(si_t *sih)
 	return false;
 }
 
-bool ai_is_sprom_available(si_t *sih)
+bool ai_is_sprom_available(struct si_pub *sih)
 {
 	if (sih->ccrev >= 31) {
 		si_info_t *sii;
@@ -2109,7 +2114,7 @@ bool ai_is_sprom_available(si_t *sih)
 	}
 }
 
-bool ai_is_otp_disabled(si_t *sih)
+bool ai_is_otp_disabled(struct si_pub *sih)
 {
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -2137,14 +2142,14 @@ bool ai_is_otp_disabled(si_t *sih)
 	}
 }
 
-bool ai_is_otp_powered(si_t *sih)
+bool ai_is_otp_powered(struct si_pub *sih)
 {
 	if (PMUCTL_ENAB(sih))
 		return si_pmu_is_otp_powered(sih);
 	return true;
 }
 
-void ai_otp_power(si_t *sih, bool on)
+void ai_otp_power(struct si_pub *sih, bool on)
 {
 	if (PMUCTL_ENAB(sih))
 		si_pmu_otp_power(sih, on);
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.h b/drivers/staging/brcm80211/brcmsmac/aiutils.h
index a0fec83..53d2e02 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.h
@@ -361,13 +361,6 @@ struct si_pub {
 };
 
 /*
- * for HIGH_ONLY driver, the si_t must be writable to allow states sync from
- * BMAC to HIGH driver for monolithic driver, it is readonly to prevent accident
- * change
- */
-typedef const struct si_pub si_t;
-
-/*
  * Many of the routines below take an 'sih' handle as their first arg.
  * Allocate this by calling si_attach().  Free it by calling si_detach().
  * At any one time, the sih is logically focused on one particular si core
@@ -499,94 +492,94 @@ typedef struct si_info {
 } si_info_t;
 
 /* AMBA Interconnect exported externs */
-extern void ai_scan(si_t *sih, void *regs, uint devid);
-
-extern uint ai_flag(si_t *sih);
-extern void ai_setint(si_t *sih, int siflag);
-extern uint ai_coreidx(si_t *sih);
-extern uint ai_corevendor(si_t *sih);
-extern uint ai_corerev(si_t *sih);
-extern bool ai_iscoreup(si_t *sih);
-extern void *ai_setcoreidx(si_t *sih, uint coreidx);
-extern u32 ai_core_cflags(si_t *sih, u32 mask, u32 val);
-extern void ai_core_cflags_wo(si_t *sih, u32 mask, u32 val);
-extern u32 ai_core_sflags(si_t *sih, u32 mask, u32 val);
-extern uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask,
+extern void ai_scan(struct si_pub *sih, void *regs, uint devid);
+
+extern uint ai_flag(struct si_pub *sih);
+extern void ai_setint(struct si_pub *sih, int siflag);
+extern uint ai_coreidx(struct si_pub *sih);
+extern uint ai_corevendor(struct si_pub *sih);
+extern uint ai_corerev(struct si_pub *sih);
+extern bool ai_iscoreup(struct si_pub *sih);
+extern void *ai_setcoreidx(struct si_pub *sih, uint coreidx);
+extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
+extern void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val);
+extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
+extern uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		       uint val);
-extern void ai_core_reset(si_t *sih, u32 bits, u32 resetbits);
-extern void ai_core_disable(si_t *sih, u32 bits);
-extern int ai_numaddrspaces(si_t *sih);
-extern u32 ai_addrspace(si_t *sih, uint asidx);
-extern u32 ai_addrspacesize(si_t *sih, uint asidx);
-extern void ai_write_wrap_reg(si_t *sih, u32 offset, u32 val);
+extern void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits);
+extern void ai_core_disable(struct si_pub *sih, u32 bits);
+extern int ai_numaddrspaces(struct si_pub *sih);
+extern u32 ai_addrspace(struct si_pub *sih, uint asidx);
+extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
+extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
-extern si_t *ai_attach(uint pcidev, void *regs, uint bustype,
+extern struct si_pub *ai_attach(uint pcidev, void *regs, uint bustype,
 		       void *sdh, char **vars, uint *varsz);
 
-extern void ai_detach(si_t *sih);
-extern bool ai_pci_war16165(si_t *sih);
+extern void ai_detach(struct si_pub *sih);
+extern bool ai_pci_war16165(struct si_pub *sih);
 
-extern uint ai_coreid(si_t *sih);
-extern uint ai_corerev(si_t *sih);
-extern uint ai_corereg(si_t *sih, uint coreidx, uint regoff, uint mask,
+extern uint ai_coreid(struct si_pub *sih);
+extern uint ai_corerev(struct si_pub *sih);
+extern uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		uint val);
-extern void ai_write_wrapperreg(si_t *sih, u32 offset, u32 val);
-extern u32 ai_core_cflags(si_t *sih, u32 mask, u32 val);
-extern u32 ai_core_sflags(si_t *sih, u32 mask, u32 val);
-extern bool ai_iscoreup(si_t *sih);
-extern uint ai_findcoreidx(si_t *sih, uint coreid, uint coreunit);
-extern void *ai_setcoreidx(si_t *sih, uint coreidx);
-extern void *ai_setcore(si_t *sih, uint coreid, uint coreunit);
-extern void *ai_switch_core(si_t *sih, uint coreid, uint *origidx,
+extern void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val);
+extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
+extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
+extern bool ai_iscoreup(struct si_pub *sih);
+extern uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit);
+extern void *ai_setcoreidx(struct si_pub *sih, uint coreidx);
+extern void *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit);
+extern void *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
 			    uint *intr_val);
-extern void ai_restore_core(si_t *sih, uint coreid, uint intr_val);
-extern void ai_core_reset(si_t *sih, u32 bits, u32 resetbits);
-extern void ai_core_disable(si_t *sih, u32 bits);
-extern u32 ai_alp_clock(si_t *sih);
-extern u32 ai_ilp_clock(si_t *sih);
-extern void ai_pci_setup(si_t *sih, uint coremask);
-extern void ai_setint(si_t *sih, int siflag);
-extern bool ai_backplane64(si_t *sih);
-extern void ai_register_intr_callback(si_t *sih, void *intrsoff_fn,
+extern void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val);
+extern void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits);
+extern void ai_core_disable(struct si_pub *sih, u32 bits);
+extern u32 ai_alp_clock(struct si_pub *sih);
+extern u32 ai_ilp_clock(struct si_pub *sih);
+extern void ai_pci_setup(struct si_pub *sih, uint coremask);
+extern void ai_setint(struct si_pub *sih, int siflag);
+extern bool ai_backplane64(struct si_pub *sih);
+extern void ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
 				      void *intrsrestore_fn,
 				      void *intrsenabled_fn, void *intr_arg);
-extern void ai_deregister_intr_callback(si_t *sih);
-extern void ai_clkctl_init(si_t *sih);
-extern u16 ai_clkctl_fast_pwrup_delay(si_t *sih);
-extern bool ai_clkctl_cc(si_t *sih, uint mode);
-extern int ai_clkctl_xtal(si_t *sih, uint what, bool on);
-extern bool ai_deviceremoved(si_t *sih);
-extern u32 ai_gpiocontrol(si_t *sih, u32 mask, u32 val,
+extern void ai_deregister_intr_callback(struct si_pub *sih);
+extern void ai_clkctl_init(struct si_pub *sih);
+extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
+extern bool ai_clkctl_cc(struct si_pub *sih, uint mode);
+extern int ai_clkctl_xtal(struct si_pub *sih, uint what, bool on);
+extern bool ai_deviceremoved(struct si_pub *sih);
+extern u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val,
 			     u8 priority);
 
 /* OTP status */
-extern bool ai_is_otp_disabled(si_t *sih);
-extern bool ai_is_otp_powered(si_t *sih);
-extern void ai_otp_power(si_t *sih, bool on);
+extern bool ai_is_otp_disabled(struct si_pub *sih);
+extern bool ai_is_otp_powered(struct si_pub *sih);
+extern void ai_otp_power(struct si_pub *sih, bool on);
 
 /* SPROM availability */
-extern bool ai_is_sprom_available(si_t *sih);
+extern bool ai_is_sprom_available(struct si_pub *sih);
 
 /*
  * Build device path. Path size must be >= SI_DEVPATH_BUFSZ.
  * The returned path is NULL terminated and has trailing '/'.
  * Return 0 on success, nonzero otherwise.
  */
-extern int ai_devpath(si_t *sih, char *path, int size);
+extern int ai_devpath(struct si_pub *sih, char *path, int size);
 /* Read variable with prepending the devpath to the name */
-extern char *ai_getdevpathvar(si_t *sih, const char *name);
-extern int ai_getdevpathintvar(si_t *sih, const char *name);
+extern char *ai_getdevpathvar(struct si_pub *sih, const char *name);
+extern int ai_getdevpathintvar(struct si_pub *sih, const char *name);
 
-extern void ai_pci_sleep(si_t *sih);
-extern void ai_pci_down(si_t *sih);
-extern void ai_pci_up(si_t *sih);
-extern int ai_pci_fixcfg(si_t *sih);
+extern void ai_pci_sleep(struct si_pub *sih);
+extern void ai_pci_down(struct si_pub *sih);
+extern void ai_pci_up(struct si_pub *sih);
+extern int ai_pci_fixcfg(struct si_pub *sih);
 
-extern void ai_chipcontrl_epa4331(si_t *sih, bool on);
+extern void ai_chipcontrl_epa4331(struct si_pub *sih, bool on);
 /* Enable Ex-PA for 4313 */
-extern void ai_epa_4313war(si_t *sih);
+extern void ai_epa_4313war(struct si_pub *sih);
 
-char *ai_getnvramflvar(si_t *sih, const char *name);
+char *ai_getnvramflvar(struct si_pub *sih, const char *name);
 
 #endif				/* _aiutils_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmdma.h b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
index fc68d49..005410d 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmdma.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmdma.h
@@ -148,7 +148,7 @@ struct dma_pub {
 	uint txnobuf;		/* tx out of dma descriptors */
 };
 
-extern struct dma_pub *dma_attach(char *name, si_t *sih,
+extern struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 			    void *dmaregstx, void *dmaregsrx, uint ntxd,
 			    uint nrxd, uint rxbufsize, int rxextheadroom,
 			    uint nrxpost, uint rxoffset, uint *msg_level);
@@ -201,7 +201,7 @@ extern const di_fcn_t dma64proc;
  * SB attach provides ability to probe backplane and dma core capabilities
  * This info is needed by DMA_ALLOC_CONSISTENT in dma attach
  */
-extern uint dma_addrwidth(si_t *sih, void *dmaregs);
+extern uint dma_addrwidth(struct si_pub *sih, void *dmaregs);
 void dma_walk_packets(struct dma_pub *dmah, void (*callback_fnc)
 		      (void *pkt, void *arg_a), void *arg_a);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.c b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
index aa147c3..dab71fb 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.c
@@ -89,9 +89,9 @@
 /* OTP common function type */
 typedef int (*otp_status_t) (void *oh);
 typedef int (*otp_size_t) (void *oh);
-typedef void *(*otp_init_t) (si_t *sih);
+typedef void *(*otp_init_t) (struct si_pub *sih);
 typedef u16(*otp_read_bit_t) (void *oh, chipcregs_t *cc, uint off);
-typedef int (*otp_read_region_t) (si_t *sih, int region, u16 *data,
+typedef int (*otp_read_region_t) (struct si_pub *sih, int region, u16 *data,
 				  uint *wlen);
 typedef int (*otp_nvread_t) (void *oh, char *data, uint *len);
 
@@ -108,7 +108,7 @@ typedef struct otp_fn_s {
 typedef struct {
 	uint ccrev;		/* chipc revision */
 	otp_fn_t *fn;		/* OTP functions */
-	si_t *sih;		/* Saved sb handle */
+	struct si_pub *sih;		/* Saved sb handle */
 
 #ifdef BCMIPXOTP
 	/* IPX OTP section */
@@ -245,7 +245,7 @@ static u16 ipxotp_read_bit(void *oh, chipcregs_t *cc, uint off)
 /* Calculate max HW/SW region byte size by subtracting fuse region and checksum size,
  * osizew is oi->wsize (OTP size - GU size) in words
  */
-static int ipxotp_max_rgnsz(si_t *sih, int osizew)
+static int ipxotp_max_rgnsz(struct si_pub *sih, int osizew)
 {
 	int ret = 0;
 
@@ -335,7 +335,7 @@ static void _ipxotp_init(otpinfo_t *oi, chipcregs_t *cc)
 	oi->flim = oi->wsize;
 }
 
-static void *ipxotp_init(si_t *sih)
+static void *ipxotp_init(struct si_pub *sih)
 {
 	uint idx;
 	chipcregs_t *cc;
@@ -635,7 +635,7 @@ static u16 hndotp_read_bit(void *oh, chipcregs_t *cc, uint idx)
 	return (u16) st;
 }
 
-static void *hndotp_init(si_t *sih)
+static void *hndotp_init(struct si_pub *sih)
 {
 	uint idx;
 	chipcregs_t *cc;
@@ -897,7 +897,7 @@ u16 otp_read_bit(void *oh, uint offset)
 	return readBit;
 }
 
-void *otp_init(si_t *sih)
+void *otp_init(struct si_pub *sih)
 {
 	otpinfo_t *oi;
 	void *ret = NULL;
@@ -929,7 +929,7 @@ void *otp_init(si_t *sih)
 }
 
 int
-otp_read_region(si_t *sih, int region, u16 *data,
+otp_read_region(struct si_pub *sih, int region, u16 *data,
 				 uint *wlen) {
 	bool wasup = false;
 	void *oh;
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmotp.h b/drivers/staging/brcm80211/brcmsmac/bcmotp.h
index 5803acc..ccfb9ff 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmotp.h
+++ b/drivers/staging/brcm80211/brcmsmac/bcmotp.h
@@ -37,8 +37,9 @@
 extern int otp_status(void *oh);
 extern int otp_size(void *oh);
 extern u16 otp_read_bit(void *oh, uint offset);
-extern void *otp_init(si_t *sih);
-extern int otp_read_region(si_t *sih, int region, u16 *data, uint *wlen);
+extern void *otp_init(struct si_pub *sih);
+extern int otp_read_region(struct si_pub *sih, int region, u16 *data,
+			   uint *wlen);
 extern int otp_nvread(void *oh, char *data, uint *len);
 
 #endif				/* _bcmotp_h_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
index e0899c8..c776a76 100644
--- a/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
+++ b/drivers/staging/brcm80211/brcmsmac/bcmsrom.c
@@ -780,21 +780,23 @@ static const sromvar_t perpath_pci_sromvars[] = {
 	{NULL, 0, 0, 0, 0}
 };
 
-static int initvars_srom_si(si_t *sih, void *curmap, char **vars, uint *count);
+static int initvars_srom_si(struct si_pub *sih, void *curmap, char **vars,
+			    uint *count);
 static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b);
-static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count);
-static int initvars_flash_si(si_t *sih, char **vars, uint *count);
-static int sprom_read_pci(si_t *sih, u16 *sprom,
+static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
+			     uint *count);
+static int initvars_flash_si(struct si_pub *sih, char **vars, uint *count);
+static int sprom_read_pci(struct si_pub *sih, u16 *sprom,
 			  uint wordoff, u16 *buf, uint nwords, bool check_crc);
 #if defined(BCMNVRAMR)
-static int otp_read_pci(si_t *sih, u16 *buf, uint bufsz);
+static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz);
 #endif
-static u16 srom_cc_cmd(si_t *sih, void *ccregs, u32 cmd,
+static u16 srom_cc_cmd(struct si_pub *sih, void *ccregs, u32 cmd,
 			  uint wordoff, u16 data);
 
 static int initvars_table(char *start, char *end,
 			  char **vars, uint *count);
-static int initvars_flash(si_t *sih, char **vp,
+static int initvars_flash(struct si_pub *sih, char **vp,
 			  uint len);
 
 /* Initialization of varbuf structure */
@@ -862,7 +864,7 @@ static int varbuf_append(varbuf_t *b, const char *fmt, ...)
  * Initialize local vars from the right source for this platform.
  * Return 0 on success, nonzero on error.
  */
-int srom_var_init(si_t *sih, uint bustype, void *curmap,
+int srom_var_init(struct si_pub *sih, uint bustype, void *curmap,
 		  char **vars, uint *count)
 {
 	uint len;
@@ -896,7 +898,7 @@ int srom_var_init(si_t *sih, uint bustype, void *curmap,
  * not in the bus cores.
  */
 static u16
-srom_cc_cmd(si_t *sih, void *ccregs, u32 cmd,
+srom_cc_cmd(struct si_pub *sih, void *ccregs, u32 cmd,
 	    uint wordoff, u16 data)
 {
 	chipcregs_t *cc = (chipcregs_t *) ccregs;
@@ -941,7 +943,7 @@ static inline void htol16_buf(u16 *buf, unsigned int size)
  * Return 0 on success, nonzero on error.
  */
 static int
-sprom_read_pci(si_t *sih, u16 *sprom, uint wordoff,
+sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 	       u16 *buf, uint nwords, bool check_crc)
 {
 	int err = 0;
@@ -998,7 +1000,7 @@ sprom_read_pci(si_t *sih, u16 *sprom, uint wordoff,
 }
 
 #if defined(BCMNVRAMR)
-static int otp_read_pci(si_t *sih, u16 *buf, uint bufsz)
+static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 {
 	u8 *otp;
 	uint sz = OTP_SZ_MAX / 2;	/* size in words */
@@ -1066,7 +1068,7 @@ static int initvars_table(char *start, char *end,
  * of the table upon enter and to the end of the table upon exit when success.
  * Return 0 on success, nonzero on error.
  */
-static int initvars_flash(si_t *sih, char **base, uint len)
+static int initvars_flash(struct si_pub *sih, char **base, uint len)
 {
 	char *vp = *base;
 	char *flash;
@@ -1124,7 +1126,7 @@ static int initvars_flash(si_t *sih, char **base, uint len)
  * Initialize nonvolatile variable table from flash.
  * Return 0 on success, nonzero on error.
  */
-static int initvars_flash_si(si_t *sih, char **vars, uint *count)
+static int initvars_flash_si(struct si_pub *sih, char **vars, uint *count)
 {
 	char *vp, *base;
 	int err;
@@ -1304,7 +1306,8 @@ static void _initvars_srom_pci(u8 sromrev, u16 *srom, uint off, varbuf_t *b)
  * Initialize nonvolatile variable table from sprom.
  * Return 0 on success, nonzero on error.
  */
-static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
+static int initvars_srom_pci(struct si_pub *sih, void *curmap, char **vars,
+			     uint *count)
 {
 	u16 *srom, *sromwindow;
 	u8 sromrev = 0;
@@ -1437,7 +1440,8 @@ static int initvars_srom_pci(si_t *sih, void *curmap, char **vars, uint *count)
 }
 
 
-static int initvars_srom_si(si_t *sih, void *curmap, char **vars, uint *varsz)
+static int initvars_srom_si(struct si_pub *sih, void *curmap, char **vars,
+			    uint *varsz)
 {
 	/* Search flash nvram section for srom variables */
 	return initvars_flash_si(sih, vars, varsz);
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 611a7e2..7d666c6 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -434,7 +434,7 @@ const di_fcn_t dma64proc = {
 	39
 };
 
-struct dma_pub *dma_attach(char *name, si_t *sih,
+struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 		     void *dmaregstx, void *dmaregsrx, uint ntxd,
 		     uint nrxd, uint rxbufsize, int rxextheadroom,
 		     uint nrxpost, uint rxoffset, uint *msg_level)
@@ -1873,7 +1873,7 @@ static void dma64_txrotate(dma_info_t *di)
 	      di->xmtptrbase + I2B(di->txout, dma64dd_t));
 }
 
-uint dma_addrwidth(si_t *sih, void *dmaregs)
+uint dma_addrwidth(struct si_pub *sih, void *dmaregs)
 {
 	/* Perform 64-bit checks only if we want to advertise 64-bit (> 32bit) capability) */
 	/* DMA engine is 64-bit capable */
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index e1612ec..8bc65e0 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -193,7 +193,7 @@ typedef struct {
 		struct sbpciregs *pciregs;
 	} regs;			/* Memory mapped register to the core */
 
-	si_t *sih;		/* System interconnect handle */
+	struct si_pub *sih;		/* System interconnect handle */
 	struct pci_dev *dev;
 	u8 pciecap_lcreg_offset;	/* PCIE capability LCreg offset in the config space */
 	bool pcie_pr42767;
@@ -512,7 +512,7 @@ static u8 pcie_clkreq(void *pch, u32 mask, u32 val)
 static void pcie_extendL1timer(pcicore_info_t *pi, bool extend)
 {
 	u32 w;
-	si_t *sih = pi->sih;
+	struct si_pub *sih = pi->sih;
 	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
 
 	if (!PCIE_PUB(sih) || sih->buscorerev < 7)
@@ -530,7 +530,7 @@ static void pcie_extendL1timer(pcicore_info_t *pi, bool extend)
 /* centralized clkreq control policy */
 static void pcie_clkreq_upd(pcicore_info_t *pi, uint state)
 {
-	si_t *sih = pi->sih;
+	struct si_pub *sih = pi->sih;
 
 	switch (state) {
 	case SI_DOATTACH:
@@ -596,7 +596,7 @@ static void pcie_war_polarity(pcicore_info_t *pi)
 static void pcie_war_aspm_clkreq(pcicore_info_t *pi)
 {
 	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
-	si_t *sih = pi->sih;
+	struct si_pub *sih = pi->sih;
 	u16 val16, *reg16;
 	u32 w;
 
@@ -691,7 +691,7 @@ static void pcie_war_noplldown(pcicore_info_t *pi)
 /* Needs to happen when coming out of 'standby'/'hibernate' */
 static void pcie_war_pci_setup(pcicore_info_t *pi)
 {
-	si_t *sih = pi->sih;
+	struct si_pub *sih = pi->sih;
 	sbpcieregs_t *pcieregs = pi->regs.pcieregs;
 	u32 w;
 
@@ -737,7 +737,7 @@ static void pcie_war_pci_setup(pcicore_info_t *pi)
 void pcicore_attach(void *pch, char *pvars, int state)
 {
 	pcicore_info_t *pi = (pcicore_info_t *) pch;
-	si_t *sih = pi->sih;
+	struct si_pub *sih = pi->sih;
 
 	/* Determine if this board needs override */
 	if (PCIE_ASPM(sih)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
index 93e3db9..6d4473c 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_hal.h
@@ -164,7 +164,7 @@ struct phy_pub;
 typedef struct phy_pub wlc_phy_t;
 
 typedef struct shared_phy_params {
-	si_t *sih;
+	struct si_pub *sih;
 	void *physhim;
 	uint unit;
 	uint corerev;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
index 8e7fb94..51e37aa 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/wlc_phy_int.h
@@ -534,7 +534,7 @@ typedef struct {
 struct shared_phy {
 	struct phy_info *phy_head;
 	uint unit;
-	si_t *sih;
+	struct si_pub *sih;
 	void *physhim;
 	uint corerev;
 	u32 machwcap;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_main.h b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
index 4e62b11..0dcb73f 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_main.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_main.h
@@ -450,7 +450,7 @@ struct wlc_hw_info {
 	u32 machwcap_backup;	/* backup of machwcap */
 	u16 ucode_dbgsel;	/* dbgsel for ucode debug(config gpio) */
 
-	si_t *sih;		/* SB handle (cookie for siutils calls) */
+	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
 	char *vars;		/* "environment" name=value */
 	uint vars_size;		/* size of vars, free vars on detach */
 	d11regs_t *regs;	/* pointer to device registers */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index e9230a8..ab2c0b7 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -607,7 +607,8 @@ typedef struct {
 	u32 res_mask;	/* resources (chip specific) */
 	s8 action;		/* action */
 	u32 depend_mask;	/* changes to the dependancies mask */
-	 bool(*filter) (si_t *sih);	/* action is taken when filter is NULL or return true */
+	/* action is taken when filter is NULL or return true: */
+	 bool(*filter) (struct si_pub *sih);
 } pmu_res_depend_t;
 
 /* setup pll and query clock speed */
@@ -623,10 +624,10 @@ typedef struct {
 /*
  * prototypes used in resource tables
  */
-static bool si_pmu_res_depfltr_bb(si_t *sih);
-static bool si_pmu_res_depfltr_ncb(si_t *sih);
-static bool si_pmu_res_depfltr_paldo(si_t *sih);
-static bool si_pmu_res_depfltr_npaldo(si_t *sih);
+static bool si_pmu_res_depfltr_bb(struct si_pub *sih);
+static bool si_pmu_res_depfltr_ncb(struct si_pub *sih);
+static bool si_pmu_res_depfltr_paldo(struct si_pub *sih);
+static bool si_pmu_res_depfltr_npaldo(struct si_pub *sih);
 
 static const pmu_res_updown_t bcm4328a0_res_updown[] = {
 	{
@@ -970,33 +971,33 @@ static const pmu1_xtaltab0_t pmu1_xtaltab0_880[] = {
 };
 
 /* true if the power topology uses the buck boost to provide 3.3V to VDDIO_RF and WLAN PA */
-static bool si_pmu_res_depfltr_bb(si_t *sih)
+static bool si_pmu_res_depfltr_bb(struct si_pub *sih)
 {
 	return (sih->boardflags & BFL_BUCKBOOST) != 0;
 }
 
 /* true if the power topology doesn't use the cbuck. Key on chiprev also if the chip is BCM4325. */
-static bool si_pmu_res_depfltr_ncb(si_t *sih)
+static bool si_pmu_res_depfltr_ncb(struct si_pub *sih)
 {
 
 	return (sih->boardflags & BFL_NOCBUCK) != 0;
 }
 
 /* true if the power topology uses the PALDO */
-static bool si_pmu_res_depfltr_paldo(si_t *sih)
+static bool si_pmu_res_depfltr_paldo(struct si_pub *sih)
 {
 	return (sih->boardflags & BFL_PALDO) != 0;
 }
 
 /* true if the power topology doesn't use the PALDO */
-static bool si_pmu_res_depfltr_npaldo(si_t *sih)
+static bool si_pmu_res_depfltr_npaldo(struct si_pub *sih)
 {
 	return (sih->boardflags & BFL_PALDO) == 0;
 }
 
 /* Return dependancies (direct or all/indirect) for the given resources */
 static u32
-si_pmu_res_deps(si_t *sih, chipcregs_t *cc, u32 rsrcs,
+si_pmu_res_deps(struct si_pub *sih, chipcregs_t *cc, u32 rsrcs,
 		bool all)
 {
 	u32 deps = 0;
@@ -1016,7 +1017,7 @@ si_pmu_res_deps(si_t *sih, chipcregs_t *cc, u32 rsrcs,
 }
 
 /* Determine min/max rsrc masks. Value 0 leaves hardware at default. */
-static void si_pmu_res_masks(si_t *sih, u32 * pmin, u32 * pmax)
+static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 {
 	u32 min_mask = 0, max_mask = 0;
 	uint rsrcs;
@@ -1103,7 +1104,7 @@ static void si_pmu_res_masks(si_t *sih, u32 * pmin, u32 * pmax)
 
 /* Return up time in ILP cycles for the given resource. */
 static uint
-si_pmu_res_uptime(si_t *sih, chipcregs_t *cc, u8 rsrc) {
+si_pmu_res_uptime(struct si_pub *sih, chipcregs_t *cc, u8 rsrc) {
 	u32 deps;
 	uint up, i, dup, dmax;
 	u32 min_mask = 0, max_mask = 0;
@@ -1136,7 +1137,7 @@ si_pmu_res_uptime(si_t *sih, chipcregs_t *cc, u8 rsrc) {
 }
 
 static void
-si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc, u8 spuravoid)
+si_pmu_spuravoid_pllupdate(struct si_pub *sih, chipcregs_t *cc, u8 spuravoid)
 {
 	u32 tmp = 0;
 	u8 phypll_offset = 0;
@@ -1336,7 +1337,7 @@ si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc, u8 spuravoid)
 }
 
 /* select default xtal frequency for each chip */
-static const pmu1_xtaltab0_t *si_pmu1_xtaldef0(si_t *sih)
+static const pmu1_xtaltab0_t *si_pmu1_xtaldef0(struct si_pub *sih)
 {
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1361,7 +1362,7 @@ static const pmu1_xtaltab0_t *si_pmu1_xtaldef0(si_t *sih)
 }
 
 /* select xtal table for each chip */
-static const pmu1_xtaltab0_t *si_pmu1_xtaltab0(si_t *sih)
+static const pmu1_xtaltab0_t *si_pmu1_xtaltab0(struct si_pub *sih)
 {
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1383,7 +1384,7 @@ static const pmu1_xtaltab0_t *si_pmu1_xtaltab0(si_t *sih)
 
 /* query alp/xtal clock frequency */
 static u32
-si_pmu1_alpclk0(si_t *sih, chipcregs_t *cc)
+si_pmu1_alpclk0(struct si_pub *sih, chipcregs_t *cc)
 {
 	const pmu1_xtaltab0_t *xt;
 	u32 xf;
@@ -1401,7 +1402,7 @@ si_pmu1_alpclk0(si_t *sih, chipcregs_t *cc)
 }
 
 /* select default pll fvco for each chip */
-static u32 si_pmu1_pllfvco0(si_t *sih)
+static u32 si_pmu1_pllfvco0(struct si_pub *sih)
 {
 	switch (sih->chip) {
 	case BCM4329_CHIP_ID:
@@ -1421,7 +1422,7 @@ static u32 si_pmu1_pllfvco0(si_t *sih)
 	return 0;
 }
 
-static void si_pmu_set_4330_plldivs(si_t *sih)
+static void si_pmu_set_4330_plldivs(struct si_pub *sih)
 {
 	u32 FVCO = si_pmu1_pllfvco0(sih) / 1000;
 	u32 m1div, m2div, m3div, m4div, m5div, m6div;
@@ -1455,7 +1456,7 @@ static void si_pmu_set_4330_plldivs(si_t *sih)
  * case the xtal frequency is unknown to the s/w so we need to call
  * si_pmu1_xtaldef0() wherever it is needed to return a default value.
  */
-static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
+static void si_pmu1_pllinit0(struct si_pub *sih, chipcregs_t *cc, u32 xtal)
 {
 	const pmu1_xtaltab0_t *xt;
 	u32 tmp;
@@ -1675,7 +1676,7 @@ static void si_pmu1_pllinit0(si_t *sih, chipcregs_t *cc, u32 xtal)
 	W_REG(&cc->pmucontrol, tmp);
 }
 
-u32 si_pmu_ilp_clock(si_t *sih)
+u32 si_pmu_ilp_clock(struct si_pub *sih)
 {
 	static u32 ilpcycles_per_sec;
 
@@ -1697,7 +1698,7 @@ u32 si_pmu_ilp_clock(si_t *sih)
 	return ilpcycles_per_sec;
 }
 
-void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
+void si_pmu_set_ldo_voltage(struct si_pub *sih, u8 ldo, u8 voltage)
 {
 	u8 sr_cntl_shift = 0, rc_shift = 0, shift = 0, mask = 0;
 	u8 addr = 0;
@@ -1747,7 +1748,7 @@ void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage)
 		   mask << shift, (voltage & mask) << shift);
 }
 
-u16 si_pmu_fast_pwrup_delay(si_t *sih)
+u16 si_pmu_fast_pwrup_delay(struct si_pub *sih)
 {
 	uint delay = PMU_MAX_TRANSITION_DLY;
 	chipcregs_t *cc;
@@ -1821,7 +1822,7 @@ u16 si_pmu_fast_pwrup_delay(si_t *sih)
 	return (u16) delay;
 }
 
-void si_pmu_sprom_enable(si_t *sih, bool enable)
+void si_pmu_sprom_enable(struct si_pub *sih, bool enable)
 {
 	chipcregs_t *cc;
 	uint origidx;
@@ -1835,7 +1836,7 @@ void si_pmu_sprom_enable(si_t *sih, bool enable)
 }
 
 /* Read/write a chipcontrol reg */
-u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val)
+u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
 	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, chipcontrol_addr), ~0,
 		   reg);
@@ -1844,7 +1845,7 @@ u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val)
 }
 
 /* Read/write a regcontrol reg */
-u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val)
+u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
 	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, regcontrol_addr), ~0,
 		   reg);
@@ -1853,7 +1854,7 @@ u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val)
 }
 
 /* Read/write a pllcontrol reg */
-u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val)
+u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val)
 {
 	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pllcontrol_addr), ~0,
 		   reg);
@@ -1862,14 +1863,14 @@ u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val)
 }
 
 /* PMU PLL update */
-void si_pmu_pllupd(si_t *sih)
+void si_pmu_pllupd(struct si_pub *sih)
 {
 	ai_corereg(sih, SI_CC_IDX, offsetof(chipcregs_t, pmucontrol),
 		   PCTL_PLL_PLLCTL_UPD, PCTL_PLL_PLLCTL_UPD);
 }
 
 /* query alp/xtal clock frequency */
-u32 si_pmu_alp_clock(si_t *sih)
+u32 si_pmu_alp_clock(struct si_pub *sih)
 {
 	chipcregs_t *cc;
 	uint origidx;
@@ -1920,7 +1921,7 @@ u32 si_pmu_alp_clock(si_t *sih)
 	return clock;
 }
 
-void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
+void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
 {
 	chipcregs_t *cc;
 	uint origidx, intr_val;
@@ -1955,7 +1956,7 @@ void si_pmu_spuravoid(si_t *sih, u8 spuravoid)
 }
 
 /* initialize PMU */
-void si_pmu_init(si_t *sih)
+void si_pmu_init(struct si_pub *sih)
 {
 	chipcregs_t *cc;
 	uint origidx;
@@ -1983,7 +1984,7 @@ void si_pmu_init(si_t *sih)
 }
 
 /* initialize PMU chip controls and other chip level stuff */
-void si_pmu_chip_init(si_t *sih)
+void si_pmu_chip_init(struct si_pub *sih)
 {
 	uint origidx;
 
@@ -1998,7 +1999,7 @@ void si_pmu_chip_init(si_t *sih)
 }
 
 /* initialize PMU switch/regulators */
-void si_pmu_swreg_init(si_t *sih)
+void si_pmu_swreg_init(struct si_pub *sih)
 {
 	switch (sih->chip) {
 	case BCM4336_CHIP_ID:
@@ -2023,7 +2024,7 @@ void si_pmu_swreg_init(si_t *sih)
 }
 
 /* initialize PLL */
-void si_pmu_pll_init(si_t *sih, uint xtalfreq)
+void si_pmu_pll_init(struct si_pub *sih, uint xtalfreq)
 {
 	chipcregs_t *cc;
 	uint origidx;
@@ -2063,7 +2064,7 @@ void si_pmu_pll_init(si_t *sih, uint xtalfreq)
 }
 
 /* initialize PMU resources */
-void si_pmu_res_init(si_t *sih)
+void si_pmu_res_init(struct si_pub *sih)
 {
 	chipcregs_t *cc;
 	uint origidx;
@@ -2234,7 +2235,7 @@ void si_pmu_res_init(si_t *sih)
 	ai_setcoreidx(sih, origidx);
 }
 
-u32 si_pmu_measure_alpclk(si_t *sih)
+u32 si_pmu_measure_alpclk(struct si_pub *sih)
 {
 	chipcregs_t *cc;
 	uint origidx;
@@ -2287,7 +2288,7 @@ u32 si_pmu_measure_alpclk(si_t *sih)
 	return alp_khz;
 }
 
-bool si_pmu_is_otp_powered(si_t *sih)
+bool si_pmu_is_otp_powered(struct si_pub *sih)
 {
 	uint idx;
 	chipcregs_t *cc;
@@ -2337,7 +2338,7 @@ bool si_pmu_is_otp_powered(si_t *sih)
 }
 
 /* power up/down OTP through PMU resources */
-void si_pmu_otp_power(si_t *sih, bool on)
+void si_pmu_otp_power(struct si_pub *sih, bool on)
 {
 	chipcregs_t *cc;
 	uint origidx;
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
index bd5b809b..6b005b0 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.h
@@ -36,23 +36,23 @@
 #define SET_LDO_VOLTAGE_LNLDO1	9
 #define SET_LDO_VOLTAGE_LNLDO2_SEL	10
 
-extern void si_pmu_set_ldo_voltage(si_t *sih, u8 ldo, u8 voltage);
-extern u16 si_pmu_fast_pwrup_delay(si_t *sih);
-extern void si_pmu_sprom_enable(si_t *sih, bool enable);
-extern u32 si_pmu_chipcontrol(si_t *sih, uint reg, u32 mask, u32 val);
-extern u32 si_pmu_regcontrol(si_t *sih, uint reg, u32 mask, u32 val);
-extern u32 si_pmu_ilp_clock(si_t *sih);
-extern u32 si_pmu_alp_clock(si_t *sih);
-extern void si_pmu_pllupd(si_t *sih);
-extern void si_pmu_spuravoid(si_t *sih, u8 spuravoid);
-extern u32 si_pmu_pllcontrol(si_t *sih, uint reg, u32 mask, u32 val);
-extern void si_pmu_init(si_t *sih);
-extern void si_pmu_chip_init(si_t *sih);
-extern void si_pmu_pll_init(si_t *sih, u32 xtalfreq);
-extern void si_pmu_res_init(si_t *sih);
-extern void si_pmu_swreg_init(si_t *sih);
-extern u32 si_pmu_measure_alpclk(si_t *sih);
-extern bool si_pmu_is_otp_powered(si_t *sih);
-extern void si_pmu_otp_power(si_t *sih, bool on);
+extern void si_pmu_set_ldo_voltage(struct si_pub *sih, u8 ldo, u8 voltage);
+extern u16 si_pmu_fast_pwrup_delay(struct si_pub *sih);
+extern void si_pmu_sprom_enable(struct si_pub *sih, bool enable);
+extern u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
+extern u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
+extern u32 si_pmu_ilp_clock(struct si_pub *sih);
+extern u32 si_pmu_alp_clock(struct si_pub *sih);
+extern void si_pmu_pllupd(struct si_pub *sih);
+extern void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid);
+extern u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
+extern void si_pmu_init(struct si_pub *sih);
+extern void si_pmu_chip_init(struct si_pub *sih);
+extern void si_pmu_pll_init(struct si_pub *sih, u32 xtalfreq);
+extern void si_pmu_res_init(struct si_pub *sih);
+extern void si_pmu_swreg_init(struct si_pub *sih);
+extern u32 si_pmu_measure_alpclk(struct si_pub *sih);
+extern bool si_pmu_is_otp_powered(struct si_pub *sih);
+extern void si_pmu_otp_power(struct si_pub *sih, bool on);
 
 #endif /* WLC_PMU_H_ */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 0ab16c4..77b0738 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -255,7 +255,7 @@ struct wlc_pub {
 	uint mac80211_state;
 	uint unit;		/* device instance number */
 	uint corerev;		/* core revision */
-	si_t *sih;		/* SB handle (cookie for siutils calls) */
+	struct si_pub *sih;	/* SI handle (cookie for siutils calls) */
 	char *vars;		/* "environment" name=value */
 	bool up;		/* interface up and running */
 	bool hw_off;		/* HW is off */
diff --git a/drivers/staging/brcm80211/include/bcmsrom.h b/drivers/staging/brcm80211/include/bcmsrom.h
index b9500ec..dc9ccee 100644
--- a/drivers/staging/brcm80211/include/bcmsrom.h
+++ b/drivers/staging/brcm80211/include/bcmsrom.h
@@ -18,10 +18,10 @@
 #define	_bcmsrom_h_
 
 /* Prototypes */
-extern int srom_var_init(si_t *sih, uint bus, void *curmap,
+extern int srom_var_init(struct si_pub *sih, uint bus, void *curmap,
 			 char **vars, uint *count);
 
-extern int srom_read(si_t *sih, uint bus, void *curmap,
+extern int srom_read(struct si_pub *sih, uint bus, void *curmap,
 		     uint byteoff, uint nbytes, u16 *buf, bool check_crc);
 
 /* parse standard PCMCIA cis, normally used by SB/PCMCIA/SDIO/SPI/OTP
-- 
1.7.4.1


