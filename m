Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53883 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751799Ab2F3NR6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jun 2012 09:17:58 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: linville@tuxdriver.com, arend@broadcom.com
Cc: brcm80211-dev-list@broadcom.com, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH v2 13/18] brcmsmac: add some workarounds for other chips again
Date: Sat, 30 Jun 2012 15:16:16 +0200
Message-Id: <1341062181-28071-14-git-send-email-hauke@hauke-m.de> (sfid-20120630_151801_325993_70C5170C)
In-Reply-To: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
References: <1341062181-28071-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds some workarounds for the BCM4716, BCM47162, BCM5357 to the
phy code again. This patch reverts parts of the following patch.

commit c2c724977f95135f397fe0cb45f3c041d26b91e1
Author: Arend van Spriel <arend@broadcom.com>
Date:   Wed Jun 29 16:46:35 2011 -0700

    staging: brcm80211: remove unsupported chipset code from brcmsmac phy

The BCM4716 is working for me with an other firmware and I am working
on adding support for the other chips.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 .../net/wireless/brcm80211/brcmsmac/phy/phy_n.c    |  131 +++++++++++++-------
 1 file changed, 89 insertions(+), 42 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c b/drivers/net/wireless/brcm80211/brcmsmac/phy/phy_n.c
index 14da744..65db9b7 100644
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
 
@@ -20695,12 +20707,22 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
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
 
@@ -20747,24 +20769,30 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
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
+					     pi->sh->chip == BCMA_CHIP_ID_BCM43225) &&
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
@@ -20863,11 +20891,10 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 
 			cascbias = 0x30;
 
-			if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224) ||
-			    (pi->sh->chip == BCMA_CHIP_ID_BCM43225)) {
-				if (pi->sh->chippkg == BCMA_PKG_ID_BCM43224_FAB_SMIC)
-					cascbias = 0x35;
-			}
+			if ((pi->sh->chip == BCMA_CHIP_ID_BCM43224 ||
+			     pi->sh->chip == BCMA_CHIP_ID_BCM43225) &&
+			    pi->sh->chippkg == BCMA_PKG_ID_BCM43224_FAB_SMIC)
+				cascbias = 0x35;
 
 			pabias = (pi->phy_pabias == 0) ? 0x30 : pi->phy_pabias;
 
@@ -21179,19 +21206,29 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
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
+		    (pi->sh->chip == BCMA_CHIP_ID_BCM43225)) {
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
@@ -21210,7 +21247,9 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			}
 		}
 
-		wlapi_bmac_core_phypll_reset(pi->sh->physhim);
+		if (!((pi->sh->chip == BCMA_CHIP_ID_BCM4716) ||
+		      (pi->sh->chip == BCMA_CHIP_ID_BCM47162)))
+			wlapi_bmac_core_phypll_reset(pi->sh->physhim);
 
 		mod_phy_reg(pi, 0x01, (0x1 << 15),
 			    ((spuravoid > 0) ? (0x1 << 15) : 0));
@@ -22172,9 +22211,15 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
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
 
@@ -24924,14 +24969,16 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
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

