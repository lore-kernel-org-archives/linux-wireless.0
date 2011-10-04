Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:53769 "HELO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750966Ab1JDEN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 00:13:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Frank Huang <frankh@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: use separate wait queue for each command node
Date: Mon,  3 Oct 2011 21:08:22 -0700
Message-Id: <1317701303-21871-1-git-send-email-bzhao@marvell.com> (sfid-20111004_061336_546510_9B44E171)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Currently global wait queue (adapter->cmd_wait_q) is used for
sending synchronous commands to FW. When two threads enter in
mwifiex_send_cmd_sync() routine at the same time, both the
threads wait for their command responses. They wake up
simultaneously after getting response of 1st command. After
this when a thread is waiting for command response of 3rd
command, it wakes up after getting response of 2nd command
and so on. Therefore we don't wait for the response of last
command(0xaa) during unload. Hence while next time loading the
driver command time out is seen for INIT command.

This problem is resolved by having separate wait queue for each
command. Since driver sends multiple scan commands asynchronously
to FW for scanning the network, we will need separate wait queue
for the whole scan operation. Earlier the global wait queue was
being used for scan.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c      |   84 ++++++++++++++++------------
 drivers/net/wireless/mwifiex/join.c        |   12 ++--
 drivers/net/wireless/mwifiex/main.c        |    6 +-
 drivers/net/wireless/mwifiex/main.h        |   15 +++--
 drivers/net/wireless/mwifiex/scan.c        |   19 ++++---
 drivers/net/wireless/mwifiex/sta_cmdresp.c |    6 +-
 drivers/net/wireless/mwifiex/sta_ioctl.c   |   14 ++--
 drivers/net/wireless/mwifiex/util.c        |   11 ++--
 8 files changed, 95 insertions(+), 72 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index d12e25d..aab805f 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -40,8 +40,13 @@ mwifiex_init_cmd_node(struct mwifiex_private *priv,
 {
 	cmd_node->priv = priv;
 	cmd_node->cmd_oid = cmd_oid;
-	cmd_node->wait_q_enabled = priv->adapter->cmd_wait_q_required;
-	priv->adapter->cmd_wait_q_required = false;
+	if (priv->adapter->cmd_wait_q_required) {
+		cmd_node->wait_q = &cmd_node->cmd_wait_q;
+		cmd_node->wait_q->condition = false;
+		priv->adapter->cmd_wait_q_required = false;
+	} else {
+		cmd_node->wait_q = NULL;
+	}
 	cmd_node->data_buf = data_buf;
 	cmd_node->cmd_skb = cmd_node->skb;
 }
@@ -88,7 +93,7 @@ mwifiex_clean_cmd_node(struct mwifiex_adapter *adapter,
 	cmd_node->cmd_oid = 0;
 	cmd_node->cmd_flag = 0;
 	cmd_node->data_buf = NULL;
-	cmd_node->wait_q_enabled = false;
+	cmd_node->wait_q = NULL;
 
 	if (cmd_node->cmd_skb)
 		skb_trim(cmd_node->cmd_skb, 0);
@@ -145,8 +150,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	if (host_cmd == NULL || host_cmd->size == 0) {
 		dev_err(adapter->dev, "DNLD_CMD: host_cmd is null"
 			" or cmd size is 0, not sending\n");
-		if (cmd_node->wait_q_enabled)
-			adapter->cmd_wait_q.status = -1;
+		if (cmd_node->wait_q)
+			cmd_node->wait_q->status = -1;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		return -1;
 	}
@@ -183,8 +188,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 
 	if (ret == -1) {
 		dev_err(adapter->dev, "DNLD_CMD: host to card failed\n");
-		if (cmd_node->wait_q_enabled)
-			adapter->cmd_wait_q.status = -1;
+		if (cmd_node->wait_q)
+			cmd_node->wait_q->status = -1;
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
@@ -298,13 +303,17 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	adapter->cmd_pool = cmd_array;
 	memset(adapter->cmd_pool, 0, buf_size);
 
-	/* Allocate and initialize command buffers */
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
+		/* Allocate and initialize command buffers */
 		cmd_array[i].skb = dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (!cmd_array[i].skb) {
 			dev_err(adapter->dev, "ALLOC_CMD_BUF: out of memory\n");
 			return -1;
 		}
+		/* Initialize command wait queues */
+		init_waitqueue_head(&cmd_array[i].cmd_wait_q.wait);
+		cmd_array[i].cmd_wait_q.condition = false;
+		cmd_array[i].cmd_wait_q.status = 0;
 	}
 
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++)
@@ -421,12 +430,12 @@ int mwifiex_send_cmd_sync(struct mwifiex_private *priv, uint16_t cmd_no,
 	struct mwifiex_adapter *adapter = priv->adapter;
 
 	adapter->cmd_wait_q_required = true;
-	adapter->cmd_wait_q.condition = false;
 
 	ret = mwifiex_send_cmd_async(priv, cmd_no, cmd_action, cmd_oid,
 				     data_buf);
 	if (!ret)
-		ret = mwifiex_wait_queue_complete(adapter);
+		ret = mwifiex_wait_queue_complete(adapter,
+					adapter->cmd_queued->wait_q);
 
 	return ret;
 }
@@ -513,6 +522,8 @@ int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 		return -1;
 	}
 
