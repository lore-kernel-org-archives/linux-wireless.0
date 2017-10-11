Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44966 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756656AbdJKIcM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 11 Oct 2017 04:32:12 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Cc: Peng Xu <pxu@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: [PATCH v4.9] nl80211: Define policy for packet pattern attributes
Date: Wed, 11 Oct 2017 10:32:09 +0200
Message-Id: <20171011083209.10969-1-johannes@sipsolutions.net> (sfid-20171011_103302_238245_3DF4C9B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Peng Xu <pxu@qti.qualcomm.com>

Upstream commit ad670233c9e1d5feb365d870e30083ef1b889177.

Define a policy for packet pattern attributes in order to fix a
potential read over the end of the buffer during nla_get_u32()
of the NL80211_PKTPAT_OFFSET attribute.

Note that the data there can always be read due to SKB allocation
(with alignment and struct skb_shared_info at the end), but the
data might be uninitialized. This could be used to leak some data
from uninitialized vmalloc() memory, but most drivers don't allow
an offset (so you'd just get -EINVAL if the data is non-zero) or
just allow it with a fixed value - 100 or 128 bytes, so anything
above that would get -EINVAL. With brcmfmac the limit is 1500 so
(at least) one byte could be obtained.

Cc: stable@kernel.org
Signed-off-by: Peng Xu <pxu@qti.qualcomm.com>
Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
[rewrite description based on SKB allocation knowledge]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ece0fbc08607..c626f679e1c8 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -541,6 +541,14 @@ nl80211_nan_srf_policy[NL80211_NAN_SRF_ATTR_MAX + 1] = {
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
@@ -10009,7 +10017,7 @@ static int nl80211_set_wowlan(struct sk_buff *skb, struct genl_info *info)
 			u8 *mask_pat;
 
 			nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
-				  nla_len(pat), NULL);
+				  nla_len(pat), nl80211_packet_pattern_policy);
 			err = -EINVAL;
 			if (!pat_tb[NL80211_PKTPAT_MASK] ||
 			    !pat_tb[NL80211_PKTPAT_PATTERN])
@@ -10259,7 +10267,7 @@ static int nl80211_parse_coalesce_rule(struct cfg80211_registered_device *rdev,
 		u8 *mask_pat;
 
 		nla_parse(pat_tb, MAX_NL80211_PKTPAT, nla_data(pat),
-			  nla_len(pat), NULL);
+			  nla_len(pat), nl80211_packet_pattern_policy);
 		if (!pat_tb[NL80211_PKTPAT_MASK] ||
 		    !pat_tb[NL80211_PKTPAT_PATTERN])
 			return -EINVAL;
-- 
2.14.2
