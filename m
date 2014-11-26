Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:45570 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750809AbaKZJH1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 04:07:27 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH v7] nl80211: Stop scheduled scan if netlink client disappears
Date: Wed, 26 Nov 2014 11:07:21 +0200
Message-Id: <1416992841-15728-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141126_100742_107746_BD7B37FA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

An attribute NL80211_ATTR_SOCKET_OWNER can be set by the scan initiator.
If present, the attribute will cause the scan to be stopped if the client
dies.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
Hi,

v7:
- convert the cfg80211_sched_scan_request to __rcu pointer in order
  to avoid races when accessing it
- reverting the patch v6, the port id is back in request struct

v6:
- moved owner netlink port id from cfg80211_sched_scan_request to
  rdev in order to avoid possible races

v5:
- discarded the locking changes in v4
- instead of trying to schedule sched_scan_stop worker from
  struct cfg80211_sched_scan_request, move the worker to wiphy
  as that makes it easier to manage the sched_scan_stop worker.
  There are also one scheduled scan / wiphy so it is also logical
  to do it like this.

v4:
- rtnl locking issues fixed in patch 2

v3:
- backward compatibility define tweaked in patch 1
- added missing signed-off-by:

v2:
- split the patch
- In patch 1, use a generic NL80211_ATTR_SOCKET_OWNER attribute and
  convert the old code that uses NL80211_ATTR_IFACE_SOCKET_OWNER to
  use the new value. A define is provided for backward compatibility.
- Any pending schedule scan stop worker is cancelled when interface is
  taken down in patch 2

