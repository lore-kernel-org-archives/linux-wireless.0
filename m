Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36225 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab2FEXIT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:19 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 05/18] brcmsmac: remove ai_findcore()
Date: Wed,  6 Jun 2012 01:07:08 +0200
Message-Id: <1338937641-8519-6-git-send-email-hauke@hauke-m.de> (sfid-20120606_010822_773194_B26DC38E)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

bcma also stores a pointer to the chipcommon core in its struct,
brcmsmac should use it and not search for the core by its own.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.c |   31 ++++-----------------
 drivers/net/wireless/brcm80211/brcmsmac/aiutils.h |    2 --
 drivers/net/wireless/brcm80211/brcmsmac/pmu.c     |   12 +++++---
 3 files changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
index 1e3d9e5..ca53522 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.c
@@ -590,27 +590,6 @@ void ai_detach(struct si_pub *sih)
 	kfree(sii);
 }
 
-/* return index of coreid or BADIDX if not found */
-struct bcma_device *ai_findcore(struct si_pub *sih, u16 coreid, u16 coreunit)
-{
-	struct bcma_device *core;
-	struct si_info *sii;
-	uint found;
-
-	sii = container_of(sih, struct si_info, pub);
-
-	found = 0;
-
-	list_for_each_entry(core, &sii->icbus->cores, list)
-		if (core->id.id == coreid) {
-			if (found == coreunit)
-				return core;
-			found++;
-		}
-
-	return NULL;
-}
-
 /*
  * read/modify chipcommon core register.
  */
@@ -687,12 +666,13 @@ ai_clkctl_setdelay(struct si_pub *sih, struct bcma_device *cc)
 /* initialize power control delay registers */
 void ai_clkctl_init(struct si_pub *sih)
 {
+	struct si_info *sii = container_of(sih, struct si_info, pub);
 	struct bcma_device *cc;
 
 	if (!(ai_get_cccaps(sih) & CC_CAP_PWR_CTL))
 		return;
 
-	cc = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+	cc = sii->icbus->drv_cc.core;
 	if (cc == NULL)
 		return;
 
@@ -724,7 +704,7 @@ u16 ai_clkctl_fast_pwrup_delay(struct si_pub *sih)
 		return 0;
 
 	fpdelay = 0;
-	cc = ai_findcore(sih, CC_CORE_ID, 0);
+	cc = sii->icbus->drv_cc.core;
 	if (cc) {
 		slowminfreq = ai_slowclk_freq(sih, false, cc);
 		fpdelay = (((bcma_read32(cc, CHIPCREGOFFS(pll_on_delay)) + 2)
@@ -748,7 +728,7 @@ bool ai_clkctl_cc(struct si_pub *sih, enum bcma_clkmode mode)
 
 	sii = container_of(sih, struct si_info, pub);
 
-	cc = ai_findcore(&sii->pub, BCMA_CORE_CHIPCOMMON, 0);
+	cc = sii->icbus->drv_cc.core;
 	bcma_core_set_clockmode(cc, mode);
 	return mode == BCMA_CLKMODE_FAST;
 }
@@ -777,9 +757,10 @@ void ai_pci_down(struct si_pub *sih)
 /* Enable BT-COEX & Ex-PA for 4313 */
 void ai_epa_4313war(struct si_pub *sih)
 {
+	struct si_info *sii = container_of(sih, struct si_info, pub);
 	struct bcma_device *cc;
 
-	cc = ai_findcore(sih, CC_CORE_ID, 0);
+	cc = sii->icbus->drv_cc.core;
 
 	/* EPA Fix */
 	bcma_set32(cc, CHIPCREGOFFS(gpiocontrol), GPIO_CTRL_EPA_EN_MASK);
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
index 74beb87..2c101b2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/aiutils.h
@@ -182,8 +182,6 @@ struct si_info {
 
 
 /* AMBA Interconnect exported externs */
-extern struct bcma_device *ai_findcore(struct si_pub *sih,
-				       u16 coreid, u16 coreunit);
 extern u32 ai_core_cflags(struct bcma_device *core, u32 mask, u32 val);
 
 /* === exported functions === */
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
index 4931d29..0399a86 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pmu.c
@@ -142,10 +142,11 @@ static void si_pmu_res_masks(struct si_pub *sih, u32 * pmin, u32 * pmax)
 void si_pmu_spuravoid_pllupdate(struct si_pub *sih, u8 spuravoid)
 {
 	u32 tmp = 0;
+	struct si_info *sii = container_of(sih, struct si_info, pub);
 	struct bcma_device *core;
 
 	/* switch to chipc */
-	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+	core = sii->icbus->drv_cc.core;
 
 	switch (ai_get_chip_id(sih)) {
 	case BCM43224_CHIP_ID:
@@ -286,10 +287,11 @@ u32 si_pmu_alp_clock(struct si_pub *sih)
 /* initialize PMU */
 void si_pmu_init(struct si_pub *sih)
 {
+	struct si_info *sii = container_of(sih, struct si_info, pub);
 	struct bcma_device *core;
 
 	/* select chipc */
-	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+	core = sii->icbus->drv_cc.core;
 
 	if (ai_get_pmurev(sih) == 1)
 		bcma_mask32(core, CHIPCREGOFFS(pmucontrol),
@@ -301,11 +303,12 @@ void si_pmu_init(struct si_pub *sih)
 /* initialize PMU resources */
 void si_pmu_res_init(struct si_pub *sih)
 {
+	struct si_info *sii = container_of(sih, struct si_info, pub);
 	struct bcma_device *core;
 	u32 min_mask = 0, max_mask = 0;
 
 	/* select to chipc */
-	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+	core = sii->icbus->drv_cc.core;
 
 	/* Determine min/max rsrc masks */
 	si_pmu_res_masks(sih, &min_mask, &max_mask);
@@ -328,6 +331,7 @@ void si_pmu_res_init(struct si_pub *sih)
 
 u32 si_pmu_measure_alpclk(struct si_pub *sih)
 {
+	struct si_info *sii = container_of(sih, struct si_info, pub);
 	struct bcma_device *core;
 	u32 alp_khz;
 
@@ -335,7 +339,7 @@ u32 si_pmu_measure_alpclk(struct si_pub *sih)
 		return 0;
 
 	/* Remember original core before switch to chipc */
-	core = ai_findcore(sih, BCMA_CORE_CHIPCOMMON, 0);
+	core = sii->icbus->drv_cc.core;
 
 	if (bcma_read32(core, CHIPCREGOFFS(pmustatus)) & PST_EXTLPOAVAIL) {
 		u32 ilp_ctr, alp_hz;
-- 
1.7.9.5

