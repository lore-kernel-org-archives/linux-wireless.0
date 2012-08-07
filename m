Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6844 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757126Ab2HGBPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Aug 2012 21:15:47 -0400
From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Message-ID: <20512.27634.565484.124439@gargle.gargle.HOWL> (sfid-20120807_032551_530462_A3A52FA6)
Date: Tue, 7 Aug 2012 06:44:26 +0530
To: <linux-wireless@vger.kernel.org>
CC: <ath9k-devel@lists.ath9k.org>
Subject: [RFC 10/14] ath9k: Fix RTS/CTS rate selection
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The current method of assigning the RTS/CTS rate is completely
broken for HT mode and breaks P2P operation. Fix this by using
the basic_rates provided to the driver by mac80211. For now,
choose the lowest supported basic rate for HT frames.

Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/rc.c | 41 +++++++++++++------------------------
 1 file changed, 14 insertions(+), 27 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/rc.c b/drivers/net/wireless/ath/ath9k/rc.c
index 78192c1..a94c52b 100644
--- a/drivers/net/wireless/ath/ath9k/rc.c
+++ b/drivers/net/wireless/ath/ath9k/rc.c
@@ -699,37 +699,25 @@ static void ath_rc_rate_set_rtscts(struct ath_softc *sc,
 				   const struct ath_rate_table *rate_table,
 				   struct ieee80211_tx_info *tx_info)
 {
-	struct ieee80211_tx_rate *rates = tx_info->control.rates;
-	int i = 0, rix = 0, cix, enable_g_protection = 0;
+	struct ieee80211_bss_conf *bss_conf;
 
-	/* get the cix for the lowest valid rix */
-	for (i = 3; i >= 0; i--) {
-		if (rates[i].count && (rates[i].idx >= 0)) {
-			rix = ath_rc_get_rateindex(rate_table, &rates[i]);
-			break;
-		}
-	}
-	cix = rate_table->info[rix].ctrl_rate;
+	if (!tx_info->control.vif)
+		return;
+	/*
+	 * For legacy frames, mac80211 takes care of CTS protection.
+	 */
+	if (!(tx_info->control.rates[0].flags & IEEE80211_TX_RC_MCS))
+		return;
+
+	bss_conf = &tx_info->control.vif->bss_conf;
 
-	/* All protection frames are transmited at 2Mb/s for 802.11g,
-	 * otherwise we transmit them at 1Mb/s */
-	if (sc->hw->conf.channel->band == IEEE80211_BAND_2GHZ &&
-	    !conf_is_ht(&sc->hw->conf))
-		enable_g_protection = 1;
+	if (!bss_conf->basic_rates)
+		return;
 
 	/*
-	 * If 802.11g protection is enabled, determine whether to use RTS/CTS or
-	 * just CTS.  Note that this is only done for OFDM/HT unicast frames.
+	 * For now, use the lowest allowed basic rate for HT frames.
 	 */
-	if ((tx_info->control.vif &&
-	     tx_info->control.vif->bss_conf.use_cts_prot) &&
-	    (rate_table->info[rix].phy == WLAN_RC_PHY_OFDM ||
-	     WLAN_RC_PHY_HT(rate_table->info[rix].phy))) {
-		rates[0].flags |= IEEE80211_TX_RC_USE_CTS_PROTECT;
-		cix = rate_table->info[enable_g_protection].ctrl_rate;
-	}
-
-	tx_info->control.rts_cts_rate_idx = cix;
+	tx_info->control.rts_cts_rate_idx = __ffs(bss_conf->basic_rates);
 }
 
 static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
@@ -853,7 +841,6 @@ static void ath_get_rate(void *priv, struct ieee80211_sta *sta, void *priv_sta,
 		rates[0].count = ATH_TXMAXTRY;
 	}
 
-	/* Setup RTS/CTS */
 	ath_rc_rate_set_rtscts(sc, rate_table, tx_info);
 }
 
-- 
1.7.11.4

