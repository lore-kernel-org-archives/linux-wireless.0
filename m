Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:44578 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1763656AbdJQT4X (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Oct 2017 15:56:23 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: fix connect/disconnect edge cases
Date: Tue, 17 Oct 2017 21:56:20 +0200
Message-Id: <20171017195620.911-1-johannes@sipsolutions.net> (sfid-20171017_215625_691236_7410979C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

If we try to connect while already connected/connecting, but
this fails, we set ssid_len=0 but leave current_bss hanging,
leading to errors.

Check all of this better, first of all ensuring that we can't
try to connect to a different SSID while connected/ing; ensure
that prev_bssid is set for re-association attempts even in the
case of the driver supporting the connect() method, and don't
reset ssid_len in the failure cases.

While at it, also reset ssid_len while disconnecting unless we
were connected and expect a disconnected event, and warn on a
successful connection without ssid_len being set.

Cc: stable@vger.kernel.org
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sme.c | 50 +++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 41 insertions(+), 9 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index f38ed490e42b..29bf453a0d5f 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -522,11 +522,6 @@ static int cfg80211_sme_connect(struct wireless_dev *wdev,
 		return -EOPNOTSUPP;
 
 	if (wdev->current_bss) {
-		if (!prev_bssid)
-			return -EALREADY;
-		if (prev_bssid &&
-		    !ether_addr_equal(prev_bssid, wdev->current_bss->pub.bssid))
-			return -ENOTCONN;
 		cfg80211_unhold_bss(wdev->current_bss);
 		cfg80211_put_bss(wdev->wiphy, &wdev->current_bss->pub);
 		wdev->current_bss = NULL;
@@ -1106,11 +1101,35 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 
 	ASSERT_WDEV_LOCK(wdev);
 
-	if (WARN_ON(wdev->connect_keys)) {
-		kzfree(wdev->connect_keys);
-		wdev->connect_keys = NULL;
+	/*
+	 * If we have an ssid_len, we're trying to connect or are
+	 * already connected, so reject a new SSID unless it's the
+	 * same (which is the case for re-association.)
+	 */
+	if (wdev->ssid_len &&
+	    (wdev->ssid_len != connect->ssid_len ||
+	     memcmp(wdev->ssid, connect->ssid, wdev->ssid_len)))
+		return -EALREADY;
+
+	/*
+	 * If connected, reject (re-)association unless prev_bssid
+	 * matches the current BSSID.
+	 */
+	if (wdev->current_bss) {
+		if (!prev_bssid)
+			return -EALREADY;
+		if (!ether_addr_equal(prev_bssid, wdev->current_bss->pub.bssid))
+			return -ENOTCONN;
 	}
 
+	/*
+	 * Reject if we're in the process of connecting with WEP,
+	 * this case isn't very interesting and trying to handle
+	 * it would make the code much more complex.
+	 */
+	if (wdev->connect_keys)
+		return -EINPROGRESS;
+
 	cfg80211_oper_and_ht_capa(&connect->ht_capa_mask,
 				  rdev->wiphy.ht_capa_mod_mask);
 
@@ -1161,7 +1180,12 @@ int cfg80211_connect(struct cfg80211_registered_device *rdev,
 
 	if (err) {
 		wdev->connect_keys = NULL;
-		wdev->ssid_len = 0;
+		/*
+		 * This could be reassoc getting refused, don't clear
+		 * ssid_len in that case.
+		 */
+		if (!wdev->current_bss)
+			wdev->ssid_len = 0;
 		return err;
 	}
 
@@ -1188,6 +1212,14 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
 	else if (wdev->ssid_len)
 		err = rdev_disconnect(rdev, dev, reason);
 
+	/*
+	 * Clear ssid_len unless we actually were fully connected,
+	 * in which case cfg80211_disconnected() will take care of
+	 * this later.
+	 */
+	if (!wdev->current_bss)
+		wdev->ssid_len = 0;
+
 	return err;
 }
 
-- 
2.14.2
