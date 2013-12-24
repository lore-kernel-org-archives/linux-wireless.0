Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:42978 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3LXFTm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Dec 2013 00:19:42 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] ath9k: Fix "cc_lock" usage
Date: Tue, 24 Dec 2013 10:44:27 +0530
Message-Id: <1387862067-25457-11-git-send-email-sujith@msujith.org> (sfid-20131224_062000_294051_54A500C9)
In-Reply-To: <1387862067-25457-1-git-send-email-sujith@msujith.org>
References: <1387862067-25457-1-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

IRQ save/restore is not required for the cycle counters
since they are accessed only from softirq and process context.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/link.c |  4 ++--
 drivers/net/wireless/ath/ath9k/main.c | 20 +++++++++-----------
 2 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index c92ca81..2b909bf 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -362,10 +362,10 @@ void ath_ani_calibrate(unsigned long data)
 
 	/* Call ANI routine if necessary */
 	if (aniflag) {
-		spin_lock_irqsave(&common->cc_lock, flags);
+		spin_lock_bh(&common->cc_lock);
 		ath9k_hw_ani_monitor(ah, ah->curchan);
 		ath_update_survey_stats(sc);
-		spin_unlock_irqrestore(&common->cc_lock, flags);
+		spin_unlock_bh(&common->cc_lock);
 	}
 
 	/* Perform calibration if necessary */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3900fa5..5b88572 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -118,11 +118,11 @@ void ath9k_ps_wakeup(struct ath_softc *sc)
 	 * survey data results.
 	 */
 	if (power_mode != ATH9K_PM_AWAKE) {
-		spin_lock(&common->cc_lock);
+		spin_lock_bh(&common->cc_lock);
 		ath_hw_cycle_counters_update(common);
 		memset(&common->cc_survey, 0, sizeof(common->cc_survey));
 		memset(&common->cc_ani, 0, sizeof(common->cc_ani));
-		spin_unlock(&common->cc_lock);
+		spin_unlock_bh(&common->cc_lock);
 	}
 
  unlock:
@@ -157,9 +157,9 @@ void ath9k_ps_restore(struct ath_softc *sc)
 		goto unlock;
 	}
 
-	spin_lock(&common->cc_lock);
+	spin_lock_bh(&common->cc_lock);
 	ath_hw_cycle_counters_update(common);
-	spin_unlock(&common->cc_lock);
+	spin_unlock_bh(&common->cc_lock);
 
 	ath9k_hw_setpower(sc->sc_ah, mode);
 
@@ -330,7 +330,6 @@ static int ath_set_channel(struct ath_softc *sc, struct cfg80211_chan_def *chand
 	struct ieee80211_hw *hw = sc->hw;
 	struct ath9k_channel *hchan;
 	struct ieee80211_channel *chan = chandef->chan;
-	unsigned long flags;
 	bool offchannel;
 	int pos = chan->hw_value;
 	int old_pos = -1;
@@ -348,9 +347,9 @@ static int ath_set_channel(struct ath_softc *sc, struct cfg80211_chan_def *chand
 		chan->center_freq, chandef->width);
 
 	/* update survey stats for the old channel before switching */
-	spin_lock_irqsave(&common->cc_lock, flags);
+	spin_lock_bh(&common->cc_lock);
 	ath_update_survey_stats(sc);
-	spin_unlock_irqrestore(&common->cc_lock, flags);
+	spin_unlock_bh(&common->cc_lock);
 
 	ath9k_cmn_get_channel(hw, ah, chandef);
 
@@ -1789,13 +1788,12 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ieee80211_supported_band *sband;
 	struct ieee80211_channel *chan;
-	unsigned long flags;
 	int pos;
 
 	if (config_enabled(CONFIG_ATH9K_TX99))
 		return -EOPNOTSUPP;
 
-	spin_lock_irqsave(&common->cc_lock, flags);
+	spin_lock_bh(&common->cc_lock);
 	if (idx == 0)
 		ath_update_survey_stats(sc);
 
@@ -1809,7 +1807,7 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 		sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
 
 	if (!sband || idx >= sband->n_channels) {
-		spin_unlock_irqrestore(&common->cc_lock, flags);
+		spin_unlock_bh(&common->cc_lock);
 		return -ENOENT;
 	}
 
@@ -1817,7 +1815,7 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	pos = chan->hw_value;
 	memcpy(survey, &sc->survey[pos], sizeof(*survey));
 	survey->channel = chan;
-	spin_unlock_irqrestore(&common->cc_lock, flags);
+	spin_unlock_bh(&common->cc_lock);
 
 	return 0;
 }
-- 
1.8.5.2

