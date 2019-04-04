Return-Path: <SRS0=xyYy=SG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52380C10F0D
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2E23B20643
	for <linux-wireless@archiver.kernel.org>; Thu,  4 Apr 2019 06:54:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727199AbfDDGyU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 4 Apr 2019 02:54:20 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:55736 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726966AbfDDGyT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 4 Apr 2019 02:54:19 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC5)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hBwGN-0003Pn-Ug; Thu, 04 Apr 2019 08:54:16 +0200
From:   Johannes Berg <johannes@sipsolutions.net>
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        David Ahern <dsa@cumulusnetworks.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/6] netlink: re-add parse/validate functions in strict mode
Date:   Thu,  4 Apr 2019 08:54:05 +0200
Message-Id: <20190404065408.5864-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.17.2
In-Reply-To: <20190404065408.5864-1-johannes@sipsolutions.net>
References: <20190404065408.5864-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

This re-adds the parse and validate functions like nla_parse()
that are now actually strict after the previous rename and were
just split out to make sure everything is converted (and if not
compilation of the previous patch would fail.)

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/genetlink.h | 19 ++++++++++++
 include/net/netlink.h   | 65 +++++++++++++++++++++++++++++++++++++++++
 2 files changed, 84 insertions(+)

diff --git a/include/net/genetlink.h b/include/net/genetlink.h
index 897cdba13569..68de579cfe5e 100644
--- a/include/net/genetlink.h
+++ b/include/net/genetlink.h
@@ -183,6 +183,25 @@ static inline int genlmsg_parse_deprecated(const struct nlmsghdr *nlh,
 			     policy, NL_VALIDATE_LIBERAL, extack);
 }
 
+/**
+ * genlmsg_parse - parse attributes of a genetlink message
+ * @nlh: netlink message header
+ * @family: genetlink message family
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @policy: validation policy
+ * @extack: extended ACK report struct
+ */
+static inline int genlmsg_parse(const struct nlmsghdr *nlh,
+				const struct genl_family *family,
+				struct nlattr *tb[], int maxtype,
+				const struct nla_policy *policy,
+				struct netlink_ext_ack *extack)
+{
+	return __nlmsg_parse(nlh, family->hdrsize + GENL_HDRLEN, tb, maxtype,
+			     policy, NL_VALIDATE_STRICT, extack);
+}
+
 /**
  * genl_dump_check_consistent - check if sequence is consistent and advertise if not
  * @cb: netlink callback structure that stores the sequence number
diff --git a/include/net/netlink.h b/include/net/netlink.h
index 58570462db6d..d75545c906b6 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -542,6 +542,31 @@ nlmsg_next(const struct nlmsghdr *nlh, int *remaining)
 	return (struct nlmsghdr *) ((unsigned char *) nlh + totlen);
 }
 
+/**
+ * nla_parse - Parse a stream of attributes into a tb buffer
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @head: head of attribute stream
+ * @len: length of attribute stream
+ * @policy: validation policy
+ * @extack: extended ACK pointer
+ *
+ * Parses a stream of attributes and stores a pointer to each attribute in
+ * the tb array accessible via the attribute type. Attributes with a type
+ * exceeding maxtype will be rejected, policy must be specified, attributes
+ * will be validated in the strictest way possible.
+ *
+ * Returns 0 on success or a negative error code.
+ */
+static inline int nla_parse(struct nlattr **tb, int maxtype,
+			    const struct nlattr *head, int len,
+			    const struct nla_policy *policy,
+			    struct netlink_ext_ack *extack)
+{
+	return __nla_parse(tb, maxtype, head, len, policy,
+			   NL_VALIDATE_STRICT, extack);
+}
+
 /**
  * nla_parse_deprecated - Parse a stream of attributes into a tb buffer
  * @tb: destination array with maxtype+1 elements
@@ -595,6 +620,27 @@ static inline int __nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
 			   extack);
 }
 
+/**
+ * nlmsg_parse - parse attributes of a netlink message
+ * @nlh: netlink message header
+ * @hdrlen: length of family specific header
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @validate: validation strictness
+ * @extack: extended ACK report struct
+ *
+ * See nla_parse()
+ */
+static inline int nlmsg_parse(const struct nlmsghdr *nlh, int hdrlen,
+			      struct nlattr *tb[], int maxtype,
+			      const struct nla_policy *policy,
+			      struct netlink_ext_ack *extack)
+{
+	return __nla_parse(tb, maxtype, nlmsg_attrdata(nlh, hdrlen),
+			   nlmsg_attrlen(nlh, hdrlen), policy,
+			   NL_VALIDATE_STRICT, extack);
+}
+
 /**
  * nlmsg_parse_deprecated - parse attributes of a netlink message
  * @nlh: netlink message header
@@ -1009,6 +1055,25 @@ nla_find_nested(const struct nlattr *nla, int attrtype)
 	return nla_find(nla_data(nla), nla_len(nla), attrtype);
 }
 
+/**
+ * nla_parse_nested - parse nested attributes
+ * @tb: destination array with maxtype+1 elements
+ * @maxtype: maximum attribute type to be expected
+ * @nla: attribute containing the nested attributes
+ * @policy: validation policy
+ * @extack: extended ACK report struct
+ *
+ * See nla_parse()
+ */
+static inline int nla_parse_nested(struct nlattr *tb[], int maxtype,
+				   const struct nlattr *nla,
+				   const struct nla_policy *policy,
+				   struct netlink_ext_ack *extack)
+{
+	return __nla_parse(tb, maxtype, nla_data(nla), nla_len(nla), policy,
+			   NL_VALIDATE_STRICT, extack);
+}
+
 /**
  * nla_parse_nested_deprecated - parse nested attributes
  * @tb: destination array with maxtype+1 elements
-- 
2.17.2

