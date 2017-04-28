Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:49300 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S968984AbdD1Igr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 28 Apr 2017 04:36:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC] mac80211: add support for HE RX rate reporting
Date: Fri, 28 Apr 2017 10:36:39 +0200
Message-Id: <20170428083639.3596-1-johannes@sipsolutions.net> (sfid-20170428_103709_414478_EB158A3B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for encoding and reporting HE RX rates. So far this
only passes through to cfg80211 and doesn't do anything extra
like radiotap reporting.

type=feature

Change-Id: Iab9e575bf47b4945597d703fb4fd8fde7dc0057d
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h  |  7 ++++++-
 net/mac80211/rx.c       | 11 +++++++++--
 net/mac80211/sta_info.c | 10 +++++++++-
 net/mac80211/sta_info.h | 18 ++++++++++++++++--
 4 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index f1b58b580080..94fc278c75e7 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1142,6 +1142,7 @@ enum mac80211_rx_encoding {
 	RX_ENC_LEGACY = 0,
 	RX_ENC_HT,
 	RX_ENC_VHT,
+	RX_ENC_HE,
 };
 
 /**
@@ -1176,6 +1177,9 @@ enum mac80211_rx_encoding {
  * @encoding: &enum mac80211_rx_encoding
  * @bw: &enum rate_info_bw
  * @enc_flags: uses bits from &enum mac80211_rx_encoding_flags
+ * @he_ru: HE RU, from &enum nl80211_he_ru_alloc
+ * @he_gi: HE GI, from &enum nl80211_he_gi
+ * @he_dcm: HE DCM value
  * @rx_flags: internal RX flags for mac80211
  * @ampdu_reference: A-MPDU reference number, must be a different value for
  *	each A-MPDU but the same for each subframe within one A-MPDU
@@ -1189,7 +1193,8 @@ struct ieee80211_rx_status {
 	u32 flag;
 	u16 freq;
 	u8 enc_flags;
-	u8 encoding:2, bw:3;
+	u8 encoding:2, bw:3, he_ru:3;
+	u8 he_gi:2, he_dcm:1;
 	u8 rate_idx;
 	u8 nss;
 	u8 rx_flags;
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 35f4c7d7a500..8541b0cac580 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -3341,8 +3341,7 @@ static void ieee80211_rx_handlers_result(struct ieee80211_rx_data *rx,
 		status = IEEE80211_SKB_RXCB((rx->skb));
 
 		sband = rx->local->hw.wiphy->bands[status->band];
-		if (!(status->encoding == RX_ENC_HT) &&
-		    !(status->encoding == RX_ENC_VHT))
+		if (status->encoding == RX_ENC_LEGACY)
 			rate = &sband->bitrates[status->rate_idx];
 
 		ieee80211_rx_cooked_monitor(rx, rate);
@@ -4314,6 +4313,14 @@ void ieee80211_rx_napi(struct ieee80211_hw *hw, struct ieee80211_sta *pubsta,
 				      status->rate_idx, status->nss))
 				goto drop;
 			break;
+		case RX_ENC_HE:
+			if (WARN_ONCE(status->rate_idx > 9 ||
+				      !status->nss ||
+				      status->nss > 8,
+				      "Rate marked as an HE rate but data is invalid: MCS: %d, NSS: %d\n",
+				      status->rate_idx, status->nss))
+				goto drop;
+			break;
 		default:
 			WARN_ON_ONCE(1);
 			/* fall through */
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index 464566c662c5..84138e76ac78 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -1954,7 +1954,7 @@ sta_get_last_rx_stats(struct sta_info *sta)
 	return stats;
 }
 
