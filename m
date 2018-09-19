Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53242 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731442AbeISRqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:46:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6/7] netlink: allow NLA_NESTED to specify nested policy to validate
Date: Wed, 19 Sep 2018 14:08:59 +0200
Message-Id: <20180919120900.28708-7-johannes@sipsolutions.net> (sfid-20180919_140949_714553_21C14095)
In-Reply-To: <20180919120900.28708-1-johannes@sipsolutions.net>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Now that we have a validation_data pointer, and the len field in
the policy is unused for NLA_NESTED, we can allow using them both
to have nested validation. This can be nice in code, although we
still have to use nla_parse_nested() or similar which would also
take a policy; however, it also serves as documentation in the
policy without requiring a look at the code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 13 +++++++++++--
 lib/nlattr.c          | 17 +++++++++++++++++
 2 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 0d698215d4d9..91907852da1c 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -200,8 +200,10 @@ enum {
  *    NLA_NUL_STRING       Maximum length of string (excluding NUL)
  *    NLA_FLAG             Unused
  *    NLA_BINARY           Maximum length of attribute payload
- *    NLA_NESTED           Don't use `len' field -- length verification is
- *                         done by checking len of nested header (or empty)
+ *    NLA_NESTED           Length verification is done by checking len of
+ *                         nested header (or empty); len field is used if
+ *                         validation_data is also used, for the max attr
+ *                         number in the nested policy.
  *    NLA_U8, NLA_U16,
  *    NLA_U32, NLA_U64,
  *    NLA_S8, NLA_S16,
@@ -224,6 +226,10 @@ enum {
  *    NLA_REJECT           This attribute is always rejected and validation data
  *                         may point to a string to report as the error instead
  *                         of the generic one in extended ACK.
+ *    NLA_NESTED           Points to a nested policy to validate, must also set
+ *                         `len' to the max attribute number.
+ *                         Note that nla_parse() will validate, but of course not
+ *                         parse, the nested sub-policies.
  *    All other            Unused
  *
  * Example:
@@ -247,6 +253,9 @@ struct nla_policy {
 #define NLA_POLICY_ETH_ADDR		NLA_POLICY_EXACT_LEN(ETH_ALEN)
 #define NLA_POLICY_ETH_ADDR_COMPAT	NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN)
 
+#define NLA_POLICY_NESTED(maxattr, policy) \
+	{ .type = NLA_NESTED, .validation_data = policy, .len = maxattr }
+
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 2b015e43b725..c0ea8a78eda6 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -67,6 +67,11 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 	return 0;
 }
 
+static int nla_validate_parse(const struct nlattr *head, int len, int maxtype,
+			      const struct nla_policy *policy,
+			      struct netlink_ext_ack *extack, bool *extack_set,
+			      struct nlattr **tb);
+
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy,
 			struct netlink_ext_ack *extack, bool *extack_set)
@@ -148,6 +153,18 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		 */
 		if (attrlen == 0)
 			break;
+		if (attrlen < NLA_HDRLEN)
+			return -ERANGE;
+		if (pt->validation_data) {
+			int err;
+
+			err = nla_validate_parse(nla_data(nla), nla_len(nla),
+						 pt->len, pt->validation_data,
+						 extack, extack_set, NULL);
+			if (err < 0)
+				return err;
+		}
+		break;
 	default:
 		if (pt->len)
 			minlen = pt->len;
-- 
2.14.4
