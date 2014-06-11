Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:40951 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402AbaFKKs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:48:59 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 10/28] ath9k: Fetch appropriate operating channel context
Date: Wed, 11 Jun 2014 16:17:58 +0530
Message-ID: <1402483696-2498-11-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_130457_388851_4AA8CBF0)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Retrieve appropriate operating channel context while switching
between operating and off channels.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  7 +++++-
 drivers/net/wireless/ath/ath9k/channel.c | 14 +++++++-----
 drivers/net/wireless/ath/ath9k/main.c    | 37 ++++++++++++++++----------------
 3 files changed, 34 insertions(+), 24 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index eae1830..3db4898 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -355,6 +355,10 @@ struct ath_offchannel {
 	struct ieee80211_vif *roc_vif;
 	int roc_duration;
 };
+#define ath_for_each_chanctx(_sc, _ctx)                             \
+	for (ctx = &sc->chanctx[0];                                 \
+	     ctx <= &sc->chanctx[ARRAY_SIZE(sc->chanctx) - 1];      \
+	     ctx++)
 
 void ath9k_fill_chanctx_ops(void);
 static inline struct ath_chanctx *
@@ -373,7 +377,8 @@ void ath_offchannel_timer(unsigned long data);
 void ath_offchannel_channel_change(struct ath_softc *sc);
 void ath_chanctx_offchan_switch(struct ath_softc *sc,
 				struct ieee80211_channel *chan);
-struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc);
+struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
+					      bool active);
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
 int ath_startrecv(struct ath_softc *sc);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index c679a26..0972070 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -293,13 +293,17 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 	ath_set_channel(sc);
 }
 
-struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc)
+struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc, bool active)
 {
-	u8 i;
+	struct ath_chanctx *ctx;
+
+	ath_for_each_chanctx(sc, ctx) {
+		if (!ctx->assigned || list_empty(&ctx->vifs))
+			continue;
+		if (active && !ctx->active)
+			continue;
 
-	for (i = 0; i < ARRAY_SIZE(sc->chanctx); i++) {
-		if (!list_empty(&sc->chanctx[i].vifs))
-			return &sc->chanctx[i];
+		return ctx;
 	}
 
 	return &sc->chanctx[0];
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index e0cb2af..92bf907 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2161,7 +2161,8 @@ ath_scan_next_channel(struct ath_softc *sc)
 
 	if (sc->offchannel.scan_idx >= req->n_channels) {
 		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
-		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc), NULL);
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
+				   NULL);
 		return;
 	}
 
@@ -2184,7 +2185,8 @@ static void ath_offchannel_next(struct ath_softc *sc)
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
 		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
 	} else {
-		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc), NULL);
+		ath_chanctx_switch(sc, ath_chanctx_get_oper_chan(sc, false),
+				   NULL);
 		sc->offchannel.state = ATH_OFFCHANNEL_IDLE;
 		if (sc->ps_idle)
 			ath_cancel_work(sc);
@@ -2310,13 +2312,15 @@ void ath_offchannel_channel_change(struct ath_softc *sc)
 void ath_offchannel_timer(unsigned long data)
 {
 	struct ath_softc *sc = (struct ath_softc *)data;
-	struct ath_chanctx *ctx = ath_chanctx_get_oper_chan(sc);
+	struct ath_chanctx *ctx;
 
 	switch (sc->offchannel.state) {
 	case ATH_OFFCHANNEL_PROBE_WAIT:
 		if (!sc->offchannel.scan_req)
 			return;
 
+		/* get first active channel context */
+		ctx = ath_chanctx_get_oper_chan(sc, true);
 		if (ctx->active) {
 			sc->offchannel.state = ATH_OFFCHANNEL_SUSPEND;
 			ath_chanctx_switch(sc, ctx, NULL);
@@ -2332,6 +2336,7 @@ void ath_offchannel_timer(unsigned long data)
 		break;
 	case ATH_OFFCHANNEL_ROC_START:
 	case ATH_OFFCHANNEL_ROC_WAIT:
+		ctx = ath_chanctx_get_oper_chan(sc, false);
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_DONE;
 		ath_chanctx_switch(sc, ctx, NULL);
 		break;
@@ -2432,26 +2437,22 @@ static int ath9k_add_chanctx(struct ieee80211_hw *hw,
 {
 	struct ath_softc *sc = hw->priv;
 	struct ath_chanctx *ctx, **ptr;
-	int i;
 
 	mutex_lock(&sc->mutex);
-	for (i = 0; i < ATH9K_NUM_CHANCTX; i++) {
-		if (!sc->chanctx[i].assigned)
-			break;
-	}
-	if (i == ATH9K_NUM_CHANCTX) {
+
+	ath_for_each_chanctx(sc, ctx) {
+		if (ctx->assigned)
+			continue;
+
+		ptr = (void *) conf->drv_priv;
+		*ptr = ctx;
+		ctx->assigned = true;
+		ath_chanctx_set_channel(sc, ctx, &conf->def);
 		mutex_unlock(&sc->mutex);
-		return -ENOSPC;
+		return 0;
 	}
-
-	ctx = &sc->chanctx[i];
-	ptr = (void *) conf->drv_priv;
-	*ptr = ctx;
-	ctx->assigned = true;
-	ath_chanctx_set_channel(sc, ctx, &conf->def);
 	mutex_unlock(&sc->mutex);
-
-	return 0;
+	return -ENOSPC;
 }
 
 
-- 
2.0.0

