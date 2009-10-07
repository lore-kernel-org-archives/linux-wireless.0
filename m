Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:33187 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758616AbZJGBTs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 21:19:48 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, vasanth@atheros.com,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 4/6] ath9k: add a helper to clean the core driver upon module unload
Date: Tue,  6 Oct 2009 21:19:09 -0400
Message-Id: <1254878351-32433-5-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
References: <1254878351-32433-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The core driver needs to be stopped and then as a last step the
hardware needs to be stopped and its structure free'd. We do this
by moving the core driver cleanup to a new helper ath_clean_core()
and have ath_cleanup() call it. Only as a last step does
ath_cleanup() now free the hw.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   13 +++++++++++--
 1 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e6842dd..39b2780 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1313,16 +1313,21 @@ static void ath_start_rfkill_poll(struct ath_softc *sc)
 		wiphy_rfkill_start_polling(sc->hw->wiphy);
 }
 
+static void ath_clean_core(struct ath_softc *sc);
+static void ath9k_uninit_hw(struct ath_softc *sc);
+
 void ath_cleanup(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
 
-	ath_detach(sc);
+	ath_clean_core(sc);
 	free_irq(sc->irq, sc);
 	ath_bus_cleanup(common);
 	kfree(sc->sec_wiphy);
 	ieee80211_free_hw(sc->hw);
+
+	ath9k_uninit_hw(sc);
 }
 
 static void ath9k_uninit_hw(struct ath_softc *sc)
@@ -1336,7 +1341,7 @@ static void ath9k_uninit_hw(struct ath_softc *sc)
 	sc->sc_ah = NULL;
 }
 
-void ath_detach(struct ath_softc *sc)
+static void ath_clean_core(struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath_hw *ah = sc->sc_ah;
@@ -1375,7 +1380,11 @@ void ath_detach(struct ath_softc *sc)
 	if ((sc->btcoex.no_stomp_timer) &&
 	    ah->btcoex_hw.scheme == ATH_BTCOEX_CFG_3WIRE)
 		ath_gen_timer_free(ah, sc->btcoex.no_stomp_timer);
+}
 
+void ath_detach(struct ath_softc *sc)
+{
+	ath_clean_core(sc);
 	ath9k_uninit_hw(sc);
 }
 
-- 
1.6.0.4

