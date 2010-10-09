Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:40928 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759999Ab0JIAjg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Oct 2010 20:39:36 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org, linville@tuxdriver.com
Cc: lrodriguez@atheros.com, br1@einfach.org
Subject: [PATCH 3/3] ath9k: implement channel utilization stats for survey
Date: Sat,  9 Oct 2010 02:39:31 +0200
Message-Id: <1286584771-76663-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1286584771-76663-2-git-send-email-nbd@openwrt.org>
References: <1286584771-76663-1-git-send-email-nbd@openwrt.org>
 <1286584771-76663-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Results for the active channel are updated whenever a new survey dump
is requested, the old data is kept to allow multiple processes to
make their own channel utilization averages.
All other channels only contain the data for the last time that the
hardware was on the channel, i.e. the last scan result or other
off-channel activity.
Running a background scan does not clear the data for the active
channel.

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/ath9k.h |    2 +
 drivers/net/wireless/ath/ath9k/main.c  |  103 +++++++++++++++++++++++++++----
 2 files changed, 91 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ath9k.h b/drivers/net/wireless/ath/ath9k/ath9k.h
index de2b18e..4e81fe3 100644
--- a/drivers/net/wireless/ath/ath9k/ath9k.h
+++ b/drivers/net/wireless/ath/ath9k/ath9k.h
@@ -593,6 +593,8 @@ struct ath_softc {
 	struct delayed_work wiphy_work;
 	unsigned long wiphy_scheduler_int;
 	int wiphy_scheduler_index;
+	struct survey_info *cur_survey;
+	struct survey_info survey[ATH9K_NUM_CHANNELS];
 
 	struct tasklet_struct intr_tq;
 	struct tasklet_struct bcon_tasklet;
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 360c6f5..8094a51 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -175,6 +175,49 @@ static void ath_start_ani(struct ath_common *common)
 			msecs_to_jiffies((u32)ah->config.ani_poll_interval));
 }
 
+static void ath_update_survey_nf(struct ath_softc *sc, int channel)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath9k_channel *chan = &ah->channels[channel];
+	struct survey_info *survey = &sc->survey[channel];
+
+	if (chan->noisefloor) {
+		survey->filled |= SURVEY_INFO_NOISE_DBM;
+		survey->noise = chan->noisefloor;
+	}
+}
+
+static void ath_update_survey_stats(struct ath_softc *sc)
+{
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	int pos = ah->curchan - &ah->channels[0];
+	struct survey_info *survey = &sc->survey[pos];
+	struct ath_cycle_counters *cc = &common->cc_survey;
+	unsigned long flags;
+	unsigned int div = common->clockrate * 1000;
+
+	spin_lock_irqsave(&common->cc_lock, flags);
+
+	ath_hw_cycle_counters_update(common);
+
+	if (cc->cycles > 0) {
+		survey->filled |= SURVEY_INFO_CHANNEL_TIME |
+			SURVEY_INFO_CHANNEL_TIME_BUSY |
+			SURVEY_INFO_CHANNEL_TIME_RX |
+			SURVEY_INFO_CHANNEL_TIME_TX;
+		survey->channel_time += cc->cycles / div;
+		survey->channel_time_busy += cc->rx_busy / div;
+		survey->channel_time_rx += cc->rx_frame / div;
+		survey->channel_time_tx += cc->tx_frame / div;
+	}
+	memset(cc, 0, sizeof(*cc));
+
+	ath_update_survey_nf(sc, pos);
+
+	spin_unlock_irqrestore(&common->cc_lock, flags);
+}
+
 /*
  * Set/change channels.  If the channel is really being changed, it's done
  * by reseting the chip.  To accomplish this we must first cleanup any pending
@@ -1532,7 +1575,8 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
 	bool disable_radio;
 
@@ -1598,6 +1642,10 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
 		struct ieee80211_channel *curchan = hw->conf.channel;
 		int pos = curchan->hw_value;
+		int old_pos = -1;
+
+		if (ah->curchan)
+			old_pos = ah->curchan - &ah->channels[0];
 
 		aphy->chan_idx = pos;
 		aphy->chan_is_ht = conf_is_ht(conf);
@@ -1625,12 +1673,43 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 
 		ath_update_chainmask(sc, conf_is_ht(conf));
 
+		/* update survey stats for the old channel before switching */
+		ath_update_survey_stats(sc);
+
+		/*
+		 * If the operating channel changes, change the survey in-use flags
+		 * along with it.
+		 * Reset the survey data for the new channel, unless we're switching
+		 * back to the operating channel from an off-channel operation.
+		 */
+		if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) &&
+		    sc->cur_survey != &sc->survey[pos]) {
+
+			if (sc->cur_survey)
+				sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
+
+			sc->cur_survey = &sc->survey[pos];
+
+			memset(sc->cur_survey, 0, sizeof(struct survey_info));
+			sc->cur_survey->filled |= SURVEY_INFO_IN_USE;
+		} else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE)) {
+			memset(&sc->survey[pos], 0, sizeof(struct survey_info));
+		}
+
 		if (ath_set_channel(sc, hw, &sc->sc_ah->channels[pos]) < 0) {
 			ath_print(common, ATH_DBG_FATAL,
 				  "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			return -EINVAL;
 		}
+
+		/*
+		 * The most recent snapshot of channel->noisefloor for the old
+		 * channel is only available after the hardware reset. Copy it to
+		 * the survey stats now.
+		 */
+		if (old_pos >= 0)
+			ath_update_survey_nf(sc, old_pos);
 	}
 
 skip_chan_change:
@@ -2000,9 +2079,12 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 {
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
-	struct ath_hw *ah = sc->sc_ah;
 	struct ieee80211_supported_band *sband;
-	struct ath9k_channel *chan;
+	struct ieee80211_channel *chan;
+	int pos;
+
+	if (idx == 0)
+		ath_update_survey_stats(sc);
 
 	sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
 	if (sband && idx >= sband->n_channels) {
@@ -2016,17 +2098,10 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	if (!sband || idx >= sband->n_channels)
 	    return -ENOENT;
 
-	survey->channel = &sband->channels[idx];
-	chan = &ah->channels[survey->channel->hw_value];
-	survey->filled = 0;
-
-	if (chan == ah->curchan)
-		survey->filled |= SURVEY_INFO_IN_USE;
-
-	if (chan->noisefloor) {
-		survey->filled |= SURVEY_INFO_NOISE_DBM;
-		survey->noise = chan->noisefloor;
-	}
+	chan = &sband->channels[idx];
+	pos = chan->hw_value;
+	memcpy(survey, &sc->survey[pos], sizeof(*survey));
+	survey->channel = chan;
 
 	return 0;
 }
-- 
1.7.2.2