+	adapter->cmd_queued = cmd_node;
+
 	/* Send command */
 	if (cmd_no == HostCmd_CMD_802_11_SCAN)
 		mwifiex_queue_scan_cmd(priv, cmd_node);
@@ -537,8 +548,8 @@ mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 	if (!cmd_node)
 		return;
 
-	if (cmd_node->wait_q_enabled)
-		mwifiex_complete_cmd(adapter);
+	if (cmd_node->wait_q)
+		mwifiex_complete_cmd(adapter, cmd_node->wait_q);
 	/* Clean the node */
 	mwifiex_clean_cmd_node(adapter, cmd_node);
 
@@ -746,8 +757,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 
 	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
 		dev_err(adapter->dev, "CMD_RESP: invalid cmd resp\n");
-		if (adapter->curr_cmd->wait_q_enabled)
-			adapter->cmd_wait_q.status = -1;
+		if (adapter->curr_cmd->wait_q)
+			adapter->curr_cmd->wait_q->status = -1;
 
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
@@ -778,10 +789,10 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	}
 
 	if (adapter->curr_cmd) {
-		if (adapter->curr_cmd->wait_q_enabled && (!ret))
-			adapter->cmd_wait_q.status = 0;
-		else if (adapter->curr_cmd->wait_q_enabled && (ret == -1))
-			adapter->cmd_wait_q.status = -1;
+		if (adapter->curr_cmd->wait_q && (!ret))
+			adapter->curr_cmd->wait_q->status = 0;
+		else if (adapter->curr_cmd->wait_q && (ret == -1))
+			adapter->curr_cmd->wait_q->status = -1;
 
 		/* Clean up and put current command back to cmd_free_q */
 		mwifiex_insert_cmd_to_free_q(adapter, adapter->curr_cmd);
@@ -814,8 +825,8 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		return;
 	}
 	cmd_node = adapter->curr_cmd;
