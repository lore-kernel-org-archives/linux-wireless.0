Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3156 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934709Ab1JENU4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 09:20:56 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/15] staging: brcm80211: remove code duplication for
 driver variable lookup
Date: Wed, 5 Oct 2011 15:20:03 +0200
Message-ID: <1317820814-7083-5-git-send-email-arend@broadcom.com> (sfid-20111005_152101_382940_13047ED5)
In-Reply-To: <1317820814-7083-1-git-send-email-arend@broadcom.com>
References: <1317820814-7083-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The phy code used its own driver variable lookup functions which were
duplicates of those in the brcmsmac driver (in srom.c). The phy code
now uses the functions in srom.c through the phy_shim interface.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   36 ---
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h |    6 -
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c |   56 +++---
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |  247 ++++++++++++----------
 drivers/staging/brcm80211/brcmsmac/phy_shim.c    |    9 +
 drivers/staging/brcm80211/brcmsmac/phy_shim.h    |    3 +
 6 files changed, 180 insertions(+), 177 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 0d3c9d8..59767e3 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -126,42 +126,6 @@ const u8 ofdm_rate_lookup[] = {
 
 #define PHY_WREG_LIMIT  24
 
-char *phy_getvar(struct brcms_phy *pi, const char *name)
-{
-	char *vars = pi->vars;
-	char *s;
-	int len;
-
-	if (!name)
-		return NULL;
-
-	len = strlen(name);
-	if (len == 0)
-		return NULL;
-
-	for (s = vars; s && *s;) {
-		if ((memcmp(s, name, len) == 0) && (s[len] == '='))
-			return &s[len + 1];
-
-		while (*s++)
-			;
-	}
-
-	return NULL;
-}
-
-int phy_getintvar(struct brcms_phy *pi, const char *name)
-{
-	char *val;
-	unsigned long res;
-
-	val = PHY_GETVAR(pi, name);
-	if (val && !kstrtoul(val, 0, &res))
-		return res;
-
-	return 0;
-}
-
 void wlc_phyreg_enter(struct brcms_phy_pub *pih)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 4468090..4330e38 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -919,12 +919,6 @@ struct lcnphy_radio_regs {
 	u8 do_init_g;
 };
 
-extern char *phy_getvar(struct brcms_phy *pi, const char *name);
-extern int phy_getintvar(struct brcms_phy *pi, const char *name);
-
-#define PHY_GETVAR(pi, name)    phy_getvar(pi, name)
-#define PHY_GETINTVAR(pi, name) phy_getintvar(pi, name)
-
 extern u16 read_phy_reg(struct brcms_phy *pi, u16 addr);
 extern void write_phy_reg(struct brcms_phy *pi, u16 addr, u16 val);
 extern void and_phy_reg(struct brcms_phy *pi, u16 addr, u16 val);
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index a87e392..dbeeeba 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -4823,18 +4823,21 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		u32 offset_ofdm, offset_mcs;
 
 		pi_lcn->lcnphy_tr_isolation_mid =
-			(u8) PHY_GETINTVAR(pi, "triso2g");
+			(u8) wlapi_getintvar(pi->vars, "triso2g");
 
 		pi_lcn->lcnphy_rx_power_offset =
-			(u8) PHY_GETINTVAR(pi, "rxpo2g");
+			(u8) wlapi_getintvar(pi->vars, "rxpo2g");
 
-		pi->txpa_2g[0] = (s16) PHY_GETINTVAR(pi, "pa0b0");
-		pi->txpa_2g[1] = (s16) PHY_GETINTVAR(pi, "pa0b1");
-		pi->txpa_2g[2] = (s16) PHY_GETINTVAR(pi, "pa0b2");
+		pi->txpa_2g[0] = (s16) wlapi_getintvar(pi->vars, "pa0b0");
+		pi->txpa_2g[1] = (s16) wlapi_getintvar(pi->vars, "pa0b1");
+		pi->txpa_2g[2] = (s16) wlapi_getintvar(pi->vars, "pa0b2");
 
-		pi_lcn->lcnphy_rssi_vf = (u8) PHY_GETINTVAR(pi, "rssismf2g");
-		pi_lcn->lcnphy_rssi_vc = (u8) PHY_GETINTVAR(pi, "rssismc2g");
-		pi_lcn->lcnphy_rssi_gs = (u8) PHY_GETINTVAR(pi, "rssisav2g");
+		pi_lcn->lcnphy_rssi_vf =
+				(u8) wlapi_getintvar(pi->vars, "rssismf2g");
+		pi_lcn->lcnphy_rssi_vc =
+				(u8) wlapi_getintvar(pi->vars, "rssismc2g");
+		pi_lcn->lcnphy_rssi_gs =
+				(u8) wlapi_getintvar(pi->vars, "rssisav2g");
 
 		pi_lcn->lcnphy_rssi_vf_lowtemp = pi_lcn->lcnphy_rssi_vf;
 		pi_lcn->lcnphy_rssi_vc_lowtemp = pi_lcn->lcnphy_rssi_vc;
@@ -4844,7 +4847,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		pi_lcn->lcnphy_rssi_vc_hightemp = pi_lcn->lcnphy_rssi_vc;
 		pi_lcn->lcnphy_rssi_gs_hightemp = pi_lcn->lcnphy_rssi_gs;
 
-		txpwr = (s8) PHY_GETINTVAR(pi, "maxp2ga0");
+		txpwr = (s8) wlapi_getintvar(pi->vars, "maxp2ga0");
 		pi->tx_srom_max_2g = txpwr;
 
 		for (i = 0; i < PWRTBL_NUM_COEFF; i++) {
@@ -4852,7 +4855,7 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 			pi->txpa_2g_high_temp[i] = pi->txpa_2g[i];
 		}
 
-		cckpo = (u16) PHY_GETINTVAR(pi, "cck2gpo");
+		cckpo = (u16) wlapi_getintvar(pi->vars, "cck2gpo");
 		if (cckpo) {
 			uint max_pwr_chan = txpwr;
 
@@ -4862,7 +4865,8 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 				cckpo >>= 4;
 			}
 
-			offset_ofdm = (u32) PHY_GETINTVAR(pi, "ofdm2gpo");
+			offset_ofdm =
+				(u32) wlapi_getintvar(pi->vars, "ofdm2gpo");
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
 				pi->tx_srom_max_rate_2g[i] =
 					max_pwr_chan -
@@ -4872,12 +4876,13 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		} else {
 			u8 opo = 0;
 
-			opo = (u8) PHY_GETINTVAR(pi, "opo");
+			opo = (u8) wlapi_getintvar(pi->vars, "opo");
 
 			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++)
 				pi->tx_srom_max_rate_2g[i] = txpwr;
 
