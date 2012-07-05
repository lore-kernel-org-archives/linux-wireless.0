Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34028 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754727Ab2GEL0H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jul 2012 07:26:07 -0400
Cc: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	"Luis R . Rodriguez" <rodrigue@qca.qualcomm.com>
From: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
To: "John W . Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH v2 1/2] {nl,cfg}80211: support high bitrates
Date: Thu, 5 Jul 2012 14:25:49 +0300
Message-ID: <1341487550-11502-2-git-send-email-qca_vkondrat@qca.qualcomm.com> (sfid-20120705_132612_436054_ADC3BF24)
In-Reply-To: <1341487550-11502-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
References: <1341487550-11502-1-git-send-email-qca_vkondrat@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Until now, u16 value was used to represent bitrate value.
With recently introduced high bitrates, u16 becomes too small.

Thus, new 32-bit bitrate introduced.
nl80211 reports both new bitrate and old one, in case it
fits into u16. If bitrate is too high for u16, only new (32 bit)
value reported

User space tools encouraged to switch to new bitrate.

Signed-off-by: Vladimir Kondratiev <qca_vkondrat@qca.qualcomm.com>
---
 include/linux/nl80211.h |    8 ++++++++
 include/net/cfg80211.h  |    2 +-
 net/wireless/nl80211.c  |    9 +++++++--
 net/wireless/util.c     |    2 +-
 4 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index 74cc55c..179bd3a 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -1638,12 +1638,19 @@ struct nl80211_sta_flag_update {
  *
  * These attribute types are used with %NL80211_STA_INFO_TXRATE
  * when getting information about the bitrate of a station.
+ * There are 2 types for bitrate, legacy one that represents
+ * 16-bit value, and new one that represents 32-bit value.
+ * If rate value fits into 16 bit, both attributes reported with
+ * the same value. If rate is too high to fit into 16 bit (>6.5535Gbps),
+ * only new value included.
+ * User space tools encouraged to use new bitrate.
  *
  * @__NL80211_RATE_INFO_INVALID: attribute number 0 is reserved
  * @NL80211_RATE_INFO_BITRATE: total bitrate (u16, 100kbit/s)
  * @NL80211_RATE_INFO_MCS: mcs index for 802.11n (u8)
  * @NL80211_RATE_INFO_40_MHZ_WIDTH: 40 Mhz dualchannel bitrate
  * @NL80211_RATE_INFO_SHORT_GI: 400ns guard interval
+ * @NL80211_RATE_INFO_BITRATE32: total bitrate (u32, 100kbit/s)
  * @NL80211_RATE_INFO_MAX: highest rate_info number currently defined
  * @__NL80211_RATE_INFO_AFTER_LAST: internal use
  */
@@ -1653,6 +1660,7 @@ enum nl80211_rate_info {
 	NL80211_RATE_INFO_MCS,
 	NL80211_RATE_INFO_40_MHZ_WIDTH,
 	NL80211_RATE_INFO_SHORT_GI,
+	NL80211_RATE_INFO_BITRATE32,
 
 	/* keep last */
 	__NL80211_RATE_INFO_AFTER_LAST,
diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0b564e8..8837efc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3487,7 +3487,7 @@ void cfg80211_ch_switch_notify(struct net_device *dev, int freq,
  *
  * return 0 if MCS index >= 32
  */
-u16 cfg80211_calculate_bitrate(struct rate_info *rate);
+u32 cfg80211_calculate_bitrate(struct rate_info *rate);
 
 /* Logging, debugging and troubleshooting/diagnostic helpers. */
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 77102e6..2a5cdb6 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2618,7 +2618,8 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 				 int attr)
 {
 	struct nlattr *rate;
-	u16 bitrate;
+	u32 bitrate;
+	u16 bitrate_compat;
 
 	rate = nla_nest_start(msg, attr);
 	if (!rate)
@@ -2626,8 +2627,12 @@ static bool nl80211_put_sta_rate(struct sk_buff *msg, struct rate_info *info,
 
 	/* cfg80211_calculate_bitrate will return 0 for mcs >= 32 */
 	bitrate = cfg80211_calculate_bitrate(info);
+	/* report 16-bit bitrate only if we can */
+	bitrate_compat = bitrate < (1UL << 16) ? bitrate : 0;
 	if ((bitrate > 0 &&
-	     nla_put_u16(msg, NL80211_RATE_INFO_BITRATE, bitrate)) ||
+	     nla_put_u32(msg, NL80211_RATE_INFO_BITRATE32, bitrate)) ||
+	    (bitrate_compat > 0 &&
+	     nla_put_u16(msg, NL80211_RATE_INFO_BITRATE, bitrate_compat)) ||
 	    ((info->flags & RATE_INFO_FLAGS_MCS) &&
 	     nla_put_u8(msg, NL80211_RATE_INFO_MCS, info->mcs)) ||
 	    ((info->flags & RATE_INFO_FLAGS_40_MHZ_WIDTH) &&
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 0228c64..6e52726 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -900,7 +900,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	return err;
 }
 
-u16 cfg80211_calculate_bitrate(struct rate_info *rate)
+u32 cfg80211_calculate_bitrate(struct rate_info *rate)
 {
 	int modulation, streams, bitrate;
 
-- 
1.7.9.5

