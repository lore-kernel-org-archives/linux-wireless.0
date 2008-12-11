Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:39923 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756240AbYLKQRu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 11:17:50 -0500
Received: from jm (a91-155-82-88.elisa-laajakaista.fi [91.155.82.88])
	(authenticated bits=0)
	by jmalinen.user.openhosting.com (8.13.8/8.13.8) with ESMTP id mBBGHfWO007826
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 11:17:43 -0500
Date: Thu, 11 Dec 2008 18:17:41 +0200
From: Jouni Malinen <j@w1.fi>
To: linux-wireless@vger.kernel.org
Subject: [RFC] mac80211: Add HT rates into RX status reporting
Message-ID: <20081211161741.GA27460@jm.kir.nu> (sfid-20081211_171755_461467_12BBE0E8)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds option for HT-enabled drivers to report HT rates
(HT20/HT40, short GI, MCS index) to mac80211. These rates are
currently not in the rate table, so the rate_idx is used to indicate
MCS index.

Radiotap code gets some of the additional knowledge so that it can
determine the used bitrate for HT rates, too (though, the rate field
is not large enough to fit all rates). It would be useful to add MCS
index, HT20/HT40, and short GI information into radiotap definition at
some point, too, and the needed information for filling in those field
is now available in mac80211.

The ath9k change fixes and cleans up the RX status reporting by
getting rid of code that used internal rate tables and ratekbps
calculation. The correct value is now reported with MCS index instead
of the old mechanism that defaulted to using the highest legacy rate.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>

---
 drivers/net/wireless/ath9k/recv.c |   62 ++++++++++++-----------------
 include/net/mac80211.h            |   11 ++++-
 net/mac80211/mlme.c               |    7 ++-
 net/mac80211/rx.c                 |   79 +++++++++++++++++++++++++++++++++-----
 5 files changed, 112 insertions(+), 48 deletions(-)

--- wireless-testing.orig/drivers/net/wireless/ath9k/recv.c	2008-12-11 15:53:19.000000000 +0200
+++ wireless-testing/drivers/net/wireless/ath9k/recv.c	2008-12-11 16:46:46.000000000 +0200
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
 
@@ -204,15 +175,37 @@ static int ath_rx_prepare(struct sk_buff
 	}
 
 	ratecode = ds->ds_rxstat.rs_rate;
-	rix = rate_table->rateCodeToIndex[ratecode];
-	ratekbps = rate_table->info[rix].ratekbps;
 
