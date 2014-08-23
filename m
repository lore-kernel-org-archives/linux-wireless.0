Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:54374 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbaHWH7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:35 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 08/18] ath9k: Make ath_chanctx_offchan_switch static
Date: Sat, 23 Aug 2014 13:29:13 +0530
Message-Id: <1408780763-27974-9-git-send-email-sujith@msujith.org> (sfid-20140823_101533_018244_1B86EE3A)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 --
 drivers/net/wireless/ath/ath9k/channel.c | 26 +++++++++++++-------------
 2 files changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 3b4201c..a77abe7 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -420,8 +420,6 @@ void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
 			struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
-void ath_chanctx_offchan_switch(struct ath_softc *sc,
-				struct ieee80211_channel *chan);
 struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc,
 					      bool active);
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 8214b32..7c71787 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -244,19 +244,6 @@ struct ath_chanctx *ath_chanctx_get_oper_chan(struct ath_softc *sc, bool active)
 	return &sc->chanctx[0];
 }
 
-void ath_chanctx_offchan_switch(struct ath_softc *sc,
-				struct ieee80211_channel *chan)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-	struct cfg80211_chan_def chandef;
-
-	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
-	ath_dbg(common, CHAN_CTX,
-		"Channel definition created: %d MHz\n", chandef.center_freq1);
-
-	ath_chanctx_switch(sc, &sc->offchannel.chan, &chandef);
-}
-
 static struct ath_chanctx *
 ath_chanctx_get_next(struct ath_softc *sc, struct ath_chanctx *ctx)
 {
@@ -537,6 +524,19 @@ static int ath_scan_channel_duration(struct ath_softc *sc,
 	return (HZ / 16); /* ~60 ms */
 }
 
+static void ath_chanctx_offchan_switch(struct ath_softc *sc,
+				       struct ieee80211_channel *chan)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct cfg80211_chan_def chandef;
+
+	cfg80211_chandef_create(&chandef, chan, NL80211_CHAN_NO_HT);
+	ath_dbg(common, CHAN_CTX,
+		"Channel definition created: %d MHz\n", chandef.center_freq1);
+
+	ath_chanctx_switch(sc, &sc->offchannel.chan, &chandef);
+}
+
 static void
 ath_scan_next_channel(struct ath_softc *sc)
 {
-- 
2.0.4

