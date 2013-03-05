Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:45295 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab3CEKEx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 05:04:53 -0500
Message-ID: <1362477886.8224.0.camel@jlt4.sipsolutions.net> (sfid-20130305_110457_671876_40CC9541)
Subject: [PATCH] compat-wireless: fix netlink portid patch for nl80211
From: Johannes Berg <johannes@sipsolutions.net>
To: backports@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Tue, 05 Mar 2013 11:04:46 +0100
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 patches/0005-netlink-portid.patch | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/patches/0005-netlink-portid.patch b/patches/0005-netlink-portid.patch
index ee9bc85..ebf10b6 100644
--- a/patches/0005-netlink-portid.patch
+++ b/patches/0005-netlink-portid.patch
@@ -70,11 +70,11 @@ this one should other drivers / subsystem need this change.
  			continue;
  		if (++idx <= start)
  			continue;
--		if (nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).portid,
-+		if (nl80211_send_wiphy(skb, NETLINK_CB_PORTID(skb),
- 				       cb->nlh->nlmsg_seq, NLM_F_MULTI,
- 				       dev) < 0) {
- 			idx--;
+-		ret = nl80211_send_wiphy(skb, NETLINK_CB(cb->skb).portid,
++		ret = nl80211_send_wiphy(skb, NETLINK_CB_PORTID(skb),
+ 					 cb->nlh->nlmsg_seq, NLM_F_MULTI,
+ 					 dev);
+ 		if (ret < 0) {
 @@ -1300,7 +1300,7 @@ static int nl80211_get_wiphy(struct sk_buff *skb, struct genl_info *info)
  	if (!msg)
  		return -ENOMEM;
-- 
1.8.0



