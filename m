Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45935 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932114AbcFGNKK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Jun 2016 09:10:10 -0400
From: Benjamin Berg <benjamin@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Kalle Valo <kvalo@codeaurora.org>, Felix Fietkau <nbd@nbd.name>,
	ath9k-devel@lists.ath9k.org,
	Benjamin Berg <benjamin.berg@open-mesh.com>
Subject: [PATCH 4/6] ath9k: Expose tsf_adjustment in mac80211 tsf getters and setters.
Date: Tue,  7 Jun 2016 15:09:59 +0200
Message-Id: <1465305001-26067-4-git-send-email-benjamin@sipsolutions.net> (sfid-20160607_151024_133142_4CB18EAE)
In-Reply-To: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
References: <1465305001-26067-1-git-send-email-benjamin@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Benjamin Berg <benjamin.berg@open-mesh.com>

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

