Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:33637 "EHLO
	mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbcHLQM1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2016 12:12:27 -0400
Received: by mail-oi0-f65.google.com with SMTP id s207so2436740oie.0
        for <linux-wireless@vger.kernel.org>; Fri, 12 Aug 2016 09:12:27 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v2] nl80211: Allow GET_INTERFACE dumps to be filtered
Date: Fri, 12 Aug 2016 11:12:37 -0500
Message-Id: <1471018357-3047-1-git-send-email-denkenz@gmail.com> (sfid-20160812_181231_305175_FD58D5D3)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows GET_INTERFACE dumps to be filtered based on
NL80211_ATTR_WIPHY or NL80211_ATTR_WDEV.  The documentation for
GET_INTERFACE mentions that this is possible:
"Request an interface's configuration; either a dump request on
a %NL80211_ATTR_WIPHY or ..."

However, this behavior has not been implemented until now.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/nl80211.c | 63 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 55 insertions(+), 8 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 4997857..aa85871 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2519,27 +2519,74 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	return -EMSGSIZE;
 }
 
+static int nl80211_dump_interface_parse(struct sk_buff *skb,
+					struct netlink_callback *cb,
+					int *filter_wiphy)
+{
+	struct nlattr **tb = nl80211_fam.attrbuf;
+	int ret = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+			      tb, nl80211_fam.maxattr, nl80211_policy);
+
+	/* ignore parse errors for backward compatibility */
+	if (ret)
+		return 0;
+
+	if (tb[NL80211_ATTR_WIPHY])
+		*filter_wiphy = nla_get_u32(tb[NL80211_ATTR_WIPHY]);
+	if (tb[NL80211_ATTR_WDEV])
+		*filter_wiphy = nla_get_u64(tb[NL80211_ATTR_WDEV]) >> 32;
+
+	return 0;
+}
+
+struct dump_interface_context {
+	unsigned int wp_start;
+	unsigned int if_start;
+	int filter_wiphy;
+};
+
 static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *cb)
 {
-	int wp_idx = 0;
-	int if_idx = 0;
-	int wp_start = cb->args[0];
-	int if_start = cb->args[1];
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
+	unsigned int wp_idx = 0;
+	unsigned int if_idx;
+	static struct dump_interface_context static_ctx;
+	struct dump_interface_context *ctx = cb->args[0];
+
+	if (!ctx) {
+		int ret;
+
+		static_ctx.wp_start = 0;
+		static_ctx.if_start = 0;
+		static_ctx.filter_wiphy = -1;
+
+		ret = nl80211_dump_interface_parse(skb, cb,
+						   &static_ctx.filter_wiphy);
+		if (ret)
+			return ret;
+
+		ctx = &static_ctx;
+		cb->args[0] = ctx;
+	}
 
 	rtnl_lock();
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (!net_eq(wiphy_net(&rdev->wiphy), sock_net(skb->sk)))
 			continue;
-		if (wp_idx < wp_start) {
+		if (wp_idx < ctx->wp_start) {
 			wp_idx++;
 			continue;
 		}
+
+		if (ctx->filter_wiphy != -1 &&
+		    ctx->filter_wiphy != rdev->wiphy_idx)
+			continue;
+
 		if_idx = 0;
 
 		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-			if (if_idx < if_start) {
+			if (if_idx < ctx->if_start) {
 				if_idx++;
 				continue;
 			}
@@ -2556,8 +2603,8 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
  out:
 	rtnl_unlock();
 
-	cb->args[0] = wp_idx;
-	cb->args[1] = if_idx;
+	ctx->wp_start = wp_idx;
+	ctx->if_start = if_idx;
 
 	return skb->len;
 }
-- 
2.7.3

