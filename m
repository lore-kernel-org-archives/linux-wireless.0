Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.21]:49365 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3LZCtn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Dec 2013 21:49:43 -0500
From: Sujith Manoharan <sujith@msujith.org>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH v2] ath9k: Fix "cc_lock" usage
Date: Thu, 26 Dec 2013 08:14:40 +0530
Message-Id: <1388025880-30230-1-git-send-email-sujith@msujith.org> (sfid-20131226_034947_008426_0FD9095E)
In-Reply-To: <1387862067-25457-11-git-send-email-sujith@msujith.org>
References: <1387862067-25457-11-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Sujith Manoharan <c_manoha@qca.qualcomm.com>

IRQ save/restore is not required for the cycle counters
since they are accessed only from softirq and process context.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
v2 : Avoid the warning,
     "WARNING: CPU: 0 PID: 0 at /home/sujith/dev/wireless-testing/kernel/softirq.c:156 local_bh_enable_ip+0x92/0xd0()"
     
 drivers/net/wireless/ath/ath9k/link.c |  4 ++--
 drivers/net/wireless/ath/ath9k/main.c | 12 +++++-------
 2 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/link.c b/drivers/net/wireless/ath/ath9k/link.c
index c92ca81..30dcef5 100644
--- a/drivers/net/wireless/ath/ath9k/link.c
+++ b/drivers/net/wireless/ath/ath9k/link.c
@@ -362,10 +362,10 @@ void ath_ani_calibrate(unsigned long data)
 
 	/* Call ANI routine if necessary */
 	if (aniflag) {
-		spin_lock_irqsave(&common->cc_lock, flags);
+		spin_lock(&common->cc_lock);
 		ath9k_hw_ani_monitor(ah, ah->curchan);
 		ath_update_survey_stats(sc);
-		spin_unlock_irqrestore(&common->cc_lock, flags);
+		spin_unlock(&common->cc_lock);
 	}
 
 	/* Perform calibration if necessary */
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3900fa5..2f3e7b4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
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

