Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45937 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932586AbcFGNKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 09:10:10 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 1/6] ath9k: Correct TSF adjustment to align the beacon time correctly
Date: Tue,  7 Jun 2016 15:09:56 +0200
Message-Id: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net> (sfid-20160607_151017_564891_F17347B8)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Beacons need to be send out at timestamp % beacon_time == 0.

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 drivers/net/wireless/ath/ath9k/beacon.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/beacon.c b/drivers/net/wireless/ath/ath9k/beacon.c
index 5cf0cd7..800c96b 100644
--- a/drivers/net/wireless/ath/ath9k/beacon.c
+++ b/drivers/net/wireless/ath/ath9k/beacon.c
@@ -279,17 +279,21 @@ static void ath9k_set_tsfadjust(struct ath_softc *sc, struct ieee80211_vif *vif)
 	struct ath_common *common = ath9k_hw_common(sc->sc_ah);
 	struct ath_vif *avp = (void *)vif->drv_priv;
 	struct ath_beacon_config *cur_conf = &avp->chanctx->beacon;
-	u32 tsfadjust;
+	s64 tsfadjust;
 
 	if (avp->av_bslot == 0)
 		return;
 
+	/* tsf_adjust is added to the TSF value. We send out the beacon late,
+	 * so need to adjust the TSF starting point to be later in time (i.e.
+	 * the theoretical first beacon has a TSF of 0 after correction).
+	 */
 	tsfadjust = cur_conf->beacon_interval * avp->av_bslot;
-	tsfadjust = TU_TO_USEC(tsfadjust) / ATH_BCBUF;
+	tsfadjust = -TU_TO_USEC(tsfadjust) / ATH_BCBUF;
 	avp->tsf_adjust = cpu_to_le64(tsfadjust);
 
-	ath_dbg(common, CONFIG, "tsfadjust is: %llu for bslot: %d\n",
-		(unsigned long long)tsfadjust, avp->av_bslot);
+	ath_dbg(common, CONFIG, "tsfadjust is: %lld for bslot: %d\n",
+		(signed long long)tsfadjust, avp->av_bslot);
 }
 
 bool ath9k_csa_is_finished(struct ath_softc *sc, struct ieee80211_vif *vif)
-- 
2.8.1

