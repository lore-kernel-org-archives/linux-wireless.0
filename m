Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:40340 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203AbZIJHKQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Sep 2009 03:10:16 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	devel@linuxdriverproject.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/7] ath9k: move ps helpers onto core driver when reseting tsf
Date: Thu, 10 Sep 2009 03:10:13 -0400
Message-Id: <1252566619-30390-2-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
References: <1252566619-30390-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the TSF is reset power save state is disabled and
then restored. The helpers to disable power save and restore
it use a lock provided by the driver core. Move the callers
of the helpers outside of the hw code.

We reset the TSF when mac80211 tells us and on the beacon.c
helper ath9k_hw_beaconinit() when it is made explicitly required.
Add a helper on beacon.c which will deal with ps awake/restore
if we need to reset the TSF upon ath9k_hw_beaconinit().

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c |   17 +++++++++++++++--
 drivers/net/wireless/ath/ath9k/hw.c     |    2 --
 drivers/net/wireless/ath/ath9k/main.c   |    4 ++++
 3 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 6e7a519..fb4ff55 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -502,6 +502,19 @@ void ath_beacon_tasklet(unsigned long data)
 	}
 }
 
+static void ath9k_beacon_init(struct ath_softc *sc,
+			      u32 next_beacon,
+			      u32 beacon_period)
+{
+	if (beacon_period & ATH9K_BEACON_RESET_TSF)
+		ath9k_ps_wakeup(sc);
+
+	ath9k_hw_beaconinit(sc->sc_ah, next_beacon, beacon_period);
+
+	if (beacon_period & ATH9K_BEACON_RESET_TSF)
+		ath9k_ps_restore(sc);
+}
+
 /*
  * For multi-bss ap support beacons are either staggered evenly over N slots or
  * burst together.  For the former arrange for the SWBA to be delivered for each
@@ -534,7 +547,7 @@ static void ath_beacon_config_ap(struct ath_softc *sc,
 	/* Set the computed AP beacon timers */
 
 	ath9k_hw_set_interrupts(sc->sc_ah, 0);
-	ath9k_hw_beaconinit(sc->sc_ah, nexttbtt, intval);
+	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
@@ -707,7 +720,7 @@ static void ath_beacon_config_adhoc(struct ath_softc *sc,
 	/* Set the computed ADHOC beacon timers */
 
 	ath9k_hw_set_interrupts(sc->sc_ah, 0);
-	ath9k_hw_beaconinit(sc->sc_ah, nexttbtt, intval);
+	ath9k_beacon_init(sc, nexttbtt, intval);
 	sc->beacon.bmisscnt = 0;
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 24157d2..d9a6026 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -4061,14 +4061,12 @@ void ath9k_hw_settsf64(struct ath_hw *ah, u64 tsf64)
 
 void ath9k_hw_reset_tsf(struct ath_hw *ah)
 {
-	ath9k_ps_wakeup(ah->ah_sc);
 	if (!ath9k_hw_wait(ah, AR_SLP32_MODE, AR_SLP32_TSF_WRITE_STATUS, 0,
 			   AH_TSF_WRITE_TIMEOUT))
 		DPRINTF(ah, ATH_DBG_RESET,
 			"AR_SLP32_TSF_WRITE_STATUS limit exceeded\n");
 
 	REG_WRITE(ah, AR_RESET_TSF, AR_RESET_TSF_ONCE);
-	ath9k_ps_restore(ah->ah_sc);
 }
 
 void ath9k_hw_set_tsfadjust(struct ath_hw *ah, u32 setting)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5a33d01..df09176 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2899,7 +2899,11 @@ static void ath9k_reset_tsf(struct ieee80211_hw *hw)
 	struct ath_softc *sc = aphy->sc;
 
 	mutex_lock(&sc->mutex);
+
+	ath9k_ps_wakeup(sc);
 	ath9k_hw_reset_tsf(sc->sc_ah);
+	ath9k_ps_restore(sc);
+
 	mutex_unlock(&sc->mutex);
 }
 
-- 
1.6.3.3

