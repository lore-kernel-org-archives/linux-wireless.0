Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2115 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934694Ab1JENUj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:39 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 08/15] staging: brcm80211: remove invalid variable
 lookup from srom
Date: Wed, 5 Oct 2011 15:20:07 +0200
Message-ID: <1317820814-7083-9-git-send-email-arend@broadcom.com> (sfid-20111005_152054_456309_53AE4553)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the driver several driver variables were looked up that are
not supported by the srom code. These have been removed.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Brett Rudley <brudley@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/aiutils.c     |    6 +--
 drivers/staging/brcm80211/brcmsmac/main.c        |   34 ++--------------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |    6 ----
 3 files changed, 5 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index d44f619..2bc4bb3 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -1109,10 +1109,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 		u32 xtalfreq;
 		si_pmu_init(sih);
 		si_pmu_chip_init(sih);
-		xtalfreq = getintvar(sih, "xtalfreq");
-		/* If xtalfreq var not available, try to measure it */
-		if (xtalfreq == 0)
-			xtalfreq = si_pmu_measure_alpclk(sih);
+
+		xtalfreq = si_pmu_measure_alpclk(sih);
 		si_pmu_pll_init(sih, xtalfreq);
 		si_pmu_res_init(sih);
 		si_pmu_swreg_init(sih);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index f2339a5..cfa918d 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -4557,8 +4557,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	bool wme = false;
 	struct shared_phy_params sha_params;
 	struct wiphy *wiphy = wlc->wiphy;
-	char *var;
-	unsigned long res;
 
 	BCMMSG(wlc->wiphy, "wl%d: vendor 0x%x device 0x%x\n", unit, vendor,
 		device);
@@ -4588,27 +4586,6 @@ static int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device,
 	}
 	vars = wlc_hw->vars;
 
-	/*
-	 * Get vendid/devid nvram overwrites, which could be different
-	 * than those the BIOS recognizes for devices on PCMCIA_BUS,
-	 * SDIO_BUS, and SROMless devices on PCI_BUS.
-	 */
-	var = getvar(wlc_hw->sih, "vendid");
-	if (var && !kstrtoul(var, 0, &res)) {
-		vendor = (u16)res;
-		wiphy_err(wiphy, "Overriding vendor id = 0x%x\n",
-			  vendor);
-	}
-	var = getvar(wlc_hw->sih, "devid");
-	if (var && !kstrtoul(var, 0, &res)) {
-		u16 devid = (u16)res;
-		if (devid != 0xffff) {
-			device = devid;
-			wiphy_err(wiphy, "Overriding device id = 0x%x"
-				  "\n", device);
-		}
-	}
-
 	/* verify again the device is supported */
 	if (!brcms_c_chipmatch(vendor, device)) {
 		wiphy_err(wiphy, "wl%d: brcms_b_attach: Unsupported "
@@ -4928,9 +4905,6 @@ static bool brcms_c_attach_stf_ant_init(struct brcms_c_info *wlc)
 
 	/* get antennas available */
 	aa = (s8) getintvar(sih, bandtype == BRCM_BAND_5G ? "aa5g" : "aa2g");
-	if (aa == 0)
-		aa = (s8) getintvar(sih,
-				    bandtype == BRCM_BAND_5G ? "aa1" : "aa0");
 	if ((aa < 1) || (aa > 15)) {
 		wiphy_err(wlc->wiphy, "wl%d: %s: Invalid antennas available in"
 			  " srom (0x%x), using 3\n", unit, __func__, aa);
@@ -5113,11 +5087,9 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	brcms_b_copyfrom_vars(wlc->hw, &pub->vars, &wlc->vars_size);
 
 
-	/* set maximum allowed duty cycle */
-	wlc->tx_duty_cycle_ofdm =
-	    (u16) getintvar(wlc->hw->sih, "tx_duty_cycle_ofdm");
-	wlc->tx_duty_cycle_cck =
-	    (u16) getintvar(wlc->hw->sih, "tx_duty_cycle_cck");
+	/* disable allowed duty cycle */
+	wlc->tx_duty_cycle_ofdm = 0;
+	wlc->tx_duty_cycle_cck = 0;
 
 	brcms_c_stf_phy_chain_calc(wlc);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index d84e1cf..4bcf305 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4920,12 +4920,6 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 								   "aa2g"));
 	}
 	pi_lcn->lcnphy_cck_dig_filt_type = -1;
-	if (wlapi_getvar(shim, "cckdigfilttype")) {
-		s16 temp;
-		temp = (s16)wlapi_getintvar(shim, "cckdigfilttype");
-		if (temp >= 0)
-			pi_lcn->lcnphy_cck_dig_filt_type = temp;
-	}
 
 	return true;
 }
-- 
1.7.4.1


