Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:3100 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464AbZGDRA5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 13:00:57 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	Bob Copeland <me@bobcopeland.com>, stable@kernel.org
Subject: [PATCH 5/5] ath5k: write PCU registers on initial reset
Date: Sat,  4 Jul 2009 12:59:55 -0400
Message-Id: <1246726795-3934-6-git-send-email-me@bobcopeland.com>
In-Reply-To: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
References: <1246726795-3934-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit d7dc100374df0c21afd8a198336ecd7999697159, "Ath5k: unify resets"
introduced a regression into 2.6.28 where the PCU registers are never
initialized, due to ath5k_reset() always passing true for change_channel.
We subsequently program a lot of these registers but several may start
in an unknown state.

Cc: stable@kernel.org
Reported-by: Forrest Zhang <forrest@hifulltech.com>
Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 3f55e90..80ae38d 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -2687,7 +2687,7 @@ ath5k_reset(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 		sc->curchan = chan;
 		sc->curband = &sc->sbands[chan->band];
 	}
-	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, true);
+	ret = ath5k_hw_reset(ah, sc->opmode, sc->curchan, chan == NULL);
 	if (ret) {
 		ATH5K_ERR(sc, "can't reset hardware (%d)\n", ret);
 		goto err;
-- 
1.6.2.5


