Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43704 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752505Ab0I2PPh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:15:37 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 2/6] ath9k_hw: keep calibrated noise floor values per channel
Date: Wed, 29 Sep 2010 17:15:27 +0200
Message-Id: <1285773331-73439-2-git-send-email-nbd@openwrt.org>
In-Reply-To: <1285773331-73439-1-git-send-email-nbd@openwrt.org>
References: <1285773331-73439-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/calib.c |   40 ++++++++++++++++----------------
 drivers/net/wireless/ath/ath9k/hw.c    |    2 +-
 drivers/net/wireless/ath/ath9k/hw.h    |    2 +-
 3 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index 67ee5d7..6351e76 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -346,34 +346,34 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	struct ieee80211_channel *c = chan->chan;
 	struct ath9k_hw_cal_data *caldata = ah->caldata;
 
-	if (!caldata)
-		return false;
-
 	chan->channelFlags &= (~CHANNEL_CW_INT);
 	if (REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF) {
 		ath_print(common, ATH_DBG_CALIBRATE,
 			  "NF did not complete in calibration window\n");
-		nf = 0;
-		caldata->rawNoiseFloor = nf;
 		return false;
-	} else {
-		ath9k_hw_do_getnf(ah, nfarray);
-		ath9k_hw_nf_sanitize(ah, nfarray);
-		nf = nfarray[0];
-		if (ath9k_hw_get_nf_thresh(ah, c->band, &nfThresh)
-		    && nf > nfThresh) {
-			ath_print(common, ATH_DBG_CALIBRATE,
-				  "noise floor failed detected; "
-				  "detected %d, threshold %d\n",
-				  nf, nfThresh);
-			chan->channelFlags |= CHANNEL_CW_INT;
-		}
+	}
+
+	ath9k_hw_do_getnf(ah, nfarray);
+	ath9k_hw_nf_sanitize(ah, nfarray);
+	nf = nfarray[0];
+	if (ath9k_hw_get_nf_thresh(ah, c->band, &nfThresh)
+	    && nf > nfThresh) {
+		ath_print(common, ATH_DBG_CALIBRATE,
+			  "noise floor failed detected; "
+			  "detected %d, threshold %d\n",
+			  nf, nfThresh);
+		chan->channelFlags |= CHANNEL_CW_INT;
+	}
+
+	if (!caldata) {
+		chan->noisefloor = nf;
+		return false;
 	}
 
 	h = caldata->nfCalHist;
 	caldata->nfcal_pending = false;
 	ath9k_hw_update_nfcal_hist_buffer(ah, caldata, nfarray);
-	caldata->rawNoiseFloor = h[0].privNF;
+	chan->noisefloor = h[0].privNF;
 	return true;
 }
 
@@ -401,10 +401,10 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 
 s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 {
-	if (!ah->caldata || !ah->caldata->rawNoiseFloor)
+	if (!ah->curchan || !ah->curchan->noisefloor)
 		return ath9k_hw_get_default_nf(ah, chan);
 
-	return ah->caldata->rawNoiseFloor;
+	return ah->curchan->noisefloor;
 }
 EXPORT_SYMBOL(ath9k_hw_getchan_noise);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 25ed65a..1b06604 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1239,7 +1239,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	if (!ath9k_hw_setpower(ah, ATH9K_PM_AWAKE))
 		return -EIO;
 
-	if (curchan && !ah->chip_fullsleep && ah->caldata)
+	if (curchan && !ah->chip_fullsleep)
 		ath9k_hw_getnf(ah, curchan);
 
 	ah->caldata = caldata;
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index df47f79..1b6739b 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -342,7 +342,6 @@ struct ath9k_hw_cal_data {
 	int32_t CalValid;
 	int8_t iCoff;
 	int8_t qCoff;
-	int16_t rawNoiseFloor;
 	bool paprd_done;
 	bool nfcal_pending;
 	bool nfcal_interference;
@@ -356,6 +355,7 @@ struct ath9k_channel {
 	u16 channel;
 	u32 channelFlags;
 	u32 chanmode;
+	s16 noisefloor;
 };
 
 #define IS_CHAN_G(_c) ((((_c)->channelFlags & (CHANNEL_G)) == CHANNEL_G) || \
-- 
1.7.2.2

