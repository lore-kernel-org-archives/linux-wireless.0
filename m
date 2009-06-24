Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:21390 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754169AbZFXN1T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 09:27:19 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 24 Jun 2009 06:27:23 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <Jouni.Malinen@Atheros.com>, <Luis.Rodriguez@Atheros.com>,
	<linux-wireless@vger.kernel.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 6/7] ath9k: race condition in SCANNING state check during ANI calibration
Date: Wed, 24 Jun 2009 18:56:41 +0530
Message-ID: <1245850002-26351-7-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1245850002-26351-6-git-send-email-senthilkumar@atheros.com>
References: <1245850002-26351-1-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-2-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-3-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-4-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-5-git-send-email-senthilkumar@atheros.com>
 <1245850002-26351-6-git-send-email-senthilkumar@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ANI calibration shouldn't be done when we are not on our home channel.
This is already verified. However, it is racy. Fix this by proper
spin locks.

Signed-off-by: Senthil Balasubramanian <senthilkumar@atheros.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    1 +
 drivers/net/wireless/ath/ath9k/main.c  |   11 +++++++----
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a86e384..8de4b86 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -563,6 +563,7 @@ struct ath_softc {
 	int irq;
 	spinlock_t sc_resetlock;
 	spinlock_t sc_serial_rw;
+	spinlock_t ani_lock;
 	struct mutex mutex;
 
 	u8 curbssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 81de792..b7d5305 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -342,6 +342,7 @@ static void ath_ani_calibrate(unsigned long data)
 	* don't calibrate when we're scanning.
 	* we are most likely not on our home channel.
 	*/
+	spin_lock(&sc->ani_lock);
 	if (sc->sc_flags & SC_OP_SCANNING)
 		goto set_timer;
 
@@ -405,6 +406,7 @@ static void ath_ani_calibrate(unsigned long data)
 	ath9k_ps_restore(sc);
 
 set_timer:
+	spin_unlock(&sc->ani_lock);
 	/*
 	* Set timer interval based on previous results.
 	* The interval must be the shortest necessary to satisfy ANI,
@@ -1312,6 +1314,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
+	spin_lock_init(&sc->ani_lock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
@@ -2686,9 +2689,9 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	aphy->state = ATH_WIPHY_SCAN;
 	ath9k_wiphy_pause_all_forced(sc, aphy);
 
-	mutex_lock(&sc->mutex);
+	spin_lock_bh(&sc->ani_lock);
 	sc->sc_flags |= SC_OP_SCANNING;
-	mutex_unlock(&sc->mutex);
+	spin_unlock_bh(&sc->ani_lock);
 }
 
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
@@ -2696,11 +2699,11 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
-	mutex_lock(&sc->mutex);
+	spin_lock_bh(&sc->ani_lock);
 	aphy->state = ATH_WIPHY_ACTIVE;
 	sc->sc_flags &= ~SC_OP_SCANNING;
 	sc->sc_flags |= SC_OP_FULL_RESET;
-	mutex_unlock(&sc->mutex);
+	spin_unlock_bh(&sc->ani_lock);
 }
 
 struct ieee80211_ops ath9k_ops = {
-- 
1.6.0.4

