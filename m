Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lpdvsmtp01.broadcom.com ([192.19.211.62]:60079 "EHLO
        relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751706AbdAMMr5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:47:57 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [RFC 1/5] nl80211: allow multiple active scheduled scan requests
Date: Fri, 13 Jan 2017 12:47:40 +0000
Message-Id: <1484311664-4840-2-git-send-email-arend.vanspriel@broadcom.com> (sfid-20170113_134858_991580_E744B1B2)
In-Reply-To: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1484311664-4840-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch implements the idea to have multiple scheduled scan requests
running concurrently. It mainly illustrates how to deal with the incoming
request from user-space in terms of backward compatibility. In order to
use multiple scheduled scans user-space needs to provide a flag attribute
NL80211_ATTR_SCHED_SCAN_MULTI to indicate support. If not the request is
treated as a legacy scan.

Reviewed-by: Hante Meuleman <hante.meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieter-paul.giesberts@broadcom.com>
Reviewed-by: Franky Lin <franky.lin@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 include/net/cfg80211.h       |  7 ++++
 include/uapi/linux/nl80211.h | 12 +++++-
 net/wireless/core.c          | 30 +++++++++-----
 net/wireless/core.h          | 10 ++++-
 net/wireless/nl80211.c       | 37 +++++++++++++++--
 net/wireless/rdev-ops.h      |  2 +-
 net/wireless/scan.c          | 96 ++++++++++++++++++++++++++++++++++++--------
 net/wireless/trace.h         | 18 ++++++---
 8 files changed, 173 insertions(+), 39 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index cb13789..4c77c82 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1622,6 +1622,7 @@ struct cfg80211_sched_scan_plan {
 /**
  * struct cfg80211_sched_scan_request - scheduled scan request description
  *
+ * @reqid: identifies this request.
  * @ssids: SSIDs to scan for (passed in the probe_reqs in active scans)
  * @n_ssids: number of SSIDs
  * @n_channels: total number of channels to scan
@@ -1650,12 +1651,14 @@ struct cfg80211_sched_scan_plan {
  * @rcu_head: RCU callback used to free the struct
  * @owner_nlportid: netlink portid of owner (if this should is a request
  *	owned by a particular socket)
+ * @list: for keeping list of requests.
  * @delay: delay in seconds to use before starting the first scan
  *	cycle.  The driver may ignore this parameter and start
  *	immediately (or at any other time), if this feature is not
  *	supported.
  */
 struct cfg80211_sched_scan_request {
+	u64 reqid;
 	struct cfg80211_ssid *ssids;
 	int n_ssids;
 	u32 n_channels;
@@ -1679,6 +1682,7 @@ struct cfg80211_sched_scan_request {
 	unsigned long scan_start;
 	struct rcu_head rcu_head;
 	u32 owner_nlportid;
+	struct list_head list;
 
 	/* keep last */
 	struct ieee80211_channel *channels[0];
@@ -3443,6 +3447,8 @@ struct wiphy_iftype_ext_capab {
  *	this variable determines its size
  * @max_scan_ssids: maximum number of SSIDs the device can scan for in
  *	any given scan
+ * @max_sched_scan_reqs: maximum number of scheduled scan requests that
+ *	the device can run concurrently.
  * @max_sched_scan_ssids: maximum number of SSIDs the device can scan
  *	for in any given scheduled scan
  * @max_match_sets: maximum number of match sets the device can handle
@@ -3575,6 +3581,7 @@ struct wiphy {
 
 	int bss_priv_size;
 	u8 max_scan_ssids;
+	u8 max_sched_scan_reqs;
 	u8 max_sched_scan_ssids;
 	u8 max_match_sets;
 	u16 max_scan_ie_len;
diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 174f4b3..70dc5a6 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -351,7 +351,9 @@
  *	are used.  Extra IEs can also be passed from the userspace by
  *	using the %NL80211_ATTR_IE attribute.  The first cycle of the
  *	scheduled scan can be delayed by %NL80211_ATTR_SCHED_SCAN_DELAY
- *	is supplied.
+ *	is supplied. If the device supports multiple concurrent scheduled
+ *	scans, it will allow such when the caller provides the flag attribute
+ *	%NL80211_ATTR_SCHED_SCAN_MULTI to indicate user-space support for it.
  * @NL80211_CMD_STOP_SCHED_SCAN: stop a scheduled scan. Returns -ENOENT if
  *	scheduled scan is not running. The caller may assume that as soon
  *	as the call returns, it is safe to start a new scheduled scan again.
@@ -1982,6 +1984,11 @@ enum nl80211_commands {
  * @NL80211_ATTR_BSSID: The BSSID of the AP. Note that %NL80211_ATTR_MAC is also
  *	used in various commands/events for specifying the BSSID.
  *
+ * @NL80211_ATTR_SCHED_SCAN_MULTI: flag attribute which user-space shall use to
+ *	indicate that it supports multiple active scheduled scan requests.
+ * @NL80211_ATTR_SCHED_SCAN_MAX_REQS: indicates maximum number of scheduled
+ *	scan request that may be active for the device (u8).
+ *
  * @NUM_NL80211_ATTR: total number of nl80211_attrs available
  * @NL80211_ATTR_MAX: highest attribute number currently defined
  * @__NL80211_ATTR_AFTER_LAST: internal use
@@ -2388,6 +2395,9 @@ enum nl80211_attrs {
 
 	NL80211_ATTR_BSSID,
 
+	NL80211_ATTR_SCHED_SCAN_MULTI,
+	NL80211_ATTR_SCHED_SCAN_MAX_REQS,
+
 	/* add attributes here, update the policy in nl80211.c */
 
 	__NL80211_ATTR_AFTER_LAST,
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 903fc419..1f91e85 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -346,13 +346,17 @@ static void cfg80211_destroy_iface_wk(struct work_struct *work)
 static void cfg80211_sched_scan_stop_wk(struct work_struct *work)
 {
 	struct cfg80211_registered_device *rdev;
+	struct cfg80211_sched_scan_request *pos, *tmp;
 
 	rdev = container_of(work, struct cfg80211_registered_device,
 			   sched_scan_stop_wk);
 
 	rtnl_lock();
 
-	__cfg80211_stop_sched_scan(rdev, false);
+	/* request gets removed from list so need safe iterator */
+	list_for_each_entry_safe(pos, tmp, &rdev->sched_scan_req_list, list) {
+		cfg80211_stop_sched_scan_req(rdev, pos, false);
+	}
 
 	rtnl_unlock();
 }
@@ -436,6 +440,7 @@ struct wiphy *wiphy_new_nm(const struct cfg80211_ops *ops, int sizeof_priv,
 	spin_lock_init(&rdev->beacon_registrations_lock);
 	spin_lock_init(&rdev->bss_lock);
 	INIT_LIST_HEAD(&rdev->bss_list);
+	INIT_LIST_HEAD(&rdev->sched_scan_req_list);
 	INIT_WORK(&rdev->scan_done_wk, __cfg80211_scan_done);
 	INIT_WORK(&rdev->sched_scan_results_wk, __cfg80211_sched_scan_results);
 	INIT_LIST_HEAD(&rdev->mlme_unreg);
@@ -690,6 +695,10 @@ int wiphy_register(struct wiphy *wiphy)
 		    (wiphy->bss_select_support & ~(BIT(__NL80211_BSS_SELECT_ATTR_AFTER_LAST) - 2))))
 		return -EINVAL;
 
+	if ((wiphy->flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) &&
+	    !wiphy->max_sched_scan_reqs)
+		wiphy->max_sched_scan_reqs = 1;
+
 	if (wiphy->addresses)
 		memcpy(wiphy->perm_addr, wiphy->addresses[0].addr, ETH_ALEN);
 
@@ -1000,7 +1009,7 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		      struct wireless_dev *wdev)
 {
 	struct net_device *dev = wdev->netdev;
-	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_sched_scan_request *pos, *tmp;
 
 	ASSERT_RTNL();
 	ASSERT_WDEV_LOCK(wdev);
@@ -1011,9 +1020,10 @@ void __cfg80211_leave(struct cfg80211_registered_device *rdev,
 		break;
 	case NL80211_IFTYPE_P2P_CLIENT:
 	case NL80211_IFTYPE_STATION:
-		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
-		if (sched_scan_req && dev == sched_scan_req->dev)
-			__cfg80211_stop_sched_scan(rdev, false);
+		list_for_each_entry_safe(pos, tmp, &rdev->sched_scan_req_list, list) {
+			if (dev == pos->dev)
+				cfg80211_stop_sched_scan_req(rdev, pos, false);
+		}
 
 #ifdef CONFIG_CFG80211_WEXT
 		kfree(wdev->wext.ie);
@@ -1088,7 +1098,7 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev;
-	struct cfg80211_sched_scan_request *sched_scan_req;
+	struct cfg80211_sched_scan_request *pos, *tmp;
 
 	if (!wdev)
 		return NOTIFY_DONE;
@@ -1157,10 +1167,10 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			___cfg80211_scan_done(rdev, false);
 		}
 
-		sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
-		if (WARN_ON(sched_scan_req &&
-			    sched_scan_req->dev == wdev->netdev)) {
-			__cfg80211_stop_sched_scan(rdev, false);
+		list_for_each_entry_safe(pos, tmp,
+					 &rdev->sched_scan_req_list, list) {
+			if (WARN_ON(pos && pos->dev == wdev->netdev))
+				cfg80211_stop_sched_scan_req(rdev, pos, false);
 		}
 
 		rdev->opencount--;
diff --git a/net/wireless/core.h b/net/wireless/core.h
index ba42055..621b67c 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -74,6 +74,7 @@ struct cfg80211_registered_device {
 	u32 bss_entries;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	struct sk_buff *scan_msg;
+	struct list_head sched_scan_req_list;
 	struct cfg80211_sched_scan_request __rcu *sched_scan_req;
 	unsigned long suspend_at;
 	struct work_struct scan_done_wk;
@@ -421,9 +422,16 @@ int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev,
 			   bool send_message);
+void cfg80211_add_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req);
+int cfg80211_sched_scan_req_possible(struct cfg80211_registered_device *rdev,
+				     bool want_multi);
 void __cfg80211_sched_scan_results(struct work_struct *wk);
+int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req,
+				 bool driver_initiated);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
-			       bool driver_initiated);
+			       u64 reqid, bool driver_initiated);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
 int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 			  struct net_device *dev, enum nl80211_iftype ntype,
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index b378d0a..4d1070a 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -405,6 +405,7 @@ enum nl80211_multicast_groups {
 	[NL80211_ATTR_FILS_NONCES] = { .len = 2 * FILS_NONCE_LEN },
 	[NL80211_ATTR_MULTICAST_TO_UNICAST_ENABLED] = { .type = NLA_FLAG, },
 	[NL80211_ATTR_BSSID] = { .len = ETH_ALEN },
+	[NL80211_ATTR_SCHED_SCAN_MULTI] = { .type = NLA_FLAG },
 };
 
 /* policy for the key attributes */
@@ -1463,6 +1464,8 @@ static int nl80211_send_wiphy(struct cfg80211_registered_device *rdev,
 			       rdev->wiphy.coverage_class) ||
 		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCAN_SSIDS,
 			       rdev->wiphy.max_scan_ssids) ||
+		    nla_put_u8(msg, NL80211_ATTR_SCHED_SCAN_MAX_REQS,
+			       rdev->wiphy.max_sched_scan_reqs) ||
 		    nla_put_u8(msg, NL80211_ATTR_MAX_NUM_SCHED_SCAN_SSIDS,
 			       rdev->wiphy.max_sched_scan_ssids) ||
 		    nla_put_u16(msg, NL80211_ATTR_MAX_SCAN_IE_LEN,
@@ -7176,14 +7179,17 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	struct net_device *dev = info->user_ptr[1];
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_sched_scan_request *sched_scan_req;
+	bool want_multi;
 	int err;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
 	    !rdev->ops->sched_scan_start)
 		return -EOPNOTSUPP;
 
-	if (rdev->sched_scan_req)
-		return -EINPROGRESS;
+	want_multi = !!info->attrs[NL80211_ATTR_SCHED_SCAN_MULTI];
+	err = cfg80211_sched_scan_req_possible(rdev, want_multi);
+	if (err)
+		return err;
 
 	sched_scan_req = nl80211_parse_sched_scan(&rdev->wiphy, wdev,
 						  info->attrs);
@@ -7192,6 +7198,14 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (err)
 		goto out_err;
 
+	/* leave request id zero for legacy request
+	 * or if driver does not support multi-scheduled scan
+	 */
+	if (want_multi && rdev->wiphy.max_sched_scan_reqs > 1) {
+		while (!sched_scan_req->reqid)
+			sched_scan_req->reqid = rdev->wiphy.cookie_counter++;
+	}
+
 	err = rdev_sched_scan_start(rdev, dev, sched_scan_req);
 	if (err)
 		goto out_free;
@@ -7202,7 +7216,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 	if (info->attrs[NL80211_ATTR_SOCKET_OWNER])
 		sched_scan_req->owner_nlportid = info->snd_portid;
 
-	rcu_assign_pointer(rdev->sched_scan_req, sched_scan_req);
+	cfg80211_add_sched_scan_req(rdev, sched_scan_req);
 
 	nl80211_send_sched_scan(rdev, dev,
 				NL80211_CMD_START_SCHED_SCAN);
@@ -7217,13 +7231,28 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
 static int nl80211_stop_sched_scan(struct sk_buff *skb,
 				   struct genl_info *info)
 {
+	struct cfg80211_sched_scan_request *req;
 	struct cfg80211_registered_device *rdev = info->user_ptr[0];
+	u64 cookie;
 
 	if (!(rdev->wiphy.flags & WIPHY_FLAG_SUPPORTS_SCHED_SCAN) ||
 	    !rdev->ops->sched_scan_stop)
 		return -EOPNOTSUPP;
 
-	return __cfg80211_stop_sched_scan(rdev, false);
+	if (info->attrs[NL80211_ATTR_COOKIE]) {
+		cookie = nla_get_u64(info->attrs[NL80211_ATTR_COOKIE]);
+		return __cfg80211_stop_sched_scan(rdev, cookie, false);
+	} else {
+		req = list_first_or_null_rcu(&rdev->sched_scan_req_list,
+					     struct cfg80211_sched_scan_request,
+					     list);
+		if (!req || req->reqid ||
+		    (req->owner_nlportid &&
+		     req->owner_nlportid != info->snd_portid))
+			return -ENOENT;
+
+		return cfg80211_stop_sched_scan_req(rdev, req, false);
+	}
 }
 
 static int nl80211_start_radar_detection(struct sk_buff *skb,
diff --git a/net/wireless/rdev-ops.h b/net/wireless/rdev-ops.h
index 2f42507..9ada5e2 100644
--- a/net/wireless/rdev-ops.h
+++ b/net/wireless/rdev-ops.h
@@ -802,7 +802,7 @@ static inline int rdev_get_antenna(struct cfg80211_registered_device *rdev,
 		      struct cfg80211_sched_scan_request *request)
 {
 	int ret;
-	trace_rdev_sched_scan_start(&rdev->wiphy, dev, request);
+	trace_rdev_sched_scan_start(&rdev->wiphy, dev, request->reqid);
 	ret = rdev->ops->sched_scan_start(&rdev->wiphy, dev, request);
 	trace_rdev_return_int(&rdev->wiphy, ret);
 	return ret;
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 21be56b..6704198 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -300,6 +300,64 @@ void cfg80211_scan_done(struct cfg80211_scan_request *request,
 }
 EXPORT_SYMBOL(cfg80211_scan_done);
 
+void cfg80211_add_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req)
+{
+	list_add_rcu(&req->list, &rdev->sched_scan_req_list);
+}
+
+static void cfg80211_del_sched_scan_req(struct cfg80211_registered_device *rdev,
+					struct cfg80211_sched_scan_request *req)
+{
+	list_del_rcu(&req->list);
+	kfree_rcu(req, rcu_head);
+}
+
+static struct cfg80211_sched_scan_request *
+cfg80211_find_sched_scan_req(struct cfg80211_registered_device *rdev, u64 reqid)
+{
+	struct cfg80211_sched_scan_request *pos;
+
+	list_for_each_entry(pos, &rdev->sched_scan_req_list, list) {
+		if (pos->reqid == reqid)
+			return pos;
+	}
+	return ERR_PTR(-ENOENT);
+}
+
+/*
+ * Determines if a scheduled scan request can be handled. When a legacy
+ * scheduled scan is running no other scheduled scan is allowed regardless
+ * whether the request is for legacy or multi-support scan. When a multi-support
+ * scheduled scan is running a request for legacy scan is not allowed. In this
+ * case a request for multi-support scan can be handled if resources are
+ * available, ie. struct wiphy::max_sched_scan_reqs limit is not yet reached.
+ */
+int cfg80211_sched_scan_req_possible(struct cfg80211_registered_device *rdev,
+				     bool want_multi)
+{
+	struct cfg80211_sched_scan_request *pos;
+	int i = 0;
+
+	list_for_each_entry(pos, &rdev->sched_scan_req_list, list) {
+		/* request id zero means legacy in progress */
+		if (!i && !pos->reqid)
+			return -EINPROGRESS;
+		i++;
+	}
+
+	if (i) {
+		/* no legacy allowed when multi request(s) are active */
+		if (!want_multi)
+			return -EINPROGRESS;
+
+		/* resource limit reached */
+		if (i == rdev->wiphy.max_sched_scan_reqs)
+			return -ENOSPC;
+	}
+	return 0;
+}
+
 void __cfg80211_sched_scan_results(struct work_struct *wk)
 {
 	struct cfg80211_registered_device *rdev;
@@ -347,7 +405,7 @@ void cfg80211_sched_scan_stopped_rtnl(struct wiphy *wiphy)
 
 	trace_cfg80211_sched_scan_stopped(wiphy);
 
-	__cfg80211_stop_sched_scan(rdev, true);
+	__cfg80211_stop_sched_scan(rdev, 0, true);
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped_rtnl);
 
@@ -359,34 +417,40 @@ void cfg80211_sched_scan_stopped(struct wiphy *wiphy)
 }
 EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 
-int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
-			       bool driver_initiated)
+int cfg80211_stop_sched_scan_req(struct cfg80211_registered_device *rdev,
+				 struct cfg80211_sched_scan_request *req,
+				 bool driver_initiated)
 {
-	struct cfg80211_sched_scan_request *sched_scan_req;
-	struct net_device *dev;
-
 	ASSERT_RTNL();
 
-	if (!rdev->sched_scan_req)
-		return -ENOENT;
-
-	sched_scan_req = rtnl_dereference(rdev->sched_scan_req);
-	dev = sched_scan_req->dev;
-
 	if (!driver_initiated) {
-		int err = rdev_sched_scan_stop(rdev, dev);
+		int err = rdev_sched_scan_stop(rdev, req->dev);
 		if (err)
 			return err;
 	}
 
-	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
+	nl80211_send_sched_scan(rdev, req->dev, NL80211_CMD_SCHED_SCAN_STOPPED);
 
-	RCU_INIT_POINTER(rdev->sched_scan_req, NULL);
-	kfree_rcu(sched_scan_req, rcu_head);
+	cfg80211_del_sched_scan_req(rdev, req);
 
 	return 0;
 }
 
+int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
+			       u64 reqid, bool driver_initiated)
+{
+	struct cfg80211_sched_scan_request *sched_scan_req;
+
+	ASSERT_RTNL();
+
+	sched_scan_req = cfg80211_find_sched_scan_req(rdev, reqid);
+	if (IS_ERR(sched_scan_req))
+		return PTR_ERR(sched_scan_req);
+
+	return cfg80211_stop_sched_scan_req(rdev, sched_scan_req,
+					    driver_initiated);
+}
+
 void cfg80211_bss_age(struct cfg80211_registered_device *rdev,
                       unsigned long age_secs)
 {
diff --git a/net/wireless/trace.h b/net/wireless/trace.h
index ea1b47e..7990c07 100644
--- a/net/wireless/trace.h
+++ b/net/wireless/trace.h
@@ -1588,20 +1588,26 @@
 	TP_ARGS(wiphy, rx, tx)
 );
 
-TRACE_EVENT(rdev_sched_scan_start,
-	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev,
-		 struct cfg80211_sched_scan_request *request),
-	TP_ARGS(wiphy, netdev, request),
+DECLARE_EVENT_CLASS(wiphy_netdev_id_evt,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u64 id),
+	TP_ARGS(wiphy, netdev, id),
 	TP_STRUCT__entry(
 		WIPHY_ENTRY
 		NETDEV_ENTRY
+		__field(u64, id)
 	),
 	TP_fast_assign(
 		WIPHY_ASSIGN;
 		NETDEV_ASSIGN;
+		__entry->id = id;
 	),
-	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT,
-		  WIPHY_PR_ARG, NETDEV_PR_ARG)
+	TP_printk(WIPHY_PR_FMT ", " NETDEV_PR_FMT ", id: %llu",
+		  WIPHY_PR_ARG, NETDEV_PR_ARG, __entry->id)
+);
+
+DEFINE_EVENT(wiphy_netdev_id_evt, rdev_sched_scan_start,
+	TP_PROTO(struct wiphy *wiphy, struct net_device *netdev, u64 id),
+	TP_ARGS(wiphy, netdev, id)
 );
 
 TRACE_EVENT(rdev_tdls_mgmt,
-- 
1.9.1
