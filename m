Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:54786 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757785AbZHGMvI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 08:51:08 -0400
Subject: [PATCH] cfg80211: use reassociation when possible
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 14:51:05 +0200
Message-Id: <1249649465.7194.1.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With the move of everything related to the SME from
mac80211 to cfg80211, we lost the ability to send
reassociation frames. This adds them back, but only
for wireless extensions. With the userspace SME, it
shall control assoc vs. reassoc (it already can do
so with the nl80211 interface).

I haven't touched the connect() implementation, so
it is not possible to reassociate with the nl80211
connect primitive. I think that should be done with
the NL80211_CMD_ROAM command, but we'll have to see
how that can be handled in the future, especially
with fullmac chips.

This patch addresses only the immediate regression
we had in mac80211, which previously sent reassoc.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/cfg80211.h  |    4 +--
 net/wireless/core.h     |    4 ++-
 net/wireless/mlme.c     |   11 +++++++++
 net/wireless/sme.c      |   54 +++++++++++++++++++++++++++++++++++++-----------
 net/wireless/wext-sme.c |    8 ++++++-
 5 files changed, 65 insertions(+), 16 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-08-07 14:47:53.000000000 +0200
+++ wireless-testing/net/wireless/sme.c	2009-08-07 14:48:34.000000000 +0200
@@ -27,10 +27,10 @@ struct cfg80211_conn {
 		CFG80211_CONN_ASSOCIATE_NEXT,
 		CFG80211_CONN_ASSOCIATING,
 	} state;
-	u8 bssid[ETH_ALEN];
+	u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 	u8 *ie;
 	size_t ie_len;
-	bool auto_auth;
+	bool auto_auth, prev_bssid_valid;
 };
 
 
