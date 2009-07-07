Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59728 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050AbZGGCA1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:27 -0400
Message-Id: <20090707015709.254759289@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/9] cfg80211: fix locking
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Over time, a lot of locking issues have crept into
the smarts of cfg80211, so e.g. scan completion can
race against a new scan, IBSS join can race against
leaving an IBSS, etc.

Introduce a new per-interface lock that protects
most of the per-interface data that we need to keep
track of, and sprinkle assertions about that lock
everywhere. Some things now need to be offloaded to
work structs so that we don't require being able to
sleep in functions the drivers call. The exception
to that are the MLME callbacks (rx_auth etc.) that
currently only mac80211 calls because it was easier
to do that there instead of in cfg80211, and future
drivers implementing those calls will, if they ever
exist, probably need to use a similar scheme like
mac80211 anyway...

In order to be able to handle _deauth and _disassoc
properly, introduce a cookie passed to it that will
determine locking requirements.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h     |   24 +++-
 net/mac80211/cfg.c         |   12 +-
 net/mac80211/ieee80211_i.h |    6 -
 net/mac80211/mlme.c        |   25 ++--
 net/wireless/core.c        |   92 +++++++++++++++-
 net/wireless/core.h        |  100 +++++++++++++++++
 net/wireless/ibss.c        |  133 ++++++++++++++++++-----
 net/wireless/mlme.c        |  214 ++++++++++++++++++++++++++++++--------
 net/wireless/nl80211.c     |    8 -
 net/wireless/nl80211.h     |    2 
 net/wireless/scan.c        |   30 ++++-
 net/wireless/sme.c         |  252 +++++++++++++++++++++++++++++++++++----------
 net/wireless/wext-sme.c    |  125 +++++++++++++++-------
 13 files changed, 823 insertions(+), 200 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-07 03:37:05.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-07 03:37:06.000000000 +0200
@@ -257,6 +257,71 @@ static void cfg80211_rfkill_sync_work(st
 	cfg80211_rfkill_set_block(drv, rfkill_blocked(drv->rfkill));
 }
 
+static void cfg80211_process_events(struct wireless_dev *wdev)
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
+				ev->cr.status == WLAN_STATUS_SUCCESS);
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
+static void cfg80211_event_work(struct work_struct *work)
+{
+	struct cfg80211_registered_device *rdev;
+	struct wireless_dev *wdev;
+
+	rdev = container_of(work, struct cfg80211_registered_device,
+			    event_work);
+
+	rtnl_lock();
+	cfg80211_lock_rdev(rdev);
+	mutex_lock(&rdev->devlist_mtx);
+
+	list_for_each_entry(wdev, &rdev->netdev_list, list)
+		cfg80211_process_events(wdev);
+
+	mutex_unlock(&rdev->devlist_mtx);
+	cfg80211_unlock_rdev(rdev);
+	rtnl_unlock();
+}
+
 /* exported functions */
 
 struct wiphy *wiphy_new(const struct cfg80211_ops *ops, int sizeof_priv)
@@ -299,6 +364,7 @@ struct wiphy *wiphy_new(const struct cfg
 	INIT_LIST_HEAD(&drv->netdev_list);
 	spin_lock_init(&drv->bss_lock);
 	INIT_LIST_HEAD(&drv->bss_list);
+	INIT_WORK(&drv->scan_done_wk, __cfg80211_scan_done);
 
 	device_initialize(&drv->wiphy.dev);
 	drv->wiphy.dev.class = &ieee80211_class;
@@ -316,6 +382,7 @@ struct wiphy *wiphy_new(const struct cfg
 
 	INIT_WORK(&drv->rfkill_sync, cfg80211_rfkill_sync_work);
 	INIT_WORK(&drv->conn_work, cfg80211_conn_work);
+	INIT_WORK(&drv->event_work, cfg80211_event_work);
 
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
@@ -477,6 +544,9 @@ void wiphy_unregister(struct wiphy *wiph
 	mutex_unlock(&drv->mtx);
 
 	cancel_work_sync(&drv->conn_work);
+	cancel_work_sync(&drv->scan_done_wk);
+	kfree(drv->scan_req);
+	flush_work(&drv->event_work);
 
 	cfg80211_debugfs_drv_del(drv);
 
@@ -535,6 +605,9 @@ static int cfg80211_netdev_notifier_call
 
 	switch (state) {
 	case NETDEV_REGISTER:
+		mutex_init(&wdev->mtx);
+		INIT_LIST_HEAD(&wdev->event_list);
+		spin_lock_init(&wdev->event_lock);
 		mutex_lock(&rdev->devlist_mtx);
 		list_add(&wdev->list, &rdev->netdev_list);
 		if (sysfs_create_link(&dev->dev.kobj, &rdev->wiphy.dev.kobj,
@@ -566,15 +639,17 @@ static int cfg80211_netdev_notifier_call
 			cfg80211_leave_ibss(rdev, dev, true);
 			break;
 		case NL80211_IFTYPE_STATION:
+			wdev_lock(wdev);
 #ifdef CONFIG_WIRELESS_EXT
 			kfree(wdev->wext.ie);
 			wdev->wext.ie = NULL;
 			wdev->wext.ie_len = 0;
 			wdev->wext.connect.auth_type = NL80211_AUTHTYPE_AUTOMATIC;
 #endif
-			cfg80211_disconnect(rdev, dev,
-					    WLAN_REASON_DEAUTH_LEAVING, true);
+			__cfg80211_disconnect(rdev, dev,
+					      WLAN_REASON_DEAUTH_LEAVING, true);
 			cfg80211_mlme_down(rdev, dev);
+			wdev_unlock(wdev);
 			break;
 		default:
 			break;
@@ -582,20 +657,24 @@ static int cfg80211_netdev_notifier_call
 		break;
 	case NETDEV_UP:
 #ifdef CONFIG_WIRELESS_EXT
+		cfg80211_lock_rdev(rdev);
+		wdev_lock(wdev);
 		switch (wdev->iftype) {
 		case NL80211_IFTYPE_ADHOC:
 			if (wdev->wext.ibss.ssid_len)
-				cfg80211_join_ibss(rdev, dev,
-						   &wdev->wext.ibss);
+				__cfg80211_join_ibss(rdev, dev,
+						     &wdev->wext.ibss);
 			break;
 		case NL80211_IFTYPE_STATION:
 			if (wdev->wext.connect.ssid_len)
-				cfg80211_connect(rdev, dev,
-						 &wdev->wext.connect);
+				__cfg80211_connect(rdev, dev,
+						   &wdev->wext.connect);
 			break;
 		default:
 			break;
 		}
+		wdev_unlock(wdev);
+		cfg80211_unlock_rdev(rdev);
 #endif
 		break;
 	case NETDEV_UNREGISTER:
@@ -605,6 +684,7 @@ static int cfg80211_netdev_notifier_call
 			list_del_init(&wdev->list);
 		}
 		mutex_unlock(&rdev->devlist_mtx);
+		mutex_destroy(&wdev->mtx);
 		break;
 	case NETDEV_PRE_UP:
 		if (rfkill_blocked(rdev->rfkill))
--- wireless-testing.orig/net/wireless/core.h	2009-07-07 03:37:05.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-07-07 03:37:06.000000000 +0200
@@ -57,12 +57,14 @@ struct cfg80211_registered_device {
 	u32 bss_generation;
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	unsigned long suspend_at;
+	struct work_struct scan_done_wk;
 
 #ifdef CONFIG_NL80211_TESTMODE
 	struct genl_info *testmode_info;
 #endif
 
 	struct work_struct conn_work;
+	struct work_struct event_work;
 
 #ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
@@ -170,12 +172,73 @@ struct wiphy *wiphy_idx_to_wiphy(int wip
 extern struct cfg80211_registered_device *
 cfg80211_get_dev_from_ifindex(int ifindex);
 
+static inline void cfg80211_lock_rdev(struct cfg80211_registered_device *drv)
+{
+	mutex_lock(&drv->mtx);
+}
+
 static inline void cfg80211_unlock_rdev(struct cfg80211_registered_device *drv)
 {
 	BUG_ON(IS_ERR(drv) || !drv);
 	mutex_unlock(&drv->mtx);
 }
 
+static inline void wdev_lock(struct wireless_dev *wdev)
+	__acquires(wdev)
+{
+	mutex_lock(&wdev->mtx);
+	__acquire(wdev->mtx);
+}
+
+static inline void wdev_unlock(struct wireless_dev *wdev)
+	__releases(wdev)
+{
+	__release(wdev->mtx);
+	mutex_unlock(&wdev->mtx);
+}
+
+#define ASSERT_RDEV_LOCK(rdev) WARN_ON(!mutex_is_locked(&(rdev)->mtx));
+#define ASSERT_WDEV_LOCK(wdev) WARN_ON(!mutex_is_locked(&(wdev)->mtx));
+
+enum cfg80211_event_type {
+	EVENT_CONNECT_RESULT,
+	EVENT_ROAMED,
+	EVENT_DISCONNECTED,
+	EVENT_IBSS_JOINED,
+};
+
+struct cfg80211_event {
+	struct list_head list;
+	enum cfg80211_event_type type;
+
+	union {
+		struct {
+			u8 bssid[ETH_ALEN];
+			const u8 *req_ie;
+			const u8 *resp_ie;
+			size_t req_ie_len;
+			size_t resp_ie_len;
+			u16 status;
+		} cr;
+		struct {
+			u8 bssid[ETH_ALEN];
+			const u8 *req_ie;
+			const u8 *resp_ie;
+			size_t req_ie_len;
+			size_t resp_ie_len;
+		} rm;
+		struct {
+			const u8 *ie;
+			size_t ie_len;
+			u16 reason;
+		} dc;
+		struct {
+			u8 bssid[ETH_ALEN];
+		} ij;
+	};
+};
+
+
 /* free object */
 extern void cfg80211_dev_free(struct cfg80211_registered_device *drv);
 
@@ -191,25 +254,46 @@ void cfg80211_bss_age(struct cfg80211_re
                       unsigned long age_secs);
 
 /* IBSS */
+int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct cfg80211_ibss_params *params);
 int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct cfg80211_ibss_params *params);
 void cfg80211_clear_ibss(struct net_device *dev, bool nowext);
 int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, bool nowext);
+void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid);
 
 /* MLME */
+int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_auth_type auth_type,
+			 const u8 *bssid,
+			 const u8 *ssid, int ssid_len,
+			 const u8 *ie, int ie_len);
 int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev, struct ieee80211_channel *chan,
 		       enum nl80211_auth_type auth_type, const u8 *bssid,
 		       const u8 *ssid, int ssid_len,
 		       const u8 *ie, int ie_len);
+int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev,
+			  struct ieee80211_channel *chan,
+			  const u8 *bssid, const u8 *prev_bssid,
+			  const u8 *ssid, int ssid_len,
+			  const u8 *ie, int ie_len, bool use_mfp,
+			  struct cfg80211_crypto_settings *crypt);
 int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, struct ieee80211_channel *chan,
 			const u8 *bssid, const u8 *prev_bssid,
 			const u8 *ssid, int ssid_len,
 			const u8 *ie, int ie_len, bool use_mfp,
 			struct cfg80211_crypto_settings *crypt);
