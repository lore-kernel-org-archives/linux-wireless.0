Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:38243 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753740AbZHJA2B (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Aug 2009 20:28:01 -0400
Date: Mon, 10 Aug 2009 03:27:59 +0300
From: Nick Kossifidis <mick@madwifi-project.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, jirislaby@gmail.com, me@bobcopeland.com,
	mcgrof@gmail.com, nbd@openwrt.org
Subject: [PATCH 2/5] ath5k: Linear PCDAC code fixes
Message-ID: <20090810002759.GB7079@makis>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Set correct xpd curve indices for high/low gain curves during
   rfbuffer setup on RF5112B with both calibration curves available.

 * Don't return zero min power when we have the same pcdac value
   twice because it breaks interpolation. Instead return the right
   x barrier as we do when we have equal power levels for 2 different
   pcdac values.

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
 Acked-by: Bob Copeland <me@bobcopeland.com>

---
 drivers/net/wireless/ath/ath5k/phy.c |   24 +++++++++++++++++-------
 1 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 2075ba9..6afba98 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -740,13 +740,22 @@ int ath5k_hw_rfregs_init(struct ath5k_hw *ah, struct ieee80211_channel *channel,
 						AR5K_RF_XPD_GAIN, true);
 
 		} else {
-			/* TODO: Set high and low gain bits */
-			ath5k_hw_rfb_op(ah, rf_regs,
-						ee->ee_x_gain[ee_mode],
+			u8 *pdg_curve_to_idx = ee->ee_pdc_to_idx[ee_mode];
+			if (ee->ee_pd_gains[ee_mode] > 1) {
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[0],
 						AR5K_RF_PD_GAIN_LO, true);
-			ath5k_hw_rfb_op(ah, rf_regs,
-						ee->ee_x_gain[ee_mode],
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[1],
 						AR5K_RF_PD_GAIN_HI, true);
+			} else {
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[0],
+						AR5K_RF_PD_GAIN_LO, true);
+				ath5k_hw_rfb_op(ah, rf_regs,
+						pdg_curve_to_idx[0],
+						AR5K_RF_PD_GAIN_HI, true);
+			}
 
 			/* Lower synth voltage on Rev 2 */
 			ath5k_hw_rfb_op(ah, rf_regs, 2,
@@ -1896,8 +1905,9 @@ ath5k_get_linear_pcdac_min(const u8 *stepL, const u8 *stepR,
 	s16 min_pwrL, min_pwrR;
 	s16 pwr_i;
 
-	if (WARN_ON(stepL[0] == stepL[1] || stepR[0] == stepR[1]))
-		return 0;
+	/* Some vendors write the same pcdac value twice !!! */
+	if (stepL[0] == stepL[1] || stepR[0] == stepR[1])
+		return max(pwrL[0], pwrR[0]);
 
 	if (pwrL[0] == pwrL[1])
 		min_pwrL = pwrL[0];
