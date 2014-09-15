Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:58007 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316AbaIOFz1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2014 01:55:27 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 1/5] ath9k: Remove unnecessary tbtt assignment
Date: Mon, 15 Sep 2014 11:25:50 +0530
Message-Id: <1410760554-11844-2-git-send-email-sujith@msujith.org> (sfid-20140915_075530_982336_10B45124)
In-Reply-To: <1410760554-11844-1-git-send-email-sujith@msujith.org>
References: <1410760554-11844-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

The next_tbtt variable in the scheduler is needed only
for GO/AP mode operation and is always read from the
NEXT_TBTT_TIMER in the HW. There is no need to store
the timestamp for received beacons.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 4 ++--
 drivers/net/wireless/ath/ath9k/channel.c | 5 ++---
 drivers/net/wireless/ath/ath9k/recv.c    | 2 +-
 3 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 660c151..dd0f97f 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -454,7 +454,7 @@ void ath9k_p2p_ps_timer(void *priv);
 void ath9k_chanctx_wake_queues(struct ath_softc *sc);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
 
-void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
 				enum ath_chanctx_event ev);
 void ath_chanctx_beacon_sent_ev(struct ath_softc *sc,
 				enum ath_chanctx_event ev);
@@ -483,7 +483,7 @@ static inline void ath9k_offchannel_init(struct ath_softc *sc)
 static inline void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
 }
-static inline void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+static inline void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
 					      enum ath_chanctx_event ev)
 {
 }
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index a1b3282..3906df9 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -398,7 +398,6 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			break;
 		}
 
-
 		/*
 		 * Clear the extend_absence flag if it had been
 		 * set during the previous beacon transmission,
@@ -418,6 +417,7 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 			avp->noa_duration = 0;
 			sc->sched.extend_absence = true;
 		}
+
 		/* Prevent wrap-around issues */
 		if (avp->noa_duration && tsf_time - avp->noa_start > BIT(30))
 			avp->noa_duration = 0;
@@ -608,10 +608,9 @@ void ath_chanctx_beacon_sent_ev(struct ath_softc *sc,
 		ath_chanctx_event(sc, NULL, ev);
 }
 
-void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
 				enum ath_chanctx_event ev)
 {
-	sc->sched.next_tbtt = ts;
 	ath_chanctx_event(sc, NULL, ev);
 }
 
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index dea8e1b..0b53b74 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -909,7 +909,7 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 
 	if (ath9k_is_chanctx_enabled()) {
 		if (rx_stats->is_mybeacon)
-			ath_chanctx_beacon_recv_ev(sc, rx_stats->rs_tstamp,
+			ath_chanctx_beacon_recv_ev(sc,
 					   ATH_CHANCTX_EVENT_BEACON_RECEIVED);
 	}
 
-- 
2.1.0

