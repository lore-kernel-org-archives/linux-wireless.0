Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:1727 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1JBRPA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Oct 2011 13:15:00 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 20/20] staging: brcm80211: removed functionality to
 disable N mode
Date: Sun, 2 Oct 2011 10:14:45 -0700
Message-ID: <1317575685-3156-21-git-send-email-frankyl@broadcom.com> (sfid-20111002_191528_752471_58248F91)
In-Reply-To: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
References: <1317575685-3156-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

NVRAM contains a parameter that can disable N mode. This functionality
is not needed. As a consequence, brcms_c_protection_upd() could be
simplified.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/channel.c |    2 +-
 drivers/staging/brcm80211/brcmsmac/main.c    |   85 +++++++-------------------
 drivers/staging/brcm80211/brcmsmac/main.h    |    2 +-
 3 files changed, 24 insertions(+), 65 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 7fe005a..2127c27 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -1004,7 +1004,7 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 
 	if ((wlc->pub->_n_enab & SUPPORT_11N) !=
 	    wlc->protection->nmode_user)
-		brcms_c_set_nmode(wlc, wlc->protection->nmode_user);
+		brcms_c_set_nmode(wlc);
 
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_2G_INDEX]);
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index e4dd2d4..de5f5c0 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -5202,7 +5202,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	uint err = 0;
 	uint i, j;
 	struct brcms_pub *pub;
-	uint n_disabled;
 
 	/* allocate struct brcms_c_info state and its substructures */
 	wlc = (struct brcms_c_info *) brcms_c_attach_malloc(unit, &err, device);
@@ -5228,9 +5227,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 	/* update sta/ap related parameters */
 	brcms_c_ap_upd(wlc);
 
-	/* 11n_disable nvram */
-	n_disabled = getintvar(pub->vars, "11n_disable");
-
 	/*
 	 * low level attach steps(all hw accesses go
 	 * inside, no more in rest of the attach)
@@ -5301,17 +5297,11 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 
 		/* init _n_enab supported mode */
 		if (BRCMS_PHY_11N_CAP(wlc->band)) {
-			if (n_disabled & WLFEATURE_DISABLE_11N) {
-				pub->_n_enab = OFF;
-				brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
-						       OFF);
-			} else {
-				pub->_n_enab = SUPPORT_11N;
-				brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
+			pub->_n_enab = SUPPORT_11N;
+			brcms_c_protection_upd(wlc, BRCMS_PROT_N_USER,
 						   ((pub->_n_enab ==
 						     SUPPORT_11N) ? WL_11N_2x2 :
 						    WL_11N_3x3));
-			}
 		}
 
 		/* init per-band default rateset, depend on band->gmode */
@@ -5387,19 +5377,6 @@ brcms_c_attach(struct brcms_info *wl, u16 vendor, u16 device, uint unit,
 		brcms_c_ht_update_sgi_rx(wlc, 0);
 	}
 
-	/* *******nvram 11n config overrides Start ********* */
-
-	if (n_disabled & WLFEATURE_DISABLE_11N_SGI_RX)
-		brcms_c_ht_update_sgi_rx(wlc, 0);
-
-	/* apply the stbc override from nvram conf */
-	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_TX) {
-		wlc->bandstate[BAND_2G_INDEX]->band_stf_stbc_tx = OFF;
-		wlc->bandstate[BAND_5G_INDEX]->band_stf_stbc_tx = OFF;
-	}
-	if (n_disabled & WLFEATURE_DISABLE_11N_STBC_RX)
-		brcms_c_stf_stbc_rx_set(wlc, HT_CAP_RX_STBC_NO);
-
 	/* initialize radio_mpc_disable according to wlc->mpc */
 	brcms_c_radio_mpc_upd(wlc);
 	brcms_b_antsel_set(wlc->hw, wlc->asi->antsel_avail);
