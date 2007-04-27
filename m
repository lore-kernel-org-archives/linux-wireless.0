Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:37499 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbXD0KP5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Apr 2007 06:15:57 -0400
Subject: [PATCH] cfg80211: fix rtnl warning in sysfs.c
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 27 Apr 2007 12:16:04 +0200
Message-Id: <1177668964.7828.48.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes an oversight from my rtnl patch for cfg80211.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
In the patch for net-2.6 I didn't make this mistake so it's wireless-dev
only.

 net/wireless/sysfs.c |    1 +
 1 file changed, 1 insertion(+)

--- wireless-dev.orig/net/wireless/sysfs.c	2007-04-27 12:11:14.684987898 +0200
+++ wireless-dev/net/wireless/sysfs.c	2007-04-27 12:11:23.544987898 +0200
@@ -12,6 +12,7 @@
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
+#include <linux/rtnetlink.h>
 #include <net/cfg80211.h>
 #include "sysfs.h"
 #include "core.h"