+int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev, const u8 *bssid,
+			   const u8 *ie, int ie_len, u16 reason);
 int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
 			 struct net_device *dev, const u8 *bssid,
 			 const u8 *ie, int ie_len, u16 reason);
@@ -218,24 +302,38 @@ int cfg80211_mlme_disassoc(struct cfg802
 			   const u8 *ie, int ie_len, u16 reason);
 void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
 			struct net_device *dev);
+void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
+			       const u8 *req_ie, size_t req_ie_len,
+			       const u8 *resp_ie, size_t resp_ie_len,
+			       u16 status, bool wextev);
 
 /* SME */
+int __cfg80211_connect(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       struct cfg80211_connect_params *connect);
 int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev,
 		     struct cfg80211_connect_params *connect);
+int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, u16 reason,
+			  bool wextev);
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason,
 			bool wextev);
+void __cfg80211_roamed(struct wireless_dev *wdev, const u8 *bssid,
+		       const u8 *req_ie, size_t req_ie_len,
+		       const u8 *resp_ie, size_t resp_ie_len);
 
 void cfg80211_conn_work(struct work_struct *work);
 
 /* internal helpers */
 int cfg80211_validate_key_settings(struct key_params *params, int key_idx,
 				   const u8 *mac_addr);
-void __cfg80211_disconnected(struct net_device *dev, gfp_t gfp, u8 *ie,
+void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			     size_t ie_len, u16 reason, bool from_ap);
 void cfg80211_sme_scan_done(struct net_device *dev);
 void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len);
 void cfg80211_sme_disassoc(struct net_device *dev, int idx);
+void __cfg80211_scan_done(struct work_struct *wk);
 
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/net/wireless/mlme.c	2009-07-07 03:37:05.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-07-07 03:37:06.000000000 +0200
@@ -23,7 +23,7 @@ void cfg80211_send_rx_auth(struct net_de
 	u16 status = le16_to_cpu(mgmt->u.auth.status_code);
 	bool done = false;
 
-	might_sleep();
+	wdev_lock(wdev);
 
 	for (i = 0; i < MAX_AUTH_BSSES; i++) {
 		if (wdev->authtry_bsses[i] &&
@@ -45,6 +45,8 @@ void cfg80211_send_rx_auth(struct net_de
 
 	nl80211_send_rx_auth(rdev, dev, buf, len, GFP_KERNEL);
 	cfg80211_sme_rx_auth(dev, buf, len);
+
+	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_auth);
 
@@ -59,14 +61,15 @@ void cfg80211_send_rx_assoc(struct net_d
 	int i, ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
 	bool done;
 
-	might_sleep();
+	wdev_lock(wdev);
 
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
 	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL);
 
-	cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
-				status_code, GFP_KERNEL);
+	__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, ie, len - ieoffs,
+				  status_code,
+				  status_code == WLAN_STATUS_SUCCESS);
 
 	if (status_code == WLAN_STATUS_SUCCESS) {
 		for (i = 0; wdev->current_bss && i < MAX_AUTH_BSSES; i++) {
@@ -81,10 +84,13 @@ void cfg80211_send_rx_assoc(struct net_d
 
 		WARN_ON(!done);
 	}
+
+	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len)
+static void __cfg80211_send_deauth(struct net_device *dev,
+				   const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -94,7 +100,7 @@ void cfg80211_send_deauth(struct net_dev
 	int i;
 	bool done = false;
 
-	might_sleep();
+	ASSERT_WDEV_LOCK(wdev);
 
 	nl80211_send_deauth(rdev, dev, buf, len, GFP_KERNEL);
 
@@ -132,17 +138,35 @@ void cfg80211_send_deauth(struct net_dev
 		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
 
 		from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
-		__cfg80211_disconnected(dev, GFP_KERNEL, NULL, 0,
-					reason_code, from_ap);
+		__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
 	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
-		cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					GFP_KERNEL);
+		__cfg80211_connect_result(dev, mgmt->bssid, NULL, 0, NULL, 0,
+					  WLAN_STATUS_UNSPECIFIED_FAILURE,
+					  false);
+	}
+}
+
+
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len,
+			  void *cookie)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	BUG_ON(cookie && wdev != cookie);
+
+	if (cookie) {
+		/* called within callback */
+		__cfg80211_send_deauth(dev, buf, len);
+	} else {
+		wdev_lock(wdev);
+		__cfg80211_send_deauth(dev, buf, len);
+		wdev_unlock(wdev);
 	}
 }
 EXPORT_SYMBOL(cfg80211_send_deauth);
 
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len)
+static void __cfg80211_send_disassoc(struct net_device *dev,
+				     const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -154,12 +178,12 @@ void cfg80211_send_disassoc(struct net_d
 	bool from_ap;
 	bool done = false;
 
-	might_sleep();
+	wdev_lock(wdev);
 
 	nl80211_send_disassoc(rdev, dev, buf, len, GFP_KERNEL);
 
 	if (!wdev->sme_state == CFG80211_SME_CONNECTED)
-		return;
+		goto out;
 
 	if (wdev->current_bss &&
 	    memcmp(wdev->current_bss, bssid, ETH_ALEN) == 0) {
@@ -180,8 +204,26 @@ void cfg80211_send_disassoc(struct net_d
 	reason_code = le16_to_cpu(mgmt->u.disassoc.reason_code);
 
 	from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
-	__cfg80211_disconnected(dev, GFP_KERNEL, NULL, 0,
-				reason_code, from_ap);
+	__cfg80211_disconnected(dev, NULL, 0, reason_code, from_ap);
+ out:
+	wdev_unlock(wdev);
+}
+
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len,
+			    void *cookie)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	BUG_ON(cookie && wdev != cookie);
+
+	if (cookie) {
+		/* called within callback */
+		__cfg80211_send_disassoc(dev, buf, len);
+	} else {
+		wdev_lock(wdev);
+		__cfg80211_send_disassoc(dev, buf, len);
+		wdev_unlock(wdev);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_disassoc);
 
@@ -193,13 +235,13 @@ void cfg80211_send_auth_timeout(struct n
 	int i;
 	bool done = false;
 
-	might_sleep();
+	wdev_lock(wdev);
 
 	nl80211_send_auth_timeout(rdev, dev, addr, GFP_KERNEL);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
-		cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					GFP_KERNEL);
+		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
+					  WLAN_STATUS_UNSPECIFIED_FAILURE,
+					  false);
 
 	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
 		if (wdev->authtry_bsses[i] &&
@@ -214,6 +256,8 @@ void cfg80211_send_auth_timeout(struct n
 	}
 
 	WARN_ON(!done);
+
+	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_auth_timeout);
 
@@ -225,13 +269,13 @@ void cfg80211_send_assoc_timeout(struct 
 	int i;
 	bool done = false;
 
-	might_sleep();
+	wdev_lock(wdev);
 
 	nl80211_send_assoc_timeout(rdev, dev, addr, GFP_KERNEL);
 	if (wdev->sme_state == CFG80211_SME_CONNECTING)
-		cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
-					WLAN_STATUS_UNSPECIFIED_FAILURE,
-					GFP_KERNEL);
+		__cfg80211_connect_result(dev, addr, NULL, 0, NULL, 0,
+					  WLAN_STATUS_UNSPECIFIED_FAILURE,
+					  false);
 
 	for (i = 0; addr && i < MAX_AUTH_BSSES; i++) {
 		if (wdev->auth_bsses[i] &&
@@ -246,6 +290,8 @@ void cfg80211_send_assoc_timeout(struct 
 	}
 
 	WARN_ON(!done);
+
+	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
 
@@ -276,17 +322,21 @@ void cfg80211_michael_mic_failure(struct
 EXPORT_SYMBOL(cfg80211_michael_mic_failure);
 
 /* some MLME handling for userspace SME */
-int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
-		       struct net_device *dev, struct ieee80211_channel *chan,
-		       enum nl80211_auth_type auth_type, const u8 *bssid,
-		       const u8 *ssid, int ssid_len,
-		       const u8 *ie, int ie_len)
+int __cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct ieee80211_channel *chan,
+			 enum nl80211_auth_type auth_type,
+			 const u8 *bssid,
+			 const u8 *ssid, int ssid_len,
+			 const u8 *ie, int ie_len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_auth_request req;
 	struct cfg80211_internal_bss *bss;
 	int i, err, slot = -1, nfree = 0;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (wdev->current_bss &&
 	    memcmp(bssid, wdev->current_bss->pub.bssid, ETH_ALEN) == 0)
 		return -EALREADY;
@@ -342,18 +392,37 @@ int cfg80211_mlme_auth(struct cfg80211_r
 	return err;
 }
 
-int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
-			struct net_device *dev, struct ieee80211_channel *chan,
-			const u8 *bssid, const u8 *prev_bssid,
-			const u8 *ssid, int ssid_len,
-			const u8 *ie, int ie_len, bool use_mfp,
-			struct cfg80211_crypto_settings *crypt)
+int cfg80211_mlme_auth(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev, struct ieee80211_channel *chan,
+		       enum nl80211_auth_type auth_type, const u8 *bssid,
+		       const u8 *ssid, int ssid_len,
+		       const u8 *ie, int ie_len)
+{
+	int err;
+
+	wdev_lock(dev->ieee80211_ptr);
+	err = __cfg80211_mlme_auth(rdev, dev, chan, auth_type, bssid,
+				   ssid, ssid_len, ie, ie_len);
+	wdev_unlock(dev->ieee80211_ptr);
+
+	return err;
+}
+
+int __cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev,
+			  struct ieee80211_channel *chan,
+			  const u8 *bssid, const u8 *prev_bssid,
+			  const u8 *ssid, int ssid_len,
+			  const u8 *ie, int ie_len, bool use_mfp,
+			  struct cfg80211_crypto_settings *crypt)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_assoc_request req;
 	struct cfg80211_internal_bss *bss;
 	int i, err, slot = -1;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	memset(&req, 0, sizeof(req));
 
 	if (wdev->current_bss)
@@ -390,14 +459,35 @@ int cfg80211_mlme_assoc(struct cfg80211_
 	return err;
 }
 
-int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
-			 struct net_device *dev, const u8 *bssid,
-			 const u8 *ie, int ie_len, u16 reason)
+int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			struct ieee80211_channel *chan,
+			const u8 *bssid, const u8 *prev_bssid,
+			const u8 *ssid, int ssid_len,
+			const u8 *ie, int ie_len, bool use_mfp,
+			struct cfg80211_crypto_settings *crypt)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_mlme_assoc(rdev, dev, chan, bssid, prev_bssid,
+				    ssid, ssid_len, ie, ie_len, use_mfp, crypt);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
+int __cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev, const u8 *bssid,
+			   const u8 *ie, int ie_len, u16 reason)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_deauth_request req;
 	int i;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	memset(&req, 0, sizeof(req));
 	req.reason_code = reason;
 	req.ie = ie;
