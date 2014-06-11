Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:19559 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032AbaFKKtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 06:49:43 -0400
From: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: [PATCH 17/28] ath9k: Store current offchannel duration
Date: Wed, 11 Jun 2014 16:18:05 +0530
Message-ID: <1402483696-2498-18-git-send-email-rmanohar@qti.qualcomm.com> (sfid-20140611_124946_435927_D4530BA5)
In-Reply-To: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
References: <1402483696-2498-1-git-send-email-rmanohar@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Update current offchannel duration during scan or roc request.

Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |  1 +
 drivers/net/wireless/ath/ath9k/main.c  | 28 +++++++++++++++++++---------
 2 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index b657115..6487c47 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -385,6 +385,7 @@ struct ath_offchannel {
 	struct ieee80211_channel *roc_chan;
 	struct ieee80211_vif *roc_vif;
 	int roc_duration;
+	int duration;
 };
 #define ath_for_each_chanctx(_sc, _ctx)                             \
 	for (ctx = &sc->chanctx[0];                                 \
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2393af0..0ba496d 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2171,6 +2171,17 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	clear_bit(ATH_OP_SCANNING, &common->op_flags);
 }
 
+static int ath_scan_channel_duration(struct ath_softc *sc,
+				     struct ieee80211_channel *chan)
+{
+	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
+
+	if (!req->n_ssids || (chan->flags & IEEE80211_CHAN_NO_IR))
+		return (HZ / 9); /* ~110 ms */
+
+	return (HZ / 16); /* ~60 ms */
+}
+
 static void
 ath_scan_next_channel(struct ath_softc *sc)
 {
@@ -2185,6 +2196,7 @@ ath_scan_next_channel(struct ath_softc *sc)
 	}
 
 	chan = req->channels[sc->offchannel.scan_idx++];
+	sc->offchannel.duration = ath_scan_channel_duration(sc, chan);
 	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_SEND;
 	ath_chanctx_offchan_switch(sc, chan);
 }
@@ -2200,6 +2212,7 @@ static void ath_offchannel_next(struct ath_softc *sc)
 	} else if (sc->offchannel.roc_vif) {
 		vif = sc->offchannel.roc_vif;
 		sc->offchannel.chan.txpower = vif->bss_conf.txpower;
+		sc->offchannel.duration = sc->offchannel.roc_duration;
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_START;
 		ath_chanctx_offchan_switch(sc, sc->offchannel.roc_chan);
 	} else {
@@ -2275,20 +2288,17 @@ error:
 static void ath_scan_channel_start(struct ath_softc *sc)
 {
 	struct cfg80211_scan_request *req = sc->offchannel.scan_req;
-	int i, dwell;
-
-	if ((sc->cur_chan->chandef.chan->flags & IEEE80211_CHAN_NO_IR) ||
-			!req->n_ssids) {
-		dwell = HZ / 9; /* ~110 ms */
-	} else {
-		dwell = HZ / 16; /* ~60 ms */
+	int i;
 
+	if (!(sc->cur_chan->chandef.chan->flags & IEEE80211_CHAN_NO_IR) &&
+	    req->n_ssids) {
 		for (i = 0; i < req->n_ssids; i++)
 			ath_scan_send_probe(sc, &req->ssids[i]);
+
 	}
 
 	sc->offchannel.state = ATH_OFFCHANNEL_PROBE_WAIT;
-	mod_timer(&sc->offchannel.timer, jiffies + dwell);
+	mod_timer(&sc->offchannel.timer, jiffies + sc->offchannel.duration);
 }
 
 void ath_offchannel_channel_change(struct ath_softc *sc)
@@ -2316,7 +2326,7 @@ void ath_offchannel_channel_change(struct ath_softc *sc)
 
 		sc->offchannel.state = ATH_OFFCHANNEL_ROC_WAIT;
 		mod_timer(&sc->offchannel.timer, jiffies +
-			  msecs_to_jiffies(sc->offchannel.roc_duration));
+			  msecs_to_jiffies(sc->offchannel.duration));
 		ieee80211_ready_on_channel(sc->hw);
 		break;
 	case ATH_OFFCHANNEL_ROC_DONE:
-- 
2.0.0

