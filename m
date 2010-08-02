Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:48360 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753330Ab0HBNxW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 09:53:22 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/4] ath9k: use AP beacon miss as a trigger for fast recalibration
Date: Mon,  2 Aug 2010 15:53:14 +0200
Message-Id: <1280757195-9532-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1280757195-9532-2-git-send-email-nbd@openwrt.org>
References: <1280757195-9532-1-git-send-email-nbd@openwrt.org>
 <1280757195-9532-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When beacons get stuck in AP mode, the most likely cause is interference.
Such interference can often go on for a while, and too many consecutive
beacon misses can lead to connected clients getting dropped.

Since connected clients might not be subjected to the same interference
if that happens to be very local, the AP should try to deal with it as
good as it can. One way to do this is to trigger an NF calibration with
automatic baseband update right after the beacon miss. In my tests with
very strong interference, this allowed the AP to continue transmitting
beacons after only 2-3 misses, which allows a normal client to stay
connected.

With some of the newer - really sensitive - chips, the maximum noise
floor limit is very low, which can be problematic during very strong
interference. To avoid an endless loop of stuck beacons -> nfcal ->
periodic calibration -> stuck beacons, the beacon miss event also sets
a flag, which allows the calibration code to bypass the chip specific
maximum NF value. This flag is automatically cleared, as soon as the
first NF median goes back below the limits for all chains.

In my tests, this allowed an ath9k AP to survive very strong interference
(measured NF: -68, or sometimes even higher) without losing connectivity
to its clients. Even under these conditions, I was able to transmit
several mbits/s through the interface.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    1 +
 drivers/net/wireless/ath/ath9k/calib.c  |   66 +++++++++++++++++++++++++++++--
 drivers/net/wireless/ath/ath9k/calib.h  |    1 +
 drivers/net/wireless/ath/ath9k/hw.h     |    1 +
 4 files changed, 65 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 102f123..081192e 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -362,6 +362,7 @@ void ath_beacon_tasklet(unsigned long data)
 			ath_print(common, ATH_DBG_BSTUCK,
 				  "missed %u consecutive beacons\n",
 				  sc->beacon.bmisscnt);
+			ath9k_hw_bstuck_nfcal(ah);
 		} else if (sc->beacon.bmisscnt >= BSTUCK_THRESH) {
 			ath_print(common, ATH_DBG_BSTUCK,
 				  "beacon is officially stuck\n");
diff --git a/drivers/net/wireless/ath/ath9k/calib.c b/drivers/net/wireless/ath/ath9k/calib.c
index ccb1b2e..67ee5d7 100644
--- a/drivers/net/wireless/ath/ath9k/calib.c
+++ b/drivers/net/wireless/ath/ath9k/calib.c
@@ -65,12 +65,16 @@ static s16 ath9k_hw_get_default_nf(struct ath_hw *ah,
 
 
 static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
-					      struct ath9k_nfcal_hist *h,
+					      struct ath9k_hw_cal_data *cal,
 					      int16_t *nfarray)
 {
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ath_nf_limits *limit;
+	struct ath9k_nfcal_hist *h;
+	bool high_nf_mid = false;
 	int i;
 
+	h = cal->nfCalHist;
 	limit = ath9k_hw_get_nf_limits(ah, ah->curchan);
 
 	for (i = 0; i < NUM_NF_READINGS; i++) {
@@ -87,9 +91,38 @@ static void ath9k_hw_update_nfcal_hist_buffer(struct ath_hw *ah,
 				ath9k_hw_get_nf_hist_mid(h[i].nfCalBuffer);
 		}
 
-		if (h[i].privNF > limit->max)
-			h[i].privNF = limit->max;
+		if (!h[i].privNF)
+			continue;
+
+		if (h[i].privNF > limit->max) {
+			high_nf_mid = true;
+
+			ath_print(common, ATH_DBG_CALIBRATE,
+				  "NFmid[%d] (%d) > MAX (%d), %s\n",
+				  i, h[i].privNF, limit->max,
+				  (cal->nfcal_interference ?
+				   "not corrected (due to interference)" :
+				   "correcting to MAX"));
+
+			/*
+			 * Normally we limit the average noise floor by the
+			 * hardware specific maximum here. However if we have
+			 * encountered stuck beacons because of interference,
+			 * we bypass this limit here in order to better deal
+			 * with our environment.
+			 */
+			if (!cal->nfcal_interference)
+				h[i].privNF = limit->max;
+		}
 	}
+
+	/*
+	 * If the noise floor seems normal for all chains, assume that
+	 * there is no significant interference in the environment anymore.
+	 * Re-enable the enforcement of the NF maximum again.
+	 */
+	if (!high_nf_mid)
+		cal->nfcal_interference = false;
 }
 
 static bool ath9k_hw_get_nf_thresh(struct ath_hw *ah,
@@ -339,7 +372,7 @@ bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan)
 
 	h = caldata->nfCalHist;
 	caldata->nfcal_pending = false;
-	ath9k_hw_update_nfcal_hist_buffer(ah, h, nfarray);
+	ath9k_hw_update_nfcal_hist_buffer(ah, caldata, nfarray);
 	caldata->rawNoiseFloor = h[0].privNF;
 	return true;
 }
