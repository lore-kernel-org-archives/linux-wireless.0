Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:42578 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751441AbaFTEjM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2014 00:39:12 -0400
From: Bing Zhao <bzhao@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Chin-Ran Lo <crlo@marvell.com>, Xinming Hu <huxm@marvell.com>,
	Bing Zhao <bzhao@marvell.com>
Subject: [PATCH 7/7] mwifiex: print sleep_confirm cmd/response and power save events
Date: Thu, 19 Jun 2014 21:38:58 -0700
Message-ID: <1403239138-3113-7-git-send-email-bzhao@marvell.com> (sfid-20140620_063916_692628_EAC6A467)
In-Reply-To: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
References: <1403239138-3113-1-git-send-email-bzhao@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sleep Confirm command is sent separately while other commands
are handled through cmd_pending_q. Print sleep_confirm cmd and
its response as well as power save events so that we have a
clearer picture of power save handshake in driver log.

Signed-off-by: Bing Zhao <bzhao@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index 606877b..df42f06 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -273,6 +273,7 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 				(struct mwifiex_opt_sleep_confirm *)
 						adapter->sleep_cfm->data;
 	struct sk_buff *sleep_cfm_tmp;
+	struct timeval ts;
 	__le32 tmp;
 
 	priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_ANY);
@@ -283,6 +284,14 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 					(adapter->seq_num, priv->bss_num,
 					 priv->bss_type)));
 
+	do_gettimeofday(&ts);
+	dev_dbg(adapter->dev,
+		"cmd: DNLD_CMD: (%lu.%lu): %#x, act %#x, len %d, seqno %#x\n",
+		ts.tv_sec, ts.tv_usec, le16_to_cpu(sleep_cfm_buf->command),
+		le16_to_cpu(sleep_cfm_buf->action),
+		le16_to_cpu(sleep_cfm_buf->size),
+		le16_to_cpu(sleep_cfm_buf->seq_num));
+
 	if (adapter->iface_type == MWIFIEX_USB) {
 		sleep_cfm_tmp =
 			dev_alloc_skb(sizeof(struct mwifiex_opt_sleep_confirm)
@@ -457,11 +466,10 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 		rx_info->bss_type = priv->bss_type;
 	}
 
-	if (eventcause != EVENT_PS_SLEEP && eventcause != EVENT_PS_AWAKE) {
-		do_gettimeofday(&tstamp);
-		dev_dbg(adapter->dev, "event: %lu.%lu: cause: %#x\n",
-			tstamp.tv_sec, tstamp.tv_usec, eventcause);
-	} else {
+	do_gettimeofday(&tstamp);
+	dev_dbg(adapter->dev, "EVENT: %lu.%lu: cause: %#x\n",
+		tstamp.tv_sec, tstamp.tv_usec, eventcause);
+	if (eventcause == EVENT_PS_SLEEP || eventcause == EVENT_PS_AWAKE) {
 		/* Handle PS_SLEEP/AWAKE events on STA */
 		priv = mwifiex_get_priv(adapter, MWIFIEX_BSS_ROLE_STA);
 		if (!priv)
@@ -1228,12 +1236,19 @@ mwifiex_process_sleep_confirm_resp(struct mwifiex_adapter *adapter,
 	uint16_t result = le16_to_cpu(cmd->result);
 	uint16_t command = le16_to_cpu(cmd->command);
 	uint16_t seq_num = le16_to_cpu(cmd->seq_num);
+	struct timeval ts;
 
 	if (!upld_len) {
 		dev_err(adapter->dev, "%s: cmd size is 0\n", __func__);
 		return;
 	}
 
+	do_gettimeofday(&ts);
+	dev_dbg(adapter->dev,
+		"cmd: CMD_RESP: (%lu.%lu): 0x%x, result %d, len %d, seqno 0x%x\n",
+		ts.tv_sec, ts.tv_usec, command, result, le16_to_cpu(cmd->size),
+		seq_num);
+
 	/* Get BSS number and corresponding priv */
 	priv = mwifiex_get_priv_by_id(adapter, HostCmd_GET_BSS_NO(seq_num),
 				      HostCmd_GET_BSS_TYPE(seq_num));
-- 
1.8.2.3