-			offset_ofdm = (u32) PHY_GETINTVAR(pi, "ofdm2gpo");
+			offset_ofdm =
+				(u32) wlapi_getintvar(pi->vars, "ofdm2gpo");
 
 			for (i = TXP_FIRST_OFDM; i <= TXP_LAST_OFDM; i++) {
 				pi->tx_srom_max_rate_2g[i] = txpwr -
@@ -4885,8 +4890,9 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 				offset_ofdm >>= 4;
 			}
 			offset_mcs =
-				((u16) PHY_GETINTVAR(pi, "mcs2gpo1") << 16) |
-				(u16) PHY_GETINTVAR(pi, "mcs2gpo0");
+				wlapi_getintvar(pi->vars, "mcs2gpo1") << 16;
+			offset_mcs |=
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo0");
 			pi_lcn->lcnphy_mcs20_po = offset_mcs;
 			for (i = TXP_FIRST_SISO_MCS_20;
 			     i <= TXP_LAST_SISO_MCS_20; i++) {
@@ -4897,30 +4903,30 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 		}
 
 		pi_lcn->lcnphy_rawtempsense =
-			(u16) PHY_GETINTVAR(pi, "rawtempsense");
+			(u16) wlapi_getintvar(pi->vars, "rawtempsense");
 		pi_lcn->lcnphy_measPower =
-			(u8) PHY_GETINTVAR(pi, "measpower");
+			(u8) wlapi_getintvar(pi->vars, "measpower");
 		pi_lcn->lcnphy_tempsense_slope =
