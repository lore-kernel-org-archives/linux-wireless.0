Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2278 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752052Ab1ECJgR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 05:36:17 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: "Roland Vossen" <rvossen@broadcom.com>,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Brett Rudley" <brudley@broadcom.com>,
	"Henry Ptasinski" <henryp@broadcom.com>
Subject: [PATCH 08/61] staging: brcm80211: replaced WL_ERROR in
 wlc_bmac.c
Date: Tue, 3 May 2011 11:35:08 +0200
Message-ID: <1304415361-7813-9-git-send-email-arend@broadcom.com> (sfid-20110503_113849_085976_8CD87176)
In-Reply-To: <1304415361-7813-1-git-send-email-arend@broadcom.com>
References: <1304415361-7813-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup. Replaced proprietary function by wiphy_err().

Cc: devel@linuxdriverproject.org
Cc: linux-wireless@vger.kernel.org
Cc: Brett Rudley <brudley@broadcom.com>
Cc: Henry Ptasinski <henryp@broadcom.com>
Cc: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_bmac.c |  210 ++++++++++++++-----------
 1 files changed, 121 insertions(+), 89 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
index 9c4b313..8c17518 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_bmac.c
@@ -200,6 +200,8 @@ static void wlc_bmac_update_slot_timing(struct wlc_hw_info *wlc_hw,
 
 static void WLBANDINITFN(wlc_ucode_bsinit) (struct wlc_hw_info *wlc_hw)
 {
+	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
+
 	/* init microcode host flags */
 	wlc_write_mhf(wlc_hw, wlc_hw->band->mhfs);
 
@@ -208,20 +210,21 @@ static void WLBANDINITFN(wlc_ucode_bsinit) (struct wlc_hw_info *wlc_hw)
 		if (WLCISNPHY(wlc_hw->band)) {
 			wlc_write_inits(wlc_hw, d11n0bsinitvals16);
 		} else {
-			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
-				 __func__, wlc_hw->unit, wlc_hw->corerev);
+			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
+				  " %d\n", __func__, wlc_hw->unit,
+				  wlc_hw->corerev);
 		}
 	} else {
 		if (D11REV_IS(wlc_hw->corerev, 24)) {
 			if (WLCISLCNPHY(wlc_hw->band)) {
 				wlc_write_inits(wlc_hw, d11lcn0bsinitvals24);
 			} else
-				WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
-					 __func__, wlc_hw->unit,
-					 wlc_hw->corerev);
+				wiphy_err(wiphy, "%s: wl%d: unsupported phy in"
+					  " core rev %d\n", __func__,
+					  wlc_hw->unit, wlc_hw->corerev);
 		} else {
-			WL_ERROR("%s: wl%d: unsupported corerev %d\n",
-				 __func__, wlc_hw->unit, wlc_hw->corerev);
+			wiphy_err(wiphy, "%s: wl%d: unsupported corerev %d\n",
+				__func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	}
 }
@@ -320,9 +323,11 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	bool fatal = false;
+	struct wiphy *wiphy = wlc->wiphy;
 
 	if (DEVICEREMOVED(wlc)) {
-		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
+		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+			  __func__);
 		wl_down(wlc->wl);
 		return false;
 	}
@@ -355,7 +360,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 		if (wlc_bmac_txstatus(wlc->hw, bounded, &fatal))
 			wlc->macintstatus |= MI_TFS;
 		if (fatal) {
-			WL_ERROR("MI_TFS: fatal\n");
+			wiphy_err(wiphy, "MI_TFS: fatal\n");
 			goto fatal;
 		}
 	}
@@ -386,7 +391,7 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	/* TX FIFO suspend/flush completion */
 	if (macintstatus & MI_TXSTOP) {
 		if (wlc_bmac_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO)) {
-			/*      WL_ERROR("dpc: fifo_suspend_comlete\n"); */
+			/* wiphy_err(wiphy, "dpc: fifo_suspend_comlete\n"); */
 		}
 	}
 
