Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2996 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755312Ab1IMHuW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:22 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 08/17] staging: brcm80211: macro cleanup in softmac
 main.c
Date: Tue, 13 Sep 2011 09:49:48 +0200
Message-ID: <1315900197-7260-9-git-send-email-rvossen@broadcom.com> (sfid-20110913_095036_666830_076E4991)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/main.c |  249 +++++++++++++----------------
 1 files changed, 115 insertions(+), 134 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 7067a02..a40fcba 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -167,23 +167,21 @@
 
 #define	BRCMS_HWRXOFF		38	/* chip rx buffer offset */
 
-/*
- * driver maintains internal 'tick'(wlc->pub->now) which increments in 1s
- * OS timer(soft watchdog) it is not a wall clock and won't increment when
- * driver is in "down" state this low resolution driver tick can be used
- * for maintenance tasks such as phy calibration and scb update
- */
-
-#define BRCMS_WAR16165(wlc) (wlc->war16165)
-
 /* Find basic rate for a given rate */
-#define BRCMS_BASIC_RATE(wlc, rspec) \
-	(IS_MCS(rspec) \
-	? (wlc)->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK].leg_ofdm] \
-	: (wlc)->band->basic_rate[rspec & RSPEC_RATE_MASK])
+static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
+{
+	if (IS_MCS(rspec))
+		return wlc->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK]
+		       .leg_ofdm];
+	return wlc->band->basic_rate[rspec & RSPEC_RATE_MASK];
+}
 
-#define FRAMETYPE(r, mimoframe)	\
-	(IS_MCS(r) ? mimoframe	: (IS_CCK(r) ? FT_CCK : FT_OFDM))
+static u16 frametype(u32 rspec, u8 mimoframe)
+{
+	if (IS_MCS(rspec))
+		return mimoframe;
+	return IS_CCK(rspec) ? FT_CCK : FT_OFDM;
+}
 
 /* rfdisable delay timer 500 ms, runs of ALP clock */
 #define RFDISABLE_DEFAULT	10000000
@@ -240,11 +238,6 @@
 
 #define FRAGNUM_MASK		0xF
 
-#define DMAREG(wlc_hw, direction, fifonum) \
-	((direction == DMA_TX) ? \
-		&(wlc_hw->regs->fifo64regs[fifonum].dmaxmt) : \
-		&(wlc_hw->regs->fifo64regs[fifonum].dmarcv))
-
 #define APHY_SLOT_TIME		9
 #define BPHY_SLOT_TIME		20
 
@@ -359,21 +352,11 @@
 #define END_FOREACH_BSS()	}
 
 /* currently the best mechanism for determining SIFS is the band in use */
-#define SIFS(band) ((band)->bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME : \
-						       BPHY_SIFS_TIME);
-
-/* A fifo is full. Clear precedences related to that FIFO */
-#define BRCMS_TX_FIFO_CLEAR(wlc, fifo) \
-			((wlc)->tx_prec_map &= ~(wlc)->fifo2prec_map[fifo])
-
-/* Fifo is NOT full. Enable precedences for that FIFO */
-#define BRCMS_TX_FIFO_ENAB(wlc, fifo) \
-			((wlc)->tx_prec_map |= (wlc)->fifo2prec_map[fifo])
-
-#define BRCMS_PORTOPEN(cfg) true
-
-#define brcms_b_copyfrom_shm(wlc_hw, offset, buf, len)                 \
-	brcms_b_copyfrom_objmem(wlc_hw, offset, buf, len, OBJADDR_SHM_SEL)
+static u16 get_sifs(struct brcms_band *band)
+{
+	return band->bandtype == BRCM_BAND_5G ? APHY_SIFS_TIME :
+				 BPHY_SIFS_TIME;
+}
 
 /*
  * Detect Card removed.
@@ -384,45 +367,35 @@
  * If clocks are present, call the sb routine which will figure out if the
  * device is removed.
  */
