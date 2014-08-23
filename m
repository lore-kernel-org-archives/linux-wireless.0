Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49130 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588AbaHWH7f (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Aug 2014 03:59:35 -0400
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com
Subject: [PATCH 10/18] ath9k: Make ath_chanctx_switch static
Date: Sat, 23 Aug 2014 13:29:15 +0530
Message-Id: <1408780763-27974-11-git-send-email-sujith@msujith.org> (sfid-20140823_101533_355806_85E8784F)
In-Reply-To: <1408780763-27974-1-git-send-email-sujith@msujith.org>
References: <1408780763-27974-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h   |  2 -
 drivers/net/wireless/ath/ath9k/channel.c | 74 ++++++++++++++++----------------
 2 files changed, 37 insertions(+), 39 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index 0371b30..2afe790 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -417,8 +417,6 @@ ath_chanctx_get(struct ieee80211_chanctx_conf *ctx)
 void ath_chanctx_init(struct ath_softc *sc);
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef);
-void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
-			struct cfg80211_chan_def *chandef);
 void ath_chanctx_check_active(struct ath_softc *sc, struct ath_chanctx *ctx);
 void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
 		       enum ath_chanctx_event ev);
diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
index 1950da4..ceb3ce8 100644
--- a/drivers/net/wireless/ath/ath9k/channel.c
+++ b/drivers/net/wireless/ath/ath9k/channel.c
@@ -173,43 +173,6 @@ void ath_chanctx_init(struct ath_softc *sc)
 
 }
 
-void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
-			struct cfg80211_chan_def *chandef)
-{
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
-
-	spin_lock_bh(&sc->chan_lock);
-
-	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) &&
-	    (sc->cur_chan != ctx) && (ctx == &sc->offchannel.chan)) {
-		sc->sched.offchannel_pending = true;
-		spin_unlock_bh(&sc->chan_lock);
-		return;
-	}
-
-	sc->next_chan = ctx;
-	if (chandef) {
-		ctx->chandef = *chandef;
-		ath_dbg(common, CHAN_CTX,
-			"Assigned next_chan to %d MHz\n", chandef->center_freq1);
-	}
-
-	if (sc->next_chan == &sc->offchannel.chan) {
-		sc->sched.offchannel_duration =
-			TU_TO_USEC(sc->offchannel.duration) +
-			sc->sched.channel_switch_time;
-
-		if (chandef) {
-			ath_dbg(common, CHAN_CTX,
-				"Offchannel duration for chan %d MHz : %u\n",
-				chandef->center_freq1,
-				sc->sched.offchannel_duration);
-		}
-	}
-	spin_unlock_bh(&sc->chan_lock);
-	ieee80211_queue_work(sc->hw, &sc->chanctx_work);
-}
-
 void ath_chanctx_set_channel(struct ath_softc *sc, struct ath_chanctx *ctx,
 			     struct cfg80211_chan_def *chandef)
 {
@@ -507,6 +470,43 @@ static int ath_scan_channel_duration(struct ath_softc *sc,
 	return (HZ / 16); /* ~60 ms */
 }
 
+static void ath_chanctx_switch(struct ath_softc *sc, struct ath_chanctx *ctx,
+			       struct cfg80211_chan_def *chandef)
+{
+	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+
+	spin_lock_bh(&sc->chan_lock);
+
+	if (test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) &&
+	    (sc->cur_chan != ctx) && (ctx == &sc->offchannel.chan)) {
+		sc->sched.offchannel_pending = true;
+		spin_unlock_bh(&sc->chan_lock);
+		return;
+	}
+
+	sc->next_chan = ctx;
+	if (chandef) {
+		ctx->chandef = *chandef;
+		ath_dbg(common, CHAN_CTX,
+			"Assigned next_chan to %d MHz\n", chandef->center_freq1);
+	}
+
+	if (sc->next_chan == &sc->offchannel.chan) {
+		sc->sched.offchannel_duration =
+			TU_TO_USEC(sc->offchannel.duration) +
+			sc->sched.channel_switch_time;
+
+		if (chandef) {
+			ath_dbg(common, CHAN_CTX,
+				"Offchannel duration for chan %d MHz : %u\n",
+				chandef->center_freq1,
+				sc->sched.offchannel_duration);
+		}
+	}
+	spin_unlock_bh(&sc->chan_lock);
+	ieee80211_queue_work(sc->hw, &sc->chanctx_work);
+}
+
 static void ath_chanctx_offchan_switch(struct ath_softc *sc,
 				       struct ieee80211_channel *chan)
 {
-- 
2.0.4

