Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dakia2.marvell.com ([65.219.4.35]:59747 "EHLO
	dakia2.marvell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932960Ab0LTT0o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Dec 2010 14:26:44 -0500
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 1/3] mwifiex: solve kernel dump issue for debugfs command 'debug'
Date: Mon, 20 Dec 2010 11:26:45 -0800
Message-Id: <1292873207-9318-1-git-send-email-bzhao@marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Issue is when card is reinserted (without unloading the driver),
"cat /debugfs/mwifiex/mlan0/debug" command gives kernel dump.

Actually while handling this command some elements of "struct
mwifiex_adapter *adapter"and "struct mwifiex_debug_info *info"
are read by adding structure address to element offset
and displayed them to console.
When the card is reinserted, mwifiex_dev_debugfs_init() function
is called and addresses used for reading those elements (which are
correct ones) are unnecessorily incremented by structure addresses.

Fixed this issue by using separate variable to store final address
while reading structure elements instead of incrementing same
variable.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c |   16 +++++-----------
 1 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index 9d23c68..2b642f1 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -430,7 +430,11 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 		p += sprintf(p, "%s=", d[i].name);
 
 		size = d[i].size / d[i].num;
-		addr = d[i].addr;
+
+		if (i < (num_of_items - 3))
+			addr = d[i].addr + (size_t) &info;
+		else /* The last 3 items are struct mwifiex_adapter variables */
+			addr = d[i].addr + (size_t) priv->adapter;
 
 		for (j = 0; j < d[i].num; j++) {
 			switch (size) {
@@ -2459,8 +2463,6 @@ MWIFIEX_DFS_FILE_READ_OPS(esuppmode);
 void
 mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 {
-	int i;
-
 	ENTER();
 
 	if (!mwifiex_dfs_dir || !priv)
@@ -2472,14 +2474,6 @@ mwifiex_dev_debugfs_init(struct mwifiex_private *priv)
 	if (!priv->dfs_dev_dir)
 		goto exit;
 
-	/* The last 3 items are struct mwifiex_adapter variables */
-	for (i = 0; i < num_of_items - 3; i++)
-		items[i].addr += (size_t) &info;
-
-	for (; i < num_of_items; i++)
-		items[i].addr += (size_t) priv->adapter;
-
-
 	MWIFIEX_DFS_ADD_FILE(info);
 	MWIFIEX_DFS_ADD_FILE(debug);
 	MWIFIEX_DFS_ADD_FILE(deepsleep);
-- 
1.7.0.2