-#define DEVICEREMOVED(wlc)      \
-	((wlc->hw->clk) ?   \
-	((R_REG(&wlc->hw->regs->maccontrol) & \
-	(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN) : \
-	(ai_deviceremoved(wlc->hw->sih)))
-
-#define BRCMS_WME_RETRY_SHORT_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_SHORT)
-#define BRCMS_WME_RETRY_SFB_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_SFB)
-#define BRCMS_WME_RETRY_LONG_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_LONG)
-#define BRCMS_WME_RETRY_LFB_GET(wlc, ac) \
-					GFIELD(wlc->wme_retries[ac], EDCF_LFB)
-
-#define BRCMS_WME_RETRY_SHORT_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SHORT, val))
-#define BRCMS_WME_RETRY_SFB_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_SFB, val))
-#define BRCMS_WME_RETRY_LONG_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LONG, val))
-#define BRCMS_WME_RETRY_LFB_SET(wlc, ac, val) \
-	(wlc->wme_retries[ac] = SFIELD(wlc->wme_retries[ac], EDCF_LFB, val))
+static bool brcms_deviceremoved(struct brcms_c_info *wlc)
+{
+	if (!wlc->hw->clk)
+		return ai_deviceremoved(wlc->hw->sih);
+	return (R_REG(&wlc->hw->regs->maccontrol) &
+		(MCTL_PSM_JMP_0 | MCTL_IHR_EN)) != MCTL_IHR_EN;
+}
 
 /* sum the individual fifo tx pending packet counts */
-#define	TXPKTPENDTOT(wlc) \
-	((wlc)->core->txpktpend[0] + (wlc)->core->txpktpend[1] + \
-	 (wlc)->core->txpktpend[2] + (wlc)->core->txpktpend[3])
-#define TXPKTPENDGET(wlc, fifo) ((wlc)->core->txpktpend[(fifo)])
-#define TXPKTPENDINC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] += (val))
-#define TXPKTPENDDEC(wlc, fifo, val) ((wlc)->core->txpktpend[(fifo)] -= (val))
-#define TXPKTPENDCLR(wlc, fifo)	((wlc)->core->txpktpend[(fifo)] = 0)
+static s16 brcms_txpktpendtot(struct brcms_c_info *wlc)
+{
+	return wlc->core->txpktpend[0] + wlc->core->txpktpend[1] +
+	       wlc->core->txpktpend[2] + wlc->core->txpktpend[3];
+}
 
-#define IS_MBAND_UNLOCKED(wlc) \
-	((wlc->pub->_nbands > 1) && !(wlc)->bandlocked)
+static bool brcms_is_mband_unlocked(struct brcms_c_info *wlc)
+{
+	return wlc->pub->_nbands > 1 && !wlc->bandlocked;
+}
 
-#define CHSPEC_WLC_BW(chanspec)	(CHSPEC_IS40(chanspec) ? BRCMS_40_MHZ : \
-				 CHSPEC_IS20(chanspec) ? BRCMS_20_MHZ : \
-							 BRCMS_10_MHZ)
+static int brcms_chspec_bw(u16 chanspec)
+{
+	if (CHSPEC_IS40(chanspec))
+		return BRCMS_40_MHZ;
+	if (CHSPEC_IS20(chanspec))
+		return BRCMS_20_MHZ;
+
+	return BRCMS_10_MHZ;
+}
 
 /* dup state between BMAC(struct brcms_hardware) and HIGH(struct brcms_c_info)
    driver */
@@ -973,7 +946,7 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	bool fatal = false;
 	struct wiphy *wiphy = wlc->wiphy;
 
-	if (DEVICEREMOVED(wlc)) {
+	if (brcms_deviceremoved(wlc)) {
 		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
 			  __func__);
 		brcms_down(wlc->wl);
@@ -1086,6 +1059,14 @@ brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 	}
 }
 
