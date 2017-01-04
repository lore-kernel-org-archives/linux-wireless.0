Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58412 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751858AbdADHZ0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 02:25:26 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] cfg80211: sysfs: use wiphy_name()
Date: Wed,  4 Jan 2017 08:25:22 +0100
Message-Id: <20170104072522.682-1-johannes@sipsolutions.net> (sfid-20170104_082529_609396_7ADD9AAE)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Instead of open-coding dev_name(), use the wiphy_name() inline
to make the code easier to understand. While at it, clean up
some coding style.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/sysfs.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/wireless/sysfs.c b/net/wireless/sysfs.c
index 14b3f007826d..16b6b5988be9 100644
--- a/net/wireless/sysfs.c
+++ b/net/wireless/sysfs.c
@@ -39,9 +39,11 @@ SHOW_FMT(address_mask, "%pM", wiphy.addr_mask);
 
 static ssize_t name_show(struct device *dev,
 			 struct device_attribute *attr,
-			 char *buf) {
+			 char *buf)
+{
 	struct wiphy *wiphy = &dev_to_rdev(dev)->wiphy;
-	return sprintf(buf, "%s\n", dev_name(&wiphy->dev));
+
+	return sprintf(buf, "%s\n", wiphy_name(wiphy));
 }
 static DEVICE_ATTR_RO(name);
 
-- 
2.9.3
