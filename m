Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63121 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753712Ab0BYGMQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 01:12:16 -0500
From: Zhu Yi <yi.zhu@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Zhu Yi <yi.zhu@intel.com>
Subject: [PATCH 3/7] iwmc3200wifi: add ftrace event tracing support
Date: Thu, 25 Feb 2010 14:15:27 +0800
Message-Id: <1267078531-9817-4-git-send-email-yi.zhu@intel.com>
In-Reply-To: <1267078531-9817-3-git-send-email-yi.zhu@intel.com>
References: <1267078531-9817-1-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-2-git-send-email-yi.zhu@intel.com>
 <1267078531-9817-3-git-send-email-yi.zhu@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add event tracer for iwmc3200wifi driver. When enabled, all the
commands and responses between the driver and firmware (also
including Tx/Rx frames) will be recorded in the ftrace ring buffer.

Signed-off-by: Zhu Yi <yi.zhu@intel.com>
---
 drivers/net/wireless/iwmc3200wifi/Kconfig  |    9 +-
 drivers/net/wireless/iwmc3200wifi/Makefile |    3 +
 drivers/net/wireless/iwmc3200wifi/hal.c    |    3 +
 drivers/net/wireless/iwmc3200wifi/hal.h    |    3 +-
 drivers/net/wireless/iwmc3200wifi/iwm.h    |    1 +
 drivers/net/wireless/iwmc3200wifi/rx.c     |   15 +-
 drivers/net/wireless/iwmc3200wifi/trace.c  |    3 +
 drivers/net/wireless/iwmc3200wifi/trace.h  |  283 ++++++++++++++++++++++++++++
 drivers/net/wireless/iwmc3200wifi/tx.c     |    1 +
 9 files changed, 314 insertions(+), 7 deletions(-)
 create mode 100644 drivers/net/wireless/iwmc3200wifi/trace.c
 create mode 100644 drivers/net/wireless/iwmc3200wifi/trace.h

diff --git a/drivers/net/wireless/iwmc3200wifi/Kconfig b/drivers/net/wireless/iwmc3200wifi/Kconfig
index b9d34a7..03f998d 100644
--- a/drivers/net/wireless/iwmc3200wifi/Kconfig
+++ b/drivers/net/wireless/iwmc3200wifi/Kconfig
@@ -17,7 +17,7 @@ config IWM
 config IWM_DEBUG
 	bool "Enable full debugging output in iwmc3200wifi"
 	depends on IWM && DEBUG_FS
-	---help---
+	help
 	  This option will enable debug tracing and setting for iwm
 
 	  You can set the debug level and module through debugfs. By
@@ -30,3 +30,10 @@ config IWM_DEBUG
 	  Or, if you want the full debug, for all modules:
 	  echo 0xff > /sys/kernel/debug/iwm/phyN/debug/level
 	  echo 0xff > /sys/kernel/debug/iwm/phyN/debug/modules
+
+config IWM_TRACING
+	bool "Enable event tracing for iwmc3200wifi"
+	depends on IWM && EVENT_TRACING
+	help
+	  Say Y here to trace all the commands and responses between
+	  the driver and firmware (including TX/RX frames) with ftrace.
diff --git a/drivers/net/wireless/iwmc3200wifi/Makefile b/drivers/net/wireless/iwmc3200wifi/Makefile
index d34291b..aeed5cd 100644
--- a/drivers/net/wireless/iwmc3200wifi/Makefile
+++ b/drivers/net/wireless/iwmc3200wifi/Makefile
@@ -3,3 +3,6 @@ iwmc3200wifi-objs += main.o netdev.o rx.o tx.o sdio.o hal.o fw.o
 iwmc3200wifi-objs += commands.o cfg80211.o eeprom.o
 
 iwmc3200wifi-$(CONFIG_IWM_DEBUG) += debugfs.o
+iwmc3200wifi-$(CONFIG_IWM_TRACING) += trace.o
+
+CFLAGS_trace.o := -I$(src)
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.c b/drivers/net/wireless/iwmc3200wifi/hal.c
index 96caab4..373b5b5 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.c
+++ b/drivers/net/wireless/iwmc3200wifi/hal.c
@@ -104,6 +104,7 @@
 #include "hal.h"
 #include "umac.h"
 #include "debug.h"
