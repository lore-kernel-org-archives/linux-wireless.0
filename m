Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:57520 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab0I2RMK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 13:12:10 -0400
Message-ID: <4CA37366.3040906@openwrt.org>
Date: Wed, 29 Sep 2010 19:12:06 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Paul Stewart <pstew@google.com>
CC: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: [PATCH v2 6/6] ath9k: return survey data for all channels instead
 of just the current one
References: <1285773331-73439-1-git-send-email-nbd@openwrt.org>	<1285773331-73439-2-git-send-email-nbd@openwrt.org>	<1285773331-73439-3-git-send-email-nbd@openwrt.org>	<1285773331-73439-4-git-send-email-nbd@openwrt.org>	<1285773331-73439-5-git-send-email-nbd@openwrt.org>	<1285773331-73439-6-git-send-email-nbd@openwrt.org> <AANLkTim1MuVoJnOqeBQtKzTNLK=2Pf4SpMw4MiQHPeB2@mail.gmail.com>
In-Reply-To: <AANLkTim1MuVoJnOqeBQtKzTNLK=2Pf4SpMw4MiQHPeB2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
v2: add a missing null pointer check for 5ghz sband (thx, paul)

 drivers/net/wireless/ath/ath9k/main.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a801a08..49ea458 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1994,16 +1994,31 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ieee80211_conf *conf = &hw->conf;
+	struct ieee80211_supported_band *sband;
+	struct ath9k_channel *chan;
+
+	sband = hw->wiphy->bands[IEEE80211_BAND_2GHZ];
+	if (sband && idx >= sband->n_channels) {
+		idx -= sband->n_channels;
+		sband = NULL;
+	}
 
-	 if (idx != 0)
-		return -ENOENT;
+	if (!sband)
+		sband = hw->wiphy->bands[IEEE80211_BAND_5GHZ];
 
-	survey->channel = conf->channel;
+	if (!sband || idx >= sband->n_channels)
+	    return -ENOENT;
+
+	survey->channel = &sband->channels[idx];
+	chan = &ah->channels[survey->channel->hw_value];
 	survey->filled = 0;
-	if (ah->curchan && ah->curchan->noisefloor) {
+
+	if (chan == ah->curchan)
+		survey->filled |= SURVEY_INFO_IN_USE;
+
+	if (chan->noisefloor) {
 		survey->filled |= SURVEY_INFO_NOISE_DBM;
-		survey->noise = ah->curchan->noisefloor;
+		survey->noise = chan->noisefloor;
 	}
 
 	return 0;

