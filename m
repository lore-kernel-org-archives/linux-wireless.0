Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:38605 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754407AbbEKNsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 May 2015 09:48:53 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
	by mx0a-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id t4BDmmlc004690
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:48:48 -0700
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0a-0016f401.pphosted.com with ESMTP id 1u9729wwwg-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Mon, 11 May 2015 06:48:48 -0700
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <liuzy@marvell.com>,
	<crlo@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 3/4] mwifiex: add dump data debug support
Date: Tue, 12 May 2015 00:48:19 +0530
Message-ID: <1431371900-7260-3-git-send-email-patila@marvell.com> (sfid-20150511_154905_221770_5F0D4510)
In-Reply-To: <1431371900-7260-1-git-send-email-patila@marvell.com>
References: <1431371900-7260-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Zhaoyang Liu <liuzy@marvell.com>

This patch is to add support for data hexdump debug feature.
It is controlled by level debug_mask in adapter structure.

Signed-off-by: Zhaoyang Liu <liuzy@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/cmdevt.c | 11 +++++++++--
 drivers/net/wireless/mwifiex/main.h   |  9 +++++++++
 drivers/net/wireless/mwifiex/pcie.c   |  2 +-
 drivers/net/wireless/mwifiex/scan.c   |  3 +++
 drivers/net/wireless/mwifiex/txrx.c   |  5 +++++
 5 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/cmdevt.c b/drivers/net/wireless/mwifiex/cmdevt.c
index c5a14ff..5b19786 100644
--- a/drivers/net/wireless/mwifiex/cmdevt.c
+++ b/drivers/net/wireless/mwifiex/cmdevt.c
@@ -201,6 +201,7 @@ static int mwifiex_dnld_cmd_to_fw(struct mwifiex_private *priv,
 		"cmd: DNLD_CMD: %#x, act %#x, len %d, seqno %#x\n", cmd_code,
 		le16_to_cpu(*(__le16 *) ((u8 *) host_cmd + S_DS_GEN)), cmd_size,
 		le16_to_cpu(host_cmd->seq_num));
+	mwifiex_dbg_dump(adapter, CMD_D, "cmd buffer:", host_cmd, cmd_size);
 
 	if (adapter->iface_type == MWIFIEX_USB) {
 		tmp = cpu_to_le32(MWIFIEX_USB_TYPE_CMD);
@@ -286,6 +287,8 @@ static int mwifiex_dnld_sleep_confirm_cmd(struct mwifiex_adapter *adapter)
 		le16_to_cpu(sleep_cfm_buf->action),
 		le16_to_cpu(sleep_cfm_buf->size),
 		le16_to_cpu(sleep_cfm_buf->seq_num));
+	mwifiex_dbg_dump(adapter, CMD_D, "SLEEP_CFM buffer: ", sleep_cfm_buf,
+			 le16_to_cpu(sleep_cfm_buf->size));
 
 	if (adapter->iface_type == MWIFIEX_USB) {
 		sleep_cfm_tmp =
@@ -362,8 +365,9 @@ int mwifiex_alloc_cmd_buffer(struct mwifiex_adapter *adapter)
 	for (i = 0; i < MWIFIEX_NUM_OF_CMD_BUFFER; i++) {
 		cmd_array[i].skb = dev_alloc_skb(MWIFIEX_SIZE_OF_CMD_BUFFER);
 		if (!cmd_array[i].skb) {
-			dev_err(adapter->dev, "ALLOC_CMD_BUF: out of memory\n");
-			return -1;
+			dev_err(adapter->dev,
+				"unable to allocate command buffer\n");
+			return -ENOMEM;
 		}
 	}
 
@@ -460,6 +464,7 @@ int mwifiex_process_event(struct mwifiex_adapter *adapter)
 	}
 
 	dev_dbg(adapter->dev, "EVENT: cause: %#x\n", eventcause);
+	mwifiex_dbg_dump(adapter, EVT_D, "Event Buf:", skb->data, skb->len);
 
 	if (priv->bss_role == MWIFIEX_BSS_ROLE_UAP)
 		ret = mwifiex_process_uap_event(priv);
@@ -826,6 +831,8 @@ int mwifiex_process_cmdresp(struct mwifiex_adapter *adapter)
 		"cmd: CMD_RESP: 0x%x, result %d, len %d, seqno 0x%x\n",
 		orig_cmdresp_no, cmdresp_result,
 		le16_to_cpu(resp->size), le16_to_cpu(resp->seq_num));
