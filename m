Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:37380 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754627Ab3JJMPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Oct 2013 08:15:21 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com
Subject: [PATCH 07/10] ath9k: move channel change code to ath_set_channel
Date: Thu, 10 Oct 2013 14:15:09 +0200
Message-Id: <1381407312-72719-7-git-send-email-nbd@openwrt.org> (sfid-20131010_141532_683906_1DD87AAB)
In-Reply-To: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
References: <1381407312-72719-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Preparation for adding the scanning state machine to ath9k

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c | 150 ++++++++++++++++++----------------
 1 file changed, 78 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 2a86047..bc89823 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -312,17 +312,91 @@ out:
  * by reseting the chip.  To accomplish this we must first cleanup any pending
  * DMA, then restart stuff.
 */
-static int ath_set_channel(struct ath_softc *sc, struct ieee80211_hw *hw,
-		    struct ath9k_channel *hchan)
+static int ath_set_channel(struct ath_softc *sc, struct cfg80211_chan_def *chandef)
 {
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_hw *hw = sc->hw;
+	struct ath9k_channel *hchan;
+	struct ieee80211_channel *chan = chandef->chan;
+	unsigned long flags;
+	bool offchannel;
+	int pos = chan->hw_value;
+	int old_pos = -1;
 	int r;
 
 	if (test_bit(SC_OP_INVALID, &sc->sc_flags))
 		return -EIO;
 
+	offchannel = !!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL);
+
+	if (ah->curchan)
+		old_pos = ah->curchan - &ah->channels[0];
+
+	ath_dbg(common, CONFIG, "Set channel: %d MHz width: %d\n",
+		chan->center_freq, chandef->width);
+
+	/* update survey stats for the old channel before switching */
+	spin_lock_irqsave(&common->cc_lock, flags);
+	ath_update_survey_stats(sc);
+	spin_unlock_irqrestore(&common->cc_lock, flags);
+
+	ath9k_cmn_get_channel(hw, ah, chandef);
+
+	/*
+	 * If the operating channel changes, change the survey in-use flags
+	 * along with it.
+	 * Reset the survey data for the new channel, unless we're switching
+	 * back to the operating channel from an off-channel operation.
+	 */
+	if (!offchannel && sc->cur_survey != &sc->survey[pos]) {
+		if (sc->cur_survey)
+			sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
+
+		sc->cur_survey = &sc->survey[pos];
+
+		memset(sc->cur_survey, 0, sizeof(struct survey_info));
+		sc->cur_survey->filled |= SURVEY_INFO_IN_USE;
+	} else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE)) {
+		memset(&sc->survey[pos], 0, sizeof(struct survey_info));
+	}
+
+	hchan = &sc->sc_ah->channels[pos];
 	r = ath_reset_internal(sc, hchan);
+	if (r)
+		return r;
 
