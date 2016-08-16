Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33178 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753281AbcHPHZs (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Aug 2016 03:25:48 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v3] nl80211: Allow GET_INTERFACE dumps to be filtered
Date: Tue, 16 Aug 2016 09:25:35 +0200
Message-Id: <1471332335-9251-1-git-send-email-johannes@sipsolutions.net> (sfid-20160816_092556_088339_4C995166)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Denis Kenzior <denkenz@gmail.com>

This patch allows GET_INTERFACE dumps to be filtered based on
NL80211_ATTR_WIPHY or NL80211_ATTR_WDEV.  The documentation for
GET_INTERFACE mentions that this is possible:
"Request an interface's configuration; either a dump request on
a %NL80211_ATTR_WIPHY or ..."

However, this behavior has not been implemented until now.

Johannes: rewrite most of the patch:
 * use nl80211_dump_wiphy_parse() to also allow passing an interface
   to be able to dump its siblings
 * fix locking (must hold rtnl around using nl80211_fam.attrbuf)
 * make init self-contained instead of relying on other cb->args

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/nl80211.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 499785778983..95d55d2b8a0f 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2525,10 +2525,33 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 	int if_idx = 0;
 	int wp_start = cb->args[0];
 	int if_start = cb->args[1];
+	int filter_wiphy = -1;
 	struct cfg80211_registered_device *rdev;
 	struct wireless_dev *wdev;
 
 	rtnl_lock();
+	if (!cb->args[2]) {
+		struct nl80211_dump_wiphy_state state = {};
+		int ret;
+
+		ret = nl80211_dump_wiphy_parse(skb, cb, &state);
+		if (ret)
+			return ret;
+
+		filter_wiphy = state.filter_wiphy;
+
+		/*
+		 * if filtering, set cb->args[2] to +1 since 0 is the default
+		 * value needed to determine that parsing is necessary.
+		 */
+		if (filter_wiphy >= 0)
+			cb->args[2] = filter_wiphy + 1;
+		else
+			cb->args[2] = -1;
+	} else if (cb->args[2] > 0) {
+		filter_wiphy = cb->args[2] - 1;
+	}
+
 	list_for_each_entry(rdev, &cfg80211_rdev_list, list) {
 		if (!net_eq(wiphy_net(&rdev->wiphy), sock_net(skb->sk)))
 			continue;
@@ -2536,6 +2559,10 @@ static int nl80211_dump_interface(struct sk_buff *skb, struct netlink_callback *
 			wp_idx++;
 			continue;
 		}
+
+		if (filter_wiphy >= 0 && filter_wiphy != rdev->wiphy_idx)
+			continue;
+
 		if_idx = 0;
 
 		list_for_each_entry(wdev, &rdev->wiphy.wdev_list, list) {
-- 
2.8.1
