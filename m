Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:3965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549Ab1KRIUw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:20:52 -0500
Received: from int-mx12.intmail.prod.int.phx2.redhat.com (int-mx12.intmail.prod.int.phx2.redhat.com [10.5.11.25])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8KqmL025986
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:20:52 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 01/77] iwlegacy: remove tracing
Date: Fri, 18 Nov 2011 09:21:23 +0100
Message-Id: <1321604559-10707-1-git-send-email-sgruszka@redhat.com> (sfid-20111118_092056_781707_CB329899)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is not useful.

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/Kconfig        |   17 --
 drivers/net/wireless/iwlegacy/Makefile       |    3 -
 drivers/net/wireless/iwlegacy/iwl-4965-tx.c  |    6 -
 drivers/net/wireless/iwlegacy/iwl-devtrace.c |   42 -----
 drivers/net/wireless/iwlegacy/iwl-devtrace.h |  210 --------------------------
 drivers/net/wireless/iwlegacy/iwl-io.h       |    4 -
 drivers/net/wireless/iwlegacy/iwl-tx.c       |    3 -
 drivers/net/wireless/iwlegacy/iwl3945-base.c |    3 -
 drivers/net/wireless/iwlegacy/iwl4965-base.c |    5 -
 9 files changed, 0 insertions(+), 293 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.c
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-devtrace.h

diff --git a/drivers/net/wireless/iwlegacy/Kconfig b/drivers/net/wireless/iwlegacy/Kconfig
index aef65cd..2a1ae10 100644
--- a/drivers/net/wireless/iwlegacy/Kconfig
+++ b/drivers/net/wireless/iwlegacy/Kconfig
@@ -43,23 +43,6 @@ config IWLWIFI_LEGACY_DEBUGFS
 	  is a low-impact option that allows getting insight into the
 	  driver's state at runtime.
 
-config IWLWIFI_LEGACY_DEVICE_TRACING
-	bool "iwlwifilegacy legacy device access tracing"
-	depends on IWLWIFI_LEGACY
-	depends on EVENT_TRACING
-	help
-	  Say Y here to trace all commands, including TX frames and IO
-	  accesses, sent to the device. If you say yes, iwlwifilegacy will
-	  register with the ftrace framework for event tracing and dump
-	  all this information to the ringbuffer, you may need to
-	  increase the ringbuffer size. See the ftrace documentation
-	  for more information.
-
-	  When tracing is not enabled, this option still has some
-	  (though rather small) overhead.
-
-	  If unsure, say Y so we can help you better when problems
-	  occur.
 endmenu
 
 config IWL4965
diff --git a/drivers/net/wireless/iwlegacy/Makefile b/drivers/net/wireless/iwlegacy/Makefile
index d56aeb3..4f67e45 100644
--- a/drivers/net/wireless/iwlegacy/Makefile
+++ b/drivers/net/wireless/iwlegacy/Makefile
@@ -3,12 +3,9 @@ iwl-legacy-objs 		:= iwl-core.o iwl-eeprom.o iwl-hcmd.o iwl-power.o
 iwl-legacy-objs 		+= iwl-rx.o iwl-tx.o iwl-sta.o
 iwl-legacy-objs 		+= iwl-scan.o iwl-led.o
 iwl-legacy-$(CONFIG_IWLWIFI_LEGACY_DEBUGFS) += iwl-debugfs.o
-iwl-legacy-$(CONFIG_IWLWIFI_LEGACY_DEVICE_TRACING) += iwl-devtrace.o
 
 iwl-legacy-objs += $(iwl-legacy-m)
 
-CFLAGS_iwl-devtrace.o := -I$(src)
-
 # 4965
 obj-$(CONFIG_IWL4965)	+= iwl4965.o
 iwl4965-objs		:= iwl-4965.o iwl4965-base.o iwl-4965-rs.o iwl-4965-led.o
diff --git a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
index 7f12e36..e421fdf 100644
--- a/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-4965-tx.c
@@ -513,12 +513,6 @@ int iwl4965_tx_skb(struct iwl_priv *priv, struct sk_buff *skb)
 	pci_dma_sync_single_for_device(priv->pci_dev, txcmd_phys,
 				       firstlen, PCI_DMA_BIDIRECTIONAL);
 
