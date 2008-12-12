Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58754 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756407AbYLLMjX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 07:39:23 -0500
Message-Id: <20081212123910.704978781@atheros.com> (sfid-20081212_133931_654237_DBE6EB09)
References: <20081212123832.506588839@atheros.com>
Date: Fri, 12 Dec 2008 14:38:33 +0200
From: Jouni Malinen <jouni.malinen@atheros.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jouni Malinen <jouni.malinen@atheros.com>
Subject: [PATCH 1/3] mac80211: Add HT rates into RX status reporting
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch adds option for HT-enabled drivers to report HT rates
(HT20/HT40, short GI, MCS index) to mac80211. These rates are
currently not in the rate table, so the rate_idx is used to indicate
MCS index.

Signed-off-by: Jouni Malinen <jouni.malinen@atheros.com>
---
 include/net/mac80211.h |   11 +++++++--
 net/mac80211/mlme.c    |    7 +++++-
 net/mac80211/rx.c      |   56 ++++++++++++++++++++++++++++++++++++++++---------
 3 files changed, 61 insertions(+), 13 deletions(-)

--- wireless-testing.orig/include/net/mac80211.h	2008-12-11 18:15:49.000000000 +0200
+++ wireless-testing/include/net/mac80211.h	2008-12-12 14:09:52.000000000 +0200
@@ -441,6 +441,9 @@ ieee80211_tx_info_clear_status(struct ie
  *	is valid. This is useful in monitor mode and necessary for beacon frames
  *	to enable IBSS merging.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
+ * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
+ * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
+ * @RX_FLAG_SHORT_GI: Short guard interval was used
  */
 enum mac80211_rx_flags {
 	RX_FLAG_MMIC_ERROR	= 1<<0,
@@ -451,7 +454,10 @@ enum mac80211_rx_flags {
 	RX_FLAG_FAILED_FCS_CRC	= 1<<5,
 	RX_FLAG_FAILED_PLCP_CRC = 1<<6,
 	RX_FLAG_TSFT		= 1<<7,
-	RX_FLAG_SHORTPRE	= 1<<8
+	RX_FLAG_SHORTPRE	= 1<<8,
+	RX_FLAG_HT		= 1<<9,
+	RX_FLAG_40MHZ		= 1<<10,
+	RX_FLAG_SHORT_GI	= 1<<11,
 };
 
 /**
@@ -471,7 +477,8 @@ enum mac80211_rx_flags {
  * @noise: noise when receiving this frame, in dBm.
  * @qual: overall signal quality indication, in percent (0-100).
  * @antenna: antenna used
- * @rate_idx: index of data rate into band's supported rates
+ * @rate_idx: index of data rate into band's supported rates or MCS index if
+ *	HT rates are use (RX_FLAG_HT)
  * @flag: %RX_FLAG_*
  */
 struct ieee80211_rx_status {
--- wireless-testing.orig/net/mac80211/mlme.c	2008-12-12 00:26:04.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2008-12-12 14:09:52.000000000 +0200
@@ -1627,8 +1627,13 @@ static void ieee80211_rx_bss_info(struct
 			 * e.g: at 1 MBit that means mactime is 192 usec earlier
 			 * (=24 bytes * 8 usecs/byte) than the beacon timestamp.
 			 */
-			int rate = local->hw.wiphy->bands[band]->
+			int rate;
+			if (rx_status->flag & RX_FLAG_HT) {
+				rate = 65; /* TODO: HT rates */
+			} else {
+				rate = local->hw.wiphy->bands[band]->
 					bitrates[rx_status->rate_idx].bitrate;
+			}
 			rx_timestamp = rx_status->mactime + (24 * 8 * 10 / rate);
 		} else if (local && local->ops && local->ops->get_tsf)
 			/* second best option: get current TSF */
--- wireless-testing.orig/net/mac80211/rx.c	2008-12-12 00:26:04.000000000 +0200
+++ wireless-testing/net/mac80211/rx.c	2008-12-12 14:09:52.000000000 +0200
@@ -149,7 +149,17 @@ ieee80211_add_rx_radiotap_header(struct 
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	*pos = rate->bitrate / 5;
+	if (status->flag & RX_FLAG_HT) {
+		/*
+		 * TODO: add following information into radiotap header once
+		 * suitable fields are defined for it:
+		 * - MCS index (status->rate_idx)
+		 * - HT40 (status->flag & RX_FLAG_40MHZ)
+		 * - short-GI (status->flag & RX_FLAG_SHORT_GI)
+		 */
+		*pos = 0;
+	} else
+		*pos = rate->bitrate / 5;
 	pos++;
 
 	/* IEEE80211_RADIOTAP_CHANNEL */
@@ -1863,9 +1873,15 @@ static int prepare_for_handlers(struct i
 			if (!(sdata->dev->flags & IFF_PROMISC))
 				return 0;
 			rx->flags &= ~IEEE80211_RX_RA_MATCH;
-		} else if (!rx->sta)
+		} else if (!rx->sta) {
+			int rate_idx;
+			if (rx->status->flag & RX_FLAG_HT)
+				rate_idx = 0; /* TODO: HT rates */
+			else
+				rate_idx = rx->status->rate_idx;
 			rx->sta = ieee80211_ibss_add_sta(sdata, bssid, hdr->addr2,
-				BIT(rx->status->rate_idx));
+				BIT(rate_idx));
+		}
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		if (!multicast &&
@@ -2071,7 +2087,13 @@ static u8 ieee80211_sta_manage_reorder_b
 					tid_agg_rx->reorder_buf[index]->cb,
 					sizeof(status));
 				sband = local->hw.wiphy->bands[status.band];
-				rate = &sband->bitrates[status.rate_idx];
+				if (status.flag & RX_FLAG_HT) {
+					/* TODO: HT rates */
+					rate = sband->bitrates;
+				} else {
+					rate = &sband->bitrates
+						[status.rate_idx];
+				}
 				__ieee80211_rx_handle_packet(hw,
 					tid_agg_rx->reorder_buf[index],
 					&status, rate);
@@ -2115,7 +2137,10 @@ static u8 ieee80211_sta_manage_reorder_b
 		memcpy(&status, tid_agg_rx->reorder_buf[index]->cb,
 			sizeof(status));
 		sband = local->hw.wiphy->bands[status.band];
-		rate = &sband->bitrates[status.rate_idx];
+		if (status.flag & RX_FLAG_HT)
+			rate = sband->bitrates; /* TODO: HT rates */
+		else
+			rate = &sband->bitrates[status.rate_idx];
 		__ieee80211_rx_handle_packet(hw, tid_agg_rx->reorder_buf[index],
 					     &status, rate);
 		tid_agg_rx->stored_mpdu_num--;
@@ -2203,15 +2228,26 @@ void __ieee80211_rx(struct ieee80211_hw 
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
+	if (status->flag & RX_FLAG_HT) {
+		/* rate_idx is MCS index */
+		if (WARN_ON(status->rate_idx < 0 ||
+			    status->rate_idx >= 76))
+			return;
+		/* HT rates are not in the table - use the highest legacy rate
+		 * for now since other parts of mac80211 may not yet be fully
+		 * MCS aware. */
+		rate = &sband->bitrates[sband->n_bitrates - 1];
+	} else {
+		if (WARN_ON(status->rate_idx < 0 ||
+			    status->rate_idx >= sband->n_bitrates))
+			return;
+		rate = &sband->bitrates[status->rate_idx];
+	}
 
 	/*
 	 * key references and virtual interfaces are protected using RCU

-- 

-- 
Jouni Malinen                                            PGP id EFC895FA
