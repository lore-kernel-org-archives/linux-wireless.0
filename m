Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:44852 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751092AbaIJME2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 08:04:28 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH] cfg80211: clear nl80211 messages carrying keys after processing
Date: Wed, 10 Sep 2014 15:00:16 +0300
Message-Id: <1410350416-16339-1-git-send-email-emmanuel.grumbach@intel.com> (sfid-20140910_140431_323449_C99071F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Clear any nl80211 messages that might contain keys after
processing them to avoid leaving their data in memory
"forever" after they've been freed.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 net/wireless/nl80211.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 51eb526..1dea517 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -9587,6 +9587,7 @@ static int nl80211_del_tx_ts(struct sk_buff *skb, struct genl_info *info)
 /* If a netdev is associated, it must be UP, P2P must be started */
 #define NL80211_FLAG_NEED_WDEV_UP	(NL80211_FLAG_NEED_WDEV |\
 					 NL80211_FLAG_CHECK_NETDEV_UP)
+#define NL80211_FLAG_CLEAR_SKB		0x20
 
 static int nl80211_pre_doit(__genl_const struct genl_ops *ops, struct sk_buff *skb,
 			    struct genl_info *info)
@@ -9676,8 +9677,20 @@ static void nl80211_post_doit(__genl_const struct genl_ops *ops, struct sk_buff
 			dev_put(info->user_ptr[1]);
 		}
 	}
+
 	if (ops->internal_flags & NL80211_FLAG_NEED_RTNL)
 		rtnl_unlock();
+
+	/* If needed, clear the netlink message payload from the SKB
+	 * as it might contain key data that shouldn't stick around on
+	 * the heap after the SKB is freed. The netlink message header
+	 * is still needed for further processing, so leave it intact.
+	 */
+	if (ops->internal_flags & NL80211_FLAG_CLEAR_SKB) {
+		struct nlmsghdr *nlh = nlmsg_hdr(skb);
+
+		memset(nlmsg_data(nlh), 0, nlmsg_len(nlh));
+	}
 }
 
 static __genl_const struct genl_ops nl80211_ops[] = {
@@ -9745,7 +9758,8 @@ static __genl_const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_NEW_KEY,
@@ -9753,7 +9767,8 @@ static __genl_const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_DEL_KEY,
@@ -9931,7 +9946,8 @@ static __genl_const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_ASSOCIATE,
@@ -10165,7 +10181,8 @@ static __genl_const struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 		.internal_flags = NL80211_FLAG_NEED_NETDEV_UP |
-				  NL80211_FLAG_NEED_RTNL,
+				  NL80211_FLAG_NEED_RTNL |
+				  NL80211_FLAG_CLEAR_SKB,
 	},
 	{
 		.cmd = NL80211_CMD_TDLS_MGMT,
-- 
1.9.1

