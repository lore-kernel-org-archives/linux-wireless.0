Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59458 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727844AbeITB2r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 21:28:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 3/5] netlink: move extack setting into validate_nla()
Date: Wed, 19 Sep 2018 21:49:03 +0200
Message-Id: <20180919194905.16462-4-johannes@sipsolutions.net> (sfid-20180919_214938_218448_122CE2E9)
In-Reply-To: <20180919194905.16462-1-johannes@sipsolutions.net>
References: <20180919194905.16462-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This unifies the code between nla_parse() which sets the bad
attribute pointer and an error message, and nla_validate()
which only sets the bad attribute pointer.

It also cleans up the code for NLA_REJECT and paves the way
for nested policy validation, as it will allow us to easily
skip setting the "generic" message without any extra args
like the **error_msg now, just passing the extack through is
now enough.

While at it, remove the unnecessary label in nla_parse().

Suggested-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/nlattr.c | 63 ++++++++++++++++++++++++++++++------------------------------
 1 file changed, 32 insertions(+), 31 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index e2e5b38394d5..ff6d48d7c19a 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -69,10 +69,11 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy,
-			const char **error_msg)
+			struct netlink_ext_ack *extack)
 {
 	const struct nla_policy *pt;
 	int minlen = 0, attrlen = nla_len(nla), type = nla_type(nla);
+	int err = -ERANGE;
 
 	if (type <= 0 || type > maxtype)
 		return 0;
@@ -90,24 +91,28 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	switch (pt->type) {
 	case NLA_EXACT_LEN:
 		if (attrlen != pt->len)
-			return -ERANGE;
+			goto out_err;
 		break;
 
 	case NLA_REJECT:
-		if (pt->validation_data && error_msg)
-			*error_msg = pt->validation_data;
+		NL_SET_BAD_ATTR(extack, nla);
+		if (extack && pt->validation_data)
+			 extack->_msg = pt->validation_data;
 		return -EINVAL;
 
 	case NLA_FLAG:
 		if (attrlen > 0)
-			return -ERANGE;
+			goto out_err;
 		break;
 
 	case NLA_BITFIELD32:
 		if (attrlen != sizeof(struct nla_bitfield32))
-			return -ERANGE;
+			goto out_err;
 
-		return validate_nla_bitfield32(nla, pt->validation_data);
+		err = validate_nla_bitfield32(nla, pt->validation_data);
+		if (err)
+			goto out_err;
+		break;
 
 	case NLA_NUL_STRING:
 		if (pt->len)
@@ -115,13 +120,15 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		else
 			minlen = attrlen;
 
-		if (!minlen || memchr(nla_data(nla), '\0', minlen) == NULL)
-			return -EINVAL;
+		if (!minlen || memchr(nla_data(nla), '\0', minlen) == NULL) {
+			err = -EINVAL;
+			goto out_err;
+		}
 		/* fall through */
 
 	case NLA_STRING:
 		if (attrlen < 1)
-			return -ERANGE;
+			goto out_err;
 
 		if (pt->len) {
 			char *buf = nla_data(nla);
@@ -130,13 +137,13 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 				attrlen--;
 
 			if (attrlen > pt->len)
-				return -ERANGE;
+				goto out_err;
 		}
 		break;
 
 	case NLA_BINARY:
 		if (pt->len && attrlen > pt->len)
-			return -ERANGE;
+			goto out_err;
 		break;
 
 	case NLA_NESTED:
@@ -152,10 +159,13 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			minlen = nla_attr_minlen[pt->type];
 
 		if (attrlen < minlen)
-			return -ERANGE;
+			goto out_err;
 	}
 
 	return 0;
+out_err:
+	NL_SET_ERR_MSG_ATTR(extack, nla, "Attribute failed policy validation");
+	return err;
 }
 
 /**
@@ -180,12 +190,10 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
 	int rem;
 
 	nla_for_each_attr(nla, head, len, rem) {
-		int err = validate_nla(nla, maxtype, policy, NULL);
+		int err = validate_nla(nla, maxtype, policy, extack);
 
-		if (err < 0) {
-			NL_SET_BAD_ATTR(extack, nla);
+		if (err < 0)
 			return err;
-		}
 	}
 
 	return 0;
@@ -241,7 +249,7 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 	      struct netlink_ext_ack *extack)
 {
 	const struct nlattr *nla;
-	int rem, err;
+	int rem;
 
 	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 
@@ -249,17 +257,12 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 		u16 type = nla_type(nla);
 
 		if (type > 0 && type <= maxtype) {
-			static const char _msg[] = "Attribute failed policy validation";
-			const char *msg = _msg;
-
 			if (policy) {
-				err = validate_nla(nla, maxtype, policy, &msg);
-				if (err < 0) {
-					NL_SET_BAD_ATTR(extack, nla);
-					if (extack)
-						extack->_msg = msg;
-					goto errout;
-				}
+				int err = validate_nla(nla, maxtype, policy,
+						       extack);
+
+				if (err < 0)
+					return err;
 			}
 
 			tb[type] = (struct nlattr *)nla;
@@ -270,9 +273,7 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 		pr_warn_ratelimited("netlink: %d bytes leftover after parsing attributes in process `%s'.\n",
 				    rem, current->comm);
 
-	err = 0;
-errout:
-	return err;
+	return 0;
 }
 EXPORT_SYMBOL(nla_parse);
 
-- 
2.14.4
