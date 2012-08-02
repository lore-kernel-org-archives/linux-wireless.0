Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:62776 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752281Ab2HBRly (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 13:41:54 -0400
From: Daniel Drake <dsd@laptop.org>
To: linville@tuxdriver.com, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] cfg80211: process pending events when unregistering net device
Message-Id: <20120802174148.536A39D401E@zog.reactivated.net> (sfid-20120802_194157_794748_B5CEE72E)
Date: Thu,  2 Aug 2012 18:41:48 +0100 (BST)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

libertas currently calls cfg80211_disconnected() when it is being
brought down. This causes an event to be allocated, but since the
wdev is already removed from the rdev by the time that the event
processing work executes, the event is never processed or freed.
http://article.gmane.org/gmane.linux.kernel.wireless.general/95666

Fix this leak, and other possible situations, by processing the event
queue when a device is being unregistered. Thanks to Johannes Berg for
the suggestion.

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 net/wireless/core.c | 5 +++++
 net/wireless/core.h | 1 +
 net/wireless/util.c | 2 +-
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 31b40cc..dcd64d5 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -952,6 +952,11 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		 */
 		synchronize_rcu();
 		INIT_LIST_HEAD(&wdev->list);
+		/*
+		 * Ensure that all events have been processed and
+		 * freed.
+		 */
+		cfg80211_process_wdev_events(wdev);
 		break;
 	case NETDEV_PRE_UP:
 		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 5206c68..bc7430b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -426,6 +426,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
 			  u32 *flags, struct vif_params *params);
 void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
+void cfg80211_process_wdev_events(struct wireless_dev *wdev);
 
 int cfg80211_can_use_iftype_chan(struct cfg80211_registered_device *rdev,
 				 struct wireless_dev *wdev,
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 26f8cd3..994e2f0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -735,7 +735,7 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 	wdev->connect_keys = NULL;
 }
 
-static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
+void cfg80211_process_wdev_events(struct wireless_dev *wdev)
 {
 	struct cfg80211_event *ev;
 	unsigned long flags;
-- 
1.7.11.2