-			(u8) PHY_GETINTVAR(pi, "tempsense_slope");
+			(u8) wlapi_getintvar(pi->vars, "tempsense_slope");
 		pi_lcn->lcnphy_hw_iqcal_en =
-			(bool) PHY_GETINTVAR(pi, "hw_iqcal_en");
+			(bool) wlapi_getintvar(pi->vars, "hw_iqcal_en");
 		pi_lcn->lcnphy_iqcal_swp_dis =
-			(bool) PHY_GETINTVAR(pi, "iqcal_swp_dis");
+			(bool) wlapi_getintvar(pi->vars, "iqcal_swp_dis");
 		pi_lcn->lcnphy_tempcorrx =
-			(u8) PHY_GETINTVAR(pi, "tempcorrx");
+			(u8) wlapi_getintvar(pi->vars, "tempcorrx");
 		pi_lcn->lcnphy_tempsense_option =
-			(u8) PHY_GETINTVAR(pi, "tempsense_option");
+			(u8) wlapi_getintvar(pi->vars, "tempsense_option");
 		pi_lcn->lcnphy_freqoffset_corr =
-			(u8) PHY_GETINTVAR(pi, "freqoffset_corr");
+			(u8) wlapi_getintvar(pi->vars, "freqoffset_corr");
 		if ((u8) getintvar(pi->vars, "aa2g") > 1)
 			wlc_phy_ant_rxdiv_set((struct brcms_phy_pub *) pi,
 					      (u8) getintvar(pi->vars,
 							     "aa2g"));
 	}
 	pi_lcn->lcnphy_cck_dig_filt_type = -1;
