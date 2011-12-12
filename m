Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3066 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754623Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 13/15] brcm80211: smac: cleanup buscore handling in
 aiutils.c
Date: Mon, 12 Dec 2011 15:15:11 -0800
Message-ID: <1323731713-14942-14-git-send-email-frankyl@broadcom.com> (sfid-20111213_002944_942325_1CFD2E78)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Instead of storing the buscore information now the BCMA core device
is kept for quick reference in si_info structure.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   52 +++++++++------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |   23 ++++-----
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |    3 +-
 3 files changed, 34 insertions(+), 44 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 34a5e02..372bee8 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -479,10 +479,9 @@ static bool ai_buscore_prep(struct si_info *sii)
 static bool
 ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 {
+	struct bcma_device *pci = NULL;
+	struct bcma_device *pcie = NULL;
 	struct bcma_device *core;
-	bool pci, pcie;
-	uint i;
-	uint pciidx, pcieidx, pcirev, pcierev;
 
 
 	/* no cores found, bail out */
@@ -506,15 +505,7 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 		sii->pub.pmurev = sii->pub.pmucaps & PCAP_REV_MASK;
 	}
 
-	/* figure out bus/orignal core idx */
-	sii->pub.buscoretype = NODEV_CORE_ID;
-	sii->pub.buscorerev = NOREV;
-	sii->buscoreidx = BADIDX;
-
-	pci = pcie = false;
-	pcirev = pcierev = NOREV;
-	pciidx = pcieidx = BADIDX;
-
+	/* figure out buscore */
 	list_for_each_entry(core, &cc->bus->cores, list) {
 		uint cid, crev;
 
@@ -522,30 +513,22 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 		crev = core->id.rev;
 
 		if (cid == PCI_CORE_ID) {
-			pciidx = i;
-			pcirev = crev;
-			pci = true;
+			pci = core;
 		} else if (cid == PCIE_CORE_ID) {
-			pcieidx = i;
-			pcierev = crev;
-			pcie = true;
+			pcie = core;
 		}
 	}
 
 	if (pci && pcie) {
 		if (ai_ispcie(sii))
-			pci = false;
+			pci = NULL;
 		else
-			pcie = false;
+			pcie = NULL;
 	}
 	if (pci) {
-		sii->pub.buscoretype = PCI_CORE_ID;
-		sii->pub.buscorerev = pcirev;
-		sii->buscoreidx = pciidx;
+		sii->buscore = pci;
 	} else if (pcie) {
-		sii->pub.buscoretype = PCIE_CORE_ID;
-		sii->pub.buscorerev = pcierev;
-		sii->buscoreidx = pcieidx;
+		sii->buscore = pcie;
 	}
 
 	/* fixup necessary chip/core configurations */
@@ -554,10 +537,8 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 		if (sii->pch == NULL)
 			return false;
 	}
-	if (ai_pci_fixcfg(&sii->pub)) {
-		/* si_doattach: si_pci_fixcfg failed */
+	if (ai_pci_fixcfg(&sii->pub))
 		return false;
-	}
 
 	return true;
 }
@@ -589,7 +570,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	savewin = 0;
 
 	sii->icbus = pbus;
-	sii->buscoreidx = BADIDX;
 	sii->pcibus = pbus->host_pci;
 
 	/* switch to Chipcommon core */
@@ -1248,3 +1228,15 @@ bool ai_is_otp_disabled(struct si_pub *sih)
 		return false;
 	}
 }
+
+uint ai_get_buscoretype(struct si_pub *sih)
+{
+	struct si_info *sii = (struct si_info *)sih;
+	return sii->buscore->id.id;
+}
+
+uint ai_get_buscorerev(struct si_pub *sih)
+{
+	struct si_info *sii = (struct si_info *)sih;
+	return sii->buscore->id.rev;
+}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index f9f88dd..f84c6f7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -146,8 +146,6 @@
  *   public (read-only) portion of aiutils handle returned by si_attach()
  */
 struct si_pub {
-	uint buscoretype;	/* PCI_CORE_ID, PCIE_CORE_ID, PCMCIA_CORE_ID */
-	uint buscorerev;	/* buscore rev */
 	int ccrev;		/* chip common core rev */
 	u32 cccaps;		/* chip common capabilities */
 	int pmurev;		/* pmu core rev */
@@ -175,11 +173,10 @@ struct si_info {
 	struct bcma_bus *icbus;	/* handle to soc interconnect bus */
 	struct pci_dev *pcibus;	/* handle to pci bus */
 	struct pcicore_info *pch; /* PCI/E core handle */
-
+	struct bcma_device *buscore;
 	struct list_head var_list; /* list of srom variables */
 
 	u32 chipst;		/* chip status */
-	uint buscoreidx;	/* buscore index */
 };
 
 /*
@@ -224,47 +221,49 @@ extern void ai_chipcontrl_epa4331(struct si_pub *sih, bool on);
 /* Enable Ex-PA for 4313 */
 extern void ai_epa_4313war(struct si_pub *sih);
 
-static inline uint ai_get_buscoretype(struct si_pub *sih)
-{
-	return sih->buscoretype;
-}
+extern uint ai_get_buscoretype(struct si_pub *sih);
+extern uint ai_get_buscorerev(struct si_pub *sih);
 
-static inline uint ai_get_buscorerev(struct si_pub *sih)
-{
-	return sih->buscorerev;
-}
 static inline int ai_get_ccrev(struct si_pub *sih)
 {
 	return sih->ccrev;
 }
+
 static inline u32 ai_get_cccaps(struct si_pub *sih)
 {
 	return sih->cccaps;
 }
+
 static inline int ai_get_pmurev(struct si_pub *sih)
 {
 	return sih->pmurev;
 }
+
 static inline u32 ai_get_pmucaps(struct si_pub *sih)
 {
 	return sih->pmucaps;
 }
+
 static inline uint ai_get_boardtype(struct si_pub *sih)
 {
 	return sih->boardtype;
 }
+
 static inline uint ai_get_boardvendor(struct si_pub *sih)
 {
 	return sih->boardvendor;
 }
+
 static inline uint ai_get_chip_id(struct si_pub *sih)
 {
 	return sih->chip;
 }
+
 static inline uint ai_get_chiprev(struct si_pub *sih)
 {
 	return sih->chiprev;
 }
+
 static inline uint ai_get_chippkg(struct si_pub *sih)
 {
 	return sih->chippkg;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index a433041..7fad6dc 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -408,7 +408,7 @@ pcie_mdioop(struct pcicore_info *pi, uint physmedia, uint regaddr, bool write,
 	bcma_write32(pi->core, PCIEREGOFFS(mdiocontrol),
 		     MDIOCTL_PREAM_EN | MDIOCTL_DIVISOR_VAL);
 
-	if (pi->sih->buscorerev >= 10) {
+	if (ai_get_buscorerev(pi->sih) >= 10) {
 		/* new serdes is slower in rw,
 		 * using two layers of reg address mapping
 		 */
@@ -782,7 +782,6 @@ void pcicore_down(struct pcicore_info *pi, int state)
 	pcie_extendL1timer(pi, false);
 }
 
-/* precondition: current core is sii->buscoretype */
 void pcicore_fixcfg(struct pcicore_info *pi)
 {
 	struct bcma_device *core = pi->core;
-- 
1.7.5.4


