Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3108 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752292Ab1HHN7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Aug 2011 09:59:25 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Roland Vossen" <rvossen@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCHv2 37/82] staging: brcm80211: resolved checkpatch
 warnings in N phy
Date: Mon, 8 Aug 2011 15:58:21 +0200
Message-ID: <1312811946-16713-38-git-send-email-arend@broadcom.com> (sfid-20110808_160149_583248_CD028B62)
In-Reply-To: <1312811946-16713-1-git-send-email-arend@broadcom.com>
References: <1312811946-16713-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code that exceeded the 80 char limit has been placed in separate
functions. Checkpatch warnings for the phy dir are now reduced to 1.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Henry Ptasinski <henryp@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c |  304 ++++++++++--------------
 1 files changed, 128 insertions(+), 176 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index ca6f749..fb64597 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14544,6 +14544,44 @@ static void wlc_phy_txpwrctrl_config_nphy(struct brcms_phy *pi)
 		pi->phy_5g_pwrgain = true;
 }
 
+static s32 get_rf_pwr_offset(struct brcms_phy *pi, s16 pga_gn, s16 pad_gn)
+{
+	s32 rfpwr_offset = 0;
+
+	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if ((pi->pubpi.radiorev == 3) ||
+		    (pi->pubpi.radiorev == 4) ||
+		    (pi->pubpi.radiorev == 6))
+			rfpwr_offset = (s16)
+				       nphy_papd_padgain_dlt_2g_2057rev3n4
+				       [pad_gn];
+		else if (pi->pubpi.radiorev == 5)
+			rfpwr_offset = (s16)
+				       nphy_papd_padgain_dlt_2g_2057rev5
+				       [pad_gn];
+		else if ((pi->pubpi.radiorev == 7)
+			 || (pi->pubpi.radiorev ==
+			     8))
+			rfpwr_offset = (s16)
+				       nphy_papd_padgain_dlt_2g_2057rev7
+				       [pad_gn];
+	} else {
+		if ((pi->pubpi.radiorev == 3) ||
+		    (pi->pubpi.radiorev == 4) ||
+		    (pi->pubpi.radiorev == 6))
+			rfpwr_offset = (s16)
+				       nphy_papd_pgagain_dlt_5g_2057
+				       [pga_gn];
+		else if ((pi->pubpi.radiorev == 7)
+			 || (pi->pubpi.radiorev ==
+			     8))
+			rfpwr_offset = (s16)
+				       nphy_papd_pgagain_dlt_5g_2057rev7
+				       [pga_gn];
+	}
+	return rfpwr_offset;
+}
+
 void wlc_phy_init_nphy(struct brcms_phy *pi)
 {
 	u16 val;
@@ -14714,7 +14752,7 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 		u16 idx;
 		s16 pga_gn = 0;
 		s16 pad_gn = 0;
-		s32 rfpwr_offset = 0;
+		s32 rfpwr_offset;
 
 		if (PHY_IPA(pi)) {
 			tx_pwrctrl_tbl = wlc_phy_get_ipa_gaintbl_nphy(pi);
@@ -14764,38 +14802,8 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 			for (idx = 0; idx < 128; idx++) {
 				pga_gn = (tx_pwrctrl_tbl[idx] >> 24) & 0xf;
 				pad_gn = (tx_pwrctrl_tbl[idx] >> 19) & 0x1f;
-
-				if (CHSPEC_IS2G(pi->radio_chanspec)) {
-					if ((pi->pubpi.radiorev == 3) ||
-					    (pi->pubpi.radiorev == 4) ||
-					    (pi->pubpi.radiorev == 6))
-						rfpwr_offset = (s16)
-							       nphy_papd_padgain_dlt_2g_2057rev3n4
-							       [pad_gn];
-					else if (pi->pubpi.radiorev == 5)
-						rfpwr_offset = (s16)
-							       nphy_papd_padgain_dlt_2g_2057rev5
-							       [pad_gn];
-					else if ((pi->pubpi.radiorev == 7)
-						 || (pi->pubpi.radiorev ==
-						     8))
-						rfpwr_offset = (s16)
-							       nphy_papd_padgain_dlt_2g_2057rev7
-							       [pad_gn];
-				} else {
-					if ((pi->pubpi.radiorev == 3) ||
-					    (pi->pubpi.radiorev == 4) ||
-					    (pi->pubpi.radiorev == 6))
-						rfpwr_offset = (s16)
-							       nphy_papd_pgagain_dlt_5g_2057
-							       [pga_gn];
-					else if ((pi->pubpi.radiorev == 7)
-						 || (pi->pubpi.radiorev ==
-						     8))
-						rfpwr_offset = (s16)
-							       nphy_papd_pgagain_dlt_5g_2057rev7
-							       [pga_gn];
-				}
+				rfpwr_offset = get_rf_pwr_offset(pi, pga_gn,
+								 pad_gn);
 				wlc_phy_table_write_nphy(
 					pi,
 					NPHY_TBL_ID_CORE1TXPWRCTL,
@@ -20407,6 +20415,45 @@ wlc_phy_scale_offset_rssi_nphy(struct brcms_phy *pi, u16 scale, s8 offset,
 		write_phy_reg(pi, 0x1bb, valuetostuff);
 }
 
+static void brcms_phy_wr_tx_mux(struct brcms_phy *pi, u8 core)
+{
+	if (PHY_IPA(pi)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
+			write_radio_reg(pi,
+					((core == PHY_CORE_0) ?
+					 RADIO_2057_TX0_TX_SSI_MUX :
+					 RADIO_2057_TX1_TX_SSI_MUX),
+					(CHSPEC_IS5G(pi->radio_chanspec) ?
+					0xc : 0xe));
+		else
+			write_radio_reg(pi,
+					RADIO_2056_TX_TX_SSI_MUX |
+					((core == PHY_CORE_0) ?
+					 RADIO_2056_TX0 : RADIO_2056_TX1),
+					(CHSPEC_IS5G(pi->radio_chanspec) ?
+					0xc : 0xe));
+	} else {
+		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			write_radio_reg(pi,
+					((core == PHY_CORE_0) ?
+					 RADIO_2057_TX0_TX_SSI_MUX :
+					 RADIO_2057_TX1_TX_SSI_MUX),
+					0x11);
+
+			if (pi->pubpi.radioid == BCM2057_ID)
+				write_radio_reg(pi,
+						RADIO_2057_IQTEST_SEL_PU, 0x1);
+
+		} else {
+			write_radio_reg(pi,
+					RADIO_2056_TX_TX_SSI_MUX |
+					((core == PHY_CORE_0) ?
+					 RADIO_2056_TX0 : RADIO_2056_TX1),
+					0x11);
+		}
+	}
+}
+
 void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 {
 	u16 mask, val;
@@ -20529,103 +20576,13 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 							    (core ==
 							     PHY_CORE_0) ? 0xa6
 							    : 0xa7, mask, val);
-
-						if (PHY_IPA(pi)) {
-							if (NREV_GE
-								    (pi->pubpi.
-								    phy_rev,
-								    7))
-								write_radio_reg
-									(pi,
-									((core
-									  ==
-									  PHY_CORE_0)
-									 ?
-									 RADIO_2057_TX0_TX_SSI_MUX
-									 :
-									 RADIO_2057_TX1_TX_SSI_MUX),
-									(
-										CHSPEC_IS5G
-										(
-											pi
-											->
-											radio_chanspec)
-										?
-										0xc
-										:
-										0xe));
-							else
-								write_radio_reg
-								(
-									pi,
-									RADIO_2056_TX_TX_SSI_MUX
-									|
-									((core
-									  ==
-									  PHY_CORE_0)
-									 ?
-									 RADIO_2056_TX0
-									 :
-									 RADIO_2056_TX1),
-									(
-										CHSPEC_IS5G
-										(
-											pi
-											->
-											radio_chanspec)
-										?
-										0xc
-										:
-										0xe));
-						} else {
-
-							if (NREV_GE
-								    (pi->pubpi.
-								    phy_rev,
-								    7)) {
-								write_radio_reg
-									(pi,
-									((core
-									  ==
-									  PHY_CORE_0)
-									 ?
-									 RADIO_2057_TX0_TX_SSI_MUX
-									 :
-									 RADIO_2057_TX1_TX_SSI_MUX),
-									0x11);
-
-								if (pi->pubpi.
-								    radioid ==
-								    BCM2057_ID)
-									write_radio_reg
-									(
-										pi,
-										RADIO_2057_IQTEST_SEL_PU,
-										0x1);
-
-							} else {
-								write_radio_reg
-								(
-									pi,
-									RADIO_2056_TX_TX_SSI_MUX
-									|
-									((core
-									  ==
-									  PHY_CORE_0)
-									 ?
-									 RADIO_2056_TX0
-									 :
-									 RADIO_2056_TX1),
-									0x11);
-							}
-						}
-
+						brcms_phy_wr_tx_mux(pi, core);
 						afectrlovr_rssi_val = 1 << 9;
 						mod_phy_reg(pi,
-							    (core ==
-							     PHY_CORE_0) ? 0x8f
-							    : 0xa5, (0x1 << 9),
-							    afectrlovr_rssi_val);
+							   (core ==
+							    PHY_CORE_0) ? 0x8f
+							   : 0xa5, (0x1 << 9),
+							   afectrlovr_rssi_val);
 					}
 				}
 			}