@@ -374,3 +407,28 @@ s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan)
 	return ah->caldata->rawNoiseFloor;
 }
 EXPORT_SYMBOL(ath9k_hw_getchan_noise);
+
+void ath9k_hw_bstuck_nfcal(struct ath_hw *ah)
+{
+	struct ath9k_hw_cal_data *caldata = ah->caldata;
+
+	if (unlikely(!caldata))
+		return;
+
+	/*
+	 * If beacons are stuck, the most likely cause is interference.
+	 * Triggering a noise floor calibration at this point helps the
+	 * hardware adapt to a noisy environment much faster.
+	 * To ensure that we recover from stuck beacons quickly, let
+	 * the baseband update the internal NF value itself, similar to
+	 * what is being done after a full reset.
+	 */
+	if (!caldata->nfcal_pending)
+		ath9k_hw_start_nfcal(ah, true);
+	else if (!(REG_READ(ah, AR_PHY_AGC_CONTROL) & AR_PHY_AGC_CONTROL_NF))
+		ath9k_hw_getnf(ah, ah->curchan);
+
+	caldata->nfcal_interference = true;
+}
+EXPORT_SYMBOL(ath9k_hw_bstuck_nfcal);
+
diff --git a/drivers/net/wireless/ath/ath9k/calib.h b/drivers/net/wireless/ath/ath9k/calib.h
index 0a304b3..5b053a6 100644
--- a/drivers/net/wireless/ath/ath9k/calib.h
+++ b/drivers/net/wireless/ath/ath9k/calib.h
@@ -113,6 +113,7 @@ void ath9k_hw_loadnf(struct ath_hw *ah, struct ath9k_channel *chan);
 bool ath9k_hw_getnf(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_init_nfcal_hist_buffer(struct ath_hw *ah,
 				  struct ath9k_channel *chan);
+void ath9k_hw_bstuck_nfcal(struct ath_hw *ah);
 s16 ath9k_hw_getchan_noise(struct ath_hw *ah, struct ath9k_channel *chan);
 void ath9k_hw_reset_calibration(struct ath_hw *ah,
 				struct ath9k_cal_list *currCal);
diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 399f7c1..1601dd4 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -355,6 +355,7 @@ struct ath9k_hw_cal_data {
 	int16_t rawNoiseFloor;
 	bool paprd_done;
 	bool nfcal_pending;
+	bool nfcal_interference;
 	u16 small_signal_gain[AR9300_MAX_CHAINS];
 	u32 pa_table[AR9300_MAX_CHAINS][PAPRD_TABLE_SZ];
 	struct ath9k_nfcal_hist nfCalHist[NUM_NF_READINGS];
-- 
1.6.4.2

