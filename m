Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:43624 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954AbZLWN36 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Dec 2009 08:29:58 -0500
Date: Wed, 23 Dec 2009 15:29:37 +0200
From: Dan Carpenter <error27@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [patch] fix error paths in cfg80211_wext_siwscan()
Message-ID: <20091223132937.GG17923@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The new code calls kfree(creq) and on the wreq->essid_len > IEEE80211_MAX_SSID_LEN
case it also unlocks the rdev lock.

This was found with a static checker and compile tested only.  :/

Signed-off-by: Dan Carpenter <error27@gmail.com>

--- orig/net/wireless/scan.c	2009-12-23 08:38:15.000000000 +0200
+++ devel/net/wireless/scan.c	2009-12-23 08:50:15.000000000 +0200
@@ -685,7 +685,7 @@ int cfg80211_wext_siwscan(struct net_dev
 	/* No channels found? */
 	if (!i) {
 		err = -EINVAL;
-		goto out;
+		goto out1;
 	}
 
 	/* Set real number of channels specified in creq->channels[] */
@@ -694,8 +694,10 @@ int cfg80211_wext_siwscan(struct net_dev
 	/* translate "Scan for SSID" request */
 	if (wreq) {
 		if (wrqu->data.flags & IW_SCAN_THIS_ESSID) {
-			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN)
-				return -EINVAL;
+			if (wreq->essid_len > IEEE80211_MAX_SSID_LEN) {
+				err = -EINVAL;
+				goto out1;
+			}
 			memcpy(creq->ssids[0].ssid, wreq->essid, wreq->essid_len);
 			creq->ssids[0].ssid_len = wreq->essid_len;
 		}
@@ -705,6 +707,7 @@ int cfg80211_wext_siwscan(struct net_dev
 
 	rdev->scan_req = creq;
 	err = rdev->ops->scan(wiphy, dev, creq);
+out1:
 	if (err) {
 		rdev->scan_req = NULL;
 		kfree(creq);
