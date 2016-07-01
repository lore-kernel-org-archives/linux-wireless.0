Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34992 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727AbcF3QvT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jun 2016 12:51:19 -0400
Received: by mail-oi0-f68.google.com with SMTP id d132so8401968oig.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jun 2016 09:51:19 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [RFC] nl80211: Allow GET_INTERFACE dumps to be filtered
Date: Thu, 30 Jun 2016 19:51:34 -0500
Message-Id: <1467334294-6384-1-git-send-email-denkenz@gmail.com> (sfid-20160630_185128_850366_B817D4E2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch allows GET_INTERFACE dumps to be filtered based on
NL80211_ATTR_WIPHY or NL80211_ATTR_WDEV.  The documentation for
GET_INTERFACE mentions that this is possible:
"Request an interface's configuration; either a dump request on
a %NL80211_ATTR_WIPHY or ..."

However, this behavior has not been implemented until now.
---
 net/wireless/nl80211.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 244d552..24cb4d9 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2515,15 +2515,47 @@ static int nl80211_send_iface(struct sk_buff *msg, u32 portid, u32 seq, int flag
 	return -EMSGSIZE;
 }
 
+static int nl80211_dump_interface_parse(struct sk_buff *skb,
+				    struct netlink_callback *cb,
+				    int *filter_wiphy)
+{
+	struct nlattr **tb = nl80211_fam.attrbuf;
+	int ret = nlmsg_parse(cb->nlh, GENL_HDRLEN + nl80211_fam.hdrsize,
+			      tb, nl80211_fam.maxattr, nl80211_policy);
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
 static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *cb)
 {
 	int wp_idx = 0;
 	int if_idx = 0;
 	int wp_start = cb->args[0];
 	int if_start = cb->args[1];
+	int filter_wiphy = cb->args[2];
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 
+	if (!wp_start && !if_start && !filter_wiphy) {
+		int ret;
+
+		filter_wiphy = -1;
+
+		ret = nl80211_dump_interface_parse(skb, cb, &filter_wiphy);
+		if (ret)
+			return ret;
+
+		cb->args[2] = filter_wiphy;
+	}
+
 	rtnl_lock();
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (!net_eq(wiphy_net(&rdev->wiphy), sock_net(skb->sk)))
@@ -2532,6 +2564,10 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			wp_idx++;
 			continue;
 		}
+
+		if (filter_wiphy != -1 && filter_wiphy != rdev->wiphy_idx)
+			continue;
+
 		if_idx = 0;
 
 		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-- 
2.7.3

