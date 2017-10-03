Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:22727 "EHLO
        sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752155AbdJGBfA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Oct 2017 21:35:00 -0400
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, Peng Xu <pxu@qti.qualcomm.com>,
        "Jouni Malinen" <jouni@qca.qualcomm.com>
Subject: [PATCH] nl80211: Define policy for packet pattern attributes
Date: Tue, 3 Oct 2017 23:21:51 +0300
Message-ID: <1507062111-9907-1-git-send-email-jouni@qca.qualcomm.com> (sfid-20171007_033505_021597_44C7F041)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peng Xu <pxu@qti.qualcomm.com>

Define a policy for packet pattern attributes in order to fix the
security vulnerability of buffer over read issue on
NL80211_PKTPAT_OFFSET (nla_get_u32() was used without checking the
attribute length).

Signed-off-by: Peng Xu <pxu@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
---
 net/wireless/nl80211.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 90e212d..e99671f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -549,6 +549,14 @@ nl80211_nan_srf_policy[NL80211_NAN_SRF_ATTR_MAX + 1] = {
 	[NL80211_NAN_SRF_MAC_ADDRS] = { .type = NLA_NESTED },
 };
 
+/* policy for packet pattern attributes */
+static const struct nla_policy
+nl80211_packet_pattern_policy[MAX_NL80211_PKTPAT + 1] = {
+	[NL80211_PKTPAT_MASK] = { .type = NLA_BINARY, },
+	[NL80211_PKTPAT_PATTERN] = { .type = NLA_BINARY, },
+	[NL80211_PKTPAT_OFFSET] = { .type = NLA_U32 },
+};
+
 static int nl80211_prepare_wdev_dump(struct sk_buff *skb,
 				     struct netlink_callback *cb,
 				     struct cfg80211_registered_device **rdev,
@@ -10563,7 +10571,8 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 			u8 *mask_pat;
 
 			nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
-					 NULL, info->extack);
+					 nl80211_packet_pattern_policy,
+					 info->extack);
 			err = -EINVAL;
 			if (!pat_tb[NL80211_PKTPAT_MASK] ||
 			    !pat_tb[NL80211_PKTPAT_PATTERN])
@@ -10812,7 +10821,8 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 			    rem) {
 		u8 *mask_pat;
 
-		nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat, NULL, NULL);
+		nla_parse_nested(pat_tb, MAX_NL80211_PKTPAT, pat,
+				 nl80211_packet_pattern_policy, NULL);
 		if (!pat_tb[NL80211_PKTPAT_MASK] ||
 		    !pat_tb[NL80211_PKTPAT_PATTERN])
 			return -EINVAL;
-- 
2.7.4
