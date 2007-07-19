Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nz-out-0506.google.com ([64.233.162.237]:25644 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S938656AbXGSN7b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2007 09:59:31 -0400
Received: by nz-out-0506.google.com with SMTP id s18so489095nze
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2007 06:59:30 -0700 (PDT)
Date: Thu, 19 Jul 2007 21:59:23 +0800
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: [PATCH] drivers/net/wireless/libertas/cmd.c: fix  adapter->driver_lock dereference
Message-ID: <20070719135923.GA29142@kernel.sg>
Reply-To: Eugene Teo <eugeneteo@kernel.sg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
From: Eugene Teo <eugeneteo@kernel.sg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

adapter is NULL if cmdnode is not.

Signed-off-by: Eugene Teo <eugeneteo@kernel.sg>
---
 drivers/net/wireless/libertas/cmd.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/libertas/cmd.c b/drivers/net/wireless/libertas/cmd.c
index 4a8f5dc..03af8bb 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -941,7 +941,7 @@ static int DownloadcommandToStation(wlan_private * priv,
 	unsigned long flags;
 	struct cmd_ds_command *cmdptr;
 	wlan_adapter *adapter = priv->adapter;
-	int ret = 0;
+	int ret = -1;
 	u16 cmdsize;
 	u16 command;
 
@@ -950,12 +950,6 @@ static int DownloadcommandToStation(wlan_private * priv,
 	if (!adapter || !cmdnode) {
 		lbs_deb_cmd("DNLD_CMD: adapter = %p, cmdnode = %p\n",
 		       adapter, cmdnode);
-		if (cmdnode) {
-			spin_lock_irqsave(&adapter->driver_lock, flags);
-			__libertas_cleanup_and_insert_cmd(priv, cmdnode);
-			spin_unlock_irqrestore(&adapter->driver_lock, flags);
-		}
-		ret = -1;
 		goto done;
 	}
 
@@ -968,7 +962,6 @@ static int DownloadcommandToStation(wlan_private * priv,
 		       "Not sending\n");
 		__libertas_cleanup_and_insert_cmd(priv, cmdnode);
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
-		ret = -1;
 		goto done;
 	}
 
@@ -993,7 +986,6 @@ static int DownloadcommandToStation(wlan_private * priv,
 		__libertas_cleanup_and_insert_cmd(priv, adapter->cur_cmd);
 		adapter->cur_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->driver_lock, flags);
-		ret = -1;
 		goto done;
 	}
 
-- 
1.5.2.2