-	if (cmd_node->wait_q_enabled)
-		adapter->cmd_wait_q.status = -ETIMEDOUT;
+	if (cmd_node->wait_q)
+		cmd_node->wait_q->status = -ETIMEDOUT;
 
 	if (cmd_node) {
 		adapter->dbg.timeout_cmd_id =
@@ -878,14 +889,16 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node;
 	unsigned long flags;
+	struct mwifiex_wait_queue *wait_q;
 
 	/* Cancel current cmd */
-	if ((adapter->curr_cmd) && (adapter->curr_cmd->wait_q_enabled)) {
+	if ((adapter->curr_cmd) && (adapter->curr_cmd->wait_q)) {
+		wait_q = adapter->curr_cmd->wait_q;
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, flags);
-		adapter->curr_cmd->wait_q_enabled = false;
+		adapter->curr_cmd->wait_q = NULL;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
-		adapter->cmd_wait_q.status = -1;
-		mwifiex_complete_cmd(adapter);
+		adapter->curr_cmd->wait_q->status = -1;
+		mwifiex_complete_cmd(adapter, wait_q);
 	}
 	/* Cancel all pending command */
 	spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -894,10 +907,10 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->cmd_pending_q_lock, flags);
 
-		if (cmd_node->wait_q_enabled) {
-			adapter->cmd_wait_q.status = -1;
-			mwifiex_complete_cmd(adapter);
-			cmd_node->wait_q_enabled = false;
+		if (cmd_node->wait_q) {
+			cmd_node->wait_q->status = -1;
+			mwifiex_complete_cmd(adapter, cmd_node->wait_q);
+			cmd_node->wait_q = NULL;
 		}
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock, flags);
@@ -911,7 +924,7 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
 
-		cmd_node->wait_q_enabled = false;
+		cmd_node->wait_q = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	}
@@ -933,7 +946,8 @@ mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter)
  * are cancelled.
  */
 void
-mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
+mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
+			     struct mwifiex_wait_queue *wait_q)
 {
 	struct cmd_ctrl_node *cmd_node = NULL, *tmp_node = NULL;
 	unsigned long cmd_flags;
@@ -942,10 +956,10 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 	uint16_t cancel_scan_cmd = false;
 
 	if ((adapter->curr_cmd) &&
-	     (adapter->curr_cmd->wait_q_enabled)) {
+	     (adapter->curr_cmd->wait_q)) {
 		spin_lock_irqsave(&adapter->mwifiex_cmd_lock, cmd_flags);
 		cmd_node = adapter->curr_cmd;
-		cmd_node->wait_q_enabled = false;
+		cmd_node->wait_q = NULL;
 		cmd_node->cmd_flag |= CMD_F_CANCELED;
 		spin_lock_irqsave(&adapter->cmd_pending_q_lock,
 				  cmd_pending_q_flags);
@@ -964,7 +978,7 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		list_del(&cmd_node->list);
 		spin_unlock_irqrestore(&adapter->scan_pending_q_lock,
 				       scan_pending_q_flags);
-		cmd_node->wait_q_enabled = false;
+		cmd_node->wait_q = NULL;
 		mwifiex_insert_cmd_to_free_q(adapter, cmd_node);
 		spin_lock_irqsave(&adapter->scan_pending_q_lock,
 				  scan_pending_q_flags);
@@ -978,8 +992,8 @@ mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter)
 		adapter->scan_processing = false;
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, cmd_flags);
 	}
-	adapter->cmd_wait_q.status = -1;
-	mwifiex_complete_cmd(adapter);
+	wait_q->status = -1;
+	mwifiex_complete_cmd(adapter, wait_q);
 }
 
 /*
diff --git a/drivers/net/wireless/mwifiex/join.c b/drivers/net/wireless/mwifiex/join.c
index 62b4c29..8260a4f 100644
--- a/drivers/net/wireless/mwifiex/join.c
+++ b/drivers/net/wireless/mwifiex/join.c
@@ -683,11 +683,11 @@ int mwifiex_ret_802_11_associate(struct mwifiex_private *priv,
 
 done:
 	/* Need to indicate IOCTL complete */
