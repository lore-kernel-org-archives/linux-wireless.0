Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:52235 "EHLO
	phoenix3.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZFUPrr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Jun 2009 11:47:47 -0400
From: Gabor Juhos <juhosg@openwrt.org>
To: John Linville <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni Malinen <jmalinen@atheros.com>,
	Sujith Manoharan <Sujith.Manoharan@atheros.com>,
	Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Gabor Juhos <juhosg@openwrt.org>
Subject: [PATCH 2/3] ath9k: uninline ath9k_ps_{wakeup,restore} functions
Date: Sun, 21 Jun 2009 17:47:47 +0200
Message-Id: <1245599268-2441-2-git-send-email-juhosg@openwrt.org>
In-Reply-To: <1245599268-2441-1-git-send-email-juhosg@openwrt.org>
References: <1245599268-2441-1-git-send-email-juhosg@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Uninline these functions before we add functional changes to them.

Changes-licensed-under: ISC
Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |   23 ++---------------------
 drivers/net/wireless/ath/ath9k/hw.c    |   21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 902dfed..9865452 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -658,27 +658,8 @@ static inline int ath_ahb_init(void) { return 0; };
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
index 7ade05e..acf5256 100644
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
1.5.3.2

