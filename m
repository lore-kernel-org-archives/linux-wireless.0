Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2867 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758057AbZBLSjI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Feb 2009 13:39:08 -0500
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	ath9k-devel@lists.ath9k.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 6/6] ath9k: move common regulatory code out of if() branches
Date: Thu, 12 Feb 2009 13:38:58 -0500
Message-Id: <1234463938-1350-7-git-send-email-me@bobcopeland.com> (sfid-20090212_193913_659845_923B1B3F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Both branches of the regulatory check in ath_attach() set up a
custom regulatory domain and apply radar and world flags, so extract
those into a single path.

While at it, fix a couple of spelling errors and an unnecessary extra
pointer traversal.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath9k/main.c |   20 ++++++++------------
 1 files changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index fc3460f..61f9532 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -1565,6 +1565,7 @@ bad:
 int ath_attach(u16 devid, struct ath_softc *sc)
 {
 	struct ieee80211_hw *hw = sc->hw;
+	const struct ieee80211_regdomain *regd;
 	int error = 0;
 
 	DPRINTF(sc, ATH_DBG_CONFIG, "Attach ATH hw\n");
@@ -1634,25 +1635,20 @@ int ath_attach(u16 devid, struct ath_softc *sc)
 #endif
 
 	if (ath9k_is_world_regd(sc->sc_ah)) {
-		/* Anything applied here (prior to wiphy registratoin) gets
+		/* Anything applied here (prior to wiphy registration) gets
 		 * saved on the wiphy orig_* parameters */
-		const struct ieee80211_regdomain *regd =
-			ath9k_world_regdomain(sc->sc_ah);
+		regd = ath9k_world_regdomain(sc->sc_ah);
 		hw->wiphy->custom_regulatory = true;
 		hw->wiphy->strict_regulatory = false;
-		wiphy_apply_custom_regulatory(sc->hw->wiphy, regd);
-		ath9k_reg_apply_radar_flags(hw->wiphy);
-		ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_INIT);
 	} else {
 		/* This gets applied in the case of the absense of CRDA,
-		 * its our own custom world regulatory domain, similar to
+		 * it's our own custom world regulatory domain, similar to
 		 * cfg80211's but we enable passive scanning */
-		const struct ieee80211_regdomain *regd =
-			ath9k_default_world_regdomain();
-		wiphy_apply_custom_regulatory(sc->hw->wiphy, regd);
-		ath9k_reg_apply_radar_flags(hw->wiphy);
-		ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_INIT);
+		regd = ath9k_default_world_regdomain();
 	}
+	wiphy_apply_custom_regulatory(hw->wiphy, regd);
+	ath9k_reg_apply_radar_flags(hw->wiphy);
+	ath9k_reg_apply_world_flags(hw->wiphy, REGDOM_SET_BY_INIT);
 
 	error = ieee80211_register_hw(hw);
 
-- 
1.6.0.6


