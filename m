Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:28461 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753795Ab1ASJUp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jan 2011 04:20:45 -0500
Received: from vs3002.wh2.ocn.ne.jp (125.206.180.165)
	by mail30f.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 5-0947738841
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jan 2011 18:20:44 +0900 (JST)
Subject: [PATCH 7/8] ath5k: Remove unused sc->curmode
To: linville@tuxdriver.com
From: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 19 Jan 2011 18:21:08 +0900
Message-ID: <20110119092108.19628.43971.stgit@localhost6.localdomain6>
In-Reply-To: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
References: <20110119091949.19628.28309.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

sc->curmode is set but never used. Remove it and the helper function. Also the
ath5k_rate_update which is refered to in the comment does not exist (any more?)
so we don't need to setup the band in that place.

Signed-off-by: Bruno Randolf <br1@einfach.org>
---
 drivers/net/wireless/ath/ath5k/base.c |   18 ------------------
 drivers/net/wireless/ath/ath5k/base.h |    1 -
 2 files changed, 0 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/ath/ath5k/base.c b/drivers/net/wireless/ath/ath5k/base.c
index 6900543..a00cc11 100644
--- a/drivers/net/wireless/ath/ath5k/base.c
+++ b/drivers/net/wireless/ath/ath5k/base.c
@@ -439,18 +439,6 @@ ath5k_chan_set(struct ath5k_softc *sc, struct ieee80211_channel *chan)
 	return ath5k_reset(sc, chan, true);
 }
 
-static void
-ath5k_setcurmode(struct ath5k_softc *sc, unsigned int mode)
-{
-	sc->curmode = mode;
-
-	if (mode == AR5K_MODE_11A) {
-		sc->curband = &sc->sbands[IEEE80211_BAND_5GHZ];
-	} else {
-		sc->curband = &sc->sbands[IEEE80211_BAND_2GHZ];
-	}
-}
-
 struct ath_vif_iter_data {
 	const u8	*hw_macaddr;
 	u8		mask[ETH_ALEN];
@@ -2776,12 +2764,6 @@ ath5k_init(struct ieee80211_hw *hw)
 		goto err;
 	}
 
-	/* NB: setup here so ath5k_rate_update is happy */
-	if (test_bit(AR5K_MODE_11A, ah->ah_modes))
-		ath5k_setcurmode(sc, AR5K_MODE_11A);
-	else
-		ath5k_setcurmode(sc, AR5K_MODE_11B);
-
 	/*
 	 * Allocate tx+rx descriptors and populate the lists.
 	 */
diff --git a/drivers/net/wireless/ath/ath5k/base.h b/drivers/net/wireless/ath/ath5k/base.h
index 6d51147..58660e4 100644
--- a/drivers/net/wireless/ath/ath5k/base.h
+++ b/drivers/net/wireless/ath/ath5k/base.h
@@ -202,7 +202,6 @@ struct ath5k_softc {
 #define ATH_STAT_STARTED	4		/* opened & irqs enabled */
 
 	unsigned int		filter_flags;	/* HW flags, AR5K_RX_FILTER_* */
-	unsigned int		curmode;	/* current phy mode */
 	struct ieee80211_channel *curchan;	/* current h/w channel */
 
 	u16			nvifs;

