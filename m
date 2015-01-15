Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37013 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142AbbAOPRD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 10:17:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/3] cfg80211: change bandwidth reporting to explicit field
Date: Thu, 15 Jan 2015 16:16:57 +0100
Message-Id: <1421335017-7409-3-git-send-email-johannes@sipsolutions.net> (sfid-20150115_161710_268493_184C04E6)
In-Reply-To: <1421335017-7409-1-git-send-email-johannes@sipsolutions.net>
References: <1421335017-7409-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

For some reason, we made the bandwidth separate flags, which
is rather confusing - a single rate cannot have different
bandwidths at the same time.

Change this to no longer be flags but use a separate field
for the bandwidth ('bw') instead.

While at it, add support for 5 and 10 MHz rates - these are
reported as regular legacy rates with their real bitrate,
but tagged as 5/10 now to make it easier to distinguish them.

In the nl80211 API, the flags are preserved, but the code
now can also clearly only set a single one of the flags.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/ath6kl/cfg80211.c |  3 ++-
 drivers/net/wireless/mwifiex/cfg80211.c    | 11 ++++----
 include/net/cfg80211.h                     | 33 ++++++++++++++++++------
 include/uapi/linux/nl80211.h               |  8 ++++++
 net/mac80211/cfg.c                         | 31 +++++++++++++++--------
 net/mac80211/util.c                        | 25 +++++++++++++------
 net/wireless/nl80211.c                     | 40 +++++++++++++++++++++---------
 net/wireless/util.c                        | 23 +++++++++++++----
 8 files changed, 124 insertions(+), 50 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
