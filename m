Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:58719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752619AbYESMRJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 08:17:09 -0400
Subject: [PATCH] mac80211: don't claim iwspy support
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 19 May 2008 07:18:10 +0200
Message-Id: <1211174290.6252.17.camel@johannes.berg> (sfid-20080519_141726_306099_6F33578B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We removed iwspy support a very long time ago because it is useless, but
forgot to stop claiming to support it. Apparently, nobody cares, but
remove it nonetheless.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
 net/mac80211/wext.c |    1 -
 1 file changed, 1 deletion(-)

--- everything.orig/net/mac80211/wext.c	2008-05-19 07:15:42.000000000 +0200
+++ everything/net/mac80211/wext.c	2008-05-19 07:15:45.000000000 +0200
@@ -221,7 +221,6 @@ static int ieee80211_ioctl_giwrange(stru
 	range->num_frequency = c;
 
 	IW_EVENT_CAPA_SET_KERNEL(range->event_capa);
-	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWTHRSPY);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWAP);
 	IW_EVENT_CAPA_SET(range->event_capa, SIOCGIWSCAN);
 


