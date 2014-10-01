Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:46081 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaJAKIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 06:08:00 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: linux-wireless@vger.kernel.org
Cc: ath9k-devel@qca.qualcomm.com
Subject: [RFC 3/5] ath9k: Add ath9k_chanctx_stop_queues()
Date: Wed,  1 Oct 2014 15:38:31 +0530
Message-Id: <1412158113-22913-4-git-send-email-sujith@msujith.org> (sfid-20141001_120804_640434_942DBAA5)
In-Reply-To: <1412158113-22913-1-git-send-email-sujith@msujith.org>
References: <1412158113-22913-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This can be used when the queues of a context
needs to be stopped.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  5 +++++
 drivers/net/wireless/ath/ath9k/channel.c | 19 +++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 4f94d31..bfa0b15 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -456,6 +456,7 @@ void ath9k_beacon_add_noa(struct ath_softc *sc, struct ath_vif *avp,
 			  struct sk_buff *skb);
 void ath9k_p2p_ps_timer(void *priv);
 void ath9k_chanctx_wake_queues(struct ath_softc *sc, struct ath_chanctx *ctx);
+void ath9k_chanctx_stop_queues(struct ath_softc *sc, struct ath_chanctx *ctx);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
 
 void ath_chanctx_beacon_recv_ev(struct ath_softc *sc,
@@ -529,6 +530,10 @@ static inline void ath9k_chanctx_wake_queues(struct ath_softc *sc,
 					     struct ath_chanctx *ctx)
 {
 }
+static inline void ath9k_chanctx_stop_queues(struct ath_softc *sc,
+					     struct ath_chanctx *ctx)
+{
+}
 static inline void ath_chanctx_check_active(struct ath_softc *sc,
 					    struct ath_chanctx *ctx)
 {
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 96da03e..bf5ecd8 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -1177,6 +1177,25 @@ bool ath9k_is_chanctx_enabled(void)
 /* Queue management */
 /********************/
 
+void ath9k_chanctx_stop_queues(struct ath_softc *sc, struct ath_chanctx *ctx)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	int i;
+
+	if (ctx == &sc->offchannel.chan) {
+		ieee80211_stop_queue(sc->hw,
+				     sc->hw->offchannel_tx_hw_queue);
+	} else {
+		for (i = 0; i < IEEE80211_NUM_ACS; i++)
+			ieee80211_stop_queue(sc->hw,
+					     ctx->hw_queue_base + i);
+	}
+
+	if (ah->opmode == NL80211_IFTYPE_AP)
+		ieee80211_stop_queue(sc->hw, sc->hw->queues - 2);
+}
+
+
 void ath9k_chanctx_wake_queues(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
 	struct ath_hw *ah = sc->sc_ah;
-- 
2.1.1

