Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:26833 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751514AbaB1Dfk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 22:35:40 -0500
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 8/9] mwifiex: replace num_cmd_timeout with is_cmd_timedout
Date: Thu, 27 Feb 2014 19:35:17 -0800
Message-ID: <1393558518-921-3-git-send-email-bzhao@marvell.com> (sfid-20140228_043545_100751_E769894C)
In-Reply-To: <1393558518-921-1-git-send-email-bzhao@marvell.com>
References: <1393558518-921-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Amitkumar Karwar <akarwar@marvell.com>

Command timeout happens when firmware goes into bad state.
There is no chance that next command will be successful after
this. Hence we will maintain a flag instead of count.

Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/README      |  2 +-
 drivers/net/wireless/mwifiex/cmdevt.c    | 10 +++++-----
 drivers/net/wireless/mwifiex/debugfs.c   |  4 ++--
 drivers/net/wireless/mwifiex/ioctl.h     |  2 +-
 drivers/net/wireless/mwifiex/main.h      |  2 +-
 drivers/net/wireless/mwifiex/sta_event.c |  2 +-
 drivers/net/wireless/mwifiex/util.c      |  2 +-
 7 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/README b/drivers/net/wireless/mwifiex/README
index 3d64613..b9242c3 100644
--- a/drivers/net/wireless/mwifiex/README
+++ b/drivers/net/wireless/mwifiex/README
@@ -131,7 +131,7 @@ info
 	hs_configured = <0/1, host sleep not configured/configured>
 	hs_activated = <0/1, extended host sleep not activated/activated>
 	num_tx_timeout = <number of Tx timeout>
-	num_cmd_timeout = <number of timeout commands>
+	is_cmd_timedout = <0/1 command timeout not occurred/occurred>
 	timeout_cmd_id = <command id of the last timeout command>
 	timeout_cmd_act = <command action of the last timeout command>
 	last_cmd_id = <command id of the last several commands sent to device>
diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 686943c..b4d28ed 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -514,7 +514,7 @@ int mwifiex_send_cmd(struct mwifiex_private *priv, u16 cmd_no,
 		return -1;
 	}
 
-	if (adapter->num_cmd_timeout) {
+	if (adapter->is_cmd_timedout) {
 		dev_err(adapter->dev, "PREP_CMD: FW is in bad state\n");
 		return -1;
 	}
@@ -780,7 +780,7 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		return -1;
 	}
 
-	adapter->num_cmd_timeout = 0;
+	adapter->is_cmd_timedout = 0;
 
 	resp = (struct host_cmd_ds_command *) adapter->curr_cmd->resp_skb->data;
 	if (adapter->curr_cmd->cmd_flag & CMD_F_CANCELED) {
@@ -891,7 +891,7 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	struct cmd_ctrl_node *cmd_node;
 	struct timeval tstamp;
 
-	adapter->num_cmd_timeout++;
+	adapter->is_cmd_timedout = 1;
 	if (!adapter->curr_cmd) {
 		dev_dbg(adapter->dev, "cmd: empty curr_cmd\n");
 		return;
@@ -914,8 +914,8 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 		dev_err(adapter->dev, "num_cmd_h2c_failure = %d\n",
 			adapter->dbg.num_cmd_host_to_card_failure);
 
-		dev_err(adapter->dev, "num_cmd_timeout = %d\n",
-			adapter->num_cmd_timeout);
+		dev_err(adapter->dev, "is_cmd_timedout = %d\n",
+			adapter->is_cmd_timedout);
 		dev_err(adapter->dev, "num_tx_timeout = %d\n",
 			adapter->dbg.num_tx_timeout);
 
diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index a5f9875..61b467a 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -85,8 +85,8 @@ static struct mwifiex_debug_data items[] = {
 	 item_addr(hs_activated), 1},
 	{"num_tx_timeout", item_size(num_tx_timeout),
 	 item_addr(num_tx_timeout), 1},
-	{"num_cmd_timeout", item_size(num_cmd_timeout),
-	 item_addr(num_cmd_timeout), 1},
+	{"is_cmd_timedout", item_size(is_cmd_timedout),
+	 item_addr(is_cmd_timedout), 1},
 	{"timeout_cmd_id", item_size(timeout_cmd_id),
 	 item_addr(timeout_cmd_id), 1},
 	{"timeout_cmd_act", item_size(timeout_cmd_act),
diff --git a/drivers/net/wireless/mwifiex/ioctl.h b/drivers/net/wireless/mwifiex/ioctl.h
index 5974642..1fb2212 100644
--- a/drivers/net/wireless/mwifiex/ioctl.h
+++ b/drivers/net/wireless/mwifiex/ioctl.h
@@ -209,7 +209,7 @@ struct mwifiex_debug_info {
 	u32 num_cmd_assoc_success;
 	u32 num_cmd_assoc_failure;
 	u32 num_tx_timeout;
-	u32 num_cmd_timeout;
+	u8 is_cmd_timedout;
 	u16 timeout_cmd_id;
 	u16 timeout_cmd_act;
 	u16 last_cmd_id[DBG_CMD_NUM];
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index a5f6160..c423c2e 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -718,7 +718,7 @@ struct mwifiex_adapter {
 	struct cmd_ctrl_node *curr_cmd;
 	/* spin lock for command */
 	spinlock_t mwifiex_cmd_lock;
-	u32 num_cmd_timeout;
+	u8 is_cmd_timedout;
 	u16 last_init_cmd;
 	struct timer_list cmd_timer;
 	struct list_head cmd_free_q;
diff --git a/drivers/net/wireless/mwifiex/sta_event.c b/drivers/net/wireless/mwifiex/sta_event.c
index fd2a716..368450c 100644
--- a/drivers/net/wireless/mwifiex/sta_event.c
+++ b/drivers/net/wireless/mwifiex/sta_event.c
@@ -116,7 +116,7 @@ mwifiex_reset_connect_state(struct mwifiex_private *priv, u16 reason_code)
 	adapter->tx_lock_flag = false;
 	adapter->pps_uapsd_mode = false;
 
-	if (adapter->num_cmd_timeout && adapter->curr_cmd)
+	if (adapter->is_cmd_timedout && adapter->curr_cmd)
 		return;
 	priv->media_connected = false;
 	dev_dbg(adapter->dev,
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 7022c69..c3824e3 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -104,7 +104,7 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		info->pm_wakeup_fw_try = adapter->pm_wakeup_fw_try;
 		info->is_hs_configured = adapter->is_hs_configured;
 		info->hs_activated = adapter->hs_activated;
-		info->num_cmd_timeout = adapter->num_cmd_timeout;
+		info->is_cmd_timedout = adapter->is_cmd_timedout;
 		info->num_cmd_host_to_card_failure
 				= adapter->dbg.num_cmd_host_to_card_failure;
 		info->num_cmd_sleep_cfm_host_to_card_failure
-- 
1.8.2.3

