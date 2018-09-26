Return-Path: <SRS0=mZ/2=MI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B30F1C43382
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B97221533
	for <linux-wireless@archiver.kernel.org>; Wed, 26 Sep 2018 20:06:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B97221533
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbeI0CVZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 26 Sep 2018 22:21:25 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45994 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726107AbeI0CVZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Sep 2018 22:21:25 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1g5G56-0003uP-05; Wed, 26 Sep 2018 22:06:44 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] netlink: add policy attribute range validation
Date:   Wed, 26 Sep 2018 22:06:30 +0200
Message-Id: <20180926200630.23399-1-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.14.4
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

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 25 +++++++++++++++++++++++--
 lib/nlattr.c          | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 3698ca8ff92c..ddabc832febc 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -238,7 +238,23 @@ enum {
  *                         nested attributes directly inside, while an array has
  *                         the nested attributes at another level down and the
  *                         attributes directly in the nesting don't matter.
- *    All other            Unused
+ *    All other            Unused - but note that it's a union
+ *
+ * Meaning of `min' and `max' fields:
+ *    NLA_U8,
+ *    NLA_U16,
+ *    NLA_U32,
+ *    NLA_U64,
+ *    NLA_S8,
+ *    NLA_S16,
+ *    NLA_S32,
+ *    NLA_S64              If at least one of them is non-zero, they are the
+ *                         minimum and maximum value accepted for the attribute;
+ *                         note that in the interest of code simplicity and
+ *                         struct size both limits are s16, so you cannot
+ *                         enforce a range that doesn't fall within the range
+ *                         of s16 - do that as usual in the code instead.
+ *    All other            Unused - but note that it's a union
  *
  * Example:
  * static const struct nla_policy my_policy[ATTR_MAX+1] = {
@@ -251,7 +267,12 @@ enum {
 struct nla_policy {
 	u16		type;
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
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 2f8feff669a7..dd8d34c1ae19 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -230,6 +230,55 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			goto out_err;
 	}
 
+	/* validate range */
+	if (pt->min || pt->max) {
+		s64 value;
+		bool validate = true;
+
+		switch (pt->type) {
+		case NLA_U8:
+			value = nla_get_u8(nla);
+			break;
+		case NLA_U16:
+			value = nla_get_u16(nla);
+			break;
+		case NLA_U32:
+			value = nla_get_u32(nla);
+			break;
+		case NLA_S8:
+			value = nla_get_s8(nla);
+			break;
+		case NLA_S16:
+			value = nla_get_s16(nla);
+			break;
+		case NLA_S32:
+			value = nla_get_s32(nla);
+			break;
+		case NLA_S64:
+			value = nla_get_s64(nla);
+			break;
+		case NLA_U64:
+			/* treat this one specially, since it may not fit into s64 */
+			if (nla_get_u64(nla) < pt->min ||
+			    nla_get_u64(nla) > pt->max) {
+				NL_SET_ERR_MSG_ATTR(extack, nla,
+						    "integer out of range");
+				return -ERANGE;
+			}
+			/* fall through */
+		default:
+			/* no further validation */
+			validate = false;
+			break;
+		}
+
+		if (validate && (value < pt->min || value > pt->max)) {
+			NL_SET_ERR_MSG_ATTR(extack, nla,
+					    "integer out of range");
+			return -ERANGE;
+		}
+	}
+
 	return 0;
 out_err:
 	NL_SET_ERR_MSG_ATTR(extack, nla, "Attribute failed policy validation");
-- 
2.14.4

