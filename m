Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49044 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaJBBDG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Oct 2014 21:03:06 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH v2 08/10] ath9k: Add ath9k_chanctx_stop_queues()
Date: Thu,  2 Oct 2014 06:33:18 +0530
Message-Id: <1412211800-24344-9-git-send-email-sujith@msujith.org> (sfid-20141002_030309_581360_F8E068EE)
In-Reply-To: <1412211800-24344-1-git-send-email-sujith@msujith.org>
References: <1412211800-24344-1-git-send-email-sujith@msujith.org>
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

