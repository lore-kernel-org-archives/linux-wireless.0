Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:8064 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2GAGqr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Jul 2012 02:46:47 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 60g v1 5/5] wireless: bitrate calculation for 60g
Date: Sun, 1 Jul 2012 09:45:54 +0300
Message-ID: <1341125155-628-6-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120701_084701_696221_DFC4F9B0)
In-Reply-To: <1341125155-628-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341125155-628-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

60g band uses different from .11n MCS scheme, so bitrate should be calculated
differently

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/net/cfg80211.h |    2 ++
 net/wireless/util.c    |   49 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 56e840d..f760520 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -563,11 +563,13 @@ enum station_info_flags {
  * @RATE_INFO_FLAGS_MCS: @tx_bitrate_mcs filled
  * @RATE_INFO_FLAGS_40_MHZ_WIDTH: 40 Mhz width transmission
  * @RATE_INFO_FLAGS_SHORT_GI: 400ns guard interval
+ * @RATE_INFO_FLAGS_60G: 60gHz MCS
  */
 enum rate_info_flags {
 	RATE_INFO_FLAGS_MCS		= 1<<0,
 	RATE_INFO_FLAGS_40_MHZ_WIDTH	= 1<<1,
 	RATE_INFO_FLAGS_SHORT_GI	= 1<<2,
+	RATE_INFO_FLAGS_60G		= 1<<3,
 };
 
 /**
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 11188c6..4fe1766 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -890,12 +890,61 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
+static u16 cfg80211_calculate_bitrate_60g(struct rate_info *rate)
+{
+	static const u16 __mcs2bitrate[] = {
+		/* control PHY */
+		[0] =   275,
+		/* SC PHY */
+		[1] =  3850,
+		[2] =  7700,
+		[3] =  9625,
+		[4] = 11550,
+		[5] = 12512, /* 1251.25 mbps */
+		[6] = 15400,
+		[7] = 19250,
+		[8] = 23100,
+		[9] = 25025,
+		[10] = 30800,
+		[11] = 38500,
+		[12] = 46200,
+		/* OFDM PHY */
+		[13] =  6930,
+		[14] =  8662, /* 866.25 mbps */
+		[15] = 13860,
+		[16] = 17325,
+		[17] = 20790,
+		[18] = 27720,
+		[19] = 34650,
+		[20] = 41580,
+		[21] = 45045,
+		[22] = 51975,
+		[23] = 62370,
+		[24] = 67568, /* 6756.75 mbps */
+		/* LP-SC PHY */
+		[25] =  6260,
+		[26] =  8340,
+		[27] = 11120,
+		[28] = 12510,
+		[29] = 16680,
+		[30] = 22240,
+		[31] = 25030,
+	};
+
+	if (WARN_ON_ONCE(rate->mcs >= ARRAY_SIZE(__mcs2bitrate)))
+		return 0;
+
+	return __mcs2bitrate[rate->mcs];
+}
+
 u16 cfg80211_calculate_bitrate(struct rate_info *rate)
 {
 	int modulation, streams, bitrate;
 
 	if (!(rate->flags & RATE_INFO_FLAGS_MCS))
 		return rate->legacy;
+	if (rate->flags & RATE_INFO_FLAGS_60G)
+		return cfg80211_calculate_bitrate_60g(rate);
 
 	/* the formula below does only work for MCS values smaller than 32 */
 	if (WARN_ON_ONCE(rate->mcs >= 32))
-- 
1.7.9.5

