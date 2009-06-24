Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756259AbZFXMJi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Jun 2009 08:09:38 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.69)
	(envelope-from <johannes@sipsolutions.net>)
	id 1MJRIG-0002yH-LK
	for linux-wireless@vger.kernel.org; Wed, 24 Jun 2009 14:09:40 +0200
Message-Id: <20090624120808.684168831@sipsolutions.net>
References: <20090624120745.239294066@sipsolutions.net>
Date: Wed, 24 Jun 2009 14:07:47 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC 02/11] cfg80211: emulate connect with auth/assoc
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds code to cfg80211 so that drivers (mac80211 right
now) that don't implement connect but rather auth/assoc can
still be used with the nl80211 connect command. This will
also be necessary for the wext compat code.

Signed-off-by: Samuel Ortiz <samuel.ortiz@intel.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h |   17 ++
 net/wireless/core.c    |    3 
 net/wireless/core.h    |    7 +
 net/wireless/mlme.c    |   94 ++++++++++++---
 net/wireless/nl80211.c |    4 
 net/wireless/scan.c    |    7 +
 net/wireless/sme.c     |  299 ++++++++++++++++++++++++++++++++++++++++++++++---
 7 files changed, 399 insertions(+), 32 deletions(-)

--- wireless-testing.orig/net/wireless/core.h	2009-06-24 13:54:05.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-06-24 13:54:06.000000000 +0200
@@ -58,6 +58,8 @@ struct cfg80211_registered_device {
 	struct cfg80211_scan_request *scan_req; /* protected by RTNL */
 	unsigned long suspend_at;
 
+	struct work_struct conn_work;
+
 #ifdef CONFIG_CFG80211_DEBUGFS
 	/* Debugfs entries */
 	struct wiphy_debugfsdentries {
@@ -177,8 +179,13 @@ int cfg80211_connect(struct cfg80211_reg
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason);
 
+void cfg80211_conn_work(struct work_struct *work);
+
 /* internal helpers */
 int cfg80211_validate_key_settings(struct key_params *params, int key_idx,
 				   const u8 *mac_addr);
+void __cfg80211_disconnected(struct net_device *dev, gfp_t gfp, u8 *ie,
+			     size_t ie_len, u16 reason, bool from_ap);
+void cfg80211_sme_scan_done(struct net_device *dev);
 
 #endif /* __NET_WIRELESS_CORE_H */
--- wireless-testing.orig/net/wireless/nl80211.c	2009-06-24 13:54:05.000000000 +0200
+++ wireless-testing/net/wireless/nl80211.c	2009-06-24 13:54:06.000000000 +0200
@@ -349,12 +349,12 @@ static int nl80211_send_wiphy(struct sk_
 
 #undef CMD
 
-	if (dev->ops->connect) {
+	if (dev->ops->connect || dev->ops->auth) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_CONNECT);
 	}
 
-	if (dev->ops->disconnect) {
+	if (dev->ops->disconnect || dev->ops->deauth) {
 		i++;
 		NLA_PUT_U32(msg, i, NL80211_CMD_DISCONNECT);
 	}
--- wireless-testing.orig/net/wireless/sme.c	2009-06-24 13:54:05.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-06-24 13:54:06.000000000 +0200
@@ -12,6 +12,198 @@
 #include <net/rtnetlink.h>
 #include "nl80211.h"
 
+static int cfg80211_conn_scan(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_scan_request *request;
+	int n_channels, err;
+
+	ASSERT_RTNL();
+
+	if (drv->scan_req)
+		return -EBUSY;
+
+	if (wdev->conn.params.channel) {
+		n_channels = 1;
+	} else {
+		enum ieee80211_band band;
+		n_channels = 0;
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			if (!wdev->wiphy->bands[band])
+				continue;
+			n_channels += wdev->wiphy->bands[band]->n_channels;
+		}
+	}
+	request = kzalloc(sizeof(*request) + sizeof(request->ssids[0]) +
+			  sizeof(request->channels[0]) * n_channels,
+			  GFP_KERNEL);
+	if (!request)
+		return -ENOMEM;
+
+	request->channels = (void *)((char *)request + sizeof(*request));
+	if (wdev->conn.params.channel)
+		request->channels[0] = wdev->conn.params.channel;
+	else {
+		int i = 0, j;
+		enum ieee80211_band band;
+
+		for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+			if (!wdev->wiphy->bands[band])
+				continue;
+			for (j = 0; j < wdev->wiphy->bands[band]->n_channels;
+			     i++, j++)
+				request->channels[i] =
+					&wdev->wiphy->bands[band]->channels[j];
+		}
+	}
+	request->n_channels = n_channels;
+	request->ssids = (void *)(request->channels + n_channels);
+	request->n_ssids = 1;
+
+	memcpy(request->ssids[0].ssid, wdev->conn.params.ssid,
+		wdev->conn.params.ssid_len);
+	request->ssids[0].ssid_len = wdev->conn.params.ssid_len;
+
+	request->ifidx = wdev->netdev->ifindex;
+	request->wiphy = &drv->wiphy;
+
+	drv->scan_req = request;
+
+	err = drv->ops->scan(wdev->wiphy, wdev->netdev, request);
+	if (!err) {
+		wdev->conn.state = CFG80211_CONN_SCANNING;
+		nl80211_send_scan_start(drv, wdev->netdev);
+	} else {
+		drv->scan_req = NULL;
+		kfree(request);
+	}
+	return err;
+}
+
+static int cfg80211_conn_do_work(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+	int err;
+	union {
+		struct cfg80211_auth_request auth_req;
+		struct cfg80211_assoc_request assoc_req;
+	} u;
+
+	memset(&u, 0, sizeof(u));
+
+	switch (wdev->conn.state) {
+	case CFG80211_CONN_SCAN_AGAIN:
+		return cfg80211_conn_scan(wdev);
+	case CFG80211_CONN_AUTHENTICATE_NEXT:
+		u.auth_req.chan = wdev->conn.params.channel;
+		u.auth_req.peer_addr = wdev->conn.params.bssid;
+		u.auth_req.ssid = wdev->conn.params.ssid;
+		u.auth_req.ssid_len = wdev->conn.params.ssid_len;
+		u.auth_req.auth_type = wdev->conn.params.auth_type;
+		u.auth_req.ie = NULL;
+		u.auth_req.ie_len = 0;
+		err = drv->ops->auth(wdev->wiphy, wdev->netdev, &u.auth_req);
+		if (!err)
+			wdev->conn.state = CFG80211_CONN_AUTHENTICATING;
+		return err;
+	case CFG80211_CONN_ASSOCIATE_NEXT:
+		u.assoc_req.chan = wdev->conn.params.channel;
+		u.assoc_req.peer_addr = wdev->conn.params.bssid;
+		u.assoc_req.ssid = wdev->conn.params.ssid;
+		u.assoc_req.ssid_len = wdev->conn.params.ssid_len;
+		u.assoc_req.ie = wdev->conn.params.ie;
+		u.assoc_req.ie_len = wdev->conn.params.ie_len;
+		u.assoc_req.use_mfp = false;
+		u.assoc_req.control_port = wdev->conn.params.control_port;
+		err = drv->ops->assoc(wdev->wiphy, wdev->netdev,
+				      &u.assoc_req);
+		if (!err)
+			wdev->conn.state = CFG80211_CONN_ASSOCIATING;
+		return err;
+	default:
+		return 0;
+	}
+}
+
+void cfg80211_conn_work(struct work_struct *work)
+{
+	struct cfg80211_registered_device *drv =
+		container_of(work, struct cfg80211_registered_device, conn_work);
+	struct wireless_dev *wdev;
+
+	rtnl_lock();
+	mutex_lock(&drv->devlist_mtx);
+
+	list_for_each_entry(wdev, &drv->netdev_list, list) {
+		if (!netif_running(wdev->netdev))
+			continue;
+		if (wdev->sme_state != CFG80211_SME_CONNECTING)
+			continue;
+		if (cfg80211_conn_do_work(wdev))
+			cfg80211_connect_result(wdev->netdev,
+						wdev->conn.params.bssid,
+						NULL, 0,
+						WLAN_STATUS_UNSPECIFIED_FAILURE,
+						GFP_ATOMIC);
+	}
+
+	mutex_unlock(&drv->devlist_mtx);
+	rtnl_unlock();
+}
+
+static bool cfg80211_get_conn_bss(struct wireless_dev *wdev)
+{
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_bss *bss;
+	u16 capa = WLAN_CAPABILITY_ESS;
+
+	if (wdev->conn.params.privacy)
+		capa |= WLAN_CAPABILITY_PRIVACY;
+
+	bss = cfg80211_get_bss(wdev->wiphy, NULL, wdev->conn.params.bssid,
+			       wdev->conn.params.ssid,
+			       wdev->conn.params.ssid_len,
+			       WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
+			       capa);
+
+	if (!bss)
+		return false;
+
+	memcpy(wdev->conn.bssid, bss->bssid, ETH_ALEN);
+	wdev->conn.params.bssid = wdev->conn.bssid;
+	wdev->conn.params.channel = bss->channel;
+	wdev->conn.state = CFG80211_CONN_AUTHENTICATE_NEXT;
+	schedule_work(&drv->conn_work);
+
+	cfg80211_put_bss(bss);
+	return true;
+}
+
+void cfg80211_sme_scan_done(struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct cfg80211_registered_device *drv = wiphy_to_dev(wdev->wiphy);
+
+	if (wdev->sme_state != CFG80211_SME_CONNECTING)
+		return;
+
+	if (wdev->conn.state != CFG80211_CONN_SCANNING &&
+	    wdev->conn.state != CFG80211_CONN_SCAN_AGAIN)
+		return;
+
+	if (!cfg80211_get_conn_bss(wdev)) {
+		/* not found */
+		if (wdev->conn.state == CFG80211_CONN_SCAN_AGAIN)
+			schedule_work(&drv->conn_work);
+		else
+			cfg80211_connect_result(dev, wdev->conn.params.bssid,
+						NULL, 0,
+						WLAN_STATUS_UNSPECIFIED_FAILURE,
+						GFP_ATOMIC);
+		return;
+	}
+}
 
 void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			     u8 *ie, size_t ie_len, u16 status, gfp_t gfp)
