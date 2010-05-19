Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:11355 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756779Ab0ESBcN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 May 2010 21:32:13 -0400
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0535612731
	for <linux-wireless@vger.kernel.org>; Wed, 19 May 2010 10:32:11 +0900 (JST)
Subject: [PATCH v2 04/20] ath5k: move noise floor calibration into tasklet
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 19 May 2010 10:31:00 +0900
Message-ID: <20100519013100.22206.64528.stgit@tt-desk>
In-Reply-To: <20100519012528.22206.77550.stgit@tt-desk>
References: <20100519012528.22206.77550.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Seperate noise floor calibration from other PHY calibration and move it to the
tasklet. This is the first step to more separation of different calibrations.

Also move out ath5k_hw_request_rfgain_probe(ah) so we have one clean function
for I/Q calibration on 5111x parts.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 +
 drivers/net/wireless/ath/ath5k/base.c  |    1 +
 drivers/net/wireless/ath/ath5k/phy.c   |   33 ++++++++++----------------------
 3 files changed, 12 insertions(+), 23 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 2785946..131e8b3 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1270,6 +1270,7 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah);
 int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 			   struct ieee80211_channel *channel);
+void ath5k_hw_update_noise_floor(struct ath5k_hw *ah);
 /* Spur mitigation */
 bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
 				  struct ieee80211_channel *channel);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index de59a6e..88c7314 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2806,6 +2806,7 @@ ath5k_tasklet_calibrate(unsigned long data)
 			ieee80211_frequency_to_channel(
 				sc->curchan->center_freq));
 
+	ath5k_hw_update_noise_floor(ah);
 	/* Wake queues */
 	ieee80211_wake_queues(sc->hw);
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 3ce9afb..0b24081 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1167,7 +1167,7 @@ static s16 ath5k_hw_get_median_noise_floor(struct ath5k_hw *ah)
  * The median of the values in the history is then loaded into the
  * hardware for its own use for RSSI and CCA measurements.
  */
-static void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
+void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 {
 	struct ath5k_eeprom_info *ee = &ah->ah_capabilities.cap_eeprom;
 	u32 val;
@@ -1248,7 +1248,6 @@ static void ath5k_hw_update_noise_floor(struct ath5k_hw *ah)
 /*
  * Perform a PHY calibration on RF5110
  * -Fix BPSK/QAM Constellation (I/Q correction)
- * -Calculate Noise Floor
  */
 static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 		struct ieee80211_channel *channel)
@@ -1335,8 +1334,6 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 		return ret;
 	}
 
-	ath5k_hw_update_noise_floor(ah);
-
 	/*
 	 * Re-enable RX/TX and beacons
 	 */
@@ -1348,10 +1345,10 @@ static int ath5k_hw_rf5110_calibrate(struct ath5k_hw *ah,
 }
 
 /*
- * Perform a PHY calibration on RF5111/5112 and newer chips
+ * Perform I/Q calibration on RF5111/5112 and newer chips
  */
-static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
-		struct ieee80211_channel *channel)
+static int
+ath5k_hw_rf511x_iq_calibrate(struct ath5k_hw *ah)
 {
 	u32 i_pwr, q_pwr;
 	s32 iq_corr, i_coff, i_coffd, q_coff, q_coffd;
@@ -1360,10 +1357,9 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 
 	if (!ah->ah_calibration ||
 		ath5k_hw_reg_read(ah, AR5K_PHY_IQ) & AR5K_PHY_IQ_RUN)
-		goto done;
+		return 0;
 
 	/* Calibration has finished, get the results and re-run */
-
 	/* work around empty results which can apparently happen on 5212 */
 	for (i = 0; i <= 10; i++) {
 		iq_corr = ath5k_hw_reg_read(ah, AR5K_PHY_IQRES_CAL_CORR);
@@ -1384,7 +1380,7 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 
 	/* protect against divide by 0 and loss of sign bits */
 	if (i_coffd == 0 || q_coffd < 2)
-		goto done;
+		return -1;
 
 	i_coff = (-iq_corr) / i_coffd;
 	i_coff = clamp(i_coff, -32, 31); /* signed 6 bit */
@@ -1410,17 +1406,6 @@ static int ath5k_hw_rf511x_calibrate(struct ath5k_hw *ah,
 			AR5K_PHY_IQ_CAL_NUM_LOG_MAX, 15);
 	AR5K_REG_ENABLE_BITS(ah, AR5K_PHY_IQ, AR5K_PHY_IQ_RUN);
 
-done:
-
-	/* TODO: Separate noise floor calibration from I/Q calibration
-	 * since noise floor calibration interrupts rx path while I/Q
-	 * calibration doesn't. We don't need to run noise floor calibration
-	 * as often as I/Q calibration.*/
-	ath5k_hw_update_noise_floor(ah);
-
-	/* Initiate a gain_F calibration */
-	ath5k_hw_request_rfgain_probe(ah);
-
 	return 0;
 }
 
@@ -1434,8 +1419,10 @@ int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 
 	if (ah->ah_radio == AR5K_RF5110)
 		ret = ath5k_hw_rf5110_calibrate(ah, channel);
-	else
-		ret = ath5k_hw_rf511x_calibrate(ah, channel);
+	else {
+		ret = ath5k_hw_rf511x_iq_calibrate(ah);
+		ath5k_hw_request_rfgain_probe(ah);
+	}
 
 	return ret;
 }

