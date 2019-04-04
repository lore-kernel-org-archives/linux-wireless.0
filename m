Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D641AC10F05
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADB3820643
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfDDGyT (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:54:19 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55728 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfDDGyS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 02:54:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBwGM-0003Pn-Uh; Thu, 04 Apr 2019 08:54:15 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 1/6] netlink: add NLA_MIN_LEN
Date:   Thu,  4 Apr 2019 08:54:03 +0200
Message-Id: <20190404065408.5864-2-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190404065408.5864-1-johannes@sipsolutions.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Rather than using NLA_UNSPEC for this type of thing, use NLA_MIN_LEN
so we can make NLA_UNSPEC be NLA_REJECT under certain conditions for
future attributes.

While at it, also use NLA_EXACT_LEN for the struct example.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 6 +++++-
 lib/nlattr.c          | 9 ++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 23f27b0b3cef..06f8605b740c 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -183,6 +183,7 @@ enum {
 	NLA_REJECT,
 	NLA_EXACT_LEN,
 	NLA_EXACT_LEN_WARN,
+	NLA_MIN_LEN,
 	__NLA_TYPE_MAX,
 };
 
@@ -212,6 +213,7 @@ enum nla_policy_validation {
  *    NLA_NUL_STRING       Maximum length of string (excluding NUL)
  *    NLA_FLAG             Unused
  *    NLA_BINARY           Maximum length of attribute payload
+ *    NLA_MIN_LEN          Minimum length of attribute payload
  *    NLA_NESTED,
  *    NLA_NESTED_ARRAY     Length verification is done by checking len of
  *                         nested header (or empty); len field is used if
@@ -230,6 +232,7 @@ enum nla_policy_validation {
  *                         it is rejected.
  *    NLA_EXACT_LEN_WARN   Attribute should have exactly this length, a warning
  *                         is logged if it is longer, shorter is rejected.
+ *    NLA_MIN_LEN          Minimum length of attribute payload
  *    All other            Minimum length of attribute payload
  *
  * Meaning of `validation_data' field:
@@ -281,7 +284,7 @@ enum nla_policy_validation {
  * static const struct nla_policy my_policy[ATTR_MAX+1] = {
  * 	[ATTR_FOO] = { .type = NLA_U16 },
  *	[ATTR_BAR] = { .type = NLA_STRING, .len = BARSIZ },
- *	[ATTR_BAZ] = { .len = sizeof(struct mystruct) },
+ *	[ATTR_BAZ] = { .type = NLA_EXACT_LEN, .len = sizeof(struct mystruct) },
  *	[ATTR_GOO] = { .type = NLA_BITFIELD32, .validation_data = &myvalidflags },
  * };
  */
@@ -302,6 +305,7 @@ struct nla_policy {
 #define NLA_POLICY_EXACT_LEN(_len)	{ .type = NLA_EXACT_LEN, .len = _len }
 #define NLA_POLICY_EXACT_LEN_WARN(_len)	{ .type = NLA_EXACT_LEN_WARN, \
 					  .len = _len }
+#define NLA_POLICY_MIN_LEN(_len)	{ .type = NLA_MIN_LEN, .len = _len }
 
 #define NLA_POLICY_ETH_ADDR		NLA_POLICY_EXACT_LEN(ETH_ALEN)
 #define NLA_POLICY_ETH_ADDR_COMPAT	NLA_POLICY_EXACT_LEN_WARN(ETH_ALEN)
diff --git a/lib/nlattr.c b/lib/nlattr.c
index d26de6156b97..465c9e8ef8a5 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -278,10 +278,17 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			}
 		}
 		break;
+
+	case NLA_UNSPEC:
+	case NLA_MIN_LEN:
+		if (attrlen < pt->len)
+			goto out_err;
+		break;
+
 	default:
 		if (pt->len)
 			minlen = pt->len;
-		else if (pt->type != NLA_UNSPEC)
+		else
 			minlen = nla_attr_minlen[pt->type];
 
 		if (attrlen < minlen)
-- 
2.17.2