index 44dd6ef923cd..85da63a67faf 100644
--- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
+++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
@@ -1827,6 +1827,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 		}
 
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
+		sinfo->txrate.bw = RATE_INFO_BW_20;
 	} else if (is_rate_ht40(rate, &mcs, &sgi)) {
 		if (sgi) {
 			sinfo->txrate.flags |= RATE_INFO_FLAGS_SHORT_GI;
@@ -1835,7 +1836,7 @@ static int ath6kl_get_station(struct wiphy *wiphy, struct net_device *dev,
 			sinfo->txrate.mcs = mcs;
 		}
 
-		sinfo->txrate.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+		sinfo->txrate.bw = RATE_INFO_BW_40;
 		sinfo->txrate.flags |= RATE_INFO_FLAGS_MCS;
 	} else {
 		ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
diff --git a/drivers/net/wireless/mwifiex/cfg80211.c b/drivers/net/wireless/mwifiex/cfg80211.c
index 71312ff52703..1996a8b612d2 100644
--- a/drivers/net/wireless/mwifiex/cfg80211.c
+++ b/drivers/net/wireless/mwifiex/cfg80211.c
@@ -856,16 +856,16 @@ mwifiex_parse_htinfo(struct mwifiex_private *priv, u8 tx_htinfo,
 			/* HT or VHT */
 			switch (tx_htinfo & (BIT(3) | BIT(2))) {
 			case 0:
-				/* This will be 20MHz */
+				rate->bw = RATE_INFO_BW_20;
 				break;
 			case (BIT(2)):
-				rate->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+				rate->bw = RATE_INFO_BW_40;
 				break;
 			case (BIT(3)):
-				rate->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
+				rate->bw = RATE_INFO_BW_80;
 				break;
 			case (BIT(3) | BIT(2)):
-				rate->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
+				rate->bw = RATE_INFO_BW_160;
 				break;
 			}
 
@@ -885,8 +885,9 @@ mwifiex_parse_htinfo(struct mwifiex_private *priv, u8 tx_htinfo,
 		if ((tx_htinfo & BIT(0)) && (priv->tx_rate < 16)) {
 			rate->mcs = priv->tx_rate;
 			rate->flags |= RATE_INFO_FLAGS_MCS;
+			rate->bw = RATE_INFO_BW_20;
 			if (tx_htinfo & BIT(1))
-				rate->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+				rate->bw = RATE_INFO_BW_40;
 			if (tx_htinfo & BIT(2))
 				rate->flags |= RATE_INFO_FLAGS_SHORT_GI;
 		}
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0322048fddab..7b44ba0a7632 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -873,20 +873,35 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
  *
  * @RATE_INFO_FLAGS_MCS: mcs field filled with HT MCS
  * @RATE_INFO_FLAGS_VHT_MCS: mcs field filled with VHT MCS
- * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 MHz width transmission
- * @RATE_INFO_FLAGS_80_MHZ_WIDTH: 80 MHz width transmission
- * @RATE_INFO_FLAGS_160_MHZ_WIDTH: 160 MHz width transmission
  * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
  * @RATE_INFO_FLAGS_60G: 60GHz MCS
  */
 enum rate_info_flags {
 	RATE_INFO_FLAGS_MCS			= BIT(0),
 	RATE_INFO_FLAGS_VHT_MCS			= BIT(1),
-	RATE_INFO_FLAGS_40_MHZ_WIDTH		= BIT(2),
-	RATE_INFO_FLAGS_80_MHZ_WIDTH		= BIT(3),
-	RATE_INFO_FLAGS_160_MHZ_WIDTH		= BIT(4),
-	RATE_INFO_FLAGS_SHORT_GI		= BIT(5),
-	RATE_INFO_FLAGS_60G			= BIT(6),
+	RATE_INFO_FLAGS_SHORT_GI		= BIT(2),
+	RATE_INFO_FLAGS_60G			= BIT(3),
+};
+
+/**
+ * enum rate_info_bw - rate bandwidth information
+ *
+ * Used by the driver to indicate the rate bandwidth.
+ *
+ * @RATE_INFO_BW_5: 5 MHz bandwidth
+ * @RATE_INFO_BW_10: 10 MHz bandwidth
+ * @RATE_INFO_BW_20: 20 MHz bandwidth
+ * @RATE_INFO_BW_40: 40 MHz bandwidth
+ * @RATE_INFO_BW_80: 80 MHz bandwidth
+ * @RATE_INFO_BW_160: 160 MHz bandwidth
+ */
+enum rate_info_bw {
+	RATE_INFO_BW_5,
+	RATE_INFO_BW_10,
+	RATE_INFO_BW_20,
+	RATE_INFO_BW_40,
+	RATE_INFO_BW_80,
+	RATE_INFO_BW_160,
 };
 
 /**
@@ -898,12 +913,14 @@ enum rate_info_flags {
  * @mcs: mcs index if struct describes a 802.11n bitrate
  * @legacy: bitrate in 100kbit/s for 802.11abg
  * @nss: number of streams (VHT only)
+ * @bw: bandwidth (from &enum rate_info_bw)
  */
 struct rate_info {
 	u8 flags;
 	u8 mcs;
 	u16 legacy;
 	u8 nss;
+	u8 bw;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 11cdb85ac646..f52797a90816 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2281,6 +2281,12 @@ struct nl80211_sta_flag_update {
  * @NL80211_RATE_INFO_80P80_MHZ_WIDTH: unused - 80+80 is treated the
  *	same as 160 for purposes of the bitrates
  * @NL80211_RATE_INFO_160_MHZ_WIDTH: 160 MHz VHT rate
+ * @NL80211_RATE_INFO_10_MHZ_WIDTH: 10 MHz width - note that this is
+ *	a legacy rate and will be reported as the actual bitrate, i.e.
+ *	half the base (20 MHz) rate
+ * @NL80211_RATE_INFO_5_MHZ_WIDTH: 5 MHz width - note that this is
+ *	a legacy rate and will be reported as the actual bitrate, i.e.
+ *	a quarter of the base (20 MHz) rate
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
 enum nl80211_rate_info {
@@ -2295,6 +2301,8 @@ enum nl80211_rate_info {
 	NL80211_RATE_INFO_80_MHZ_WIDTH,
 	NL80211_RATE_INFO_80P80_MHZ_WIDTH,
 	NL80211_RATE_INFO_160_MHZ_WIDTH,
+	NL80211_RATE_INFO_10_MHZ_WIDTH,
+	NL80211_RATE_INFO_5_MHZ_WIDTH,
 
 	/* keep last */
 	__NL80211_RATE_INFO_AFTER_LAST,
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 6d5076fbf87a..ff090ef1ea2c 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -428,11 +428,13 @@ void sta_set_rate_info_tx(struct sta_info *sta,
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 	}
 	if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
-		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-	if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
-		rinfo->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-	if (rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
-		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
+		rinfo->bw = RATE_INFO_BW_40;
+	else if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		rinfo->bw = RATE_INFO_BW_80;
+	else if (rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+		rinfo->bw = RATE_INFO_BW_160;
+	else
+		rinfo->bw = RATE_INFO_BW_20;
 	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
 }
@@ -459,14 +461,21 @@ void sta_set_rate_info_rx(struct sta_info *sta, struct rate_info *rinfo)
 		rinfo->legacy = DIV_ROUND_UP(brate, 1 << shift);
 	}
 
-	if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
-		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
 	if (sta->last_rx_rate_flag & RX_FLAG_SHORT_GI)
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
-	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80MHZ)
-		rinfo->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-	if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_160MHZ)
-		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
+
+	if (sta->last_rx_rate_flag & RX_FLAG_5MHZ)
+		rinfo->bw = RATE_INFO_BW_5;
+	else if (sta->last_rx_rate_flag & RX_FLAG_10MHZ)
+		rinfo->bw = RATE_INFO_BW_10;
+	else if (sta->last_rx_rate_flag & RX_FLAG_40MHZ)
+		rinfo->bw = RATE_INFO_BW_40;
+	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_80MHZ)
+		rinfo->bw = RATE_INFO_BW_80;
+	else if (sta->last_rx_rate_vht_flag & RX_VHT_FLAG_160MHZ)
+		rinfo->bw = RATE_INFO_BW_160;
+	else
+		rinfo->bw = RATE_INFO_BW_20;
 }
 
 static int ieee80211_dump_station(struct wiphy *wiphy, struct net_device *dev,
diff --git a/net/mac80211/util.c b/net/mac80211/util.c
index db7216124736..fbd37d43dfce 100644
--- a/net/mac80211/util.c
+++ b/net/mac80211/util.c
@@ -2541,7 +2541,9 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		ri.mcs = status->rate_idx;
 		ri.flags |= RATE_INFO_FLAGS_MCS;
 		if (status->flag & RX_FLAG_40MHZ)
-			ri.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+			ri.bw = RATE_INFO_BW_40;
+		else
+			ri.bw = RATE_INFO_BW_20;
 		if (status->flag & RX_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 	} else if (status->flag & RX_FLAG_VHT) {
@@ -2549,11 +2551,13 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		ri.mcs = status->rate_idx;
 		ri.nss = status->vht_nss;
 		if (status->flag & RX_FLAG_40MHZ)
-			ri.flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
-		if (status->vht_flag & RX_VHT_FLAG_80MHZ)
-			ri.flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
-		if (status->vht_flag & RX_VHT_FLAG_160MHZ)
-			ri.flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
+			ri.bw = RATE_INFO_BW_40;
+		else if (status->vht_flag & RX_VHT_FLAG_80MHZ)
+			ri.bw = RATE_INFO_BW_80;
+		else if (status->vht_flag & RX_VHT_FLAG_160MHZ)
+			ri.bw = RATE_INFO_BW_160;
+		else
+			ri.bw = RATE_INFO_BW_20;
 		if (status->flag & RX_FLAG_SHORT_GI)
 			ri.flags |= RATE_INFO_FLAGS_SHORT_GI;
 	} else {
@@ -2561,10 +2565,15 @@ u64 ieee80211_calculate_rx_timestamp(struct ieee80211_local *local,
 		int shift = 0;
 		int bitrate;
 
-		if (status->flag & RX_FLAG_10MHZ)
+		if (status->flag & RX_FLAG_10MHZ) {
 			shift = 1;
-		if (status->flag & RX_FLAG_5MHZ)
+			ri.bw = RATE_INFO_BW_10;
+		} else if (status->flag & RX_FLAG_5MHZ) {
 			shift = 2;
+			ri.bw = RATE_INFO_BW_5;
+		} else {
+			ri.bw = RATE_INFO_BW_20;
+		}
 
 		sband = local->hw.wiphy->bands[status->band];
 		bitrate = sband->bitrates[status->rate_idx].bitrate;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 8998484ea970..8e56eeb583aa 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3578,6 +3578,7 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 	struct nlattr *rate;
 	u32 bitrate;
 	u16 bitrate_compat;
+	enum nl80211_attrs rate_flg;
 
 	rate = nla_nest_start(msg, attr);
 	if (!rate)
@@ -3594,12 +3595,36 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 	    nla_put_u16(msg, NL80211_RATE_INFO_BITRATE, bitrate_compat))
 		return false;
 
+	switch (info->bw) {
+	case RATE_INFO_BW_5:
+		rate_flg = NL80211_RATE_INFO_5_MHZ_WIDTH;
+		break;
+	case RATE_INFO_BW_10:
+		rate_flg = NL80211_RATE_INFO_10_MHZ_WIDTH;
+		break;
+	default:
+		WARN_ON(1);
+		/* fall through */
+	case RATE_INFO_BW_20:
+		rate_flg = 0;
+		break;
+	case RATE_INFO_BW_40:
+		rate_flg = NL80211_RATE_INFO_40_MHZ_WIDTH;
+		break;
+	case RATE_INFO_BW_80:
+		rate_flg = NL80211_RATE_INFO_80_MHZ_WIDTH;
+		break;
+	case RATE_INFO_BW_160:
+		rate_flg = NL80211_RATE_INFO_160_MHZ_WIDTH;
+		break;
+	}
+
+	if (rate_flg && nla_put_flag(msg, rate_flg))
+		return false;
+
 	if (info->flags & RATE_INFO_FLAGS_MCS) {
 		if (nla_put_u8(msg, NL80211_RATE_INFO_MCS, info->mcs))
 			return false;
-		if (info->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH &&
-		    nla_put_flag(msg, NL80211_RATE_INFO_40_MHZ_WIDTH))
-			return false;
 		if (info->flags & RATE_INFO_FLAGS_SHORT_GI &&
 		    nla_put_flag(msg, NL80211_RATE_INFO_SHORT_GI))
 			return false;
@@ -3608,15 +3633,6 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 			return false;
 		if (nla_put_u8(msg, NL80211_RATE_INFO_VHT_NSS, info->nss))
 			return false;
-		if (info->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH &&
-		    nla_put_flag(msg, NL80211_RATE_INFO_40_MHZ_WIDTH))
-			return false;
-		if (info->flags & RATE_INFO_FLAGS_80_MHZ_WIDTH &&
-		    nla_put_flag(msg, NL80211_RATE_INFO_80_MHZ_WIDTH))
-			return false;
-		if (info->flags & RATE_INFO_FLAGS_160_MHZ_WIDTH &&
-		    nla_put_flag(msg, NL80211_RATE_INFO_160_MHZ_WIDTH))
-			return false;
 		if (info->flags & RATE_INFO_FLAGS_SHORT_GI &&
 		    nla_put_flag(msg, NL80211_RATE_INFO_SHORT_GI))
 			return false;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 6942d48f1ac5..2344dec74c86 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1073,9 +1073,23 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 	if (WARN_ON_ONCE(rate->mcs > 9))
 		return 0;
 
-	idx = rate->flags & RATE_INFO_FLAGS_160_MHZ_WIDTH ? 3 :
-		  rate->flags & RATE_INFO_FLAGS_80_MHZ_WIDTH ? 2 :
-		  rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH ? 1 : 0;
+	switch (rate->bw) {
+	case RATE_INFO_BW_160:
+		idx = 3;
+		break;
+	case RATE_INFO_BW_80:
+		idx = 2;
+		break;
+	case RATE_INFO_BW_40:
+		idx = 1;
+		break;
+	case RATE_INFO_BW_5:
+	case RATE_INFO_BW_10:
+		WARN_ON(1);
+		/* fall through */
+	case RATE_INFO_BW_20:
+		idx = 0;
+	}
 
 	bitrate = base[idx][rate->mcs];
 	bitrate *= rate->nss;
@@ -1106,8 +1120,7 @@ u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 	modulation = rate->mcs & 7;
 	streams = (rate->mcs >> 3) + 1;
 
-	bitrate = (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
-			13500000 : 6500000;
+	bitrate = (rate->bw == RATE_INFO_BW_40) ? 13500000 : 6500000;
 
 	if (modulation < 4)
 		bitrate *= (modulation + 1);
-- 
2.1.4

