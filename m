Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54797 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753585AbcGDMiG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 08:38:06 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH v2 1/6] ath9k: Correct TSF adjustment to align the beacon time correctly
Date: Mon,  4 Jul 2016 14:37:20 +0200
Message-Id: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net> (sfid-20160704_143815_343955_7D69FBA1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

Beacons were not send out at (timestamp % beacon_time == 0) for interfaces
other than the primary one. To send out beacons with the correct timestamp
according to 10.1.3.2 of the 802.11 standard the tsf_adjustment has to be
set to the negative time difference instead of positive. This way the
later beacons get corrected to have a lower (and similar) timestamp with
regard to the beacon from slot 0.

I am not aware about any issues that have been caused by this.

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