-	/* HT rate */
 	if (ratecode & 0x80) {
+		/* HT rate */
 		if (ds->ds_rxstat.rs_flags & ATH9K_RX_2040)
-			ratekbps = (ratekbps * 27) / 13;
+			rx_status->flag |= RX_FLAG_HT40;
+		else
+			rx_status->flag |= RX_FLAG_HT20;
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
@@ -220,7 +213,6 @@ static int ath_rx_prepare(struct sk_buff
 	rx_status->freq =  sc->hw->conf.channel->center_freq;
 	rx_status->noise = sc->sc_ani.sc_noise_floor;
 	rx_status->signal = rx_status->noise + ds->ds_rxstat.rs_rssi;
-	rx_status->rate_idx = ath_rate2idx(sc, (ratekbps / 100));
 	rx_status->antenna = ds->ds_rxstat.rs_antenna;
 
 	/* at 45 you will be able to use MCS 15 reliably. A more elaborate
--- wireless-testing.orig/include/net/mac80211.h	2008-12-11 16:25:19.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2008-12-11 16:30:33.000000000 +0200
@@ -436,6 +436,9 @@ ieee80211_tx_info_clear_status(struct ie
  *	is valid. This is useful in monitor mode and necessary for beacon frames
  *	to enable IBSS merging.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
+ * @RX_FLAG_HT20: HT20 MCS was used and rate_idx is MCS index
+ * @RX_FLAG_HT40: HT40 MCS was used and rate_idx is MCS index
+ * @RX_FLAG_SHORT_GI: Short guard interval was used
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -446,7 +449,10 @@ enum mac80211_rx_flags {
 	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
 	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
 	RX_FLAG_TSFT		= 1<<7,
-	RX_FLAG_SHORTPRE	= 1<<8
+	RX_FLAG_SHORTPRE	= 1<<8,
+	RX_FLAG_HT20		= 1<<9,
+	RX_FLAG_HT40		= 1<<10,
+	RX_FLAG_SHORT_GI	= 1<<11,
 };
 
 /**
@@ -466,7 +472,8 @@ enum mac80211_rx_flags {
  * @noise: noise when receiving this frame, in dBm.
  * @qual: overall signal quality indication, in percent (0-100).
  * @antenna: antenna used
- * @rate_idx: index of data rate into band's supported rates
+ * @rate_idx: index of data rate into band's supported rates or MCS index if
+ *	HT rates are use (RX_FLAG_HT20 or RX_FLAG_HT40)
  * @flag: %RX_FLAG_*
  */
 struct ieee80211_rx_status {
--- wireless-testing.orig/net/mac80211/mlme.c	2008-12-11 16:48:40.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2008-12-11 16:59:01.000000000 +0200
@@ -1629,8 +1629,13 @@ static void ieee80211_rx_bss_info(struct
 			 * e.g: at 1 MBit that means mactime is 192 usec earlier
 			 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
 			 */
-			int rate = local->hw.wiphy->bands[band]->
+			int rate;
+			if (rx_status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
+				rate = 65; /* TODO: HT rates */
+			} else {
+				rate = local->hw.wiphy->bands[band]->
 					bitrates[rx_status->rate_idx].bitrate;
+			}
 			rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
 		} else if (local && local->ops && local->ops->get_tsf)
 			/* second best option: get current TSF */
--- wireless-testing.orig/net/mac80211/rx.c	2008-12-11 16:48:43.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2008-12-11 18:05:31.000000000 +0200
@@ -149,7 +149,41 @@ ieee80211_add_rx_radiotap_header(struct 
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	*pos = rate->bitrate / 5;
+	if (status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
+		int mcs_idx = status->rate_idx;
+		if (mcs_idx >= 16) {
+			/* TODO: MCS index 16.. */
+			*pos = 0;
+		} else {
+			int mcs2rate_ht40[16] = {
+				13500, 27500, 40500, 54000,
+				81500, 108000, 121500, 135000,
+				27000, 54000, 81000, 108000,
+				162000, 216000, 243000, 270000
+			};
+			int mcs2rate[16] = {
+				6500, 13000, 19500, 26000,
+				39000, 52000, 58500, 65000,
+				13000, 26000, 39000, 52000,
+				78000, 104000, 117000, 130000
+			};
+			int rate;
+			if (status->flag & RX_FLAG_HT40)
+				rate = mcs2rate_ht40[mcs_idx];
+			else
+				rate = mcs2rate[mcs_idx];
+
+			if (status->flag & RX_FLAG_SHORT_GI)
+				rate = rate * 10 / 9;
+
+			rate /= 500;
+			if (rate > 255)
+				rate = 255;
+
+			*pos = rate;
+		}
+	} else
+		*pos = rate->bitrate / 5;
 	pos++;
 
 	/* IEEE80211_RADIOTAP_CHANNEL */
@@ -1863,10 +1897,16 @@ static int prepare_for_handlers(struct i
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
-		} else if (!rx->sta)
+		} else if (!rx->sta) {
+			int rate_idx;
+			if (rx->status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40))
+				rate_idx = 0; /* TODO: HT rates */
+			else
+				rate_idx = rx->status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, rx->skb,
 						bssid, hdr->addr2,
-						BIT(rx->status->rate_idx));
+						BIT(rate_idx));
+		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
@@ -2072,7 +2112,14 @@ static u8 ieee80211_sta_manage_reorder_b
 					tid_agg_rx->reorder_buf[index]->cb,
 					sizeof(status));
 				sband = local->hw.wiphy->bands[status.band];
-				rate = &sband->bitrates[status.rate_idx];
+				if (status.flag &
+				    (RX_FLAG_HT20 | RX_FLAG_HT40)) {
+					/* TODO: HT rates */
+					rate = sband->bitrates;
+				} else {
+					rate = &sband->bitrates
+						[status.rate_idx];
+				}
 				__ieee80211_rx_handle_packet(hw,
 					tid_agg_rx->reorder_buf[index],
 					&status, rate);
@@ -2116,7 +2163,10 @@ static u8 ieee80211_sta_manage_reorder_b
 		memcpy(&status, tid_agg_rx->reorder_buf[index]->cb,
 			sizeof(status));
 		sband = local->hw.wiphy->bands[status.band];
-		rate = &sband->bitrates[status.rate_idx];
+		if (status.flag & (RX_FLAG_HT20 | RX_FLAG_HT40))
+			rate = sband->bitrates; /* TODO: HT rates */
+		else
+			rate = &sband->bitrates[status.rate_idx];
 		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
 					     &status, rate);
 		tid_agg_rx->stored_mpdu_num--;
@@ -2204,15 +2254,24 @@ void __ieee80211_rx(struct ieee80211_hw 
 	}
 
 	sband = local->hw.wiphy->bands[status->band];
-
-	if (!sband ||
-	    status->rate_idx < 0 ||
-	    status->rate_idx >= sband->n_bitrates) {
+	if (!sband) {
 		WARN_ON(1);
 		return;
 	}
 
-	rate = &sband->bitrates[status->rate_idx];
+	if (status->flag & (RX_FLAG_HT20 | RX_FLAG_HT40)) {
+		/* HT rates are not in the table - use the highest legacy rate
+		 * for now since other parts of mac80211 may not yet be fully
+		 * MCS aware. */
+		rate = &sband->bitrates[sband->n_bitrates - 1];
+	} else {
+		if (status->rate_idx < 0 ||
+		    status->rate_idx >= sband->n_bitrates) {
+			WARN_ON(1);
+			return;
+		}
+		rate = &sband->bitrates[status->rate_idx];
+	}
 
 	/*
 	 * key references and virtual interfaces are protected using RCU

-- 
Jouni Malinen                                            PGP id EFC895FA