-	if (PHY_GETVAR(pi, "cckdigfilttype")) {
+	if (wlapi_getvar(pi->vars, "cckdigfilttype")) {
 		s16 temp;
-		temp = (s16) PHY_GETINTVAR(pi, "cckdigfilttype");
+		temp = (s16) wlapi_getintvar(pi->vars, "cckdigfilttype");
 		if (temp >= 0)
 			pi_lcn->lcnphy_cck_dig_filt_type = temp;
 	}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 67cfcdd..c410bf0 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14387,25 +14387,25 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 	if (pi->sh->sromrev >= 9)
 		return;
 
-	bw40po = (u16) PHY_GETINTVAR(pi, "bw40po");
+	bw40po = (u16) wlapi_getintvar(pi->vars, "bw40po");
 	pi->bw402gpo = bw40po & 0xf;
 	pi->bw405gpo = (bw40po & 0xf0) >> 4;
 	pi->bw405glpo = (bw40po & 0xf00) >> 8;
 	pi->bw405ghpo = (bw40po & 0xf000) >> 12;
 
-	cddpo = (u16) PHY_GETINTVAR(pi, "cddpo");
+	cddpo = (u16) wlapi_getintvar(pi->vars, "cddpo");
 	pi->cdd2gpo = cddpo & 0xf;
 	pi->cdd5gpo = (cddpo & 0xf0) >> 4;
 	pi->cdd5glpo = (cddpo & 0xf00) >> 8;
 	pi->cdd5ghpo = (cddpo & 0xf000) >> 12;
 
-	stbcpo = (u16) PHY_GETINTVAR(pi, "stbcpo");
+	stbcpo = (u16) wlapi_getintvar(pi->vars, "stbcpo");
 	pi->stbc2gpo = stbcpo & 0xf;
 	pi->stbc5gpo = (stbcpo & 0xf0) >> 4;
 	pi->stbc5glpo = (stbcpo & 0xf00) >> 8;
 	pi->stbc5ghpo = (stbcpo & 0xf000) >> 12;
 
-	bwduppo = (u16) PHY_GETINTVAR(pi, "bwduppo");
+	bwduppo = (u16) wlapi_getintvar(pi->vars, "bwduppo");
 	pi->bwdup2gpo = bwduppo & 0xf;
 	pi->bwdup5gpo = (bwduppo & 0xf0) >> 4;
 	pi->bwdup5glpo = (bwduppo & 0xf00) >> 8;
@@ -14417,168 +14417,188 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 		case 0:
 
 			pi->nphy_txpid2g[PHY_CORE_0] =
-				(u8) PHY_GETINTVAR(pi, "txpid2ga0");
+				(u8) wlapi_getintvar(pi->vars, "txpid2ga0");
 			pi->nphy_txpid2g[PHY_CORE_1] =
-				(u8) PHY_GETINTVAR(pi, "txpid2ga1");
+				(u8) wlapi_getintvar(pi->vars, "txpid2ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_2g =
-				(s8) PHY_GETINTVAR(pi, "maxp2ga0");
+				(s8) wlapi_getintvar(pi->vars, "maxp2ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_2g =
-				(s8) PHY_GETINTVAR(pi, "maxp2ga1");
+				(s8) wlapi_getintvar(pi->vars, "maxp2ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw0a0");
+				(s16) wlapi_getintvar(pi->vars, "pa2gw0a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw0a1");
+				(s16) wlapi_getintvar(pi->vars, "pa2gw0a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw1a0");
+				(s16) wlapi_getintvar(pi->vars, "pa2gw1a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw1a1");
+				(s16) wlapi_getintvar(pi->vars, "pa2gw1a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_2g_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw2a0");
+				(s16) wlapi_getintvar(pi->vars, "pa2gw2a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_2g_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa2gw2a1");
+				(s16) wlapi_getintvar(pi->vars, "pa2gw2a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_2g =
-				(s8) PHY_GETINTVAR(pi, "itt2ga0");
+				(s8) wlapi_getintvar(pi->vars, "itt2ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_2g =
-				(s8) PHY_GETINTVAR(pi, "itt2ga1");
-
-			pi->cck2gpo = (u16) PHY_GETINTVAR(pi, "cck2gpo");
-
-			pi->ofdm2gpo = (u32) PHY_GETINTVAR(pi, "ofdm2gpo");
-
-			pi->mcs2gpo[0] = (u16) PHY_GETINTVAR(pi, "mcs2gpo0");
-			pi->mcs2gpo[1] = (u16) PHY_GETINTVAR(pi, "mcs2gpo1");
-			pi->mcs2gpo[2] = (u16) PHY_GETINTVAR(pi, "mcs2gpo2");
-			pi->mcs2gpo[3] = (u16) PHY_GETINTVAR(pi, "mcs2gpo3");
-			pi->mcs2gpo[4] = (u16) PHY_GETINTVAR(pi, "mcs2gpo4");
-			pi->mcs2gpo[5] = (u16) PHY_GETINTVAR(pi, "mcs2gpo5");
-			pi->mcs2gpo[6] = (u16) PHY_GETINTVAR(pi, "mcs2gpo6");
-			pi->mcs2gpo[7] = (u16) PHY_GETINTVAR(pi, "mcs2gpo7");
+				(s8) wlapi_getintvar(pi->vars, "itt2ga1");
+
+			pi->cck2gpo =
+				(u16) wlapi_getintvar(pi->vars, "cck2gpo");
+			pi->ofdm2gpo =
+				(u32) wlapi_getintvar(pi->vars, "ofdm2gpo");
+
+			pi->mcs2gpo[0] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo0");
+			pi->mcs2gpo[1] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo1");
+			pi->mcs2gpo[2] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo2");
+			pi->mcs2gpo[3] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo3");
+			pi->mcs2gpo[4] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo4");
+			pi->mcs2gpo[5] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo5");
+			pi->mcs2gpo[6] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo6");
+			pi->mcs2gpo[7] =
+				(u16) wlapi_getintvar(pi->vars, "mcs2gpo7");
 			break;
 		case 1:
 
 			pi->nphy_txpid5g[PHY_CORE_0] =
-				(u8) PHY_GETINTVAR(pi, "txpid5ga0");
+				(u8) wlapi_getintvar(pi->vars, "txpid5ga0");
 			pi->nphy_txpid5g[PHY_CORE_1] =
-				(u8) PHY_GETINTVAR(pi, "txpid5ga1");
+				(u8) wlapi_getintvar(pi->vars, "txpid5ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].max_pwr_5gm =
-				(s8) PHY_GETINTVAR(pi, "maxp5ga0");
+				(s8) wlapi_getintvar(pi->vars, "maxp5ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].max_pwr_5gm =
-				(s8) PHY_GETINTVAR(pi, "maxp5ga1");
+				(s8) wlapi_getintvar(pi->vars, "maxp5ga1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw0a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5gw0a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw0a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5gw0a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw1a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5gw1a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw1a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5gw1a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].pwrdet_5gm_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw2a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5gw2a0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].pwrdet_5gm_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5gw2a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5gw2a1");
 			pi->nphy_pwrctrl_info[PHY_CORE_0].idle_targ_5gm =
-				(s8) PHY_GETINTVAR(pi, "itt5ga0");
+				(s8) wlapi_getintvar(pi->vars, "itt5ga0");
 			pi->nphy_pwrctrl_info[PHY_CORE_1].idle_targ_5gm =
-				(s8) PHY_GETINTVAR(pi, "itt5ga1");
-
-			pi->ofdm5gpo = (u32) PHY_GETINTVAR(pi, "ofdm5gpo");
-
-			pi->mcs5gpo[0] = (u16) PHY_GETINTVAR(pi, "mcs5gpo0");
-			pi->mcs5gpo[1] = (u16) PHY_GETINTVAR(pi, "mcs5gpo1");
-			pi->mcs5gpo[2] = (u16) PHY_GETINTVAR(pi, "mcs5gpo2");
-			pi->mcs5gpo[3] = (u16) PHY_GETINTVAR(pi, "mcs5gpo3");
-			pi->mcs5gpo[4] = (u16) PHY_GETINTVAR(pi, "mcs5gpo4");
-			pi->mcs5gpo[5] = (u16) PHY_GETINTVAR(pi, "mcs5gpo5");
-			pi->mcs5gpo[6] = (u16) PHY_GETINTVAR(pi, "mcs5gpo6");
-			pi->mcs5gpo[7] = (u16) PHY_GETINTVAR(pi, "mcs5gpo7");
+				(s8) wlapi_getintvar(pi->vars, "itt5ga1");
+
+			pi->ofdm5gpo =
+				(u32) wlapi_getintvar(pi->vars, "ofdm5gpo");
+
+			pi->mcs5gpo[0] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo0");
+			pi->mcs5gpo[1] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo1");
+			pi->mcs5gpo[2] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo2");
+			pi->mcs5gpo[3] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo3");
+			pi->mcs5gpo[4] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo4");
+			pi->mcs5gpo[5] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo5");
+			pi->mcs5gpo[6] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo6");
+			pi->mcs5gpo[7] =
+				(u16) wlapi_getintvar(pi->vars, "mcs5gpo7");
 			break;
 		case 2:
 
 			pi->nphy_txpid5gl[0] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gla0");
+				(u8) wlapi_getintvar(pi->vars, "txpid5gla0");
 			pi->nphy_txpid5gl[1] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gla1");
+				(u8) wlapi_getintvar(pi->vars, "txpid5gla1");
 			pi->nphy_pwrctrl_info[0].max_pwr_5gl =
-				(s8) PHY_GETINTVAR(pi, "maxp5gla0");
+				(s8) wlapi_getintvar(pi->vars, "maxp5gla0");
 			pi->nphy_pwrctrl_info[1].max_pwr_5gl =
-				(s8) PHY_GETINTVAR(pi, "maxp5gla1");
+				(s8) wlapi_getintvar(pi->vars, "maxp5gla1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw0a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5glw0a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw0a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5glw0a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw1a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5glw1a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw1a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5glw1a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gl_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw2a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5glw2a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gl_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5glw2a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5glw2a1");
 			pi->nphy_pwrctrl_info[0].idle_targ_5gl = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gl = 0;
 
-			pi->ofdm5glpo = (u32) PHY_GETINTVAR(pi, "ofdm5glpo");
+			pi->ofdm5glpo =
+				(u32) wlapi_getintvar(pi->vars, "ofdm5glpo");
 
 			pi->mcs5glpo[0] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo0");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo0");
 			pi->mcs5glpo[1] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo1");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo1");
 			pi->mcs5glpo[2] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo2");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo2");
 			pi->mcs5glpo[3] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo3");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo3");
 			pi->mcs5glpo[4] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo4");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo4");
 			pi->mcs5glpo[5] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo5");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo5");
 			pi->mcs5glpo[6] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo6");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo6");
 			pi->mcs5glpo[7] =
