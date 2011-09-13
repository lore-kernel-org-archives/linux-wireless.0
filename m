Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4066 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094Ab1IMHuS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Sep 2011 03:50:18 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 12/17] staging: brcm80211: macro cleanup in softmac
 rate.h
Date: Tue, 13 Sep 2011 09:49:52 +0200
Message-ID: <1315900197-7260-13-git-send-email-rvossen@broadcom.com> (sfid-20110913_095045_096927_9728142C)
In-Reply-To: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
References: <1315900197-7260-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Substituted/moved/deleted macro's.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/ampdu.c |   25 ++--
 drivers/staging/brcm80211/brcmsmac/main.c  |  173 +++++++++++++-------------
 drivers/staging/brcm80211/brcmsmac/rate.c  |   16 ++-
 drivers/staging/brcm80211/brcmsmac/rate.h  |  188 +++++++++++++++++-----------
 drivers/staging/brcm80211/brcmsmac/stf.c   |    2 +-
 5 files changed, 220 insertions(+), 184 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 76f4871..47dc27a 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -158,16 +158,16 @@ static void brcms_c_scb_ampdu_update_max_txlen(struct ampdu_info *ampdu, u8 dur)
 	for (mcs = 0; mcs < MCS_TABLE_SIZE; mcs++) {
 		/* rate is in Kbps; dur is in msec ==> len = (rate * dur) / 8 */
 		/* 20MHz, No SGI */
-		rate = MCS_RATE(mcs, false, false);
+		rate = mcs_2_rate(mcs, false, false);
 		ampdu->max_txlen[mcs][0][0] = (rate * dur) >> 3;
 		/* 40 MHz, No SGI */
-		rate = MCS_RATE(mcs, true, false);
+		rate = mcs_2_rate(mcs, true, false);
 		ampdu->max_txlen[mcs][1][0] = (rate * dur) >> 3;
 		/* 20MHz, SGI */
-		rate = MCS_RATE(mcs, false, true);
+		rate = mcs_2_rate(mcs, false, true);
 		ampdu->max_txlen[mcs][0][1] = (rate * dur) >> 3;
 		/* 40 MHz, SGI */
-		rate = MCS_RATE(mcs, true, true);
+		rate = mcs_2_rate(mcs, true, true);
 		ampdu->max_txlen[mcs][1][1] = (rate * dur) >> 3;
 	}
 }
@@ -330,7 +330,7 @@ static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 	/* note : we divide/multiply by 100 to avoid integer overflows */
 	max_mpdu = min_t(u8, fifo->mcs2ampdu_table[FFPLD_MAX_MCS],
 			 AMPDU_NUM_MPDU_LEGACY);
