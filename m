Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:35662 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760212Ab2EQQGC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 May 2012 12:06:02 -0400
Received: by wibhm6 with SMTP id hm6so106142wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 09:05:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] cfg80211: fix memory leak/corruption of bss_list
Date: Thu, 17 May 2012 19:06:08 +0300
Message-Id: <1337270768-22719-1-git-send-email-eliad@wizery.com> (sfid-20120517_180607_739105_AD6C5A0A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

cfg80211_dev_free() calls cfg80211_put_bss() directly on all
the remaining bss entries, skipping the proper bss entry
cleanup that usually made by __cfg80211_unlink_bss(), and
leaving the bss_list and the rb_tree with dangling pointers.

Fix it by calling cfg80211_unlink_bss() instead.

Cc: stable@vger.kernel.org
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 net/wireless/core.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/wireless/core.c b/net/wireless/core.c
index 4e86a86..232c385 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -729,7 +729,7 @@ void cfg80211_dev_free(struct cfg80211_registered_device *rdev)
 	mutex_destroy(&rdev->devlist_mtx);
 	mutex_destroy(&rdev->sched_scan_mtx);
 	list_for_each_entry_safe(scan, tmp, &rdev->bss_list, list)
-		cfg80211_put_bss(&scan->pub);
+		cfg80211_unlink_bss(&rdev->wiphy, &scan->pub);
 	kfree(rdev);
 }
 
-- 
1.7.6.401.g6a319

