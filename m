Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:42564 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab1G1MJK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 28 Jul 2011 08:09:10 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 1/2] ath9k_hw: calculate a much better approximation of channel noise
Date: Thu, 28 Jul 2011 14:08:56 +0200
Message-Id: <1311854937-9411-1-git-send-email-nbd@openwrt.org> (sfid-20110728_140914_307647_9E4511DB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Currently ath9k presents the internal calibrated noise floor as channel
noise measurement, however this results in highly chip specific values
that are only useful as relative measurements but do not resemble any
real channel noise values.

In order to give a much better approximation of the real channel noise,
add the difference between the measured noise floor and the nominal
chip specific noise floor to the default minimum channel noise value,
which is currently used to calculate the signal strength from the RSSI
value. This may not be 100% accurate, but it's much better than what's
there before.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/calib.c |   15 +++++++++++++++
 drivers/net/wireless/ath/ath9k/calib.h |    1 +
 drivers/net/wireless/ath/ath9k/hw.c    |    1 +
 drivers/net/wireless/ath/ath9k/hw.h    |    1 +
 4 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index a1250c5..ac2da3c 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -63,6 +63,19 @@ static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
 	return ath9k_hw_get_nf_limits(ah, chan)->nominal;
 }
 
+s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
+{
+	s8 noise = ATH_DEFAULT_NOISE_FLOOR;
+
+	if (chan && chan->noisefloor) {
+		s8 delta = chan->noisefloor -
+			   ath9k_hw_get_default_nf(ah, chan);
+		if (delta > 0)
+			noise += delta;
+	}
+	return noise;
+}
+EXPORT_SYMBOL(ath9k_hw_getchan_noise);
 
 static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 					      struct ath9k_hw_cal_data *cal,
@@ -378,6 +391,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	if (!caldata) {
 		chan->noisefloor = nf;
+		ah->noise = ath9k_hw_getchan_noise(ah, chan);
 		return false;
 	}
 
@@ -385,6 +399,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 	caldata->nfcal_pending = false;
 	ath9k_hw_update_nfcal_hist_buffer(ah, caldata, nfarray);
 	chan->noisefloor = h[0].privNF;
+	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 	return true;
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 1bef41d..05b9dbf 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -108,6 +108,7 @@ void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 void ath9k_hw_bstuck_nfcal(struct ath_hw *ah);
 void ath9k_hw_reset_calibration(struct ath_hw *ah,
 				struct ath9k_cal_list *currCal);
+s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
 
 
 #endif /* CALIB_H */
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index a2e5763..fd1644e 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -1479,6 +1479,7 @@ int ath9k_hw_reset(struct ath_hw *ah, struct ath9k_channel *chan,
 		memset(caldata, 0, sizeof(*caldata));
 		ath9k_init_nfcal_hist_buffer(ah, chan);
 	}
+	ah->noise = ath9k_hw_getchan_noise(ah, chan);
 
 	if (bChannelChange &&
 	    (ah->chip_fullsleep != true) &&
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 6acd0f9..b9916f4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -690,6 +690,7 @@ struct ath_hw {
 	enum nl80211_iftype opmode;
 	enum ath9k_power_mode power_mode;
 
+	s8 noise;
 	struct ath9k_hw_cal_data *caldata;
 	struct ath9k_pacal_info pacal_info;
 	struct ar5416Stats stats;
-- 
1.7.3.2

