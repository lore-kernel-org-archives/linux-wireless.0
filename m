Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42691 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752288Ab0LGViF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Dec 2010 16:38:05 -0500
Received: by yxt3 with SMTP id 3so277534yxt.19
        for <linux-wireless@vger.kernel.org>; Tue, 07 Dec 2010 13:38:04 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath5k: Put the right tsf value in mesh beacons
Date: Tue,  7 Dec 2010 13:37:56 -0800
Message-Id: <1291757876-29936-1-git-send-email-javier@cozybit.com>
In-Reply-To: <20101207205751.GJ2700@tuxdriver.com>
References: <20101207205751.GJ2700@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 2bf2e28..ac7da50 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1881,7 +1881,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
 		sc->bmisscount = 0;
 	}
 
-	if (sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) {
+	if ((sc->opmode == NL80211_IFTYPE_AP && sc->num_ap_vifs > 1) ||
+			sc->opmode == NL80211_IFTYPE_MESH_POINT) {
 		u64 tsf = ath5k_hw_get_tsf64(ah);
 		u32 tsftu = TSF_TO_TU(tsf);
 		int slot = ((tsftu % sc->bintval) * ATH_BCBUF) / sc->bintval;
-- 
1.7.1

