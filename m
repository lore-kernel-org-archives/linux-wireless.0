Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.24]:14754 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbZHSAEm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2009 20:04:42 -0400
Received: by ey-out-2122.google.com with SMTP id 22so862866eye.37
        for <linux-wireless@vger.kernel.org>; Tue, 18 Aug 2009 17:04:43 -0700 (PDT)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 5/5] cfg80211: scan before connect if we don't have the bss
Date: Wed, 19 Aug 2009 01:04:13 +0100
Message-Id: <1250640253-18434-6-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The connect_result callback relies on cfg80211 having the bss
information (via beacons/probes). For a fullmac driver, this information
is only likely to be present after a scan. Userspace is not guaranteed
to scan before connecting (e.g. wpa_supplicant ap_scan=2 in wext mode),
so before calling ->connect do an explicit ->scan if we don't have the
bss in our list.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 net/wireless/sme.c |  150 ++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 110 insertions(+), 40 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 9ddc00e..6dc7981 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -26,11 +26,13 @@ struct cfg80211_conn {
 		CFG80211_CONN_AUTHENTICATING,
 		CFG80211_CONN_ASSOCIATE_NEXT,
 		CFG80211_CONN_ASSOCIATING,
+		CFG80211_CONN_DELAYED_CONNECT,
 	} state;
 	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 *ie;
 	size_t ie_len;
 	bool auto_auth, prev_bssid_valid;
+	bool connect_after_scan;
 };
 
 
@@ -148,6 +150,19 @@ static int cfg80211_conn_do_work(struct wireless_dev *wdev)
 					       NULL, 0,
 					       WLAN_REASON_DEAUTH_LEAVING);
 		return err;
+	case CFG80211_CONN_DELAYED_CONNECT:
+		BUG_ON(!rdev->ops->connect);
+		err = rdev->ops->connect(&rdev->wiphy, wdev->netdev,
+					 &wdev->conn->params);
+		kfree(wdev->conn->ie);
+		kfree(wdev->conn);
+		wdev->conn = NULL;
+		if (err) {
+			wdev->connect_keys = NULL;
+			wdev->sme_state = CFG80211_SME_IDLE;
+			wdev->ssid_len = 0;
+		}
+		return err;
 	default:
 		return 0;
 	}
@@ -234,6 +249,12 @@ static void __cfg80211_sme_scan_done(struct net_device *dev)
 	    wdev->conn->state != CFG80211_CONN_SCAN_AGAIN)
 		return;
 
+	if (wdev->conn->connect_after_scan) {
+		wdev->conn->state = CFG80211_CONN_DELAYED_CONNECT;
+		schedule_work(&rdev->conn_work);
+		return;
+	}
+
 	if (!cfg80211_get_conn_bss(wdev)) {
 		/* not found */
 		if (wdev->conn->state == CFG80211_CONN_SCAN_AGAIN)
@@ -655,6 +676,52 @@ void cfg80211_disconnected(struct net_device *dev, u16 reason,
 }
 EXPORT_SYMBOL(cfg80211_disconnected);
 
+static int cfg80211_conn_clone(struct wireless_dev *wdev,
+			       struct cfg80211_connect_params *connect)
+{
+	if (WARN_ON(wdev->conn))
+		return -EINPROGRESS;
+
+	wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);
+	if (!wdev->conn)
+		return -ENOMEM;
+
+	memcpy(&wdev->conn->params, connect, sizeof(*connect));
+	if (connect->bssid) {
+		wdev->conn->params.bssid = wdev->conn->bssid;
+		memcpy(wdev->conn->bssid, connect->bssid, ETH_ALEN);
+	}
+
+	if (connect->ie) {
+		wdev->conn->ie = kmemdup(connect->ie, connect->ie_len,
+					 GFP_KERNEL);
+		wdev->conn->params.ie = wdev->conn->ie;
+		if (!wdev->conn->ie) {
+			kfree(wdev->conn);
+			wdev->conn = NULL;
+			return -ENOMEM;
+		}
+	}
+
+	if (connect->auth_type == NL80211_AUTHTYPE_AUTOMATIC) {
+		wdev->conn->auto_auth = true;
+		/* start with open system ... should mostly work */
+		wdev->conn->params.auth_type =
+			NL80211_AUTHTYPE_OPEN_SYSTEM;
+	} else {
+		wdev->conn->auto_auth = false;
+	}
+
+	memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
+	wdev->ssid_len = connect->ssid_len;
+	wdev->conn->params.ssid = wdev->ssid;
+	wdev->conn->params.ssid_len = connect->ssid_len;
+
+	wdev->conn->connect_after_scan = false;
+
+	return 0;
+}
+
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct cfg80211_connect_params *connect,
@@ -710,46 +777,12 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 		if (!rdev->ops->auth || !rdev->ops->assoc)
 			return -EOPNOTSUPP;
 
