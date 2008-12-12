Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58753 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756143AbYLLMjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 07:39:23 -0500
Message-Id: <20081212123914.789977800@atheros.com> (sfid-20081212_133930_919421_F397330F)
References: <20081212123832.506588839@atheros.com>
Date: Fri, 12 Dec 2008 14:38:34 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 2/3] ath9k: Report HT rates in RX status
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix and clean up the RX status reporting by getting rid of code that
used internal rate tables and ratekbps calculation. The correct value
is now reported with MCS index instead of the old mechanism that
defaulted to using the highest legacy rate.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 drivers/net/wireless/ath9k/recv.c |   61 ++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 35 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2008-12-12 00:26:04.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2008-12-12 14:09:59.000000000 +0200
@@ -111,33 +111,6 @@ static struct sk_buff *ath_rxbuf_alloc(s
 	return skb;
 }
 
-static int ath_rate2idx(struct ath_softc *sc, int rate)
-{
-	int i = 0, cur_band, n_rates;
-	struct ieee80211_hw *hw = sc->hw;
-
-	cur_band = hw->conf.channel->band;
-	n_rates = sc->sbands[cur_band].n_bitrates;
-
-	for (i = 0; i < n_rates; i++) {
-		if (sc->sbands[cur_band].bitrates[i].bitrate == rate)
-			break;
-	}
-
-	/*
-	 * NB:mac80211 validates rx rate index against the supported legacy rate
-	 * index only (should be done against ht rates also), return the highest
-	 * legacy rate index for rx rate which does not match any one of the
-	 * supported basic and extended rates to make mac80211 happy.
-	 * The following hack will be cleaned up once the issue with
-	 * the rx rate index validation in mac80211 is fixed.
-	 */
-	if (i == n_rates)
-		return n_rates - 1;
-
-	return i;
-}
-
 /*
  * For Decrypt or Demic errors, we only mark packet status here and always push
  * up the frame up to let mac80211 handle the actual error case, be it no
@@ -147,9 +120,7 @@ static int ath_rx_prepare(struct sk_buff
 			  struct ieee80211_rx_status *rx_status, bool *decrypt_error,
 			  struct ath_softc *sc)
 {
-	struct ath_rate_table *rate_table = sc->cur_rate_table;
 	struct ieee80211_hdr *hdr;
-	int ratekbps, rix;
 	u8 ratecode;
 	__le16 fc;
 
@@ -204,15 +175,36 @@ static int ath_rx_prepare(struct sk_buff
 	}
 
 	ratecode = ds->ds_rxstat.rs_rate;
-	rix = rate_table->rateCodeToIndex[ratecode];
-	ratekbps = rate_table->info[rix].ratekbps;
 
-	/* HT rate */
 	if (ratecode & 0x80) {
+		/* HT rate */
+		rx_status->flag |= RX_FLAG_HT;
 		if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040)
-			ratekbps = (ratekbps * 27) / 13;
+			rx_status->flag |= RX_FLAG_40MHZ;
 		if (ds->ds_rxstat.rs_flags & ATH9K_RX_GI)
-			ratekbps = (ratekbps * 10) / 9;
+			rx_status->flag |= RX_FLAG_SHORT_GI;
+		rx_status->rate_idx = ratecode & 0x7f;
+	} else {
+		int i = 0, cur_band, n_rates;
+		struct ieee80211_hw *hw = sc->hw;
+
+		cur_band = hw->conf.channel->band;
+		n_rates = sc->sbands[cur_band].n_bitrates;
+
+		for (i = 0; i < n_rates; i++) {
+			if (sc->sbands[cur_band].bitrates[i].hw_value ==
+			    ratecode) {
+				rx_status->rate_idx = i;
+				break;
+			}
+
+			if (sc->sbands[cur_band].bitrates[i].hw_value_short ==
+			    ratecode) {
+				rx_status->rate_idx = i;
+				rx_status->flag |= RX_FLAG_SHORTPRE;
+				break;
+			}
+		}
 	}
 
 	rx_status->mactime = ath_extend_tsf(sc, ds->ds_rxstat.rs_tstamp);
@@ -220,7 +212,6 @@ static int ath_rx_prepare(struct sk_buff
 	rx_status->freq =  sc->hw->conf.channel->center_freq;
 	rx_status->noise = sc->sc_ani.sc_noise_floor;
 	rx_status->signal = rx_status->noise + ds->ds_rxstat.rs_rssi;
-	rx_status->rate_idx = ath_rate2idx(sc, (ratekbps / 100));
 	rx_status->antenna = ds->ds_rxstat.rs_antenna;
 
 	/* at 45 you will be able to use MCS 15 reliably. A more elaborate

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