@@ -22441,6 +22398,47 @@ void wlc_phy_stopplayback_nphy(struct brcms_phy *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 }
 
+static u32 *brcms_phy_get_tx_pwrctrl_tbl(struct brcms_phy *pi)
+{
+	u32 *tx_pwrctrl_tbl = NULL;
+	uint phyrev = pi->pubpi.phy_rev;
+
+	if (PHY_IPA(pi)) {
+		tx_pwrctrl_tbl =
+			wlc_phy_get_ipa_gaintbl_nphy(pi);
+	} else {
+		if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			if (NREV_IS(phyrev, 3))
+				tx_pwrctrl_tbl = nphy_tpc_5GHz_txgain_rev3;
+			else if (NREV_IS(phyrev, 4))
+				tx_pwrctrl_tbl =
+					(pi->srom_fem5g.extpagain == 3) ?
+					nphy_tpc_5GHz_txgain_HiPwrEPA :
+					nphy_tpc_5GHz_txgain_rev4;
+			else
+				tx_pwrctrl_tbl = nphy_tpc_5GHz_txgain_rev5;
+		} else {
+			if (NREV_GE(phyrev, 7)) {
+				if (pi->pubpi.radiorev == 3)
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_epa_2057rev3;
+				else if (pi->pubpi.radiorev == 5)
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_epa_2057rev5;
+			} else {
+				if (NREV_GE(phyrev, 5) &&
+				   (pi->srom_fem2g.extpagain ==	3))
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_HiPwrEPA;
+				else
+					tx_pwrctrl_tbl =
+						nphy_tpc_txgain_rev3;
+			}
+		}
+	}
+	return tx_pwrctrl_tbl;
+}
+
 struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 {
 	u16 base_idx[2], curr_gain[2];
@@ -22497,54 +22495,8 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 		base_idx[1] = (read_phy_reg(pi, 0x1ee) >> 8) & 0x7f;
 		for (core_no = 0; core_no < 2; core_no++) {
 			if (NREV_GE(phyrev, 3)) {
-				if (PHY_IPA(pi)) {
-					tx_pwrctrl_tbl =
-						wlc_phy_get_ipa_gaintbl_nphy(pi);
-				} else {
-					if (CHSPEC_IS5G(pi->radio_chanspec)) {
-						if (NREV_IS(phyrev, 3))
-							tx_pwrctrl_tbl =
-								nphy_tpc_5GHz_txgain_rev3;
-						else if (NREV_IS(phyrev, 4))
-							tx_pwrctrl_tbl =
-								(pi->srom_fem5g
-								 .
-								 extpagain ==
-								 3) ?
-								nphy_tpc_5GHz_txgain_HiPwrEPA
-								:
-								nphy_tpc_5GHz_txgain_rev4;
-						else
-							tx_pwrctrl_tbl =
-								nphy_tpc_5GHz_txgain_rev5;
-					} else {
-						if (NREV_GE(phyrev, 7)) {
-							if (pi->pubpi.
-							    radiorev == 3)
-								tx_pwrctrl_tbl
-									=
-										nphy_tpc_txgain_epa_2057rev3;
-							else if (pi->pubpi.
-								 radiorev ==
-								 5)
-								tx_pwrctrl_tbl
-									=
-										nphy_tpc_txgain_epa_2057rev5;
-						} else {
-							if (NREV_GE(phyrev, 5)
-							    && (pi->srom_fem2g.
-								extpagain ==
-								3))
-								tx_pwrctrl_tbl
-									=
-										nphy_tpc_txgain_HiPwrEPA;
-							else
-								tx_pwrctrl_tbl
-									=
-										nphy_tpc_txgain_rev3;
-						}
-					}
-				}
+				tx_pwrctrl_tbl =
+					brcms_phy_get_tx_pwrctrl_tbl(pi);
 				if (NREV_GE(phyrev, 7)) {
 					target_gain.ipa[core_no] =
 						(tx_pwrctrl_tbl
-- 
1.7.4.1