@@ -396,8 +401,8 @@ bool BCMFASTPATH wlc_dpc(struct wlc_info *wlc, bool bounded)
 	}
 
 	if (macintstatus & MI_GP0) {
-		WL_ERROR("wl%d: PSM microcode watchdog fired at %d (seconds). Resetting.\n",
-			 wlc_hw->unit, wlc_hw->now);
+		wiphy_err(wiphy, "wl%d: PSM microcode watchdog fired at %d "
+			"(seconds). Resetting.\n", wlc_hw->unit, wlc_hw->now);
 
 		printk_once("%s : PSM Watchdog, chipid 0x%x, chiprev 0x%x\n",
 					__func__, wlc_hw->sih->chip,
@@ -522,6 +527,7 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 	uint unit = wlc_hw->unit;
 	wlc_tunables_t *tune = wlc->pub->tunables;
+	struct wiphy *wiphy = wlc->wiphy;
 
 	/* name and offsets for dma_attach */
 	snprintf(name, sizeof(name), "wl%d", unit);
@@ -537,8 +543,8 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 		    dma_addrwidth(wlc_hw->sih, DMAREG(wlc_hw, DMA_TX, 0));
 
 		if (!wl_alloc_dma_resources(wlc_hw->wlc->wl, addrwidth)) {
-			WL_ERROR("wl%d: wlc_attach: alloc_dma_resources failed\n",
-				 unit);
+			wiphy_err(wiphy, "wl%d: wlc_attach: alloc_dma_"
+				  "resources failed\n", unit);
 			return false;
 		}
 
@@ -590,7 +596,8 @@ static bool wlc_bmac_attach_dmapio(struct wlc_info *wlc, uint j, bool wme)
 /* Cleaner to leave this as if with AP defined */
 
 		if (dma_attach_err) {
-			WL_ERROR("wl%d: wlc_attach: dma_attach failed\n", unit);
+			wiphy_err(wiphy, "wl%d: wlc_attach: dma_attach failed"
+				  "\n", unit);
 			return false;
 		}
 
@@ -637,6 +644,7 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	uint j;
 	bool wme = false;
 	shared_phy_params_t sha_params;
+	struct wiphy *wiphy = wlc->wiphy;
 
 	WL_TRACE("wl%d: wlc_bmac_attach: vendor 0x%x device 0x%x\n",
 		 unit, vendor, device);
@@ -661,7 +669,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->sih = si_attach((uint) device, regsva, bustype, btparam,
 				&wlc_hw->vars, &wlc_hw->vars_size);
 	if (wlc_hw->sih == NULL) {
-		WL_ERROR("wl%d: wlc_bmac_attach: si_attach failed\n", unit);
+		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: si_attach failed\n",
+			  unit);
 		err = 11;
 		goto fail;
 	}
@@ -681,21 +690,23 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		var = getvar(vars, "vendid");
 		if (var) {
 			vendor = (u16) simple_strtoul(var, NULL, 0);
-			WL_ERROR("Overriding vendor id = 0x%x\n", vendor);
+			wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
+				  vendor);
 		}
 		var = getvar(vars, "devid");
 		if (var) {
 			u16 devid = (u16) simple_strtoul(var, NULL, 0);
 			if (devid != 0xffff) {
 				device = devid;
-				WL_ERROR("Overriding device id = 0x%x\n",
-					 device);
+				wiphy_err(wiphy, "Overriding device id = 0x%x"
+					  "\n", device);
 			}
 		}
 
 		/* verify again the device is supported */
 		if (!wlc_chipmatch(vendor, device)) {
-			WL_ERROR("wl%d: wlc_bmac_attach: Unsupported vendor/device (0x%x/0x%x)\n",
+			wiphy_err(wiphy, "wl%d: wlc_bmac_attach: Unsupported "
+				"vendor/device (0x%x/0x%x)\n",
 				 unit, vendor, device);
 			err = 12;
 			goto fail;
@@ -731,8 +742,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_bmac_corereset(wlc_hw, WLC_USE_COREFLAGS);
 
 	if (!wlc_bmac_validate_chip_access(wlc_hw)) {
-		WL_ERROR("wl%d: wlc_bmac_attach: validate_chip_access failed\n",
-			 unit);
+		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: validate_chip_access "
+			"failed\n", unit);
 		err = 14;
 		goto fail;
 	}
@@ -744,7 +755,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 		j = BOARDREV_PROMOTED;
 	wlc_hw->boardrev = (u16) j;
 	if (!wlc_validboardtype(wlc_hw)) {
-		WL_ERROR("wl%d: wlc_bmac_attach: Unsupported Broadcom board type (0x%x)" " or revision level (0x%x)\n",
+		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: Unsupported Broadcom "
+			"board type (0x%x)" " or revision level (0x%x)\n",
 			 unit, wlc_hw->sih->boardtype, wlc_hw->boardrev);
 		err = 15;
 		goto fail;
@@ -786,8 +798,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	wlc_hw->physhim = wlc_phy_shim_attach(wlc_hw, wlc->wl, wlc);
 
 	if (wlc_hw->physhim == NULL) {
-		WL_ERROR("wl%d: wlc_bmac_attach: wlc_phy_shim_attach failed\n",
-			 unit);
+		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: wlc_phy_shim_attach "
+			"failed\n", unit);
 		err = 25;
 		goto fail;
 	}
@@ -852,8 +864,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 			(void *)regs, wlc_bmac_bandtype(wlc_hw), vars,
 			wlc->wiphy);
 		if (wlc_hw->band->pi == NULL) {
-			WL_ERROR("wl%d: wlc_bmac_attach: wlc_phy_attach failed\n",
-				 unit);
+			wiphy_err(wiphy, "wl%d: wlc_bmac_attach: wlc_phy_"
+				  "attach failed\n", unit);
 			err = 17;
 			goto fail;
 		}
