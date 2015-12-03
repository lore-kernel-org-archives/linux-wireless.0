Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:60852 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995AbbLCOW5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2015 09:22:57 -0500
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id tB3EMuxT008584
	for <linux-wireless@vger.kernel.org>; Thu, 3 Dec 2015 08:22:56 -0600
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id tB3EMu8N012445
	for <linux-wireless@vger.kernel.org>; Thu, 3 Dec 2015 08:22:56 -0600
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Shahar Patury <shaharp@ti.com>
Subject: [PATCH V5] wlcore/wl18xx: fw logger over sdio
Date: Thu, 3 Dec 2015 16:08:43 +0200
Message-ID: <1449151723-28387-1-git-send-email-guym@ti.com> (sfid-20151203_152343_040001_467A1EDE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shahar Patury <shaharp@ti.com>

enable the FW Logger to work over the SDIO interface instead of only
over UART.
in new design we will use fw internal memory instead of packet ram
that was used in older (and wl12xx) design.
this change will reduce the impact on tp and stability.
adding new event to notify fw logger is ready to be read.
adding dynamic configuration to debugfs.

Signed-off-by: Shahar Patury <shaharp@ti.com>
---
V5: Resubmitted again due to cpu interface changes

 drivers/net/wireless/ti/wl18xx/event.c   |    2 +
 drivers/net/wireless/ti/wl18xx/event.h   |    1 +
 drivers/net/wireless/ti/wl18xx/main.c    |    9 ++-
 drivers/net/wireless/ti/wlcore/cmd.h     |    1 -
 drivers/net/wireless/ti/wlcore/debugfs.c |   60 +++++++++++++++++++
 drivers/net/wireless/ti/wlcore/event.c   |   82 +++++++++++++++++++++++++
 drivers/net/wireless/ti/wlcore/event.h   |    9 +++
 drivers/net/wireless/ti/wlcore/io.c      |   11 ++--
 drivers/net/wireless/ti/wlcore/io.h      |    4 +-
 drivers/net/wireless/ti/wlcore/main.c    |   96 +++--------------------------
 drivers/net/wireless/ti/wlcore/rx.c      |    1 -
 drivers/net/wireless/ti/wlcore/sysfs.c   |   26 --------
 drivers/net/wireless/ti/wlcore/wlcore.h  |    3 -
 13 files changed, 177 insertions(+), 128 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 09c7e09..719907a 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -205,6 +205,8 @@ int wl18xx_process_mailbox_events(struct wl1271 *wl)
 						 mbox->sc_ssid,
 						 mbox->sc_pwd_len,
 						 mbox->sc_pwd);
