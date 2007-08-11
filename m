Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:54990 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbXHKISx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 11 Aug 2007 04:18:53 -0400
Subject: [PATCH] nl80211: fix a bug caused by a missing asterisk
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Aug 2007 10:21:32 +0200
Message-Id: <1186820492.5363.4.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I really dislike double pointers. Oh well.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

---
Just hit it yesterday, oopses the kernel under RNTL so you're screwed.
Not nice.

--- wireless-dev.orig/net/wireless/nl80211.c	2007-08-11 10:19:57.999563528 +0200
+++ wireless-dev/net/wireless/nl80211.c	2007-08-11 10:19:58.559563528 +0200
@@ -55,7 +55,7 @@ static int get_drv_dev_by_info_ifindex(s
 
 	ifindex = nla_get_u32(info->attrs[NL80211_ATTR_IFINDEX]);
 	*dev = dev_get_by_index(ifindex);
-	if (!dev)
+	if (!*dev)
 		return -ENODEV;
 
 	*drv = cfg80211_get_dev_from_ifindex(ifindex);


