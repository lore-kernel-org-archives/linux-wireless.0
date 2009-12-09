Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60622 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757167AbZLIWAK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 17:00:10 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] wireless: report non-zero bitrate for MCS rates through wext
Date: Wed,  9 Dec 2009 16:46:05 -0500
Message-Id: <1260395165-7116-1-git-send-email-linville@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: John W. Linville <linville@tuxdriver.com>
---
 net/wireless/core.h        |    2 ++
 net/wireless/nl80211.c     |   37 ++-----------------------------------
 net/wireless/util.c        |   33 +++++++++++++++++++++++++++++++++
 net/wireless/wext-compat.c |    5 +----
 4 files changed, 38 insertions(+), 39 deletions(-)

diff --git a/net/wireless/core.h b/net/wireless/core.h
index 4ef3efc..35b7121 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -378,6 +378,8 @@ int rdev_set_freq(struct cfg80211_registered_device *rdev,
 		  struct wireless_dev *for_wdev,
 		  int freq, enum nl80211_channel_type channel_type);
 
+u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+
 #ifdef CONFIG_CFG80211_DEVELOPER_WARNINGS
 #define CFG80211_DEV_WARN_ON(cond)	WARN_ON(cond)
 #else
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index a602843..7cb0d64 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -1637,39 +1637,6 @@ static int parse_station_flags(struct genl_info *info,
 	return 0;
 }
 
-static u16 nl80211_calculate_bitrate(struct rate_info *rate)
-{
-	int modulation, streams, bitrate;
-
-	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
-		return rate->legacy;
-
-	/* the formula below does only work for MCS values smaller than 32 */
-	if (rate->mcs >= 32)
-		return 0;
-
-	modulation = rate->mcs & 7;
-	streams = (rate->mcs >> 3) + 1;
-
-	bitrate = (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
-			13500000 : 6500000;
-
-	if (modulation < 4)
-		bitrate *= (modulation + 1);
-	else if (modulation == 4)
-		bitrate *= (modulation + 2);
-	else
-		bitrate *= (modulation + 3);
-
-	bitrate *= streams;
-
-	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
-		bitrate = (bitrate / 9) * 10;
-
-	/* do NOT round down here */
-	return (bitrate + 50000) / 100000;
-}
-
 static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 				int flags, struct net_device *dev,
 				u8 *mac_addr, struct station_info *sinfo)
@@ -1716,8 +1683,8 @@ static int nl80211_send_station(struct sk_buff *msg, u32 pid, u32 seq,
 		if (!txrate)
 			goto nla_put_failure;
 
-		/* nl80211_calculate_bitrate will return 0 for mcs >= 32 */
-		bitrate = nl80211_calculate_bitrate(&sinfo->txrate);
+		/* cfg80211_calculate_bitrate will return 0 for mcs >= 32 */
+		bitrate = cfg80211_calculate_bitrate(&sinfo->txrate);
 		if (bitrate > 0)
 			NLA_PUT_U16(msg, NL80211_RATE_INFO_BITRATE, bitrate);
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 59361fd..a3c841a 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -720,3 +720,36 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 
 	return err;
 }
+
+u16 cfg80211_calculate_bitrate(struct rate_info *rate)
+{
+	int modulation, streams, bitrate;
+
+	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
+		return rate->legacy;
+
+	/* the formula below does only work for MCS values smaller than 32 */
+	if (rate->mcs >= 32)
+		return 0;
+
+	modulation = rate->mcs & 7;
+	streams = (rate->mcs >> 3) + 1;
+
+	bitrate = (rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) ?
+			13500000 : 6500000;
+
+	if (modulation < 4)
+		bitrate *= (modulation + 1);
+	else if (modulation == 4)
+		bitrate *= (modulation + 2);
+	else
+		bitrate *= (modulation + 3);
+
+	bitrate *= streams;
+
+	if (rate->flags & RATE_INFO_FLAGS_SHORT_GI)
+		bitrate = (bitrate / 9) * 10;
+
+	/* do NOT round down here */
+	return (bitrate + 50000) / 100000;
+}
diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 54face3..4198243 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -1257,10 +1257,7 @@ int cfg80211_wext_giwrate(struct net_device *dev,
 	if (!(sinfo.filled & STATION_INFO_TX_BITRATE))
 		return -EOPNOTSUPP;
 
-	rate->value = 0;
-
-	if (!(sinfo.txrate.flags & RATE_INFO_FLAGS_MCS))
-		rate->value = 100000 * sinfo.txrate.legacy;
+	rate->value = 100000 * cfg80211_calculate_bitrate(&sinfo.txrate);
 
 	return 0;
 }
-- 
1.6.2.5

