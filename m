Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.191]:48706 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbYLFOy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Dec 2008 09:54:29 -0500
Received: by ti-out-0910.google.com with SMTP id b6so310521tic.23
        for <linux-wireless@vger.kernel.org>; Sat, 06 Dec 2008 06:54:27 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18746.37273.989918.333164@localhost.localdomain> (sfid-20081206_155434_351378_12894E5F)
Date: Sat, 6 Dec 2008 20:22:09 +0530
To: Mats Johannesson <spamcan1@abrasax.se>
Cc: linux-wireless@vger.kernel.org
Subject: [ath9k] 2.6.28-rc7-wl Kernel panic when "iwlist ath0 scan" as root
In-Reply-To: <20081206113406.734f1d94@loke.fish.not>
References: <20081206113406.734f1d94@loke.fish.not>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Mats Johannesson wrote:
> As the subject says, 2.6.28-rc7-wl git pulled Dec 6 exhibits a kernel
> panic when doing "iwlist ath0 scan" as root under the ath9k driver.
> Machine dead, panic LED blinking.
> 
> Scan as normal user is OK.
> 

Can you check if this makes any difference ? Thanks.

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
