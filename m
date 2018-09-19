Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53234 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731436AbeISRqx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:46:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/7] netlink: combine validate/parse functions
Date: Wed, 19 Sep 2018 14:08:57 +0200
Message-Id: <20180919120900.28708-5-johannes@sipsolutions.net> (sfid-20180919_140951_088760_E1C8582B)
In-Reply-To: <20180919120900.28708-1-johannes@sipsolutions.net>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The parse function of course contains validate, but it's
implemented a second time, sharing just the validation
of a single attribute.

Introduce nla_validate_parse() that can be used for both
parsing/validation and only validation, to share code.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/nlattr.c | 76 +++++++++++++++++++++++++++++++-----------------------------
 1 file changed, 39 insertions(+), 37 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 33404745bec4..966cd3dcf31b 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -158,6 +158,37 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 	return 0;
 }
 
+static int nla_validate_parse(const struct nlattr *head, int len, int maxtype,
+			      const struct nla_policy *policy,
+			      struct netlink_ext_ack *extack,
+			      struct nlattr **tb)
+{
+	const struct nlattr *nla;
+	int rem;
+
+	nla_for_each_attr(nla, head, len, rem) {
+		static const char _msg[] = "Attribute failed policy validation";
+		const char *msg = _msg;
+		u16 type = nla_type(nla);
+
+		if (policy) {
+			int err = validate_nla(nla, maxtype, policy, &msg);
+
+			if (err < 0) {
+				if (extack)
+					extack->_msg = msg;
+				NL_SET_BAD_ATTR(extack, nla);
+				return err;
+			}
+		}
+
+		if (tb && type > 0 && type <= maxtype)
+			tb[type] = (struct nlattr *)nla;
+	}
+
+	return rem;
+}
+
 /**
  * nla_validate - Validate a stream of attributes
  * @head: head of attribute stream
@@ -176,21 +207,12 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
 		 const struct nla_policy *policy,
 		 struct netlink_ext_ack *extack)
 {
-	const struct nlattr *nla;
 	int rem;
 
-	nla_for_each_attr(nla, head, len, rem) {
-		static const char _msg[] = "Attribute failed policy validation";
-		const char *msg = _msg;
-		int err = validate_nla(nla, maxtype, policy, &msg);
+	rem = nla_validate_parse(head, len, maxtype, policy, extack, NULL);
 
-		if (err < 0) {
-			if (extack)
-				extack->_msg = msg;
-			NL_SET_BAD_ATTR(extack, nla);
-			return err;
-		}
-	}
+	if (rem < 0)
+		return rem;
 
 	return 0;
 }
@@ -244,39 +266,19 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 	      int len, const struct nla_policy *policy,
 	      struct netlink_ext_ack *extack)
 {
-	const struct nlattr *nla;
-	int rem, err;
+	int rem;
 
 	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 
-	nla_for_each_attr(nla, head, len, rem) {
-		u16 type = nla_type(nla);
-
-		if (type > 0 && type <= maxtype) {
-			static const char _msg[] = "Attribute failed policy validation";
-			const char *msg = _msg;
-
-			if (policy) {
-				err = validate_nla(nla, maxtype, policy, &msg);
-				if (err < 0) {
-					NL_SET_BAD_ATTR(extack, nla);
-					if (extack)
-						extack->_msg = msg;
-					goto errout;
-				}
-			}
-
-			tb[type] = (struct nlattr *)nla;
-		}
-	}
+	rem = nla_validate_parse(head, len, maxtype, policy, extack, tb);
+	if (rem < 0)
+		return rem;
 
 	if (unlikely(rem > 0))
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
