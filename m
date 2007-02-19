Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:54733 "EHLO silver.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S965112AbXBSWjZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Feb 2007 17:39:25 -0500
From: Jiri Benc <jbenc@suse.cz>
To: "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <20070219233919.221549000.midnight@suse.cz>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 9/12] d80211: remove IEEE80211_HW_FRAGLIST flag
Message-Id: <20070219223955.25305484B0@silver.suse.cz>
Date: Mon, 19 Feb 2007 23:39:55 +0100 (CET)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes@sipsolutions.net>

This patch removes the IEEE80211_HW_FRAGLIST flag as it is neither used
nor makes sense (since we never submit fragmented frames to the master
device.)

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Jiri Benc <jbenc@suse.cz>

---

 include/net/d80211.h   |    4 +---
 net/d80211/ieee80211.c |    2 --
 2 files changed, 1 insertions(+), 5 deletions(-)

2746f09e163ca7d80bbb1ec0419bd47c6b31ec28
diff --git a/include/net/d80211.h b/include/net/d80211.h
index 25a4dca..551fe46 100644
--- a/include/net/d80211.h
+++ b/include/net/d80211.h
@@ -520,9 +520,7 @@ #define IEEE80211_HW_DEVICE_STRIPS_MIC (
 	 * normal operation. */
 #define IEEE80211_HW_MONITOR_DURING_OPER (1<<9)
 
-	/* Set if the low-level driver supports skb fraglist (NETIF_F_FRAGLIST),
-	 * i.e. more than one skb per frame */
-#define IEEE80211_HW_FRAGLIST (1<<10)
+	/* please fill this gap when adding new flags */
 
 	/* calculate Michael MIC for an MSDU when doing hwcrypto */
 #define IEEE80211_HW_TKIP_INCLUDE_MMIC (1<<12)
diff --git a/net/d80211/ieee80211.c b/net/d80211/ieee80211.c
index 0e5f23f..273cba1 100644
--- a/net/d80211/ieee80211.c
+++ b/net/d80211/ieee80211.c
@@ -4640,8 +4640,6 @@ int ieee80211_register_hw(struct ieee802
 	if (result < 0)
 		goto fail_sta_info;
 
-	if (hw->flags & IEEE80211_HW_FRAGLIST)
-		local->mdev->features |= NETIF_F_FRAGLIST;
 	rtnl_lock();
 	result = dev_alloc_name(local->mdev, local->mdev->name);
 	if (result < 0) {
-- 
1.3.0

