Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:41175 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbZJaGkm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 02:40:42 -0400
Subject: [PATCH] cfg80211: fix NULL ptr deref
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Parag Warudkar <parag.lkml@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 31 Oct 2009 07:40:37 +0100
Message-ID: <1256971237.3555.87.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

  commit 211a4d12abf86fe0df4cd68fc6327cbb58f56f81
  Author: Johannes Berg <johannes@sipsolutions.net>
  Date:   Tue Oct 20 15:08:53 2009 +0900

      cfg80211: sme: deauthenticate on assoc failure

introduced a potential NULL pointer dereference that
some people have been hitting for some reason -- the
params.bssid pointer is not guaranteed to be non-NULL
for what seems to be a race between various ways of
reaching the same thing.

While I'm trying to analyse the problem more let's
first fix the crash. I think the real fix may be to
avoid doing _anything_ if it ended up being NULL, but
right now I'm not sure yet.

I think
http://bugzilla.kernel.org/show_bug.cgi?id=14342
might also be this issue.

Reported-by: Parag Warudkar <parag.lkml@gmail.com>
Tested-by: Parag Warudkar <parag.lkml@gmail.com>
Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/sme.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/sme.c	2009-10-31 07:29:47.000000000 +0100
+++ wireless-testing/net/wireless/sme.c	2009-10-31 07:31:29.000000000 +0100
@@ -165,7 +165,7 @@ void cfg80211_conn_work(struct work_stru
 	struct cfg80211_registered_device *rdev =
 		container_of(work, struct cfg80211_registered_device, conn_work);
 	struct wireless_dev *wdev;
-	u8 bssid[ETH_ALEN];
+	u8 bssid_buf[ETH_ALEN], *bssid = NULL;
 
 	rtnl_lock();
 	cfg80211_lock_rdev(rdev);
@@ -181,7 +181,10 @@ void cfg80211_conn_work(struct work_stru
 			wdev_unlock(wdev);
 			continue;
 		}
-		memcpy(bssid, wdev->conn->params.bssid, ETH_ALEN);
+		if (wdev->conn->params.bssid) {
+			memcpy(bssid_buf, wdev->conn->params.bssid, ETH_ALEN);
+			bssid = bssid_buf;
+		}
 		if (cfg80211_conn_do_work(wdev))
 			__cfg80211_connect_result(
 					wdev->netdev, bssid,


