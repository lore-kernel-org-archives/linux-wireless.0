Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58091 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546Ab0KXKxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 05:53:04 -0500
Received: by bwz15 with SMTP id 15so8073263bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 02:53:03 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luciano.coelho@nokia.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2] wl1271: move wl12xx debugfs directory to under wiphy's debugfs
Date: Wed, 24 Nov 2010 12:53:16 +0200
Message-Id: <1290595996-2049-2-git-send-email-eliad@wizery.com>
In-Reply-To: <1290595996-2049-1-git-send-email-eliad@wizery.com>
References: <1290595996-2049-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use per-device debugfs path, so multiple devices won't collide.

in order to use wl->hw->wiphy->debugfsdir, we have to move the debugfs
creation from wl1271_debugfs_init() to wl1271_register_hw().

Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/debugfs.c |    3 ++-
 drivers/net/wireless/wl12xx/main.c    |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/debugfs.c b/drivers/net/wireless/wl12xx/debugfs.c
index 402df14..2ac289e 100644
--- a/drivers/net/wireless/wl12xx/debugfs.c
+++ b/drivers/net/wireless/wl12xx/debugfs.c
@@ -423,7 +423,8 @@ int wl1271_debugfs_init(struct wl1271 *wl)
 {
 	int ret;
 
-	wl->rootdir = debugfs_create_dir(KBUILD_MODNAME, NULL);
+	wl->rootdir = debugfs_create_dir(KBUILD_MODNAME,
+					 wl->hw->wiphy->debugfsdir);
 
 	if (IS_ERR(wl->rootdir)) {
 		ret = PTR_ERR(wl->rootdir);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 31f0e2f..9e0181a 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2578,6 +2578,8 @@ int wl1271_register_hw(struct wl1271 *wl)
 
 	wl->mac80211_registered = true;
 
+	wl1271_debugfs_init(wl);
+
 	register_netdevice_notifier(&wl1271_dev_notifier);
 
 	wl1271_notice("loaded");
@@ -2712,8 +2714,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	/* Apply default driver configuration. */
 	wl1271_conf_init(wl);
 
-	wl1271_debugfs_init(wl);
-
 	order = get_order(WL1271_AGGR_BUFFER_SIZE);
 	wl->aggr_buf = (u8 *)__get_free_pages(GFP_KERNEL, order);
 	if (!wl->aggr_buf) {
-- 
1.7.0.4

