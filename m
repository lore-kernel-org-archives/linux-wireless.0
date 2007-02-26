Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58862 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161300AbXBZWrP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Feb 2007 17:47:15 -0500
Received: from [84.135.252.42] (helo=johannes.berg)
	by sipsolutions.net with esmtpsa (TLS-1.0:RSA_ARCFOUR_MD5:16)
	(Exim 4.63)
	(envelope-from <johannes@sipsolutions.net>)
	id 1HLoYb-000250-Uy
	for linux-wireless@vger.kernel.org; Mon, 26 Feb 2007 22:42:58 +0000
Subject: [PATCH] net/wireless: fix sparse warnings
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Mon, 26 Feb 2007 23:46:56 +0100
Message-Id: <1172530016.3870.199.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes a few things sparse pointed out when I finally got it
working.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/sysfs.c       |    1 +
 net/wireless/wext-common.c |    8 ++++----
 2 files changed, 5 insertions(+), 4 deletions(-)

--- wireless-dev.orig/net/wireless/sysfs.c	2007-02-26 23:42:38.124692803 +0100
+++ wireless-dev/net/wireless/sysfs.c	2007-02-26 23:42:43.314692803 +0100
@@ -13,6 +13,7 @@
 #include <linux/netdevice.h>
 #include <linux/nl80211.h>
 #include <net/cfg80211.h>
+#include "sysfs.h"
 #include "core.h"
 
 static inline struct cfg80211_registered_device *dev_to_rdev(
--- wireless-dev.orig/net/wireless/wext-common.c	2007-02-26 23:43:08.314692803 +0100
+++ wireless-dev/net/wireless/wext-common.c	2007-02-26 23:44:55.654692803 +0100
@@ -13,10 +13,11 @@
 #include <linux/module.h>
 #include <linux/wireless.h>
 #include <linux/types.h>
-#include <net/iw_handler.h>
 #include <linux/seq_file.h>
-#include <net/netlink.h>
 #include <linux/rtnetlink.h>
+#include <net/iw_handler.h>
+#include <net/netlink.h>
+#include <net/wireless.h>
 #include "wext.h"
 
 /* common data */
@@ -301,8 +302,7 @@ const struct iw_ioctl_description standa
 		.max_tokens	= sizeof(struct iw_pmkid_cand),
 	},
 };
-unsigned standard_event_num = (sizeof(standard_event) /
-					sizeof(struct iw_ioctl_description));
+static unsigned standard_event_num = ARRAY_SIZE(standard_event);
 
 /* Size (in bytes) of various events */
 const int event_type_size[] = {


