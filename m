Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:51544 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966235AbXBPJBm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Feb 2007 04:01:42 -0500
Subject: [PATCH] remove IEEE80211_HW_FRAGLIST flag
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jiri Benc <jbenc@suse.cz>
Content-Type: text/plain
Date: Thu, 15 Feb 2007 20:53:01 +0100
Message-Id: <1171569181.5220.60.camel@johannes.berg>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the IEEE80211_HW_FRAGLIST flag as it is neither used
nor makes sense (since we never submit fragmented frames to the master
device.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
---
Looking through the hw flags I found this one. I can't see how it makes
sense at all, I don't see how a frame can end up being submitted in
fragments to the master device. So how about this patch?

Besides, should we ever want to submit fragmented frames we'll need to
test and verify that anyway so it makes more sense to add the flag back
when we do.

Please apply or otherwise tell me how the flag makes sense.

--- wireless-dev.orig/include/net/d80211.h	2007-02-15 20:49:00.554294167
+0100
+++ wireless-dev/include/net/d80211.h	2007-02-15 20:49:24.884294167 +0100
@@ -522,9 +522,7 @@ struct ieee80211_hw {
 	 * normal operation. */
 #define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
 
-	/* Set if the low-level driver supports skb fraglist (NETIF_F_FRAGLIST),
-	 * i.e. more than one skb per frame */
-#define IEEE80211_HW_FRAGLIST (1<<10)
+	/* please fill this gap when adding new flags */
 
 	/* calculate Michael MIC for an MSDU when doing hwcrypto */
 #define IEEE80211_HW_TKIP_INCLUDE_MMIC (1<<12)
--- wireless-dev.orig/net/d80211/ieee80211.c	2007-02-15 20:49:35.134294167 +0100
+++ wireless-dev/net/d80211/ieee80211.c	2007-02-15 20:49:40.414294167 +0100
@@ -4640,8 +4640,6 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		goto fail_sta_info;
 
-	if (hw->flags & IEEE80211_HW_FRAGLIST)
-		local->mdev->features |= NETIF_F_FRAGLIST;
 	rtnl_lock();
 	result = dev_alloc_name(local->mdev, local->mdev->name);
 	if (result < 0) {


