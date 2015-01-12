Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:40346 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257AbbALOog (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Jan 2015 09:44:36 -0500
Received: by mail-lb0-f178.google.com with SMTP id u14so17865381lbd.9
        for <linux-wireless@vger.kernel.org>; Mon, 12 Jan 2015 06:44:34 -0800 (PST)
From: Vadim Kochan <vadim4j@gmail.com>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, Vadim Kochan <vadim4j@gmail.com>
Subject: [PATCH mac80211-next] nl80211: Allow set network namespace by fd
Date: Mon, 12 Jan 2015 16:34:05 +0200
Message-Id: <1421073245-20312-1-git-send-email-vadim4j@gmail.com> (sfid-20150112_154439_462402_28679D27)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vadim Kochan <vadim4j@gmail.com>

Added new NL80211_ATTR_NETNS_FD which allows to
set namespace via nl80211 by fd.

Signed-off-by: Vadim Kochan <vadim4j@gmail.com>
---
 include/uapi/linux/nl80211.h |  2 ++
 net/core/net_namespace.c     |  1 +
 net/wireless/nl80211.c       | 16 +++++++++++-----
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index a963d48..47757cb 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2098,6 +2098,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SURVEY_RADIO_STATS,
 
+	NL80211_ATTR_NETNS_FD,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
index 7f15517..5d5ee8f 100644
--- a/net/core/net_namespace.c
+++ b/net/core/net_namespace.c
@@ -361,6 +361,7 @@ struct net *get_net_ns_by_fd(int fd)
 	return ERR_PTR(-EINVAL);
 }
 #endif
+EXPORT_SYMBOL_GPL(get_net_ns_by_fd);
 
 struct net *get_net_ns_by_pid(pid_t pid)
 {
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 7c2ce26..dfa3284 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -397,6 +397,7 @@ static const struct nla_policy nl80211_policy[NUM_NL80211_ATTR] = {
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
 	[NL80211_ATTR_MAC_MASK] = { .len = ETH_ALEN },
 	[NL80211_ATTR_WIPHY_SELF_MANAGED_REG] = { .type = NLA_FLAG },
+	[NL80211_ATTR_NETNS_FD] = { .type = NLA_U32 },
 };
 
 /* policy for the key attributes */
@@ -7744,14 +7745,19 @@ static int nl80211_wiphy_netns(struct sk_buff *skb, struct genl_info *info)
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct net *net;
 	int err;
-	u32 pid;
 
-	if (!info->attrs[NL80211_ATTR_PID])
-		return -EINVAL;
+	if (info->attrs[NL80211_ATTR_PID]) {
+		u32 pid = nla_get_u32(info->attrs[NL80211_ATTR_PID]);
+
+		net = get_net_ns_by_pid(pid);
+	} else if (info->attrs[NL80211_ATTR_NETNS_FD]) {
+		u32 fd = nla_get_u32(info->attrs[NL80211_ATTR_NETNS_FD]);
 
-	pid = nla_get_u32(info->attrs[NL80211_ATTR_PID]);
+		net = get_net_ns_by_fd(fd);
+	} else {
+		return -EINVAL;
+	}
 
-	net = get_net_ns_by_pid(pid);
 	if (IS_ERR(net))
 		return PTR_ERR(net);
 
-- 
2.1.3

