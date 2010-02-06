Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f228.google.com ([209.85.219.228]:53889 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755632Ab0BFNUq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2010 08:20:46 -0500
Received: by mail-ew0-f228.google.com with SMTP id 28so944897ewy.28
        for <linux-wireless@vger.kernel.org>; Sat, 06 Feb 2010 05:20:46 -0800 (PST)
From: David Kilroy <kilroyd@googlemail.com>
To: linux-wireless@vger.kernel.org
Cc: holgerschurig@gmail.com, sameo@linux.intel.com, dcbw@redhat.com,
	David Kilroy <kilroyd@googlemail.com>
Subject: [RFC 2/2] cfg80211: scan for missing BSS on connect completion
Date: Sat,  6 Feb 2010 13:20:16 +0000
Message-Id: <1265462416-7547-3-git-send-email-kilroyd@googlemail.com>
In-Reply-To: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
References: <1265462416-7547-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some drivers don't notify cfg80211 of every beacon or probe response
they get. In this case, cfg80211 won't have the BSS structure for the AP
that we just connected with.

We address that issue by doing a scan after the driver indicates it has
connected. Scan for the SSID that we are in. If we have the channel,
specify that as well to reduce scanning time.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 include/net/cfg80211.h |    3 +
 net/wireless/scan.c    |    5 ++
 net/wireless/sme.c     |  143 +++++++++++++++++++++++++++++++++++++++++------
 3 files changed, 132 insertions(+), 19 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index a3f0a7e..67bb8f5 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -1420,6 +1420,7 @@ extern void wiphy_free(struct wiphy *wiphy);
 struct cfg80211_conn;
 struct cfg80211_internal_bss;
 struct cfg80211_cached_keys;
+struct cfg80211_conn2;
 
 #define MAX_AUTH_BSSES		4
 
@@ -1471,6 +1472,8 @@ struct wireless_dev {
 	struct cfg80211_conn *conn;
 	struct cfg80211_cached_keys *connect_keys;
 
+	struct cfg80211_conn2 *conn2; /* TODO: Rename */
+
 	struct list_head event_list;
 	spinlock_t event_lock;
 
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index e3d0957..140da4c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -39,6 +39,11 @@ void ___cfg80211_scan_done(struct cfg80211_registered_device *rdev, bool leak)
 	 * This must be before sending the other events!
 	 * Otherwise, wpa_supplicant gets completely confused with
 	 * wext events.
+	 *
+	 * At the moment this will either call cfg80211_sme_scan_done
+	 * or cfg80211_complete_connect. The former should only get
+	 * called if the device supports ops->auth & ops->assoc, the
+	 * latter if the device supports ops->connect.
 	 */
 	if (rdev->async_scan_cb) {
 		rdev->async_scan_cb(dev);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 2ef83b7..6134332 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -34,6 +34,15 @@ struct cfg80211_conn {
 	bool auto_auth, prev_bssid_valid;
 };
 
+/* TODO: This struct needs renaming */
+struct cfg80211_conn2 {
+	struct ieee80211_channel *channel;
+	u8 bssid[ETH_ALEN];
+};
+
+static void __cfg80211_complete_connect(struct net_device *dev,
+					struct cfg80211_bss *bss);
+
 bool cfg80211_is_all_idle(void)
 {
 	struct cfg80211_registered_device *rdev;
@@ -385,6 +394,62 @@ void cfg80211_sme_failed_assoc(struct wireless_dev *wdev)
 	schedule_work(&rdev->conn_work);
 }
 
+static void __cfg80211_complete_connect(struct net_device *dev,
+					struct cfg80211_bss *bss)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+	u8 *country_ie;
+
+	cfg80211_hold_bss(bss_from_pub(bss));
+	wdev->current_bss = bss_from_pub(bss);
+
+	wdev->sme_state = CFG80211_SME_CONNECTED;
+	cfg80211_upload_connect_keys(wdev);
+
+	country_ie = (u8 *) ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
+
+	if (!country_ie)
+		return;
+
+	/*
+	 * ieee80211_bss_get_ie() ensures we can access:
+	 * - country_ie + 2, the start of the country ie data, and
+	 * - and country_ie[1] which is the IE length
+	 */
+	regulatory_hint_11d(wdev->wiphy,
+			    bss->channel->band,
+			    country_ie + 2,
+			    country_ie[1]);
+}
+
+void cfg80211_complete_connect(struct net_device *dev)
+{
+	struct wireless_dev *wdev = dev->ieee80211_ptr;
+
+	mutex_lock(&wiphy_to_dev(wdev->wiphy)->devlist_mtx);
+	wdev_lock(wdev);
+
+	if (wdev->conn2) {
+		struct cfg80211_bss *bss;
+
+		bss = cfg80211_get_bss(wdev->wiphy, NULL, wdev->conn2->bssid,
+				       wdev->ssid, wdev->ssid_len,
+				       WLAN_CAPABILITY_ESS,
+				       WLAN_CAPABILITY_ESS);
+
+		if (WARN_ON(!bss))
+			wdev->sme_state = CFG80211_SME_IDLE;
+		else
+			__cfg80211_complete_connect(dev, bss);
+
+		kfree(wdev->conn2);
+		wdev->conn2 = NULL;
+	}
+
+	wdev_unlock(wdev);
+	mutex_unlock(&wiphy_to_dev(wdev->wiphy)->devlist_mtx);
+}
+
 void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       const u8 *req_ie, size_t req_ie_len,
 			       const u8 *resp_ie, size_t resp_ie_len,
@@ -392,7 +457,6 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 			       struct cfg80211_bss *bss)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	u8 *country_ie;
 #ifdef CONFIG_CFG80211_WEXT
 	union iwreq_data wrqu;
 #endif
@@ -462,29 +526,58 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 				       WLAN_CAPABILITY_ESS,
 				       WLAN_CAPABILITY_ESS);
 
