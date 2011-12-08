Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2182 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab1LHXHR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:17 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 14/23] brcm80211: smac: remove enumeration rom parsing
 function
Date: Thu, 8 Dec 2011 15:06:50 -0800
Message-ID: <1323385619-7454-15-git-send-email-frankyl@broadcom.com> (sfid-20111209_000820_500435_CB20C232)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The core enumeration rom is already parsed by the bcma bus driver and
there is no need to repeat the exercise. The ai_scan() function still
exists but is targetted for removal as well.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |  257 ++-------------------
 1 files changed, 19 insertions(+), 238 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index c1e4f35..989dd3e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -481,247 +481,27 @@ struct aidmp {
 	u32 componentid3;	/* 0xffc */
 };
 
-/* EROM parsing */
-
-static u32
-get_erom_ent(struct si_pub *sih, u32 __iomem **eromptr, u32 mask, u32 match)
-{
-	u32 ent;
-	uint inv = 0, nom = 0;
-
-	while (true) {
-		ent = R_REG(*eromptr);
-		(*eromptr)++;
-
-		if (mask == 0)
-			break;
-
-		if ((ent & ER_VALID) == 0) {
-			inv++;
-			continue;
-		}
-
-		if (ent == (ER_END | ER_VALID))
-			break;
-
-		if ((ent & mask) == match)
-			break;
-
-		nom++;
-	}
-
-	return ent;
-}
-
-static u32
-get_asd(struct si_pub *sih, u32 __iomem **eromptr, uint sp, uint ad, uint st,
-	u32 *addrl, u32 *addrh, u32 *sizel, u32 *sizeh)
-{
-	u32 asd, sz, szd;
-
-	asd = get_erom_ent(sih, eromptr, ER_VALID, ER_VALID);
-	if (((asd & ER_TAG1) != ER_ADD) ||
-	    (((asd & AD_SP_MASK) >> AD_SP_SHIFT) != sp) ||
-	    ((asd & AD_ST_MASK) != st)) {
-		/* This is not what we want, "push" it back */
-		(*eromptr)--;
-		return 0;
-	}
-	*addrl = asd & AD_ADDR_MASK;
-	if (asd & AD_AG32)
-		*addrh = get_erom_ent(sih, eromptr, 0, 0);
-	else
-		*addrh = 0;
-	*sizeh = 0;
-	sz = asd & AD_SZ_MASK;
-	if (sz == AD_SZ_SZD) {
-		szd = get_erom_ent(sih, eromptr, 0, 0);
-		*sizel = szd & SD_SZ_MASK;
-		if (szd & SD_SG32)
-			*sizeh = get_erom_ent(sih, eromptr, 0, 0);
-	} else
-		*sizel = AD_SZ_BASE << (sz >> AD_SZ_SHIFT);
-
-	return asd;
-}
-
-static void ai_hwfixup(struct si_info *sii)
-{
-}
-
 /* parse the enumeration rom to identify all cores */
