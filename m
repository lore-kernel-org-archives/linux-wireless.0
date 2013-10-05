Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f42.google.com ([74.125.83.42]:58986 "EHLO
	mail-ee0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536Ab3JEVQP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 5 Oct 2013 17:16:15 -0400
Received: by mail-ee0-f42.google.com with SMTP id b45so2500906eek.1
        for <linux-wireless@vger.kernel.org>; Sat, 05 Oct 2013 14:16:14 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, mcgrof@qca.qualcomm.com,
	simon.wunderlich@s2003.tu-chemnitz.de
Subject: [PATCH 1/2] ath9k: add noise floor parameter to ath9k_hw_getchan_noise
Date: Sat,  5 Oct 2013 23:16:08 +0200
Message-Id: <1381007769-11800-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20131005_231619_565998_96596CC2)
In-Reply-To: <1381007769-11800-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1381007769-11800-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add nf parameter to ath9k_hw_getchan_noise() in order to compute NF for EXT
chains with the same scale of noise floor calculated on CTL chains.
ath9k_hw_getchan_noise() will be used in ath_process_fft() for spectral scan on
HT40 channels

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 drivers/net/wireless/ath/ath9k/calib.c | 10 +++++-----
 drivers/net/wireless/ath/ath9k/calib.h |  3 ++-
 drivers/net/wireless/ath/ath9k/hw.c    |  2 +-
 drivers/net/wireless/ath/ath9k/link.c  |  3 ++-
 4 files changed, 10 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index d438a03..698d91a 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -63,13 +63,13 @@ static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
 	return ath9k_hw_get_nf_limits(ah, chan)->nominal;
 }
 
-s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
+s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan,
+			   s16 nf)
 {
 	s8 noise = ATH_DEFAULT_NOISE_FLOOR;
 
-	if (chan && chan->noisefloor) {
-		s8 delta = chan->noisefloor -
-			   ATH9K_NF_CAL_NOISE_THRESH -
+	if (nf) {
+		s8 delta = nf - ATH9K_NF_CAL_NOISE_THRESH -
 			   ath9k_hw_get_default_nf(ah, chan);
 		if (delta > 0)
 			noise += delta;
@@ -394,7 +394,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	clear_bit(NFCAL_PENDING, &caldata->cal_flags);
 	ath9k_hw_update_nfcal_hist_buffer(ah, caldata, nfarray);
 	chan->noisefloor = h[0].privNF;
-	ah->noise = ath9k_hw_getchan_noise(ah, chan);
+	ah->noise = ath9k_hw_getchan_noise(ah, chan, chan->noisefloor);
 	return true;
 }
 EXPORT_SYMBOL(ath9k_hw_getnf);
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 3d70b8c..b8ed95e 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -116,7 +116,8 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 void ath9k_hw_bstuck_nfcal(struct ath_hw *ah);
 void ath9k_hw_reset_calibration(struct ath_hw *ah,
 				struct ath9k_cal_list *currCal);
-s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
+s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan,
+			   s16 nf);
 
 
 #endif /* CALIB_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index f11e838..79b766f 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1907,7 +1907,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 	} else if (caldata) {
 		clear_bit(PAPRD_PACKET_SENT, &caldata->cal_flags);
 	}
-	ah->noise = ath9k_hw_getchan_noise(ah, chan);
+	ah->noise = ath9k_hw_getchan_noise(ah, chan, chan->noisefloor);
 
 	if (fastcc) {
 		r = ath9k_hw_do_fastcc(ah, chan);
diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index 84a6064..b797519 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -518,7 +518,8 @@ void ath_update_survey_nf(struct ath_softc *sc, int channel)
 
 	if (chan->noisefloor) {
 		survey->filled |= SURVEY_INFO_NOISE_DBM;
-		survey->noise = ath9k_hw_getchan_noise(ah, chan);
+		survey->noise = ath9k_hw_getchan_noise(ah, chan,
+						       chan->noisefloor);
 	}
 }
 
-- 
1.8.1.2

