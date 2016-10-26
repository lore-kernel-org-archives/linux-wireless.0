Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:47920 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750866AbcJZGAC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Oct 2016 02:00:02 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: process events caused by suspend before suspending
Date: Wed, 26 Oct 2016 07:59:58 +0200
Message-Id: <1477461598-6395-1-git-send-email-johannes@sipsolutions.net> (sfid-20161026_080005_810886_61BF892A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

When suspending without WoWLAN, cfg80211 will ask drivers to
disconnect. Even when the driver does this synchronously, and
immediately returns with a notification, cfg80211 schedules
the handling thereof to a workqueue, and may then call back
into the driver when the driver was already suspended/ing.

Fix this by processing all events caused by cfg80211_leave_all()
directly after that function returns. The driver still needs to
do the right thing here and wait for the firmware response, but
that is - at least - true for mwifiex where this occurred.

Reported-by: Amitkumar Karwar <akarwar@marvell.com>
Tested-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sysfs.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 0082f4b01795..14b3f007826d 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -104,13 +104,16 @@ static int wiphy_suspend(struct device *dev)
 
 	rtnl_lock();
 	if (rdev->wiphy.registered) {
-		if (!rdev->wiphy.wowlan_config)
+		if (!rdev->wiphy.wowlan_config) {
 			cfg80211_leave_all(rdev);
+			cfg80211_process_rdev_events(rdev);
+		}
 		if (rdev->ops->suspend)
 			ret = rdev_suspend(rdev, rdev->wiphy.wowlan_config);
 		if (ret == 1) {
 			/* Driver refuse to configure wowlan */
 			cfg80211_leave_all(rdev);
+			cfg80211_process_rdev_events(rdev);
 			ret = rdev_suspend(rdev, NULL);
 		}
 	}
-- 
2.8.1