@@ -63,7 +255,7 @@ void cfg80211_connect_result(struct net_
 
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-	if (bssid)
+	if (bssid && status == WLAN_STATUS_SUCCESS)
 		memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
 	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 #endif
@@ -122,9 +314,8 @@ void cfg80211_roamed(struct net_device *
 }
 EXPORT_SYMBOL(cfg80211_roamed);
 
-static void __cfg80211_disconnected(struct net_device *dev, gfp_t gfp,
-				    u8 *ie, size_t ie_len, u16 reason,
-				    bool from_ap)
+void __cfg80211_disconnected(struct net_device *dev, gfp_t gfp, u8 *ie,
+			     size_t ie_len, u16 reason, bool from_ap)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 #ifdef CONFIG_WIRELESS_EXT
@@ -145,6 +336,9 @@ static void __cfg80211_disconnected(stru
 	wdev->current_bss = NULL;
 	wdev->sme_state = CFG80211_SME_IDLE;
 
+	kfree(wdev->conn.ie);
+	wdev->conn.ie = NULL;
+
 	nl80211_send_disconnected(wiphy_to_dev(wdev->wiphy), dev,
 				  reason, ie, ie_len, from_ap, gfp);
 
@@ -158,7 +352,7 @@ static void __cfg80211_disconnected(stru
 void cfg80211_disconnected(struct net_device *dev, u16 reason,
 			   u8 *ie, size_t ie_len, gfp_t gfp)
 {
-	__cfg80211_disconnected(dev, reason, ie, ie_len, true, gfp);
+	__cfg80211_disconnected(dev, gfp, ie, ie_len, reason, true);
 }
 EXPORT_SYMBOL(cfg80211_disconnected);
 
@@ -173,34 +367,113 @@ int cfg80211_connect(struct cfg80211_reg
 		return -EALREADY;
 
 	if (!rdev->ops->connect) {
-		return -EOPNOTSUPP;
+		if (!rdev->ops->auth || !rdev->ops->assoc)
+			return -EOPNOTSUPP;
+
+		/*
+		 * Keep the IEs, BSSID, SSID
+		 */
+		memcpy(&wdev->conn.params, connect, sizeof(*connect));
+		if (connect->bssid) {
+			wdev->conn.params.bssid = wdev->conn.bssid;
+			memcpy(wdev->conn.bssid, connect->bssid, ETH_ALEN);
+		}
+
+		if (connect->ie) {
+			wdev->conn.ie = kmemdup(connect->ie, connect->ie_len,
+						GFP_KERNEL);
+			wdev->conn.params.ie = wdev->conn.ie;
+			if (!wdev->conn.ie)
+				return -ENOMEM;
+		}
+
+		memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
+		wdev->ssid_len = connect->ssid_len;
+		wdev->conn.params.ssid = wdev->ssid;
+		wdev->conn.params.ssid_len = connect->ssid_len;
+
+		/* don't care about result -- but fill bssid & channel */
+		if (!wdev->conn.params.bssid || !wdev->conn.params.channel)
+			cfg80211_get_conn_bss(wdev);
+
+		/* we're good if we have both BSSID and channel */
+		if (wdev->conn.params.bssid && wdev->conn.params.channel) {
+			wdev->conn.state = CFG80211_CONN_AUTHENTICATE_NEXT;
+			err = cfg80211_conn_do_work(wdev);
+		} else {
+			/* otherwise we'll need to scan for the AP first */
+			err = cfg80211_conn_scan(wdev);
+			/*
+			 * If we can't scan right now, then we need to scan again
+			 * after the current scan finished, since the parameters
+			 * changed (unless we find a good AP anyway).
+			 */
+			if (err == -EBUSY) {
+				err = 0;
+				wdev->conn.state = CFG80211_CONN_SCAN_AGAIN;
+			}
+		}
+		if (!err)
+			wdev->sme_state = CFG80211_SME_CONNECTING;
+
+		return err;
 	} else {
 		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
 		if (err)
 			return err;
-		wdev->sme_state = CFG80211_SME_CONNECTING;
-	}
 
-	memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
-	wdev->ssid_len = connect->ssid_len;
+		memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
+		wdev->ssid_len = connect->ssid_len;
 
-	return 0;
+		return 0;
+	}
 }
 
 int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 			struct net_device *dev, u16 reason)
 {
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	int err;
 
+	if (wdev->sme_state == CFG80211_SME_IDLE)
+		return -EINVAL;
+
 	if (!rdev->ops->disconnect) {
-		return -EOPNOTSUPP;
+		struct cfg80211_deauth_request deauth;
+		u8 bssid[ETH_ALEN];
+
+		if (wdev->sme_state == CFG80211_SME_CONNECTING &&
+		    (wdev->conn.state == CFG80211_CONN_SCANNING ||
+		     wdev->conn.state == CFG80211_CONN_SCAN_AGAIN)) {
+			wdev->sme_state = CFG80211_SME_IDLE;
+			return 0;
+		}
+
+		if (!rdev->ops->deauth)
+			return -EOPNOTSUPP;
+
+		memset(&deauth, 0, sizeof(deauth));
+
+		/* wdev->conn.params.bssid must be set if > SCANNING */
+		memcpy(bssid, wdev->conn.params.bssid, ETH_ALEN);
+		deauth.peer_addr = bssid;
+		deauth.reason_code = reason;
+
+		err = rdev->ops->deauth(&rdev->wiphy, dev, &deauth);
+		if (err)
+			return err;
 	} else {
 		err = rdev->ops->disconnect(&rdev->wiphy, dev, reason);
 		if (err)
 			return err;
 	}
 
-	__cfg80211_disconnected(dev, 0, NULL, 0, false, GFP_KERNEL);
+	if (wdev->sme_state == CFG80211_SME_CONNECTED)
+		__cfg80211_disconnected(dev, GFP_KERNEL, NULL, 0, 0, false);
+	else if (wdev->sme_state == CFG80211_SME_CONNECTING)
+		cfg80211_connect_result(dev, NULL, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE,
+					GFP_KERNEL);
 
 	return 0;
 }
--- wireless-testing.orig/net/wireless/mlme.c	2009-06-24 13:54:04.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-06-24 13:54:06.000000000 +0200
@@ -14,51 +14,110 @@
 
 void cfg80211_send_rx_auth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	u16 status_code;
+	struct ieee80211_mgmt *mgmt;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	mgmt = (struct ieee80211_mgmt *)buf;
+	status_code = le16_to_cpu(mgmt->u.auth.status_code);
+
 	nl80211_send_rx_auth(rdev, dev, buf, len, gfp);
+
+	if (status_code != WLAN_STATUS_SUCCESS)
+		wdev->sme_state = CFG80211_SME_IDLE;
+	else if (wdev->sme_state == CFG80211_SME_CONNECTING &&
+		 wdev->conn.state == CFG80211_CONN_AUTHENTICATING) {
+		wdev->conn.state = CFG80211_CONN_ASSOCIATE_NEXT;
+		schedule_work(&rdev->conn_work);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_rx_auth);
 
 void cfg80211_send_rx_assoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
-	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	u16 status_code;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
+	u8 *ie = mgmt->u.assoc_resp.variable;
+	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
+
+	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
+
 	nl80211_send_rx_assoc(rdev, dev, buf, len, gfp);
+
+	if (wdev->sme_state == CFG80211_SME_CONNECTING)
+		cfg80211_connect_result(dev, mgmt->bssid, ie, len - ieoffs,
+					status_code, gfp);
+	if (status_code != WLAN_STATUS_SUCCESS) {
+		/* XXX: try other auth algs? */
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);
 
 void cfg80211_send_deauth(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
+
 	nl80211_send_deauth(rdev, dev, buf, len, gfp);
+
+	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
+		u16 reason_code;
+		bool from_ap;
+
+		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
+		from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
+		__cfg80211_disconnected(dev, gfp, NULL, 0,
+					reason_code, from_ap);
+	} else if (wdev->sme_state == CFG80211_SME_CONNECTING) {
+		cfg80211_connect_result(dev, mgmt->bssid, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
+	}
 }
 EXPORT_SYMBOL(cfg80211_send_deauth);
 
 void cfg80211_send_disassoc(struct net_device *dev, const u8 *buf, size_t len, gfp_t gfp)
 {
-	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	struct wiphy *wiphy = wdev->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)buf;
+	u8 *ie = mgmt->u.assoc_resp.variable;
+	int ieoffs = offsetof(struct ieee80211_mgmt, u.assoc_resp.variable);
+
 	nl80211_send_disassoc(rdev, dev, buf, len, gfp);
-}
-EXPORT_SYMBOL(cfg80211_send_disassoc);
 