-	phy_rate = MCS_RATE(FFPLD_MAX_MCS, true, false);
+	phy_rate = mcs_2_rate(FFPLD_MAX_MCS, true, false);
 	dma_rate =
 	    (((phy_rate / 100) *
 	      (max_mpdu * FFPLD_MPDU_SIZE - fifo->ampdu_pld_size))
@@ -341,7 +341,7 @@ static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 	dma_rate = dma_rate >> 7;
 	for (i = 0; i < FFPLD_MAX_MCS; i++) {
 		/* shifting to keep it within integer range */
-		phy_rate = MCS_RATE(i, true, false) >> 7;
+		phy_rate = mcs_2_rate(i, true, false) >> 7;
 		if (phy_rate > dma_rate) {
 			tmp = ((fifo->ampdu_pld_size * phy_rate) /
 			       ((phy_rate - dma_rate) * FFPLD_MPDU_SIZE)) + 1;
@@ -360,7 +360,7 @@ static void brcms_c_ffpld_calc_mcs2ampdu_table(struct ampdu_info *ampdu, int f)
 static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 {
 	struct ampdu_info *ampdu = wlc->ampdu;
-	u32 phy_rate = MCS_RATE(FFPLD_MAX_MCS, true, false);
+	u32 phy_rate = mcs_2_rate(FFPLD_MAX_MCS, true, false);
 	u32 txunfl_ratio;
 	u8 max_mpdu;
 	u32 current_ampdu_cnt = 0;
@@ -678,7 +678,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 			}
 			is40 = (plcp0 & MIMO_PLCP_40MHZ) ? 1 : 0;
-			sgi = PLCP3_ISSGI(plcp3) ? 1 : 0;
+			sgi = plcp3_issgi(plcp3) ? 1 : 0;
 			mcs = plcp0 & ~MIMO_PLCP_40MHZ;
 			max_ampdu_bytes =
 			    min(scb_ampdu->max_rx_ampdu_bytes,
@@ -697,9 +697,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 				rspec |= (PHY_TXC1_BW_40MHZ << RSPEC_BW_SHIFT);
 
 			if (fbr_iscck)	/* CCK */
-				rspec_fallback =
-				    CCK_RSPEC(CCK_PHY2MAC_RATE
-					      (txh->FragPLCPFallback[0]));
+				rspec_fallback = cck_rspec(cck_phy2mac_rate
+						    (txh->FragPLCPFallback[0]));
 			else {	/* MIMO */
 				rspec_fallback = RSPEC_MIMORATE;
 				rspec_fallback |=
@@ -722,7 +721,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 		/* if (first mpdu for host agg) */
 		/* test whether to add more */
-		if ((MCS_RATE(mcs, true, false) >= f->dmaxferrate) &&
+		if ((mcs_2_rate(mcs, true, false) >= f->dmaxferrate) &&
 		    (count == f->mcs2ampdu_table[mcs])) {
 			BCMMSG(wlc->wiphy, "wl%d: PR 37644: stopping"
 				" ampdu at %d for mcs %d\n",
@@ -816,7 +815,7 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 		}
 
 		/* set the preload length */
-		if (MCS_RATE(mcs, true, false) >= f->dmaxferrate) {
+		if (mcs_2_rate(mcs, true, false) >= f->dmaxferrate) {
 			dma_len = min(dma_len, f->ampdu_pld_size);
 			txh->PreloadSize = cpu_to_le16(dma_len);
 		} else
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index ec7de38..2c9ac6d 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -170,7 +170,7 @@
 /* Find basic rate for a given rate */
 static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
 {
-	if (IS_MCS(rspec))
+	if (is_mcs_rate(rspec))
 		return wlc->band->basic_rate[mcs_table[rspec & RSPEC_RATE_MASK]
 		       .leg_ofdm];
 	return wlc->band->basic_rate[rspec & RSPEC_RATE_MASK];
@@ -178,9 +178,9 @@ static u8 brcms_basic_rate(struct brcms_c_info *wlc, u32 rspec)
 
 static u16 frametype(u32 rspec, u8 mimoframe)
 {
-	if (IS_MCS(rspec))
+	if (is_mcs_rate(rspec))
 		return mimoframe;
-	return IS_CCK(rspec) ? FT_CCK : FT_OFDM;
+	return is_cck_rate(rspec) ? FT_CCK : FT_OFDM;
 }
 
 /* rfdisable delay timer 500 ms, runs of ALP clock */
@@ -4001,7 +4001,7 @@ u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 	 * pick siso/cdd as default for OFDM (note no basic
 	 * rate MCSs are supported yet)
 	 */
-	if (IS_OFDM(lowest_basic_rspec))
+	if (is_ofdm_rate(lowest_basic_rspec))
 		lowest_basic_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
 
 	return lowest_basic_rspec;
@@ -6560,7 +6560,7 @@ u16 brcms_b_rate_shm_offset(struct brcms_hardware *wlc_hw, u8 rate)
 	u8 phy_rate, index;
 
 	/* get the phy specific rate encoding for the PLCP SIGNAL field */
-	if (IS_OFDM(rate))
+	if (is_ofdm_rate(rate))
 		table_ptr = M_RT_DIRMAP_A;
 	else
 		table_ptr = M_RT_DIRMAP_B;
@@ -6772,27 +6772,26 @@ brcms_c_calc_frame_len(struct brcms_c_info *wlc, u32 ratespec,
 		   u8 preamble_type, uint dur)
 {
 	uint nsyms, mac_len, Ndps, kNdps;
-	uint rate = RSPEC2RATE(ratespec);
+	uint rate = rspec2rate(ratespec);
 
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, dur %d\n",
 		 wlc->pub->unit, ratespec, preamble_type, dur);
 
-	if (IS_MCS(ratespec)) {
+	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
-		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
+		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
 		dur -= PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
 		/* payload calculation matches that of regular ofdm */
 		if (wlc->band->bandtype == BRCM_BAND_2G)
 			dur -= DOT11_OFDM_SIGNAL_EXTENSION;
 		/* kNdbps = kbps * 4 */
-		kNdps =
-		    MCS_RATE(mcs, RSPEC_IS40MHZ(ratespec),
-			     RSPEC_ISSGI(ratespec)) * 4;
+		kNdps =	mcs_2_rate(mcs, rspec_is40mhz(ratespec),
+				   rspec_issgi(ratespec)) * 4;
 		nsyms = dur / APHY_SYMBOL_TIME;
 		mac_len =
 		    ((nsyms * kNdps) -
 		     ((APHY_SERVICE_NBITS + APHY_TAIL_NBITS) * 1000)) / 8000;
-	} else if (IS_OFDM(ratespec)) {
+	} else if (is_ofdm_rate(ratespec)) {
 		dur -= APHY_PREAMBLE_TIME;
 		dur -= APHY_SIGNAL_TIME;
 		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
@@ -6872,14 +6871,14 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 				goto done;
 			}
 		}
-	} else if (IS_OFDM(rate)) {
+	} else if (is_ofdm_rate(rate)) {
 		if ((stf != PHY_TXC1_MODE_CDD) && (stf != PHY_TXC1_MODE_SISO)) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid OFDM\n",
 				  wlc->pub->unit, __func__);
 			bcmerror = -EINVAL;
 			goto done;
 		}
-	} else if (IS_CCK(rate)) {
+	} else if (is_cck_rate(rate)) {
 		if ((cur_band->bandtype != BRCM_BAND_2G)
 		    || (stf != PHY_TXC1_MODE_SISO)) {
 			wiphy_err(wlc->wiphy, "wl%d: %s: Invalid CCK\n",
@@ -7074,7 +7073,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		 *   determine and validate primary rate
 		 *   and fallback rates
 		 */
-		if (!RSPEC_ACTIVE(rspec[k])) {
+		if (!rspec_active(rspec[k])) {
 			rspec[k] = BRCM_RATE_1M;
 		} else {
 			if (!is_multicast_ether_addr(h->addr1)) {
@@ -7093,15 +7092,15 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			 * apply siso/cdd to single stream mcs's or ofdm
 			 * if rspec is auto selected
 			 */
-			if (((IS_MCS(rspec[k]) &&
-			      IS_SINGLE_STREAM(rspec[k] & RSPEC_RATE_MASK)) ||
-			     IS_OFDM(rspec[k]))
+			if (((is_mcs_rate(rspec[k]) &&
+			      is_single_stream(rspec[k] & RSPEC_RATE_MASK)) ||
+			     is_ofdm_rate(rspec[k]))
 			    && ((rspec[k] & RSPEC_OVERRIDE_MCS_ONLY)
 				|| !(rspec[k] & RSPEC_OVERRIDE))) {
 				rspec[k] &= ~(RSPEC_STF_MASK | RSPEC_STC_MASK);
 
 				/* For SISO MCS use STBC if possible */
-				if (IS_MCS(rspec[k])
+				if (is_mcs_rate(rspec[k])
 				    && BRCMS_STF_SS_STBC_TX(wlc, scb)) {
 					u8 stc;
 
@@ -7126,7 +7125,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 								 wlc->band->pi))
 				   ? PHY_TXC1_BW_20MHZ_UP : PHY_TXC1_BW_20MHZ;
 
-				if (IS_MCS(rspec[k])) {
+				if (is_mcs_rate(rspec[k])) {
 					/* mcs 32 must be 40b/w DUP */
 					if ((rspec[k] & RSPEC_RATE_MASK)
 					    == 32) {
@@ -7138,7 +7137,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 					/* else check if dst is using 40 Mhz */
 					else if (scb->flags & SCB_IS40)
 						mimo_txbw = PHY_TXC1_BW_40MHZ;
-				} else if (IS_OFDM(rspec[k])) {
+				} else if (is_ofdm_rate(rspec[k])) {
 					if (wlc->ofdm_40txbw != AUTO)
 						mimo_txbw = wlc->ofdm_40txbw;
 				} else if (wlc->cck_40txbw != AUTO) {
@@ -7159,7 +7158,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 			/* Set channel width */
 			rspec[k] &= ~RSPEC_BW_MASK;
-			if ((k == 0) || ((k > 0) && IS_MCS(rspec[k])))
+			if ((k == 0) || ((k > 0) && is_mcs_rate(rspec[k])))
 				rspec[k] |= (mimo_txbw << RSPEC_BW_SHIFT);
 			else
 				rspec[k] |= (mimo_ctlchbw << RSPEC_BW_SHIFT);
@@ -7172,13 +7171,13 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				mimo_preamble_type = BRCMS_GF_PREAMBLE;
 
 			if ((txrate[k]->flags & IEEE80211_TX_RC_MCS)
-			    && (!IS_MCS(rspec[k]))) {
+			    && (!is_mcs_rate(rspec[k]))) {
 				wiphy_err(wlc->wiphy, "wl%d: %s: IEEE80211_TX_"
-					  "RC_MCS != IS_MCS(rspec)\n",
+					  "RC_MCS != is_mcs_rate(rspec)\n",
 					  wlc->pub->unit, __func__);
 			}
 
-			if (IS_MCS(rspec[k])) {
+			if (is_mcs_rate(rspec[k])) {
 				preamble_type[k] = mimo_preamble_type;
 
 				/*
@@ -7186,13 +7185,13 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				 * for single stream
 				 */
 				if ((rspec[k] & RSPEC_SHORT_GI)
-				    && IS_SINGLE_STREAM(rspec[k] &
+				    && is_single_stream(rspec[k] &
 							RSPEC_RATE_MASK))
 					preamble_type[k] = BRCMS_MM_PREAMBLE;
 			}
 
 			/* should be better conditionalized */
-			if (!IS_MCS(rspec[0])
+			if (!is_mcs_rate(rspec[0])
 			    && (tx_info->control.rates[0].
 				flags & IEEE80211_TX_RC_USE_SHORT_PREAMBLE))
 				preamble_type[k] = BRCMS_SHORT_PREAMBLE;
@@ -7204,7 +7203,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			rspec[k] |= (PHY_TXC1_BW_20MHZ << RSPEC_BW_SHIFT);
 
 			/* for nphy, stf of ofdm frames must follow policies */
-			if (BRCMS_ISNPHY(wlc->band) && IS_OFDM(rspec[k])) {
+			if (BRCMS_ISNPHY(wlc->band) && is_ofdm_rate(rspec[k])) {
 				rspec[k] &= ~RSPEC_STF_MASK;
 				rspec[k] |= phyctl1_stf << RSPEC_STF_SHIFT;
 			}
@@ -7229,13 +7228,13 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	       plcp_fallback, sizeof(txh->FragPLCPFallback));
 
 	/* Length field now put in CCK FBR CRC field */
-	if (IS_CCK(rspec[1])) {
+	if (is_cck_rate(rspec[1])) {
 		txh->FragPLCPFallback[4] = phylen & 0xff;
 		txh->FragPLCPFallback[5] = (phylen & 0xff00) >> 8;
 	}
 
 	/* MIMO-RATE: need validation ?? */
-	mainrates = IS_OFDM(rspec[0]) ?
+	mainrates = is_ofdm_rate(rspec[0]) ?
 			D11A_PHY_HDR_GRATE((struct ofdm_phy_hdr *) plcp) :
 			plcp[0];
 
@@ -7292,7 +7291,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	/* Set fallback rate preamble type */
 	if ((preamble_type[1] == BRCMS_SHORT_PREAMBLE) ||
 	    (preamble_type[1] == BRCMS_GF_PREAMBLE)) {
-		if (RSPEC2RATE(rspec[1]) != BRCM_RATE_1M)
+		if (rspec2rate(rspec[1]) != BRCM_RATE_1M)
 			mch |= TXC_PREAMBLE_DATA_FB_SHORT;
 	}
 
@@ -7336,15 +7335,15 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 							      mimo_ctlchbw);
 		}
 
-		if (!IS_OFDM(rts_rspec[0]) &&
-		    !((RSPEC2RATE(rts_rspec[0]) == BRCM_RATE_1M) ||
+		if (!is_ofdm_rate(rts_rspec[0]) &&
+		    !((rspec2rate(rts_rspec[0]) == BRCM_RATE_1M) ||
 		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
 			rts_preamble_type[0] = BRCMS_SHORT_PREAMBLE;
 			mch |= TXC_PREAMBLE_RTS_MAIN_SHORT;
 		}
 
-		if (!IS_OFDM(rts_rspec[1]) &&
-		    !((RSPEC2RATE(rts_rspec[1]) == BRCM_RATE_1M) ||
+		if (!is_ofdm_rate(rts_rspec[1]) &&
+		    !((rspec2rate(rts_rspec[1]) == BRCM_RATE_1M) ||
 		      (wlc->PLCPHdr_override == BRCMS_PLCP_LONG))) {
 			rts_preamble_type[1] = BRCMS_SHORT_PREAMBLE;
 			mch |= TXC_PREAMBLE_RTS_FB_SHORT;
@@ -7403,7 +7402,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		 *    low 8 bits: main frag rate/mcs,
 		 *    high 8 bits: rts/cts rate/mcs
 		 */
-		mainrates |= (IS_OFDM(rts_rspec[0]) ?
+		mainrates |= (is_ofdm_rate(rts_rspec[0]) ?
 				D11A_PHY_HDR_GRATE(
 					(struct ofdm_phy_hdr *) rts_plcp) :
 				rts_plcp[0]) << 8;
@@ -7418,7 +7417,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 #ifdef SUPPORT_40MHZ
 	/* add null delimiter count */
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && IS_MCS(rspec))
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && is_mcs_rate(rspec))
 		txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] =
 		   brcm_c_ampdu_null_delim_cnt(wlc->ampdu, scb, rspec, phylen);
 
@@ -7448,7 +7447,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	phyctl = frametype(rspec[0], wlc->mimoft);
 	if ((preamble_type[0] == BRCMS_SHORT_PREAMBLE) ||
 	    (preamble_type[0] == BRCMS_GF_PREAMBLE)) {
-		if (RSPEC2RATE(rspec[0]) != BRCM_RATE_1M)
+		if (rspec2rate(rspec[0]) != BRCM_RATE_1M)
 			phyctl |= PHY_TXC_SHORT_HDR;
 	}
 
@@ -7477,14 +7476,14 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		 * is going to be set, fill in non-zero MModeLen and/or
 		 * MModeFbrLen it will be unnecessary if they are separated
 		 */
-		if (IS_MCS(rspec[0]) &&
+		if (is_mcs_rate(rspec[0]) &&
 		    (preamble_type[0] == BRCMS_MM_PREAMBLE)) {
 			u16 mmodelen =
 			    brcms_c_calc_lsig_len(wlc, rspec[0], phylen);
 			txh->MModeLen = cpu_to_le16(mmodelen);
 		}
 
-		if (IS_MCS(rspec[1]) &&
+		if (is_mcs_rate(rspec[1]) &&
 		    (preamble_type[1] == BRCMS_MM_PREAMBLE)) {
 			u16 mmodefbrlen =
 			    brcms_c_calc_lsig_len(wlc, rspec[1], phylen);
@@ -7570,7 +7569,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				wiphy_err(wlc->wiphy, "wl%d: %s txop invalid "
 					  "for rate %d\n",
 					  wlc->pub->unit, fifo_names[queue],
-					  RSPEC2RATE(rspec[0]));
+					  rspec2rate(rspec[0]));
 			}
 
 			if (dur > wlc->edcf_txop[ac])
@@ -7772,10 +7771,10 @@ static void brcms_c_compute_mimo_plcp(u32 rspec, uint length, u8 *plcp)
 {
 	u8 mcs = (u8) (rspec & RSPEC_RATE_MASK);
 	plcp[0] = mcs;
-	if (RSPEC_IS40MHZ(rspec) || (mcs == 32))
+	if (rspec_is40mhz(rspec) || (mcs == 32))
 		plcp[0] |= MIMO_PLCP_40MHZ;
 	BRCMS_SET_MIMO_PLCP_LEN(plcp, length);
-	plcp[3] = RSPEC_MIMOPLCP3(rspec); /* rspec already holds this byte */
+	plcp[3] = rspec_mimoplcp3(rspec); /* rspec already holds this byte */
 	plcp[3] |= 0x7; /* set smoothing, not sounding ppdu & reserved */
 	plcp[4] = 0; /* number of extension spatial streams bit 0 & 1 */
 	plcp[5] = 0;
@@ -7787,7 +7786,7 @@ brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 {
 	u8 rate_signal;
 	u32 tmp = 0;
-	int rate = RSPEC2RATE(rspec);
+	int rate = rspec2rate(rspec);
 
 	/*
 	 * encode rate per 802.11a-1999 sec 17.3.4.1, with lsb
@@ -7809,7 +7808,7 @@ brcms_c_compute_ofdm_plcp(u32 rspec, u32 length, u8 *plcp)
 static void brcms_c_compute_cck_plcp(struct brcms_c_info *wlc, u32 rspec,
 				 uint length, u8 *plcp)
 {
-	int rate = RSPEC2RATE(rspec);
+	int rate = rspec2rate(rspec);
 
 	brcms_c_cck_plcp_set(wlc, rate, length, plcp);
 }
@@ -7818,9 +7817,9 @@ void
 brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
 		     uint length, u8 *plcp)
 {
-	if (IS_MCS(rspec))
+	if (is_mcs_rate(rspec))
 		brcms_c_compute_mimo_plcp(rspec, length, plcp);
-	else if (IS_OFDM(rspec))
+	else if (is_ofdm_rate(rspec))
 		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
 	else
 		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
@@ -7881,7 +7880,7 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 	if (BRCMS_ISLCNPHY(wlc->band)) {
 		bw = PHY_TXC1_BW_20MHZ;
 	} else {
-		bw = RSPEC_GET_BW(rspec);
+		bw = rspec_get_bw(rspec);
 		/* 10Mhz is not supported yet */
 		if (bw < PHY_TXC1_BW_20MHZ) {
 			wiphy_err(wlc->wiphy, "phytxctl1_calc: bw %d is "
@@ -7890,14 +7889,14 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		}
 	}
 
-	if (IS_MCS(rspec)) {
+	if (is_mcs_rate(rspec)) {
 		uint mcs = rspec & RSPEC_RATE_MASK;
 
-		/* bw, stf, coding-type is part of RSPEC_PHYTXBYTE2 returns */
-		phyctl1 = RSPEC_PHYTXBYTE2(rspec);
+		/* bw, stf, coding-type is part of rspec_phytxbyte2 returns */
+		phyctl1 = rspec_phytxbyte2(rspec);
 		/* set the upper byte of phyctl1 */
 		phyctl1 |= (mcs_table[mcs].tx_phy_ctl3 << 8);
-	} else if (IS_CCK(rspec) && !BRCMS_ISLCNPHY(wlc->band)
+	} else if (is_cck_rate(rspec) && !BRCMS_ISLCNPHY(wlc->band)
 		   && !BRCMS_ISSSLPNPHY(wlc->band)) {
 		/*
 		 * In CCK mode LPPHY overloads OFDM Modulation bits with CCK
@@ -7905,11 +7904,11 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		 * this format
 		 */
 		/* 0 = 1Mbps; 1 = 2Mbps; 2 = 5.5Mbps; 3 = 11Mbps */
-		phyctl1 = (bw | (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
+		phyctl1 = (bw | (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
 	} else {		/* legacy OFDM/CCK */
 		s16 phycfg;
 		/* get the phyctl byte from rate phycfg table */
-		phycfg = brcms_c_rate_legacy_phyctl(RSPEC2RATE(rspec));
+		phycfg = brcms_c_rate_legacy_phyctl(rspec2rate(rspec));
 		if (phycfg == -1) {
 			wiphy_err(wlc->wiphy, "phytxctl1_calc: wrong "
 				  "legacy OFDM/CCK rate\n");
@@ -7918,7 +7917,7 @@ u16 brcms_c_phytxctl1_calc(struct brcms_c_info *wlc, u32 rspec)
 		/* set the upper byte of phyctl1 */
 		phyctl1 =
 		    (bw | (phycfg << 8) |
-		     (RSPEC_STF(rspec) << PHY_TXC1_MODE_SHIFT));
+		     (rspec_stf(rspec) << PHY_TXC1_MODE_SHIFT));
 	}
 	return phyctl1;
 }
@@ -7932,7 +7931,7 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 	if (use_rspec)
 		/* use frame rate as rts rate */
 		rts_rspec = rspec;
-	else if (wlc->band->gmode && wlc->protection->_g && !IS_CCK(rspec))
+	else if (wlc->band->gmode && wlc->protection->_g && !is_cck_rate(rspec))
 		/* Use 11Mbps as the g protection RTS target rate and fallback.
 		 * Use the brcms_basic_rate() lookup to find the best basic rate
 		 * under the target in case 11 Mbps is not Basic.
@@ -7956,13 +7955,13 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 		 * if rspec/rspec_fallback is 40MHz, then send RTS on both
 		 * 20MHz channel (DUP), otherwise send RTS on control channel
 		 */
-		if (RSPEC_IS40MHZ(rspec) && !IS_CCK(rts_rspec))
+		if (rspec_is40mhz(rspec) && !is_cck_rate(rts_rspec))
 			rts_rspec |= (PHY_TXC1_BW_40MHZ_DUP << RSPEC_BW_SHIFT);
 		else
 			rts_rspec |= (mimo_ctlchbw << RSPEC_BW_SHIFT);
 
 		/* pick siso/cdd as default for ofdm */
-		if (IS_OFDM(rts_rspec)) {
+		if (is_ofdm_rate(rts_rspec)) {
 			rts_rspec &= ~RSPEC_STF_MASK;
 			rts_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
 		}
@@ -8269,13 +8268,13 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	plcp = p->data;
 
 	rspec = brcms_c_compute_rspec(rxh, plcp);
-	if (IS_MCS(rspec)) {
+	if (is_mcs_rate(rspec)) {
 		rx_status->rate_idx = rspec & RSPEC_RATE_MASK;
 		rx_status->flag |= RX_FLAG_HT;
-		if (RSPEC_IS40MHZ(rspec))
+		if (rspec_is40mhz(rspec))
 			rx_status->flag |= RX_FLAG_40MHZ;
 	} else {
-		switch (RSPEC2RATE(rspec)) {
+		switch (rspec2rate(rspec)) {
 		case BRCM_RATE_1M:
 			rx_status->rate_idx = 0;
 			break;
@@ -8326,10 +8325,10 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 
 		/* Determine short preamble and rate_idx */
 		preamble = 0;
-		if (IS_CCK(rspec)) {
+		if (is_cck_rate(rspec)) {
 			if (rxh->PhyRxStatus_0 & PRXS0_SHORTH)
 				rx_status->flag |= RX_FLAG_SHORTPRE;
-		} else if (IS_OFDM(rspec)) {
+		} else if (is_ofdm_rate(rspec)) {
 			rx_status->flag |= RX_FLAG_SHORTPRE;
 		} else {
 			wiphy_err(wlc->wiphy, "%s: Unknown modulation\n",
@@ -8337,7 +8336,7 @@ prep_mac80211_status(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 		}
 	}
 
-	if (PLCP3_ISSGI(plcp[3]))
+	if (plcp3_issgi(plcp[3]))
 		rx_status->flag |= RX_FLAG_SHORT_GI;
 
 	if (rxh->RxStatus1 & RXS_DECERR) {
@@ -8479,23 +8478,22 @@ brcms_c_calc_lsig_len(struct brcms_c_info *wlc, u32 ratespec,
 	uint nsyms, len = 0, kNdps;
 
 	BCMMSG(wlc->wiphy, "wl%d: rate %d, len%d\n",
-		 wlc->pub->unit, RSPEC2RATE(ratespec), mac_len);
+		 wlc->pub->unit, rspec2rate(ratespec), mac_len);
 
-	if (IS_MCS(ratespec)) {
+	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
-		/* MCS_TXS(mcs) returns num tx streams - 1 */
-		int tot_streams = (MCS_TXS(mcs) + 1) + RSPEC_STC(ratespec);
+		int tot_streams = (mcs_2_txstreams(mcs) + 1) +
+				  rspec_stc(ratespec);
 
 		/*
 		 * the payload duration calculation matches that
 		 * of regular ofdm
 		 */
 		/* 1000Ndbps = kbps * 4 */
-		kNdps =
-		    MCS_RATE(mcs, RSPEC_IS40MHZ(ratespec),
-			     RSPEC_ISSGI(ratespec)) * 4;
+		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
+				   rspec_issgi(ratespec)) * 4;
 
-		if (RSPEC_STC(ratespec) == 0)
+		if (rspec_stc(ratespec) == 0)
 			nsyms =
 			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
 				  APHY_TAIL_NBITS) * 1000, kNdps);
@@ -8527,7 +8525,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 			u8 preamble_type, uint mac_len)
 {
 	uint nsyms, dur = 0, Ndps, kNdps;
-	uint rate = RSPEC2RATE(ratespec);
+	uint rate = rspec2rate(ratespec);
 
 	if (rate == 0) {
 		wiphy_err(wlc->wiphy, "wl%d: WAR: using rate of 1 mbps\n",
@@ -8538,19 +8536,18 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 	BCMMSG(wlc->wiphy, "wl%d: rspec 0x%x, preamble_type %d, len%d\n",
 		 wlc->pub->unit, ratespec, preamble_type, mac_len);
 
-	if (IS_MCS(ratespec)) {
+	if (is_mcs_rate(ratespec)) {
 		uint mcs = ratespec & RSPEC_RATE_MASK;
-		int tot_streams = MCS_TXS(mcs) + RSPEC_STC(ratespec);
+		int tot_streams = mcs_2_txstreams(mcs) + rspec_stc(ratespec);
 
 		dur = PREN_PREAMBLE + (tot_streams * PREN_PREAMBLE_EXT);
 		if (preamble_type == BRCMS_MM_PREAMBLE)
 			dur += PREN_MM_EXT;
 		/* 1000Ndbps = kbps * 4 */
-		kNdps =
-		    MCS_RATE(mcs, RSPEC_IS40MHZ(ratespec),
-			     RSPEC_ISSGI(ratespec)) * 4;
+		kNdps = mcs_2_rate(mcs, rspec_is40mhz(ratespec),
+				   rspec_issgi(ratespec)) * 4;
 
-		if (RSPEC_STC(ratespec) == 0)
+		if (rspec_stc(ratespec) == 0)
 			nsyms =
 			    CEIL((APHY_SERVICE_NBITS + 8 * mac_len +
 				  APHY_TAIL_NBITS) * 1000, kNdps);
@@ -8564,7 +8561,7 @@ brcms_c_calc_frame_time(struct brcms_c_info *wlc, u32 ratespec,
 		dur += APHY_SYMBOL_TIME * nsyms;
 		if (wlc->band->bandtype == BRCM_BAND_2G)
 			dur += DOT11_OFDM_SIGNAL_EXTENSION;
-	} else if (IS_OFDM(rate)) {
+	} else if (is_ofdm_rate(rate)) {
 		dur = APHY_PREAMBLE_TIME;
 		dur += APHY_SIGNAL_TIME;
 		/* Ndbps = Mbps * 4 = rate(500Kbps) * 2 */
@@ -8649,7 +8646,7 @@ void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 			 * Keep track of the best basic rate so far by
 			 * modulation type.
 			 */
-			if (IS_OFDM(rate))
+			if (is_ofdm_rate(rate))
 				ofdm_basic = rate;
 			else
 				cck_basic = rate;
@@ -8662,12 +8659,12 @@ void brcms_c_rate_lookup_init(struct brcms_c_info *wlc,
 		 * the hole in the table
 		 */
 
-		br[rate] = IS_OFDM(rate) ? ofdm_basic : cck_basic;
+		br[rate] = is_ofdm_rate(rate) ? ofdm_basic : cck_basic;
 
 		if (br[rate] != 0)
 			continue;
 
-		if (IS_OFDM(rate)) {
+		if (is_ofdm_rate(rate)) {
 			/*
 			 * In 11g and 11a, the OFDM mandatory rates
 			 * are 6, 12, and 24 Mbps
@@ -8696,10 +8693,10 @@ static void brcms_c_write_rate_shm(struct brcms_c_info *wlc, u8 rate,
 	u16 basic_ptr;
 
 	/* Shared memory address for the table we are reading */
-	dir_table = IS_OFDM(basic_rate) ? M_RT_DIRMAP_A : M_RT_DIRMAP_B;
+	dir_table = is_ofdm_rate(basic_rate) ? M_RT_DIRMAP_A : M_RT_DIRMAP_B;
 
 	/* Shared memory address for the table we are writing */
-	basic_table = IS_OFDM(rate) ? M_RT_BBRSMAP_A : M_RT_BBRSMAP_B;
+	basic_table = is_ofdm_rate(rate) ? M_RT_BBRSMAP_A : M_RT_BBRSMAP_B;
 
 	/*
 	 * for a given rate, the LS-nibble of the PLCP SIGNAL field is
@@ -8788,15 +8785,15 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 		return false;
 
 	/* check if this is a mimo rate */
-	if (IS_MCS(rspec)) {
-		if (!VALID_MCS((rspec & RSPEC_RATE_MASK)))
+	if (is_mcs_rate(rspec)) {
+		if ((rspec & RSPEC_RATE_MASK) >= MCS_TABLE_SIZE)
 			goto error;
 
 		return isset(hw_rateset->mcs, (rspec & RSPEC_RATE_MASK));
 	}
 
 	for (i = 0; i < hw_rateset->count; i++)
-		if (hw_rateset->rates[i] == RSPEC2RATE(rspec))
+		if (hw_rateset->rates[i] == rspec2rate(rspec))
 			return true;
  error:
 	if (verbose)
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index 1241dc9..0a0c0ad 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -353,12 +353,12 @@ u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
 		switch (rxh->PhyRxStatus_0 & PRXS0_FT_MASK) {
 		case PRXS0_CCK:
 			rspec =
-			    CCK_PHY2MAC_RATE(
+				cck_phy2mac_rate(
 				((struct cck_phy_hdr *) plcp)->signal);
 			break;
 		case PRXS0_OFDM:
 			rspec =
-			    OFDM_PHY2MAC_RATE(
+			    ofdm_phy2mac_rate(
 				((struct ofdm_phy_hdr *) plcp)->rlpt[0]);
 			break;
 		case PRXS0_PREN:
@@ -375,14 +375,14 @@ u32 brcms_c_compute_rspec(struct d11rxhdr *rxh, u8 *plcp)
 			/* not supported, error condition */
 			break;
 		}
-		if (PLCP3_ISSGI(plcp[3]))
+		if (plcp3_issgi(plcp[3]))
 			rspec |= RSPEC_SHORT_GI;
 	} else
 	    if ((phy_type == PHY_TYPE_A) || (rxh->PhyRxStatus_0 & PRXS0_OFDM))
-		rspec = OFDM_PHY2MAC_RATE(
+		rspec = ofdm_phy2mac_rate(
 				((struct ofdm_phy_hdr *) plcp)->rlpt[0]);
 	else
-		rspec = CCK_PHY2MAC_RATE(
+		rspec = cck_phy2mac_rate(
 				((struct cck_phy_hdr *) plcp)->signal);
 
 	return rspec;
@@ -417,9 +417,11 @@ brcms_c_rateset_filter(struct brcms_c_rateset *src, struct brcms_c_rateset *dst,
 		r = src->rates[i];
 		if (basic_only && !(r & BRCMS_RATE_FLAG))
 			continue;
-		if (rates == BRCMS_RATES_CCK && IS_OFDM((r & BRCMS_RATE_MASK)))
+		if (rates == BRCMS_RATES_CCK &&
+		    is_ofdm_rate((r & BRCMS_RATE_MASK)))
 			continue;
-		if (rates == BRCMS_RATES_OFDM && IS_CCK((r & BRCMS_RATE_MASK)))
+		if (rates == BRCMS_RATES_OFDM &&
+		    is_cck_rate((r & BRCMS_RATE_MASK)))
 			continue;
 		dst->rates[count++] = r & xmask;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.h b/drivers/staging/brcm80211/brcmsmac/rate.h
index ae5479b..2cc66e0 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.h
+++ b/drivers/staging/brcm80211/brcmsmac/rate.h
@@ -18,6 +18,7 @@
 #define _BRCM_RATE_H_
 
 #include "types.h"
+#include "d11.h"
 
 extern const u8 rate_info[];
 extern const struct brcms_c_rateset cck_ofdm_mimo_rates;
@@ -48,33 +49,31 @@ struct brcms_mcs_info {
 #define MCS_TABLE_SIZE	33	/* Number of mcs entries in the table */
 extern const struct brcms_mcs_info mcs_table[];
 
-#define MCS_INVALID	0xFF
-#define MCS_CR_MASK	0x07	/* Code Rate bit mask */
-#define MCS_MOD_MASK	0x38	/* Modulation bit shift */
-#define MCS_MOD_SHIFT	3	/* MOdulation bit shift */
 #define MCS_TXS_MASK	0xc0	/* num tx streams - 1 bit mask */
 #define MCS_TXS_SHIFT	6	/* num tx streams - 1 bit shift */
-#define MCS_CR(_mcs)	(mcs_table[_mcs].tx_phy_ctl3 & MCS_CR_MASK)
 
-#define MCS_MOD(_mcs) \
-	((mcs_table[_mcs].tx_phy_ctl3 & MCS_MOD_MASK) >> MCS_MOD_SHIFT)
-
-#define MCS_TXS(_mcs) \
-	((mcs_table[_mcs].tx_phy_ctl3 & MCS_TXS_MASK) >> MCS_TXS_SHIFT)
-
-#define MCS_RATE(_mcs, _is40, _sgi)	(_sgi ? \
-	(_is40 ? mcs_table[_mcs].phy_rate_40_sgi : \
-		 mcs_table[_mcs].phy_rate_20_sgi) : \
-	(_is40 ? mcs_table[_mcs].phy_rate_40 : mcs_table[_mcs].phy_rate_20))
-
-#define VALID_MCS(_mcs)	((_mcs < MCS_TABLE_SIZE))
+/* returns num tx streams - 1 */
+static inline u8 mcs_2_txstreams(u8 mcs)
+{
+	return (mcs_table[mcs].tx_phy_ctl3 & MCS_TXS_MASK) >> MCS_TXS_SHIFT;
+}
+
+static inline uint mcs_2_rate(u8 mcs, bool is40, bool sgi)
+{
+	if (sgi) {
+		if (is40)
+			return mcs_table[mcs].phy_rate_40_sgi;
+		return mcs_table[mcs].phy_rate_20_sgi;
+	}
+	if (is40)
+		return mcs_table[mcs].phy_rate_40;
+
+	return mcs_table[mcs].phy_rate_20;
+}
 
 /* Macro to use the rate_info table */
 #define	BRCMS_RATE_MASK_FULL 0xff /* Rate value mask with basic rate flag */
 
-/* convert 500kbps to bps */
-#define BRCMS_RATE_500K_TO_BPS(rate)	((rate) * 500000)
-
 /*
  * rate spec : holds rate and mode specific information required to generate a
  * tx frame. Legacy CCK and OFDM information is held in the same manner as was
@@ -113,65 +112,104 @@ extern const struct brcms_mcs_info mcs_table[];
 /* bit indicates override rate only */
 #define RSPEC_OVERRIDE_MCS_ONLY 0x40000000
 
-#define BRCMS_HTPHY		127	/* HT PHY Membership */
-
-#define RSPEC_ACTIVE(rspec)	(rspec & (RSPEC_RATE_MASK | RSPEC_MIMORATE))
-
-#define RSPEC2RATE(rspec) \
-	((rspec & RSPEC_MIMORATE) ? \
-	MCS_RATE((rspec & RSPEC_RATE_MASK), RSPEC_IS40MHZ(rspec), \
-		  RSPEC_ISSGI(rspec)) : \
-	(rspec & RSPEC_RATE_MASK))
-
-#define RSPEC_PHYTXBYTE2(rspec)	((rspec & 0xff00) >> 8)
-
-#define RSPEC_GET_BW(rspec)	((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT)
-
-#define RSPEC_IS40MHZ(rspec) \
-	((((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT) == PHY_TXC1_BW_40MHZ) || \
-	 (((rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT) == PHY_TXC1_BW_40MHZ_DUP))
-
-#define RSPEC_ISSGI(rspec)	((rspec & RSPEC_SHORT_GI) == RSPEC_SHORT_GI)
-#define RSPEC_MIMOPLCP3(rspec)	((rspec & 0xf00000) >> 16)
-#define PLCP3_ISSGI(plcp)	(plcp & (RSPEC_SHORT_GI >> 16))
-#define RSPEC_STC(rspec)	((rspec & RSPEC_STC_MASK) >> RSPEC_STC_SHIFT)
-#define RSPEC_STF(rspec)	((rspec & RSPEC_STF_MASK) >> RSPEC_STF_SHIFT)
-#define PLCP3_ISSTBC(plcp)	((plcp & (RSPEC_STC_MASK) >> 16) == 0x10)
-#define PLCP3_STC_MASK          0x30
-#define PLCP3_STC_SHIFT         4
-
-/* Rate info table; takes a legacy rate or u32 */
-#define	IS_MCS(r)	(r & RSPEC_MIMORATE)
-
-#define	IS_OFDM(r)	(!IS_MCS(r) && (rate_info[(r) & RSPEC_RATE_MASK] & \
-					BRCMS_RATE_FLAG))
-
-#define	IS_CCK(r)	(!IS_MCS(r) && ( \
-			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_1M || \
-			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_2M || \
-			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_5M5 || \
-			 ((r) & BRCMS_RATE_MASK) == BRCM_RATE_11M))
-
-#define IS_SINGLE_STREAM(mcs) \
-	(((mcs) <= HIGHEST_SINGLE_STREAM_MCS) || ((mcs) == 32))
-
-#define CCK_RSPEC(cck)		((cck) & RSPEC_RATE_MASK)
-
-#define OFDM_RSPEC(ofdm)	(((ofdm) & RSPEC_RATE_MASK) |\
-	(PHY_TXC1_MODE_CDD << RSPEC_STF_SHIFT))
-
-#define LEGACY_RSPEC(rate) \
-	(IS_CCK(rate) ? CCK_RSPEC(rate) : OFDM_RSPEC(rate))
-
-#define MCS_RSPEC(mcs)		(((mcs) & RSPEC_RATE_MASK) | RSPEC_MIMORATE | \
-	(IS_SINGLE_STREAM(mcs) ? (PHY_TXC1_MODE_CDD << RSPEC_STF_SHIFT) : \
-	(PHY_TXC1_MODE_SDM << RSPEC_STF_SHIFT)))
+static inline bool rspec_active(u32 rspec)
+{
+	return rspec & (RSPEC_RATE_MASK | RSPEC_MIMORATE);
+}
+
+static inline u8 rspec_phytxbyte2(u32 rspec)
+{
+	return (rspec & 0xff00) >> 8;
+}
+
+static inline u32 rspec_get_bw(u32 rspec)
+{
+	return (rspec & RSPEC_BW_MASK) >> RSPEC_BW_SHIFT;
+}
+
+static inline bool rspec_issgi(u32 rspec)
+{
+	return (rspec & RSPEC_SHORT_GI) == RSPEC_SHORT_GI;
+}
+
+static inline bool rspec_is40mhz(u32 rspec)
+{
+	u32 bw = rspec_get_bw(rspec);
+
+	return bw == PHY_TXC1_BW_40MHZ || bw == PHY_TXC1_BW_40MHZ_DUP;
+}
+
+static inline uint rspec2rate(u32 rspec)
+{
+	if (rspec & RSPEC_MIMORATE)
+		return mcs_2_rate(rspec & RSPEC_RATE_MASK, rspec_is40mhz(rspec),
+				  rspec_issgi(rspec));
+	return rspec & RSPEC_RATE_MASK;
+}
+
+static inline u8 rspec_mimoplcp3(u32 rspec)
+{
+	return (rspec & 0xf00000) >> 16;
+}
+
+static inline bool plcp3_issgi(u8 plcp)
+{
+	return (plcp & (RSPEC_SHORT_GI >> 16)) != 0;
+}
+
+static inline uint rspec_stc(u32 rspec)
+{
+	return (rspec & RSPEC_STC_MASK) >> RSPEC_STC_SHIFT;
+}
+
+static inline uint rspec_stf(u32 rspec)
+{
+	return (rspec & RSPEC_STF_MASK) >> RSPEC_STF_SHIFT;
+}
+
+static inline bool is_mcs_rate(u32 ratespec)
+{
+	return (ratespec & RSPEC_MIMORATE) != 0;
+}
+
+static inline bool is_ofdm_rate(u32 ratespec)
+{
+	return !is_mcs_rate(ratespec) &&
+	       (rate_info[ratespec & RSPEC_RATE_MASK] & BRCMS_RATE_FLAG);
+}
+
+static inline bool is_cck_rate(u32 ratespec)
+{
+	u32 rate = (ratespec & BRCMS_RATE_MASK);
+
+	return !is_mcs_rate(ratespec) && (
+			rate == BRCM_RATE_1M || rate == BRCM_RATE_2M ||
+			rate == BRCM_RATE_5M5 || rate == BRCM_RATE_11M);
+}
+
+static inline bool is_single_stream(u8 mcs)
+{
+	return mcs <= HIGHEST_SINGLE_STREAM_MCS || mcs == 32;
+}
+
+static inline u8 cck_rspec(u8 cck)
+{
+	return cck & RSPEC_RATE_MASK;
+}
 
 /* Convert encoded rate value in plcp header to numerical rates in 500 KHz
  * increments */
 extern const u8 ofdm_rate_lookup[];
-#define OFDM_PHY2MAC_RATE(rlpt)		(ofdm_rate_lookup[rlpt & 0x7])
-#define CCK_PHY2MAC_RATE(signal)	(signal/5)
+
+static inline u8 ofdm_phy2mac_rate(u8 rlpt)
+{
+	return ofdm_rate_lookup[rlpt & 0x7];
+}
+
+static inline u8 cck_phy2mac_rate(u8 signal)
+{
+	return signal/5;
+}
 
 /* Rates specified in brcms_c_rateset_filter() */
 #define BRCMS_RATES_CCK_OFDM	0
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index 82805e0..91b53a5 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -421,7 +421,7 @@ static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
 {
 	u16 phytxant = wlc->stf->phytxant;
 
-	if (RSPEC_STF(rspec) != PHY_TXC1_MODE_SISO)
+	if (rspec_stf(rspec) != PHY_TXC1_MODE_SISO)
 		phytxant = wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
 	else if (wlc->stf->txant == ANT_TX_DEF)
 		phytxant = wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
-- 
1.7.4.1


