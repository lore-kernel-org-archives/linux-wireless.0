Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:37340 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756687Ab0KJTn6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 14:43:58 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: ath5k-devel@venema.h4ckr.net, Ben Greear <greearb@candelatech.com>
Subject: [PATCH] ath5k:  Cleanup opmode setting logic.
Date: Wed, 10 Nov 2010 11:43:51 -0800
Message-Id: <1289418231-2427-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

An earlier review suggested moving the code in a small
method that was only called once inline.  This patch
accomplishes that.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 b9f93fb... afd3094... M	drivers/net/wireless/ath/ath5k/base.c
 drivers/net/wireless/ath/ath5k/base.c |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index b9f93fb..afd3094 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -549,7 +549,7 @@ static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 	/* Calculate combined mode - when APs are active, operate in AP mode.
 	 * Otherwise use the mode of the new interface. This can currently
 	 * only deal with combinations of APs and STAs. Only one ad-hoc
-	 * interfaces is allowed above.
+	 * interfaces is allowed.
 	 */
 	if (avf->opmode == NL80211_IFTYPE_AP)
 		iter_data->opmode = NL80211_IFTYPE_AP;
@@ -558,14 +558,6 @@ static void ath_vif_iter(void *data, u8 *mac, struct ieee80211_vif *vif)
 			iter_data->opmode = avf->opmode;
 }
 
-static void ath_do_set_opmode(struct ath5k_softc *sc)
-{
-	struct ath5k_hw *ah = sc->ah;
-	ath5k_hw_set_opmode(ah, sc->opmode);
-	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
-		  sc->opmode, ath_opmode_to_string(sc->opmode));
-}
-
 static void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 					       struct ieee80211_vif *vif)
 {
@@ -595,7 +587,9 @@ static void ath5k_update_bssid_mask_and_opmode(struct ath5k_softc *sc,
 		/* Nothing active, default to station mode */
 		sc->opmode = NL80211_IFTYPE_STATION;
 
-	ath_do_set_opmode(sc);
+	ath5k_hw_set_opmode(sc->ah, sc->opmode);
+	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
+		  sc->opmode, ath_opmode_to_string(sc->opmode));
 
 	if (iter_data.need_set_hw_addr && iter_data.found_active)
 		ath5k_hw_set_lladdr(sc->ah, iter_data.active_mac);
-- 
1.7.2.3

