Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:1715 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752282Ab1ECJgY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:24 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 48/61] staging: brcm80211: use local variable for
 socitype during ai_scan
Date: Tue, 3 May 2011 11:35:48 +0200
Message-ID: <1304415361-7813-49-git-send-email-arend@broadcom.com> (sfid-20110503_113650_079380_0E331F1D)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The SOC interface type is only needed to verify that we are accessing
a chip with AMBA AXI interconnect during ai_scan function. Therefor
this can be done with a local variable.

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 2ee4236..c57b6c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -761,6 +761,7 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	u32 w, savewin;
 	chipcregs_t *cc;
 	char *pvars = NULL;
+	uint socitype;
 	uint origidx;
 
 	ASSERT(GOODREGS(regs));
@@ -814,7 +815,7 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	 *   be added here.
 	 */
 	w = R_REG(&cc->chipid);
-	sih->socitype = (w & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
+	socitype = (w & CID_TYPE_MASK) >> CID_TYPE_SHIFT;
 	/* Might as wll fill in chip id rev & pkg */
 	sih->chip = w & CID_ID_MASK;
 	sih->chiprev = (w & CID_REV_MASK) >> CID_REV_SHIFT;
@@ -823,7 +824,7 @@ static si_info_t *ai_doattach(si_info_t *sii, uint devid,
 	sih->issim = IS_SIM(sih->chippkg);
 
 	/* scan for cores */
-	if (sii->pub.socitype == SOCI_AI) {
+	if (socitype == SOCI_AI) {
 		SI_MSG(("Found chip type AI (0x%08x)\n", w));
 		/* pass chipc address instead of original core base */
 		ai_scan(&sii->pub, (void *)cc, devid);
-- 
1.7.4.1