Cheers,
Jukka


 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  3 +++
 net/wireless/core.c          | 28 +++++++++++++++++++++++++---
 net/wireless/core.h          |  4 +++-
 net/wireless/nl80211.c       | 40 +++++++++++++++++++++++++++++++++-------
 net/wireless/scan.c          | 27 +++++++++++++++++++++------
 6 files changed, 87 insertions(+), 17 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index bb748c4..0e540fc 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1537,6 +1537,8 @@ struct cfg80211_sched_scan_request {
 	struct wiphy *wiphy;
 	struct net_device *dev;
 	unsigned long scan_start;
+	u32 owner_nlportid;
+	struct rcu_head rcu_head;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index d775245..a0e3b32 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1655,6 +1655,9 @@ enum nl80211_commands {
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
index 4c2e501..368e276 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -320,6 +320,20 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
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
+	__cfg80211_stop_sched_scan(rdev, false);
+
+	rtnl_unlock();
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
@@ -406,6 +420,7 @@ use_default_name:
 	INIT_LIST_HEAD(&rdev->destroy_list);
 	spin_lock_init(&rdev->destroy_list_lock);
 	INIT_WORK(&rdev->destroy_work, cfg80211_destroy_iface_wk);
+	INIT_WORK(&rdev->sched_scan_stop_wk, cfg80211_sched_scan_stop_wk);
 
 #ifdef CONFIG_CFG80211_DEFAULT_PS
 	rdev->wiphy.flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT;
@@ -764,6 +779,7 @@ void wiphy_unregister(struct wiphy *wiphy)
 	flush_work(&rdev->event_work);
 	cancel_delayed_work_sync(&rdev->dfs_update_channels_wk);
 	flush_work(&rdev->destroy_work);
+	flush_work(&rdev->sched_scan_stop_wk);
 
 #ifdef CONFIG_PM
 	if (rdev->wiphy.wowlan_config && rdev->ops->set_wakeup)
@@ -854,8 +870,11 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		if (rdev->sched_scan_req && dev == rdev->sched_scan_req->dev)
+		rcu_read_lock();
+		if (rcu_access_pointer(rdev->sched_scan_req) &&
+		    dev == rtnl_dereference(rdev->sched_scan_req)->dev)
 			__cfg80211_stop_sched_scan(rdev, false);
+		rcu_read_unlock();
 
 #ifdef CONFIG_CFG80211_WEXT
 		kfree(wdev->wext.ie);
@@ -993,10 +1012,13 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			___cfg80211_scan_done(rdev, false);
 		}
 
-		if (WARN_ON(rdev->sched_scan_req &&
-			    rdev->sched_scan_req->dev == wdev->netdev)) {
+		rcu_read_lock();
+		if (WARN_ON(rcu_access_pointer(rdev->sched_scan_req) &&
+			    rtnl_dereference(rdev->sched_scan_req)->dev ==
+				wdev->netdev)) {
 			__cfg80211_stop_sched_scan(rdev, false);
 		}
+		rcu_read_unlock();
 
 		rdev->opencount--;
 		wake_up(&rdev->dev_wait);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index faa5b16..4e3630b 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -63,7 +63,7 @@ struct cfg80211_registered_device {
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	struct sk_buff *scan_msg;
-	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
 	struct work_struct sched_scan_results_wk;
@@ -84,6 +84,8 @@ struct cfg80211_registered_device {
 	struct list_head destroy_list;
 	struct work_struct destroy_work;
 
+	struct work_struct sched_scan_stop_wk;
+
 	/* must be last because of the way we do wiphy_priv(),
 	 * and it should at least be aligned to NETDEV_ALIGN */
 	struct wiphy wiphy __aligned(NETDEV_ALIGN);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 6e41777..11ed9df 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -6077,27 +6077,40 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (rdev->sched_scan_req)
 		return -EINPROGRESS;
 
-	rdev->sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
-							info->attrs);
+	rcu_assign_pointer(rdev->sched_scan_req,
+			   nl80211_parse_sched_scan(&rdev->wiphy, wdev,
+						    info->attrs));
+	synchronize_rcu();
+
 	err = PTR_ERR_OR_ZERO(rdev->sched_scan_req);
 	if (err)
 		goto out_err;
 
-	err = rdev_sched_scan_start(rdev, dev, rdev->sched_scan_req);
+	err = rdev_sched_scan_start(rdev, dev,
+				    rcu_access_pointer(rdev->sched_scan_req));
 	if (err)
 		goto out_free;
 
-	rdev->sched_scan_req->dev = dev;
-	rdev->sched_scan_req->wiphy = &rdev->wiphy;
+	rcu_read_lock();
+
+	if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
+		rtnl_dereference(rdev->sched_scan_req)->owner_nlportid =
+			info->snd_portid;
+
+	rtnl_dereference(rdev->sched_scan_req)->dev = dev;
+	rtnl_dereference(rdev->sched_scan_req)->wiphy = &rdev->wiphy;
+
+	rcu_read_unlock();
 
 	nl80211_send_sched_scan(rdev, dev,
 				NL80211_CMD_START_SCHED_SCAN);
 	return 0;
 
 out_free:
-	kfree(rdev->sched_scan_req);
+	kfree_rcu(rcu_access_pointer(rdev->sched_scan_req), rcu_head);
 out_err:
-	rdev->sched_scan_req = NULL;
+	rcu_assign_pointer(rdev->sched_scan_req, NULL);
+	synchronize_rcu();
 	return err;
 }
 
@@ -12475,6 +12488,13 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
 	list_for_each_entry_rcu(rdev, &cfg80211_rdev_list, list) {
 		bool schedule_destroy_work = false;
+		bool schedule_scan_stop = false;
+		struct cfg80211_sched_scan_request __rcu *req =
+			rdev->sched_scan_req;
+
+		if (rcu_access_pointer(req) && notify->portid &&
+		    rcu_dereference(req)->owner_nlportid == notify->portid)
+			schedule_scan_stop = true;
 
 		list_for_each_entry_rcu(wdev, &rdev->wdev_list, list) {
 			cfg80211_mlme_unregister_socket(wdev, notify->portid);
@@ -12505,6 +12525,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				spin_unlock(&rdev->destroy_list_lock);
 				schedule_work(&rdev->destroy_work);
 			}
+		} else if (schedule_scan_stop) {
+			rcu_dereference(req)->owner_nlportid = 0;
+
+			if (rdev->ops->sched_scan_stop &&
+			    rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN)
+				schedule_work(&rdev->sched_scan_stop_wk);
 		}
 	}
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index bda39f1..782d04f 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -257,7 +257,9 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 
 	rtnl_lock();
 
-	request = rdev->sched_scan_req;
+	rcu_read_lock();
+	request = rtnl_dereference(rdev->sched_scan_req);
+	rcu_read_unlock();
 
 	/* we don't have sched_scan_req anymore if the scan is stopping */
 	if (request) {
@@ -277,9 +279,16 @@ void __cfg80211_sched_scan_results(struct work_struct *wk)
 
 void cfg80211_sched_scan_results(struct wiphy *wiphy)
 {
+	struct cfg80211_sched_scan_request *request;
+
 	trace_cfg80211_sched_scan_results(wiphy);
 	/* ignore if we're not scanning */
-	if (wiphy_to_rdev(wiphy)->sched_scan_req)
+
+	rcu_read_lock();
+	request = rcu_dereference(wiphy_to_rdev(wiphy)->sched_scan_req);
+	rcu_read_unlock();
+
+	if (request)
 		queue_work(cfg80211_wq,
 			   &wiphy_to_rdev(wiphy)->sched_scan_results_wk);
 }
@@ -309,13 +318,16 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated)
 {
 	struct net_device *dev;
+	struct cfg80211_sched_scan_request *req;
 
 	ASSERT_RTNL();
 
-	if (!rdev->sched_scan_req)
+	if (!rcu_access_pointer(rdev->sched_scan_req))
 		return -ENOENT;
 
-	dev = rdev->sched_scan_req->dev;
+	rcu_read_lock();
+	dev = rtnl_dereference(rdev->sched_scan_req)->dev;
+	rcu_read_unlock();
 
 	if (!driver_initiated) {
 		int err = rdev_sched_scan_stop(rdev, dev);
@@ -325,8 +337,11 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 
 	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
 
-	kfree(rdev->sched_scan_req);
-	rdev->sched_scan_req = NULL;
+	req = rcu_access_pointer(rdev->sched_scan_req);
+
+	rcu_assign_pointer(rdev->sched_scan_req, NULL);
+
+	kfree_rcu(req, rcu_head);
 
 	return 0;
 }
-- 
1.8.3.1

