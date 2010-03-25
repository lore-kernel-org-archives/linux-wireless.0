Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30g.wh2.ocn.ne.jp ([220.111.41.239]:48285 "HELO
	mail30g.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752506Ab0CYFtP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Mar 2010 01:49:15 -0400
Received: from vs3001.wh2.ocn.ne.jp (125.206.180.229)
	by mail30g.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 2-0813496154
	for <linux-wireless@vger.kernel.org>; Thu, 25 Mar 2010 14:49:14 +0900 (JST)
Subject: [PATCH 02/10] ath5k: remove the use of SWI interrupt
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, bob@bobcopeland.com,
	ath5k-devel@lists.ath5k.org, lrodriguez@atheros.com,
	mickflemm@gmail.com
Date: Thu, 25 Mar 2010 14:49:09 +0900
Message-ID: <20100325054909.10697.16867.stgit@tt-desk>
In-Reply-To: <20100325054603.10697.48915.stgit@tt-desk>
References: <20100325054603.10697.48915.stgit@tt-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need to generate a software interrupt (SWI) just to schedule a tasklet
- we can just schedule the tasklet directly.

Rename constants, names, etc to reflect the fact that we don't use SWI any more.

Also move the flag handling into the tasklet and prepare it to behave correctly
when there are multiple flags present.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/ath5k.h |   12 ++++++------
 drivers/net/wireless/ath/ath5k/base.c  |   11 +++--------
 drivers/net/wireless/ath/ath5k/phy.c   |    3 +--
 3 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/ath5k.h b/drivers/net/wireless/ath/ath5k/ath5k.h
index a3019ee..d84ccde 100644
--- a/drivers/net/wireless/ath/ath5k/ath5k.h
+++ b/drivers/net/wireless/ath/ath5k/ath5k.h
@@ -890,10 +890,10 @@ enum ath5k_int {
 	AR5K_INT_NOCARD	= 0xffffffff
 };
 
-/* Software interrupts used for calibration */
-enum ath5k_software_interrupt {
-	AR5K_SWI_FULL_CALIBRATION = 0x01,
-	AR5K_SWI_SHORT_CALIBRATION = 0x02,
+/* mask which calibration is active at the moment */
+enum ath5k_calibration_mask {
+	AR5K_CALIBRATION_FULL = 0x01,
+	AR5K_CALIBRATION_SHORT = 0x02,
 };
 
 /*
@@ -1102,8 +1102,8 @@ struct ath5k_hw {
 	/* Calibration timestamp */
 	unsigned long		ah_cal_tstamp;
 
-	/* Software interrupt mask */
-	u8			ah_swi_mask;
+	/* Calibration mask */
+	u8			ah_cal_mask;
 
 	/*
 	 * Function pointers
diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 39d5800..539a6d5 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2507,7 +2507,7 @@ ath5k_init(struct ath5k_softc *sc)
 	sc->curband = &sc->sbands[sc->curchan->band];
 	sc->imask = AR5K_INT_RXOK | AR5K_INT_RXERR | AR5K_INT_RXEOL |
 		AR5K_INT_RXORN | AR5K_INT_TXDESC | AR5K_INT_TXEOL |
-		AR5K_INT_FATAL | AR5K_INT_GLOBAL | AR5K_INT_SWI;
+		AR5K_INT_FATAL | AR5K_INT_GLOBAL;
 	ret = ath5k_reset(sc, NULL);
 	if (ret)
 		goto done;
@@ -2673,9 +2673,6 @@ ath5k_intr(int irq, void *dev_id)
 			if (status & AR5K_INT_BMISS) {
 				/* TODO */
 			}
-			if (status & AR5K_INT_SWI) {
-				tasklet_schedule(&sc->calib);
-			}
 			if (status & AR5K_INT_MIB) {
 				/*
 				 * These stats are also used for ANI i think
@@ -2716,8 +2713,7 @@ ath5k_tasklet_calibrate(unsigned long data)
 	struct ath5k_hw *ah = sc->ah;
 
 	/* Only full calibration for now */
-	if (ah->ah_swi_mask != AR5K_SWI_FULL_CALIBRATION)
-		return;
+	ah->ah_cal_mask |= AR5K_CALIBRATION_FULL;
 
 	/* Stop queues so that calibration
 	 * doesn't interfere with tx */
@@ -2740,11 +2736,10 @@ ath5k_tasklet_calibrate(unsigned long data)
 			ieee80211_frequency_to_channel(
 				sc->curchan->center_freq));
 
-	ah->ah_swi_mask = 0;
-
 	/* Wake queues */
 	ieee80211_wake_queues(sc->hw);
 
+	ah->ah_cal_mask &= ~AR5K_CALIBRATION_FULL;
 }
 
 
diff --git a/drivers/net/wireless/ath/ath5k/phy.c b/drivers/net/wireless/ath/ath5k/phy.c
index 07f59b1..cbdc511 100644
--- a/drivers/net/wireless/ath/ath5k/phy.c
+++ b/drivers/net/wireless/ath/ath5k/phy.c
@@ -1119,8 +1119,7 @@ ath5k_hw_calibration_poll(struct ath5k_hw *ah)
 	 * interrupt (bit gets auto-cleared) */
 	if (time_is_before_eq_jiffies(ah->ah_cal_tstamp + cal_intval)) {
 		ah->ah_cal_tstamp = jiffies;
-		ah->ah_swi_mask = AR5K_SWI_FULL_CALIBRATION;
-		AR5K_REG_ENABLE_BITS(ah, AR5K_CR, AR5K_CR_SWI);
+		tasklet_schedule(&ah->ah_sc->calib);
 	}
 }
 

