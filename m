Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:39775 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab0LOJrk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 04:47:40 -0500
Received: by wyb28 with SMTP id 28so1266838wyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 01:47:38 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: remove redundant debugfs_remove_recursive() call
Date: Wed, 15 Dec 2010 11:47:54 +0200
Message-Id: <1292406474-3238-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Upon rmmod, the <debugfs>/ieee80211/phyX dir is being removed.
later, we try to remove <debugfs>/ieee80211/phyX/wl12xx, which
might result in NULL dereference.

Remove the excessive debugfs_remove_recursive() call.
(consequently, there is no more need to save wl->rootdir)

Reported-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |   34 ++++++++++++++------------------
 drivers/net/wireless/wl12xx/wl12xx.h  |    1 -
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 8106a6c..86cf1fc 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -293,12 +293,13 @@ static const struct file_operations gpio_power_ops = {
 	.llseek = default_llseek,
 };
 
-static int wl1271_debugfs_add_files(struct wl1271 *wl)
+static int wl1271_debugfs_add_files(struct wl1271 *wl,
+				     struct dentry *rootdir)
 {
 	int ret = 0;
 	struct dentry *entry, *stats;
 
-	stats = debugfs_create_dir("fw-statistics", wl->rootdir);
+	stats = debugfs_create_dir("fw-statistics", rootdir);
 	if (!stats || IS_ERR(stats)) {
 		entry = stats;
 		goto err;
@@ -395,11 +396,11 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl)
 	DEBUGFS_FWSTATS_ADD(rxpipe, missed_beacon_host_int_trig_rx_data);
 	DEBUGFS_FWSTATS_ADD(rxpipe, tx_xfr_host_int_trig_rx_data);
 
-	DEBUGFS_ADD(tx_queue_len, wl->rootdir);
-	DEBUGFS_ADD(retry_count, wl->rootdir);
-	DEBUGFS_ADD(excessive_retries, wl->rootdir);
+	DEBUGFS_ADD(tx_queue_len, rootdir);
+	DEBUGFS_ADD(retry_count, rootdir);
+	DEBUGFS_ADD(excessive_retries, rootdir);
 
-	DEBUGFS_ADD(gpio_power, wl->rootdir);
+	DEBUGFS_ADD(gpio_power, rootdir);
 
 	return 0;
 
@@ -414,7 +415,7 @@ err:
 
 void wl1271_debugfs_reset(struct wl1271 *wl)
 {
-	if (!wl->rootdir)
+	if (!wl->stats.fw_stats)
 		return;
 
 	memset(wl->stats.fw_stats, 0, sizeof(*wl->stats.fw_stats));
@@ -425,13 +426,13 @@ void wl1271_debugfs_reset(struct wl1271 *wl)
 int wl1271_debugfs_init(struct wl1271 *wl)
 {
 	int ret;
+	struct dentry *rootdir;
 
-	wl->rootdir = debugfs_create_dir(KBUILD_MODNAME,
-					 wl->hw->wiphy->debugfsdir);
+	rootdir = debugfs_create_dir(KBUILD_MODNAME,
+				     wl->hw->wiphy->debugfsdir);
 
-	if (IS_ERR(wl->rootdir)) {
-		ret = PTR_ERR(wl->rootdir);
-		wl->rootdir = NULL;
+	if (IS_ERR(rootdir)) {
+		ret = PTR_ERR(rootdir);
 		goto err;
 	}
 
@@ -445,7 +446,7 @@ int wl1271_debugfs_init(struct wl1271 *wl)
 
 	wl->stats.fw_stats_update = jiffies;
 
-	ret = wl1271_debugfs_add_files(wl);
+	ret = wl1271_debugfs_add_files(wl, rootdir);
 
 	if (ret < 0)
 		goto err_file;
@@ -457,8 +458,7 @@ err_file:
 	wl->stats.fw_stats = NULL;
 
 err_fw:
-	debugfs_remove_recursive(wl->rootdir);
-	wl->rootdir = NULL;
+	debugfs_remove_recursive(rootdir);
 
 err:
 	return ret;
@@ -468,8 +468,4 @@ void wl1271_debugfs_exit(struct wl1271 *wl)
 {
 	kfree(wl->stats.fw_stats);
 	wl->stats.fw_stats = NULL;
-
-	debugfs_remove_recursive(wl->rootdir);
-	wl->rootdir = NULL;
-
 }
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index e904c72..da275d0 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -376,7 +376,6 @@ struct wl1271 {
 	int last_rssi_event;
 
 	struct wl1271_stats stats;
-	struct dentry *rootdir;
 
 	__le32 buffer_32;
 	u32 buffer_cmd;
-- 
1.7.0.4