-	if (adapter->curr_cmd->wait_q_enabled) {
+	if (adapter->curr_cmd->wait_q) {
 		if (ret)
-			adapter->cmd_wait_q.status = -1;
+			adapter->curr_cmd->wait_q->status = -1;
 		else
-			adapter->cmd_wait_q.status = 0;
+			adapter->curr_cmd->wait_q->status = 0;
 	}
 
 	return ret;
@@ -1213,11 +1213,11 @@ int mwifiex_ret_802_11_ad_hoc(struct mwifiex_private *priv,
 
 done:
 	/* Need to indicate IOCTL complete */
-	if (adapter->curr_cmd->wait_q_enabled) {
+	if (adapter->curr_cmd->wait_q) {
 		if (ret)
-			adapter->cmd_wait_q.status = -1;
+			adapter->curr_cmd->wait_q->status = -1;
 		else
-			adapter->cmd_wait_q.status = 0;
+			adapter->curr_cmd->wait_q->status = 0;
 
 	}
 
diff --git a/drivers/net/wireless/mwifiex/main.c b/drivers/net/wireless/mwifiex/main.c
index 8486451..13264b8 100644
--- a/drivers/net/wireless/mwifiex/main.c
+++ b/drivers/net/wireless/mwifiex/main.c
@@ -682,9 +682,9 @@ mwifiex_add_card(void *card, struct semaphore *sem,
 	adapter->hs_activated = false;
 	init_waitqueue_head(&adapter->hs_activate_wait_q);
 	adapter->cmd_wait_q_required = false;
-	init_waitqueue_head(&adapter->cmd_wait_q.wait);
-	adapter->cmd_wait_q.condition = false;
-	adapter->cmd_wait_q.status = 0;
+	init_waitqueue_head(&adapter->scan_wait_q.wait);
+	adapter->scan_wait_q.condition = false;
+	adapter->scan_wait_q.status = 0;
 
 	adapter->workqueue = create_workqueue("MWIFIEX_WORK_QUEUE");
 	if (!adapter->workqueue)
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 907ab74..842ae6b 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -510,7 +510,8 @@ struct cmd_ctrl_node {
 	struct sk_buff *cmd_skb;
 	struct sk_buff *resp_skb;
 	void *data_buf;
-	u32 wait_q_enabled;
+	struct mwifiex_wait_queue cmd_wait_q;
+	struct mwifiex_wait_queue *wait_q;
 	struct sk_buff *skb;
 };
 
@@ -638,7 +639,8 @@ struct mwifiex_adapter {
 	u8 arp_filter[ARP_FILTER_MAX_BUF_SIZE];
 	u32 arp_filter_size;
 	u16 cmd_wait_q_required;
-	struct mwifiex_wait_queue cmd_wait_q;
+	struct mwifiex_wait_queue scan_wait_q;
+	struct cmd_ctrl_node *cmd_queued;
 };
 
 int mwifiex_init_lock_list(struct mwifiex_adapter *adapter);
@@ -658,7 +660,8 @@ int mwifiex_recv_packet(struct mwifiex_adapter *, struct sk_buff *skb);
 
 int mwifiex_process_event(struct mwifiex_adapter *adapter);
 
-int mwifiex_complete_cmd(struct mwifiex_adapter *adapter);
+int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
+			 struct mwifiex_wait_queue *wait_q);
 
 int mwifiex_send_cmd_async(struct mwifiex_private *priv, uint16_t cmd_no,
 			   u16 cmd_action, u32 cmd_oid, void *data_buf);
@@ -674,7 +677,8 @@ int mwifiex_get_debug_info(struct mwifiex_private *,
 int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter);
 int mwifiex_free_cmd_buffer(struct mwifiex_adapter *adapter);
 void mwifiex_cancel_all_pending_cmd(struct mwifiex_adapter *adapter);
-void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter);
+void mwifiex_cancel_pending_ioctl(struct mwifiex_adapter *adapter,
+				  struct mwifiex_wait_queue *wait_q);
 
 void mwifiex_insert_cmd_to_free_q(struct mwifiex_adapter *adapter,
 				  struct cmd_ctrl_node *cmd_node);
@@ -881,7 +885,8 @@ int mwifiex_request_set_multicast_list(struct mwifiex_private *priv,
 			struct mwifiex_multicast_list *mcast_list);
 int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
 			    struct net_device *dev);
-int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter);
+int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
+				struct mwifiex_wait_queue *wait_q);
 int mwifiex_bss_start(struct mwifiex_private *priv, struct cfg80211_bss *bss,
 		      struct mwifiex_802_11_ssid *req_ssid);
 int mwifiex_set_hs_params(struct mwifiex_private *priv,
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index ca37619..f66960f 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -185,11 +185,12 @@ int mwifiex_set_user_scan_ioctl(struct mwifiex_private *priv,
 {
 	int status;
 
-	priv->adapter->cmd_wait_q.condition = false;
+	priv->adapter->scan_wait_q.condition = false;
 
 	status = mwifiex_scan_networks(priv, scan_req);
 	if (!status)
-		status = mwifiex_wait_queue_complete(priv->adapter);
+		status = mwifiex_wait_queue_complete(priv->adapter,
+						&priv->adapter->scan_wait_q);
 
 	return status;
 }
@@ -1786,9 +1787,10 @@ int mwifiex_ret_802_11_scan(struct mwifiex_private *priv,
 		spin_unlock_irqrestore(&adapter->mwifiex_cmd_lock, flags);
 
 		/* Need to indicate IOCTL complete */
-		if (adapter->curr_cmd->wait_q_enabled) {
-			adapter->cmd_wait_q.status = 0;
-			mwifiex_complete_cmd(adapter);
+		if (adapter->curr_cmd->wait_q) {
+			adapter->curr_cmd->wait_q->status = 0;
+			mwifiex_complete_cmd(adapter,
+					adapter->curr_cmd->wait_q);
 		}
 		if (priv->report_scan_result)
 			priv->report_scan_result = false;
@@ -1844,7 +1846,7 @@ mwifiex_queue_scan_cmd(struct mwifiex_private *priv,
 	struct mwifiex_adapter *adapter = priv->adapter;
 	unsigned long flags;
 
-	cmd_node->wait_q_enabled = true;
+	cmd_node->wait_q = &adapter->scan_wait_q;
 	spin_lock_irqsave(&adapter->scan_pending_q_lock, flags);
 	list_add_tail(&cmd_node->list, &adapter->scan_pending_q);
 	spin_unlock_irqrestore(&adapter->scan_pending_q_lock, flags);
@@ -1911,7 +1913,7 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 	}
 	priv->scan_pending_on_block = true;
 
-	priv->adapter->cmd_wait_q.condition = false;
+	priv->adapter->scan_wait_q.condition = false;
 
 	if (req_ssid && req_ssid->ssid_len != 0)
 		/* Specific SSID scan */
@@ -1921,7 +1923,8 @@ int mwifiex_request_scan(struct mwifiex_private *priv,
 		ret = mwifiex_scan_networks(priv, NULL);
 
 	if (!ret)
-		ret = mwifiex_wait_queue_complete(priv->adapter);
+		ret = mwifiex_wait_queue_complete(priv->adapter,
+						  &priv->adapter->scan_wait_q);
 
 	if (ret == -1) {
 		priv->scan_pending_on_block = false;
diff --git a/drivers/net/wireless/mwifiex/sta_cmdresp.c b/drivers/net/wireless/mwifiex/sta_cmdresp.c
index 6804239..066f204 100644
--- a/drivers/net/wireless/mwifiex/sta_cmdresp.c
+++ b/drivers/net/wireless/mwifiex/sta_cmdresp.c
@@ -51,8 +51,8 @@ mwifiex_process_cmdresp_error(struct mwifiex_private *priv,
 	dev_err(adapter->dev, "CMD_RESP: cmd %#x error, result=%#x\n",
 			resp->command, resp->result);
 
-	if (adapter->curr_cmd->wait_q_enabled)
-		adapter->cmd_wait_q.status = -1;
+	if (adapter->curr_cmd->wait_q)
+		adapter->curr_cmd->wait_q->status = -1;
 
 	switch (le16_to_cpu(resp->command)) {
 	case HostCmd_CMD_802_11_PS_MODE_ENH:
@@ -847,7 +847,7 @@ int mwifiex_process_sta_cmdresp(struct mwifiex_private *priv, u16 cmdresp_no,
 		break;
 	case HostCmd_CMD_802_11_SCAN:
 		ret = mwifiex_ret_802_11_scan(priv, resp);
-		adapter->curr_cmd->wait_q_enabled = false;
+		adapter->curr_cmd->wait_q = NULL;
 		break;
 	case HostCmd_CMD_802_11_BG_SCAN_QUERY:
 		ret = mwifiex_ret_802_11_scan(priv, resp);
diff --git a/drivers/net/wireless/mwifiex/sta_ioctl.c b/drivers/net/wireless/mwifiex/sta_ioctl.c
index 520800b..e55393a 100644
--- a/drivers/net/wireless/mwifiex/sta_ioctl.c
+++ b/drivers/net/wireless/mwifiex/sta_ioctl.c
@@ -51,10 +51,11 @@ int mwifiex_copy_mcast_addr(struct mwifiex_multicast_list *mlist,
  * This function waits on a cmd wait queue. It also cancels the pending
  * request after waking up, in case of errors.
  */
-int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
+int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter,
+				struct mwifiex_wait_queue *wait_q)
 {
 	bool cancel_flag = false;
-	int status = adapter->cmd_wait_q.status;
+	int status = wait_q->status;
 
 	dev_dbg(adapter->dev, "cmd pending\n");
 	atomic_inc(&adapter->cmd_pending);
@@ -63,16 +64,15 @@ int mwifiex_wait_queue_complete(struct mwifiex_adapter *adapter)
 	queue_work(adapter->workqueue, &adapter->main_work);
 
 	/* Wait for completion */
-	wait_event_interruptible(adapter->cmd_wait_q.wait,
-					adapter->cmd_wait_q.condition);
-	if (!adapter->cmd_wait_q.condition)
+	wait_event_interruptible(wait_q->wait, wait_q->condition);
+	if (!wait_q->condition)
 		cancel_flag = true;
 
 	if (cancel_flag) {
-		mwifiex_cancel_pending_ioctl(adapter);
+		mwifiex_cancel_pending_ioctl(adapter, wait_q);
 		dev_dbg(adapter->dev, "cmd cancel\n");
 	}
-	adapter->cmd_wait_q.status = 0;
+	wait_q->status = 0;
 
 	return status;
 }
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index d412915..430bb50 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -185,18 +185,19 @@ int mwifiex_recv_packet(struct mwifiex_adapter *adapter, struct sk_buff *skb)
  * corresponding waiting function. Otherwise, it processes the
  * IOCTL response and frees the response buffer.
  */
-int mwifiex_complete_cmd(struct mwifiex_adapter *adapter)
+int mwifiex_complete_cmd(struct mwifiex_adapter *adapter,
+			 struct mwifiex_wait_queue *wait_q)
 {
 	atomic_dec(&adapter->cmd_pending);
 	dev_dbg(adapter->dev, "cmd completed: status=%d\n",
-					adapter->cmd_wait_q.status);
+					wait_q->status);
 
-	adapter->cmd_wait_q.condition = true;
+	wait_q->condition = true;
 
-	if (adapter->cmd_wait_q.status == -ETIMEDOUT)
+	if (wait_q->status == -ETIMEDOUT)
 		dev_err(adapter->dev, "cmd timeout\n");
 	else
-		wake_up_interruptible(&adapter->cmd_wait_q.wait);
+		wake_up_interruptible(&wait_q->wait);
 
 	return 0;
 }
-- 
1.7.0.2

