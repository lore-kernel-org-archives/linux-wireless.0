Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:25120 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751860AbYLVSUx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Dec 2008 13:20:53 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Mon, 22 Dec 2008 10:20:53 -0800
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
To: <linville@tuxdriver.com>, <linville@tuxdriver.com>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>
Subject: [PATCH v2 03/18] ath9k: remove cache of rate preference when using 11g protection
Date: Mon, 22 Dec 2008 10:20:24 -0800
Message-ID: <1229970039-10561-4-git-send-email-lrodriguez@atheros.com> (sfid-20081222_192056_088357_21D8C704)
In-Reply-To: <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
References: <1229970039-10561-1-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-2-git-send-email-lrodriguez@atheros.com>
 <1229970039-10561-3-git-send-email-lrodriguez@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

No need to cache when we want to use 2Mbit/s for all protection
frames for 802.11g as we can determine that dynamically on
ath_buf_set_rate() itself.

Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    1 -
 drivers/net/wireless/ath9k/main.c |   13 +++----------
 drivers/net/wireless/ath9k/xmit.c |   13 ++++++++++---
 3 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index 4ca2aed..2bb35dd 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -718,7 +718,6 @@ struct ath_softc {
 	u32 sc_keymax;
 	DECLARE_BITMAP(sc_keymap, ATH_KEYMAX);
 	u8 sc_splitmic;
-	u8 sc_protrix;
 	enum ath9k_int sc_imask;
 	enum PROT_MODE sc_protmode;
 	enum ath9k_ht_extprotspacing sc_ht_extprotspacing;
diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
index 2bf2b3f..28d9de1 100644
--- a/drivers/net/wireless/ath9k/main.c
+++ b/drivers/net/wireless/ath9k/main.c
@@ -61,12 +61,6 @@ static void bus_read_cachesize(struct ath_softc *sc, int *csz)
 
 static void ath_setcurmode(struct ath_softc *sc, struct ieee80211_conf *conf)
 {
-	/*
-	 * All protection frames are transmited at 2Mb/s for
-	 * 11g, otherwise at 1Mb/s.
-	 * XXX select protection rate index from rate table.
-	 */
-	sc->sc_protrix = 0;
 	switch (conf->channel->band) {
 	case IEEE80211_BAND_2GHZ:
 		if (conf_is_ht20(conf))
@@ -78,11 +72,9 @@ static void ath_setcurmode(struct ath_softc *sc, struct ieee80211_conf *conf)
 		else if (conf_is_ht40_plus(conf))
 			sc->cur_rate_table =
 			  sc->hw_rate_table[ATH9K_MODE_11NG_HT40PLUS];
-		else {
-			sc->sc_protrix = 1;
+		else
 			sc->cur_rate_table =
 			  sc->hw_rate_table[ATH9K_MODE_11G];
-		}
 		break;
 	case IEEE80211_BAND_5GHZ:
 		if (conf_is_ht20(conf))
@@ -95,7 +87,8 @@ static void ath_setcurmode(struct ath_softc *sc, struct ieee80211_conf *conf)
 			sc->cur_rate_table =
 			  sc->hw_rate_table[ATH9K_MODE_11NA_HT40PLUS];
 		else
-			sc->cur_rate_table = sc->hw_rate_table[ATH9K_MODE_11A];
+			sc->cur_rate_table =
+			  sc->hw_rate_table[ATH9K_MODE_11A];
 		break;
 	default:
 		break;
diff --git a/drivers/net/wireless/ath9k/xmit.c b/drivers/net/wireless/ath9k/xmit.c
index 3bfc3b9..b724ca2 100644
--- a/drivers/net/wireless/ath9k/xmit.c
+++ b/drivers/net/wireless/ath9k/xmit.c
@@ -557,7 +557,8 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	struct ieee80211_tx_info *tx_info;
 	struct ieee80211_tx_rate *rates;
 	struct ieee80211_hdr *hdr;
-	int i, flags, rtsctsena = 0;
+	struct ieee80211_hw *hw = sc->hw;
+	int i, flags, rtsctsena = 0, enable_g_protection = 0;
 	u32 ctsduration = 0;
 	u8 rix = 0, cix, ctsrate = 0;
 	__le16 fc;
@@ -589,6 +590,12 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	flags = (bf->bf_flags & (ATH9K_TXDESC_RTSENA | ATH9K_TXDESC_CTSENA));
 	cix = rt->info[rix].ctrl_rate;
 
+	/* All protection frames are transmited at 2Mb/s for 802.11g,
+	 * otherwise we transmit them at 1Mb/s */
+	if (hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
+	  !conf_is_ht(&hw->conf))
+		enable_g_protection = 1;
+
 	/*
 	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
 	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
@@ -601,7 +608,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 		else if (sc->sc_protmode == PROT_M_CTSONLY)
 			flags = ATH9K_TXDESC_CTSENA;
 
-		cix = rt->info[sc->sc_protrix].ctrl_rate;
+		cix = rt->info[enable_g_protection].ctrl_rate;
 		rtsctsena = 1;
 	}
 
@@ -619,7 +626,7 @@ static void ath_buf_set_rate(struct ath_softc *sc, struct ath_buf *bf)
 	if (sc->sc_config.ath_aggr_prot &&
 	    (!bf_isaggr(bf) || (bf_isaggr(bf) && bf->bf_al < 8192))) {
 		flags = ATH9K_TXDESC_RTSENA;
-		cix = rt->info[sc->sc_protrix].ctrl_rate;
+		cix = rt->info[enable_g_protection].ctrl_rate;
 		rtsctsena = 1;
 	}
 
-- 
1.6.1.rc3.51.g5832d

