Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog138.obsmtp.com ([74.125.149.19]:51206 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754384Ab2DKJiX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:38:23 -0400
Received: by lbok13 with SMTP id k13so786352lbo.17
        for <linux-wireless@vger.kernel.org>; Wed, 11 Apr 2012 02:38:19 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: arik@wizery.com, linville@tuxdriver.com, coelho@ti.com
Subject: [PATCH 06/16] wlcore/wl12xx: implement chip-specific partition tables
Date: Wed, 11 Apr 2012 12:37:53 +0300
Message-Id: <1334137083-13490-7-git-send-email-coelho@ti.com> (sfid-20120411_113833_672714_72A6D0F2)
In-Reply-To: <1334137083-13490-1-git-send-email-coelho@ti.com>
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add partition tables to wlcore, move and reorganize partition setting
functions.  Move wl12xx partition table to use the wlcore partition
table instead.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   |   62 +++++++++++++++
 drivers/net/wireless/ti/wlcore/boot.c   |   20 +++---
 drivers/net/wireless/ti/wlcore/debug.h  |    1 +
 drivers/net/wireless/ti/wlcore/io.c     |  126 +++++++++++++-----------------
 drivers/net/wireless/ti/wlcore/io.h     |   43 +++--------
 drivers/net/wireless/ti/wlcore/main.c   |    8 +-
 drivers/net/wireless/ti/wlcore/wl12xx.h |   20 -----
 drivers/net/wireless/ti/wlcore/wlcore.h |   27 +++++++-
 8 files changed, 168 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 0d30150..0d3ed7d 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -27,9 +27,70 @@
 #include "../wlcore/wlcore.h"
 #include "../wlcore/debug.h"
 
+#include "../wlcore/reg.h"
+
 static struct wlcore_ops wl12xx_ops = {
 };
 
+static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
+	[PART_DOWN] = {
+		.mem = {
+			.start = 0x00000000,
+			.size  = 0x000177c0
+		},
+		.reg = {
+			.start = REGISTERS_BASE,
+			.size  = 0x00008800
+		},
+		.mem2 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
+		.mem3 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
+	},
+
+	[PART_WORK] = {
+		.mem = {
+			.start = 0x00040000,
+			.size  = 0x00014fc0
+		},
+		.reg = {
+			.start = REGISTERS_BASE,
+			.size  = 0x0000a000
+		},
+		.mem2 = {
+			.start = 0x003004f8,
+			.size  = 0x00000004
+		},
+		.mem3 = {
+			.start = 0x00040404,
+			.size  = 0x00000000
+		},
+	},
+
+	[PART_DRPW] = {
+		.mem = {
+			.start = 0x00040000,
+			.size  = 0x00014fc0
+		},
+		.reg = {
+			.start = DRPW_BASE,
+			.size  = 0x00006000
+		},
+		.mem2 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
+		.mem3 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		}
+	}
+};
+
 static int __devinit wl12xx_probe(struct platform_device *pdev)
 {
 	struct wl1271 *wl;
@@ -43,6 +104,7 @@ static int __devinit wl12xx_probe(struct platform_device *pdev)
 
 	wl = hw->priv;
 	wl->ops = &wl12xx_ops;
+	wl->ptable = wl12xx_ptable;
 
 	return wlcore_probe(wl, pdev);
 }
diff --git a/drivers/net/wireless/ti/wlcore/boot.c b/drivers/net/wireless/ti/wlcore/boot.c
index 88d60c4..da37c59 100644
--- a/drivers/net/wireless/ti/wlcore/boot.c
+++ b/drivers/net/wireless/ti/wlcore/boot.c
@@ -108,7 +108,7 @@ static void wl1271_boot_fw_version(struct wl1271 *wl)
 static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 					     size_t fw_data_len, u32 dest)
 {
-	struct wl1271_partition_set partition;
+	struct wlcore_partition_set partition;
 	int addr, chunk_num, partition_limit;
 	u8 *p, *chunk;
 
@@ -130,13 +130,13 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		return -ENOMEM;
 	}
 
-	memcpy(&partition, &wl12xx_part_table[PART_DOWN], sizeof(partition));
+	memcpy(&partition, &wl->ptable[PART_DOWN], sizeof(partition));
 	partition.mem.start = dest;
