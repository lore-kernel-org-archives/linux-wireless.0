Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35623 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbbASRwc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Jan 2015 12:52:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] Revert "wireless: Support of IFLA_INFO_KIND rtnl attribute"
Date: Mon, 19 Jan 2015 18:52:23 +0100
Message-Id: <1421689943-13264-1-git-send-email-johannes@sipsolutions.net> (sfid-20150119_185234_968564_95BB0018)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This reverts commit ba1debdfed974f25aa598c283567878657b292ee.

Oliver reported that it breaks network-manager, for some reason with
this patch NM decides that the device isn't wireless but "generic"
(ethernet), sees no carrier (as expected with wifi) and fails to do
anything else with it.

Revert this to unbreak userspace.

Reported-by: Oliver Hartkopp <socketcan@hartkopp.net>
Tested-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/core.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 456e4c38c279..3af0ecf1cc16 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -21,7 +21,6 @@
 #include <linux/sched.h>
 #include <net/genetlink.h>
 #include <net/cfg80211.h>
-#include <net/rtnetlink.h>
 #include "nl80211.h"
 #include "core.h"
 #include "sysfs.h"
@@ -964,10 +963,6 @@ void cfg80211_stop_iface(struct wiphy *wiphy, struct wireless_dev *wdev,
 }
 EXPORT_SYMBOL(cfg80211_stop_iface);
 
-static const struct rtnl_link_ops wireless_link_ops = {
-	.kind = "wlan",
-};
-
 static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 					 unsigned long state, void *ptr)
 {
@@ -986,7 +981,6 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 	switch (state) {
 	case NETDEV_POST_INIT:
 		SET_NETDEV_DEVTYPE(dev, &wiphy_type);
-		dev->rtnl_link_ops = &wireless_link_ops;
 		break;
 	case NETDEV_REGISTER:
 		/*
-- 
2.1.4

