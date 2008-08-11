Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:39648 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbYHKLDW (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Aug 2008 07:03:22 -0400
Message-Id: <20080811110238.358118211@localhost> (sfid-20080811_130324_679915_2ABD5CB3)
References: <20080811110146.877112595@localhost>
Date: Mon, 11 Aug 2008 14:01:47 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/5] ath9k: Allow AP mode to be enabled
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>


Index: wireless-testing/drivers/net/wireless/ath9k/main.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/main.c
+++ wireless-testing/drivers/net/wireless/ath9k/main.c
@@ -426,10 +426,13 @@ static int ath9k_add_interface(struct ie
 	case IEEE80211_IF_TYPE_IBSS:
 		ic_opmode = ATH9K_M_IBSS;
 		break;
+	case IEEE80211_IF_TYPE_AP:
+		ic_opmode = ATH9K_M_HOSTAP;
+		break;
 	default:
 		DPRINTF(sc, ATH_DBG_FATAL,
-			"%s: Only STA and IBSS are supported currently\n",
-			__func__);
+			"%s: Interface type %d not yet supported\n",
+			__func__, conf->type);
 		return -EOPNOTSUPP;
 	}
 
@@ -530,6 +533,7 @@ static int ath9k_config_interface(struct
 				  struct ieee80211_if_conf *conf)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_hal *ah = sc->sc_ah;
 	struct ath_vap *avp;
 	u32 rfilt = 0;
 	int error, i;
@@ -542,6 +546,17 @@ static int ath9k_config_interface(struct
 		return -EINVAL;
 	}
 
+	/* TODO: Need to decide which hw opmode to use for multi-interface
+	 * cases */
+	if (vif->type == IEEE80211_IF_TYPE_AP &&
+	    ah->ah_opmode != ATH9K_M_HOSTAP) {
+		ah->ah_opmode = ATH9K_M_HOSTAP;
+		ath9k_hw_setopmode(ah);
+		ath9k_hw_write_associd(ah, sc->sc_myaddr, 0);
+		/* Request full reset to get hw opmode changed properly */
+		sc->sc_flags |= SC_OP_FULL_RESET;
+	}
+
 	if ((conf->changed & IEEE80211_IFCC_BSSID) &&
 	    !is_zero_ether_addr(conf->bssid)) {
 		switch (vif->type) {
Index: wireless-testing/drivers/net/wireless/ath9k/core.c
===================================================================
--- wireless-testing.orig/drivers/net/wireless/ath9k/core.c
+++ wireless-testing/drivers/net/wireless/ath9k/core.c
@@ -549,9 +549,15 @@ int ath_vap_listen(struct ath_softc *sc,
 	 * XXXX
 	 * Disable BMISS interrupt when we're not associated
 	 */
-	ath9k_hw_set_interrupts(ah,
-		sc->sc_imask & ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS));
-	sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
+	if (sc->sc_ah->ah_opmode == ATH9K_M_HOSTAP) {
+		ath9k_hw_set_interrupts(ah, sc->sc_imask & ~ATH9K_INT_BMISS);
+		sc->sc_imask &= ~ATH9K_INT_BMISS;
+	} else {
+		ath9k_hw_set_interrupts(
+			ah,
+			sc->sc_imask & ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS));
+		sc->sc_imask &= ~(ATH9K_INT_SWBA | ATH9K_INT_BMISS);
+	}
 	/* need to reconfigure the beacons when it moves to RUN */
 	sc->sc_flags &= ~SC_OP_BEACONS;
 

--

-- 
Jouni Malinen                                            PGP id EFC895FA
