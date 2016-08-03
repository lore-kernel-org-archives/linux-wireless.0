Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:34495 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756700AbcHCOK3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Aug 2016 10:10:29 -0400
Received: by mail-oi0-f68.google.com with SMTP id a135so2322675oii.1
        for <linux-wireless@vger.kernel.org>; Wed, 03 Aug 2016 07:10:28 -0700 (PDT)
From: Denis Kenzior <denkenz@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Denis Kenzior <denkenz@gmail.com>
Subject: [PATCH v3 3/3] core: Always notify when wireless netdev is removed
Date: Wed,  3 Aug 2016 16:58:35 -0500
Message-Id: <1470261515-2830-4-git-send-email-denkenz@gmail.com> (sfid-20160803_161048_409742_6828899A)
In-Reply-To: <1470261515-2830-1-git-send-email-denkenz@gmail.com>
References: <1470261515-2830-1-git-send-email-denkenz@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This change alters the semantics of NL80211_CMD_DEL_INTERFACE events
by always sending this event whenever a net_device object associated
with a wdev is destroyed.  Prior to this change, this event was only
emitted as a result of NL80211_CMD_DEL_INTERFACE command sent from
userspace.  This allows userspace to reliably detect when wireless
interfaces have been removed, e.g. due to USB removal events, etc.

For wireless device objects without an associated net_device (e.g.
NL80211_IFTYPE_P2P_DEVICE), the NL80211_CMD_DEL_INTERFACE event is
now generated inside cfg80211_unregister_wdev.

Signed-off-by: Denis Kenzior <denkenz@gmail.com>
---
 net/wireless/core.c    |  4 ++++
 net/wireless/nl80211.c | 18 +-----------------
 2 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 7758c0f..fccead7 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -906,6 +906,8 @@ void cfg80211_unregister_wdev(struct wireless_dev *wdev)
 	if (WARN_ON(wdev->netdev))
 		return;
 
+	nl80211_notify_iface(rdev, wdev, NL80211_CMD_DEL_INTERFACE);
+
 	list_del_rcu(&wdev->list);
 	rdev->devlist_generation++;
 
@@ -1159,6 +1161,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 * remove and clean it up.
 		 */
 		if (!list_empty(&wdev->list)) {
+			nl80211_notify_iface(rdev, wdev,
+						NL80211_CMD_DEL_INTERFACE);
 			sysfs_remove_link(&dev->dev.kobj, "phy80211");
 			list_del_rcu(&wdev->list);
 			rdev->devlist_generation++;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 591c3ab..4fa7175 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2907,18 +2907,10 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 {
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
 	struct wireless_dev *wdev = info->user_ptr[1];
-	struct sk_buff *msg;
-	int status;
 
 	if (!rdev->ops->del_virtual_intf)
 		return -EOPNOTSUPP;
 
-	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
-	if (msg && nl80211_send_iface(msg, 0, 0, 0, rdev, wdev, true) < 0) {
-		nlmsg_free(msg);
-		msg = NULL;
-	}
-
 	/*
 	 * If we remove a wireless device without a netdev then clear
 	 * user_ptr[1] so that nl80211_post_doit won't dereference it
@@ -2929,15 +2921,7 @@ static int nl80211_del_interface(struct sk_buff *skb, struct genl_info *info)
 	if (!wdev->netdev)
 		info->user_ptr[1] = NULL;
 
-	status = rdev_del_virtual_intf(rdev, wdev);
-	if (status >= 0 && msg)
-		genlmsg_multicast_netns(&nl80211_fam, wiphy_net(&rdev->wiphy),
-					msg, 0, NL80211_MCGRP_CONFIG,
-					GFP_KERNEL);
-	else
-		nlmsg_free(msg);
-
-	return status;
+	return rdev_del_virtual_intf(rdev, wdev);
 }
 
 static int nl80211_set_noack_map(struct sk_buff *skb, struct genl_info *info)
-- 
2.7.3

