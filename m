Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:51455 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752687Ab0J0Syx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Oct 2010 14:54:53 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, mcgrof@infradead.org,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/2] compat-wireless: revert workqueue patch
Date: Wed, 27 Oct 2010 20:54:35 +0200
Message-Id: <1288205675-25061-2-git-send-email-hauke@hauke-m.de>
In-Reply-To: <1288205675-25061-1-git-send-email-hauke@hauke-m.de>
References: <1288205675-25061-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This just reverts the workqueue patch commited in
99b88a0ecbdbc6df03527292571b2b442965814a
        mac80211: cancel restart_work explicitly instead of depending on flush_scheduled_work()

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/36-workqueue.patch |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)
 create mode 100644 patches/36-workqueue.patch

diff --git a/patches/36-workqueue.patch b/patches/36-workqueue.patch
new file mode 100644
index 0000000..9bb2705
--- /dev/null
+++ b/patches/36-workqueue.patch
@@ -0,0 +1,27 @@
+Backport commit 99b88a0ecbdbc6df03527292571b2b442965814a
+
+--- a/net/mac80211/main.c
++++ b/net/mac80211/main.c
+@@ -754,7 +754,11 @@ int ieee80211_register_hw(struct ieee802
+ 		hw->queues = IEEE80211_MAX_QUEUES;
+ 
+ 	local->workqueue =
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,37))
+ 		alloc_ordered_workqueue(wiphy_name(local->hw.wiphy), 0);
++#else
++		create_singlethread_workqueue(wiphy_name(local->hw.wiphy));
++#endif
+ 	if (!local->workqueue) {
+ 		result = -ENOMEM;
+ 		goto fail_workqueue;
+@@ -968,6 +972,10 @@ static void __exit ieee80211_exit(void)
+ 	rc80211_minstrel_ht_exit();
+ 	rc80211_minstrel_exit();
+ 
++#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,37))
++	flush_scheduled_work();
++#endif
++
+ 	if (mesh_allocated)
+ 		ieee80211s_stop();
+ 
-- 
1.7.1

