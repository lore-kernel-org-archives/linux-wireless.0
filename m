Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54788 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520AbcGDMiE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jul 2016 08:38:04 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH v2 4/6] ath9k: Expose tsf_adjustment in mac80211 tsf getters and setters.
Date: Mon,  4 Jul 2016 14:37:23 +0200
Message-Id: <1467635845-32653-4-git-send-email-benjamin@sipsolutions.net> (sfid-20160704_143809_461486_AC494C3C)
In-Reply-To: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net>
References: <1467635845-32653-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

The ath9k driver modifies the TSF for VIFs for the purpose of sending
beacons in a staggered fashion. This patch exposes this VIF specific
adjustment of the TSF value to mac80211. Without the change the TSF
routines handle the hardware TSF value instead of the actual TSF value as
seen on the air.

Signed-off-by: Benjamin Berg <benjamin.berg@open-mesh.com>
---
 drivers/net/wireless/ath/ath9k/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
index 375c2ac..f2ebc85 100644
--- a/drivers/net/wireless/ath/ath9k/main.c
+++ b/drivers/net/wireless/ath/ath9k/main.c
@@ -1835,6 +1835,7 @@ static u64 ath9k_get_tsf(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 		tsf = sc->cur_chan->tsf_val +
 		      ath9k_hw_get_tsf_offset(&sc->cur_chan->tsf_ts, NULL);
 	}
+	tsf += le64_to_cpu(avp->tsf_adjust);
 	ath9k_ps_restore(sc);
 	mutex_unlock(&sc->mutex);
 
@@ -1850,6 +1851,7 @@ static void ath9k_set_tsf(struct ieee80211_hw *hw,
 
 	mutex_lock(&sc->mutex);
 	ath9k_ps_wakeup(sc);
+	tsf -= le64_to_cpu(avp->tsf_adjust);
 	getrawmonotonic(&avp->chanctx->tsf_ts);
 	if (sc->cur_chan == avp->chanctx)
 		ath9k_hw_settsf64(sc->sc_ah, tsf);
-- 
2.8.1

