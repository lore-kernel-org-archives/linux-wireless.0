Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34422 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876Ab1F1SjV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:39:21 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 2/3] compat-wireless: do not set netlink seq.
Date: Tue, 28 Jun 2011 20:38:51 +0200
Message-Id: <1309286332-12470-2-git-send-email-hauke@hauke-m.de> (sfid-20110628_205756_187632_F282269B)
In-Reply-To: <1309286332-12470-1-git-send-email-hauke@hauke-m.de>
References: <1309286332-12470-1-git-send-email-hauke@hauke-m.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This member is not available in older kernel versions.

This was introduced in commit:
commit 9720bb3ab0b80659c63ed337eab66104a4156db0
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Jun 21 09:45:33 2011 +0200

    nl80211: use netlink consistent dump feature for BSS dumps

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 patches/42-netlink_seq.patch |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)
 create mode 100644 patches/42-netlink_seq.patch

diff --git a/patches/42-netlink_seq.patch b/patches/42-netlink_seq.patch
new file mode 100644
index 0000000..2897b40
--- /dev/null
+++ b/patches/42-netlink_seq.patch
@@ -0,0 +1,12 @@
+--- a/net/wireless/nl80211.c
++++ b/net/wireless/nl80211.c
+@@ -3728,7 +3728,9 @@ static int nl80211_dump_scan(struct sk_b
+ 	spin_lock_bh(&rdev->bss_lock);
+ 	cfg80211_bss_expire(rdev);
+ 
++#if (LINUX_VERSION_CODE >= KERNEL_VERSION(3,1,0))
+ 	cb->seq = rdev->bss_generation;
++#endif
+ 
+ 	list_for_each_entry(scan, &rdev->bss_list, list) {
+ 		if (++idx <= start)
-- 
1.7.4.1

