Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:53619 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757422AbZHGKel (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2009 06:34:41 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 10/23] wl1251: remove wl1251_ops
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Aug 2009 13:33:57 +0300
Message-ID: <20090807103356.31717.60456.stgit@tikku>
In-Reply-To: <20090807102732.31717.84006.stgit@tikku>
References: <20090807102732.31717.84006.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kalle.valo@nokia.com>

Now wl1271 is splitted to separate files, no need to use wl1251_ops anymore.
So remove struct wl1251_chip and wl1251_ops.c.

Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
---

 drivers/net/wireless/wl12xx/Makefile      |    2 
 drivers/net/wireless/wl12xx/wl1251.h      |   55 ++----
 drivers/net/wireless/wl12xx/wl1251_acx.c  |   79 +++++++++
 drivers/net/wireless/wl12xx/wl1251_acx.h  |  146 +++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_boot.c |  256 ++++++++++++++++++++++++++++-
 drivers/net/wireless/wl12xx/wl1251_boot.h |    1 
 drivers/net/wireless/wl12xx/wl1251_cmd.c  |    4 
 drivers/net/wireless/wl12xx/wl1251_init.c |  213 ++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_init.h |    2 
 drivers/net/wireless/wl12xx/wl1251_io.c   |   17 ++
 drivers/net/wireless/wl12xx/wl1251_main.c |  141 +++++++++++++---
 drivers/net/wireless/wl12xx/wl1251_ops.h  |  165 -------------------
 12 files changed, 842 insertions(+), 239 deletions(-)
 delete mode 100644 drivers/net/wireless/wl12xx/wl1251_ops.h

diff --git a/drivers/net/wireless/wl12xx/Makefile b/drivers/net/wireless/wl12xx/Makefile
index f7f84d4..c43307d 100644
--- a/drivers/net/wireless/wl12xx/Makefile
+++ b/drivers/net/wireless/wl12xx/Makefile
@@ -1,7 +1,7 @@
 wl1251-objs		= wl1251_main.o wl1251_event.o \
 			  wl1251_tx.o wl1251_rx.o wl1251_ps.o wl1251_cmd.o \
 			  wl1251_acx.o wl1251_boot.o wl1251_init.o \
-			  wl1251_ops.o wl1251_debugfs.o wl1251_io.o
+			  wl1251_debugfs.o wl1251_io.o
 
 obj-$(CONFIG_WL1251)	+= wl1251.o
 obj-$(CONFIG_WL1251_SPI)	+= wl1251_spi.o
