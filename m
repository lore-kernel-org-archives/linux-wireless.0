Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from venema.h4ckr.net ([217.24.1.135]:36570 "EHLO venema.h4ckr.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755803AbXLPBLs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 15 Dec 2007 20:11:48 -0500
Date: Sun, 16 Dec 2007 03:11:48 +0200
From: Nick Kossifidis <mick@madwifi.org>
To: ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, bruno@thinktube.com, jirislaby@gmail.com,
	mcgrof@gmail.com
Subject: [PATCH 9/9] ath5k: Minor cleanups
Message-ID: <20071216011148.GI5482@makis.domain.invalid> (sfid-20071216_011150_636198_296A6DB8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

* Call set_txpower_limit directly
* Remove "partialy supported" mesage

Changes-licensed-under: ISC
Signed-off-by: Nick Kossifidis <mickflemm@gmail.com>

---
diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index c874a5e..b58b153 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -285,7 +285,6 @@ static int 	ath5k_stop_locked(struct ath5k_softc *sc);
 static int 	ath5k_stop_hw(struct ath5k_softc *sc);
 static irqreturn_t ath5k_intr(int irq, void *dev_id);
 static void 	ath5k_tasklet_reset(unsigned long data);
-static inline void ath5k_update_txpow(struct ath5k_softc *sc);
 static void 	ath5k_calibrate(unsigned long data);
 /* LED functions */
 static void 	ath5k_led_off(unsigned long data);
@@ -1014,7 +1013,7 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 			return ret;
 		}
 		sc->curchan = chan;
-		ath5k_update_txpow(sc);
+		ath5k_hw_set_txpower_limit(sc->ah, 0);
 
 		/*
 		 * Re-enable rx framework.
@@ -2098,7 +2097,7 @@ ath5k_init(struct ath5k_softc *sc)
 	 * This is needed only to setup initial state
 	 * but it's best done after a reset.
 	 */
-	ath5k_update_txpow(sc);
+	ath5k_hw_set_txpower_limit(sc->ah, 0);
 
 	/*
 	 * Setup the hardware after reset: the key cache
@@ -2297,12 +2296,6 @@ ath5k_tasklet_reset(unsigned long data)
 	ath5k_reset(sc->hw);
 }
 
-static inline void
-ath5k_update_txpow(struct ath5k_softc *sc)
-{
-	ath5k_hw_set_txpower_limit(sc->ah, 0);
-}
-
 /*
  * Periodically recalibrate the PHY to account
  * for temperature/environment changes.
@@ -2478,7 +2471,7 @@ ath5k_reset(struct ieee80211_hw *hw)
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;
 	}
-	ath5k_update_txpow(sc);
+	ath5k_hw_set_txpower_limit(sc->ah, 0);
 
 	ret = ath5k_rx_start(sc);
 	if (unlikely(ret)) {
diff --git a/drivers/net/wireless/ath5k/hw.c b/drivers/net/wireless/ath5k/hw.c
index ea5960e..fc43778 100644
--- a/drivers/net/wireless/ath5k/hw.c
+++ b/drivers/net/wireless/ath5k/hw.c
@@ -209,11 +209,6 @@ struct ath5k_hw *ath5k_hw_attach(struct ath5k_softc *sc, u8 mac_version)
 		goto err_free;
 	}
 
-	/* Warn for partially supported chips (unsupported phy etc) */
-	if(srev >= AR5K_SREV_VER_AR2424){
-		ATH5K_WARN(sc, "Device only partially supported.\n");
-	}
-
 	/* Identify single chip solutions */
 	if((srev <= AR5K_SREV_VER_AR5414) &&
 	(srev >= AR5K_SREV_VER_AR2424)) {