-		if (WARN_ON(wdev->conn))
-			return -EINPROGRESS;
-
-		wdev->conn = kzalloc(sizeof(*wdev->conn), GFP_KERNEL);
-		if (!wdev->conn)
-			return -ENOMEM;
-
 		/*
 		 * Copy all parameters, and treat explicitly IEs, BSSID, SSID.
 		 */
-		memcpy(&wdev->conn->params, connect, sizeof(*connect));
-		if (connect->bssid) {
-			wdev->conn->params.bssid = wdev->conn->bssid;
-			memcpy(wdev->conn->bssid, connect->bssid, ETH_ALEN);
-		}
-
-		if (connect->ie) {
-			wdev->conn->ie = kmemdup(connect->ie, connect->ie_len,
-						GFP_KERNEL);
-			wdev->conn->params.ie = wdev->conn->ie;
-			if (!wdev->conn->ie) {
-				kfree(wdev->conn);
-				wdev->conn = NULL;
-				return -ENOMEM;
-			}
-		}
-
-		if (connect->auth_type == NL80211_AUTHTYPE_AUTOMATIC) {
-			wdev->conn->auto_auth = true;
-			/* start with open system ... should mostly work */
-			wdev->conn->params.auth_type =
-				NL80211_AUTHTYPE_OPEN_SYSTEM;
-		} else {
-			wdev->conn->auto_auth = false;
-		}
-
-		memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
-		wdev->ssid_len = connect->ssid_len;
-		wdev->conn->params.ssid = wdev->ssid;
-		wdev->conn->params.ssid_len = connect->ssid_len;
+		err = cfg80211_conn_clone(wdev, connect);
+		if (err)
+			return err;
 
 		/* don't care about result -- but fill bssid & channel */
 		if (!wdev->conn->params.bssid || !wdev->conn->params.channel)
@@ -791,18 +824,55 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 
 		return err;
 	} else {
+		struct cfg80211_bss *bss;
+
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 		wdev->connect_keys = connkeys;
+
+		bss = cfg80211_get_bss(wdev->wiphy, NULL, connect->bssid,
+				       connect->ssid, connect->ssid_len,
+				       WLAN_CAPABILITY_ESS,
+				       WLAN_CAPABILITY_ESS);
+		if (!bss) {
+			/* We don't have a matching BSS.
+			 *
+			 * This means __connect_result will fail,
+			 * unless the driver provides scan results
+			 * between now and then. So do an explicit
+			 * scan, and try connect later.
+			 */
+			err = cfg80211_conn_clone(wdev, connect);
+			if (!err) {
+				wdev->conn->connect_after_scan = true;
+				err = cfg80211_conn_scan(wdev);
+
+				if (!err)
+					return 0;
+			}
+
+			/* Failed to clone (or scan), so we can't
+			 * delay the connect. Free everything up and
+			 * go ahead with the connect */
+			if (wdev->conn)
+				kfree(wdev->conn->ie);
+			kfree(wdev->conn);
+			wdev->conn = NULL;
+
+		} else {
+			cfg80211_put_bss(bss);
+
+			memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
+			wdev->ssid_len = connect->ssid_len;
+		}
+
 		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
 		if (err) {
 			wdev->connect_keys = NULL;
 			wdev->sme_state = CFG80211_SME_IDLE;
+			wdev->ssid_len = 0;
 			return err;
 		}
 
-		memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
-		wdev->ssid_len = connect->ssid_len;
-
 		return 0;
 	}
 }
-- 
1.6.3.3

