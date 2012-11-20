Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42081 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2KTVoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:44:54 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 08/10] mac80211: support VHT rates in TX info
Date: Tue, 20 Nov 2012 22:45:14 +0100
Message-Id: <1353447916-17304-9-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224501_942157_88DA8A71)
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

To achieve this, limit the number of retries to
31 (instead of 255) and use the three bits that
are then free for VHT flags.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h | 36 +++++++++++++++++++++++++++++++++---
 net/mac80211/cfg.c     | 41 ++++++++++++++++++++++++-----------------
 2 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c846526..a183b5b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -499,9 +499,14 @@ enum mac80211_tx_control_flags {
  *	This is set if the current BSS requires ERP protection.
  * @IEEE80211_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
  * @IEEE80211_TX_RC_MCS: HT rate.
+ * @IEEE80211_TX_RC_VHT_MCS: VHT MCS rate, in this case the idx field is split
+ *	into a higher 4 bits (Nss) and lower 4 bits (MCS number)
  * @IEEE80211_TX_RC_GREEN_FIELD: Indicates whether this rate should be used in
  *	Greenfield mode.
  * @IEEE80211_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width should be 40 MHz.
+ * @IEEE80211_TX_RC_80_MHZ_WIDTH: Indicates 80 MHz transmission
+ * @IEEE80211_TX_RC_160_MHZ_WIDTH: Indicates 160 MHz transmission
+ *	(80+80 isn't supported yet)
  * @IEEE80211_TX_RC_DUP_DATA: The frame should be transmitted on both of the
  *	adjacent 20 MHz channels, if the current channel type is
  *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
@@ -512,12 +517,15 @@ enum mac80211_rate_control_flags {
 	IEEE80211_TX_RC_USE_CTS_PROTECT		= BIT(1),
 	IEEE80211_TX_RC_USE_SHORT_PREAMBLE	= BIT(2),
 
-	/* rate index is an MCS rate number instead of an index */
+	/* rate index is an HT/VHT MCS instead of an index */
 	IEEE80211_TX_RC_MCS			= BIT(3),
 	IEEE80211_TX_RC_GREEN_FIELD		= BIT(4),
 	IEEE80211_TX_RC_40_MHZ_WIDTH		= BIT(5),
 	IEEE80211_TX_RC_DUP_DATA		= BIT(6),
 	IEEE80211_TX_RC_SHORT_GI		= BIT(7),
+	IEEE80211_TX_RC_VHT_MCS			= BIT(8),
+	IEEE80211_TX_RC_80_MHZ_WIDTH		= BIT(9),
+	IEEE80211_TX_RC_160_MHZ_WIDTH		= BIT(10),
 };
 
 
@@ -560,10 +568,32 @@ enum mac80211_rate_control_flags {
  */
 struct ieee80211_tx_rate {
 	s8 idx;
-	u8 count;
-	u8 flags;
+	u16 count:5,
+	    flags:11;
 } __packed;
 
+#define IEEE80211_MAX_TX_RETRY		31
+
+static inline void ieee80211_rate_set_vht(struct ieee80211_tx_rate *rate,
+					  u8 mcs, u8 nss)
+{
+	WARN_ON(mcs & ~0xF);
+	WARN_ON(nss & ~0x7);
+	rate->idx = (nss << 4) | mcs;
+}
+
+static inline u8
+ieee80211_rate_get_vht_mcs(const struct ieee80211_tx_rate *rate)
+{
+	return rate->idx & 0xF;
+}
+
+static inline u8
+ieee80211_rate_get_vht_nss(const struct ieee80211_tx_rate *rate)
+{
+	return rate->idx >> 4;
+}
+
 /**
  * struct ieee80211_tx_info - skb transmit information
  *
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 0b9de4f..5d30e5f 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -370,31 +370,32 @@ static int ieee80211_config_default_mgmt_key(struct wiphy *wiphy,
 	return 0;
 }
 
-static void rate_idx_to_bitrate(struct rate_info *rate, struct sta_info *sta, int idx)
-{
-	enum ieee80211_band band = ieee80211_get_sdata_band(sta->sdata);
-
-	if (!(rate->flags & RATE_INFO_FLAGS_MCS) &&
-	    !(rate->flags & RATE_INFO_FLAGS_VHT_MCS)) {
-		struct ieee80211_supported_band *sband;
-		sband = sta->local->hw.wiphy->bands[band];
-		rate->legacy = sband->bitrates[idx].bitrate;
-	} else
-		rate->mcs = idx;
-}
-
 void sta_set_rate_info_tx(struct sta_info *sta,
 			  const struct ieee80211_tx_rate *rate,
 			  struct rate_info *rinfo)
 {
 	rinfo->flags = 0;
-	if (rate->flags & IEEE80211_TX_RC_MCS)
+	if (rate->flags & IEEE80211_TX_RC_MCS) {
 		rinfo->flags |= RATE_INFO_FLAGS_MCS;
+		rinfo->mcs = rate->idx;
+	} else if (rate->flags & IEEE80211_TX_RC_VHT_MCS) {
+		rinfo->flags |= RATE_INFO_FLAGS_VHT_MCS;
+		rinfo->mcs = ieee80211_rate_get_vht_mcs(rate);
+		rinfo->nss = ieee80211_rate_get_vht_nss(rate);
+	} else {
+		struct ieee80211_supported_band *sband;
+		sband = sta->local->hw.wiphy->bands[
+				ieee80211_get_sdata_band(sta->sdata)];
+		rinfo->legacy = sband->bitrates[rate->idx].bitrate;
+	}
 	if (rate->flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
 		rinfo->flags |= RATE_INFO_FLAGS_40_MHZ_WIDTH;
+	if (rate->flags & IEEE80211_TX_RC_80_MHZ_WIDTH)
+		rinfo->flags |= RATE_INFO_FLAGS_80_MHZ_WIDTH;
+	if (rate->flags & IEEE80211_TX_RC_160_MHZ_WIDTH)
+		rinfo->flags |= RATE_INFO_FLAGS_160_MHZ_WIDTH;
 	if (rate->flags & IEEE80211_TX_RC_SHORT_GI)
 		rinfo->flags |= RATE_INFO_FLAGS_SHORT_GI;
-	rate_idx_to_bitrate(rinfo, sta, rate->idx);
 }
 
 static void sta_set_sinfo(struct sta_info *sta, struct station_info *sinfo)
@@ -2003,10 +2004,16 @@ static int ieee80211_set_wiphy_params(struct wiphy *wiphy, u32 changed)
 			return err;
 	}
 
-	if (changed & WIPHY_PARAM_RETRY_SHORT)
+	if (changed & WIPHY_PARAM_RETRY_SHORT) {
+		if (wiphy->retry_short > IEEE80211_MAX_TX_RETRY)
+			return -EINVAL;
 		local->hw.conf.short_frame_max_tx_count = wiphy->retry_short;
-	if (changed & WIPHY_PARAM_RETRY_LONG)
+	}
+	if (changed & WIPHY_PARAM_RETRY_LONG) {
+		if (wiphy->retry_long > IEEE80211_MAX_TX_RETRY)
+			return -EINVAL;
 		local->hw.conf.long_frame_max_tx_count = wiphy->retry_long;
+	}
 	if (changed &
 	    (WIPHY_PARAM_RETRY_SHORT | WIPHY_PARAM_RETRY_LONG))
 		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_RETRY_LIMITS);
-- 
1.8.0

