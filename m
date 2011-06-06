Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55550 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753105Ab1FFL5X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jun 2011 07:57:23 -0400
Received: by mail-wy0-f174.google.com with SMTP id 21so2719203wya.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jun 2011 04:57:22 -0700 (PDT)
From: Ido Yariv <ido@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, Ido Yariv <ido@wizery.com>
Subject: [PATCH 3/3] wl12xx: Support routing FW logs to the host
Date: Mon,  6 Jun 2011 14:57:06 +0300
Message-Id: <1307361426-7573-3-git-send-email-ido@wizery.com> (sfid-20110606_135726_847980_750145C8)
In-Reply-To: <1307361426-7573-1-git-send-email-ido@wizery.com>
References: <1307361426-7573-1-git-send-email-ido@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

A recently added feature to the firmware enables the driver to retrieve
firmware logs via the host bus (SDIO or SPI).

There are two modes of operation:
1. On-demand: The FW collects its log in an internal ring buffer. This
   buffer can later be read, for example, upon recovery.
2. Continuous: The FW pushes the FW logs as special packets in the RX
   path.

Reading the internal ring buffer does not involve the FW. Thus, as long
as the HW is not in ELP, it should be possible to read the logs, even if
the FW crashes.

A sysfs binary file named "fwlog" was added to support this feature,
letting a monitor process read the FW messages. The log is transferred
from the FW only when available, so the reading process might block.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/acx.c    |    1 +
 drivers/net/wireless/wl12xx/acx.h    |    2 +
 drivers/net/wireless/wl12xx/boot.c   |    9 ++
 drivers/net/wireless/wl12xx/cmd.c    |   84 ++++++++++++++
 drivers/net/wireless/wl12xx/cmd.h    |   62 ++++++++++
 drivers/net/wireless/wl12xx/conf.h   |   25 ++++
 drivers/net/wireless/wl12xx/init.c   |   19 +++
 drivers/net/wireless/wl12xx/io.h     |   14 +++
 drivers/net/wireless/wl12xx/main.c   |  207 +++++++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/rx.c     |    8 ++
 drivers/net/wireless/wl12xx/rx.h     |   12 ++
 drivers/net/wireless/wl12xx/wl12xx.h |   20 +++-
 12 files changed, 459 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/acx.c b/drivers/net/wireless/wl12xx/acx.c
index b5880eb..87caa94 100644
--- a/drivers/net/wireless/wl12xx/acx.c
+++ b/drivers/net/wireless/wl12xx/acx.c
@@ -1067,6 +1067,7 @@ int wl1271_acx_sta_mem_cfg(struct wl1271 *wl)
 	mem_conf->tx_free_req = mem->min_req_tx_blocks;
 	mem_conf->rx_free_req = mem->min_req_rx_blocks;
 	mem_conf->tx_min = mem->tx_min;
+	mem_conf->fwlog_blocks = wl->conf.fwlog.mem_blocks;
 
 	ret = wl1271_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
 				   sizeof(*mem_conf));
diff --git a/drivers/net/wireless/wl12xx/acx.h b/drivers/net/wireless/wl12xx/acx.h
index f1d5531..d303265 100644
--- a/drivers/net/wireless/wl12xx/acx.h
+++ b/drivers/net/wireless/wl12xx/acx.h
@@ -828,6 +828,8 @@ struct wl1271_acx_sta_config_memory {
 	u8 tx_free_req;
 	u8 rx_free_req;
 	u8 tx_min;
+	u8 fwlog_blocks;
+	u8 padding[3];
 } __packed;
 
 struct wl1271_acx_mem_map {
diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b9d8fa9..ff67753 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -117,6 +117,15 @@ static unsigned int wl12xx_get_fw_ver_quirks(struct wl1271 *wl)
 	      (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_1_SPARE_AP_MIN))))
 		quirks |= WL12XX_QUIRK_USE_2_SPARE_BLOCKS;
 
