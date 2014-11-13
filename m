Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:14229 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbaKMP3s (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Nov 2014 10:29:48 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v5 2/2] nl80211: Stop scheduled scan if netlink client disappears
Date: Thu, 13 Nov 2014 17:25:15 +0200
Message-Id: <1415892315-2911-3-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141113_162954_070889_EBEB661D)
In-Reply-To: <1415892315-2911-1-git-send-email-jukka.rissanen@linux.intel.com>
References: <1415892315-2911-1-git-send-email-jukka.rissanen@linux.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An attribute NL80211_ATTR_SOCKET_OWNER can be set by the scan initiator.
If present, the attribute will cause the scan to be stopped if the client
dies.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 include/net/cfg80211.h       |  1 +
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/core.c          | 17 +++++++++++++++++
 net/wireless/core.h          |  2 ++
 net/wireless/nl80211.c       | 15 +++++++++++++++
 5 files changed, 38 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 220d5f5..6fa764a 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1512,6 +1512,7 @@ struct cfg80211_sched_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	unsigned long scan_start;
+	u32 owner_nlportid;
 
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
index a4d2792..6fffcb3 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -320,6 +320,21 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
 	rtnl_unlock();
 }
 
+static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+
+	rdev = container_of(work, struct cfg80211_registered_device,
+			   sched_scan_stop_wk);
+
+	rtnl_lock();
+
+	if (rdev->sched_scan_req)
+		__cfg80211_stop_sched_scan(rdev, false);
+
+	rtnl_unlock();
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
@@ -406,6 +421,7 @@ use_default_name:
 	INIT_LIST_HEAD(&rdev->destroy_list);
 	spin_lock_init(&rdev->destroy_list_lock);
 	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
+	INIT_WORK(&rdev->sched_scan_stop_wk, cfg80211_sched_scan_stop_wk);
 
 #ifdef CONFIG_CFG80211_DEFAULT_PS
 	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -760,6 +776,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 	flush_work(&rdev->destroy_work);
+	flush_work(&rdev->sched_scan_stop_wk);
 
 #ifdef CONFIG_PM
 	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 61ee664..1bdffac 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -84,6 +84,8 @@ struct cfg80211_registered_device {
 	struct list_head destroy_list;
 	struct work_struct destroy_work;
 
+	struct work_struct sched_scan_stop_wk;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index df447c0..8ab3610 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -5955,6 +5955,9 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	err = rdev_sched_scan_start(rdev, dev, request);
 	if (!err) {
+		if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
+			request->owner_nlportid = info->snd_portid;
+
 		rdev->sched_scan_req = request;
 		nl80211_send_sched_scan(rdev, dev,
 					NL80211_CMD_START_SCHED_SCAN);
@@ -12127,6 +12130,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
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
@@ -12157,6 +12166,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				spin_unlock(&rdev->destroy_list_lock);
 				schedule_work(&rdev->destroy_work);
 			}
+		} else if (schedule_scan_stop) {
+			req->owner_nlportid = 0;
+
+			if (rdev->ops->sched_scan_stop &&
+			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+				schedule_work(&rdev->sched_scan_stop_wk);
 		}
 	}
 
-- 
1.8.3.1

