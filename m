Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:45098 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753824AbdBNP5q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Feb 2017 10:57:46 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 1/2] cfg80211: refactor cfg80211_calculate_bitrate()
Date: Tue, 14 Feb 2017 16:57:39 +0100
Message-Id: <20170214155740.6465-1-johannes@sipsolutions.net> (sfid-20170214_165830_253087_52C3785D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This function contains the HT calculations, which makes no
sense - split that out into a separate function. As a side
effect, this makes the 60G flag independent from HT_MCS so
remove the MCS one from wil6210 (also deleting a duplicate
assignment.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c |  3 +-
 net/wireless/util.c                         | 60 +++++++++++++++--------------
 2 files changed, 33 insertions(+), 30 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 83155b5ddbfb..79d107018eac 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -178,9 +178,8 @@ int wil_cid_fill_sinfo(struct wil6210_priv *wil, int cid,
 			BIT(NL80211_STA_INFO_RX_DROP_MISC) |
 			BIT(NL80211_STA_INFO_TX_FAILED);
 
-	sinfo->txrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
+	sinfo->txrate.flags = RATE_INFO_FLAGS_60G;
 	sinfo->txrate.mcs = le16_to_cpu(reply.evt.bf_mcs);
-	sinfo->rxrate.flags = RATE_INFO_FLAGS_MCS | RATE_INFO_FLAGS_60G;
 	sinfo->rxrate.mcs = stats->last_mcs_rx;
 	sinfo->rx_bytes = stats->rx_bytes;
 	sinfo->rx_packets = stats->rx_packets;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 68e5f2ecee1a..23ee3d66dfe0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1097,6 +1097,35 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
+static u32 cfg80211_calculate_bitrate_ht(struct rate_info *rate)
+{
+	int modulation, streams, bitrate;
+
+	/* the formula below does only work for MCS values smaller than 32 */
+	if (WARN_ON_ONCE(rate->mcs >= 32))
+		return 0;
+
+	modulation = rate->mcs & 7;
+	streams = (rate->mcs >> 3) + 1;
+
+	bitrate = (rate->bw == RATE_INFO_BW_40) ? 13500000 : 6500000;
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
+
 static u32 cfg80211_calculate_bitrate_60g(struct rate_info *rate)
 {
 	static const u32 __mcs2bitrate[] = {
@@ -1230,39 +1259,14 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 
 u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 {
-	int modulation, streams, bitrate;
-
-	if (!(rate->flags & RATE_INFO_FLAGS_MCS) &&
-	    !(rate->flags & RATE_INFO_FLAGS_VHT_MCS))
-		return rate->legacy;
+	if (rate->flags & RATE_INFO_FLAGS_MCS)
+		return cfg80211_calculate_bitrate_ht(rate);
 	if (rate->flags & RATE_INFO_FLAGS_60G)
 		return cfg80211_calculate_bitrate_60g(rate);
 	if (rate->flags & RATE_INFO_FLAGS_VHT_MCS)
 		return cfg80211_calculate_bitrate_vht(rate);
 
-	/* the formula below does only work for MCS values smaller than 32 */
-	if (WARN_ON_ONCE(rate->mcs >= 32))
-		return 0;
-
-	modulation = rate->mcs & 7;
-	streams = (rate->mcs >> 3) + 1;
-
-	bitrate = (rate->bw == RATE_INFO_BW_40) ? 13500000 : 6500000;
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
+	return rate->legacy;
 }
 EXPORT_SYMBOL(cfg80211_calculate_bitrate);
 
-- 
2.9.3
