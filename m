Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:3057 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754587Ab1LLXPv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Dec 2011 18:15:51 -0500
From: "Franky Lin" <frankyl@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org
Subject: [PATCH 10/15] brcm80211: smac: remove ai_switch_core() function
Date: Mon, 12 Dec 2011 15:15:08 -0800
Message-ID: <1323731713-14942-11-git-send-email-frankyl@broadcom.com> (sfid-20111213_001605_066886_5408B050)
In-Reply-To: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
References: <1323731713-14942-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

The function ai_switch_core() is no longer needed and its counterpart
ai_restore_core() as well, because interrupts disabling is not needed
anymore.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c  |   40 --------------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h  |    3 -
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |    7 +---
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c      |   24 ++---------
 drivers/net/wireless/brcm80211/brcmsmac/pmu.h      |    2 +-
 5 files changed, 7 insertions(+), 69 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 86e33f9..a99a163 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -321,20 +321,6 @@
 #define	IS_SIM(chippkg)	\
 	((chippkg == HDLSIM_PKG_ID) || (chippkg == HWSIM_PKG_ID))
 
-/*
- * Macros to disable/restore function core(D11, ENET, ILINE20, etc) interrupts
- * before after core switching to avoid invalid register accesss inside ISR.
- */
-#define INTR_OFF(si, intr_val) \
-	if ((si)->intrsoff_fn && \
-	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
-		intr_val = (*(si)->intrsoff_fn)((si)->intr_arg)
-
-#define INTR_RESTORE(si, intr_val) \
-	if ((si)->intrsrestore_fn && \
-	    (si)->coreid[(si)->curidx] == (si)->dev_coreid) \
-		(*(si)->intrsrestore_fn)((si)->intr_arg, intr_val)
-
 #define PCI(sih)	(ai_get_buscoretype(sih) == PCI_CORE_ID)
 #define PCIE(sih)	(ai_get_buscoretype(sih) == PCIE_CORE_ID)
 
@@ -872,32 +858,6 @@ void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit)
 	return ai_setcoreidx(sih, core->core_index);
 }
 
-/* Turn off interrupt as required by ai_setcore, before switch core */
-void __iomem *ai_switch_core(struct si_pub *sih, uint coreid, uint *origidx,
-			     uint *intr_val)
-{
-	void __iomem *cc;
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-
-	INTR_OFF(sii, *intr_val);
-	*origidx = sii->curidx;
-	cc = ai_setcore(sih, coreid, 0);
-	return cc;
-}
-
-/* restore coreidx and restore interrupt */
-void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val)
-{
-	struct si_info *sii;
-
-	sii = (struct si_info *)sih;
-
-	ai_setcoreidx(sih, coreid);
-	INTR_RESTORE(sii, intr_val);
-}
-
 /*
  * Switch to 'coreidx', issue a single arbitrary 32bit register mask&set
  * operation, switch back to the original core, and return the new value.
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 8c51345..e37c9f4 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -234,9 +234,6 @@ extern uint ai_cc_reg(struct si_pub *sih, uint regoff, u32 mask, u32 val);
 extern uint ai_findcoreidx(struct si_pub *sih, uint coreid, uint coreunit);
 extern void __iomem *ai_setcoreidx(struct si_pub *sih, uint coreidx);
 extern void __iomem *ai_setcore(struct si_pub *sih, uint coreid, uint coreunit);
-extern void __iomem *ai_switch_core(struct si_pub *sih, uint coreid,
-				    uint *origidx, uint *intr_val);
-extern void ai_restore_core(struct si_pub *sih, uint coreid, uint intr_val);
 extern void ai_pci_setup(struct si_pub *sih, uint coremask);
 extern void ai_clkctl_init(struct si_pub *sih);
 extern u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index e0237e4..a16f1ab 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -19447,7 +19447,6 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	u8 tx_pwr_ctrl_state;
 	bool do_nphy_cal = false;
 	uint core;
-	uint origidx, intr_val;
 	u32 d11_clk_ctl_st;
 	bool do_rssi_cal = false;
 
@@ -19469,8 +19468,6 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
-		ai_switch_core(pi->sh->sih, D11_CORE_ID, &origidx, &intr_val);
-
 		d11_clk_ctl_st = bcma_read32(pi->d11core,
 					     D11REGOFFS(clk_ctl_st));
 		bcma_mask32(pi->d11core, D11REGOFFS(clk_ctl_st),
@@ -19478,8 +19475,6 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 
 		bcma_write32(pi->d11core, D11REGOFFS(clk_ctl_st),
 			     d11_clk_ctl_st);
-
-		ai_restore_core(pi->sh->sih, origidx, intr_val);
 	}
 
 	pi->use_int_tx_iqlo_cal_nphy =
@@ -21342,7 +21337,7 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			spuravoid = 1;
 
 		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
-		si_pmu_spuravoid(pi->sh->sih, spuravoid);
+		si_pmu_spuravoid_pllupdate(pi->sh->sih, spuravoid);
 		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
 
 		if ((pi->sh->chip == BCM43224_CHIP_ID) ||
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index d972e9c..4931d29 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -139,11 +139,13 @@ static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 	*pmax = max_mask;
 }
 
-static void
-si_pmu_spuravoid_pllupdate(struct si_pub *sih, struct bcma_device *core,
-			   u8 spuravoid)
+void si_pmu_spuravoid_pllupdate(struct si_pub *sih, u8 spuravoid)
 {
 	u32 tmp = 0;
+	struct bcma_device *core;
+
+	/* switch to chipc */
+	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
 
 	switch (ai_get_chip_id(sih)) {
 	case BCM43224_CHIP_ID:
@@ -281,22 +283,6 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 	return clock;
 }
 
-void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid)
-{
-	struct bcma_device *cc;
-	uint origidx, intr_val;
-
-	/* switch to chipc */
-	cc = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
-	ai_switch_core(sih, CC_CORE_ID, &origidx, &intr_val);
-
-	/* update the pll changes */
-	si_pmu_spuravoid_pllupdate(sih, cc, spuravoid);
-
-	/* Return to original core */
-	ai_restore_core(sih, origidx, intr_val);
-}
-
 /* initialize PMU */
 void si_pmu_init(struct si_pub *sih)
 {
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
index dcd893c..3e39c5e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.h
@@ -26,7 +26,7 @@ extern u32 si_pmu_chipcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_regcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern u32 si_pmu_alp_clock(struct si_pub *sih);
 extern void si_pmu_pllupd(struct si_pub *sih);
-extern void si_pmu_spuravoid(struct si_pub *sih, u8 spuravoid);
+extern void si_pmu_spuravoid_pllupdate(struct si_pub *sih, u8 spuravoid);
 extern u32 si_pmu_pllcontrol(struct si_pub *sih, uint reg, u32 mask, u32 val);
 extern void si_pmu_init(struct si_pub *sih);
 extern void si_pmu_res_init(struct si_pub *sih);
-- 
1.7.5.4


