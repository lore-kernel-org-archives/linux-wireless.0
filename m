Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:59446 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732757AbeITB2p (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 21:28:45 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH v2 1/5] netlink: remove NLA_NESTED_COMPAT
Date: Wed, 19 Sep 2018 21:49:01 +0200
Message-Id: <20180919194905.16462-2-johannes@sipsolutions.net> (sfid-20180919_214937_577138_4C32905B)
In-Reply-To: <20180919194905.16462-1-johannes@sipsolutions.net>
References: <20180919194905.16462-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This isn't used anywhere, so we might as well get rid of it.

Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h |  2 --
 lib/nlattr.c          | 11 -----------
 2 files changed, 13 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index 318b1ded3833..b680fe365e91 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -172,7 +172,6 @@ enum {
 	NLA_FLAG,
 	NLA_MSECS,
 	NLA_NESTED,
-	NLA_NESTED_COMPAT,
 	NLA_NUL_STRING,
 	NLA_BINARY,
 	NLA_S8,
@@ -203,7 +202,6 @@ enum {
  *    NLA_BINARY           Maximum length of attribute payload
  *    NLA_NESTED           Don't use `len' field -- length verification is
  *                         done by checking len of nested header (or empty)
- *    NLA_NESTED_COMPAT    Minimum length of structure payload
  *    NLA_U8, NLA_U16,
  *    NLA_U32, NLA_U64,
  *    NLA_S8, NLA_S16,
diff --git a/lib/nlattr.c b/lib/nlattr.c
index bb6fe5ed4ecf..120ad569e13d 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -140,17 +140,6 @@ static int validate_nla(const struct nlattr *nla, int maxtype,
 			return -ERANGE;
 		break;
 
-	case NLA_NESTED_COMPAT:
-		if (attrlen < pt->len)
-			return -ERANGE;
-		if (attrlen < NLA_ALIGN(pt->len))
-			break;
-		if (attrlen < NLA_ALIGN(pt->len) + NLA_HDRLEN)
-			return -ERANGE;
-		nla = nla_data(nla) + NLA_ALIGN(pt->len);
-		if (attrlen < NLA_ALIGN(pt->len) + NLA_HDRLEN + nla_len(nla))
-			return -ERANGE;
-		break;
 	case NLA_NESTED:
 		/* a nested attributes is allowed to be empty; if its not,
 		 * it must have a size of at least NLA_HDRLEN.
-- 
2.14.4
