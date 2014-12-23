Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:51523 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754873AbaLWIOt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Dec 2014 03:14:49 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.14.5/8.14.5) with SMTP id sBN8EnpX010336
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:49 -0800
Received: from sc-owa04.marvell.com ([199.233.58.150])
	by mx0b-0016f401.pphosted.com with ESMTP id 1rd602ptat-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 23 Dec 2014 00:14:49 -0800
From: Avinash Patil <patila@marvell.com>
To: <linux-wireless@vger.kernel.org>
CC: <akarwar@marvell.com>, <cluo@marvell.com>, <yangyang@marvell.com>,
	<huxm@marvell.com>, Avinash Patil <patila@marvell.com>
Subject: [PATCH 5/8] mwifiex: move debug_data dump function to common utililty file
Date: Tue, 23 Dec 2014 19:14:09 +0530
Message-ID: <1419342252-2702-6-git-send-email-patila@marvell.com> (sfid-20141223_091454_449878_49F064D2)
In-Reply-To: <1419342252-2702-1-git-send-email-patila@marvell.com>
References: <1419342252-2702-1-git-send-email-patila@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Xinming Hu <huxm@marvell.com>

mwifiex_debug_info also need be save to file when firmware dump happens.
Move its dump implementation function to commmon utilility file, thus it
can be reused in firmware dump function.

Signed-off-by: Xinming Hu <huxm@marvell.com>
Signed-off-by: Cathy Luo <cluo@marvell.com>
Signed-off-by: Avinash Patil <patila@marvell.com>
---
 drivers/net/wireless/mwifiex/debugfs.c | 181 +--------------------------------
 drivers/net/wireless/mwifiex/util.c    | 177 ++++++++++++++++++++++++++++++++
 drivers/net/wireless/mwifiex/util.h    |  20 ++++
 3 files changed, 198 insertions(+), 180 deletions(-)

diff --git a/drivers/net/wireless/mwifiex/debugfs.c b/drivers/net/wireless/mwifiex/debugfs.c
index fe1eb74..1fb329d 100644
--- a/drivers/net/wireless/mwifiex/debugfs.c
+++ b/drivers/net/wireless/mwifiex/debugfs.c
@@ -39,111 +39,6 @@ static char *bss_modes[] = {
 	"P2P_DEVICE",
 };
 
