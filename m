Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58567 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619AbXBVNgM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Feb 2007 08:36:12 -0500
Subject: [PATCH] hook up nl80211 again
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 22 Feb 2007 13:36:17 +0100
Message-Id: <1172147777.5080.5.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Apparently when doing all the cfg80211 changes I accidentally removed
the nl80211 registration. This patch adds it back.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/core.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- wireless-dev.orig/net/wireless/core.c	2007-02-22 12:10:05.824688035 +0100
+++ wireless-dev/net/wireless/core.c	2007-02-22 12:11:52.384688035 +0100
@@ -242,19 +242,23 @@ EXPORT_SYMBOL(wiphy_free);
 static int cfg80211_init(void)
 {
 	int err = wiphy_sysfs_init();
-
 	if (err)
 		return err;
 
 	err = cfg80211_wext_init();
-
 	if (err)
 		goto out_exit_sysfs;
 
+	err = nl80211_init();
+	if (err)
+		goto out_nl80211;
+
 	ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);
 
 	return 0;
 
+ out_nl80211:
+	cfg80211_wext_exit();
  out_exit_sysfs:
 	wiphy_sysfs_exit();
 
@@ -265,6 +269,7 @@ module_init(cfg80211_init);
 static void cfg80211_exit(void)
 {
 	debugfs_remove(ieee80211_debugfs_dir);
+	nl80211_exit();
 	cfg80211_wext_exit();
 	wiphy_sysfs_exit();
 }


