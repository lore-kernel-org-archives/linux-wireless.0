Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45940 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932506AbcFGNKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 09:10:10 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 2/6] ath9k: Handle channel context in get_/set_/reset_tsf
Date: Tue,  7 Jun 2016 15:09:57 +0200
Message-Id: <1465305001-26067-2-git-send-email-benjamin@sipsolutions.net> (sfid-20160607_151018_516055_430A58E3)
In-Reply-To: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
References: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 8b63988..375c2ac 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1823,11 +1823,18 @@ static void ath9k_bss_info_changed(struct ieee80211_hw *hw,
 static u64 ath9k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 	u64 tsf;
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	/* Get current TSF either from HW or kernel time. */
+	if (sc->cur_chan == avp->chanctx) {
+		tsf = ath9k_hw_gettsf64(sc->sc_ah);
+	} else {
+		tsf = sc->cur_chan->tsf_val +
+		      ath9k_hw_get_tsf_offset(&sc->cur_chan->tsf_ts, NULL);
+	}
 	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
 
@@ -1839,10 +1846,14 @@ static void ath9k_set_tsf(struct ieee80211_hw *hw,
 			  u64 tsf)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
-	ath9k_hw_settsf64(sc->sc_ah, tsf);
+	getrawmonotonic(&avp->chanctx->tsf_ts);
+	if (sc->cur_chan == avp->chanctx)
+		ath9k_hw_settsf64(sc->sc_ah, tsf);
+	avp->chanctx->tsf_val = tsf;
 	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
 }
@@ -1850,11 +1861,15 @@ static void ath9k_set_tsf(struct ieee80211_hw *hw,
 static void ath9k_reset_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 {
 	struct ath_softc *sc = hw->priv;
+	struct ath_vif *avp = (void *)vif->drv_priv;
 
 	mutex_lock(&sc->mutex);
 
 	ath9k_ps_wakeup(sc);
-	ath9k_hw_reset_tsf(sc->sc_ah);
+	getrawmonotonic(&avp->chanctx->tsf_ts);
+	if (sc->cur_chan == avp->chanctx)
+		ath9k_hw_reset_tsf(sc->sc_ah);
+	avp->chanctx->tsf_val = 0;
 	ath9k_ps_restore(sc);
 
 	mutex_unlock(&sc->mutex);
-- 
2.8.1

