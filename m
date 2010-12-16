Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30s.wh2.ocn.ne.jp ([125.206.180.198]:13033 "HELO
	mail30s.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751364Ab0LPHVg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 02:21:36 -0500
Received: from vs3016.wh2.ocn.ne.jp (125.206.180.189)
	by mail30s.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-091254093
	for <linux-wireless@vger.kernel.org>; Thu, 16 Dec 2010 16:21:34 +0900 (JST)
Subject: [PATCH] ath5k: Fix survey
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@lists.ath5k.org, jonathan@guerin.id.au,
	linux-wireless@vger.kernel.org
Date: Thu, 16 Dec 2010 16:22:20 +0900
Message-ID: <20101216072219.2136.80015.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The old survey implementation was broken and returned nonsense data.

Clear cycle counters and survey data on reset. Since the cycle counters easily
overflow it's better to keep a local version of collected survey data (in ms
resolution, instead of clockrate) and update this every time survey is
retrieved. If survey is retrieved often enough to avoid cycle counter overflows
this works fine, otherwise we could update survey more often, like ath9k does.
Still only the survey for the current channel is kept.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   35 ++++++++++++++++++++++-----------
 drivers/net/wireless/ath/ath5k/base.h |    2 ++
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3c65fef..e4ec40c 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2658,6 +2658,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 							bool skip_pcu)
 {
 	struct ath5k_hw *ah = sc->ah;
+	struct ath_common *common = ath5k_hw_common(ah);
 	int ret, ani_mode;
 
 	ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "resetting\n");
@@ -2700,6 +2701,14 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan,
 	ah->ah_cal_next_nf = jiffies;
 	ewma_init(&ah->ah_beacon_rssi_avg, 1024, 8);
 
+	/* clear survey data and cycle counters */
+	memset(&sc->survey, 0, sizeof(sc->survey));
+	spin_lock(&common->cc_lock);
+	ath_hw_cycle_counters_update(common);
+	memset(&common->cc_survey, 0, sizeof(common->cc_survey));
+	memset(&common->cc_ani, 0, sizeof(common->cc_ani));
+	spin_unlock(&common->cc_lock);
+
 	/*
 	 * Change channels and update the h/w rate map if we're switching;
 	 * e.g. 11a to 11b/g.
@@ -3366,25 +3375,27 @@ static int ath5k_get_survey(struct ieee80211_hw *hw, int idx,
 	if (idx != 0)
 		return -ENOENT;
 
-	survey->channel = conf->channel;
-	survey->filled = SURVEY_INFO_NOISE_DBM;
-	survey->noise = sc->ah->ah_noise_floor;
-
 	spin_lock_bh(&common->cc_lock);
 	ath_hw_cycle_counters_update(common);
 	if (cc->cycles > 0) {
-		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
-			SURVEY_INFO_CHANNEL_TIME_BUSY |
-			SURVEY_INFO_CHANNEL_TIME_RX |
-			SURVEY_INFO_CHANNEL_TIME_TX;
-		survey->channel_time += cc->cycles / div;
-		survey->channel_time_busy += cc->rx_busy / div;
-		survey->channel_time_rx += cc->rx_frame / div;
-		survey->channel_time_tx += cc->tx_frame / div;
+		sc->survey.channel_time += cc->cycles / div;
+		sc->survey.channel_time_busy += cc->rx_busy / div;
+		sc->survey.channel_time_rx += cc->rx_frame / div;
+		sc->survey.channel_time_tx += cc->tx_frame / div;
 	}
 	memset(cc, 0, sizeof(*cc));
 	spin_unlock_bh(&common->cc_lock);
 
+	memcpy(survey, &sc->survey, sizeof(*survey));
+
+	survey->channel = conf->channel;
+	survey->noise = sc->ah->ah_noise_floor;
+	survey->filled = SURVEY_INFO_NOISE_DBM |
+			SURVEY_INFO_CHANNEL_TIME |
+			SURVEY_INFO_CHANNEL_TIME_BUSY |
+			SURVEY_INFO_CHANNEL_TIME_RX |
+			SURVEY_INFO_CHANNEL_TIME_TX;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index aa6c32a..6d51147 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -258,6 +258,8 @@ struct ath5k_softc {
 	struct tasklet_struct	ani_tasklet;	/* ANI calibration */
 
 	struct delayed_work	tx_complete_work;
+
+	struct survey_info	survey;		/* collected survey info */
 };
 
 #define ath5k_hw_hasbssidmask(_ah) \