@@ -421,16 +511,32 @@ int cfg80211_mlme_deauth(struct cfg80211
 	if (!req.bss)
 		return -ENOTCONN;
 
-	return rdev->ops->deauth(&rdev->wiphy, dev, &req);
+	return rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
 }
 
-int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
-			   struct net_device *dev, const u8 *bssid,
-			   const u8 *ie, int ie_len, u16 reason)
+int cfg80211_mlme_deauth(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev, const u8 *bssid,
+			 const u8 *ie, int ie_len, u16 reason)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_mlme_deauth(rdev, dev, bssid, ie, ie_len, reason);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
+static int __cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
+				    struct net_device *dev, const u8 *bssid,
+				    const u8 *ie, int ie_len, u16 reason)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_disassoc_request req;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	memset(&req, 0, sizeof(req));
 	req.reason_code = reason;
 	req.ie = ie;
@@ -440,7 +546,21 @@ int cfg80211_mlme_disassoc(struct cfg802
 	else
 		return -ENOTCONN;
 
-	return rdev->ops->disassoc(&rdev->wiphy, dev, &req);
+	return rdev->ops->disassoc(&rdev->wiphy, dev, &req, wdev);
+}
+
+int cfg80211_mlme_disassoc(struct cfg80211_registered_device *rdev,
+			   struct net_device *dev, const u8 *bssid,
+			   const u8 *ie, int ie_len, u16 reason)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_mlme_disassoc(rdev, dev, bssid, ie, ie_len, reason);
+	wdev_unlock(wdev);
+
+	return err;
 }
 
 void cfg80211_mlme_down(struct cfg80211_registered_device *rdev,
@@ -450,6 +570,8 @@ void cfg80211_mlme_down(struct cfg80211_
 	struct cfg80211_deauth_request req;
 	int i;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (!rdev->ops->deauth)
 		return;
 
@@ -460,7 +582,7 @@ void cfg80211_mlme_down(struct cfg80211_
 
 	if (wdev->current_bss) {
 		req.bss = &wdev->current_bss->pub;
-		rdev->ops->deauth(&rdev->wiphy, dev, &req);
+		rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
 		if (wdev->current_bss) {
 			cfg80211_unhold_bss(wdev->current_bss);
 			cfg80211_put_bss(&wdev->current_bss->pub);
@@ -471,7 +593,7 @@ void cfg80211_mlme_down(struct cfg80211_
 	for (i = 0; i < MAX_AUTH_BSSES; i++) {
 		if (wdev->auth_bsses[i]) {
 			req.bss = &wdev->auth_bsses[i]->pub;
-			rdev->ops->deauth(&rdev->wiphy, dev, &req);
+			rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
 			if (wdev->auth_bsses[i]) {
 				cfg80211_unhold_bss(wdev->auth_bsses[i]);
 				cfg80211_put_bss(&wdev->auth_bsses[i]->pub);
@@ -480,7 +602,7 @@ void cfg80211_mlme_down(struct cfg80211_
 		}
 		if (wdev->authtry_bsses[i]) {
 			req.bss = &wdev->authtry_bsses[i]->pub;
-			rdev->ops->deauth(&rdev->wiphy, dev, &req);
+			rdev->ops->deauth(&rdev->wiphy, dev, &req, wdev);
 			if (wdev->authtry_bsses[i]) {
 				cfg80211_unhold_bss(wdev->authtry_bsses[i]);
 				cfg80211_put_bss(&wdev->authtry_bsses[i]->pub);
--- wireless-testing.orig/net/wireless/sme.c	2009-07-07 03:36:58.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-07-07 03:37:06.000000000 +0200
@@ -38,6 +38,8 @@ static int cfg80211_conn_scan(struct wir
 	int n_channels, err;
 
 	ASSERT_RTNL();
+	ASSERT_RDEV_LOCK(drv);
+	ASSERT_WDEV_LOCK(wdev);
 
 	if (drv->scan_req)
 		return -EBUSY;
@@ -106,6 +108,8 @@ static int cfg80211_conn_do_work(struct 
 	struct cfg80211_connect_params *params;
 	int err;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (!wdev->conn)
 		return 0;
 
@@ -117,11 +121,11 @@ static int cfg80211_conn_do_work(struct 
 	case CFG80211_CONN_AUTHENTICATE_NEXT:
 		BUG_ON(!drv->ops->auth);
 		wdev->conn->state = CFG80211_CONN_AUTHENTICATING;
-		return cfg80211_mlme_auth(drv, wdev->netdev,
-					  params->channel, params->auth_type,
-					  params->bssid,
-					  params->ssid, params->ssid_len,
-					  NULL, 0);
+		return __cfg80211_mlme_auth(drv, wdev->netdev,
+					    params->channel, params->auth_type,
+					    params->bssid,
+					    params->ssid, params->ssid_len,
+					    NULL, 0);
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		BUG_ON(!drv->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
@@ -131,14 +135,16 @@ static int cfg80211_conn_do_work(struct 
 		 * that some APs don't like that -- so we'd need to retry
 		 * the association.
 		 */
-		err = cfg80211_mlme_assoc(drv, wdev->netdev,
-					  params->channel, params->bssid, NULL,
-					  params->ssid, params->ssid_len,
-					  params->ie, params->ie_len,
-					  false, &params->crypto);
+		err = __cfg80211_mlme_assoc(drv, wdev->netdev,
+					    params->channel, params->bssid,
+					    NULL,
+					    params->ssid, params->ssid_len,
+					    params->ie, params->ie_len,
+					    false, &params->crypto);
 		if (err)
-			cfg80211_mlme_deauth(drv, wdev->netdev, params->bssid,
-					     NULL, 0, WLAN_REASON_DEAUTH_LEAVING);
+			__cfg80211_mlme_deauth(drv, wdev->netdev, params->bssid,
+					       NULL, 0,
+					       WLAN_REASON_DEAUTH_LEAVING);
 		return err;
 	default:
 		return 0;
@@ -152,22 +158,31 @@ void cfg80211_conn_work(struct work_stru
 	struct wireless_dev *wdev;
 
 	rtnl_lock();
+	cfg80211_lock_rdev(drv);
 	mutex_lock(&drv->devlist_mtx);
 
 	list_for_each_entry(wdev, &drv->netdev_list, list) {
-		if (!netif_running(wdev->netdev))
+		wdev_lock(wdev);
+		if (!netif_running(wdev->netdev)) {
+			wdev_unlock(wdev);
 			continue;
-		if (wdev->sme_state != CFG80211_SME_CONNECTING)
+		}
+		if (wdev->sme_state != CFG80211_SME_CONNECTING) {
+			wdev_unlock(wdev);
 			continue;
+		}
 		if (cfg80211_conn_do_work(wdev))
-			cfg80211_connect_result(wdev->netdev,
-						wdev->conn->params.bssid,
-						NULL, 0, NULL, 0,
-						WLAN_STATUS_UNSPECIFIED_FAILURE,
-						GFP_ATOMIC);
+			__cfg80211_connect_result(
+					wdev->netdev,
+					wdev->conn->params.bssid,
+					NULL, 0, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					false);
+		wdev_unlock(wdev);
 	}
 
 	mutex_unlock(&drv->devlist_mtx);
+	cfg80211_unlock_rdev(drv);
 	rtnl_unlock();
 }
 
@@ -177,6 +192,8 @@ static bool cfg80211_get_conn_bss(struct
 	struct cfg80211_bss *bss;
 	u16 capa = WLAN_CAPABILITY_ESS;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (wdev->conn->params.privacy)
 		capa |= WLAN_CAPABILITY_PRIVACY;
 
@@ -198,11 +215,13 @@ static bool cfg80211_get_conn_bss(struct
 	return true;
 }
 
-void cfg80211_sme_scan_done(struct net_device *dev)
+static void __cfg80211_sme_scan_done(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (wdev->sme_state != CFG80211_SME_CONNECTING)
 		return;
 
@@ -218,15 +237,26 @@ void cfg80211_sme_scan_done(struct net_d
 		if (wdev->conn->state == CFG80211_CONN_SCAN_AGAIN)
 			schedule_work(&drv->conn_work);
 		else
-			cfg80211_connect_result(dev, wdev->conn->params.bssid,
-						NULL, 0, NULL, 0,
-						WLAN_STATUS_UNSPECIFIED_FAILURE,
-						GFP_ATOMIC);
-		return;
+			__cfg80211_connect_result(
+					wdev->netdev,
+					wdev->conn->params.bssid,
+					NULL, 0, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					false);
 	}
 }
 
-void cfg80211_sme_rx_auth(struct net_device *dev, const u8 *buf, size_t len)
+void cfg80211_sme_scan_done(struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	wdev_lock(wdev);
+	__cfg80211_sme_scan_done(dev);
+	wdev_unlock(wdev);
+}
+
+void cfg80211_sme_rx_auth(struct net_device *dev,
+			  const u8 *buf, size_t len)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct wiphy *wiphy = wdev->wiphy;
@@ -234,6 +264,8 @@ void cfg80211_sme_rx_auth(struct net_dev
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
 	u16 status_code = le16_to_cpu(mgmt->u.auth.status_code);
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	/* should only RX auth frames when connecting */
 	if (wdev->sme_state != CFG80211_SME_CONNECTING)
 		return;
@@ -273,10 +305,10 @@ void cfg80211_sme_rx_auth(struct net_dev
 	}
 }
 
-static void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
-				      const u8 *req_ie, size_t req_ie_len,
-				      const u8 *resp_ie, size_t resp_ie_len,
-				      u16 status, bool wextev, gfp_t gfp)
+void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
+			       const u8 *req_ie, size_t req_ie_len,
+			       const u8 *resp_ie, size_t resp_ie_len,
+			       u16 status, bool wextev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss;
@@ -284,18 +316,20 @@ static void __cfg80211_connect_result(st
 	union iwreq_data wrqu;
 #endif
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
 	if (wdev->sme_state == CFG80211_SME_CONNECTED)
 		nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), dev,
 				    bssid, req_ie, req_ie_len,
-				    resp_ie, resp_ie_len, gfp);
+				    resp_ie, resp_ie_len, GFP_KERNEL);
 	else
 		nl80211_send_connect_result(wiphy_to_dev(wdev->wiphy), dev,
 					    bssid, req_ie, req_ie_len,
 					    resp_ie, resp_ie_len,
-					    status, gfp);
+					    status, GFP_KERNEL);
 
 #ifdef CONFIG_WIRELESS_EXT
 	if (wextev) {
@@ -362,21 +396,43 @@ void cfg80211_connect_result(struct net_
 			     const u8 *resp_ie, size_t resp_ie_len,
 			     u16 status, gfp_t gfp)
 {
-	bool wextev = status == WLAN_STATUS_SUCCESS;
-	__cfg80211_connect_result(dev, bssid, req_ie, req_ie_len, resp_ie, resp_ie_len, status, wextev, gfp);
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
+	if (!ev)
+		return;
+
+	ev->type = EVENT_CONNECT_RESULT;
+	memcpy(ev->cr.bssid, bssid, ETH_ALEN);
+	ev->cr.req_ie = ((u8 *)ev) + sizeof(*ev);
+	ev->cr.req_ie_len = req_ie_len;
+	memcpy((void *)ev->cr.req_ie, req_ie, req_ie_len);
+	ev->cr.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
+	ev->cr.resp_ie_len = resp_ie_len;
+	memcpy((void *)ev->cr.resp_ie, resp_ie, resp_ie_len);
+	ev->cr.status = status;
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	schedule_work(&rdev->event_work);
 }
 EXPORT_SYMBOL(cfg80211_connect_result);
 
-void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
-		     const u8 *req_ie, size_t req_ie_len,
-		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
+void __cfg80211_roamed(struct wireless_dev *wdev, const u8 *bssid,
+		       const u8 *req_ie, size_t req_ie_len,
+		       const u8 *resp_ie, size_t resp_ie_len)
 {
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss;
 #ifdef CONFIG_WIRELESS_EXT
 	union iwreq_data wrqu;
 #endif
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
@@ -402,31 +458,62 @@ void cfg80211_roamed(struct net_device *
 	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
-	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), dev, bssid,
-			    req_ie, req_ie_len, resp_ie, resp_ie_len, gfp);
+	nl80211_send_roamed(wiphy_to_dev(wdev->wiphy), wdev->netdev, bssid,
+			    req_ie, req_ie_len, resp_ie, resp_ie_len,
+			    GFP_KERNEL);
 
 #ifdef CONFIG_WIRELESS_EXT
 	if (req_ie) {
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = req_ie_len;
-		wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, req_ie);
+		wireless_send_event(wdev->netdev, IWEVASSOCRESPIE,
+				    &wrqu, req_ie);
 	}
 
 	if (resp_ie) {
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.data.length = resp_ie_len;
-		wireless_send_event(dev, IWEVASSOCRESPIE, &wrqu, resp_ie);
+		wireless_send_event(wdev->netdev, IWEVASSOCRESPIE,
+				    &wrqu, resp_ie);
 	}
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
+	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
 #endif
 }
+
+void cfg80211_roamed(struct net_device *dev, const u8 *bssid,
+		     const u8 *req_ie, size_t req_ie_len,
+		     const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	ev = kzalloc(sizeof(*ev) + req_ie_len + resp_ie_len, gfp);
+	if (!ev)
+		return;
+
+	ev->type = EVENT_ROAMED;
+	memcpy(ev->rm.bssid, bssid, ETH_ALEN);
+	ev->rm.req_ie = ((u8 *)ev) + sizeof(*ev);
+	ev->rm.req_ie_len = req_ie_len;
+	memcpy((void *)ev->rm.req_ie, req_ie, req_ie_len);
+	ev->rm.resp_ie = ((u8 *)ev) + sizeof(*ev) + req_ie_len;
+	ev->rm.resp_ie_len = resp_ie_len;
+	memcpy((void *)ev->rm.resp_ie, resp_ie, resp_ie_len);
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	schedule_work(&rdev->event_work);
+}
 EXPORT_SYMBOL(cfg80211_roamed);
 
-void __cfg80211_disconnected(struct net_device *dev, gfp_t gfp, u8 *ie,
+void __cfg80211_disconnected(struct net_device *dev, const u8 *ie,
 			     size_t ie_len, u16 reason, bool from_ap)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
@@ -434,6 +521,8 @@ void __cfg80211_disconnected(struct net_
 	union iwreq_data wrqu;
 #endif
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return;
 
@@ -456,7 +545,7 @@ void __cfg80211_disconnected(struct net_
 	}
 
 	nl80211_send_disconnected(wiphy_to_dev(wdev->wiphy), dev,
-				  reason, ie, ie_len, from_ap, gfp);
+				  reason, ie, ie_len, from_ap);
 
 #ifdef CONFIG_WIRELESS_EXT
 	memset(&wrqu, 0, sizeof(wrqu));
@@ -468,16 +557,36 @@ void __cfg80211_disconnected(struct net_
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
 			   u8 *ie, size_t ie_len, gfp_t gfp)
 {
-	__cfg80211_disconnected(dev, gfp, ie, ie_len, reason, true);
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	ev = kzalloc(sizeof(*ev) + ie_len, gfp);
+	if (!ev)
+		return;
+
+	ev->type = EVENT_DISCONNECTED;
+	ev->dc.ie = ((u8 *)ev) + sizeof(*ev);
+	ev->dc.ie_len = ie_len;
+	memcpy((void *)ev->dc.ie, ie, ie_len);
+	ev->dc.reason = reason;
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	schedule_work(&rdev->event_work);
 }
 EXPORT_SYMBOL(cfg80211_disconnected);
 
-int cfg80211_connect(struct cfg80211_registered_device *rdev,
-		     struct net_device *dev,
-		     struct cfg80211_connect_params *connect)
+int __cfg80211_connect(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       struct cfg80211_connect_params *connect)
 {
-	int err;
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	ASSERT_WDEV_LOCK(wdev);
 
 	if (wdev->sme_state != CFG80211_SME_IDLE)
 		return -EALREADY;
@@ -572,12 +681,27 @@ int cfg80211_connect(struct cfg80211_reg
 	}
 }
 
-int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
-			struct net_device *dev, u16 reason, bool wextev)
+int cfg80211_connect(struct cfg80211_registered_device *rdev,
+		     struct net_device *dev,
+		     struct cfg80211_connect_params *connect)
+{
+	int err;
+
+	wdev_lock(dev->ieee80211_ptr);
+	err = __cfg80211_connect(rdev, dev, connect);
+	wdev_unlock(dev->ieee80211_ptr);
+
+	return err;
+}
+
+int __cfg80211_disconnect(struct cfg80211_registered_device *rdev,
+			  struct net_device *dev, u16 reason, bool wextev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (wdev->sme_state == CFG80211_SME_IDLE)
 		return -EINVAL;
 
@@ -601,8 +725,9 @@ int cfg80211_disconnect(struct cfg80211_
 		}
 
 		/* wdev->conn->params.bssid must be set if > SCANNING */
-		err = cfg80211_mlme_deauth(rdev, dev, wdev->conn->params.bssid,
-					   NULL, 0, reason);
+		err = __cfg80211_mlme_deauth(rdev, dev,
+					     wdev->conn->params.bssid,
+					     NULL, 0, reason);
 		if (err)
 			return err;
 	} else {
@@ -612,21 +737,36 @@ int cfg80211_disconnect(struct cfg80211_
 	}
 
 	if (wdev->sme_state == CFG80211_SME_CONNECTED)
-		__cfg80211_disconnected(dev, GFP_KERNEL, NULL, 0, 0, false);
+		__cfg80211_disconnected(dev, NULL, 0, 0, false);
 	else if (wdev->sme_state == CFG80211_SME_CONNECTING)
 		__cfg80211_connect_result(dev, NULL, NULL, 0, NULL, 0,
 					  WLAN_STATUS_UNSPECIFIED_FAILURE,
-					  wextev, GFP_KERNEL);
+					  wextev);
 
 	return 0;
 }
 
+int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
+			struct net_device *dev,
+			u16 reason, bool wextev)
+{
+	int err;
+
+	wdev_lock(dev->ieee80211_ptr);
+	err = __cfg80211_disconnect(rdev, dev, reason, wextev);
+	wdev_unlock(dev->ieee80211_ptr);
+
+	return err;
+}
+
 void cfg80211_sme_disassoc(struct net_device *dev, int idx)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	u8 bssid[ETH_ALEN];
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (!wdev->conn)
 		return;
 
--- wireless-testing.orig/include/net/cfg80211.h	2009-07-07 03:37:04.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-07-07 03:37:06.000000000 +0200
@@ -555,6 +555,7 @@ struct cfg80211_scan_request {
 	/* internal */
 	struct wiphy *wiphy;
 	int ifidx;
+	bool aborted;
 };
 
 /**
@@ -998,9 +999,11 @@ struct cfg80211_ops {
 	int	(*assoc)(struct wiphy *wiphy, struct net_device *dev,
 			 struct cfg80211_assoc_request *req);
 	int	(*deauth)(struct wiphy *wiphy, struct net_device *dev,
-			  struct cfg80211_deauth_request *req);
+			  struct cfg80211_deauth_request *req,
+			  void *cookie);
 	int	(*disassoc)(struct wiphy *wiphy, struct net_device *dev,
-			    struct cfg80211_disassoc_request *req);
+			    struct cfg80211_disassoc_request *req,
+			    void *cookie);
 
 	int	(*connect)(struct wiphy *wiphy, struct net_device *dev,
 			   struct cfg80211_connect_params *sme);
@@ -1249,10 +1252,12 @@ struct wireless_dev {
 	struct wiphy *wiphy;
 	enum nl80211_iftype iftype;
 
-	/* private to the generic wireless code */
+	/* the remainder of this struct should be private to cfg80211 */
 	struct list_head list;
 	struct net_device *netdev;
 
+	struct mutex mtx;
+
 	/* currently used for IBSS and SME - might be rearranged later */
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;
@@ -1263,6 +1268,9 @@ struct wireless_dev {
 	} sme_state;
 	struct cfg80211_conn *conn;
 
+	struct list_head event_list;
+	spinlock_t event_lock;
+
 	struct cfg80211_internal_bss *authtry_bsses[MAX_AUTH_BSSES];
 	struct cfg80211_internal_bss *auth_bsses[MAX_AUTH_BSSES];
 	struct cfg80211_internal_bss *current_bss; /* associated / joined */
@@ -1765,24 +1773,30 @@ void cfg80211_send_assoc_timeout(struct 
  * @dev: network device
  * @buf: deauthentication frame (header + body)
  * @len: length of the frame data
+ * @cookie: cookie from ->deauth if called within that callback,
+ *	%NULL otherwise
  *
  * This function is called whenever deauthentication has been processed in
  * station mode. This includes both received deauthentication frames and
  * locally generated ones. This function may sleep.
  */
-void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len,
+			  void *cookie);
 
 /**
  * cfg80211_send_disassoc - notification of processed disassociation
  * @dev: network device
  * @buf: disassociation response frame (header + body)
  * @len: length of the frame data
+ * @cookie: cookie from ->disassoc if called within that callback,
+ *	%NULL otherwise
  *
  * This function is called whenever disassociation has been processed in
  * station mode. This includes both received disassociation frames and locally
  * generated ones. This function may sleep.
  */
-void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len);
+void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len,
+			    void *cookie);
 
 /**
  * cfg80211_michael_mic_failure - notification of Michael MIC failure (TKIP)
--- wireless-testing.orig/net/wireless/scan.c	2009-07-07 03:37:05.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-07-07 03:37:06.000000000 +0200
@@ -17,13 +17,21 @@
 
 #define IEEE80211_SCAN_RESULT_EXPIRE	(10 * HZ)
 
-void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
+void __cfg80211_scan_done(struct work_struct *wk)
 {
+	struct cfg80211_registered_device *rdev;
+	struct cfg80211_scan_request *request;
 	struct net_device *dev;
 #ifdef CONFIG_WIRELESS_EXT
 	union iwreq_data wrqu;
 #endif
 
+	rdev = container_of(wk, struct cfg80211_registered_device,
+			    scan_done_wk);
+
+	mutex_lock(&rdev->mtx);
+	request = rdev->scan_req;
+
 	dev = dev_get_by_index(&init_net, request->ifidx);
 	if (!dev)
 		goto out;
@@ -35,7 +43,7 @@ void cfg80211_scan_done(struct cfg80211_
 	 */
 	cfg80211_sme_scan_done(dev);
 
-	if (aborted)
+	if (request->aborted)
 		nl80211_send_scan_aborted(wiphy_to_dev(request->wiphy), dev);
 	else
 		nl80211_send_scan_done(wiphy_to_dev(request->wiphy), dev);
@@ -43,7 +51,7 @@ void cfg80211_scan_done(struct cfg80211_
 	wiphy_to_dev(request->wiphy)->scan_req = NULL;
 
 #ifdef CONFIG_WIRELESS_EXT
-	if (!aborted) {
+	if (!request->aborted) {
 		memset(&wrqu, 0, sizeof(wrqu));
 
 		wireless_send_event(dev, SIOCGIWSCAN, &wrqu, NULL);
@@ -53,8 +61,24 @@ void cfg80211_scan_done(struct cfg80211_
 	dev_put(dev);
 
  out:
+	cfg80211_unlock_rdev(rdev);
 	kfree(request);
 }
+
+void cfg80211_scan_done(struct cfg80211_scan_request *request, bool aborted)
+{
+	struct net_device *dev = dev_get_by_index(&init_net, request->ifidx);
+	if (WARN_ON(!dev)) {
+		kfree(request);
+		return;
+	}
+
+	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
+
+	request->aborted = aborted;
+	schedule_work(&wiphy_to_dev(request->wiphy)->scan_done_wk);
+	dev_put(dev);
+}
 EXPORT_SYMBOL(cfg80211_scan_done);
 
 static void bss_release(struct kref *ref)
--- wireless-testing.orig/net/wireless/nl80211.c	2009-07-07 03:37:05.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-07-07 03:37:06.000000000 +0200
@@ -4029,6 +4029,8 @@ static int nl80211_add_scan_req(struct s
 	struct nlattr *nest;
 	int i;
 
+	ASSERT_RDEV_LOCK(rdev);
+
 	if (WARN_ON(!req))
 		return 0;
 
@@ -4391,12 +4393,12 @@ void nl80211_send_roamed(struct cfg80211
 
 void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
-			       u8 *ie, size_t ie_len, bool from_ap, gfp_t gfp)
+			       const u8 *ie, size_t ie_len, bool from_ap)
 {
 	struct sk_buff *msg;
 	void *hdr;
 
-	msg = nlmsg_new(NLMSG_GOODSIZE, gfp);
+	msg = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (!msg)
 		return;
 
@@ -4420,7 +4422,7 @@ void nl80211_send_disconnected(struct cf
 		return;
 	}
 
-	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, gfp);
+	genlmsg_multicast(msg, 0, nl80211_mlme_mcgrp.id, GFP_KERNEL);
 	return;
 
  nla_put_failure:
--- wireless-testing.orig/net/wireless/ibss.c	2009-07-07 03:37:03.000000000 +0200
+++ wireless-testing/net/wireless/ibss.c	2009-07-07 03:37:06.000000000 +0200
@@ -10,7 +10,7 @@
 #include "nl80211.h"
 
 
-void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
+void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_bss *bss;
@@ -39,22 +39,45 @@ void cfg80211_ibss_joined(struct net_dev
 	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
-	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid, gfp);
+	nl80211_send_ibss_bssid(wiphy_to_dev(wdev->wiphy), dev, bssid,
+				GFP_KERNEL);
 #ifdef CONFIG_WIRELESS_EXT
 	memset(&wrqu, 0, sizeof(wrqu));
 	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 #endif
 }
+
+void cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid, gfp_t gfp)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_event *ev;
+	unsigned long flags;
+
+	ev = kzalloc(sizeof(*ev), gfp);
+	if (!ev)
+		return;
+
+	ev->type = EVENT_IBSS_JOINED;
+	memcpy(ev->cr.bssid, bssid, ETH_ALEN);
+
+	spin_lock_irqsave(&wdev->event_lock, flags);
+	list_add_tail(&ev->list, &wdev->event_list);
+	spin_unlock_irqrestore(&wdev->event_lock, flags);
+	schedule_work(&rdev->event_work);
+}
 EXPORT_SYMBOL(cfg80211_ibss_joined);
 
-int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
-		       struct net_device *dev,
-		       struct cfg80211_ibss_params *params)
+int __cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
+			 struct net_device *dev,
+			 struct cfg80211_ibss_params *params)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (wdev->ssid_len)
 		return -EALREADY;
 
@@ -72,10 +95,26 @@ int cfg80211_join_ibss(struct cfg80211_r
 	return 0;
 }
 
-void cfg80211_clear_ibss(struct net_device *dev, bool nowext)
+int cfg80211_join_ibss(struct cfg80211_registered_device *rdev,
+		       struct net_device *dev,
+		       struct cfg80211_ibss_params *params)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_join_ibss(rdev, dev, params);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
+static void __cfg80211_clear_ibss(struct net_device *dev, bool nowext)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (wdev->current_bss) {
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(&wdev->current_bss->pub);
@@ -89,12 +128,23 @@ void cfg80211_clear_ibss(struct net_devi
 #endif
 }
 
-int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
-			struct net_device *dev, bool nowext)
+void cfg80211_clear_ibss(struct net_device *dev, bool nowext)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	wdev_lock(wdev);
+	__cfg80211_clear_ibss(dev, nowext);
+	wdev_unlock(wdev);
+}
+
+static int __cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
+				 struct net_device *dev, bool nowext)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (!wdev->ssid_len)
 		return -ENOLINK;
 
@@ -103,11 +153,24 @@ int cfg80211_leave_ibss(struct cfg80211_
 	if (err)
 		return err;
 
-	cfg80211_clear_ibss(dev, nowext);
+	__cfg80211_clear_ibss(dev, nowext);
 
 	return 0;
 }
 
+int cfg80211_leave_ibss(struct cfg80211_registered_device *rdev,
+			struct net_device *dev, bool nowext)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	int err;
+
+	wdev_lock(wdev);
+	err = __cfg80211_leave_ibss(rdev, dev, nowext);
+	wdev_unlock(wdev);
+
+	return err;
+}
+
 #ifdef CONFIG_WIRELESS_EXT
 static int cfg80211_ibss_wext_join(struct cfg80211_registered_device *rdev,
 				   struct wireless_dev *wdev)
@@ -184,12 +247,15 @@ int cfg80211_ibss_wext_siwfreq(struct ne
 	if (wdev->wext.ibss.channel == chan)
 		return 0;
 
-	if (wdev->ssid_len) {
-		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
-					  dev, true);
-		if (err)
-			return err;
-	}
+	wdev_lock(wdev);
+	err = 0;
+	if (wdev->ssid_len)
+		err = __cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
+					    dev, true);
+	wdev_unlock(wdev);
+
+	if (err)
+		return err;
 
 	if (chan) {
 		wdev->wext.ibss.channel = chan;
@@ -215,10 +281,12 @@ int cfg80211_ibss_wext_giwfreq(struct ne
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_ADHOC))
 		return -EINVAL;
 
+	wdev_lock(wdev);
 	if (wdev->current_bss)
 		chan = wdev->current_bss->pub.channel;
 	else if (wdev->wext.ibss.channel)
 		chan = wdev->wext.ibss.channel;
+	wdev_unlock(wdev);
 
 	if (chan) {
 		freq->m = chan->center_freq;
@@ -247,12 +315,15 @@ int cfg80211_ibss_wext_siwessid(struct n
 	if (!wiphy_to_dev(wdev->wiphy)->ops->join_ibss)
 		return -EOPNOTSUPP;
 
-	if (wdev->ssid_len) {
-		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
-					  dev, true);
-		if (err)
-			return err;
-	}
+	wdev_lock(wdev);
+	err = 0;
+	if (wdev->ssid_len)
+		err = __cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
+					    dev, true);
+	wdev_unlock(wdev);
+
+	if (err)
+		return err;
 
 	/* iwconfig uses nul termination in SSID.. */
 	if (len > 0 && ssid[len - 1] == '\0')
@@ -279,6 +350,7 @@ int cfg80211_ibss_wext_giwessid(struct n
 
 	data->flags = 0;
 
+	wdev_lock(wdev);
 	if (wdev->ssid_len) {
 		data->flags = 1;
 		data->length = wdev->ssid_len;
@@ -288,6 +360,7 @@ int cfg80211_ibss_wext_giwessid(struct n
 		data->length = wdev->wext.ibss.ssid_len;
 		memcpy(ssid, wdev->wext.ibss.ssid, data->length);
 	}
+	wdev_unlock(wdev);
 
 	return 0;
 }
@@ -325,12 +398,15 @@ int cfg80211_ibss_wext_siwap(struct net_
 	    compare_ether_addr(bssid, wdev->wext.ibss.bssid) == 0)
 		return 0;
 
-	if (wdev->ssid_len) {
-		err = cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
-					  dev, true);
-		if (err)
-			return err;
-	}
+	wdev_lock(wdev);
+	err = 0;
+	if (wdev->ssid_len)
+		err = __cfg80211_leave_ibss(wiphy_to_dev(wdev->wiphy),
+					    dev, true);
+	wdev_unlock(wdev);
+
+	if (err)
+		return err;
 
 	if (bssid) {
 		memcpy(wdev->wext.bssid, bssid, ETH_ALEN);
@@ -355,10 +431,13 @@ int cfg80211_ibss_wext_giwap(struct net_
 
 	ap_addr->sa_family = ARPHRD_ETHER;
 
+	wdev_lock(wdev);
 	if (wdev->current_bss)
 		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
 	else
 		memcpy(ap_addr->sa_data, wdev->wext.ibss.bssid, ETH_ALEN);
+	wdev_unlock(wdev);
+
 	return 0;
 }
 /* temporary symbol - mark GPL - in the future the handler won't be */
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-07-07 03:37:06.000000000 +0200
@@ -15,6 +15,9 @@ static int cfg80211_mgd_wext_connect(str
 {
 	int err;
 
+	ASSERT_RDEV_LOCK(rdev);
+	ASSERT_WDEV_LOCK(wdev);
+
 	if (!netif_running(wdev->netdev))
 		return 0;
 
@@ -24,8 +27,8 @@ static int cfg80211_mgd_wext_connect(str
 
 	err = 0;
 	if (wdev->wext.connect.ssid_len != 0)
-		err = cfg80211_connect(rdev, wdev->netdev,
-					&wdev->wext.connect);
+		err = __cfg80211_connect(rdev, wdev->netdev,
+					 &wdev->wext.connect);
 
 	return err;
 }
@@ -50,33 +53,43 @@ int cfg80211_mgd_wext_siwfreq(struct net
 	if (chan && (chan->flags & IEEE80211_CHAN_DISABLED))
 		return -EINVAL;
 
-	if (wdev->wext.connect.channel == chan)
-		return 0;
+	cfg80211_lock_rdev(rdev);
+	wdev_lock(wdev);
+
+	if (wdev->wext.connect.channel == chan) {
+		err = 0;
+		goto out;
+	}
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
 		bool event = true;
 		/* if SSID set, we'll try right again, avoid event */
 		if (wdev->wext.connect.ssid_len)
 			event = false;
-		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
-					  dev, WLAN_REASON_DEAUTH_LEAVING,
-					  event);
+		err = __cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					    dev, WLAN_REASON_DEAUTH_LEAVING,
+					    event);
 		if (err)
-			return err;
+			goto out;
 	}
 
+
 	wdev->wext.connect.channel = chan;
 
 	/* SSID is not set, we just want to switch channel */
 	if (wdev->wext.connect.ssid_len && chan) {
-		if (!rdev->ops->set_channel)
-			return -EOPNOTSUPP;
-
-		return rdev->ops->set_channel(wdev->wiphy, chan,
-					      NL80211_CHAN_NO_HT);
+		err = -EOPNOTSUPP;
+		if (rdev->ops->set_channel)
+			err = rdev->ops->set_channel(wdev->wiphy, chan,
+						     NL80211_CHAN_NO_HT);
+		goto out;
 	}
 
-	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+	err = cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+ out:
+	wdev_unlock(wdev);
+	cfg80211_unlock_rdev(rdev);
+	return err;
 }
 /* temporary symbol - mark GPL - in the future the handler won't be */
 EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwfreq);
@@ -92,10 +105,12 @@ int cfg80211_mgd_wext_giwfreq(struct net
 	if (WARN_ON(wdev->iftype != NL80211_IFTYPE_STATION))
 		return -EINVAL;
 
+	wdev_lock(wdev);
 	if (wdev->current_bss)
 		chan = wdev->current_bss->pub.channel;
 	else if (wdev->wext.connect.channel)
 		chan = wdev->wext.connect.channel;
+	wdev_unlock(wdev);
 
 	if (chan) {
 		freq->m = chan->center_freq;
@@ -128,21 +143,26 @@ int cfg80211_mgd_wext_siwessid(struct ne
 	if (len > 0 && ssid[len - 1] == '\0')
 		len--;
 
+	cfg80211_lock_rdev(wiphy_to_dev(wdev->wiphy));
+	wdev_lock(wdev);
+
+	err = 0;
+
 	if (wdev->wext.connect.ssid && len &&
 	    len == wdev->wext.connect.ssid_len &&
 	    memcmp(wdev->wext.connect.ssid, ssid, len))
-		return 0;
+		goto out;
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
 		bool event = true;
 		/* if SSID set now, we'll try to connect, avoid event */
 		if (len)
 			event = false;
-		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
-					  dev, WLAN_REASON_DEAUTH_LEAVING,
-					  event);
+		err = __cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					    dev, WLAN_REASON_DEAUTH_LEAVING,
+					    event);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	wdev->wext.connect.ssid = wdev->wext.ssid;
@@ -151,7 +171,11 @@ int cfg80211_mgd_wext_siwessid(struct ne
 
 	wdev->wext.connect.crypto.control_port = false;
 
-	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+	err = cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+ out:
+	wdev_unlock(wdev);
+	cfg80211_unlock_rdev(wiphy_to_dev(wdev->wiphy));
+	return err;
 }
 /* temporary symbol - mark GPL - in the future the handler won't be */
 EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwessid);
@@ -168,6 +192,7 @@ int cfg80211_mgd_wext_giwessid(struct ne
 
 	data->flags = 0;
 
+	wdev_lock(wdev);
 	if (wdev->ssid_len) {
 		data->flags = 1;
 		data->length = wdev->ssid_len;
@@ -178,6 +203,7 @@ int cfg80211_mgd_wext_giwessid(struct ne
 		memcpy(ssid, wdev->wext.connect.ssid, data->length);
 	} else
 		data->flags = 0;
+	wdev_unlock(wdev);
 
 	return 0;
 }
@@ -203,21 +229,25 @@ int cfg80211_mgd_wext_siwap(struct net_d
 	if (is_zero_ether_addr(bssid) || is_broadcast_ether_addr(bssid))
 		bssid = NULL;
 
+	cfg80211_lock_rdev(wiphy_to_dev(wdev->wiphy));
+	wdev_lock(wdev);
+
+	err = 0;
 	/* both automatic */
 	if (!bssid && !wdev->wext.connect.bssid)
-		return 0;
+		goto out;
 
 	/* fixed already - and no change */
 	if (wdev->wext.connect.bssid && bssid &&
 	    compare_ether_addr(bssid, wdev->wext.connect.bssid) == 0)
-		return 0;
+		goto out;
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
-		err = cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
-					  dev, WLAN_REASON_DEAUTH_LEAVING,
-					  false);
+		err = __cfg80211_disconnect(wiphy_to_dev(wdev->wiphy),
+					    dev, WLAN_REASON_DEAUTH_LEAVING,
+					    false);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	if (bssid) {
@@ -226,7 +256,11 @@ int cfg80211_mgd_wext_siwap(struct net_d
 	} else
 		wdev->wext.connect.bssid = NULL;
 
-	return cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+	err = cfg80211_mgd_wext_connect(wiphy_to_dev(wdev->wiphy), wdev);
+ out:
+	wdev_unlock(wdev);
+	cfg80211_unlock_rdev(wiphy_to_dev(wdev->wiphy));
+	return err;
 }
 /* temporary symbol - mark GPL - in the future the handler won't be */
 EXPORT_SYMBOL_GPL(cfg80211_mgd_wext_siwap);
@@ -243,12 +277,14 @@ int cfg80211_mgd_wext_giwap(struct net_d
 
 	ap_addr->sa_family = ARPHRD_ETHER;
 
+	wdev_lock(wdev);
 	if (wdev->current_bss)
 		memcpy(ap_addr->sa_data, wdev->current_bss->pub.bssid, ETH_ALEN);
 	else if (wdev->wext.connect.bssid)
 		memcpy(ap_addr->sa_data, wdev->wext.connect.bssid, ETH_ALEN);
 	else
 		memset(ap_addr->sa_data, 0, ETH_ALEN);
+	wdev_unlock(wdev);
 
 	return 0;
 }
@@ -270,15 +306,20 @@ int cfg80211_wext_siwgenie(struct net_de
 	if (!ie_len)
 		ie = NULL;
 
+	wdev_lock(wdev);
+
 	/* no change */
+	err = 0;
 	if (wdev->wext.ie_len == ie_len &&
 	    memcmp(wdev->wext.ie, ie, ie_len) == 0)
-		return 0;
+		goto out;
 
 	if (ie_len) {
 		ie = kmemdup(extra, ie_len, GFP_KERNEL);
-		if (!ie)
-			return -ENOMEM;
+		if (!ie) {
+			err = -ENOMEM;
+			goto out;
+		}
 	} else
 		ie = NULL;
 
@@ -287,14 +328,17 @@ int cfg80211_wext_siwgenie(struct net_de
 	wdev->wext.ie_len = ie_len;
 
 	if (wdev->sme_state != CFG80211_SME_IDLE) {
-		err = cfg80211_disconnect(rdev, dev,
-					  WLAN_REASON_DEAUTH_LEAVING, false);
+		err = __cfg80211_disconnect(rdev, dev,
+					    WLAN_REASON_DEAUTH_LEAVING, false);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	/* userspace better not think we'll reconnect */
-	return 0;
+	err = 0;
+ out:
+	wdev_unlock(wdev);
+	return err;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwgenie);
 
@@ -305,6 +349,7 @@ int cfg80211_wext_siwmlme(struct net_dev
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct iw_mlme *mlme = (struct iw_mlme *)extra;
 	struct cfg80211_registered_device *rdev;
+	int err;
 
 	if (!wdev)
 		return -EOPNOTSUPP;
@@ -317,13 +362,19 @@ int cfg80211_wext_siwmlme(struct net_dev
 	if (mlme->addr.sa_family != ARPHRD_ETHER)
 		return -EINVAL;
 
+	wdev_lock(wdev);
 	switch (mlme->cmd) {
 	case IW_MLME_DEAUTH:
 	case IW_MLME_DISASSOC:
-		return cfg80211_disconnect(rdev, dev, mlme->reason_code,
-					   true);
+		err = __cfg80211_disconnect(rdev, dev, mlme->reason_code,
+					    true);
+		break;
 	default:
-		return -EOPNOTSUPP;
+		err = -EOPNOTSUPP;
+		break;
 	}
+	wdev_unlock(wdev);
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(cfg80211_wext_siwmlme);
--- wireless-testing.orig/net/mac80211/cfg.c	2009-07-07 03:37:03.000000000 +0200
+++ wireless-testing/net/mac80211/cfg.c	2009-07-07 03:37:06.000000000 +0200
@@ -1182,15 +1182,19 @@ static int ieee80211_assoc(struct wiphy 
 }
 
 static int ieee80211_deauth(struct wiphy *wiphy, struct net_device *dev,
-			    struct cfg80211_deauth_request *req)
+			    struct cfg80211_deauth_request *req,
+			    void *cookie)
 {
-	return ieee80211_mgd_deauth(IEEE80211_DEV_TO_SUB_IF(dev), req);
+	return ieee80211_mgd_deauth(IEEE80211_DEV_TO_SUB_IF(dev),
+				    req, cookie);
 }
 
 static int ieee80211_disassoc(struct wiphy *wiphy, struct net_device *dev,
-			      struct cfg80211_disassoc_request *req)
+			      struct cfg80211_disassoc_request *req,
+			      void *cookie)
 {
-	return ieee80211_mgd_disassoc(IEEE80211_DEV_TO_SUB_IF(dev), req);
+	return ieee80211_mgd_disassoc(IEEE80211_DEV_TO_SUB_IF(dev),
+				      req, cookie);
 }
 
 static int ieee80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
--- wireless-testing.orig/net/mac80211/ieee80211_i.h	2009-07-07 03:37:03.000000000 +0200
+++ wireless-testing/net/mac80211/ieee80211_i.h	2009-07-07 03:37:06.000000000 +0200
@@ -916,9 +916,11 @@ int ieee80211_mgd_auth(struct ieee80211_
 int ieee80211_mgd_assoc(struct ieee80211_sub_if_data *sdata,
 			struct cfg80211_assoc_request *req);
 int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
-			 struct cfg80211_deauth_request *req);
+			 struct cfg80211_deauth_request *req,
+			 void *cookie);
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
-			   struct cfg80211_disassoc_request *req);
+			   struct cfg80211_disassoc_request *req,
+			   void *cookie);
 ieee80211_rx_result ieee80211_sta_rx_mgmt(struct ieee80211_sub_if_data *sdata,
 					  struct sk_buff *skb);
 void ieee80211_send_pspoll(struct ieee80211_local *local,
--- wireless-testing.orig/net/mac80211/mlme.c	2009-07-07 03:37:04.000000000 +0200
+++ wireless-testing/net/mac80211/mlme.c	2009-07-07 03:37:06.000000000 +0200
@@ -386,7 +386,8 @@ static void ieee80211_send_assoc(struct 
 
 
 static void ieee80211_send_deauth_disassoc(struct ieee80211_sub_if_data *sdata,
-					   const u8 *bssid, u16 stype, u16 reason)
+					   const u8 *bssid, u16 stype, u16 reason,
+					   void *cookie)
 {
 	struct ieee80211_local *local = sdata->local;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
@@ -412,9 +413,9 @@ static void ieee80211_send_deauth_disass
 	mgmt->u.deauth.reason_code = cpu_to_le16(reason);
 
 	if (stype == IEEE80211_STYPE_DEAUTH)
-		cfg80211_send_deauth(sdata->dev, (u8 *) mgmt, skb->len);
+		cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len, cookie);
 	else
-		cfg80211_send_disassoc(sdata->dev, (u8 *) mgmt, skb->len);
+		cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len, cookie);
 	ieee80211_tx_skb(sdata, skb, ifmgd->flags & IEEE80211_STA_MFP_ENABLED);
 }
 