+	/* Only new station firmwares support routing fw logs to the host */
+	if ((fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_STA) &&
+	    (fw_ver[FW_VER_MINOR] < FW_VER_MINOR_FWLOG_STA_MIN))
+		quirks |= WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED;
+
+	/* This feature is not yet supported for AP mode */
+	if (fw_ver[FW_VER_IF_TYPE] == FW_VER_IF_TYPE_AP)
+		quirks |= WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED;
+
 	return quirks;
 }
 
diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 0754eb1..6548f3a 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -1229,3 +1229,87 @@ out_free:
 out:
 	return ret;
 }
+
+int wl12xx_cmd_config_fwlog(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_config_fwlog *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd config firmware logger");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	cmd->logger_mode = wl->conf.fwlog.mode;
+	cmd->log_severity = wl->conf.fwlog.severity;
+	cmd->timestamp = wl->conf.fwlog.timestamp;
+	cmd->output = wl->conf.fwlog.output;
+	cmd->threshold = wl->conf.fwlog.threshold;
+
+	ret = wl1271_cmd_send(wl, CMD_CONFIG_FWLOGGER, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send config firmware logger command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+int wl12xx_cmd_start_fwlog(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_start_fwlog *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd start firmware logger");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_START_FWLOGGER, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send start firmware logger command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
+
+int wl12xx_cmd_stop_fwlog(struct wl1271 *wl)
+{
+	struct wl12xx_cmd_stop_fwlog *cmd;
+	int ret = 0;
+
+	wl1271_debug(DEBUG_CMD, "cmd stop firmware logger");
+
+	cmd = kzalloc(sizeof(*cmd), GFP_KERNEL);
+	if (!cmd) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = wl1271_cmd_send(wl, CMD_STOP_FWLOGGER, cmd, sizeof(*cmd), 0);
+	if (ret < 0) {
+		wl1271_error("failed to send stop firmware logger command");
+		goto out_free;
+	}
+
+out_free:
+	kfree(cmd);
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/cmd.h b/drivers/net/wireless/wl12xx/cmd.h
index 5cac95d..1f70372 100644
--- a/drivers/net/wireless/wl12xx/cmd.h
+++ b/drivers/net/wireless/wl12xx/cmd.h
@@ -70,6 +70,9 @@ int wl1271_cmd_start_bss(struct wl1271 *wl);
 int wl1271_cmd_stop_bss(struct wl1271 *wl);
 int wl1271_cmd_add_sta(struct wl1271 *wl, struct ieee80211_sta *sta, u8 hlid);
 int wl1271_cmd_remove_sta(struct wl1271 *wl, u8 hlid);
+int wl12xx_cmd_config_fwlog(struct wl1271 *wl);
+int wl12xx_cmd_start_fwlog(struct wl1271 *wl);
+int wl12xx_cmd_stop_fwlog(struct wl1271 *wl);
 
 enum wl1271_commands {
 	CMD_INTERROGATE     = 1,    /*use this to read information elements*/
@@ -107,6 +110,9 @@ enum wl1271_commands {
 	CMD_START_PERIODIC_SCAN      = 50,
 	CMD_STOP_PERIODIC_SCAN       = 51,
 	CMD_SET_STA_STATE            = 52,
+	CMD_CONFIG_FWLOGGER          = 53,
+	CMD_START_FWLOGGER           = 54,
+	CMD_STOP_FWLOGGER            = 55,
 
 	/* AP mode commands */
 	CMD_BSS_START                = 60,
@@ -575,4 +581,60 @@ struct wl1271_cmd_remove_sta {
 	u8 padding1;
 } __packed;
 
+/*
+ * Continuous mode - packets are transferred to the host periodically
+ * via the data path.
+ * On demand - Log messages are stored in a cyclic buffer in the
+ * firmware, and only transferred to the host when explicitly requested
+ */
+enum wl12xx_fwlogger_log_mode {
+	WL12XX_FWLOG_CONTINUOUS,
+	WL12XX_FWLOG_ON_DEMAND
+};
+
+/* Include/exclude timestamps from the log messages */
+enum wl12xx_fwlogger_timestamp {
+	WL12XX_FWLOG_TIMESTAMP_DISABLED,
+	WL12XX_FWLOG_TIMESTAMP_ENABLED
+};
+
+/*
+ * Logs can be routed to the debug pinouts (where available), to the host bus
+ * (SDIO/SPI), or dropped
+ */
+enum wl12xx_fwlogger_output {
+	WL12XX_FWLOG_OUTPUT_NONE,
+	WL12XX_FWLOG_OUTPUT_DBG_PINS,
+	WL12XX_FWLOG_OUTPUT_HOST,
+};
+
+struct wl12xx_cmd_config_fwlog {
+	struct wl1271_cmd_header header;
+
+	/* See enum wl12xx_fwlogger_log_mode */
+	u8 logger_mode;
+
+	/* Minimum log level threshold */
+	u8 log_severity;
+
+	/* Include/exclude timestamps from the log messages */
+	u8 timestamp;
+
+	/* See enum wl1271_fwlogger_output */
+	u8 output;
+
+	/* Regulates the frequency of log messages */
+	u8 threshold;
+
+	u8 padding[3];
+} __packed;
+
+struct wl12xx_cmd_start_fwlog {
+	struct wl1271_cmd_header header;
+} __packed;
+
+struct wl12xx_cmd_stop_fwlog {
+	struct wl1271_cmd_header header;
+} __packed;
+
 #endif /* __WL1271_CMD_H__ */
diff --git a/drivers/net/wireless/wl12xx/conf.h b/drivers/net/wireless/wl12xx/conf.h
index 510c2f7..9e74edf 100644
--- a/drivers/net/wireless/wl12xx/conf.h
+++ b/drivers/net/wireless/wl12xx/conf.h
@@ -1274,6 +1274,30 @@ struct conf_rx_streaming_settings {
 	u8 always;
 };
 
+struct conf_fwlog {
+	/* Continuous or on-demand */
+	u8 mode;
+
+	/*
+	 * Number of memory blocks dedicated for the FW logger
+	 *
+	 * Range: 1-3, or 0 to disable the FW logger
+	 */
+	u8 mem_blocks;
+
+	/* Minimum log level threshold */
+	u8 severity;
+
+	/* Include/exclude timestamps from the log messages */
+	u8 timestamp;
+
+	/* See enum wl1271_fwlogger_output */
+	u8 output;
+
+	/* Regulates the frequency of log messages */
+	u8 threshold;
+};
+
 struct conf_drv_settings {
 	struct conf_sg_settings sg;
 	struct conf_rx_settings rx;
@@ -1290,6 +1314,7 @@ struct conf_drv_settings {
 	struct conf_memory_settings mem_wl128x;
 	struct conf_fm_coex fm_coex;
 	struct conf_rx_streaming_settings rx_streaming;
+	struct conf_fwlog fwlog;
 	u8 hci_io_ds;
 };
 
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index b85edcc..dc433ce 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -321,6 +321,20 @@ static int wl1271_init_beacon_broadcast(struct wl1271 *wl)
 	return 0;
 }
 
+static int wl12xx_init_fwlog(struct wl1271 *wl)
+{
+	int ret;
+
+	if (wl->quirks & WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED)
+		return 0;
+
+	ret = wl12xx_cmd_config_fwlog(wl);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
 static int wl1271_sta_hw_init(struct wl1271 *wl)
 {
 	int ret;
@@ -387,6 +401,11 @@ static int wl1271_sta_hw_init(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
+	/* Configure the FW logger */
+	ret = wl12xx_init_fwlog(wl);
+	if (ret < 0)
+		return ret;
+
 	return 0;
 }
 
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index beed621..cfb3588 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -128,6 +128,20 @@ static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
 	wl1271_raw_write(wl, physical, buf, len, fixed);
 }
 
+static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
+				      void *buf, size_t len, bool fixed)
+{
+	int physical;
+	int addr;
+
+	/* Addresses are stored internally as addresses to 32 bytes blocks */
+	addr = hwaddr << 5;
+
+	physical = wl1271_translate_addr(wl, addr);
+
+	wl1271_raw_read(wl, physical, buf, len, fixed);
+}
+
 static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
 {
 	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e3b7ffd..03af7cc 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -31,6 +31,7 @@
 #include <linux/platform_device.h>
 #include <linux/slab.h>
 #include <linux/wl12xx.h>
+#include <linux/sched.h>
 
 #include "wl12xx.h"
 #include "wl12xx_80211.h"
@@ -367,9 +368,19 @@ static struct conf_drv_settings default_conf = {
 		.interval                      = 20,
 		.always                        = 0,
 	},
+	.fwlog = {
+		.mode                         = WL12XX_FWLOG_ON_DEMAND,
+		.mem_blocks                   = 2,
+		.severity                     = 0,
+		.timestamp                    = WL12XX_FWLOG_TIMESTAMP_DISABLED,
+		.output                       = WL12XX_FWLOG_OUTPUT_HOST,
+		.threshold                    = 0,
+	},
 	.hci_io_ds = HCI_IO_DS_6MA,
 };
 
+static char *fwlog_param;
+
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues);
 static void wl1271_free_ap_keys(struct wl1271 *wl);
@@ -604,8 +615,24 @@ static void wl1271_conf_init(struct wl1271 *wl)
 
 	/* apply driver default configuration */
 	memcpy(&wl->conf, &default_conf, sizeof(default_conf));
-}
 
+	/* Adjust settings according to optional module parameters */
+	if (fwlog_param) {
+		if (!strcmp(fwlog_param, "continuous")) {
+			wl->conf.fwlog.mode = WL12XX_FWLOG_CONTINUOUS;
+		} else if (!strcmp(fwlog_param, "ondemand")) {
+			wl->conf.fwlog.mode = WL12XX_FWLOG_ON_DEMAND;
+		} else if (!strcmp(fwlog_param, "dbgpins")) {
+			wl->conf.fwlog.mode = WL12XX_FWLOG_CONTINUOUS;
+			wl->conf.fwlog.output = WL12XX_FWLOG_OUTPUT_DBG_PINS;
+		} else if (!strcmp(fwlog_param, "disable")) {
+			wl->conf.fwlog.mem_blocks = 0;
+			wl->conf.fwlog.output = WL12XX_FWLOG_OUTPUT_NONE;
+		} else {
+			wl1271_error("Unknown fwlog parameter %s", fwlog_param);
+		}
+	}
+}
 
 static int wl1271_plt_init(struct wl1271 *wl)
 {
@@ -1092,6 +1119,83 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl)
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 }
 
+size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen)
+{
+	size_t len = 0;
+
+	/* The FW log is a length-value list, find where the log end */
+	while (len < maxlen) {
+		if (memblock[len] == 0)
+			break;
+		if (len + memblock[len] + 1 > maxlen)
+			break;
+		len += memblock[len] + 1;
+	}
+
+	/* Make sure we have enough room */
+	len = min(len, (size_t)(PAGE_SIZE - wl->fwlog_size));
+
+	/* Fill the FW log file, consumed by the sysfs fwlog entry */
+	memcpy(wl->fwlog + wl->fwlog_size, memblock, len);
+	wl->fwlog_size += len;
+
+	return len;
+}
+
+static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
+{
+	u32 addr;
+	u32 first_addr;
+	u8 *block;
+
+	if ((wl->quirks & WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED) ||
+	    (wl->conf.fwlog.mode != WL12XX_FWLOG_ON_DEMAND) ||
+	    (wl->conf.fwlog.mem_blocks == 0))
+		return;
+
+	wl1271_info("Reading FW panic log");
+
+	block = kmalloc(WL12XX_HW_BLOCK_SIZE, GFP_KERNEL);
+	if (!block)
+		return;
+
+	/*
+	 * Make sure the chip is awake and the logger isn't active.
+	 * This might fail if the firmware hanged.
+	 */
+	if (!wl1271_ps_elp_wakeup(wl))
+		wl12xx_cmd_stop_fwlog(wl);
+
+	/* Read the first memory block address */
+	wl1271_fw_status(wl, wl->fw_status);
+	first_addr = __le32_to_cpu(wl->fw_status->sta.log_start_addr);
+	if (!first_addr)
+		goto out;
+
+	/* Traverse the memory blocks linked list */
+	addr = first_addr;
+	do {
+		memset(block, 0, WL12XX_HW_BLOCK_SIZE);
+		wl1271_read_hwaddr(wl, addr, block, WL12XX_HW_BLOCK_SIZE,
+				   false);
+
+		/*
+		 * Memory blocks are linked to one another. The first 4 bytes
+		 * of each memory block hold the hardware address of the next
+		 * one. The last memory block points to the first one.
+		 */
+		addr = __le32_to_cpup((__le32 *)block);
+		if (!wl12xx_copy_fwlog(wl, block + sizeof(addr),
+				       WL12XX_HW_BLOCK_SIZE - sizeof(addr)))
+			break;
+	} while (addr && (addr != first_addr));
+
+	wake_up_interruptible(&wl->fwlog_waitq);
+
+out:
+	kfree(block);
+}
+
 static void wl1271_recovery_work(struct work_struct *work)
 {
 	struct wl1271 *wl =
@@ -1105,6 +1209,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	/* Avoid a recursive recovery */
 	set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 
+	wl12xx_read_fwlog_panic(wl);
+
 	wl1271_info("Hardware recovery in progress. FW ver: %s pc: 0x%x",
 		    wl->chip.fw_ver_str, wl1271_read32(wl, SCR_PAD4));
 
@@ -3885,6 +3991,69 @@ static ssize_t wl1271_sysfs_show_hw_pg_ver(struct device *dev,
 static DEVICE_ATTR(hw_pg_ver, S_IRUGO | S_IWUSR,
 		   wl1271_sysfs_show_hw_pg_ver, NULL);
 
+static ssize_t wl1271_sysfs_read_fwlog(struct file *filp, struct kobject *kobj,
+				       struct bin_attribute *bin_attr,
+				       char *buffer, loff_t pos, size_t count)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct wl1271 *wl = dev_get_drvdata(dev);
+	ssize_t len;
+	int ret;
+
+	ret = mutex_lock_interruptible(&wl->mutex);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
+	/* Let only one thread read the log at a time, blocking others */
+	while (wl->fwlog_size == 0) {
+		DEFINE_WAIT(wait);
+
+		prepare_to_wait_exclusive(&wl->fwlog_waitq,
+					  &wait,
+					  TASK_INTERRUPTIBLE);
+
+		if (wl->fwlog_size != 0) {
+			finish_wait(&wl->fwlog_waitq, &wait);
+			break;
+		}
+
+		mutex_unlock(&wl->mutex);
+
+		schedule();
+		finish_wait(&wl->fwlog_waitq, &wait);
+
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+
+		ret = mutex_lock_interruptible(&wl->mutex);
+		if (ret < 0)
+			return -ERESTARTSYS;
+	}
+
+	/* Check if the fwlog is still valid */
+	if (wl->fwlog_size < 0) {
+		mutex_unlock(&wl->mutex);
+		return 0;
+	}
+
+	/* Seeking is not supported - old logs are not kept. Disregard pos. */
+	len = min(count, (size_t)wl->fwlog_size);
+	wl->fwlog_size -= len;
+	memcpy(buffer, wl->fwlog, len);
+
+	/* Make room for new messages */
+	memmove(wl->fwlog, wl->fwlog + len, wl->fwlog_size);
+
+	mutex_unlock(&wl->mutex);
+
+	return len;
+}
+
+static struct bin_attribute fwlog_attr = {
+	.attr = {.name = "fwlog", .mode = S_IRUSR},
+	.read = wl1271_sysfs_read_fwlog,
+};
+
 int wl1271_register_hw(struct wl1271 *wl)
 {
 	int ret;
@@ -4097,6 +4266,8 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->sched_scanning = false;
 	setup_timer(&wl->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wl);
+	wl->fwlog_size = 0;
+	init_waitqueue_head(&wl->fwlog_waitq);
 
 	memset(wl->tx_frames_map, 0, sizeof(wl->tx_frames_map));
 	for (i = 0; i < ACX_TX_DESCRIPTORS; i++)
@@ -4123,11 +4294,18 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 		goto err_aggr;
 	}
 
+	/* Allocate one page for the FW log */
+	wl->fwlog = (u8 *)get_zeroed_page(GFP_KERNEL);
+	if (!wl->fwlog) {
+		ret = -ENOMEM;
+		goto err_dummy_packet;
+	}
+
 	/* Register platform device */
 	ret = platform_device_register(wl->plat_dev);
 	if (ret) {
 		wl1271_error("couldn't register platform device");
-		goto err_dummy_packet;
+		goto err_fwlog;
 	}
 	dev_set_drvdata(&wl->plat_dev->dev, wl);
 
@@ -4145,14 +4323,27 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 		goto err_bt_coex_state;
 	}
 
+	/* Create sysfs file for the FW log */
+	ret = device_create_bin_file(&wl->plat_dev->dev, &fwlog_attr);
+	if (ret < 0) {
+		wl1271_error("failed to create sysfs file fwlog");
+		goto err_hw_pg_ver;
+	}
+
 	return hw;
 
+err_hw_pg_ver:
+	device_remove_file(&wl->plat_dev->dev, &dev_attr_hw_pg_ver);
+
 err_bt_coex_state:
 	device_remove_file(&wl->plat_dev->dev, &dev_attr_bt_coex_state);
 
 err_platform:
 	platform_device_unregister(wl->plat_dev);
 
+err_fwlog:
+	free_page((unsigned long)wl->fwlog);
+
 err_dummy_packet:
 	dev_kfree_skb(wl->dummy_packet);
 
@@ -4174,7 +4365,15 @@ EXPORT_SYMBOL_GPL(wl1271_alloc_hw);
 
 int wl1271_free_hw(struct wl1271 *wl)
 {
+	/* Unblock any fwlog readers */
+	mutex_lock(&wl->mutex);
+	wl->fwlog_size = -1;
+	wake_up_interruptible_all(&wl->fwlog_waitq);
+	mutex_unlock(&wl->mutex);
+
+	device_remove_bin_file(&wl->plat_dev->dev, &fwlog_attr);
 	platform_device_unregister(wl->plat_dev);
+	free_page((unsigned long)wl->fwlog);
 	dev_kfree_skb(wl->dummy_packet);
 	free_pages((unsigned long)wl->aggr_buf,
 			get_order(WL1271_AGGR_BUFFER_SIZE));
@@ -4201,6 +4400,10 @@ EXPORT_SYMBOL_GPL(wl12xx_debug_level);
 module_param_named(debug_level, wl12xx_debug_level, uint, S_IRUSR | S_IWUSR);
 MODULE_PARM_DESC(debug_level, "wl12xx debugging level");
 
+module_param_named(fwlog, fwlog_param, charp, 0);
+MODULE_PARM_DESC(keymap,
+		 "FW logger options: continuous, ondemand, dbgpins or disable");
+
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Luciano Coelho <coelho@ti.com>");
 MODULE_AUTHOR("Juuso Oikarinen <juuso.oikarinen@nokia.com>");
diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index db230a5..b86b9b5 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -22,6 +22,7 @@
  */
 
 #include <linux/gfp.h>
+#include <linux/sched.h>
 
 #include "wl12xx.h"
 #include "acx.h"
@@ -107,6 +108,13 @@ static int wl1271_rx_handle_data(struct wl1271 *wl, u8 *data, u32 length)
 	/* the data read starts with the descriptor */
 	desc = (struct wl1271_rx_descriptor *) data;
 
+	if (desc->packet_class == WL12XX_RX_CLASS_LOGGER) {
+		size_t len = length - sizeof(*desc);
+		wl12xx_copy_fwlog(wl, data + sizeof(*desc), len);
+		wake_up_interruptible(&wl->fwlog_waitq);
+		return 0;
+	}
+
 	switch (desc->status & WL1271_RX_DESC_STATUS_MASK) {
 	/* discard corrupted packets */
 	case WL1271_RX_DESC_DRIVER_RX_Q_FAIL:
diff --git a/drivers/net/wireless/wl12xx/rx.h b/drivers/net/wireless/wl12xx/rx.h
index 75fabf8..c88e3fa 100644
--- a/drivers/net/wireless/wl12xx/rx.h
+++ b/drivers/net/wireless/wl12xx/rx.h
@@ -97,6 +97,18 @@
 #define RX_BUF_SIZE_MASK      0xFFF00
 #define RX_BUF_SIZE_SHIFT_DIV 6
 
+enum {
+	WL12XX_RX_CLASS_UNKNOWN,
+	WL12XX_RX_CLASS_MANAGEMENT,
+	WL12XX_RX_CLASS_DATA,
+	WL12XX_RX_CLASS_QOS_DATA,
+	WL12XX_RX_CLASS_BCN_PRBRSP,
+	WL12XX_RX_CLASS_EAPOL,
+	WL12XX_RX_CLASS_BA_EVENT,
+	WL12XX_RX_CLASS_AMSDU,
+	WL12XX_RX_CLASS_LOGGER,
+};
+
 struct wl1271_rx_descriptor {
 	__le16 length;
 	u8  status;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b966a37..d63b4b4 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -226,6 +226,8 @@ enum {
 #define FW_VER_MINOR_1_SPARE_STA_MIN 58
 #define FW_VER_MINOR_1_SPARE_AP_MIN  47
 
+#define FW_VER_MINOR_FWLOG_STA_MIN 70
+
 struct wl1271_chip {
 	u32 id;
 	char fw_ver_str[ETHTOOL_BUSINFO_LEN];
@@ -284,8 +286,7 @@ struct wl1271_fw_sta_status {
 	u8  tx_total;
 	u8  reserved1;
 	__le16 reserved2;
-	/* Total structure size is 68 bytes */
-	u32 padding;
+	__le32 log_start_addr;
 } __packed;
 
 struct wl1271_fw_full_status {
@@ -471,6 +472,15 @@ struct wl1271 {
 	/* Network stack work  */
 	struct work_struct netstack_work;
 
+	/* FW log buffer */
+	u8 *fwlog;
+
+	/* Number of valid bytes in the FW log buffer */
+	ssize_t fwlog_size;
+
+	/* Sysfs FW log entry readers wait queue */
+	wait_queue_head_t fwlog_waitq;
+
 	/* Hardware recovery work */
 	struct work_struct recovery_work;
 
@@ -611,6 +621,7 @@ int wl1271_plt_start(struct wl1271 *wl);
 int wl1271_plt_stop(struct wl1271 *wl);
 int wl1271_recalc_rx_streaming(struct wl1271 *wl);
 void wl12xx_queue_recovery_work(struct wl1271 *wl);
+size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen);
 
 #define JOIN_TIMEOUT 5000 /* 5000 milliseconds to join */
 
@@ -646,4 +657,9 @@ void wl12xx_queue_recovery_work(struct wl1271 *wl);
 /* WL128X requires aggregated packets to be aligned to the SDIO block size */
 #define WL12XX_QUIRK_BLOCKSIZE_ALIGNMENT	BIT(2)
 
+/* Older firmwares did not implement the FW logger over bus feature */
+#define WL12XX_QUIRK_FWLOG_NOT_IMPLEMENTED	BIT(3)
+
+#define WL12XX_HW_BLOCK_SIZE	256
+
 #endif
-- 
1.7.4.1