@@ -883,9 +895,9 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 				goto bad_phy;
 		} else {
  bad_phy:
-			WL_ERROR("wl%d: wlc_bmac_attach: unsupported phy type/rev (%d/%d)\n",
-				 unit,
-				 wlc_hw->band->phytype, wlc_hw->band->phyrev);
+			wiphy_err(wiphy, "wl%d: wlc_bmac_attach: unsupported "
+				  "phy type/rev (%d/%d)\n", unit,
+				  wlc_hw->band->phytype, wlc_hw->band->phyrev);
 			err = 18;
 			goto fail;
 		}
@@ -940,15 +952,16 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	/* init etheraddr state variables */
 	macaddr = wlc_get_macaddr(wlc_hw);
 	if (macaddr == NULL) {
-		WL_ERROR("wl%d: wlc_bmac_attach: macaddr not found\n", unit);
+		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: macaddr not found\n",
+			  unit);
 		err = 21;
 		goto fail;
 	}
 	bcm_ether_atoe(macaddr, wlc_hw->etheraddr);
 	if (is_broadcast_ether_addr(wlc_hw->etheraddr) ||
 	    is_zero_ether_addr(wlc_hw->etheraddr)) {
-		WL_ERROR("wl%d: wlc_bmac_attach: bad macaddr %s\n",
-			 unit, macaddr);
+		wiphy_err(wiphy, "wl%d: wlc_bmac_attach: bad macaddr %s\n",
+			  unit, macaddr);
 		err = 22;
 		goto fail;
 	}
@@ -960,7 +973,8 @@ int wlc_bmac_attach(struct wlc_info *wlc, u16 vendor, u16 device, uint unit,
 	return err;
 
  fail:
-	WL_ERROR("wl%d: wlc_bmac_attach: failed with err %d\n", unit, err);
+	wiphy_err(wiphy, "wl%d: wlc_bmac_attach: failed with err %d\n", unit,
+		  err);
 	return err;
 }
 
