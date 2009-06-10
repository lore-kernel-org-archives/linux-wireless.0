Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:43284 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378AbZFJQ0I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 12:26:08 -0400
Received: from mail.atheros.com ([10.10.20.104])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 10 Jun 2009 09:26:11 -0700
From: Senthil Balasubramanian <senthilkumar@atheros.com>
To: <linville@tuxdriver.com>
CC: <jouni.malinen@atheros.com>, <luis.rodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
Subject: [PATCH 5/7] ath9k: race condition in SCANNING state check during ANI calibration
Date: Wed, 10 Jun 2009 21:55:30 +0530
Message-ID: <1244651133-6537-6-git-send-email-senthilkumar@atheros.com>
In-Reply-To: <1244651133-6537-5-git-send-email-senthilkumar@atheros.com>
References: <1244651133-6537-1-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-2-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-3-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-4-git-send-email-senthilkumar@atheros.com>
 <1244651133-6537-5-git-send-email-senthilkumar@atheros.com>
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
index 2a3c66f..71d71c0 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -568,6 +568,7 @@ struct ath_softc {
 	int irq;
 	spinlock_t sc_resetlock;
 	spinlock_t sc_serial_rw;
+	spinlock_t ani_lock;
 	struct mutex mutex;
 
 	u8 curbssid[ETH_ALEN];
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 10dc7d1..e2c8649 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -326,6 +326,7 @@ static void ath_ani_calibrate(unsigned long data)
 	* don't calibrate when we're scanning.
 	* we are most likely not on our home channel.
 	*/
+	spin_lock(&sc->ani_lock);
 	if (sc->sc_flags & SC_OP_SCANNING)
 		goto set_timer;
 
@@ -389,6 +390,7 @@ static void ath_ani_calibrate(unsigned long data)
 	ath9k_ps_restore(sc);
 
 set_timer:
+	spin_unlock(&sc->ani_lock);
 	/*
 	* Set timer interval based on previous results.
 	* The interval must be the shortest necessary to satisfy ANI,
@@ -1348,6 +1350,7 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	spin_lock_init(&sc->wiphy_lock);
 	spin_lock_init(&sc->sc_resetlock);
 	spin_lock_init(&sc->sc_serial_rw);
+	spin_lock_init(&sc->ani_lock);
 	mutex_init(&sc->mutex);
 	tasklet_init(&sc->intr_tq, ath9k_tasklet, (unsigned long)sc);
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
@@ -2732,9 +2735,9 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	aphy->state = ATH_WIPHY_SCAN;
 	ath9k_wiphy_pause_all_forced(sc, aphy);
 
-	mutex_lock(&sc->mutex);
+	spin_lock_bh(&sc->ani_lock);
 	sc->sc_flags |= SC_OP_SCANNING;
-	mutex_unlock(&sc->mutex);
+	spin_unlock_bh(&sc->ani_lock);
 }
 
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
@@ -2742,11 +2745,11 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
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

