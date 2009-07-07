Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:59732 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbZGGCAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jul 2009 22:00:37 -0400
Message-Id: <20090707015709.554947659@sipsolutions.net>
References: <20090707015604.369008211@sipsolutions.net>
Date: Tue, 07 Jul 2009 03:56:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 9/9] cfg80211: disallow configuring unsupported interfaces
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In order to force drivers to advertise their interface
types, don't just disallow creating new interfaces with
unadvertised types but also disallow setting them UP.
Additionally, add some validation on the operations the
drivers support.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/wireless/core.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- wireless-testing.orig/net/wireless/core.c	2009-07-07 03:37:06.000000000 +0200
+++ wireless-testing/net/wireless/core.c	2009-07-07 03:37:07.000000000 +0200
@@ -331,8 +331,13 @@ struct wiphy *wiphy_new(const struct cfg
 	struct cfg80211_registered_device *rdev;
 	int alloc_size;
 
-	WARN_ON(!ops->add_key && ops->del_key);
-	WARN_ON(ops->add_key && !ops->del_key);
+	WARN_ON(ops->add_key && (!ops->del_key || !ops->set_default_key));
+	WARN_ON(ops->auth && (!ops->assoc || !ops->deauth || !ops->disassoc));
+	WARN_ON(ops->connect && !ops->disconnect);
+	WARN_ON(ops->join_ibss && !ops->leave_ibss);
+	WARN_ON(ops->add_virtual_intf && !ops->del_virtual_intf);
+	WARN_ON(ops->add_station && !ops->del_station);
+	WARN_ON(ops->add_mpath && !ops->del_mpath);
 
 	alloc_size = sizeof(*rdev) + sizeof_priv;
 
@@ -687,6 +692,8 @@ static int cfg80211_netdev_notifier_call
 		mutex_destroy(&wdev->mtx);
 		break;
 	case NETDEV_PRE_UP:
+		if (!(wdev->wiphy->interface_modes & BIT(wdev->iftype)))
+			return notifier_from_errno(-EOPNOTSUPP);
 		if (rfkill_blocked(rdev->rfkill))
 			return notifier_from_errno(-ERFKILL);
 		break;

-- 