@@ -1999,7 +2013,8 @@ static bool wlc_isgoodchip(struct wlc_hw_info *wlc_hw)
 
 	/* reject unsupported corerev */
 	if (!VALID_COREREV(wlc_hw->corerev)) {
-		WL_ERROR("unsupported core rev %d\n", wlc_hw->corerev);
+		wiphy_err(wlc_hw->wlc->wiphy, "unsupported core rev %d\n",
+			  wlc_hw->corerev);
 		return false;
 	}
 
@@ -2047,8 +2062,8 @@ static char *wlc_get_macaddr(struct wlc_hw_info *wlc_hw)
 
 	macaddr = getvar(wlc_hw->vars, varname);
 	if (macaddr == NULL) {
-		WL_ERROR("wl%d: wlc_get_macaddr: macaddr getvar(%s) not found\n",
-			 wlc_hw->unit, varname);
+		wiphy_err(wlc_hw->wlc->wiphy, "wl%d: wlc_get_macaddr: macaddr "
+			  "getvar(%s) not found\n", wlc_hw->unit, varname);
 	}
 
 	return macaddr;
@@ -2182,14 +2197,16 @@ void wlc_bmac_corereset(struct wlc_hw_info *wlc_hw, u32 flags)
 	if (ai_iscoreup(wlc_hw->sih)) {
 		for (i = 0; i < NFIFO; i++)
 			if ((wlc_hw->di[i]) && (!dma_txreset(wlc_hw->di[i]))) {
-				WL_ERROR("wl%d: %s: dma_txreset[%d]: cannot stop dma\n",
-					 wlc_hw->unit, __func__, i);
+				wiphy_err(wlc_hw->wlc->wiphy, "wl%d: %s: "
+					  "dma_txreset[%d]: cannot stop dma\n",
+					   wlc_hw->unit, __func__, i);
 			}
 
 		if ((wlc_hw->di[RX_FIFO])
 		    && (!wlc_dma_rxreset(wlc_hw, RX_FIFO))) {
-			WL_ERROR("wl%d: %s: dma_rxreset[%d]: cannot stop dma\n",
-				 wlc_hw->unit, __func__, RX_FIFO);
+			wiphy_err(wlc_hw->wlc->wiphy, "wl%d: %s: dma_rxreset"
+				  "[%d]: cannot stop dma\n",
+				  wlc_hw->unit, __func__, RX_FIFO);
 		}
 	}
 	/* if noreset, just stop the psm and return */
@@ -2305,6 +2322,7 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	bool fifosz_fixup = false;
 	int err = 0;
 	u16 buf[NFIFO];
+	struct wiphy *wiphy = wlc->wiphy;
 
 	regs = wlc_hw->regs;
 
@@ -2328,8 +2346,8 @@ static void wlc_coreinit(struct wlc_info *wlc)
 	SPINWAIT(((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0),
 		 1000 * 1000);
 	if ((R_REG(&regs->macintstatus) & MI_MACSSPNDD) == 0)
-		WL_ERROR("wl%d: wlc_coreinit: ucode did not self-suspend!\n",
-			 wlc_hw->unit);
+		wiphy_err(wiphy, "wl%d: wlc_coreinit: ucode did not self-"
+			  "suspend!\n", wlc_hw->unit);
 
 	wlc_gpio_init(wlc);
 
@@ -2339,18 +2357,20 @@ static void wlc_coreinit(struct wlc_info *wlc)
 		if (WLCISNPHY(wlc_hw->band))
 			wlc_write_inits(wlc_hw, d11n0initvals16);
 		else
-			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
-				 __func__, wlc_hw->unit, wlc_hw->corerev);
+			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
+				  " %d\n", __func__, wlc_hw->unit,
+				  wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (WLCISLCNPHY(wlc_hw->band)) {
 			wlc_write_inits(wlc_hw, d11lcn0initvals24);
 		} else {
-			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
-				 __func__, wlc_hw->unit, wlc_hw->corerev);
+			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
+				  " %d\n", __func__, wlc_hw->unit,
+				  wlc_hw->corerev);
 		}
 	} else {
-		WL_ERROR("%s: wl%d: unsupported corerev %d\n",
-			 __func__, wlc_hw->unit, wlc_hw->corerev);
+		wiphy_err(wiphy, "%s: wl%d: unsupported corerev %d\n",
+			  __func__, wlc_hw->unit, wlc_hw->corerev);
 	}
 
 	/* For old ucode, txfifo sizes needs to be modified(increased) */
