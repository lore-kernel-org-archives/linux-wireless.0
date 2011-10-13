Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:46621 "HELO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752239Ab1JMD3a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 23:29:30 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH v2] mwifiex: use separate wait condition for each command node
Date: Wed, 12 Oct 2011 20:28:06 -0700
Message-Id: <1318476486-10113-1-git-send-email-bzhao@marvell.com> (sfid-20111013_052940_433385_0E9BE401)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently global wait condition (adapter->cmd_wait_q.condition)
is used while sending synchronous commands to FW. When two threads
enter in mwifiex_send_cmd_sync() routine at the same time, both the
threads wait for their command responses. Since wait condition is
same for both, they wake up simultaneously after getting response
of 1st command. After this when a thread is waiting for command
response of 3rd command, it wakes up after getting response of 2nd
command and so on. Therefore we don't wait for the response of last
command(0xaa) during unload. Hence while next time loading the driver
command time out is seen for INIT command.

This problem is resolved by having separate wait condition flag for
each command(except scan command). Since scan command is treated
differently (by maintaining scan pending q etc.), newly defined flag
(scan_wait_q_woken) is used as a scan wait condition.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Yogesh Ashok Powar <yogeshp@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
v2: define wait condition in each cmd and mark it as completed
    when cmd response is received. This way multiple cmds can
    wait on one waitqueue. (Johannes Berg)

 drivers/net/wireless/mwifiex/cmdevt.c    |   23 ++++++++++++++---------
 drivers/net/wireless/mwifiex/decl.h      |    1 -
 drivers/net/wireless/mwifiex/main.c      |    2 +-
 drivers/net/wireless/mwifiex/main.h      |    7 ++++++-
 drivers/net/wireless/mwifiex/scan.c      |    8 +++++---
 drivers/net/wireless/mwifiex/sta_ioctl.c |    6 ++++--
 drivers/net/wireless/mwifiex/util.c      |    5 +++--
 7 files changed, 33 insertions(+), 19 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 508de7f..ac27815 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -40,8 +40,12 @@ mwifiex_init_cmd_node(struct mwifiex_private *priv,
 {
 	cmd_node->priv = priv;
 	cmd_node->cmd_oid = cmd_oid;
-	cmd_node->wait_q_enabled = priv->adapter->cmd_wait_q_required;
-	priv->adapter->cmd_wait_q_required = false;
+	if (priv->adapter->cmd_wait_q_required) {
+		cmd_node->wait_q_enabled = priv->adapter->cmd_wait_q_required;
+		priv->adapter->cmd_wait_q_required = false;
+		cmd_node->cmd_wait_q_woken = false;
+		cmd_node->condition = &cmd_node->cmd_wait_q_woken;
+	}
 	cmd_node->data_buf = data_buf;
 	cmd_node->cmd_skb = cmd_node->skb;
 }
@@ -418,7 +422,6 @@ int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	adapter->cmd_wait_q_required = true;
-	adapter->cmd_wait_q.condition = false;
 
 	ret = mwifiex_send_cmd_async(priv, cmd_no, cmd_action, cmd_oid,
 				     data_buf);
@@ -511,10 +514,12 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 	}
 
 	/* Send command */
-	if (cmd_no == HostCmd_CMD_802_11_SCAN)
+	if (cmd_no == HostCmd_CMD_802_11_SCAN) {
 		mwifiex_queue_scan_cmd(priv, cmd_node);
-	else
+	} else {
+		adapter->cmd_queued = cmd_node;
 		mwifiex_insert_cmd_to_pending_q(adapter, cmd_node, true);
+	}
 
 	return ret;
 }
@@ -535,7 +540,7 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 		return;
 
 	if (cmd_node->wait_q_enabled)
-		mwifiex_complete_cmd(adapter);
+		mwifiex_complete_cmd(adapter, cmd_node);
 	/* Clean the node */
 	mwifiex_clean_cmd_node(adapter, cmd_node);
 
@@ -882,7 +887,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		adapter->curr_cmd->wait_q_enabled = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 		adapter->cmd_wait_q.status = -1;
-		mwifiex_complete_cmd(adapter);
+		mwifiex_complete_cmd(adapter, adapter->curr_cmd);
 	}
 	/* Cancel all pending command */
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -893,7 +898,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 
 		if (cmd_node->wait_q_enabled) {
 			adapter->cmd_wait_q.status = -1;
-			mwifiex_complete_cmd(adapter);
+			mwifiex_complete_cmd(adapter, cmd_node);
 			cmd_node->wait_q_enabled = false;
 		}
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
@@ -976,7 +981,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
 	adapter->cmd_wait_q.status = -1;
