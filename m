Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40284 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754709Ab1ALJfK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Jan 2011 04:35:10 -0500
Received: by ewy5 with SMTP id 5so140635ewy.19
        for <linux-wireless@vger.kernel.org>; Wed, 12 Jan 2011 01:35:09 -0800 (PST)
From: Guy Eilam <guy@wizery.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH] wl12xx: change debug_level module param sysfs permissions
Date: Wed, 12 Jan 2011 11:33:29 +0200
Message-Id: <1294824809-8364-1-git-send-email-guy@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

changed the visibility of the debug_level module parameter
in the filesystem to be readable and writable to the root user.
It is now accessible under /sys/module/wl12xx/parameters

removed the debug_level debugfs file that was created under
/sys/kernel/debug/...

Signed-off-by: Guy Eilam <guy@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    5 -----
 drivers/net/wireless/wl12xx/main.c    |    4 ++--
 2 files changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 36e7ec1..dc3ca00 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -402,11 +402,6 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 
 	DEBUGFS_ADD(gpio_power, rootdir);
 
-	entry = debugfs_create_x32("debug_level", 0600, rootdir,
-				   &wl12xx_debug_level);
-	if (!entry || IS_ERR(entry))
-		goto err;
-
 	return 0;
 
 err:
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 45a9d2f..03dcd8f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2893,9 +2893,9 @@ int wl1271_free_hw(struct wl1271 *wl)
 }
 EXPORT_SYMBOL_GPL(wl1271_free_hw);
 
-u32 wl12xx_debug_level;
+u32 wl12xx_debug_level = DEBUG_NONE;
 EXPORT_SYMBOL_GPL(wl12xx_debug_level);
-module_param_named(debug_level, wl12xx_debug_level, uint, DEBUG_NONE);
+module_param_named(debug_level, wl12xx_debug_level, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(debug_level, "wl12xx debugging level");
 
 MODULE_LICENSE("GPL");
-- 
1.7.1