@@ -2392,8 +2412,9 @@ static void wlc_coreinit(struct wlc_info *wlc)
 		err = -1;
 	}
 	if (err != 0) {
-		WL_ERROR("wlc_coreinit: txfifo mismatch: ucode size %d driver size %d index %d\n",
-			 buf[i], wlc_hw->xmtfifo_sz[i], i);
+		wiphy_err(wiphy, "wlc_coreinit: txfifo mismatch: ucode size %d"
+			  " driver size %d index %d\n", buf[i],
+			  wlc_hw->xmtfifo_sz[i], i);
 		ASSERT(0);
 	}
 
@@ -2588,16 +2609,18 @@ static void wlc_ucode_download(struct wlc_hw_info *wlc_hw)
 					bcm43xx_16_mimosz);
 			wlc_hw->ucode_loaded = true;
 		} else
-			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
-				 __func__, wlc_hw->unit, wlc_hw->corerev);
+			wiphy_err(wlc->wiphy, "%s: wl%d: unsupported phy in "
+				  "corerev %d\n",
+				  __func__, wlc_hw->unit, wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
 		if (WLCISLCNPHY(wlc_hw->band)) {
 			wlc_ucode_write(wlc_hw, bcm43xx_24_lcn,
 					bcm43xx_24_lcnsz);
 			wlc_hw->ucode_loaded = true;
 		} else {
-			WL_ERROR("%s: wl%d: unsupported phy in corerev %d\n",
-				 __func__, wlc_hw->unit, wlc_hw->corerev);
+			wiphy_err(wlc->wiphy, "%s: wl%d: unsupported phy in "
+				  "corerev %d\n",
+				  __func__, wlc_hw->unit, wlc_hw->corerev);
 		}
 	}
 }
@@ -2690,6 +2713,7 @@ void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
 	uint unit;
 	uint intstatus, idx;
 	d11regs_t *regs = wlc_hw->regs;
+	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	unit = wlc_hw->unit;
 
