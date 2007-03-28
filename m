Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:48707 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342AbXC2LIL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 07:08:11 -0400
Subject: [PATCH] remove another wext/netlink comment
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 00:10:39 +0200
Message-Id: <1175119840.8807.0.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Looks like I missed this when removing wext/nl.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
 net/wireless/wext-old.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- wireless-dev.orig/net/wireless/wext-old.c	2007-03-29 00:01:28.645833397 +0200
+++ wireless-dev/net/wireless/wext-old.c	2007-03-29 00:01:43.785833397 +0200
@@ -586,30 +586,6 @@ int wireless_process_ioctl(struct ifreq 
 	return -EINVAL;
 }
 
-/********************** RTNETLINK REQUEST API **********************/
-/*
- * The alternate user space API to configure all those Wireless Extensions
- * is through RtNetlink.
- * This API support only the new driver API (iw_handler).
- *
- * This RtNetlink API use the same query/reply model as the ioctl API.
- * Maximum effort has been done to fit in the RtNetlink model, and
- * we support both RtNetlink Set and RtNelink Get operations.
- * On the other hand, we don't offer Dump operations because of the
- * following reasons :
- *	o Large number of parameters, most optional
- *	o Large size of some parameters (> 100 bytes)
- *	o Each parameters need to be extracted from hardware
- *	o Scan requests can take seconds and disable network activity.
- * Because of this high cost/overhead, we want to return only the
- * parameters the user application is really interested in.
- * We could offer partial Dump using the IW_DESCR_FLAG_DUMP flag.
- *
- * The API uses the standard RtNetlink socket. When the RtNetlink code
- * find a IFLA_WIRELESS field in a RtNetlink SET_LINK request,
- * it calls here.
- */
-
 /********************** ENHANCED IWSPY SUPPORT **********************/
 /*
  * In the old days, the driver was handling spy support all by itself.


