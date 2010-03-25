Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:22662 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752623Ab0CYFt0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:26 -0400
Received: from vs3015.wh2.ocn.ne.jp (125.206.180.247)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 0-0296806164
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:24 +0900 (JST)
Subject: [PATCH 04/10] ath5k: move ath5k_hw_calibration_poll to base.c
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:19 +0900
Message-ID: <20100325054919.10697.91333.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bruno Randolf <br1@thinktube.com>

It's not a phy related funtion; It has more to do with the interrupt handler
and tasklet scheduling, so it belongs to base.c.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |    1 -
 drivers/net/wireless/ath/ath5k/base.c  |   15 ++++++++++++++-
 drivers/net/wireless/ath/ath5k/phy.c   |   13 -------------
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index 3f56d9e..6334294 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -1254,7 +1254,6 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel);
 void ath5k_hw_init_nfcal_hist(struct ath5k_hw *ah);
 int ath5k_hw_phy_calibrate(struct ath5k_hw *ah,
 			   struct ieee80211_channel *channel);
-void ath5k_hw_calibration_poll(struct ath5k_hw *ah);
 /* Spur mitigation */
 bool ath5k_hw_chan_has_spur_noise(struct ath5k_hw *ah,
 				  struct ieee80211_channel *channel);
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 539a6d5..f60d84f 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2625,6 +2625,19 @@ ath5k_stop_hw(struct ath5k_softc *sc)
 	return ret;
 }
 
+static void
+ath5k_intr_calibration_poll(struct ath5k_hw *ah)
+{
+	if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
+		ah->ah_cal_next_full = jiffies +
+			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
+		tasklet_schedule(&ah->ah_sc->calib);
+	}
+	/* we could use SWI to generate enough interrupts to meet our
+	 * calibration interval requirements, if necessary:
+	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
+}
+
 static irqreturn_t
 ath5k_intr(int irq, void *dev_id)
 {
@@ -2689,7 +2702,7 @@ ath5k_intr(int irq, void *dev_id)
 	if (unlikely(!counter))
 		ATH5K_WARN(sc, "too many interrupts, giving up for now\n");
 
-	ath5k_hw_calibration_poll(ah);
+	ath5k_intr_calibration_poll(ah);
 
 	return IRQ_HANDLED;
 }
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 60241ad..7f09c59 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1102,19 +1102,6 @@ int ath5k_hw_channel(struct ath5k_hw *ah, struct ieee80211_channel *channel)
   PHY calibration
 \*****************/
 
-void
-ath5k_hw_calibration_poll(struct ath5k_hw *ah)
-{
-	if (time_is_before_eq_jiffies(ah->ah_cal_next_full)) {
-		ah->ah_cal_next_full = jiffies +
-			msecs_to_jiffies(ATH5K_TUNE_CALIBRATION_INTERVAL_FULL);
-		tasklet_schedule(&ah->ah_sc->calib);
-	}
-	/* we could use SWI to generate enough interrupts to meet our
-	 * calibration interval requirements, if necessary:
-	 * AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI); */
-}
-
 static int sign_extend(int val, const int nbits)
 {
 	int order = BIT(nbits-1);

