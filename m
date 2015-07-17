Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f175.google.com ([209.85.212.175]:35751 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756995AbbGQHNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 03:13:47 -0400
Received: by wibxm9 with SMTP id xm9so31466397wib.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 00:13:46 -0700 (PDT)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 3/4] mwifiex: remove CMD_F_CANCELED flag
Date: Fri, 17 Jul 2015 09:13:05 +0200
Message-Id: <1437117186-25243-4-git-send-email-afenkart@gmail.com> (sfid-20150717_091349_662975_86F6F09D)
In-Reply-To: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
References: <1437117186-25243-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

CMD_F_CANCELED was used to abort mwifiex_process_cmdresp in
case it already started or starts processing the cmd.
But this was probably not working the way intended:
- it is racy: mwifiex_process_cmdresp might already have passed that
  test and is continuing to use the cmd node being recycled
- mwifiex_process_cmdresp repeatedly uses adapter->curr_cmd which
  we just set to NULL
- mwifiex_recycle_cmd_node will clear the flag

The reason why it probably works is that mwifiex_cancel_pending_ioctl
is only called from mwifiex_cmd_timeout_func, where the there is little
chance of a command response still arriving

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 23 ++++++++++-------------
 drivers/net/wireless/mwifiex/fw.h     |  1 -
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 87b6dee..6458e17 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -807,17 +807,6 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	adapter->is_cmd_timedout = 0;
 
 	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
-	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
-		mwifiex_dbg(adapter, ERROR,
-			    "CMD_RESP: %#x been canceled\n",
-			    le16_to_cpu(resp->command));
-		mwifiex_recycle_cmd_node(adapter, adapter->curr_cmd);
-		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->curr_cmd = NULL;
-		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		return -1;
-	}
-
 	if (adapter->curr_cmd->cmd_flag & CMD_F_HOSTCMD) {
 		/* Copy original response back to response buffer */
 		struct mwifiex_ds_misc_cmd *hostcmd;
@@ -1090,10 +1079,18 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 	    (adapter->curr_cmd->wait_q_enabled)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		cmd_node = adapter->curr_cmd;
-		cmd_node->cmd_flag |= CMD_F_CANCELED;
-		mwifiex_recycle_cmd_node(adapter, cmd_node);
+		/* setting curr_cmd to NULL is quite dangerous, because
+		 * mwifiex_process_cmdresp checks curr_cmd to be != NULL
+		 * at the beginning then relies on it and dereferences
+		 * it at will
+		 * this probably works since mwifiex_cmd_timeout_func
+		 * is the only caller of this function and responses
+		 * at that point
+		 */
 		adapter->curr_cmd = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
+
+		mwifiex_recycle_cmd_node(adapter, cmd_node);
 	}
 
 	/* Cancel all pending scan command */
diff --git a/drivers/net/wireless/mwifiex/fw.h b/drivers/net/wireless/mwifiex/fw.h
index cd09051..c71e6b2 100644
--- a/drivers/net/wireless/mwifiex/fw.h
+++ b/drivers/net/wireless/mwifiex/fw.h
@@ -432,7 +432,6 @@ enum P2P_MODES {
 
 
 #define CMD_F_HOSTCMD           (1 << 0)
-#define CMD_F_CANCELED          (1 << 1)
 
 #define HostCmd_CMD_ID_MASK             0x0fff
 
-- 
2.1.4

