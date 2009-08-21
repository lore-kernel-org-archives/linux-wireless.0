Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:47459 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755353AbZHUKjT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Aug 2009 06:39:19 -0400
Subject: [PATCH] cfg80211: clean up properly on interface type change
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 21 Aug 2009 12:39:17 +0200
Message-Id: <1250851157.14573.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When the interface type changes while connected, and the
driver does not require the interface to be down for a
type change, it is currently possible to get very strange
results unless the driver takes special care, which it
shouldn't have to.

To fix this, take care to disconnect/leave IBSS when
changing the interface type -- even if the driver may fail
the call. Also process all events that may be pending to
avoid running into a situation where an event is reported
but only processed after the type has already changed,
which would lead to missing events and warnings.

A side effect of this is that you will have disconnected
or left the IBSS even if the mode change ultimately fails,
but since the intention was to change it and thus leave or
disconnect, this is not a problem.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c        |   53 ----------------------
 net/wireless/core.h        |    4 +
 net/wireless/nl80211.c     |   16 ------
 net/wireless/util.c        |  105 +++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/wext-compat.c |   16 +-----
 5 files changed, 114 insertions(+), 80 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-08-21 12:12:03.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-08-21 12:23:54.000000000 +0200
@@ -293,68 +293,17 @@ static void cfg80211_rfkill_sync_work(st
 	cfg80211_rfkill_set_block(rdev, rfkill_blocked(rdev->rfkill));
 }
 
-static void cfg80211_process_events(struct wireless_dev *wdev)
-{
-	struct cfg80211_event *ev;
-	unsigned long flags;
-
-	spin_lock_irqsave(&wdev->event_lock, flags);
-	while (!list_empty(&wdev->event_list)) {
-		ev = list_first_entry(&wdev->event_list,
-				      struct cfg80211_event, list);
-		list_del(&ev->list);
-		spin_unlock_irqrestore(&wdev->event_lock, flags);
-
-		wdev_lock(wdev);
-		switch (ev->type) {
-		case EVENT_CONNECT_RESULT:
-			__cfg80211_connect_result(
-				wdev->netdev, ev->cr.bssid,
-				ev->cr.req_ie, ev->cr.req_ie_len,
-				ev->cr.resp_ie, ev->cr.resp_ie_len,
-				ev->cr.status,
-				ev->cr.status == WLAN_STATUS_SUCCESS,
-				NULL);
-			break;
-		case EVENT_ROAMED:
-			__cfg80211_roamed(wdev, ev->rm.bssid,
-					  ev->rm.req_ie, ev->rm.req_ie_len,
-					  ev->rm.resp_ie, ev->rm.resp_ie_len);
-			break;
-		case EVENT_DISCONNECTED:
-			__cfg80211_disconnected(wdev->netdev,
-						ev->dc.ie, ev->dc.ie_len,
-						ev->dc.reason, true);
-			break;
-		case EVENT_IBSS_JOINED:
-			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid);
-			break;
-		}
-		wdev_unlock(wdev);
-
-		kfree(ev);
-
-		spin_lock_irqsave(&wdev->event_lock, flags);
-	}
-	spin_unlock_irqrestore(&wdev->event_lock, flags);
-}
-
 static void cfg80211_event_work(struct work_struct *work)
 {
 	struct cfg80211_registered_device *rdev;
-	struct wireless_dev *wdev;
 
 	rdev = container_of(work, struct cfg80211_registered_device,
 			    event_work);
 
 	rtnl_lock();
 	cfg80211_lock_rdev(rdev);
-	mutex_lock(&rdev->devlist_mtx);
 
-	list_for_each_entry(wdev, &rdev->netdev_list, list)
-		cfg80211_process_events(wdev);
-
-	mutex_unlock(&rdev->devlist_mtx);
+	cfg80211_process_rdev_events(rdev);
 	cfg80211_unlock_rdev(rdev);
 	rtnl_unlock();
 }
--- wireless-testing.orig/net/wireless/core.h	2009-08-21 12:17:02.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-21 12:23:54.000000000 +0200
@@ -372,6 +372,10 @@ void cfg80211_sme_disassoc(struct net_de
 void __cfg80211_scan_done(struct work_struct *wk);
 void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak);
 void cfg80211_upload_connect_keys(struct wireless_dev *wdev);
+int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, enum nl80211_iftype ntype,
+			  u32 *flags, struct vif_params *params);
+void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev);
 
 struct ieee80211_channel *
 rdev_fixed_channel(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/nl80211.c	2009-08-21 12:12:03.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-08-21 12:23:54.000000000 +0200
@@ -977,12 +977,6 @@ static int nl80211_set_interface(struct 
 		}
 	}
 
