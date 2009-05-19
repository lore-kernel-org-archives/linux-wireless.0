Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59974 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752223AbZESOCX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 10:02:23 -0400
Message-Id: <20090519140216.840595983@atheros.com>
References: <20090519140137.708996030@atheros.com>
Date: Tue, 19 May 2009 17:01:38 +0300
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/7] ath9k: Wake up for TX in mac80211 timeout=0 sleep mode
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When using timeout=0 (PS-Poll) with mac80211, the driver will need to
wake up for TX requests and remain awake until the TX has been
completed (ACK received or timeout) or until the buffer frame(s) have
been received (in case the TX is for a PS-Poll frame).

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath/ath9k/ath9k.h |    6 +++++-
 drivers/net/wireless/ath/ath9k/main.c  |   30 +++++++++++++++++++++++++++++-
 drivers/net/wireless/ath/ath9k/recv.c  |   16 ++++++++++++++--
 drivers/net/wireless/ath/ath9k/xmit.c  |   10 ++++++++++
 4 files changed, 58 insertions(+), 4 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:28.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/main.c	2009-05-19 16:32:29.000000000 +0300
@@ -2070,6 +2070,31 @@ static int ath9k_tx(struct ieee80211_hw 
 		goto exit;
 	}
 
+	if (unlikely(sc->sc_ah->power_mode != ATH9K_PM_AWAKE)) {
+		/*
+		 * We are using PS-Poll and mac80211 can request TX while in
+		 * power save mode. Need to wake up hardware for the TX to be
+		 * completed and if needed, also for RX of buffered frames.
+		 */
+		struct ieee80211_hdr *hdr = (struct ieee80211_hdr *) skb->data;
+		ath9k_ps_wakeup(sc);
+		ath9k_hw_setrxabort(sc->sc_ah, 0);
+		if (ieee80211_is_pspoll(hdr->frame_control)) {
+			DPRINTF(sc, ATH_DBG_PS, "Sending PS-Poll to pick a "
+				"buffered frame\n");
+			sc->sc_flags |= SC_OP_WAIT_FOR_PSPOLL_DATA;
+		} else {
+			DPRINTF(sc, ATH_DBG_PS, "Wake up to complete TX\n");
+			sc->sc_flags |= SC_OP_WAIT_FOR_TX_ACK;
+		}
+		/*
+		 * The actual restore operation will happen only after
+		 * the sc_flags bit is cleared. We are just dropping
+		 * the ps_usecount here.
+		 */
+		ath9k_ps_restore(sc);
+	}
+
 	memset(&txctl, 0, sizeof(struct ath_tx_control));
 
 	/*
@@ -2307,7 +2332,10 @@ static int ath9k_config(struct ieee80211
 			if (!(ah->caps.hw_caps &
 			      ATH9K_HW_CAP_AUTOSLEEP)) {
 				ath9k_hw_setrxabort(sc->sc_ah, 0);
-				sc->sc_flags &= ~SC_OP_WAIT_FOR_BEACON;
+				sc->sc_flags &= ~(SC_OP_WAIT_FOR_BEACON |
+						  SC_OP_WAIT_FOR_CAB |
+						  SC_OP_WAIT_FOR_PSPOLL_DATA |
+						  SC_OP_WAIT_FOR_TX_ACK);
 				if (sc->imask & ATH9K_INT_TIM_TIMER) {
 					sc->imask &= ~ATH9K_INT_TIM_TIMER;
 					ath9k_hw_set_interrupts(sc->sc_ah,
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/ath9k.h	2009-05-19 16:32:27.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/ath9k.h	2009-05-19 16:32:29.000000000 +0300
@@ -520,6 +520,8 @@ struct ath_rfkill {
 #define SC_OP_SCANNING          BIT(14)
 #define SC_OP_TSF_RESET         BIT(15)
 #define SC_OP_WAIT_FOR_CAB      BIT(16)
+#define SC_OP_WAIT_FOR_PSPOLL_DATA BIT(17)
+#define SC_OP_WAIT_FOR_TX_ACK   BIT(18)
 
 struct ath_bus_ops {
 	void		(*read_cachesize)(struct ath_softc *sc, int *csz);
@@ -682,7 +684,9 @@ static inline void ath9k_ps_restore(stru
 {
 	if (atomic_dec_and_test(&sc->ps_usecount))
 		if ((sc->hw->conf.flags & IEEE80211_CONF_PS) &&
-		    !(sc->sc_flags & SC_OP_WAIT_FOR_BEACON))
+		    !(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+				      SC_OP_WAIT_FOR_PSPOLL_DATA |
+				      SC_OP_WAIT_FOR_TX_ACK)))
 			ath9k_hw_setpower(sc->sc_ah,
 					  sc->sc_ah->restore_mode);
 }
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/recv.c	2009-05-19 16:32:27.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/recv.c	2009-05-19 16:32:29.000000000 +0300
@@ -560,7 +560,8 @@ static void ath_rx_ps(struct ath_softc *
 	hdr = (struct ieee80211_hdr *)skb->data;
 
 	/* Process Beacon and CAB receive in PS state */