-	wl1271_set_partition(wl, &partition);
+	wlcore_set_partition(wl, &partition);
 
 	/* 10.1 set partition limit and chunk num */
 	chunk_num = 0;
-	partition_limit = wl12xx_part_table[PART_DOWN].mem.size;
+	partition_limit = wl->ptable[PART_DOWN].mem.size;
 
 	while (chunk_num < fw_data_len / CHUNK_SIZE) {
 		/* 10.2 update partition, if needed */
@@ -144,9 +144,9 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		if (addr > partition_limit) {
 			addr = dest + chunk_num * CHUNK_SIZE;
 			partition_limit = chunk_num * CHUNK_SIZE +
-				wl12xx_part_table[PART_DOWN].mem.size;
+				wl->ptable[PART_DOWN].mem.size;
 			partition.mem.start = addr;
-			wl1271_set_partition(wl, &partition);
+			wlcore_set_partition(wl, &partition);
 		}
 
 		/* 10.3 upload the chunk */
@@ -332,7 +332,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	nvs_len -= nvs_ptr - (u8 *)wl->nvs;
 
 	/* Now we must set the partition correctly */
-	wl1271_set_partition(wl, &wl12xx_part_table[PART_WORK]);
+	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	/* Copy the NVS tables to a new block to ensure alignment */
 	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
@@ -441,7 +441,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	wl->event_box_addr = wl1271_read32(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
-	wl1271_set_partition(wl, &wl12xx_part_table[PART_WORK]);
+	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	wl1271_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
 		     wl->cmd_box_addr, wl->event_box_addr);
@@ -702,7 +702,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	wl1271_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
 	udelay(500);
 
-	wl1271_set_partition(wl, &wl12xx_part_table[PART_DRPW]);
+	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
 
 	/* Read-modify-write DRPW_SCRATCH_START register (see next state)
 	   to be used by DRPw FW. The RTRIM value will be added by the FW
@@ -721,7 +721,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
-	wl1271_set_partition(wl, &wl12xx_part_table[PART_WORK]);
+	wlcore_set_partition(wl, &wl->ptable[PART_WORK]);
 
 	/* Disable interrupts */
 	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
diff --git a/drivers/net/wireless/ti/wlcore/debug.h b/drivers/net/wireless/ti/wlcore/debug.h
index ec0fdc2..6b800b3 100644
--- a/drivers/net/wireless/ti/wlcore/debug.h
+++ b/drivers/net/wireless/ti/wlcore/debug.h
@@ -52,6 +52,7 @@ enum {
 	DEBUG_ADHOC     = BIT(16),
 	DEBUG_AP	= BIT(17),
 	DEBUG_PROBE	= BIT(18),
+	DEBUG_IO	= BIT(19),
 	DEBUG_MASTER	= (DEBUG_ADHOC | DEBUG_AP),
 	DEBUG_ALL	= ~0,
 };
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index b0701fb..65c562c 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -45,65 +45,6 @@
 #define OCP_STATUS_REQ_FAILED 0x20000
 #define OCP_STATUS_RESP_ERROR 0x30000
 
-struct wl1271_partition_set wl12xx_part_table[PART_TABLE_LEN] = {
-	[PART_DOWN] = {
-		.mem = {
-			.start = 0x00000000,
-			.size  = 0x000177c0
-		},
-		.reg = {
-			.start = REGISTERS_BASE,
-			.size  = 0x00008800
-		},
-		.mem2 = {
-			.start = 0x00000000,
-			.size  = 0x00000000
-		},
-		.mem3 = {
-			.start = 0x00000000,
-			.size  = 0x00000000
-		},
-	},
-
-	[PART_WORK] = {
-		.mem = {
-			.start = 0x00040000,
-			.size  = 0x00014fc0
-		},
-		.reg = {
-			.start = REGISTERS_BASE,
-			.size  = 0x0000a000
-		},
-		.mem2 = {
-			.start = 0x003004f8,
-			.size  = 0x00000004
-		},
-		.mem3 = {
-			.start = 0x00040404,
-			.size  = 0x00000000
-		},
-	},
-
-	[PART_DRPW] = {
-		.mem = {
-			.start = 0x00040000,
-			.size  = 0x00014fc0
-		},
-		.reg = {
-			.start = DRPW_BASE,
-			.size  = 0x00006000
-		},
-		.mem2 = {
-			.start = 0x00000000,
-			.size  = 0x00000000
-		},
-		.mem3 = {
-			.start = 0x00000000,
-			.size  = 0x00000000
-		}
-	}
-};
-
 bool wl1271_set_block_size(struct wl1271 *wl)
 {
 	if (wl->if_ops->set_block_size) {
@@ -124,7 +65,41 @@ void wl1271_enable_interrupts(struct wl1271 *wl)
 	enable_irq(wl->irq);
 }
 
-/* Set the SPI partitions to access the chip addresses
+int wlcore_translate_addr(struct wl1271 *wl, int addr)
+{
+	struct wlcore_partition_set *part = &wl->curr_part;
+
+	/*
+	 * To translate, first check to which window of addresses the
+	 * particular address belongs. Then subtract the starting address
+	 * of that window from the address. Then, add offset of the
+	 * translated region.
+	 *
+	 * The translated regions occur next to each other in physical device
+	 * memory, so just add the sizes of the preceding address regions to
+	 * get the offset to the new region.
+	 */
+	if ((addr >= part->mem.start) &&
+	    (addr < part->mem.start + part->mem.size))
+		return addr - part->mem.start;
+	else if ((addr >= part->reg.start) &&
+		 (addr < part->reg.start + part->reg.size))
+		return addr - part->reg.start + part->mem.size;
+	else if ((addr >= part->mem2.start) &&
+		 (addr < part->mem2.start + part->mem2.size))
+		return addr - part->mem2.start + part->mem.size +
+			part->reg.size;
+	else if ((addr >= part->mem3.start) &&
+		 (addr < part->mem3.start + part->mem3.size))
+		return addr - part->mem3.start + part->mem.size +
+			part->reg.size + part->mem2.size;
+
+	WARN(1, "HW address 0x%x out of range", addr);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(wlcore_translate_addr);
+
+/* Set the partitions to access the chip addresses
  *
  * To simplify driver code, a fixed (virtual) memory map is defined for
  * register and memory addresses. Because in the chipset, in different stages
@@ -158,33 +133,43 @@ void wl1271_enable_interrupts(struct wl1271 *wl)
  *                                    |    |
  *
  */
-int wl1271_set_partition(struct wl1271 *wl,
-			 struct wl1271_partition_set *p)
+void wlcore_set_partition(struct wl1271 *wl,
+			  const struct wlcore_partition_set *p)
 {
 	/* copy partition info */
-	memcpy(&wl->part, p, sizeof(*p));
+	memcpy(&wl->curr_part, p, sizeof(*p));
 
-	wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+	wl1271_debug(DEBUG_IO, "mem_start %08X mem_size %08X",
 		     p->mem.start, p->mem.size);
-	wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+	wl1271_debug(DEBUG_IO, "reg_start %08X reg_size %08X",
 		     p->reg.start, p->reg.size);
-	wl1271_debug(DEBUG_SPI, "mem2_start %08X mem2_size %08X",
+	wl1271_debug(DEBUG_IO, "mem2_start %08X mem2_size %08X",
 		     p->mem2.start, p->mem2.size);
-	wl1271_debug(DEBUG_SPI, "mem3_start %08X mem3_size %08X",
+	wl1271_debug(DEBUG_IO, "mem3_start %08X mem3_size %08X",
 		     p->mem3.start, p->mem3.size);
 
-	/* write partition info to the chipset */
 	wl1271_raw_write32(wl, HW_PART0_START_ADDR, p->mem.start);
 	wl1271_raw_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
 	wl1271_raw_write32(wl, HW_PART1_START_ADDR, p->reg.start);
 	wl1271_raw_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
 	wl1271_raw_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
 	wl1271_raw_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
+	/*
+	 * We don't need the size of the last partition, as it is
+	 * automatically calculated based on the total memory size and
+	 * the sizes of the previous partitions.
+	 */
 	wl1271_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
+}
+EXPORT_SYMBOL_GPL(wlcore_set_partition);
 
-	return 0;
+void wlcore_select_partition(struct wl1271 *wl, u8 part)
+{
+	wl1271_debug(DEBUG_IO, "setting partition %d", part);
+
+	wlcore_set_partition(wl, &wl->ptable[part]);
 }
-EXPORT_SYMBOL_GPL(wl1271_set_partition);
+EXPORT_SYMBOL_GPL(wlcore_select_partition);
 
 void wl1271_io_reset(struct wl1271 *wl)
 {
@@ -241,4 +226,3 @@ u16 wl1271_top_reg_read(struct wl1271 *wl, int addr)
 		return 0xffff;
 	}
 }
-
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 4fb3dab..495ab33 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -43,8 +43,6 @@
 
 #define HW_ACCESS_PRAM_MAX_RANGE	0x3c000
 
-extern struct wl1271_partition_set wl12xx_part_table[PART_TABLE_LEN];
-
 struct wl1271;
 
 void wl1271_disable_interrupts(struct wl1271 *wl);
@@ -52,6 +50,7 @@ void wl1271_enable_interrupts(struct wl1271 *wl);
 
 void wl1271_io_reset(struct wl1271 *wl);
 void wl1271_io_init(struct wl1271 *wl);
+int wlcore_translate_addr(struct wl1271 *wl, int addr);
 
 /* Raw target IO, address is not translated */
 static inline void wl1271_raw_write(struct wl1271 *wl, int addr, void *buf,
@@ -81,36 +80,12 @@ static inline void wl1271_raw_write32(struct wl1271 *wl, int addr, u32 val)
 			     sizeof(wl->buffer_32), false);
 }
 
-/* Translated target IO */
-static inline int wl1271_translate_addr(struct wl1271 *wl, int addr)
-{
-	/*
-	 * To translate, first check to which window of addresses the
-	 * particular address belongs. Then subtract the starting address
-	 * of that window from the address. Then, add offset of the
-	 * translated region.
-	 *
-	 * The translated regions occur next to each other in physical device
-	 * memory, so just add the sizes of the preceding address regions to
-	 * get the offset to the new region.
-	 *
-	 * Currently, only the two first regions are addressed, and the
-	 * assumption is that all addresses will fall into either of those
-	 * two.
-	 */
-	if ((addr >= wl->part.reg.start) &&
-	    (addr < wl->part.reg.start + wl->part.reg.size))
-		return addr - wl->part.reg.start + wl->part.mem.size;
-	else
-		return addr - wl->part.mem.start;
-}
-
 static inline void wl1271_read(struct wl1271 *wl, int addr, void *buf,
 			       size_t len, bool fixed)
 {
 	int physical;
 
-	physical = wl1271_translate_addr(wl, addr);
+	physical = wlcore_translate_addr(wl, addr);
 
 	wl1271_raw_read(wl, physical, buf, len, fixed);
 }
@@ -120,7 +95,7 @@ static inline void wl1271_write(struct wl1271 *wl, int addr, void *buf,
 {
 	int physical;
 
-	physical = wl1271_translate_addr(wl, addr);
+	physical = wlcore_translate_addr(wl, addr);
 
 	wl1271_raw_write(wl, physical, buf, len, fixed);
 }
@@ -134,19 +109,19 @@ static inline void wl1271_read_hwaddr(struct wl1271 *wl, int hwaddr,
 	/* Addresses are stored internally as addresses to 32 bytes blocks */
 	addr = hwaddr << 5;
 
-	physical = wl1271_translate_addr(wl, addr);
+	physical = wlcore_translate_addr(wl, addr);
 
 	wl1271_raw_read(wl, physical, buf, len, fixed);
 }
 
 static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
 {
-	return wl1271_raw_read32(wl, wl1271_translate_addr(wl, addr));
+	return wl1271_raw_read32(wl, wlcore_translate_addr(wl, addr));
 }
 
 static inline void wl1271_write32(struct wl1271 *wl, int addr, u32 val)
 {
-	wl1271_raw_write32(wl, wl1271_translate_addr(wl, addr), val);
+	wl1271_raw_write32(wl, wlcore_translate_addr(wl, addr), val);
 }
 
 static inline void wl1271_power_off(struct wl1271 *wl)
@@ -169,8 +144,8 @@ static inline int wl1271_power_on(struct wl1271 *wl)
 void wl1271_top_reg_write(struct wl1271 *wl, int addr, u16 val);
 u16 wl1271_top_reg_read(struct wl1271 *wl, int addr);
 
-int wl1271_set_partition(struct wl1271 *wl,
-			 struct wl1271_partition_set *p);
+void wlcore_set_partition(struct wl1271 *wl,
+			  const struct wlcore_partition_set *p);
 
 bool wl1271_set_block_size(struct wl1271 *wl);
 
@@ -178,4 +153,6 @@ bool wl1271_set_block_size(struct wl1271 *wl);
 
 int wl1271_tx_dummy_packet(struct wl1271 *wl);
 
+void wlcore_select_partition(struct wl1271 *wl, u8 part);
+
 #endif
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 194a8b0..30d47b2 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -1330,7 +1330,7 @@ static int wl12xx_set_power_on(struct wl1271 *wl)
 	wl1271_io_reset(wl);
 	wl1271_io_init(wl);
 
-	wl1271_set_partition(wl, &wl12xx_part_table[PART_DOWN]);
+	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 
 	/* ELP module wake up */
 	wl1271_fw_wakeup(wl);
@@ -5085,7 +5085,7 @@ static void wl12xx_get_fuse_mac(struct wl1271 *wl)
 {
 	u32 mac1, mac2;
 
-	wl1271_set_partition(wl, &wl12xx_part_table[PART_DRPW]);
+	wlcore_set_partition(wl, &wl->ptable[PART_DRPW]);
 
 	mac1 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_1);
 	mac2 = wl1271_read32(wl, WL12XX_REG_FUSE_BD_ADDR_2);
@@ -5095,7 +5095,7 @@ static void wl12xx_get_fuse_mac(struct wl1271 *wl)
 		((mac1 & 0xff000000) >> 24);
 	wl->fuse_nic_addr = mac1 & 0xffffff;
 
-	wl1271_set_partition(wl, &wl12xx_part_table[PART_DOWN]);
+	wlcore_set_partition(wl, &wl->ptable[PART_DOWN]);
 }
 
 static int wl12xx_get_hw_info(struct wl1271 *wl)
@@ -5485,7 +5485,7 @@ int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev)
 	unsigned long irqflags;
 	int ret;
 
-	if (!wl->ops) {
+	if (!wl->ops || !wl->ptable) {
 		ret = -EINVAL;
 		goto out_free_hw;
 	}
diff --git a/drivers/net/wireless/ti/wlcore/wl12xx.h b/drivers/net/wireless/ti/wlcore/wl12xx.h
index 37b2d64..c979920 100644
--- a/drivers/net/wireless/ti/wlcore/wl12xx.h
+++ b/drivers/net/wireless/ti/wlcore/wl12xx.h
@@ -105,26 +105,6 @@ enum wl12xx_fw_type {
 	WL12XX_FW_TYPE_PLT,
 };
 
-enum wl1271_partition_type {
-	PART_DOWN,
-	PART_WORK,
-	PART_DRPW,
-
-	PART_TABLE_LEN
-};
-
-struct wl1271_partition {
-	u32 size;
-	u32 start;
-};
-
-struct wl1271_partition_set {
-	struct wl1271_partition mem;
-	struct wl1271_partition reg;
-	struct wl1271_partition mem2;
-	struct wl1271_partition mem3;
-};
-
 struct wl1271;
 
 enum {
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0bcc6ad..84f05a4 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -30,6 +30,29 @@
 struct wlcore_ops {
 };
 
+enum wlcore_partitions {
+	PART_DOWN,
+	PART_WORK,
+	PART_BOOT,
+	PART_DRPW,
+	PART_TOP_PRCM_ELP_SOC,
+	PART_PHY_INIT,
+
+	PART_TABLE_LEN,
+};
+
+struct wlcore_partition {
+	u32 size;
+	u32 start;
+};
+
+struct wlcore_partition_set {
+	struct wlcore_partition mem;
+	struct wlcore_partition reg;
+	struct wlcore_partition mem2;
+	struct wlcore_partition mem3;
+};
+
 struct wl1271 {
 	struct ieee80211_hw *hw;
 	bool mac80211_registered;
@@ -54,7 +77,7 @@ struct wl1271 {
 
 	unsigned long flags;
 
-	struct wl1271_partition_set part;
+	struct wlcore_partition_set curr_part;
 
 	struct wl1271_chip chip;
 
@@ -241,6 +264,8 @@ struct wl1271 {
 	struct delayed_work tx_watchdog_work;
 
 	struct wlcore_ops *ops;
+	/* pointer to the lower driver partition table */
+	const struct wlcore_partition_set *ptable;
 };
 
 int __devinit wlcore_probe(struct wl1271 *wl, struct platform_device *pdev);
-- 
1.7.5.4

