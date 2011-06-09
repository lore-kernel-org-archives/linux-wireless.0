Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:2255 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752979Ab1FIOp3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jun 2011 10:45:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 17/21] staging: brcm80211: replaced wlc_ by brcms_c_,
 part 2
Date: Thu, 9 Jun 2011 16:44:57 +0200
Message-ID: <1307630701-9170-18-git-send-email-rvossen@broadcom.com> (sfid-20110609_164539_926149_93EFA81F)
In-Reply-To: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
References: <1307630701-9170-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. Function renaming. Triggered by feedback comment from John
Linville, just like the other function renames that preceded this patch.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/alloc.c       |   38 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c       |    4 +-
 drivers/staging/brcm80211/brcmsmac/bmac.c        |  182 +++++----
 drivers/staging/brcm80211/brcmsmac/bmac.h        |    4 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c |    4 +-
 drivers/staging/brcm80211/brcmsmac/main.c        |  469 +++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    7 +-
 drivers/staging/brcm80211/brcmsmac/pub.h         |    2 +-
 8 files changed, 364 insertions(+), 346 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index dbf64d7..34eafbe 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -20,14 +20,14 @@
 #include "main.h"
 #include "alloc.h"
 
-static struct brcms_c_bsscfg *wlc_bsscfg_malloc(uint unit);
-static void wlc_bsscfg_mfree(struct brcms_c_bsscfg *cfg);
-static struct wlc_pub *wlc_pub_malloc(uint unit,
+static struct brcms_c_bsscfg *brcms_c_bsscfg_malloc(uint unit);
+static void brcms_c_bsscfg_mfree(struct brcms_c_bsscfg *cfg);
+static struct wlc_pub *brcms_c_pub_malloc(uint unit,
 				      uint *err, uint devid);
-static void wlc_pub_mfree(struct wlc_pub *pub);
-static void wlc_tunables_init(wlc_tunables_t *tunables, uint devid);
+static void brcms_c_pub_mfree(struct wlc_pub *pub);
+static void brcms_c_tunables_init(wlc_tunables_t *tunables, uint devid);
 
-static void wlc_tunables_init(wlc_tunables_t *tunables, uint devid)
+static void brcms_c_tunables_init(wlc_tunables_t *tunables, uint devid)
 {
 	tunables->ntxd = NTXD;
 	tunables->nrxd = NRXD;
@@ -45,7 +45,7 @@ static void wlc_tunables_init(wlc_tunables_t *tunables, uint devid)
 	tunables->txsbnd = TXSBND;
 }
 
-static struct wlc_pub *wlc_pub_malloc(uint unit, uint *err, uint devid)
+static struct wlc_pub *brcms_c_pub_malloc(uint unit, uint *err, uint devid)
 {
 	struct wlc_pub *pub;
 
@@ -62,7 +62,7 @@ static struct wlc_pub *wlc_pub_malloc(uint unit, uint *err, uint devid)
 	}
 
 	/* need to init the tunables now */
-	wlc_tunables_init(pub->tunables, devid);
+	brcms_c_tunables_init(pub->tunables, devid);
 
 	pub->multicast = kzalloc(ETH_ALEN * MAXMULTILIST, GFP_ATOMIC);
 	if (pub->multicast == NULL) {
@@ -73,11 +73,11 @@ static struct wlc_pub *wlc_pub_malloc(uint unit, uint *err, uint devid)
 	return pub;
 
  fail:
-	wlc_pub_mfree(pub);
+	brcms_c_pub_mfree(pub);
 	return NULL;
 }
 
-static void wlc_pub_mfree(struct wlc_pub *pub)
+static void brcms_c_pub_mfree(struct wlc_pub *pub)
 {
 	if (pub == NULL)
 		return;
@@ -87,7 +87,7 @@ static void wlc_pub_mfree(struct wlc_pub *pub)
 	kfree(pub);
 }
 
-static struct brcms_c_bsscfg *wlc_bsscfg_malloc(uint unit)
+static struct brcms_c_bsscfg *brcms_c_bsscfg_malloc(uint unit)
 {
 	struct brcms_c_bsscfg *cfg;
 
@@ -102,11 +102,11 @@ static struct brcms_c_bsscfg *wlc_bsscfg_malloc(uint unit)
 	return cfg;
 
  fail:
-	wlc_bsscfg_mfree(cfg);
+	brcms_c_bsscfg_mfree(cfg);
 	return NULL;
 }
 
-static void wlc_bsscfg_mfree(struct brcms_c_bsscfg *cfg)
+static void brcms_c_bsscfg_mfree(struct brcms_c_bsscfg *cfg)
 {
 	if (cfg == NULL)
 		return;
@@ -116,7 +116,7 @@ static void wlc_bsscfg_mfree(struct brcms_c_bsscfg *cfg)
 	kfree(cfg);
 }
 
-static void wlc_bsscfg_ID_assign(struct brcms_c_info *wlc,
+static void brcms_c_bsscfg_ID_assign(struct brcms_c_info *wlc,
 				 struct brcms_c_bsscfg *bsscfg)
 {
 	bsscfg->ID = wlc->next_bsscfg_ID;
@@ -137,7 +137,7 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	}
 
 	/* allocate struct brcms_c_pub state structure */
-	wlc->pub = wlc_pub_malloc(unit, err, devid);
+	wlc->pub = brcms_c_pub_malloc(unit, err, devid);
 	if (wlc->pub == NULL) {
 		*err = 1003;
 		goto fail;
@@ -181,12 +181,12 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		goto fail;
 	}
 
-	wlc->cfg = wlc_bsscfg_malloc(unit);
+	wlc->cfg = brcms_c_bsscfg_malloc(unit);
 	if (wlc->cfg == NULL) {
 		*err = 1011;
 		goto fail;
 	}
-	wlc_bsscfg_ID_assign(wlc, wlc->cfg);
+	brcms_c_bsscfg_ID_assign(wlc, wlc->cfg);
 
 	wlc->wsec_def_keys[0] =
 		kzalloc(sizeof(wsec_key_t) * WLC_DEFAULT_KEYS, GFP_ATOMIC);
@@ -255,8 +255,8 @@ void brcms_c_detach_mfree(struct brcms_c_info *wlc)
 	if (wlc == NULL)
 		return;
 
-	wlc_bsscfg_mfree(wlc->cfg);
-	wlc_pub_mfree(wlc->pub);
+	brcms_c_bsscfg_mfree(wlc->cfg);
+	brcms_c_pub_mfree(wlc->pub);
 	kfree(wlc->modulecb);
 	kfree(wlc->default_bss);
 	kfree(wlc->wsec_def_keys[0]);
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index b8c6002..74c4055 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -505,7 +505,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 
 		if (err) {
 			if (err == -EBUSY) {
-				wiphy_err(wiphy, "wl%d: wlc_sendampdu: "
+				wiphy_err(wiphy, "wl%d: sendampdu: "
 					  "prep_xdu retry; seq 0x%x\n",
 					  wlc->pub->unit, seq);
 				*pdu = p;
@@ -513,7 +513,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_c_txq_info *qi,
 			}
 
 			/* error in the packet; reject it */
-			wiphy_err(wiphy, "wl%d: wlc_sendampdu: prep_xdu "
+			wiphy_err(wiphy, "wl%d: sendampdu: prep_xdu "
 				  "rejected; seq 0x%x\n", wlc->pub->unit, seq);
 			*pdu = NULL;
 			break;
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.c b/drivers/staging/brcm80211/brcmsmac/bmac.c
index 7f88ea2..f8878c7 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.c
@@ -75,12 +75,12 @@ static void brcms_b_clkctl_clk(struct brcms_c_hw_info *wlc, uint mode);
 static void brcms_b_coreinit(struct brcms_c_info *wlc);
 
 /* used by wlc_wakeucode_init() */
-static void wlc_write_inits(struct brcms_c_hw_info *wlc_hw,
+static void brcms_c_write_inits(struct brcms_c_hw_info *wlc_hw,
 			    const struct d11init *inits);
-static void wlc_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
+static void brcms_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
 			    const uint nbytes);
-static void wlc_ucode_download(struct brcms_c_hw_info *wlc);
-static void wlc_ucode_txant_set(struct brcms_c_hw_info *wlc_hw);
+static void brcms_ucode_download(struct brcms_c_hw_info *wlc);
+static void brcms_c_ucode_txant_set(struct brcms_c_hw_info *wlc_hw);
 
 /* used by brcms_c_dpc() */
 static bool brcms_b_dotxstatus(struct brcms_c_hw_info *wlc, tx_status_t *txs,
@@ -90,10 +90,10 @@ static bool brcms_b_txstatus(struct brcms_c_hw_info *wlc, bool bound,
 static bool brcms_b_recv(struct brcms_c_hw_info *wlc_hw, uint fifo, bool bound);
 
 /* used by brcms_c_down() */
-static void wlc_flushqueues(struct brcms_c_info *wlc);
+static void brcms_c_flushqueues(struct brcms_c_info *wlc);
 
-static void wlc_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs);
-static void wlc_mctrl_reset(struct brcms_c_hw_info *wlc_hw);
+static void brcms_c_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs);
+static void brcms_c_mctrl_reset(struct brcms_c_hw_info *wlc_hw);
 static void brcms_b_corerev_fifofixup(struct brcms_c_hw_info *wlc_hw);
 static bool brcms_b_tx_fifo_suspended(struct brcms_c_hw_info *wlc_hw,
 				       uint tx_fifo);
@@ -113,31 +113,31 @@ static void brcms_b_write_objmem(struct brcms_c_hw_info *wlc_hw, uint offset,
 static void brcms_b_core_phy_clk(struct brcms_c_hw_info *wlc_hw, bool clk);
 static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme);
 static void brcms_b_detach_dmapio(struct brcms_c_hw_info *wlc_hw);
-static void wlc_ucode_bsinit(struct brcms_c_hw_info *wlc_hw);
-static bool wlc_validboardtype(struct brcms_c_hw_info *wlc);
-static bool wlc_isgoodchip(struct brcms_c_hw_info *wlc_hw);
+static void brcms_c_ucode_bsinit(struct brcms_c_hw_info *wlc_hw);
+static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc);
+static bool brcms_c_isgoodchip(struct brcms_c_hw_info *wlc_hw);
 static bool brcms_b_validate_chip_access(struct brcms_c_hw_info *wlc_hw);
-static char *wlc_get_macaddr(struct brcms_c_hw_info *wlc_hw);
-static void wlc_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init);
-static void wlc_mctrl_write(struct brcms_c_hw_info *wlc_hw);
+static char *brcms_c_get_macaddr(struct brcms_c_hw_info *wlc_hw);
+static void brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init);
+static void brcms_c_mctrl_write(struct brcms_c_hw_info *wlc_hw);
 static void brcms_b_mute(struct brcms_c_hw_info *wlc_hw, bool want,
 			 mbool flags);
-static void wlc_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw);
-static void wlc_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw);
-static u32 wlc_wlintrsoff(struct brcms_c_info *wlc);
-static void wlc_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask);
-static void wlc_gpio_init(struct brcms_c_info *wlc);
-static void wlc_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn,
-				      int len);
-static void wlc_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw, void *bcn,
-				      int len);
+static void brcms_c_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw);
+static void brcms_c_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw);
+static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc);
+static void brcms_c_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask);
+static void brcms_c_gpio_init(struct brcms_c_info *wlc);
+static void brcms_c_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw,
+					  void *bcn, int len);
+static void brcms_c_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw,
+					  void *bcn, int len);
 static void brcms_b_bsinit(struct brcms_c_info *wlc, chanspec_t chanspec);
-static u32 wlc_setband_inact(struct brcms_c_info *wlc, uint bandunit);
+static u32 brcms_c_setband_inact(struct brcms_c_info *wlc, uint bandunit);
 static void brcms_b_setband(struct brcms_c_hw_info *wlc_hw, uint bandunit,
 			     chanspec_t chanspec);
 static void brcms_b_update_slot_timing(struct brcms_c_hw_info *wlc_hw,
 					bool shortslot);
-static void wlc_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw);
+static void brcms_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw);
 static u16 brcms_b_ofdm_ratetable_offset(struct brcms_c_hw_info *wlc_hw,
 					     u8 rate);
 
@@ -177,17 +177,17 @@ static void brcms_b_update_slot_timing(struct brcms_c_hw_info *wlc_hw,
 	}
 }
 
