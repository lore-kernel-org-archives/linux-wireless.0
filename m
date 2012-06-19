Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:52373 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab2FSOvD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 10:51:03 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [RFC 09/17] nl80211: don't assume wdev->netdev exists
Date: Tue, 19 Jun 2012 16:50:48 +0200
Message-Id: <1340117456-10154-10-git-send-email-johannes@sipsolutions.net> (sfid-20120619_165111_209939_0BBDF409)
In-Reply-To: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
References: <1340117456-10154-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

There are a few places that iterate the wdev
list and assume wdev->netdev exists, check
there. The rfkill one has to be extended for
each non-netdev type later.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 280e54d..458de46 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -177,6 +177,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 		return -EOPNOTSUPP;
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list) {
+		if (!wdev->netdev)
+			continue;
 		wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 		err = dev_change_net_namespace(wdev->netdev, net, "wlan%d");
 		if (err)
@@ -190,6 +192,8 @@ int cfg80211_switch_netns(struct cfg80211_registered_device *rdev,
 
 		list_for_each_entry_continue_reverse(wdev, &rdev->wdev_list,
 						     list) {
+			if (!wdev->netdev)
+				continue;
 			wdev->netdev->features &= ~NETIF_F_NETNS_LOCAL;
 			err = dev_change_net_namespace(wdev->netdev, net,
 							"wlan%d");
@@ -227,7 +231,8 @@ static int cfg80211_rfkill_set_block(void *data, bool blocked)
 	mutex_lock(&rdev->devlist_mtx);
 
 	list_for_each_entry(wdev, &rdev->wdev_list, list)
-		dev_close(wdev->netdev);
+		if (wdev->netdev)
+			dev_close(wdev->netdev);
 
 	mutex_unlock(&rdev->devlist_mtx);
 	rtnl_unlock();
-- 
1.7.10

