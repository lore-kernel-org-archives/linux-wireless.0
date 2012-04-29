Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44999 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Avx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 15/19] brcmsmac: remove pcicore_fixcfg()
Date: Sun, 29 Apr 2012 02:50:39 +0200
Message-Id: <1335660643-26368-16-git-send-email-hauke@hauke-m.de> (sfid-20120429_025158_801601_4A478C17)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now done in bcma by bcma_core_pci_fixcfg().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   16 ----------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    2 --
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.c  |   17 -----------------
 drivers/net/wireless/brcm80211/brcmsmac/nicpci.h  |    1 -
 5 files changed, 37 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 8df7cb5..8908c89 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -484,8 +484,6 @@ ai_buscore_setup(struct si_info *sii, struct bcma_device *cc)
 		if (sii->pch == NULL)
 			return false;
 	}
-	if (ai_pci_fixcfg(&sii->pub))
-		return false;
 
 	return true;
 }
@@ -815,20 +813,6 @@ void ai_pci_down(struct si_pub *sih)
 		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci, false);
 }
 
-/*
- * Fixup SROMless PCI device's configuration.
- * The current core may be changed upon return.
- */
-int ai_pci_fixcfg(struct si_pub *sih)
-{
-	struct si_info *sii = (struct si_info *)sih;
-
-	/* Fixup PI in SROM shadow area to enable the correct PCI core access */
-	/* check 'pi' is correct and fix it if not */
-	pcicore_fixcfg(sii->pch);
-	return 0;
-}
-
 /* Enable BT-COEX & Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 14ae9f5..da758c3 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -199,7 +199,6 @@ extern bool ai_deviceremoved(struct si_pub *sih);
 
 extern void ai_pci_down(struct si_pub *sih);
 extern void ai_pci_up(struct si_pub *sih);
-extern int ai_pci_fixcfg(struct si_pub *sih);
 
 /* Enable Ex-PA for 4313 */
 extern void ai_epa_4313war(struct si_pub *sih);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index 0d4a511..880fb55 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5021,8 +5021,6 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 	ai_clkctl_init(wlc_hw->sih);
 	brcms_b_clkctl_clk(wlc_hw, BCMA_CLKMODE_FAST);
 
-	ai_pci_fixcfg(wlc_hw->sih);
-
 	/*
 	 * TODO: test suspend/resume
 	 *
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
index 9a3e03b..cd3899b7 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.c
@@ -239,20 +239,3 @@ void pcicore_deinit(struct pcicore_info *pch)
 {
 	kfree(pch);
 }
-
-void pcicore_fixcfg(struct pcicore_info *pi)
-{
-	struct bcma_device *core = pi->core;
-	u16 val16;
-	uint regoff;
-
-	regoff = PCIEREGOFFS(sprom[SRSH_PI_OFFSET]);
-
-	val16 = bcma_read16(pi->core, regoff);
-	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) !=
-	    (u16)core->core_index) {
-		val16 = ((u16)core->core_index << SRSH_PI_SHIFT) |
-			(val16 & ~SRSH_PI_MASK);
-		bcma_write16(pi->core, regoff, val16);
-	}
-}
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
index 1e15ba9..cbd426e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/nicpci.h
@@ -66,6 +66,5 @@ extern struct pcicore_info *pcicore_init(struct si_pub *sih,
 extern void pcicore_deinit(struct pcicore_info *pch);
 extern void pcicore_up(struct pcicore_info *pch, int state);
 extern void pcicore_down(struct pcicore_info *pch, int state);
-extern void pcicore_fixcfg(struct pcicore_info *pch);
 
 #endif /* _BRCM_NICPCI_H_ */
-- 
1.7.9.5

