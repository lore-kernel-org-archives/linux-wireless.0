Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:60814 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752873AbaKLMJE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Nov 2014 07:09:04 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v3 2/2] nl80211: Stop scheduled scan if netlink client disappears
Date: Wed, 12 Nov 2014 14:08:59 +0200
Message-Id: <1415794139-7124-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141112_130909_519151_DCCF3FB0)
In-Reply-To: <1415794139-7124-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1415794139-7124-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An attribute NL80211_ATTR_SOCKET_OWNER can be set by the scan initiator.
If present, the attribute will cause the scan to be stopped if the client
dies.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/core.c          | 10 +++++++++-
 net/wireless/nl80211.c       | 34 ++++++++++++++++++++++++++++++++++
 4 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 220d5f5..84378bf 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1512,6 +1512,8 @@ struct cfg80211_sched_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	unsigned long scan_start;
+	u32 owner_nlportid;
+	struct work_struct sched_scan_stop_wk;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 185f9c7..5038240 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1640,6 +1640,9 @@ enum nl80211_commands {
  * @NL80211_ATTR_SOCKET_OWNER: Flag attribute, if set during interface
  *	creation then the new interface will be owned by the netlink socket
  *	that created it and will be destroyed when the socket is closed.
+ *	If set during scheduled scan start then the new scan req will be
+ *	owned by the netlink socket that created it and the scheduled scan will
+ *	be stopped when the socket is closed.
  *
  * @NL80211_ATTR_TDLS_INITIATOR: flag attribute indicating the current end is
  *	the TDLS link initiator.
diff --git a/net/wireless/core.c b/net/wireless/core.c
index a4d2792..88898d9 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -840,6 +840,8 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
+	struct cfg80211_sched_scan_request *sched_scan_req =
+		rdev->sched_scan_req;
 
 	ASSERT_RTNL();
 	ASSERT_WDEV_LOCK(wdev);
@@ -850,8 +852,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
+		if (sched_scan_req && dev == sched_scan_req->dev) {
+			cancel_work_sync(&sched_scan_req->sched_scan_stop_wk);
 			__cfg80211_stop_sched_scan(rdev, false);
+		}
 
 #ifdef CONFIG_CFG80211_WEXT
 		kfree(wdev->wext.ie);
@@ -991,6 +995,10 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 
 		if (WARN_ON(rdev->sched_scan_req &&
 			    rdev->sched_scan_req->dev == wdev->netdev)) {
+			struct cfg80211_sched_scan_request *sched_scan_req =
+				rdev->sched_scan_req;
+
+			cancel_work_sync(&sched_scan_req->sched_scan_stop_wk);
 			__cfg80211_stop_sched_scan(rdev, false);
 		}
 
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df447c0..8fc500d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5681,6 +5681,21 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+static void nl80211_sched_scan_stop_wk(struct work_struct *work)
+{
+	struct cfg80211_sched_scan_request *req;
+	struct cfg80211_registered_device *rdev;
+
+	req = container_of(work, struct cfg80211_sched_scan_request,
+			   sched_scan_stop_wk);
+
+	rdev = wiphy_to_rdev(req->wiphy);
+
+	rtnl_lock();
+	__cfg80211_stop_sched_scan(rdev, false);
+	rtnl_unlock();
+}
+
 static int nl80211_start_sched_scan(struct sk_buff *skb,
 				    struct genl_info *info)
 {
@@ -5955,6 +5970,13 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	err = rdev_sched_scan_start(rdev, dev, request);
 	if (!err) {
+		if (info->attrs[NL80211_ATTR_SOCKET_OWNER]) {
+			INIT_WORK(&request->sched_scan_stop_wk,
+				  nl80211_sched_scan_stop_wk);
+
+			request->owner_nlportid = info->snd_portid;
+		}
+
 		rdev->sched_scan_req = request;
 		nl80211_send_sched_scan(rdev, dev,
 					NL80211_CMD_START_SCHED_SCAN);
@@ -12127,6 +12149,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
 		bool schedule_destroy_work = false;
+		bool schedule_scan_stop = false;
+		struct cfg80211_sched_scan_request *req = rdev->sched_scan_req;
+
+		if (req && req->owner_nlportid == notify->portid &&
+		    notify->portid)
+			schedule_scan_stop = true;
 
 		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list) {
 			cfg80211_mlme_unregister_socket(wdev, notify->portid);
@@ -12157,6 +12185,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				spin_unlock(&rdev->destroy_list_lock);
 				schedule_work(&rdev->destroy_work);
 			}
+		} else if (schedule_scan_stop) {
+			req->owner_nlportid = 0;
+
+			if (rdev->ops->sched_scan_stop &&
+			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+				schedule_work(&req->sched_scan_stop_wk);
 		}
 	}
 
-- 
1.8.3.1