@@ -6109,54 +6086,36 @@ static int brcms_c_nmode_validate(struct brcms_c_info *wlc, s32 nmode)
 	return err;
 }
 
-int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode)
+int brcms_c_set_nmode(struct brcms_c_info *wlc)
 {
 	uint i;
 	int err;
+	s32 nmode = AUTO;
 
 	err = brcms_c_nmode_validate(wlc, nmode);
 	if (err)
 		return err;
 
-	switch (nmode) {
-	case OFF:
-		wlc->pub->_n_enab = OFF;
-		wlc->default_bss->flags &= ~BRCMS_BSS_HT;
-		/* delete the mcs rates from the default and hw ratesets */
-		brcms_c_rateset_mcs_clear(&wlc->default_bss->rateset);
-		for (i = 0; i < wlc->pub->_nbands; i++) {
-			memset(wlc->bandstate[i]->hw_rateset.mcs, 0,
-			       MCSSET_LEN);
-		}
-		break;
-
-	case AUTO:
-		if (wlc->stf->txstreams == WL_11N_3x3)
-			nmode = WL_11N_3x3;
-		else
-			nmode = WL_11N_2x2;
-	case WL_11N_2x2:
-	case WL_11N_3x3:
-		/* force GMODE_AUTO if NMODE is ON */
-		brcms_c_set_gmode(wlc, GMODE_AUTO, true);
-		if (nmode == WL_11N_3x3)
-			wlc->pub->_n_enab = SUPPORT_HT;
-		else
-			wlc->pub->_n_enab = SUPPORT_11N;
-		wlc->default_bss->flags |= BRCMS_BSS_HT;
-		/* add the mcs rates to the default and hw ratesets */
-		brcms_c_rateset_mcs_build(&wlc->default_bss->rateset,
-				      wlc->stf->txstreams);
-		for (i = 0; i < wlc->pub->_nbands; i++)
-			memcpy(wlc->bandstate[i]->hw_rateset.mcs,
-			       wlc->default_bss->rateset.mcs, MCSSET_LEN);
-		break;
+	if (wlc->stf->txstreams == WL_11N_3x3)
+		nmode = WL_11N_3x3;
+	else
+		nmode = WL_11N_2x2;
 
-	default:
-		break;
-	}
+	/* force GMODE_AUTO if NMODE is ON */
+	brcms_c_set_gmode(wlc, GMODE_AUTO, true);
+	if (nmode == WL_11N_3x3)
+		wlc->pub->_n_enab = SUPPORT_HT;
+	else
+		wlc->pub->_n_enab = SUPPORT_11N;
+	wlc->default_bss->flags |= BRCMS_BSS_HT;
+	/* add the mcs rates to the default and hw ratesets */
+	brcms_c_rateset_mcs_build(&wlc->default_bss->rateset,
+			      wlc->stf->txstreams);
+	for (i = 0; i < wlc->pub->_nbands; i++)
+		memcpy(wlc->bandstate[i]->hw_rateset.mcs,
+		       wlc->default_bss->rateset.mcs, MCSSET_LEN);
 
-	return err;
+	return 0;
 }
 
 static int
diff --git a/drivers/staging/brcm80211/brcmsmac/main.h b/drivers/staging/brcm80211/brcmsmac/main.h
index 8815042..e458916 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.h
+++ b/drivers/staging/brcm80211/brcmsmac/main.h
@@ -799,7 +799,7 @@ extern void brcms_c_set_chanspec(struct brcms_c_info *wlc,
 
 extern bool brcms_c_timers_init(struct brcms_c_info *wlc, int unit);
 
-extern int brcms_c_set_nmode(struct brcms_c_info *wlc, s32 nmode);
+extern int brcms_c_set_nmode(struct brcms_c_info *wlc);
 extern void brcms_c_mimops_action_ht_send(struct brcms_c_info *wlc,
 				      struct brcms_bss_cfg *bsscfg,
 				      u8 mimops_mode);
-- 
1.7.1


