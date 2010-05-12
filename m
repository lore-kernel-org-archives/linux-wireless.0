Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:42728 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754387Ab0ELJkO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 May 2010 05:40:14 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0392777211
	for <linux-wireless@vger.kernel.org>; Wed, 12 May 2010 18:40:12 +0900 (JST)
Subject: [PATCH 06/12] ath5k: run NF calibration only every 60 seconds
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Date: Wed, 12 May 2010 18:40:13 +0900
Message-ID: <20100512094013.6575.9949.stgit@tt-desk>
In-Reply-To: <20100512093947.6575.99595.stgit@tt-desk>
References: <20100512093947.6575.99595.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Since NF calibration interferes with TX and RX and also has been the cause of
other problems (when it's run concurrently with ath5k_reset) we want to run it
less often - every 60 seconds for now.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 ++
 drivers/net/wireless/ath/ath5k/base.c  |   18 +++++++++++-------
 2 files changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 131e8b3..d6f9afe 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -204,6 +204,7 @@
 #define AR5K_TUNE_TPC_TXPOWER			false
 #define ATH5K_TUNE_CALIBRATION_INTERVAL_FULL    10000   /* 10 sec */
 #define ATH5K_TUNE_CALIBRATION_INTERVAL_ANI	1000	/* 1 sec */
+#define ATH5K_TUNE_CALIBRATION_INTERVAL_NF	60000	/* 60 sec */
 
 #define AR5K_INIT_CARR_SENSE_EN			1
 
@@ -1118,6 +1119,7 @@ struct ath5k_hw {
 	/* Calibration timestamp */
 	unsigned long		ah_cal_next_full;
 	unsigned long		ah_cal_next_ani;
+	unsigned long		ah_cal_next_nf;
 
 	/* Calibration mask */
 	u8			ah_cal_mask;
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b15b9d6..e3803ba 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2801,14 +2801,16 @@ ath5k_tasklet_calibrate(unsigned long data)
 			ieee80211_frequency_to_channel(
 				sc->curchan->center_freq));
 
-	/* TODO: We don't need to run noise floor calibration as often
-	 * as I/Q calibration.*/
-
 	/* Noise floor calibration interrupts rx/tx path while I/Q calibration
-	 * doesn't. Stop queues so that calibration doesn't interfere with tx */
-	ieee80211_stop_queues(sc->hw);
-	ath5k_hw_update_noise_floor(ah);
-	ieee80211_wake_queues(sc->hw);
+	 * doesn't. We stop the queues so that calibration doesn't interfere
+	 * with TX and don't run it as often */
+	if (time_is_before_eq_jiffies(ah->ah_cal_next_nf)) {
+		ah->ah_cal_next_nf = jiffies +
+			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_NF);
+		ieee80211_stop_queues(sc->hw);
+		ath5k_hw_update_noise_floor(ah);
+		ieee80211_wake_queues(sc->hw);
+	}
 
 	ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;
 }
@@ -2929,6 +2931,8 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 
 	ah->ah_cal_next_full = jiffies;
 	ah->ah_cal_next_ani = jiffies;
+	ah->ah_cal_next_nf = jiffies;
+
 	/*
 	 * Change channels and update the h/w rate map if we're switching;
 	 * e.g. 11a to 11b/g.