-static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
+static void sta_stats_decode_rate(struct ieee80211_local *local, u32 rate,
 				  struct rate_info *rinfo)
 {
 	rinfo->bw = STA_STATS_GET(BW, rate);
@@ -1992,6 +1992,14 @@ static void sta_stats_decode_rate(struct ieee80211_local *local, u16 rate,
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 		break;
 		}
+	case STA_STATS_RATE_TYPE_HE:
+		rinfo->flags = RATE_INFO_FLAGS_HE_MCS;
+		rinfo->mcs = STA_STATS_GET(HE_MCS, rate);
+		rinfo->nss = STA_STATS_GET(HE_NSS, rate);
+		rinfo->he_gi = STA_STATS_GET(HE_GI, rate);
+		rinfo->he_ru_alloc = STA_STATS_GET(HE_RU, rate);
+		rinfo->he_dcm = STA_STATS_GET(HE_DCM, rate);
+		break;
 	}
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 5609cacb20d5..12832842fe78 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -387,7 +387,7 @@ struct ieee80211_sta_rx_stats {
 	int last_signal;
 	u8 chains;
 	s8 chain_signal_last[IEEE80211_MAX_CHAINS];
-	u16 last_rate;
+	u32 last_rate;
 	struct u64_stats_sync syncp;
 	u64 bytes;
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
@@ -733,6 +733,7 @@ enum sta_stats_type {
 	STA_STATS_RATE_TYPE_LEGACY,
 	STA_STATS_RATE_TYPE_HT,
 	STA_STATS_RATE_TYPE_VHT,
+	STA_STATS_RATE_TYPE_HE,
 };
 
 #define STA_STATS_FIELD_HT_MCS		GENMASK( 7,  0)
@@ -740,9 +741,14 @@ enum sta_stats_type {
 #define STA_STATS_FIELD_LEGACY_BAND	GENMASK( 7,  4)
 #define STA_STATS_FIELD_VHT_MCS		GENMASK( 3,  0)
 #define STA_STATS_FIELD_VHT_NSS		GENMASK( 7,  4)
+#define STA_STATS_FIELD_HE_MCS		GENMASK( 3,  0)
+#define STA_STATS_FIELD_HE_NSS		GENMASK( 7,  4)
 #define STA_STATS_FIELD_BW		GENMASK(11,  8)
 #define STA_STATS_FIELD_SGI		GENMASK(12, 12)
 #define STA_STATS_FIELD_TYPE		GENMASK(15, 13)
+#define STA_STATS_FIELD_HE_RU		GENMASK(18, 16)
+#define STA_STATS_FIELD_HE_GI		GENMASK(20, 19)
+#define STA_STATS_FIELD_HE_DCM		GENMASK(21, 21)
 
 #define STA_STATS_FIELD(_n, _v)		FIELD_PREP(STA_STATS_FIELD_ ## _n, _v)
 #define STA_STATS_GET(_n, _v)		FIELD_GET(STA_STATS_FIELD_ ## _n, _v)
@@ -751,7 +757,7 @@ enum sta_stats_type {
 
 static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 {
-	u16 r;
+	u32 r;
 
 	r = STA_STATS_FIELD(BW, s->bw);
 
@@ -773,6 +779,14 @@ static inline u32 sta_stats_encode_rate(struct ieee80211_rx_status *s)
 		r |= STA_STATS_FIELD(LEGACY_BAND, s->band);
 		r |= STA_STATS_FIELD(LEGACY_IDX, s->rate_idx);
 		break;
+	case RX_ENC_HE:
+		r |= STA_STATS_FIELD(TYPE, STA_STATS_RATE_TYPE_HE);
+		r |= STA_STATS_FIELD(HE_NSS, s->nss);
+		r |= STA_STATS_FIELD(HE_MCS, s->rate_idx);
+		r |= STA_STATS_FIELD(HE_GI, s->he_gi);
+		r |= STA_STATS_FIELD(HE_RU, s->he_ru);
+		r |= STA_STATS_FIELD(HE_DCM, s->he_dcm);
+		break;
 	default:
 		WARN_ON(1);
 		return STA_STATS_RATE_INVALID;
-- 
2.11.0
