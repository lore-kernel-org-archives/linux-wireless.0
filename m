Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58509 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbZLWOdn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 09:33:43 -0500
Subject: [PATCH] cfg80211: fix error path in cfg80211_wext_siwscan
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Carpenter <error27@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <20091223132937.GG17923@bicker>
References: <20091223132937.GG17923@bicker>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Dec 2009 15:33:35 +0100
Message-ID: <1261578815.7304.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

If there's an invalid channel or SSID, the code leaks
the scan request. Always free the scan request, unless
it was successfully given to the driver.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
I kinda prefer this, thoughts?

 net/wireless/scan.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/wireless/scan.c	2009-12-23 15:27:20.000000000 +0100
+++ wireless-testing/net/wireless/scan.c	2009-12-23 15:32:52.000000000 +0100
@@ -601,7 +601,7 @@ int cfg80211_wext_siwscan(struct net_dev
 	struct cfg80211_registered_device *rdev;
 	struct wiphy *wiphy;
 	struct iw_scan_req *wreq = NULL;
-	struct cfg80211_scan_request *creq;
+	struct cfg80211_scan_request *creq = NULL;
 	int i, err, n_channels = 0;
 	enum ieee80211_band band;
 
@@ -694,8 +694,10 @@ int cfg80211_wext_siwscan(struct net_dev
 	/* translate "Scan for SSID" request */
 	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
+			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out;
+			}
 			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
 			creq->ssids[0].ssid_len = wreq->essid_len;
 		}
@@ -707,12 +709,15 @@ int cfg80211_wext_siwscan(struct net_dev
 	err = rdev->ops->scan(wiphy, dev, creq);
 	if (err) {
 		rdev->scan_req = NULL;
-		kfree(creq);
+		/* creq will be freed below */
 	} else {
 		nl80211_send_scan_start(rdev, dev);
+		/* creq now owned by driver */
+		creq = NULL;
 		dev_hold(dev);
 	}
  out:
+	kfree(creq);
 	cfg80211_unlock_rdev(rdev);
 	return err;
 }