-				(u16) PHY_GETINTVAR(pi, "mcs5glpo7");
+				(u16) wlapi_getintvar(pi->vars, "mcs5glpo7");
 			break;
 		case 3:
 
 			pi->nphy_txpid5gh[0] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gha0");
+				(u8) wlapi_getintvar(pi->vars, "txpid5gha0");
 			pi->nphy_txpid5gh[1] =
-				(u8) PHY_GETINTVAR(pi, "txpid5gha1");
+				(u8) wlapi_getintvar(pi->vars, "txpid5gha1");
 			pi->nphy_pwrctrl_info[0].max_pwr_5gh =
-				(s8) PHY_GETINTVAR(pi, "maxp5gha0");
+				(s8) wlapi_getintvar(pi->vars, "maxp5gha0");
 			pi->nphy_pwrctrl_info[1].max_pwr_5gh =
-				(s8) PHY_GETINTVAR(pi, "maxp5gha1");
+				(s8) wlapi_getintvar(pi->vars, "maxp5gha1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw0a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5ghw0a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_a1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw0a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5ghw0a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw1a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5ghw1a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b0 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw1a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5ghw1a1");
 			pi->nphy_pwrctrl_info[0].pwrdet_5gh_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw2a0");
+				(s16) wlapi_getintvar(pi->vars, "pa5ghw2a0");
 			pi->nphy_pwrctrl_info[1].pwrdet_5gh_b1 =
