Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:55192 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757288Ab0D0WIf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Apr 2010 18:08:35 -0400
From: Benoit Papillault <benoit.papillault@free.fr>
To: lrodriguez@atheros.com, jmalinen@atheros.com
Cc: ath9k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	Benoit Papillault <benoit.papillault@free.fr>
Subject: [PATCH] ath9k: Added get_survey callback in order to get channel noise
Date: Wed, 28 Apr 2010 00:08:24 +0200
Message-Id: <1272406104-6870-1-git-send-email-benoit.papillault@free.fr>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Benoit Papillault <benoit.papillault@free.fr>
---
 drivers/net/wireless/ath/ath9k/main.c |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c03821e..f0b2aa2 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2047,6 +2047,25 @@ static int ath9k_ampdu_action(struct ieee80211_hw *hw,
 	return ret;
 }
 
+static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
+			     struct survey_info *survey)
+{
+	struct ath_wiphy *aphy = hw->priv;
+	struct ath_softc *sc = aphy->sc;
+	struct ath_hw *ah = sc->sc_ah;
+	struct ath_common *common = ath9k_hw_common(ah);
+	struct ieee80211_conf *conf = &hw->conf;
+
+	 if (idx != 0)
+		return -ENOENT;
+
+	survey->channel = conf->channel;
+	survey->filled = SURVEY_INFO_NOISE_DBM;
+	survey->noise = common->ani.noise_floor;
+
+	return 0;
+}
+
 static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 {
 	struct ath_wiphy *aphy = hw->priv;
@@ -2122,6 +2141,7 @@ struct ieee80211_ops ath9k_ops = {
 	.set_tsf 	    = ath9k_set_tsf,
 	.reset_tsf 	    = ath9k_reset_tsf,
 	.ampdu_action       = ath9k_ampdu_action,
+	.get_survey	    = ath9k_get_survey,
 	.sw_scan_start      = ath9k_sw_scan_start,
 	.sw_scan_complete   = ath9k_sw_scan_complete,
 	.rfkill_poll        = ath9k_rfkill_poll_state,
-- 
1.5.6.5

