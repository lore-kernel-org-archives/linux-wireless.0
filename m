Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54828 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754333Ab2KIURF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:17:05 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 7/8] mac80211: support drivers reporting VHT RX
Date: Fri,  9 Nov 2012 21:17:33 +0100
Message-Id: <1352492254-29399-8-git-send-email-johannes@sipsolutions.net> (sfid-20121109_211718_310169_CB5788D3)
In-Reply-To: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support to mac80211 for having drivers report
received VHT MCS information.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h   | 12 +++++++++++-
 net/mac80211/cfg.c       | 26 +++++++++++++++++++++++---
 net/mac80211/ibss.c      |  2 +-
 net/mac80211/mesh_sync.c |  2 +-
 net/mac80211/rx.c        | 20 +++++++++++++++-----
 net/mac80211/sta_info.h  |  4 +++-
 6 files changed, 54 insertions(+), 12 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 52807d4..da9fcd6 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -714,7 +714,11 @@ ieee80211_tx_info_clear_status(struct ieee80211_tx_info *info)
  *	merging.
  * @RX_FLAG_SHORTPRE: Short preamble was used for this frame
  * @RX_FLAG_HT: HT MCS was used and rate_idx is MCS index
+ * @RX_FLAG_VHT: VHT MCS was used and rate_index is MCS index
  * @RX_FLAG_40MHZ: HT40 (40 MHz) was used
+ * @RX_FLAG_80MHZ: 80 MHz was used
+ * @RX_FLAG_80P80MHZ: 80+80 MHz was used
+ * @RX_FLAG_160MHZ: 160 MHz was used
  * @RX_FLAG_SHORT_GI: Short guard interval was used
  * @RX_FLAG_NO_SIGNAL_VAL: The signal strength value is not present.
  *	Valid only for data frames (mainly A-MPDU)
@@ -756,6 +760,10 @@ enum mac80211_rx_flags {
 	RX_FLAG_AMPDU_IS_LAST		= BIT(18),
 	RX_FLAG_AMPDU_DELIM_CRC_ERROR	= BIT(19),
 	RX_FLAG_AMPDU_DELIM_CRC_KNOWN	= BIT(20),
+	RX_FLAG_VHT			= BIT(21),
+	RX_FLAG_80MHZ			= BIT(22),
+	RX_FLAG_80P80MHZ		= BIT(23),
+	RX_FLAG_160MHZ			= BIT(24),
 };
 
 /**
@@ -776,7 +784,8 @@ enum mac80211_rx_flags {
  *	@IEEE80211_HW_SIGNAL_*
  * @antenna: antenna used
  * @rate_idx: index of data rate into band's supported rates or MCS index if
- *	HT rates are use (RX_FLAG_HT)
+ *	HT or VHT is used (%RX_FLAG_HT/%RX_FLAG_VHT)
+ * @vht_nss: number of streams (VHT only)
  * @flag: %RX_FLAG_*
  * @rx_flags: internal RX flags for mac80211
  * @ampdu_reference: A-MPDU reference number, must be a different value for
@@ -790,6 +799,7 @@ struct ieee80211_rx_status {
 	u32 flag;
 	u16 freq;
 	u8 rate_idx;
+	u8 vht_nss;
 	u8 rx_flags;
 	u8 band;
 	u8 antenna;
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 91823ad..5e9fdce 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -374,7 +374,8 @@ static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, in
 {
 	enum ieee80211_band band = ieee80211_get_sdata_band(sta->sdata);
 
-	if (!(rate->flags & RATE_INFO_FLAGS_MCS)) {
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS) &&
+	    !(rate->flags & RATE_INFO_FLAGS_VHT_MCS)) {
 		struct ieee80211_supported_band *sband;
 		sband = sta->local->hw.wiphy->bands[band];
 		rate->legacy = sband->bitrates[idx].bitrate;
@@ -444,13 +445,32 @@ static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
 	sta_set_rate_info_tx(sta, &sta->last_tx_rate, &sinfo->txrate);
 
 	sinfo->rxrate.flags = 0;
-	if (sta->last_rx_rate_flag & RX_FLAG_HT)
+	if (sta->last_rx_rate_flag & RX_FLAG_HT) {
 		sinfo->rxrate.flags |= RATE_INFO_FLAGS_MCS;
+		sinfo->rxrate.mcs = sta->last_rx_rate_idx;
+	} else if (sta->last_rx_rate_flag & RX_FLAG_VHT) {
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_VHT_MCS;
+		sinfo->rxrate.nss = sta->last_rx_rate_vht_nss;
+		sinfo->rxrate.mcs = sta->last_rx_rate_idx;
+	} else {
+		struct ieee80211_supported_band *sband;
+
+		sband = sta->local->hw.wiphy->bands[
+				ieee80211_get_sdata_band(sta->sdata)];
+		sinfo->rxrate.legacy =
+			sband->bitrates[sta->last_rx_rate_idx].bitrate;
+	}
+
 	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
 		sinfo->rxrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
 	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
 		sinfo->rxrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
-	rate_idx_to_bitrate(&sinfo->rxrate, sta, sta->last_rx_rate_idx);
+	if (sta->last_rx_rate_flag & RX_FLAG_80MHZ)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_80P80MHZ)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_80P80_MHZ_WIDTH;
+	if (sta->last_rx_rate_flag & RX_FLAG_160MHZ)
+		sinfo->rxrate.flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 
 	if (ieee80211_vif_is_mesh(&sdata->vif)) {
 #ifdef CONFIG_MAC80211_MESH
diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index e9e29ad..5e69188 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -565,7 +565,7 @@ static void ieee80211_rx_bss_info(struct ieee80211_sub_if_data *sdata,
 		 */
 		int rate;
 
