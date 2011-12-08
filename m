Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2839 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1LHXHK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:10 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 21/23] brcm80211: smac: remove unused functions and/or
 prototypes
Date: Thu, 8 Dec 2011 15:06:57 -0800
Message-ID: <1323385619-7454-22-git-send-email-frankyl@broadcom.com> (sfid-20111209_000715_929509_C803B3A7)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several functions provided by aiutils.c are not used in brcmsmac
driver and have been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |  127 +--------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |   25 ----
 2 files changed, 1 insertions(+), 151 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index d72e993..fa8067b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -525,75 +525,6 @@ void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 	return sii->curmap;
 }
 
-/* Return the number of address spaces in current core */
-int ai_numaddrspaces(struct si_pub *sih)
-{
-	return 2;
-}
-
-/* Return the address of the nth address space in the current core */
-u32 ai_addrspace(struct si_pub *sih, uint asidx)
-{
-	struct si_info *sii;
-	uint cidx;
-
-	sii = (struct si_info *)sih;
-	cidx = sii->curidx;
-
-	if (asidx == 0)
-		return sii->coresba[cidx];
-	else if (asidx == 1)
-		return sii->coresba2[cidx];
-	else {
-		/* Need to parse the erom again to find addr space */
-		return 0;
-	}
-}
-
-/* Return the size of the nth address space in the current core */
-u32 ai_addrspacesize(struct si_pub *sih, uint asidx)
-{
-	struct si_info *sii;
-	uint cidx;
-
-	sii = (struct si_info *)sih;
-	cidx = sii->curidx;
-
-	if (asidx == 0)
-		return sii->coresba_size[cidx];
-	else if (asidx == 1)
-		return sii->coresba2_size[cidx];
-	else {
-		/* Need to parse the erom again to find addr */
-		return 0;
-	}
-}
-
-uint ai_flag(struct si_pub *sih)
-{
-	struct si_info *sii;
-	struct aidmp *ai;
-
-	sii = (struct si_info *)sih;
-	ai = sii->curwrap;
-
-	return R_REG(&ai->oobselouta30) & 0x1f;
-}
-
-void ai_setint(struct si_pub *sih, int siflag)
-{
-}
-
-uint ai_corevendor(struct si_pub *sih)
-{
-	struct si_info *sii;
-	u32 cia;
-
-	sii = (struct si_info *)sih;
-	cia = sii->cia[sii->curidx];
-	return (cia & CIA_MFG_MASK) >> CIA_MFG_SHIFT;
-}
-
 uint ai_corerev(struct si_pub *sih)
 {
 	struct si_info *sii;
@@ -617,22 +548,6 @@ bool ai_iscoreup(struct si_pub *sih)
 		&& ((R_REG(&ai->resetctrl) & AIRC_RESET) == 0));
 }
 
-void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val)
-{
-	struct si_info *sii;
-	struct aidmp *ai;
-	u32 w;
-
-	sii = (struct si_info *)sih;
-
-	ai = sii->curwrap;
-
-	if (mask || val) {
-		w = ((R_REG(&ai->ioctrl) & ~mask) | val);
-		W_REG(&ai->ioctrl, w);
-	}
-}
-
 u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val)
 {
 	struct si_info *sii;
@@ -1016,11 +931,6 @@ uint ai_coreidx(struct si_pub *sih)
 	return sii->curidx;
 }
 
-bool ai_backplane64(struct si_pub *sih)
-{
-	return (ai_get_cccaps(sih) & CC_CAP_BKPLN64) != 0;
-}
-
 /* return index of coreid or BADIDX if not found */
 uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit)
 {
@@ -1085,14 +995,6 @@ void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
 	INTR_RESTORE(sii, intr_val);
 }
 
