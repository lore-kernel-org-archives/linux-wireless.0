Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59470 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732824AbeITB2s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 21:28:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 5/5] netlink: add nested array policy validation
Date: Wed, 19 Sep 2018 21:49:05 +0200
Message-Id: <20180919194905.16462-6-johannes@sipsolutions.net> (sfid-20180919_214939_695388_1D93BAE8)
In-Reply-To: <20180919194905.16462-1-johannes@sipsolutions.net>
References: <20180919194905.16462-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Sometimes nested netlink attributes are just used as arrays, with
the nla_type() of each not being used; we have this in nl80211 and
e.g. NFTA_SET_ELEM_LIST_ELEMENTS.

Add the ability to validate this type of message directly in the
policy, by adding the type NLA_NESTED_ARRAY which does exactly
this: require a first level of nesting but ignore the attribute
type, and then inside each require a second level of nested and
validate those attributes against a given policy (if present).

Note that some nested array types actually require that all of
the entries have the same index, this is possible to express in
a nested policy already, apart from the validation that only the
one allowed type is used.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 12 +++++++++++-
 lib/nlattr.c          | 51 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 91907852da1c..3698ca8ff92c 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -172,6 +172,7 @@ enum {
 	NLA_FLAG,
 	NLA_MSECS,
 	NLA_NESTED,
+	NLA_NESTED_ARRAY,
 	NLA_NUL_STRING,
 	NLA_BINARY,
 	NLA_S8,
@@ -200,7 +201,8 @@ enum {
  *    NLA_NUL_STRING       Maximum length of string (excluding NUL)
  *    NLA_FLAG             Unused
  *    NLA_BINARY           Maximum length of attribute payload
- *    NLA_NESTED           Length verification is done by checking len of
+ *    NLA_NESTED,
+ *    NLA_NESTED_ARRAY     Length verification is done by checking len of
  *                         nested header (or empty); len field is used if
  *                         validation_data is also used, for the max attr
  *                         number in the nested policy.
@@ -230,6 +232,12 @@ enum {
  *                         `len' to the max attribute number.
  *                         Note that nla_parse() will validate, but of course not
  *                         parse, the nested sub-policies.
+ *    NLA_NESTED_ARRAY     Points to a nested policy to validate, must also set
+ *                         `len' to the max attribute number. The difference to
+ *                         NLA_NESTED is the structure - NLA_NESTED has the
+ *                         nested attributes directly inside, while an array has
+ *                         the nested attributes at another level down and the
+ *                         attributes directly in the nesting don't matter.
  *    All other            Unused
  *
  * Example:
@@ -255,6 +263,8 @@ struct nla_policy {
 
 #define NLA_POLICY_NESTED(maxattr, policy) \
 	{ .type = NLA_NESTED, .validation_data = policy, .len = maxattr }
+#define NLA_POLICY_NESTED_ARRAY(maxattr, policy) \
+	{ .type = NLA_NESTED_ARRAY, .validation_data = policy, .len = maxattr }
 
 /**
  * struct nl_info - netlink source information
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 4cbfc64f6d10..9d8e1dc71680 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -67,6 +67,34 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 	return 0;
 }
 
+static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
+			      const struct nla_policy *policy,
+			      struct netlink_ext_ack *extack)
+{
+	const struct nlattr *entry;
+	int rem;
+
+	nla_for_each_attr(entry, head, len, rem) {
+		int ret;
+
+		if (nla_len(entry) == 0)
+			continue;
+
+		if (nla_len(entry) < NLA_HDRLEN) {
+			NL_SET_ERR_MSG_ATTR(extack, entry,
+					    "Array element too short");
+			return -ERANGE;
+		}
+
+		ret = nla_validate(nla_data(entry), nla_len(entry),
+				   maxtype, policy, extack);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy,
 			struct netlink_ext_ack *extack)
@@ -166,6 +194,29 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			}
 		}
 		break;
+	case NLA_NESTED_ARRAY:
+		/* a nested array attribute is allowed to be empty; if its not,
+		 * it must have a size of at least NLA_HDRLEN.
+		 */
+		if (attrlen == 0)
+			break;
+		if (attrlen < NLA_HDRLEN)
+			goto out_err;
+		if (pt->validation_data) {
+			int err;
+
+			err = nla_validate_array(nla_data(nla), nla_len(nla),
+						 pt->len, pt->validation_data,
+						 extack);
+			if (err < 0) {
+				/*
+				 * return directly to preserve the inner
+				 * error message/attribute pointer
+				 */
+				return err;
+			}
+		}
+		break;
 	default:
 		if (pt->len)
 			minlen = pt->len;
-- 
2.14.4