-static void WLBANDINITFN(wlc_ucode_bsinit) (struct brcms_c_hw_info *wlc_hw)
+static void WLBANDINITFN(brcms_c_ucode_bsinit) (struct brcms_c_hw_info *wlc_hw)
 {
 	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	/* init microcode host flags */
-	wlc_write_mhf(wlc_hw, wlc_hw->band->mhfs);
+	brcms_c_write_mhf(wlc_hw, wlc_hw->band->mhfs);
 
 	/* do band-specific ucode IHR, SHM, and SCR inits */
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
 		if (WLCISNPHY(wlc_hw->band)) {
-			wlc_write_inits(wlc_hw, d11n0bsinitvals16);
+			brcms_c_write_inits(wlc_hw, d11n0bsinitvals16);
 		} else {
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
@@ -196,7 +196,8 @@ static void WLBANDINITFN(wlc_ucode_bsinit) (struct brcms_c_hw_info *wlc_hw)
 	} else {
 		if (D11REV_IS(wlc_hw->corerev, 24)) {
 			if (WLCISLCNPHY(wlc_hw->band)) {
-				wlc_write_inits(wlc_hw, d11lcn0bsinitvals24);
+				brcms_c_write_inits(wlc_hw,
+						    d11lcn0bsinitvals24);
 			} else
 				wiphy_err(wiphy, "%s: wl%d: unsupported phy in"
 					  " core rev %d\n", __func__,
@@ -209,7 +210,7 @@ static void WLBANDINITFN(wlc_ucode_bsinit) (struct brcms_c_hw_info *wlc_hw)
 }
 
 /* switch to new band but leave it inactive */
-static u32 WLBANDINITFN(wlc_setband_inact) (struct brcms_c_info *wlc,
+static u32 WLBANDINITFN(brcms_c_setband_inact) (struct brcms_c_info *wlc,
 					    uint bandunit)
 {
 	struct brcms_c_hw_info *wlc_hw = wlc->hw;
@@ -555,7 +556,7 @@ static bool brcms_b_attach_dmapio(struct brcms_c_info *wlc, uint j, bool wme)
 	}
 
 	/* initial ucode host flags */
-	wlc_mhfdef(wlc, wlc_hw->band->mhfs, pio_mhf2);
+	brcms_c_mhfdef(wlc, wlc_hw->band->mhfs, pio_mhf2);
 
 	return true;
 }
@@ -669,7 +670,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc->regs = wlc_hw->regs;
 
 	/* validate chip, chiprev and corerev */
-	if (!wlc_isgoodchip(wlc_hw)) {
+	if (!brcms_c_isgoodchip(wlc_hw)) {
 		err = 13;
 		goto fail;
 	}
@@ -698,7 +699,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	if (j == BOARDREV_PROMOTABLE)
 		j = BOARDREV_PROMOTED;
 	wlc_hw->boardrev = (u16) j;
-	if (!wlc_validboardtype(wlc_hw)) {
+	if (!brcms_c_validboardtype(wlc_hw)) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported Broadcom "
 			"board type (0x%x)" " or revision level (0x%x)\n",
 			 unit, wlc_hw->sih->boardtype, wlc_hw->boardrev);
@@ -876,8 +877,8 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 		ai_pci_down(wlc_hw->sih);
 
 	/* register sb interrupt callback functions */
-	ai_register_intr_callback(wlc_hw->sih, (void *)wlc_wlintrsoff,
-				  (void *)wlc_wlintrsrestore, NULL, wlc);
+	ai_register_intr_callback(wlc_hw->sih, (void *)brcms_c_wlintrsoff,
+				  (void *)brcms_c_wlintrsrestore, NULL, wlc);
 
 	/* turn off pll and xtal to match driver "down" state */
 	brcms_b_xtal(wlc_hw, OFF);
@@ -893,7 +894,7 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 	 */
 
 	/* init etheraddr state variables */
-	macaddr = wlc_get_macaddr(wlc_hw);
+	macaddr = brcms_c_get_macaddr(wlc_hw);
 	if (macaddr == NULL) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: macaddr not found\n",
 			  unit);
@@ -1007,7 +1008,7 @@ void brcms_b_reset(struct brcms_c_hw_info *wlc_hw)
 		brcms_b_corereset(wlc_hw, WLC_USE_COREFLAGS);
 
 	/* purge the dma rings */
-	wlc_flushqueues(wlc_hw->wlc);
+	brcms_c_flushqueues(wlc_hw->wlc);
 
 	brcms_c_reset_bmac_done(wlc_hw->wlc);
 }
@@ -1170,7 +1171,7 @@ int brcms_b_down_finish(struct brcms_c_hw_info *wlc_hw)
 		wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, false);
 
 		/* reclaim any posted packets */
-		wlc_flushqueues(wlc_hw->wlc);
+		brcms_c_flushqueues(wlc_hw->wlc);
 	} else {
 
 		/* Reset and disable the core */
@@ -1285,7 +1286,7 @@ static void brcms_b_clkctl_clk(struct brcms_c_hw_info *wlc_hw, uint mode)
 
 /* set initial host flags value */
 static void
-wlc_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
+brcms_c_mhfdef(struct brcms_c_info *wlc, u16 *mhfs, u16 mhf2_init)
 {
 	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 
@@ -1393,7 +1394,7 @@ u16 brcms_b_mhf_get(struct brcms_c_hw_info *wlc_hw, u8 idx, int bands)
 	return band->mhfs[idx];
 }
 
-static void wlc_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs)
+static void brcms_c_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs)
 {
 	u8 idx;
 	u16 addr[] = {
@@ -1409,7 +1410,7 @@ static void wlc_write_mhf(struct brcms_c_hw_info *wlc_hw, u16 *mhfs)
 /* set the maccontrol register to desired reset state and
  * initialize the sw cache of the register
  */
-static void wlc_mctrl_reset(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_mctrl_reset(struct brcms_c_hw_info *wlc_hw)
 {
 	/* IHR accesses are always enabled, PSM disabled, HPS off and WAKE on */
 	wlc_hw->maccontrol = 0;
@@ -1438,11 +1439,11 @@ void brcms_b_mctrl(struct brcms_c_hw_info *wlc_hw, u32 mask, u32 val)
 	wlc_hw->maccontrol = new_maccontrol;
 
 	/* write the new values with overrides applied */
-	wlc_mctrl_write(wlc_hw);
+	brcms_c_mctrl_write(wlc_hw);
 }
 
 /* write the software state of maccontrol and overrides to the maccontrol register */
-static void wlc_mctrl_write(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_mctrl_write(struct brcms_c_hw_info *wlc_hw)
 {
 	u32 maccontrol = wlc_hw->maccontrol;
 
@@ -1459,7 +1460,7 @@ static void wlc_mctrl_write(struct brcms_c_hw_info *wlc_hw)
 	W_REG(&wlc_hw->regs->maccontrol, maccontrol);
 }
 
-void wlc_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
+void brcms_c_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
 				 u32 override_bit)
 {
 	if (wlc_hw->wake_override || (wlc_hw->maccontrol & MCTL_WAKE)) {
@@ -1469,13 +1470,13 @@ void wlc_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
 
 	mboolset(wlc_hw->wake_override, override_bit);
 
-	wlc_mctrl_write(wlc_hw);
+	brcms_c_mctrl_write(wlc_hw);
 	brcms_b_wait_for_wake(wlc_hw);
 
 	return;
 }
 
-void wlc_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
+void brcms_c_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
 				   u32 override_bit)
 {
 	mboolclr(wlc_hw->wake_override, override_bit);
@@ -1483,7 +1484,7 @@ void wlc_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
 	if (wlc_hw->wake_override || (wlc_hw->maccontrol & MCTL_WAKE))
 		return;
 
-	wlc_mctrl_write(wlc_hw);
+	brcms_c_mctrl_write(wlc_hw);
 
 	return;
 }
@@ -1495,7 +1496,7 @@ void wlc_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
  * STA               0              1 <--- This will ensure no beacons
  * IBSS              0              0
  */
-static void wlc_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw)
 {
 	wlc_hw->mute_override = 1;
 
@@ -1505,13 +1506,13 @@ static void wlc_ucode_mute_override_set(struct brcms_c_hw_info *wlc_hw)
 	if ((wlc_hw->maccontrol & (MCTL_AP | MCTL_INFRA)) == MCTL_INFRA)
 		return;
 
-	wlc_mctrl_write(wlc_hw);
+	brcms_c_mctrl_write(wlc_hw);
 
 	return;
 }
 
 /* Clear the override on AP and INFRA bits */
-static void wlc_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw)
 {
 	if (wlc_hw->mute_override == 0)
 		return;
@@ -1524,7 +1525,7 @@ static void wlc_ucode_mute_override_clear(struct brcms_c_hw_info *wlc_hw)
 	if ((wlc_hw->maccontrol & (MCTL_AP | MCTL_INFRA)) == MCTL_INFRA)
 		return;
 
-	wlc_mctrl_write(wlc_hw);
+	brcms_c_mctrl_write(wlc_hw);
 }
 
 /*
@@ -1626,7 +1627,8 @@ void brcms_b_bw_set(struct brcms_c_hw_info *wlc_hw, u16 bw)
 }
 
 static void
-wlc_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn, int len)
+brcms_c_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn,
+			      int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
 
@@ -1639,7 +1641,8 @@ wlc_write_hw_bcntemplate0(struct brcms_c_hw_info *wlc_hw, void *bcn, int len)
 }
 
 static void
-wlc_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw, void *bcn, int len)
+brcms_c_write_hw_bcntemplate1(struct brcms_c_hw_info *wlc_hw, void *bcn,
+			      int len)
 {
 	d11regs_t *regs = wlc_hw->regs;
 
@@ -1659,16 +1662,16 @@ brcms_b_write_hw_bcntemplates(struct brcms_c_hw_info *wlc_hw, void *bcn,
 	d11regs_t *regs = wlc_hw->regs;
 
 	if (both) {
-		wlc_write_hw_bcntemplate0(wlc_hw, bcn, len);
-		wlc_write_hw_bcntemplate1(wlc_hw, bcn, len);
+		brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
+		brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
 	} else {
 		/* bcn 0 */
 		if (!(R_REG(&regs->maccommand) & MCMD_BCN0VLD))
-			wlc_write_hw_bcntemplate0(wlc_hw, bcn, len);
+			brcms_c_write_hw_bcntemplate0(wlc_hw, bcn, len);
 		/* bcn 1 */
 		else if (!
 			 (R_REG(&regs->maccommand) & MCMD_BCN1VLD))
-			wlc_write_hw_bcntemplate1(wlc_hw, bcn, len);
+			brcms_c_write_hw_bcntemplate1(wlc_hw, bcn, len);
 	}
 }
 
@@ -1698,11 +1701,11 @@ WLBANDINITFN(brcms_b_bsinit) (struct brcms_c_info *wlc, chanspec_t chanspec)
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n", wlc_hw->unit,
 		wlc_hw->band->bandunit);
 
-	wlc_ucode_bsinit(wlc_hw);
+	brcms_c_ucode_bsinit(wlc_hw);
 
 	wlc_phy_init(wlc_hw->band->pi, chanspec);
 
-	wlc_ucode_txant_set(wlc_hw);
+	brcms_c_ucode_txant_set(wlc_hw);
 
 	/* cwmin is band-specific, update hardware with value for current band */
 	brcms_b_set_cwmin(wlc_hw, wlc_hw->band->CWmin);
@@ -1718,7 +1721,7 @@ WLBANDINITFN(brcms_b_bsinit) (struct brcms_c_info *wlc, chanspec_t chanspec)
 	brcms_b_write_shm(wlc_hw, M_PHYVER, (u16) wlc_hw->band->phyrev);
 
 	/* initialize the txphyctl1 rate table since shmem is shared between bands */
-	wlc_upd_ofdm_pctl1_table(wlc_hw);
+	brcms_upd_ofdm_pctl1_table(wlc_hw);
 
 	brcms_b_upd_synthpu(wlc_hw);
 }
@@ -1842,10 +1845,10 @@ WLBANDINITFN(brcms_b_setband) (struct brcms_c_hw_info *wlc_hw, uint bandunit,
 	/* Enable the d11 core before accessing it */
 	if (!ai_iscoreup(wlc_hw->sih)) {
 		ai_core_reset(wlc_hw->sih, 0, 0);
-		wlc_mctrl_reset(wlc_hw);
+		brcms_c_mctrl_reset(wlc_hw);
 	}
 
-	macintmask = wlc_setband_inact(wlc, bandunit);
+	macintmask = brcms_c_setband_inact(wlc, bandunit);
 
 	if (!wlc_hw->up)
 		return;
@@ -1889,7 +1892,7 @@ void WLBANDINITFN(brcms_c_setxband) (struct brcms_c_hw_info *wlc_hw,
 	}
 }
 
-static bool wlc_isgoodchip(struct brcms_c_hw_info *wlc_hw)
+static bool brcms_c_isgoodchip(struct brcms_c_hw_info *wlc_hw)
 {
 
 	/* reject unsupported corerev */
@@ -1902,7 +1905,7 @@ static bool wlc_isgoodchip(struct brcms_c_hw_info *wlc_hw)
 	return true;
 }
 
-static bool wlc_validboardtype(struct brcms_c_hw_info *wlc_hw)
+static bool brcms_c_validboardtype(struct brcms_c_hw_info *wlc_hw)
 {
 	bool goodboard = true;
 	uint boardrev = wlc_hw->boardrev;
@@ -1926,7 +1929,7 @@ static bool wlc_validboardtype(struct brcms_c_hw_info *wlc_hw)
 	return goodboard;
 }
 
-static char *wlc_get_macaddr(struct brcms_c_hw_info *wlc_hw)
+static char *brcms_c_get_macaddr(struct brcms_c_hw_info *wlc_hw)
 {
 	const char *varname = "macaddr";
 	char *macaddr;
@@ -1983,7 +1986,7 @@ bool brcms_b_radio_read_hwdisabled(struct brcms_c_hw_info *wlc_hw)
 			    (d11regs_t *) ai_setcore(wlc_hw->sih, D11_CORE_ID,
 						     0);
 		ai_core_reset(wlc_hw->sih, flags, resetbits);
-		wlc_mctrl_reset(wlc_hw);
+		brcms_c_mctrl_reset(wlc_hw);
 	}
 
 	v = ((R_REG(&wlc_hw->regs->phydebug) & PDBG_RFD) != 0);