-				(s16) PHY_GETINTVAR(pi, "pa5ghw2a1");
+				(s16) wlapi_getintvar(pi->vars, "pa5ghw2a1");
 			pi->nphy_pwrctrl_info[0].idle_targ_5gh = 0;
 			pi->nphy_pwrctrl_info[1].idle_targ_5gh = 0;
 
-			pi->ofdm5ghpo = (u32) PHY_GETINTVAR(pi, "ofdm5ghpo");
+			pi->ofdm5ghpo =
+				(u32) wlapi_getintvar(pi->vars, "ofdm5ghpo");
 
 			pi->mcs5ghpo[0] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo0");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo0");
 			pi->mcs5ghpo[1] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo1");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo1");
 			pi->mcs5ghpo[2] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo2");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo2");
 			pi->mcs5ghpo[3] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo3");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo3");
 			pi->mcs5ghpo[4] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo4");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo4");
 			pi->mcs5ghpo[5] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo5");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo5");
 			pi->mcs5ghpo[6] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo6");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo6");
 			pi->mcs5ghpo[7] =
-				(u16) PHY_GETINTVAR(pi, "mcs5ghpo7");
+				(u16) wlapi_getintvar(pi->vars, "mcs5ghpo7");
 			break;
 		}
 	}
@@ -14589,34 +14609,40 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 {
 
-	pi->antswitch = (u8) PHY_GETINTVAR(pi, "antswitch");
-	pi->aa2g = (u8) PHY_GETINTVAR(pi, "aa2g");
-	pi->aa5g = (u8) PHY_GETINTVAR(pi, "aa5g");
-
-	pi->srom_fem2g.tssipos = (u8) PHY_GETINTVAR(pi, "tssipos2g");
-	pi->srom_fem2g.extpagain = (u8) PHY_GETINTVAR(pi, "extpagain2g");
-	pi->srom_fem2g.pdetrange = (u8) PHY_GETINTVAR(pi, "pdetrange2g");
-	pi->srom_fem2g.triso = (u8) PHY_GETINTVAR(pi, "triso2g");
-	pi->srom_fem2g.antswctrllut = (u8) PHY_GETINTVAR(pi, "antswctl2g");
-
-	pi->srom_fem5g.tssipos = (u8) PHY_GETINTVAR(pi, "tssipos5g");
-	pi->srom_fem5g.extpagain = (u8) PHY_GETINTVAR(pi, "extpagain5g");
-	pi->srom_fem5g.pdetrange = (u8) PHY_GETINTVAR(pi, "pdetrange5g");
-	pi->srom_fem5g.triso = (u8) PHY_GETINTVAR(pi, "triso5g");
-	if (PHY_GETVAR(pi, "antswctl5g"))
+	pi->antswitch = (u8) wlapi_getintvar(pi->vars, "antswitch");
+	pi->aa2g = (u8) wlapi_getintvar(pi->vars, "aa2g");
+	pi->aa5g = (u8) wlapi_getintvar(pi->vars, "aa5g");
+
+	pi->srom_fem2g.tssipos = (u8) wlapi_getintvar(pi->vars, "tssipos2g");
+	pi->srom_fem2g.extpagain =
+			(u8) wlapi_getintvar(pi->vars, "extpagain2g");
+	pi->srom_fem2g.pdetrange =
+			(u8) wlapi_getintvar(pi->vars, "pdetrange2g");
+	pi->srom_fem2g.triso = (u8) wlapi_getintvar(pi->vars, "triso2g");
+	pi->srom_fem2g.antswctrllut =
+			(u8) wlapi_getintvar(pi->vars, "antswctl2g");
+
+	pi->srom_fem5g.tssipos = (u8) wlapi_getintvar(pi->vars, "tssipos5g");
+	pi->srom_fem5g.extpagain =
+			(u8) wlapi_getintvar(pi->vars, "extpagain5g");
+	pi->srom_fem5g.pdetrange =
+			(u8) wlapi_getintvar(pi->vars, "pdetrange5g");
+	pi->srom_fem5g.triso = (u8) wlapi_getintvar(pi->vars, "triso5g");
+	if (wlapi_getvar(pi->vars, "antswctl5g"))
 		pi->srom_fem5g.antswctrllut =
-			(u8) PHY_GETINTVAR(pi, "antswctl5g");
+			(u8) wlapi_getintvar(pi->vars, "antswctl5g");
 	else
 		pi->srom_fem5g.antswctrllut =
-			(u8) PHY_GETINTVAR(pi, "antswctl2g");
+			(u8) wlapi_getintvar(pi->vars, "antswctl2g");
 
 	wlc_phy_txpower_ipa_upd(pi);
 
-	pi->phy_txcore_disable_temp = (s16) PHY_GETINTVAR(pi, "tempthresh");
+	pi->phy_txcore_disable_temp =
+			(s16) wlapi_getintvar(pi->vars, "tempthresh");
 	if (pi->phy_txcore_disable_temp == 0)
 		pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
 
-	pi->phy_tempsense_offset = (s8) PHY_GETINTVAR(pi, "tempoffset");
+	pi->phy_tempsense_offset = (s8) wlapi_getintvar(pi->vars, "tempoffset");
 	if (pi->phy_tempsense_offset != 0) {
 		if (pi->phy_tempsense_offset >
 		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET))
@@ -14631,7 +14657,8 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 	pi->phy_txcore_enable_temp =
 		pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
 
-	pi->phycal_tempdelta = (u8) PHY_GETINTVAR(pi, "phycal_tempdelta");
+	pi->phycal_tempdelta =
+			(u8) wlapi_getintvar(pi->vars, "phycal_tempdelta");
 	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
 		pi->phycal_tempdelta = 0;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.c b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
index e0c19b6..0be07ed 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.c
@@ -215,3 +215,12 @@ wlapi_copyto_objmem(struct phy_shim_info *physhim, uint offset, const void *buf,
 {
 	brcms_b_copyto_objmem(physhim->wlc_hw, offset, buf, l, sel);
 }
+
+char *wlapi_getvar(char *vars, const char *name)
+{
+	return getvar(vars, name);
+}
+int wlapi_getintvar(char *vars, const char *name)
+{
+	return getintvar(vars, name);
+}
diff --git a/drivers/staging/brcm80211/brcmsmac/phy_shim.h b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
index d88c820..35fe993 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy_shim.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy_shim.h
@@ -178,4 +178,7 @@ extern void wlapi_copyto_objmem(struct phy_shim_info *physhim, uint,
 extern void wlapi_high_update_phy_mode(struct phy_shim_info *physhim,
 				       u32 phy_mode);
 extern u16 wlapi_bmac_get_txant(struct phy_shim_info *physhim);
+extern char *wlapi_getvar(char *vars, const char *name);
+extern int wlapi_getintvar(char *vars, const char *name);
+
 #endif				/* _BRCM_PHY_SHIM_H_ */
-- 
1.7.4.1