diff --git a/drivers/net/wireless/wl12xx/wl1251.h b/drivers/net/wireless/wl12xx/wl1251.h
index 13f0589..44c5001 100644
--- a/drivers/net/wireless/wl12xx/wl1251.h
+++ b/drivers/net/wireless/wl12xx/wl1251.h
@@ -143,35 +143,6 @@ struct wl1251_partition_set {
 
 struct wl1251;
 
-/* FIXME: I'm not sure about this structure name */
-struct wl1251_chip {
-	u32 id;
-
-	const char *fw_filename;
-	const char *nvs_filename;
-
-	char fw_ver[21];
-
-	unsigned int power_on_sleep;
-	int intr_cmd_complete;
-	int intr_init_complete;
-
-	int (*op_upload_fw)(struct wl1251 *wl);
-	int (*op_upload_nvs)(struct wl1251 *wl);
-	int (*op_boot)(struct wl1251 *wl);
-	void (*op_set_ecpu_ctrl)(struct wl1251 *wl, u32 flag);
-	void (*op_target_enable_interrupts)(struct wl1251 *wl);
-	int (*op_hw_init)(struct wl1251 *wl);
-	int (*op_plt_init)(struct wl1251 *wl);
-	void (*op_tx_flush)(struct wl1251 *wl);
-	void (*op_fw_version)(struct wl1251 *wl);
-	int (*op_cmd_join)(struct wl1251 *wl, u8 bss_type, u8 dtim_interval,
-			    u16 beacon_interval, u8 wait);
-
-	struct wl1251_partition_set *p_table;
-	enum wl12xx_acx_int_reg *acx_reg_table;
-};
-
 struct wl1251_stats {
 	struct acx_statistics *fw_stats;
 	unsigned long fw_stats_update;
@@ -307,8 +278,6 @@ struct wl1251 {
 	int virtual_mem_addr;
 	int virtual_reg_addr;
 
-	struct wl1251_chip chip;
-
 	int cmd_box_addr;
 	int event_box_addr;
 	struct boot_attr boot_attr;
@@ -401,6 +370,9 @@ struct wl1251 {
 	u32 buffer_cmd;
 	u8 buffer_busyword[WL1251_BUSY_WORD_LEN];
 	struct wl1251_rx_descriptor *rx_descriptor;
+
+	u32 chip_id;
+	char fw_ver[21];
 };
 
 int wl1251_plt_start(struct wl1251 *wl);
@@ -420,16 +392,25 @@ void wl1251_disable_interrupts(struct wl1251 *wl);
 
 #define WL1251_TX_QUEUE_MAX_LENGTH 20
 
-/* Different chips need different sleep times after power on.  WL1271 needs
- * 200ms, WL1251 needs only 10ms.  By default we use 200ms, but as soon as we
- * know the chip ID, we change the sleep value in the wl1251 chip structure,
- * so in subsequent power ons, we don't waste more time then needed.  */
-#define WL1251_DEFAULT_POWER_ON_SLEEP 200
-
 #define CHIP_ID_1251_PG10	           (0x7010101)
 #define CHIP_ID_1251_PG11	           (0x7020101)
 #define CHIP_ID_1251_PG12	           (0x7030101)
 #define CHIP_ID_1271_PG10	           (0x4030101)
 #define CHIP_ID_1271_PG20	           (0x4030111)
 
+#define WL1251_FW_NAME "wl1251-fw.bin"
+#define WL1251_NVS_NAME "wl1251-nvs.bin"
+
+#define WL1251_POWER_ON_SLEEP 10 /* in miliseconds */
+
+#define WL1251_PART_DOWN_MEM_START	0x0
+#define WL1251_PART_DOWN_MEM_SIZE	0x16800
+#define WL1251_PART_DOWN_REG_START	REGISTERS_BASE
+#define WL1251_PART_DOWN_REG_SIZE	REGISTERS_DOWN_SIZE
+
+#define WL1251_PART_WORK_MEM_START	0x28000
+#define WL1251_PART_WORK_MEM_SIZE	0x14000
+#define WL1251_PART_WORK_REG_START	REGISTERS_BASE
+#define WL1251_PART_WORK_REG_SIZE	REGISTERS_WORK_SIZE
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.c b/drivers/net/wireless/wl12xx/wl1251_acx.c
index 91fe16c..0a225c6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.c
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.c
@@ -837,3 +837,82 @@ int wl1251_acx_statistics(struct wl1251 *wl, struct acx_statistics *stats)
 
 	return 0;
 }
+
+int wl1251_acx_rate_policies(struct wl1251 *wl)
+{
+	struct acx_rate_policy *acx;
+	int ret = 0;
+
+	wl1251_debug(DEBUG_ACX, "acx rate policies");
+
+	acx = kzalloc(sizeof(*acx), GFP_KERNEL);
+
+	if (!acx) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* configure one default (one-size-fits-all) rate class */
+	acx->rate_class_cnt = 1;
+	acx->rate_class[0].enabled_rates = ACX_RATE_MASK_UNSPECIFIED;
+	acx->rate_class[0].short_retry_limit = ACX_RATE_RETRY_LIMIT;
+	acx->rate_class[0].long_retry_limit = ACX_RATE_RETRY_LIMIT;
+	acx->rate_class[0].aflags = 0;
+
+	ret = wl1251_cmd_configure(wl, ACX_RATE_POLICY, acx, sizeof(*acx));
+	if (ret < 0) {
+		wl1251_warning("Setting of rate policies failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(acx);
+	return ret;
+}
+
+int wl1251_acx_mem_cfg(struct wl1251 *wl)
+{
+	struct wl1251_acx_config_memory *mem_conf;
+	int ret, i;
+
+	wl1251_debug(DEBUG_ACX, "acx mem cfg");
+
+	mem_conf = kzalloc(sizeof(*mem_conf), GFP_KERNEL);
+	if (!mem_conf) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	/* memory config */
+	mem_conf->mem_config.num_stations = cpu_to_le16(DEFAULT_NUM_STATIONS);
+	mem_conf->mem_config.rx_mem_block_num = 35;
+	mem_conf->mem_config.tx_min_mem_block_num = 64;
+	mem_conf->mem_config.num_tx_queues = MAX_TX_QUEUES;
+	mem_conf->mem_config.host_if_options = HOSTIF_PKT_RING;
+	mem_conf->mem_config.num_ssid_profiles = 1;
+	mem_conf->mem_config.debug_buffer_size =
+		cpu_to_le16(TRACE_BUFFER_MAX_SIZE);
+
+	/* RX queue config */
+	mem_conf->rx_queue_config.dma_address = 0;
+	mem_conf->rx_queue_config.num_descs = ACX_RX_DESC_DEF;
+	mem_conf->rx_queue_config.priority = DEFAULT_RXQ_PRIORITY;
+	mem_conf->rx_queue_config.type = DEFAULT_RXQ_TYPE;
+
+	/* TX queue config */
+	for (i = 0; i < MAX_TX_QUEUES; i++) {
+		mem_conf->tx_queue_config[i].num_descs = ACX_TX_DESC_DEF;
+		mem_conf->tx_queue_config[i].attributes = i;
+	}
+
+	ret = wl1251_cmd_configure(wl, ACX_MEM_CFG, mem_conf,
+				   sizeof(*mem_conf));
+	if (ret < 0) {
+		wl1251_warning("wl1251 mem config failed: %d", ret);
+		goto out;
+	}
+
+out:
+	kfree(mem_conf);
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 2e7b193..cafb914 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -1031,6 +1031,150 @@ struct acx_statistics {
 	struct acx_rxpipe_statistics rxpipe;
 } __attribute__ ((packed));
 
+#define ACX_MAX_RATE_CLASSES       8
+#define ACX_RATE_MASK_UNSPECIFIED  0
+#define ACX_RATE_RETRY_LIMIT      10
+
+struct acx_rate_class {
+	u32 enabled_rates;
+	u8 short_retry_limit;
+	u8 long_retry_limit;
+	u8 aflags;
+	u8 reserved;
+};
+
+struct acx_rate_policy {
+	struct acx_header header;
+
+	u32 rate_class_cnt;
+	struct acx_rate_class rate_class[ACX_MAX_RATE_CLASSES];
+} __attribute__ ((packed));
+
+struct wl1251_acx_memory {
+	__le16 num_stations; /* number of STAs to be supported. */
+	u16 reserved_1;
+
+	/*
+	 * Nmber of memory buffers for the RX mem pool.
+	 * The actual number may be less if there are
+	 * not enough blocks left for the minimum num
+	 * of TX ones.
+	 */
+	u8 rx_mem_block_num;
+	u8 reserved_2;
+	u8 num_tx_queues; /* From 1 to 16 */
+	u8 host_if_options; /* HOST_IF* */
+	u8 tx_min_mem_block_num;
+	u8 num_ssid_profiles;
+	__le16 debug_buffer_size;
+} __attribute__ ((packed));
+
+
+#define ACX_RX_DESC_MIN                1
+#define ACX_RX_DESC_MAX                127
+#define ACX_RX_DESC_DEF                32
+struct wl1251_acx_rx_queue_config {
+	u8 num_descs;
+	u8 pad;
+	u8 type;
+	u8 priority;
+	__le32 dma_address;
+} __attribute__ ((packed));
+
+#define ACX_TX_DESC_MIN                1
+#define ACX_TX_DESC_MAX                127
+#define ACX_TX_DESC_DEF                16
+struct wl1251_acx_tx_queue_config {
+    u8 num_descs;
+    u8 pad[2];
+    u8 attributes;
+} __attribute__ ((packed));
+
+#define MAX_TX_QUEUE_CONFIGS 5
+#define MAX_TX_QUEUES 4
+struct wl1251_acx_config_memory {
+	struct acx_header header;
+
+	struct wl1251_acx_memory mem_config;
+	struct wl1251_acx_rx_queue_config rx_queue_config;
+	struct wl1251_acx_tx_queue_config tx_queue_config[MAX_TX_QUEUE_CONFIGS];
+} __attribute__ ((packed));
+
+struct wl1251_acx_mem_map {
+	struct acx_header header;
+
+	void *code_start;
+	void *code_end;
+
+	void *wep_defkey_start;
+	void *wep_defkey_end;
+
+	void *sta_table_start;
+	void *sta_table_end;
+
+	void *packet_template_start;
+	void *packet_template_end;
+
+	void *queue_memory_start;
+	void *queue_memory_end;
+
+	void *packet_memory_pool_start;
+	void *packet_memory_pool_end;
+
+	void *debug_buffer1_start;
+	void *debug_buffer1_end;
+
+	void *debug_buffer2_start;
+	void *debug_buffer2_end;
+
+	/* Number of blocks FW allocated for TX packets */
+	u32 num_tx_mem_blocks;
+
+	/* Number of blocks FW allocated for RX packets */
+	u32 num_rx_mem_blocks;
+} __attribute__ ((packed));
+
+/*************************************************************************
+
+    Host Interrupt Register (WiLink -> Host)
+
+**************************************************************************/
+
+/* RX packet is ready in Xfer buffer #0 */
+#define WL1251_ACX_INTR_RX0_DATA      BIT(0)
+
+/* TX result(s) are in the TX complete buffer */
+#define WL1251_ACX_INTR_TX_RESULT	BIT(1)
+
+/* OBSOLETE */
+#define WL1251_ACX_INTR_TX_XFR		BIT(2)
+
+/* RX packet is ready in Xfer buffer #1 */
+#define WL1251_ACX_INTR_RX1_DATA	BIT(3)
+
+/* Event was entered to Event MBOX #A */
+#define WL1251_ACX_INTR_EVENT_A		BIT(4)
+
+/* Event was entered to Event MBOX #B */
+#define WL1251_ACX_INTR_EVENT_B		BIT(5)
+
+/* OBSOLETE */
+#define WL1251_ACX_INTR_WAKE_ON_HOST	BIT(6)
+
+/* Trace meassge on MBOX #A */
+#define WL1251_ACX_INTR_TRACE_A		BIT(7)
+
+/* Trace meassge on MBOX #B */
+#define WL1251_ACX_INTR_TRACE_B		BIT(8)
+
+/* Command processing completion */
+#define WL1251_ACX_INTR_CMD_COMPLETE	BIT(9)
+
+/* Init sequence is done */
+#define WL1251_ACX_INTR_INIT_COMPLETE	BIT(14)
+
+#define WL1251_ACX_INTR_ALL           0xFFFFFFFF
+
 enum {
 	ACX_WAKE_UP_CONDITIONS      = 0x0002,
 	ACX_MEM_CFG                 = 0x0003,
@@ -1142,5 +1286,7 @@ int wl1251_acx_cts_protect(struct wl1251 *wl,
 			    enum acx_ctsprotect_type ctsprotect);
 int wl1251_acx_statistics(struct wl1251 *wl, struct acx_statistics *stats);
 int wl1251_acx_tsf_info(struct wl1251 *wl, u64 *mactime);
+int wl1251_acx_rate_policies(struct wl1251 *wl);
+int wl1251_acx_mem_cfg(struct wl1251 *wl);
 
 #endif /* __WL1251_ACX_H__ */
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 8b50d44..88e9cb0 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -28,6 +28,7 @@
 #include "wl1251_io.h"
 #include "wl1251_spi.h"
 #include "wl1251_event.h"
+#include "wl1251_acx.h"
 
 void wl1251_boot_target_enable_interrupts(struct wl1251 *wl)
 {
@@ -208,18 +209,30 @@ int wl1251_boot_init_seq(struct wl1251 *wl)
 	return 0;
 }
 
+static void wl1251_boot_set_ecpu_ctrl(struct wl1251 *wl, u32 flag)
+{
+	u32 cpu_ctrl;
+
+	/* 10.5.0 run the firmware (I) */
+	cpu_ctrl = wl1251_reg_read32(wl, ACX_REG_ECPU_CONTROL);
+
+	/* 10.5.1 run the firmware (II) */
+	cpu_ctrl &= ~flag;
+	wl1251_reg_write32(wl, ACX_REG_ECPU_CONTROL, cpu_ctrl);
+}
+
 int wl1251_boot_run_firmware(struct wl1251 *wl)
 {
 	int loop, ret;
 	u32 chip_id, interrupt;
 
-	wl->chip.op_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
+	wl1251_boot_set_ecpu_ctrl(wl, ECPU_CONTROL_HALT);
 
 	chip_id = wl1251_reg_read32(wl, CHIP_ID_B);
 
 	wl1251_debug(DEBUG_BOOT, "chip id after firmware boot: 0x%x", chip_id);
 
-	if (chip_id != wl->chip.id) {
+	if (chip_id != wl->chip_id) {
 		wl1251_error("chip id doesn't match after firmware boot");
 		return -EIO;
 	}
@@ -236,9 +249,9 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 			return -EIO;
 		}
 		/* check that ACX_INTR_INIT_COMPLETE is enabled */
-		else if (interrupt & wl->chip.intr_init_complete) {
+		else if (interrupt & WL1251_ACX_INTR_INIT_COMPLETE) {
 			wl1251_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
-					   wl->chip.intr_init_complete);
+					   WL1251_ACX_INTR_INIT_COMPLETE);
 			break;
 		}
 	}
@@ -256,16 +269,15 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 	wl->event_box_addr = wl1251_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
-	wl1251_set_partition(wl,
-			     wl->chip.p_table[PART_WORK].mem.start,
-			     wl->chip.p_table[PART_WORK].mem.size,
-			     wl->chip.p_table[PART_WORK].reg.start,
-			     wl->chip.p_table[PART_WORK].reg.size);
+	wl1251_set_partition(wl, WL1251_PART_WORK_MEM_START,
+			     WL1251_PART_WORK_MEM_SIZE,
+			     WL1251_PART_WORK_REG_START,
+			     WL1251_PART_WORK_REG_SIZE);
 
 	wl1251_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
 		     wl->cmd_box_addr, wl->event_box_addr);
 
-	wl->chip.op_fw_version(wl);
+	wl1251_acx_fw_version(wl, wl->fw_ver, sizeof(wl->fw_ver));
 
 	/*
 	 * in case of full asynchronous mode the firmware event must be
@@ -275,7 +287,14 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 	/* enable gpio interrupts */
 	wl1251_enable_interrupts(wl);
 
-	wl->chip.op_target_enable_interrupts(wl);
+	/* Enable target's interrupts */
+	wl->intr_mask = WL1251_ACX_INTR_RX0_DATA |
+		WL1251_ACX_INTR_RX1_DATA |
+		WL1251_ACX_INTR_TX_RESULT |
+		WL1251_ACX_INTR_EVENT_A |
+		WL1251_ACX_INTR_EVENT_B |
+		WL1251_ACX_INTR_INIT_COMPLETE;
+	wl1251_boot_target_enable_interrupts(wl);
 
 	/* unmask all mbox events  */
 	wl->event_mask = 0xffffffff;
@@ -291,3 +310,218 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 	/* firmware startup completed */
 	return 0;
 }
+
+static int wl1251_boot_upload_firmware(struct wl1251 *wl)
+{
+	int addr, chunk_num, partition_limit;
+	size_t fw_data_len;
+	u8 *p;
+
+	/* whal_FwCtrl_LoadFwImageSm() */
+
+	wl1251_debug(DEBUG_BOOT, "chip id before fw upload: 0x%x",
+		     wl1251_reg_read32(wl, CHIP_ID_B));
+
+	/* 10.0 check firmware length and set partition */
+	fw_data_len =  (wl->fw[4] << 24) | (wl->fw[5] << 16) |
+		(wl->fw[6] << 8) | (wl->fw[7]);
+
+	wl1251_debug(DEBUG_BOOT, "fw_data_len %zu chunk_size %d", fw_data_len,
+		CHUNK_SIZE);
+
+	if ((fw_data_len % 4) != 0) {
+		wl1251_error("firmware length not multiple of four");
+		return -EIO;
+	}
+
+	wl1251_set_partition(wl, WL1251_PART_DOWN_MEM_START,
+			     WL1251_PART_DOWN_MEM_SIZE,
+			     WL1251_PART_DOWN_REG_START,
+			     WL1251_PART_DOWN_REG_SIZE);
+
+	/* 10.1 set partition limit and chunk num */
+	chunk_num = 0;
+	partition_limit = WL1251_PART_DOWN_MEM_SIZE;
+
+	while (chunk_num < fw_data_len / CHUNK_SIZE) {
+		/* 10.2 update partition, if needed */
+		addr = WL1251_PART_DOWN_MEM_START +
+			(chunk_num + 2) * CHUNK_SIZE;
+		if (addr > partition_limit) {
+			addr = WL1251_PART_DOWN_MEM_START +
+				chunk_num * CHUNK_SIZE;
+			partition_limit = chunk_num * CHUNK_SIZE +
+				WL1251_PART_DOWN_MEM_SIZE;
+			wl1251_set_partition(wl,
+					     addr,
+					     WL1251_PART_DOWN_MEM_SIZE,
+					     WL1251_PART_DOWN_REG_START,
+					     WL1251_PART_DOWN_REG_SIZE);
+		}
+
+		/* 10.3 upload the chunk */
+		addr = WL1251_PART_DOWN_MEM_START + chunk_num * CHUNK_SIZE;
+		p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
+		wl1251_debug(DEBUG_BOOT, "uploading fw chunk 0x%p to 0x%x",
+			     p, addr);
+		wl1251_mem_write(wl, addr, p, CHUNK_SIZE);
+
+		chunk_num++;
+	}
+
+	/* 10.4 upload the last chunk */
+	addr = WL1251_PART_DOWN_MEM_START + chunk_num * CHUNK_SIZE;
+	p = wl->fw + FW_HDR_SIZE + chunk_num * CHUNK_SIZE;
+	wl1251_debug(DEBUG_BOOT, "uploading fw last chunk (%zu B) 0x%p to 0x%x",
+		     fw_data_len % CHUNK_SIZE, p, addr);
+	wl1251_mem_write(wl, addr, p, fw_data_len % CHUNK_SIZE);
+
+	return 0;
+}
+
+static int wl1251_boot_upload_nvs(struct wl1251 *wl)
+{
+	size_t nvs_len, nvs_bytes_written, burst_len;
+	int nvs_start, i;
+	u32 dest_addr, val;
+	u8 *nvs_ptr, *nvs;
+
+	nvs = wl->nvs;
+	if (nvs == NULL)
+		return -ENODEV;
+
+	nvs_ptr = nvs;
+
+	nvs_len = wl->nvs_len;
+	nvs_start = wl->fw_len;
+
+	/*
+	 * Layout before the actual NVS tables:
+	 * 1 byte : burst length.
+	 * 2 bytes: destination address.
+	 * n bytes: data to burst copy.
+	 *
+	 * This is ended by a 0 length, then the NVS tables.
+	 */
+
+	while (nvs_ptr[0]) {
+		burst_len = nvs_ptr[0];
+		dest_addr = (nvs_ptr[1] & 0xfe) | ((u32)(nvs_ptr[2] << 8));
+
+		/* We move our pointer to the data */
+		nvs_ptr += 3;
+
+		for (i = 0; i < burst_len; i++) {
+			val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
+			       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
+
+			wl1251_debug(DEBUG_BOOT,
+				     "nvs burst write 0x%x: 0x%x",
+				     dest_addr, val);
+			wl1251_mem_write32(wl, dest_addr, val);
+
+			nvs_ptr += 4;
+			dest_addr += 4;
+		}
+	}
+
+	/*
+	 * We've reached the first zero length, the first NVS table
+	 * is 7 bytes further.
+	 */
+	nvs_ptr += 7;
+	nvs_len -= nvs_ptr - nvs;
+	nvs_len = ALIGN(nvs_len, 4);
+
+	/* Now we must set the partition correctly */
+	wl1251_set_partition(wl, nvs_start,
+			     WL1251_PART_DOWN_MEM_SIZE,
+			     WL1251_PART_DOWN_REG_START,
+			     WL1251_PART_DOWN_REG_SIZE);
+
+	/* And finally we upload the NVS tables */
+	nvs_bytes_written = 0;
+	while (nvs_bytes_written < nvs_len) {
+		val = (nvs_ptr[0] | (nvs_ptr[1] << 8)
+		       | (nvs_ptr[2] << 16) | (nvs_ptr[3] << 24));
+
+		val = cpu_to_le32(val);
+
+		wl1251_debug(DEBUG_BOOT,
+			     "nvs write table 0x%x: 0x%x",
+			     nvs_start, val);
+		wl1251_mem_write32(wl, nvs_start, val);
+
+		nvs_ptr += 4;
+		nvs_bytes_written += 4;
+		nvs_start += 4;
+	}
+
+	return 0;
+}
+
+int wl1251_boot(struct wl1251 *wl)
+{
+	int ret = 0, minor_minor_e2_ver;
+	u32 tmp, boot_data;
+
+	ret = wl1251_boot_soft_reset(wl);
+	if (ret < 0)
+		goto out;
+
+	/* 2. start processing NVS file */
+	ret = wl1251_boot_upload_nvs(wl);
+	if (ret < 0)
+		goto out;
+
+	/* write firmware's last address (ie. it's length) to
+	 * ACX_EEPROMLESS_IND_REG */
+	wl1251_reg_write32(wl, ACX_EEPROMLESS_IND_REG, wl->fw_len);
+
+	/* 6. read the EEPROM parameters */
+	tmp = wl1251_reg_read32(wl, SCR_PAD2);
+
+	/* 7. read bootdata */
+	wl->boot_attr.radio_type = (tmp & 0x0000FF00) >> 8;
+	wl->boot_attr.major = (tmp & 0x00FF0000) >> 16;
+	tmp = wl1251_reg_read32(wl, SCR_PAD3);
+
+	/* 8. check bootdata and call restart sequence */
+	wl->boot_attr.minor = (tmp & 0x00FF0000) >> 16;
+	minor_minor_e2_ver = (tmp & 0xFF000000) >> 24;
+
+	wl1251_debug(DEBUG_BOOT, "radioType 0x%x majorE2Ver 0x%x "
+		     "minorE2Ver 0x%x minor_minor_e2_ver 0x%x",
+		     wl->boot_attr.radio_type, wl->boot_attr.major,
+		     wl->boot_attr.minor, minor_minor_e2_ver);
+
+	ret = wl1251_boot_init_seq(wl);
+	if (ret < 0)
+		goto out;
+
+	/* 9. NVS processing done */
+	boot_data = wl1251_reg_read32(wl, ACX_REG_ECPU_CONTROL);
+
+	wl1251_debug(DEBUG_BOOT, "halt boot_data 0x%x", boot_data);
+
+	/* 10. check that ECPU_CONTROL_HALT bits are set in
+	 * pWhalBus->uBootData and start uploading firmware
+	 */
+	if ((boot_data & ECPU_CONTROL_HALT) == 0) {
+		wl1251_error("boot failed, ECPU_CONTROL_HALT not set");
+		ret = -EIO;
+		goto out;
+	}
+
+	ret = wl1251_boot_upload_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+	/* 10.5 start firmware */
+	ret = wl1251_boot_run_firmware(wl);
+	if (ret < 0)
+		goto out;
+
+out:
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.h b/drivers/net/wireless/wl12xx/wl1251_boot.h
index 798362d..9006369 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.h
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.h
@@ -30,6 +30,7 @@ int wl1251_boot_soft_reset(struct wl1251 *wl);
 int wl1251_boot_init_seq(struct wl1251 *wl);
 int wl1251_boot_run_firmware(struct wl1251 *wl);
 void wl1251_boot_target_enable_interrupts(struct wl1251 *wl);
+int wl1251_boot(struct wl1251 *wl);
 
 /* number of times we try to read the INIT interrupt */
 #define INIT_LOOP 20000
diff --git a/drivers/net/wireless/wl12xx/wl1251_cmd.c b/drivers/net/wireless/wl12xx/wl1251_cmd.c
index dfbf681..53f5da6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1251_cmd.c
@@ -37,7 +37,7 @@ int wl1251_cmd_send(struct wl1251 *wl, u16 id, void *buf, size_t len)
 	timeout = jiffies + msecs_to_jiffies(WL1251_COMMAND_TIMEOUT);
 
 	intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_NO_CLEAR);
-	while (!(intr & wl->chip.intr_cmd_complete)) {
+	while (!(intr & WL1251_ACX_INTR_CMD_COMPLETE)) {
 		if (time_after(jiffies, timeout)) {
 			wl1251_error("command complete timeout");
 			ret = -ETIMEDOUT;
@@ -50,7 +50,7 @@ int wl1251_cmd_send(struct wl1251 *wl, u16 id, void *buf, size_t len)
 	}
 
 	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_ACK,
-			   wl->chip.intr_cmd_complete);
+			   WL1251_ACX_INTR_CMD_COMPLETE);
 
 out:
 	return ret;
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.c b/drivers/net/wireless/wl12xx/wl1251_init.c
index df6c60f..1c587ec 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.c
+++ b/drivers/net/wireless/wl12xx/wl1251_init.c
@@ -28,6 +28,7 @@
 #include "wl12xx_80211.h"
 #include "wl1251_acx.h"
 #include "wl1251_cmd.h"
+#include "reg.h"
 
 int wl1251_hw_init_hwenc_config(struct wl1251 *wl)
 {
@@ -198,3 +199,215 @@ int wl1251_hw_init_power_auth(struct wl1251 *wl)
 {
 	return wl1251_acx_sleep_auth(wl, WL1251_PSM_CAM);
 }
+
+int wl1251_hw_init_mem_config(struct wl1251 *wl)
+{
+	int ret;
+
+	ret = wl1251_acx_mem_cfg(wl);
+	if (ret < 0)
+		return ret;
+
+	wl->target_mem_map = kzalloc(sizeof(struct wl1251_acx_mem_map),
+					  GFP_KERNEL);
+	if (!wl->target_mem_map) {
+		wl1251_error("couldn't allocate target memory map");
+		return -ENOMEM;
+	}
+
+	/* we now ask for the firmware built memory map */
+	ret = wl1251_acx_mem_map(wl, wl->target_mem_map,
+				 sizeof(struct wl1251_acx_mem_map));
+	if (ret < 0) {
+		wl1251_error("couldn't retrieve firmware memory map");
+		kfree(wl->target_mem_map);
+		wl->target_mem_map = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+static int wl1251_hw_init_txq_fill(u8 qid,
+				   struct acx_tx_queue_qos_config *config,
+				   u32 num_blocks)
+{
+	config->qid = qid;
+
+	switch (qid) {
+	case QOS_AC_BE:
+		config->high_threshold =
+			(QOS_TX_HIGH_BE_DEF * num_blocks) / 100;
+		config->low_threshold =
+			(QOS_TX_LOW_BE_DEF * num_blocks) / 100;
+		break;
+	case QOS_AC_BK:
+		config->high_threshold =
+			(QOS_TX_HIGH_BK_DEF * num_blocks) / 100;
+		config->low_threshold =
+			(QOS_TX_LOW_BK_DEF * num_blocks) / 100;
+		break;
+	case QOS_AC_VI:
+		config->high_threshold =
+			(QOS_TX_HIGH_VI_DEF * num_blocks) / 100;
+		config->low_threshold =
+			(QOS_TX_LOW_VI_DEF * num_blocks) / 100;
+		break;
+	case QOS_AC_VO:
+		config->high_threshold =
+			(QOS_TX_HIGH_VO_DEF * num_blocks) / 100;
+		config->low_threshold =
+			(QOS_TX_LOW_VO_DEF * num_blocks) / 100;
+		break;
+	default:
+		wl1251_error("Invalid TX queue id: %d", qid);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int wl1251_hw_init_tx_queue_config(struct wl1251 *wl)
+{
+	struct acx_tx_queue_qos_config *config;
+	struct wl1251_acx_mem_map *wl_mem_map = wl->target_mem_map;
+	int ret, i;
+
+	wl1251_debug(DEBUG_ACX, "acx tx queue config");
+
+	config = kzalloc(sizeof(*config), GFP_KERNEL);
+	if (!config) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < MAX_NUM_OF_AC; i++) {
+		ret = wl1251_hw_init_txq_fill(i, config,
+					      wl_mem_map->num_tx_mem_blocks);
+		if (ret < 0)
+			goto out;
+
+		ret = wl1251_cmd_configure(wl, ACX_TX_QUEUE_CFG,
+					   config, sizeof(*config));
+		if (ret < 0)
+			goto out;
+	}
+
+out:
+	kfree(config);
+	return ret;
+}
+
+static int wl1251_hw_init_data_path_config(struct wl1251 *wl)
+{
+	int ret;
+
+	/* asking for the data path parameters */
+	wl->data_path = kzalloc(sizeof(struct acx_data_path_params_resp),
+				GFP_KERNEL);
+	if (!wl->data_path) {
+		wl1251_error("Couldnt allocate data path parameters");
+		return -ENOMEM;
+	}
+
+	ret = wl1251_acx_data_path_params(wl, wl->data_path);
+	if (ret < 0) {
+		kfree(wl->data_path);
+		wl->data_path = NULL;
+		return ret;
+	}
+
+	return 0;
+}
+
+
+int wl1251_hw_init(struct wl1251 *wl)
+{
+	struct wl1251_acx_mem_map *wl_mem_map;
+	int ret;
+
+	ret = wl1251_hw_init_hwenc_config(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Template settings */
+	ret = wl1251_hw_init_templates_config(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Default memory configuration */
+	ret = wl1251_hw_init_mem_config(wl);
+	if (ret < 0)
+		return ret;
+
+	/* Default data path configuration  */
+	ret = wl1251_hw_init_data_path_config(wl);
+	if (ret < 0)
+		goto out_free_memmap;
+
+	/* RX config */
+	ret = wl1251_hw_init_rx_config(wl,
+				       RX_CFG_PROMISCUOUS | RX_CFG_TSF,
+				       RX_FILTER_OPTION_DEF);
+	/* RX_CONFIG_OPTION_ANY_DST_ANY_BSS,
+	   RX_FILTER_OPTION_FILTER_ALL); */
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* TX queues config */
+	ret = wl1251_hw_init_tx_queue_config(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* PHY layer config */
+	ret = wl1251_hw_init_phy_config(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* Beacon filtering */
+	ret = wl1251_hw_init_beacon_filter(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* Bluetooth WLAN coexistence */
+	ret = wl1251_hw_init_pta(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* Energy detection */
+	ret = wl1251_hw_init_energy_detection(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* Beacons and boradcast settings */
+	ret = wl1251_hw_init_beacon_broadcast(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* Enable data path */
+	ret = wl1251_cmd_data_path(wl, wl->channel, 1);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	/* Default power state */
+	ret = wl1251_hw_init_power_auth(wl);
+	if (ret < 0)
+		goto out_free_data_path;
+
+	wl_mem_map = wl->target_mem_map;
+	wl1251_info("%d tx blocks at 0x%x, %d rx blocks at 0x%x",
+		    wl_mem_map->num_tx_mem_blocks,
+		    wl->data_path->tx_control_addr,
+		    wl_mem_map->num_rx_mem_blocks,
+		    wl->data_path->rx_control_addr);
+
+	return 0;
+
+ out_free_data_path:
+	kfree(wl->data_path);
+
+ out_free_memmap:
+	kfree(wl->target_mem_map);
+
+	return ret;
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_init.h b/drivers/net/wireless/wl12xx/wl1251_init.h
index 8596188..b3b25ec 100644
--- a/drivers/net/wireless/wl12xx/wl1251_init.h
+++ b/drivers/net/wireless/wl12xx/wl1251_init.h
@@ -35,5 +35,7 @@ int wl1251_hw_init_pta(struct wl1251 *wl);
 int wl1251_hw_init_energy_detection(struct wl1251 *wl);
 int wl1251_hw_init_beacon_broadcast(struct wl1251 *wl);
 int wl1251_hw_init_power_auth(struct wl1251 *wl);
+int wl1251_hw_init_mem_config(struct wl1251 *wl);
+int wl1251_hw_init(struct wl1251 *wl);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.c b/drivers/net/wireless/wl12xx/wl1251_io.c
index db2cfbf..04e486c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_io.c
+++ b/drivers/net/wireless/wl12xx/wl1251_io.c
@@ -25,6 +25,21 @@
 #include "reg.h"
 #include "wl1251_io.h"
 
+/* FIXME: this is static data nowadays and the table can be removed */
+static enum wl12xx_acx_int_reg wl1251_io_reg_table[ACX_REG_TABLE_LEN] = {
+	[ACX_REG_INTERRUPT_TRIG]     = (REGISTERS_BASE + 0x0474),
+	[ACX_REG_INTERRUPT_TRIG_H]   = (REGISTERS_BASE + 0x0478),
+	[ACX_REG_INTERRUPT_MASK]     = (REGISTERS_BASE + 0x0494),
+	[ACX_REG_HINT_MASK_SET]      = (REGISTERS_BASE + 0x0498),
+	[ACX_REG_HINT_MASK_CLR]      = (REGISTERS_BASE + 0x049C),
+	[ACX_REG_INTERRUPT_NO_CLEAR] = (REGISTERS_BASE + 0x04B0),
+	[ACX_REG_INTERRUPT_CLEAR]    = (REGISTERS_BASE + 0x04A4),
+	[ACX_REG_INTERRUPT_ACK]      = (REGISTERS_BASE + 0x04A8),
+	[ACX_REG_SLV_SOFT_RESET]     = (REGISTERS_BASE + 0x0000),
+	[ACX_REG_EE_START]           = (REGISTERS_BASE + 0x080C),
+	[ACX_REG_ECPU_CONTROL]       = (REGISTERS_BASE + 0x0804)
+};
+
 static int wl1251_translate_reg_addr(struct wl1251 *wl, int addr)
 {
 	/* If the address is lower than REGISTERS_BASE, it means that this is
@@ -36,7 +51,7 @@ static int wl1251_translate_reg_addr(struct wl1251 *wl, int addr)
 			wl1251_error("address out of range (%d)", addr);
 			return -EINVAL;
 		}
-		addr = wl->chip.acx_reg_table[addr];
+		addr = wl1251_io_reg_table[addr];
 	}
 
 	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 4c1aad3..8c88fe2 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -32,7 +32,6 @@
 #include "wl1251.h"
 #include "wl12xx_80211.h"
 #include "reg.h"
-#include "wl1251_ops.h"
 #include "wl1251_io.h"
 #include "wl1251_cmd.h"
 #include "wl1251_event.h"
@@ -41,6 +40,7 @@
 #include "wl1251_ps.h"
 #include "wl1251_init.h"
 #include "wl1251_debugfs.h"
+#include "wl1251_boot.h"
 
 void wl1251_enable_interrupts(struct wl1251 *wl)
 {
@@ -68,7 +68,7 @@ static int wl1251_fetch_firmware(struct wl1251 *wl)
 	struct device *dev = wiphy_dev(wl->hw->wiphy);
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.fw_filename, dev);
+	ret = request_firmware(&fw, WL1251_FW_NAME, dev);
 
 	if (ret < 0) {
 		wl1251_error("could not get firmware: %d", ret);
@@ -107,7 +107,7 @@ static int wl1251_fetch_nvs(struct wl1251 *wl)
 	struct device *dev = wiphy_dev(wl->hw->wiphy);
 	int ret;
 
-	ret = request_firmware(&fw, wl->chip.nvs_filename, dev);
+	ret = request_firmware(&fw, WL1251_NVS_NAME, dev);
 
 	if (ret < 0) {
 		wl1251_error("could not get nvs file: %d", ret);
@@ -157,7 +157,7 @@ static int wl1251_chip_wakeup(struct wl1251 *wl)
 	int ret = 0;
 
 	wl1251_power_on(wl);
-	msleep(wl->chip.power_on_sleep);
+	msleep(WL1251_POWER_ON_SLEEP);
 	wl->if_ops->reset(wl);
 
 	/* We don't need a real memory partition here, because we only want
@@ -174,22 +174,19 @@ static int wl1251_chip_wakeup(struct wl1251 *wl)
 	/* whal_FwCtrl_BootSm() */
 
 	/* 0. read chip id from CHIP_ID */
-	wl->chip.id = wl1251_reg_read32(wl, CHIP_ID_B);
+	wl->chip_id = wl1251_reg_read32(wl, CHIP_ID_B);
 
 	/* 1. check if chip id is valid */
 
-	switch (wl->chip.id) {
+	switch (wl->chip_id) {
 	case CHIP_ID_1251_PG12:
 		wl1251_debug(DEBUG_BOOT, "chip id 0x%x (1251 PG12)",
-			     wl->chip.id);
-
-		wl1251_setup(wl);
-
+			     wl->chip_id);
 		break;
 	case CHIP_ID_1251_PG10:
 	case CHIP_ID_1251_PG11:
 	default:
-		wl1251_error("unsupported chip id: 0x%x", wl->chip.id);
+		wl1251_error("unsupported chip id: 0x%x", wl->chip_id);
 		ret = -ENODEV;
 		goto out;
 	}
@@ -211,6 +208,107 @@ out:
 	return ret;
 }
 
+static void wl1251_irq_work(struct work_struct *work)
+{
+	u32 intr;
+	struct wl1251 *wl =
+		container_of(work, struct wl1251, irq_work);
+	int ret;
+
+	mutex_lock(&wl->mutex);
+
+	wl1251_debug(DEBUG_IRQ, "IRQ work");
+
+	if (wl->state == WL1251_STATE_OFF)
+		goto out;
+
+	ret = wl1251_ps_elp_wakeup(wl);
+	if (ret < 0)
+		goto out;
+
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1251_ACX_INTR_ALL);
+
+	intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
+	wl1251_debug(DEBUG_IRQ, "intr: 0x%x", intr);
+
+	if (wl->data_path) {
+		wl->rx_counter =
+			wl1251_mem_read32(wl, wl->data_path->rx_control_addr);
+
+		/* We handle a frmware bug here */
+		switch ((wl->rx_counter - wl->rx_handled) & 0xf) {
+		case 0:
+			wl1251_debug(DEBUG_IRQ, "RX: FW and host in sync");
+			intr &= ~WL1251_ACX_INTR_RX0_DATA;
+			intr &= ~WL1251_ACX_INTR_RX1_DATA;
+			break;
+		case 1:
+			wl1251_debug(DEBUG_IRQ, "RX: FW +1");
+			intr |= WL1251_ACX_INTR_RX0_DATA;
+			intr &= ~WL1251_ACX_INTR_RX1_DATA;
+			break;
+		case 2:
+			wl1251_debug(DEBUG_IRQ, "RX: FW +2");
+			intr |= WL1251_ACX_INTR_RX0_DATA;
+			intr |= WL1251_ACX_INTR_RX1_DATA;
+			break;
+		default:
+			wl1251_warning("RX: FW and host out of sync: %d",
+				       wl->rx_counter - wl->rx_handled);
+			break;
+		}
+
+		wl->rx_handled = wl->rx_counter;
+
+
+		wl1251_debug(DEBUG_IRQ, "RX counter: %d", wl->rx_counter);
+	}
+
+	intr &= wl->intr_mask;
+
+	if (intr == 0) {
+		wl1251_debug(DEBUG_IRQ, "INTR is 0");
+		wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
+				   ~(wl->intr_mask));
+
+		goto out_sleep;
+	}
+
+	if (intr & WL1251_ACX_INTR_RX0_DATA) {
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX0_DATA");
+		wl1251_rx(wl);
+	}
+
+	if (intr & WL1251_ACX_INTR_RX1_DATA) {
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX1_DATA");
+		wl1251_rx(wl);
+	}
+
+	if (intr & WL1251_ACX_INTR_TX_RESULT) {
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_TX_RESULT");
+		wl1251_tx_complete(wl);
+	}
+
+	if (intr & (WL1251_ACX_INTR_EVENT_A | WL1251_ACX_INTR_EVENT_B)) {
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT (0x%x)", intr);
+		if (intr & WL1251_ACX_INTR_EVENT_A)
+			wl1251_event_handle(wl, 0);
+		else
+			wl1251_event_handle(wl, 1);
+	}
+
+	if (intr & WL1251_ACX_INTR_INIT_COMPLETE)
+		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_INIT_COMPLETE");
+
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
+
+out_sleep:
+	wl1251_ps_elp_sleep(wl);
+
+out:
+	mutex_unlock(&wl->mutex);
+}
+
 static void wl1251_filter_work(struct work_struct *work)
 {
 	struct wl1251 *wl =
@@ -227,7 +325,7 @@ static void wl1251_filter_work(struct work_struct *work)
 		goto out;
 
 	/* FIXME: replace the magic numbers with proper definitions */
-	ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
+	ret = wl1251_cmd_join(wl, wl->bss_type, 1, 100, 0);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -289,11 +387,11 @@ static int wl1251_op_start(struct ieee80211_hw *hw)
 	if (ret < 0)
 		goto out;
 
-	ret = wl->chip.op_boot(wl);
+	ret = wl1251_boot(wl);
 	if (ret < 0)
 		goto out;
 
-	ret = wl->chip.op_hw_init(wl);
+	ret = wl1251_hw_init(wl);
 	if (ret < 0)
 		goto out;
 
@@ -303,7 +401,7 @@ static int wl1251_op_start(struct ieee80211_hw *hw)
 
 	wl->state = WL1251_STATE_ON;
 
-	wl1251_info("firmware booted (%s)", wl->chip.fw_ver);
+	wl1251_info("firmware booted (%s)", wl->fw_ver);
 
 out:
 	if (ret < 0)
@@ -346,7 +444,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	mutex_lock(&wl->mutex);
 
 	/* let's notify MAC80211 about the remaining pending TX frames */
-	wl->chip.op_tx_flush(wl);
+	wl1251_tx_flush(wl);
 	wl1251_power_off(wl);
 
 	memset(wl->bssid, 0, ETH_ALEN);
@@ -467,7 +565,7 @@ static int wl1251_op_config(struct ieee80211_hw *hw, u32 changed)
 
 	if (channel != wl->channel) {
 		/* FIXME: use beacon interval provided by mac80211 */
-		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl1251_cmd_join(wl, wl->bss_type, 1, 100, 0);
 		if (ret < 0)
 			goto out_sleep;
 
@@ -1041,7 +1139,7 @@ static void wl1251_op_bss_info_changed(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out;
 
-		ret = wl->chip.op_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl1251_cmd_join(wl, wl->bss_type, 1, 100, 0);
 
 		if (ret < 0)
 			goto out;
@@ -1232,15 +1330,14 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 
-	/* We use the default power on sleep time until we know which chip
-	 * we're using */
-	wl->chip.power_on_sleep = WL1251_DEFAULT_POWER_ON_SLEEP;
-
 	for (i = 0; i < FW_TX_CMPLT_BLOCK_SIZE; i++)
 		wl->tx_frames[i] = NULL;
 
 	wl->next_tx_complete = 0;
 
+	INIT_WORK(&wl->irq_work, wl1251_irq_work);
+	INIT_WORK(&wl->tx_work, wl1251_tx_work);
+
 	/*
 	 * In case our MAC address is not correctly set,
 	 * we use a random but Nokia MAC.
diff --git a/drivers/net/wireless/wl12xx/wl1251_ops.h b/drivers/net/wireless/wl12xx/wl1251_ops.h
deleted file mode 100644
index 68183c4..0000000
--- a/drivers/net/wireless/wl12xx/wl1251_ops.h
+++ /dev/null
@@ -1,165 +0,0 @@
-/*
- * This file is part of wl1251
- *
- * Copyright (C) 2008 Nokia Corporation
- *
- * Contact: Kalle Valo <kalle.valo@nokia.com>
- *
- * This program is free software; you can redistribute it and/or
- * modify it under the terms of the GNU General Public License
- * version 2 as published by the Free Software Foundation.
- *
- * This program is distributed in the hope that it will be useful, but
- * WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
- * General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
- * 02110-1301 USA
- *
- */
-
-#ifndef __WL1251_OPS_H__
-#define __WL1251_OPS_H__
-
-#include <linux/bitops.h>
-
-#include "wl1251.h"
-#include "wl1251_acx.h"
-
-#define WL1251_FW_NAME "wl1251-fw.bin"
-#define WL1251_NVS_NAME "wl1251-nvs.bin"
-
-#define WL1251_POWER_ON_SLEEP 10 /* in miliseconds */
-
-void wl1251_setup(struct wl1251 *wl);
-
-
-struct wl1251_acx_memory {
-	__le16 num_stations; /* number of STAs to be supported. */
-	u16 reserved_1;
-
-	/*
-	 * Nmber of memory buffers for the RX mem pool.
-	 * The actual number may be less if there are
-	 * not enough blocks left for the minimum num
-	 * of TX ones.
-	 */
-	u8 rx_mem_block_num;
-	u8 reserved_2;
-	u8 num_tx_queues; /* From 1 to 16 */
-	u8 host_if_options; /* HOST_IF* */
-	u8 tx_min_mem_block_num;
-	u8 num_ssid_profiles;
-	__le16 debug_buffer_size;
-} __attribute__ ((packed));
-
-
-#define ACX_RX_DESC_MIN                1
-#define ACX_RX_DESC_MAX                127
-#define ACX_RX_DESC_DEF                32
-struct wl1251_acx_rx_queue_config {
-	u8 num_descs;
-	u8 pad;
-	u8 type;
-	u8 priority;
-	__le32 dma_address;
-} __attribute__ ((packed));
-
-#define ACX_TX_DESC_MIN                1
-#define ACX_TX_DESC_MAX                127
-#define ACX_TX_DESC_DEF                16
-struct wl1251_acx_tx_queue_config {
-    u8 num_descs;
-    u8 pad[2];
-    u8 attributes;
-} __attribute__ ((packed));
-
-#define MAX_TX_QUEUE_CONFIGS 5
-#define MAX_TX_QUEUES 4
-struct wl1251_acx_config_memory {
-	struct acx_header header;
-
-	struct wl1251_acx_memory mem_config;
-	struct wl1251_acx_rx_queue_config rx_queue_config;
-	struct wl1251_acx_tx_queue_config tx_queue_config[MAX_TX_QUEUE_CONFIGS];
-} __attribute__ ((packed));
-
-struct wl1251_acx_mem_map {
-	struct acx_header header;
-
-	void *code_start;
-	void *code_end;
-
-	void *wep_defkey_start;
-	void *wep_defkey_end;
-
-	void *sta_table_start;
-	void *sta_table_end;
-
-	void *packet_template_start;
-	void *packet_template_end;
-
-	void *queue_memory_start;
-	void *queue_memory_end;
-
-	void *packet_memory_pool_start;
-	void *packet_memory_pool_end;
-
-	void *debug_buffer1_start;
-	void *debug_buffer1_end;
-
-	void *debug_buffer2_start;
-	void *debug_buffer2_end;
-
-	/* Number of blocks FW allocated for TX packets */
-	u32 num_tx_mem_blocks;
-
-	/* Number of blocks FW allocated for RX packets */
-	u32 num_rx_mem_blocks;
-} __attribute__ ((packed));
-
-/*************************************************************************
-
-    Host Interrupt Register (WiLink -> Host)
-
-**************************************************************************/
-
-/* RX packet is ready in Xfer buffer #0 */
-#define WL1251_ACX_INTR_RX0_DATA      BIT(0)
-
-/* TX result(s) are in the TX complete buffer */
-#define WL1251_ACX_INTR_TX_RESULT	BIT(1)
-
-/* OBSOLETE */
-#define WL1251_ACX_INTR_TX_XFR		BIT(2)
-
-/* RX packet is ready in Xfer buffer #1 */
-#define WL1251_ACX_INTR_RX1_DATA	BIT(3)
-
-/* Event was entered to Event MBOX #A */
-#define WL1251_ACX_INTR_EVENT_A		BIT(4)
-
-/* Event was entered to Event MBOX #B */
-#define WL1251_ACX_INTR_EVENT_B		BIT(5)
-
-/* OBSOLETE */
-#define WL1251_ACX_INTR_WAKE_ON_HOST	BIT(6)
-
-/* Trace meassge on MBOX #A */
-#define WL1251_ACX_INTR_TRACE_A		BIT(7)
-
-/* Trace meassge on MBOX #B */
-#define WL1251_ACX_INTR_TRACE_B		BIT(8)
-
-/* Command processing completion */
-#define WL1251_ACX_INTR_CMD_COMPLETE	BIT(9)
-
-/* Init sequence is done */
-#define WL1251_ACX_INTR_INIT_COMPLETE	BIT(14)
-
-#define WL1251_ACX_INTR_ALL           0xFFFFFFFF
-
-#endif