+	if (vector & FW_LOGGER_INDICATION)
+		wlcore_event_fw_logger(wl);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/ti/wl18xx/event.h b/drivers/net/wireless/ti/wl18xx/event.h
index f3d4f13..070de12 100644
--- a/drivers/net/wireless/ti/wl18xx/event.h
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -41,6 +41,7 @@ enum {
 	SMART_CONFIG_SYNC_EVENT_ID               = BIT(22),
 	SMART_CONFIG_DECODE_EVENT_ID             = BIT(23),
 	TIME_SYNC_EVENT_ID                       = BIT(24),
+	FW_LOGGER_INDICATION			= BIT(25),
 };
 
 enum wl18xx_radar_types {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 50cce42..60eda4d 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -461,7 +461,7 @@ static struct wlcore_conf wl18xx_conf = {
 	},
 	.fwlog = {
 		.mode                         = WL12XX_FWLOG_CONTINUOUS,
-		.mem_blocks                   = 2,
+		.mem_blocks                   = 0,
 		.severity                     = 0,
 		.timestamp                    = WL12XX_FWLOG_TIMESTAMP_DISABLED,
 		.output                       = WL12XX_FWLOG_OUTPUT_DBG_PINS,
@@ -584,7 +584,7 @@ static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 		.mem  = { .start = 0x00A00000, .size  = 0x00012000 },
 		.reg  = { .start = 0x00807000, .size  = 0x00005000 },
 		.mem2 = { .start = 0x00800000, .size  = 0x0000B000 },
-		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
+		.mem3 = { .start = 0x00401594, .size  = 0x00001020 },
 	},
 	[PART_DOWN] = {
 		.mem  = { .start = 0x00000000, .size  = 0x00014000 },
@@ -602,7 +602,7 @@ static const struct wlcore_partition_set wl18xx_ptable[PART_TABLE_LEN] = {
 		.mem  = { .start = 0x00800000, .size  = 0x000050FC },
 		.reg  = { .start = 0x00B00404, .size  = 0x00001000 },
 		.mem2 = { .start = 0x00C00000, .size  = 0x00000400 },
-		.mem3 = { .start = 0x00000000, .size  = 0x00000000 },
+		.mem3 = { .start = 0x00401594, .size  = 0x00001020 },
 	},
 	[PART_PHY_INIT] = {
 		.mem  = { .start = WL18XX_PHY_INIT_MEM_ADDR,
@@ -1029,7 +1029,8 @@ static int wl18xx_boot(struct wl1271 *wl)
 		DFS_CHANNELS_CONFIG_COMPLETE_EVENT |
 		SMART_CONFIG_SYNC_EVENT_ID |
 		SMART_CONFIG_DECODE_EVENT_ID |
-		TIME_SYNC_EVENT_ID;
+		TIME_SYNC_EVENT_ID |
+		FW_LOGGER_INDICATION;
 
 	wl->ap_event_mask = MAX_TX_FAILURE_EVENT_ID;
 
diff --git a/drivers/net/wireless/ti/wlcore/cmd.h b/drivers/net/wireless/ti/wlcore/cmd.h
index 8dc46c0..e28e2f2 100644
--- a/drivers/net/wireless/ti/wlcore/cmd.h
+++ b/drivers/net/wireless/ti/wlcore/cmd.h
@@ -626,7 +626,6 @@ struct wl12xx_cmd_remove_peer {
  */
 enum wl12xx_fwlogger_log_mode {
 	WL12XX_FWLOG_CONTINUOUS,
-	WL12XX_FWLOG_ON_DEMAND
 };
 
 /* Include/exclude timestamps from the log messages */
diff --git a/drivers/net/wireless/ti/wlcore/debugfs.c b/drivers/net/wireless/ti/wlcore/debugfs.c
index eb43f94..8367f9e 100644
--- a/drivers/net/wireless/ti/wlcore/debugfs.c
+++ b/drivers/net/wireless/ti/wlcore/debugfs.c
@@ -1234,6 +1234,65 @@ static const struct file_operations dev_mem_ops = {
 	.llseek = dev_mem_seek,
 };
 
+static ssize_t fw_logger_read(struct file *file, char __user *user_buf,
+			      size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+
+	return wl1271_format_buffer(user_buf, count,
+					ppos, "%d\n",
+					wl->conf.fwlog.output);
+}
+
+static ssize_t fw_logger_write(struct file *file,
+			       const char __user *user_buf,
+			       size_t count, loff_t *ppos)
+{
+	struct wl1271 *wl = file->private_data;
+	unsigned long value;
+	int ret;
+
+	ret = kstrtoul_from_user(user_buf, count, 0, &value);
+	if (ret < 0) {
+		wl1271_warning("illegal value in fw_logger");
+		return -EINVAL;
+	}
+
+	if ((value > 2) || (value == 0)) {
+		wl1271_warning("fw_logger value must be 1-UART 2-SDIO");
+		return -ERANGE;
+	}
+
+	if (wl->conf.fwlog.output == 0) {
+		wl1271_warning("iligal opperation - fw logger disabled by default, please change mode via wlconf");
+		return -EINVAL;
+	}
+
+	mutex_lock(&wl->mutex);
+	ret = wl1271_ps_elp_wakeup(wl);
+	if (ret < 0) {
+		count = ret;
+		goto out;
+	}
+
+	wl->conf.fwlog.output = value;
+
+	ret = wl12xx_cmd_config_fwlog(wl);
+
+	wl1271_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+	return count;
+}
+
+static const struct file_operations fw_logger_ops = {
+	.open = simple_open,
+	.read = fw_logger_read,
+	.write = fw_logger_write,
+	.llseek = default_llseek,
+};
+
 static int wl1271_debugfs_add_files(struct wl1271 *wl,
 				    struct dentry *rootdir)
 {
@@ -1260,6 +1319,7 @@ static int wl1271_debugfs_add_files(struct wl1271 *wl,
 	DEBUGFS_ADD(irq_timeout, rootdir);
 	DEBUGFS_ADD(fw_stats_raw, rootdir);
 	DEBUGFS_ADD(sleep_auth, rootdir);
+	DEBUGFS_ADD(fw_logger, rootdir);
 
 	streaming = debugfs_create_dir("rx_streaming", rootdir);
 	if (!streaming || IS_ERR(streaming))
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index c42e789..c964054 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -28,6 +28,88 @@
 #include "ps.h"
 #include "scan.h"
 #include "wl12xx_80211.h"
+#include "hw_ops.h"
+
+#define WL18XX_LOGGER_SDIO_BUFF_MAX	(0x1020)
+#define WL18XX_DATA_RAM_BASE_ADDRESS	(0x20000000)
+#define WL18XX_LOGGER_SDIO_BUFF_ADDR	(0x40159c)
+#define WL18XX_LOGGER_BUFF_OFFSET	(sizeof(struct fw_logger_information))
+#define WL18XX_LOGGER_READ_POINT_OFFSET		(12)
+
+int wlcore_event_fw_logger(struct wl1271 *wl)
+{
+	u32 ret;
+	struct fw_logger_information fw_log;
+	u8  *buffer;
+	u32 internal_fw_addrbase = WL18XX_DATA_RAM_BASE_ADDRESS;
+	u32 addr = WL18XX_LOGGER_SDIO_BUFF_ADDR;
+	u32 end_buff_addr = WL18XX_LOGGER_SDIO_BUFF_ADDR +
+				WL18XX_LOGGER_BUFF_OFFSET;
+	u32 available_len;
+	u32 actual_len;
+	u32 clear_addr;
+	size_t len;
+	u32 start_loc;
+
+	buffer = kzalloc(WL18XX_LOGGER_SDIO_BUFF_MAX, GFP_KERNEL);
+	if (!buffer) {
+		wl1271_error("Fail to allocate fw logger memory");
+		fw_log.actual_buff_size = cpu_to_le32(0);
+		goto out;
+	}
+
+	ret = wlcore_read(wl, addr, buffer, WL18XX_LOGGER_SDIO_BUFF_MAX,
+			  false);
+	if (ret < 0) {
+		wl1271_error("Fail to read logger buffer, error_id = %d",
+			     ret);
+		fw_log.actual_buff_size = cpu_to_le32(0);
+		goto free_out;
+	}
+
+	memcpy(&fw_log, buffer, sizeof(fw_log));
+
+	if (le32_to_cpu(fw_log.actual_buff_size) == 0)
+		goto free_out;
+
+	actual_len = le32_to_cpu(fw_log.actual_buff_size);
+	start_loc = (le32_to_cpu(fw_log.buff_read_ptr) -
+			internal_fw_addrbase) - addr;
+	end_buff_addr += le32_to_cpu(fw_log.max_buff_size);
+	available_len = end_buff_addr -
+			(le32_to_cpu(fw_log.buff_read_ptr) -
+				 internal_fw_addrbase);
+	actual_len = min(actual_len, available_len);
+	len = actual_len;
+
+	wl12xx_copy_fwlog(wl, &buffer[start_loc], len);
+	clear_addr = addr + start_loc + le32_to_cpu(fw_log.actual_buff_size) +
+			internal_fw_addrbase;
+
+	len = le32_to_cpu(fw_log.actual_buff_size) - len;
+	if (len) {
+		wl12xx_copy_fwlog(wl,
+				  &buffer[WL18XX_LOGGER_BUFF_OFFSET],
+				  len);
+		clear_addr = addr + WL18XX_LOGGER_BUFF_OFFSET + len +
+				internal_fw_addrbase;
+	}
+
+	/* double check that clear address and write pointer are the same */
+	if (clear_addr != le32_to_cpu(fw_log.buff_write_ptr)) {
+		wl1271_error("Calculate of clear addr Clear = %x, write = %x",
+			     clear_addr, le32_to_cpu(fw_log.buff_write_ptr));
+	}
+
+	/* indicate FW about Clear buffer */
+	ret = wlcore_write32(wl, addr + WL18XX_LOGGER_READ_POINT_OFFSET,
+			     fw_log.buff_write_ptr);
+free_out:
+	kfree(buffer);
+out:
+	return le32_to_cpu(fw_log.actual_buff_size);
+}
+EXPORT_SYMBOL_GPL(wlcore_event_fw_logger);
 
 void wlcore_event_rssi_trigger(struct wl1271 *wl, s8 *metric_arr)
 {
diff --git a/drivers/net/wireless/ti/wlcore/event.h b/drivers/net/wireless/ti/wlcore/event.h
index acc7a59..75e8e98 100644
--- a/drivers/net/wireless/ti/wlcore/event.h
+++ b/drivers/net/wireless/ti/wlcore/event.h
@@ -64,6 +64,14 @@ enum {
 
 #define NUM_OF_RSSI_SNR_TRIGGERS 8
 
+struct fw_logger_information {
+	__le32 max_buff_size;
+	__le32 actual_buff_size;
+	__le32 num_trace_drop;
+	__le32 buff_read_ptr;
+	__le32 buff_write_ptr;
+} __packed;
+
 struct wl1271;
 
 int wl1271_event_unmask(struct wl1271 *wl);
@@ -84,4 +92,5 @@ void wlcore_event_max_tx_failure(struct wl1271 *wl, unsigned long sta_bitmap);
 void wlcore_event_inactive_sta(struct wl1271 *wl, unsigned long sta_bitmap);
 void wlcore_event_roc_complete(struct wl1271 *wl);
 void wlcore_event_rssi_trigger(struct wl1271 *wl, s8 *metric_arr);
+int  wlcore_event_fw_logger(struct wl1271 *wl);
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 68e74ee..9ac118e 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -175,12 +175,13 @@ int wlcore_set_partition(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * We don't need the size of the last partition, as it is
-	 * automatically calculated based on the total memory size and
-	 * the sizes of the previous partitions.
-	 */
 	ret = wlcore_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
+	if (ret < 0)
+		goto out;
+
+	ret = wlcore_raw_write32(wl, HW_PART3_SIZE_ADDR, p->mem3.size);
+	if (ret < 0)
+		goto out;
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 0305729..020c7b8 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -36,8 +36,8 @@
 #define HW_PART1_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 12)
 #define HW_PART2_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 16)
 #define HW_PART2_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 20)
-#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 24)
-
+#define HW_PART3_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 24)
+#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 28)
 #define HW_ACCESS_REGISTER_SIZE         4
 
 #define HW_ACCESS_PRAM_MAX_RANGE	0x3c000
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ec7f6af..d1109c4 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1,4 +1,3 @@
-
 /*
  * This file is part of wlcore
  *
@@ -303,25 +302,11 @@ out:
 
 static void wlcore_adjust_conf(struct wl1271 *wl)
 {
-	/* Adjust settings according to optional module parameters */
-
-	/* Firmware Logger params */
-	if (fwlog_mem_blocks != -1) {
-		if (fwlog_mem_blocks >= CONF_FWLOG_MIN_MEM_BLOCKS &&
-		    fwlog_mem_blocks <= CONF_FWLOG_MAX_MEM_BLOCKS) {
-			wl->conf.fwlog.mem_blocks = fwlog_mem_blocks;
-		} else {
-			wl1271_error(
-				"Illegal fwlog_mem_blocks=%d using default %d",
-				fwlog_mem_blocks, wl->conf.fwlog.mem_blocks);
-		}
-	}
 
 	if (fwlog_param) {
 		if (!strcmp(fwlog_param, "continuous")) {
 			wl->conf.fwlog.mode = WL12XX_FWLOG_CONTINUOUS;
-		} else if (!strcmp(fwlog_param, "ondemand")) {
-			wl->conf.fwlog.mode = WL12XX_FWLOG_ON_DEMAND;
+			wl->conf.fwlog.output = WL12XX_FWLOG_OUTPUT_HOST;
 		} else if (!strcmp(fwlog_param, "dbgpins")) {
 			wl->conf.fwlog.mode = WL12XX_FWLOG_CONTINUOUS;
 			wl->conf.fwlog.output = WL12XX_FWLOG_OUTPUT_DBG_PINS;
@@ -825,91 +810,32 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen)
 
 static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 {
-	struct wlcore_partition_set part, old_part;
-	u32 addr;
-	u32 offset;
-	u32 end_of_log;
-	u8 *block;
-	int ret;
+	u32 end_of_log = 0;
 
-	if ((wl->quirks & WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED) ||
-	    (wl->conf.fwlog.mem_blocks == 0))
+	if (wl->quirks & WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED)
 		return;
 
 	wl1271_info("Reading FW panic log");
 
-	block = kmalloc(wl->fw_mem_block_size, GFP_KERNEL);
-	if (!block)
-		return;
-
 	/*
 	 * Make sure the chip is awake and the logger isn't active.
 	 * Do not send a stop fwlog command if the fw is hanged or if
 	 * dbgpins are used (due to some fw bug).
 	 */
 	if (wl1271_ps_elp_wakeup(wl))
-		goto out;
+		return;
 	if (!wl->watchdog_recovery &&
 	    wl->conf.fwlog.output != WL12XX_FWLOG_OUTPUT_DBG_PINS)
 		wl12xx_cmd_stop_fwlog(wl);
 
-	/* Read the first memory block address */
-	ret = wlcore_fw_status(wl, wl->fw_status);
-	if (ret < 0)
-		goto out;
-
-	addr = wl->fw_status->log_start_addr;
-	if (!addr)
-		goto out;
-
-	if (wl->conf.fwlog.mode == WL12XX_FWLOG_CONTINUOUS) {
-		offset = sizeof(addr) + sizeof(struct wl1271_rx_descriptor);
-		end_of_log = wl->fwlog_end;
-	} else {
-		offset = sizeof(addr);
-		end_of_log = addr;
-	}
-
-	old_part = wl->curr_part;
-	memset(&part, 0, sizeof(part));
-
 	/* Traverse the memory blocks linked list */
 	do {
-		part.mem.start = wlcore_hw_convert_hwaddr(wl, addr);
-		part.mem.size  = PAGE_SIZE;
-
-		ret = wlcore_set_partition(wl, &part);
-		if (ret < 0) {
-			wl1271_error("%s: set_partition start=0x%X size=%d",
-				__func__, part.mem.start, part.mem.size);
-			goto out;
+		end_of_log = wlcore_event_fw_logger(wl);
+		if (end_of_log == 0) {
+			msleep(100);
+			end_of_log = wlcore_event_fw_logger(wl);
 		}
-
-		memset(block, 0, wl->fw_mem_block_size);
-		ret = wlcore_read_hwaddr(wl, addr, block,
-					wl->fw_mem_block_size, false);
-
-		if (ret < 0)
-			goto out;
-
-		/*
-		 * Memory blocks are linked to one another. The first 4 bytes
-		 * of each memory block hold the hardware address of the next
-		 * one. The last memory block points to the first one in
-		 * on demand mode and is equal to 0x2000000 in continuous mode.
-		 */
-		addr = le32_to_cpup((__le32 *)block);
-
-		if (!wl12xx_copy_fwlog(wl, block + offset,
-					wl->fw_mem_block_size - offset))
-			break;
-	} while (addr && (addr != end_of_log));
-
-	wake_up_interruptible(&wl->fwlog_waitq);
-
-out:
-	kfree(block);
-	wlcore_set_partition(wl, &old_part);
+	} while (end_of_log != 0);
 }
 
 static void wlcore_save_freed_pkts(struct wl1271 *wl, struct wl12xx_vif *wlvif,
@@ -6291,7 +6217,6 @@ struct ieee80211_hw *wlcore_alloc_hw(size_t priv_size, u32 aggr_buf_size,
 	wl->active_sta_count = 0;
 	wl->active_link_count = 0;
 	wl->fwlog_size = 0;
-	init_waitqueue_head(&wl->fwlog_waitq);
 
 	/* The system link is always allocated */
 	__set_bit(WL12XX_SYSTEM_HLID, wl->links_map);
@@ -6377,7 +6302,6 @@ int wlcore_free_hw(struct wl1271 *wl)
 	/* Unblock any fwlog readers */
 	mutex_lock(&wl->mutex);
 	wl->fwlog_size = -1;
-	wake_up_interruptible_all(&wl->fwlog_waitq);
 	mutex_unlock(&wl->mutex);
 
 	wlcore_sysfs_free(wl);
@@ -6584,7 +6508,7 @@ MODULE_PARM_DESC(debug_level, "wl12xx debugging level");
 
 module_param_named(fwlog, fwlog_param, charp, 0);
 MODULE_PARM_DESC(fwlog,
-		 "FW logger options: continuous, ondemand, dbgpins or disable");
+		 "FW logger options: continuous, dbgpins or disable");
 
 module_param(fwlog_mem_blocks, int, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(fwlog_mem_blocks, "fwlog mem_blocks");
diff --git a/drivers/net/wireless/ti/wlcore/rx.c b/drivers/net/wireless/ti/wlcore/rx.c
index 5b29273..34e7e93 100644
--- a/drivers/net/wireless/ti/wlcore/rx.c
+++ b/drivers/net/wireless/ti/wlcore/rx.c
@@ -149,7 +149,6 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length,
 	if (desc->packet_class == WL12XX_RX_CLASS_LOGGER) {
 		size_t len = length - sizeof(*desc);
 		wl12xx_copy_fwlog(wl, data + sizeof(*desc), len);
-		wake_up_interruptible(&wl->fwlog_waitq);
 		return 0;
 	}
 
diff --git a/drivers/net/wireless/ti/wlcore/sysfs.c b/drivers/net/wireless/ti/wlcore/sysfs.c
index 24dd288..a9218e5 100644
--- a/drivers/net/wireless/ti/wlcore/sysfs.c
+++ b/drivers/net/wireless/ti/wlcore/sysfs.c
@@ -119,32 +119,6 @@ static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
 	if (ret < 0)
 		return -ERESTARTSYS;
 
-	/* Let only one thread read the log at a time, blocking others */
-	while (wl->fwlog_size == 0) {
-		DEFINE_WAIT(wait);
-
-		prepare_to_wait_exclusive(&wl->fwlog_waitq,
-					  &wait,
-					  TASK_INTERRUPTIBLE);
-
-		if (wl->fwlog_size != 0) {
-			finish_wait(&wl->fwlog_waitq, &wait);
-			break;
-		}
-
-		mutex_unlock(&wl->mutex);
-
-		schedule();
-		finish_wait(&wl->fwlog_waitq, &wait);
-
-		if (signal_pending(current))
-			return -ERESTARTSYS;
-
-		ret = mutex_lock_interruptible(&wl->mutex);
-		if (ret < 0)
-			return -ERESTARTSYS;
-	}
-
 	/* Check if the fwlog is still valid */
 	if (wl->fwlog_size < 0) {
 		mutex_unlock(&wl->mutex);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 906be6a..dda01b1 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -310,9 +310,6 @@ struct wl1271 {
 	/* FW memory block size */
 	u32 fw_mem_block_size;
 
-	/* Sysfs FW log entry readers wait queue */
-	wait_queue_head_t fwlog_waitq;
-
 	/* Hardware recovery work */
 	struct work_struct recovery_work;
 	bool watchdog_recovery;
-- 
1.7.0.4

