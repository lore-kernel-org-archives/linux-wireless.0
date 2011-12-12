Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3079 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754664Ab1LLXPq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:46 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/15] brcm80211: smac: remove interrupt disable
 callback functionality
Date: Mon, 12 Dec 2011 15:15:07 -0800
Message-ID: <1323731713-14942-10-git-send-email-frankyl@broadcom.com> (sfid-20111213_001607_370479_B2839286)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

There is no need to interrupt disable/enable functionality any
longer due to BCMA usage assures the correct core is accessed
in any context.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   27 ---------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    4 ---
 drivers/net/wireless/brcm80211/brcmsmac/main.c    |   26 --------------------
 3 files changed, 0 insertions(+), 57 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 3a78f5f..86e33f9 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -818,33 +818,6 @@ void ai_detach(struct si_pub *sih)
 	kfree(sii);
 }
 
-/* register driver interrupt disabling and restoring callback functions */
-void
-ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
-			  void *intrsrestore_fn,
-			  void *intrsenabled_fn, void *intr_arg)
-{
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-	sii->intr_arg = intr_arg;
-	sii->intrsoff_fn = (u32 (*)(void *)) intrsoff_fn;
-	sii->intrsrestore_fn = (void (*) (void *, u32)) intrsrestore_fn;
-	sii->intrsenabled_fn = (bool (*)(void *)) intrsenabled_fn;
-	/* save current core id.  when this function called, the current core
-	 * must be the core which provides driver functions(il, et, wl, etc.)
-	 */
-	sii->dev_coreid = sii->coreid[sii->curidx];
-}
-
-void ai_deregister_intr_callback(struct si_pub *sih)
-{
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-	sii->intrsoff_fn = NULL;
-}
-
 uint ai_coreid(struct si_pub *sih)
 {
 	struct si_info *sii;
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index b0b0bff..8c51345 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -238,10 +238,6 @@ extern void __iomem *ai_switch_core(struct si_pub *sih, uint coreid,
 				    uint *origidx, uint *intr_val);
 extern void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val);
 extern void ai_pci_setup(struct si_pub *sih, uint coremask);
-extern void ai_register_intr_callback(struct si_pub *sih, void *intrsoff_fn,
-				      void *intrsrestore_fn,
-				      void *intrsenabled_fn, void *intr_arg);
-extern void ai_deregister_intr_callback(struct si_pub *sih);
 extern void ai_clkctl_init(struct si_pub *sih);
 extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
 extern bool ai_clkctl_cc(struct si_pub *sih, uint mode);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index d974809..1c75e2f 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -2370,27 +2370,6 @@ void brcms_c_intrson(struct brcms_c_info *wlc)
 	bcma_write32(wlc_hw->d11core, D11REGOFFS(macintmask), wlc->macintmask);
 }
 
-/*
- * callback for siutils.c, which has only wlc handler, no wl they both check
- * up, not only because there is no need to off/restore d11 interrupt but also
- * because per-port code may require sync with valid interrupt.
- */
-static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc)
-{
-	if (!wlc->hw->up)
-		return 0;
-
-	return brcms_intrsoff(wlc->wl);
-}
-
-static void brcms_c_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask)
-{
-	if (!wlc->hw->up)
-		return;
-
-	brcms_intrsrestore(wlc->wl, macintmask);
-}
-
 u32 brcms_c_intrsoff(struct brcms_c_info *wlc)
 {
 	struct brcms_hardware *wlc_hw = wlc->hw;
@@ -4712,10 +4691,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, struct bcma_device *core,
 	/* Match driver "down" state */
 	ai_pci_down(wlc_hw->sih);
 
-	/* register sb interrupt callback functions */
-	ai_register_intr_callback(wlc_hw->sih, (void *)brcms_c_wlintrsoff,
-				  (void *)brcms_c_wlintrsrestore, NULL, wlc);
-
 	/* turn off pll and xtal to match driver "down" state */
 	brcms_b_xtal(wlc_hw, OFF);
 
@@ -4986,7 +4961,6 @@ static int brcms_b_detach(struct brcms_c_info *wlc)
 		 * and per-port interrupt object may has been freed. this must
 		 * be done before sb core switch
 		 */
-		ai_deregister_intr_callback(wlc_hw->sih);
 		ai_pci_sleep(wlc_hw->sih);
 	}
 
-- 
1.7.5.4


