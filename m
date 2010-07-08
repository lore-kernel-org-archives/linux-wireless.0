Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:59844 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753420Ab0GHGmh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Jul 2010 02:42:37 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Wed, 07 Jul 2010 23:42:32 -0700
From: Rajkumar Manoharan <rmanoharan@atheros.com>
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanoharan@atheros.com>
Subject: [PATCH] ath9k: fix panic while cleaning up virtaul wifis
Date: Thu, 8 Jul 2010 12:12:29 +0530
Message-ID: <1278571349-10873-1-git-send-email-rmanoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

num_sec_wiphy means max secondary wifis that the driver can accomudate.
So cancelling wiphy work should be based on the presence of
secondary wifis.

Signed-off-by: Rajkumar Manoharan <rmanoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/init.c |    2 +-
 drivers/net/wireless/ath/ath9k/main.c |    8 +++++++-
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
index fe730cb..243c177 100644
--- a/drivers/net/wireless/ath/ath9k/init.c
+++ b/drivers/net/wireless/ath/ath9k/init.c
@@ -787,12 +787,12 @@ void ath9k_deinit_device(struct ath_softc *sc)
 		ieee80211_unregister_hw(aphy->hw);
 		ieee80211_free_hw(aphy->hw);
 	}
-	kfree(sc->sec_wiphy);
 
 	ieee80211_unregister_hw(hw);
 	ath_rx_cleanup(sc);
 	ath_tx_cleanup(sc);
 	ath9k_deinit_softc(sc);
+	kfree(sc->sec_wiphy);
 }
 
 void ath_descdma_cleanup(struct ath_softc *sc,
diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 4c0831f..bca8c5a 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1264,6 +1264,7 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_softc *sc = aphy->sc;
 	struct ath_hw *ah = sc->sc_ah;
 	struct ath_common *common = ath9k_hw_common(ah);
+	int i;
 
 	mutex_lock(&sc->mutex);
 
@@ -1276,7 +1277,12 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	cancel_work_sync(&sc->paprd_work);
 	cancel_work_sync(&sc->hw_check_work);
 
-	if (!sc->num_sec_wiphy) {
+	for (i = 0; i < sc->num_sec_wiphy; i++) {
+		if (sc->sec_wiphy[i])
+			break;
+	}
+
+	if (i == sc->num_sec_wiphy) {
 		cancel_delayed_work_sync(&sc->wiphy_work);
 		cancel_work_sync(&sc->chan_work);
 	}
-- 
1.7.0.4

