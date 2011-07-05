Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2950 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753791Ab1GEWDP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2011 18:03:15 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 18/31] staging: brcm80211: remove checkpatch warnings
 from phy_n.c
Date: Wed, 6 Jul 2011 00:02:45 +0200
Message-ID: <1309903378-29021-19-git-send-email-arend@broadcom.com> (sfid-20110706_000322_996789_AAE279C5)
In-Reply-To: <1309903378-29021-1-git-send-email-arend@broadcom.com>
References: <1309903378-29021-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The source file phy_n.c had couple of checkpatch warnings that
have been fixed in this patch.

Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c |   51 ++++++++++-------------
 1 files changed, 22 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index 151dc3c..2a8c9ff 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -14705,12 +14705,10 @@ void WLBANDINITFN(wlc_phy_init_nphy) (struct brcms_phy *pi)
 			tx_pwrctrl_tbl = wlc_phy_get_ipa_gaintbl_nphy(pi);
 		} else {
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if NREV_IS
-					(pi->pubpi.phy_rev, 3) {
+				if (NREV_IS(pi->pubpi.phy_rev, 3)) {
 					tx_pwrctrl_tbl =
 					    nphy_tpc_5GHz_txgain_rev3;
-				} else if NREV_IS
-					(pi->pubpi.phy_rev, 4) {
+				} else if (NREV_IS(pi->pubpi.phy_rev, 4)) {
 					tx_pwrctrl_tbl =
 					    (pi->srom_fem5g.extpagain == 3) ?
 					    nphy_tpc_5GHz_txgain_HiPwrEPA :
@@ -22515,21 +22513,21 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 			}
 		}
 	} else {
+		uint phyrev = pi->pubpi.phy_rev;
+
 		base_idx[0] = (read_phy_reg(pi, 0x1ed) >> 8) & 0x7f;
 		base_idx[1] = (read_phy_reg(pi, 0x1ee) >> 8) & 0x7f;
 		for (core_no = 0; core_no < 2; core_no++) {
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			if (NREV_GE(phyrev, 3)) {
 				if (PHY_IPA(pi)) {
 					tx_pwrctrl_tbl =
 					    wlc_phy_get_ipa_gaintbl_nphy(pi);
 				} else {
 					if (CHSPEC_IS5G(pi->radio_chanspec)) {
-						if NREV_IS
-							(pi->pubpi.phy_rev, 3) {
+						if (NREV_IS(phyrev, 3)) {
 							tx_pwrctrl_tbl =
 							    nphy_tpc_5GHz_txgain_rev3;
-						} else if NREV_IS
-							(pi->pubpi.phy_rev, 4) {
+						} else if (NREV_IS(phyrev, 4)) {
 							tx_pwrctrl_tbl =
 							    (pi->srom_fem5g.
 							     extpagain ==
@@ -22542,8 +22540,7 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 							    nphy_tpc_5GHz_txgain_rev5;
 						}
 					} else {
-						if (NREV_GE
-						    (pi->pubpi.phy_rev, 7)) {
+						if (NREV_GE(phyrev, 7)) {
 							if (pi->pubpi.
 							    radiorev == 3) {
 								tx_pwrctrl_tbl =
@@ -22556,9 +22553,7 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 							}
 
 						} else {
-							if (NREV_GE
-							    (pi->pubpi.phy_rev,
-							     5)
+							if (NREV_GE(phyrev, 5)
 							    && (pi->srom_fem2g.
 								extpagain ==
 								3)) {
@@ -22571,8 +22566,7 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 						}
 					}
 				}
-				if NREV_GE
-					(pi->pubpi.phy_rev, 7) {
+				if (NREV_GE(phyrev, 7)) {
 					target_gain.ipa[core_no] =
 					    (tx_pwrctrl_tbl[base_idx[core_no]]
 					     >> 16) & 0x7;
@@ -27449,20 +27443,20 @@ void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 	pi->nphy_txpwrindex[PHY_CORE_1].index_internal_save = txpi[1];
 
 	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		uint phyrev = pi->pubpi.phy_rev;
+
+		if (NREV_GE(phyrev, 3)) {
 			if (PHY_IPA(pi)) {
 				u32 *tx_gaintbl =
 				    wlc_phy_get_ipa_gaintbl_nphy(pi);
 				txgain = tx_gaintbl[txpi[core]];
 			} else {
 				if (CHSPEC_IS5G(pi->radio_chanspec)) {
-					if NREV_IS
-						(pi->pubpi.phy_rev, 3) {
+					if (NREV_IS(phyrev, 3)) {
 						txgain =
 						    nphy_tpc_5GHz_txgain_rev3
 						    [txpi[core]];
-					} else if NREV_IS
-						(pi->pubpi.phy_rev, 4) {
+					} else if (NREV_IS(phyrev, 4)) {
 						txgain =
 						    (pi->srom_fem5g.extpagain ==
 						     3) ?
@@ -27476,7 +27470,7 @@ void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 						    [txpi[core]];
 					}
 				} else {
-					if (NREV_GE(pi->pubpi.phy_rev, 5) &&
+					if (NREV_GE(phyrev, 5) &&
 					    (pi->srom_fem2g.extpagain == 3)) {
 						txgain =
 						    nphy_tpc_txgain_HiPwrEPA
@@ -27492,20 +27486,19 @@ void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 			txgain = nphy_tpc_txgain[txpi[core]];
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (NREV_GE(phyrev, 3))
 			rad_gain = (txgain >> 16) & ((1 << (32 - 16 + 1)) - 1);
-		} else {
+		else
 			rad_gain = (txgain >> 16) & ((1 << (28 - 16 + 1)) - 1);
-		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(phyrev, 7))
 			dac_gain = (txgain >> 8) & ((1 << (10 - 8 + 1)) - 1);
-		} else {
+		else
 			dac_gain = (txgain >> 8) & ((1 << (13 - 8 + 1)) - 1);
-		}
+
 		bbmult = (txgain >> 0) & ((1 << (7 - 0 + 1)) - 1);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (NREV_GE(phyrev, 3)) {
 			mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
 					 0xa5), (0x1 << 8), (0x1 << 8));
 		} else {
-- 
1.7.4.1


