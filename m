Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E3B3C43382
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:29:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F2BBB2150D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:29:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2BBB2150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727629AbeI0PqY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:46:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53476 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727328AbeI0PqY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:46:24 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5SbV-0000f4-A4; Thu, 27 Sep 2018 11:29:01 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 2/2] netlink: add validation function to policy
Date:   Thu, 27 Sep 2018 11:28:36 +0200
Message-Id: <20180927092836.6117-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
In-Reply-To: <20180927092836.6117-1-johannes@sipsolutions.net>
References: <20180927092836.6117-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Add the ability to have an arbitrary validation function attached
to a netlink policy that doesn't already use the validation_data
pointer in another way.

This can be useful to validate for example the content of a binary
attribute, like in nl80211 the "(information) elements", which must
be valid streams of "u8 type, u8 length, u8 value[length]".

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 24 +++++++++++++++++++++++-
 lib/nlattr.c          |  7 +++++++
 2 files changed, 30 insertions(+), 1 deletion(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index d34ceeba82a8..6a106ef5ca56 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -193,13 +193,14 @@ enum nla_policy_validation {
 	NLA_VALIDATE_RANGE,
 	NLA_VALIDATE_MIN,
 	NLA_VALIDATE_MAX,
+	NLA_VALIDATE_FUNCTION,
 };
 
 /**
  * struct nla_policy - attribute validation policy
  * @type: Type of attribute or NLA_UNSPEC
  * @validation_type: type of attribute validation done in addition to
- *	type-specific validation (e.g. range), see
+ *	type-specific validation (e.g. range, function call), see
  *	&enum nla_policy_validation
  * @len: Type specific length of payload
  *
@@ -269,6 +270,13 @@ enum nla_policy_validation {
  *                         of s16 - do that as usual in the code instead.
  *    All other            Unused - but note that it's a union
  *
+ * Meaning of `validate' field, use via NLA_POLICY_VALIDATE_FN:
+ *    NLA_BINARY           Validation function called for the attribute,
+ *                         not compatible with use of the validation_data
+ *                         as in NLA_BITFIELD32, NLA_REJECT, NLA_NESTED and
+ *                         NLA_NESTED_ARRAY.
+ *    All other            Unused - but note that it's a union
+ *
  * Example:
  * static const struct nla_policy my_policy[ATTR_MAX+1] = {
  * 	[ATTR_FOO] = { .type = NLA_U16 },
@@ -286,6 +294,8 @@ struct nla_policy {
 		struct {
 			s16 min, max;
 		};
+		int (*validate)(const struct nlattr *attr,
+				struct netlink_ext_ack *extack);
 	};
 };
 
@@ -307,6 +317,11 @@ struct nla_policy {
 		      tp == NLA_S16 || tp == NLA_U16 ||	\
 		      tp == NLA_S32 || tp == NLA_U32 ||	\
 		      tp == NLA_S64 || tp == NLA_U64) + tp)
+#define NLA_ENSURE_NO_VALIDATION_PTR(tp)		\
+	(__NLA_ENSURE(tp != NLA_BITFIELD32 &&		\
+		      tp != NLA_REJECT &&		\
+		      tp != NLA_NESTED &&		\
+		      tp != NLA_NESTED_ARRAY) + tp)
 
 #define NLA_POLICY_RANGE(tp, _min, _max) {		\
 	.type = NLA_ENSURE_INT_TYPE(tp),		\
@@ -327,6 +342,13 @@ struct nla_policy {
 	.max = _max,					\
 }
 
+#define NLA_POLICY_VALIDATE_FN(tp, fn, ...) {		\
+	.type = NLA_ENSURE_NO_VALIDATION_PTR(tp),	\
+	.validation_type = NLA_VALIDATE_FUNCTION,	\
+	.validate = fn,					\
+	.len = __VA_ARGS__ + 0,				\
+}
+
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 5670e4b7dfef..1e900bb414ef 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -300,6 +300,13 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 		if (err)
 			return err;
 		break;
+	case NLA_VALIDATE_FUNCTION:
+		if (pt->validate) {
+			err = pt->validate(nla, extack);
+			if (err)
+				return err;
+		}
+		break;
 	}
 
 	return 0;
-- 
2.14.4

