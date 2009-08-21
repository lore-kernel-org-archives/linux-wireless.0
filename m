Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:64514 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbZHUGaM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 02:30:12 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2009 23:30:14 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19086.16132.472040.96071@gargle.gargle.HOWL>
Date: Fri, 21 Aug 2009 12:00:28 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix chainmask selection during scanning
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The TX/RX chainmasks were set to 1x1 during scanning.
Configure them properly with the values retrieved from
the EEPROM.

Also, this requires scan_start/scan_end callbacks to be
locked with sc->mutex.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 9b9b4e8..eb8d673 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -439,7 +439,7 @@ static void ath_start_ani(struct ath_softc *sc)
  */
 void ath_update_chainmask(struct ath_softc *sc, int is_ht)
 {
-	if (is_ht ||
+	if ((sc->sc_flags & SC_OP_SCANNING) || is_ht ||
 	    (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_BT_COEX)) {
 		sc->tx_chainmask = sc->sc_ah->caps.tx_chainmask;
 		sc->rx_chainmask = sc->sc_ah->caps.rx_chainmask;
@@ -2713,6 +2713,7 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
+	mutex_lock(&sc->mutex);
 	if (ath9k_wiphy_scanning(sc)) {
 		printk(KERN_DEBUG "ath9k: Two wiphys trying to scan at the "
 		       "same time\n");
@@ -2720,6 +2721,7 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 		 * Do not allow the concurrent scanning state for now. This
 		 * could be improved with scanning control moved into ath9k.
 		 */
+		mutex_unlock(&sc->mutex);
 		return;
 	}
 
@@ -2729,6 +2731,7 @@ static void ath9k_sw_scan_start(struct ieee80211_hw *hw)
 	spin_lock_bh(&sc->ani_lock);
 	sc->sc_flags |= SC_OP_SCANNING;
 	spin_unlock_bh(&sc->ani_lock);
+	mutex_unlock(&sc->mutex);
 }
 
 static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
@@ -2736,11 +2739,13 @@ static void ath9k_sw_scan_complete(struct ieee80211_hw *hw)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
+	mutex_lock(&sc->mutex);
 	spin_lock_bh(&sc->ani_lock);
 	aphy->state = ATH_WIPHY_ACTIVE;
 	sc->sc_flags &= ~SC_OP_SCANNING;
 	sc->sc_flags |= SC_OP_FULL_RESET;
 	spin_unlock_bh(&sc->ani_lock);
+	mutex_unlock(&sc->mutex);
 }
 
 struct ieee80211_ops ath9k_ops = {
-- 
1.6.4

