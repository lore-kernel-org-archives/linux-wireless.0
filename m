Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:34747 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185AbYLGQOt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Dec 2008 11:14:49 -0500
Received: from mail.atheros.com ([10.10.20.108])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Sun, 07 Dec 2008 08:14:49 -0800
From: Sujith <Sujith.Manoharan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <18747.62905.202648.225086@gargle.gargle.HOWL> (sfid-20081207_171453_882422_70AD13D9)
Date: Sun, 7 Dec 2008 21:41:37 +0530
To: <linville@tuxdriver.com>
CC: <linux-wireless@vger.kernel.org>, <Jouni.Malinen@Atheros.com>,
	<Luis.Rodriguez@Atheros.com>
Subject: [PATCH 1/6] ath9k: Fix bug in rate table management
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The proper rate table wouldn't be used if a disassoc
happens and a new attempt is made to associate using
wpa_supplicant. This patch fixes it by storing the rate
table to be used on association.

Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
---
 drivers/net/wireless/ath9k/core.h |    1 +
 drivers/net/wireless/ath9k/rc.c   |    9 +++++----
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ath9k/core.h b/drivers/net/wireless/ath9k/core.h
index ca8ed7d..726d0a3 100644
--- a/drivers/net/wireless/ath9k/core.h
+++ b/drivers/net/wireless/ath9k/core.h
@@ -702,6 +702,7 @@ struct ath_softc {
 	/* Rate */
 	struct ieee80211_rate rates[IEEE80211_NUM_BANDS][ATH_RATE_MAX];
 	struct ath_rate_table *hw_rate_table[ATH9K_MODE_MAX];
+	struct ath_rate_table *cur_rate_table;
 	u8 sc_protrix;
 
 	/* Channel, Band */
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index 76acd2b..8eec667 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -817,7 +817,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	struct ath_rate_table *rate_table;
 	struct ieee80211_tx_rate *rates = tx_info->control.rates;
 
-	rate_table = sc->hw_rate_table[sc->sc_curmode];
+	rate_table = sc->cur_rate_table;
 	rix = ath_rc_ratefind_ht(sc, ath_rc_priv, rate_table, 1,
 				 is_probe, is_retry);
 	nrix = rix;
@@ -877,7 +877,7 @@ static void ath_rc_ratefind(struct ath_softc *sc,
 	if ((sc->sc_curmode == ATH9K_MODE_11NG_HT20) ||
 	    (sc->sc_curmode == ATH9K_MODE_11NG_HT40PLUS) ||
 	    (sc->sc_curmode == ATH9K_MODE_11NG_HT40MINUS)) {
-		u8  dot11rate = rate_table->info[rix].dot11rate;
+		u8 dot11rate = rate_table->info[rix].dot11rate;
 		u8 phy = rate_table->info[rix].phy;
 		if (i == 4 &&
 		    ((dot11rate == 2 && phy == WLAN_RC_PHY_HT_40_SS) ||
@@ -1094,7 +1094,7 @@ static void ath_rc_update_ht(struct ath_softc *sc,
 	int rate;
 	u8 last_per;
 	bool state_change = false;
-	struct ath_rate_table *rate_table = sc->hw_rate_table[sc->sc_curmode];
+	struct ath_rate_table *rate_table = sc->cur_rate_table;
 	int size = ath_rc_priv->rate_table_size;
 
 	if ((tx_rate < 0) || (tx_rate > rate_table->rate_cnt))
@@ -1254,7 +1254,7 @@ static void ath_rc_tx_status(struct ath_softc *sc,
 	u8 flags;
 	u32 i = 0, rix;
 
-	rate_table = sc->hw_rate_table[sc->sc_curmode];
+	rate_table = sc->cur_rate_table;
 
 	/*
 	 * If the first rate is not the final index, there
@@ -1432,6 +1432,7 @@ static void ath_rc_init(struct ath_softc *sc,
 	ath_rc_priv->max_valid_rate = k;
 	ath_rc_sort_validrates(rate_table, ath_rc_priv);
 	ath_rc_priv->rate_max_phy = ath_rc_priv->valid_rate_index[k-4];
+	sc->cur_rate_table = rate_table;
 }
 
 /* Rate Control callbacks */
-- 
1.6.0.3

