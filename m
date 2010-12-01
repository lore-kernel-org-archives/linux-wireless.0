Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58926 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0LACTS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Nov 2010 21:19:18 -0500
Received: by mail-yx0-f174.google.com with SMTP id 3so2622320yxt.19
        for <linux-wireless@vger.kernel.org>; Tue, 30 Nov 2010 18:19:18 -0800 (PST)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Steve Derosier <steve@cozybit.com>, devel@lists.open80211s.org,
	linux-wireless@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath5k: Put the right tsf value in mesh beacons
Date: Tue, 30 Nov 2010 18:18:39 -0800
Message-Id: <1291169919-3867-4-git-send-email-javier@cozybit.com>
In-Reply-To: <1291169919-3867-1-git-send-email-javier@cozybit.com>
References: <1291169919-3867-1-git-send-email-javier@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/ath/ath5k/base.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 44f3050..6b06754 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1889,7 +1889,8 @@ ath5k_beacon_send(struct ath5k_softc *sc)
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

