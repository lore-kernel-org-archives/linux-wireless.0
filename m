Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:40963 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751075Ab0IJWF2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Sep 2010 18:05:28 -0400
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [virtual-sta 2/3] ath9k:  Calculate bssid-mask and rxfilter for 2+ STAs
Date: Fri, 10 Sep 2010 15:04:57 -0700
Message-Id: <1284156298-15863-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
References: <1284156298-15863-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

The rx-filter wasn't taking multiple VIFs into account
when calculating the BEACON and OTHER_BSS filter.

Make sure that bssid-mask is set up properly if we have
more than 1 VIF.  The BSSID should be calculated over all
VIFs, not just running ones.  Otherwise, secondary VIFS
cannot receive enough packets to bring up their link.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
:100644 100644 2a6e45a... 26fb322... M	drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
:100644 100644 b32c8f0... 6e1aee0... M	drivers/net/wireless/ath/ath9k/recv.c
:100644 100644 fd20241... 9c1d529... M	drivers/net/wireless/ath/ath9k/virtual.c
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c |    1 +
 drivers/net/wireless/ath/ath9k/recv.c         |   23 ++++++++++++++++-------
 drivers/net/wireless/ath/ath9k/virtual.c      |   12 +++++++-----
 3 files changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
index 2a6e45a..26fb322 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_txrx.c
@@ -416,6 +416,7 @@ static void ath9k_htc_opmode_init(struct ath9k_htc_priv *priv)
 
 	/* configure bssid mask */
 	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+		/* NOTE:  Maybe this should be ath9k_set_bssid_mask?? */
 		ath_hw_setbssidmask(common);
 
 	/* configure operational mode */
diff --git a/drivers/net/wireless/ath/ath9k/recv.c b/drivers/net/wireless/ath/ath9k/recv.c
index b32c8f0..6e1aee0 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -110,7 +110,6 @@ static void ath_setdefantenna(struct ath_softc *sc, u32 antenna)
 static void ath_opmode_init(struct ath_softc *sc)
 {
 	struct ath_hw *ah = sc->sc_ah;
-	struct ath_common *common = ath9k_hw_common(ah);
 
 	u32 rfilt, mfilt[2];
 
@@ -118,9 +117,15 @@ static void ath_opmode_init(struct ath_softc *sc)
 	rfilt = ath_calcrxfilter(sc);
 	ath9k_hw_setrxfilter(ah, rfilt);
 
-	/* configure bssid mask */
-	if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
-		ath_hw_setbssidmask(common);
+	/* configure bssid mask, if ah->hw is configured.
+	 * it is NOT configured when mac80211 is calling
+	 * ieee80211_do_open, but probably just as well since
+	 * this STA isn't in the list yet.
+	 */
+	if (ah->hw) {
+		if (ah->caps.hw_caps & ATH9K_HW_CAP_BSSIDMASK)
+			ath9k_set_bssid_mask(ah->hw);
+	}
 
 	/* configure operational mode */
 	ath9k_hw_setopmode(ah);
@@ -426,6 +431,8 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 #define	RX_FILTER_PRESERVE (ATH9K_RX_FILTER_PHYERR | ATH9K_RX_FILTER_PHYRADAR)
 
 	u32 rfilt;
+	int avifs = ieee80211_iterate_interfaces_helper(sc->hw, true, false,
+							NULL, NULL);
 
 	rfilt = (ath9k_hw_getrxfilter(sc->sc_ah) & RX_FILTER_PRESERVE)
 		| ATH9K_RX_FILTER_UCAST | ATH9K_RX_FILTER_BCAST
@@ -448,7 +455,11 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (sc->rx.rxfilter & FIF_CONTROL)
 		rfilt |= ATH9K_RX_FILTER_CONTROL;
 
+	/* If we have more than one active STA, then we need to
+	 * accept more than just MYBEACON.
+	 */
 	if ((sc->sc_ah->opmode == NL80211_IFTYPE_STATION) &&
+	    (avifs <= 1) &&
 	    !(sc->rx.rxfilter & FIF_BCN_PRBRESP_PROMISC))
 		rfilt |= ATH9K_RX_FILTER_MYBEACON;
 	else
@@ -463,9 +474,7 @@ u32 ath_calcrxfilter(struct ath_softc *sc)
 	if (conf_is_ht(&sc->hw->conf))
 		rfilt |= ATH9K_RX_FILTER_COMP_BAR;
 
-	if (sc->sec_wiphy || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
-		/* TODO: only needed if more than one BSSID is in use in
-		 * station/adhoc mode */
+	if (sc->sec_wiphy || (avifs > 1) || (sc->rx.rxfilter & FIF_OTHER_BSS)) {
 		/* The following may also be needed for other older chips */
 		if (sc->sc_ah->hw_version.macVersion == AR_SREV_VERSION_9160)
 			rfilt |= ATH9K_RX_FILTER_PROM;
diff --git a/drivers/net/wireless/ath/ath9k/virtual.c b/drivers/net/wireless/ath/ath9k/virtual.c
index fd20241..9c1d529 100644
--- a/drivers/net/wireless/ath/ath9k/virtual.c
+++ b/drivers/net/wireless/ath/ath9k/virtual.c
@@ -59,15 +59,17 @@ void ath9k_set_bssid_mask(struct ieee80211_hw *hw)
 	} else
 		iter_data.count = 0;
 
-	/* Get list of all active MAC addresses */
+	/* Get list of all MAC addresses for STA and ADHOC interfaces. */
 	spin_lock_bh(&sc->wiphy_lock);
-	ieee80211_iterate_active_interfaces_atomic(sc->hw, ath9k_vif_iter,
-						   &iter_data);
+	ieee80211_iterate_interfaces_helper(sc->hw, true, false,
+					    ath9k_vif_iter,
+					    &iter_data);
 	for (i = 0; i < sc->num_sec_wiphy; i++) {
 		if (sc->sec_wiphy[i] == NULL)
 			continue;
-		ieee80211_iterate_active_interfaces_atomic(
-			sc->sec_wiphy[i]->hw, ath9k_vif_iter, &iter_data);
+		ieee80211_iterate_interfaces_helper(
+			sc->sec_wiphy[i]->hw, true, false,
+			ath9k_vif_iter, &iter_data);
 	}
 	spin_unlock_bh(&sc->wiphy_lock);
 
-- 
1.7.2.2

