Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41960 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754945Ab0I3Vpc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 17:45:32 -0400
Received: by qyk36 with SMTP id 36so2260806qyk.19
        for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 14:45:30 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 30 Sep 2010 17:45:22 -0400
Message-ID: <AANLkTi=aV15hHyg+qoU8m3jTrzKunjq2-vrZJCep6WCh@mail.gmail.com>
Subject: [PATCH] cfg80211: add interface to set WDS peer BSSID
From: Bill Jordan <bjordan@rajant.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Splitting up previous patch as requested.

Added a nl interface to set the peer bssid of a WDS interface.

I also have patches to iw to add a "set peer" option which uses this
interface. Is this the
right place to submit patches to iw?

Signed-off-by: Bill Jordan <bjordan@rajant.com>
---
 include/linux/nl80211.h |    3 ++
 net/wireless/nl80211.c  |   49 +++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
index f0518b0..35a9681 100644
--- a/include/linux/nl80211.h
+++ b/include/linux/nl80211.h
@@ -387,6 +387,8 @@
  *	of any other interfaces, and other interfaces will again take
  *	precedence when they are used.
  *
+ * @NL80211_CMD_SET_WDS_PEER: Set the MAC address of the peer on a
WDS interface.
+ *
  * @NL80211_CMD_MAX: highest used command number
  * @__NL80211_CMD_AFTER_LAST: internal use
  */
@@ -489,6 +491,7 @@ enum nl80211_commands {
 	NL80211_CMD_NOTIFY_CQM,

 	NL80211_CMD_SET_CHANNEL,
+	NL80211_CMD_SET_WDS_PEER,

 	/* add new commands above here */

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9c84825..c401349 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -603,6 +603,7 @@ static int nl80211_send_wiphy(struct sk_buff *msg,
u32 pid, u32 seq, int flags,
 		NLA_PUT_U32(msg, i, NL80211_CMD_SET_WIPHY_NETNS);
 	}
 	CMD(set_channel, SET_CHANNEL);
+	CMD(set_wds_peer, SET_WDS_PEER);

 #undef CMD

@@ -831,6 +832,48 @@ static int nl80211_set_channel(struct sk_buff
*skb, struct genl_info *info)
 	return result;
 }

+static int nl80211_set_wds_peer(struct sk_buff *skb, struct genl_info *info)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+	struct net_device *dev;
+	u8 *bssid;
+	int err;
+
+	if (!info->attrs[NL80211_ATTR_MAC])
+		return -EINVAL;
+
+	rtnl_lock();
+
+	err = get_rdev_dev_by_info_ifindex(info, &rdev, &dev);
+	if (err)
+		goto unlock_rtnl;
+
+	wdev = dev->ieee80211_ptr;
+
+	if (!rdev->ops->set_wds_peer) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	if (wdev->iftype != NL80211_IFTYPE_WDS) {
+		err = -EOPNOTSUPP;
+		goto out;
+	}
+
+	bssid = nla_data(info->attrs[NL80211_ATTR_MAC]);
+	err = rdev->ops->set_wds_peer(wdev->wiphy, dev, bssid);
+
+out:
+	cfg80211_unlock_rdev(rdev);
+	dev_put(dev);
+unlock_rtnl:
+	rtnl_unlock();
+
+	return err;
+}
+
+
 static int nl80211_set_wiphy(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev;
@@ -5462,6 +5505,12 @@ static struct genl_ops nl80211_ops[] = {
 		.policy = nl80211_policy,
 		.flags = GENL_ADMIN_PERM,
 	},
+	{
+		.cmd = NL80211_CMD_SET_WDS_PEER,
+		.doit = nl80211_set_wds_peer,
+		.policy = nl80211_policy,
+		.flags = GENL_ADMIN_PERM,
+	},
 };

 static struct genl_multicast_group nl80211_mlme_mcgrp = {
-- 
1.7.2.3
