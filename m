Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53238 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731439AbeISRqy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:46:54 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5/7] netlink: prepare validate extack setting for recursion
Date: Wed, 19 Sep 2018 14:08:58 +0200
Message-Id: <20180919120900.28708-6-johannes@sipsolutions.net> (sfid-20180919_140949_126084_7E01098D)
In-Reply-To: <20180919120900.28708-1-johannes@sipsolutions.net>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In one of my previous patches in this area I introduced code
to pass out just the error message to store in the extack, for
use in NLA_REJECT.

Change this code now to set both the error message and the bad
attribute pointer, and carry around a boolean indicating that
the values have been set.

This will be used in the next patch to allow recursive validation
of nested policies, while preserving the innermost error message
rather than overwriting it with a generic out-level message.

Note that this is a completely local change - code calling one
of nla_parse/nla_validate isn't affected, both functions continue
to overwrite any previously set message with an error generated
here, but in the next patch the message generated may come from
an inner call to nested attribute validation instead, and there
the outer (generic) message shouldn't overwrite the inner.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/nlattr.c | 32 ++++++++++++++++++++------------
 1 file changed, 20 insertions(+), 12 deletions(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index 966cd3dcf31b..2b015e43b725 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -69,7 +69,7 @@ static int validate_nla_bitfield32(const struct nlattr *nla,
 
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy,
-			const char **error_msg)
+			struct netlink_ext_ack *extack, bool *extack_set)
 {
 	const struct nla_policy *pt;
 	int minlen = 0, attrlen = nla_len(nla), type = nla_type(nla);
@@ -94,8 +94,11 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		break;
 
 	case NLA_REJECT:
-		if (pt->validation_data && error_msg)
-			*error_msg = pt->validation_data;
+		if (pt->validation_data && extack && !*extack_set) {
+			*extack_set = true;
+			extack->_msg = pt->validation_data;
+			NL_SET_BAD_ATTR(extack, nla);
+		}
 		return -EINVAL;
 
 	case NLA_FLAG:
@@ -160,24 +163,25 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 
 static int nla_validate_parse(const struct nlattr *head, int len, int maxtype,
 			      const struct nla_policy *policy,
-			      struct netlink_ext_ack *extack,
+			      struct netlink_ext_ack *extack, bool *extack_set,
 			      struct nlattr **tb)
 {
 	const struct nlattr *nla;
 	int rem;
 
 	nla_for_each_attr(nla, head, len, rem) {
-		static const char _msg[] = "Attribute failed policy validation";
-		const char *msg = _msg;
 		u16 type = nla_type(nla);
 
 		if (policy) {
-			int err = validate_nla(nla, maxtype, policy, &msg);
+			int err = validate_nla(nla, maxtype, policy,
+					       extack, extack_set);
 
 			if (err < 0) {
-				if (extack)
-					extack->_msg = msg;
-				NL_SET_BAD_ATTR(extack, nla);
+				if (!*extack_set) {
+					*extack_set = true;
+					NL_SET_ERR_MSG_ATTR(extack, nla,
+							    "Attribute failed policy validation");
+				}
 				return err;
 			}
 		}
@@ -207,9 +211,11 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
 		 const struct nla_policy *policy,
 		 struct netlink_ext_ack *extack)
 {
+	bool extack_set = false;
 	int rem;
 
-	rem = nla_validate_parse(head, len, maxtype, policy, extack, NULL);
+	rem = nla_validate_parse(head, len, maxtype, policy,
+				 extack, &extack_set, NULL);
 
 	if (rem < 0)
 		return rem;
@@ -266,11 +272,13 @@ int nla_parse(struct nlattr **tb, int maxtype, const struct nlattr *head,
 	      int len, const struct nla_policy *policy,
 	      struct netlink_ext_ack *extack)
 {
+	bool extack_set = false;
 	int rem;
 
 	memset(tb, 0, sizeof(struct nlattr *) * (maxtype + 1));
 
-	rem = nla_validate_parse(head, len, maxtype, policy, extack, tb);
+	rem = nla_validate_parse(head, len, maxtype, policy,
+				 extack, &extack_set, tb);
 	if (rem < 0)
 		return rem;
 
-- 
2.14.4
