Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:36274 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753543Ab2FEXIi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jun 2012 19:08:38 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com, brudley@broadcom.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 13/18] brcmsmac: add some workarounds for other chips again
Date: Wed,  6 Jun 2012 01:07:16 +0200
Message-Id: <1338937641-8519-14-git-send-email-hauke@hauke-m.de> (sfid-20120606_012943_849975_AC7F4B25)
In-Reply-To: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
References: <1338937641-8519-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some workarounds for the BCM4716, BCM47162, BCM43421, BCM5357
and BCM6362 to the phy code again. This patch reverts the following
patch expect the part with the workaround for the BCM43236, which is an
usb chip and will be unsupported by brcmsmac.

commit c2c724977f95135f397fe0cb45f3c041d26b91e1
Author: Arend van Spriel <arend@broadcom.com>
Date:   Wed Jun 29 16:46:35 2011 -0700

    staging: brcm80211: remove unsupported chipset code from brcmsmac phy

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c  |   14 +-
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |  144 ++++++++++++++------
 2 files changed, 109 insertions(+), 49 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
index d16cbec..5cfbe5c 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -837,8 +837,9 @@ wlc_phy_table_addr(struct brcms_phy *pi, uint tbl_id, uint tbl_offset,
 	pi->tbl_data_hi = tblDataHi;
 	pi->tbl_data_lo = tblDataLo;
 
-	if (pi->sh->chip == BCMA_CHIP_ID_BCM43224 &&
-	    pi->sh->chiprev == 1) {
+	if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224 ||
+	     pi->sh->chip == BCMA_CHIP_ID_BCM43421) &&
+	    (pi->sh->chiprev == 1)) {
 		pi->tbl_addr = tblAddr;
 		pi->tbl_save_id = tbl_id;
 		pi->tbl_save_offset = tbl_offset;
@@ -847,7 +848,8 @@ wlc_phy_table_addr(struct brcms_phy *pi, uint tbl_id, uint tbl_offset,
 
 void wlc_phy_table_data_write(struct brcms_phy *pi, uint width, u32 val)
 {
-	if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) &&
+	if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224 ||
+	     pi->sh->chip == BCMA_CHIP_ID_BCM43421) &&
 	    (pi->sh->chiprev == 1) &&
 	    (pi->tbl_save_id == NPHY_TBL_ID_ANTSWCTRLLUT)) {
 		read_phy_reg(pi, pi->tbl_data_lo);
@@ -881,7 +883,8 @@ wlc_phy_write_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 
 	for (idx = 0; idx < ptbl_info->tbl_len; idx++) {
 
-		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) &&
+		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224 ||
+		     pi->sh->chip == BCMA_CHIP_ID_BCM43421) &&
 		    (pi->sh->chiprev == 1) &&
 		    (tbl_id == NPHY_TBL_ID_ANTSWCTRLLUT)) {
 			read_phy_reg(pi, tblDataLo);
@@ -918,7 +921,8 @@ wlc_phy_read_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 
 	for (idx = 0; idx < ptbl_info->tbl_len; idx++) {
 
-		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) &&
+		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224 ||
+		     pi->sh->chip == BCMA_CHIP_ID_BCM43421) &&
 		    (pi->sh->chiprev == 1)) {
 			(void)read_phy_reg(pi, tblDataLo);
 
diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index f0ccac8..de1101a 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
@@ -17893,6 +17893,8 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi)
 					nphy_tpc_txgain_ipa_2g_2057rev7;
 		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev6;
+			if (pi->sh->chip == BCMA_CHIP_ID_BCM47162)
+				tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev5;
 		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev5;
 		} else {
@@ -19254,8 +19256,14 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 			case 38:
 			case 102:
 			case 118:
-				nphy_adj_tone_id_buf[0] = 0;
-				nphy_adj_noise_var_buf[0] = 0x0;
+				if ((pi->sh->chip == BCMA_CHIP_ID_BCM4716) &&
+				    (pi->sh->chippkg == BCMA_PKG_ID_BCM4717)) {
+					nphy_adj_tone_id_buf[0] = 32;
+					nphy_adj_noise_var_buf[0] = 0x21f;
+				} else {
+					nphy_adj_tone_id_buf[0] = 0;
+					nphy_adj_noise_var_buf[0] = 0x0;
+				}
 				break;
 			case 134:
 				nphy_adj_tone_id_buf[0] = 32;
@@ -19318,6 +19326,10 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 				  0x40, 0x40);
 	}
 
