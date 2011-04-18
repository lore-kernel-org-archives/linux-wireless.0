Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3926 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752544Ab1DRJcE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Apr 2011 05:32:04 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 1/3] staging: brcm80211: delete ASSERTs in 4 files in
 brcmsmac dir
Date: Mon, 18 Apr 2011 11:31:46 +0200
Message-ID: <1303119108-32487-2-git-send-email-rvossen@broadcom.com>
In-Reply-To: <1303119108-32487-1-git-send-email-rvossen@broadcom.com>
References: <1303119108-32487-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlc_antsel.c, wlc_channel.c, wlc_rate.c and wlc_stf.c are now
ASSERT free.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_antsel.c  |    3 ---
 drivers/staging/brcm80211/brcmsmac/wlc_channel.c |   18 ++----------------
 drivers/staging/brcm80211/brcmsmac/wlc_rate.c    |    6 ++----
 drivers/staging/brcm80211/brcmsmac/wlc_stf.c     |   19 ++-----------------
 4 files changed, 6 insertions(+), 40 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
index 4516377..7a154ab 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_antsel.c
@@ -130,7 +130,6 @@ struct antsel_info *wlc_antsel_attach(struct wlc_info *wlc)
 				asi->antsel_avail = false;
 				dev_err(wlc->dev, "wlc_antsel_attach: 2o3 "
 					"board cfg invalid\n");
-				ASSERT(0);
 			}
 			break;
 		default:
@@ -298,8 +297,6 @@ static int wlc_antsel_cfgupd(struct antsel_info *asi, wlc_antselcfg_t *antsel)
 	u8 ant_cfg;
 	u16 mimo_antsel;
 
-	ASSERT(asi->antsel_type != ANTSEL_NA);
-
 	/* 1) Update TX antconfig for all frames that are not unicast data
 	 *    (aka default TX)
 	 */
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
index 124e9cd..55a741b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_channel.c
@@ -594,8 +594,7 @@ struct chan20_info chan20_info[] = {
 static const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table)) {
-		ASSERT(locale_idx < ARRAY_SIZE(g_locale_2g_table));
-		return NULL;
+		return NULL; /* error condition */
 	}
 	return g_locale_2g_table[locale_idx];
 }
@@ -603,8 +602,7 @@ static const locale_info_t *wlc_get_locale_2g(u8 locale_idx)
 static const locale_info_t *wlc_get_locale_5g(u8 locale_idx)
 {
 	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table)) {
-		ASSERT(locale_idx < ARRAY_SIZE(g_locale_5g_table));
-		return NULL;
+		return NULL; /* error condition */
 	}
 	return g_locale_5g_table[locale_idx];
 }
@@ -659,8 +657,6 @@ wlc_cm_info_t *wlc_channel_mgr_attach(struct wlc_info *wlc)
 	strncpy(country_abbrev, "X2", sizeof(country_abbrev) - 1);
 	country = wlc_country_lookup(wlc, country_abbrev);
 
-	ASSERT(country != NULL);
-
 	/* save default country for exiting 11d regulatory mode */
 	strncpy(wlc->country_default, country_abbrev, WLC_CNTRY_BUF_SZ - 1);
 
