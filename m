Return-Path: <SRS0=euQo=MJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AE7ECE561
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CD962150D
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Sep 2018 09:29:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1CD962150D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727522AbeI0PqY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Sep 2018 11:46:24 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:53472 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbeI0PqX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Sep 2018 11:46:23 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5SbU-0000f4-P6; Thu, 27 Sep 2018 11:29:00 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Michal Kubecek <mkubecek@suse.cz>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/2] netlink: add attribute range validation to policy
Date:   Thu, 27 Sep 2018 11:28:35 +0200
Message-Id: <20180927092836.6117-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
In-Reply-To: <20180927092836.6117-1-johannes@sipsolutions.net>
References: <20180927092836.6117-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Without further bloating the policy structs, we can overload
the `validation_data' pointer with a struct of s16 min, max
and use those to validate ranges in NLA_{U,S}{8,16,32,64}
attributes.

It may sound strange to validate NLA_U32 with a s16 max, but
in many cases NLA_U32 is used for enums etc. since there's no
size benefit in using a smaller attribute width anyway, due
to netlink attribute alignment; in cases like that it's still
useful, particularly when the attribute really transports an
enum value.

Doing so lets us remove quite a bit of validation code, if we
can be sure that these attributes aren't used by userspace in
places where they're ignored today.

To achieve all this, split the 'type' field and introduce a
new 'validation_type' field which indicates what further
validation (beyond the validation prescribed by the type of
the attribute) is done. This currently allows for no further
validation (the default), as well as min, max and range checks.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 67 ++++++++++++++++++++++++++++++++++++++++++++---
 lib/nlattr.c          | 72 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 3698ca8ff92c..d34ceeba82a8 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -188,9 +188,19 @@ enum {
 
 #define NLA_TYPE_MAX (__NLA_TYPE_MAX - 1)
 
+enum nla_policy_validation {
+	NLA_VALIDATE_NONE,
+	NLA_VALIDATE_RANGE,
+	NLA_VALIDATE_MIN,
+	NLA_VALIDATE_MAX,
+};
+
 /**
  * struct nla_policy - attribute validation policy
  * @type: Type of attribute or NLA_UNSPEC
+ * @validation_type: type of attribute validation done in addition to
+ *	type-specific validation (e.g. range), see
+ *	&enum nla_policy_validation
  * @len: Type specific length of payload
  *
  * Policies are defined as arrays of this struct, the array must be
@@ -238,7 +248,26 @@ enum {
  *                         nested attributes directly inside, while an array has
  *                         the nested attributes at another level down and the
  *                         attributes directly in the nesting don't matter.
- *    All other            Unused
+ *    All other            Unused - but note that it's a union
+ *
+ * Meaning of `min' and `max' fields, use via NLA_POLICY_MIN, NLA_POLICY_MAX
+ * and NLA_POLICY_RANGE:
+ *    NLA_U8,
+ *    NLA_U16,
+ *    NLA_U32,
+ *    NLA_U64,
+ *    NLA_S8,
+ *    NLA_S16,
+ *    NLA_S32,
+ *    NLA_S64              These are used depending on the validation_type
+ *                         field, if that is min/max/range then the minimum,
+ *                         maximum and both are used (respectively) to check
+ *                         the value of the integer attribute.
+ *                         Note that in the interest of code simplicity and
+ *                         struct size both limits are s16, so you cannot
+ *                         enforce a range that doesn't fall within the range
+ *                         of s16 - do that as usual in the code instead.
+ *    All other            Unused - but note that it's a union
  *
  * Example:
  * static const struct nla_policy my_policy[ATTR_MAX+1] = {
@@ -249,9 +278,15 @@ enum {
  * };
  */
 struct nla_policy {
-	u16		type;
+	u8		type;
+	u8		validation_type;
 	u16		len;
-	const void     *validation_data;
+	union {
+		const void *validation_data;
+		struct {
+			s16 min, max;
+		};
+	};
 };
 
 #define NLA_POLICY_EXACT_LEN(_len)	{ .type = NLA_EXACT_LEN, .len = _len }
@@ -266,6 +301,32 @@ struct nla_policy {
 #define NLA_POLICY_NESTED_ARRAY(maxattr, policy) \
 	{ .type = NLA_NESTED_ARRAY, .validation_data = policy, .len = maxattr }
 
+#define __NLA_ENSURE(condition) (sizeof(char[1 - 2*!(condition)]) - 1)
+#define NLA_ENSURE_INT_TYPE(tp)				\
+	(__NLA_ENSURE(tp == NLA_S8 || tp == NLA_U8 ||	\
+		      tp == NLA_S16 || tp == NLA_U16 ||	\
+		      tp == NLA_S32 || tp == NLA_U32 ||	\
+		      tp == NLA_S64 || tp == NLA_U64) + tp)
+
+#define NLA_POLICY_RANGE(tp, _min, _max) {		\
+	.type = NLA_ENSURE_INT_TYPE(tp),		\
+	.validation_type = NLA_VALIDATE_RANGE,		\
+	.min = _min,					\
+	.max = _max					\
+}
+
+#define NLA_POLICY_MIN(tp, _min) {			\
+	.type = NLA_ENSURE_INT_TYPE(tp),		\
+	.validation_type = NLA_VALIDATE_MIN,		\
+	.min = _min,					\
+}
+
+#define NLA_POLICY_MAX(tp, _max) {			\
+	.type = NLA_ENSURE_INT_TYPE(tp),		\
+	.validation_type = NLA_VALIDATE_MAX,		\
+	.max = _max,					\
+}
+
 /**
  * struct nl_info - netlink source information
  * @nlh: Netlink message header of original request
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 2f8feff669a7..5670e4b7dfef 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -95,6 +95,64 @@ static int nla_validate_array(const struct nlattr *head, int len, int maxtype,
 	return 0;
 }
 
+static int nla_validate_int_range(const struct nla_policy *pt,
+				  const struct nlattr *nla,
+				  struct netlink_ext_ack *extack)
+{
+	bool validate_min, validate_max;
+	s64 value;
+
+	validate_min = pt->validation_type == NLA_VALIDATE_RANGE ||
+		       pt->validation_type == NLA_VALIDATE_MIN;
+	validate_max = pt->validation_type == NLA_VALIDATE_RANGE ||
+		       pt->validation_type == NLA_VALIDATE_MAX;
+
+	switch (pt->type) {
+	case NLA_U8:
+		value = nla_get_u8(nla);
+		break;
+	case NLA_U16:
+		value = nla_get_u16(nla);
+		break;
+	case NLA_U32:
+		value = nla_get_u32(nla);
+		break;
+	case NLA_S8:
+		value = nla_get_s8(nla);
+		break;
+	case NLA_S16:
+		value = nla_get_s16(nla);
+		break;
+	case NLA_S32:
+		value = nla_get_s32(nla);
+		break;
+	case NLA_S64:
+		value = nla_get_s64(nla);
+		break;
+	case NLA_U64:
+		/* treat this one specially, since it may not fit into s64 */
+		if ((validate_min && nla_get_u64(nla) < pt->min) ||
+		    (validate_max && nla_get_u64(nla) > pt->max)) {
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "integer out of range");
+			return -ERANGE;
+		}
+		return 0;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	if ((validate_min && value < pt->min) ||
+	    (validate_max && value > pt->max)) {
+		NL_SET_ERR_MSG_ATTR(extack, nla,
+				    "integer out of range");
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
 static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy,
 			struct netlink_ext_ack *extack)
@@ -230,6 +288,20 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			goto out_err;
 	}
 
+	/* further validation */
+	switch (pt->validation_type) {
+	case NLA_VALIDATE_NONE:
+		/* nothing to do */
+		break;
+	case NLA_VALIDATE_RANGE:
+	case NLA_VALIDATE_MIN:
+	case NLA_VALIDATE_MAX:
+		err = nla_validate_int_range(pt, nla, extack);
+		if (err)
+			return err;
+		break;
+	}
+
 	return 0;
 out_err:
 	NL_SET_ERR_MSG_ATTR(extack, nla, "Attribute failed policy validation");
-- 
2.14.4