@@ -110,6 +110,7 @@ static int cfg80211_conn_do_work(struct 
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_connect_params *params;
+	const u8 *prev_bssid = NULL;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -135,15 +136,11 @@ static int cfg80211_conn_do_work(struct 
 	case CFG80211_CONN_ASSOCIATE_NEXT:
 		BUG_ON(!rdev->ops->assoc);
 		wdev->conn->state = CFG80211_CONN_ASSOCIATING;
-		/*
-		 * We could, later, implement roaming here and then actually
-		 * set prev_bssid to non-NULL. But then we need to be aware
-		 * that some APs don't like that -- so we'd need to retry
-		 * the association.
-		 */
+		if (wdev->conn->prev_bssid_valid)
+			prev_bssid = wdev->conn->prev_bssid;
 		err = __cfg80211_mlme_assoc(rdev, wdev->netdev,
 					    params->channel, params->bssid,
-					    NULL,
+					    prev_bssid,
 					    params->ssid, params->ssid_len,
 					    params->ie, params->ie_len,
 					    false, &params->crypto);
@@ -314,6 +311,28 @@ void cfg80211_sme_rx_auth(struct net_dev
 	}
 }
 
+bool cfg80211_sme_failed_reassoc(struct wireless_dev *wdev)
+{
+	struct wiphy *wiphy = wdev->wiphy;
+	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
+
+	if (WARN_ON(!wdev->conn))
+		return false;
+
+	if (!wdev->conn->prev_bssid_valid)
+		return false;
+
+	/*
+	 * Some stupid APs don't accept reassoc, so we
+	 * need to fall back to trying regular assoc.
+	 */
+	wdev->conn->prev_bssid_valid = false;
+	wdev->conn->state = CFG80211_CONN_ASSOCIATE_NEXT;
+	schedule_work(&rdev->conn_work);
+
+	return true;
+}
+
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
@@ -357,8 +376,11 @@ void __cfg80211_connect_result(struct ne
 
 		memset(&wrqu, 0, sizeof(wrqu));
 		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-		if (bssid && status == WLAN_STATUS_SUCCESS)
+		if (bssid && status == WLAN_STATUS_SUCCESS) {
 			memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+			memcpy(wdev->wext.prev_bssid, bssid, ETH_ALEN);
+			wdev->wext.prev_bssid_valid = true;
+		}
 		wireless_send_event(dev, SIOCGIWAP, &wrqu, NULL);
 	}
 #endif
@@ -509,6 +531,8 @@ void __cfg80211_roamed(struct wireless_d
 	memset(&wrqu, 0, sizeof(wrqu));
 	wrqu.ap_addr.sa_family = ARPHRD_ETHER;
 	memcpy(wrqu.ap_addr.sa_data, bssid, ETH_ALEN);
+	memcpy(wdev->wext.prev_bssid, bssid, ETH_ALEN);
+	wdev->wext.prev_bssid_valid = true;
 	wireless_send_event(wdev->netdev, SIOCGIWAP, &wrqu, NULL);
 #endif
 }
@@ -641,7 +665,8 @@ EXPORT_SYMBOL(cfg80211_disconnected);
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct cfg80211_connect_params *connect,
-		       struct cfg80211_cached_keys *connkeys)
+		       struct cfg80211_cached_keys *connkeys,
+		       const u8 *prev_bssid)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_channel *chan;
@@ -726,6 +751,11 @@ int __cfg80211_connect(struct cfg80211_r
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 		wdev->connect_keys = connkeys;
 
+		if (prev_bssid) {
+			memcpy(wdev->conn->prev_bssid, prev_bssid, ETH_ALEN);
+			wdev->conn->prev_bssid_valid = true;
+		}
+
 		/* we're good if we have both BSSID and channel */
 		if (wdev->conn->params.bssid && wdev->conn->params.channel) {
 			wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
@@ -777,7 +807,7 @@ int cfg80211_connect(struct cfg80211_reg
 	int err;
 
 	wdev_lock(dev->ieee80211_ptr);
-	err = __cfg80211_connect(rdev, dev, connect, connkeys);
+	err = __cfg80211_connect(rdev, dev, connect, connkeys, NULL);
 	wdev_unlock(dev->ieee80211_ptr);
 
 	return err;
--- wireless-testing.orig/net/wireless/core.h	2009-08-07 14:47:53.000000000 +0200
+++ wireless-testing/net/wireless/core.h	2009-08-07 14:48:34.000000000 +0200
@@ -335,7 +335,8 @@ void __cfg80211_connect_result(struct ne
 int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 		       struct net_device *dev,
 		       struct cfg80211_connect_params *connect,
-		       struct cfg80211_cached_keys *connkeys);
+		       struct cfg80211_cached_keys *connkeys,
+		       const u8 *prev_bssid);
 int cfg80211_connect(struct cfg80211_registered_device *rdev,
 		     struct net_device *dev,
 		     struct cfg80211_connect_params *connect,
@@ -353,6 +354,7 @@ int cfg80211_mgd_wext_connect(struct cfg
 			      struct wireless_dev *wdev);
 
 void cfg80211_conn_work(struct work_struct *work);
+bool cfg80211_sme_failed_reassoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
--- wireless-testing.orig/net/wireless/wext-sme.c	2009-08-07 14:47:53.000000000 +0200
+++ wireless-testing/net/wireless/wext-sme.c	2009-08-07 14:48:34.000000000 +0200
@@ -15,6 +15,7 @@ int cfg80211_mgd_wext_connect(struct cfg
 			      struct wireless_dev *wdev)
 {
 	struct cfg80211_cached_keys *ck = NULL;
+	const u8 *prev_bssid = NULL;
 	int err, i;
 
 	ASSERT_RDEV_LOCK(rdev);
@@ -42,8 +43,12 @@ int cfg80211_mgd_wext_connect(struct cfg
 		for (i = 0; i < 6; i++)
 			ck->params[i].key = ck->data[i];
 	}
+
+	if (wdev->wext.prev_bssid_valid)
+		prev_bssid = wdev->wext.prev_bssid;
+
 	err = __cfg80211_connect(rdev, wdev->netdev,
-				 &wdev->wext.connect, ck);
+				 &wdev->wext.connect, ck, prev_bssid);
 	if (err)
 		kfree(ck);
 
@@ -182,6 +187,7 @@ int cfg80211_mgd_wext_siwessid(struct ne
 			goto out;
 	}
 
+	wdev->wext.prev_bssid_valid = false;
 	wdev->wext.connect.ssid = wdev->wext.ssid;
 	memcpy(wdev->wext.ssid, ssid, len);
 	wdev->wext.connect.ssid_len = len;
--- wireless-testing.orig/include/net/cfg80211.h	2009-08-07 14:47:52.000000000 +0200
+++ wireless-testing/include/net/cfg80211.h	2009-08-07 14:48:34.000000000 +0200
@@ -1335,10 +1335,10 @@ struct wireless_dev {
 		struct cfg80211_cached_keys *keys;
 		u8 *ie;
 		size_t ie_len;
-		u8 bssid[ETH_ALEN];
+		u8 bssid[ETH_ALEN], prev_bssid[ETH_ALEN];
 		u8 ssid[IEEE80211_MAX_SSID_LEN];
 		s8 default_key, default_mgmt_key;
-		bool ps;
+		bool ps, prev_bssid_valid;
 		int ps_timeout;
 	} wext;
 #endif
--- wireless-testing.orig/net/wireless/mlme.c	2009-08-07 14:47:51.000000000 +0200
+++ wireless-testing/net/wireless/mlme.c	2009-08-07 14:48:34.000000000 +0200
@@ -67,6 +67,16 @@ void cfg80211_send_rx_assoc(struct net_d
 
 	status_code = le16_to_cpu(mgmt->u.assoc_resp.status_code);
 
+	/*
+	 * This is a bit of a hack, we don't notify userspace of
+	 * a (re-)association reply if we tried to send a reassoc
+	 * and got a reject -- we only try again with an assoc
+	 * frame instead of reassoc.
+	 */
+	if (status_code != WLAN_STATUS_SUCCESS && wdev->conn &&
+	    cfg80211_sme_failed_reassoc(wdev))
+		goto out;
+
 	nl80211_send_rx_assoc(rdev, dev, buf, len, GFP_KERNEL);
 
 	if (status_code == WLAN_STATUS_SUCCESS) {
@@ -97,6 +107,7 @@ void cfg80211_send_rx_assoc(struct net_d
 		cfg80211_put_bss(&bss->pub);
 	}
 
+ out:
 	wdev_unlock(wdev);
 }
 EXPORT_SYMBOL(cfg80211_send_rx_assoc);


