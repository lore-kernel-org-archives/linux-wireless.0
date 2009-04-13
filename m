Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:54214 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753784AbZDMQbK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Apr 2009 12:31:10 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 13 Apr 2009 09:31:10 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18915.26566.17579.316992@gargle.gargle.HOWL> (sfid-20090413_183114_280601_CE77AD81)
Date: Mon, 13 Apr 2009 21:56:46 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH 07/11] ath9k: Initialize ANI timers
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The various ANI timers have to be initialized properly when
starting the calibration timer.

Cc: stable@kernel.org
Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   24 +++++++++++++++---------
 1 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index b2d129f..9564b73 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -407,6 +407,18 @@ set_timer:
 	mod_timer(&sc->ani.timer, jiffies + msecs_to_jiffies(cal_interval));
 }
 
+static void ath_start_ani(struct ath_softc *sc)
+{
+	unsigned long timestamp = jiffies_to_msecs(jiffies);
+
+	sc->ani.longcal_timer = timestamp;
+	sc->ani.shortcal_timer = timestamp;
+	sc->ani.checkani_timer = timestamp;
+
+	mod_timer(&sc->ani.timer,
+		  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
+}
+
 /*
  * Update tx/rx chainmask. For legacy association,
  * hard code chainmask to 1x1, for 11n association, use
@@ -911,9 +923,7 @@ static void ath9k_bss_assoc_info(struct ath_softc *sc,
 		sc->nodestats.ns_avgtxrssi = ATH_RSSI_DUMMY_MARKER;
 		sc->nodestats.ns_avgtxrate = ATH_RATE_DUMMY_MARKER;
 
-		/* Start ANI */
-		mod_timer(&sc->ani.timer,
-			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
+		ath_start_ani(sc);
 	} else {
 		DPRINTF(sc, ATH_DBG_CONFIG, "Bss Info DISASSOC\n");
 		sc->curaid = 0;
@@ -2239,12 +2249,8 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 
 	ath9k_hw_set_interrupts(sc->sc_ah, sc->imask);
 
-	if (conf->type == NL80211_IFTYPE_AP) {
-		/* TODO: is this a suitable place to start ANI for AP mode? */
-		/* Start ANI */
-		mod_timer(&sc->ani.timer,
-			  jiffies + msecs_to_jiffies(ATH_ANI_POLLINTERVAL));
-	}
+	if (conf->type == NL80211_IFTYPE_AP)
+		ath_start_ani(sc);
 
 out:
 	mutex_unlock(&sc->mutex);
-- 
1.6.2.2

