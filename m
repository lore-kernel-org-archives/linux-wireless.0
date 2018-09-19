Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.62]:53230 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727772AbeISRqx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Sep 2018 13:46:53 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 3/7] netlink: set extack error message in nla_validate()
Date: Wed, 19 Sep 2018 14:08:56 +0200
Message-Id: <20180919120900.28708-4-johannes@sipsolutions.net> (sfid-20180919_140951_691420_74C08A5D)
In-Reply-To: <20180919120900.28708-1-johannes@sipsolutions.net>
References: <20180919120900.28708-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

In nla_parse() we already set this, but it makes sense to
also do it in nla_validate() which already also sets the
bad attribute pointer.

CC: David Ahern <dsahern@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 lib/nlattr.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/lib/nlattr.c b/lib/nlattr.c
index e2e5b38394d5..33404745bec4 100644
--- a/lib/nlattr.c
+++ b/lib/nlattr.c
@@ -180,9 +180,13 @@ int nla_validate(const struct nlattr *head, int len, int maxtype,
 	int rem;
 
 	nla_for_each_attr(nla, head, len, rem) {
-		int err = validate_nla(nla, maxtype, policy, NULL);
+		static const char _msg[] = "Attribute failed policy validation";
+		const char *msg = _msg;
+		int err = validate_nla(nla, maxtype, policy, &msg);
 
 		if (err < 0) {
+			if (extack)
+				extack->_msg = msg;
 			NL_SET_BAD_ATTR(extack, nla);
 			return err;
 		}
-- 
2.14.4
