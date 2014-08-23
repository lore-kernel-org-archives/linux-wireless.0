Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:40911 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaHWNmS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 09:42:18 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 4/4] ath9k: Fix ath_chanctx_get()
Date: Sat, 23 Aug 2014 19:12:16 +0530
Message-Id: <1408801336-7626-5-git-send-email-sujith@msujith.org> (sfid-20140823_154224_426204_CB86D0FC)
In-Reply-To: <1408801336-7626-1-git-send-email-sujith@msujith.org>
References: <1408801336-7626-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Move it inside a CONFIG_ATH9K_CHANNEL_CONTEXT ifdef
since it is not needed otherwise.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 9e61679..acbe2b7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -413,16 +413,19 @@ struct ath_offchannel {
 	     ctx <= &sc->chanctx[ARRAY_SIZE(sc->chanctx) - 1];      \
 	     ctx++)
 
+void ath_chanctx_init(struct ath_softc *sc);
+void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
+			     struct cfg80211_chan_def *chandef);
+
+#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
 static inline struct ath_chanctx *
 ath_chanctx_get(struct ieee80211_chanctx_conf *ctx)
 {
 	struct ath_chanctx **ptr = (void *) ctx->drv_priv;
 	return *ptr;
 }
-void ath_chanctx_init(struct ath_softc *sc);
-void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
-			     struct cfg80211_chan_def *chandef);
-#ifdef CONFIG_ATH9K_CHANNEL_CONTEXT
+
 bool ath9k_is_chanctx_enabled(void);
 void ath9k_fill_chanctx_ops(void);
 void ath9k_init_channel_context(struct ath_softc *sc);
@@ -451,7 +454,9 @@ void ath_chanctx_set_next(struct ath_softc *sc, bool force);
 void ath_offchannel_next(struct ath_softc *sc);
 void ath_scan_complete(struct ath_softc *sc, bool abort);
 void ath_roc_complete(struct ath_softc *sc, bool abort);
+
 #else
+
 static inline bool ath9k_is_chanctx_enabled(void)
 {
 	return false;
@@ -513,6 +518,7 @@ static inline void ath_chanctx_check_active(struct ath_softc *sc,
 					    struct ath_chanctx *ctx)
 {
 }
+
 #endif /* CONFIG_ATH9K_CHANNEL_CONTEXT */
 
 int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan);
-- 
2.0.4