@@ -2117,7 +2120,7 @@ void brcms_b_corereset(struct brcms_c_hw_info *wlc_hw, u32 flags)
 	if (wlc_hw->band && wlc_hw->band->pi)
 		wlc_phy_hw_clk_state_upd(wlc_hw->band->pi, true);
 
-	wlc_mctrl_reset(wlc_hw);
+	brcms_c_mctrl_reset(wlc_hw);
 
 	if (PMUCTL_ENAB(wlc_hw->sih))
 		brcms_b_clkctl_clk(wlc_hw, CLK_FAST);
@@ -2212,7 +2215,7 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 	/* reset PSM */
 	brcms_b_mctrl(wlc_hw, ~0, (MCTL_IHR_EN | MCTL_PSM_JMP_0 | MCTL_WAKE));
 
-	wlc_ucode_download(wlc_hw);
+	brcms_ucode_download(wlc_hw);
 	/*
 	 * FIFOSZ fixup. driver wants to controls the fifo allocation.
 	 */
@@ -2230,20 +2233,20 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 		wiphy_err(wiphy, "wl%d: wlc_coreinit: ucode did not self-"
 			  "suspend!\n", wlc_hw->unit);
 
-	wlc_gpio_init(wlc);
+	brcms_c_gpio_init(wlc);
 
 	sflags = ai_core_sflags(wlc_hw->sih, 0, 0);
 
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
 		if (WLCISNPHY(wlc_hw->band))
-			wlc_write_inits(wlc_hw, d11n0initvals16);
+			brcms_c_write_inits(wlc_hw, d11n0initvals16);
 		else
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (WLCISLCNPHY(wlc_hw->band)) {
-			wlc_write_inits(wlc_hw, d11lcn0initvals24);
+			brcms_c_write_inits(wlc_hw, d11lcn0initvals24);
 		} else {
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
@@ -2412,7 +2415,7 @@ void brcms_b_switch_macfreq(struct brcms_c_hw_info *wlc_hw, u8 spurmode)
 }
 
 /* Initialize GPIOs that are controlled by D11 core */
-static void wlc_gpio_init(struct brcms_c_info *wlc)
+static void brcms_c_gpio_init(struct brcms_c_info *wlc)
 {
 	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs;
@@ -2474,7 +2477,7 @@ static void wlc_gpio_init(struct brcms_c_info *wlc)
 	ai_gpiocontrol(wlc_hw->sih, gm, gc, GPIO_DRV_PRIORITY);
 }
 
-static void wlc_ucode_download(struct brcms_c_hw_info *wlc_hw)
+static void brcms_ucode_download(struct brcms_c_hw_info *wlc_hw)
 {
 	struct brcms_c_info *wlc;
 	wlc = wlc_hw->wlc;
@@ -2484,7 +2487,7 @@ static void wlc_ucode_download(struct brcms_c_hw_info *wlc_hw)
 
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
 		if (WLCISNPHY(wlc_hw->band)) {
-			wlc_ucode_write(wlc_hw, bcm43xx_16_mimo,
+			brcms_ucode_write(wlc_hw, bcm43xx_16_mimo,
 					bcm43xx_16_mimosz);
 			wlc_hw->ucode_loaded = true;
 		} else
@@ -2493,7 +2496,7 @@ static void wlc_ucode_download(struct brcms_c_hw_info *wlc_hw)
 				  __func__, wlc_hw->unit, wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (WLCISLCNPHY(wlc_hw->band)) {
-			wlc_ucode_write(wlc_hw, bcm43xx_24_lcn,
+			brcms_ucode_write(wlc_hw, bcm43xx_24_lcn,
 					bcm43xx_24_lcnsz);
 			wlc_hw->ucode_loaded = true;
 		} else {
@@ -2504,7 +2507,7 @@ static void wlc_ucode_download(struct brcms_c_hw_info *wlc_hw)
 	}
 }
 
-static void wlc_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
+static void brcms_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
 			      const uint nbytes) {
 	d11regs_t *regs = wlc_hw->regs;
 	uint i;
@@ -2520,7 +2523,7 @@ static void wlc_ucode_write(struct brcms_c_hw_info *wlc_hw, const u32 ucode[],
 		W_REG(&regs->objdata, ucode[i]);
 }
 
-static void wlc_write_inits(struct brcms_c_hw_info *wlc_hw,
+static void brcms_c_write_inits(struct brcms_c_hw_info *wlc_hw,
 			    const struct d11init *inits)
 {
 	int i;
@@ -2540,7 +2543,7 @@ static void wlc_write_inits(struct brcms_c_hw_info *wlc_hw,
 	}
 }
 
-static void wlc_ucode_txant_set(struct brcms_c_hw_info *wlc_hw)
+static void brcms_c_ucode_txant_set(struct brcms_c_hw_info *wlc_hw)
 {
 	u16 phyctl;
 	u16 phytxant = wlc_hw->bmac_phytxant;
@@ -2565,7 +2568,7 @@ void brcms_b_txant_set(struct brcms_c_hw_info *wlc_hw, u16 phytxant)
 	/* push to ucode if up */
 	if (!wlc_hw->up)
 		return;
-	wlc_ucode_txant_set(wlc_hw);
+	brcms_c_ucode_txant_set(wlc_hw);
 
 }
 
@@ -2658,7 +2661,7 @@ void brcms_c_intrson(struct brcms_c_info *wlc)
  *  but also because per-port code may require sync with valid interrupt.
  */
 
-static u32 wlc_wlintrsoff(struct brcms_c_info *wlc)
+static u32 brcms_c_wlintrsoff(struct brcms_c_info *wlc)
 {
 	if (!wlc->hw->up)
 		return 0;
@@ -2666,7 +2669,7 @@ static u32 wlc_wlintrsoff(struct brcms_c_info *wlc)
 	return brcms_intrsoff(wlc->wl);
 }
 
-static void wlc_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask)
+static void brcms_c_wlintrsrestore(struct brcms_c_info *wlc, u32 macintmask)
 {
 	if (!wlc->hw->up)
 		return;
@@ -2734,9 +2737,9 @@ static void brcms_b_mute(struct brcms_c_hw_info *wlc_hw, bool on, mbool flags)
 	wlc_phy_mute_upd(wlc_hw->band->pi, on, flags);
 
 	if (on)
-		wlc_ucode_mute_override_set(wlc_hw);
+		brcms_c_ucode_mute_override_set(wlc_hw);
 	else
-		wlc_ucode_mute_override_clear(wlc_hw);
+		brcms_c_ucode_mute_override_clear(wlc_hw);
 }
 
 int brcms_b_xmtfifo_sz_get(struct brcms_c_hw_info *wlc_hw, uint fifo,
@@ -2792,7 +2795,8 @@ static void brcms_b_tx_fifo_suspend(struct brcms_c_hw_info *wlc_hw,
 
 	/* force the core awake only if not already */
 	if (wlc_hw->suspended_fifos == 0)
-		wlc_ucode_wake_override_set(wlc_hw, WLC_WAKE_OVERRIDE_TXFIFO);
+		brcms_c_ucode_wake_override_set(wlc_hw,
+						WLC_WAKE_OVERRIDE_TXFIFO);
 
 	wlc_hw->suspended_fifos |= fifo;
 
@@ -2828,7 +2832,7 @@ static void brcms_b_tx_fifo_resume(struct brcms_c_hw_info *wlc_hw,
 	else {
 		wlc_hw->suspended_fifos &= ~(1 << tx_fifo);
 		if (wlc_hw->suspended_fifos == 0)
-			wlc_ucode_wake_override_clear(wlc_hw,
+			brcms_c_ucode_wake_override_clear(wlc_hw,
 						      WLC_WAKE_OVERRIDE_TXFIFO);
 	}
 }
@@ -3043,7 +3047,7 @@ void brcms_c_suspend_mac_and_wait(struct brcms_c_info *wlc)
 		return;
 
 	/* force the core awake */
-	wlc_ucode_wake_override_set(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
+	brcms_c_ucode_wake_override_set(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
 
 	mc = R_REG(&regs->maccontrol);
 
@@ -3126,10 +3130,10 @@ void brcms_c_enable_mac(struct brcms_c_info *wlc)
 	mi = R_REG(&regs->macintstatus);
 	WARN_ON(mi & MI_MACSSPNDD);
 
-	wlc_ucode_wake_override_clear(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
+	brcms_c_ucode_wake_override_clear(wlc_hw, WLC_WAKE_OVERRIDE_MACSUSPEND);
 }
 
-static void wlc_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw)
+static void brcms_upd_ofdm_pctl1_table(struct brcms_c_hw_info *wlc_hw)
 {
 	u8 rate;
 	u8 rates[8] = {
@@ -3202,7 +3206,7 @@ void brcms_b_band_stf_ss_set(struct brcms_c_hw_info *wlc_hw, u8 stf_mode)
 	wlc_hw->hw_stf_ss_opmode = stf_mode;
 
 	if (wlc_hw->clk)
-		wlc_upd_ofdm_pctl1_table(wlc_hw);
+		brcms_upd_ofdm_pctl1_table(wlc_hw);
 }
 
 void
@@ -3392,7 +3396,7 @@ static void brcms_b_xtal(struct brcms_c_hw_info *wlc_hw, bool want)
 	}
 }
 
-static void wlc_flushqueues(struct brcms_c_info *wlc)
+static void brcms_c_flushqueues(struct brcms_c_info *wlc)
 {
 	struct brcms_c_hw_info *wlc_hw = wlc->hw;
 	uint i;
diff --git a/drivers/staging/brcm80211/brcmsmac/bmac.h b/drivers/staging/brcm80211/brcmsmac/bmac.h
index 693d342..3a1ee78 100644
--- a/drivers/staging/brcm80211/brcmsmac/bmac.h
+++ b/drivers/staging/brcm80211/brcmsmac/bmac.h
@@ -139,9 +139,9 @@ extern void brcms_b_band_stf_ss_set(struct brcms_c_hw_info *wlc_hw,
 
 extern void brcms_b_wait_for_wake(struct brcms_c_hw_info *wlc_hw);
 
-extern void wlc_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_c_ucode_wake_override_set(struct brcms_c_hw_info *wlc_hw,
 					u32 override_bit);
-extern void wlc_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
+extern void brcms_c_ucode_wake_override_clear(struct brcms_c_hw_info *wlc_hw,
 					  u32 override_bit);
 
 extern void brcms_b_set_addrmatch(struct brcms_c_hw_info *wlc_hw,
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index 0dd01d0..73e60df 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -801,7 +801,7 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 			     wl->regsva, wl->bcm_bustype, btparam, &err);
 	brcms_release_fw(wl);
 	if (!wl->wlc) {
-		wiphy_err(wl->wiphy, "%s: wlc_attach() failed with code %d\n",
+		wiphy_err(wl->wiphy, "%s: attach() failed with code %d\n",
 			  KBUILD_MODNAME, err);
 		goto fail;
 	}
@@ -1241,7 +1241,7 @@ static void brcms_remove(struct pci_dev *pdev)
 	status = brcms_c_chipmatch(pdev->vendor, pdev->device);
 	UNLOCK(wl);
 	if (!status) {
-		wiphy_err(wl->wiphy, "wl: brcms_remove: wlc_chipmatch "
+		wiphy_err(wl->wiphy, "wl: brcms_remove: chipmatch "
 				     "failed\n");
 		return;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index 1df1178..e2d8d23 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -304,7 +304,7 @@ static const u8 acbitmap2maxprio[] = {
 #define WLC_REPLAY_CNTRS_VALUE	WPA_CAP_16_REPLAY_CNTRS
 
 /* local prototypes */
-static u16 wlc_d11hdrs_mac80211(struct brcms_c_info *wlc,
+static u16 brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc,
 					       struct ieee80211_hw *hw,
 					       struct sk_buff *p,
 					       struct scb *scb, uint frag,
@@ -312,72 +312,73 @@ static u16 wlc_d11hdrs_mac80211(struct brcms_c_info *wlc,
 					       uint next_frag_len,
 					       wsec_key_t *key,
 					       ratespec_t rspec_override);
-static void wlc_bss_default_init(struct brcms_c_info *wlc);
-static void wlc_ucode_mac_upd(struct brcms_c_info *wlc);
+static void brcms_c_bss_default_init(struct brcms_c_info *wlc);
+static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc);
 static ratespec_t mac80211_wlc_set_nrate(struct brcms_c_info *wlc,
 					 struct brcms_c_band *cur_band,
 					 u32 int_val);
-static void wlc_tx_prec_map_init(struct brcms_c_info *wlc);
-static void wlc_watchdog(void *arg);
-static void wlc_watchdog_by_timer(void *arg);
-static u16 wlc_rate_shm_offset(struct brcms_c_info *wlc, u8 rate);
-static int wlc_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg);
-static u8 wlc_local_constraint_qdbm(struct brcms_c_info *wlc);
+static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc);
+static void brcms_c_watchdog(void *arg);
+static void brcms_c_watchdog_by_timer(void *arg);
+static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate);
+static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg);
+static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc);
 
 /* send and receive */
-static struct brcms_c_txq_info *wlc_txq_alloc(struct brcms_c_info *wlc);
-static void wlc_txq_free(struct brcms_c_info *wlc,
+static struct brcms_c_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc);
+static void brcms_c_txq_free(struct brcms_c_info *wlc,
 			 struct brcms_c_txq_info *qi);
-static void wlc_txflowcontrol_signal(struct brcms_c_info *wlc,
+static void brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
 				     struct brcms_c_txq_info *qi,
 				     bool on, int prio);
-static void wlc_txflowcontrol_reset(struct brcms_c_info *wlc);
-static void wlc_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rate,
+static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc);
+static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rate,
 				 uint length, u8 *plcp);
-static void wlc_compute_ofdm_plcp(ratespec_t rate, uint length, u8 *plcp);
-static void wlc_compute_mimo_plcp(ratespec_t rate, uint length, u8 *plcp);
-static u16 wlc_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
+static void brcms_c_compute_ofdm_plcp(ratespec_t rate, uint length, u8 *plcp);
+static void brcms_c_compute_mimo_plcp(ratespec_t rate, uint length, u8 *plcp);
+static u16 brcms_c_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
 				    u8 preamble_type, uint next_frag_len);
-static u64 wlc_recover_tsf64(struct brcms_c_info *wlc,
+static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
 			     struct wlc_d11rxhdr *rxh);
-static void wlc_recvctl(struct brcms_c_info *wlc,
+static void brcms_c_recvctl(struct brcms_c_info *wlc,
 			d11rxhdr_t *rxh, struct sk_buff *p);
-static uint wlc_calc_frame_len(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_frame_len(struct brcms_c_info *wlc, ratespec_t rate,
 			       u8 preamble_type, uint dur);
-static uint wlc_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rate,
 			      u8 preamble_type);
-static uint wlc_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rate,
 			      u8 preamble_type);
 /* interrupt, up/down, band */
-static void wlc_setband(struct brcms_c_info *wlc, uint bandunit);
-static chanspec_t wlc_init_chanspec(struct brcms_c_info *wlc);
-static void wlc_bandinit_ordered(struct brcms_c_info *wlc, chanspec_t chanspec);
-static void wlc_bsinit(struct brcms_c_info *wlc);
-static int wlc_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle,
+static void brcms_c_setband(struct brcms_c_info *wlc, uint bandunit);
+static chanspec_t brcms_c_init_chanspec(struct brcms_c_info *wlc);
+static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
+				     chanspec_t chanspec);
+static void brcms_c_bsinit(struct brcms_c_info *wlc);
+static int brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle,
 			      bool isOFDM, bool writeToShm);
-static void wlc_radio_hwdisable_upd(struct brcms_c_info *wlc);
-static bool wlc_radio_monitor_start(struct brcms_c_info *wlc);
-static void wlc_radio_timer(void *arg);
-static void wlc_radio_enable(struct brcms_c_info *wlc);
-static void wlc_radio_upd(struct brcms_c_info *wlc);
+static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc);
+static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc);
+static void brcms_c_radio_timer(void *arg);
+static void brcms_c_radio_enable(struct brcms_c_info *wlc);
+static void brcms_c_radio_upd(struct brcms_c_info *wlc);
 
 /* scan, association, BSS */
