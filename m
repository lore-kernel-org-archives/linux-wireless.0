Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14691 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757478AbaGQWzh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jul 2014 18:55:37 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Paul Stewart <pstew@chromium.org>,
	Avinash Patil <patila@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH] mwifiex: remove redundant timestamps in debug prints
Date: Thu, 17 Jul 2014 15:55:09 -0700
Message-ID: <1405637709-26976-1-git-send-email-bzhao@marvell.com> (sfid-20140718_005541_123776_2A5C87B7)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We don't need wall-clock time here, and in most configurations
that care, there are already timestamps in the kernel using
CONFIG_PRINTK_TIME=y.

Reported-by: Paul Stewart <pstew@chromium.org>
Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 40 +++++++++++------------------------
 drivers/net/wireless/mwifiex/pcie.c   | 14 ++++--------
 drivers/net/wireless/mwifiex/sdio.c   | 14 ++++--------
 3 files changed, 20 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 5899eee..baf0aab 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -137,7 +137,6 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 	struct host_cmd_ds_command *host_cmd;
 	uint16_t cmd_code;
 	uint16_t cmd_size;
-	struct timeval tstamp;
 	unsigned long flags;
 	__le32 tmp;
 
@@ -198,10 +197,8 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		 */
 		skb_put(cmd_node->cmd_skb, cmd_size - cmd_node->cmd_skb->len);
 
-	do_gettimeofday(&tstamp);
-	dev_dbg(adapter->dev, "cmd: DNLD_CMD: (%lu.%lu): %#x, act %#x, len %d,"
-		" seqno %#x\n",
-		tstamp.tv_sec, tstamp.tv_usec, cmd_code,
+	dev_dbg(adapter->dev,
+		"cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n", cmd_code,
 		le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
 		le16_to_cpu(host_cmd->seq_num));
 
@@ -273,7 +270,6 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 				(struct mwifiex_opt_sleep_confirm *)
 						adapter->sleep_cfm->data;
 	struct sk_buff *sleep_cfm_tmp;
-	struct timeval ts;
 	__le32 tmp;
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
@@ -284,10 +280,9 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 					(adapter->seq_num, priv->bss_num,
 					 priv->bss_type)));
 
-	do_gettimeofday(&ts);
 	dev_dbg(adapter->dev,
-		"cmd: DNLD_CMD: (%lu.%lu): %#x, act %#x, len %d, seqno %#x\n",
-		ts.tv_sec, ts.tv_usec, le16_to_cpu(sleep_cfm_buf->command),
+		"cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n",
+		le16_to_cpu(sleep_cfm_buf->command),
 		le16_to_cpu(sleep_cfm_buf->action),
 		le16_to_cpu(sleep_cfm_buf->size),
 		le16_to_cpu(sleep_cfm_buf->seq_num));
@@ -442,7 +437,6 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 		mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
 	struct sk_buff *skb = adapter->event_skb;
 	u32 eventcause = adapter->event_cause;
-	struct timeval tstamp;
 	struct mwifiex_rxinfo *rx_info;
 
 	/* Save the last event to debug log */
@@ -467,9 +461,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 		rx_info->bss_type = priv->bss_type;
 	}
 