@@ -715,7 +711,6 @@ wlc_set_countrycode_rev(wlc_cm_info_t *wlc_cm,
 					&mapped_regrev);
 	} else {
 		/* find the matching built-in country definition */
-		ASSERT(0);
 		country = wlc_country_lookup_direct(ccode, regrev);
 		strncpy(mapped_ccode, ccode, WLC_CNTRY_BUF_SZ);
 		mapped_regrev = regrev;
@@ -745,8 +740,6 @@ wlc_set_country_common(wlc_cm_info_t *wlc_cm,
 	struct wlc_info *wlc = wlc_cm->wlc;
 	char prev_country_abbrev[WLC_CNTRY_BUF_SZ];
 
-	ASSERT(country != NULL);
-
 	/* save current country state */
 	wlc_cm->country = country;
 
@@ -831,7 +824,6 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 		*mapped_regrev = srom_regrev;
 		mapped = 0;
 		dev_err(wlc->dev, "srom_code == ccode %s\n", __func__);
-		ASSERT(0);
 	} else {
 		mapped =
 		    wlc_country_aggregate_map(wlc_cm, ccode, mapped_ccode,
@@ -844,7 +836,6 @@ static const country_info_t *wlc_countrycode_map(wlc_cm_info_t *wlc_cm,
 	/* if there is not an exact rev match, default to rev zero */
 	if (country == NULL && *mapped_regrev != 0) {
 		*mapped_regrev = 0;
-		ASSERT(0);
 		country =
 		    wlc_country_lookup_direct(mapped_ccode, *mapped_regrev);
 	}
@@ -881,8 +872,6 @@ static const country_info_t *wlc_country_lookup_direct(const char *ccode,
 			return &cntry_locales[i].country;
 		}
 	}
-
-	ASSERT(0);
 	return NULL;
 }
 
@@ -903,12 +892,10 @@ wlc_channels_init(wlc_cm_info_t *wlc_cm, const country_info_t *country)
 		li = BAND_5G(band->bandtype) ?
 		    wlc_get_locale_5g(country->locale_5G) :
 		    wlc_get_locale_2g(country->locale_2G);
-		ASSERT(li);
 		wlc_cm->bandstate[band->bandunit].locale_flags = li->flags;
 		li_mimo = BAND_5G(band->bandtype) ?
 		    wlc_get_mimo_5g(country->locale_mimo_5G) :
 		    wlc_get_mimo_2g(country->locale_mimo_2G);
-		ASSERT(li_mimo);
 
 		/* merge the mimo non-mimo locale flags */
 		wlc_cm->bandstate[band->bandunit].locale_flags |=
@@ -1516,7 +1503,6 @@ wlc_valid_chanspec_ext(wlc_cm_info_t *wlc_cm, chanspec_t chspec, bool dualband)
 	if (wf_chspec_malformed(chspec)) {
 		dev_err(wlc->dev, "wl%d: malformed chanspec 0x%x\n",
 			wlc->pub->unit, chspec);
-		ASSERT(0);
 		return false;
 	}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
index 1f3f320..87a2f62 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_rate.c
@@ -315,7 +315,6 @@ wlc_rate_hwrs_filter_sort_validate(wlc_rateset_t *rs,
 	count = 0;
 	for (i = 0; i < hw_rs->count; i++) {
 		r = hw_rs->rates[i] & WLC_RATE_MASK;
-		ASSERT(r <= WLC_MAXRATE);
 		if (rateset[r])
 			rs->rates[count++] = rateset[r];
 	}
@@ -364,8 +363,7 @@ ratespec_t BCMFASTPATH wlc_compute_rspec(d11rxhdr_t *rxh, u8 *plcp)
 		case PRXS0_STDN:
 			/* fallthru */
 		default:
-			/* not supported */
-			ASSERT(0);
+			/* not supported, error condition */
 			break;
 		}
 		if (PLCP3_ISSGI(plcp[3]))
@@ -451,7 +449,7 @@ wlc_rateset_default(wlc_rateset_t *rs_tgt, const wlc_rateset_t *rs_hw,
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_G)) {
 		rs_dflt = &cck_ofdm_rates;
 	} else {
-		ASSERT(0);	/* should not happen */
+		/* should not happen, error condition */
 		rs_dflt = &cck_rates;	/* force cck */
 	}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
index 26f1897..c58ab68 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_stf.c
@@ -69,9 +69,6 @@ const u8 txcore_default[5] = {
 
 static void wlc_stf_stbc_rx_ht_update(struct wlc_info *wlc, int val)
 {
-	ASSERT((val == HT_CAP_RX_STBC_NO)
-	       || (val == HT_CAP_RX_STBC_ONE_STREAM));
-
 	/* MIMOPHYs rev3-6 cannot receive STBC with only one rx core active */
 	if (WLC_STF_SS_STBC_RX(wlc)) {
 		if ((wlc->stf->rxstreams == 1) && (val != HT_CAP_RX_STBC_NO))
@@ -196,8 +193,6 @@ static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
 	WL_TRACE("wl%d: %s: Nsts %d core_mask %x\n",
 		 wlc->pub->unit, __func__, Nsts, core_mask);
 
-	ASSERT((Nsts > 0) && (Nsts <= MAX_STREAMS_SUPPORTED));
-
 	if (WLC_BITSCNT(core_mask) > wlc->stf->txstreams) {
 		core_mask = 0;
 	}
@@ -208,8 +203,6 @@ static int wlc_stf_txcore_set(struct wlc_info *wlc, u8 Nsts, u8 core_mask)
 		core_mask = wlc->stf->txchain;
 	}
 
-	ASSERT(!core_mask || Nsts <= WLC_BITSCNT(core_mask));
-
 	wlc->stf->txcore[Nsts] = core_mask;
 	/* Nsts = 1..4, txcore index = 1..4 */
 	if (Nsts == 1) {
@@ -321,9 +314,6 @@ int wlc_stf_ss_update(struct wlc_info *wlc, struct wlcband *band)
 	if (WLC_STBC_CAP_PHY(wlc) &&
 	    wlc->stf->ss_algosel_auto
 	    && (wlc->stf->ss_algo_channel != (u16) -1)) {
-		ASSERT(isset(&wlc->stf->ss_algo_channel, PHY_TXC1_MODE_CDD)
-		       || isset(&wlc->stf->ss_algo_channel,
-				PHY_TXC1_MODE_SISO));
 		upd_stf_ss = (wlc->stf->no_cddstbc || (wlc->stf->txstreams == 1)
 			      || isset(&wlc->stf->ss_algo_channel,
 				       PHY_TXC1_MODE_SISO)) ? PHY_TXC1_MODE_SISO
@@ -423,9 +413,6 @@ static void _wlc_stf_phy_txant_upd(struct wlc_info *wlc)
 	s8 txant;
 
 	txant = (s8) wlc->stf->txant;
-	ASSERT(txant == ANT_TX_FORCE_0 || txant == ANT_TX_FORCE_1
-	       || txant == ANT_TX_LAST_RX);
-
 	if (WLC_PHY_11N_CAP(wlc->band)) {
 		if (txant == ANT_TX_FORCE_0) {
 			wlc->stf->phytxant = PHY_TXC_ANT_0;
@@ -441,8 +428,8 @@ static void _wlc_stf_phy_txant_upd(struct wlc_info *wlc)
 			if (WLCISLCNPHY(wlc->band) || WLCISSSLPNPHY(wlc->band))
 				wlc->stf->phytxant = PHY_TXC_LCNPHY_ANT_LAST;
 			else {
-				/* keep this assert to catch out of sync wlc->stf->txcore */
-				ASSERT(wlc->stf->txchain > 0);
+				/* catch out of sync wlc->stf->txcore */
+				WARN_ON(wlc->stf->txchain <= 0);
 				wlc->stf->phytxant =
 				    wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
 			}
@@ -506,7 +493,6 @@ static u16 _wlc_stf_phytxchain_sel(struct wlc_info *wlc, ratespec_t rspec)
 	u16 phytxant = wlc->stf->phytxant;
 
 	if (RSPEC_STF(rspec) != PHY_TXC1_MODE_SISO) {
-		ASSERT(wlc->stf->txstreams > 1);
 		phytxant = wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
 	} else if (wlc->stf->txant == ANT_TX_DEF)
 		phytxant = wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
@@ -526,7 +512,6 @@ u16 wlc_stf_d11hdrs_phyctl_txant(struct wlc_info *wlc, ratespec_t rspec)
 
 	/* for non-siso rates or default setting, use the available chains */
 	if (WLCISNPHY(wlc->band)) {
-		ASSERT(wlc->stf->txchain != 0);
 		phytxant = _wlc_stf_phytxchain_sel(wlc, rspec);
 		mask = PHY_TXC_HTANT_MASK;
 	}
-- 
1.7.1