-/* size/addr for mwifiex_debug_info */
-#define item_size(n)		(FIELD_SIZEOF(struct mwifiex_debug_info, n))
-#define item_addr(n)		(offsetof(struct mwifiex_debug_info, n))
-
-/* size/addr for struct mwifiex_adapter */
-#define adapter_item_size(n)	(FIELD_SIZEOF(struct mwifiex_adapter, n))
-#define adapter_item_addr(n)	(offsetof(struct mwifiex_adapter, n))
-
-struct mwifiex_debug_data {
-	char name[32];		/* variable/array name */
-	u32 size;		/* size of the variable/array */
-	size_t addr;		/* address of the variable/array */
-	int num;		/* number of variables in an array */
-};
-
-static struct mwifiex_debug_data items[] = {
-	{"int_counter", item_size(int_counter),
-	 item_addr(int_counter), 1},
-	{"wmm_ac_vo", item_size(packets_out[WMM_AC_VO]),
-	 item_addr(packets_out[WMM_AC_VO]), 1},
-	{"wmm_ac_vi", item_size(packets_out[WMM_AC_VI]),
-	 item_addr(packets_out[WMM_AC_VI]), 1},
-	{"wmm_ac_be", item_size(packets_out[WMM_AC_BE]),
-	 item_addr(packets_out[WMM_AC_BE]), 1},
-	{"wmm_ac_bk", item_size(packets_out[WMM_AC_BK]),
-	 item_addr(packets_out[WMM_AC_BK]), 1},
-	{"tx_buf_size", item_size(tx_buf_size),
-	 item_addr(tx_buf_size), 1},
-	{"curr_tx_buf_size", item_size(curr_tx_buf_size),
-	 item_addr(curr_tx_buf_size), 1},
-	{"ps_mode", item_size(ps_mode),
-	 item_addr(ps_mode), 1},
-	{"ps_state", item_size(ps_state),
-	 item_addr(ps_state), 1},
-	{"is_deep_sleep", item_size(is_deep_sleep),
-	 item_addr(is_deep_sleep), 1},
-	{"wakeup_dev_req", item_size(pm_wakeup_card_req),
-	 item_addr(pm_wakeup_card_req), 1},
-	{"wakeup_tries", item_size(pm_wakeup_fw_try),
-	 item_addr(pm_wakeup_fw_try), 1},
-	{"hs_configured", item_size(is_hs_configured),
-	 item_addr(is_hs_configured), 1},
-	{"hs_activated", item_size(hs_activated),
-	 item_addr(hs_activated), 1},
-	{"num_tx_timeout", item_size(num_tx_timeout),
-	 item_addr(num_tx_timeout), 1},
-	{"is_cmd_timedout", item_size(is_cmd_timedout),
-	 item_addr(is_cmd_timedout), 1},
-	{"timeout_cmd_id", item_size(timeout_cmd_id),
-	 item_addr(timeout_cmd_id), 1},
-	{"timeout_cmd_act", item_size(timeout_cmd_act),
-	 item_addr(timeout_cmd_act), 1},
-	{"last_cmd_id", item_size(last_cmd_id),
-	 item_addr(last_cmd_id), DBG_CMD_NUM},
-	{"last_cmd_act", item_size(last_cmd_act),
-	 item_addr(last_cmd_act), DBG_CMD_NUM},
-	{"last_cmd_index", item_size(last_cmd_index),
-	 item_addr(last_cmd_index), 1},
-	{"last_cmd_resp_id", item_size(last_cmd_resp_id),
-	 item_addr(last_cmd_resp_id), DBG_CMD_NUM},
-	{"last_cmd_resp_index", item_size(last_cmd_resp_index),
-	 item_addr(last_cmd_resp_index), 1},
-	{"last_event", item_size(last_event),
-	 item_addr(last_event), DBG_CMD_NUM},
-	{"last_event_index", item_size(last_event_index),
-	 item_addr(last_event_index), 1},
-	{"num_cmd_h2c_fail", item_size(num_cmd_host_to_card_failure),
-	 item_addr(num_cmd_host_to_card_failure), 1},
-	{"num_cmd_sleep_cfm_fail",
-	 item_size(num_cmd_sleep_cfm_host_to_card_failure),
-	 item_addr(num_cmd_sleep_cfm_host_to_card_failure), 1},
-	{"num_tx_h2c_fail", item_size(num_tx_host_to_card_failure),
-	 item_addr(num_tx_host_to_card_failure), 1},
-	{"num_evt_deauth", item_size(num_event_deauth),
-	 item_addr(num_event_deauth), 1},
-	{"num_evt_disassoc", item_size(num_event_disassoc),
-	 item_addr(num_event_disassoc), 1},
-	{"num_evt_link_lost", item_size(num_event_link_lost),
-	 item_addr(num_event_link_lost), 1},
-	{"num_cmd_deauth", item_size(num_cmd_deauth),
-	 item_addr(num_cmd_deauth), 1},
-	{"num_cmd_assoc_ok", item_size(num_cmd_assoc_success),
-	 item_addr(num_cmd_assoc_success), 1},
-	{"num_cmd_assoc_fail", item_size(num_cmd_assoc_failure),
-	 item_addr(num_cmd_assoc_failure), 1},
-	{"cmd_sent", item_size(cmd_sent),
-	 item_addr(cmd_sent), 1},
-	{"data_sent", item_size(data_sent),
-	 item_addr(data_sent), 1},
-	{"cmd_resp_received", item_size(cmd_resp_received),
-	 item_addr(cmd_resp_received), 1},
-	{"event_received", item_size(event_received),
-	 item_addr(event_received), 1},
-
-	/* variables defined in struct mwifiex_adapter */
-	{"cmd_pending", adapter_item_size(cmd_pending),
-	 adapter_item_addr(cmd_pending), 1},
-	{"tx_pending", adapter_item_size(tx_pending),
-	 adapter_item_addr(tx_pending), 1},
-	{"rx_pending", adapter_item_size(rx_pending),
-	 adapter_item_addr(rx_pending), 1},
-};
-
-static int num_of_items = ARRAY_SIZE(items);
-
 /*
  * Proc info file read handler.
  *
@@ -518,13 +413,9 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 {
 	struct mwifiex_private *priv =
 		(struct mwifiex_private *) file->private_data;
-	struct mwifiex_debug_data *d = &items[0];
 	unsigned long page = get_zeroed_page(GFP_KERNEL);
 	char *p = (char *) page;
 	ssize_t ret;
-	size_t size, addr;
-	long val;
-	int i, j;
 
 	if (!p)
 		return -ENOMEM;
@@ -533,77 +424,7 @@ mwifiex_debug_read(struct file *file, char __user *ubuf,
 	if (ret)
 		goto free_and_exit;
 
-	for (i = 0; i < num_of_items; i++) {
-		p += sprintf(p, "%s=", d[i].name);
-
-		size = d[i].size / d[i].num;
-
-		if (i < (num_of_items - 3))
-			addr = d[i].addr + (size_t) &info;
-		else /* The last 3 items are struct mwifiex_adapter variables */
-			addr = d[i].addr + (size_t) priv->adapter;
-
-		for (j = 0; j < d[i].num; j++) {
-			switch (size) {
-			case 1:
-				val = *((u8 *) addr);
-				break;
-			case 2:
-				val = *((u16 *) addr);
-				break;
-			case 4:
-				val = *((u32 *) addr);
-				break;
-			case 8:
-				val = *((long long *) addr);
-				break;
-			default:
-				val = -1;
-				break;
-			}
-
-			p += sprintf(p, "%#lx ", val);
-			addr += size;
-		}
-
-		p += sprintf(p, "\n");
-	}
-
-	if (info.tx_tbl_num) {
-		p += sprintf(p, "Tx BA stream table:\n");
-		for (i = 0; i < info.tx_tbl_num; i++)
-			p += sprintf(p, "tid = %d, ra = %pM\n",
-				     info.tx_tbl[i].tid, info.tx_tbl[i].ra);
-	}
-
-	if (info.rx_tbl_num) {
-		p += sprintf(p, "Rx reorder table:\n");
-		for (i = 0; i < info.rx_tbl_num; i++) {
-			p += sprintf(p, "tid = %d, ta = %pM, "
-				     "start_win = %d, "
-				     "win_size = %d, buffer: ",
-				     info.rx_tbl[i].tid,
-				     info.rx_tbl[i].ta,
-				     info.rx_tbl[i].start_win,
-				     info.rx_tbl[i].win_size);
-
-			for (j = 0; j < info.rx_tbl[i].win_size; j++)
-				p += sprintf(p, "%c ",
-					     info.rx_tbl[i].buffer[j] ?
-					     '1' : '0');
-
-			p += sprintf(p, "\n");
-		}
-	}
-
-	if (info.tdls_peer_num) {
-		p += sprintf(p, "TDLS peer table:\n");
-		for (i = 0; i < info.tdls_peer_num; i++) {
-			p += sprintf(p, "peer = %pM",
-				     info.tdls_list[i].peer_addr);
-			p += sprintf(p, "\n");
-		}
-	}
+	p += mwifiex_debug_info_to_buffer(priv, p, &info);
 
 	ret = simple_read_from_buffer(ubuf, count, ppos, (char *) page,
 				      (unsigned long) p - page);