+#include "trace.h"
 
 static int iwm_nonwifi_cmd_init(struct iwm_priv *iwm,
 				struct iwm_nonwifi_cmd *cmd,
@@ -276,6 +277,7 @@ static int iwm_send_udma_nonwifi_cmd(struct iwm_priv *iwm,
 		    udma_cmd->handle_by_hw, cmd->seq_num, udma_cmd->addr,
 		    udma_cmd->op1_sz, udma_cmd->op2);
 
+	trace_iwm_tx_nonwifi_cmd(iwm, udma_hdr);
 	return iwm_bus_send_chunk(iwm, buf->start, buf->len);
 }
 
@@ -362,6 +364,7 @@ static int iwm_send_udma_wifi_cmd(struct iwm_priv *iwm,
 		return ret;
 	}
 
+	trace_iwm_tx_wifi_cmd(iwm, umac_hdr);
 	return iwm_bus_send_chunk(iwm, buf->start, buf->len);
 }
 
diff --git a/drivers/net/wireless/iwmc3200wifi/hal.h b/drivers/net/wireless/iwmc3200wifi/hal.h
index 0adfdc8..e7bc416 100644
--- a/drivers/net/wireless/iwmc3200wifi/hal.h
+++ b/drivers/net/wireless/iwmc3200wifi/hal.h
@@ -75,7 +75,8 @@ do {									  \
 
 
 /* UDMA IN OP CODE -- cmd bits [3:0] */
-#define UDMA_IN_OPCODE_MASK			0xF
+#define UDMA_HDI_IN_NW_CMD_OPCODE_POS		0
+#define UDMA_HDI_IN_NW_CMD_OPCODE_SEED		0xF
 
 #define UDMA_IN_OPCODE_GENERAL_RESP		0x0
 #define UDMA_IN_OPCODE_READ_RESP		0x1
diff --git a/drivers/net/wireless/iwmc3200wifi/iwm.h b/drivers/net/wireless/iwmc3200wifi/iwm.h
index 79ffa3b..9ad5b3c 100644
--- a/drivers/net/wireless/iwmc3200wifi/iwm.h
+++ b/drivers/net/wireless/iwmc3200wifi/iwm.h
@@ -48,6 +48,7 @@
 #include "umac.h"
 #include "lmac.h"
 #include "eeprom.h"
+#include "trace.h"
 
 #define IWM_COPYRIGHT "Copyright(c) 2009 Intel Corporation"
 #define IWM_AUTHOR "<ilw@linux.intel.com>"
diff --git a/drivers/net/wireless/iwmc3200wifi/rx.c b/drivers/net/wireless/iwmc3200wifi/rx.c
index cbaf8ae..38d950b 100644
--- a/drivers/net/wireless/iwmc3200wifi/rx.c
+++ b/drivers/net/wireless/iwmc3200wifi/rx.c
@@ -1235,18 +1235,24 @@ static int iwm_rx_handle_wifi(struct iwm_priv *iwm, u8 *buf,
 	u8 source, cmd_id;
 	u16 seq_num;
 	u32 count;
-	u8 resp;
 
 	wifi_hdr = (struct iwm_umac_wifi_in_hdr *)buf;
 	cmd_id = wifi_hdr->sw_hdr.cmd.cmd;
-
 	source = GET_VAL32(wifi_hdr->hw_hdr.cmd, UMAC_HDI_IN_CMD_SOURCE);
 	if (source >= IWM_SRC_NUM) {
 		IWM_CRIT(iwm, "invalid source %d\n", source);
 		return -EINVAL;
 	}
 
-	count = (GET_VAL32(wifi_hdr->sw_hdr.meta_data, UMAC_FW_CMD_BYTE_COUNT));
+	if (cmd_id == REPLY_RX_MPDU_CMD)
+		trace_iwm_rx_packet(iwm, buf, buf_size);
+	else if ((cmd_id == UMAC_NOTIFY_OPCODE_RX_TICKET) &&
+		 (source == UMAC_HDI_IN_SOURCE_FW))
+		trace_iwm_rx_ticket(iwm, buf, buf_size);
+	else
+		trace_iwm_rx_wifi_cmd(iwm, wifi_hdr);
+
+	count = GET_VAL32(wifi_hdr->sw_hdr.meta_data, UMAC_FW_CMD_BYTE_COUNT);
 	count += sizeof(struct iwm_umac_wifi_in_hdr) -
 		 sizeof(struct iwm_dev_cmd_hdr);
 	if (count > buf_size) {
@@ -1254,8 +1260,6 @@ static int iwm_rx_handle_wifi(struct iwm_priv *iwm, u8 *buf,
 		return -EINVAL;
 	}
 
-	resp = GET_VAL32(wifi_hdr->sw_hdr.meta_data, UMAC_FW_CMD_STATUS);
-
 	seq_num = le16_to_cpu(wifi_hdr->sw_hdr.cmd.seq_num);
 
 	IWM_DBG_RX(iwm, DBG, "CMD:0x%x, source: 0x%x, seqnum: %d\n",
@@ -1330,6 +1334,7 @@ static int iwm_rx_handle_nonwifi(struct iwm_priv *iwm, u8 *buf,
 	struct iwm_udma_in_hdr *hdr = (struct iwm_udma_in_hdr *)buf;
 	struct iwm_nonwifi_cmd *cmd;
 
+	trace_iwm_rx_nonwifi_cmd(iwm, buf, buf_size);
 	seq_num = GET_VAL32(hdr->cmd, UDMA_HDI_IN_CMD_NON_WIFI_HW_SEQ_NUM);
 
 	/*
diff --git a/drivers/net/wireless/iwmc3200wifi/trace.c b/drivers/net/wireless/iwmc3200wifi/trace.c
new file mode 100644
index 0000000..904d36f
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/trace.c
@@ -0,0 +1,3 @@
+#include "iwm.h"
+#define CREATE_TRACE_POINTS
+#include "trace.h"
diff --git a/drivers/net/wireless/iwmc3200wifi/trace.h b/drivers/net/wireless/iwmc3200wifi/trace.h
new file mode 100644
index 0000000..320e54f
--- /dev/null
+++ b/drivers/net/wireless/iwmc3200wifi/trace.h
@@ -0,0 +1,283 @@
+#if !defined(__IWM_TRACE_H__) || defined(TRACE_HEADER_MULTI_READ)
+#define __IWM_TRACE_H__
+
+#include <linux/tracepoint.h>
+
+#if !defined(CONFIG_IWM_TRACING)
+#undef TRACE_EVENT
+#define TRACE_EVENT(name, proto, ...) \
+static inline void trace_ ## name(proto) {}
+#endif
+
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM iwm
+
+#define IWM_ENTRY	__array(char, ndev_name, 16)
+#define IWM_ASSIGN	strlcpy(__entry->ndev_name, iwm_to_ndev(iwm)->name, 16)
+#define IWM_PR_FMT	"%s"
+#define IWM_PR_ARG	__entry->ndev_name
+
+TRACE_EVENT(iwm_tx_nonwifi_cmd,
+	TP_PROTO(struct iwm_priv *iwm, struct iwm_udma_out_nonwifi_hdr *hdr),
+
+	TP_ARGS(iwm, hdr),
+
+	TP_STRUCT__entry(
+		IWM_ENTRY
+		__field(u8, opcode)
+		__field(u8, resp)
+		__field(u8, eot)
+		__field(u8, hw)
+		__field(u16, seq)
+		__field(u32, addr)
+		__field(u32, op1)
+		__field(u32, op2)
+	),
+
+	TP_fast_assign(
+		IWM_ASSIGN;
+		__entry->opcode = GET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_OPCODE);
+		__entry->resp = GET_VAL32(hdr->cmd, UDMA_HDI_OUT_NW_CMD_RESP);
+		__entry->eot = GET_VAL32(hdr->cmd, UMAC_HDI_OUT_CMD_EOT);
+		__entry->hw = GET_VAL32(hdr->cmd, UDMA_HDI_OUT_NW_CMD_HANDLE_BY_HW);
+		__entry->seq = GET_VAL32(hdr->cmd, UDMA_HDI_OUT_CMD_NON_WIFI_HW_SEQ_NUM);
+		__entry->addr = le32_to_cpu(hdr->addr);
+		__entry->op1 = le32_to_cpu(hdr->op1_sz);
+		__entry->op2 = le32_to_cpu(hdr->op2);
+	),
+
+	TP_printk(
+		IWM_PR_FMT " Tx TARGET CMD: opcode 0x%x, resp %d, eot %d, "
+		"hw %d, seq 0x%x, addr 0x%x, op1 0x%x, op2 0x%x",
+		IWM_PR_ARG, __entry->opcode, __entry->resp, __entry->eot,
+		__entry->hw, __entry->seq, __entry->addr, __entry->op1,
+		__entry->op2
+	)
+);
+
+TRACE_EVENT(iwm_tx_wifi_cmd,
+	TP_PROTO(struct iwm_priv *iwm, struct iwm_umac_wifi_out_hdr *hdr),
+
+	TP_ARGS(iwm, hdr),
+
+	TP_STRUCT__entry(
+		IWM_ENTRY
+		__field(u8, opcode)
+		__field(u8, lmac)
+		__field(u8, resp)
+		__field(u8, eot)
+		__field(u8, ra_tid)
+		__field(u8, credit_group)
+		__field(u8, color)
+		__field(u16, seq)
+	),
+
+	TP_fast_assign(
+		IWM_ASSIGN;
+		__entry->opcode = hdr->sw_hdr.cmd.cmd;
+		__entry->lmac = 0;
+		__entry->seq = hdr->sw_hdr.cmd.seq_num;
+		__entry->resp = GET_VAL8(hdr->sw_hdr.cmd.flags, UMAC_DEV_CMD_FLAGS_RESP_REQ);
+		__entry->color = GET_VAL32(hdr->sw_hdr.meta_data, UMAC_FW_CMD_TX_STA_COLOR);
+		__entry->eot = GET_VAL32(hdr->hw_hdr.cmd, UMAC_HDI_OUT_CMD_EOT);
+		__entry->ra_tid = GET_VAL32(hdr->hw_hdr.meta_data, UMAC_HDI_OUT_RATID);
+		__entry->credit_group = GET_VAL32(hdr->hw_hdr.meta_data, UMAC_HDI_OUT_CREDIT_GRP);
+		if (__entry->opcode == UMAC_CMD_OPCODE_WIFI_PASS_THROUGH ||
+		    __entry->opcode == UMAC_CMD_OPCODE_WIFI_IF_WRAPPER) {
+			__entry->lmac = 1;
+			__entry->opcode = ((struct iwm_lmac_hdr *)(hdr + 1))->id;
+		}
+	),
+
+	TP_printk(
+		IWM_PR_FMT " Tx %cMAC CMD: opcode 0x%x, resp %d, eot %d, "
+		"seq 0x%x, sta_color 0x%x, ra_tid 0x%x, credit_group 0x%x",
+		IWM_PR_ARG, __entry->lmac ? 'L' : 'U', __entry->opcode,
+		__entry->resp, __entry->eot, __entry->seq, __entry->color,
+		__entry->ra_tid, __entry->credit_group
+	)
+);
+
+TRACE_EVENT(iwm_tx_packets,
+	TP_PROTO(struct iwm_priv *iwm, u8 *buf, int len),
+
+	TP_ARGS(iwm, buf, len),
+
+	TP_STRUCT__entry(
+		IWM_ENTRY
+		__field(u8, eot)
+		__field(u8, ra_tid)
+		__field(u8, credit_group)
+		__field(u8, color)
+		__field(u16, seq)
+		__field(u8, npkt)
+		__field(u32, bytes)
+	),
+
+	TP_fast_assign(
+		struct iwm_umac_wifi_out_hdr *hdr =
+			(struct iwm_umac_wifi_out_hdr *)buf;
+
+		IWM_ASSIGN;
+		__entry->eot = GET_VAL32(hdr->hw_hdr.cmd, UMAC_HDI_OUT_CMD_EOT);
+		__entry->ra_tid = GET_VAL32(hdr->hw_hdr.meta_data, UMAC_HDI_OUT_RATID);
+		__entry->credit_group = GET_VAL32(hdr->hw_hdr.meta_data, UMAC_HDI_OUT_CREDIT_GRP);
+		__entry->color = GET_VAL32(hdr->sw_hdr.meta_data, UMAC_FW_CMD_TX_STA_COLOR);
+		__entry->seq = hdr->sw_hdr.cmd.seq_num;
+		__entry->npkt = 1;
+		__entry->bytes = len;
+
+		if (!__entry->eot) {
+			int count;
+			u8 *ptr = buf;
+
+			__entry->npkt = 0;
+			while (ptr < buf + len) {
+				count = GET_VAL32(hdr->sw_hdr.meta_data,
+						  UMAC_FW_CMD_BYTE_COUNT);
+				ptr += ALIGN(sizeof(*hdr) + count, 16);
+				hdr = (struct iwm_umac_wifi_out_hdr *)ptr;
+				__entry->npkt++;
+			}
+		}
+	),
+
+	TP_printk(
+		IWM_PR_FMT " Tx %spacket: eot %d, seq 0x%x, sta_color 0x%x, "
+		"ra_tid 0x%x, credit_group 0x%x, embeded_packets %d, %d bytes",
+		IWM_PR_ARG, !__entry->eot ? "concatenated " : "",
+		__entry->eot, __entry->seq, __entry->color, __entry->ra_tid,
+		__entry->credit_group, __entry->npkt, __entry->bytes
+	)
+);
+
+TRACE_EVENT(iwm_rx_nonwifi_cmd,
+	TP_PROTO(struct iwm_priv *iwm, void *buf, int len),
+
+	TP_ARGS(iwm, buf, len),
+
+	TP_STRUCT__entry(
+		IWM_ENTRY
+		__field(u8, opcode)
+		__field(u16, seq)
+		__field(u32, len)
+	),
+
+	TP_fast_assign(
+		struct iwm_udma_in_hdr *hdr = buf;
+
+		IWM_ASSIGN;
+		__entry->opcode = GET_VAL32(hdr->cmd, UDMA_HDI_IN_NW_CMD_OPCODE);
+		__entry->seq = GET_VAL32(hdr->cmd, UDMA_HDI_IN_CMD_NON_WIFI_HW_SEQ_NUM);
+		__entry->len = len;
+	),
+
+	TP_printk(
+		IWM_PR_FMT " Rx TARGET RESP: opcode 0x%x, seq 0x%x, len 0x%x",
+		IWM_PR_ARG, __entry->opcode, __entry->seq, __entry->len
+	)
+);
+
+TRACE_EVENT(iwm_rx_wifi_cmd,
+	TP_PROTO(struct iwm_priv *iwm, struct iwm_umac_wifi_in_hdr *hdr),
+
+	TP_ARGS(iwm, hdr),
+
+	TP_STRUCT__entry(
+		IWM_ENTRY
+		__field(u8, cmd)
+		__field(u8, source)
+		__field(u16, seq)
+		__field(u32, count)
+	),
+
+	TP_fast_assign(
+		IWM_ASSIGN;
+		__entry->cmd = hdr->sw_hdr.cmd.cmd;
+		__entry->source = GET_VAL32(hdr->hw_hdr.cmd, UMAC_HDI_IN_CMD_SOURCE);
+		__entry->count = GET_VAL32(hdr->sw_hdr.meta_data, UMAC_FW_CMD_BYTE_COUNT);
+		__entry->seq = le16_to_cpu(hdr->sw_hdr.cmd.seq_num);
+	),
+
+	TP_printk(
+		IWM_PR_FMT " Rx %s RESP: cmd 0x%x, seq 0x%x, count 0x%x",
+		IWM_PR_ARG, __entry->source == UMAC_HDI_IN_SOURCE_FHRX ? "LMAC" :
+		__entry->source == UMAC_HDI_IN_SOURCE_FW ? "UMAC" : "UDMA",
+		__entry->cmd, __entry->seq, __entry->count
+	)
+);
+
+#define iwm_ticket_action_symbol		\
+	{ IWM_RX_TICKET_DROP, "DROP" },		\
+	{ IWM_RX_TICKET_RELEASE, "RELEASE" },	\
+	{ IWM_RX_TICKET_SNIFFER, "SNIFFER" },	\
+	{ IWM_RX_TICKET_ENQUEUE, "ENQUEUE" }
+
+TRACE_EVENT(iwm_rx_ticket,
+	TP_PROTO(struct iwm_priv *iwm, void *buf, int len),
+
+	TP_ARGS(iwm, buf, len),
+
+	TP_STRUCT__entry(
+		IWM_ENTRY
+		__field(u8, action)
+		__field(u8, reason)
+		__field(u16, id)
+		__field(u16, flags)
+	),
+
+	TP_fast_assign(
+		struct iwm_rx_ticket *ticket =
+			((struct iwm_umac_notif_rx_ticket *)buf)->tickets;
+
+		IWM_ASSIGN;
+		__entry->id = le16_to_cpu(ticket->id);
+		__entry->action = le16_to_cpu(ticket->action);
+		__entry->flags = le16_to_cpu(ticket->flags);
+		__entry->reason = (__entry->flags & IWM_RX_TICKET_DROP_REASON_MSK) >> IWM_RX_TICKET_DROP_REASON_POS;
+	),
+
+	TP_printk(
+		IWM_PR_FMT " Rx ticket: id 0x%x, action %s, %s 0x%x%s",
+		IWM_PR_ARG, __entry->id,
+		__print_symbolic(__entry->action, iwm_ticket_action_symbol),
+		__entry->reason ? "reason" : "flags",
+		__entry->reason ? __entry->reason : __entry->flags,
+		__entry->flags & IWM_RX_TICKET_AMSDU_MSK ? ", AMSDU frame" : ""
+	)
+);
+
+TRACE_EVENT(iwm_rx_packet,
+	TP_PROTO(struct iwm_priv *iwm, void *buf, int len),
+
+	TP_ARGS(iwm, buf, len),
+
+	TP_STRUCT__entry(
+		IWM_ENTRY
+		__field(u8, source)
+		__field(u16, id)
+		__field(u32, len)
+	),
+
+	TP_fast_assign(
+		struct iwm_umac_wifi_in_hdr *hdr = buf;
+
+		IWM_ASSIGN;
+		__entry->source = GET_VAL32(hdr->hw_hdr.cmd, UMAC_HDI_IN_CMD_SOURCE);
+		__entry->id = le16_to_cpu(hdr->sw_hdr.cmd.seq_num);
+		__entry->len = len - sizeof(*hdr);
+	),
+
+	TP_printk(
+		IWM_PR_FMT " Rx %s packet: id 0x%x, %d bytes",
+		IWM_PR_ARG, __entry->source == UMAC_HDI_IN_SOURCE_FHRX ?
+		"LMAC" : "UMAC", __entry->id, __entry->len
+	)
+);
+#endif
+
+#undef TRACE_INCLUDE_PATH
+#define TRACE_INCLUDE_PATH .
+#undef TRACE_INCLUDE_FILE
+#define TRACE_INCLUDE_FILE trace
+#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/iwmc3200wifi/tx.c b/drivers/net/wireless/iwmc3200wifi/tx.c
index 55905f0..406615c 100644
--- a/drivers/net/wireless/iwmc3200wifi/tx.c
+++ b/drivers/net/wireless/iwmc3200wifi/tx.c
@@ -346,6 +346,7 @@ static int iwm_tx_send_concat_packets(struct iwm_priv *iwm,
 	/* mark EOP for the last packet */
 	iwm_udma_wifi_hdr_set_eop(iwm, txq->concat_ptr, 1);
 
+	trace_iwm_tx_packets(iwm, txq->concat_buf, txq->concat_count);
 	ret = iwm_bus_send_chunk(iwm, txq->concat_buf, txq->concat_count);
 
 	txq->concat_count = 0;
-- 
1.6.0.4

