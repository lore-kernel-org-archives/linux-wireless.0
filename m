Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24652 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756792Ab1KRIWt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 03:22:49 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id pAI8Mn2B022822
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2011 03:22:49 -0500
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: linux-wireless@vger.kernel.org
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Subject: [PATCH 55/77] iwlegacy: merge common header files
Date: Fri, 18 Nov 2011 09:22:17 +0100
Message-Id: <1321604559-10707-55-git-send-email-sgruszka@redhat.com> (sfid-20111118_092259_021009_81A63270)
In-Reply-To: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
References: <1321604559-10707-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
---
 drivers/net/wireless/iwlegacy/3945-debug.c  |    1 -
 drivers/net/wireless/iwlegacy/3945-mac.c    |    7 +-
 drivers/net/wireless/iwlegacy/3945-rs.c     |    1 -
 drivers/net/wireless/iwlegacy/3945.c        |    6 +-
 drivers/net/wireless/iwlegacy/3945.h        |    9 +-
 drivers/net/wireless/iwlegacy/4965-calib.c  |    1 -
 drivers/net/wireless/iwlegacy/4965-debug.c  |    1 -
 drivers/net/wireless/iwlegacy/4965-mac.c    |    8 +-
 drivers/net/wireless/iwlegacy/4965-rs.c     |    2 -
 drivers/net/wireless/iwlegacy/4965.c        |    6 +-
 drivers/net/wireless/iwlegacy/commands.h    |    2 +
 drivers/net/wireless/iwlegacy/common.c      |    6 +-
 drivers/net/wireless/iwlegacy/common.h      | 2044 ++++++++++++++++++++++++++-
 drivers/net/wireless/iwlegacy/iwl-debugfs.c |    2 -
 drivers/net/wireless/iwlegacy/iwl-dev.h     | 1351 ------------------
 drivers/net/wireless/iwlegacy/iwl-fh.h      |   96 --
 drivers/net/wireless/iwlegacy/iwl-io.h      |  337 -----
 drivers/net/wireless/iwlegacy/iwl-sta.h     |  146 --
 18 files changed, 2003 insertions(+), 2023 deletions(-)
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-dev.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-io.h
 delete mode 100644 drivers/net/wireless/iwlegacy/iwl-sta.h

diff --git a/drivers/net/wireless/iwlegacy/3945-debug.c b/drivers/net/wireless/iwlegacy/3945-debug.c
index b73b425..1a690a0 100644
--- a/drivers/net/wireless/iwlegacy/3945-debug.c
+++ b/drivers/net/wireless/iwlegacy/3945-debug.c
@@ -26,7 +26,6 @@
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *****************************************************************************/
 
-#include "iwl-dev.h"
 #include "common.h"
 #include "3945.h"
 
diff --git a/drivers/net/wireless/iwlegacy/3945-mac.c b/drivers/net/wireless/iwlegacy/3945-mac.c
index b650292..3c89999 100644
--- a/drivers/net/wireless/iwlegacy/3945-mac.c
+++ b/drivers/net/wireless/iwlegacy/3945-mac.c
@@ -52,11 +52,8 @@
 #define DRV_NAME	"iwl3945"
 
 #include "commands.h"
-#include "iwl-sta.h"
-#include "3945.h"
 #include "common.h"
-#include "iwl-helpers.h"
-#include "iwl-dev.h"
+#include "3945.h"
 #include "iwl-spectrum.h"
 
 /*
@@ -1242,7 +1239,7 @@ static void il3945_rx_handle(struct il_priv *il)
 			       PCI_DMA_FROMDEVICE);
 		pkt = rxb_addr(rxb);
 
-		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
 
 		/* Reclaim a command buffer only if this packet is a response
diff --git a/drivers/net/wireless/iwlegacy/3945-rs.c b/drivers/net/wireless/iwlegacy/3945-rs.c
index 4aa0432..dc0dfdd 100644
--- a/drivers/net/wireless/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/iwlegacy/3945-rs.c
@@ -38,7 +38,6 @@
 
 #include "commands.h"
 #include "3945.h"
-#include "iwl-sta.h"
 
 #define RS_NAME "iwl-3945-rs"
 
diff --git a/drivers/net/wireless/iwlegacy/3945.c b/drivers/net/wireless/iwlegacy/3945.c
index 795d206..02ae32c 100644
--- a/drivers/net/wireless/iwlegacy/3945.c
+++ b/drivers/net/wireless/iwlegacy/3945.c
@@ -39,11 +39,9 @@
 #include <asm/unaligned.h>
 #include <net/mac80211.h>
 
+#include "common.h"
 #include "commands.h"
-#include "iwl-sta.h"
 #include "iwl-eeprom.h"
-#include "common.h"
-#include "iwl-helpers.h"
 #include "iwl-led.h"
 #include "3945.h"
 
@@ -417,7 +415,7 @@ void il3945_hdl_stats(struct il_priv *il,
 
 	D_RX("Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct il3945_notif_stats),
-		     le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK);
+		     le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK);
 #ifdef CONFIG_IWLEGACY_DEBUGFS
 	il3945_accumulative_stats(il, (__le32 *)&pkt->u.raw);
 #endif
diff --git a/drivers/net/wireless/iwlegacy/3945.h b/drivers/net/wireless/iwlegacy/3945.h
index e89ca5d..726ca2c 100644
--- a/drivers/net/wireless/iwlegacy/3945.h
+++ b/drivers/net/wireless/iwlegacy/3945.h
@@ -34,10 +34,10 @@
 /* Hardware specific file defines the PCI IDs table for that hardware module */
 extern const struct pci_device_id il3945_hw_card_ids[];
 
+#include "common.h"
 #include "iwl-prph.h"
 #include "iwl-debug.h"
 #include "iwl-power.h"
-#include "iwl-dev.h"
 #include "iwl-led.h"
 #include "iwl-eeprom.h"
 
@@ -455,10 +455,6 @@ struct il3945_eeprom {
 #define RFD_SIZE                              4
 #define NUM_TFD_CHUNKS                        4
 
-#define RX_QUEUE_SIZE                         256
-#define RX_QUEUE_MASK                         255
-#define RX_QUEUE_SIZE_LOG                     8
-
 #define TFD_CTL_COUNT_SET(n)       (n << 24)
 #define TFD_CTL_COUNT_GET(ctl)     ((ctl >> 24) & 7)
 #define TFD_CTL_PAD_SET(n)         (n << 28)
@@ -659,7 +655,4 @@ static ssize_t il3945_ucode_general_stats_read(struct file *file,
 }
 #endif
 
-/* Requires full declaration of il_priv before including */
-#include "iwl-io.h"
-
 #endif
diff --git a/drivers/net/wireless/iwlegacy/4965-calib.c b/drivers/net/wireless/iwlegacy/4965-calib.c
index 1e47798..405032a 100644
--- a/drivers/net/wireless/iwlegacy/4965-calib.c
+++ b/drivers/net/wireless/iwlegacy/4965-calib.c
@@ -63,7 +63,6 @@
 #include <linux/slab.h>
 #include <net/mac80211.h>
 
-#include "iwl-dev.h"
 #include "common.h"
 #include "4965.h"
 
diff --git a/drivers/net/wireless/iwlegacy/4965-debug.c b/drivers/net/wireless/iwlegacy/4965-debug.c
index 1056d3e..5f89031 100644
--- a/drivers/net/wireless/iwlegacy/4965-debug.c
+++ b/drivers/net/wireless/iwlegacy/4965-debug.c
@@ -25,7 +25,6 @@
 *  Intel Linux Wireless <ilw@linux.intel.com>
 * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
 *****************************************************************************/
-#include "iwl-dev.h"
 #include "common.h"
 #include "4965.h"
 
diff --git a/drivers/net/wireless/iwlegacy/4965-mac.c b/drivers/net/wireless/iwlegacy/4965-mac.c
index 2f747e4..6848b91 100644
--- a/drivers/net/wireless/iwlegacy/4965-mac.c
+++ b/drivers/net/wireless/iwlegacy/4965-mac.c
@@ -51,11 +51,7 @@
 #define DRV_NAME        "iwl4965"
 
 #include "iwl-eeprom.h"
-#include "iwl-dev.h"
 #include "common.h"
-#include "iwl-io.h"
-#include "iwl-helpers.h"
-#include "iwl-sta.h"
 #include "4965.h"
 
 
@@ -1362,7 +1358,7 @@ void il4965_hdl_stats(struct il_priv *il,
 		     "Statistics notification received (%d vs %d).\n",
 		     (int)sizeof(struct il_notif_stats),
 		     le32_to_cpu(pkt->len_n_flags) &
-		     FH_RSCSR_FRAME_SIZE_MSK);
+		     IL_RX_FRAME_SIZE_MSK);
 
 	change = ((il->_4965.stats.general.common.temperature !=
 		   pkt->u.stats.general.common.temperature) ||
@@ -4009,7 +4005,7 @@ void il4965_rx_handle(struct il_priv *il)
 			       PCI_DMA_FROMDEVICE);
 		pkt = rxb_addr(rxb);
 
-		len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+		len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 		len += sizeof(u32); /* account for status word */
 
 		/* Reclaim a command buffer only if this packet is a response
diff --git a/drivers/net/wireless/iwlegacy/4965-rs.c b/drivers/net/wireless/iwlegacy/4965-rs.c
index 06f5beb..f9db9df 100644
--- a/drivers/net/wireless/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/iwlegacy/4965-rs.c
@@ -35,8 +35,6 @@
 
 #include <linux/workqueue.h>
 
-#include "iwl-dev.h"
-#include "iwl-sta.h"
 #include "common.h"
 #include "4965.h"
 
diff --git a/drivers/net/wireless/iwlegacy/4965.c b/drivers/net/wireless/iwlegacy/4965.c
index 7febcf3..d66d4e8 100644
--- a/drivers/net/wireless/iwlegacy/4965.c
+++ b/drivers/net/wireless/iwlegacy/4965.c
@@ -37,12 +37,8 @@
 #include <linux/etherdevice.h>
 #include <asm/unaligned.h>
 
-#include "iwl-eeprom.h"
-#include "iwl-dev.h"
 #include "common.h"
-#include "iwl-io.h"
-#include "iwl-helpers.h"
-#include "iwl-sta.h"
+#include "iwl-eeprom.h"
 #include "4965.h"
 
 #define IL_AC_UNSET -1
diff --git a/drivers/net/wireless/iwlegacy/commands.h b/drivers/net/wireless/iwlegacy/commands.h
index 82cf472..2f64ed3 100644
--- a/drivers/net/wireless/iwlegacy/commands.h
+++ b/drivers/net/wireless/iwlegacy/commands.h
@@ -3355,6 +3355,8 @@ struct il_led_cmd {
  *
  *****************************************************************************/
 
