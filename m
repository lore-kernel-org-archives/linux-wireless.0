Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4856 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab0DHEAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Apr 2010 00:00:17 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linville@tuxdriver.com, jirislaby@gmail.com, mickflemm@gmail.com,
	lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	br1@einfach.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 2/4] ath5k: clean up queue manipulation
Date: Wed,  7 Apr 2010 23:55:57 -0400
Message-Id: <1270698959-7844-3-git-send-email-me@bobcopeland.com>
In-Reply-To: <1270698959-7844-1-git-send-email-me@bobcopeland.com>
References: <1270698959-7844-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Review spotted a couple of strange invocations to
ieee80211_wake_queues that could potentially cause problems:

 - queues are awakened in the calibration tasklet before
   phy calibration, and then again after calibration

 - queues are awakened inside reset when we're trying to
   drain the ath5k transmit queues, and again after
   reset is completed (in callers to ath5k_reset_wake).

In both cases the first wake is unnecessary, so remove it.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath5k/base.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index a1c0dcb..1e10439 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -1633,7 +1633,6 @@ ath5k_txq_cleanup(struct ath5k_softc *sc)
 					sc->txqs[i].link);
 			}
 	}
-	ieee80211_wake_queues(sc->hw); /* XXX move to callers */
 
 	for (i = 0; i < ARRAY_SIZE(sc->txqs); i++)
 		if (sc->txqs[i].setup)
@@ -2761,7 +2760,7 @@ ath5k_tasklet_calibrate(unsigned long data)
 		 * to load new gain values.
 		 */
 		ATH5K_DBG(sc, ATH5K_DEBUG_RESET, "calibration, resetting\n");
-		ath5k_reset_wake(sc);
+		ath5k_reset(sc, sc->curchan);
 	}
 	if (ath5k_hw_phy_calibrate(ah, sc->curchan))
 		ATH5K_ERR(sc, "calibration of channel %u failed\n",
-- 
1.6.3.3


