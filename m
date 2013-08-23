Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51202 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754230Ab3HWWco (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 18:32:44 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, zajec5@gmail.com,
	Hauke Mehrtens <hauke@hauke-m.de>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 2/5] brcmsmac: use bcma PCIe up and down functions
Date: Sat, 24 Aug 2013 00:32:31 +0200
Message-Id: <1377297154-14525-2-git-send-email-hauke@hauke-m.de> (sfid-20130824_003250_579214_5977CF6D)
In-Reply-To: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
References: <1377297154-14525-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

replace the calls to bcma_core_pci_extend_L1timer() by calls to the
newly introduced bcma_core_pci_ip() and bcma_core_pci_down()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   21 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    3 ---
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    8 ++++----
 3 files changed, 4 insertions(+), 28 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index e4fd1ee..5336597 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -679,27 +679,6 @@ bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
 	return mode == BCMA_CLKMODE_FAST;
 }
 
-void ai_pci_up(struct si_pub *sih)
-{
-	struct si_info *sii;
-
-	sii = container_of(sih, struct si_info, pub);
-
-	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
-		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci[0], true);
-}
-
-/* Unconfigure and/or apply various WARs when going down */
-void ai_pci_down(struct si_pub *sih)
-{
-	struct si_info *sii;
-
-	sii = container_of(sih, struct si_info, pub);
-
-	if (sii->icbus->hosttype == BCMA_HOSTTYPE_PCI)
-		bcma_core_pci_extend_L1timer(&sii->icbus->drv_pci[0], false);
-}
-
 /* Enable BT-COEX & Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 89562c1..a8a267b 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -183,9 +183,6 @@ extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
 extern bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode);
 extern bool ai_deviceremoved(struct si_pub *sih);
 
-extern void ai_pci_down(struct si_pub *sih);
-extern void ai_pci_up(struct si_pub *sih);
-
 /* Enable Ex-PA for 4313 */
 extern void ai_epa_4313war(struct si_pub *sih);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index c3c6123..4608e0e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -4669,7 +4669,7 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	brcms_c_coredisable(wlc_hw);
 
 	/* Match driver "down" state */
-	ai_pci_down(wlc_hw->sih);
+	bcma_core_pci_down(wlc_hw->d11core->bus);
 
 	/* turn off pll and xtal to match driver "down" state */
 	brcms_b_xtal(wlc_hw, OFF);
@@ -5012,12 +5012,12 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 */
 	if (brcms_b_radio_read_hwdisabled(wlc_hw)) {
 		/* put SB PCI in down state again */
-		ai_pci_down(wlc_hw->sih);
+		bcma_core_pci_down(wlc_hw->d11core->bus);
 		brcms_b_xtal(wlc_hw, OFF);
 		return -ENOMEDIUM;
 	}
 
-	ai_pci_up(wlc_hw->sih);
+	bcma_core_pci_up(wlc_hw->d11core->bus);
 
 	/* reset the d11 core */
 	brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
@@ -5214,7 +5214,7 @@ static int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 
 		/* turn off primary xtal and pll */
 		if (!wlc_hw->noreset) {
-			ai_pci_down(wlc_hw->sih);
+			bcma_core_pci_down(wlc_hw->d11core->bus);
 			brcms_b_xtal(wlc_hw, OFF);
 		}
 	}
-- 
1.7.10.4