diff --git a/drivers/net/wireless/mwifiex/util.c b/drivers/net/wireless/mwifiex/util.c
index 6a83c04..70731979 100644
--- a/drivers/net/wireless/mwifiex/util.c
+++ b/drivers/net/wireless/mwifiex/util.c
@@ -25,6 +25,96 @@
 #include "wmm.h"
 #include "11n.h"
 
+static struct mwifiex_debug_data items[] = {
+	{"int_counter", item_size(int_counter),
+	 item_addr(int_counter), 1},
+	{"wmm_ac_vo", item_size(packets_out[WMM_AC_VO]),
+	 item_addr(packets_out[WMM_AC_VO]), 1},
+	{"wmm_ac_vi", item_size(packets_out[WMM_AC_VI]),
+	 item_addr(packets_out[WMM_AC_VI]), 1},
+	{"wmm_ac_be", item_size(packets_out[WMM_AC_BE]),
+	 item_addr(packets_out[WMM_AC_BE]), 1},
+	{"wmm_ac_bk", item_size(packets_out[WMM_AC_BK]),
+	 item_addr(packets_out[WMM_AC_BK]), 1},
+	{"tx_buf_size", item_size(tx_buf_size),
+	 item_addr(tx_buf_size), 1},
+	{"curr_tx_buf_size", item_size(curr_tx_buf_size),
+	 item_addr(curr_tx_buf_size), 1},
+	{"ps_mode", item_size(ps_mode),
+	 item_addr(ps_mode), 1},
+	{"ps_state", item_size(ps_state),
+	 item_addr(ps_state), 1},
+	{"is_deep_sleep", item_size(is_deep_sleep),
+	 item_addr(is_deep_sleep), 1},
+	{"wakeup_dev_req", item_size(pm_wakeup_card_req),
+	 item_addr(pm_wakeup_card_req), 1},
+	{"wakeup_tries", item_size(pm_wakeup_fw_try),
+	 item_addr(pm_wakeup_fw_try), 1},
+	{"hs_configured", item_size(is_hs_configured),
+	 item_addr(is_hs_configured), 1},
+	{"hs_activated", item_size(hs_activated),
+	 item_addr(hs_activated), 1},
+	{"num_tx_timeout", item_size(num_tx_timeout),
+	 item_addr(num_tx_timeout), 1},
+	{"is_cmd_timedout", item_size(is_cmd_timedout),
+	 item_addr(is_cmd_timedout), 1},
+	{"timeout_cmd_id", item_size(timeout_cmd_id),
+	 item_addr(timeout_cmd_id), 1},
+	{"timeout_cmd_act", item_size(timeout_cmd_act),
+	 item_addr(timeout_cmd_act), 1},
+	{"last_cmd_id", item_size(last_cmd_id),
+	 item_addr(last_cmd_id), DBG_CMD_NUM},
+	{"last_cmd_act", item_size(last_cmd_act),
+	 item_addr(last_cmd_act), DBG_CMD_NUM},
+	{"last_cmd_index", item_size(last_cmd_index),
+	 item_addr(last_cmd_index), 1},
+	{"last_cmd_resp_id", item_size(last_cmd_resp_id),
+	 item_addr(last_cmd_resp_id), DBG_CMD_NUM},
+	{"last_cmd_resp_index", item_size(last_cmd_resp_index),
+	 item_addr(last_cmd_resp_index), 1},
+	{"last_event", item_size(last_event),
+	 item_addr(last_event), DBG_CMD_NUM},
+	{"last_event_index", item_size(last_event_index),
+	 item_addr(last_event_index), 1},
+	{"num_cmd_h2c_fail", item_size(num_cmd_host_to_card_failure),
+	 item_addr(num_cmd_host_to_card_failure), 1},
+	{"num_cmd_sleep_cfm_fail",
+	 item_size(num_cmd_sleep_cfm_host_to_card_failure),
+	 item_addr(num_cmd_sleep_cfm_host_to_card_failure), 1},
+	{"num_tx_h2c_fail", item_size(num_tx_host_to_card_failure),
+	 item_addr(num_tx_host_to_card_failure), 1},
+	{"num_evt_deauth", item_size(num_event_deauth),
+	 item_addr(num_event_deauth), 1},
+	{"num_evt_disassoc", item_size(num_event_disassoc),
+	 item_addr(num_event_disassoc), 1},
+	{"num_evt_link_lost", item_size(num_event_link_lost),
+	 item_addr(num_event_link_lost), 1},
+	{"num_cmd_deauth", item_size(num_cmd_deauth),
+	 item_addr(num_cmd_deauth), 1},
+	{"num_cmd_assoc_ok", item_size(num_cmd_assoc_success),
+	 item_addr(num_cmd_assoc_success), 1},
+	{"num_cmd_assoc_fail", item_size(num_cmd_assoc_failure),
+	 item_addr(num_cmd_assoc_failure), 1},
+	{"cmd_sent", item_size(cmd_sent),
+	 item_addr(cmd_sent), 1},
+	{"data_sent", item_size(data_sent),
+	 item_addr(data_sent), 1},
+	{"cmd_resp_received", item_size(cmd_resp_received),
+	 item_addr(cmd_resp_received), 1},
+	{"event_received", item_size(event_received),
+	 item_addr(event_received), 1},
+
+	/* variables defined in struct mwifiex_adapter */
+	{"cmd_pending", adapter_item_size(cmd_pending),
+	 adapter_item_addr(cmd_pending), 1},
+	{"tx_pending", adapter_item_size(tx_pending),
+	 adapter_item_addr(tx_pending), 1},
+	{"rx_pending", adapter_item_size(rx_pending),
+	 adapter_item_addr(rx_pending), 1},
+};
+
+static int num_of_items = ARRAY_SIZE(items);
+
 /*
  * Firmware initialization complete callback handler.
  *
@@ -143,6 +233,93 @@ int mwifiex_get_debug_info(struct mwifiex_private *priv,
 	return 0;
 }
 
+int mwifiex_debug_info_to_buffer(struct mwifiex_private *priv, char *buf,
+				 struct mwifiex_debug_info *info)
+{
+	char *p = buf;
+	struct mwifiex_debug_data *d = &items[0];
+	size_t size, addr;
+	long val;
+	int i, j;
+
+	if (!info)
+		return 0;
+
+	for (i = 0; i < num_of_items; i++) {
+		p += sprintf(p, "%s=", d[i].name);
+
+		size = d[i].size / d[i].num;
+
+		if (i < (num_of_items - 3))
+			addr = d[i].addr + (size_t)info;
+		else /* The last 3 items are struct mwifiex_adapter variables */
+			addr = d[i].addr + (size_t)priv->adapter;
+
+		for (j = 0; j < d[i].num; j++) {
+			switch (size) {
+			case 1:
+				val = *((u8 *)addr);
+				break;
+			case 2:
+				val = *((u16 *)addr);
+				break;
+			case 4:
+				val = *((u32 *)addr);
+				break;
+			case 8:
+				val = *((long long *)addr);
+				break;
+			default:
+				val = -1;
+				break;
+			}
+
+			p += sprintf(p, "%#lx ", val);
+			addr += size;
+		}
+
+		p += sprintf(p, "\n");
+	}
+
+	if (info->tx_tbl_num) {
+		p += sprintf(p, "Tx BA stream table:\n");
+		for (i = 0; i < info->tx_tbl_num; i++)
+			p += sprintf(p, "tid = %d, ra = %pM\n",
+				     info->tx_tbl[i].tid, info->tx_tbl[i].ra);
+	}
+
+	if (info->rx_tbl_num) {
+		p += sprintf(p, "Rx reorder table:\n");
+		for (i = 0; i < info->rx_tbl_num; i++) {
+			p += sprintf(p, "tid = %d, ta = %pM, ",
+				     info->rx_tbl[i].tid,
+				     info->rx_tbl[i].ta);
+			p += sprintf(p, "start_win = %d, ",
+				     info->rx_tbl[i].start_win);
+			p += sprintf(p, "win_size = %d, buffer: ",
+				     info->rx_tbl[i].win_size);
+
+			for (j = 0; j < info->rx_tbl[i].win_size; j++)
+				p += sprintf(p, "%c ",
+					     info->rx_tbl[i].buffer[j] ?
+					     '1' : '0');
+
+			p += sprintf(p, "\n");
+		}
+	}
+
+	if (info->tdls_peer_num) {
+		p += sprintf(p, "TDLS peer table:\n");
+		for (i = 0; i < info->tdls_peer_num; i++) {
+			p += sprintf(p, "peer = %pM",
+				     info->tdls_list[i].peer_addr);
+			p += sprintf(p, "\n");
+		}
+	}
+
+	return p - buf;
+}
+
 static int
 mwifiex_parse_mgmt_packet(struct mwifiex_private *priv, u8 *payload, u16 len,
 			  struct rxpd *rx_pd)
