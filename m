Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:34050 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935183AbcCJIob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2016 03:44:31 -0500
Received: by mail-wm0-f49.google.com with SMTP id p65so18587456wmp.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Mar 2016 00:44:30 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Julian Calaby <julian.calaby@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH v2 6/7] mwifiex: factor out mwifiex_cancel_pending_scan_cmd
Date: Thu, 10 Mar 2016 09:44:10 +0100
Message-Id: <1457599451-13910-7-git-send-email-afenkart@gmail.com> (sfid-20160310_094435_256453_749EC091)
In-Reply-To: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
References: <1457599451-13910-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Releasing the scan_pending lock in mwifiex_check_next_scan_command
introduces a short window where pending scan commands can be removed
or added before removing them all in mwifiex_cancel_pending_scan_cmd.
I think this is safe, since the worst thing to happen is that a
pending scan cmd is removed by the command handler. Adding new scan
commands is not possible while one is pending, see scan_processing flag.
Since all commands are removed from the queue anyway, we don't care if
some commands are removed by a different code path earlier, the final
state remains the same.
I assume, that the critical section needed for the check has been
extended over clearing the pending scan queue out of convenience. The
lock was already held and releasing it and grab it again was just
more work. It doesn't seem to be necessary because of concurrency.

Signed-off-by: Andreas Fenkart <afenkart@gmail.com>
---
 drivers/net/wireless/marvell/mwifiex/cmdevt.c      | 43 ++++++++++------------
 drivers/net/wireless/marvell/mwifiex/main.h        |  1 +
 drivers/net/wireless/marvell/mwifiex/scan.c        | 23 +++---------
 drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c | 13 +------
 4 files changed, 27 insertions(+), 53 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/cmdevt.c b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
index cb25aa7..61426b3 100644
--- a/drivers/net/wireless/marvell/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/marvell/mwifiex/cmdevt.c
@@ -991,6 +991,23 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		adapter->if_ops.card_reset(adapter);
 }
 
+void
+mwifiex_cancel_pending_scan_cmd(struct mwifiex_adapter *adapter)
+{
+	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node;
+	unsigned long flags;
+
+	/* Cancel all pending scan command */
+	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
+	list_for_each_entry_safe(cmd_node, tmp_node,
+				 &adapter->scan_pending_q, list) {
+		list_del(&cmd_node->list);
+		cmd_node->wait_q_enabled = false;
+		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
+	}
+	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+}
+
 /*
  * This function cancels all the pending commands.
  *
@@ -1029,16 +1046,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 	spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 	spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 
-	/* Cancel all pending scan command */
-	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-	list_for_each_entry_safe(cmd_node, tmp_node,
-				 &adapter->scan_pending_q, list) {
-		list_del(&cmd_node->list);
-
-		cmd_node->wait_q_enabled = false;
-		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-	}
-	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+	mwifiex_cancel_pending_scan_cmd(adapter);
 
 	if (adapter->scan_processing) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
@@ -1070,9 +1078,8 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 void
 mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 {
-	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
+	struct cmd_ctrl_node *cmd_node = NULL;
 	unsigned long cmd_flags;
-	unsigned long scan_pending_q_flags;
 	struct mwifiex_private *priv;
 	int i;
 
@@ -1094,17 +1101,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		mwifiex_recycle_cmd_node(adapter, cmd_node);
 	}
 
-	/* Cancel all pending scan command */
-	spin_lock_irqsave(&adapter->scan_pending_q_lock,
-			  scan_pending_q_flags);
-	list_for_each_entry_safe(cmd_node, tmp_node,
-				 &adapter->scan_pending_q, list) {
-		list_del(&cmd_node->list);
-		cmd_node->wait_q_enabled = false;
-		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-	}
-	spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-			       scan_pending_q_flags);
+	mwifiex_cancel_pending_scan_cmd(adapter);
 
 	if (adapter->scan_processing) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index 2f7f478..f71f894 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -1043,6 +1043,7 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
 int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
+void mwifiex_cancel_pending_scan_cmd(struct mwifiex_adapter *adapter);
 
 void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 				  struct cmd_ctrl_node *cmd_node);
diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
index 327b4d8..de210c3 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -564,8 +564,6 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	int ret = 0;
 	struct mwifiex_chan_scan_param_set *tmp_chan_list;
 	struct mwifiex_chan_scan_param_set *start_chan;
-	struct cmd_ctrl_node *cmd_node, *tmp_node;
-	unsigned long flags;
 	u32 tlv_idx, rates_size, cmd_no;
 	u32 total_scan_time;
 	u32 done_early;
@@ -722,16 +720,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 			    sizeof(struct mwifiex_ie_types_header) + rates_size;
 
 		if (ret) {
-			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-			list_for_each_entry_safe(cmd_node, tmp_node,
-						 &adapter->scan_pending_q,
-						 list) {
-				list_del(&cmd_node->list);
-				cmd_node->wait_q_enabled = false;
-				mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-			}
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
+			mwifiex_cancel_pending_scan_cmd(adapter);
 			break;
 		}
 	}
@@ -1894,12 +1883,13 @@ mwifiex_active_scan_req_for_passive_chan(struct mwifiex_private *priv)
 static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 {
 	struct mwifiex_adapter *adapter = priv->adapter;
-	struct cmd_ctrl_node *cmd_node, *tmp_node;
+	struct cmd_ctrl_node *cmd_node;
 	unsigned long flags;
 
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	if (list_empty(&adapter->scan_pending_q)) {
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
@@ -1921,13 +1911,10 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
 		}
 	} else if ((priv->scan_aborting && !priv->scan_request) ||
 		   priv->scan_block) {
-		list_for_each_entry_safe(cmd_node, tmp_node,
-					 &adapter->scan_pending_q, list) {
-			list_del(&cmd_node->list);
-			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-		}
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
+		mwifiex_cancel_pending_scan_cmd(adapter);
+
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
diff --git a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
index 9ac7aa2..81e23d8 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_cmdresp.c
@@ -44,7 +44,6 @@ static void
 mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 			      struct host_cmd_ds_command *resp)
 {
-	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node;
 	struct mwifiex_adapter *adapter = priv->adapter;
 	struct host_cmd_ds_802_11_ps_mode_enh *pm;
 	unsigned long flags;
@@ -71,17 +70,7 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 		break;
 	case HostCmd_CMD_802_11_SCAN:
 	case HostCmd_CMD_802_11_SCAN_EXT:
-		/* Cancel all pending scan command */
-		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-		list_for_each_entry_safe(cmd_node, tmp_node,
-					 &adapter->scan_pending_q, list) {
-			list_del(&cmd_node->list);
-			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
-					       flags);
-			mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
-			spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
-		}
-		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
+		mwifiex_cancel_pending_scan_cmd(adapter);
 
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
 		adapter->scan_processing = false;
-- 
2.7.0

