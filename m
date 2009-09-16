Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:46762 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbZIPEjp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 00:39:45 -0400
Subject: Re: [PATCH] cfg80211: don't report SME connection errs at
 SIOCSIW{FREQ/AP/ESSID}
From: Johannes Berg <johannes@sipsolutions.net>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John W Linville <linville@tuxdriver.com>
In-Reply-To: <200909150821.57216.hs4233@mail.mn-solutions.de>
References: <200909141254.14988.hs4233@mail.mn-solutions.de>
	 <200909141323.44245.hs4233@mail.mn-solutions.de>
	 <1252950234.23427.51.camel@johannes.local>
	 <200909150821.57216.hs4233@mail.mn-solutions.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Sep 2009 21:39:07 -0700
Message-Id: <1253075947.9450.0.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-09-15 at 08:21 +0200, Holger Schurig wrote:
> > And doesn't look correct to me at all. probably something
> > missing wrt. disconnect() while connecting.
> 
> Can you then outline the right solution ?

Try this please.

johannes

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


