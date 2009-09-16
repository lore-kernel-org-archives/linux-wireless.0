Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:33541 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759462AbZIPQE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 12:04:58 -0400
Subject: [PATCH] cfg80211: fix SME connect
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Sep 2009 09:04:26 -0700
Message-Id: <1253117066.9450.2.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's a check saying
	/* we're good if we have both BSSID and channel */
	if (wdev->conn->params.bssid && wdev->conn->params.channel) {

but that isn't true -- we need the BSS struct. This leads
to errors such as

    Trying to associate with 00:1b:53:11:dc:40 (SSID='TEST' freq=2412 MHz)
    ioctl[SIOCSIWFREQ]: No such file or directory
    ioctl[SIOCSIWESSID]: No such file or directory
    Association request to the driver failed
    Associated with 00:1b:53:11:dc:40

in wpa_supplicant, as reported by Holger.

Instead, we really need to have the BSS struct, and if we
don't, then we need to initiate a scan for it. But we may
already have the BSS struct here, so hang on to it if we
do and scan if we don't.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Tested-by: Holger Schurig <hs4233@mail.mn-solutions.de>
---
 net/wireless/sme.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-09-15 21:33:41.000000000 -0700
+++ wireless-testing/net/wireless/sme.c	2009-09-15 21:37:58.000000000 -0700
@@ -188,7 +188,7 @@ void cfg80211_conn_work(struct work_stru
 	rtnl_unlock();
 }
 
-static bool cfg80211_get_conn_bss(struct wireless_dev *wdev)
+static struct cfg80211_bss *cfg80211_get_conn_bss(struct wireless_dev *wdev)
 {
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
 	struct cfg80211_bss *bss;
@@ -205,7 +205,7 @@ static bool cfg80211_get_conn_bss(struct
 			       WLAN_CAPABILITY_ESS | WLAN_CAPABILITY_PRIVACY,
 			       capa);
 	if (!bss)
-		return false;
+		return NULL;
 
 	memcpy(wdev->conn->bssid, bss->bssid, ETH_ALEN);
 	wdev->conn->params.bssid = wdev->conn->bssid;
@@ -213,14 +213,14 @@ static bool cfg80211_get_conn_bss(struct
 	wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 	schedule_work(&rdev->conn_work);
 
-	cfg80211_put_bss(bss);
-	return true;
+	return bss;
 }
 
 static void __cfg80211_sme_scan_done(struct net_device *dev)
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct cfg80211_registered_device *rdev = wiphy_to_dev(wdev->wiphy);
+	struct cfg80211_bss *bss;
 
 	ASSERT_WDEV_LOCK(wdev);
 
@@ -234,7 +234,10 @@ static void __cfg80211_sme_scan_done(str
 	    wdev->conn->state != CFG80211_CONN_SCAN_AGAIN)
 		return;
 
-	if (!cfg80211_get_conn_bss(wdev)) {
+	bss = cfg80211_get_conn_bss(wdev);
+	if (bss) {
+		cfg80211_put_bss(bss);
+	} else {
 		/* not found */
 		if (wdev->conn->state == CFG80211_CONN_SCAN_AGAIN)
 			schedule_work(&rdev->conn_work);
@@ -670,6 +673,7 @@ int __cfg80211_connect(struct cfg80211_r
 {
 	struct wireless_dev *wdev = dev->ieee80211_ptr;
 	struct ieee80211_channel *chan;
+	struct cfg80211_bss *bss = NULL;
 	int err;
 
 	ASSERT_WDEV_LOCK(wdev);
@@ -760,7 +764,7 @@ int __cfg80211_connect(struct cfg80211_r
 
 		/* don't care about result -- but fill bssid & channel */
 		if (!wdev->conn->params.bssid || !wdev->conn->params.channel)
-			cfg80211_get_conn_bss(wdev);
+			bss = cfg80211_get_conn_bss(wdev);
 
 		wdev->sme_state = CFG80211_SME_CONNECTING;
 		wdev->connect_keys = connkeys;
@@ -770,10 +774,11 @@ int __cfg80211_connect(struct cfg80211_r
 			wdev->conn->prev_bssid_valid = true;
 		}
 
-		/* we're good if we have both BSSID and channel */
-		if (wdev->conn->params.bssid && wdev->conn->params.channel) {
+		/* we're good if we have a matching bss struct */
+		if (bss) {
 			wdev->conn->state = CFG80211_CONN_AUTHENTICATE_NEXT;
 			err = cfg80211_conn_do_work(wdev);
+			cfg80211_put_bss(bss);
 		} else {
 			/* otherwise we'll need to scan for the AP first */
 			err = cfg80211_conn_scan(wdev);


