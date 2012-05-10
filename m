Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:51169 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758764Ab2EJJRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 05:17:14 -0400
Received: by mail-wi0-f172.google.com with SMTP id hr2so244170wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 02:17:14 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 74/78] wlcore/wl12xx/wl18xx: move lower driver debugfs to a subdir
Date: Thu, 10 May 2012 12:14:19 +0300
Message-Id: <1336641263-5761-75-git-send-email-arik@wizery.com> (sfid-20120510_111722_999386_3279FF72)
In-Reply-To: <1336641263-5761-1-git-send-email-arik@wizery.com>
References: <1336641263-5761-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

Instead of adding more files from the lower drivers into the same
directory in debugfs as wlcore, we now add a subdirectory for the
lower driver.  This makes things a bit easier, because we can quickly
see where the debugfs entry is implemented and what is specific to the
lower driver.

Signed-off-by: Luciano Coelho <coelho@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/debugfs.c |   10 ++++++++--
 drivers/net/wireless/ti/wl12xx/main.c    |    7 +------
 drivers/net/wireless/ti/wl18xx/debugfs.c |   10 ++++++++--
 drivers/net/wireless/ti/wl18xx/main.c    |    7 +------
 4 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/debugfs.c b/drivers/net/wireless/ti/wl12xx/debugfs.c
index 311703d..0521cbf 100644
--- a/drivers/net/wireless/ti/wl12xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl12xx/debugfs.c
@@ -126,9 +126,15 @@ int wl12xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
 	int ret = 0;
-	struct dentry *entry, *stats;
+	struct dentry *entry, *stats, *moddir;
 
-	stats = debugfs_create_dir("wl12xx_fw_stats", rootdir);
+	moddir = debugfs_create_dir(KBUILD_MODNAME, rootdir);
+	if (!moddir || IS_ERR(moddir)) {
+		entry = moddir;
+		goto err;
+	}
+
+	stats = debugfs_create_dir("fw_stats", moddir);
 	if (!stats || IS_ERR(stats)) {
 		entry = stats;
 		goto err;
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 2ac8407..ba5afa4 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1360,11 +1360,6 @@ out:
 	return ret;
 }
 
-static int wl12xx_debugfs_init(struct wl1271 *wl, struct dentry *rootdir)
-{
-	return wl12xx_debugfs_add_files(wl, rootdir);
-}
-
 static struct wlcore_ops wl12xx_ops = {
 	.identify_chip		= wl12xx_identify_chip,
 	.identify_fw		= wl12xx_identify_fw,
@@ -1387,7 +1382,7 @@ static struct wlcore_ops wl12xx_ops = {
 	.set_tx_desc_csum	= wl12xx_set_tx_desc_csum,
 	.set_rx_csum		= NULL,
 	.ap_get_mimo_wide_rate_mask = NULL,
-	.debugfs_init		= wl12xx_debugfs_init,
+	.debugfs_init		= wl12xx_debugfs_add_files,
 };
 
 static struct ieee80211_sta_ht_cap wl12xx_ht_cap = {
diff --git a/drivers/net/wireless/ti/wl18xx/debugfs.c b/drivers/net/wireless/ti/wl18xx/debugfs.c
index 8354dfc..f4127bf 100644
--- a/drivers/net/wireless/ti/wl18xx/debugfs.c
+++ b/drivers/net/wireless/ti/wl18xx/debugfs.c
@@ -181,9 +181,15 @@ int wl18xx_debugfs_add_files(struct wl1271 *wl,
 			     struct dentry *rootdir)
 {
 	int ret = 0;
-	struct dentry *entry, *stats;
+	struct dentry *entry, *stats, *moddir;
 
-	stats = debugfs_create_dir("wl18xx_fw_stats", rootdir);
+	moddir = debugfs_create_dir(KBUILD_MODNAME, rootdir);
+	if (!moddir || IS_ERR(moddir)) {
+		entry = moddir;
+		goto err;
+	}
+
+	stats = debugfs_create_dir("fw_stats", moddir);
 	if (!stats || IS_ERR(stats)) {
 		entry = stats;
 		goto err;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 524f44c..27cd9b8 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1022,11 +1022,6 @@ static void wl18xx_get_mac(struct wl1271 *wl)
 	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 }
 
-static int wl18xx_debugfs_init(struct wl1271 *wl, struct dentry *rootdir)
-{
-	return wl18xx_debugfs_add_files(wl, rootdir);
-}
-
 static int wl18xx_handle_static_data(struct wl1271 *wl,
 				     struct wl1271_static_data *static_data)
 {
@@ -1058,7 +1053,7 @@ static struct wlcore_ops wl18xx_ops = {
 	.sta_get_ap_rate_mask = wl18xx_sta_get_ap_rate_mask,
 	.ap_get_mimo_wide_rate_mask = wl18xx_ap_get_mimo_wide_rate_mask,
 	.get_mac	= wl18xx_get_mac,
-	.debugfs_init	= wl18xx_debugfs_init,
+	.debugfs_init	= wl18xx_debugfs_add_files,
 	.handle_static_data	= wl18xx_handle_static_data,
 };
 
-- 
1.7.9.5