-static void ai_scan(struct si_pub *sih, struct chipcregs __iomem *cc)
+static void ai_scan(struct si_pub *sih, struct bcma_bus *bus)
 {
 	struct si_info *sii = (struct si_info *)sih;
+	struct bcma_device *core;
+	uint idx;
 
-	u32 erombase;
-	u32 __iomem *eromptr, *eromlim;
-	void __iomem *regs = cc;
-
-	erombase = R_REG(&cc->eromptr);
-
-	/* Set wrappers address */
-	sii->curwrap = (void *)((unsigned long)cc + SI_CORE_SIZE);
-
-	/* Now point the window at the erom */
-	pci_write_config_dword(sii->pcibus, PCI_BAR0_WIN, erombase);
-	eromptr = regs;
-	eromlim = eromptr + (ER_REMAPCONTROL / sizeof(u32));
-
-	while (eromptr < eromlim) {
-		u32 cia, cib, cid, mfg, crev, nmw, nsw, nmp, nsp;
-		u32 mpd, asd, addrl, addrh, sizel, sizeh;
-		u32 __iomem *base;
-		uint i, j, idx;
-		bool br;
-
-		br = false;
-
-		/* Grok a component */
-		cia = get_erom_ent(sih, &eromptr, ER_TAG, ER_CI);
-		if (cia == (ER_END | ER_VALID)) {
-			/*  Found END of erom */
-			ai_hwfixup(sii);
-			return;
-		}
-		base = eromptr - 1;
-		cib = get_erom_ent(sih, &eromptr, 0, 0);
-
-		if ((cib & ER_TAG) != ER_CI) {
-			/* CIA not followed by CIB */
-			goto error;
-		}
-
-		cid = (cia & CIA_CID_MASK) >> CIA_CID_SHIFT;
-		mfg = (cia & CIA_MFG_MASK) >> CIA_MFG_SHIFT;
-		crev = (cib & CIB_REV_MASK) >> CIB_REV_SHIFT;
-		nmw = (cib & CIB_NMW_MASK) >> CIB_NMW_SHIFT;
-		nsw = (cib & CIB_NSW_MASK) >> CIB_NSW_SHIFT;
-		nmp = (cib & CIB_NMP_MASK) >> CIB_NMP_SHIFT;
-		nsp = (cib & CIB_NSP_MASK) >> CIB_NSP_SHIFT;
-
-		if (((mfg == MFGID_ARM) && (cid == DEF_AI_COMP)) || (nsp == 0))
-			continue;
-		if ((nmw + nsw == 0)) {
-			/* A component which is not a core */
-			if (cid == OOB_ROUTER_CORE_ID) {
-				asd = get_asd(sih, &eromptr, 0, 0, AD_ST_SLAVE,
-					      &addrl, &addrh, &sizel, &sizeh);
-				if (asd != 0)
-					sii->oob_router = addrl;
-			}
-			continue;
-		}
-
-		idx = sii->numcores;
-/*		sii->eromptr[idx] = base; */
-		sii->cia[idx] = cia;
-		sii->cib[idx] = cib;
-		sii->coreid[idx] = cid;
-
-		for (i = 0; i < nmp; i++) {
-			mpd = get_erom_ent(sih, &eromptr, ER_VALID, ER_VALID);
-			if ((mpd & ER_TAG) != ER_MP) {
-				/* Not enough MP entries for component */
-				goto error;
-			}
-		}
-
-		/* First Slave Address Descriptor should be port 0:
-		 * the main register space for the core
-		 */
-		asd =
-		    get_asd(sih, &eromptr, 0, 0, AD_ST_SLAVE, &addrl, &addrh,
-			    &sizel, &sizeh);
-		if (asd == 0) {
-			/* Try again to see if it is a bridge */
-			asd =
-			    get_asd(sih, &eromptr, 0, 0, AD_ST_BRIDGE, &addrl,
-				    &addrh, &sizel, &sizeh);
-			if (asd != 0)
-				br = true;
-			else if ((addrh != 0) || (sizeh != 0)
-				 || (sizel != SI_CORE_SIZE)) {
-				/* First Slave ASD for core malformed */
-				goto error;
-			}
-		}
-		sii->coresba[idx] = addrl;
-		sii->coresba_size[idx] = sizel;
-		/* Get any more ASDs in port 0 */
-		j = 1;
-		do {
-			asd =
-			    get_asd(sih, &eromptr, 0, j, AD_ST_SLAVE, &addrl,
-				    &addrh, &sizel, &sizeh);
-			if ((asd != 0) && (j == 1) && (sizel == SI_CORE_SIZE)) {
-				sii->coresba2[idx] = addrl;
-				sii->coresba2_size[idx] = sizel;
-			}
-			j++;
-		} while (asd != 0);
-
-		/* Go through the ASDs for other slave ports */
-		for (i = 1; i < nsp; i++) {
-			j = 0;
-			do {
-				asd =
-				    get_asd(sih, &eromptr, i, j++, AD_ST_SLAVE,
-					    &addrl, &addrh, &sizel, &sizeh);
-			} while (asd != 0);
-			if (j == 0) {
-				/* SP has no address descriptors */
-				goto error;
-			}
-		}
-
-		/* Now get master wrappers */
-		for (i = 0; i < nmw; i++) {
-			asd =
-			    get_asd(sih, &eromptr, i, 0, AD_ST_MWRAP, &addrl,
-				    &addrh, &sizel, &sizeh);
-			if (asd == 0) {
-				/* Missing descriptor for MW */
-				goto error;
-			}
-			if ((sizeh != 0) || (sizel != SI_CORE_SIZE)) {
-				/* Master wrapper %d is not 4KB */
-				goto error;
-			}
-			if (i == 0)
-				sii->wrapba[idx] = addrl;
-		}
-
-		/* And finally slave wrappers */
-		for (i = 0; i < nsw; i++) {
-			uint fwp = (nsp == 1) ? 0 : 1;
-			asd =
-			    get_asd(sih, &eromptr, fwp + i, 0, AD_ST_SWRAP,
-				    &addrl, &addrh, &sizel, &sizeh);
-			if (asd == 0) {
-				/* Missing descriptor for SW */
-				goto error;
-			}
-			if ((sizeh != 0) || (sizel != SI_CORE_SIZE)) {
-				/* Slave wrapper is not 4KB */
-				goto error;
-			}
-			if ((nmw == 0) && (i == 0))
-				sii->wrapba[idx] = addrl;
-		}
-
-		/* Don't record bridges */
-		if (br)
-			continue;
-
-		/* Done with core */
+	list_for_each_entry(core, &bus->cores, list) {
+		idx = core->core_index;
+		sii->cia[idx] = core->id.manuf << CIA_MFG_SHIFT;
+		sii->cia[idx] |= core->id.id << CIA_CID_SHIFT;
+		sii->cia[idx] |= core->id.class << CIA_CCL_SHIFT;
+		sii->cib[idx] = core->id.rev << CIB_REV_SHIFT;
+		sii->coreid[idx] = core->id.id;
+		sii->coresba[idx] = core->addr;
+		sii->coresba_size[idx] = 0x1000;
+		sii->coresba2[idx] = 0;
+		sii->coresba2_size[idx] = 0;
+		sii->wrapba[idx] = core->wrap;
 		sii->numcores++;
 	}
-
- error:
-	/* Reached end of erom without finding END */
-	sii->numcores = 0;
-	return;
 }
 
 /*
@@ -1039,8 +819,9 @@ static struct si_info *ai_doattach(struct si_info *sii,
 
 	sii->icbus = pbus;
 	sii->buscoreidx = BADIDX;
-	sii->curmap = regs;
 	sii->pcibus = pbus->host_pci;
+	sii->curmap = regs;
+	sii->curwrap = sii->curmap + SI_CORE_SIZE;
 
 	/* find Chipcommon address */
 	pci_read_config_dword(sii->pcibus, PCI_BAR0_WIN, &savewin);
@@ -1073,7 +854,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	if (socitype == SOCI_AI) {
 		SI_MSG("Found chip type AI (0x%08x)\n", w);
 		/* pass chipc address instead of original core base */
-		ai_scan(&sii->pub, cc);
+		ai_scan(&sii->pub, pbus);
 	} else {
 		/* Found chip of unknown type */
 		return NULL;
-- 
1.7.5.4