-		if (rx_status->flag & RX_FLAG_HT)
+		if (rx_status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
 			rate = 65; /* TODO: HT rates */
 		else
 			rate = local->hw.wiphy->bands[band]->
diff --git a/net/mac80211/mesh_sync.c b/net/mac80211/mesh_sync.c
index 407c870..ed2503f 100644
--- a/net/mac80211/mesh_sync.c
+++ b/net/mac80211/mesh_sync.c
@@ -137,7 +137,7 @@ static void mesh_sync_offset_rx_bcn_presp(struct ieee80211_sub_if_data *sdata,
 		 */
 		int rate;
 
-		if (rx_status->flag & RX_FLAG_HT) {
+		if (rx_status->flag & (RX_FLAG_HT | RX_FLAG_VHT)) {
 			/* TODO:
 			 * In principle there could be HT-beacons (Dual Beacon
 			 * HT Operation options), but for now ignore them and
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 6ad3303..c45c9ff 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -150,7 +150,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	pos++;
 
 	/* IEEE80211_RADIOTAP_RATE */
-	if (!rate || status->flag & RX_FLAG_HT) {
+	if (!rate || status->flag & (RX_FLAG_HT | RX_FLAG_VHT)) {
 		/*
 		 * Without rate information don't add it. If we have,
 		 * MCS information is a separate field in radiotap,
@@ -170,7 +170,7 @@ ieee80211_add_rx_radiotap_header(struct ieee80211_local *local,
 	if (status->band == IEEE80211_BAND_5GHZ)
 		put_unaligned_le16(IEEE80211_CHAN_OFDM | IEEE80211_CHAN_5GHZ,
 				   pos);
-	else if (status->flag & RX_FLAG_HT)
+	else if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
 		put_unaligned_le16(IEEE80211_CHAN_DYN | IEEE80211_CHAN_2GHZ,
 				   pos);
 	else if (rate && rate->flags & IEEE80211_RATE_ERP_G)
@@ -1294,6 +1294,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 			if (ieee80211_is_data(hdr->frame_control)) {
 				sta->last_rx_rate_idx = status->rate_idx;
 				sta->last_rx_rate_flag = status->flag;
+				sta->last_rx_rate_vht_nss = status->vht_nss;
 			}
 		}
 	} else if (!is_multicast_ether_addr(hdr->addr1)) {
@@ -1305,6 +1306,7 @@ ieee80211_rx_h_sta_process(struct ieee80211_rx_data *rx)
 		if (ieee80211_is_data(hdr->frame_control)) {
 			sta->last_rx_rate_idx = status->rate_idx;
 			sta->last_rx_rate_flag = status->flag;
+			sta->last_rx_rate_vht_nss = status->vht_nss;
 		}
 	}
 
@@ -2648,7 +2650,8 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 		status = IEEE80211_SKB_RXCB((rx->skb));
 
 		sband = rx->local->hw.wiphy->bands[status->band];
-		if (!(status->flag & RX_FLAG_HT))
+		if (!(status->flag & RX_FLAG_HT) &&
+		    !(status->flag & RX_FLAG_VHT))
 			rate = &sband->bitrates[status->rate_idx];
 
 		ieee80211_rx_cooked_monitor(rx, rate);
@@ -2815,8 +2818,8 @@ static int prepare_for_handlers(struct ieee80211_rx_data *rx,
 			status->rx_flags &= ~IEEE80211_RX_RA_MATCH;
 		} else if (!rx->sta) {
 			int rate_idx;
-			if (status->flag & RX_FLAG_HT)
-				rate_idx = 0; /* TODO: HT rates */
+			if (status->flag & (RX_FLAG_HT | RX_FLAG_VHT))
+				rate_idx = 0; /* TODO: HT/VHT rates */
 			else
 				rate_idx = status->rate_idx;
 			ieee80211_ibss_rx_no_sta(sdata, bssid, hdr->addr2,
@@ -3092,6 +3095,13 @@ void ieee80211_rx(struct ieee80211_hw *hw, struct sk_buff *skb)
 				 status->rate_idx,
 				 status->rate_idx))
 				goto drop;
+		} else if (status->flag & RX_FLAG_VHT) {
+			if (WARN_ONCE(status->rate_idx > 9 ||
+				      !status->vht_nss ||
+				      status->vht_nss > 8,
+				      "Rate marked as a VHT rate but data is invalid: MCS: %d, NSS: %d\n",
+				      status->rate_idx, status->vht_nss))
+				goto drop;
 		} else {
 			if (WARN_ON(status->rate_idx >= sband->n_bitrates))
 				goto drop;
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index e0191f0..dcc0ffc 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -228,6 +228,7 @@ struct sta_ampdu_mlme {
  *	"the" transmit rate
  * @last_rx_rate_idx: rx status rate index of the last data packet
  * @last_rx_rate_flag: rx status flag of the last data packet
+ * @last_rx_rate_vht_nss: rx status nss of last data packet
  * @lock: used for locking all fields that require locking, see comments
  *	in the header file.
  * @drv_unblock_wk: used for driver PS unblocking
@@ -344,7 +345,8 @@ struct sta_info {
 	unsigned long tx_fragments;
 	struct ieee80211_tx_rate last_tx_rate;
 	int last_rx_rate_idx;
-	int last_rx_rate_flag;
+	u32 last_rx_rate_flag;
+	u8 last_rx_rate_vht_nss;
 	u16 tid_seq[IEEE80211_QOS_CTL_TID_MASK + 1];
 
 	/*
-- 
1.8.0