-	return r;
+	/*
+	 * The most recent snapshot of channel->noisefloor for the old
+	 * channel is only available after the hardware reset. Copy it to
+	 * the survey stats now.
+	 */
+	if (old_pos >= 0)
+		ath_update_survey_nf(sc, old_pos);
+
+	/*
+	 * Enable radar pulse detection if on a DFS channel. Spectral
+	 * scanning and radar detection can not be used concurrently.
+	 */
+	if (hw->conf.radar_enabled) {
+		u32 rxfilter;
+
+		/* set HW specific DFS configuration */
+		ath9k_hw_set_radar_params(ah);
+		rxfilter = ath9k_hw_getrxfilter(ah);
+		rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
+				ATH9K_RX_FILTER_PHYERR;
+		ath9k_hw_setrxfilter(ah, rxfilter);
+		ath_dbg(common, DFS, "DFS enabled at freq %d\n",
+			chan->center_freq);
+	} else {
+		/* perform spectral scan if requested. */
+		if (test_bit(SC_OP_SCANNING, &sc->sc_flags) &&
+			sc->spectral_mode == SPECTRAL_CHANSCAN)
+			ath9k_spectral_scan_trigger(hw);
+	}
+
+	return 0;
 }
 
 static void ath_node_attach(struct ath_softc *sc, struct ieee80211_sta *sta,
@@ -1207,80 +1281,12 @@ static int ath9k_config(struct ieee80211_hw *hw, u32 changed)
 	}
 
 	if ((changed & IEEE80211_CONF_CHANGE_CHANNEL) || reset_channel) {
-		struct ieee80211_channel *curchan = hw->conf.chandef.chan;
-		int pos = curchan->hw_value;
-		int old_pos = -1;
-		unsigned long flags;
-
-		if (ah->curchan)
-			old_pos = ah->curchan - &ah->channels[0];
-
-		ath_dbg(common, CONFIG, "Set channel: %d MHz width: %d\n",
-			curchan->center_freq, hw->conf.chandef.width);
-
-		/* update survey stats for the old channel before switching */
-		spin_lock_irqsave(&common->cc_lock, flags);
-		ath_update_survey_stats(sc);
-		spin_unlock_irqrestore(&common->cc_lock, flags);
-
-		ath9k_cmn_get_channel(hw, ah, &conf->chandef);
-
-		/*
-		 * If the operating channel changes, change the survey in-use flags
-		 * along with it.
-		 * Reset the survey data for the new channel, unless we're switching
-		 * back to the operating channel from an off-channel operation.
-		 */
-		if (!(hw->conf.flags & IEEE80211_CONF_OFFCHANNEL) &&
-		    sc->cur_survey != &sc->survey[pos]) {
-
-			if (sc->cur_survey)
-				sc->cur_survey->filled &= ~SURVEY_INFO_IN_USE;
-
-			sc->cur_survey = &sc->survey[pos];
-
-			memset(sc->cur_survey, 0, sizeof(struct survey_info));
-			sc->cur_survey->filled |= SURVEY_INFO_IN_USE;
-		} else if (!(sc->survey[pos].filled & SURVEY_INFO_IN_USE)) {
-			memset(&sc->survey[pos], 0, sizeof(struct survey_info));
-		}
-
-		if (ath_set_channel(sc, hw, &sc->sc_ah->channels[pos]) < 0) {
+		if (ath_set_channel(sc, &hw->conf.chandef) < 0) {
 			ath_err(common, "Unable to set channel\n");
 			mutex_unlock(&sc->mutex);
 			ath9k_ps_restore(sc);
 			return -EINVAL;
 		}
-
-		/*
-		 * The most recent snapshot of channel->noisefloor for the old
-		 * channel is only available after the hardware reset. Copy it to
-		 * the survey stats now.
-		 */
-		if (old_pos >= 0)
-			ath_update_survey_nf(sc, old_pos);
-
-		/*
-		 * Enable radar pulse detection if on a DFS channel. Spectral
-		 * scanning and radar detection can not be used concurrently.
-		 */
-		if (hw->conf.radar_enabled) {
-			u32 rxfilter;
-
-			/* set HW specific DFS configuration */
-			ath9k_hw_set_radar_params(ah);
-			rxfilter = ath9k_hw_getrxfilter(ah);
-			rxfilter |= ATH9K_RX_FILTER_PHYRADAR |
-				    ATH9K_RX_FILTER_PHYERR;
-			ath9k_hw_setrxfilter(ah, rxfilter);
-			ath_dbg(common, DFS, "DFS enabled at freq %d\n",
-				curchan->center_freq);
-		} else {
-			/* perform spectral scan if requested. */
-			if (test_bit(SC_OP_SCANNING, &sc->sc_flags) &&
-			    sc->spectral_mode == SPECTRAL_CHANSCAN)
-				ath9k_spectral_scan_trigger(hw);
-		}
 	}
 
 	if (changed & IEEE80211_CONF_CHANGE_POWER) {
-- 
1.8.0.2

