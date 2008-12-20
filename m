Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32074 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752077AbYLTFzb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 00:55:31 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 19 Dec 2008 21:55:30 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH 02/16] ath9k: use hw->conf on ath_setcurmode()
Date: Fri, 19 Dec 2008 21:55:08 -0800
Message-ID: <1229752522-1917-3-git-send-email-lrodriguez@atheros.com> (sfid-20081220_065538_287618_AEDD70C5)
In-Reply-To: <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
References: <1229752522-1917-1-git-send-email-lrodriguez@atheros.com>
 <1229752522-1917-2-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need to use our own mode for setting the
the routine tries to do, in fact lets remove ath_chan2mode() now as
we can simply use the currently set band and the HT configuration
provided by mac80211 through the ieee80211_conf. This works on
changing channels as well as the internal ath9k_channel we use is
based on the ieee80211_channel in the config.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/main.c |   70 ++++++++++++++++++++-----------------
 1 files changed, 38 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 70affb7..a1bd611 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -59,41 +59,45 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 		*csz = DEFAULT_CACHELINE >> 2;   /* Use the default size */
 }
 
-static void ath_setcurmode(struct ath_softc *sc, enum wireless_mode mode)
+static void ath_setcurmode(struct ath_softc *sc, struct ieee80211_conf *conf)
 {
-	sc->cur_rate_table = sc->hw_rate_table[mode];
 	/*
 	 * All protection frames are transmited at 2Mb/s for
 	 * 11g, otherwise at 1Mb/s.
 	 * XXX select protection rate index from rate table.
 	 */
-	sc->sc_protrix = (mode == ATH9K_MODE_11G ? 1 : 0);
-}
-
-static enum wireless_mode ath_chan2mode(struct ath9k_channel *chan)
-{
-	if (chan->chanmode == CHANNEL_A)
-		return ATH9K_MODE_11A;
-	else if (chan->chanmode == CHANNEL_G)
-		return ATH9K_MODE_11G;
-	else if (chan->chanmode == CHANNEL_B)
-		return ATH9K_MODE_11B;
-	else if (chan->chanmode == CHANNEL_A_HT20)
-		return ATH9K_MODE_11NA_HT20;
-	else if (chan->chanmode == CHANNEL_G_HT20)
-		return ATH9K_MODE_11NG_HT20;
-	else if (chan->chanmode == CHANNEL_A_HT40PLUS)
-		return ATH9K_MODE_11NA_HT40PLUS;
-	else if (chan->chanmode == CHANNEL_A_HT40MINUS)
-		return ATH9K_MODE_11NA_HT40MINUS;
-	else if (chan->chanmode == CHANNEL_G_HT40PLUS)
-		return ATH9K_MODE_11NG_HT40PLUS;
-	else if (chan->chanmode == CHANNEL_G_HT40MINUS)
-		return ATH9K_MODE_11NG_HT40MINUS;
-
-	WARN_ON(1); /* should not get here */
-
-	return ATH9K_MODE_11B;
+	sc->sc_protrix = 0;
+	switch (conf->channel->band) {
+	case IEEE80211_BAND_2GHZ:
+		/* If the IEEE ends up deciding to support HT40 on 2 GHz
+		 * then we can map the HT40+ or HT40- to the appropriate rate
+		 * table then. For now only HT20 is only supported by
+		 * mac80211 */
+		if (conf_is_ht20(conf))
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11NG_HT20];
+		else {
+			sc->sc_protrix = 1;
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11G];
+		}
+		break;
+	case IEEE80211_BAND_5GHZ:
+		if (conf_is_ht20(conf))
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11NA_HT20];
+		else if (conf_is_ht40_minus(conf))
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11NA_HT40MINUS];
+		else if (conf_is_ht40_plus(conf))
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS];
+		else
+			sc->cur_rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
+		break;
+	default:
+		break;
+	}
 }
 
 static void ath_update_txpow(struct ath_softc *sc)
@@ -258,6 +262,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
+	struct ieee80211_hw *hw = sc->hw;
 
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
@@ -316,7 +321,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 			return -EIO;
 		}
 
-		ath_setcurmode(sc, ath_chan2mode(hchan));
+		ath_setcurmode(sc, &hw->conf);
 		ath_update_txpow(sc);
 		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 	}
@@ -1621,6 +1626,7 @@ detach:
 int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
+	struct ieee80211_hw *hw = sc->hw;
 	int status;
 	int error = 0;
 
@@ -1648,7 +1654,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	 * that changes the channel so update any state that
 	 * might change as a result.
 	 */
-	ath_setcurmode(sc, ath_chan2mode(sc->sc_ah->ah_curchan));
+	ath_setcurmode(sc, &hw->conf);
 
 	ath_update_txpow(sc);
 
@@ -1945,7 +1951,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
 
-	ath_setcurmode(sc, ath_chan2mode(init_channel));
+	ath_setcurmode(sc, &hw->conf);
 
 	sc->sc_flags &= ~SC_OP_INVALID;
 
-- 
1.5.6.rc2.15.g457bb.dirty

