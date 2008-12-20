Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32076 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428AbYLTFzg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:36 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:36 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 04/16] ath9k: Rename ath_setcurmode() to ath_cache_conf_rate()
Date: Fri, 19 Dec 2008 21:55:10 -0800
Message-ID: <1229752522-1917-5-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065541_188317_0C53966C)
In-Reply-To: <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-3-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-4-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath_setcurmode() is a bit misleading, all we are doing is
caching the rate for the corresponding configuration we
are using.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   10 ++++++----
 1 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 04ca86f..dddcb4f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -59,7 +59,8 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
 }
 
-static void ath_setcurmode(struct ath_softc *sc, struct ieee80211_conf *conf)
+static void ath_cache_conf_rate(struct ath_softc *sc,
+				struct ieee80211_conf *conf)
 {
 	switch (conf->channel->band) {
 	case IEEE80211_BAND_2GHZ:
@@ -88,6 +89,7 @@ static void ath_setcurmode(struct ath_softc *sc, struct ieee80211_conf *conf)
 			sc->cur_rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
 		break;
 	default:
+		BUG_ON(1);
 		break;
 	}
 }
@@ -313,7 +315,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 			return -EIO;
 		}
 
-		ath_setcurmode(sc, &hw->conf);
+		ath_cache_conf_rate(sc, &hw->conf);
 		ath_update_txpow(sc);
 		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 	}
@@ -1646,7 +1648,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	 * that changes the channel so update any state that
 	 * might change as a result.
 	 */
-	ath_setcurmode(sc, &hw->conf);
+	ath_cache_conf_rate(sc, &hw->conf);
 
 	ath_update_txpow(sc);
 
@@ -1943,7 +1945,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
 
-	ath_setcurmode(sc, &hw->conf);
+	ath_cache_conf_rate(sc, &hw->conf);
 
 	sc->sc_flags &= ~SC_OP_INVALID;
 
-- 
1.5.6.rc2.15.g457bb.dirty