diff --git a/drivers/net/wireless/mwifiex/util.h b/drivers/net/wireless/mwifiex/util.h
index 40296cb..b541d66 100644
--- a/drivers/net/wireless/mwifiex/util.h
+++ b/drivers/net/wireless/mwifiex/util.h
@@ -20,6 +20,8 @@
 #ifndef _MWIFIEX_UTIL_H_
 #define _MWIFIEX_UTIL_H_
 
+struct mwifiex_private;
+
 struct mwifiex_dma_mapping {
 	dma_addr_t addr;
 	size_t len;
@@ -33,6 +35,21 @@ struct mwifiex_cb {
 	};
 };
 
+/* size/addr for mwifiex_debug_info */
+#define item_size(n)		(FIELD_SIZEOF(struct mwifiex_debug_info, n))
+#define item_addr(n)		(offsetof(struct mwifiex_debug_info, n))
+
+/* size/addr for struct mwifiex_adapter */
+#define adapter_item_size(n)	(FIELD_SIZEOF(struct mwifiex_adapter, n))
+#define adapter_item_addr(n)	(offsetof(struct mwifiex_adapter, n))
+
+struct mwifiex_debug_data {
+	char name[32];		/* variable/array name */
+	u32 size;		/* size of the variable/array */
+	size_t addr;		/* address of the variable/array */
+	int num;		/* number of variables in an array */
+};
+
 static inline struct mwifiex_rxinfo *MWIFIEX_SKB_RXCB(struct sk_buff *skb)
 {
 	struct mwifiex_cb *cb = (struct mwifiex_cb *)skb->cb;
@@ -73,4 +90,7 @@ static inline dma_addr_t MWIFIEX_SKB_DMA_ADDR(struct sk_buff *skb)
 	return mapping.addr;
 }
 
+int mwifiex_debug_info_to_buffer(struct mwifiex_private *priv, char *buf,
+				 struct mwifiex_debug_info *info);
+
 #endif /* !_MWIFIEX_UTIL_H_ */
-- 
1.8.1.4

