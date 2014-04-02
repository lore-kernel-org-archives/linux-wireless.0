Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37859 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756889AbaDBCIQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Apr 2014 22:08:16 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so10792598pbb.33
        for <linux-wireless@vger.kernel.org>; Tue, 01 Apr 2014 19:08:16 -0700 (PDT)
From: Fariya Fatima <fariyaf@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Fariya Fatima <fariyaf@gmail.com>
Subject: [PATCH 1/6] rsi: Potential null pointer derefernce issue fixed.
Date: Wed,  2 Apr 2014 07:38:00 +0530
Message-Id: <1396404485-3989-2-git-send-email-fariyaf@gmail.com> (sfid-20140402_040820_315721_29CF95A3)
In-Reply-To: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
References: <1396404485-3989-1-git-send-email-fariyaf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fariya Fatima <fariyaf@gmail.com>

Signed-off-by: Fariya Fatima <fariyaf@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_debugfs.c |   35 ++++++++++++---------------
 1 files changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_debugfs.c b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
index 7e4ef45..c466246 100644
--- a/drivers/net/wireless/rsi/rsi_91x_debugfs.c
+++ b/drivers/net/wireless/rsi/rsi_91x_debugfs.c
@@ -289,32 +289,29 @@ int rsi_init_dbgfs(struct rsi_hw *adapter)
 	const struct rsi_dbg_files *files;
 
 	dev_dbgfs = kzalloc(sizeof(*dev_dbgfs), GFP_KERNEL);
+	if (!dev_dbgfs)
+		return -ENOMEM;
+
 	adapter->dfsentry = dev_dbgfs;
 
 	snprintf(devdir, sizeof(devdir), "%s",
 		 wiphy_name(adapter->hw->wiphy));
-	dev_dbgfs->subdir = debugfs_create_dir(devdir, NULL);
 
-	if (IS_ERR(dev_dbgfs->subdir)) {
-		if (dev_dbgfs->subdir == ERR_PTR(-ENODEV))
-			rsi_dbg(ERR_ZONE,
-				"%s:Debugfs has not been mounted\n", __func__);
-		else
-			rsi_dbg(ERR_ZONE, "debugfs:%s not created\n", devdir);
+	dev_dbgfs->subdir = debugfs_create_dir(devdir, NULL);
 
-		adapter->dfsentry = NULL;
+	if (!dev_dbgfs->subdir) {
 		kfree(dev_dbgfs);
-		return (int)PTR_ERR(dev_dbgfs->subdir);
-	} else {
-		for (ii = 0; ii < adapter->num_debugfs_entries; ii++) {
-			files = &dev_debugfs_files[ii];
-			dev_dbgfs->rsi_files[ii] =
-			debugfs_create_file(files->name,
-					    files->perms,
-					    dev_dbgfs->subdir,
-					    common,
-					    &files->fops);
-		}
+		return -ENOMEM;
+	}
+
+	for (ii = 0; ii < adapter->num_debugfs_entries; ii++) {
+		files = &dev_debugfs_files[ii];
+		dev_dbgfs->rsi_files[ii] =
+		debugfs_create_file(files->name,
+				    files->perms,
+				    dev_dbgfs->subdir,
+				    common,
+				    &files->fops);
 	}
 	return 0;
 }
-- 
1.7.5.4

