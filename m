Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37011 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbbAOPRD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 10:17:03 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/3] cfg80211: remove 80+80 MHz rate reporting
Date: Thu, 15 Jan 2015 16:16:56 +0100
Message-Id: <1421335017-7409-2-git-send-email-johannes@sipsolutions.net> (sfid-20150115_161712_127032_D51CF138)
In-Reply-To: <1421335017-7409-1-git-send-email-johannes@sipsolutions.net>
References: <1421335017-7409-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

These rates are treated the same as 160 MHz in the spec, so
it makes no sense to distinguish them. As no driver uses them
yet, this is also not a problem, just remove them.

In the userspace API the field remains reserved to preserve
API and ABI.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/cfg80211.h       | 8 +++-----
 include/uapi/linux/nl80211.h | 3 ++-
 net/wireless/nl80211.c       | 3 ---
 net/wireless/util.c          | 3 +--
 4 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 38abc07503fd..0322048fddab 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -875,7 +875,6 @@ int cfg80211_check_station_change(struct wiphy *wiphy,
  * @RATE_INFO_FLAGS_VHT_MCS: mcs field filled with VHT MCS
  * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 MHz width transmission
  * @RATE_INFO_FLAGS_80_MHZ_WIDTH: 80 MHz width transmission
- * @RATE_INFO_FLAGS_80P80_MHZ_WIDTH: 80+80 MHz width transmission
  * @RATE_INFO_FLAGS_160_MHZ_WIDTH: 160 MHz width transmission
  * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
  * @RATE_INFO_FLAGS_60G: 60GHz MCS
@@ -885,10 +884,9 @@ enum rate_info_flags {
 	RATE_INFO_FLAGS_VHT_MCS			= BIT(1),
 	RATE_INFO_FLAGS_40_MHZ_WIDTH		= BIT(2),
 	RATE_INFO_FLAGS_80_MHZ_WIDTH		= BIT(3),
-	RATE_INFO_FLAGS_80P80_MHZ_WIDTH		= BIT(4),
-	RATE_INFO_FLAGS_160_MHZ_WIDTH		= BIT(5),
-	RATE_INFO_FLAGS_SHORT_GI		= BIT(6),
-	RATE_INFO_FLAGS_60G			= BIT(7),
+	RATE_INFO_FLAGS_160_MHZ_WIDTH		= BIT(4),
+	RATE_INFO_FLAGS_SHORT_GI		= BIT(5),
+	RATE_INFO_FLAGS_60G			= BIT(6),
 };
 
 /**
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index b6c1a00bd8d2..11cdb85ac646 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2278,7 +2278,8 @@ struct nl80211_sta_flag_update {
  * @NL80211_RATE_INFO_VHT_MCS: MCS index for VHT (u8)
  * @NL80211_RATE_INFO_VHT_NSS: number of streams in VHT (u8)
  * @NL80211_RATE_INFO_80_MHZ_WIDTH: 80 MHz VHT rate
- * @NL80211_RATE_INFO_80P80_MHZ_WIDTH: 80+80 MHz VHT rate
+ * @NL80211_RATE_INFO_80P80_MHZ_WIDTH: unused - 80+80 is treated the
+ *	same as 160 for purposes of the bitrates
  * @NL80211_RATE_INFO_160_MHZ_WIDTH: 160 MHz VHT rate
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 380784378df8..8998484ea970 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -3614,9 +3614,6 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 		if (info->flags & RATE_INFO_FLAGS_80_MHZ_WIDTH &&
 		    nla_put_flag(msg, NL80211_RATE_INFO_80_MHZ_WIDTH))
 			return false;
-		if (info->flags & RATE_INFO_FLAGS_80P80_MHZ_WIDTH &&
-		    nla_put_flag(msg, NL80211_RATE_INFO_80P80_MHZ_WIDTH))
-			return false;
 		if (info->flags & RATE_INFO_FLAGS_160_MHZ_WIDTH &&
 		    nla_put_flag(msg, NL80211_RATE_INFO_160_MHZ_WIDTH))
 			return false;
diff --git a/net/wireless/util.c b/net/wireless/util.c
index d0ac795445b7..6942d48f1ac5 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -1073,8 +1073,7 @@ static u32 cfg80211_calculate_bitrate_vht(struct rate_info *rate)
 	if (WARN_ON_ONCE(rate->mcs > 9))
 		return 0;
 
-	idx = rate->flags & (RATE_INFO_FLAGS_160_MHZ_WIDTH |
-			     RATE_INFO_FLAGS_80P80_MHZ_WIDTH) ? 3 :
+	idx = rate->flags & RATE_INFO_FLAGS_160_MHZ_WIDTH ? 3 :
 		  rate->flags & RATE_INFO_FLAGS_80_MHZ_WIDTH ? 2 :
 		  rate->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH ? 1 : 0;
 
-- 
2.1.4

