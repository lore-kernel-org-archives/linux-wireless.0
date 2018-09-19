Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53226 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731399AbeISRqw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:46:52 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/7] netlink: make validation_data const
Date: Wed, 19 Sep 2018 14:08:55 +0200
Message-Id: <20180919120900.28708-3-johannes@sipsolutions.net> (sfid-20180919_140947_807720_76E9DEF5)
In-Reply-To: <20180919120900.28708-1-johannes@sipsolutions.net>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

The validation data is only used within the policy that
should usually already be const, and isn't changed in any
code that uses it. Therefore, make the validation_data
pointer const.

While at it, remove the duplicate variable in the bitfield
validation that I'd otherwise have to change to const.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/netlink.h | 2 +-
 lib/nlattr.c          | 5 ++---
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/include/net/netlink.h b/include/net/netlink.h
index b680fe365e91..0d698215d4d9 100644
--- a/include/net/netlink.h
+++ b/include/net/netlink.h
@@ -237,7 +237,7 @@ enum {
 struct nla_policy {
 	u16		type;
 	u16		len;
-	void            *validation_data;
+	const void     *validation_data;
 };
 
 #define NLA_POLICY_EXACT_LEN(_len)	{ .type = NLA_EXACT_LEN, .len = _len }
diff --git a/lib/nlattr.c b/lib/nlattr.c
index 120ad569e13d..e2e5b38394d5 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -45,12 +45,11 @@ static const u8 nla_attr_minlen[NLA_TYPE_MAX+1] = {
 };
 
 static int validate_nla_bitfield32(const struct nlattr *nla,
-				   u32 *valid_flags_allowed)
+				   const u32 *valid_flags_mask)
 {
 	const struct nla_bitfield32 *bf = nla_data(nla);
-	u32 *valid_flags_mask = valid_flags_allowed;
 
-	if (!valid_flags_allowed)
+	if (!valid_flags_mask)
 		return -EINVAL;
 
 	/*disallow invalid bit selector */
-- 
2.14.4
