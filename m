Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52407 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758448Ab2CFKGq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Mar 2012 05:06:46 -0500
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, mickflemm@gmail.com
Subject: [PATCH 2/2] ath5k: do not re-run AGC calibration periodically
Date: Tue,  6 Mar 2012 11:06:38 +0100
Message-Id: <1331028398-27417-2-git-send-email-nbd@openwrt.org> (sfid-20120306_110650_623356_6506746F)
In-Reply-To: <1331028398-27417-1-git-send-email-nbd@openwrt.org>
References: <1331028398-27417-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

All other Atheros drivers run the AGC gain calibration and DC offset
calibration only after reset. Running them periodically has caused stability
issues on some (primarily AR2315/2413/5413/5414 based) devices, leading to
messages such as:

ath5k phy0: gain calibration timeout (2462MHz)
ath5k phy0: calibration of channel 11 failed

Related bug reports:
https://dev.openwrt.org/ticket/10574
https://bugzilla.redhat.com/show_bug.cgi?id=795141

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Nick Kossifidis <mickflemm@gmail.com>
---
 drivers/net/wireless/ath/ath5k/phy.c |   34 +++++++++-------------------------
 1 files changed, 9 insertions(+), 25 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index e1f8613..3a28454 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1871,31 +1871,15 @@ ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 		ret = 0;
 	}
 
-	/* On full calibration do an AGC calibration and
-	 * request a PAPD probe for gainf calibration if
-	 * needed */
-	if (ah->ah_cal_mask & AR5K_CALIBRATION_FULL) {
-
-		AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_AGCCTL,
-					AR5K_PHY_AGCCTL_CAL);
-
-		ret = ath5k_hw_register_timeout(ah, AR5K_PHY_AGCCTL,
-			AR5K_PHY_AGCCTL_CAL | AR5K_PHY_AGCCTL_NF,
-			0, false);
-		if (ret) {
-			ATH5K_ERR(ah,
-				"gain calibration timeout (%uMHz)\n",
-				channel->center_freq);
-		}
-
-		if ((ah->ah_radio == AR5K_RF5111 ||
-			ah->ah_radio == AR5K_RF5112)
-			&& (channel->hw_value != AR5K_MODE_11B))
-			ath5k_hw_request_rfgain_probe(ah);
-	}
-
-	/* Update noise floor
-	 * XXX: Only do this after AGC calibration */
+	/* On full calibration request a PAPD probe for
+	 * gainf calibration if needed */
+	if ((ah->ah_cal_mask & AR5K_CALIBRATION_FULL) &&
+	    (ah->ah_radio == AR5K_RF5111 ||
+	     ah->ah_radio == AR5K_RF5112) &&
+	    channel->hw_value != AR5K_MODE_11B)
+		ath5k_hw_request_rfgain_probe(ah);
+
+	/* Update noise floor */
 	if (!(ah->ah_cal_mask & AR5K_CALIBRATION_NF))
 		ath5k_hw_update_noise_floor(ah);
 
-- 
1.7.3.2