-static uint wlc_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rate,
+static uint brcms_c_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rate,
 			     u8 preamble_type);
-static void wlc_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap);
-static void wlc_ht_update_sgi_rx(struct brcms_c_info *wlc, int val);
-static void wlc_ht_update_ldpc(struct brcms_c_info *wlc, s8 val);
-static void wlc_war16165(struct brcms_c_info *wlc, bool tx);
-
-static void wlc_wme_retries_write(struct brcms_c_info *wlc);
-static bool wlc_attach_stf_ant_init(struct brcms_c_info *wlc);
-static uint wlc_attach_module(struct brcms_c_info *wlc);
-static void wlc_detach_module(struct brcms_c_info *wlc);
-static void wlc_timers_deinit(struct brcms_c_info *wlc);
-static void wlc_down_led_upd(struct brcms_c_info *wlc);
-static uint wlc_down_del_timer(struct brcms_c_info *wlc);
-static void wlc_ofdm_rateset_war(struct brcms_c_info *wlc);
-static int _wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
+static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap);
+static void brcms_c_ht_update_sgi_rx(struct brcms_c_info *wlc, int val);
+static void brcms_c_ht_update_ldpc(struct brcms_c_info *wlc, s8 val);
+static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx);
+
+static void brcms_c_wme_retries_write(struct brcms_c_info *wlc);
+static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc);
+static uint brcms_c_attach_module(struct brcms_c_info *wlc);
+static void brcms_c_detach_module(struct brcms_c_info *wlc);
+static void brcms_c_timers_deinit(struct brcms_c_info *wlc);
+static void brcms_c_down_led_upd(struct brcms_c_info *wlc);
+static uint brcms_c_down_del_timer(struct brcms_c_info *wlc);
+static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc);
+static int _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 		      struct brcms_c_if *wlcif);
 
 /* conditions under which the PM bit should be set in outgoing frames and STAY_AWAKE is meaningful
@@ -433,7 +434,7 @@ void brcms_c_fatal_error(struct brcms_c_info *wlc)
  * if other configurations are in conflict (bandlocked, 11n mode disabled,
  * invalid channel for current country, etc.)
  */
-static chanspec_t wlc_init_chanspec(struct brcms_c_info *wlc)
+static chanspec_t brcms_c_init_chanspec(struct brcms_c_info *wlc)
 {
 	chanspec_t chanspec =
 	    1 | WL_CHANSPEC_BW_20 | WL_CHANSPEC_CTL_SB_NONE |
@@ -444,7 +445,7 @@ static chanspec_t wlc_init_chanspec(struct brcms_c_info *wlc)
 
 struct scb global_scb;
 
-static void wlc_init_scb(struct brcms_c_info *wlc, struct scb *scb)
+static void brcms_c_init_scb(struct brcms_c_info *wlc, struct scb *scb)
 {
 	int i;
 	scb->flags = SCB_WMECAP | SCB_HTCAP;
@@ -470,7 +471,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	if (wlc->pub->associated)
 		chanspec = wlc->home_chanspec;
 	else
-		chanspec = wlc_init_chanspec(wlc);
+		chanspec = brcms_c_init_chanspec(wlc);
 
 	brcms_b_init(wlc->hw, chanspec, mute);
 
@@ -509,9 +510,9 @@ void brcms_c_init(struct brcms_c_info *wlc)
 		}
 	}
 
-	wlc_bandinit_ordered(wlc, chanspec);
+	brcms_c_bandinit_ordered(wlc, chanspec);
 
-	wlc_init_scb(wlc, &global_scb);
+	brcms_c_init_scb(wlc, &global_scb);
 
 	/* init probe response timeout */
 	brcms_c_write_shm(wlc, M_PRS_MAXTIME, wlc->prb_resp_timeout);
@@ -522,14 +523,14 @@ void brcms_c_init(struct brcms_c_info *wlc)
 		       _rifs ? (EDCF_AC_VO_TXOP_AP << 5) : MAXFRAMEBURST_TXOP));
 
 	/* initialize maximum allowed duty cycle */
-	wlc_duty_cycle_set(wlc, wlc->tx_duty_cycle_ofdm, true, true);
-	wlc_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
+	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_ofdm, true, true);
+	brcms_c_duty_cycle_set(wlc, wlc->tx_duty_cycle_cck, false, true);
 
 	/* Update some shared memory locations related to max AMPDU size allowed to received */
 	brcms_c_ampdu_shm_upd(wlc->ampdu);
 
 	/* band-specific inits */
-	wlc_bsinit(wlc);
+	brcms_c_bsinit(wlc);
 
 	/* Enable EDCF mode (while the MAC is suspended) */
 	if (EDCF_ENAB(wlc->pub)) {
@@ -538,7 +539,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	}
 
 	/* Init precedence maps for empty FIFOs */
-	wlc_tx_prec_map_init(wlc);
+	brcms_c_tx_prec_map_init(wlc);
 
 	/* read the ucode version if we have not yet done so */
 	if (wlc->ucode_rev == 0) {
@@ -551,7 +552,7 @@ void brcms_c_init(struct brcms_c_info *wlc)
 	brcms_c_enable_mac(wlc);
 
 	/* clear tx flow control */
-	wlc_txflowcontrol_reset(wlc);
+	brcms_c_txflowcontrol_reset(wlc);
 
 	/* clear tx data fifo suspends */
 	wlc->tx_suspended = false;
@@ -670,7 +671,7 @@ void brcms_c_set_bssid(struct brcms_c_bsscfg *cfg)
 	}
 #ifdef SUPPORT_HWKEYS
 	else if (BSSCFG_STA(cfg) && cfg->BSS) {
-		wlc_rcmta_add_bssid(wlc, cfg);
+		brcms_c_rcmta_add_bssid(wlc, cfg);
 	}
 #endif
 }
@@ -707,7 +708,7 @@ void brcms_c_switch_shortslot(struct brcms_c_info *wlc, bool shortslot)
 	brcms_b_set_shortslot(wlc->hw, shortslot);
 }
 
-static u8 wlc_local_constraint_qdbm(struct brcms_c_info *wlc)
+static u8 brcms_c_local_constraint_qdbm(struct brcms_c_info *wlc)
 {
 	u8 local;
 	s16 local_max;
@@ -752,7 +753,8 @@ void brcms_c_set_home_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 	}
 }
 
-static void wlc_set_phy_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
+static void brcms_c_set_phy_chanspec(struct brcms_c_info *wlc,
+				     chanspec_t chanspec)
 {
 	/* Save our copy of the chanspec */
 	wlc->chanspec = chanspec;
@@ -761,7 +763,7 @@ static void wlc_set_phy_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 	 * any 11h local tx power constraints.
 	 */
 	brcms_c_channel_set_chanspec(wlc->cmi, chanspec,
-				 wlc_local_constraint_qdbm(wlc));
+				 brcms_c_local_constraint_qdbm(wlc));
 
 	if (wlc->stf->ss_algosel_auto)
 		brcms_c_stf_ss_algo_channel_get(wlc, &wlc->stf->ss_algo_channel,
@@ -798,17 +800,17 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 			/*
 			 * should the setband call come after the
 			 * brcms_b_chanspec() ? if the setband updates
-			 * (wlc_bsinit) use low level calls to inspect and
+			 * (brcms_c_bsinit) use low level calls to inspect and
 			 * set state, the state inspected may be from the wrong
 			 * band, or the following brcms_b_set_chanspec() may
 			 * undo the work.
 			 */
-			wlc_setband(wlc, bandunit);
+			brcms_c_setband(wlc, bandunit);
 		}
 	}
 
 	/* sync up phy/radio chanspec */
-	wlc_set_phy_chanspec(wlc, chanspec);
+	brcms_c_set_phy_chanspec(wlc, chanspec);
 
 	/* init antenna selection */
 	if (CHSPEC_WLC_BW(old_chanspec) != CHSPEC_WLC_BW(chanspec)) {
@@ -824,7 +826,7 @@ void brcms_c_set_chanspec(struct brcms_c_info *wlc, chanspec_t chanspec)
 	}
 
 	/* update some mac configuration since chanspec changed */
-	wlc_ucode_mac_upd(wlc);
+	brcms_c_ucode_mac_upd(wlc);
 }
 
 ratespec_t brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
@@ -921,7 +923,7 @@ void brcms_c_protection_upd(struct brcms_c_info *wlc, uint idx, int val)
 
 }
 
-static void wlc_ht_update_sgi_rx(struct brcms_c_info *wlc, int val)
+static void brcms_c_ht_update_sgi_rx(struct brcms_c_info *wlc, int val)
 {
 	wlc->ht_cap.cap_info &= ~(IEEE80211_HT_CAP_SGI_20 |
 					IEEE80211_HT_CAP_SGI_40);
@@ -936,7 +938,7 @@ static void wlc_ht_update_sgi_rx(struct brcms_c_info *wlc, int val)
 	}
 }
 
