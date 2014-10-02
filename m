Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:45094 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753929AbaJBBDC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 21:03:02 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 07/10] ath9k: Pass context to ath9k_chanctx_wake_queues()
Date: Thu,  2 Oct 2014 06:33:17 +0530
Message-Id: <1412211800-24344-8-git-send-email-sujith@msujith.org> (sfid-20141002_030306_747796_DCEF1F1E)
In-Reply-To: <1412211800-24344-1-git-send-email-sujith@msujith.org>
References: <1412211800-24344-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Change the ath9k_chanctx_wake_queues() API so
that we can pass the channel context that needs its
queues to be stopped.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   | 5 +++--
 drivers/net/wireless/ath/ath9k/channel.c | 6 +++---
 drivers/net/wireless/ath/ath9k/main.c    | 2 +-
 3 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 37a5ccf..4f94d31 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -455,7 +455,7 @@ void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 			  struct sk_buff *skb);
 void ath9k_p2p_ps_timer(void *priv);
-void ath9k_chanctx_wake_queues(struct ath_softc *sc);
+void ath9k_chanctx_wake_queues(struct ath_softc *sc, struct ath_chanctx *ctx);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
 
 void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
@@ -525,7 +525,8 @@ static inline void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *av
 static inline void ath9k_p2p_ps_timer(struct ath_softc *sc)
 {
 }
-static inline void ath9k_chanctx_wake_queues(struct ath_softc *sc)
+static inline void ath9k_chanctx_wake_queues(struct ath_softc *sc,
+					     struct ath_chanctx *ctx)
 {
 }
 static inline void ath_chanctx_check_active(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index d088f06..96da03e 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1177,18 +1177,18 @@ bool ath9k_is_chanctx_enabled(void)
 /* Queue management */
 /********************/
 
-void ath9k_chanctx_wake_queues(struct ath_softc *sc)
+void ath9k_chanctx_wake_queues(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
 	struct ath_hw *ah = sc->sc_ah;
 	int i;
 
-	if (sc->cur_chan == &sc->offchannel.chan) {
+	if (ctx == &sc->offchannel.chan) {
 		ieee80211_wake_queue(sc->hw,
 				     sc->hw->offchannel_tx_hw_queue);
 	} else {
 		for (i = 0; i < IEEE80211_NUM_ACS; i++)
 			ieee80211_wake_queue(sc->hw,
-					     sc->cur_chan->hw_queue_base + i);
+					     ctx->hw_queue_base + i);
 	}
 
 	if (ah->opmode == NL80211_IFTYPE_AP)
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 5f908a0..f0035a9 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -268,7 +268,7 @@ static bool ath_complete_reset(struct ath_softc *sc, bool start)
 	if (!ath9k_is_chanctx_enabled())
 		ieee80211_wake_queues(sc->hw);
 	else
-		ath9k_chanctx_wake_queues(sc);
+		ath9k_chanctx_wake_queues(sc, sc->cur_chan);
 
 	ath9k_p2p_ps_timer(sc);
 
-- 
2.1.1