-void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val)
-{
-	struct si_info *sii = (struct si_info *)sih;
-	u32 *w = (u32 *) sii->curwrap;
-	W_REG(w + (offset / 4), val);
-	return;
-}
-
 /*
  * Switch to 'coreidx', issue a single arbitrary 32bit register mask&set
  * operation, switch back to the original core, and return the new value.
@@ -1514,27 +1416,6 @@ bool ai_clkctl_cc(struct si_pub *sih, uint mode)
 	return _ai_clkctl_cc(sii, mode);
 }
 
-/* Build device path */
-int ai_devpath(struct si_pub *sih, char *path, int size)
-{
-	int slen;
-
-	if (!path || size <= 0)
-		return -1;
-
-	slen = snprintf(path, (size_t) size, "pci/%u/%u/",
-		((struct si_info *)sih)->pcibus->bus->number,
-		PCI_SLOT(((struct pci_dev *)
-				(((struct si_info *)(sih))->pcibus))->devfn));
-
-	if (slen < 0 || slen >= size) {
-		path[0] = '\0';
-		return -1;
-	}
-
-	return 0;
-}
-
 void ai_pci_up(struct si_pub *sih)
 {
 	struct si_info *sii;
@@ -1581,7 +1462,7 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 {
 	struct si_info *sii;
 	struct sbpciregs __iomem *regs = NULL;
-	u32 siflag = 0, w;
+	u32 w;
 	uint idx = 0;
 
 	sii = (struct si_info *)sih;
@@ -1590,9 +1471,6 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 		/* get current core index */
 		idx = sii->curidx;
 
-		/* we interrupt on this backplane flag number */
-		siflag = ai_flag(sih);
-
 		/* switch over to pci core */
 		regs = ai_setcoreidx(sih, sii->buscoreidx);
 	}
@@ -1606,9 +1484,6 @@ void ai_pci_setup(struct si_pub *sih, uint coremask)
 		pci_read_config_dword(sii->pcibus, PCI_INT_MASK, &w);
 		w |= (coremask << PCI_SBIM_SHIFT);
 		pci_write_config_dword(sii->pcibus, PCI_INT_MASK, w);
-	} else {
-		/* set sbintvec bit for our flag number */
-		ai_setint(sih, siflag);
 	}
 
 	if (PCI(sih)) {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 7923108..40d0070 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -219,21 +219,13 @@ struct si_info {
 
 
 /* AMBA Interconnect exported externs */
-extern uint ai_flag(struct si_pub *sih);
-extern void ai_setint(struct si_pub *sih, int siflag);
 extern uint ai_coreidx(struct si_pub *sih);
-extern uint ai_corevendor(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
 extern bool ai_iscoreup(struct si_pub *sih);
 extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
-extern void ai_core_cflags_wo(struct si_pub *sih, u32 mask, u32 val);
 extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
 extern void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits);
 extern void ai_core_disable(struct si_pub *sih, u32 bits);
-extern int ai_numaddrspaces(struct si_pub *sih);
-extern u32 ai_addrspace(struct si_pub *sih, uint asidx);
-extern u32 ai_addrspacesize(struct si_pub *sih, uint asidx);
-extern void ai_write_wrap_reg(struct si_pub *sih, u32 offset, u32 val);
 
 /* === exported functions === */
 extern struct si_pub *ai_attach(struct bcma_bus *pbus);
@@ -241,23 +233,13 @@ extern void ai_detach(struct si_pub *sih);
 extern uint ai_coreid(struct si_pub *sih);
 extern uint ai_corerev(struct si_pub *sih);
 extern uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val);
-extern void ai_write_wrapperreg(struct si_pub *sih, u32 offset, u32 val);
-extern u32 ai_core_cflags(struct si_pub *sih, u32 mask, u32 val);
-extern u32 ai_core_sflags(struct si_pub *sih, u32 mask, u32 val);
-extern bool ai_iscoreup(struct si_pub *sih);
 extern uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit);
 extern void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx);
 extern void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit);
 extern void __iomem *ai_switch_core(struct si_pub *sih, uint coreid,
 				    uint *origidx, uint *intr_val);
 extern void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val);
-extern void ai_core_reset(struct si_pub *sih, u32 bits, u32 resetbits);
-extern void ai_core_disable(struct si_pub *sih, u32 bits);
-extern u32 ai_alp_clock(struct si_pub *sih);
-extern u32 ai_ilp_clock(struct si_pub *sih);
 extern void ai_pci_setup(struct si_pub *sih, uint coremask);
-extern void ai_setint(struct si_pub *sih, int siflag);
-extern bool ai_backplane64(struct si_pub *sih);
 extern void ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
 				      void *intrsrestore_fn,
 				      void *intrsenabled_fn, void *intr_arg);
@@ -276,13 +258,6 @@ extern bool ai_is_otp_disabled(struct si_pub *sih);
 /* SPROM availability */
 extern bool ai_is_sprom_available(struct si_pub *sih);
 
-/*
- * Build device path. Path size must be >= SI_DEVPATH_BUFSZ.
- * The returned path is NULL terminated and has trailing '/'.
- * Return 0 on success, nonzero otherwise.
- */
-extern int ai_devpath(struct si_pub *sih, char *path, int size);
-
 extern void ai_pci_sleep(struct si_pub *sih);
 extern void ai_pci_down(struct si_pub *sih);
 extern void ai_pci_up(struct si_pub *sih);
-- 
1.7.5.4