+static struct dma64regs *
+dmareg(struct brcms_hardware *hw, uint direction, uint fifonum)
+{
+	if (direction == DMA_TX)
+		return &(hw->regs->fifo64regs[fifonum].dmaxmt);
+	return &(hw->regs->fifo64regs[fifonum].dmarcv);
+}
+
 static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 {
 	uint i;
@@ -1110,8 +1091,8 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * RX: RX_FIFO (RX data packets)
 		 */
 		wlc_hw->di[0] = dma_attach(name, wlc_hw->sih,
-					   (wme ? DMAREG(wlc_hw, DMA_TX, 0) :
-					    NULL), DMAREG(wlc_hw, DMA_RX, 0),
+					   (wme ? dmareg(wlc_hw, DMA_TX, 0) :
+					    NULL), dmareg(wlc_hw, DMA_RX, 0),
 					   (wme ? NTXD : 0), NRXD,
 					   RXBUFSZ, -1, NRXBUFPOST,
 					   BRCMS_HWRXOFF, &brcm_msg_level);
@@ -1124,7 +1105,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * RX: UNUSED
 		 */
 		wlc_hw->di[1] = dma_attach(name, wlc_hw->sih,
-					   DMAREG(wlc_hw, DMA_TX, 1), NULL,
+					   dmareg(wlc_hw, DMA_TX, 1), NULL,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[1]);
@@ -1135,7 +1116,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 * RX: UNUSED
 		 */
 		wlc_hw->di[2] = dma_attach(name, wlc_hw->sih,
-					   DMAREG(wlc_hw, DMA_TX, 2), NULL,
+					   dmareg(wlc_hw, DMA_TX, 2), NULL,
 					   NTXD, 0, 0, -1, 0, 0,
 					   &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[2]);
@@ -1145,7 +1126,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 		 *   (legacy) TX_CTL_FIFO (TX control & mgmt packets)
 		 */
 		wlc_hw->di[3] = dma_attach(name, wlc_hw->sih,
-					   DMAREG(wlc_hw, DMA_TX, 3),
+					   dmareg(wlc_hw, DMA_TX, 3),
 					   NULL, NTXD, 0, 0, -1,
 					   0, 0, &brcm_msg_level);
 		dma_attach_err |= (NULL == wlc_hw->di[3]);
@@ -2567,7 +2548,7 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
  * Read and clear macintmask and macintstatus and intstatus registers.
  * This routine should be called with interrupts off
  * Return:
- *   -1 if DEVICEREMOVED(wlc) evaluates to true;
+ *   -1 if brcms_deviceremoved(wlc) evaluates to true;
  *   0 if the interrupt is not for us, or we are in some special cases;
  *   device interrupt status bits otherwise.
  */
@@ -2584,10 +2565,10 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 		 macintstatus);
 
 	/* detect cardbus removed, in power down(suspend) and in reset */
-	if (DEVICEREMOVED(wlc))
+	if (brcms_deviceremoved(wlc))
 		return -1;
 
-	/* DEVICEREMOVED succeeds even when the core is still resetting,
+	/* brcms_deviceremoved() succeeds even when the core is still resetting,
 	 * handle that case here.
 	 */
 	if (macintstatus == 0xffffffff)
@@ -2916,7 +2897,7 @@ void brcms_c_coredisable(struct brcms_hardware *wlc_hw)
 
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
-	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
+	dev_gone = brcms_deviceremoved(wlc_hw->wlc);
 
 	if (dev_gone)
 		return;
@@ -2949,7 +2930,7 @@ static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 	for (i = 0; i < NFIFO; i++)
 		if (wlc_hw->di[i]) {
 			dma_txreclaim(wlc_hw->di[i], DMA_RANGE_ALL);
-			TXPKTPENDCLR(wlc, i);
+			wlc->core->txpktpend[i] = 0;
 			BCMMSG(wlc->wiphy, "pktpend fifo %d clrd\n", i);
 		}
 
@@ -3131,7 +3112,7 @@ bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
 			 * disallow PS when one of the following
 			 * bsscfg specific conditions meets
 			 */
-			if (!cfg->BSS || !BRCMS_PORTOPEN(cfg))
+			if (!cfg->BSS)
 				return false;
 
 			if (!cfg->dtim_programmed)
@@ -3147,7 +3128,7 @@ static void brcms_b_reset(struct brcms_hardware *wlc_hw)
 	BCMMSG(wlc_hw->wlc->wiphy, "wl%d\n", wlc_hw->unit);
 
 	/* reset the core */
-	if (!DEVICEREMOVED(wlc_hw->wlc))
+	if (!brcms_deviceremoved(wlc_hw->wlc))
 		brcms_b_corereset(wlc_hw, BRCMS_USE_COREFLAGS);
 
 	/* purge the dma rings */
@@ -3724,7 +3705,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	 * Initialize WME parameters; if they haven't been set by some other
 	 * mechanism (IOVar, etc) then read them from the hardware.
 	 */
