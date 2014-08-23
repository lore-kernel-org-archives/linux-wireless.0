Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57459 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752567AbaHWH7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:33 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 09/18] ath9k: Make ath_chanctx_get_oper_chan static
Date: Sat, 23 Aug 2014 13:29:14 +0530
Message-Id: <1408780763-27974-10-git-send-email-sujith@msujith.org> (sfid-20140823_095940_163122_BA884359)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 --
 drivers/net/wireless/ath/ath9k/channel.c | 35 ++++++++++++++++----------------
 2 files changed, 18 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index a77abe7..0371b30 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -420,8 +420,6 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
-struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
-					      bool active);
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev);
 void ath_offchannel_next(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 7c71787..1950da4 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -227,23 +227,6 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 	ath_set_channel(sc);
 }
 
-struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc, bool active)
-{
-	struct ath_chanctx *ctx;
-
-	ath_for_each_chanctx(sc, ctx) {
-		if (!ctx->assigned || list_empty(&ctx->vifs))
-			continue;
-		if (active && !ctx->active)
-			continue;
-
-		if (ctx->switch_after_beacon)
-			return ctx;
-	}
-
-	return &sc->chanctx[0];
-}
-
 static struct ath_chanctx *
 ath_chanctx_get_next(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
@@ -537,6 +520,24 @@ static void ath_chanctx_offchan_switch(struct ath_softc *sc,
 	ath_chanctx_switch(sc, &sc->offchannel.chan, &chandef);
 }
 
+static struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
+						     bool active)
+{
+	struct ath_chanctx *ctx;
+
+	ath_for_each_chanctx(sc, ctx) {
+		if (!ctx->assigned || list_empty(&ctx->vifs))
+			continue;
+		if (active && !ctx->active)
+			continue;
+
+		if (ctx->switch_after_beacon)
+			return ctx;
+	}
+
+	return &sc->chanctx[0];
+}
+
 static void
 ath_scan_next_channel(struct ath_softc *sc)
 {
-- 
2.0.4