+#define IL_RX_FRAME_SIZE_MSK	0x00003fff
+
 struct il_rx_pkt {
 	/*
 	 * The first 4 bytes of the RX frame header contain both the RX frame
diff --git a/drivers/net/wireless/iwlegacy/common.c b/drivers/net/wireless/iwlegacy/common.c
index d99ed75..4258bf6 100644
--- a/drivers/net/wireless/iwlegacy/common.c
+++ b/drivers/net/wireless/iwlegacy/common.c
@@ -41,13 +41,9 @@
 #include <net/mac80211.h>
 
 #include "iwl-eeprom.h"
-#include "iwl-dev.h"
 #include "iwl-debug.h"
 #include "common.h"
-#include "iwl-io.h"
 #include "iwl-power.h"
-#include "iwl-sta.h"
-#include "iwl-helpers.h"
 
 const char *il_get_cmd_string(u8 cmd)
 {
@@ -4351,7 +4347,7 @@ void il_hdl_pm_debug_stats(struct il_priv *il,
 				      struct il_rx_buf *rxb)
 {
 	struct il_rx_pkt *pkt = rxb_addr(rxb);
-	u32 len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
+	u32 len = le32_to_cpu(pkt->len_n_flags) & IL_RX_FRAME_SIZE_MSK;
 	D_RADIO("Dumping %d bytes of unhandled "
 			"notification for %s:\n", len,
 			il_get_cmd_string(pkt->hdr.cmd));
diff --git a/drivers/net/wireless/iwlegacy/common.h b/drivers/net/wireless/iwlegacy/common.h
index 5de742c..e83c6ab 100644
--- a/drivers/net/wireless/iwlegacy/common.h
+++ b/drivers/net/wireless/iwlegacy/common.h
@@ -1,74 +1,1358 @@
 /******************************************************************************
  *
- * This file is provided under a dual BSD/GPLv2 license.  When using or
- * redistributing this file, you may do so under either license.
+ * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
  *
- * GPL LICENSE SUMMARY
- *
- * Copyright(c) 2008 - 2011 Intel Corporation. All rights reserved.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of version 2 of the GNU General Public License as
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of version 2 of the GNU General Public License as
  * published by the Free Software Foundation.
  *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
+ * This program is distributed in the hope that it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110,
- * USA
+ * You should have received a copy of the GNU General Public License along with
+ * this program; if not, write to the Free Software Foundation, Inc.,
+ * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
  *
- * The full GNU General Public License is included in this distribution
- * in the file called LICENSE.GPL.
+ * The full GNU General Public License is included in this distribution in the
+ * file called LICENSE.
  *
  * Contact Information:
  *  Intel Linux Wireless <ilw@linux.intel.com>
  * Intel Corporation, 5200 N.E. Elam Young Parkway, Hillsboro, OR 97124-6497
  *
- * BSD LICENSE
- *
- * Copyright(c) 2005 - 2011 Intel Corporation. All rights reserved.
- * All rights reserved.
- *
- * Redistribution and use in source and binary forms, with or without
- * modification, are permitted provided that the following conditions
- * are met:
- *
- *  * Redistributions of source code must retain the above copyright
- *    notice, this list of conditions and the following disclaimer.
- *  * Redistributions in binary form must reproduce the above copyright
- *    notice, this list of conditions and the following disclaimer in
- *    the documentation and/or other materials provided with the
- *    distribution.
- *  * Neither the name Intel Corporation nor the names of its
- *    contributors may be used to endorse or promote products derived
- *    from this software without specific prior written permission.
- *
- * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
- * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
- * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
- * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
- * OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
- * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
- * LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
- * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
- * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
- * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
- * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *****************************************************************************/
-
 #ifndef __il_core_h__
 #define __il_core_h__
 
-/************************
- * forward declarations *
- ************************/
+#include <linux/interrupt.h>
+#include <linux/pci.h> /* for struct pci_device_id */
+#include <linux/kernel.h>
+#include <linux/leds.h>
+#include <linux/wait.h>
+#include <net/ieee80211_radiotap.h>
+
+#include "iwl-eeprom.h"
+#include "csr.h"
+#include "iwl-prph.h"
+#include "iwl-debug.h"
+#include "iwl-led.h"
+#include "iwl-power.h"
+#include "iwl-legacy-rs.h"
+
 struct il_host_cmd;
 struct il_cmd;
+struct il_tx_queue;
+
+#define RX_QUEUE_SIZE                         256
+#define RX_QUEUE_MASK                         255
+#define RX_QUEUE_SIZE_LOG                     8
+
+/*
+ * RX related structures and functions
+ */
+#define RX_FREE_BUFFERS 64
+#define RX_LOW_WATERMARK 8
+
+#define U32_PAD(n)		((4-(n))&0x3)
+
+/* CT-KILL constants */
+#define CT_KILL_THRESHOLD_LEGACY   110 /* in Celsius */
+
+/* Default noise level to report when noise measurement is not available.
+ *   This may be because we're:
+ *   1)  Not associated (4965, no beacon stats being sent to driver)
+ *   2)  Scanning (noise measurement does not apply to associated channel)
+ *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
+ * Use default noise value of -127 ... this is below the range of measurable
+ *   Rx dBm for either 3945 or 4965, so it can indicate "unmeasurable" to user.
+ *   Also, -127 works better than 0 when averaging frames with/without
+ *   noise info (e.g. averaging might be done in app); measured dBm values are
+ *   always negative ... using a negative value as the default keeps all
+ *   averages within an s8's (used in some apps) range of negative values. */
+#define IL_NOISE_MEAS_NOT_AVAILABLE (-127)
+
+/*
+ * RTS threshold here is total size [2347] minus 4 FCS bytes
+ * Per spec:
+ *   a value of 0 means RTS on all data/management packets
+ *   a value > max MSDU size means no RTS
+ * else RTS for data/management frames where MPDU is larger
+ *   than RTS value.
+ */
+#define DEFAULT_RTS_THRESHOLD     2347U
+#define MIN_RTS_THRESHOLD         0U
+#define MAX_RTS_THRESHOLD         2347U
+#define MAX_MSDU_SIZE		  2304U
+#define MAX_MPDU_SIZE		  2346U
+#define DEFAULT_BEACON_INTERVAL   100U
+#define	DEFAULT_SHORT_RETRY_LIMIT 7U
+#define	DEFAULT_LONG_RETRY_LIMIT  4U
+
+struct il_rx_buf {
+	dma_addr_t page_dma;
+	struct page *page;
+	struct list_head list;
+};
+
+#define rxb_addr(r) page_address(r->page)
+
+/* defined below */
+struct il_device_cmd;
+
+struct il_cmd_meta {
+	/* only for SYNC commands, iff the reply skb is wanted */
+	struct il_host_cmd *source;
+	/*
+	 * only for ASYNC commands
+	 * (which is somewhat stupid -- look at common.c for instance
+	 * which duplicates a bunch of code because the callback isn't
+	 * invoked for SYNC commands, if it were and its result passed
+	 * through it would be simpler...)
+	 */
+	void (*callback)(struct il_priv *il,
+			 struct il_device_cmd *cmd,
+			 struct il_rx_pkt *pkt);
+
+	/* The CMD_SIZE_HUGE flag bit indicates that the command
+	 * structure is stored at the end of the shared queue memory. */
+	u32 flags;
+
+	DEFINE_DMA_UNMAP_ADDR(mapping);
+	DEFINE_DMA_UNMAP_LEN(len);
+};
+
+/*
+ * Generic queue structure
+ *
+ * Contains common data for Rx and Tx queues
+ */
+struct il_queue {
+	int n_bd;              /* number of BDs in this queue */
+	int write_ptr;       /* 1-st empty entry (idx) host_w*/
+	int read_ptr;         /* last used entry (idx) host_r*/
+	/* use for monitoring and recovering the stuck queue */
+	dma_addr_t dma_addr;   /* physical addr for BD's */
+	int n_win;	       /* safe queue win */
+	u32 id;
+	int low_mark;	       /* low watermark, resume queue if free
+				* space more than this */
+	int high_mark;         /* high watermark, stop queue if free
+				* space less than this */
+};
+
+/* One for each TFD */
+struct il_tx_info {
+	struct sk_buff *skb;
+	struct il_rxon_context *ctx;
+};
+
+/**
+ * struct il_tx_queue - Tx Queue for DMA
+ * @q: generic Rx/Tx queue descriptor
+ * @bd: base of circular buffer of TFDs
+ * @cmd: array of command/TX buffer pointers
+ * @meta: array of meta data for each command/tx buffer
+ * @dma_addr_cmd: physical address of cmd/tx buffer array
+ * @txb: array of per-TFD driver data
+ * @time_stamp: time (in jiffies) of last read_ptr change
+ * @need_update: indicates need to update read/write idx
+ * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
+ *
+ * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
+ * descriptors) and required locking structures.
+ */
+#define TFD_TX_CMD_SLOTS 256
+#define TFD_CMD_SLOTS 32
+
+struct il_tx_queue {
+	struct il_queue q;
+	void *tfds;
+	struct il_device_cmd **cmd;
+	struct il_cmd_meta *meta;
+	struct il_tx_info *txb;
+	unsigned long time_stamp;
+	u8 need_update;
+	u8 sched_retry;
+	u8 active;
+	u8 swq_id;
+};
+
+#define IL_NUM_SCAN_RATES         (2)
+
+struct il4965_channel_tgd_info {
+	u8 type;
+	s8 max_power;
+};
+
+struct il4965_channel_tgh_info {
+	s64 last_radar_time;
+};
+
+#define IL4965_MAX_RATE (33)
+
+struct il3945_clip_group {
+	/* maximum power level to prevent clipping for each rate, derived by
+	 *   us from this band's saturation power in EEPROM */
+	const s8 clip_powers[IL_MAX_RATES];
+};
+
+/* current Tx power values to use, one for each rate for each channel.
+ * requested power is limited by:
+ * -- regulatory EEPROM limits for this channel
+ * -- hardware capabilities (clip-powers)
+ * -- spectrum management
+ * -- user preference (e.g. iwconfig)
+ * when requested power is set, base power idx must also be set. */
+struct il3945_channel_power_info {
+	struct il3945_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_idx;	/* actual (compenst'd) idx into gain table */
+	s8 base_power_idx;	/* gain idx for power at factory temp. */
+	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
+};
+
+/* current scan Tx power values to use, one for each scan rate for each
+ * channel. */
+struct il3945_scan_power_info {
+	struct il3945_tx_power tpc;	/* actual radio and DSP gain settings */
+	s8 power_table_idx;	/* actual (compenst'd) idx into gain table */
+	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
+};
+
+/*
+ * One for each channel, holds all channel setup data
+ * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
+ *     with one another!
+ */
+struct il_channel_info {
+	struct il4965_channel_tgd_info tgd;
+	struct il4965_channel_tgh_info tgh;
+	struct il_eeprom_channel eeprom;	/* EEPROM regulatory limit */
+	struct il_eeprom_channel ht40_eeprom;	/* EEPROM regulatory limit for
+						 * HT40 channel */
+
+	u8 channel;	  /* channel number */
+	u8 flags;	  /* flags copied from EEPROM */
+	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
+	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) limit */
+	s8 min_power;	  /* always 0 */
+	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
+
+	u8 group_idx;	  /* 0-4, maps channel to group1/2/3/4/5 */
+	u8 band_idx;	  /* 0-4, maps channel to band1/2/3/4/5 */
+	enum ieee80211_band band;
+
+	/* HT40 channel info */
+	s8 ht40_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
+	u8 ht40_flags;		/* flags copied from EEPROM */
+	u8 ht40_extension_channel; /* HT_IE_EXT_CHANNEL_* */
+
+	/* Radio/DSP gain settings for each "normal" data Tx rate.
+	 * These include, in addition to RF and DSP gain, a few fields for
+	 *   remembering/modifying gain settings (idxes). */
+	struct il3945_channel_power_info power_info[IL4965_MAX_RATE];
+
+	/* Radio/DSP gain settings for each scan rate, for directed scans. */
+	struct il3945_scan_power_info scan_pwr_info[IL_NUM_SCAN_RATES];
+};
+
+#define IL_TX_FIFO_BK		0	/* shared */
+#define IL_TX_FIFO_BE		1
+#define IL_TX_FIFO_VI		2	/* shared */
+#define IL_TX_FIFO_VO		3
+#define IL_TX_FIFO_UNUSED	-1
+
+/* Minimum number of queues. MAX_NUM is defined in hw specific files.
+ * Set the minimum to accommodate the 4 standard TX queues, 1 command
+ * queue, 2 (unused) HCCA queues, and 4 HT queues (one for each AC) */
+#define IL_MIN_NUM_QUEUES	10
+
+#define IL_DEFAULT_CMD_QUEUE_NUM	4
+
+#define IEEE80211_DATA_LEN              2304
+#define IEEE80211_4ADDR_LEN             30
+#define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
+#define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
+
+struct il_frame {
+	union {
+		struct ieee80211_hdr frame;
+		struct il_tx_beacon_cmd beacon;
+		u8 raw[IEEE80211_FRAME_LEN];
+		u8 cmd[360];
+	} u;
+	struct list_head list;
+};
+
+#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
+#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
+#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
+
+enum {
+	CMD_SYNC = 0,
+	CMD_SIZE_NORMAL = 0,
+	CMD_NO_SKB = 0,
+	CMD_SIZE_HUGE = (1 << 0),
+	CMD_ASYNC = (1 << 1),
+	CMD_WANT_SKB = (1 << 2),
+	CMD_MAPPED = (1 << 3),
+};
+
+#define DEF_CMD_PAYLOAD_SIZE 320
+
+/**
+ * struct il_device_cmd
+ *
+ * For allocation of the command and tx queues, this establishes the overall
+ * size of the largest command we send to uCode, except for a scan command
+ * (which is relatively huge; space is allocated separately).
+ */
+struct il_device_cmd {
+	struct il_cmd_header hdr;	/* uCode API */
+	union {
+		u32 flags;
+		u8 val8;
+		u16 val16;
+		u32 val32;
+		struct il_tx_cmd tx;
+		u8 payload[DEF_CMD_PAYLOAD_SIZE];
+	} __packed cmd;
+} __packed;
+
+#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct il_device_cmd))
+
+
+struct il_host_cmd {
+	const void *data;
+	unsigned long reply_page;
+	void (*callback)(struct il_priv *il,
+			 struct il_device_cmd *cmd,
+			 struct il_rx_pkt *pkt);
+	u32 flags;
+	u16 len;
+	u8 id;
+};
+
+#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
+#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
+#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
+
+/**
+ * struct il_rx_queue - Rx queue
+ * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
+ * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
+ * @read: Shared idx to newest available Rx buffer
+ * @write: Shared idx to oldest written Rx packet
+ * @free_count: Number of pre-allocated buffers in rx_free
+ * @rx_free: list of free SKBs for use
+ * @rx_used: List of Rx buffers with no SKB
+ * @need_update: flag to indicate we need to update read/write idx
+ * @rb_stts: driver's pointer to receive buffer status
+ * @rb_stts_dma: bus address of receive buffer status
+ *
+ * NOTE:  rx_free and rx_used are used as a FIFO for il_rx_bufs
+ */
+struct il_rx_queue {
+	__le32 *bd;
+	dma_addr_t bd_dma;
+	struct il_rx_buf pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
+	struct il_rx_buf *queue[RX_QUEUE_SIZE];
+	u32 read;
+	u32 write;
+	u32 free_count;
+	u32 write_actual;
+	struct list_head rx_free;
+	struct list_head rx_used;
+	int need_update;
+	struct il_rb_status *rb_stts;
+	dma_addr_t rb_stts_dma;
+	spinlock_t lock;
+};
+
+#define IL_SUPPORTED_RATES_IE_LEN         8
+
+#define MAX_TID_COUNT        9
+
+#define IL_INVALID_RATE     0xFF
+#define IL_INVALID_VALUE    -1
+
+/**
+ * struct il_ht_agg -- aggregation status while waiting for block-ack
+ * @txq_id: Tx queue used for Tx attempt
+ * @frame_count: # frames attempted by Tx command
+ * @wait_for_ba: Expect block-ack before next Tx reply
+ * @start_idx: Index of 1st Transmit Frame Descriptor (TFD) in Tx win
+ * @bitmap0: Low order bitmap, one bit for each frame pending ACK in Tx win
+ * @bitmap1: High order, one bit for each frame pending ACK in Tx win
+ * @rate_n_flags: Rate at which Tx was attempted
+ *
+ * If C_TX indicates that aggregation was attempted, driver must wait
+ * for block ack (N_COMPRESSED_BA).  This struct stores tx reply info
+ * until block ack arrives.
+ */
+struct il_ht_agg {
+	u16 txq_id;
+	u16 frame_count;
+	u16 wait_for_ba;
+	u16 start_idx;
+	u64 bitmap;
+	u32 rate_n_flags;
+#define IL_AGG_OFF 0
+#define IL_AGG_ON 1
+#define IL_EMPTYING_HW_QUEUE_ADDBA 2
+#define IL_EMPTYING_HW_QUEUE_DELBA 3
+	u8 state;
+};
+
+
+struct il_tid_data {
+	u16 seq_number; /* 4965 only */
+	u16 tfds_in_queue;
+	struct il_ht_agg agg;
+};
+
+struct il_hw_key {
+	u32 cipher;
+	int keylen;
+	u8 keyidx;
+	u8 key[32];
+};
+
+union il_ht_rate_supp {
+	u16 rates;
+	struct {
+		u8 siso_rate;
+		u8 mimo_rate;
+	};
+};
+
+#define CFG_HT_RX_AMPDU_FACTOR_8K   (0x0)
+#define CFG_HT_RX_AMPDU_FACTOR_16K  (0x1)
+#define CFG_HT_RX_AMPDU_FACTOR_32K  (0x2)
+#define CFG_HT_RX_AMPDU_FACTOR_64K  (0x3)
+#define CFG_HT_RX_AMPDU_FACTOR_DEF  CFG_HT_RX_AMPDU_FACTOR_64K
+#define CFG_HT_RX_AMPDU_FACTOR_MAX  CFG_HT_RX_AMPDU_FACTOR_64K
+#define CFG_HT_RX_AMPDU_FACTOR_MIN  CFG_HT_RX_AMPDU_FACTOR_8K
+
+/*
+ * Maximal MPDU density for TX aggregation
+ * 4 - 2us density
+ * 5 - 4us density
+ * 6 - 8us density
+ * 7 - 16us density
+ */
+#define CFG_HT_MPDU_DENSITY_2USEC   (0x4)
+#define CFG_HT_MPDU_DENSITY_4USEC   (0x5)
+#define CFG_HT_MPDU_DENSITY_8USEC   (0x6)
+#define CFG_HT_MPDU_DENSITY_16USEC  (0x7)
+#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_4USEC
+#define CFG_HT_MPDU_DENSITY_MAX CFG_HT_MPDU_DENSITY_16USEC
+#define CFG_HT_MPDU_DENSITY_MIN     (0x1)
+
+struct il_ht_config {
+	bool single_chain_sufficient;
+	enum ieee80211_smps_mode smps; /* current smps mode */
+};
+
+/* QoS structures */
+struct il_qos_info {
+	int qos_active;
+	struct il_qosparam_cmd def_qos_parm;
+};
+
+/*
+ * Structure should be accessed with sta_lock held. When station addition
+ * is in progress (IL_STA_UCODE_INPROGRESS) it is possible to access only
+ * the commands (il_addsta_cmd and il_link_quality_cmd) without
+ * sta_lock held.
+ */
+struct il_station_entry {
+	struct il_addsta_cmd sta;
+	struct il_tid_data tid[MAX_TID_COUNT];
+	u8 used, ctxid;
+	struct il_hw_key keyinfo;
+	struct il_link_quality_cmd *lq;
+};
+
+struct il_station_priv_common {
+	struct il_rxon_context *ctx;
+	u8 sta_id;
+};
+
+/*
+ * il_station_priv: Driver's ilate station information
+ *
+ * When mac80211 creates a station it reserves some space (hw->sta_data_size)
+ * in the structure for use by driver. This structure is places in that
+ * space.
+ *
+ * The common struct MUST be first because it is shared between
+ * 3945 and 4965!
+ */
+struct il_station_priv {
+	struct il_station_priv_common common;
+	struct il_lq_sta lq_sta;
+	atomic_t pending_frames;
+	bool client;
+	bool asleep;
+};
+
+/**
+ * struct il_vif_priv - driver's ilate per-interface information
+ *
+ * When mac80211 allocates a virtual interface, it can allocate
+ * space for us to put data into.
+ */
+struct il_vif_priv {
+	struct il_rxon_context *ctx;
+	u8 ibss_bssid_sta_id;
+};
+
+/* one for each uCode image (inst/data, boot/init/runtime) */
+struct fw_desc {
+	void *v_addr;		/* access by driver */
+	dma_addr_t p_addr;	/* access by card's busmaster DMA */
+	u32 len;		/* bytes */
+};
+
+/* uCode file layout */
+struct il_ucode_header {
+	__le32 ver;	/* major/minor/API/serial */
+	struct {
+		__le32 inst_size;	/* bytes of runtime code */
+		__le32 data_size;	/* bytes of runtime data */
+		__le32 init_size;	/* bytes of init code */
+		__le32 init_data_size;	/* bytes of init data */
+		__le32 boot_size;	/* bytes of bootstrap code */
+		u8 data[0];		/* in same order as sizes */
+	} v1;
+};
+
+struct il4965_ibss_seq {
+	u8 mac[ETH_ALEN];
+	u16 seq_num;
+	u16 frag_num;
+	unsigned long packet_time;
+	struct list_head list;
+};
+
+struct il_sensitivity_ranges {
+	u16 min_nrg_cck;
+	u16 max_nrg_cck;
+
+	u16 nrg_th_cck;
+	u16 nrg_th_ofdm;
+
+	u16 auto_corr_min_ofdm;
+	u16 auto_corr_min_ofdm_mrc;
+	u16 auto_corr_min_ofdm_x1;
+	u16 auto_corr_min_ofdm_mrc_x1;
+
+	u16 auto_corr_max_ofdm;
+	u16 auto_corr_max_ofdm_mrc;
+	u16 auto_corr_max_ofdm_x1;
+	u16 auto_corr_max_ofdm_mrc_x1;
+
+	u16 auto_corr_max_cck;
+	u16 auto_corr_max_cck_mrc;
+	u16 auto_corr_min_cck;
+	u16 auto_corr_min_cck_mrc;
+
+	u16 barker_corr_th_min;
+	u16 barker_corr_th_min_mrc;
+	u16 nrg_th_cca;
+};
+
+
+#define KELVIN_TO_CELSIUS(x) ((x)-273)
+#define CELSIUS_TO_KELVIN(x) ((x)+273)
+
+
+/**
+ * struct il_hw_params
+ * @max_txq_num: Max # Tx queues supported
+ * @dma_chnl_num: Number of Tx DMA/FIFO channels
+ * @scd_bc_tbls_size: size of scheduler byte count tables
+ * @tfd_size: TFD size
+ * @tx/rx_chains_num: Number of TX/RX chains
+ * @valid_tx/rx_ant: usable antennas
+ * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
+ * @max_rxq_log: Log-base-2 of max_rxq_size
+ * @rx_page_order: Rx buffer page order
+ * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
+ * @max_stations:
+ * @ht40_channel: is 40MHz width possible in band 2.4
+ * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
+ * @sw_crypto: 0 for hw, 1 for sw
+ * @max_xxx_size: for ucode uses
+ * @ct_kill_threshold: temperature threshold
+ * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
+ * @struct il_sensitivity_ranges: range of sensitivity values
+ */
+struct il_hw_params {
+	u8 max_txq_num;
+	u8 dma_chnl_num;
+	u16 scd_bc_tbls_size;
+	u32 tfd_size;
+	u8  tx_chains_num;
+	u8  rx_chains_num;
+	u8  valid_tx_ant;
+	u8  valid_rx_ant;
+	u16 max_rxq_size;
+	u16 max_rxq_log;
+	u32 rx_page_order;
+	u32 rx_wrt_ptr_reg;
+	u8  max_stations;
+	u8  ht40_channel;
+	u8  max_beacon_itrvl;	/* in 1024 ms */
+	u32 max_inst_size;
+	u32 max_data_size;
+	u32 max_bsm_size;
+	u32 ct_kill_threshold; /* value in hw-dependent units */
+	u16 beacon_time_tsf_bits;
+	const struct il_sensitivity_ranges *sens;
+};
+
+
+/******************************************************************************
+ *
+ * Functions implemented in core module which are forward declared here
+ * for use by iwl-[4-5].c
+ *
+ * NOTE:  The implementation of these functions are not hardware specific
+ * which is why they are in the core module files.
+ *
+ * Naming convention --
+ * il_         <-- Is part of iwlwifi
+ * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
+ * il4965_bg_      <-- Called from work queue context
+ * il4965_mac_     <-- mac80211 callback
+ *
+ ****************************************************************************/
+extern void il4965_update_chain_flags(struct il_priv *il);
+extern const u8 il_bcast_addr[ETH_ALEN];
+extern int il_queue_space(const struct il_queue *q);
+static inline int il_queue_used(const struct il_queue *q, int i)
+{
+	return q->write_ptr >= q->read_ptr ?
+		(i >= q->read_ptr && i < q->write_ptr) :
+		!(i < q->read_ptr && i >= q->write_ptr);
+}
+
+
+static inline u8 il_get_cmd_idx(struct il_queue *q, u32 idx,
+								int is_huge)
+{
+	/*
+	 * This is for init calibration result and scan command which
+	 * required buffer > TFD_MAX_PAYLOAD_SIZE,
+	 * the big buffer at end of command array
+	 */
+	if (is_huge)
+		return q->n_win;	/* must be power of 2 */
+
+	/* Otherwise, use normal size buffers */
+	return idx & (q->n_win - 1);
+}
+
+
+struct il_dma_ptr {
+	dma_addr_t dma;
+	void *addr;
+	size_t size;
+};
+
+#define IL_OPERATION_MODE_AUTO     0
+#define IL_OPERATION_MODE_HT_ONLY  1
+#define IL_OPERATION_MODE_MIXED    2
+#define IL_OPERATION_MODE_20MHZ    3
+
+#define IL_TX_CRC_SIZE 4
+#define IL_TX_DELIMITER_SIZE 4
+
+#define TX_POWER_IL_ILLEGAL_VOLTAGE -10000
+
+/* Sensitivity and chain noise calibration */
+#define INITIALIZATION_VALUE		0xFFFF
+#define IL4965_CAL_NUM_BEACONS		20
+#define IL_CAL_NUM_BEACONS		16
+#define MAXIMUM_ALLOWED_PATHLOSS	15
+
+#define CHAIN_NOISE_MAX_DELTA_GAIN_CODE 3
+
+#define MAX_FA_OFDM  50
+#define MIN_FA_OFDM  5
+#define MAX_FA_CCK   50
+#define MIN_FA_CCK   5
+
+#define AUTO_CORR_STEP_OFDM       1
+
+#define AUTO_CORR_STEP_CCK     3
+#define AUTO_CORR_MAX_TH_CCK   160
+
+#define NRG_DIFF               2
+#define NRG_STEP_CCK           2
+#define NRG_MARGIN             8
+#define MAX_NUMBER_CCK_NO_FA 100
+
+#define AUTO_CORR_CCK_MIN_VAL_DEF    (125)
+
+#define CHAIN_A             0
+#define CHAIN_B             1
+#define CHAIN_C             2
+#define CHAIN_NOISE_DELTA_GAIN_INIT_VAL 4
+#define ALL_BAND_FILTER			0xFF00
+#define IN_BAND_FILTER			0xFF
+#define MIN_AVERAGE_NOISE_MAX_VALUE	0xFFFFFFFF
+
+#define NRG_NUM_PREV_STAT_L     20
+#define NUM_RX_CHAINS           3
+
+enum il4965_false_alarm_state {
+	IL_FA_TOO_MANY = 0,
+	IL_FA_TOO_FEW = 1,
+	IL_FA_GOOD_RANGE = 2,
+};
+
+enum il4965_chain_noise_state {
+	IL_CHAIN_NOISE_ALIVE = 0,  /* must be 0 */
+	IL_CHAIN_NOISE_ACCUMULATE,
+	IL_CHAIN_NOISE_CALIBRATED,
+	IL_CHAIN_NOISE_DONE,
+};
+
+enum il4965_calib_enabled_state {
+	IL_CALIB_DISABLED = 0,  /* must be 0 */
+	IL_CALIB_ENABLED = 1,
+};
+
+/*
+ * enum il_calib
+ * defines the order in which results of initial calibrations
+ * should be sent to the runtime uCode
+ */
+enum il_calib {
+	IL_CALIB_MAX,
+};
+
+/* Opaque calibration results */
+struct il_calib_result {
+	void *buf;
+	size_t buf_len;
+};
+
+enum ucode_type {
+	UCODE_NONE = 0,
+	UCODE_INIT,
+	UCODE_RT
+};
+
+/* Sensitivity calib data */
+struct il_sensitivity_data {
+	u32 auto_corr_ofdm;
+	u32 auto_corr_ofdm_mrc;
+	u32 auto_corr_ofdm_x1;
+	u32 auto_corr_ofdm_mrc_x1;
+	u32 auto_corr_cck;
+	u32 auto_corr_cck_mrc;
+
+	u32 last_bad_plcp_cnt_ofdm;
+	u32 last_fa_cnt_ofdm;
+	u32 last_bad_plcp_cnt_cck;
+	u32 last_fa_cnt_cck;
+
+	u32 nrg_curr_state;
+	u32 nrg_prev_state;
+	u32 nrg_value[10];
+	u8  nrg_silence_rssi[NRG_NUM_PREV_STAT_L];
+	u32 nrg_silence_ref;
+	u32 nrg_energy_idx;
+	u32 nrg_silence_idx;
+	u32 nrg_th_cck;
+	s32 nrg_auto_corr_silence_diff;
+	u32 num_in_cck_no_fa;
+	u32 nrg_th_ofdm;
+
+	u16 barker_corr_th_min;
+	u16 barker_corr_th_min_mrc;
+	u16 nrg_th_cca;
+};
+
+/* Chain noise (differential Rx gain) calib data */
+struct il_chain_noise_data {
+	u32 active_chains;
+	u32 chain_noise_a;
+	u32 chain_noise_b;
+	u32 chain_noise_c;
+	u32 chain_signal_a;
+	u32 chain_signal_b;
+	u32 chain_signal_c;
+	u16 beacon_count;
+	u8 disconn_array[NUM_RX_CHAINS];
+	u8 delta_gain_code[NUM_RX_CHAINS];
+	u8 radio_write;
+	u8 state;
+};
+
+#define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
+#define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
+
+#define IL_TRAFFIC_ENTRIES	(256)
+#define IL_TRAFFIC_ENTRY_SIZE  (64)
+
+enum {
+	MEASUREMENT_READY = (1 << 0),
+	MEASUREMENT_ACTIVE = (1 << 1),
+};
+
+/* interrupt stats */
+struct isr_stats {
+	u32 hw;
+	u32 sw;
+	u32 err_code;
+	u32 sch;
+	u32 alive;
+	u32 rfkill;
+	u32 ctkill;
+	u32 wakeup;
+	u32 rx;
+	u32 handlers[IL_CN_MAX];
+	u32 tx;
+	u32 unhandled;
+};
+
+/* management stats */
+enum il_mgmt_stats {
+	MANAGEMENT_ASSOC_REQ = 0,
+	MANAGEMENT_ASSOC_RESP,
+	MANAGEMENT_REASSOC_REQ,
+	MANAGEMENT_REASSOC_RESP,
+	MANAGEMENT_PROBE_REQ,
+	MANAGEMENT_PROBE_RESP,
+	MANAGEMENT_BEACON,
+	MANAGEMENT_ATIM,
+	MANAGEMENT_DISASSOC,
+	MANAGEMENT_AUTH,
+	MANAGEMENT_DEAUTH,
+	MANAGEMENT_ACTION,
+	MANAGEMENT_MAX,
+};
+/* control stats */
+enum il_ctrl_stats {
+	CONTROL_BACK_REQ =  0,
+	CONTROL_BACK,
+	CONTROL_PSPOLL,
+	CONTROL_RTS,
+	CONTROL_CTS,
+	CONTROL_ACK,
+	CONTROL_CFEND,
+	CONTROL_CFENDACK,
+	CONTROL_MAX,
+};
+
+struct traffic_stats {
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+	u32 mgmt[MANAGEMENT_MAX];
+	u32 ctrl[CONTROL_MAX];
+	u32 data_cnt;
+	u64 data_bytes;
+#endif
+};
+
+/*
+ * host interrupt timeout value
+ * used with setting interrupt coalescing timer
+ * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
+ *
+ * default interrupt coalescing timer is 64 x 32 = 2048 usecs
+ * default interrupt coalescing calibration timer is 16 x 32 = 512 usecs
+ */
+#define IL_HOST_INT_TIMEOUT_MAX	(0xFF)
+#define IL_HOST_INT_TIMEOUT_DEF	(0x40)
+#define IL_HOST_INT_TIMEOUT_MIN	(0x0)
+#define IL_HOST_INT_CALIB_TIMEOUT_MAX	(0xFF)
+#define IL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
+#define IL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
+
+#define IL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
+
+/* TX queue watchdog timeouts in mSecs */
+#define IL_DEF_WD_TIMEOUT	(2000)
+#define IL_LONG_WD_TIMEOUT	(10000)
+#define IL_MAX_WD_TIMEOUT	(120000)
+
+struct il_force_reset {
+	int reset_request_count;
+	int reset_success_count;
+	int reset_reject_count;
+	unsigned long reset_duration;
+	unsigned long last_force_reset_jiffies;
+};
+
+/* extend beacon time format bit shifting  */
+/*
+ * for _3945 devices
+ * bits 31:24 - extended
+ * bits 23:0  - interval
+ */
+#define IL3945_EXT_BEACON_TIME_POS	24
+/*
+ * for _4965 devices
+ * bits 31:22 - extended
+ * bits 21:0  - interval
+ */
+#define IL4965_EXT_BEACON_TIME_POS	22
+
+struct il_rxon_context {
+	struct ieee80211_vif *vif;
+
+	const u8 *ac_to_fifo;
+	const u8 *ac_to_queue;
+	u8 mcast_queue;
+
+	/*
+	 * We could use the vif to indicate active, but we
+	 * also need it to be active during disabling when
+	 * we already removed the vif for type setting.
+	 */
+	bool always_active, is_active;
+
+	bool ht_need_multiple_chains;
+
+	int ctxid;
+
+	u32 interface_modes, exclusive_interface_modes;
+	u8 unused_devtype, ap_devtype, ibss_devtype, station_devtype;
+
+	/*
+	 * We declare this const so it can only be
+	 * changed via explicit cast within the
+	 * routines that actually update the physical
+	 * hardware.
+	 */
+	const struct il_rxon_cmd active;
+	struct il_rxon_cmd staging;
+
+	struct il_rxon_time_cmd timing;
+
+	struct il_qos_info qos_data;
+
+	u8 bcast_sta_id, ap_sta_id;
+
+	u8 rxon_cmd, rxon_assoc_cmd, rxon_timing_cmd;
+	u8 qos_cmd;
+	u8 wep_key_cmd;
+
+	struct il_wep_key wep_keys[WEP_KEYS_MAX];
+	u8 key_mapping_keys;
+
+	__le32 station_flags;
+
+	struct {
+		bool non_gf_sta_present;
+		u8 protection;
+		bool enabled, is_40mhz;
+		u8 extension_chan_offset;
+	} ht;
+};
+
+struct il_priv {
+
+	/* ieee device used by generic ieee processing code */
+	struct ieee80211_hw *hw;
+	struct ieee80211_channel *ieee_channels;
+	struct ieee80211_rate *ieee_rates;
+	struct il_cfg *cfg;
+
+	/* temporary frame storage list */
+	struct list_head free_frames;
+	int frames_count;
+
+	enum ieee80211_band band;
+	int alloc_rxb_page;
+
+	void (*handlers[IL_CN_MAX])(struct il_priv *il,
+				       struct il_rx_buf *rxb);
+
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+
+	/* spectrum measurement report caching */
+	struct il_spectrum_notification measure_report;
+	u8 measurement_status;
+
+	/* ucode beacon time */
+	u32 ucode_beacon_time;
+	int missed_beacon_threshold;
+
+	/* track IBSS manager (last beacon) status */
+	u32 ibss_manager;
+
+	/* force reset */
+	struct il_force_reset force_reset;
+
+	/* we allocate array of il_channel_info for NIC's valid channels.
+	 *    Access via channel # using indirect idx array */
+	struct il_channel_info *channel_info;	/* channel info array */
+	u8 channel_count;	/* # of channels */
+
+	/* thermal calibration */
+	s32 temperature;	/* degrees Kelvin */
+	s32 last_temperature;
+
+	/* init calibration results */
+	struct il_calib_result calib_results[IL_CALIB_MAX];
+
+	/* Scan related variables */
+	unsigned long scan_start;
+	unsigned long scan_start_tsf;
+	void *scan_cmd;
+	enum ieee80211_band scan_band;
+	struct cfg80211_scan_request *scan_request;
+	struct ieee80211_vif *scan_vif;
+	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
+	u8 mgmt_tx_ant;
+
+	/* spinlock */
+	spinlock_t lock;	/* protect general shared data */
+	spinlock_t hcmd_lock;	/* protect hcmd */
+	spinlock_t reg_lock;	/* protect hw register access */
+	struct mutex mutex;
+
+	/* basic pci-network driver stuff */
+	struct pci_dev *pci_dev;
+
+	/* pci hardware address support */
+	void __iomem *hw_base;
+	u32  hw_rev;
+	u32  hw_wa_rev;
+	u8   rev_id;
+
+	/* command queue number */
+	u8 cmd_queue;
+
+	/* max number of station keys */
+	u8 sta_key_max_num;
+
+	/* EEPROM MAC addresses */
+	struct mac_address addresses[1];
+
+	/* uCode images, save to reload in case of failure */
+	int fw_idx;			/* firmware we're trying to load */
+	u32 ucode_ver;			/* version of ucode, copy of
+					   il_ucode.ver */
+	struct fw_desc ucode_code;	/* runtime inst */
+	struct fw_desc ucode_data;	/* runtime data original */
+	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
+	struct fw_desc ucode_init;	/* initialization inst */
+	struct fw_desc ucode_init_data;	/* initialization data */
+	struct fw_desc ucode_boot;	/* bootstrap inst */
+	enum ucode_type ucode_type;
+	u8 ucode_write_complete;	/* the image write is complete */
+	char firmware_name[25];
+
+	struct il_rxon_context ctx;
+
+	__le16 switch_channel;
+
+	/* 1st responses from initialize and runtime uCode images.
+	 * _4965's initialize alive response contains some calibration data. */
+	struct il_init_alive_resp card_alive_init;
+	struct il_alive_resp card_alive;
+
+	u16 active_rate;
+
+	u8 start_calib;
+	struct il_sensitivity_data sensitivity_data;
+	struct il_chain_noise_data chain_noise_data;
+	__le16 sensitivity_tbl[HD_TBL_SIZE];
+
+	struct il_ht_config current_ht_config;
+
+	/* Rate scaling data */
+	u8 retry_rate;
+
+	wait_queue_head_t wait_command_queue;
+
+	int activity_timer_active;
+
+	/* Rx and Tx DMA processing queues */
+	struct il_rx_queue rxq;
+	struct il_tx_queue *txq;
+	unsigned long txq_ctx_active_msk;
+	struct il_dma_ptr  kw;	/* keep warm address */
+	struct il_dma_ptr  scd_bc_tbls;
+
+	u32 scd_base_addr;	/* scheduler sram base address */
+
+	unsigned long status;
+
+	/* counts mgmt, ctl, and data packets */
+	struct traffic_stats tx_stats;
+	struct traffic_stats rx_stats;
+
+	/* counts interrupts */
+	struct isr_stats isr_stats;
+
+	struct il_power_mgr power_data;
+
+	/* context information */
+	u8 bssid[ETH_ALEN]; /* used only on 3945 but filled by core */
+
+	/* station table variables */
+
+	/* Note: if lock and sta_lock are needed, lock must be acquired first */
+	spinlock_t sta_lock;
+	int num_stations;
+	struct il_station_entry stations[IL_STATION_COUNT];
+	unsigned long ucode_key_table;
+
+	/* queue refcounts */
+#define IL_MAX_HW_QUEUES	32
+	unsigned long queue_stopped[BITS_TO_LONGS(IL_MAX_HW_QUEUES)];
+	/* for each AC */
+	atomic_t queue_stop_count[4];
+
+	/* Indication if ieee80211_ops->open has been called */
+	u8 is_open;
+
+	u8 mac80211_registered;
+
+	/* eeprom -- this is in the card's little endian byte order */
+	u8 *eeprom;
+	struct il_eeprom_calib_info *calib_info;
+
+	enum nl80211_iftype iw_mode;
+
+	/* Last Rx'd beacon timestamp */
+	u64 timestamp;
+
+	union {
+#if defined(CONFIG_IWL3945) || defined(CONFIG_IWL3945_MODULE)
+		struct {
+			void *shared_virt;
+			dma_addr_t shared_phys;
+
+			struct delayed_work thermal_periodic;
+			struct delayed_work rfkill_poll;
+
+			struct il3945_notif_stats stats;
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+			struct il3945_notif_stats accum_stats;
+			struct il3945_notif_stats delta_stats;
+			struct il3945_notif_stats max_delta;
+#endif
+
+			u32 sta_supp_rates;
+			int last_rx_rssi;	/* From Rx packet stats */
+
+			/* Rx'd packet timing information */
+			u32 last_beacon_time;
+			u64 last_tsf;
+
+			/*
+			 * each calibration channel group in the
+			 * EEPROM has a derived clip setting for
+			 * each rate.
+			 */
+			const struct il3945_clip_group clip_groups[5];
+
+		} _3945;
+#endif
+#if defined(CONFIG_IWL4965) || defined(CONFIG_IWL4965_MODULE)
+		struct {
+			struct il_rx_phy_res last_phy_res;
+			bool last_phy_res_valid;
+
+			struct completion firmware_loading_complete;
+
+			/*
+			 * chain noise reset and gain commands are the
+			 * two extra calibration commands follows the standard
+			 * phy calibration commands
+			 */
+			u8 phy_calib_chain_noise_reset_cmd;
+			u8 phy_calib_chain_noise_gain_cmd;
+
+			struct il_notif_stats stats;
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+			struct il_notif_stats accum_stats;
+			struct il_notif_stats delta_stats;
+			struct il_notif_stats max_delta;
+#endif
+
+		} _4965;
+#endif
+	};
+
+	struct il_hw_params hw_params;
+
+	u32 inta_mask;
+
+	struct workqueue_struct *workqueue;
+
+	struct work_struct restart;
+	struct work_struct scan_completed;
+	struct work_struct rx_replenish;
+	struct work_struct abort_scan;
+
+	struct il_rxon_context *beacon_ctx;
+	struct sk_buff *beacon_skb;
 
+	struct work_struct tx_flush;
+
+	struct tasklet_struct irq_tasklet;
+
+	struct delayed_work init_alive_start;
+	struct delayed_work alive_start;
+	struct delayed_work scan_check;
+
+	/* TX Power */
+	s8 tx_power_user_lmt;
+	s8 tx_power_device_lmt;
+	s8 tx_power_next;
+
+
+#ifdef CONFIG_IWLEGACY_DEBUG
+	/* debugging info */
+	u32 debug_level; /* per device debugging will override global
+			    il_debug_level if set */
+#endif /* CONFIG_IWLEGACY_DEBUG */
+#ifdef CONFIG_IWLEGACY_DEBUGFS
+	/* debugfs */
+	u16 tx_traffic_idx;
+	u16 rx_traffic_idx;
+	u8 *tx_traffic;
+	u8 *rx_traffic;
+	struct dentry *debugfs_dir;
+	u32 dbgfs_sram_offset, dbgfs_sram_len;
+	bool disable_ht40;
+#endif /* CONFIG_IWLEGACY_DEBUGFS */
+
+	struct work_struct txpower_work;
+	u32 disable_sens_cal;
+	u32 disable_chain_noise_cal;
+	u32 disable_tx_power_cal;
+	struct work_struct run_time_calib_work;
+	struct timer_list stats_periodic;
+	struct timer_list watchdog;
+	bool hw_ready;
+
+	struct led_classdev led;
+	unsigned long blink_on, blink_off;
+	bool led_registered;
+}; /*il_priv */
+
+static inline void il_txq_ctx_activate(struct il_priv *il, int txq_id)
+{
+	set_bit(txq_id, &il->txq_ctx_active_msk);
+}
+
+static inline void il_txq_ctx_deactivate(struct il_priv *il, int txq_id)
+{
+	clear_bit(txq_id, &il->txq_ctx_active_msk);
+}
+
+#ifdef CONFIG_IWLEGACY_DEBUG
+/*
+ * il_get_debug_level: Return active debug level for device
+ *
+ * Using sysfs it is possible to set per device debug level. This debug
+ * level will be used if set, otherwise the global debug level which can be
+ * set via module parameter is used.
+ */
+static inline u32 il_get_debug_level(struct il_priv *il)
+{
+	if (il->debug_level)
+		return il->debug_level;
+	else
+		return il_debug_level;
+}
+#else
+static inline u32 il_get_debug_level(struct il_priv *il)
+{
+	return il_debug_level;
+}
+#endif
+
+
+static inline struct ieee80211_hdr *
+il_tx_queue_get_hdr(struct il_priv *il,
+						 int txq_id, int idx)
+{
+	if (il->txq[txq_id].txb[idx].skb)
+		return (struct ieee80211_hdr *)il->txq[txq_id].
+				txb[idx].skb->data;
+	return NULL;
+}
+
+static inline struct il_rxon_context *
+il_rxon_ctx_from_vif(struct ieee80211_vif *vif)
+{
+	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
+
+	return vif_priv->ctx;
+}
+
+#define for_each_context(il, _ctx) \
+	for (_ctx = &il->ctx; _ctx == &il->ctx; _ctx++)
+
+static inline int il_is_associated(struct il_priv *il)
+{
+	return (il->ctx.active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+}
+
+static inline int il_is_any_associated(struct il_priv *il)
+{
+	return il_is_associated(il);
+}
+
+static inline int il_is_associated_ctx(struct il_rxon_context *ctx)
+{
+	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
+}
+
+static inline int il_is_channel_valid(const struct il_channel_info *ch_info)
+{
+	if (ch_info == NULL)
+		return 0;
+	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
+}
+
+static inline int il_is_channel_radar(const struct il_channel_info *ch_info)
+{
+	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
+}
+
+static inline u8 il_is_channel_a_band(const struct il_channel_info *ch_info)
+{
+	return ch_info->band == IEEE80211_BAND_5GHZ;
+}
+
+static inline int
+il_is_channel_passive(const struct il_channel_info *ch)
+{
+	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
+}
+
+static inline int
+il_is_channel_ibss(const struct il_channel_info *ch)
+{
+	return (ch->flags & EEPROM_CHANNEL_IBSS) ? 1 : 0;
+}
+
+static inline void
+__il_free_pages(struct il_priv *il, struct page *page)
+{
+	__free_pages(page, il->hw_params.rx_page_order);
+	il->alloc_rxb_page--;
+}
+
+static inline void il_free_pages(struct il_priv *il, unsigned long page)
+{
+	free_pages(page, il->hw_params.rx_page_order);
+	il->alloc_rxb_page--;
+}
 
 #define IWLWIFI_VERSION "in-tree:"
 #define DRV_COPYRIGHT	"Copyright(c) 2003-2011 Intel Corporation"
@@ -87,6 +1371,11 @@ struct il_cmd;
 
 #define IL_CMD(x) case x: return #x
 
+/* Size of one Rx buffer in host DRAM */
+#define IL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
+#define IL_RX_BUF_SIZE_4K (4 * 1024)
+#define IL_RX_BUF_SIZE_8K (8 * 1024)
+
 struct il_hcmd_ops {
 	int (*rxon_assoc)(struct il_priv *il, struct il_rxon_context *ctx);
 	int (*commit_rxon)(struct il_priv *il, struct il_rxon_context *ctx);
@@ -633,4 +1922,655 @@ void il_tx_cmd_protection(struct il_priv *il,
 
 irqreturn_t il_isr(int irq, void *data);
 
+
+#include <linux/io.h>
+
+static inline void _il_write8(struct il_priv *il, u32 ofs, u8 val)
+{
+	iowrite8(val, il->hw_base + ofs);
+}
+#define il_write8(il, ofs, val) _il_write8(il, ofs, val)
+
+static inline void _il_wr(struct il_priv *il, u32 ofs, u32 val)
+{
+	iowrite32(val, il->hw_base + ofs);
+}
+
+static inline u32 _il_rd(struct il_priv *il, u32 ofs)
+{
+	return ioread32(il->hw_base + ofs);
+}
+
+#define IL_POLL_INTERVAL 10	/* microseconds */
+static inline int
+_il_poll_bit(struct il_priv *il, u32 addr,
+				u32 bits, u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((_il_rd(il, addr) & mask) == (bits & mask))
+			return t;
+		udelay(IL_POLL_INTERVAL);
+		t += IL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
+static inline void _il_set_bit(struct il_priv *il, u32 reg, u32 mask)
+{
+	_il_wr(il, reg, _il_rd(il, reg) | mask);
+}
+
+static inline void il_set_bit(struct il_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	_il_set_bit(p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
+
+static inline void
+_il_clear_bit(struct il_priv *il, u32 reg, u32 mask)
+{
+	_il_wr(il, reg, _il_rd(il, reg) & ~mask);
+}
+
+static inline void il_clear_bit(struct il_priv *p, u32 r, u32 m)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&p->reg_lock, reg_flags);
+	_il_clear_bit(p, r, m);
+	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
+}
+
+static inline int _il_grab_nic_access(struct il_priv *il)
+{
+	int ret;
+	u32 val;
+
+	/* this bit wakes up the NIC */
+	_il_set_bit(il, CSR_GP_CNTRL,
+				CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+
+	/*
+	 * These bits say the device is running, and should keep running for
+	 * at least a short while (at least as long as MAC_ACCESS_REQ stays 1),
+	 * but they do not indicate that embedded SRAM is restored yet;
+	 * 3945 and 4965 have volatile SRAM, and must save/restore contents
+	 * to/from host DRAM when sleeping/waking for power-saving.
+	 * Each direction takes approximately 1/4 millisecond; with this
+	 * overhead, it's a good idea to grab and hold MAC_ACCESS_REQUEST if a
+	 * series of register accesses are expected (e.g. reading Event Log),
+	 * to keep device from sleeping.
+	 *
+	 * CSR_UCODE_DRV_GP1 register bit MAC_SLEEP == 0 indicates that
+	 * SRAM is okay/restored.  We don't check that here because this call
+	 * is just for hardware register access; but GP1 MAC_SLEEP check is a
+	 * good idea before accessing 3945/4965 SRAM (e.g. reading Event Log).
+	 *
+	 */
+	ret = _il_poll_bit(il, CSR_GP_CNTRL,
+			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
+			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
+			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
+	if (ret < 0) {
+		val = _il_rd(il, CSR_GP_CNTRL);
+		IL_ERR(
+			"MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
+		_il_wr(il, CSR_RESET,
+				CSR_RESET_REG_FLAG_FORCE_NMI);
+		return -EIO;
+	}
+
+	return 0;
+}
+
+static inline void _il_release_nic_access(struct il_priv *il)
+{
+	_il_clear_bit(il, CSR_GP_CNTRL,
+			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
+}
+
+static inline u32 il_rd(struct il_priv *il, u32 reg)
+{
+	u32 value;
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+	value = _il_rd(il, reg);
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+	return value;
+
+}
+
+static inline void
+il_wr(struct il_priv *il, u32 reg, u32 value)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	if (!_il_grab_nic_access(il)) {
+		_il_wr(il, reg, value);
+		_il_release_nic_access(il);
+	}
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+
+static inline void il_write_reg_buf(struct il_priv *il,
+					       u32 reg, u32 len, u32 *values)
+{
+	u32 count = sizeof(u32);
+
+	if (il != NULL && values != NULL) {
+		for (; 0 < len; len -= count, reg += count, values++)
+			il_wr(il, reg, *values);
+	}
+}
+
+static inline int il_poll_bit(struct il_priv *il, u32 addr,
+				       u32 mask, int timeout)
+{
+	int t = 0;
+
+	do {
+		if ((il_rd(il, addr) & mask) == mask)
+			return t;
+		udelay(IL_POLL_INTERVAL);
+		t += IL_POLL_INTERVAL;
+	} while (t < timeout);
+
+	return -ETIMEDOUT;
+}
+
+static inline u32 _il_rd_prph(struct il_priv *il, u32 reg)
+{
+	_il_wr(il, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
+	rmb();
+	return _il_rd(il, HBUS_TARG_PRPH_RDAT);
+}
+
+static inline u32 il_rd_prph(struct il_priv *il, u32 reg)
+{
+	unsigned long reg_flags;
+	u32 val;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+	val = _il_rd_prph(il, reg);
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+	return val;
+}
+
+static inline void _il_wr_prph(struct il_priv *il,
+					     u32 addr, u32 val)
+{
+	_il_wr(il, HBUS_TARG_PRPH_WADDR,
+			      ((addr & 0x0000FFFF) | (3 << 24)));
+	wmb();
+	_il_wr(il, HBUS_TARG_PRPH_WDAT, val);
+}
+
+static inline void
+il_wr_prph(struct il_priv *il, u32 addr, u32 val)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	if (!_il_grab_nic_access(il)) {
+		_il_wr_prph(il, addr, val);
+		_il_release_nic_access(il);
+	}
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+
+#define _il_set_bits_prph(il, reg, mask) \
+_il_wr_prph(il, reg, (_il_rd_prph(il, reg) | mask))
+
+static inline void
+il_set_bits_prph(struct il_priv *il, u32 reg, u32 mask)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+	_il_set_bits_prph(il, reg, mask);
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+
+#define _il_set_bits_mask_prph(il, reg, bits, mask) \
+_il_wr_prph(il, reg,				\
+		 ((_il_rd_prph(il, reg) & mask) | bits))
+
+static inline void il_set_bits_mask_prph(struct il_priv *il, u32 reg,
+				u32 bits, u32 mask)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+	_il_set_bits_mask_prph(il, reg, bits, mask);
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+
+static inline void il_clear_bits_prph(struct il_priv
+						 *il, u32 reg, u32 mask)
+{
+	unsigned long reg_flags;
+	u32 val;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+	val = _il_rd_prph(il, reg);
+	_il_wr_prph(il, reg, (val & ~mask));
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+
+static inline u32 il_read_targ_mem(struct il_priv *il, u32 addr)
+{
+	unsigned long reg_flags;
+	u32 value;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	_il_grab_nic_access(il);
+
+	_il_wr(il, HBUS_TARG_MEM_RADDR, addr);
+	rmb();
+	value = _il_rd(il, HBUS_TARG_MEM_RDAT);
+
+	_il_release_nic_access(il);
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+	return value;
+}
+
+static inline void
+il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	if (!_il_grab_nic_access(il)) {
+		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
+		wmb();
+		_il_wr(il, HBUS_TARG_MEM_WDAT, val);
+		_il_release_nic_access(il);
+	}
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+
+static inline void
+il_write_targ_mem_buf(struct il_priv *il, u32 addr,
+					  u32 len, u32 *values)
+{
+	unsigned long reg_flags;
+
+	spin_lock_irqsave(&il->reg_lock, reg_flags);
+	if (!_il_grab_nic_access(il)) {
+		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
+		wmb();
+		for (; 0 < len; len -= sizeof(u32), values++)
+			_il_wr(il,
+					HBUS_TARG_MEM_WDAT, *values);
+
+		_il_release_nic_access(il);
+	}
+	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
+}
+
+#define HW_KEY_DYNAMIC 0
+#define HW_KEY_DEFAULT 1
+
+#define IL_STA_DRIVER_ACTIVE BIT(0) /* driver entry is active */
+#define IL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
+#define IL_STA_UCODE_INPROGRESS  BIT(2) /* ucode entry is in process of
+					    being activated */
+#define IL_STA_LOCAL BIT(3) /* station state not directed by mac80211;
+				(this is for the IBSS BSSID stations) */
+#define IL_STA_BCAST BIT(4) /* this station is the special bcast station */
+
+
+void il_restore_stations(struct il_priv *il,
+				struct il_rxon_context *ctx);
+void il_clear_ucode_stations(struct il_priv *il,
+			      struct il_rxon_context *ctx);
+void il_dealloc_bcast_stations(struct il_priv *il);
+int il_get_free_ucode_key_idx(struct il_priv *il);
+int il_send_add_sta(struct il_priv *il,
+			struct il_addsta_cmd *sta, u8 flags);
+int il_add_station_common(struct il_priv *il,
+			struct il_rxon_context *ctx,
+			const u8 *addr, bool is_ap,
+			struct ieee80211_sta *sta, u8 *sta_id_r);
+int il_remove_station(struct il_priv *il,
+			const u8 sta_id,
+			const u8 *addr);
+int il_mac_sta_remove(struct ieee80211_hw *hw,
+			struct ieee80211_vif *vif,
+			struct ieee80211_sta *sta);
+
+u8 il_prep_station(struct il_priv *il,
+			struct il_rxon_context *ctx,
+			const u8 *addr, bool is_ap,
+			struct ieee80211_sta *sta);
+
+int il_send_lq_cmd(struct il_priv *il,
+			struct il_rxon_context *ctx,
+			struct il_link_quality_cmd *lq,
+			u8 flags, bool init);
+
+/**
+ * il_clear_driver_stations - clear knowledge of all stations from driver
+ * @il: iwl il struct
+ *
+ * This is called during il_down() to make sure that in the case
+ * we're coming there from a hardware restart mac80211 will be
+ * able to reconfigure stations -- if we're getting there in the
+ * normal down flow then the stations will already be cleared.
+ */
+static inline void il_clear_driver_stations(struct il_priv *il)
+{
+	unsigned long flags;
+	struct il_rxon_context *ctx = &il->ctx;
+
+	spin_lock_irqsave(&il->sta_lock, flags);
+	memset(il->stations, 0, sizeof(il->stations));
+	il->num_stations = 0;
+
+	il->ucode_key_table = 0;
+
+	/*
+	 * Remove all key information that is not stored as part
+	 * of station information since mac80211 may not have had
+	 * a chance to remove all the keys. When device is
+	 * reconfigured by mac80211 after an error all keys will
+	 * be reconfigured.
+	 */
+	memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
+	ctx->key_mapping_keys = 0;
+
+	spin_unlock_irqrestore(&il->sta_lock, flags);
+}
+
+static inline int il_sta_id(struct ieee80211_sta *sta)
+{
+	if (WARN_ON(!sta))
+		return IL_INVALID_STATION;
+
+	return ((struct il_station_priv_common *)sta->drv_priv)->sta_id;
+}
+
+/**
+ * il_sta_id_or_broadcast - return sta_id or broadcast sta
+ * @il: iwl il
+ * @context: the current context
+ * @sta: mac80211 station
+ *
+ * In certain circumstances mac80211 passes a station pointer
+ * that may be %NULL, for example during TX or key setup. In
+ * that case, we need to use the broadcast station, so this
+ * inline wraps that pattern.
+ */
+static inline int il_sta_id_or_broadcast(struct il_priv *il,
+					  struct il_rxon_context *context,
+					  struct ieee80211_sta *sta)
+{
+	int sta_id;
+
+	if (!sta)
+		return context->bcast_sta_id;
+
+	sta_id = il_sta_id(sta);
+
+	/*
+	 * mac80211 should not be passing a partially
+	 * initialised station!
+	 */
+	WARN_ON(sta_id == IL_INVALID_STATION);
+
+	return sta_id;
+}
+
+/**
+ * il_queue_inc_wrap - increment queue idx, wrap back to beginning
+ * @idx -- current idx
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int il_queue_inc_wrap(int idx, int n_bd)
+{
+	return ++idx & (n_bd - 1);
+}
+
+/**
+ * il_queue_dec_wrap - decrement queue idx, wrap back to end
+ * @idx -- current idx
+ * @n_bd -- total number of entries in queue (must be power of 2)
+ */
+static inline int il_queue_dec_wrap(int idx, int n_bd)
+{
+	return --idx & (n_bd - 1);
+}
+
+/* TODO: Move fw_desc functions to iwl-pci.ko */
+static inline void il_free_fw_desc(struct pci_dev *pci_dev,
+				    struct fw_desc *desc)
+{
+	if (desc->v_addr)
+		dma_free_coherent(&pci_dev->dev, desc->len,
+				  desc->v_addr, desc->p_addr);
+	desc->v_addr = NULL;
+	desc->len = 0;
+}
+
+static inline int il_alloc_fw_desc(struct pci_dev *pci_dev,
+				    struct fw_desc *desc)
+{
+	if (!desc->len) {
+		desc->v_addr = NULL;
+		return -EINVAL;
+	}
+
+	desc->v_addr = dma_alloc_coherent(&pci_dev->dev, desc->len,
+					  &desc->p_addr, GFP_KERNEL);
+	return (desc->v_addr != NULL) ? 0 : -ENOMEM;
+}
+
+/*
+ * we have 8 bits used like this:
+ *
+ * 7 6 5 4 3 2 1 0
+ * | | | | | | | |
+ * | | | | | | +-+-------- AC queue (0-3)
+ * | | | | | |
+ * | +-+-+-+-+------------ HW queue ID
+ * |
+ * +---------------------- unused
+ */
+static inline void
+il_set_swq_id(struct il_tx_queue *txq, u8 ac, u8 hwq)
+{
+	BUG_ON(ac > 3);   /* only have 2 bits */
+	BUG_ON(hwq > 31); /* only use 5 bits */
+
+	txq->swq_id = (hwq << 2) | ac;
+}
+
+static inline void il_wake_queue(struct il_priv *il,
+				  struct il_tx_queue *txq)
+{
+	u8 queue = txq->swq_id;
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
+
+	if (test_and_clear_bit(hwq, il->queue_stopped))
+		if (atomic_dec_return(&il->queue_stop_count[ac]) <= 0)
+			ieee80211_wake_queue(il->hw, ac);
+}
+
+static inline void il_stop_queue(struct il_priv *il,
+				  struct il_tx_queue *txq)
+{
+	u8 queue = txq->swq_id;
+	u8 ac = queue & 3;
+	u8 hwq = (queue >> 2) & 0x1f;
+
+	if (!test_and_set_bit(hwq, il->queue_stopped))
+		if (atomic_inc_return(&il->queue_stop_count[ac]) > 0)
+			ieee80211_stop_queue(il->hw, ac);
+}
+
+#ifdef ieee80211_stop_queue
+#undef ieee80211_stop_queue
+#endif
+
+#define ieee80211_stop_queue DO_NOT_USE_ieee80211_stop_queue
+
+#ifdef ieee80211_wake_queue
+#undef ieee80211_wake_queue
+#endif
+
+#define ieee80211_wake_queue DO_NOT_USE_ieee80211_wake_queue
+
+static inline void il_disable_interrupts(struct il_priv *il)
+{
+	clear_bit(S_INT_ENABLED, &il->status);
+
+	/* disable interrupts from uCode/NIC to host */
+	_il_wr(il, CSR_INT_MASK, 0x00000000);
+
+	/* acknowledge/clear/reset any interrupts still pending
+	 * from uCode or flow handler (Rx/Tx DMA) */
+	_il_wr(il, CSR_INT, 0xffffffff);
+	_il_wr(il, CSR_FH_INT_STATUS, 0xffffffff);
+	D_ISR("Disabled interrupts\n");
+}
+
+static inline void il_enable_rfkill_int(struct il_priv *il)
+{
+	D_ISR("Enabling rfkill interrupt\n");
+	_il_wr(il, CSR_INT_MASK, CSR_INT_BIT_RF_KILL);
+}
+
+static inline void il_enable_interrupts(struct il_priv *il)
+{
+	D_ISR("Enabling interrupts\n");
+	set_bit(S_INT_ENABLED, &il->status);
+	_il_wr(il, CSR_INT_MASK, il->inta_mask);
+}
+
+/**
+ * il_beacon_time_mask_low - mask of lower 32 bit of beacon time
+ * @il -- pointer to il_priv data structure
+ * @tsf_bits -- number of bits need to shift for masking)
+ */
+static inline u32 il_beacon_time_mask_low(struct il_priv *il,
+					   u16 tsf_bits)
+{
+	return (1 << tsf_bits) - 1;
+}
+
+/**
+ * il_beacon_time_mask_high - mask of higher 32 bit of beacon time
+ * @il -- pointer to il_priv data structure
+ * @tsf_bits -- number of bits need to shift for masking)
+ */
+static inline u32 il_beacon_time_mask_high(struct il_priv *il,
+					    u16 tsf_bits)
+{
+	return ((1 << (32 - tsf_bits)) - 1) << tsf_bits;
+}
+
+/**
+ * struct il_rb_status - reseve buffer status host memory mapped FH registers
+ *
+ * @closed_rb_num [0:11] - Indicates the idx of the RB which was closed
+ * @closed_fr_num [0:11] - Indicates the idx of the RX Frame which was closed
+ * @finished_rb_num [0:11] - Indicates the idx of the current RB
+ *			     in which the last frame was written to
+ * @finished_fr_num [0:11] - Indicates the idx of the RX Frame
+ *			     which was transferred
+ */
+struct il_rb_status {
+	__le16 closed_rb_num;
+	__le16 closed_fr_num;
+	__le16 finished_rb_num;
+	__le16 finished_fr_nam;
+	__le32 __unused; /* 3945 only */
+} __packed;
+
+
+#define TFD_QUEUE_SIZE_MAX      (256)
+#define TFD_QUEUE_SIZE_BC_DUP	(64)
+#define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
+#define IL_TX_DMA_MASK        DMA_BIT_MASK(36)
+#define IL_NUM_OF_TBS		20
+
+static inline u8 il_get_dma_hi_addr(dma_addr_t addr)
+{
+	return (sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0) & 0xF;
+}
+/**
+ * struct il_tfd_tb transmit buffer descriptor within transmit frame descriptor
+ *
+ * This structure contains dma address and length of transmission address
+ *
+ * @lo: low [31:0] portion of the dma address of TX buffer
+ * 	every even is unaligned on 16 bit boundary
+ * @hi_n_len 0-3 [35:32] portion of dma
+ *	     4-15 length of the tx buffer
+ */
+struct il_tfd_tb {
+	__le32 lo;
+	__le16 hi_n_len;
+} __packed;
+
+/**
+ * struct il_tfd
+ *
+ * Transmit Frame Descriptor (TFD)
+ *
+ * @ __reserved1[3] reserved
+ * @ num_tbs 0-4 number of active tbs
+ *	     5   reserved
+ * 	     6-7 padding (not used)
+ * @ tbs[20]	transmit frame buffer descriptors
+ * @ __pad 	padding
+ *
+ * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
+ * Both driver and device share these circular buffers, each of which must be
+ * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes
+ *
+ * Driver must indicate the physical address of the base of each
+ * circular buffer via the FH_MEM_CBBC_QUEUE registers.
+ *
+ * Each TFD contains pointer/size information for up to 20 data buffers
+ * in host DRAM.  These buffers collectively contain the (one) frame described
+ * by the TFD.  Each buffer must be a single contiguous block of memory within
+ * itself, but buffers may be scattered in host DRAM.  Each buffer has max size
+ * of (4K - 4).  The concatenates all of a TFD's buffers into a single
+ * Tx frame, up to 8 KBytes in size.
+ *
+ * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
+ */
+struct il_tfd {
+	u8 __reserved1[3];
+	u8 num_tbs;
+	struct il_tfd_tb tbs[IL_NUM_OF_TBS];
+	__le32 __pad;
+} __packed;
+/* PCI registers */
+#define PCI_CFG_RETRY_TIMEOUT	0x041
+
+/* PCI register values */
+#define PCI_CFG_LINK_CTRL_VAL_L0S_EN	0x01
+#define PCI_CFG_LINK_CTRL_VAL_L1_EN	0x02
+
 #endif /* __il_core_h__ */
diff --git a/drivers/net/wireless/iwlegacy/iwl-debugfs.c b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
index 6c4bc50..62292a6 100644
--- a/drivers/net/wireless/iwlegacy/iwl-debugfs.c
+++ b/drivers/net/wireless/iwlegacy/iwl-debugfs.c
@@ -29,10 +29,8 @@
 #include <net/mac80211.h>
 
 
-#include "iwl-dev.h"
 #include "iwl-debug.h"
 #include "common.h"
-#include "iwl-io.h"
 
 /* create and remove of files */
 #define DEBUGFS_ADD_FILE(name, parent, mode) do {			\
diff --git a/drivers/net/wireless/iwlegacy/iwl-dev.h b/drivers/net/wireless/iwlegacy/iwl-dev.h
deleted file mode 100644
index ce5bc53..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-dev.h
+++ /dev/null
@@ -1,1351 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
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
-/*
- * Please use this file (iwl-dev.h) for driver implementation definitions.
- * Please use commands.h for uCode API definitions.
- * Please use 4965.h for hardware-related definitions.
- */
-
-#ifndef __il_dev_h__
-#define __il_dev_h__
-
-#include <linux/interrupt.h>
-#include <linux/pci.h> /* for struct pci_device_id */
-#include <linux/kernel.h>
-#include <linux/leds.h>
-#include <linux/wait.h>
-#include <net/ieee80211_radiotap.h>
-
-#include "iwl-eeprom.h"
-#include "csr.h"
-#include "iwl-prph.h"
-#include "iwl-debug.h"
-#include "4965.h"
-#include "iwl-led.h"
-#include "iwl-power.h"
-#include "iwl-legacy-rs.h"
-
-#define U32_PAD(n)		((4-(n))&0x3)
-
-struct il_tx_queue;
-
-/* CT-KILL constants */
-#define CT_KILL_THRESHOLD_LEGACY   110 /* in Celsius */
-
-/* Default noise level to report when noise measurement is not available.
- *   This may be because we're:
- *   1)  Not associated (4965, no beacon stats being sent to driver)
- *   2)  Scanning (noise measurement does not apply to associated channel)
- *   3)  Receiving CCK (3945 delivers noise info only for OFDM frames)
- * Use default noise value of -127 ... this is below the range of measurable
- *   Rx dBm for either 3945 or 4965, so it can indicate "unmeasurable" to user.
- *   Also, -127 works better than 0 when averaging frames with/without
- *   noise info (e.g. averaging might be done in app); measured dBm values are
- *   always negative ... using a negative value as the default keeps all
- *   averages within an s8's (used in some apps) range of negative values. */
-#define IL_NOISE_MEAS_NOT_AVAILABLE (-127)
-
-/*
- * RTS threshold here is total size [2347] minus 4 FCS bytes
- * Per spec:
- *   a value of 0 means RTS on all data/management packets
- *   a value > max MSDU size means no RTS
- * else RTS for data/management frames where MPDU is larger
- *   than RTS value.
- */
-#define DEFAULT_RTS_THRESHOLD     2347U
-#define MIN_RTS_THRESHOLD         0U
-#define MAX_RTS_THRESHOLD         2347U
-#define MAX_MSDU_SIZE		  2304U
-#define MAX_MPDU_SIZE		  2346U
-#define DEFAULT_BEACON_INTERVAL   100U
-#define	DEFAULT_SHORT_RETRY_LIMIT 7U
-#define	DEFAULT_LONG_RETRY_LIMIT  4U
-
-struct il_rx_buf {
-	dma_addr_t page_dma;
-	struct page *page;
-	struct list_head list;
-};
-
-#define rxb_addr(r) page_address(r->page)
-
-/* defined below */
-struct il_device_cmd;
-
-struct il_cmd_meta {
-	/* only for SYNC commands, iff the reply skb is wanted */
-	struct il_host_cmd *source;
-	/*
-	 * only for ASYNC commands
-	 * (which is somewhat stupid -- look at iwl-sta.c for instance
-	 * which duplicates a bunch of code because the callback isn't
-	 * invoked for SYNC commands, if it were and its result passed
-	 * through it would be simpler...)
-	 */
-	void (*callback)(struct il_priv *il,
-			 struct il_device_cmd *cmd,
-			 struct il_rx_pkt *pkt);
-
-	/* The CMD_SIZE_HUGE flag bit indicates that the command
-	 * structure is stored at the end of the shared queue memory. */
-	u32 flags;
-
-	DEFINE_DMA_UNMAP_ADDR(mapping);
-	DEFINE_DMA_UNMAP_LEN(len);
-};
-
-/*
- * Generic queue structure
- *
- * Contains common data for Rx and Tx queues
- */
-struct il_queue {
-	int n_bd;              /* number of BDs in this queue */
-	int write_ptr;       /* 1-st empty entry (idx) host_w*/
-	int read_ptr;         /* last used entry (idx) host_r*/
-	/* use for monitoring and recovering the stuck queue */
-	dma_addr_t dma_addr;   /* physical addr for BD's */
-	int n_win;	       /* safe queue win */
-	u32 id;
-	int low_mark;	       /* low watermark, resume queue if free
-				* space more than this */
-	int high_mark;         /* high watermark, stop queue if free
-				* space less than this */
-};
-
-/* One for each TFD */
-struct il_tx_info {
-	struct sk_buff *skb;
-	struct il_rxon_context *ctx;
-};
-
-/**
- * struct il_tx_queue - Tx Queue for DMA
- * @q: generic Rx/Tx queue descriptor
- * @bd: base of circular buffer of TFDs
- * @cmd: array of command/TX buffer pointers
- * @meta: array of meta data for each command/tx buffer
- * @dma_addr_cmd: physical address of cmd/tx buffer array
- * @txb: array of per-TFD driver data
- * @time_stamp: time (in jiffies) of last read_ptr change
- * @need_update: indicates need to update read/write idx
- * @sched_retry: indicates queue is high-throughput aggregation (HT AGG) enabled
- *
- * A Tx queue consists of circular buffer of BDs (a.k.a. TFDs, transmit frame
- * descriptors) and required locking structures.
- */
-#define TFD_TX_CMD_SLOTS 256
-#define TFD_CMD_SLOTS 32
-
-struct il_tx_queue {
-	struct il_queue q;
-	void *tfds;
-	struct il_device_cmd **cmd;
-	struct il_cmd_meta *meta;
-	struct il_tx_info *txb;
-	unsigned long time_stamp;
-	u8 need_update;
-	u8 sched_retry;
-	u8 active;
-	u8 swq_id;
-};
-
-#define IL_NUM_SCAN_RATES         (2)
-
-struct il4965_channel_tgd_info {
-	u8 type;
-	s8 max_power;
-};
-
-struct il4965_channel_tgh_info {
-	s64 last_radar_time;
-};
-
-#define IL4965_MAX_RATE (33)
-
-struct il3945_clip_group {
-	/* maximum power level to prevent clipping for each rate, derived by
-	 *   us from this band's saturation power in EEPROM */
-	const s8 clip_powers[IL_MAX_RATES];
-};
-
-/* current Tx power values to use, one for each rate for each channel.
- * requested power is limited by:
- * -- regulatory EEPROM limits for this channel
- * -- hardware capabilities (clip-powers)
- * -- spectrum management
- * -- user preference (e.g. iwconfig)
- * when requested power is set, base power idx must also be set. */
-struct il3945_channel_power_info {
-	struct il3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_idx;	/* actual (compenst'd) idx into gain table */
-	s8 base_power_idx;	/* gain idx for power at factory temp. */
-	s8 requested_power;	/* power (dBm) requested for this chnl/rate */
-};
-
-/* current scan Tx power values to use, one for each scan rate for each
- * channel. */
-struct il3945_scan_power_info {
-	struct il3945_tx_power tpc;	/* actual radio and DSP gain settings */
-	s8 power_table_idx;	/* actual (compenst'd) idx into gain table */
-	s8 requested_power;	/* scan pwr (dBm) requested for chnl/rate */
-};
-
-/*
- * One for each channel, holds all channel setup data
- * Some of the fields (e.g. eeprom and flags/max_power_avg) are redundant
- *     with one another!
- */
-struct il_channel_info {
-	struct il4965_channel_tgd_info tgd;
-	struct il4965_channel_tgh_info tgh;
-	struct il_eeprom_channel eeprom;	/* EEPROM regulatory limit */
-	struct il_eeprom_channel ht40_eeprom;	/* EEPROM regulatory limit for
-						 * HT40 channel */
-
-	u8 channel;	  /* channel number */
-	u8 flags;	  /* flags copied from EEPROM */
-	s8 max_power_avg; /* (dBm) regul. eeprom, normal Tx, any rate */
-	s8 curr_txpow;	  /* (dBm) regulatory/spectrum/user (not h/w) limit */
-	s8 min_power;	  /* always 0 */
-	s8 scan_power;	  /* (dBm) regul. eeprom, direct scans, any rate */
-
-	u8 group_idx;	  /* 0-4, maps channel to group1/2/3/4/5 */
-	u8 band_idx;	  /* 0-4, maps channel to band1/2/3/4/5 */
-	enum ieee80211_band band;
-
-	/* HT40 channel info */
-	s8 ht40_max_power_avg;	/* (dBm) regul. eeprom, normal Tx, any rate */
-	u8 ht40_flags;		/* flags copied from EEPROM */
-	u8 ht40_extension_channel; /* HT_IE_EXT_CHANNEL_* */
-
-	/* Radio/DSP gain settings for each "normal" data Tx rate.
-	 * These include, in addition to RF and DSP gain, a few fields for
-	 *   remembering/modifying gain settings (idxes). */
-	struct il3945_channel_power_info power_info[IL4965_MAX_RATE];
-
-	/* Radio/DSP gain settings for each scan rate, for directed scans. */
-	struct il3945_scan_power_info scan_pwr_info[IL_NUM_SCAN_RATES];
-};
-
-#define IL_TX_FIFO_BK		0	/* shared */
-#define IL_TX_FIFO_BE		1
-#define IL_TX_FIFO_VI		2	/* shared */
-#define IL_TX_FIFO_VO		3
-#define IL_TX_FIFO_UNUSED	-1
-
-/* Minimum number of queues. MAX_NUM is defined in hw specific files.
- * Set the minimum to accommodate the 4 standard TX queues, 1 command
- * queue, 2 (unused) HCCA queues, and 4 HT queues (one for each AC) */
-#define IL_MIN_NUM_QUEUES	10
-
-#define IL_DEFAULT_CMD_QUEUE_NUM	4
-
-#define IEEE80211_DATA_LEN              2304
-#define IEEE80211_4ADDR_LEN             30
-#define IEEE80211_HLEN                  (IEEE80211_4ADDR_LEN)
-#define IEEE80211_FRAME_LEN             (IEEE80211_DATA_LEN + IEEE80211_HLEN)
-
-struct il_frame {
-	union {
-		struct ieee80211_hdr frame;
-		struct il_tx_beacon_cmd beacon;
-		u8 raw[IEEE80211_FRAME_LEN];
-		u8 cmd[360];
-	} u;
-	struct list_head list;
-};
-
-#define SEQ_TO_SN(seq) (((seq) & IEEE80211_SCTL_SEQ) >> 4)
-#define SN_TO_SEQ(ssn) (((ssn) << 4) & IEEE80211_SCTL_SEQ)
-#define MAX_SN ((IEEE80211_SCTL_SEQ) >> 4)
-
-enum {
-	CMD_SYNC = 0,
-	CMD_SIZE_NORMAL = 0,
-	CMD_NO_SKB = 0,
-	CMD_SIZE_HUGE = (1 << 0),
-	CMD_ASYNC = (1 << 1),
-	CMD_WANT_SKB = (1 << 2),
-	CMD_MAPPED = (1 << 3),
-};
-
-#define DEF_CMD_PAYLOAD_SIZE 320
-
-/**
- * struct il_device_cmd
- *
- * For allocation of the command and tx queues, this establishes the overall
- * size of the largest command we send to uCode, except for a scan command
- * (which is relatively huge; space is allocated separately).
- */
-struct il_device_cmd {
-	struct il_cmd_header hdr;	/* uCode API */
-	union {
-		u32 flags;
-		u8 val8;
-		u16 val16;
-		u32 val32;
-		struct il_tx_cmd tx;
-		u8 payload[DEF_CMD_PAYLOAD_SIZE];
-	} __packed cmd;
-} __packed;
-
-#define TFD_MAX_PAYLOAD_SIZE (sizeof(struct il_device_cmd))
-
-
-struct il_host_cmd {
-	const void *data;
-	unsigned long reply_page;
-	void (*callback)(struct il_priv *il,
-			 struct il_device_cmd *cmd,
-			 struct il_rx_pkt *pkt);
-	u32 flags;
-	u16 len;
-	u8 id;
-};
-
-#define SUP_RATE_11A_MAX_NUM_CHANNELS  8
-#define SUP_RATE_11B_MAX_NUM_CHANNELS  4
-#define SUP_RATE_11G_MAX_NUM_CHANNELS  12
-
-/**
- * struct il_rx_queue - Rx queue
- * @bd: driver's pointer to buffer of receive buffer descriptors (rbd)
- * @bd_dma: bus address of buffer of receive buffer descriptors (rbd)
- * @read: Shared idx to newest available Rx buffer
- * @write: Shared idx to oldest written Rx packet
- * @free_count: Number of pre-allocated buffers in rx_free
- * @rx_free: list of free SKBs for use
- * @rx_used: List of Rx buffers with no SKB
- * @need_update: flag to indicate we need to update read/write idx
- * @rb_stts: driver's pointer to receive buffer status
- * @rb_stts_dma: bus address of receive buffer status
- *
- * NOTE:  rx_free and rx_used are used as a FIFO for il_rx_bufs
- */
-struct il_rx_queue {
-	__le32 *bd;
-	dma_addr_t bd_dma;
-	struct il_rx_buf pool[RX_QUEUE_SIZE + RX_FREE_BUFFERS];
-	struct il_rx_buf *queue[RX_QUEUE_SIZE];
-	u32 read;
-	u32 write;
-	u32 free_count;
-	u32 write_actual;
-	struct list_head rx_free;
-	struct list_head rx_used;
-	int need_update;
-	struct il_rb_status *rb_stts;
-	dma_addr_t rb_stts_dma;
-	spinlock_t lock;
-};
-
-#define IL_SUPPORTED_RATES_IE_LEN         8
-
-#define MAX_TID_COUNT        9
-
-#define IL_INVALID_RATE     0xFF
-#define IL_INVALID_VALUE    -1
-
-/**
- * struct il_ht_agg -- aggregation status while waiting for block-ack
- * @txq_id: Tx queue used for Tx attempt
- * @frame_count: # frames attempted by Tx command
- * @wait_for_ba: Expect block-ack before next Tx reply
- * @start_idx: Index of 1st Transmit Frame Descriptor (TFD) in Tx win
- * @bitmap0: Low order bitmap, one bit for each frame pending ACK in Tx win
- * @bitmap1: High order, one bit for each frame pending ACK in Tx win
- * @rate_n_flags: Rate at which Tx was attempted
- *
- * If C_TX indicates that aggregation was attempted, driver must wait
- * for block ack (N_COMPRESSED_BA).  This struct stores tx reply info
- * until block ack arrives.
- */
-struct il_ht_agg {
-	u16 txq_id;
-	u16 frame_count;
-	u16 wait_for_ba;
-	u16 start_idx;
-	u64 bitmap;
-	u32 rate_n_flags;
-#define IL_AGG_OFF 0
-#define IL_AGG_ON 1
-#define IL_EMPTYING_HW_QUEUE_ADDBA 2
-#define IL_EMPTYING_HW_QUEUE_DELBA 3
-	u8 state;
-};
-
-
-struct il_tid_data {
-	u16 seq_number; /* 4965 only */
-	u16 tfds_in_queue;
-	struct il_ht_agg agg;
-};
-
-struct il_hw_key {
-	u32 cipher;
-	int keylen;
-	u8 keyidx;
-	u8 key[32];
-};
-
-union il_ht_rate_supp {
-	u16 rates;
-	struct {
-		u8 siso_rate;
-		u8 mimo_rate;
-	};
-};
-
-#define CFG_HT_RX_AMPDU_FACTOR_8K   (0x0)
-#define CFG_HT_RX_AMPDU_FACTOR_16K  (0x1)
-#define CFG_HT_RX_AMPDU_FACTOR_32K  (0x2)
-#define CFG_HT_RX_AMPDU_FACTOR_64K  (0x3)
-#define CFG_HT_RX_AMPDU_FACTOR_DEF  CFG_HT_RX_AMPDU_FACTOR_64K
-#define CFG_HT_RX_AMPDU_FACTOR_MAX  CFG_HT_RX_AMPDU_FACTOR_64K
-#define CFG_HT_RX_AMPDU_FACTOR_MIN  CFG_HT_RX_AMPDU_FACTOR_8K
-
-/*
- * Maximal MPDU density for TX aggregation
- * 4 - 2us density
- * 5 - 4us density
- * 6 - 8us density
- * 7 - 16us density
- */
-#define CFG_HT_MPDU_DENSITY_2USEC   (0x4)
-#define CFG_HT_MPDU_DENSITY_4USEC   (0x5)
-#define CFG_HT_MPDU_DENSITY_8USEC   (0x6)
-#define CFG_HT_MPDU_DENSITY_16USEC  (0x7)
-#define CFG_HT_MPDU_DENSITY_DEF CFG_HT_MPDU_DENSITY_4USEC
-#define CFG_HT_MPDU_DENSITY_MAX CFG_HT_MPDU_DENSITY_16USEC
-#define CFG_HT_MPDU_DENSITY_MIN     (0x1)
-
-struct il_ht_config {
-	bool single_chain_sufficient;
-	enum ieee80211_smps_mode smps; /* current smps mode */
-};
-
-/* QoS structures */
-struct il_qos_info {
-	int qos_active;
-	struct il_qosparam_cmd def_qos_parm;
-};
-
-/*
- * Structure should be accessed with sta_lock held. When station addition
- * is in progress (IL_STA_UCODE_INPROGRESS) it is possible to access only
- * the commands (il_addsta_cmd and il_link_quality_cmd) without
- * sta_lock held.
- */
-struct il_station_entry {
-	struct il_addsta_cmd sta;
-	struct il_tid_data tid[MAX_TID_COUNT];
-	u8 used, ctxid;
-	struct il_hw_key keyinfo;
-	struct il_link_quality_cmd *lq;
-};
-
-struct il_station_priv_common {
-	struct il_rxon_context *ctx;
-	u8 sta_id;
-};
-
-/*
- * il_station_priv: Driver's ilate station information
- *
- * When mac80211 creates a station it reserves some space (hw->sta_data_size)
- * in the structure for use by driver. This structure is places in that
- * space.
- *
- * The common struct MUST be first because it is shared between
- * 3945 and 4965!
- */
-struct il_station_priv {
-	struct il_station_priv_common common;
-	struct il_lq_sta lq_sta;
-	atomic_t pending_frames;
-	bool client;
-	bool asleep;
-};
-
-/**
- * struct il_vif_priv - driver's ilate per-interface information
- *
- * When mac80211 allocates a virtual interface, it can allocate
- * space for us to put data into.
- */
-struct il_vif_priv {
-	struct il_rxon_context *ctx;
-	u8 ibss_bssid_sta_id;
-};
-
-/* one for each uCode image (inst/data, boot/init/runtime) */
-struct fw_desc {
-	void *v_addr;		/* access by driver */
-	dma_addr_t p_addr;	/* access by card's busmaster DMA */
-	u32 len;		/* bytes */
-};
-
-/* uCode file layout */
-struct il_ucode_header {
-	__le32 ver;	/* major/minor/API/serial */
-	struct {
-		__le32 inst_size;	/* bytes of runtime code */
-		__le32 data_size;	/* bytes of runtime data */
-		__le32 init_size;	/* bytes of init code */
-		__le32 init_data_size;	/* bytes of init data */
-		__le32 boot_size;	/* bytes of bootstrap code */
-		u8 data[0];		/* in same order as sizes */
-	} v1;
-};
-
-struct il4965_ibss_seq {
-	u8 mac[ETH_ALEN];
-	u16 seq_num;
-	u16 frag_num;
-	unsigned long packet_time;
-	struct list_head list;
-};
-
-struct il_sensitivity_ranges {
-	u16 min_nrg_cck;
-	u16 max_nrg_cck;
-
-	u16 nrg_th_cck;
-	u16 nrg_th_ofdm;
-
-	u16 auto_corr_min_ofdm;
-	u16 auto_corr_min_ofdm_mrc;
-	u16 auto_corr_min_ofdm_x1;
-	u16 auto_corr_min_ofdm_mrc_x1;
-
-	u16 auto_corr_max_ofdm;
-	u16 auto_corr_max_ofdm_mrc;
-	u16 auto_corr_max_ofdm_x1;
-	u16 auto_corr_max_ofdm_mrc_x1;
-
-	u16 auto_corr_max_cck;
-	u16 auto_corr_max_cck_mrc;
-	u16 auto_corr_min_cck;
-	u16 auto_corr_min_cck_mrc;
-
-	u16 barker_corr_th_min;
-	u16 barker_corr_th_min_mrc;
-	u16 nrg_th_cca;
-};
-
-
-#define KELVIN_TO_CELSIUS(x) ((x)-273)
-#define CELSIUS_TO_KELVIN(x) ((x)+273)
-
-
-/**
- * struct il_hw_params
- * @max_txq_num: Max # Tx queues supported
- * @dma_chnl_num: Number of Tx DMA/FIFO channels
- * @scd_bc_tbls_size: size of scheduler byte count tables
- * @tfd_size: TFD size
- * @tx/rx_chains_num: Number of TX/RX chains
- * @valid_tx/rx_ant: usable antennas
- * @max_rxq_size: Max # Rx frames in Rx queue (must be power-of-2)
- * @max_rxq_log: Log-base-2 of max_rxq_size
- * @rx_page_order: Rx buffer page order
- * @rx_wrt_ptr_reg: FH{39}_RSCSR_CHNL0_WPTR
- * @max_stations:
- * @ht40_channel: is 40MHz width possible in band 2.4
- * BIT(IEEE80211_BAND_5GHZ) BIT(IEEE80211_BAND_5GHZ)
- * @sw_crypto: 0 for hw, 1 for sw
- * @max_xxx_size: for ucode uses
- * @ct_kill_threshold: temperature threshold
- * @beacon_time_tsf_bits: number of valid tsf bits for beacon time
- * @struct il_sensitivity_ranges: range of sensitivity values
- */
-struct il_hw_params {
-	u8 max_txq_num;
-	u8 dma_chnl_num;
-	u16 scd_bc_tbls_size;
-	u32 tfd_size;
-	u8  tx_chains_num;
-	u8  rx_chains_num;
-	u8  valid_tx_ant;
-	u8  valid_rx_ant;
-	u16 max_rxq_size;
-	u16 max_rxq_log;
-	u32 rx_page_order;
-	u32 rx_wrt_ptr_reg;
-	u8  max_stations;
-	u8  ht40_channel;
-	u8  max_beacon_itrvl;	/* in 1024 ms */
-	u32 max_inst_size;
-	u32 max_data_size;
-	u32 max_bsm_size;
-	u32 ct_kill_threshold; /* value in hw-dependent units */
-	u16 beacon_time_tsf_bits;
-	const struct il_sensitivity_ranges *sens;
-};
-
-
-/******************************************************************************
- *
- * Functions implemented in core module which are forward declared here
- * for use by iwl-[4-5].c
- *
- * NOTE:  The implementation of these functions are not hardware specific
- * which is why they are in the core module files.
- *
- * Naming convention --
- * il_         <-- Is part of iwlwifi
- * iwlXXXX_     <-- Hardware specific (implemented in iwl-XXXX.c for XXXX)
- * il4965_bg_      <-- Called from work queue context
- * il4965_mac_     <-- mac80211 callback
- *
- ****************************************************************************/
-extern void il4965_update_chain_flags(struct il_priv *il);
-extern const u8 il_bcast_addr[ETH_ALEN];
-extern int il_queue_space(const struct il_queue *q);
-static inline int il_queue_used(const struct il_queue *q, int i)
-{
-	return q->write_ptr >= q->read_ptr ?
-		(i >= q->read_ptr && i < q->write_ptr) :
-		!(i < q->read_ptr && i >= q->write_ptr);
-}
-
-
-static inline u8 il_get_cmd_idx(struct il_queue *q, u32 idx,
-								int is_huge)
-{
-	/*
-	 * This is for init calibration result and scan command which
-	 * required buffer > TFD_MAX_PAYLOAD_SIZE,
-	 * the big buffer at end of command array
-	 */
-	if (is_huge)
-		return q->n_win;	/* must be power of 2 */
-
-	/* Otherwise, use normal size buffers */
-	return idx & (q->n_win - 1);
-}
-
-
-struct il_dma_ptr {
-	dma_addr_t dma;
-	void *addr;
-	size_t size;
-};
-
-#define IL_OPERATION_MODE_AUTO     0
-#define IL_OPERATION_MODE_HT_ONLY  1
-#define IL_OPERATION_MODE_MIXED    2
-#define IL_OPERATION_MODE_20MHZ    3
-
-#define IL_TX_CRC_SIZE 4
-#define IL_TX_DELIMITER_SIZE 4
-
-#define TX_POWER_IL_ILLEGAL_VOLTAGE -10000
-
-/* Sensitivity and chain noise calibration */
-#define INITIALIZATION_VALUE		0xFFFF
-#define IL4965_CAL_NUM_BEACONS		20
-#define IL_CAL_NUM_BEACONS		16
-#define MAXIMUM_ALLOWED_PATHLOSS	15
-
-#define CHAIN_NOISE_MAX_DELTA_GAIN_CODE 3
-
-#define MAX_FA_OFDM  50
-#define MIN_FA_OFDM  5
-#define MAX_FA_CCK   50
-#define MIN_FA_CCK   5
-
-#define AUTO_CORR_STEP_OFDM       1
-
-#define AUTO_CORR_STEP_CCK     3
-#define AUTO_CORR_MAX_TH_CCK   160
-
-#define NRG_DIFF               2
-#define NRG_STEP_CCK           2
-#define NRG_MARGIN             8
-#define MAX_NUMBER_CCK_NO_FA 100
-
-#define AUTO_CORR_CCK_MIN_VAL_DEF    (125)
-
-#define CHAIN_A             0
-#define CHAIN_B             1
-#define CHAIN_C             2
-#define CHAIN_NOISE_DELTA_GAIN_INIT_VAL 4
-#define ALL_BAND_FILTER			0xFF00
-#define IN_BAND_FILTER			0xFF
-#define MIN_AVERAGE_NOISE_MAX_VALUE	0xFFFFFFFF
-
-#define NRG_NUM_PREV_STAT_L     20
-#define NUM_RX_CHAINS           3
-
-enum il4965_false_alarm_state {
-	IL_FA_TOO_MANY = 0,
-	IL_FA_TOO_FEW = 1,
-	IL_FA_GOOD_RANGE = 2,
-};
-
-enum il4965_chain_noise_state {
-	IL_CHAIN_NOISE_ALIVE = 0,  /* must be 0 */
-	IL_CHAIN_NOISE_ACCUMULATE,
-	IL_CHAIN_NOISE_CALIBRATED,
-	IL_CHAIN_NOISE_DONE,
-};
-
-enum il4965_calib_enabled_state {
-	IL_CALIB_DISABLED = 0,  /* must be 0 */
-	IL_CALIB_ENABLED = 1,
-};
-
-/*
- * enum il_calib
- * defines the order in which results of initial calibrations
- * should be sent to the runtime uCode
- */
-enum il_calib {
-	IL_CALIB_MAX,
-};
-
-/* Opaque calibration results */
-struct il_calib_result {
-	void *buf;
-	size_t buf_len;
-};
-
-enum ucode_type {
-	UCODE_NONE = 0,
-	UCODE_INIT,
-	UCODE_RT
-};
-
-/* Sensitivity calib data */
-struct il_sensitivity_data {
-	u32 auto_corr_ofdm;
-	u32 auto_corr_ofdm_mrc;
-	u32 auto_corr_ofdm_x1;
-	u32 auto_corr_ofdm_mrc_x1;
-	u32 auto_corr_cck;
-	u32 auto_corr_cck_mrc;
-
-	u32 last_bad_plcp_cnt_ofdm;
-	u32 last_fa_cnt_ofdm;
-	u32 last_bad_plcp_cnt_cck;
-	u32 last_fa_cnt_cck;
-
-	u32 nrg_curr_state;
-	u32 nrg_prev_state;
-	u32 nrg_value[10];
-	u8  nrg_silence_rssi[NRG_NUM_PREV_STAT_L];
-	u32 nrg_silence_ref;
-	u32 nrg_energy_idx;
-	u32 nrg_silence_idx;
-	u32 nrg_th_cck;
-	s32 nrg_auto_corr_silence_diff;
-	u32 num_in_cck_no_fa;
-	u32 nrg_th_ofdm;
-
-	u16 barker_corr_th_min;
-	u16 barker_corr_th_min_mrc;
-	u16 nrg_th_cca;
-};
-
-/* Chain noise (differential Rx gain) calib data */
-struct il_chain_noise_data {
-	u32 active_chains;
-	u32 chain_noise_a;
-	u32 chain_noise_b;
-	u32 chain_noise_c;
-	u32 chain_signal_a;
-	u32 chain_signal_b;
-	u32 chain_signal_c;
-	u16 beacon_count;
-	u8 disconn_array[NUM_RX_CHAINS];
-	u8 delta_gain_code[NUM_RX_CHAINS];
-	u8 radio_write;
-	u8 state;
-};
-
-#define	EEPROM_SEM_TIMEOUT 10		/* milliseconds */
-#define EEPROM_SEM_RETRY_LIMIT 1000	/* number of attempts (not time) */
-
-#define IL_TRAFFIC_ENTRIES	(256)
-#define IL_TRAFFIC_ENTRY_SIZE  (64)
-
-enum {
-	MEASUREMENT_READY = (1 << 0),
-	MEASUREMENT_ACTIVE = (1 << 1),
-};
-
-/* interrupt stats */
-struct isr_stats {
-	u32 hw;
-	u32 sw;
-	u32 err_code;
-	u32 sch;
-	u32 alive;
-	u32 rfkill;
-	u32 ctkill;
-	u32 wakeup;
-	u32 rx;
-	u32 handlers[IL_CN_MAX];
-	u32 tx;
-	u32 unhandled;
-};
-
-/* management stats */
-enum il_mgmt_stats {
-	MANAGEMENT_ASSOC_REQ = 0,
-	MANAGEMENT_ASSOC_RESP,
-	MANAGEMENT_REASSOC_REQ,
-	MANAGEMENT_REASSOC_RESP,
-	MANAGEMENT_PROBE_REQ,
-	MANAGEMENT_PROBE_RESP,
-	MANAGEMENT_BEACON,
-	MANAGEMENT_ATIM,
-	MANAGEMENT_DISASSOC,
-	MANAGEMENT_AUTH,
-	MANAGEMENT_DEAUTH,
-	MANAGEMENT_ACTION,
-	MANAGEMENT_MAX,
-};
-/* control stats */
-enum il_ctrl_stats {
-	CONTROL_BACK_REQ =  0,
-	CONTROL_BACK,
-	CONTROL_PSPOLL,
-	CONTROL_RTS,
-	CONTROL_CTS,
-	CONTROL_ACK,
-	CONTROL_CFEND,
-	CONTROL_CFENDACK,
-	CONTROL_MAX,
-};
-
-struct traffic_stats {
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-	u32 mgmt[MANAGEMENT_MAX];
-	u32 ctrl[CONTROL_MAX];
-	u32 data_cnt;
-	u64 data_bytes;
-#endif
-};
-
-/*
- * host interrupt timeout value
- * used with setting interrupt coalescing timer
- * the CSR_INT_COALESCING is an 8 bit register in 32-usec unit
- *
- * default interrupt coalescing timer is 64 x 32 = 2048 usecs
- * default interrupt coalescing calibration timer is 16 x 32 = 512 usecs
- */
-#define IL_HOST_INT_TIMEOUT_MAX	(0xFF)
-#define IL_HOST_INT_TIMEOUT_DEF	(0x40)
-#define IL_HOST_INT_TIMEOUT_MIN	(0x0)
-#define IL_HOST_INT_CALIB_TIMEOUT_MAX	(0xFF)
-#define IL_HOST_INT_CALIB_TIMEOUT_DEF	(0x10)
-#define IL_HOST_INT_CALIB_TIMEOUT_MIN	(0x0)
-
-#define IL_DELAY_NEXT_FORCE_FW_RELOAD (HZ*5)
-
-/* TX queue watchdog timeouts in mSecs */
-#define IL_DEF_WD_TIMEOUT	(2000)
-#define IL_LONG_WD_TIMEOUT	(10000)
-#define IL_MAX_WD_TIMEOUT	(120000)
-
-struct il_force_reset {
-	int reset_request_count;
-	int reset_success_count;
-	int reset_reject_count;
-	unsigned long reset_duration;
-	unsigned long last_force_reset_jiffies;
-};
-
-/* extend beacon time format bit shifting  */
-/*
- * for _3945 devices
- * bits 31:24 - extended
- * bits 23:0  - interval
- */
-#define IL3945_EXT_BEACON_TIME_POS	24
-/*
- * for _4965 devices
- * bits 31:22 - extended
- * bits 21:0  - interval
- */
-#define IL4965_EXT_BEACON_TIME_POS	22
-
-struct il_rxon_context {
-	struct ieee80211_vif *vif;
-
-	const u8 *ac_to_fifo;
-	const u8 *ac_to_queue;
-	u8 mcast_queue;
-
-	/*
-	 * We could use the vif to indicate active, but we
-	 * also need it to be active during disabling when
-	 * we already removed the vif for type setting.
-	 */
-	bool always_active, is_active;
-
-	bool ht_need_multiple_chains;
-
-	int ctxid;
-
-	u32 interface_modes, exclusive_interface_modes;
-	u8 unused_devtype, ap_devtype, ibss_devtype, station_devtype;
-
-	/*
-	 * We declare this const so it can only be
-	 * changed via explicit cast within the
-	 * routines that actually update the physical
-	 * hardware.
-	 */
-	const struct il_rxon_cmd active;
-	struct il_rxon_cmd staging;
-
-	struct il_rxon_time_cmd timing;
-
-	struct il_qos_info qos_data;
-
-	u8 bcast_sta_id, ap_sta_id;
-
-	u8 rxon_cmd, rxon_assoc_cmd, rxon_timing_cmd;
-	u8 qos_cmd;
-	u8 wep_key_cmd;
-
-	struct il_wep_key wep_keys[WEP_KEYS_MAX];
-	u8 key_mapping_keys;
-
-	__le32 station_flags;
-
-	struct {
-		bool non_gf_sta_present;
-		u8 protection;
-		bool enabled, is_40mhz;
-		u8 extension_chan_offset;
-	} ht;
-};
-
-struct il_priv {
-
-	/* ieee device used by generic ieee processing code */
-	struct ieee80211_hw *hw;
-	struct ieee80211_channel *ieee_channels;
-	struct ieee80211_rate *ieee_rates;
-	struct il_cfg *cfg;
-
-	/* temporary frame storage list */
-	struct list_head free_frames;
-	int frames_count;
-
-	enum ieee80211_band band;
-	int alloc_rxb_page;
-
-	void (*handlers[IL_CN_MAX])(struct il_priv *il,
-				       struct il_rx_buf *rxb);
-
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
-
-	/* spectrum measurement report caching */
-	struct il_spectrum_notification measure_report;
-	u8 measurement_status;
-
-	/* ucode beacon time */
-	u32 ucode_beacon_time;
-	int missed_beacon_threshold;
-
-	/* track IBSS manager (last beacon) status */
-	u32 ibss_manager;
-
-	/* force reset */
-	struct il_force_reset force_reset;
-
-	/* we allocate array of il_channel_info for NIC's valid channels.
-	 *    Access via channel # using indirect idx array */
-	struct il_channel_info *channel_info;	/* channel info array */
-	u8 channel_count;	/* # of channels */
-
-	/* thermal calibration */
-	s32 temperature;	/* degrees Kelvin */
-	s32 last_temperature;
-
-	/* init calibration results */
-	struct il_calib_result calib_results[IL_CALIB_MAX];
-
-	/* Scan related variables */
-	unsigned long scan_start;
-	unsigned long scan_start_tsf;
-	void *scan_cmd;
-	enum ieee80211_band scan_band;
-	struct cfg80211_scan_request *scan_request;
-	struct ieee80211_vif *scan_vif;
-	u8 scan_tx_ant[IEEE80211_NUM_BANDS];
-	u8 mgmt_tx_ant;
-
-	/* spinlock */
-	spinlock_t lock;	/* protect general shared data */
-	spinlock_t hcmd_lock;	/* protect hcmd */
-	spinlock_t reg_lock;	/* protect hw register access */
-	struct mutex mutex;
-
-	/* basic pci-network driver stuff */
-	struct pci_dev *pci_dev;
-
-	/* pci hardware address support */
-	void __iomem *hw_base;
-	u32  hw_rev;
-	u32  hw_wa_rev;
-	u8   rev_id;
-
-	/* command queue number */
-	u8 cmd_queue;
-
-	/* max number of station keys */
-	u8 sta_key_max_num;
-
-	/* EEPROM MAC addresses */
-	struct mac_address addresses[1];
-
-	/* uCode images, save to reload in case of failure */
-	int fw_idx;			/* firmware we're trying to load */
-	u32 ucode_ver;			/* version of ucode, copy of
-					   il_ucode.ver */
-	struct fw_desc ucode_code;	/* runtime inst */
-	struct fw_desc ucode_data;	/* runtime data original */
-	struct fw_desc ucode_data_backup;	/* runtime data save/restore */
-	struct fw_desc ucode_init;	/* initialization inst */
-	struct fw_desc ucode_init_data;	/* initialization data */
-	struct fw_desc ucode_boot;	/* bootstrap inst */
-	enum ucode_type ucode_type;
-	u8 ucode_write_complete;	/* the image write is complete */
-	char firmware_name[25];
-
-	struct il_rxon_context ctx;
-
-	__le16 switch_channel;
-
-	/* 1st responses from initialize and runtime uCode images.
-	 * _4965's initialize alive response contains some calibration data. */
-	struct il_init_alive_resp card_alive_init;
-	struct il_alive_resp card_alive;
-
-	u16 active_rate;
-
-	u8 start_calib;
-	struct il_sensitivity_data sensitivity_data;
-	struct il_chain_noise_data chain_noise_data;
-	__le16 sensitivity_tbl[HD_TBL_SIZE];
-
-	struct il_ht_config current_ht_config;
-
-	/* Rate scaling data */
-	u8 retry_rate;
-
-	wait_queue_head_t wait_command_queue;
-
-	int activity_timer_active;
-
-	/* Rx and Tx DMA processing queues */
-	struct il_rx_queue rxq;
-	struct il_tx_queue *txq;
-	unsigned long txq_ctx_active_msk;
-	struct il_dma_ptr  kw;	/* keep warm address */
-	struct il_dma_ptr  scd_bc_tbls;
-
-	u32 scd_base_addr;	/* scheduler sram base address */
-
-	unsigned long status;
-
-	/* counts mgmt, ctl, and data packets */
-	struct traffic_stats tx_stats;
-	struct traffic_stats rx_stats;
-
-	/* counts interrupts */
-	struct isr_stats isr_stats;
-
-	struct il_power_mgr power_data;
-
-	/* context information */
-	u8 bssid[ETH_ALEN]; /* used only on 3945 but filled by core */
-
-	/* station table variables */
-
-	/* Note: if lock and sta_lock are needed, lock must be acquired first */
-	spinlock_t sta_lock;
-	int num_stations;
-	struct il_station_entry stations[IL_STATION_COUNT];
-	unsigned long ucode_key_table;
-
-	/* queue refcounts */
-#define IL_MAX_HW_QUEUES	32
-	unsigned long queue_stopped[BITS_TO_LONGS(IL_MAX_HW_QUEUES)];
-	/* for each AC */
-	atomic_t queue_stop_count[4];
-
-	/* Indication if ieee80211_ops->open has been called */
-	u8 is_open;
-
-	u8 mac80211_registered;
-
-	/* eeprom -- this is in the card's little endian byte order */
-	u8 *eeprom;
-	struct il_eeprom_calib_info *calib_info;
-
-	enum nl80211_iftype iw_mode;
-
-	/* Last Rx'd beacon timestamp */
-	u64 timestamp;
-
-	union {
-#if defined(CONFIG_IWL3945) || defined(CONFIG_IWL3945_MODULE)
-		struct {
-			void *shared_virt;
-			dma_addr_t shared_phys;
-
-			struct delayed_work thermal_periodic;
-			struct delayed_work rfkill_poll;
-
-			struct il3945_notif_stats stats;
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-			struct il3945_notif_stats accum_stats;
-			struct il3945_notif_stats delta_stats;
-			struct il3945_notif_stats max_delta;
-#endif
-
-			u32 sta_supp_rates;
-			int last_rx_rssi;	/* From Rx packet stats */
-
-			/* Rx'd packet timing information */
-			u32 last_beacon_time;
-			u64 last_tsf;
-
-			/*
-			 * each calibration channel group in the
-			 * EEPROM has a derived clip setting for
-			 * each rate.
-			 */
-			const struct il3945_clip_group clip_groups[5];
-
-		} _3945;
-#endif
-#if defined(CONFIG_IWL4965) || defined(CONFIG_IWL4965_MODULE)
-		struct {
-			struct il_rx_phy_res last_phy_res;
-			bool last_phy_res_valid;
-
-			struct completion firmware_loading_complete;
-
-			/*
-			 * chain noise reset and gain commands are the
-			 * two extra calibration commands follows the standard
-			 * phy calibration commands
-			 */
-			u8 phy_calib_chain_noise_reset_cmd;
-			u8 phy_calib_chain_noise_gain_cmd;
-
-			struct il_notif_stats stats;
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-			struct il_notif_stats accum_stats;
-			struct il_notif_stats delta_stats;
-			struct il_notif_stats max_delta;
-#endif
-
-		} _4965;
-#endif
-	};
-
-	struct il_hw_params hw_params;
-
-	u32 inta_mask;
-
-	struct workqueue_struct *workqueue;
-
-	struct work_struct restart;
-	struct work_struct scan_completed;
-	struct work_struct rx_replenish;
-	struct work_struct abort_scan;
-
-	struct il_rxon_context *beacon_ctx;
-	struct sk_buff *beacon_skb;
-
-	struct work_struct tx_flush;
-
-	struct tasklet_struct irq_tasklet;
-
-	struct delayed_work init_alive_start;
-	struct delayed_work alive_start;
-	struct delayed_work scan_check;
-
-	/* TX Power */
-	s8 tx_power_user_lmt;
-	s8 tx_power_device_lmt;
-	s8 tx_power_next;
-
-
-#ifdef CONFIG_IWLEGACY_DEBUG
-	/* debugging info */
-	u32 debug_level; /* per device debugging will override global
-			    il_debug_level if set */
-#endif /* CONFIG_IWLEGACY_DEBUG */
-#ifdef CONFIG_IWLEGACY_DEBUGFS
-	/* debugfs */
-	u16 tx_traffic_idx;
-	u16 rx_traffic_idx;
-	u8 *tx_traffic;
-	u8 *rx_traffic;
-	struct dentry *debugfs_dir;
-	u32 dbgfs_sram_offset, dbgfs_sram_len;
-	bool disable_ht40;
-#endif /* CONFIG_IWLEGACY_DEBUGFS */
-
-	struct work_struct txpower_work;
-	u32 disable_sens_cal;
-	u32 disable_chain_noise_cal;
-	u32 disable_tx_power_cal;
-	struct work_struct run_time_calib_work;
-	struct timer_list stats_periodic;
-	struct timer_list watchdog;
-	bool hw_ready;
-
-	struct led_classdev led;
-	unsigned long blink_on, blink_off;
-	bool led_registered;
-}; /*il_priv */
-
-static inline void il_txq_ctx_activate(struct il_priv *il, int txq_id)
-{
-	set_bit(txq_id, &il->txq_ctx_active_msk);
-}
-
-static inline void il_txq_ctx_deactivate(struct il_priv *il, int txq_id)
-{
-	clear_bit(txq_id, &il->txq_ctx_active_msk);
-}
-
-#ifdef CONFIG_IWLEGACY_DEBUG
-/*
- * il_get_debug_level: Return active debug level for device
- *
- * Using sysfs it is possible to set per device debug level. This debug
- * level will be used if set, otherwise the global debug level which can be
- * set via module parameter is used.
- */
-static inline u32 il_get_debug_level(struct il_priv *il)
-{
-	if (il->debug_level)
-		return il->debug_level;
-	else
-		return il_debug_level;
-}
-#else
-static inline u32 il_get_debug_level(struct il_priv *il)
-{
-	return il_debug_level;
-}
-#endif
-
-
-static inline struct ieee80211_hdr *
-il_tx_queue_get_hdr(struct il_priv *il,
-						 int txq_id, int idx)
-{
-	if (il->txq[txq_id].txb[idx].skb)
-		return (struct ieee80211_hdr *)il->txq[txq_id].
-				txb[idx].skb->data;
-	return NULL;
-}
-
-static inline struct il_rxon_context *
-il_rxon_ctx_from_vif(struct ieee80211_vif *vif)
-{
-	struct il_vif_priv *vif_priv = (void *)vif->drv_priv;
-
-	return vif_priv->ctx;
-}
-
-#define for_each_context(il, _ctx) \
-	for (_ctx = &il->ctx; _ctx == &il->ctx; _ctx++)
-
-static inline int il_is_associated(struct il_priv *il)
-{
-	return (il->ctx.active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
-}
-
-static inline int il_is_any_associated(struct il_priv *il)
-{
-	return il_is_associated(il);
-}
-
-static inline int il_is_associated_ctx(struct il_rxon_context *ctx)
-{
-	return (ctx->active.filter_flags & RXON_FILTER_ASSOC_MSK) ? 1 : 0;
-}
-
-static inline int il_is_channel_valid(const struct il_channel_info *ch_info)
-{
-	if (ch_info == NULL)
-		return 0;
-	return (ch_info->flags & EEPROM_CHANNEL_VALID) ? 1 : 0;
-}
-
-static inline int il_is_channel_radar(const struct il_channel_info *ch_info)
-{
-	return (ch_info->flags & EEPROM_CHANNEL_RADAR) ? 1 : 0;
-}
-
-static inline u8 il_is_channel_a_band(const struct il_channel_info *ch_info)
-{
-	return ch_info->band == IEEE80211_BAND_5GHZ;
-}
-
-static inline int
-il_is_channel_passive(const struct il_channel_info *ch)
-{
-	return (!(ch->flags & EEPROM_CHANNEL_ACTIVE)) ? 1 : 0;
-}
-
-static inline int
-il_is_channel_ibss(const struct il_channel_info *ch)
-{
-	return (ch->flags & EEPROM_CHANNEL_IBSS) ? 1 : 0;
-}
-
-static inline void
-__il_free_pages(struct il_priv *il, struct page *page)
-{
-	__free_pages(page, il->hw_params.rx_page_order);
-	il->alloc_rxb_page--;
-}
-
-static inline void il_free_pages(struct il_priv *il, unsigned long page)
-{
-	free_pages(page, il->hw_params.rx_page_order);
-	il->alloc_rxb_page--;
-}
-#endif				/* __il_dev_h__ */
diff --git a/drivers/net/wireless/iwlegacy/iwl-fh.h b/drivers/net/wireless/iwlegacy/iwl-fh.h
index f53f1b8..7846bae 100644
--- a/drivers/net/wireless/iwlegacy/iwl-fh.h
+++ b/drivers/net/wireless/iwlegacy/iwl-fh.h
@@ -266,8 +266,6 @@
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_NO_INT_VAL    (0x00000000)
 #define FH_RCSR_CHNL0_RX_CONFIG_IRQ_DEST_INT_HOST_VAL  (0x00001000)
 
-#define FH_RSCSR_FRAME_SIZE_MSK	(0x00003FFF)	/* bits 0-13 */
-
 /**
  * Rx Shared Status Registers (RSSR)
  *
@@ -413,100 +411,6 @@
  */
 #define FH_TX_CHICKEN_BITS_SCD_AUTO_RETRY_EN	(0x00000002)
 
-#define RX_QUEUE_SIZE                         256
-#define RX_QUEUE_MASK                         255
-#define RX_QUEUE_SIZE_LOG                     8
-
-/*
- * RX related structures and functions
- */
-#define RX_FREE_BUFFERS 64
-#define RX_LOW_WATERMARK 8
-
-/* Size of one Rx buffer in host DRAM */
-#define IL_RX_BUF_SIZE_3K (3 * 1000) /* 3945 only */
-#define IL_RX_BUF_SIZE_4K (4 * 1024)
-#define IL_RX_BUF_SIZE_8K (8 * 1024)
-
-/**
- * struct il_rb_status - reseve buffer status
- * 	host memory mapped FH registers
- * @closed_rb_num [0:11] - Indicates the idx of the RB which was closed
- * @closed_fr_num [0:11] - Indicates the idx of the RX Frame which was closed
- * @finished_rb_num [0:11] - Indicates the idx of the current RB
- * 	in which the last frame was written to
- * @finished_fr_num [0:11] - Indicates the idx of the RX Frame
- * 	which was transferred
- */
-struct il_rb_status {
-	__le16 closed_rb_num;
-	__le16 closed_fr_num;
-	__le16 finished_rb_num;
-	__le16 finished_fr_nam;
-	__le32 __unused; /* 3945 only */
-} __packed;
-
-
-#define TFD_QUEUE_SIZE_MAX      (256)
-#define TFD_QUEUE_SIZE_BC_DUP	(64)
-#define TFD_QUEUE_BC_SIZE	(TFD_QUEUE_SIZE_MAX + TFD_QUEUE_SIZE_BC_DUP)
-#define IL_TX_DMA_MASK        DMA_BIT_MASK(36)
-#define IL_NUM_OF_TBS		20
-
-static inline u8 il_get_dma_hi_addr(dma_addr_t addr)
-{
-	return (sizeof(addr) > sizeof(u32) ? (addr >> 16) >> 16 : 0) & 0xF;
-}
-/**
- * struct il_tfd_tb transmit buffer descriptor within transmit frame descriptor
- *
- * This structure contains dma address and length of transmission address
- *
- * @lo: low [31:0] portion of the dma address of TX buffer
- * 	every even is unaligned on 16 bit boundary
- * @hi_n_len 0-3 [35:32] portion of dma
- *	     4-15 length of the tx buffer
- */
-struct il_tfd_tb {
-	__le32 lo;
-	__le16 hi_n_len;
-} __packed;
-
-/**
- * struct il_tfd
- *
- * Transmit Frame Descriptor (TFD)
- *
- * @ __reserved1[3] reserved
- * @ num_tbs 0-4 number of active tbs
- *	     5   reserved
- * 	     6-7 padding (not used)
- * @ tbs[20]	transmit frame buffer descriptors
- * @ __pad 	padding
- *
- * Each Tx queue uses a circular buffer of 256 TFDs stored in host DRAM.
- * Both driver and device share these circular buffers, each of which must be
- * contiguous 256 TFDs x 128 bytes-per-TFD = 32 KBytes
- *
- * Driver must indicate the physical address of the base of each
- * circular buffer via the FH_MEM_CBBC_QUEUE registers.
- *
- * Each TFD contains pointer/size information for up to 20 data buffers
- * in host DRAM.  These buffers collectively contain the (one) frame described
- * by the TFD.  Each buffer must be a single contiguous block of memory within
- * itself, but buffers may be scattered in host DRAM.  Each buffer has max size
- * of (4K - 4).  The concatenates all of a TFD's buffers into a single
- * Tx frame, up to 8 KBytes in size.
- *
- * A maximum of 255 (not 256!) TFDs may be on a queue waiting for Tx.
- */
-struct il_tfd {
-	u8 __reserved1[3];
-	u8 num_tbs;
-	struct il_tfd_tb tbs[IL_NUM_OF_TBS];
-	__le32 __pad;
-} __packed;
-
 /* Keep Warm Size */
 #define IL_KW_SIZE 0x1000	/* 4k */
 
diff --git a/drivers/net/wireless/iwlegacy/iwl-io.h b/drivers/net/wireless/iwlegacy/iwl-io.h
deleted file mode 100644
index 9d33da8..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-io.h
+++ /dev/null
@@ -1,337 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project.
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
-#ifndef __il_io_h__
-#define __il_io_h__
-
-#include <linux/io.h>
-
-#include "iwl-dev.h"
-#include "iwl-debug.h"
-
-static inline void _il_write8(struct il_priv *il, u32 ofs, u8 val)
-{
-	iowrite8(val, il->hw_base + ofs);
-}
-#define il_write8(il, ofs, val) _il_write8(il, ofs, val)
-
-static inline void _il_wr(struct il_priv *il, u32 ofs, u32 val)
-{
-	iowrite32(val, il->hw_base + ofs);
-}
-
-static inline u32 _il_rd(struct il_priv *il, u32 ofs)
-{
-	return ioread32(il->hw_base + ofs);
-}
-
-#define IL_POLL_INTERVAL 10	/* microseconds */
-static inline int
-_il_poll_bit(struct il_priv *il, u32 addr,
-				u32 bits, u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((_il_rd(il, addr) & mask) == (bits & mask))
-			return t;
-		udelay(IL_POLL_INTERVAL);
-		t += IL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
-static inline void _il_set_bit(struct il_priv *il, u32 reg, u32 mask)
-{
-	_il_wr(il, reg, _il_rd(il, reg) | mask);
-}
-
-static inline void il_set_bit(struct il_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	_il_set_bit(p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-
-static inline void
-_il_clear_bit(struct il_priv *il, u32 reg, u32 mask)
-{
-	_il_wr(il, reg, _il_rd(il, reg) & ~mask);
-}
-
-static inline void il_clear_bit(struct il_priv *p, u32 r, u32 m)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&p->reg_lock, reg_flags);
-	_il_clear_bit(p, r, m);
-	spin_unlock_irqrestore(&p->reg_lock, reg_flags);
-}
-
-static inline int _il_grab_nic_access(struct il_priv *il)
-{
-	int ret;
-	u32 val;
-
-	/* this bit wakes up the NIC */
-	_il_set_bit(il, CSR_GP_CNTRL,
-				CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-
-	/*
-	 * These bits say the device is running, and should keep running for
-	 * at least a short while (at least as long as MAC_ACCESS_REQ stays 1),
-	 * but they do not indicate that embedded SRAM is restored yet;
-	 * 3945 and 4965 have volatile SRAM, and must save/restore contents
-	 * to/from host DRAM when sleeping/waking for power-saving.
-	 * Each direction takes approximately 1/4 millisecond; with this
-	 * overhead, it's a good idea to grab and hold MAC_ACCESS_REQUEST if a
-	 * series of register accesses are expected (e.g. reading Event Log),
-	 * to keep device from sleeping.
-	 *
-	 * CSR_UCODE_DRV_GP1 register bit MAC_SLEEP == 0 indicates that
-	 * SRAM is okay/restored.  We don't check that here because this call
-	 * is just for hardware register access; but GP1 MAC_SLEEP check is a
-	 * good idea before accessing 3945/4965 SRAM (e.g. reading Event Log).
-	 *
-	 */
-	ret = _il_poll_bit(il, CSR_GP_CNTRL,
-			   CSR_GP_CNTRL_REG_VAL_MAC_ACCESS_EN,
-			   (CSR_GP_CNTRL_REG_FLAG_MAC_CLOCK_READY |
-			    CSR_GP_CNTRL_REG_FLAG_GOING_TO_SLEEP), 15000);
-	if (ret < 0) {
-		val = _il_rd(il, CSR_GP_CNTRL);
-		IL_ERR(
-			"MAC is in deep sleep!.  CSR_GP_CNTRL = 0x%08X\n", val);
-		_il_wr(il, CSR_RESET,
-				CSR_RESET_REG_FLAG_FORCE_NMI);
-		return -EIO;
-	}
-
-	return 0;
-}
-
-static inline void _il_release_nic_access(struct il_priv *il)
-{
-	_il_clear_bit(il, CSR_GP_CNTRL,
-			CSR_GP_CNTRL_REG_FLAG_MAC_ACCESS_REQ);
-}
-
-static inline u32 il_rd(struct il_priv *il, u32 reg)
-{
-	u32 value;
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	value = _il_rd(il, reg);
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-	return value;
-
-}
-
-static inline void
-il_wr(struct il_priv *il, u32 reg, u32 value)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
-		_il_wr(il, reg, value);
-		_il_release_nic_access(il);
-	}
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-static inline void il_write_reg_buf(struct il_priv *il,
-					       u32 reg, u32 len, u32 *values)
-{
-	u32 count = sizeof(u32);
-
-	if (il != NULL && values != NULL) {
-		for (; 0 < len; len -= count, reg += count, values++)
-			il_wr(il, reg, *values);
-	}
-}
-
-static inline int il_poll_bit(struct il_priv *il, u32 addr,
-				       u32 mask, int timeout)
-{
-	int t = 0;
-
-	do {
-		if ((il_rd(il, addr) & mask) == mask)
-			return t;
-		udelay(IL_POLL_INTERVAL);
-		t += IL_POLL_INTERVAL;
-	} while (t < timeout);
-
-	return -ETIMEDOUT;
-}
-
-static inline u32 _il_rd_prph(struct il_priv *il, u32 reg)
-{
-	_il_wr(il, HBUS_TARG_PRPH_RADDR, reg | (3 << 24));
-	rmb();
-	return _il_rd(il, HBUS_TARG_PRPH_RDAT);
-}
-
-static inline u32 il_rd_prph(struct il_priv *il, u32 reg)
-{
-	unsigned long reg_flags;
-	u32 val;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	val = _il_rd_prph(il, reg);
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-	return val;
-}
-
-static inline void _il_wr_prph(struct il_priv *il,
-					     u32 addr, u32 val)
-{
-	_il_wr(il, HBUS_TARG_PRPH_WADDR,
-			      ((addr & 0x0000FFFF) | (3 << 24)));
-	wmb();
-	_il_wr(il, HBUS_TARG_PRPH_WDAT, val);
-}
-
-static inline void
-il_wr_prph(struct il_priv *il, u32 addr, u32 val)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
-		_il_wr_prph(il, addr, val);
-		_il_release_nic_access(il);
-	}
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-#define _il_set_bits_prph(il, reg, mask) \
-_il_wr_prph(il, reg, (_il_rd_prph(il, reg) | mask))
-
-static inline void
-il_set_bits_prph(struct il_priv *il, u32 reg, u32 mask)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	_il_set_bits_prph(il, reg, mask);
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-#define _il_set_bits_mask_prph(il, reg, bits, mask) \
-_il_wr_prph(il, reg,				\
-		 ((_il_rd_prph(il, reg) & mask) | bits))
-
-static inline void il_set_bits_mask_prph(struct il_priv *il, u32 reg,
-				u32 bits, u32 mask)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	_il_set_bits_mask_prph(il, reg, bits, mask);
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-static inline void il_clear_bits_prph(struct il_priv
-						 *il, u32 reg, u32 mask)
-{
-	unsigned long reg_flags;
-	u32 val;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-	val = _il_rd_prph(il, reg);
-	_il_wr_prph(il, reg, (val & ~mask));
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-static inline u32 il_read_targ_mem(struct il_priv *il, u32 addr)
-{
-	unsigned long reg_flags;
-	u32 value;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	_il_grab_nic_access(il);
-
-	_il_wr(il, HBUS_TARG_MEM_RADDR, addr);
-	rmb();
-	value = _il_rd(il, HBUS_TARG_MEM_RDAT);
-
-	_il_release_nic_access(il);
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-	return value;
-}
-
-static inline void
-il_write_targ_mem(struct il_priv *il, u32 addr, u32 val)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
-		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-		_il_wr(il, HBUS_TARG_MEM_WDAT, val);
-		_il_release_nic_access(il);
-	}
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-
-static inline void
-il_write_targ_mem_buf(struct il_priv *il, u32 addr,
-					  u32 len, u32 *values)
-{
-	unsigned long reg_flags;
-
-	spin_lock_irqsave(&il->reg_lock, reg_flags);
-	if (!_il_grab_nic_access(il)) {
-		_il_wr(il, HBUS_TARG_MEM_WADDR, addr);
-		wmb();
-		for (; 0 < len; len -= sizeof(u32), values++)
-			_il_wr(il,
-					HBUS_TARG_MEM_WDAT, *values);
-
-		_il_release_nic_access(il);
-	}
-	spin_unlock_irqrestore(&il->reg_lock, reg_flags);
-}
-#endif
diff --git a/drivers/net/wireless/iwlegacy/iwl-sta.h b/drivers/net/wireless/iwlegacy/iwl-sta.h
deleted file mode 100644
index afd3003..0000000
--- a/drivers/net/wireless/iwlegacy/iwl-sta.h
+++ /dev/null
@@ -1,146 +0,0 @@
-/******************************************************************************
- *
- * Copyright(c) 2003 - 2011 Intel Corporation. All rights reserved.
- *
- * Portions of this file are derived from the ipw3945 project, as well
- * as portions of the ieee80211 subsystem header files.
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
-#ifndef __il_sta_h__
-#define __il_sta_h__
-
-#include "iwl-dev.h"
-
-#define HW_KEY_DYNAMIC 0
-#define HW_KEY_DEFAULT 1
-
-#define IL_STA_DRIVER_ACTIVE BIT(0) /* driver entry is active */
-#define IL_STA_UCODE_ACTIVE  BIT(1) /* ucode entry is active */
-#define IL_STA_UCODE_INPROGRESS  BIT(2) /* ucode entry is in process of
-					    being activated */
-#define IL_STA_LOCAL BIT(3) /* station state not directed by mac80211;
-				(this is for the IBSS BSSID stations) */
-#define IL_STA_BCAST BIT(4) /* this station is the special bcast station */
-
-
-void il_restore_stations(struct il_priv *il,
-				struct il_rxon_context *ctx);
-void il_clear_ucode_stations(struct il_priv *il,
-			      struct il_rxon_context *ctx);
-void il_dealloc_bcast_stations(struct il_priv *il);
-int il_get_free_ucode_key_idx(struct il_priv *il);
-int il_send_add_sta(struct il_priv *il,
-			struct il_addsta_cmd *sta, u8 flags);
-int il_add_station_common(struct il_priv *il,
-			struct il_rxon_context *ctx,
-			const u8 *addr, bool is_ap,
-			struct ieee80211_sta *sta, u8 *sta_id_r);
-int il_remove_station(struct il_priv *il,
-			const u8 sta_id,
-			const u8 *addr);
-int il_mac_sta_remove(struct ieee80211_hw *hw,
-			struct ieee80211_vif *vif,
-			struct ieee80211_sta *sta);
-
-u8 il_prep_station(struct il_priv *il,
-			struct il_rxon_context *ctx,
-			const u8 *addr, bool is_ap,
-			struct ieee80211_sta *sta);
-
-int il_send_lq_cmd(struct il_priv *il,
-			struct il_rxon_context *ctx,
-			struct il_link_quality_cmd *lq,
-			u8 flags, bool init);
-
-/**
- * il_clear_driver_stations - clear knowledge of all stations from driver
- * @il: iwl il struct
- *
- * This is called during il_down() to make sure that in the case
- * we're coming there from a hardware restart mac80211 will be
- * able to reconfigure stations -- if we're getting there in the
- * normal down flow then the stations will already be cleared.
- */
-static inline void il_clear_driver_stations(struct il_priv *il)
-{
-	unsigned long flags;
-	struct il_rxon_context *ctx = &il->ctx;
-
-	spin_lock_irqsave(&il->sta_lock, flags);
-	memset(il->stations, 0, sizeof(il->stations));
-	il->num_stations = 0;
-
-	il->ucode_key_table = 0;
-
-	/*
-	 * Remove all key information that is not stored as part
-	 * of station information since mac80211 may not have had
-	 * a chance to remove all the keys. When device is
-	 * reconfigured by mac80211 after an error all keys will
-	 * be reconfigured.
-	 */
-	memset(ctx->wep_keys, 0, sizeof(ctx->wep_keys));
-	ctx->key_mapping_keys = 0;
-
-	spin_unlock_irqrestore(&il->sta_lock, flags);
-}
-
-static inline int il_sta_id(struct ieee80211_sta *sta)
-{
-	if (WARN_ON(!sta))
-		return IL_INVALID_STATION;
-
-	return ((struct il_station_priv_common *)sta->drv_priv)->sta_id;
-}
-
-/**
- * il_sta_id_or_broadcast - return sta_id or broadcast sta
- * @il: iwl il
- * @context: the current context
- * @sta: mac80211 station
- *
- * In certain circumstances mac80211 passes a station pointer
- * that may be %NULL, for example during TX or key setup. In
- * that case, we need to use the broadcast station, so this
- * inline wraps that pattern.
- */
-static inline int il_sta_id_or_broadcast(struct il_priv *il,
-					  struct il_rxon_context *context,
-					  struct ieee80211_sta *sta)
-{
-	int sta_id;
-
-	if (!sta)
-		return context->bcast_sta_id;
-
-	sta_id = il_sta_id(sta);
-
-	/*
-	 * mac80211 should not be passing a partially
-	 * initialised station!
-	 */
-	WARN_ON(sta_id == IL_INVALID_STATION);
-
-	return sta_id;
-}
-#endif /* __il_sta_h__ */
-- 
1.7.1