+	if ((!PHY_IPA(pi)) && (pi->sh->chip == BCMA_CHIP_ID_BCM5357))
+		si_pmu_chipcontrol(pi->sh->sih, 1, CCTRL5357_EXTPA,
+				   CCTRL5357_EXTPA);
+
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
 	    CHSPEC_IS40(pi->radio_chanspec)) {
 
@@ -20060,6 +20072,9 @@ static void wlc_phy_radio_postinit_2057(struct brcms_phy *pi)
 
 	mod_radio_reg(pi, RADIO_2057_XTALPUOVR_PINCTRL, 0x1, 0x1);
 
+	if (pi->sh->chip == !BCMA_CHIP_ID_BCM6362)
+		mod_radio_reg(pi, RADIO_2057_XTALPUOVR_PINCTRL, 0x2, 0x2);
+
 	mod_radio_reg(pi, RADIO_2057_RFPLL_MISC_CAL_RESETN, 0x78, 0x78);
 	mod_radio_reg(pi, RADIO_2057_XTAL_CONFIG2, 0x80, 0x80);
 	mdelay(2);
@@ -20695,12 +20710,22 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 			write_radio_reg(pi, RADIO_2056_SYN_PLL_LOOPFILTER2 |
 					RADIO_2056_SYN, 0x1f);
 
-			write_radio_reg(pi,
-					RADIO_2056_SYN_PLL_LOOPFILTER4 |
-					RADIO_2056_SYN, 0xb);
-			write_radio_reg(pi,
-					RADIO_2056_SYN_PLL_CP2 |
-					RADIO_2056_SYN, 0x14);
+			if ((pi->sh->chip == BCMA_CHIP_ID_BCM4716) ||
+			    (pi->sh->chip == BCMA_CHIP_ID_BCM47162)) {
+				write_radio_reg(pi,
+						RADIO_2056_SYN_PLL_LOOPFILTER4 |
+						RADIO_2056_SYN, 0x14);
+				write_radio_reg(pi,
+						RADIO_2056_SYN_PLL_CP2 |
+						RADIO_2056_SYN, 0x00);
+			} else {
+				write_radio_reg(pi,
+						RADIO_2056_SYN_PLL_LOOPFILTER4 |
+						RADIO_2056_SYN, 0xb);
+				write_radio_reg(pi,
+						RADIO_2056_SYN_PLL_CP2 |
+						RADIO_2056_SYN, 0x14);
+			}
 		}
 	}
 
@@ -20747,24 +20772,31 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
 						 PADG_IDAC, 0xcc);
 
-				bias = 0x25;
-				cascbias = 0x20;
+				if ((pi->sh->chip == BCMA_CHIP_ID_BCM4716) ||
+				    (pi->sh->chip == BCMA_CHIP_ID_BCM47162)) {
+					bias = 0x40;
+					cascbias = 0x45;
+					pag_boost_tune = 0x5;
+					pgag_boost_tune = 0x33;
+					padg_boost_tune = 0x77;
+					mixg_boost_tune = 0x55;
+				} else {
+					bias = 0x25;
+					cascbias = 0x20;
 
-				if ((pi->sh->chip ==
-				     BCMA_CHIP_ID_BCM43224)
-				    || (pi->sh->chip ==
-					BCMA_CHIP_ID_BCM43225)) {
-					if (pi->sh->chippkg ==
-					    BCMA_PKG_ID_BCM43224_FAB_SMIC) {
+					if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224 ||
+					     pi->sh->chip == BCMA_CHIP_ID_BCM43225 ||
+					     pi->sh->chip == BCMA_CHIP_ID_BCM43421) &&
+					    pi->sh->chippkg == BCMA_PKG_ID_BCM43224_FAB_SMIC) {
 						bias = 0x2a;
 						cascbias = 0x38;
 					}
-				}
 
-				pag_boost_tune = 0x4;
-				pgag_boost_tune = 0x03;
-				padg_boost_tune = 0x77;
-				mixg_boost_tune = 0x65;
+					pag_boost_tune = 0x4;
+					pgag_boost_tune = 0x03;
+					padg_boost_tune = 0x77;
+					mixg_boost_tune = 0x65;
+				}
 
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
 						 INTPAG_IMAIN_STAT, bias);
@@ -20863,11 +20895,11 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 
 			cascbias = 0x30;
 
-			if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) ||
-			    (pi->sh->chip == BCMA_CHIP_ID_BCM43225)) {
-				if (pi->sh->chippkg == BCMA_PKG_ID_BCM43224_FAB_SMIC)
-					cascbias = 0x35;
-			}
+			if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224 ||
+			     pi->sh->chip == BCMA_CHIP_ID_BCM43225 ||
+			     pi->sh->chip == BCMA_CHIP_ID_BCM43421) &&
+			    pi->sh->chippkg == BCMA_PKG_ID_BCM43224_FAB_SMIC)
+				cascbias = 0x35;
 
 			pabias = (pi->phy_pabias == 0) ? 0x30 : pi->phy_pabias;
 
