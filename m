Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:63637 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab1LUKLP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 05:11:15 -0500
Received: by mail-ww0-f44.google.com with SMTP id dr13so13979045wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 02:11:14 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>, Luciano Coelho <coelho@ti.com>
Subject: [PATCH v2 2/2] nl80211: report stopped sched scan only after driver does
Date: Wed, 21 Dec 2011 12:11:02 +0200
Message-Id: <1324462262-10277-3-git-send-email-eyal@wizery.com> (sfid-20111221_111120_970684_8131E3D0)
In-Reply-To: <1324462262-10277-1-git-send-email-eyal@wizery.com>
References: <1324462262-10277-1-git-send-email-eyal@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Report NL80211_CMD_SCHED_SCAN_STOPPED and change internal
states in cfg80211 only after the driver reports that
sched scan was actually stopped.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
v2: No changes

 net/wireless/scan.c |   17 ++++++++---------
 1 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 31119e3..d6c87d9 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -133,6 +133,7 @@ EXPORT_SYMBOL(cfg80211_sched_scan_stopped);
 int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 			       bool driver_initiated)
 {
+	int err = 0;
 	struct net_device *dev;
 
 	lockdep_assert_held(&rdev->sched_scan_mtx);
@@ -143,17 +144,15 @@ int __cfg80211_stop_sched_scan(struct cfg80211_registered_device *rdev,
 	dev = rdev->sched_scan_req->dev;
 
 	if (!driver_initiated) {
-		int err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
-		if (err)
-			return err;
+		err = rdev->ops->sched_scan_stop(&rdev->wiphy, dev);
+	} else {
+		nl80211_send_sched_scan(rdev, dev,
+					NL80211_CMD_SCHED_SCAN_STOPPED);
+		kfree(rdev->sched_scan_req);
+		rdev->sched_scan_req = NULL;
 	}
 
-	nl80211_send_sched_scan(rdev, dev, NL80211_CMD_SCHED_SCAN_STOPPED);
-
-	kfree(rdev->sched_scan_req);
-	rdev->sched_scan_req = NULL;
-
-	return 0;
+	return err;
 }
 
 static void bss_release(struct kref *ref)
-- 
1.7.4.1

