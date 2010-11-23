Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44375 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab0KWTd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Nov 2010 14:33:59 -0500
Received: by ewy5 with SMTP id 5so2675108ewy.19
        for <linux-wireless@vger.kernel.org>; Tue, 23 Nov 2010 11:33:58 -0800 (PST)
Date: Tue, 23 Nov 2010 21:33:22 +0200
From: Nick Kossifidis <mickflemm@gmail.com>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, me@bobcopeland.com, mcgrof@gmail.com,
	jirislaby@gmail.com, nbd@openwrt.org, br1@einfach.org
Subject: [PATCH 21/30] ath5k: Update PLL programming for turbo/half/quarter
Message-ID: <20101123193322.GU4303@makis.mantri>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

 * Set correct PLL settings for each bwmode

 Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/reset.c |   28 +++++++++++++++++++++++-----
 1 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/reset.c b/drivers/net/wireless/ath/ath5k/reset.c
index ee605cd..ef57bce 100644
--- a/drivers/net/wireless/ath/ath5k/reset.c
+++ b/drivers/net/wireless/ath/ath5k/reset.c
@@ -500,7 +500,6 @@ int ath5k_hw_on_hold(struct ath5k_hw *ah)
 
 /*
  * Bring up MAC + PHY Chips and program PLL
- * TODO: Half/Quarter rate support
  */
 int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 {
@@ -588,7 +587,8 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 				 * CCK headers) operation. We need to test
 				 * this, 5211 might support ofdm-only g after
 				 * all, there are also initial register values
-				 * in the code for g mode (see initvals.c). */
+				 * in the code for g mode (see initvals.c).
+				 */
 				if (ah->ah_version == AR5K_AR5211)
 					mode |= AR5K_PHY_MODE_MOD_OFDM;
 				else
@@ -601,6 +601,7 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 		} else if (flags & CHANNEL_5GHZ) {
 			mode |= AR5K_PHY_MODE_FREQ_5GHZ;
 
+			/* Different PLL setting for 5413 */
 			if (ah->ah_radio == AR5K_RF5413)
 				clock = AR5K_PHY_PLL_40MHZ_5413;
 			else
@@ -618,12 +619,29 @@ int ath5k_hw_nic_wakeup(struct ath5k_hw *ah, int flags, bool initial)
 			return -EINVAL;
 		}
 
-		if (flags & CHANNEL_TURBO)
-			turbo = AR5K_PHY_TURBO_MODE | AR5K_PHY_TURBO_SHORT;
+		/*XXX: Can bwmode be used with dynamic mode ?
+		 * (I don't think it supports 44MHz) */
+		/* On 2425 initvals TURBO_SHORT is not pressent */
+		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ) {
+			turbo = AR5K_PHY_TURBO_MODE |
+				(ah->ah_radio == AR5K_RF2425) ? 0 :
+				AR5K_PHY_TURBO_SHORT;
+		} else if (ah->ah_bwmode != AR5K_BWMODE_DEFAULT) {
+			if (ah->ah_radio == AR5K_RF5413) {
+				mode |= (ah->ah_bwmode == AR5K_BWMODE_10MHZ) ?
+					AR5K_PHY_MODE_HALF_RATE :
+					AR5K_PHY_MODE_QUARTER_RATE;
+			} else if (ah->ah_version == AR5K_AR5212) {
+				clock |= (ah->ah_bwmode == AR5K_BWMODE_10MHZ) ?
+					AR5K_PHY_PLL_HALF_RATE :
+					AR5K_PHY_PLL_QUARTER_RATE;
+			}
+		}
+
 	} else { /* Reset the device */
 
 		/* ...enable Atheros turbo mode if requested */
-		if (flags & CHANNEL_TURBO)
+		if (ah->ah_bwmode == AR5K_BWMODE_40MHZ)
 			ath5k_hw_reg_write(ah, AR5K_PHY_TURBO_MODE,
 					AR5K_PHY_TURBO);
 	}