@@ -21179,19 +21211,30 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 		} else if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			if (val == 54)
 				spuravoid = 1;
-		} else {
-			if (pi->nphy_aband_spurwar_en &&
-			    ((val == 38) || (val == 102)
-			     || (val == 118)))
+		} else if (pi->nphy_aband_spurwar_en &&
+		    ((val == 38) || (val == 102) || (val == 118))) {
+			if ((pi->sh->chip == BCMA_CHIP_ID_BCM4716)
+			    && (pi->sh->chippkg == BCMA_PKG_ID_BCM4717)) {
+				spuravoid = 0;
+			} else {
 				spuravoid = 1;
+			}
 		}
 
 		if (pi->phy_spuravoid == SPURAVOID_FORCEON)
 			spuravoid = 1;
 
-		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
-		bcma_pmu_spuravoid_pllupdate(&sii->icbus->drv_cc, spuravoid);
-		wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
+		if ((pi->sh->chip == BCMA_CHIP_ID_BCM4716) ||
+		    (pi->sh->chip == BCMA_CHIP_ID_BCM43225) ||
+		    (pi->sh->chip == BCMA_CHIP_ID_BCM43421)) {
+			bcma_pmu_spuravoid_pllupdate(&sii->icbus->drv_cc,
+						     spuravoid);
+		} else {
+			wlapi_bmac_core_phypll_ctl(pi->sh->physhim, false);
+			bcma_pmu_spuravoid_pllupdate(&sii->icbus->drv_cc,
+						     spuravoid);
+			wlapi_bmac_core_phypll_ctl(pi->sh->physhim, true);
+		}
 
 		if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) ||
 		    (pi->sh->chip == BCMA_CHIP_ID_BCM43225)) {
@@ -21210,7 +21253,9 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			}
 		}
 
-		wlapi_bmac_core_phypll_reset(pi->sh->physhim);
+		if (!((pi->sh->chip == BCMA_CHIP_ID_BCM4716) ||
+		      (pi->sh->chip == BCMA_CHIP_ID_BCM47162)))
+			wlapi_bmac_core_phypll_reset(pi->sh->physhim);
 
 		mod_phy_reg(pi, 0x01, (0x1 << 15),
 			    ((spuravoid > 0) ? (0x1 << 15) : 0));
@@ -22172,9 +22217,15 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x03, 16,
 					 &auxADC_rssi_ctrlH_save);
 
-		radio_temp[0] = (179 * (radio_temp[1] + radio_temp2[1])
-				 + 82 * (auxADC_Vl) - 28861 +
-				 128) / 256;
+		if (pi->sh->chip == BCMA_CHIP_ID_BCM5357) {
+			radio_temp[0] = (193 * (radio_temp[1] + radio_temp2[1])
+					 + 88 * (auxADC_Vl) - 27111 +
+					 128) / 256;
+		} else {
+			radio_temp[0] = (179 * (radio_temp[1] + radio_temp2[1])
+					 + 82 * (auxADC_Vl) - 28861 +
+					 128) / 256;
+		}
 
 		offset = (s16) pi->phy_tempsense_offset;
 
@@ -24818,8 +24869,11 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 		phy_a2 = 63;
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			if ((pi->pubpi.radiorev == 4)
-			    || (pi->pubpi.radiorev == 6)) {
+			if (pi->sh->chip == BCMA_CHIP_ID_BCM6362) {
+				phy_a1 = 35;
+				phy_a3 = 35;
+			} else if ((pi->pubpi.radiorev == 4)
+				   || (pi->pubpi.radiorev == 6)) {
 				phy_a1 = 30;
 				phy_a3 = 30;
 			} else {
@@ -24924,14 +24978,16 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 			if (txgains->useindex) {
 				phy_a4 = 15 - ((txgains->index) >> 3);
 				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					if (NREV_GE(pi->pubpi.phy_rev, 6))
+					if (NREV_GE(pi->pubpi.phy_rev, 6) &&
+					    pi->sh->chip == BCMA_CHIP_ID_BCM47162) {
+						phy_a5 = 0x10f7 | (phy_a4 << 8);
+					} else if (NREV_GE(pi->pubpi.phy_rev, 6)) {
 						phy_a5 = 0x00f7 | (phy_a4 << 8);
-
-					else
-					if (NREV_IS(pi->pubpi.phy_rev, 5))
+					} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
 						phy_a5 = 0x10f7 | (phy_a4 << 8);
-					else
+					} else {
 						phy_a5 = 0x50f7 | (phy_a4 << 8);
+					}
 				} else {
 					phy_a5 = 0x70f7 | (phy_a4 << 8);
 				}
-- 
1.7.9.5