@@ -2704,41 +2728,42 @@ void wlc_bmac_fifoerrors(struct wlc_hw_info *wlc_hw)
 			 unit, idx, intstatus);
 
 		if (intstatus & I_RO) {
-			WL_ERROR("wl%d: fifo %d: receive fifo overflow\n",
-				 unit, idx);
+			wiphy_err(wiphy, "wl%d: fifo %d: receive fifo "
+				  "overflow\n", unit, idx);
 			wlc_hw->wlc->pub->_cnt->rxoflo++;
 			fatal = true;
 		}
 
 		if (intstatus & I_PC) {
-			WL_ERROR("wl%d: fifo %d: descriptor error\n",
+			wiphy_err(wiphy, "wl%d: fifo %d: descriptor error\n",
 				 unit, idx);
 			wlc_hw->wlc->pub->_cnt->dmade++;
 			fatal = true;
 		}
 
 		if (intstatus & I_PD) {
-			WL_ERROR("wl%d: fifo %d: data error\n", unit, idx);
+			wiphy_err(wiphy, "wl%d: fifo %d: data error\n", unit,
+				  idx);
 			wlc_hw->wlc->pub->_cnt->dmada++;
 			fatal = true;
 		}
 
 		if (intstatus & I_DE) {
-			WL_ERROR("wl%d: fifo %d: descriptor protocol error\n",
-				 unit, idx);
+			wiphy_err(wiphy, "wl%d: fifo %d: descriptor protocol "
+				  "error\n", unit, idx);
 			wlc_hw->wlc->pub->_cnt->dmape++;
 			fatal = true;
 		}
 
 		if (intstatus & I_RU) {
-			WL_ERROR("wl%d: fifo %d: receive descriptor underflow\n",
-				 idx, unit);
+			wiphy_err(wiphy, "wl%d: fifo %d: receive descriptor "
+				  "underflow\n", idx, unit);
 			wlc_hw->wlc->pub->_cnt->rxuflo[idx]++;
 		}
 
 		if (intstatus & I_XU) {
-			WL_ERROR("wl%d: fifo %d: transmit fifo underflow\n",
-				 idx, unit);
+			wiphy_err(wiphy, "wl%d: fifo %d: transmit fifo "
+				  "underflow\n", idx, unit);
 			wlc_hw->wlc->pub->_cnt->txuflo++;
 			fatal = true;
 		}
@@ -3038,7 +3063,8 @@ bool BCMFASTPATH wlc_isr(struct wlc_info *wlc, bool *wantdpc)
 	macintstatus = wlc_intstatus(wlc, true);
 
 	if (macintstatus == 0xffffffff)
-		WL_ERROR("DEVICEREMOVED detected in the ISR code path\n");
+		wiphy_err(wlc->wiphy, "DEVICEREMOVED detected in the ISR code"
+			  " path\n");
 
 	/* it is not for us */
 	if (macintstatus == 0)
@@ -3096,7 +3122,7 @@ wlc_bmac_txstatus(struct wlc_hw_info *wlc_hw, bool bound, bool *fatal)
 	       && (s1 = R_REG(&regs->frmtxstatus)) & TXS_V) {
 
 		if (s1 == 0xffffffff) {
-			WL_ERROR("wl%d: %s: dead chip\n",
+			wiphy_err(wlc->wiphy, "wl%d: %s: dead chip\n",
 				wlc_hw->unit, __func__);
 			ASSERT(s1 != 0xffffffff);
 			return morepending;
@@ -3134,6 +3160,7 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	struct wlc_hw_info *wlc_hw = wlc->hw;
 	d11regs_t *regs = wlc_hw->regs;
 	u32 mc, mi;
+	struct wiphy *wiphy = wlc->wiphy;
 
 	WL_TRACE("wl%d: wlc_suspend_mac_and_wait: bandunit %d\n",
 		 wlc_hw->unit, wlc_hw->band->bandunit);
@@ -3151,7 +3178,8 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 	mc = R_REG(&regs->maccontrol);
 
 	if (mc == 0xffffffff) {
-		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
+		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+			  __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -3161,7 +3189,8 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 
 	mi = R_REG(&regs->macintstatus);
 	if (mi == 0xffffffff) {
-		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
+		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+			  __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -3173,18 +3202,20 @@ void wlc_suspend_mac_and_wait(struct wlc_info *wlc)
 		 WLC_MAX_MAC_SUSPEND);
 
 	if (!(R_REG(&regs->macintstatus) & MI_MACSSPNDD)) {
-		WL_ERROR("wl%d: wlc_suspend_mac_and_wait: waited %d uS and MI_MACSSPNDD is still not on.\n",
-			 wlc_hw->unit, WLC_MAX_MAC_SUSPEND);
-		WL_ERROR("wl%d: psmdebug 0x%08x, phydebug 0x%08x, psm_brc 0x%04x\n",
-			 wlc_hw->unit,
-			 R_REG(&regs->psmdebug),
-			 R_REG(&regs->phydebug),
-			 R_REG(&regs->psm_brc));
+		wiphy_err(wiphy, "wl%d: wlc_suspend_mac_and_wait: waited %d uS"
+			  " and MI_MACSSPNDD is still not on.\n",
+			  wlc_hw->unit, WLC_MAX_MAC_SUSPEND);
+		wiphy_err(wiphy, "wl%d: psmdebug 0x%08x, phydebug 0x%08x, "
+			  "psm_brc 0x%04x\n", wlc_hw->unit,
+			  R_REG(&regs->psmdebug),
+			  R_REG(&regs->phydebug),
+			  R_REG(&regs->psm_brc));
 	}
 
 	mc = R_REG(&regs->maccontrol);
 	if (mc == 0xffffffff) {
-		WL_ERROR("wl%d: %s: dead chip\n", wlc_hw->unit, __func__);
+		wiphy_err(wiphy, "wl%d: %s: dead chip\n", wlc_hw->unit,
+			  __func__);
 		wl_down(wlc->wl);
 		return;
 	}
@@ -3321,6 +3352,7 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 {
 	d11regs_t *regs;
 	u32 w, val;
+	struct wiphy *wiphy = wlc_hw->wlc->wiphy;
 
 	WL_TRACE("wl%d: validate_chip_access\n", wlc_hw->unit);
 
@@ -3341,8 +3373,8 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	(void)R_REG(&regs->objaddr);
 	val = R_REG(&regs->objdata);
 	if (val != (u32) 0xaa5555aa) {
-		WL_ERROR("wl%d: validate_chip_access: SHM = 0x%x, expected 0xaa5555aa\n",
-			 wlc_hw->unit, val);
+		wiphy_err(wiphy, "wl%d: validate_chip_access: SHM = 0x%x, "
+			  "expected 0xaa5555aa\n", wlc_hw->unit, val);
 		return false;
 	}
 
@@ -3354,8 +3386,8 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	(void)R_REG(&regs->objaddr);
 	val = R_REG(&regs->objdata);
 	if (val != (u32) 0x55aaaa55) {
-		WL_ERROR("wl%d: validate_chip_access: SHM = 0x%x, expected 0x55aaaa55\n",
-			 wlc_hw->unit, val);
+		wiphy_err(wiphy, "wl%d: validate_chip_access: SHM = 0x%x, "
+			  "expected 0x55aaaa55\n", wlc_hw->unit, val);
 		return false;
 	}
 
@@ -3369,10 +3401,10 @@ static bool wlc_bmac_validate_chip_access(struct wlc_hw_info *wlc_hw)
 	w = R_REG(&regs->maccontrol);
 	if ((w != (MCTL_IHR_EN | MCTL_WAKE)) &&
 	    (w != (MCTL_IHR_EN | MCTL_GMODE | MCTL_WAKE))) {
-		WL_ERROR("wl%d: validate_chip_access: maccontrol = 0x%x, expected 0x%x or 0x%x\n",
-			 wlc_hw->unit, w,
-			 (MCTL_IHR_EN | MCTL_WAKE),
-			 (MCTL_IHR_EN | MCTL_GMODE | MCTL_WAKE));
+		wiphy_err(wiphy, "wl%d: validate_chip_access: maccontrol = "
+			  "0x%x, expected 0x%x or 0x%x\n", wlc_hw->unit, w,
+			  (MCTL_IHR_EN | MCTL_WAKE),
+			  (MCTL_IHR_EN | MCTL_GMODE | MCTL_WAKE));
 		return false;
 	}
 
@@ -3403,8 +3435,8 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 			tmp = R_REG(&regs->clk_ctl_st);
 			if ((tmp & (CCS_ERSRC_AVAIL_HT)) !=
 			    (CCS_ERSRC_AVAIL_HT)) {
-				WL_ERROR("%s: turn on PHY PLL failed\n",
-					 __func__);
+				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on PHY"
+					  " PLL failed\n", __func__);
 				ASSERT(0);
 			}
 		} else {
@@ -3421,8 +3453,8 @@ void wlc_bmac_core_phypll_ctl(struct wlc_hw_info *wlc_hw, bool on)
 			     (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL))
 			    !=
 			    (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL)) {
-				WL_ERROR("%s: turn on PHY PLL failed\n",
-					 __func__);
+				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on "
+					  "PHY PLL failed\n", __func__);
 				ASSERT(0);
 			}
 		}
-- 
1.7.4.1


