Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:58669 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbZESVuA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 17:50:00 -0400
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: linville@tuxdriver.com
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: [PATCH 1/3] ath9k: fix custom regulatory call position
Date: Tue, 19 May 2009 17:49:45 -0400
Message-Id: <1242769787-29467-1-git-send-email-lrodriguez@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_regd_init() needs to be called with the wiphy already
properly set with the bands. Without this the custom regulatory
settings were not taking effect, and the device would get
the default channel settings from ath9k_[25]ghz_chantable.

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index c161b75..7fab2d4 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1412,8 +1412,6 @@ static int ath_init(u16 devid, struct ath_softc *sc)
 	for (i = 0; i < sc->keymax; i++)
 		ath9k_hw_keyreset(ah, (u16) i);
 
-	error = ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
-			      ath9k_reg_notifier);
 	if (error)
 		goto bad;
 
@@ -1626,14 +1624,19 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 	if (error != 0)
 		return error;
 
-	reg = &sc->sc_ah->regulatory;
-
 	/* get mac address from hardware and set in mac80211 */
 
 	SET_IEEE80211_PERM_ADDR(hw, sc->sc_ah->macaddr);
 
 	ath_set_hw_capab(sc, hw);
 
+        error = ath_regd_init(&sc->sc_ah->regulatory, sc->hw->wiphy,
+			      ath9k_reg_notifier);
+	if (error)
+		return error;
+
+	reg = &sc->sc_ah->regulatory;
+
 	if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT) {
 		setup_ht_cap(sc, &sc->sbands[IEEE80211_BAND_2GHZ].ht_cap);
 		if (test_bit(ATH9K_MODE_11A, sc->sc_ah->caps.wireless_modes))
-- 
1.6.0.6

