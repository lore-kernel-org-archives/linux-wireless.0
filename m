Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36243 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2FEXI2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:28 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 08/18] brcmsmac: remove some redundant chip common workarounds
Date: Wed,  6 Jun 2012 01:07:11 +0200
Message-Id: <1338937641-8519-9-git-send-email-hauke@hauke-m.de> (sfid-20120606_010830_302050_54345465)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The removed workarounds are already performed in bcma_pmu_workarounds()
and bcma_core_chipcommon_init()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   42 ---------------------
 1 file changed, 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 01837fb..5997624 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -476,11 +476,7 @@ static struct si_info *ai_doattach(struct si_info *sii,
 				   struct bcma_bus *pbus)
 {
 	struct si_pub *sih = &sii->pub;
-	u32 w, savewin;
 	struct bcma_device *cc;
-	struct ssb_sprom *sprom = &pbus->sprom;
-
-	savewin = 0;
 
 	sii->icbus = pbus;
 	sii->pcibus = pbus->host_pci;
@@ -506,44 +502,6 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		(void)si_pmu_measure_alpclk(sih);
 	}
 
-	/* setup the GPIO based LED powersave register */
-	w = (sprom->leddc_on_time << BCMA_CC_GPIOTIMER_ONTIME_SHIFT) |
-		 (sprom->leddc_off_time << BCMA_CC_GPIOTIMER_OFFTIME_SHIFT);
-	if (w == 0)
-		w = DEFAULT_GPIOTIMERVAL;
-	ai_cc_reg(sih, offsetof(struct chipcregs, gpiotimerval),
-		  ~0, w);
-
-	if (ai_get_chip_id(sih) == BCM43224_CHIP_ID) {
-		/*
-		 * enable 12 mA drive strenth for 43224 and
-		 * set chipControl register bit 15
-		 */
-		if (ai_get_chiprev(sih) == 0) {
-			SI_MSG("Applying 43224A0 WARs\n");
-			ai_cc_reg(sih, offsetof(struct chipcregs, chipcontrol),
-				  CCTRL43224_GPIO_TOGGLE,
-				  CCTRL43224_GPIO_TOGGLE);
-			si_pmu_chipcontrol(sih, 0, CCTRL_43224A0_12MA_LED_DRIVE,
-					   CCTRL_43224A0_12MA_LED_DRIVE);
-		}
-		if (ai_get_chiprev(sih) >= 1) {
-			SI_MSG("Applying 43224B0+ WARs\n");
-			si_pmu_chipcontrol(sih, 0, CCTRL_43224B0_12MA_LED_DRIVE,
-					   CCTRL_43224B0_12MA_LED_DRIVE);
-		}
-	}
-
-	if (ai_get_chip_id(sih) == BCM4313_CHIP_ID) {
-		/*
-		 * enable 12 mA drive strenth for 4313 and
-		 * set chipControl register bit 1
-		 */
-		SI_MSG("Applying 4313 WARs\n");
-		si_pmu_chipcontrol(sih, 0, CCTRL_4313_12MA_LED_DRIVE,
-				   CCTRL_4313_12MA_LED_DRIVE);
-	}
-
 	return sii;
 
  exit:
-- 
1.7.9.5