-	trace_iwlwifi_legacy_dev_tx(priv,
-			     &((struct iwl_tfd *)txq->tfds)[txq->q.write_ptr],
-			     sizeof(struct iwl_tfd),
-			     &out_cmd->hdr, firstlen,
-			     skb->data + hdr_len, secondlen);
-
 	/* Tell device the write index *just past* this latest filled TFD */
 	q->write_ptr = iwl_legacy_queue_inc_wrap(q->write_ptr, q->n_bd);
 	iwl_legacy_txq_update_write_ptr(priv, txq);
diff --git a/drivers/net/wireless/iwlegacy/iwl-devtrace.c b/drivers/net/wireless/iwlegacy/iwl-devtrace.c
deleted file mode 100644
index acec991..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-devtrace.c
+++ /dev/null
@@ -1,42 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2009 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#include <linux/module.h>
-
-/* sparse doesn't like tracepoint macros */
-#ifndef __CHECKER__
-#include "iwl-dev.h"
-
-#define CREATE_TRACE_POINTS
-#include "iwl-devtrace.h"
-
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_iowrite8);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_ioread32);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_iowrite32);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_rx);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_tx);
-EXPORT_TRACEPOINT_SYMBOL(iwlwifi_legacy_dev_ucode_error);
-#endif
diff --git a/drivers/net/wireless/iwlegacy/iwl-devtrace.h b/drivers/net/wireless/iwlegacy/iwl-devtrace.h
deleted file mode 100644
index a443725..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-devtrace.h
+++ /dev/null
@@ -1,210 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2009 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify it
- * under the terms of version 2 of the GNU General Public License as
- * published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but WITHOUT
- * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
- * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
- * more details.
- *
- * You should have received a copy of the GNU General Public License along with
- * this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
- *
- * The full GNU General Public License is included in this distribution in the
- * file called LICENSE.
- *
- * Contact Information:
- *  Intel Linux Wireless <ilw@linux.intel.com>
- * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
- *
- *****************************************************************************/
-
-#if !defined(__IWLWIFI_LEGACY_DEVICE_TRACE) || defined(TRACE_HEADER_MULTI_READ)
-#define __IWLWIFI_LEGACY_DEVICE_TRACE
-
-#include <linux/tracepoint.h>
-
-#if !defined(CONFIG_IWLWIFI_LEGACY_DEVICE_TRACING) || defined(__CHECKER__)
-#undef TRACE_EVENT
-#define TRACE_EVENT(name, proto, ...) \
-static inline void trace_ ## name(proto) {}
-#endif
-
-
-#define PRIV_ENTRY	__field(struct iwl_priv *, priv)
-#define PRIV_ASSIGN	(__entry->priv = priv)
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM iwlwifi_legacy_io
-
-TRACE_EVENT(iwlwifi_legacy_dev_ioread32,
-	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
-	TP_ARGS(priv, offs, val),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-		__field(u32, offs)
-		__field(u32, val)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->offs = offs;
-		__entry->val = val;
-	),
-	TP_printk("[%p] read io[%#x] = %#x", __entry->priv,
-					__entry->offs, __entry->val)
-);
-
-TRACE_EVENT(iwlwifi_legacy_dev_iowrite8,
-	TP_PROTO(struct iwl_priv *priv, u32 offs, u8 val),
-	TP_ARGS(priv, offs, val),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-		__field(u32, offs)
-		__field(u8, val)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->offs = offs;
-		__entry->val = val;
-	),
-	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv,
-					__entry->offs, __entry->val)
-);
-
-TRACE_EVENT(iwlwifi_legacy_dev_iowrite32,
-	TP_PROTO(struct iwl_priv *priv, u32 offs, u32 val),
-	TP_ARGS(priv, offs, val),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-		__field(u32, offs)
-		__field(u32, val)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->offs = offs;
-		__entry->val = val;
-	),
-	TP_printk("[%p] write io[%#x] = %#x)", __entry->priv,
-					__entry->offs, __entry->val)
-);
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM iwlwifi_legacy_ucode
-
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM iwlwifi
-
-TRACE_EVENT(iwlwifi_legacy_dev_hcmd,
-	TP_PROTO(struct iwl_priv *priv, void *hcmd, size_t len, u32 flags),
-	TP_ARGS(priv, hcmd, len, flags),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-		__dynamic_array(u8, hcmd, len)
-		__field(u32, flags)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		memcpy(__get_dynamic_array(hcmd), hcmd, len);
-		__entry->flags = flags;
-	),
-	TP_printk("[%p] hcmd %#.2x (%ssync)",
-		  __entry->priv, ((u8 *)__get_dynamic_array(hcmd))[0],
-		  __entry->flags & CMD_ASYNC ? "a" : "")
-);
-
-TRACE_EVENT(iwlwifi_legacy_dev_rx,
-	TP_PROTO(struct iwl_priv *priv, void *rxbuf, size_t len),
-	TP_ARGS(priv, rxbuf, len),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-		__dynamic_array(u8, rxbuf, len)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		memcpy(__get_dynamic_array(rxbuf), rxbuf, len);
-	),
-	TP_printk("[%p] RX cmd %#.2x",
-		  __entry->priv, ((u8 *)__get_dynamic_array(rxbuf))[4])
-);
-
-TRACE_EVENT(iwlwifi_legacy_dev_tx,
-	TP_PROTO(struct iwl_priv *priv, void *tfd, size_t tfdlen,
-		 void *buf0, size_t buf0_len,
-		 void *buf1, size_t buf1_len),
-	TP_ARGS(priv, tfd, tfdlen, buf0, buf0_len, buf1, buf1_len),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-
-		__field(size_t, framelen)
-		__dynamic_array(u8, tfd, tfdlen)
-
-		/*
-		 * Do not insert between or below these items,
-		 * we want to keep the frame together (except
-		 * for the possible padding).
-		 */
-		__dynamic_array(u8, buf0, buf0_len)
-		__dynamic_array(u8, buf1, buf1_len)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->framelen = buf0_len + buf1_len;
-		memcpy(__get_dynamic_array(tfd), tfd, tfdlen);
-		memcpy(__get_dynamic_array(buf0), buf0, buf0_len);
-		memcpy(__get_dynamic_array(buf1), buf1, buf1_len);
-	),
-	TP_printk("[%p] TX %.2x (%zu bytes)",
-		  __entry->priv,
-		  ((u8 *)__get_dynamic_array(buf0))[0],
-		  __entry->framelen)
-);
-
-TRACE_EVENT(iwlwifi_legacy_dev_ucode_error,
-	TP_PROTO(struct iwl_priv *priv, u32 desc, u32 time,
-		 u32 data1, u32 data2, u32 line, u32 blink1,
-		 u32 blink2, u32 ilink1, u32 ilink2),
-	TP_ARGS(priv, desc, time, data1, data2, line,
-		blink1, blink2, ilink1, ilink2),
-	TP_STRUCT__entry(
-		PRIV_ENTRY
-		__field(u32, desc)
-		__field(u32, time)
-		__field(u32, data1)
-		__field(u32, data2)
-		__field(u32, line)
-		__field(u32, blink1)
-		__field(u32, blink2)
-		__field(u32, ilink1)
-		__field(u32, ilink2)
-	),
-	TP_fast_assign(
-		PRIV_ASSIGN;
-		__entry->desc = desc;
-		__entry->time = time;
-		__entry->data1 = data1;
-		__entry->data2 = data2;
-		__entry->line = line;
-		__entry->blink1 = blink1;
-		__entry->blink2 = blink2;
-		__entry->ilink1 = ilink1;
-		__entry->ilink2 = ilink2;
-	),
-	TP_printk("[%p] #%02d %010u data 0x%08X 0x%08X line %u, "
-		  "blink 0x%05X 0x%05X ilink 0x%05X 0x%05X",
-		  __entry->priv, __entry->desc, __entry->time, __entry->data1,
-		  __entry->data2, __entry->line, __entry->blink1,
-		  __entry->blink2, __entry->ilink1, __entry->ilink2)
-);
-
-#endif /* __IWLWIFI_DEVICE_TRACE */
-
-#undef TRACE_INCLUDE_PATH
-#define TRACE_INCLUDE_PATH .
-#undef TRACE_INCLUDE_FILE
-#define TRACE_INCLUDE_FILE iwl-devtrace
-#include <trace/define_trace.h>
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
index 5cc5d34..868ef01 100644
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ b/drivers/net/wireless/iwlegacy/iwl-io.h
@@ -33,7 +33,6 @@
 
 #include "iwl-dev.h"
 #include "iwl-debug.h"
