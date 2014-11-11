Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:11592 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751018AbaKKO1n (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 09:27:43 -0500
From: Jukka Rissanen <jukka.rissanen@linux.intel.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] nl80211: Stop scheduled scan if netlink client disappears
Date: Tue, 11 Nov 2014 16:27:39 +0200
Message-Id: <1415716059-608-1-git-send-email-jukka.rissanen@linux.intel.com> (sfid-20141111_152746_888050_18874AA2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A new attribute NL80211_ATTR_SCAN_SOCKET_OWNER can be set by the
scan initiator. If present, the attribute will cause the scan to
be stopped if the client dies.

Signed-off-by: Jukka Rissanen <jukka.rissanen@linux.intel.com>
---
 include/net/cfg80211.h       |  2 ++
 include/uapi/linux/nl80211.h |  8 ++++++++
 net/wireless/nl80211.c       | 35 +++++++++++++++++++++++++++++++++++
 3 files changed, 45 insertions(+)

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
index 442369f..2731a04 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -1669,6 +1669,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_SMPS_MODE: SMPS mode to use (ap mode). see
  *	&enum nl80211_smps_mode.
  *
+ * @NL80211_ATTR_SCAN_SOCKET_OWNER: flag attribute, if set during scheduled
+ *	scan start then the new scan req will be owned by the netlink socket
+ *	that created it and the pending scan will be stopped when the socket
+ *	is closed.
+ *
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
  */
@@ -2021,6 +2026,8 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_SMPS_MODE,
 
+	NL80211_ATTR_SCAN_SOCKET_OWNER,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
@@ -2056,6 +2063,7 @@ enum nl80211_attrs {
 #define NL80211_ATTR_KEY NL80211_ATTR_KEY
 #define NL80211_ATTR_KEYS NL80211_ATTR_KEYS
 #define NL80211_ATTR_FEATURE_FLAGS NL80211_ATTR_FEATURE_FLAGS
+#define NL80211_ATTR_SCAN_SOCKET_OWNER NL80211_ATTR_SCAN_SOCKET_OWNER
 
 #define NL80211_MAX_SUPP_RATES			32
 #define NL80211_MAX_SUPP_HT_RATES		77
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d0a8361..653f649 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -395,6 +395,7 @@ static const struct nla_policy nl80211_policy[NL80211_ATTR_MAX+1] = {
 	[NL80211_ATTR_USER_PRIO] = { .type = NLA_U8 },
 	[NL80211_ATTR_ADMITTED_TIME] = { .type = NLA_U16 },
 	[NL80211_ATTR_SMPS_MODE] = { .type = NLA_U8 },
+	[NL80211_ATTR_SCAN_SOCKET_OWNER] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -5681,6 +5682,21 @@ static int nl80211_trigger_scan(struct sk_buff *skb, struct genl_info *info)
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
@@ -5955,6 +5971,13 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 
 	err = rdev_sched_scan_start(rdev, dev, request);
 	if (!err) {
+		if (info->attrs[NL80211_ATTR_SCAN_SOCKET_OWNER]) {
+			INIT_WORK(&request->sched_scan_stop_wk,
+				  nl80211_sched_scan_stop_wk);
+
+			request->owner_nlportid = info->snd_portid;
+		}
+
 		rdev->sched_scan_req = request;
 		nl80211_send_sched_scan(rdev, dev,
 					NL80211_CMD_START_SCHED_SCAN);
@@ -12127,6 +12150,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 
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
@@ -12157,6 +12186,12 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
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