-static void cfg80211_wext_disconnected(struct net_device *dev)
-{
-#ifdef CONFIG_WIRELESS_EXT
-	union iwreq_data wrqu;
-	memset(&wrqu, 0, sizeof(wrqu));
-	wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
-#endif
+	if (wdev->sme_state == CFG80211_SME_CONNECTED) {
+		u16 reason_code;
+		bool from_ap;
+
+		reason_code = le16_to_cpu(mgmt->u.deauth.reason_code);
+
+		from_ap = memcmp(mgmt->da, dev->dev_addr, ETH_ALEN) == 0;
+		__cfg80211_disconnected(dev, gfp, ie, len - ieoffs,
+					reason_code, from_ap);
+
+		wdev->sme_state = CFG80211_SME_IDLE;
+	}
 }
+EXPORT_SYMBOL(cfg80211_send_disassoc);
 
 void cfg80211_send_auth_timeout(struct net_device *dev, const u8 *addr, gfp_t gfp)
 {
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	nl80211_send_auth_timeout(rdev, dev, addr, gfp);
-	cfg80211_wext_disconnected(dev);
+	if (dev->ieee80211_ptr->sme_state == CFG80211_SME_CONNECTING)
+		cfg80211_connect_result(dev, addr, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
+	dev->ieee80211_ptr->sme_state = CFG80211_SME_IDLE;
 }
 EXPORT_SYMBOL(cfg80211_send_auth_timeout);
 
@@ -67,7 +126,10 @@ void cfg80211_send_assoc_timeout(struct 
 	struct wiphy *wiphy = dev->ieee80211_ptr->wiphy;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
 	nl80211_send_assoc_timeout(rdev, dev, addr, gfp);
-	cfg80211_wext_disconnected(dev);
+	if (dev->ieee80211_ptr->sme_state == CFG80211_SME_CONNECTING)
+		cfg80211_connect_result(dev, addr, NULL, 0,
+					WLAN_STATUS_UNSPECIFIED_FAILURE, gfp);
+	dev->ieee80211_ptr->sme_state = CFG80211_SME_IDLE;
 }
 EXPORT_SYMBOL(cfg80211_send_assoc_timeout);
 
--- wireless-testing.orig/net/wireless/core.c	2009-06-24 13:54:05.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-06-24 13:54:06.000000000 +0200
@@ -321,6 +321,7 @@ struct wiphy *wiphy_new(const struct cfg
 	}
 
 	INIT_WORK(&drv->rfkill_sync, cfg80211_rfkill_sync_work);
+	INIT_WORK(&drv->conn_work, cfg80211_conn_work);
 
 	/*
 	 * Initialize wiphy parameters to IEEE 802.11 MIB default values.
@@ -481,6 +482,8 @@ void wiphy_unregister(struct wiphy *wiph
 	/* unlock again before freeing */
 	mutex_unlock(&drv->mtx);
 
+	cancel_work_sync(&drv->conn_work);
+
 	cfg80211_debugfs_drv_del(drv);
 
 	/* If this device got a regulatory hint tell core its
--- wireless-testing.orig/include/net/cfg80211.h	2009-06-24 13:54:05.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-06-24 13:54:06.000000000 +0200
@@ -1218,9 +1218,24 @@ struct wireless_dev {
 	u8 ssid_len;
 	enum {
 		CFG80211_SME_IDLE,
-		CFG80211_SME_CONNECTING, /* ->connect called */
+		CFG80211_SME_CONNECTING,
 		CFG80211_SME_CONNECTED,
 	} sme_state;