-	if (WARN_ON(!bss))
-		return;
+	if (!bss) {
+		struct cfg80211_scan_request *request;
+		int err;
+
+		/* The driver hasn't reported any beacons or probe
+		 * responses for the BSS that we've connected
+		 * with. Trigger a scan to get it.
+		 *
+		 * Record the BSSID we connected with, so we know what
+		 * to look for later.
+		 *
+		 * Then do a scan on the channel (if specified),
+		 * specifying the SSID.
+		 */
+		memcpy(wdev->conn2->bssid, bssid, ETH_ALEN);
 
-	cfg80211_hold_bss(bss_from_pub(bss));
-	wdev->current_bss = bss_from_pub(bss);
+		request = kzalloc(sizeof(*request) + sizeof(request->ssids[0]) +
+				  sizeof(request->channels[0]),
+				  GFP_KERNEL);
+		if (!request)
+			return;
 
-	wdev->sme_state = CFG80211_SME_CONNECTED;
-	cfg80211_upload_connect_keys(wdev);
+		/* Would be better if we knew the channel of the AP we
+		 * connected to. Is it available in one of the IEs? */
+		if (wdev->conn2->channel) {
+			request->channels[0] = wdev->conn2->channel;
+			request->n_channels = 1;
+			request->ssids = (void *) &request->channels[1];
+		} else
+			request->ssids = (void *) &request->channels[0];
 
-	country_ie = (u8 *) ieee80211_bss_get_ie(bss, WLAN_EID_COUNTRY);
+		request->n_ssids = 1;
 
-	if (!country_ie)
-		return;
+		memcpy(request->ssids[0].ssid, wdev->ssid, wdev->ssid_len);
+		request->ssids[0].ssid_len = wdev->ssid_len;
+
+		request->dev = dev;
+		request->wiphy = wdev->wiphy;
+
+		err = cfg80211_async_scan(wdev, request, false,
+					  cfg80211_complete_connect);
+		if (err) {
+			kfree(request);
+			wdev->sme_state = CFG80211_SME_IDLE;
+		}
+	} else {
+		kfree(wdev->conn2);
+		wdev->conn2 = NULL;
+
+		__cfg80211_complete_connect(dev, bss);
+	};
 
-	/*
-	 * ieee80211_bss_get_ie() ensures we can access:
-	 * - country_ie + 2, the start of the country ie data, and
-	 * - and country_ie[1] which is the IE length
-	 */
-	regulatory_hint_11d(wdev->wiphy,
-			    bss->channel->band,
-			    country_ie + 2,
-			    country_ie[1]);
 }
 
 void cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
@@ -854,10 +947,22 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 
 		return err;
 	} else {
+
+		if (WARN_ON_ONCE(wdev->conn2))
+			return -EINPROGRESS;
+
+		wdev->conn2 = kzalloc(sizeof(*wdev->conn2), GFP_KERNEL);
+		if (!wdev->conn2)
+			return -ENOMEM;
+
+		wdev->conn2->channel = connect->channel;
+
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 		wdev->connect_keys = connkeys;
 		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
 		if (err) {
+			kfree(wdev->conn2);
+			wdev->conn2 = NULL;
 			wdev->connect_keys = NULL;
 			wdev->sme_state = CFG80211_SME_IDLE;
 			return err;
-- 
1.6.4.4

