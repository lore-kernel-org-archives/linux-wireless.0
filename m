Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52557 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753730Ab2ENBxt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 May 2012 21:53:49 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20400.25980.76017.711819@gargle.gargle.HOWL> (sfid-20120514_035353_218291_00DE6DBD)
Date: Mon, 14 May 2012 07:23:00 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 1/7] ath9k: Prune ath9k_init_device
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Instead of cluttering ath9k_init_device() with 'ath_softc'
specific initialization code, use ath9k_init_softc() to
setup driver-specific work routines, timers etc.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/init.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index dee9e09..3e22839 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -489,6 +489,7 @@ static void ath9k_init_misc(struct ath_softc *sc)
 
 	setup_timer(&common->ani.timer, ath_ani_calibrate, (unsigned long)sc);
 
+	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
 	sc->config.txpowlimit = ATH_TXPOWER_MAX;
 	memcpy(common->bssidmask, ath_bcast_mac, ETH_ALEN);
 	sc->beacon.slottime = ATH9K_SLOT_TIME_9;
@@ -560,6 +561,12 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	tasklet_init(&sc->bcon_tasklet, ath_beacon_tasklet,
 		     (unsigned long)sc);
 
+	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
+	INIT_WORK(&sc->hw_check_work, ath_hw_check);
+	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
+	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
+	setup_timer(&sc->rx_poll_timer, ath_rx_poll, (unsigned long)sc);
+
 	/*
 	 * Cache line size is used to size and align various
 	 * structures used to communicate with the hardware.
@@ -782,11 +789,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 		ARRAY_SIZE(ath9k_tpt_blink));
 #endif
 
-	INIT_WORK(&sc->hw_reset_work, ath_reset_work);
-	INIT_WORK(&sc->hw_check_work, ath_hw_check);
-	INIT_WORK(&sc->paprd_work, ath_paprd_calibrate);
-	INIT_DELAYED_WORK(&sc->hw_pll_work, ath_hw_pll_work);
-
 	/* Register with mac80211 */
 	error = ieee80211_register_hw(hw);
 	if (error)
@@ -805,9 +807,6 @@ int ath9k_init_device(u16 devid, struct ath_softc *sc,
 			goto error_world;
 	}
 
-	setup_timer(&sc->rx_poll_timer, ath_rx_poll, (unsigned long)sc);
-	sc->last_rssi = ATH_RSSI_DUMMY_MARKER;
-
 	ath_init_leds(sc);
 	ath_start_rfkill_poll(sc);
 
-- 
1.7.10.2

