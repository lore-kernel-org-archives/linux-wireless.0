Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:35189 "EHLO
	mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585AbcBYAJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:09:13 -0500
Received: by mail-wm0-f51.google.com with SMTP id c200so5769742wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:09:12 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 7/7] mwifiex: make mwifiex_insert_cmd_to_free_q local static
Date: Thu, 25 Feb 2016 01:08:52 +0100
Message-Id: <1456358932-23114-8-git-send-email-afenkart@gmail.com> (sfid-20160225_010918_335619_225792BF)
In-Reply-To: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

after factoring out mwifiex_cancel_pending_scan_cmd
the function is noc called outside of cmdevt file

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c | 6 +++++-
 drivers/net/wireless/marvell/mwifiex/main.h   | 2 --
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index 61426b3..4b0f44d 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -26,6 +26,10 @@
 #include "11n.h"
 #include "11ac.h"
 
+static void
+mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
+			     struct cmd_ctrl_node *cmd_node);
+
 /*
  * This function initializes a command node.
  *
@@ -619,7 +623,7 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
  * The function also calls the completion callback if required, before
  * cleaning the command node and re-inserting it into the free queue.
  */
-void
+static void
 mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 			     struct cmd_ctrl_node *cmd_node)
 {
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index f71f894..840e5d4 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1045,8 +1045,6 @@ void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_scan_cmd(struct mwifiex_adapter *adapter);
 
-void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
-				  struct cmd_ctrl_node *cmd_node);
 void mwifiex_recycle_cmd_node(struct mwifiex_adapter *adapter,
 			      struct cmd_ctrl_node *cmd_node);
 
-- 
2.7.0

