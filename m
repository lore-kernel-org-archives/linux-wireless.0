Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1485 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751360Ab1LHXHM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Dec 2011 18:07:12 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/23] brcm80211: smac: remove unused fields from struct
 si_pub definition
Date: Thu, 8 Dec 2011 15:06:43 -0800
Message-ID: <1323385619-7454-8-git-send-email-frankyl@broadcom.com> (sfid-20111209_000740_094889_CDAE817C)
In-Reply-To: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
References: <1323385619-7454-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

Several fields from the si_pub structure were not used or only set
once but never checked. These fields have been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |    7 -------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    7 -------
 2 files changed, 0 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 39e3054..66c79f1 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -932,10 +932,6 @@ ai_buscore_setup(struct si_info *sii, u32 savewin, uint *origidx)
 
 	/* get chipcommon capabilites */
 	sii->pub.cccaps = R_REG(&cc->capabilities);
-	/* get chipcommon extended capabilities */
-
-	if (sii->pub.ccrev >= 35)
-		sii->pub.cccaps_ext = R_REG(&cc->capabilities_ext);
 
 	/* get pmu rev and caps */
 	if (sii->pub.cccaps & CC_CAP_PMU) {
@@ -1023,7 +1019,6 @@ static __used void ai_nvram_process(struct si_info *sii)
 
 	sii->pub.boardvendor = w & 0xffff;
 	sii->pub.boardtype = (w >> 16) & 0xffff;
-	sii->pub.boardflags = getintvar(&sii->pub, BRCMS_SROM_BOARDFLAGS);
 }
 
 static struct si_info *ai_doattach(struct si_info *sii,
@@ -1071,8 +1066,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	sih->chiprev = (w & CID_REV_MASK) >> CID_REV_SHIFT;
 	sih->chippkg = (w & CID_PKG_MASK) >> CID_PKG_SHIFT;
 
-	sih->issim = false;
-
 	/* scan for cores */
 	if (socitype == SOCI_AI) {
 		SI_MSG("Found chip type AI (0x%08x)\n", w);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index b51d1e4..1da9759 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -149,21 +149,14 @@ struct si_pub {
 	uint buscoreidx;	/* buscore index */
 	int ccrev;		/* chip common core rev */
 	u32 cccaps;		/* chip common capabilities */
-	u32 cccaps_ext;	/* chip common capabilities extension */
 	int pmurev;		/* pmu core rev */
 	u32 pmucaps;		/* pmu capabilities */
 	uint boardtype;		/* board type */
 	uint boardvendor;	/* board vendor */
-	uint boardflags;	/* board flags */
-	uint boardflags2;	/* board flags2 */
 	uint chip;		/* chip number */
 	uint chiprev;		/* chip revision */
 	uint chippkg;		/* chip package option */
 	u32 chipst;		/* chip status */
-	bool issim;		/* chip is in simulation or emulation */
-	uint socirev;		/* SOC interconnect rev */
-	bool pci_pr32414;
-
 };
 
 struct pci_dev;
-- 
1.7.5.4


