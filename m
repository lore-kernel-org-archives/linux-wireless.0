Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:33125 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYLTFzt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:49 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 09/16] ath9k: use ieee80211_conf on ath9k_hw_iscal_supported()
Date: Fri, 19 Dec 2008 21:55:15 -0800
Message-ID: <1229752522-1917-10-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065608_697128_6C61EF48)
In-Reply-To: <1229752522-1917-9-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-5-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-6-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-7-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-8-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-9-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath9k_hw_iscal_supported() just needs to be aware of your band
and if HT20 is being used so lets abandon our internal channel
HT appended values and internal mode values and use ieee80211_conf
which already carries this information. This works as calibration
is being done for the currently configured channel.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/ath9k.h |    3 +-
 drivers/net/wireless/ath9k/calib.c |   67 +++++++++++++++++------------------
 drivers/net/wireless/ath9k/main.c  |    3 +-
 3 files changed, 35 insertions(+), 38 deletions(-)

diff --git a/drivers/net/wireless/ath9k/ath9k.h b/drivers/net/wireless/ath9k/ath9k.h
index 8e47802..10c61ed 100644
--- a/drivers/net/wireless/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath9k/ath9k.h
@@ -947,8 +947,7 @@ void ath9k_hw_ani_detach(struct ath_hal *ah);
 
 /* Calibration */
 
-void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
-			     bool *isCalDone);
+bool ath9k_hw_reset_calvalid(struct ath_hal *ah);
 void ath9k_hw_start_nfcal(struct ath_hal *ah);
 void ath9k_hw_loadnf(struct ath_hal *ah, struct ath9k_channel *chan);
 int16_t ath9k_hw_getnf(struct ath_hal *ah,
diff --git a/drivers/net/wireless/ath9k/calib.c b/drivers/net/wireless/ath9k/calib.c
index c72bf10..74369c1 100644
--- a/drivers/net/wireless/ath9k/calib.c
+++ b/drivers/net/wireless/ath9k/calib.c
@@ -277,27 +277,24 @@ static void ath9k_hw_per_calibration(struct ath_hal *ah,
 	}
 }
 
+/* Assumes you are talking about the currently configured channel */
 static bool ath9k_hw_iscal_supported(struct ath_hal *ah,
-				     struct ath9k_channel *chan,
 				     enum hal_cal_types calType)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	bool retval = false;
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
 
 	switch (calType & ahp->ah_suppCals) {
-	case IQ_MISMATCH_CAL:
-		if (!IS_CHAN_B(chan))
-			retval = true;
-		break;
+	case IQ_MISMATCH_CAL: /* Both 2 GHz and 5 GHz support OFDM */
+		return true;
 	case ADC_GAIN_CAL:
 	case ADC_DC_CAL:
-		if (!IS_CHAN_B(chan)
-		    && !(IS_CHAN_2GHZ(chan) && IS_CHAN_HT20(chan)))
-			retval = true;
+		if (conf->channel->band == IEEE80211_BAND_5GHZ &&
+		  conf_is_ht20(conf))
+			return true;
 		break;
 	}
-
-	return retval;
+	return false;
 }
 
 static void ath9k_hw_iqcal_collect(struct ath_hal *ah)
@@ -565,50 +562,52 @@ static void ath9k_hw_adc_dccal_calibrate(struct ath_hal *ah, u8 numChains)
 		  AR_PHY_NEW_ADC_DC_OFFSET_CORR_ENABLE);
 }
 
