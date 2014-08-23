Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:59491 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHWH7k (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:40 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 13/18] ath9k: Add wrappers for beacon events
Date: Sat, 23 Aug 2014 13:29:18 +0530
Message-Id: <1408780763-27974-14-git-send-email-sujith@msujith.org> (sfid-20140823_101533_231729_B07A07EE)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Using these wrappers allows us to move the 'sched'
variable in ath_softc inside CONFIG_ATH9K_CHANNEL_CONTEXT.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 14 +++++++++++++-
 drivers/net/wireless/ath/ath9k/beacon.c  |  5 ++---
 drivers/net/wireless/ath/ath9k/channel.c | 14 ++++++++++++++
 drivers/net/wireless/ath/ath9k/recv.c    |  8 +++-----
 4 files changed, 32 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 8cf8e4f..352c5da 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -433,6 +433,10 @@ void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 				struct ieee80211_vif *vif);
 void ath9k_p2p_ps_timer(void *priv);
 
+void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+				enum ath_chanctx_event ev);
+void ath_chanctx_beacon_sent_ev(struct ath_softc *sc,
+				enum ath_chanctx_event ev);
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev);
 void ath_chanctx_set_next(struct ath_softc *sc, bool force);
@@ -453,6 +457,14 @@ static inline void ath9k_init_channel_context(struct ath_softc *sc)
 static inline void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
 }
+static inline void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+					      enum ath_chanctx_event ev)
+{
+}
+static inline void ath_chanctx_beacon_sent_ev(struct ath_softc *sc,
+					      enum ath_chanctx_event ev)
+{
+}
 static inline void ath_chanctx_event(struct ath_softc *sc,
 				     struct ieee80211_vif *vif,
 				     enum ath_chanctx_event ev)
@@ -901,6 +913,7 @@ struct ath_softc {
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 	struct ath_gen_timer *p2p_ps_timer;
 	struct ath_vif *p2p_ps_vif;
+	struct ath_chanctx_sched sched;
 #endif
 
 	unsigned long driver_data;
@@ -925,7 +938,6 @@ struct ath_softc {
 	struct ath_chanctx *next_chan;
 	spinlock_t chan_lock;
 	struct ath_offchannel offchannel;
-	struct ath_chanctx_sched sched;
 
 #ifdef CONFIG_MAC80211_LEDS
 	bool led_registered;
diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 68c95d4..dc68d11 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -428,9 +428,8 @@ void ath9k_beacon_tasklet(unsigned long data)
 	/* EDMA devices check that in the tx completion function. */
 	if (!edma) {
 		if (ath9k_is_chanctx_enabled()) {
-			if (sc->sched.beacon_pending)
-				ath_chanctx_event(sc, NULL,
-						  ATH_CHANCTX_EVENT_BEACON_SENT);
+			ath_chanctx_beacon_sent_ev(sc,
+					  ATH_CHANCTX_EVENT_BEACON_SENT);
 		}
 
 		if (ath9k_csa_is_finished(sc, vif))
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index ae0b3f9..39df24c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -463,6 +463,20 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 	spin_unlock_bh(&sc->chan_lock);
 }
 
+void ath_chanctx_beacon_sent_ev(struct ath_softc *sc,
+				enum ath_chanctx_event ev)
+{
+	if (sc->sched.beacon_pending)
+		ath_chanctx_event(sc, NULL, ev);
+}
+
+void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
+				enum ath_chanctx_event ev)
+{
+	sc->sched.next_tbtt = ts;
+	ath_chanctx_event(sc, NULL, ev);
+}
+
 static int ath_scan_channel_duration(struct ath_softc *sc,
 				     struct ieee80211_channel *chan)
 {
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index cc91749..2aaf233 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -893,11 +893,9 @@ static int ath9k_rx_skb_preprocess(struct ath_softc *sc,
 	}
 
 	if (ath9k_is_chanctx_enabled()) {
-		if (rx_stats->is_mybeacon) {
-			sc->sched.next_tbtt = rx_stats->rs_tstamp;
-			ath_chanctx_event(sc, NULL,
-					  ATH_CHANCTX_EVENT_BEACON_RECEIVED);
-		}
+		if (rx_stats->is_mybeacon)
+			ath_chanctx_beacon_recv_ev(sc, rx_stats->rs_tstamp,
+					   ATH_CHANCTX_EVENT_BEACON_RECEIVED);
 	}
 
 	ath9k_cmn_process_rssi(common, hw, rx_stats, rx_status);
-- 
2.0.4