-#include "iwl-devtrace.h"
 
 /*
  * IO, register, and NIC memory access functions
@@ -65,7 +64,6 @@
 
 static inline void _iwl_legacy_write8(struct iwl_priv *priv, u32 ofs, u8 val)
 {
-	trace_iwlwifi_legacy_dev_iowrite8(priv, ofs, val);
 	iowrite8(val, priv->hw_base + ofs);
 }
 
@@ -86,7 +84,6 @@ __iwl_legacy_write8(const char *f, u32 l, struct iwl_priv *priv,
 
 static inline void _iwl_legacy_write32(struct iwl_priv *priv, u32 ofs, u32 val)
 {
-	trace_iwlwifi_legacy_dev_iowrite32(priv, ofs, val);
 	iowrite32(val, priv->hw_base + ofs);
 }
 
@@ -107,7 +104,6 @@ __iwl_legacy_write32(const char *f, u32 l, struct iwl_priv *priv,
 static inline u32 _iwl_legacy_read32(struct iwl_priv *priv, u32 ofs)
 {
 	u32 val = ioread32(priv->hw_base + ofs);
-	trace_iwlwifi_legacy_dev_ioread32(priv, ofs, val);
 	return val;
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-tx.c b/drivers/net/wireless/iwlegacy/iwl-tx.c
index ef9e268..e1a559b 100644
--- a/drivers/net/wireless/iwlegacy/iwl-tx.c
+++ b/drivers/net/wireless/iwlegacy/iwl-tx.c
@@ -539,9 +539,6 @@ int iwl_legacy_enqueue_hcmd(struct iwl_priv *priv, struct iwl_host_cmd *cmd)
 	dma_unmap_addr_set(out_meta, mapping, phys_addr);
 	dma_unmap_len_set(out_meta, len, fix_size);
 
-	trace_iwlwifi_legacy_dev_hcmd(priv, &out_cmd->hdr,
-						fix_size, cmd->flags);
-
 	priv->cfg->ops->lib->txq_attach_buf_to_tfd(priv, txq,
 						   phys_addr, fix_size, 1,
 						   U32_PAD(cmd->len));
diff --git a/drivers/net/wireless/iwlegacy/iwl3945-base.c b/drivers/net/wireless/iwlegacy/iwl3945-base.c
index b282d86..7507819 100644
--- a/drivers/net/wireless/iwlegacy/iwl3945-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl3945-base.c
@@ -1246,7 +1246,6 @@ static void iwl3945_rx_handle(struct iwl_priv *priv)
 
 		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
-		trace_iwlwifi_legacy_dev_rx(priv, pkt, len);
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
@@ -1403,8 +1402,6 @@ void iwl3945_dump_nic_error_log(struct iwl_priv *priv)
 			"%-13s (0x%X) %010u 0x%05X 0x%05X 0x%05X 0x%05X %u\n\n",
 			iwl3945_desc_lookup(desc), desc, time, blink1, blink2,
 			ilink1, ilink2, data1);
-		trace_iwlwifi_legacy_dev_ucode_error(priv, desc, time, data1, 0,
-					0, blink1, blink2, ilink1, ilink2);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
index d2fba9e..fd2f7a4 100644
--- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
+++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
@@ -679,7 +679,6 @@ void iwl4965_rx_handle(struct iwl_priv *priv)
 
 		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
-		trace_iwlwifi_legacy_dev_rx(priv, pkt, len);
 
 		/* Reclaim a command buffer only if this packet is a response
 		 *   to a (driver-originated) command.
@@ -1569,10 +1568,6 @@ void iwl4965_dump_nic_error_log(struct iwl_priv *priv)
 	time = iwl_legacy_read_targ_mem(priv, base + 11 * sizeof(u32));
 	hcmd = iwl_legacy_read_targ_mem(priv, base + 22 * sizeof(u32));
 
-	trace_iwlwifi_legacy_dev_ucode_error(priv, desc,
-					time, data1, data2, line,
-				      blink1, blink2, ilink1, ilink2);
-
 	IWL_ERR(priv, "Desc                                  Time       "
 		"data1      data2      line\n");
 	IWL_ERR(priv, "%-28s (0x%04X) %010u 0x%08X 0x%08X %u\n",
-- 
1.7.1

