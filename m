Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:35987 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755874AbZGATfw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 15:35:52 -0400
Message-Id: <20090701193419.987710222@sipsolutions.net>
References: <20090701192641.072258140@sipsolutions.net>
Date: Wed, 01 Jul 2009 21:26:50 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 09/20 v4] wext: constify extra argument to
 wireless_send_event
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is never changed by the function, so can be marked const.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 include/net/iw_handler.h |    2 +-
 net/wireless/wext.c      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- wireless-testing.orig/include/net/iw_handler.h	2009-07-01 08:55:06.000000000 +0200
+++ wireless-testing/include/net/iw_handler.h	2009-07-01 09:01:20.000000000 +0200
@@ -443,7 +443,7 @@ extern int dev_get_wireless_info(char * 
 extern void wireless_send_event(struct net_device *	dev,
 				unsigned int		cmd,
 				union iwreq_data *	wrqu,
-				char *			extra);
+				const char *		extra);
 
 /* We may need a function to send a stream of events to user space.
  * More on that later... */
--- wireless-testing.orig/net/wireless/wext.c	2009-07-01 08:59:43.000000000 +0200
+++ wireless-testing/net/wireless/wext.c	2009-07-01 09:01:20.000000000 +0200
@@ -1376,7 +1376,7 @@ static void rtmsg_iwinfo(struct net_devi
 void wireless_send_event(struct net_device *	dev,
 			 unsigned int		cmd,
 			 union iwreq_data *	wrqu,
-			 char *			extra)
+			 const char *		extra)
 {
 	const struct iw_ioctl_description *	descr = NULL;
 	int extra_len = 0;

-- 

