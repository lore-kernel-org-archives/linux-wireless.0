Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:46112 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003AbZHRFVf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 01:21:35 -0400
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2009 22:21:37 -0700
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <19082.14960.701320.200218@gargle.gargle.HOWL>
Date: Tue, 18 Aug 2009 10:51:52 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>
Subject: [PATCH] ath9k: Fix TX poll cancelling
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In ath9k_stop(), tx_complete_work was being cancelled twice.
This patch fixes it. Also, locking sc->mutex should be done
at the beginning.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath/ath9k/main.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 3e09b9a..c454d19 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -2105,6 +2105,8 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 	struct ath_wiphy *aphy = hw->priv;
 	struct ath_softc *sc = aphy->sc;
 
+	mutex_lock(&sc->mutex);
+
 	aphy->state = ATH_WIPHY_INACTIVE;
 
 	cancel_delayed_work_sync(&sc->ath_led_blink_work);
@@ -2117,13 +2119,10 @@ static void ath9k_stop(struct ieee80211_hw *hw)
 
 	if (sc->sc_flags & SC_OP_INVALID) {
 		DPRINTF(sc, ATH_DBG_ANY, "Device not present\n");
+		mutex_unlock(&sc->mutex);
 		return;
 	}
 
-	mutex_lock(&sc->mutex);
-
-	cancel_delayed_work_sync(&sc->tx_complete_work);
-
 	if (ath9k_wiphy_started(sc)) {
 		mutex_unlock(&sc->mutex);
 		return; /* another wiphy still in use */
-- 
1.6.4

