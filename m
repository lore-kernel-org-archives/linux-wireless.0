Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4830 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750982Ab3FWKvi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Jun 2013 06:51:38 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: johannes@sipsolutions.net
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH] cfg80211: fix compilation warning for
 cfg80211_leave_all()
Date: Sun, 23 Jun 2013 12:51:21 +0200
Message-ID: <1371984681-3384-1-git-send-email-arend@broadcom.com> (sfid-20130623_125154_624690_EDC64C92)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The following compilation issue popped up moving from v3.10-rc1 to
v3.10-rc6 after merging wireless-testing.

net/wireless/sysfs.c:86:13: error: 'cfg80211_leave_all' defined
but not used [-Werror=unused-function]

The function is only called when CONFIG_PM is enabled. Moving the
function under CONFIG_PM as well.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 net/wireless/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 360a42c..a23253e 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -83,6 +83,7 @@ static int wiphy_uevent(struct device *dev, struct kobj_uevent_env *env)
 	return 0;
 }
 
+#ifdef CONFIG_PM
 static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
 {
 	struct wireless_dev *wdev;
@@ -91,7 +92,6 @@ static void cfg80211_leave_all(struct cfg80211_registered_device *rdev)
 		cfg80211_leave(rdev, wdev);
 }
 
-#ifdef CONFIG_PM
 static int wiphy_suspend(struct device *dev, pm_message_t state)
 {
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
-- 
1.7.10.4


