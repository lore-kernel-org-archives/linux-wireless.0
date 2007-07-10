Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:55882
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069AbXGJXSl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2007 19:18:41 -0400
From: Michael Buesch <mb@bu3sch.de>
To: John Linville <linville@tuxdriver.com>
Subject: [PATCH] cfg80211: Don't allow users to create/remove interfaces
Date: Wed, 11 Jul 2007 01:17:25 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	Andy Green <andy@warmcat.com>, linux-wireless@vger.kernel.org
MIME-Version: 1.0
Message-Id: <200707110117.26067.mb@bu3sch.de>
Content-Type: text/plain;
  charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This adds a capability check to only allow creation
and removal of interfaces by a network admin.

Signed-off-by: Michael Buesch <mb@bu3sch.de>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: Andy Green <andy@warmcat.com>

Index: mac80211/net/wireless/sysfs.c
===================================================================
--- mac80211.orig/net/wireless/sysfs.c	2007-06-01 11:20:32.000000000 +0200
+++ mac80211/net/wireless/sysfs.c	2007-07-11 01:04:53.000000000 +0200
@@ -46,9 +46,10 @@ static ssize_t _store_add_iface(struct d
 	struct cfg80211_registered_device *rdev = dev_to_rdev(dev);
 	int res;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
 	if (len > IFNAMSIZ)
 		return -EINVAL;
-
 	if (!rdev->ops->add_virtual_intf)
 		return -ENOSYS;
 
@@ -68,9 +69,10 @@ static ssize_t _store_remove_iface(struc
 	int res, ifidx;
 	struct net_device *netdev;
 
+	if (!capable(CAP_NET_ADMIN))
+		return -EPERM;
 	if (len > IFNAMSIZ)
 		return -EINVAL;
-
 	if (!rdev->ops->del_virtual_intf)
 		return -ENOSYS;
 

-- 
Greetings Michael.
