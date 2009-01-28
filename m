Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:54390 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbZA1Jpx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Jan 2009 04:45:53 -0500
Received: by rv-out-0506.google.com with SMTP id k40so6869707rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Jan 2009 01:45:53 -0800 (PST)
Date: Wed, 28 Jan 2009 15:05:39 +0530
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] ath9k: Enable MIB and TIM interrupts for station mode.
Message-ID: <20090128093538.GA5799@myhost.users.atheros.com> (sfid-20090128_104558_523809_8F4DED26)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enable operating mode specific interrupts in ath9k_add_interface instead
of ath9k_start.

Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   40 +++++++++++++++++++-----------------
 1 files changed, 21 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index d8e8266..8b149ef 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1957,25 +1957,6 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	if (sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_HT)
 		sc->sc_imask |= ATH9K_INT_CST;
 
-	/*
-	 * Enable MIB interrupts when there are hardware phy counters.
-	 * Note we only do this (at the moment) for station mode.
-	 */
-	if (ath9k_hw_phycounters(sc->sc_ah) &&
-	    ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) ||
-	     (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)))
-		sc->sc_imask |= ATH9K_INT_MIB;
-	/*
-	 * Some hardware processes the TIM IE and fires an
-	 * interrupt when the TIM bit is set.  For hardware
-	 * that does, if not overridden by configuration,
-	 * enable the TIM interrupt when operating as station.
-	 */
-	if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
-	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) &&
-	    !sc->sc_config.swBeaconProcess)
-		sc->sc_imask |= ATH9K_INT_TIM;
-
 	ath_cache_conf_rate(sc, &hw->conf);
 
 	sc->sc_flags &= ~SC_OP_INVALID;
@@ -2124,6 +2105,27 @@ static int ath9k_add_interface(struct ieee80211_hw *hw,
 	/* Set the device opmode */
 	sc->sc_ah->ah_opmode = ic_opmode;
 
+	/*
+	 * Enable MIB interrupts when there are hardware phy counters.
+	 * Note we only do this (at the moment) for station mode.
+	 */
+	if (ath9k_hw_phycounters(sc->sc_ah) &&
+	    ((sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) ||
+	     (sc->sc_ah->ah_opmode == NL80211_IFTYPE_ADHOC)))
+		sc->sc_imask |= ATH9K_INT_MIB;
+	/*
+	 * Some hardware processes the TIM IE and fires an
+	 * interrupt when the TIM bit is set.  For hardware
+	 * that does, if not overridden by configuration,
+	 * enable the TIM interrupt when operating as station.
+	 */
+	if ((sc->sc_ah->ah_caps.hw_caps & ATH9K_HW_CAP_ENHANCEDPM) &&
+	    (sc->sc_ah->ah_opmode == NL80211_IFTYPE_STATION) &&
+	    !sc->sc_config.swBeaconProcess)
+		sc->sc_imask |= ATH9K_INT_TIM;
+
+	ath9k_hw_set_interrupts(sc->sc_ah, sc->sc_imask);
+
 	if (conf->type == NL80211_IFTYPE_AP) {
 		/* TODO: is this a suitable place to start ANI for AP mode? */
 		/* Start ANI */
-- 
1.6.0.1

