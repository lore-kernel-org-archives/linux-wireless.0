Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:55723 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755376AbXH3OGe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Aug 2007 10:06:34 -0400
Subject: [PATCH net-2.6.24/wireless-dev] mac80211: remove spy wext ioctls
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 30 Aug 2007 16:07:45 +0200
Message-Id: <1188482865.3978.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

mac80211 never calls wireless_spy_update so these aren't
useful.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Patch should apply against both trees.

 net/mac80211/ieee80211_ioctl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- wireless-dev.orig/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:36:01.692051253 +0200
+++ wireless-dev/net/mac80211/ieee80211_ioctl.c	2007-08-30 14:36:02.392051253 +0200
@@ -2072,10 +2072,10 @@ static const iw_handler ieee80211_handle
 	(iw_handler) NULL /* kernel code */,		/* SIOCGIWPRIV */
 	(iw_handler) NULL /* not used */,		/* SIOCSIWSTATS */
 	(iw_handler) NULL /* kernel code */,		/* SIOCGIWSTATS */
-	iw_handler_set_spy,				/* SIOCSIWSPY */
-	iw_handler_get_spy,				/* SIOCGIWSPY */
-	iw_handler_set_thrspy,				/* SIOCSIWTHRSPY */
-	iw_handler_get_thrspy,				/* SIOCGIWTHRSPY */
+	(iw_handler) NULL,				/* SIOCSIWSPY */
+	(iw_handler) NULL,				/* SIOCGIWSPY */
+	(iw_handler) NULL,				/* SIOCSIWTHRSPY */
+	(iw_handler) NULL,				/* SIOCGIWTHRSPY */
 	(iw_handler) ieee80211_ioctl_siwap,		/* SIOCSIWAP */
 	(iw_handler) ieee80211_ioctl_giwap,		/* SIOCGIWAP */
 	(iw_handler) ieee80211_ioctl_siwmlme,		/* SIOCSIWMLME */


