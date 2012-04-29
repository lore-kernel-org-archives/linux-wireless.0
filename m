Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:44956 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755162Ab2D2Avi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2012 20:51:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 08/19] brcmsmac: remove ai_pci_setup()
Date: Sun, 29 Apr 2012 02:50:32 +0200
Message-Id: <1335660643-26368-9-git-send-email-hauke@hauke-m.de> (sfid-20120429_025146_455266_553A2EE4)
In-Reply-To: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
References: <1335660643-26368-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is now done by calling bcma_core_pci_irq_ctl()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   23 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    1 -
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |    7 ++-----
 3 files changed, 2 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index fd99e7b..585a516 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -843,29 +843,6 @@ void ai_pci_down(struct si_pub *sih)
 }
 
 /*
- * Configure the pci core for pci client (NIC) action
- * coremask is the bitvec of cores by index to be enabled.
- */
-void ai_pci_setup(struct si_pub *sih, uint coremask)
-{
-	struct si_info *sii;
-	u32 w;
-
-	sii = (struct si_info *)sih;
-
-	/*
-	 * Enable sb->pci interrupts.  Assume
-	 * PCI rev 2.3 support was added in pci core rev 6 and things changed..
-	 */
-	if (PCIE(sih)) {
-		/* pci config write to set this core bit in PCIIntMask */
-		pci_read_config_dword(sii->pcibus, PCI_INT_MASK, &w);
-		w |= (coremask << PCI_SBIM_SHIFT);
-		pci_write_config_dword(sii->pcibus, PCI_INT_MASK, w);
-	}
-}
-
-/*
  * Fixup SROMless PCI device's configuration.
  * The current core may be changed upon return.
  */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 4ea166c..3994257 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -196,7 +196,6 @@ extern u32 ai_core_cflags(struct bcma_device *core, u32 mask, u32 val);
 extern struct si_pub *ai_attach(struct bcma_bus *pbus);
 extern void ai_detach(struct si_pub *sih);
 extern uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val);
-extern void ai_pci_setup(struct si_pub *sih, uint coremask);
 extern void ai_clkctl_init(struct si_pub *sih);
 extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
 extern bool ai_clkctl_cc(struct si_pub *sih, uint mode);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index d61e4a0..e2ec333 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -5050,8 +5050,6 @@ static void brcms_b_hw_up(struct brcms_hardware *wlc_hw)
 
 static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 {
-	uint coremask;
-
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/*
@@ -5066,9 +5064,8 @@ static int brcms_b_up_prep(struct brcms_hardware *wlc_hw)
 	 * Configure pci/pcmcia here instead of in brcms_c_attach()
 	 * to allow mfg hotswap:  down, hotswap (chip power cycle), up.
 	 */
-	coremask = (1 << wlc_hw->wlc->core->coreidx);
-
-	ai_pci_setup(wlc_hw->sih, coremask);
+	bcma_core_pci_irq_ctl(&wlc_hw->d11core->bus->drv_pci, wlc_hw->d11core,
+			      true);
 
 	/*
 	 * Need to read the hwradio status here to cover the case where the
-- 
1.7.9.5

