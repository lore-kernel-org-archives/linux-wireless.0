Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54826 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab2KIURE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Nov 2012 15:17:04 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC v2 6/8] nl80211/cfg80211: add VHT MCS support
Date: Fri,  9 Nov 2012 21:17:32 +0100
Message-Id: <1352492254-29399-7-git-send-email-johannes@sipsolutions.net> (sfid-20121109_211717_583017_4D40DD6D)
In-Reply-To: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
References: <1352492254-29399-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Add support for reporting and calculating VHT MCSes.

Note that I'm not completely sure that the bitrate
calculations are correct, nor that they can't be
simplified.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 24 +++++++++-----
 include/uapi/linux/nl80211.h | 12 ++++++-
 net/wireless/nl80211.c       | 58 +++++++++++++++++++++++++---------
 net/wireless/util.c          | 74 +++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 144 insertions(+), 24 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0712421..fe0c8f5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -662,16 +662,24 @@ enum station_info_flags {
  * Used by the driver to indicate the specific rate transmission
  * type for 802.11n transmissions.
  *
- * @RATE_INFO_FLAGS_MCS: @tx_bitrate_mcs filled
- * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 Mhz width transmission
+ * @RATE_INFO_FLAGS_MCS: mcs field filled with HT MCS
+ * @RATE_INFO_FLAGS_VHT_MCS: mcs field filled with VHT MCS
+ * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 MHz width transmission
+ * @RATE_INFO_FLAGS_80_MHZ_WIDTH: 80 MHz width transmission
+ * @RATE_INFO_FLAGS_80P80_MHZ_WIDTH: 80+80 MHz width transmission
+ * @RATE_INFO_FLAGS_160_MHZ_WIDTH: 160 MHz width transmission
  * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
- * @RATE_INFO_FLAGS_60G: 60gHz MCS
+ * @RATE_INFO_FLAGS_60G: 60GHz MCS
  */
 enum rate_info_flags {
-	RATE_INFO_FLAGS_MCS		= 1<<0,
-	RATE_INFO_FLAGS_40_MHZ_WIDTH	= 1<<1,
-	RATE_INFO_FLAGS_SHORT_GI	= 1<<2,
-	RATE_INFO_FLAGS_60G		= 1<<3,
+	RATE_INFO_FLAGS_MCS			= BIT(0),
+	RATE_INFO_FLAGS_VHT_MCS			= BIT(1),
+	RATE_INFO_FLAGS_40_MHZ_WIDTH		= BIT(2),
+	RATE_INFO_FLAGS_80_MHZ_WIDTH		= BIT(3),
+	RATE_INFO_FLAGS_80P80_MHZ_WIDTH		= BIT(4),
+	RATE_INFO_FLAGS_160_MHZ_WIDTH		= BIT(5),
+	RATE_INFO_FLAGS_SHORT_GI		= BIT(6),
+	RATE_INFO_FLAGS_60G			= BIT(7),
 };
 
 /**
@@ -682,11 +690,13 @@ enum rate_info_flags {
  * @flags: bitflag of flags from &enum rate_info_flags
  * @mcs: mcs index if struct describes a 802.11n bitrate
  * @legacy: bitrate in 100kbit/s for 802.11abg
+ * @nss: number of streams (VHT only)
  */
 struct rate_info {
 	u8 flags;
 	u8 mcs;
 	u16 legacy;
+	u8 nss;
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index ea33515..71b20cc 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1732,10 +1732,15 @@ struct nl80211_sta_flag_update {
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
- * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
+ * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 MHz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
  * @NL80211_RATE_INFO_BITRATE32: total bitrate (u32, 100kbit/s)
  * @NL80211_RATE_INFO_MAX: highest rate_info number currently defined
+ * @NL80211_RATE_INFO_VHT_MCS: MCS index for VHT (u8)
+ * @NL80211_RATE_INFO_VHT_NSS: number of streams in VHT (u8)
+ * @NL80211_RATE_INFO_80_MHZ_WIDTH: 80 MHz VHT rate
+ * @NL80211_RATE_INFO_80P80_MHZ_WIDTH: 80+80 MHz VHT rate
+ * @NL80211_RATE_INFO_160_MHZ_WIDTH: 160 MHz VHT rate
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
 enum nl80211_rate_info {
@@ -1745,6 +1750,11 @@ enum nl80211_rate_info {
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
 	NL80211_RATE_INFO_BITRATE32,
+	NL80211_RATE_INFO_VHT_MCS,
+	NL80211_RATE_INFO_VHT_NSS,
+	NL80211_RATE_INFO_80_MHZ_WIDTH,
+	NL80211_RATE_INFO_80P80_MHZ_WIDTH,
+	NL80211_RATE_INFO_160_MHZ_WIDTH,
 
 	/* keep last */
 	__NL80211_RATE_INFO_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6c9c6bc..2d03380 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2905,29 +2905,52 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 
 	rate = nla_nest_start(msg, attr);
 	if (!rate)
-		goto nla_put_failure;
+		return false;
 
 	/* cfg80211_calculate_bitrate will return 0 for mcs >= 32 */
 	bitrate = cfg80211_calculate_bitrate(info);
 	/* report 16-bit bitrate only if we can */
 	bitrate_compat = bitrate < (1UL << 16) ? bitrate : 0;
-	if ((bitrate > 0 &&
-	     nla_put_u32(msg, NL80211_RATE_INFO_BITRATE32, bitrate)) ||
-	    (bitrate_compat > 0 &&
-	     nla_put_u16(msg, NL80211_RATE_INFO_BITRATE, bitrate_compat)) ||
-	    ((info->flags & RATE_INFO_FLAGS_MCS) &&
-	     nla_put_u8(msg, NL80211_RATE_INFO_MCS, info->mcs)) ||
-	    ((info->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) &&
-	     nla_put_flag(msg, NL80211_RATE_INFO_40_MHZ_WIDTH)) ||
-	    ((info->flags & RATE_INFO_FLAGS_SHORT_GI) &&
-	     nla_put_flag(msg, NL80211_RATE_INFO_SHORT_GI)))
-		goto nla_put_failure;
+	if (bitrate > 0 &&
+	    nla_put_u32(msg, NL80211_RATE_INFO_BITRATE32, bitrate))
+		return false;
+	if (bitrate_compat > 0 &&
+	    nla_put_u16(msg, NL80211_RATE_INFO_BITRATE, bitrate_compat))
+		return false;
+
+	if (info->flags & RATE_INFO_FLAGS_MCS) {
+		if (nla_put_u8(msg, NL80211_RATE_INFO_MCS, info->mcs))
+			return false;
+		if (info->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH &&
+		    nla_put_flag(msg, NL80211_RATE_INFO_40_MHZ_WIDTH))
+			return false;
+		if (info->flags & RATE_INFO_FLAGS_SHORT_GI &&
+		    nla_put_flag(msg, NL80211_RATE_INFO_SHORT_GI))
+			return false;
+	} else if (info->flags & RATE_INFO_FLAGS_VHT_MCS) {
+		if (nla_put_u8(msg, NL80211_RATE_INFO_VHT_MCS, info->mcs))
+			return false;
+		if (nla_put_u8(msg, NL80211_RATE_INFO_VHT_NSS, info->nss))
+			return false;
+		if (info->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH &&
+		    nla_put_flag(msg, NL80211_RATE_INFO_40_MHZ_WIDTH))
+			return false;
+		if (info->flags & RATE_INFO_FLAGS_80_MHZ_WIDTH &&
+		    nla_put_flag(msg, NL80211_RATE_INFO_80_MHZ_WIDTH))
+			return false;
+		if (info->flags & RATE_INFO_FLAGS_80P80_MHZ_WIDTH &&
+		    nla_put_flag(msg, NL80211_RATE_INFO_80P80_MHZ_WIDTH))
+			return false;
+		if (info->flags & RATE_INFO_FLAGS_160_MHZ_WIDTH &&
+		    nla_put_flag(msg, NL80211_RATE_INFO_160_MHZ_WIDTH))
+			return false;
+		if (info->flags & RATE_INFO_FLAGS_SHORT_GI &&
+		    nla_put_flag(msg, NL80211_RATE_INFO_SHORT_GI))
+			return false;
+	}
 
 	nla_nest_end(msg, rate);
 	return true;
-
-nla_put_failure:
-	return false;
 }
 
 static int nl80211_send_station(struct sk_buff *msg, u32 portid, u32 seq,
@@ -5514,6 +5537,11 @@ static int nl80211_join_ibss(struct sk_buff *skb, struct genl_info *info)
 	if (!cfg80211_reg_can_beacon(&rdev->wiphy, &ibss.chandef))
 		return -EINVAL;
 
+	if (ibss.chandef.width > NL80211_CHAN_WIDTH_40)
+		return -EINVAL;
+	if (ibss.chandef.width != NL80211_CHAN_WIDTH_20_NOHT &&
+	    !(rdev->wiphy.features & NL80211_FEATURE_HT_IBSS))
+
 	ibss.channel_fixed = !!info->attrs[NL80211_ATTR_FREQ_FIXED];
 	ibss.privacy = !!info->attrs[NL80211_ATTR_PRIVACY];
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 2964223..ae8f050 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -944,14 +944,86 @@ static u32 cfg80211_calculate_bitrate_60g(struct rate_info *rate)
 	return __mcs2bitrate[rate->mcs];
 }
 
+static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
+{
+	static const u32 base[4][10] = {
+		{   6500000,
+		   13000000,
+		   19500000,
+		   26000000,
+		   39000000,
+		   52000000,
+		   58500000,
+		   65000000,
+		   78000000,
+		   0,
+		},
+		{  13500000,
+		   27000000,
+		   40500000,
+		   54000000,
+		   81000000,
+		  108000000,
+		  121500000,
+		  135000000,
+		  162000000,
+		  180000000,
+		},
+		{  29300000,
+		   58500000,
+		   87800000,
+		  117000000,
+		  175500000,
+		  234000000,
+		  263300000,
+		  292500000,
+		  351000000,
+		  390000000,
+		},
+		{  58500000,
+		  117000000,
+		  175500000,
+		  234000000,
+		  351000000,
+		  468000000,
+		  526500000,
+		  585000000,
+		  702000000,
+		  780000000,
+		},
+	};
+	u32 bitrate;
+	int idx;
+
+	if (WARN_ON_ONCE(rate->mcs > 9))
+		return 0;
+
+	idx = rate->flags & (RATE_INFO_FLAGS_160_MHZ_WIDTH |
+			     RATE_INFO_FLAGS_80P80_MHZ_WIDTH) ? 3 :
+		  rate->flags & RATE_INFO_FLAGS_80_MHZ_WIDTH ? 2 :
+		  rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH ? 1 : 0;
+
+	bitrate = base[idx][rate->mcs];
+	bitrate *= rate->nss;
+
+	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
+		bitrate = (bitrate / 9) * 10;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
+
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 {
 	int modulation, streams, bitrate;
 
-	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS) &&
+	    !(rate->flags & RATE_INFO_FLAGS_VHT_MCS))
 		return rate->legacy;
 	if (rate->flags & RATE_INFO_FLAGS_60G)
 		return cfg80211_calculate_bitrate_60g(rate);
+	if (rate->flags & RATE_INFO_FLAGS_VHT_MCS)
+		return cfg80211_calculate_bitrate_vht(rate);
 
 	/* the formula below does only work for MCS values smaller than 32 */
 	if (WARN_ON_ONCE(rate->mcs >= 32))
-- 
1.8.0

