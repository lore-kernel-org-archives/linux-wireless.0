Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:43708 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753317Ab0I2PPt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 11:15:49 -0400
From: Felix Fietkau <nbd@openwrt.org>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, lrodriguez@atheros.com
Subject: [PATCH 3/6] ath9k: do not return default noise floor values via survey
Date: Wed, 29 Sep 2010 17:15:28 +0200
Message-Id: <1285773331-73439-3-git-send-email-nbd@openwrt.org>
In-Reply-To: <1285773331-73439-2-git-send-email-nbd@openwrt.org>
References: <1285773331-73439-1-git-send-email-nbd@openwrt.org>
 <1285773331-73439-2-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Felix Fietkau <nbd@openwrt.org>
---
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index a133878..fcba402 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2004,15 +2004,17 @@ static int ath9k_get_survey(struct ieee80211_hw *hw, int idx,
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 	struct ieee80211_conf *conf = &hw->conf;
 
 	 if (idx != 0)
 		return -ENOENT;
 
 	survey->channel = conf->channel;
-	survey->filled = SURVEY_INFO_NOISE_DBM;
-	survey->noise = common->ani.noise_floor;
+	survey->filled = 0;
+	if (ah->curchan && ah->curchan->noisefloor) {
+		survey->filled |= SURVEY_INFO_NOISE_DBM;
+		survey->noise = ah->curchan->noisefloor;
+	}
 
 	return 0;
 }
-- 
1.7.2.2

