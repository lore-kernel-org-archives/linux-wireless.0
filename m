Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3062 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 12/15] brcm80211: smac: cleanup si_info structure
 definition
Date: Mon, 12 Dec 2011 15:15:10 -0800
Message-ID: <1323731713-14942-13-git-send-email-frankyl@broadcom.com> (sfid-20111213_001558_656989_1DB85A38)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Number of fields are no longer needed as the BCMA provides it
or makes them redundant. These have been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   51 +++++----------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |   27 -----------
 2 files changed, 11 insertions(+), 67 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index f78350a..34a5e02 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -454,29 +454,6 @@ struct aidmp {
 	u32 componentid3;	/* 0xffc */
 };
 
-/* parse the enumeration rom to identify all cores */
-static void ai_scan(struct si_pub *sih, struct bcma_bus *bus)
-{
-	struct si_info *sii = (struct si_info *)sih;
-	struct bcma_device *core;
-	uint idx;
-
-	list_for_each_entry(core, &bus->cores, list) {
-		idx = core->core_index;
-		sii->cia[idx] = core->id.manuf << CIA_MFG_SHIFT;
-		sii->cia[idx] |= core->id.id << CIA_CID_SHIFT;
-		sii->cia[idx] |= core->id.class << CIA_CCL_SHIFT;
-		sii->cib[idx] = core->id.rev << CIB_REV_SHIFT;
-		sii->coreid[idx] = core->id.id;
-		sii->coresba[idx] = core->addr;
-		sii->coresba_size[idx] = 0x1000;
-		sii->coresba2[idx] = 0;
-		sii->coresba2_size[idx] = 0;
-		sii->wrapba[idx] = core->wrap;
-		sii->numcores++;
-	}
-}
-
 /* return true if PCIE capability exists in the pci config space */
 static bool ai_ispcie(struct si_info *sii)
 {
@@ -502,10 +479,16 @@ static bool ai_buscore_prep(struct si_info *sii)
 static bool
 ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 {
+	struct bcma_device *core;
 	bool pci, pcie;
 	uint i;
 	uint pciidx, pcieidx, pcirev, pcierev;
 
+
+	/* no cores found, bail out */
+	if (cc->bus->nr_cores == 0)
+		return false;
+
 	/* get chipcommon rev */
 	sii->pub.ccrev = cc->id.rev;
 
@@ -532,11 +515,11 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 	pcirev = pcierev = NOREV;
 	pciidx = pcieidx = BADIDX;
 
-	for (i = 0; i < sii->numcores; i++) {
+	list_for_each_entry(core, &cc->bus->cores, list) {
 		uint cid, crev;
 
-		cid = sii->coreid[i];
-		crev = (sii->cib[i] & CIB_REV_MASK) >> CIB_REV_SHIFT;
+		cid = core->id.id;
+		crev = core->id.rev;
 
 		if (cid == PCI_CORE_ID) {
 			pciidx = i;
@@ -596,7 +579,6 @@ static __used void ai_nvram_process(struct si_info *sii)
 static struct si_info *ai_doattach(struct si_info *sii,
 				   struct bcma_bus *pbus)
 {
-	void __iomem *regs = pbus->mmio;
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
 	struct bcma_device *cc;
@@ -609,8 +591,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sii->icbus = pbus;
 	sii->buscoreidx = BADIDX;
 	sii->pcibus = pbus->host_pci;
-	sii->curmap = regs;
-	sii->curwrap = sii->curmap + SI_CORE_SIZE;
 
 	/* switch to Chipcommon core */
 	cc = pbus->drv_cc.core;
@@ -634,19 +614,10 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sih->chippkg = (w & CID_PKG_MASK) >> CID_PKG_SHIFT;
 
 	/* scan for cores */
-	if (socitype == SOCI_AI) {
-		SI_MSG("Found chip type AI (0x%08x)\n", w);
-		/* pass chipc address instead of original core base */
-		ai_scan(&sii->pub, pbus);
-	} else {
-		/* Found chip of unknown type */
-		return NULL;
-	}
-	/* no cores found, bail out */
-	if (sii->numcores == 0)
+	if (socitype != SOCI_AI)
 		return NULL;
 
-	/* bus/core/clk setup */
+	SI_MSG("Found chip type AI (0x%08x)\n", w);
 	if (!ai_buscore_setup(sii, cc))
 		goto exit;
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 6742758..f9f88dd 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -174,39 +174,12 @@ struct si_info {
 	struct si_pub pub;	/* back plane public state (must be first) */
 	struct bcma_bus *icbus;	/* handle to soc interconnect bus */
 	struct pci_dev *pcibus;	/* handle to pci bus */
-	uint dev_coreid;	/* the core provides driver functions */
-	void *intr_arg;		/* interrupt callback function arg */
-	u32 (*intrsoff_fn) (void *intr_arg); /* turns chip interrupts off */
-	/* restore chip interrupts */
-	void (*intrsrestore_fn) (void *intr_arg, u32 arg);
-	/* check if interrupts are enabled */
-	bool (*intrsenabled_fn) (void *intr_arg);
-
 	struct pcicore_info *pch; /* PCI/E core handle */
 
 	struct list_head var_list; /* list of srom variables */
 
-	void __iomem *curmap;			/* current regs va */
-	void __iomem *regs[SI_MAXCORES];	/* other regs va */
-
 	u32 chipst;		/* chip status */
-	uint curidx;		/* current core index */
 	uint buscoreidx;	/* buscore index */
-	uint numcores;		/* # discovered cores */
-	uint coreid[SI_MAXCORES]; /* id of each core */
-	u32 coresba[SI_MAXCORES]; /* backplane address of each core */
-	void *regs2[SI_MAXCORES]; /* 2nd virtual address per core (usbh20) */
-	u32 coresba2[SI_MAXCORES]; /* 2nd phys address per core (usbh20) */
-	u32 coresba_size[SI_MAXCORES]; /* backplane address space size */
-	u32 coresba2_size[SI_MAXCORES];	/* second address space size */
-
-	void *curwrap;		/* current wrapper va */
-	void *wrappers[SI_MAXCORES];	/* other cores wrapper va */
-	u32 wrapba[SI_MAXCORES];	/* address of controlling wrapper */
-
-	u32 cia[SI_MAXCORES];	/* erom cia entry for each core */
-	u32 cib[SI_MAXCORES];	/* erom cia entry for each core */
-	u32 oob_router;	/* oob router registers for axi */
 };
 
 /*
-- 
1.7.5.4


