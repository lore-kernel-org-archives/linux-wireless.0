Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4623 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757865Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 011/119] staging: brcm80211: remove unsupported chipset
 code from brcmsmac phy
Date: Wed, 29 Jun 2011 16:46:35 -0700
Message-ID: <1309391303-22741-12-git-send-email-frankyl@broadcom.com> (sfid-20110630_014945_269909_A427B99C)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

the phy sources contained some code fragments for chipsets that are not
supported by this driver, which have been removed.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c |   14 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c   |  160 ++++++----------------
 2 files changed, 44 insertions(+), 130 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index 79008a9..dd56f10 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -981,9 +981,8 @@ wlc_phy_table_addr(phy_info_t *pi, uint tbl_id, uint tbl_offset,
 	pi->tbl_data_hi = tblDataHi;
 	pi->tbl_data_lo = tblDataLo;
 
-	if ((pi->sh->chip == BCM43224_CHIP_ID ||
-	     pi->sh->chip == BCM43421_CHIP_ID) &&
-	    (pi->sh->chiprev == 1)) {
+	if (pi->sh->chip == BCM43224_CHIP_ID &&
+	    pi->sh->chiprev == 1) {
 		pi->tbl_addr = tblAddr;
 		pi->tbl_save_id = tbl_id;
 		pi->tbl_save_offset = tbl_offset;
@@ -992,8 +991,7 @@ wlc_phy_table_addr(phy_info_t *pi, uint tbl_id, uint tbl_offset,
 
 void wlc_phy_table_data_write(phy_info_t *pi, uint width, u32 val)
 {
-	if ((pi->sh->chip == BCM43224_CHIP_ID ||
-	     pi->sh->chip == BCM43421_CHIP_ID) &&
+	if ((pi->sh->chip == BCM43224_CHIP_ID) &&
 	    (pi->sh->chiprev == 1) &&
 	    (pi->tbl_save_id == NPHY_TBL_ID_ANTSWCTRLLUT)) {
 		read_phy_reg(pi, pi->tbl_data_lo);
@@ -1029,8 +1027,7 @@ wlc_phy_write_table(phy_info_t *pi, const phytbl_info_t *ptbl_info,
 
 	for (idx = 0; idx < ptbl_info->tbl_len; idx++) {
 
-		if ((pi->sh->chip == BCM43224_CHIP_ID ||
-		     pi->sh->chip == BCM43421_CHIP_ID) &&
+		if ((pi->sh->chip == BCM43224_CHIP_ID) &&
 		    (pi->sh->chiprev == 1) &&
 		    (tbl_id == NPHY_TBL_ID_ANTSWCTRLLUT)) {
 			read_phy_reg(pi, tblDataLo);
@@ -1070,8 +1067,7 @@ wlc_phy_read_table(phy_info_t *pi, const phytbl_info_t *ptbl_info,
 
 	for (idx = 0; idx < ptbl_info->tbl_len; idx++) {
 
-		if ((pi->sh->chip == BCM43224_CHIP_ID ||
-		     pi->sh->chip == BCM43421_CHIP_ID) &&
+		if ((pi->sh->chip == BCM43224_CHIP_ID) &&
 		    (pi->sh->chiprev == 1)) {
 			(void)read_phy_reg(pi, tblDataLo);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 696825f..ff0eb22 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14550,11 +14550,6 @@ void WLBANDINITFN(wlc_phy_init_nphy) (phy_info_t *pi)
 		}
 	}
 
-	if ((!PHY_IPA(pi)) && (pi->sh->chip == BCM5357_CHIP_ID)) {
-		si_pmu_chipcontrol(pi->sh->sih, 1, CCTRL5357_EXTPA,
-				   CCTRL5357_EXTPA);
-	}
-
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
@@ -17581,11 +17576,6 @@ static void wlc_phy_radio_postinit_2057(phy_info_t *pi)
 
 	mod_radio_reg(pi, RADIO_2057_XTALPUOVR_PINCTRL, 0x1, 0x1);
 
-	if (pi->sh->chip == !BCM6362_CHIP_ID) {
-
-		mod_radio_reg(pi, RADIO_2057_XTALPUOVR_PINCTRL, 0x2, 0x2);
-	}
-
 	mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x78, 0x78);
 	mod_radio_reg(pi, RADIO_2057_XTAL_CONFIG2, 0x80, 0x80);
 	mdelay(2);
@@ -17986,23 +17976,12 @@ wlc_phy_chanspec_radio2056_setup(phy_info_t *pi,
 			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 |
 					RADIO_2056_SYN, 0x1f);
 
-			if ((pi->sh->chip == BCM4716_CHIP_ID) ||
-			    (pi->sh->chip == BCM47162_CHIP_ID)) {
-
-				write_radio_reg(pi,
-						RADIO_2056_SYN_PLL_LOOPFILTER4 |
-						RADIO_2056_SYN, 0x14);
-				write_radio_reg(pi,
-						RADIO_2056_SYN_PLL_CP2 |
-						RADIO_2056_SYN, 0x00);
-			} else {
-				write_radio_reg(pi,
-						RADIO_2056_SYN_PLL_LOOPFILTER4 |
-						RADIO_2056_SYN, 0xb);
-				write_radio_reg(pi,
-						RADIO_2056_SYN_PLL_CP2 |
-						RADIO_2056_SYN, 0x14);
-			}
+			write_radio_reg(pi,
+					RADIO_2056_SYN_PLL_LOOPFILTER4 |
+					RADIO_2056_SYN, 0xb);
+			write_radio_reg(pi,
+					RADIO_2056_SYN_PLL_CP2 |
+					RADIO_2056_SYN, 0x14);
 		}
 	}
 
@@ -18049,38 +18028,25 @@ wlc_phy_chanspec_radio2056_setup(phy_info_t *pi,
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
 						 PADG_IDAC, 0xcc);
 
-				if ((pi->sh->chip == BCM4716_CHIP_ID) ||
-				    (pi->sh->chip ==
-				     BCM47162_CHIP_ID)) {
-					bias = 0x40;
-					cascbias = 0x45;
-					pag_boost_tune = 0x5;
-					pgag_boost_tune = 0x33;
-					padg_boost_tune = 0x77;
-					mixg_boost_tune = 0x55;
-				} else {
-					bias = 0x25;
-					cascbias = 0x20;
-
-					if ((pi->sh->chip ==
-					     BCM43224_CHIP_ID)
-					    || (pi->sh->chip ==
-						BCM43225_CHIP_ID)
-					    || (pi->sh->chip ==
-						BCM43421_CHIP_ID)) {
-						if (pi->sh->chippkg ==
-						    BCM43224_FAB_SMIC) {
-							bias = 0x2a;
-							cascbias = 0x38;
-						}
+				bias = 0x25;
+				cascbias = 0x20;
+
+				if ((pi->sh->chip ==
+				     BCM43224_CHIP_ID)
+				    || (pi->sh->chip ==
+					BCM43225_CHIP_ID)) {
+					if (pi->sh->chippkg ==
+					    BCM43224_FAB_SMIC) {
+						bias = 0x2a;
+						cascbias = 0x38;
 					}
-
-					pag_boost_tune = 0x4;
-					pgag_boost_tune = 0x03;
-					padg_boost_tune = 0x77;
-					mixg_boost_tune = 0x65;
 				}
 
+				pag_boost_tune = 0x4;
+				pgag_boost_tune = 0x03;
+				padg_boost_tune = 0x77;
+				mixg_boost_tune = 0x65;
+
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
 						 INTPAG_IMAIN_STAT, bias);
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
@@ -18178,8 +18144,7 @@ wlc_phy_chanspec_radio2056_setup(phy_info_t *pi,
 			cascbias = 0x30;
 
 			if ((pi->sh->chip == BCM43224_CHIP_ID) ||
-			    (pi->sh->chip == BCM43225_CHIP_ID) ||
-			    (pi->sh->chip == BCM43421_CHIP_ID)) {
+			    (pi->sh->chip == BCM43225_CHIP_ID)) {
 				if (pi->sh->chippkg == BCM43224_FAB_SMIC) {
 					cascbias = 0x35;
 				}
@@ -18907,14 +18872,8 @@ static void wlc_phy_spurwar_nphy(phy_info_t *pi)
 			case 38:
 			case 102:
 			case 118:
-				if ((pi->sh->chip == BCM4716_CHIP_ID) &&
-				    (pi->sh->chippkg == BCM4717_PKG_ID)) {
-					nphy_adj_tone_id_buf[0] = 32;
-					nphy_adj_noise_var_buf[0] = 0x21f;
-				} else {
-					nphy_adj_tone_id_buf[0] = 0;
-					nphy_adj_noise_var_buf[0] = 0x0;
-				}
+				nphy_adj_tone_id_buf[0] = 0;
+				nphy_adj_noise_var_buf[0] = 0x0;
 				break;
 			case 134:
 				nphy_adj_tone_id_buf[0] = 32;
@@ -19041,34 +19000,20 @@ wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chanspec,
 
 				if (pi->nphy_aband_spurwar_en &&
 				    ((val == 38) || (val == 102)
-				     || (val == 118))) {
-					if ((pi->sh->chip ==
-					     BCM4716_CHIP_ID)
-					    && (pi->sh->chippkg ==
-						BCM4717_PKG_ID)) {
-						spuravoid = 0;
-					} else {
-						spuravoid = 1;
-					}
-				}
+				     || (val == 118)))
+					spuravoid = 1;
 			}
 		}
 
 		if (pi->phy_spuravoid == SPURAVOID_FORCEON)
 			spuravoid = 1;
 
-		if ((pi->sh->chip == BCM4716_CHIP_ID) ||
-		    (pi->sh->chip == BCM47162_CHIP_ID)) {
-			si_pmu_spuravoid(pi->sh->sih, spuravoid);
-		} else {
-			wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
-			si_pmu_spuravoid(pi->sh->sih, spuravoid);
-			wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
-		}
+		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
+		si_pmu_spuravoid(pi->sh->sih, spuravoid);
+		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
 
 		if ((pi->sh->chip == BCM43224_CHIP_ID) ||
-		    (pi->sh->chip == BCM43225_CHIP_ID) ||
-		    (pi->sh->chip == BCM43421_CHIP_ID)) {
+		    (pi->sh->chip == BCM43225_CHIP_ID)) {
 
 			if (spuravoid == 1) {
 
@@ -19085,10 +19030,7 @@ wlc_phy_chanspec_nphy_setup(phy_info_t *pi, chanspec_t chanspec,
 			}
 		}
 
-		if (!((pi->sh->chip == BCM4716_CHIP_ID) ||
-		      (pi->sh->chip == BCM47162_CHIP_ID))) {
-			wlapi_bmac_core_phypll_reset(pi->sh->physhim);
-		}
+		wlapi_bmac_core_phypll_reset(pi->sh->physhim);
 
 		mod_phy_reg(pi, 0x01, (0x1 << 15),
 			    ((spuravoid > 0) ? (0x1 << 15) : 0));
@@ -21035,19 +20977,9 @@ s16 wlc_phy_tempsense_nphy(phy_info_t *pi)
 		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
 					 &auxADC_rssi_ctrlH_save);
 
-		if (pi->sh->chip == BCM5357_CHIP_ID) {
-			radio_temp[0] = (193 * (radio_temp[1] + radio_temp2[1])
-					 + 88 * (auxADC_Vl) - 27111 +
-					 128) / 256;
-		} else if (pi->sh->chip == BCM43236_CHIP_ID) {
-			radio_temp[0] = (198 * (radio_temp[1] + radio_temp2[1])
-					 + 91 * (auxADC_Vl) - 27243 +
-					 128) / 256;
-		} else {
-			radio_temp[0] = (179 * (radio_temp[1] + radio_temp2[1])
-					 + 82 * (auxADC_Vl) - 28861 +
-					 128) / 256;
-		}
+		radio_temp[0] = (179 * (radio_temp[1] + radio_temp2[1])
+				 + 82 * (auxADC_Vl) - 28861 +
+				 128) / 256;
 
 		offset = (s16) pi->phy_tempsense_offset;
 
@@ -26237,11 +26169,6 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(phy_info_t *pi)
 		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
 
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev6;
-			if (pi->sh->chip == BCM47162_CHIP_ID) {
-
-				tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev5;
-			}
-
 		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
 
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev5;
@@ -26781,11 +26708,8 @@ wlc_phy_a2_nphy(phy_info_t *pi, nphy_ipa_txcalgains_t *txgains,
 		phy_a2 = 63;
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			if (pi->sh->chip == BCM6362_CHIP_ID) {
-				phy_a1 = 35;
-				phy_a3 = 35;
-			} else if ((pi->pubpi.radiorev == 4)
-				   || (pi->pubpi.radiorev == 6)) {
+			if ((pi->pubpi.radiorev == 4)
+			    || (pi->pubpi.radiorev == 6)) {
 				phy_a1 = 30;
 				phy_a3 = 30;
 			} else {
@@ -26891,16 +26815,10 @@ wlc_phy_a2_nphy(phy_info_t *pi, nphy_ipa_txcalgains_t *txgains,
 			if (txgains->useindex) {
 				phy_a4 = 15 - ((txgains->index) >> 3);
 				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					if (NREV_GE(pi->pubpi.phy_rev, 6)) {
+					if (NREV_GE(pi->pubpi.phy_rev, 6))
 						phy_a5 = 0x00f7 | (phy_a4 << 8);
 
-						if (pi->sh->chip ==
-						    BCM47162_CHIP_ID) {
-							phy_a5 =
-							    0x10f7 | (phy_a4 <<
-								      8);
-						}
-					} else
+					else
 					    if (NREV_IS(pi->pubpi.phy_rev, 5))
 						phy_a5 = 0x10f7 | (phy_a4 << 8);
 					else
-- 
1.7.1


