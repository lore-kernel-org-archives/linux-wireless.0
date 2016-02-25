Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:35160 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756666AbcBYAJL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2016 19:09:11 -0500
Received: by mail-wm0-f50.google.com with SMTP id c200so5768923wme.0
        for <linux-wireless@vger.kernel.org>; Wed, 24 Feb 2016 16:09:10 -0800 (PST)
From: Andreas Fenkart <afenkart@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Amitkumar Karwar <akarwar@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	Andreas Fenkart <afenkart@gmail.com>
Subject: [PATCH 6/7] mwifiex: factor out mwifiex_cancel_pending_scan_cmd
Date: Thu, 25 Feb 2016 01:08:51 +0100
Message-Id: <1456358932-23114-7-git-send-email-afenkart@gmail.com> (sfid-20160225_010916_696395_C64DDF8E)
In-Reply-To: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
References: <1456358932-23114-1-git-send-email-afenkart@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

releasing the scan_pending lock in mwifiex_check_next_scan_command
is valid, since the lock is taken again, and all nodes removed
from the scan_pending queue.

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
index 6ddc98b..490d0d1 100644
--- a/drivers/net/wireless/marvell/mwifiex/scan.c
+++ b/drivers/net/wireless/marvell/mwifiex/scan.c
@@ -563,8 +563,6 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
 	int ret = 0;
 	struct mwifiex_chan_scan_param_set *tmp_chan_list;
 	struct mwifiex_chan_scan_param_set *start_chan;
-	struct cmd_ctrl_node *cmd_node, *tmp_node;
-	unsigned long flags;
 	u32 tlv_idx, rates_size, cmd_no;
 	u32 total_scan_time;
 	u32 done_early;
@@ -721,16 +719,7 @@ mwifiex_scan_channel_list(struct mwifiex_private *priv,
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
@@ -1893,12 +1882,13 @@ mwifiex_active_scan_req_for_passive_chan(struct mwifiex_private *priv)
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
@@ -1920,13 +1910,10 @@ static void mwifiex_check_next_scan_command(struct mwifiex_private *priv)
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

