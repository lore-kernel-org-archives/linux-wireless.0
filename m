Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F9A2C10F0F
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EAE3A206DF
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727230AbfDDGy1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:54:27 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55740 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfDDGyS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 02:54:18 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBwGO-0003Pn-Fs; Thu, 04 Apr 2019 08:54:16 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 4/6] netlink: add strict parsing for future attributes
Date:   Thu,  4 Apr 2019 08:54:06 +0200
Message-Id: <20190404065408.5864-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190404065408.5864-1-johannes@sipsolutions.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

Unfortunately, we cannot add strict parsing for all attributes, as
that would break existing userspace. We currently warn about it, but
that's about all we can do.

For new attributes, however, the story is better: nobody is using
them, so we can reject bad sizes.

Also, for new attributes, we need not accept them when the policy
doesn't declare their usage.

David Ahern and I went back and forth on how to best encode this, and
the best way we found was to have a "boundary type", from which point
on new attributes have all possible validation applied, and NLA_UNSPEC
is rejected.

As we didn't want to add another argument to all functions that get a
netlink policy, the workaround is to encode that boundary in the first
entry of the policy array (which is for type 0 and thus probably not
really valid anyway). I put it into the validation union for the rare
possibility that somebody is actually using attribute 0, which would
continue to work fine unless they tried to use the extended validation,
which isn't likely. We also didn't find any in-tree users with type 0.

The reason for setting the "start strict here" attribute is that we
never really need to start strict from 0, which is invalid anyway (or
in legacy families where that isn't true, it cannot be set to strict),
so we can thus reserve the value 0 for "don't do this check" and don't
have to add the tag to all policies right now.

Thus, policies can now opt in to this validation, which we should do
for all existing policies, at least when adding new attributes.

Note that entirely *new* policies won't need to set it, as the use
of that should be using nla_parse()/nlmsg_parse() etc. which anyway
do fully strict validation now, regardless of this.

So in effect, this patch only covers the "existing command with new
attribute" case.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 18 ++++++++++++++++++
 lib/nlattr.c          |  4 ++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index d75545c906b6..fdb39b0fd752 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -299,6 +299,24 @@ struct nla_policy {
 		};
 		int (*validate)(const struct nlattr *attr,
 				struct netlink_ext_ack *extack);
+		/* This entry is special, and used for the attribute at index 0
+		 * only, and specifies special data about the policy, namely it
+		 * specifies the "boundary type" where strict length validation
+		 * starts for any attribute types >= this value, also, strict
+		 * nesting validation starts here.
+		 *
+		 * Additionally, it means that NLA_UNSPEC is actually NLA_REJECT
+		 * for any types >= this, so need to use NLA_MIN_LEN to get the
+		 * previous pure { .len = xyz } behaviour. The advantage of this
+		 * is that types not specified in the policy will be rejected.
+		 *
+		 * For completely new families it should be set to 1 so that the
+		 * validation is enforced for all attributes. For existing ones
+		 * it should be set at least when new attributes are added to
+		 * the enum used by the policy, and be set to the new value that
+		 * was added to enforce strict validation from thereon.
+		 */
+		u16 strict_start_type;
 	};
 };
 
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 3ba54904256a..63691d40eccf 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -158,10 +158,14 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			const struct nla_policy *policy, unsigned int validate,
 			struct netlink_ext_ack *extack)
 {
+	u16 strict_start_type = policy[0].strict_start_type;
 	const struct nla_policy *pt;
 	int minlen = 0, attrlen = nla_len(nla), type = nla_type(nla);
 	int err = -ERANGE;
 
+	if (strict_start_type && type >= strict_start_type)
+		validate |= NL_VALIDATE_STRICT;
+
 	if (type <= 0 || type > maxtype)
 		return 0;
 
-- 
2.17.2

