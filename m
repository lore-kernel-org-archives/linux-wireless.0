Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59771 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0LQD4s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Dec 2010 22:56:48 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: use debugfs_remove_recursive()
Date: Thu, 16 Dec 2010 19:56:46 -0800
Message-Id: <1292558206-29423-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

instead of keeping pointers to all entries.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Kiran Divekar <dkiran@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c |   36 +++----------------------------
 drivers/net/wireless/mwifiex/main.h    |   23 --------------------
 2 files changed, 4 insertions(+), 55 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 4ea5cbc..9d23c68 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -2404,14 +2404,9 @@ exit:
 }
 
 #define MWIFIEX_DFS_ADD_FILE(name) do {                                 \
-	priv->dfs_##name =                                              \
-	debugfs_create_file(#name, 0644, priv->dfs_dev_dir,             \
-			priv, &mwifiex_dfs_##name##_fops);              \
-} while (0);
-
-#define MWIFIEX_DFS_REM_FILE(name) do {                                 \
-	if (priv->dfs_##name)                                           \
-		debugfs_remove(priv->dfs_##name);                       \
+	if (!debugfs_create_file(#name, 0644, priv->dfs_dev_dir,        \
+			priv, &mwifiex_dfs_##name##_fops))              \
+		goto exit;                                               \
 } while (0);
 
 #define MWIFIEX_DFS_FILE_OPS(name)                                      \
@@ -2524,30 +2519,7 @@ mwifiex_dev_debugfs_remove(struct mwifiex_private *priv)
 	if (!priv)
 		goto exit;
 
-	MWIFIEX_DFS_REM_FILE(info);
-	MWIFIEX_DFS_REM_FILE(debug);
-	MWIFIEX_DFS_REM_FILE(deepsleep);
-	MWIFIEX_DFS_REM_FILE(hscfg);
-	MWIFIEX_DFS_REM_FILE(amsduaggrctrl);
-	MWIFIEX_DFS_REM_FILE(txaggrprio);
-	MWIFIEX_DFS_REM_FILE(sleeppd);
-	MWIFIEX_DFS_REM_FILE(mpactrl);
-	MWIFIEX_DFS_REM_FILE(qoscfg);
-	MWIFIEX_DFS_REM_FILE(atimwindow);
-	MWIFIEX_DFS_REM_FILE(txratecfg);
-	MWIFIEX_DFS_REM_FILE(addbapara);
-	MWIFIEX_DFS_REM_FILE(addbareject);
-	MWIFIEX_DFS_REM_FILE(httxcfg);
-	MWIFIEX_DFS_REM_FILE(htcapinfo);
-	MWIFIEX_DFS_REM_FILE(getlog);
-	MWIFIEX_DFS_REM_FILE(antcfg);
-	MWIFIEX_DFS_REM_FILE(regrdwr);
-	MWIFIEX_DFS_REM_FILE(rdeeprom);
-	MWIFIEX_DFS_REM_FILE(drvdbg);
-	MWIFIEX_DFS_REM_FILE(txbufcfg);
-	MWIFIEX_DFS_REM_FILE(passphrase);
-	MWIFIEX_DFS_REM_FILE(esuppmode);
-	MWIFIEX_DFS_REM_FILE(dev_dir);
+	debugfs_remove_recursive(priv->dfs_dev_dir);
 exit:
 	LEAVE();
 }
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 8bb8b45..646cc55 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -419,29 +419,6 @@ struct mwifiex_private {
 	char version_str[128];
 #ifdef CONFIG_DEBUG_FS
 	struct dentry *dfs_dev_dir;
-	struct dentry *dfs_info;
-	struct dentry *dfs_debug;
-	struct dentry *dfs_deepsleep;
-	struct dentry *dfs_hscfg;
-	struct dentry *dfs_amsduaggrctrl;
-	struct dentry *dfs_txaggrprio;
-	struct dentry *dfs_sleeppd;
-	struct dentry *dfs_mpactrl;
-	struct dentry *dfs_qoscfg;
-	struct dentry *dfs_atimwindow;
-	struct dentry *dfs_txratecfg;
-	struct dentry *dfs_addbapara;
-	struct dentry *dfs_addbareject;
-	struct dentry *dfs_httxcfg;
-	struct dentry *dfs_htcapinfo;
-	struct dentry *dfs_getlog;
-	struct dentry *dfs_antcfg;
-	struct dentry *dfs_regrdwr;
-	struct dentry *dfs_rdeeprom;
-	struct dentry *dfs_drvdbg;
-	struct dentry *dfs_txbufcfg;
-	struct dentry *dfs_passphrase;
-	struct dentry *dfs_esuppmode;
 #endif
 	u8 nick_name[16];
 	bool is_adhoc_link_sensed;
-- 
1.7.0.2