-	if (BRCMS_WME_RETRY_SHORT_GET(wlc, 0) == 0) {
+	if (GFIELD(wlc->wme_retries[0], EDCF_SHORT) == 0) {
 		/* Uninitialized; read from HW */
 		int ac;
 
@@ -3987,16 +3968,14 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, u16 chanspec)
 	brcms_c_set_phy_chanspec(wlc, chanspec);
 
 	/* init antenna selection */
-	if (CHSPEC_WLC_BW(old_chanspec) != CHSPEC_WLC_BW(chanspec)) {
+	if (brcms_chspec_bw(old_chanspec) != brcms_chspec_bw(chanspec)) {
 		brcms_c_antsel_init(wlc->asi);
 
 		/* Fix the hardware rateset based on bw.
 		 * Mainly add MCS32 for 40Mhz, remove MCS 32 for 20Mhz
 		 */
 		brcms_c_rateset_bw_mcs_filter(&wlc->band->hw_rateset,
-					  wlc->band->
-					  mimo_cap_40 ? CHSPEC_WLC_BW(chanspec)
-					  : 0);
+			wlc->band->mimo_cap_40 ? brcms_chspec_bw(chanspec) : 0);
 	}
 
 	/* update some mac configuration since chanspec changed */
@@ -4278,7 +4257,7 @@ static void brcms_c_radio_enable(struct brcms_c_info *wlc)
 	if (wlc->pub->up)
 		return;
 
-	if (DEVICEREMOVED(wlc))
+	if (brcms_deviceremoved(wlc))
 		return;
 
 	brcms_up(wlc->wl);
@@ -4332,7 +4311,7 @@ static void brcms_c_radio_timer(void *arg)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 
-	if (DEVICEREMOVED(wlc)) {
+	if (brcms_deviceremoved(wlc)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
 			__func__);
 		brcms_down(wlc->wl);
@@ -4380,7 +4359,7 @@ static void brcms_c_watchdog(void *arg)
 	if (!wlc->pub->up)
 		return;
 
-	if (DEVICEREMOVED(wlc)) {
+	if (brcms_deviceremoved(wlc)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n", wlc->pub->unit,
 			  __func__);
 		brcms_down(wlc->wl);
@@ -4564,8 +4543,6 @@ struct brcms_pub *brcms_c_pub(struct brcms_c_info *wlc)
 	return wlc->pub;
 }
 
-#define CHIP_SUPPORTS_11N(wlc)	1
-
 /* low level attach
  *    run backplane attach, init nvram
  *    run phy attach
@@ -5011,7 +4988,7 @@ static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 	brcms_c_rateset_default(&bi->rateset, NULL, band->phytype,
 		band->bandtype, false, BRCMS_RATE_MASK_FULL,
 		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
-		CHSPEC_WLC_BW(chanspec), wlc->stf->txstreams);
+		brcms_chspec_bw(chanspec), wlc->stf->txstreams);
 
 	if (wlc->pub->_n_enab & SUPPORT_11N)
 		bi->flags |= BRCMS_BSS_HT;
@@ -5202,7 +5179,7 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		}
 
 		/* init _n_enab supported mode */
-		if (BRCMS_PHY_11N_CAP(wlc->band) && CHIP_SUPPORTS_11N(wlc)) {
+		if (BRCMS_PHY_11N_CAP(wlc->band)) {
 			if (n_disabled & WLFEATURE_DISABLE_11N) {
 				pub->_n_enab = OFF;
 				brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
@@ -5649,7 +5626,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	BCMMSG(wlc->wiphy, "wl%d\n", wlc->pub->unit);
 
 	/* HW is turned off so don't try to access it */
-	if (wlc->pub->hw_off || DEVICEREMOVED(wlc))
+	if (wlc->pub->hw_off || brcms_deviceremoved(wlc))
 		return -ENOMEDIUM;
 
 	if (!wlc->pub->hw_up) {
@@ -5712,7 +5689,7 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	/* Set EDCF hostflags */
 	brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
 
-	if (BRCMS_WAR16165(wlc))
+	if (wlc->war16165)
 		brcms_c_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
 			BRCM_BAND_ALL);
 
@@ -5760,7 +5737,7 @@ static int brcms_b_bmac_down_prep(struct brcms_hardware *wlc_hw)
 	if (!wlc_hw->up)
 		return callbacks;
 
-	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
+	dev_gone = brcms_deviceremoved(wlc_hw->wlc);
 
 	/* disable interrupts */
 	if (dev_gone)
@@ -5791,7 +5768,7 @@ static int brcms_b_down_finish(struct brcms_hardware *wlc_hw)
 	wlc_hw->up = false;
 	wlc_phy_hw_state_upd(wlc_hw->band->pi, false);
 
-	dev_gone = DEVICEREMOVED(wlc_hw->wlc);
+	dev_gone = brcms_deviceremoved(wlc_hw->wlc);
 
 	if (dev_gone) {
 		wlc_hw->sbclk = false;
@@ -5850,7 +5827,7 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 
 	callbacks += brcms_b_bmac_down_prep(wlc->hw);
 
-	dev_gone = DEVICEREMOVED(wlc);
+	dev_gone = brcms_deviceremoved(wlc);
 
 	/* Call any registered down handlers */
 	for (i = 0; i < BRCMS_MAXMODULES; i++) {
@@ -6099,7 +6076,7 @@ brcms_c_set_internal_rateset(struct brcms_c_info *wlc,
 		goto good;
 
 	/* try the other band */
-	if (IS_MBAND_UNLOCKED(wlc)) {
+	if (brcms_is_mband_unlocked(wlc)) {
 		bandunit = OTHERBANDUNIT(wlc);
 		memcpy(&new, &rs, sizeof(struct brcms_c_rateset));
 		if (brcms_c_rate_hwrs_filter_sort_validate(&new,
@@ -6147,7 +6124,7 @@ int brcms_c_set_channel(struct brcms_c_info *wlc, u16 channel)
 		return -EINVAL;
 
 
-	if (!wlc->pub->up && IS_MBAND_UNLOCKED(wlc)) {
+	if (!wlc->pub->up && brcms_is_mband_unlocked(wlc)) {
 		if (wlc->band->bandunit != chspec_bandunit(chspec))
 			wlc->bandinit_pending = true;
 		else
@@ -6180,8 +6157,10 @@ int brcms_c_set_rate_limit(struct brcms_c_info *wlc, u16 srl, u16 lrl)
 	brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
 	for (ac = 0; ac < AC_COUNT; ac++) {
-		BRCMS_WME_RETRY_SHORT_SET(wlc, ac, srl);
-		BRCMS_WME_RETRY_LONG_SET(wlc, ac, lrl);
+		wlc->wme_retries[ac] =	SFIELD(wlc->wme_retries[ac],
+					       EDCF_SHORT,  wlc->SRL);
+		wlc->wme_retries[ac] =	SFIELD(wlc->wme_retries[ac],
+					       EDCF_LONG, wlc->LRL);
 	}
 	brcms_c_wme_retries_write(wlc);
 
@@ -6400,8 +6379,8 @@ void brcms_c_statsupd(struct brcms_c_info *wlc)
 #endif				/* BCMDBG */
 
 	/* Read mac stats from contiguous shared memory */
-	brcms_b_copyfrom_shm(wlc->hw, M_UCODE_MACSTAT,
-			     &macstats, sizeof(struct macstat));
+	brcms_b_copyfrom_objmem(wlc->hw, M_UCODE_MACSTAT, &macstats,
+				sizeof(struct macstat), OBJADDR_SHM_SEL);
 
 #ifdef BCMDBG
 	/* check for rx fifo 0 overflow */
@@ -6719,7 +6698,7 @@ brcms_c_calc_ack_time(struct brcms_c_info *wlc, u32 rspec,
 	 * is less than or equal to the rate of the immediately previous
 	 * frame in the FES
 	 */
-	rspec = BRCMS_BASIC_RATE(wlc, rspec);
+	rspec = brcms_basic_rate(wlc, rspec);
 	/* ACK frame len == 14 == 2(fc) + 2(dur) + 6(ra) + 4(fcs) */
 	dur =
 	    brcms_c_calc_frame_time(wlc, rspec, preamble_type,
@@ -6747,7 +6726,7 @@ brcms_c_calc_ba_time(struct brcms_c_info *wlc, u32 rspec,
 	 * is less than or equal to the rate of the immediately previous
 	 * frame in the FES
 	 */
-	rspec = BRCMS_BASIC_RATE(wlc, rspec);
+	rspec = brcms_basic_rate(wlc, rspec);
 	/* BA len == 32 == 16(ctl hdr) + 4(ba len) + 8(bitmap) + 4(fcs) */
 	return brcms_c_calc_frame_time(wlc, rspec, preamble_type,
 				   (DOT11_BA_LEN + DOT11_BA_BITMAP_LEN +
@@ -6770,7 +6749,7 @@ brcms_c_compute_frame_dur(struct brcms_c_info *wlc, u32 rate,
 {
 	u16 dur, sifs;
 
-	sifs = SIFS(wlc->band);
+	sifs = get_sifs(wlc->band);
 
 	dur = sifs;
 	dur += (u16) brcms_c_calc_ack_time(wlc, rate, preamble_type);
@@ -7140,7 +7119,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			 * Is the phy configured to use 40MHZ frames? If
 			 * so then pick the desired txbw
 			 */
-			if (CHSPEC_WLC_BW(wlc->chanspec) == BRCMS_40_MHZ) {
+			if (brcms_chspec_bw(wlc->chanspec) == BRCMS_40_MHZ) {
 				/* default txbw is 20in40 SB */
 				mimo_ctlchbw = mimo_txbw =
 				   CHSPEC_SB_UPPER(wlc_phy_chanspec_get(
@@ -7458,15 +7437,15 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	txh->MainRates = cpu_to_le16(mainrates);
 
 	/* XtraFrameTypes */
-	xfts = FRAMETYPE(rspec[1], wlc->mimoft);
-	xfts |= (FRAMETYPE(rts_rspec[0], wlc->mimoft) << XFTS_RTS_FT_SHIFT);
-	xfts |= (FRAMETYPE(rts_rspec[1], wlc->mimoft) << XFTS_FBRRTS_FT_SHIFT);
+	xfts = frametype(rspec[1], wlc->mimoft);
+	xfts |= (frametype(rts_rspec[0], wlc->mimoft) << XFTS_RTS_FT_SHIFT);
+	xfts |= (frametype(rts_rspec[1], wlc->mimoft) << XFTS_FBRRTS_FT_SHIFT);
 	xfts |= CHSPEC_CHANNEL(wlc_phy_chanspec_get(wlc->band->pi)) <<
 							     XFTS_CHANNEL_SHIFT;
 	txh->XtraFrameTypes = cpu_to_le16(xfts);
 
 	/* PhyTxControlWord */
-	phyctl = FRAMETYPE(rspec[0], wlc->mimoft);
+	phyctl = frametype(rspec[0], wlc->mimoft);
 	if ((preamble_type[0] == BRCMS_SHORT_PREAMBLE) ||
 	    (preamble_type[0] == BRCMS_GF_PREAMBLE)) {
 		if (RSPEC2RATE(rspec[0]) != BRCM_RATE_1M)
@@ -7707,7 +7686,7 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	if (fifo == TX_BCMC_FIFO)
 		frameid = le16_to_cpu(txh->TxFrameID);
 
-	if (BRCMS_WAR16165(wlc))
+	if (wlc->war16165)
 		brcms_c_war16165(wlc, true);
 
 
@@ -7716,9 +7695,9 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	 * used, this will be handled in brcms_b_txfifo()
 	 */
 	if (commit) {
-		TXPKTPENDINC(wlc, fifo, txpktpend);
+		wlc->core->txpktpend[fifo] += txpktpend;
 		BCMMSG(wlc->wiphy, "pktpend inc %d to %d\n",
-			 txpktpend, TXPKTPENDGET(wlc, fifo));
+			 txpktpend, wlc->core->txpktpend[fifo]);
 	}
 
 	/* Commit BCMC sequence number in the SHM frame ID location */
@@ -7867,7 +7846,7 @@ brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 {
 	u16 dur, sifs;
 
-	sifs = SIFS(wlc->band);
+	sifs = get_sifs(wlc->band);
 
 	if (!cts_only) {
 		/* RTS/CTS */
@@ -7955,19 +7934,19 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 		rts_rspec = rspec;
 	else if (wlc->band->gmode && wlc->protection->_g && !IS_CCK(rspec))
 		/* Use 11Mbps as the g protection RTS target rate and fallback.
-		 * Use the BRCMS_BASIC_RATE() lookup to find the best basic rate
+		 * Use the brcms_basic_rate() lookup to find the best basic rate
 		 * under the target in case 11 Mbps is not Basic.
 		 * 6 and 9 Mbps are not usually selected by rate selection, but
 		 * even if the OFDM rate we are protecting is 6 or 9 Mbps, 11
 		 * is more robust.
 		 */
-		rts_rspec = BRCMS_BASIC_RATE(wlc, BRCM_RATE_11M);
+		rts_rspec = brcms_basic_rate(wlc, BRCM_RATE_11M);
 	else
 		/* calculate RTS rate and fallback rate based on the frame rate
 		 * RTS must be sent at a basic rate since it is a
 		 * control frame, sec 9.6 of 802.11 spec
 		 */
-		rts_rspec = BRCMS_BASIC_RATE(wlc, rspec);
+		rts_rspec = brcms_basic_rate(wlc, rspec);
 
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		/* set rts txbw to correct side band */
@@ -8043,7 +8022,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 	}
 
 	p = dma_getnexttxp(wlc->hw->di[queue], DMA_RANGE_TRANSMITTED);
-	if (BRCMS_WAR16165(wlc))
+	if (wlc->war16165)
 		brcms_c_war16165(wlc, false);
 	if (p == NULL)
 		goto fatal;
@@ -8103,8 +8082,10 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 		    fbl;
 
 		if (queue < AC_COUNT) {
-			sfbl = BRCMS_WME_RETRY_SFB_GET(wlc, wme_fifo2ac[queue]);
-			lfbl = BRCMS_WME_RETRY_LFB_GET(wlc, wme_fifo2ac[queue]);
+			sfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
+				      EDCF_SFB);
+			lfbl = GFIELD(wlc->wme_retries[wme_fifo2ac[queue]],
+				      EDCF_LFB);
 		} else {
 			sfbl = wlc->SFBL;
 			lfbl = wlc->LFBL;
@@ -8179,12 +8160,12 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, struct tx_status *txs, u32 frm_tx2)
 void
 brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 {
-	TXPKTPENDDEC(wlc, fifo, txpktpend);
+	wlc->core->txpktpend[fifo] -= txpktpend;
 	BCMMSG(wlc->wiphy, "pktpend dec %d to %d\n", txpktpend,
-		TXPKTPENDGET(wlc, fifo));
+	       wlc->core->txpktpend[fifo]);
 
 	/* There is more room; mark precedences related to this FIFO sendable */
-	BRCMS_TX_FIFO_ENAB(wlc, fifo);
+	wlc->tx_prec_map |= wlc->fifo2prec_map[fifo];
 
 	/* figure out which bsscfg is being worked on... */
 }
@@ -8774,10 +8755,10 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 	for (i = 0; i < rs.count; i++) {
 		rate = rs.rates[i] & BRCMS_RATE_MASK;
 
-		/* for a given rate BRCMS_BASIC_RATE returns the rate at
+		/* for a given rate brcms_basic_rate returns the rate at
 		 * which a response ACK/CTS should be sent.
 		 */
-		basic_rate = BRCMS_BASIC_RATE(wlc, rate);
+		basic_rate = brcms_basic_rate(wlc, rate);
 		if (basic_rate == 0)
 			/* This should only happen if we are using a
 			 * restricted rateset.
@@ -8835,7 +8816,7 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 	u16 dur, sifs;
 	uint i;
 
-	sifs = SIFS(wlc->band);
+	sifs = get_sifs(wlc->band);
 
 	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
 
@@ -9124,7 +9105,8 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 	/* return if insufficient dma resources */
 	if (*wlc->core->txavail[fifo] < MAX_DMA_SEGS) {
 		/* Mark precedences related to this FIFO, unsendable */
-		BRCMS_TX_FIFO_CLEAR(wlc, fifo);
+		/* A fifo is full. Clear precedences related to that FIFO */
+		wlc->tx_prec_map &= ~(wlc->fifo2prec_map[fifo]);
 		return -EBUSY;
 	}
 	return 0;
@@ -9153,7 +9135,7 @@ void brcms_default_rateset(struct brcms_c_info *wlc, struct brcms_c_rateset *rs)
 	brcms_c_rateset_default(rs, NULL, wlc->band->phytype,
 		wlc->band->bandtype, false, BRCMS_RATE_MASK_FULL,
 		(bool) (wlc->pub->_n_enab & SUPPORT_11N),
-		CHSPEC_WLC_BW(wlc->default_bss->chanspec),
+		brcms_chspec_bw(wlc->default_bss->chanspec),
 		wlc->stf->txstreams);
 }
 
@@ -9389,8 +9371,7 @@ void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 		brcmu_pktq_flush(&wlc->pkt_queue->q, false, NULL, NULL);
 
 	/* wait for queue and DMA fifos to run dry */
-	while (!pktq_empty(&wlc->pkt_queue->q) ||
-	       TXPKTPENDTOT(wlc) > 0)
+	while (!pktq_empty(&wlc->pkt_queue->q) || brcms_txpktpendtot(wlc) > 0)
 		brcms_msleep(wlc->wl, 1);
 }
 
-- 
1.7.4.1


