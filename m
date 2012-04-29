Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44966 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755082Ab2D2Avm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:42 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 10/19] brcmsmac: remove ai_gpiocontrol()
Date: Sun, 29 Apr 2012 02:50:34 +0200
Message-Id: <1335660643-26368-11-git-send-email-hauke@hauke-m.de> (sfid-20120429_025216_060021_5BA829D4)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now done by calling bcma_chipco_gpio_control().

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |    9 ---------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |    2 --
 drivers/net/wireless/brcm80211/brcmsmac/main.c     |    2 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    2 +-
 4 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index ade9d1b..1b7b172 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -856,15 +856,6 @@ int ai_pci_fixcfg(struct si_pub *sih)
 	return 0;
 }
 
-/* mask&set gpiocontrol bits */
-u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val, u8 priority)
-{
-	uint regoff;
-
-	regoff = offsetof(struct chipcregs, gpiocontrol);
-	return ai_cc_reg(sih, regoff, mask, val);
-}
-
 /* Enable BT-COEX & Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 7c6108a..62c3a63 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -200,8 +200,6 @@ extern void ai_clkctl_init(struct si_pub *sih);
 extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
 extern bool ai_clkctl_cc(struct si_pub *sih, uint mode);
 extern bool ai_deviceremoved(struct si_pub *sih);
-extern u32 ai_gpiocontrol(struct si_pub *sih, u32 mask, u32 val,
-			     u8 priority);
 
 extern void ai_pci_down(struct si_pub *sih);
 extern void ai_pci_up(struct si_pub *sih);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index e2ec333..f8b0e09 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2208,7 +2208,7 @@ static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 		gm |= gc |= BOARD_GPIO_PACTRL;
 
 	/* apply to gpiocontrol register */
-	ai_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
+	bcma_chipco_gpio_control(&wlc_hw->d11core->bus->drv_cc, gm, gc);
 }
 
 static void brcms_ucode_write(struct brcms_hardware *wlc_hw,
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index c26387b..13b2615 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -21343,7 +21343,7 @@ void wlc_phy_antsel_init(struct brcms_phy_pub *ppi, bool lut_init)
 		write_phy_reg(pi, 0xc8, 0x0);
 		write_phy_reg(pi, 0xc9, 0x0);
 
-		ai_gpiocontrol(pi->sh->sih, mask, mask, GPIO_DRV_PRIORITY);
+		bcma_chipco_gpio_control(&pi->d11core->bus->drv_cc, mask, mask);
 
 		mc = bcma_read32(pi->d11core, D11REGOFFS(maccontrol));
 		mc &= ~MCTL_GPOUT_SEL_MASK;
-- 
1.7.9.5

