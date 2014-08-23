Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49705 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaHWH7o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:44 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 15/18] ath9k: Add ath9k_offchannel_init
Date: Sat, 23 Aug 2014 13:29:20 +0530
Message-Id: <1408780763-27974-16-git-send-email-sujith@msujith.org> (sfid-20140823_101533_730123_058E7F07)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

This patch adds a routine to setup the offchannel
instance in ath_softc.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  4 ++++
 drivers/net/wireless/ath/ath9k/channel.c | 33 ++++++++++++++++++++++++--------
 drivers/net/wireless/ath/ath9k/init.c    |  1 +
 3 files changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 892ca4a..5b8bc5d 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -423,6 +423,7 @@ void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
 bool ath9k_is_chanctx_enabled(void);
 void ath9k_fill_chanctx_ops(void);
 void ath9k_init_channel_context(struct ath_softc *sc);
+void ath9k_offchannel_init(struct ath_softc *sc);
 void ath9k_deinit_channel_context(struct ath_softc *sc);
 int ath9k_init_p2p(struct ath_softc *sc);
 void ath9k_deinit_p2p(struct ath_softc *sc);
@@ -455,6 +456,9 @@ static inline void ath9k_fill_chanctx_ops(void)
 static inline void ath9k_init_channel_context(struct ath_softc *sc)
 {
 }
+static inline void ath9k_offchannel_init(struct ath_softc *sc)
+{
+}
 static inline void ath9k_deinit_channel_context(struct ath_softc *sc)
 {
 }
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index f719c36..d1ad5a2 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -167,14 +167,6 @@ void ath_chanctx_init(struct ath_softc *sc)
 		for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
 			INIT_LIST_HEAD(&ctx->acq[j]);
 	}
-	ctx = &sc->offchannel.chan;
-	cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
-	INIT_LIST_HEAD(&ctx->vifs);
-	ctx->txpower = ATH_TXPOWER_MAX;
-	for (j = 0; j < ARRAY_SIZE(ctx->acq); j++)
-		INIT_LIST_HEAD(&ctx->acq[j]);
-	sc->offchannel.chan.offchannel = true;
-
 }
 
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
@@ -942,6 +934,31 @@ static void ath_chanctx_work(struct work_struct *work)
 	mutex_unlock(&sc->mutex);
 }
 
+void ath9k_offchannel_init(struct ath_softc *sc)
+{
+	struct ath_chanctx *ctx;
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ieee80211_supported_band *sband;
+	struct ieee80211_channel *chan;
+	int i;
+
+	sband = &common->sbands[IEEE80211_BAND_2GHZ];
+	if (!sband->n_channels)
+		sband = &common->sbands[IEEE80211_BAND_5GHZ];
+
+	chan = &sband->channels[0];
+
+	ctx = &sc->offchannel.chan;
+	INIT_LIST_HEAD(&ctx->vifs);
+	ctx->txpower = ATH_TXPOWER_MAX;
+	cfg80211_chandef_create(&ctx->chandef, chan, NL80211_CHAN_HT20);
+
+	for (i = 0; i < ARRAY_SIZE(ctx->acq); i++)
+		INIT_LIST_HEAD(&ctx->acq[i]);
+
+	sc->offchannel.chan.offchannel = true;
+}
+
 void ath9k_init_channel_context(struct ath_softc *sc)
 {
 	INIT_WORK(&sc->chanctx_work, ath_chanctx_work);
diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fe0311a..5887499 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -610,6 +610,7 @@ static int ath9k_init_softc(u16 devid, struct ath_softc *sc,
 	ath9k_init_misc(sc);
 	ath_fill_led_pin(sc);
 	ath_chanctx_init(sc);
+	ath9k_offchannel_init(sc);
 
 	if (common->bus_ops->aspm_init)
 		common->bus_ops->aspm_init(common);
-- 
2.0.4