-	if (!rdev->ops->change_virtual_intf ||
-	    !(rdev->wiphy.interface_modes & (1 << ntype))) {
-		err = -EOPNOTSUPP;
-		goto unlock;
-	}
-
 	if (info->attrs[NL80211_ATTR_MESH_ID]) {
 		if (ntype != NL80211_IFTYPE_MESH_POINT) {
 			err = -EINVAL;
@@ -1008,18 +1002,10 @@ static int nl80211_set_interface(struct 
 	}
 
 	if (change)
-		err = rdev->ops->change_virtual_intf(&rdev->wiphy, dev,
-						    ntype, flags, &params);
+		err = cfg80211_change_iface(rdev, dev, ntype, flags, &params);
 	else
 		err = 0;
 
-	WARN_ON(!err && dev->ieee80211_ptr->iftype != ntype);
-
-	if (!err && (ntype != otype)) {
-		if (otype == NL80211_IFTYPE_ADHOC)
-			cfg80211_clear_ibss(dev, false);
-	}
-
  unlock:
 	dev_put(dev);
 	cfg80211_unlock_rdev(rdev);
--- wireless-testing.orig/net/wireless/util.c	2009-08-21 12:12:03.000000000 +0200
+++ wireless-testing/net/wireless/util.c	2009-08-21 12:23:54.000000000 +0200
@@ -574,3 +574,108 @@ void cfg80211_upload_connect_keys(struct
 	kfree(wdev->connect_keys);
 	wdev->connect_keys = NULL;
 }
+
+static void cfg80211_process_wdev_events(struct wireless_dev *wdev)
+{
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	while (!list_empty(&wdev->event_list)) {
+		ev = list_first_entry(&wdev->event_list,
+				      struct cfg80211_event, list);
+		list_del(&ev->list);
+		spin_unlock_irqrestore(&wdev->event_lock, flags);
+
+		wdev_lock(wdev);
+		switch (ev->type) {
+		case EVENT_CONNECT_RESULT:
+			__cfg80211_connect_result(
+				wdev->netdev, ev->cr.bssid,
+				ev->cr.req_ie, ev->cr.req_ie_len,
+				ev->cr.resp_ie, ev->cr.resp_ie_len,
+				ev->cr.status,
+				ev->cr.status == WLAN_STATUS_SUCCESS,
+				NULL);
+			break;
+		case EVENT_ROAMED:
+			__cfg80211_roamed(wdev, ev->rm.bssid,
+					  ev->rm.req_ie, ev->rm.req_ie_len,
+					  ev->rm.resp_ie, ev->rm.resp_ie_len);
+			break;
+		case EVENT_DISCONNECTED:
+			__cfg80211_disconnected(wdev->netdev,
+						ev->dc.ie, ev->dc.ie_len,
+						ev->dc.reason, true);
+			break;
+		case EVENT_IBSS_JOINED:
+			__cfg80211_ibss_joined(wdev->netdev, ev->ij.bssid);
+			break;
+		}
+		wdev_unlock(wdev);
+
+		kfree(ev);
+
+		spin_lock_irqsave(&wdev->event_lock, flags);
+	}
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+}
+
+void cfg80211_process_rdev_events(struct cfg80211_registered_device *rdev)
+{
+	struct wireless_dev *wdev;
+
+	ASSERT_RTNL();
+	ASSERT_RDEV_LOCK(rdev);
+
+	mutex_lock(&rdev->devlist_mtx);
+
+	list_for_each_entry(wdev, &rdev->netdev_list, list)
+		cfg80211_process_wdev_events(wdev);
+
+	mutex_unlock(&rdev->devlist_mtx);
+}
+
+int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, enum nl80211_iftype ntype,
+			  u32 *flags, struct vif_params *params)
+{
+	int err;
+	enum nl80211_iftype otype = dev->ieee80211_ptr->iftype;
+
+	ASSERT_RDEV_LOCK(rdev);
+
+	/* don't support changing VLANs, you just re-create them */
+	if (otype == NL80211_IFTYPE_AP_VLAN)
+		return -EOPNOTSUPP;
+
+	if (!rdev->ops->change_virtual_intf ||
+	    !(rdev->wiphy.interface_modes & (1 << ntype)))
+		return -EOPNOTSUPP;
+
+	if (ntype != otype) {
+		switch (otype) {
+		case NL80211_IFTYPE_ADHOC:
+			cfg80211_leave_ibss(rdev, dev, false);
+			break;
+		case NL80211_IFTYPE_STATION:
+			cfg80211_disconnect(rdev, dev,
+					    WLAN_REASON_DEAUTH_LEAVING, true);
+			break;
+		case NL80211_IFTYPE_MESH_POINT:
+			/* mesh should be handled? */
+			break;
+		default:
+			break;
+		}
+
+		cfg80211_process_rdev_events(rdev);
+	}
+
+	err = rdev->ops->change_virtual_intf(&rdev->wiphy, dev,
+					     ntype, flags, params);
+
+	WARN_ON(!err && dev->ieee80211_ptr->iftype != ntype);
+
+	return err;
+}
--- wireless-testing.orig/net/wireless/wext-compat.c	2009-08-21 12:12:03.000000000 +0200
+++ wireless-testing/net/wireless/wext-compat.c	2009-08-21 12:23:54.000000000 +0200
@@ -70,18 +70,8 @@ int cfg80211_wext_siwmode(struct net_dev
 	enum nl80211_iftype type;
 	int ret;
 
-	if (!wdev)
-		return -EOPNOTSUPP;
-
 	rdev = wiphy_to_dev(wdev->wiphy);
 
-	if (!rdev->ops->change_virtual_intf)
-		return -EOPNOTSUPP;
-
-	/* don't support changing VLANs, you just re-create them */
-	if (wdev->iftype == NL80211_IFTYPE_AP_VLAN)
-		return -EOPNOTSUPP;
-
 	switch (*mode) {
 	case IW_MODE_INFRA:
 		type = NL80211_IFTYPE_STATION;
@@ -104,9 +94,9 @@ int cfg80211_wext_siwmode(struct net_dev
 
 	memset(&vifparams, 0, sizeof(vifparams));
 
-	ret = rdev->ops->change_virtual_intf(wdev->wiphy, dev, type,
-					     NULL, &vifparams);
-	WARN_ON(!ret && wdev->iftype != type);
+	cfg80211_lock_rdev(rdev);
+	ret = cfg80211_change_iface(rdev, dev, type, NULL, &vifparams);
+	cfg80211_unlock_rdev(rdev);
 
 	return ret;
 }


