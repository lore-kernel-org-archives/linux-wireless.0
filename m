Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:33262 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635AbaHWH7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:46 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 16/18] ath9k: Use ath_chanctx_check_active properly
Date: Sat, 23 Aug 2014 13:29:21 +0530
Message-Id: <1408780763-27974-17-git-send-email-sujith@msujith.org> (sfid-20140823_101534_137761_3C50E4E4)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

ath_chanctx_check_active() is required only when channel contexts
are used. Make sure that it is not called in normal usage.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  7 ++-
 drivers/net/wireless/ath/ath9k/channel.c | 90 ++++++++++++++++----------------
 2 files changed, 50 insertions(+), 47 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 5b8bc5d..8767aa7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -417,8 +417,6 @@ ath_chanctx_get(struct ieee80211_chanctx_conf *ctx)
 void ath_chanctx_init(struct ath_softc *sc);
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
-void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
-
 #ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
 bool ath9k_is_chanctx_enabled(void);
 void ath9k_fill_chanctx_ops(void);
@@ -434,6 +432,7 @@ void ath9k_p2p_bss_info_changed(struct ath_softc *sc,
 				struct ieee80211_vif *vif);
 void ath9k_p2p_ps_timer(void *priv);
 void ath9k_chanctx_wake_queues(struct ath_softc *sc);
+void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
 
 void ath_chanctx_beacon_recv_ev(struct ath_softc *sc, u32 ts,
 				enum ath_chanctx_event ev);
@@ -499,6 +498,10 @@ static inline void ath9k_p2p_ps_timer(struct ath_softc *sc)
 static inline void ath9k_chanctx_wake_queues(struct ath_softc *sc)
 {
 }
+static inline void ath_chanctx_check_active(struct ath_softc *sc,
+					    struct ath_chanctx *ctx)
+{
+}
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index d1ad5a2..08bb14c 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -101,51 +101,6 @@ static int ath_set_channel(struct ath_softc *sc)
 	return 0;
 }
 
-void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct ath_vif *avp;
-	bool active = false;
-	u8 n_active = 0;
-
-	if (!ctx)
-		return;
-
-	list_for_each_entry(avp, &ctx->vifs, list) {
-		struct ieee80211_vif *vif = avp->vif;
-
-		switch (vif->type) {
-		case NL80211_IFTYPE_P2P_CLIENT:
-		case NL80211_IFTYPE_STATION:
-			if (vif->bss_conf.assoc)
-				active = true;
-			break;
-		default:
-			active = true;
-			break;
-		}
-	}
-	ctx->active = active;
-
-	ath_for_each_chanctx(sc, ctx) {
-		if (!ctx->assigned || list_empty(&ctx->vifs))
-			continue;
-		n_active++;
-	}
-
-	if (n_active <= 1) {
-		clear_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags);
-		return;
-	}
-	if (test_and_set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
-		return;
-
-	if (ath9k_is_chanctx_enabled()) {
-		ath_chanctx_event(sc, NULL,
-				  ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL);
-	}
-}
-
 void ath_chanctx_init(struct ath_softc *sc)
 {
 	struct ath_chanctx *ctx;
@@ -209,6 +164,51 @@ static const char *offchannel_state_string(enum ath_offchannel_state state)
 	}
 }
 
+void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_vif *avp;
+	bool active = false;
+	u8 n_active = 0;
+
+	if (!ctx)
+		return;
+
+	list_for_each_entry(avp, &ctx->vifs, list) {
+		struct ieee80211_vif *vif = avp->vif;
+
+		switch (vif->type) {
+		case NL80211_IFTYPE_P2P_CLIENT:
+		case NL80211_IFTYPE_STATION:
+			if (vif->bss_conf.assoc)
+				active = true;
+			break;
+		default:
+			active = true;
+			break;
+		}
+	}
+	ctx->active = active;
+
+	ath_for_each_chanctx(sc, ctx) {
+		if (!ctx->assigned || list_empty(&ctx->vifs))
+			continue;
+		n_active++;
+	}
+
+	if (n_active <= 1) {
+		clear_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags);
+		return;
+	}
+	if (test_and_set_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags))
+		return;
+
+	if (ath9k_is_chanctx_enabled()) {
+		ath_chanctx_event(sc, NULL,
+				  ATH_CHANCTX_EVENT_ENABLE_MULTICHANNEL);
+	}
+}
+
 static struct ath_chanctx *
 ath_chanctx_get_next(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
-- 
2.0.4