-	mwifiex_complete_cmd(adapter);
+	mwifiex_complete_cmd(adapter, adapter->curr_cmd);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/decl.h b/drivers/net/wireless/mwifiex/decl.h
index 6ca62c8..ae17ce0 100644
--- a/drivers/net/wireless/mwifiex/decl.h
+++ b/drivers/net/wireless/mwifiex/decl.h
@@ -98,7 +98,6 @@ struct mwifiex_802_11_ssid {
 
 struct mwifiex_wait_queue {
 	wait_queue_head_t wait;
-	u16 condition;
 	int status;
 };
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 849144d..25ce86b 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -685,8 +685,8 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
 	adapter->cmd_wait_q_required = false;
 	init_waitqueue_head(&adapter->cmd_wait_q.wait);
-	adapter->cmd_wait_q.condition = false;
 	adapter->cmd_wait_q.status = 0;
+	adapter->scan_wait_q_woken = false;
 
 	adapter->workqueue = create_workqueue("MWIFIEX_WORK_QUEUE");
 	if (!adapter->workqueue)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index ec45607..7db20db 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -520,6 +520,8 @@ struct cmd_ctrl_node {
 	void *data_buf;
 	u32 wait_q_enabled;
 	struct sk_buff *skb;
+	u8 *condition;
+	u8 cmd_wait_q_woken;
 };
 
 struct mwifiex_if_ops {
@@ -651,6 +653,8 @@ struct mwifiex_adapter {
 	u32 arp_filter_size;
 	u16 cmd_wait_q_required;
 	struct mwifiex_wait_queue cmd_wait_q;
+	u8 scan_wait_q_woken;
+	struct cmd_ctrl_node *cmd_queued;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
@@ -670,7 +674,8 @@ int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
 
 int mwifiex_process_event(struct mwifiex_adapter *adapter);
 
-int mwifiex_complete_cmd(struct mwifiex_adapter *adapter);
+int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
+			 struct cmd_ctrl_node *cmd_node);
 
 int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 			   u16 cmd_action, u32 cmd_oid, void *data_buf);
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ca37619..5456dcb 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -185,7 +185,7 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 {
 	int status;
 
-	priv->adapter->cmd_wait_q.condition = false;
+	priv->adapter->scan_wait_q_woken = false;
 
 	status = mwifiex_scan_networks(priv, scan_req);
 	if (!status)
@@ -1380,6 +1380,7 @@ int mwifiex_scan_networks(struct mwifiex_private *priv,
 			list_del(&cmd_node->list);
 			spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 									flags);
+			adapter->cmd_queued = cmd_node;
 			mwifiex_insert_cmd_to_pending_q(adapter, cmd_node,
 							true);
 		} else {
@@ -1788,7 +1789,7 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		/* Need to indicate IOCTL complete */
 		if (adapter->curr_cmd->wait_q_enabled) {
 			adapter->cmd_wait_q.status = 0;
-			mwifiex_complete_cmd(adapter);
+			mwifiex_complete_cmd(adapter, adapter->curr_cmd);
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
@@ -1845,6 +1846,7 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 	unsigned long flags;
 
 	cmd_node->wait_q_enabled = true;
+	cmd_node->condition = &adapter->scan_wait_q_woken;
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	list_add_tail(&cmd_node->list, &adapter->scan_pending_q);
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
@@ -1911,7 +1913,7 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 	}
 	priv->scan_pending_on_block = true;
 
-	priv->adapter->cmd_wait_q.condition = false;
+	priv->adapter->scan_wait_q_woken = false;
 
 	if (req_ssid && req_ssid->ssid_len != 0)
 		/* Specific SSID scan */
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index f20550a..d39bb72 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -55,7 +55,9 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 {
 	bool cancel_flag = false;
 	int status = adapter->cmd_wait_q.status;
+	struct cmd_ctrl_node *cmd_queued = adapter->cmd_queued;
 
+	adapter->cmd_queued = NULL;
 	dev_dbg(adapter->dev, "cmd pending\n");
 	atomic_inc(&adapter->cmd_pending);
 
@@ -64,8 +66,8 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 
 	/* Wait for completion */
 	wait_event_interruptible(adapter->cmd_wait_q.wait,
-					adapter->cmd_wait_q.condition);
-	if (!adapter->cmd_wait_q.condition)
+					*(cmd_queued->condition));
+	if (!*(cmd_queued->condition))
 		cancel_flag = true;
 
 	if (cancel_flag) {
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index d412915..06976f5 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -185,13 +185,14 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
  * corresponding waiting function. Otherwise, it processes the
  * IOCTL response and frees the response buffer.
  */
-int mwifiex_complete_cmd(struct mwifiex_adapter *adapter)
+int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
+			 struct cmd_ctrl_node *cmd_node)
 {
 	atomic_dec(&adapter->cmd_pending);
 	dev_dbg(adapter->dev, "cmd completed: status=%d\n",
 					adapter->cmd_wait_q.status);
 
-	adapter->cmd_wait_q.condition = true;
+	*(cmd_node->condition) = true;
 
 	if (adapter->cmd_wait_q.status == -ETIMEDOUT)
 		dev_err(adapter->dev, "cmd timeout\n");
-- 
1.7.0.2

