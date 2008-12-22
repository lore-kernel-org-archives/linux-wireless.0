Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25118 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYLVSUu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:20:50 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:20:50 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 02/18] ath9k: use hw->conf on ath_setcurmode()
Date: Mon, 22 Dec 2008 10:20:23 -0800
Message-ID: <1229970039-10561-3-git-send-email-lrodriguez@atheros.com> (sfid-20081222_192054_033634_D15E5BAD)
In-Reply-To: <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
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
 drivers/net/wireless/ath9k/main.c |   72 ++++++++++++++++++++----------------
 1 files changed, 40 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 70affb7..2bf2b3f 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -59,41 +59,47 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
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
+		if (conf_is_ht20(conf))
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11NG_HT20];
+		else if (conf_is_ht40_minus(conf))
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11NG_HT40MINUS];
+		else if (conf_is_ht40_plus(conf))
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS];
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
+			  sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS];
+		else
+			sc->cur_rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
+		break;
+	default:
+		break;
+	}
 }
 
 static void ath_update_txpow(struct ath_softc *sc)
@@ -258,6 +264,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 {
 	struct ath_hal *ah = sc->sc_ah;
 	bool fastcc = true, stopped;
+	struct ieee80211_hw *hw = sc->hw;
 
 	if (sc->sc_flags & SC_OP_INVALID)
 		return -EIO;
@@ -316,7 +323,7 @@ static int ath_set_channel(struct ath_softc *sc, struct ath9k_channel *hchan)
 			return -EIO;
 		}
 
-		ath_setcurmode(sc, ath_chan2mode(hchan));
+		ath_setcurmode(sc, &hw->conf);
 		ath_update_txpow(sc);
 		ath9k_hw_set_interrupts(ah, sc->sc_imask);
 	}
@@ -1621,6 +1628,7 @@ detach:
 int ath_reset(struct ath_softc *sc, bool retry_tx)
 {
 	struct ath_hal *ah = sc->sc_ah;
+	struct ieee80211_hw *hw = sc->hw;
 	int status;
 	int error = 0;
 
@@ -1648,7 +1656,7 @@ int ath_reset(struct ath_softc *sc, bool retry_tx)
 	 * that changes the channel so update any state that
 	 * might change as a result.
 	 */
-	ath_setcurmode(sc, ath_chan2mode(sc->sc_ah->ah_curchan));
+	ath_setcurmode(sc, &hw->conf);
 
 	ath_update_txpow(sc);
 
@@ -1945,7 +1953,7 @@ static int ath9k_start(struct ieee80211_hw *hw)
 	    !sc->sc_config.swBeaconProcess)
 		sc->sc_imask |= ATH9K_INT_TIM;
 
-	ath_setcurmode(sc, ath_chan2mode(init_channel));
+	ath_setcurmode(sc, &hw->conf);
 
 	sc->sc_flags &= ~SC_OP_INVALID;
 
-- 
1.6.1.rc3.51.g5832d

