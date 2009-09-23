Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46433 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754356AbZIWISD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Sep 2009 04:18:03 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2009 01:18:08 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19129.55808.751631.154022@gargle.gargle.HOWL>
Date: Wed, 23 Sep 2009 13:49:12 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix RFKILL bugs
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch fixes 2 issues in RFKILL:

* Calling wiphy_rfkill_stop_polling() in ath9k_stop
  would mean that the driver cannot report HW status
  when the radio is re-enabled. Move this to ath_detach().

* Calling ath_radio_{enable/disable} without checking the current
  state results in ath_radio_enable() being called repeatedly
  for every invocation of rfkill_poll(). This is not needed
  in any case since wiphy_rfkill_set_hw_state() would call
  ->stop() if the radio has been disabled.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0d6bbb8..2278dcb 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1299,11 +1299,6 @@ static void ath9k_rfkill_poll_state(struct ieee80211_hw *hw)
 	bool blocked = !!ath_is_rfkill_set(sc);
 
 	wiphy_rfkill_set_hw_state(hw->wiphy, blocked);
-
-	if (blocked)
-		ath_radio_disable(sc);
-	else
-		ath_radio_enable(sc);
 }
 
 static void ath_start_rfkill_poll(struct ath_softc *sc)
@@ -1337,6 +1332,7 @@ void ath_detach(struct ath_softc *sc)
 	dev_dbg(sc->dev, "Detach ATH hw\n");
 
 	ath_deinit_leds(sc);
+	wiphy_rfkill_stop_polling(sc->hw->wiphy);
 
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		struct ath_wiphy *aphy = sc->sec_wiphy[i];
@@ -2524,8 +2520,6 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	} else
 		sc->rx.rxlink = NULL;
 
-	wiphy_rfkill_stop_polling(sc->hw->wiphy);
-
 	/* disable HAL and put h/w to sleep */
 	ath9k_hw_disable(ah);
 	ath9k_hw_configpcipowersave(ah, 1, 1);
-- 
1.6.4.4