-	do_gettimeofday(&tstamp);
-	dev_dbg(adapter->dev, "EVENT: %lu.%lu: cause: %#x\n",
-		tstamp.tv_sec, tstamp.tv_usec, eventcause);
+	dev_dbg(adapter->dev, "EVENT: cause: %#x\n", eventcause);
 	if (eventcause == EVENT_PS_SLEEP || eventcause == EVENT_PS_AWAKE) {
 		/* Handle PS_SLEEP/AWAKE events on STA */
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
@@ -781,7 +773,6 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	uint16_t orig_cmdresp_no;
 	uint16_t cmdresp_no;
 	uint16_t cmdresp_result;
-	struct timeval tstamp;
 	unsigned long flags;
 
 	/* Now we got response from FW, cancel the command timer */
@@ -839,11 +830,10 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 	adapter->dbg.last_cmd_resp_id[adapter->dbg.last_cmd_resp_index] =
 								orig_cmdresp_no;
 
-	do_gettimeofday(&tstamp);
-	dev_dbg(adapter->dev, "cmd: CMD_RESP: (%lu.%lu): 0x%x, result %d,"
-		" len %d, seqno 0x%x\n",
-	       tstamp.tv_sec, tstamp.tv_usec, orig_cmdresp_no, cmdresp_result,
-	       le16_to_cpu(resp->size), le16_to_cpu(resp->seq_num));
+	dev_dbg(adapter->dev,
+		"cmd: CMD_RESP: 0x%x, result %d, len %d, seqno 0x%x\n",
+		orig_cmdresp_no, cmdresp_result,
+		le16_to_cpu(resp->size), le16_to_cpu(resp->seq_num));
 
 	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
 		dev_err(adapter->dev, "CMD_RESP: invalid cmd resp\n");
@@ -903,7 +893,6 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 	struct mwifiex_adapter *adapter =
 		(struct mwifiex_adapter *) function_context;
 	struct cmd_ctrl_node *cmd_node;
-	struct timeval tstamp;
 
 	adapter->is_cmd_timedout = 1;
 	if (!adapter->curr_cmd) {
@@ -916,10 +905,8 @@ mwifiex_cmd_timeout_func(unsigned long function_context)
 			adapter->dbg.last_cmd_id[adapter->dbg.last_cmd_index];
 		adapter->dbg.timeout_cmd_act =
 			adapter->dbg.last_cmd_act[adapter->dbg.last_cmd_index];
-		do_gettimeofday(&tstamp);
 		dev_err(adapter->dev,
-			"%s: Timeout cmd id (%lu.%lu) = %#x, act = %#x\n",
-			__func__, tstamp.tv_sec, tstamp.tv_usec,
+			"%s: Timeout cmd id = %#x, act = %#x\n", __func__,
 			adapter->dbg.timeout_cmd_id,
 			adapter->dbg.timeout_cmd_act);
 
@@ -1237,18 +1224,15 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	uint16_t result = le16_to_cpu(cmd->result);
 	uint16_t command = le16_to_cpu(cmd->command);
 	uint16_t seq_num = le16_to_cpu(cmd->seq_num);
-	struct timeval ts;
 
 	if (!upld_len) {
 		dev_err(adapter->dev, "%s: cmd size is 0\n", __func__);
 		return;
 	}
 
-	do_gettimeofday(&ts);
 	dev_dbg(adapter->dev,
-		"cmd: CMD_RESP: (%lu.%lu): 0x%x, result %d, len %d, seqno 0x%x\n",
-		ts.tv_sec, ts.tv_usec, command, result, le16_to_cpu(cmd->size),
-		seq_num);
+		"cmd: CMD_RESP: 0x%x, result %d, len %d, seqno 0x%x\n",
+		command, result, le16_to_cpu(cmd->size), seq_num);
 
 	/* Get BSS number and corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter, HostCmd_GET_BSS_NO(seq_num),
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index 5f7afff..c16dd2c 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -2238,7 +2238,6 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 	struct pcie_service_card *card = adapter->card;
 	const struct mwifiex_pcie_card_reg *creg = card->pcie.reg;
 	unsigned int reg, reg_start, reg_end;
-	struct timeval t;
 	u8 *dbg_ptr, *end_ptr, dump_num, idx, i, read_reg, doneflag = 0;
 	enum rdwr_status stat;
 	u32 memory_size;
@@ -2257,9 +2256,7 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 		entry->mem_size = 0;
 	}
 
-	do_gettimeofday(&t);
-	dev_info(adapter->dev, "== mwifiex firmware dump start: %u.%06u ==\n",
-		 (u32)t.tv_sec, (u32)t.tv_usec);
+	dev_info(adapter->dev, "== mwifiex firmware dump start ==\n");
 
 	/* Read the number of the memories which will dump */
 	stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
@@ -2303,9 +2300,8 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 		end_ptr = dbg_ptr + memory_size;
 
 		doneflag = entry->done_flag;
-		do_gettimeofday(&t);
-		dev_info(adapter->dev, "Start %s output %u.%06u, please wait...\n",
-			 entry->mem_name, (u32)t.tv_sec, (u32)t.tv_usec);
+		dev_info(adapter->dev, "Start %s output, please wait...\n",
+			 entry->mem_name);
 
 		do {
 			stat = mwifiex_pcie_rdwr_firmware(adapter, doneflag);
@@ -2331,9 +2327,7 @@ static void mwifiex_pcie_fw_dump_work(struct mwifiex_adapter *adapter)
 			break;
 		} while (true);
 	}
-	do_gettimeofday(&t);
-	dev_info(adapter->dev, "== mwifiex firmware dump end: %u.%06u ==\n",
-		 (u32)t.tv_sec, (u32)t.tv_usec);
+	dev_info(adapter->dev, "== mwifiex firmware dump end ==\n");
 
 	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
 
diff --git a/drivers/net/wireless/mwifiex/sdio.c b/drivers/net/wireless/mwifiex/sdio.c
index 1da04a0..3e48ef5 100644
--- a/drivers/net/wireless/mwifiex/sdio.c
+++ b/drivers/net/wireless/mwifiex/sdio.c
@@ -2012,7 +2012,6 @@ static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
 	int ret = 0;
 	unsigned int reg, reg_start, reg_end;
 	u8 *dbg_ptr, *end_ptr, dump_num, idx, i, read_reg, doneflag = 0;
-	struct timeval t;
 	enum rdwr_status stat;
 	u32 memory_size;
 	static char *env[] = { "DRIVER=mwifiex_sdio", "EVENT=fw_dump", NULL };
@@ -2033,9 +2032,7 @@ static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
 	mwifiex_pm_wakeup_card(adapter);
 	sdio_claim_host(card->func);
 
-	do_gettimeofday(&t);
-	dev_info(adapter->dev, "== mwifiex firmware dump start: %u.%06u ==\n",
-		 (u32)t.tv_sec, (u32)t.tv_usec);
+	dev_info(adapter->dev, "== mwifiex firmware dump start ==\n");
 
 	stat = mwifiex_sdio_rdwr_firmware(adapter, doneflag);
 	if (stat == RDWR_STATUS_FAILURE)
@@ -2087,9 +2084,8 @@ static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
 		end_ptr = dbg_ptr + memory_size;
 
 		doneflag = entry->done_flag;
-		do_gettimeofday(&t);
-		dev_info(adapter->dev, "Start %s output %u.%06u, please wait...\n",
-			 entry->mem_name, (u32)t.tv_sec, (u32)t.tv_usec);
+		dev_info(adapter->dev, "Start %s output, please wait...\n",
+			 entry->mem_name);
 
 		do {
 			stat = mwifiex_sdio_rdwr_firmware(adapter, doneflag);
@@ -2120,9 +2116,7 @@ static void mwifiex_sdio_fw_dump_work(struct work_struct *work)
 			break;
 		} while (1);
 	}
-	do_gettimeofday(&t);
-	dev_info(adapter->dev, "== mwifiex firmware dump end: %u.%06u ==\n",
-		 (u32)t.tv_sec, (u32)t.tv_usec);
+	dev_info(adapter->dev, "== mwifiex firmware dump end ==\n");
 
 	kobject_uevent_env(&adapter->wiphy->dev.kobj, KOBJ_CHANGE, env);
 
-- 
1.8.2.3