@@ -1837,10 +1838,12 @@ static void ieee80211_sta_rx_queued_mgmt
 			/* no action */
 			break;
 		case RX_MGMT_CFG80211_DEAUTH:
-			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len);
+			cfg80211_send_deauth(sdata->dev, (u8 *)mgmt, skb->len,
+					     NULL);
 			break;
 		case RX_MGMT_CFG80211_DISASSOC:
-			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len);
+			cfg80211_send_disassoc(sdata->dev, (u8 *)mgmt, skb->len,
+					       NULL);
 			break;
 		default:
 			WARN(1, "unexpected: %d", rma);
@@ -2273,7 +2276,8 @@ int ieee80211_mgd_assoc(struct ieee80211
 }
 
 int ieee80211_mgd_deauth(struct ieee80211_sub_if_data *sdata,
-			 struct cfg80211_deauth_request *req)
+			 struct cfg80211_deauth_request *req,
+			 void *cookie)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 	struct ieee80211_mgd_work *wk;
@@ -2305,13 +2309,15 @@ int ieee80211_mgd_deauth(struct ieee8021
 	mutex_unlock(&ifmgd->mtx);
 
 	ieee80211_send_deauth_disassoc(sdata, bssid,
-			IEEE80211_STYPE_DEAUTH, req->reason_code);
+			IEEE80211_STYPE_DEAUTH, req->reason_code,
+			cookie);
 
 	return 0;
 }
 
 int ieee80211_mgd_disassoc(struct ieee80211_sub_if_data *sdata,
-			   struct cfg80211_disassoc_request *req)
+			   struct cfg80211_disassoc_request *req,
+			   void *cookie)
 {
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
@@ -2331,6 +2337,7 @@ int ieee80211_mgd_disassoc(struct ieee80
 	mutex_unlock(&ifmgd->mtx);
 
 	ieee80211_send_deauth_disassoc(sdata, req->bss->bssid,
-			IEEE80211_STYPE_DISASSOC, req->reason_code);
+			IEEE80211_STYPE_DISASSOC, req->reason_code,
+			cookie);
 	return 0;
 }
--- wireless-testing.orig/net/wireless/nl80211.h	2009-07-07 03:29:39.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.h	2009-07-07 03:37:06.000000000 +0200
@@ -42,7 +42,7 @@ void nl80211_send_roamed(struct cfg80211
 			 const u8 *resp_ie, size_t resp_ie_len, gfp_t gfp);
 void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 			       struct net_device *netdev, u16 reason,
-			       u8 *ie, size_t ie_len, bool from_ap, gfp_t gfp);
+			       const u8 *ie, size_t ie_len, bool from_ap);
 
 void
 nl80211_michael_mic_failure(struct cfg80211_registered_device *rdev,

-- 

