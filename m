Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:30088 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752648AbZGTILg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jul 2009 04:11:36 -0400
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH] cfg80211: avoid setting default_key if add_key fails
Date: Mon, 20 Jul 2009 16:12:57 +0800
Message-Id: <1248077577-7295-1-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In cfg80211_upload_connect_keys(), we call add_key, set_default_key
and set_default_mgmt_key (if applicable) one by one. If one of these
operations fails, we should stop calling the following functions.
Because if the key is not added successfully, we should not set it as
default key anyway.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 net/wireless/util.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 4bab380..ba387d8 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -546,13 +546,17 @@ void cfg80211_upload_connect_keys(struct wireless_dev *wdev)
 		if (!wdev->connect_keys->params[i].cipher)
 			continue;
 		if (rdev->ops->add_key(wdev->wiphy, dev, i, NULL,
-					&wdev->connect_keys->params[i]))
+					&wdev->connect_keys->params[i])) {
 			printk(KERN_ERR "%s: failed to set key %d\n",
 				dev->name, i);
+			continue;
+		}
 		if (wdev->connect_keys->def == i)
-			if (rdev->ops->set_default_key(wdev->wiphy, dev, i))
+			if (rdev->ops->set_default_key(wdev->wiphy, dev, i)) {
 				printk(KERN_ERR "%s: failed to set defkey %d\n",
 					dev->name, i);
+				continue;
+			}
 		if (wdev->connect_keys->defmgmt == i)
 			if (rdev->ops->set_default_mgmt_key(wdev->wiphy, dev, i))
 				printk(KERN_ERR "%s: failed to set mgtdef %d\n",
-- 
1.6.0.4