+	mwifiex_dbg_dump(adapter, CMD_D, "CMD_RESP buffer:", resp,
+			 le16_to_cpu(resp->size));
 
 	if (!(orig_cmdresp_no & HostCmd_RET_BIT)) {
 		dev_err(adapter->dev, "CMD_RESP: invalid cmd resp\n");
diff --git a/drivers/net/wireless/mwifiex/main.h b/drivers/net/wireless/mwifiex/main.h
index 6cbbc50..2f55161 100644
--- a/drivers/net/wireless/mwifiex/main.h
+++ b/drivers/net/wireless/mwifiex/main.h
@@ -186,6 +186,15 @@ do {								\
 			dev_info((adapter)->dev, fmt, ## args);	\
 } while (0)
 
+#define DEBUG_DUMP_DATA_MAX_LEN		128
+#define mwifiex_dbg_dump(adapter, dbg_mask, str, buf, len)	\
+do {								\
+	if ((adapter)->debug_mask & MWIFIEX_DBG_##dbg_mask)	\
+		print_hex_dump(KERN_DEBUG, str,			\
+			       DUMP_PREFIX_OFFSET, 16, 1,	\
+			       buf, len, false);		\
+} while (0)
+
 struct mwifiex_dbg {
 	u32 num_cmd_host_to_card_failure;
 	u32 num_cmd_sleep_cfm_host_to_card_failure;
diff --git a/drivers/net/wireless/mwifiex/pcie.c b/drivers/net/wireless/mwifiex/pcie.c
index bcc7751..88bda3f 100644
--- a/drivers/net/wireless/mwifiex/pcie.c
+++ b/drivers/net/wireless/mwifiex/pcie.c
@@ -1721,7 +1721,7 @@ static int mwifiex_pcie_process_event_ready(struct mwifiex_adapter *adapter)
 		   len is 2 bytes followed by type which is 2 bytes */
 		memcpy(&data_len, skb_cmd->data, sizeof(__le16));
 		evt_len = le16_to_cpu(data_len);
-
+		skb_trim(skb_cmd, evt_len);
 		skb_pull(skb_cmd, INTF_HEADER_LEN);
 		dev_dbg(adapter->dev, "info: Event length: %d\n", evt_len);
 
diff --git a/drivers/net/wireless/mwifiex/scan.c b/drivers/net/wireless/mwifiex/scan.c
index 0ffdb7c..84843d1 100644
--- a/drivers/net/wireless/mwifiex/scan.c
+++ b/drivers/net/wireless/mwifiex/scan.c
@@ -2125,6 +2125,9 @@ int mwifiex_handle_event_ext_scan_report(struct mwifiex_private *priv,
 	dev_dbg(adapter->dev,
 		"EXT_SCAN: size %d, returned %d APs...",
 		scan_resp_size, num_of_set);
+	mwifiex_dbg_dump(adapter, CMD_D, "EXT_SCAN buffer:", buf,
+			 scan_resp_size +
+			 sizeof(struct mwifiex_event_scan_result));
 
 	tlv = (struct mwifiex_ie_types_data *)scan_resp;
 
diff --git a/drivers/net/wireless/mwifiex/txrx.c b/drivers/net/wireless/mwifiex/txrx.c
index a245f44..73082b5 100644
--- a/drivers/net/wireless/mwifiex/txrx.c
+++ b/drivers/net/wireless/mwifiex/txrx.c
@@ -55,6 +55,9 @@ int mwifiex_handle_rx_packet(struct mwifiex_adapter *adapter,
 		return -1;
 	}
 
+	mwifiex_dbg_dump(adapter, DAT_D, "rx pkt:", skb->data,
+			 min_t(size_t, skb->len, DEBUG_DUMP_DATA_MAX_LEN));
+
 	memset(rx_info, 0, sizeof(*rx_info));
 	rx_info->bss_num = priv->bss_num;
 	rx_info->bss_type = priv->bss_type;
@@ -112,6 +115,8 @@ int mwifiex_process_tx(struct mwifiex_private *priv, struct sk_buff *skb,
 							   skb, tx_param);
 		}
 	}
+	mwifiex_dbg_dump(adapter, DAT_D, "tx pkt:", skb->data,
+			 min_t(size_t, skb->len, DEBUG_DUMP_DATA_MAX_LEN));
 
 	switch (ret) {
 	case -ENOSR:
-- 
1.8.1.4

