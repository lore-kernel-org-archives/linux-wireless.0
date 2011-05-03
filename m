Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2447 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752140Ab1ECJgS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:18 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>,
	"Roland Vossen" <rvossen@broadcom.com>
Subject: [PATCH 39/61] staging: brcm80211: fix checkpatch warnings in
 si_pmu_spuravoid_pllupdate
Date: Tue, 3 May 2011 11:35:39 +0200
Message-ID: <1304415361-7813-40-git-send-email-arend@broadcom.com> (sfid-20110503_113823_262187_2D269EB9)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

patch "remove dependency between aiutils and siutils sources" resulted
in several checkpatch warnings and errors. This patch fixes those in
function si_pmu_spuravoid_pllupdate().

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pmu.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
index 4bb14c5..603172a 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pmu.c
@@ -683,7 +683,10 @@ si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc, u8 spuravoid)
 	case BCM43236_CHIP_ID:
 	case BCM43238_CHIP_ID:
 
-		/* BCM5357 needs to touch PLL1_PLLCTL[02], so offset PLL0_PLLCTL[02] by 6 */
+		/*
+		 * BCM5357 needs to touch PLL1_PLLCTL[02],
+		 * so offset PLL0_PLLCTL[02] by 6
+		 */
 		phypll_offset = (sih->chip == BCM5357_CHIP_ID) ? 6 : 0;
 
 		/* RMW only the P1 divider */
@@ -821,10 +824,12 @@ si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc, u8 spuravoid)
 		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL5);
 		W_REG(&cc->pllcontrol_data, 0x88888854);
 
-		if (spuravoid == 1) {	/* spur_avoid ON, enable 41/82/164Mhz clock mode */
+		if (spuravoid == 1) {
+			/* spur_avoid ON, so enable 41/82/164Mhz clock mode */
 			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
 			W_REG(&cc->pllcontrol_data, 0x05201828);
-		} else {	/* enable 40/80/160Mhz clock mode */
+		} else {
+			/* enable 40/80/160Mhz clock mode */
 			W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL2);
 			W_REG(&cc->pllcontrol_data, 0x05001828);
 		}
@@ -847,11 +852,10 @@ si_pmu_spuravoid_pllupdate(si_t *sih, chipcregs_t *cc, u8 spuravoid)
 		W_REG(&cc->pllcontrol_data, 0x88888825);
 
 		W_REG(&cc->pllcontrol_addr, PMU1_PLL0_PLLCTL3);
-		if (spuravoid == 1) {
+		if (spuravoid == 1)
 			W_REG(&cc->pllcontrol_data, 0x00EC4EC4);
-		} else {
+		else
 			W_REG(&cc->pllcontrol_data, 0x00762762);
-		}
 
 		tmp = PCTL_PLL_PLLCTL_UPD;
 		break;
-- 
1.7.4.1