-void ath9k_hw_reset_calvalid(struct ath_hal *ah, struct ath9k_channel *chan,
-			     bool *isCalDone)
+/* This is done for the currently configured channel */
+bool ath9k_hw_reset_calvalid(struct ath_hal *ah)
 {
 	struct ath_hal_5416 *ahp = AH5416(ah);
-	struct ath9k_channel *ichan =
-		ath9k_regd_check_channel(ah, chan);
+	struct ieee80211_conf *conf = &ah->ah_sc->hw->conf;
+	struct ath9k_channel *chan;
+	struct ath9k_channel *ichan;
 	struct hal_cal_list *currCal = ahp->ah_cal_list_curr;
 
-	*isCalDone = true;
+	if (!conf->channel->priv)
+		return true;
+
+	chan = (struct ath9k_channel *) conf->channel->priv;
+	ichan = ath9k_regd_check_channel(ah, chan);
 
 	if (!AR_SREV_9100(ah) && !AR_SREV_9160_10_OR_LATER(ah))
-		return;
+		return true;
 
 	if (currCal == NULL)
-		return;
+		return true;
 
-	if (ichan == NULL) {
+	if (!ichan) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-			"invalid channel %u/0x%x; no mapping\n",
-			chan->channel, chan->channelFlags);
-		return;
+			"invalid channel %u; no mapping\n",
+			conf->channel->center_freq);
+		return true;
 	}
 
-
 	if (currCal->calState != CAL_DONE) {
 		DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 			"Calibration state incorrect, %d\n",
 			currCal->calState);
-		return;
+		return true;
 	}
 
-
-	if (!ath9k_hw_iscal_supported(ah, chan, currCal->calData->calType))
-		return;
+	if (!ath9k_hw_iscal_supported(ah, currCal->calData->calType))
+		return true;
 
 	DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
-		"Resetting Cal %d state for channel %u/0x%x\n",
-		currCal->calData->calType, chan->channel,
-		chan->channelFlags);
+		"Resetting Cal %d state for channel %u\n",
+		currCal->calData->calType, conf->channel->center_freq);
 
 	ichan->CalValid &= ~currCal->calData->calType;
 	currCal->calState = CAL_WAITING;
 
-	*isCalDone = false;
+	return false;
 }
 
 void ath9k_hw_start_nfcal(struct ath_hal *ah)
@@ -933,19 +932,19 @@ bool ath9k_hw_init_cal(struct ath_hal *ah,
 	ahp->ah_cal_list = ahp->ah_cal_list_last = ahp->ah_cal_list_curr = NULL;
 
 	if (AR_SREV_9100(ah) || AR_SREV_9160_10_OR_LATER(ah)) {
-		if (ath9k_hw_iscal_supported(ah, chan, ADC_GAIN_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, ADC_GAIN_CAL)) {
 			INIT_CAL(&ahp->ah_adcGainCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcGainCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling ADC Gain Calibration.\n");
 		}
-		if (ath9k_hw_iscal_supported(ah, chan, ADC_DC_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, ADC_DC_CAL)) {
 			INIT_CAL(&ahp->ah_adcDcCalData);
 			INSERT_CAL(ahp, &ahp->ah_adcDcCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
 				"enabling ADC DC Calibration.\n");
 		}
-		if (ath9k_hw_iscal_supported(ah, chan, IQ_MISMATCH_CAL)) {
+		if (ath9k_hw_iscal_supported(ah, IQ_MISMATCH_CAL)) {
 			INIT_CAL(&ahp->ah_iqCalData);
 			INSERT_CAL(ahp, &ahp->ah_iqCalData);
 			DPRINTF(ah->ah_sc, ATH_DBG_CALIBRATE,
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 0d47936..54c6d60 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -376,8 +376,7 @@ static void ath_ani_calibrate(unsigned long data)
 	} else {
 		if ((timestamp - sc->sc_ani.sc_resetcal_timer) >=
 		    ATH_RESTART_CALINTERVAL) {
-			ath9k_hw_reset_calvalid(ah, ah->ah_curchan,
-						&sc->sc_ani.sc_caldone);
+			sc->sc_ani.sc_caldone = ath9k_hw_reset_calvalid(ah);
 			if (sc->sc_ani.sc_caldone)
 				sc->sc_ani.sc_resetcal_timer = timestamp;
 		}
-- 
1.5.6.rc2.15.g457bb.dirty

