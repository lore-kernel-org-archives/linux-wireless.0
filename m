Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51557 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752336AbaG1OCc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2014 10:02:32 -0400
Received: by mail-wi0-f173.google.com with SMTP id f8so4504605wiw.0
        for <linux-wireless@vger.kernel.org>; Mon, 28 Jul 2014 07:02:31 -0700 (PDT)
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Christian Lamparter <chunkeey@googlemail.com>,
	Nick Kossifidis <mickflemm@gmail.com>
Subject: [PATCHv4 1/2] cfg80211: enable dynack through nl80211
Date: Mon, 28 Jul 2014 16:02:27 +0200
Message-Id: <1406556148-3924-2-git-send-email-lorenzo.bianconi83@gmail.com> (sfid-20140728_160236_990069_48C4BCD9)
In-Reply-To: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
References: <1406556148-3924-1-git-send-email-lorenzo.bianconi83@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Define NL80211_ATTR_WIPHY_DYN_ACK attribute in order to enable ack timeout
estimation algorithm (dynack) using set_coverage_class codepath.
Define NL80211_FEATURE_ACKTO_ESTIMATION flag, which is set by lower drivers to
show dynack capability

Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  8 ++++++++
 net/wireless/nl80211.c       | 11 +++++++++++
 3 files changed, 21 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 0a080c4..ef7f250 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1800,6 +1800,7 @@ struct cfg80211_connect_params {
  * @WIPHY_PARAM_FRAG_THRESHOLD: wiphy->frag_threshold has changed
  * @WIPHY_PARAM_RTS_THRESHOLD: wiphy->rts_threshold has changed
  * @WIPHY_PARAM_COVERAGE_CLASS: coverage class changed
+ * @WIPHY_PARAM_DYN_ACK: dynack has been enabled
  */
 enum wiphy_params_flags {
 	WIPHY_PARAM_RETRY_SHORT		= 1 << 0,
@@ -1807,6 +1808,7 @@ enum wiphy_params_flags {
 	WIPHY_PARAM_FRAG_THRESHOLD	= 1 << 2,
 	WIPHY_PARAM_RTS_THRESHOLD	= 1 << 3,
 	WIPHY_PARAM_COVERAGE_CLASS	= 1 << 4,
+	WIPHY_PARAM_DYN_ACK		= 1 << 5,
 };
 
 /*
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index f1db15b..0b2d55d 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1594,6 +1594,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
  *
+ * @NL80211_ATTR_WIPHY_DYN_ACK: whether dynamic ack timeout estimation
+ *	algorithm is enabled
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -1936,6 +1939,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_TDLS_INITIATOR,
 
+	NL80211_ATTR_WIPHY_DYN_ACK,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -3956,6 +3961,8 @@ enum nl80211_ap_sme_features {
  * @NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE: This driver supports dynamic
  *	channel bandwidth change (e.g., HT 20 <-> 40 MHz channel) during the
  *	lifetime of a BSS.
+ * @NL80211_FEATURE_ACKTO_ESTIMATION: This driver supports dynamic ACK timeout
+ *	estimation.
  */
 enum nl80211_feature_flags {
 	NL80211_FEATURE_SK_TX_STATUS			= 1 << 0,
@@ -3977,6 +3984,7 @@ enum nl80211_feature_flags {
 	NL80211_FEATURE_USERSPACE_MPM			= 1 << 16,
 	NL80211_FEATURE_ACTIVE_MONITOR			= 1 << 17,
 	NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE	= 1 << 18,
+	NL80211_FEATURE_ACKTO_ESTIMATION		= 1 << 19,
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df7b133..b00cd11 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -225,6 +225,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_WIPHY_FRAG_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_RTS_THRESHOLD] = { .type = NLA_U32 },
 	[NL80211_ATTR_WIPHY_COVERAGE_CLASS] = { .type = NLA_U8 },
+	[NL80211_ATTR_WIPHY_DYN_ACK] = { .type = NLA_FLAG },
 
 	[NL80211_ATTR_IFTYPE] = { .type = NLA_U32 },
 	[NL80211_ATTR_IFINDEX] = { .type = NLA_U32 },
@@ -2237,11 +2238,21 @@ static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	if (info->attrs[NL80211_ATTR_WIPHY_COVERAGE_CLASS]) {
+		if (info->attrs[NL80211_ATTR_WIPHY_DYN_ACK])
+			return -EINVAL;
+
 		coverage_class = nla_get_u8(
 			info->attrs[NL80211_ATTR_WIPHY_COVERAGE_CLASS]);
 		changed |= WIPHY_PARAM_COVERAGE_CLASS;
 	}
 
+	if (info->attrs[NL80211_ATTR_WIPHY_DYN_ACK]) {
+		if (!(rdev->wiphy.features & NL80211_FEATURE_ACKTO_ESTIMATION))
+			return -EOPNOTSUPP;
+
+		changed |= WIPHY_PARAM_DYN_ACK;
+	}
+
 	if (changed) {
 		u8 old_retry_short, old_retry_long;
 		u32 old_frag_threshold, old_rts_threshold;
-- 
1.9.1

