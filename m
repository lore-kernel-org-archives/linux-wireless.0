Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:60190 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab1HEN3X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Aug 2011 09:29:23 -0400
From: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: [PATCH 1/3] ath9k: do not enable interrupt on set interrupt mask
Date: Fri, 5 Aug 2011 18:59:40 +0530
Message-ID: <1312550982-21914-1-git-send-email-rmanohar@qca.qualcomm.com> (sfid-20110805_152929_405227_58409EC8)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

At preset set_interrupt also enables interrupt after changing
mask. This is not necessary in all cases and also sometime it
breaks the assumption that interrupt was disabled. So let us
enable the interrupt explicity if it was disabled earlier.
This could also avoid unnecessary register ops and also helps
the follow up patch to have global ref count for interrupts ops.

Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |    9 +++++++--
 drivers/net/wireless/ath/ath9k/gpio.c   |    2 ++
 drivers/net/wireless/ath/ath9k/mac.c    |    3 ---
 drivers/net/wireless/ath/ath9k/main.c   |    4 ++++
 4 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index e19a230..72d3b6b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -521,6 +521,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 }
 
 /*
@@ -651,8 +652,10 @@ static void ath_beacon_config_sta(struct ath_softc *sc,
 	 * If the beacon config is called beacause of TSFOOR,
 	 * Interrupts will be enabled back at the end of ath9k_tasklet
 	 */
-	if (!(sc->ps_flags & PS_TSFOOR_SYNC))
+	if (!(sc->ps_flags & PS_TSFOOR_SYNC)) {
 		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_enable_interrupts(ah);
+	}
 }
 
 static void ath_beacon_config_adhoc(struct ath_softc *sc,
@@ -690,8 +693,10 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	 * If the beacon config is called beacause of TSFOOR,
 	 * Interrupts will be enabled back at the end of ath9k_tasklet
 	 */
-	if (!(sc->ps_flags & PS_TSFOOR_SYNC))
+	if (!(sc->ps_flags & PS_TSFOOR_SYNC)) {
 		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_enable_interrupts(ah);
+	}
 }
 
 static bool ath9k_allow_beacon_config(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index bc713fc..5113dd8 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -149,6 +149,7 @@ static void ath9k_gen_timer_start(struct ath_hw *ah,
 		ath9k_hw_disable_interrupts(ah);
 		ah->imask |= ATH9K_INT_GENTIMER;
 		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_enable_interrupts(ah);
 	}
 }
 
@@ -163,6 +164,7 @@ static void ath9k_gen_timer_stop(struct ath_hw *ah, struct ath_gen_timer *timer)
 		ath9k_hw_disable_interrupts(ah);
 		ah->imask &= ~ATH9K_INT_GENTIMER;
 		ath9k_hw_set_interrupts(ah, ah->imask);
+		ath9k_hw_enable_interrupts(ah);
 	}
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/mac.c b/drivers/net/wireless/ath/ath9k/mac.c
index b6b523a..c3af61e 100644
--- a/drivers/net/wireless/ath/ath9k/mac.c
+++ b/drivers/net/wireless/ath/ath9k/mac.c
@@ -929,9 +929,6 @@ void ath9k_hw_set_interrupts(struct ath_hw *ah, enum ath9k_int ints)
 			REG_CLR_BIT(ah, AR_IMR_S5, AR_IMR_S5_TIM_TIMER);
 	}
 
-	if (ints & ATH9K_INT_GLOBAL)
-		ath9k_hw_enable_interrupts(ah);
-
 	return;
 }
 EXPORT_SYMBOL(ath9k_hw_set_interrupts);
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9098aaa..72b7b0d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -294,6 +294,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
 	ath9k_cmn_update_txpow(ah, sc->curtxpow,
 			       sc->config.txpowlimit, &sc->curtxpow);
 	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 
 	if (!(sc->sc_flags & (SC_OP_OFFCHANNEL))) {
 		if (sc->sc_flags & SC_OP_BEACONS)
@@ -910,6 +911,7 @@ static void ath_radio_enable(struct ath_softc *sc, struct ieee80211_hw *hw)
 
 	/* Re-Enable  interrupts */
 	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 
 	/* Enable LED */
 	ath9k_hw_cfg_output(ah, ah->led_pin,
@@ -1016,6 +1018,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 		ath_set_beacon(sc);	/* restart beacons */
 
 	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 
 	if (retry_tx) {
 		int i;
@@ -1130,6 +1133,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	/* Disable BMISS interrupt when we're not associated */
 	ah->imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
 	ath9k_hw_set_interrupts(ah, ah->imask);
+	ath9k_hw_enable_interrupts(ah);
 
 	ieee80211_wake_queues(hw);
 
-- 
1.7.6

