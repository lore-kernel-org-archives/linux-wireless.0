Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46992 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbcBWNUa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 08:20:30 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id u1NDJfJm005571
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:29 -0800
Received: from sc-exch02.marvell.com ([199.233.58.182])
	by mx0b-0016f401.pphosted.com with ESMTP id 218m3q0saa-1
	(version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 05:20:29 -0800
From: Amitkumar Karwar <akarwar@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Xinming Hu <huxm@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Subject: [PATCH 3/4] mwifiex: add sdio multiport aggregation debug information
Date: Tue, 23 Feb 2016 05:16:18 -0800
Message-ID: <1456233379-12099-3-git-send-email-akarwar@marvell.com> (sfid-20160223_142033_485183_BB9D1605)
In-Reply-To: <1456233379-12099-1-git-send-email-akarwar@marvell.com>
References: <1456233379-12099-1-git-send-email-akarwar@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

This patch sdio multi port aggregation statistics which can be
used for debugging. This debug data is collected in
/sys/kernel/debug/mwifiex/mlan0/debug.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Amitkumar Karwar <akarwar@marvell.com>
---
 drivers/net/wireless/marvell/mwifiex/ioctl.h |  6 ++++++
 drivers/net/wireless/marvell/mwifiex/main.h  |  5 +++++
 drivers/net/wireless/marvell/mwifiex/sdio.c  | 10 ++++++++++
 drivers/net/wireless/marvell/mwifiex/util.c  | 20 ++++++++++++++++++++
 4 files changed, 41 insertions(+)

diff --git a/drivers/net/wireless/marvell/mwifiex/ioctl.h b/drivers/net/wireless/marvell/mwifiex/ioctl.h
index 14cfa37..a5a48c1 100644
--- a/drivers/net/wireless/marvell/mwifiex/ioctl.h
+++ b/drivers/net/wireless/marvell/mwifiex/ioctl.h
@@ -184,6 +184,7 @@ struct mwifiex_ds_tx_ba_stream_tbl {
 };
 
 #define DBG_CMD_NUM    5
+#define MWIFIEX_DBG_SDIO_MP_NUM    10
 
 struct tdls_peer_info {
 	u8 peer_addr[ETH_ALEN];
@@ -235,6 +236,11 @@ struct mwifiex_debug_info {
 	u8 cmd_sent;
 	u8 cmd_resp_received;
 	u8 event_received;
+	u32 last_mp_wr_bitmap[MWIFIEX_DBG_SDIO_MP_NUM];
+	u32 last_mp_wr_ports[MWIFIEX_DBG_SDIO_MP_NUM];
+	u32 last_mp_wr_len[MWIFIEX_DBG_SDIO_MP_NUM];
+	u32 last_mp_curr_wr_port[MWIFIEX_DBG_SDIO_MP_NUM];
+	u8 last_sdio_mp_index;
 };
 
 #define MWIFIEX_KEY_INDEX_UNICAST	0x40000000
diff --git a/drivers/net/wireless/marvell/mwifiex/main.h b/drivers/net/wireless/marvell/mwifiex/main.h
index aea7aee..aafc4ab 100644
--- a/drivers/net/wireless/marvell/mwifiex/main.h
+++ b/drivers/net/wireless/marvell/mwifiex/main.h
@@ -223,6 +223,11 @@ struct mwifiex_dbg {
 	u16 last_cmd_resp_index;
 	u16 last_event[DBG_CMD_NUM];
 	u16 last_event_index;
+	u32 last_mp_wr_bitmap[MWIFIEX_DBG_SDIO_MP_NUM];
+	u32 last_mp_wr_ports[MWIFIEX_DBG_SDIO_MP_NUM];
+	u32 last_mp_wr_len[MWIFIEX_DBG_SDIO_MP_NUM];
+	u32 last_mp_curr_wr_port[MWIFIEX_DBG_SDIO_MP_NUM];
+	u8 last_sdio_mp_index;
 };
 
 enum MWIFIEX_HARDWARE_STATUS {
diff --git a/drivers/net/wireless/marvell/mwifiex/sdio.c b/drivers/net/wireless/marvell/mwifiex/sdio.c
index abf15db..838b260 100644
--- a/drivers/net/wireless/marvell/mwifiex/sdio.c
+++ b/drivers/net/wireless/marvell/mwifiex/sdio.c
@@ -1684,6 +1684,7 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 	s32 f_precopy_cur_buf = 0;
 	s32 f_postcopy_cur_buf = 0;
 	u32 mport;
+	int index;
 
 	if (!card->mpa_tx.enabled ||
 	    (card->has_control_mask && (port == CTRL_PORT)) ||
@@ -1788,6 +1789,15 @@ static int mwifiex_host_to_card_mp_aggr(struct mwifiex_adapter *adapter,
 		ret = mwifiex_write_data_to_card(adapter, card->mpa_tx.buf,
 						 card->mpa_tx.buf_len, mport);
 
+		/* Save the last multi port tx aggreagation info to debug log */
+		index = adapter->dbg.last_sdio_mp_index;
+		index = (index + 1) % MWIFIEX_DBG_SDIO_MP_NUM;
+		adapter->dbg.last_sdio_mp_index = index;
+		adapter->dbg.last_mp_wr_ports[index] = mport;
+		adapter->dbg.last_mp_wr_bitmap[index] = card->mp_wr_bitmap;
+		adapter->dbg.last_mp_wr_len[index] = card->mpa_tx.buf_len;
+		adapter->dbg.last_mp_curr_wr_port[index] = card->curr_wr_port;
+
 		MP_TX_AGGR_BUF_RESET(card);
 	}
 
diff --git a/drivers/net/wireless/marvell/mwifiex/util.c b/drivers/net/wireless/marvell/mwifiex/util.c
index 0cec8a6..6681be0 100644
--- a/drivers/net/wireless/marvell/mwifiex/util.c
+++ b/drivers/net/wireless/marvell/mwifiex/util.c
@@ -78,6 +78,16 @@ static struct mwifiex_debug_data items[] = {
 	 item_addr(last_event), DBG_CMD_NUM},
 	{"last_event_index", item_size(last_event_index),
 	 item_addr(last_event_index), 1},
+	{"last_mp_wr_bitmap", item_size(last_mp_wr_bitmap),
+	 item_addr(last_mp_wr_bitmap), MWIFIEX_DBG_SDIO_MP_NUM},
+	{"last_mp_wr_ports", item_size(last_mp_wr_ports),
+	 item_addr(last_mp_wr_ports), MWIFIEX_DBG_SDIO_MP_NUM},
+	{"last_mp_wr_len", item_size(last_mp_wr_len),
+	 item_addr(last_mp_wr_len), MWIFIEX_DBG_SDIO_MP_NUM},
+	{"last_mp_curr_wr_port", item_size(last_mp_curr_wr_port),
+	 item_addr(last_mp_curr_wr_port), MWIFIEX_DBG_SDIO_MP_NUM},
+	{"last_sdio_mp_index", item_size(last_sdio_mp_index),
+	 item_addr(last_sdio_mp_index), 1},
 	{"num_cmd_h2c_fail", item_size(num_cmd_host_to_card_failure),
 	 item_addr(num_cmd_host_to_card_failure), 1},
 	{"num_cmd_sleep_cfm_fail",
@@ -233,6 +243,16 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 		memcpy(info->last_event, adapter->dbg.last_event,
 		       sizeof(adapter->dbg.last_event));
 		info->last_event_index = adapter->dbg.last_event_index;
+		memcpy(info->last_mp_wr_bitmap, adapter->dbg.last_mp_wr_bitmap,
+		       sizeof(adapter->dbg.last_mp_wr_bitmap));
+		memcpy(info->last_mp_wr_ports, adapter->dbg.last_mp_wr_ports,
+		       sizeof(adapter->dbg.last_mp_wr_ports));
+		memcpy(info->last_mp_curr_wr_port,
+		       adapter->dbg.last_mp_curr_wr_port,
+		       sizeof(adapter->dbg.last_mp_curr_wr_port));
+		memcpy(info->last_mp_wr_len, adapter->dbg.last_mp_wr_len,
+		       sizeof(adapter->dbg.last_mp_wr_len));
+		info->last_sdio_mp_index = adapter->dbg.last_sdio_mp_index;
 		info->data_sent = adapter->data_sent;
 		info->cmd_sent = adapter->cmd_sent;
 		info->cmd_resp_received = adapter->cmd_resp_received;
-- 
1.8.1.4