-static void wlc_ht_update_ldpc(struct brcms_c_info *wlc, s8 val)
+static void brcms_c_ht_update_ldpc(struct brcms_c_info *wlc, s8 val)
 {
 	wlc->stf->ldpc = val;
 
@@ -955,7 +957,7 @@ static void wlc_ht_update_ldpc(struct brcms_c_info *wlc, s8 val)
  * ucode, hwmac update
  *    Channel dependent updates for ucode and hw
  */
-static void wlc_ucode_mac_upd(struct brcms_c_info *wlc)
+static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 {
 	/* enable or disable any active IBSSs depending on whether or not
 	 * we are on the home channel
@@ -982,7 +984,8 @@ static void wlc_ucode_mac_upd(struct brcms_c_info *wlc)
 	brcms_c_mac_promisc(wlc);
 }
 
-static void wlc_bandinit_ordered(struct brcms_c_info *wlc, chanspec_t chanspec)
+static void brcms_c_bandinit_ordered(struct brcms_c_info *wlc,
+				     chanspec_t chanspec)
 {
 	wlc_rateset_t default_rateset;
 	uint parkband;
@@ -994,7 +997,8 @@ static void wlc_bandinit_ordered(struct brcms_c_info *wlc, chanspec_t chanspec)
 	 * figure out the right band to park on
 	 */
 	if (wlc->bandlocked || NBANDS(wlc) == 1) {
-		parkband = wlc->band->bandunit;	/* updated in wlc_bandlock() */
+		/* updated in brcms_c_bandlock() */
+		parkband = wlc->band->bandunit;
 		band_order[0] = band_order[1] = parkband;
 	} else {
 		/* park on the band of the specified chanspec */
@@ -1023,11 +1027,11 @@ static void wlc_bandinit_ordered(struct brcms_c_info *wlc, chanspec_t chanspec)
 	}
 
 	/* sync up phy/radio chanspec */
-	wlc_set_phy_chanspec(wlc, chanspec);
+	brcms_c_set_phy_chanspec(wlc, chanspec);
 }
 
 /* band-specific init */
-static void WLBANDINITFN(wlc_bsinit) (struct brcms_c_info *wlc)
+static void WLBANDINITFN(brcms_c_bsinit) (struct brcms_c_info *wlc)
 {
 	BCMMSG(wlc->wiphy, "wl%d: bandunit %d\n",
 		 wlc->pub->unit, wlc->band->bandunit);
@@ -1036,7 +1040,7 @@ static void WLBANDINITFN(wlc_bsinit) (struct brcms_c_info *wlc)
 	brcms_c_set_ratetable(wlc);
 
 	/* update some band specific mac configuration */
-	wlc_ucode_mac_upd(wlc);
+	brcms_c_ucode_mac_upd(wlc);
 
 	/* init antenna selection */
 	brcms_c_antsel_init(wlc->asi);
@@ -1044,7 +1048,8 @@ static void WLBANDINITFN(wlc_bsinit) (struct brcms_c_info *wlc)
 }
 
 /* switch to and initialize new band */
-static void WLBANDINITFN(wlc_setband) (struct brcms_c_info *wlc, uint bandunit)
+static void WLBANDINITFN(brcms_c_setband) (struct brcms_c_info *wlc,
+					   uint bandunit)
 {
 	int idx;
 	struct brcms_c_bsscfg *cfg;
@@ -1060,7 +1065,7 @@ static void WLBANDINITFN(wlc_setband) (struct brcms_c_info *wlc, uint bandunit)
 	brcms_c_set_ps_ctrl(wlc);
 
 	/* band-specific initializations */
-	wlc_bsinit(wlc);
+	brcms_c_bsinit(wlc);
 }
 
 /* Initialize a WME Parameter Info Element with default STA parameters from WMM Spec, Table 12 */
@@ -1117,7 +1122,7 @@ void brcms_c_wme_setparams(struct brcms_c_info *wlc, u16 aci,
 
 		if (acp_shm.aifs < EDCF_AIFSN_MIN
 		    || acp_shm.aifs > EDCF_AIFSN_MAX) {
-			wiphy_err(wlc->wiphy, "wl%d: wlc_edcf_setparams: bad "
+			wiphy_err(wlc->wiphy, "wl%d: edcf_setparams: bad "
 				  "aifs %d\n", wlc->pub->unit, acp_shm.aifs);
 			continue;
 		}
@@ -1201,7 +1206,7 @@ void brcms_c_edcf_setparams(struct brcms_c_info *wlc, bool suspend)
 
 bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
 {
-	wlc->wdtimer = brcms_init_timer(wlc->wl, wlc_watchdog_by_timer,
+	wlc->wdtimer = brcms_init_timer(wlc->wl, brcms_c_watchdog_by_timer,
 		wlc, "watchdog");
 	if (!wlc->wdtimer) {
 		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for wdtimer "
@@ -1209,7 +1214,7 @@ bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit)
 		goto fail;
 	}
 
-	wlc->radio_timer = brcms_init_timer(wlc->wl, wlc_radio_timer,
+	wlc->radio_timer = brcms_init_timer(wlc->wl, brcms_c_radio_timer,
 		wlc, "radio");
 	if (!wlc->radio_timer) {
 		wiphy_err(wlc->wiphy, "wl%d:  wl_init_timer for radio_timer "
@@ -1297,7 +1302,7 @@ void brcms_c_info_init(struct brcms_c_info *wlc, int unit)
 	wlc->mpc_delay_off = wlc->mpc_dlycnt = WLC_MPC_MIN_DELAYCNT;
 }
 
-static bool wlc_state_bmac_sync(struct brcms_c_info *wlc)
+static bool brcms_c_state_bmac_sync(struct brcms_c_info *wlc)
 {
 	brcms_b_state_t state_bmac;
 
@@ -1311,7 +1316,7 @@ static bool wlc_state_bmac_sync(struct brcms_c_info *wlc)
 	return true;
 }
 
-static uint wlc_attach_module(struct brcms_c_info *wlc)
+static uint brcms_c_attach_module(struct brcms_c_info *wlc)
 {
 	uint err = 0;
 	uint unit;
@@ -1319,7 +1324,7 @@ static uint wlc_attach_module(struct brcms_c_info *wlc)
 
 	wlc->asi = brcms_c_antsel_attach(wlc);
 	if (wlc->asi == NULL) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: antsel_attach "
+		wiphy_err(wlc->wiphy, "wl%d: attach: antsel_attach "
 			  "failed\n", unit);
 		err = 44;
 		goto fail;
@@ -1327,14 +1332,14 @@ static uint wlc_attach_module(struct brcms_c_info *wlc)
 
 	wlc->ampdu = brcms_c_ampdu_attach(wlc);
 	if (wlc->ampdu == NULL) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: brcms_c_ampdu_attach "
+		wiphy_err(wlc->wiphy, "wl%d: attach: ampdu_attach "
 			  "failed\n", unit);
 		err = 50;
 		goto fail;
 	}
 
 	if ((brcms_c_stf_attach(wlc) != 0)) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_attach: wlc_stf_attach "
+		wiphy_err(wlc->wiphy, "wl%d: attach: stf_attach "
 			  "failed\n", unit);
 		err = 68;
 		goto fail;
@@ -1402,7 +1407,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	/* for some states, due to different info pointer(e,g, wlc, wlc_hw) or master/slave split,
 	 * HIGH driver(both monolithic and HIGH_ONLY) needs to sync states FROM BMAC portion driver
 	 */
-	if (!wlc_state_bmac_sync(wlc)) {
+	if (!brcms_c_state_bmac_sync(wlc)) {
 		err = 20;
 		goto fail;
 	}
@@ -1447,7 +1452,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 
 		wlc->band = wlc->bandstate[j];
 
-		if (!wlc_attach_stf_ant_init(wlc)) {
+		if (!brcms_c_attach_stf_ant_init(wlc)) {
 			err = 24;
 			goto fail;
 		}
@@ -1492,12 +1497,12 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	brcms_c_stf_phy_txant_upd(wlc);
 
 	/* attach each modules */
-	err = wlc_attach_module(wlc);
+	err = brcms_c_attach_module(wlc);
 	if (err != 0)
 		goto fail;
 
 	if (!brcms_c_timers_init(wlc, unit)) {
-		wiphy_err(wl->wiphy, "wl%d: %s: wlc_init_timer failed\n", unit,
+		wiphy_err(wl->wiphy, "wl%d: %s: init_timer failed\n", unit,
 			  __func__);
 		err = 32;
 		goto fail;
@@ -1513,14 +1518,14 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	}
 
 	/* init default when all parameters are ready, i.e. ->rateset */
-	wlc_bss_default_init(wlc);
+	brcms_c_bss_default_init(wlc);
 
 	/*
 	 * Complete the wlc default state initializations..
 	 */
 
 	/* allocate our initial queue */
-	wlc->pkt_queue = wlc_txq_alloc(wlc);
+	wlc->pkt_queue = brcms_c_txq_alloc(wlc);
 	if (wlc->pkt_queue == NULL) {
 		wiphy_err(wl->wiphy, "wl%d: %s: failed to malloc tx queue\n",
 			  unit, __func__);
@@ -1543,17 +1548,17 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	wlc->mimo_40txbw = AUTO;
 	wlc->ofdm_40txbw = AUTO;
 	wlc->cck_40txbw = AUTO;
-	wlc_update_mimo_band_bwcap(wlc, WLC_N_BW_20IN2G_40IN5G);
+	brcms_c_update_mimo_band_bwcap(wlc, WLC_N_BW_20IN2G_40IN5G);
 
 	/* Set default values of SGI */
 	if (WLC_SGI_CAP_PHY(wlc)) {
-		wlc_ht_update_sgi_rx(wlc, (WLC_N_SGI_20 | WLC_N_SGI_40));
+		brcms_c_ht_update_sgi_rx(wlc, (WLC_N_SGI_20 | WLC_N_SGI_40));
 		wlc->sgi_tx = AUTO;
 	} else if (WLCISSSLPNPHY(wlc->band)) {
-		wlc_ht_update_sgi_rx(wlc, (WLC_N_SGI_20 | WLC_N_SGI_40));
+		brcms_c_ht_update_sgi_rx(wlc, (WLC_N_SGI_20 | WLC_N_SGI_40));
 		wlc->sgi_tx = AUTO;
 	} else {
-		wlc_ht_update_sgi_rx(wlc, 0);
+		brcms_c_ht_update_sgi_rx(wlc, 0);
 		wlc->sgi_tx = OFF;
 	}
 
@@ -1564,7 +1569,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		wlc->sgi_tx = OFF;
 
 	if (n_disabled & WLFEATURE_DISABLE_11N_SGI_RX)
-		wlc_ht_update_sgi_rx(wlc, 0);
+		brcms_c_ht_update_sgi_rx(wlc, 0);
 
 	/* apply the stbc override from nvram conf */
 	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_TX) {
@@ -1607,7 +1612,7 @@ void *brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	return NULL;
 }
 
-static void wlc_attach_antgain_init(struct brcms_c_info *wlc)
+static void brcms_c_attach_antgain_init(struct brcms_c_info *wlc)
 {
 	uint unit;
 	unit = wlc->pub->unit;
@@ -1639,7 +1644,7 @@ static void wlc_attach_antgain_init(struct brcms_c_info *wlc)
 	}
 }
 
-static bool wlc_attach_stf_ant_init(struct brcms_c_info *wlc)
+static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 {
 	int aa;
 	uint unit;
@@ -1674,13 +1679,13 @@ static bool wlc_attach_stf_ant_init(struct brcms_c_info *wlc)
 	/* Compute Antenna Gain */
 	wlc->band->antgain =
 	    (s8) getintvar(vars, (BAND_5G(bandtype) ? "ag1" : "ag0"));
-	wlc_attach_antgain_init(wlc);
+	brcms_c_attach_antgain_init(wlc);
 
 	return true;
 }
 
 
-static void wlc_timers_deinit(struct brcms_c_info *wlc)
+static void brcms_c_timers_deinit(struct brcms_c_info *wlc)
 {
 	/* free timer state */
 	if (wlc->wdtimer) {
@@ -1693,7 +1698,7 @@ static void wlc_timers_deinit(struct brcms_c_info *wlc)
 	}
 }
 
-static void wlc_detach_module(struct brcms_c_info *wlc)
+static void brcms_c_detach_module(struct brcms_c_info *wlc)
 {
 	if (wlc->asi) {
 		brcms_c_antsel_detach(wlc->asi);
@@ -1730,18 +1735,18 @@ uint brcms_c_detach(struct brcms_c_info *wlc)
 	callbacks += brcms_b_detach(wlc);
 
 	/* delete software timers */
-	if (!wlc_radio_monitor_stop(wlc))
+	if (!brcms_c_radio_monitor_stop(wlc))
 		callbacks++;
 
 	brcms_c_channel_mgr_detach(wlc->cmi);
 
-	wlc_timers_deinit(wlc);
+	brcms_c_timers_deinit(wlc);
 
-	wlc_detach_module(wlc);
+	brcms_c_detach_module(wlc);
 
 
 	while (wlc->tx_queues != NULL)
-		wlc_txq_free(wlc, wlc->tx_queues);
+		brcms_c_txq_free(wlc, wlc->tx_queues);
 
 	brcms_c_detach_mfree(wlc);
 	return callbacks;
@@ -1760,7 +1765,7 @@ void brcms_c_ap_upd(struct brcms_c_info *wlc)
 }
 
 /* read hwdisable state and propagate to wlc flag */
-static void wlc_radio_hwdisable_upd(struct brcms_c_info *wlc)
+static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc)
 {
 	if (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO || wlc->pub->hw_off)
 		return;
@@ -1797,9 +1802,9 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 		if (!wlc->pub->radio_disabled)
 			return;
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
-		wlc_radio_upd(wlc);
+		brcms_c_radio_upd(wlc);
 		if (!wlc->pub->radio_disabled)
-			wlc_radio_monitor_stop(wlc);
+			brcms_c_radio_monitor_stop(wlc);
 		return;
 	}
 
@@ -1817,7 +1822,7 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 		wlc->mpc_delay_off = wlc->mpc_dlycnt;
 	else if (radio_state == OFF && mpc_radio == ON) {
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_MPC_DISABLE);
-		wlc_radio_upd(wlc);
+		brcms_c_radio_upd(wlc);
 		if (wlc->mpc_offcnt < WLC_MPC_THRESHOLD) {
 			wlc->mpc_dlycnt = WLC_MPC_MAX_DELAYCNT;
 		} else
@@ -1839,17 +1844,17 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
  * centralized radio disable/enable function,
  * invoke radio enable/disable after updating hwradio status
  */
-static void wlc_radio_upd(struct brcms_c_info *wlc)
+static void brcms_c_radio_upd(struct brcms_c_info *wlc)
 {
 	if (wlc->pub->radio_disabled) {
 		brcms_c_radio_disable(wlc);
 	} else {
-		wlc_radio_enable(wlc);
+		brcms_c_radio_enable(wlc);
 	}
 }
 
 /* maintain LED behavior in down state */
-static void wlc_down_led_upd(struct brcms_c_info *wlc)
+static void brcms_c_down_led_upd(struct brcms_c_info *wlc)
 {
 	/* maintain LEDs while in down state, turn on sbclk if not available yet */
 	/* turn on sbclk if necessary */
@@ -1863,7 +1868,7 @@ static void wlc_down_led_upd(struct brcms_c_info *wlc)
 /* update hwradio status and return it */
 bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc)
 {
-	wlc_radio_hwdisable_upd(wlc);
+	brcms_c_radio_hwdisable_upd(wlc);
 
 	return mboolisset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE) ? true : false;
 }
@@ -1871,15 +1876,15 @@ bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc)
 void brcms_c_radio_disable(struct brcms_c_info *wlc)
 {
 	if (!wlc->pub->up) {
-		wlc_down_led_upd(wlc);
+		brcms_c_down_led_upd(wlc);
 		return;
 	}
 
-	wlc_radio_monitor_start(wlc);
+	brcms_c_radio_monitor_start(wlc);
 	brcms_down(wlc->wl);
 }
 
-static void wlc_radio_enable(struct brcms_c_info *wlc)
+static void brcms_c_radio_enable(struct brcms_c_info *wlc)
 {
 	if (wlc->pub->up)
 		return;
@@ -1891,7 +1896,7 @@ static void wlc_radio_enable(struct brcms_c_info *wlc)
 }
 
 /* periodical query hw radio button while driver is "down" */
-static void wlc_radio_timer(void *arg)
+static void brcms_c_radio_timer(void *arg)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 
@@ -1906,11 +1911,11 @@ static void wlc_radio_timer(void *arg)
 	if (wlc->mpc_offcnt < WLC_MPC_MAX_DELAYCNT)
 		wlc->mpc_offcnt++;
 
-	wlc_radio_hwdisable_upd(wlc);
-	wlc_radio_upd(wlc);
+	brcms_c_radio_hwdisable_upd(wlc);
+	brcms_c_radio_upd(wlc);
 }
 
-static bool wlc_radio_monitor_start(struct brcms_c_info *wlc)
+static bool brcms_c_radio_monitor_start(struct brcms_c_info *wlc)
 {
 	/* Don't start the timer if HWRADIO feature is disabled */
 	if (wlc->radio_monitor || (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO))
@@ -1923,7 +1928,7 @@ static bool wlc_radio_monitor_start(struct brcms_c_info *wlc)
 	return true;
 }
 
-bool wlc_radio_monitor_stop(struct brcms_c_info *wlc)
+bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc)
 {
 	if (!wlc->radio_monitor)
 		return true;
@@ -1933,13 +1938,13 @@ bool wlc_radio_monitor_stop(struct brcms_c_info *wlc)
 	return brcms_del_timer(wlc->wl, wlc->radio_timer);
 }
 
-static void wlc_watchdog_by_timer(void *arg)
+static void brcms_c_watchdog_by_timer(void *arg)
 {
-	wlc_watchdog(arg);
+	brcms_c_watchdog(arg);
 }
 
 /* common watchdog code */
-static void wlc_watchdog(void *arg)
+static void brcms_c_watchdog(void *arg)
 {
 	struct brcms_c_info *wlc = (struct brcms_c_info *) arg;
 	int i;
@@ -1974,8 +1979,8 @@ static void wlc_watchdog(void *arg)
 	/* mpc sync */
 	brcms_c_radio_mpc_upd(wlc);
 	/* radio sync: sw/hw/mpc --> radio_disable/radio_enable */
-	wlc_radio_hwdisable_upd(wlc);
-	wlc_radio_upd(wlc);
+	brcms_c_radio_hwdisable_upd(wlc);
+	brcms_c_radio_upd(wlc);
 	/* if radio is disable, driver may be down, quit here */
 	if (wlc->pub->radio_disabled)
 		return;
@@ -2058,9 +2063,9 @@ int brcms_c_up(struct brcms_c_info *wlc)
 					if (!BSSCFG_STA(bsscfg)
 					    || !bsscfg->enable || !bsscfg->BSS)
 						continue;
-					wiphy_err(wlc->wiphy, "wl%d.%d: wlc_up"
+					wiphy_err(wlc->wiphy, "wl%d.%d: up"
 						  ": rfdisable -> "
-						  "wlc_bsscfg_disable()\n",
+						  "bsscfg_disable()\n",
 						   wlc->pub->unit, idx);
 				}
 			}
@@ -2068,14 +2073,14 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	}
 
 	if (wlc->pub->radio_disabled) {
-		wlc_radio_monitor_start(wlc);
+		brcms_c_radio_monitor_start(wlc);
 		return 0;
 	}
 
-	/* brcms_b_up_prep has done wlc_corereset(). so clk is on, set it */
+	/* brcms_b_up_prep has done brcms_c_corereset(). so clk is on, set it */
 	wlc->clk = true;
 
-	wlc_radio_monitor_stop(wlc);
+	brcms_c_radio_monitor_stop(wlc);
 
 	/* Set EDCF hostflags */
 	if (EDCF_ENAB(wlc->pub)) {
@@ -2102,10 +2107,10 @@ int brcms_c_up(struct brcms_c_info *wlc)
 
 	/* other software states up after ISR is running */
 	/* start APs that were to be brought up but are not up  yet */
-	/* if (AP_ENAB(wlc->pub)) wlc_restart_ap(wlc->ap); */
+	/* if (AP_ENAB(wlc->pub)) brcms_c_restart_ap(wlc->ap); */
 
 	/* Program the TX wme params with the current settings */
-	wlc_wme_retries_write(wlc);
+	brcms_c_wme_retries_write(wlc);
 
 	/* start one second watchdog timer */
 	brcms_add_timer(wlc->wl, wlc->wdtimer, TIMER_INTERVAL_WATCHDOG, true);
@@ -2114,13 +2119,13 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	/* ensure antenna config is up to date */
 	brcms_c_stf_phy_txant_upd(wlc);
 	/* ensure LDPC config is in sync */
-	wlc_ht_update_ldpc(wlc, wlc->stf->ldpc);
+	brcms_c_ht_update_ldpc(wlc, wlc->stf->ldpc);
 
 	return 0;
 }
 
 /* Initialize the base precedence map for dequeueing from txq based on WME settings */
-static void wlc_tx_prec_map_init(struct brcms_c_info *wlc)
+static void brcms_c_tx_prec_map_init(struct brcms_c_info *wlc)
 {
 	wlc->tx_prec_map = WLC_PREC_BMP_ALL;
 	memset(wlc->fifo2prec_map, 0, NFIFO * sizeof(u16));
@@ -2139,7 +2144,7 @@ static void wlc_tx_prec_map_init(struct brcms_c_info *wlc)
 	}
 }
 
-static uint wlc_down_del_timer(struct brcms_c_info *wlc)
+static uint brcms_c_down_del_timer(struct brcms_c_info *wlc)
 {
 	uint callbacks = 0;
 
@@ -2191,14 +2196,14 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 		wlc->WDarmed = false;
 	}
 	/* cancel all other timers */
-	callbacks += wlc_down_del_timer(wlc);
+	callbacks += brcms_c_down_del_timer(wlc);
 
 	wlc->pub->up = false;
 
 	wlc_phy_mute_upd(wlc->band->pi, false, PHY_MUTE_ALL);
 
 	/* clear txq flow control */
-	wlc_txflowcontrol_reset(wlc);
+	brcms_c_txflowcontrol_reset(wlc);
 
 	/* flush tx queues */
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
@@ -2364,7 +2369,7 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 	return ret;
 }
 
-static int wlc_nmode_validate(struct brcms_c_info *wlc, s32 nmode)
+static int brcms_c_nmode_validate(struct brcms_c_info *wlc, s32 nmode)
 {
 	int err = 0;
 
@@ -2393,7 +2398,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 	uint i;
 	int err;
 
-	err = wlc_nmode_validate(wlc, nmode);
+	err = brcms_c_nmode_validate(wlc, nmode);
 	if (err)
 		return err;
 
@@ -2444,7 +2449,7 @@ int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
 	return err;
 }
 
-static int wlc_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
+static int brcms_c_set_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs_arg)
 {
 	wlc_rateset_t rs, new;
 	uint bandunit;
@@ -2497,7 +2502,7 @@ int brcms_c_get(struct brcms_c_info *wlc, int cmd, int *arg)
 	return brcms_c_ioctl(wlc, cmd, arg, sizeof(int), NULL);
 }
 
