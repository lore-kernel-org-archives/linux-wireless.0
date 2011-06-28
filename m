Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:34433 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760816Ab1F1SkE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Jun 2011 14:40:04 -0400
From: Hauke Mehrtens <hauke@hauke-m.de>
To: mcgrof@gmail.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH] compat: replace genl_dump_check_consistent
Date: Tue, 28 Jun 2011 20:39:57 +0200
Message-Id: <1309286397-12541-1-git-send-email-hauke@hauke-m.de> (sfid-20110628_205756_721901_4179CFBB)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove the usage of genl_dump_check_consistent from the code.

This was introduced in:
commit 9720bb3ab0b80659c63ed337eab66104a4156db0
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Tue Jun 21 09:45:33 2011 +0200

    nl80211: use netlink consistent dump feature for BSS dumps

Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
---
 include/linux/compat-3.1.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/include/linux/compat-3.1.h b/include/linux/compat-3.1.h
index 855490e..be68c81 100644
--- a/include/linux/compat-3.1.h
+++ b/include/linux/compat-3.1.h
@@ -22,6 +22,8 @@
 #define br_port_exists(dev)	(dev->br_port)
 #endif
 
+#define genl_dump_check_consistent(cb, user_hdr, family)
+
 #endif /* (LINUX_VERSION_CODE < KERNEL_VERSION(3,1,0)) */
 
 #endif /* LINUX_3_1_COMPAT_H */
-- 
1.7.4.1

