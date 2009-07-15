Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58383 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756799AbZGOARP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 14 Jul 2009 20:17:15 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 8/9] ath9k: uninline ath9k_ps_{wakeup,restore} functions
Date: Tue, 14 Jul 2009 20:17:14 -0400
Message-Id: <1247617035-15402-9-git-send-email-lrodriguez@atheros.com>
In-Reply-To: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
References: <1247617035-15402-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Gabor Juhos <juhosg@openwrt.org>

Uninline these functions before we add functional changes to them.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   23 ++---------------------
 drivers/net/wireless/ath/ath9k/hw.c    |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b37eb59..8b38c0a 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -674,27 +674,8 @@ static inline int ath_ahb_init(void) { return 0; };
 static inline void ath_ahb_exit(void) {};
 #endif
 
-static inline void ath9k_ps_wakeup(struct ath_softc *sc)
-{
-	if (atomic_inc_return(&sc->ps_usecount) == 1)
-		if (sc->sc_ah->power_mode !=  ATH9K_PM_AWAKE) {
-			sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
-			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
-		}
-}
-
-static inline void ath9k_ps_restore(struct ath_softc *sc)
-{
-	if (atomic_dec_and_test(&sc->ps_usecount))
-		if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
-		    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
-				      SC_OP_WAIT_FOR_CAB |
-				      SC_OP_WAIT_FOR_PSPOLL_DATA |
-				      SC_OP_WAIT_FOR_TX_ACK)))
-			ath9k_hw_setpower(sc->sc_ah,
-					  sc->sc_ah->restore_mode);
-}
-
+void ath9k_ps_wakeup(struct ath_softc *sc);
+void ath9k_ps_restore(struct ath_softc *sc);
 
 void ath9k_set_bssid_mask(struct ieee80211_hw *hw);
 int ath9k_wiphy_add(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/hw.c b/drivers/net/wireless/ath/ath9k/hw.c
index 6740a6b..df278fd 100644
--- a/drivers/net/wireless/ath/ath9k/hw.c
+++ b/drivers/net/wireless/ath/ath9k/hw.c
@@ -2775,6 +2775,27 @@ bool ath9k_hw_setpower(struct ath_hw *ah, enum ath9k_power_mode mode)
 	return ret;
 }
 
+void ath9k_ps_wakeup(struct ath_softc *sc)
+{
+	if (atomic_inc_return(&sc->ps_usecount) == 1)
+		if (sc->sc_ah->power_mode != ATH9K_PM_AWAKE) {
+			sc->sc_ah->restore_mode = sc->sc_ah->power_mode;
+			ath9k_hw_setpower(sc->sc_ah, ATH9K_PM_AWAKE);
+		}
+}
+
+void ath9k_ps_restore(struct ath_softc *sc)
+{
+	if (atomic_dec_and_test(&sc->ps_usecount))
+		if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
+		    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+				      SC_OP_WAIT_FOR_CAB |
+				      SC_OP_WAIT_FOR_PSPOLL_DATA |
+				      SC_OP_WAIT_FOR_TX_ACK)))
+			ath9k_hw_setpower(sc->sc_ah,
+					  sc->sc_ah->restore_mode);
+}
+
 /*
  * Helper for ASPM support.
  *
-- 
1.6.0.6