-static void wlc_ofdm_rateset_war(struct brcms_c_info *wlc)
+static void brcms_c_ofdm_rateset_war(struct brcms_c_info *wlc)
 {
 	u8 r;
 	bool war = false;
@@ -2514,15 +2519,15 @@ static void wlc_ofdm_rateset_war(struct brcms_c_info *wlc)
 
 int
 brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-	  struct brcms_c_if *wlcif)
+	      struct brcms_c_if *wlcif)
 {
-	return _wlc_ioctl(wlc, cmd, arg, len, wlcif);
+	return _brcms_c_ioctl(wlc, cmd, arg, len, wlcif);
 }
 
 /* common ioctl handler. return: 0=ok, -1=error, positive=particular error */
 static int
-_wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
-	   struct brcms_c_if *wlcif)
+_brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
+	       struct brcms_c_if *wlcif)
 {
 	int val, *pval;
 	bool bool_val;
@@ -2594,7 +2599,8 @@ _wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			}
 
 			wlc->default_bss->chanspec = chspec;
-			/* wlc_BSSinit() will sanitize the rateset before using it.. */
+			/* brcms_c_BSSinit() will sanitize the rateset before
+			 * using it.. */
 			if (wlc->pub->up &&
 			    (WLC_BAND_PI_RADIO_CHANSPEC != chspec)) {
 				brcms_c_set_home_chanspec(wlc, chspec);
@@ -2615,7 +2621,7 @@ _wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			for (ac = 0; ac < AC_COUNT; ac++) {
 				WLC_WME_RETRY_SHORT_SET(wlc, ac, wlc->SRL);
 			}
-			wlc_wme_retries_write(wlc);
+			brcms_c_wme_retries_write(wlc);
 		} else
 			bcmerror = -EINVAL;
 		break;
@@ -2630,7 +2636,7 @@ _wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 			for (ac = 0; ac < AC_COUNT; ac++) {
 				WLC_WME_RETRY_LONG_SET(wlc, ac, wlc->LRL);
 			}
-			wlc_wme_retries_write(wlc);
+			brcms_c_wme_retries_write(wlc);
 		} else
 			bcmerror = -EINVAL;
 		break;
@@ -2687,10 +2693,10 @@ _wlc_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 					       MCSSET_LEN);
 			}
 
-			bcmerror = wlc_set_rateset(wlc, &rs);
+			bcmerror = brcms_c_set_rateset(wlc, &rs);
 
 			if (!bcmerror)
-				wlc_ofdm_rateset_war(wlc);
+				brcms_c_ofdm_rateset_war(wlc);
 
 			break;
 		}
@@ -2813,7 +2819,7 @@ int brcms_c_module_unregister(struct wlc_pub *pub, const char *name, void *hdl)
 }
 
 /* Write WME tunable parameters for retransmit/max rate from wlc struct to ucode */
