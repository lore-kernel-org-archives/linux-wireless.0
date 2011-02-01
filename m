Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:53983 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751414Ab1BAVN4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Feb 2011 16:13:56 -0500
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: backport of alloc_ordered_workqueue into compat.git
Date: Tue,  1 Feb 2011 22:13:47 +0100
Message-Id: <1296594827-30742-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1296594827-30742-1-git-send-email-hauke@hauke-m.de>
References: <1296594827-30742-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The backport of alloc_ordered_workqueue is now in compat.git.

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/36-workqueue.patch |   15 ++-------------
 1 files changed, 2 insertions(+), 13 deletions(-)

diff --git a/patches/36-workqueue.patch b/patches/36-workqueue.patch
index 06e580d..dfa6d8b 100644
--- a/patches/36-workqueue.patch
+++ b/patches/36-workqueue.patch
@@ -1,20 +1,9 @@
 Backport commit 99b88a0ecbdbc6df03527292571b2b442965814a
+The rest is backported in include/linux/compat-2.6.37.h
 
 --- a/net/mac80211/main.c
 +++ b/net/mac80211/main.c
-@@ -787,7 +787,11 @@ int ieee80211_register_hw(struct ieee802
- 		hw->queues = IEEE80211_MAX_QUEUES;
- 
- 	local->workqueue =
-+#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
- 		alloc_ordered_workqueue(wiphy_name(local->hw.wiphy), 0);
-+#else
-+		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
-+#endif
- 	if (!local->workqueue) {
- 		result = -ENOMEM;
- 		goto fail_workqueue;
-@@ -1002,6 +1006,10 @@ static void __exit ieee80211_exit(void)
+@@ -1002,6 +1002,10 @@ static void __exit ieee80211_exit(void)
  	rc80211_minstrel_ht_exit();
  	rc80211_minstrel_exit();
  
-- 
1.7.1