-	if (ieee80211_is_beacon(hdr->frame_control))
+	if ((sc->sc_flags & SC_OP_WAIT_FOR_BEACON) &&
+	    ieee80211_is_beacon(hdr->frame_control))
 		ath_rx_ps_beacon(sc, skb);
 	else if ((sc->sc_flags & SC_OP_WAIT_FOR_CAB) &&
 		 (ieee80211_is_data(hdr->frame_control) ||
@@ -574,6 +575,16 @@ static void ath_rx_ps(struct ath_softc *
 		 * point.
 		 */
 		ath_rx_ps_back_to_sleep(sc);
+	} else if ((sc->sc_flags & SC_OP_WAIT_FOR_PSPOLL_DATA) &&
+		   !is_multicast_ether_addr(hdr->addr1) &&
+		   !ieee80211_has_morefrags(hdr->frame_control)) {
+		sc->sc_flags &= ~SC_OP_WAIT_FOR_PSPOLL_DATA;
+		DPRINTF(sc, ATH_DBG_PS, "Going back to sleep after having "
+			"received PS-Poll data (0x%x)\n",
+			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+					SC_OP_WAIT_FOR_CAB |
+					SC_OP_WAIT_FOR_PSPOLL_DATA |
+					SC_OP_WAIT_FOR_TX_ACK));
 	}
 }
 
@@ -798,7 +809,8 @@ int ath_rx_tasklet(struct ath_softc *sc,
 			sc->rx.rxotherant = 0;
 		}
 
-		if (unlikely(sc->sc_flags & SC_OP_WAIT_FOR_BEACON))
+		if (unlikely(sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+					     SC_OP_WAIT_FOR_PSPOLL_DATA)))
 			ath_rx_ps(sc, skb);
 
 		ath_rx_send_to_mac80211(sc, skb, &rx_status);
--- wireless-testing.orig/drivers/net/wireless/ath/ath9k/xmit.c	2009-05-19 16:32:27.000000000 +0300
+++ wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c	2009-05-19 16:32:29.000000000 +0300
@@ -1790,6 +1790,16 @@ static void ath_tx_complete(struct ath_s
 		skb_pull(skb, padsize);
 	}
 
+	if (sc->sc_flags & SC_OP_WAIT_FOR_TX_ACK) {
+		sc->sc_flags &= ~SC_OP_WAIT_FOR_TX_ACK;
+		DPRINTF(sc, ATH_DBG_PS, "Going back to sleep after having "
+			"received TX status (0x%x)\n",
+			sc->sc_flags & (SC_OP_WAIT_FOR_BEACON |
+					SC_OP_WAIT_FOR_CAB |
+					SC_OP_WAIT_FOR_PSPOLL_DATA |
+					SC_OP_WAIT_FOR_TX_ACK));
+	}
+
 	if (frame_type == ATH9K_NOT_INTERNAL)
 		ieee80211_tx_status(hw, skb);
 	else

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