-static void wlc_wme_retries_write(struct brcms_c_info *wlc)
+static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 {
 	int ac;
 
@@ -2834,7 +2840,7 @@ static const char *supr_reason[] = {
 	"Lifetime Expiry", "Underflow"
 };
 
-static void wlc_print_txs_status(u16 s)
+static void brcms_c_print_txs_status(u16 s)
 {
 	printk(KERN_DEBUG "[15:12]  %d  frame attempts\n",
 	       (s & TX_STATUS_FRM_RTX_MASK) >> TX_STATUS_FRM_RTX_SHIFT);
@@ -2866,7 +2872,7 @@ void brcms_c_print_txstatus(tx_status_t *txs)
 	printk(KERN_DEBUG "TxStatus: %04x", s);
 	printk(KERN_DEBUG "\n");
 
-	wlc_print_txs_status(s);
+	brcms_c_print_txs_status(s);
 
 	printk(KERN_DEBUG "LastTxTime: %04x ", txs->lasttxtime);
 	printk(KERN_DEBUG "Seq: %04x ", txs->sequence);
@@ -2935,7 +2941,7 @@ void brcms_c_statsupd(struct brcms_c_info *wlc)
 bool brcms_c_chipmatch(u16 vendor, u16 device)
 {
 	if (vendor != PCI_VENDOR_ID_BROADCOM) {
-		pr_err("wlc_chipmatch: unknown vendor id %04x\n", vendor);
+		pr_err("chipmatch: unknown vendor id %04x\n", vendor);
 		return false;
 	}
 
@@ -2948,7 +2954,7 @@ bool brcms_c_chipmatch(u16 vendor, u16 device)
 	if ((device == BCM43236_D11N_ID) || (device == BCM43236_D11N2G_ID))
 		return true;
 
-	pr_err("wlc_chipmatch: unknown device id %04x\n", device);
+	pr_err("chipmatch: unknown device id %04x\n", device);
 	return false;
 }
 
@@ -3078,7 +3084,7 @@ void brcms_c_print_rxh(d11rxhdr_t *rxh)
 }
 #endif				/* defined(BCMDBG) */
 
-static u16 wlc_rate_shm_offset(struct brcms_c_info *wlc, u8 rate)
+static u16 brcms_c_rate_shm_offset(struct brcms_c_info *wlc, u8 rate)
 {
 	return brcms_b_rate_shm_offset(wlc->hw, rate);
 }
@@ -3160,7 +3166,7 @@ void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 	if (!brcms_c_prec_enq(wlc, q, sdu, prec)) {
 		if (!EDCF_ENAB(wlc->pub)
 		    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL))
-			wiphy_err(wlc->wiphy, "wl%d: wlc_txq_enq: txq overflow"
+			wiphy_err(wlc->wiphy, "wl%d: txq_enq: txq overflow"
 				  "\n", wlc->pub->unit);
 
 		/*
@@ -3203,7 +3209,8 @@ brcms_c_sendpkt_mac80211(struct brcms_c_info *wlc, struct sk_buff *sdu,
 	fifo = prio2fifo[prio];
 	pkt = sdu;
 	if (unlikely
-	    (wlc_d11hdrs_mac80211(wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
+	    (brcms_c_d11hdrs_mac80211(
+		wlc, hw, pkt, scb, 0, 1, fifo, 0, NULL, 0)))
 		return -EINVAL;
 	brcms_c_txq_enq(wlc, scb, pkt, WLC_PRIO_TO_PREC(prio));
 	brcms_c_send_q(wlc);
@@ -3316,7 +3323,7 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	}
 
 	if (WLC_WAR16165(wlc))
-		wlc_war16165(wlc, true);
+		brcms_c_war16165(wlc, true);
 
 
 	/* Bump up pending count for if not using rpc. If rpc is used, this will be handled
@@ -3333,7 +3340,7 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 		BCMCFID(wlc, frameid);
 
 	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0) {
-		wiphy_err(wlc->wiphy, "wlc_txfifo: fatal, toss frames !!!\n");
+		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
 	}
 }
 
@@ -3342,17 +3349,17 @@ brcms_c_compute_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
 		     uint length, u8 *plcp)
 {
 	if (IS_MCS(rspec)) {
-		wlc_compute_mimo_plcp(rspec, length, plcp);
+		brcms_c_compute_mimo_plcp(rspec, length, plcp);
 	} else if (IS_OFDM(rspec)) {
-		wlc_compute_ofdm_plcp(rspec, length, plcp);
+		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
 	} else {
-		wlc_compute_cck_plcp(wlc, rspec, length, plcp);
+		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
 	}
 	return;
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void wlc_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
+static void brcms_c_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
 {
 	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
 	plcp[0] = mcs;
@@ -3367,7 +3374,7 @@ static void wlc_compute_mimo_plcp(ratespec_t rspec, uint length, u8 *plcp)
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
 static void
-wlc_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
+brcms_c_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
 {
 	u8 rate_signal;
 	u32 tmp = 0;
@@ -3393,7 +3400,7 @@ wlc_compute_ofdm_plcp(ratespec_t rspec, u32 length, u8 *plcp)
  * Broken out for PRQ.
  */
 
-static void wlc_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
+static void brcms_c_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 			     uint length, u8 *plcp)
 {
 	u16 usec = 0;
@@ -3421,7 +3428,7 @@ static void wlc_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 		break;
 
 	default:
-		wiphy_err(wlc->wiphy, "wlc_cck_plcp_set: unsupported rate %d"
+		wiphy_err(wlc->wiphy, "brcms_c_cck_plcp_set: unsupported rate %d"
 			  "\n", rate_500);
 		rate_500 = WLC_RATE_1M;
 		usec = length << 3;
@@ -3440,15 +3447,15 @@ static void wlc_cck_plcp_set(struct brcms_c_info *wlc, int rate_500,
 }
 
 /* Rate: 802.11 rate code, length: PSDU length in octets */
-static void wlc_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
+static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
 				 uint length, u8 *plcp)
 {
 	int rate = RSPEC2RATE(rspec);
 
-	wlc_cck_plcp_set(wlc, rate, length, plcp);
+	brcms_c_cck_plcp_set(wlc, rate, length, plcp);
 }
 
-/* wlc_compute_frame_dur()
+/* brcms_c_compute_frame_dur()
  *
  * Calculate the 802.11 MAC header DUR field for MPDU
  * DUR for a single frame = 1 SIFS + 1 ACK
@@ -3459,7 +3466,7 @@ static void wlc_compute_cck_plcp(struct brcms_c_info *wlc, ratespec_t rspec,
  * preamble_type	use short/GF or long/MM PLCP header
  */
 static u16
-wlc_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
+brcms_c_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
 		      u8 preamble_type, uint next_frag_len)
 {
 	u16 dur, sifs;
@@ -3467,7 +3474,7 @@ wlc_compute_frame_dur(struct brcms_c_info *wlc, ratespec_t rate,
 	sifs = SIFS(wlc->band);
 
 	dur = sifs;
-	dur += (u16) wlc_calc_ack_time(wlc, rate, preamble_type);
+	dur += (u16) brcms_c_calc_ack_time(wlc, rate, preamble_type);
 
 	if (next_frag_len) {
 		/* Double the current DUR to get 2 SIFS + 2 ACKs */
@@ -3505,7 +3512,7 @@ brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 	if (!cts_only) {	/* RTS/CTS */
 		dur = 3 * sifs;
 		dur +=
-		    (u16) wlc_calc_cts_time(wlc, rts_rate,
+		    (u16) brcms_c_calc_cts_time(wlc, rts_rate,
 					       rts_preamble_type);
 	} else {		/* CTS-TO-SELF */
 		dur = 2 * sifs;
@@ -3516,11 +3523,11 @@ brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 					 frame_len);
 	if (ba)
 		dur +=
-		    (u16) wlc_calc_ba_time(wlc, frame_rate,
+		    (u16) brcms_c_calc_ba_time(wlc, frame_rate,
 					      WLC_SHORT_PREAMBLE);
 	else
 		dur +=
-		    (u16) wlc_calc_ack_time(wlc, frame_rate,
+		    (u16) brcms_c_calc_ack_time(wlc, frame_rate,
 					       frame_preamble_type);
 	return dur;
 }
@@ -3536,7 +3543,7 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
 		bw = RSPEC_GET_BW(rspec);
 		/* 10Mhz is not supported yet */
 		if (bw < PHY_TXC1_BW_20MHZ) {
-			wiphy_err(wlc->wiphy, "wlc_phytxctl1_calc: bw %d is "
+			wiphy_err(wlc->wiphy, "phytxctl1_calc: bw %d is "
 				  "not supported yet, set to 20L\n", bw);
 			bw = PHY_TXC1_BW_20MHZ;
 		}
@@ -3560,7 +3567,7 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, ratespec_t rspec)
 		/* get the phyctl byte from rate phycfg table */
 		phycfg = brcms_c_rate_legacy_phyctl(RSPEC2RATE(rspec));
 		if (phycfg == -1) {
-			wiphy_err(wlc->wiphy, "wlc_phytxctl1_calc: wrong "
+			wiphy_err(wlc->wiphy, "phytxctl1_calc: wrong "
 				  "legacy OFDM/CCK rate\n");
 			phycfg = 0;
 		}
@@ -3629,7 +3636,7 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, ratespec_t rspec,
  *
  */
 static u16
-wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
+brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		     struct sk_buff *p, struct scb *scb, uint frag,
 		     uint nfrags, uint queue, uint next_frag_len,
 		     wsec_key_t *key, ratespec_t rspec_override)
@@ -3931,7 +3938,7 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	if (!ieee80211_is_pspoll(h->frame_control) &&
 	    !is_multicast_ether_addr(h->addr1) && !use_rifs) {
 		durid =
-		    wlc_compute_frame_dur(wlc, rspec[0], preamble_type[0],
+		    brcms_c_compute_frame_dur(wlc, rspec[0], preamble_type[0],
 					  next_frag_len);
 		h->duration_id = cpu_to_le16(durid);
 	} else if (use_rifs) {
@@ -3950,7 +3957,7 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	else if (is_multicast_ether_addr(h->addr1) || use_rifs)
 		txh->FragDurFallback = 0;
 	else {
-		durid = wlc_compute_frame_dur(wlc, rspec[1],
+		durid = brcms_c_compute_frame_dur(wlc, rspec[1],
 					      preamble_type[1], next_frag_len);
 		txh->FragDurFallback = cpu_to_le16(durid);
 	}
@@ -4181,10 +4188,10 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			if (rts) {
 				/* 1 RTS or CTS-to-self frame */
 				dur =
-				    wlc_calc_cts_time(wlc, rts_rspec[0],
+				    brcms_c_calc_cts_time(wlc, rts_rspec[0],
 						      rts_preamble_type[0]);
 				dur_fallback =
-				    wlc_calc_cts_time(wlc, rts_rspec[1],
+				    brcms_c_calc_cts_time(wlc, rts_rspec[1],
 						      rts_preamble_type[1]);
 				/* (SIFS + CTS) + SIFS + frame + SIFS + ACK */
 				dur += le16_to_cpu(rts->duration);
@@ -4197,7 +4204,7 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				/* frame + SIFS + ACK */
 				dur = frag_dur;
 				dur +=
-				    wlc_compute_frame_dur(wlc, rspec[0],
+				    brcms_c_compute_frame_dur(wlc, rspec[0],
 							  preamble_type[0], 0);
 
 				dur_fallback =
@@ -4205,7 +4212,7 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 							preamble_type[1],
 							phylen);
 				dur_fallback +=
-				    wlc_compute_frame_dur(wlc, rspec[1],
+				    brcms_c_compute_frame_dur(wlc, rspec[1],
 							  preamble_type[1], 0);
 			}
 			/* NEED to set TxFesTimeNormal (hard) */
@@ -4220,12 +4227,10 @@ wlc_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 					uint newfragthresh;
 
 					newfragthresh =
-					    wlc_calc_frame_len(wlc, rspec[0],
-							       preamble_type[0],
-							       (wlc->
-								edcf_txop[ac] -
-								(dur -
-								 frag_dur)));
+					    brcms_c_calc_frame_len(wlc,
+						rspec[0], preamble_type[0],
+						(wlc->edcf_txop[ac] -
+							(dur - frag_dur)));
 					/* range bound the fragthreshold */
 					if (newfragthresh < DOT11_MIN_FRAG_LEN)
 						newfragthresh =
@@ -4270,7 +4275,7 @@ void brcms_c_tbtt(struct brcms_c_info *wlc)
 	}
 }
 
-static void wlc_war16165(struct brcms_c_info *wlc, bool tx)
+static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
 {
 	if (tx) {
 		/* the post-increment is used in STAY_AWAKE macro */
@@ -4324,7 +4329,7 @@ brcms_c_dotxstatus(struct brcms_c_info *wlc, tx_status_t *txs, u32 frm_tx2)
 
 	p = GETNEXTTXP(wlc, queue);
 	if (WLC_WAR16165(wlc))
-		wlc_war16165(wlc, false);
+		brcms_c_war16165(wlc, false);
 	if (p == NULL)
 		goto fatal;
 
@@ -4478,7 +4483,8 @@ void brcms_c_bcn_li_upd(struct brcms_c_info *wlc)
  * receive call sequence after rx interrupt. Only the higher 16 bits
  * are used. Finally, the tsf_h is read from the tsf register.
  */
-static u64 wlc_recover_tsf64(struct brcms_c_info *wlc, struct wlc_d11rxhdr *rxh)
+static u64 brcms_c_recover_tsf64(struct brcms_c_info *wlc,
+				 struct wlc_d11rxhdr *rxh)
 {
 	u32 tsf_h, tsf_l;
 	u16 rx_tsf_0_15, rx_tsf_16_31;
@@ -4513,7 +4519,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, d11rxhdr_t *rxh,
 	unsigned char *plcp;
 
 	/* fill in TSF and flag its presence */
-	rx_status->mactime = wlc_recover_tsf64(wlc, wlc_rxh);
+	rx_status->mactime = brcms_c_recover_tsf64(wlc, wlc_rxh);
 	rx_status->flag |= RX_FLAG_MACTIME_MPDU;
 
 	channel = WLC_CHAN_CHANNEL(rxh->RxChan);
@@ -4613,7 +4619,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, d11rxhdr_t *rxh,
 }
 
 static void
-wlc_recvctl(struct brcms_c_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
+brcms_c_recvctl(struct brcms_c_info *wlc, d11rxhdr_t *rxh, struct sk_buff *p)
 {
 	int len_mpdu;
 	struct ieee80211_rx_status rx_status;
@@ -4668,7 +4674,7 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	/* MAC inserts 2 pad bytes for a4 headers or QoS or A-MSDU subframes */
 	if (rxh->RxStatus1 & RXS_PBPRES) {
 		if (p->len < 2) {
-			wiphy_err(wlc->wiphy, "wl%d: wlc_recv: rcvd runt of "
+			wiphy_err(wlc->wiphy, "wl%d: recv: rcvd runt of "
 				  "len %d\n", wlc->pub->unit, p->len);
 			goto toss;
 		}
@@ -4720,7 +4726,7 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	if (is_amsdu)
 		goto toss;
 
-	wlc_recvctl(wlc, rxh, p);
+	brcms_c_recvctl(wlc, rxh, p);
 	return;
 
  toss:
@@ -4844,7 +4850,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, ratespec_t ratespec,
 
 /* The opposite of brcms_c_calc_frame_time */
 static uint
-wlc_calc_frame_len(struct brcms_c_info *wlc, ratespec_t ratespec,
+brcms_c_calc_frame_len(struct brcms_c_info *wlc, ratespec_t ratespec,
 		   u8 preamble_type, uint dur)
 {
 	uint nsyms, mac_len, Ndps, kNdps;
@@ -4890,7 +4896,8 @@ wlc_calc_frame_len(struct brcms_c_info *wlc, ratespec_t ratespec,
 }
 
 static uint
-wlc_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
+brcms_c_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rspec,
+		     u8 preamble_type)
 {
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, "
 		 "preamble_type %d\n", wlc->pub->unit, rspec, preamble_type);
@@ -4905,7 +4912,8 @@ wlc_calc_ba_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
 }
 
 static uint
-wlc_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
+brcms_c_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rspec,
+		      u8 preamble_type)
 {
 	uint dur = 0;
 
@@ -4923,11 +4931,12 @@ wlc_calc_ack_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
 }
 
 static uint
-wlc_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rspec, u8 preamble_type)
+brcms_c_calc_cts_time(struct brcms_c_info *wlc, ratespec_t rspec,
+		      u8 preamble_type)
 {
 	BCMMSG(wlc->wiphy, "wl%d: ratespec 0x%x, preamble_type %d\n",
 		wlc->pub->unit, rspec, preamble_type);
-	return wlc_calc_ack_time(wlc, rspec, preamble_type);
+	return brcms_c_calc_ack_time(wlc, rspec, preamble_type);
 }
 
 /* derive wlc->band->basic_rate[] table from 'rateset' */
@@ -5021,7 +5030,8 @@ void brcms_c_rate_lookup_init(struct brcms_c_info *wlc, wlc_rateset_t *rateset)
 	}
 }
 
-static void wlc_write_rate_shm(struct brcms_c_info *wlc, u8 rate, u8 basic_rate)
+static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
+				   u8 basic_rate)
 {
 	u8 phy_rate, index;
 	u8 basic_phy_rate, basic_index;
@@ -5054,7 +5064,7 @@ static void wlc_write_rate_shm(struct brcms_c_info *wlc, u8 rate, u8 basic_rate)
 	brcms_c_write_shm(wlc, (basic_table + index * 2), basic_ptr);
 }
 
-static const wlc_rateset_t *wlc_rateset_get_hwrs(struct brcms_c_info *wlc)
+static const wlc_rateset_t *brcms_c_rateset_get_hwrs(struct brcms_c_info *wlc)
 {
 	const wlc_rateset_t *rs_dflt;
 
@@ -5078,7 +5088,7 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 	u8 rate, basic_rate;
 	uint i;
 
-	rs_dflt = wlc_rateset_get_hwrs(wlc);
+	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
 
 	brcms_c_rateset_copy(rs_dflt, &rs);
 	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
@@ -5098,7 +5108,7 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 			basic_rate = rs.rates[0] & WLC_RATE_MASK;
 		}
 
-		wlc_write_rate_shm(wlc, rate, basic_rate);
+		brcms_c_write_rate_shm(wlc, rate, basic_rate);
 	}
 }
 
@@ -5134,14 +5144,14 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, ratespec_t rspec, int band,
 			return true;
  error:
 	if (verbose) {
-		wiphy_err(wlc->wiphy, "wl%d: wlc_valid_rate: rate spec 0x%x "
+		wiphy_err(wlc->wiphy, "wl%d: valid_rate: rate spec 0x%x "
 			  "not in hw_rateset\n", wlc->pub->unit, rspec);
 	}
 
 	return false;
 }
 
-static void wlc_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
+static void brcms_c_update_mimo_band_bwcap(struct brcms_c_info *wlc, u8 bwcap)
 {
 	uint i;
 	struct brcms_c_band *band;
@@ -5177,7 +5187,7 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 
 	sifs = SIFS(wlc->band);
 
-	rs_dflt = wlc_rateset_get_hwrs(wlc);
+	rs_dflt = brcms_c_rateset_get_hwrs(wlc);
 
 	brcms_c_rateset_copy(rs_dflt, &rs);
 	brcms_c_rateset_mcs_upd(&rs, wlc->stf->txstreams);
@@ -5186,7 +5196,7 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
 	for (i = 0; i < rs.count; i++) {
 		rate = rs.rates[i] & WLC_RATE_MASK;
 
-		entry_ptr = wlc_rate_shm_offset(wlc, rate);
+		entry_ptr = brcms_c_rate_shm_offset(wlc, rate);
 
 		/* Calculate the Probe Response PLCP for the given rate */
 		brcms_c_compute_plcp(wlc, rate, frame_len, plcp);
@@ -5219,8 +5229,9 @@ void brcms_c_mod_prb_rsp_rate_table(struct brcms_c_info *wlc, uint frame_len)
  *	and included up to, but not including, the 4 byte FCS.
  */
 static void
-wlc_bcn_prb_template(struct brcms_c_info *wlc, u16 type, ratespec_t bcn_rspec,
-		     struct brcms_c_bsscfg *cfg, u16 *buf, int *len)
+brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
+			 ratespec_t bcn_rspec,
+			 struct brcms_c_bsscfg *cfg, u16 *buf, int *len)
 {
 	static const u8 ether_bcast[ETH_ALEN] = {255, 255, 255, 255, 255, 255};
 	cck_phy_hdr_t *plcp;
@@ -5320,7 +5331,7 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 		wlc->bcn_rspec =
 		    brcms_c_lowest_basic_rspec(wlc, &cfg->current_bss->rateset);
 		/* update the template and ucode shm */
-		wlc_bcn_prb_template(wlc, IEEE80211_STYPE_BEACON,
+		brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_BEACON,
 				     wlc->bcn_rspec, cfg, bcn, &len);
 		brcms_c_write_hw_bcntemplates(wlc, bcn, len, false);
 	}
@@ -5382,8 +5393,8 @@ brcms_c_bss_update_probe_resp(struct brcms_c_info *wlc,
 	if (!MBSS_PRB_ENAB(cfg)) {
 
 		/* create the probe response template */
-		wlc_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0, cfg,
-				     prb_resp, &len);
+		brcms_c_bcn_prb_template(wlc, IEEE80211_STYPE_PROBE_RESP, 0,
+					 cfg, prb_resp, &len);
 
 		if (suspend)
 			brcms_c_suspend_mac_and_wait(wlc);
@@ -5425,7 +5436,8 @@ int brcms_c_prep_pdu(struct brcms_c_info *wlc, struct sk_buff *pdu, uint *fifop)
 	txh = (d11txh_t *) (pdu->data);
 	h = (struct ieee80211_hdr *)((u8 *) (txh + 1) + D11_PHY_HDR_LEN);
 
-	/* get the pkt queue info. This was put at wlc_sendctl or wlc_send for PDU */
+	/* get the pkt queue info. This was put at brcms_c_sendctl or
+	 * brcms_c_send for PDU */
 	fifo = le16_to_cpu(txh->TxFrameID) & TXFID_QUEUE_MASK;
 
 	scb = NULL;
@@ -5468,7 +5480,7 @@ void brcms_default_rateset(struct brcms_c_info *wlc, wlc_rateset_t *rs)
 		wlc->stf->txstreams);
 }
 
-static void wlc_bss_default_init(struct brcms_c_info *wlc)
+static void brcms_c_bss_default_init(struct brcms_c_info *wlc)
 {
 	chanspec_t chanspec;
 	struct brcms_c_band *band;
@@ -5619,7 +5631,7 @@ done:
 
 /* formula:  IDLE_BUSY_RATIO_X_16 = (100-duty_cycle)/duty_cycle*16 */
 static int
-wlc_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
+brcms_c_duty_cycle_set(struct brcms_c_info *wlc, int duty_cycle, bool isOFDM,
 		   bool writeToShm)
 {
 	int idle_busy_ratio_x_16 = 0;
@@ -5779,7 +5791,7 @@ void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
 		return;
 	}
 
-	wlc_txflowcontrol_signal(wlc, qi, on, prio);
+	brcms_c_txflowcontrol_signal(wlc, qi, on, prio);
 }
 
 void
@@ -5803,7 +5815,7 @@ brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
 			return;
 		}
 
-		wlc_txflowcontrol_signal(wlc, qi, ON, ALLPRIO);
+		brcms_c_txflowcontrol_signal(wlc, qi, ON, ALLPRIO);
 	} else {
 		mboolclr(qi->stopped, override);
 		/* clearing an override bit will only make a difference for
@@ -5815,34 +5827,34 @@ brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
 		}
 
 		if (qi->stopped == 0) {
-			wlc_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
+			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
 		} else {
 			int prio;
 
 			for (prio = MAXPRIO; prio >= 0; prio--) {
 				if (!mboolisset(qi->stopped, NBITVAL(prio)))
-					wlc_txflowcontrol_signal(wlc, qi, OFF,
-								 prio);
+					brcms_c_txflowcontrol_signal(
+						wlc, qi, OFF, prio);
 			}
 		}
 	}
 }
 
-static void wlc_txflowcontrol_reset(struct brcms_c_info *wlc)
+static void brcms_c_txflowcontrol_reset(struct brcms_c_info *wlc)
 {
 	struct brcms_c_txq_info *qi;
 
 	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
 		if (qi->stopped) {
-			wlc_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
+			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
 			qi->stopped = 0;
 		}
 	}
 }
 
 static void
-wlc_txflowcontrol_signal(struct brcms_c_info *wlc, struct brcms_c_txq_info *qi,
-			 bool on, int prio)
+brcms_c_txflowcontrol_signal(struct brcms_c_info *wlc,
+			     struct brcms_c_txq_info *qi, bool on, int prio)
 {
 #ifdef NON_FUNCTIONAL
 	/* wlcif_list is never filled so this function is not functional */
@@ -5855,7 +5867,7 @@ wlc_txflowcontrol_signal(struct brcms_c_info *wlc, struct brcms_c_txq_info *qi,
 #endif
 }
 
-static struct brcms_c_txq_info *wlc_txq_alloc(struct brcms_c_info *wlc)
+static struct brcms_c_txq_info *brcms_c_txq_alloc(struct brcms_c_info *wlc)
 {
 	struct brcms_c_txq_info *qi, *p;
 
@@ -5884,7 +5896,8 @@ static struct brcms_c_txq_info *wlc_txq_alloc(struct brcms_c_info *wlc)
 	return qi;
 }
 
-static void wlc_txq_free(struct brcms_c_info *wlc, struct brcms_c_txq_info *qi)
+static void brcms_c_txq_free(struct brcms_c_info *wlc,
+			     struct brcms_c_txq_info *qi)
 {
 	struct brcms_c_txq_info *p;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index 728b9e2..915efdf 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -177,13 +177,14 @@ void wlapi_bmac_core_phypll_reset(wlc_phy_shim_info_t *physhim)
 
 void wlapi_bmac_ucode_wake_override_phyreg_set(wlc_phy_shim_info_t *physhim)
 {
-	wlc_ucode_wake_override_set(physhim->wlc_hw, WLC_WAKE_OVERRIDE_PHYREG);
+	brcms_c_ucode_wake_override_set(physhim->wlc_hw,
+					WLC_WAKE_OVERRIDE_PHYREG);
 }
 
 void wlapi_bmac_ucode_wake_override_phyreg_clear(wlc_phy_shim_info_t *physhim)
 {
-	wlc_ucode_wake_override_clear(physhim->wlc_hw,
-				      WLC_WAKE_OVERRIDE_PHYREG);
+	brcms_c_ucode_wake_override_clear(physhim->wlc_hw,
+					  WLC_WAKE_OVERRIDE_PHYREG);
 }
 
 void
diff --git a/drivers/staging/brcm80211/brcmsmac/pub.h b/drivers/staging/brcm80211/brcmsmac/pub.h
index 8ceab43..2345a31 100644
--- a/drivers/staging/brcm80211/brcmsmac/pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/pub.h
@@ -653,7 +653,7 @@ extern void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc,
 
 /* helper functions */
 extern bool brcms_c_check_radio_disabled(struct brcms_c_info *wlc);
-extern bool wlc_radio_monitor_stop(struct brcms_c_info *wlc);
+extern bool brcms_c_radio_monitor_stop(struct brcms_c_info *wlc);
 
 #define	MAXBANDS		2	/* Maximum #of bands */
 /* bandstate array indices */
-- 
1.7.4.1


