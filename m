Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:14808 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752506Ab0CYFtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:21 -0400
Received: from vs3000.wh2.ocn.ne.jp (125.206.180.163)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 1-0296346159
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:19 +0900 (JST)
Subject: [PATCH 03/10] ath5k: optimize ath5k_hw_calibration_poll
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:14 +0900
Message-ID: <20100325054914.10697.73582.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Optimize ath5k_hw_calibration_poll() since it is called on every singe
interrupt.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    2 +-
 drivers/net/wireless/ath/ath5k/phy.c   |   20 ++++++--------------
 2 files changed, 7 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index d84ccde..3f56d9e 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1100,7 +1100,7 @@ struct ath5k_hw {
 	s32			ah_noise_floor;
 
 	/* Calibration timestamp */
-	unsigned long		ah_cal_tstamp;
+	unsigned long		ah_cal_next_full;
 
 	/* Calibration mask */
 	u8			ah_cal_mask;
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index cbdc511..60241ad 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1105,22 +1105,14 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
 void
 ath5k_hw_calibration_poll(struct ath5k_hw *ah)
 {
-	/* Calibration interval in jiffies */
-	unsigned long cal_intval;
-
-	cal_intval = msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
-
-	/* Initialize timestamp if needed */
-	if (!ah->ah_cal_tstamp)
-		ah->ah_cal_tstamp = jiffies;
-
-	/* For now we always do full calibration
-	 * Mark software interrupt mask and fire software
-	 * interrupt (bit gets auto-cleared) */
-	if (time_is_before_eq_jiffies(ah->ah_cal_tstamp + cal_intval)) {
-		ah->ah_cal_tstamp = jiffies;
+	if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
+		ah->ah_cal_next_full = jiffies +
+			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
 		tasklet_schedule(&ah->ah_sc->calib);
 	}
+	/* we could use SWI to generate enough interrupts to meet our
+	 * calibration interval requirements, if necessary:
+	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
 }
 
 static int sign_extend(int val, const int nbits)

