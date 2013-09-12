Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:45079 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539Ab3ILPe1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Sep 2013 11:34:27 -0400
From: Vladimir Murzin <murzin.v@gmail.com>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Cc: coelho@ti.com, linville@tuxdriver.com,
	Vladimir Murzin <murzin.v@gmail.com>
Subject: [PATCH 3/3] wlcore: limit base for output buffer in dev_mem_read
Date: Thu, 12 Sep 2013 17:32:23 +0200
Message-Id: <1378999943-1968-4-git-send-email-murzin.v@gmail.com> (sfid-20130912_173436_030185_B9E609F4)
In-Reply-To: <1378999943-1968-1-git-send-email-murzin.v@gmail.com>
References: <1378999943-1968-1-git-send-email-murzin.v@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

dev_mem_read tries to speed up things a bit by limiting output
buffer which can not exceed WLCORE_MAX_BLOCK_SIZE. However,
WLCORE_MAX_BLOCK_SIZE is based on PAGE_SIZE which may vary.

Use 4K size base for buffer explicitly.

Signed-off-by: Vladimir Murzin <murzin.v@gmail.com>
---
 drivers/net/wireless/ti/wlcore/debugfs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index e17630c..6b413a7 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -38,7 +38,8 @@
 /* ms */
 #define WL1271_DEBUGFS_STATS_LIFETIME 1000
 
-#define WLCORE_MAX_BLOCK_SIZE ((size_t)(4*PAGE_SIZE))
+#define WLCORE_PAGE_SIZE	4096
+#define WLCORE_MAX_BLOCK_SIZE ((size_t)(4*WLCORE_PAGE_SIZE))
 
 /* debugfs macros idea from mac80211 */
 int wl1271_format_buffer(char __user *userbuf, size_t count,
-- 
1.7.10.4