+	struct {
+		struct cfg80211_connect_params params;
+		/* these are sub-states of the _CONNECTING sme_state */
+		enum {
+			CFG80211_CONN_SCANNING,
+			CFG80211_CONN_SCAN_AGAIN,
+			CFG80211_CONN_AUTHENTICATE_NEXT,
+			CFG80211_CONN_AUTHENTICATING,
+			CFG80211_CONN_ASSOCIATE_NEXT,
+			CFG80211_CONN_ASSOCIATING,
+		} state;
+		u8 bssid[ETH_ALEN];
+		u8 *ie;
+		size_t ie_len;
+	} conn;
 
 #ifdef CONFIG_WIRELESS_EXT
 	/* wext data */
--- wireless-testing.orig/net/wireless/scan.c	2009-06-24 13:53:13.000000000 +0200
+++ wireless-testing/net/wireless/scan.c	2009-06-24 13:54:06.000000000 +0200
@@ -30,6 +30,13 @@ void cfg80211_scan_done(struct cfg80211_
 
 	WARN_ON(request != wiphy_to_dev(request->wiphy)->scan_req);
 
+	/*
+	 * This must be before sending the other events!
+	 * Otherwise, wpa_supplicant gets completely confused with
+	 * wext events.
+	 */
+	cfg80211_sme_scan_done(dev);
+
 	if (aborted)
 		nl80211_send_scan_aborted(wiphy_to_dev(request->wiphy), dev);
 	else

-- 

