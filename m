Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44927 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974Ab2D2Av1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:27 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 03/19] brcmsmac: get board and chip info from bcma
Date: Sun, 29 Apr 2012 02:50:27 +0200
Message-Id: <1335660643-26368-4-git-send-email-hauke@hauke-m.de> (sfid-20120429_025145_938898_6CCDED49)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma now provide this data and brcmsmac should get it from there and
not parse it by its self.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   40 +++------------------
 1 file changed, 5 insertions(+), 35 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 441b3cc..d2c8f14 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -542,27 +542,12 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 	return true;
 }
 
-/*
- * get boardtype and boardrev
- */
-static __used void ai_nvram_process(struct si_info *sii)
-{
-	uint w = 0;
-
-	/* do a pci config read to get subsystem id and subvendor id */
-	pci_read_config_dword(sii->pcibus, PCI_SUBSYSTEM_VENDOR_ID, &w);
-
-	sii->pub.boardvendor = w & 0xffff;
-	sii->pub.boardtype = (w >> 16) & 0xffff;
-}
-
 static struct si_info *ai_doattach(struct si_info *sii,
 				   struct bcma_bus *pbus)
 {
 	struct si_pub *sih = &sii->pub;
 	u32 w, savewin;
 	struct bcma_device *cc;
-	uint socitype;
 	struct ssb_sprom *sprom = &pbus->sprom;
 
 	savewin = 0;
@@ -577,30 +562,15 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	if (!ai_buscore_prep(sii))
 		return NULL;
 
-	/*
-	 * ChipID recognition.
-	 *   We assume we can read chipid at offset 0 from the regs arg.
-	 *   If we add other chiptypes (or if we need to support old sdio
-	 *   hosts w/o chipcommon), some way of recognizing them needs to
-	 *   be added here.
-	 */
-	w = bcma_read32(cc, CHIPCREGOFFS(chipid));
-	socitype = (w & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
-	/* Might as wll fill in chip id rev & pkg */
-	sih->chip = w & CID_ID_MASK;
-	sih->chiprev = (w & CID_REV_MASK) >> CID_REV_SHIFT;
-	sih->chippkg = (w & CID_PKG_MASK) >> CID_PKG_SHIFT;
-
-	/* scan for cores */
-	if (socitype != SOCI_AI)
-		return NULL;
+	sih->chip = pbus->chipinfo.id;
+	sih->chiprev = pbus->chipinfo.rev;
+	sih->chippkg = pbus->chipinfo.pkg;
+	sih->boardvendor = pbus->boardinfo.vendor;
+	sih->boardtype = pbus->boardinfo.type;
 
-	SI_MSG("Found chip type AI (0x%08x)\n", w);
 	if (!ai_buscore_setup(sii, cc))
 		goto exit;
 
-	ai_nvram_process(sii);
-
 	/* === NVRAM, clock is ready === */
 	bcma_write32(cc, CHIPCREGOFFS(gpiopullup), 0);
 	bcma_write32(cc, CHIPCREGOFFS(gpiopulldown), 0);
-- 
1.7.9.5

