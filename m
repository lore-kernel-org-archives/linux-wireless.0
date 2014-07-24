Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:49895 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019AbaGXKj1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 06:39:27 -0400
Received: by mail-wi0-f175.google.com with SMTP id ho1so9316922wib.8
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 03:39:24 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Philippe Duchein <wireless-dev@duchein.net>
Subject: [PATCHv2 1/2] cfg80211: extend coverage_class datatype
Date: Thu, 24 Jul 2014 12:39:21 +0200
Message-Id: <1406198362-4999-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140724_123931_485329_53F19F2F)
In-Reply-To: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1406198362-4999-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use s16 as datatype for coverage_class in order to enable ack timeout
estimation algorithm through nl80211

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/cfg80211.h       |  5 +++--
 include/uapi/linux/nl80211.h |  5 +++++
 net/wireless/nl80211.c       | 14 ++++++++++----
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0a080c4..1c8e281 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -2876,7 +2876,8 @@ struct wiphy_vendor_command {
  *	include fixed IEs like supported rates
  * @max_sched_scan_ie_len: same as max_scan_ie_len, but for scheduled
  *	scans
- * @coverage_class: current coverage class
+ * @coverage_class: current coverage class, -1 if dynamic ack timeout
+ *	estimation has been enabled
  * @fw_version: firmware version for ethtool reporting
  * @hw_version: hardware version for ethtool reporting
  * @max_num_pmkids: maximum number of PMKIDs supported by device
@@ -2990,7 +2991,7 @@ struct wiphy {
 	u8 retry_long;
 	u32 frag_threshold;
 	u32 rts_threshold;
-	u8 coverage_class;
+	s16 coverage_class;
 
 	char fw_version[ETHTOOL_FWVERS_LEN];
 	u32 hw_version;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f1db15b..7cc5ecd 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1594,6 +1594,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
  *
+ * @NL80211_ATTR_WIPHY_DYNACK: whether dynamic ack timeout estimation algorithm
+ *	is enabled
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1936,6 +1939,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TDLS_INITIATOR,
 
+	NL80211_ATTR_WIPHY_DYNACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df7b133..c097827 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -225,6 +225,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY_FRAG_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_RTS_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_COVERAGE_CLASS] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_DYNACK] = { .type = NLA_FLAG },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -1269,8 +1270,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 				rdev->wiphy.frag_threshold) ||
 		    nla_put_u32(msg, NL80211_ATTR_WIPHY_RTS_THRESHOLD,
 				rdev->wiphy.rts_threshold) ||
-		    nla_put_u8(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
-			       rdev->wiphy.coverage_class) ||
+		    nla_put_s16(msg, NL80211_ATTR_WIPHY_COVERAGE_CLASS,
+				rdev->wiphy.coverage_class) ||
 		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 			       rdev->wiphy.max_scan_ssids) ||
 		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
@@ -2046,7 +2047,7 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	u32 changed;
 	u8 retry_short = 0, retry_long = 0;
 	u32 frag_threshold = 0, rts_threshold = 0;
-	u8 coverage_class = 0;
+	s16 coverage_class = 0;
 
 	ASSERT_RTNL();
 
@@ -2242,10 +2243,15 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 		changed |= WIPHY_PARAM_COVERAGE_CLASS;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_DYNACK]) {
+		coverage_class = -1;
+		changed |= WIPHY_PARAM_COVERAGE_CLASS;
+	}
+
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
 		u32 old_frag_threshold, old_rts_threshold;
-		u8 old_coverage_class;
+		s16 old_coverage_class;
 
 		if (!rdev->ops->set_wiphy_params)
 			return -EOPNOTSUPP;
-- 
1.9.1

