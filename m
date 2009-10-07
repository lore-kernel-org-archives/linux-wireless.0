Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33178 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758599AbZJGBTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:19:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 3/6] ath9k: add helper to un-init the hw properly
Date: Tue,  6 Oct 2009 21:19:08 -0400
Message-Id: <1254878351-32433-4-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
References: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is used in several places, ensure we do it right in all
callers by using a helper.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   23 ++++++++++++++---------
 1 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 0fe915a..e6842dd 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1325,6 +1325,17 @@ void ath_cleanup(struct ath_softc *sc)
 	ieee80211_free_hw(sc->hw);
 }
 
+static void ath9k_uninit_hw(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+
+	BUG_ON(!ah);
+
+	ath9k_exit_debug(ah);
+	ath9k_hw_detach(ah);
+	sc->sc_ah = NULL;
+}
+
 void ath_detach(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
@@ -1365,9 +1376,7 @@ void ath_detach(struct ath_softc *sc)
 	    ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
 
-	ath9k_exit_debug(ah);
-	ath9k_hw_detach(ah);
-	sc->sc_ah = NULL;
+	ath9k_uninit_hw(sc);
 }
 
 static int ath9k_reg_notifier(struct wiphy *wiphy,
@@ -1850,10 +1859,8 @@ bad2:
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	ath9k_exit_debug(ah);
 bad_free_hw:
-	ath9k_hw_detach(ah);
-	sc->sc_ah = NULL;
+	ath9k_uninit_hw(sc);
 	return r;
 }
 
@@ -1966,9 +1973,7 @@ error_attach:
 		if (ATH_TXQ_SETUP(sc, i))
 			ath_tx_cleanupq(sc, &sc->tx.txq[i]);
 
-	ath9k_exit_debug(ah);
-	ath9k_hw_detach(ah);
-	sc->sc_ah = NULL;
+	ath9k_uninit_hw(sc);
 
 	return error;
 }
-- 
1.6.0.4

