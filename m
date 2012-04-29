Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44969 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Avn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:43 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 09/19] brcmsmac: remove ai_chipcontrl_epa4331
Date: Sun, 29 Apr 2012 02:50:33 +0200
Message-Id: <1335660643-26368-10-git-send-email-hauke@hauke-m.de> (sfid-20120429_025148_149465_07001EE6)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ai_chipcontrl_epa4331 is not referenced by any method in brcmsmac and
the functionality is already in bcma_chipco_bcm4331_ext_pa_lines_ctl in
drivers/bcma/driver_chipcommon_pmu.c

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   24 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    1 -
 2 files changed, 25 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 585a516..ade9d1b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -865,30 +865,6 @@ u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
 	return ai_cc_reg(sih, regoff, mask, val);
 }
 
-void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
-{
-	struct bcma_device *cc;
-	u32 val;
-
-	cc = ai_findcore(sih, CC_CORE_ID, 0);
-
-	if (on) {
-		if (ai_get_chippkg(sih) == 9 || ai_get_chippkg(sih) == 0xb)
-			/* Ext PA Controls for 4331 12x9 Package */
-			bcma_set32(cc, CHIPCREGOFFS(chipcontrol),
-				   CCTRL4331_EXTPA_EN |
-				   CCTRL4331_EXTPA_ON_GPIO2_5);
-		else
-			/* Ext PA Controls for 4331 12x12 Package */
-			bcma_set32(cc, CHIPCREGOFFS(chipcontrol),
-				   CCTRL4331_EXTPA_EN);
-	} else {
-		val &= ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5);
-		bcma_mask32(cc, CHIPCREGOFFS(chipcontrol),
-			    ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5));
-	}
-}
-
 /* Enable BT-COEX & Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 3994257..7c6108a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -207,7 +207,6 @@ extern void ai_pci_down(struct si_pub *sih);
 extern void ai_pci_up(struct si_pub *sih);
 extern int ai_pci_fixcfg(struct si_pub *sih);
 
-extern void ai_chipcontrl_epa4331(struct si_pub *sih, bool on);
 /* Enable Ex-PA for 4313 */
 extern void ai_epa_4313war(struct si_pub *sih);
 
-- 
1.7.9.5

