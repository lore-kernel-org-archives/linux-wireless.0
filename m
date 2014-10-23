Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:63167 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaJWGhh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 02:37:37 -0400
Received: by mail-wi0-f177.google.com with SMTP id ex7so874255wid.16
        for <linux-wireless@vger.kernel.org>; Wed, 22 Oct 2014 23:37:35 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 1/5] cfg80211: introduce regulatory flags controlling bw
Date: Thu, 23 Oct 2014 09:37:33 +0300
Message-Id: <1414046257-22184-2-git-send-email-arik@wizery.com> (sfid-20141023_083740_259800_D9309FFA)
In-Reply-To: <1414046257-22184-1-git-send-email-arik@wizery.com>
References: <1414046257-22184-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Allow setting bandwidth related regulatory flags. These flags are mapped
to the corresponding channel flags in the specified range.
Make sure the new flags are consulted when calculating the maximum
bandwidth allowed by a regulatory-rule.

Also allow propagating the GO_CONCURRENT modifier from a reg-rule to a
channel.

Signed-off-by: Arik Nemtsov <arikx.nemtsov@intel.com>
---
 include/uapi/linux/nl80211.h | 12 ++++++++++++
 net/wireless/reg.c           | 36 ++++++++++++++++++++++++++++++++++--
 2 files changed, 46 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index be1d5de..1970d29 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2641,6 +2641,11 @@ enum nl80211_sched_scan_match_attr {
  * @NL80211_RRF_AUTO_BW: maximum available bandwidth should be calculated
  *	base on contiguous rules and wider channels will be allowed to cross
  *	multiple contiguous/overlapping frequency ranges.
+ * @NL80211_RRF_GO_CONCURRENT: See &NL80211_FREQUENCY_ATTR_GO_CONCURRENT
+ * @NL80211_RRF_NO_HT40MINUS: channels can't be used in HT40- operation
+ * @NL80211_RRF_NO_HT40PLUS: channels can't be used in HT40+ operation
+ * @NL80211_RRF_NO_80MHZ: 80MHz operation not allowed
+ * @NL80211_RRF_NO_160MHZ: 160MHz operation not allowed
  */
 enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_OFDM		= 1<<0,
@@ -2653,11 +2658,18 @@ enum nl80211_reg_rule_flags {
 	NL80211_RRF_NO_IR		= 1<<7,
 	__NL80211_RRF_NO_IBSS		= 1<<8,
 	NL80211_RRF_AUTO_BW		= 1<<11,
+	NL80211_RRF_GO_CONCURRENT	= 1<<12,
+	NL80211_RRF_NO_HT40MINUS	= 1<<13,
+	NL80211_RRF_NO_HT40PLUS		= 1<<14,
+	NL80211_RRF_NO_80MHZ		= 1<<15,
+	NL80211_RRF_NO_160MHZ		= 1<<16,
 };
 
 #define NL80211_RRF_PASSIVE_SCAN	NL80211_RRF_NO_IR
 #define NL80211_RRF_NO_IBSS		NL80211_RRF_NO_IR
 #define NL80211_RRF_NO_IR		NL80211_RRF_NO_IR
+#define NL80211_RRF_NO_HT40		(NL80211_RRF_NO_HT40MINUS |\
+					 NL80211_RRF_NO_HT40PLUS)
 
 /* For backport compatibility with older userspace */
 #define NL80211_RRF_NO_IR_ALL		(NL80211_RRF_NO_IR | __NL80211_RRF_NO_IBSS)
diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index b725a31..7449a8c 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -573,8 +573,9 @@ static const struct ieee80211_regdomain *reg_get_regdomain(struct wiphy *wiphy)
 	return get_cfg80211_regdom();
 }
 
-unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
-				   const struct ieee80211_reg_rule *rule)
+static unsigned int
+reg_get_max_bandwidth_from_range(const struct ieee80211_regdomain *rd,
+				 const struct ieee80211_reg_rule *rule)
 {
 	const struct ieee80211_freq_range *freq_range = &rule->freq_range;
 	const struct ieee80211_freq_range *freq_range_tmp;
@@ -622,6 +623,27 @@ unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
 	return end_freq - start_freq;
 }
 
+unsigned int reg_get_max_bandwidth(const struct ieee80211_regdomain *rd,
+				   const struct ieee80211_reg_rule *rule)
+{
+	unsigned int bw = reg_get_max_bandwidth_from_range(rd, rule);
+
+	if (rule->flags & NL80211_RRF_NO_160MHZ)
+		bw = min_t(unsigned int, bw, MHZ_TO_KHZ(80));
+	if (rule->flags & NL80211_RRF_NO_80MHZ)
+		bw = min_t(unsigned int, bw, MHZ_TO_KHZ(40));
+
+	/*
+	 * HT40+/HT40- limits are handled per-channel. Only limit BW if both
+	 * are not allowed.
+	 */
+	if (rule->flags & NL80211_RRF_NO_HT40MINUS &&
+	    rule->flags & NL80211_RRF_NO_HT40PLUS)
+		bw = min_t(unsigned int, bw, MHZ_TO_KHZ(20));
+
+	return bw;
+}
+
 /* Sanity check on a regulatory rule */
 static bool is_valid_reg_rule(const struct ieee80211_reg_rule *rule)
 {
@@ -946,6 +968,16 @@ static u32 map_regdom_flags(u32 rd_flags)
 		channel_flags |= IEEE80211_CHAN_NO_OFDM;
 	if (rd_flags & NL80211_RRF_NO_OUTDOOR)
 		channel_flags |= IEEE80211_CHAN_INDOOR_ONLY;
+	if (rd_flags & NL80211_RRF_GO_CONCURRENT)
+		channel_flags |= IEEE80211_CHAN_GO_CONCURRENT;
+	if (rd_flags & NL80211_RRF_NO_HT40MINUS)
+		channel_flags |= IEEE80211_CHAN_NO_HT40MINUS;
+	if (rd_flags & NL80211_RRF_NO_HT40PLUS)
+		channel_flags |= IEEE80211_CHAN_NO_HT40PLUS;
+	if (rd_flags & NL80211_RRF_NO_80MHZ)
+		channel_flags |= IEEE80211_CHAN_NO_80MHZ;
+	if (rd_flags & NL80211_RRF_NO_160MHZ)
+		channel_flags |= IEEE80211_CHAN_NO_160MHZ;
 	return channel_flags;
 }
 
-- 
1.9.1

