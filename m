Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:39528 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130AbbCAGUW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 01:20:22 -0500
Received: from [117.199.133.19] (port=11028 helo=sujith-pixel.localdomain)
	by server72.web-hosting.com with esmtpsa (UNKNOWN:AES128-SHA256:128)
	(Exim 4.82)
	(envelope-from <sujith@msujith.org>)
	id 1YRxEj-002K5A-AZ
	for linux-wireless@vger.kernel.org; Sun, 01 Mar 2015 01:20:21 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 5/6] ath9k: Handle timers for MCI
Date: Sun,  1 Mar 2015 11:53:48 +0530
Message-Id: <1425191029-13667-6-git-send-email-sujith@msujith.org> (sfid-20150301_072030_862918_01489AA4)
In-Reply-To: <1425191029-13667-1-git-send-email-sujith@msujith.org>
References: <1425191029-13667-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Make sure that the btcoex timers are started/stopped
properly for both 3-wire and MCI schemes.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/gpio.c | 52 +++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/gpio.c b/drivers/net/wireless/ath/ath9k/gpio.c
index b4a0612..6e22d80 100644
--- a/drivers/net/wireless/ath/ath9k/gpio.c
+++ b/drivers/net/wireless/ath/ath9k/gpio.c
@@ -298,6 +298,10 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	struct ath_btcoex *btcoex = &sc->btcoex;
 	struct ath_hw *ah = sc->sc_ah;
 
+	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_3WIRE &&
+	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_MCI)
+		return;
+
 	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Starting btcoex timers\n");
 
 	/* make sure duty cycle timer is also stopped when resuming */
@@ -311,13 +315,19 @@ void ath9k_btcoex_timer_resume(struct ath_softc *sc)
 	mod_timer(&btcoex->period_timer, jiffies);
 }
 
-
 /*
  * Pause btcoex timer and bt duty cycle timer
  */
 void ath9k_btcoex_timer_pause(struct ath_softc *sc)
 {
 	struct ath_btcoex *btcoex = &sc->btcoex;
+	struct ath_hw *ah = sc->sc_ah;
+
+	if (ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_3WIRE &&
+	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_MCI)
+		return;
+
+	ath_dbg(ath9k_hw_common(ah), BTCOEX, "Stopping btcoex timers\n");
 
 	del_timer_sync(&btcoex->period_timer);
 	del_timer_sync(&btcoex->no_stomp_timer);
@@ -355,33 +365,33 @@ void ath9k_start_btcoex(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-	if ((ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) &&
-	    !ah->btcoex_hw.enabled) {
-		if (!(sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
-			ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
-						   AR_STOMP_LOW_WLAN_WGHT, 0);
-		else
-			ath9k_hw_btcoex_set_weight(ah, 0, 0,
-						   ATH_BTCOEX_STOMP_NONE);
-		ath9k_hw_btcoex_enable(ah);
+	if (ah->btcoex_hw.enabled ||
+	    ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
 
-		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
-			ath9k_btcoex_timer_resume(sc);
-	}
+	if (!(ah->caps.hw_caps & ATH9K_HW_CAP_MCI))
+		ath9k_hw_btcoex_set_weight(ah, AR_BT_COEX_WGHT,
+					   AR_STOMP_LOW_WLAN_WGHT, 0);
+	else
+		ath9k_hw_btcoex_set_weight(ah, 0, 0,
+					   ATH_BTCOEX_STOMP_NONE);
+	ath9k_hw_btcoex_enable(ah);
+	ath9k_btcoex_timer_resume(sc);
 }
 
 void ath9k_stop_btcoex(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 
-	if (ah->btcoex_hw.enabled &&
-	    ath9k_hw_get_btcoex_scheme(ah) != ATH_BTCOEX_CFG_NONE) {
-		if (ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_3WIRE)
-			ath9k_btcoex_timer_pause(sc);
-		ath9k_hw_btcoex_disable(ah);
-		if (AR_SREV_9462(ah) || AR_SREV_9565(ah))
-			ath_mci_flush_profile(&sc->btcoex.mci);
-	}
+	if (!ah->btcoex_hw.enabled ||
+	    ath9k_hw_get_btcoex_scheme(ah) == ATH_BTCOEX_CFG_NONE)
+		return;
+
+	ath9k_btcoex_timer_pause(sc);
+	ath9k_hw_btcoex_disable(ah);
+
+	if (ah->caps.hw_caps & ATH9K_HW_CAP_MCI)
+		ath_mci_flush_profile(&sc->btcoex.mci);
 }
 
 void ath9k_deinit_btcoex(struct ath_softc *sc)
-- 
2.3.0

