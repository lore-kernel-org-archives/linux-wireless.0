Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:58699 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755935AbZJLMKq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:10:46 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 05/16] wl1271: Update memory mapping for firmware revision 6.1.0.0.241
Date: Mon, 12 Oct 2009 15:08:46 +0300
Message-Id: <1255349337-9776-6-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Update the memory regions and memory mapping to support firmware revision
6.1.0.0.241.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    7 +-
 drivers/net/wireless/wl12xx/wl1271_boot.c |   67 ++++++-----
 drivers/net/wireless/wl12xx/wl1271_main.c |   10 +-
 drivers/net/wireless/wl12xx/wl1271_spi.c  |  178 ++++++++++------------------
 drivers/net/wireless/wl12xx/wl1271_spi.h  |   15 ++-
 5 files changed, 116 insertions(+), 161 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 858bf6b..b2bc7b5 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -148,6 +148,8 @@ struct wl1271_partition {
 struct wl1271_partition_set {
 	struct wl1271_partition mem;
 	struct wl1271_partition reg;
+	struct wl1271_partition mem2;
+	struct wl1271_partition mem3;
 };
 
 struct wl1271;
@@ -302,10 +304,7 @@ struct wl1271 {
 	enum wl1271_state state;
 	struct mutex mutex;
 
-	int physical_mem_addr;
-	int physical_reg_addr;
-	int virtual_mem_addr;
-	int virtual_reg_addr;
+	struct wl1271_partition_set part;
 
 	struct wl1271_chip chip;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_boot.c b/drivers/net/wireless/wl12xx/wl1271_boot.c
index 140e943..2eb7836 100644
--- a/drivers/net/wireless/wl12xx/wl1271_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1271_boot.c
@@ -39,6 +39,14 @@ static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
 			.start = REGISTERS_BASE,
 			.size  = 0x00008800
 		},
+		.mem2 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
+		.mem3 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
 	},
 
 	[PART_WORK] = {
@@ -48,7 +56,15 @@ static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
 		},
 		.reg = {
 			.start = REGISTERS_BASE,
-			.size  = 0x0000b000
+			.size  = 0x0000a000
+		},
+		.mem2 = {
+			.start = 0x003004f8,
+			.size  = 0x00000004
+		},
+		.mem3 = {
+			.start = 0x00040404,
+			.size  = 0x00000000
 		},
 	},
 
@@ -60,6 +76,14 @@ static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
 		.reg = {
 			.start = DRPW_BASE,
 			.size  = 0x00006000
+		},
+		.mem2 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
+		},
+		.mem3 = {
+			.start = 0x00000000,
+			.size  = 0x00000000
 		}
 	}
 };
@@ -93,6 +117,7 @@ static void wl1271_boot_fw_version(struct wl1271 *wl)
 static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 					     size_t fw_data_len, u32 dest)
 {
+	struct wl1271_partition_set partition;
 	int addr, chunk_num, partition_limit;
 	u8 *p, *chunk;
 
@@ -114,10 +139,9 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		return -ENOMEM;
 	}
 
-	wl1271_set_partition(wl, dest,
-			     part_table[PART_DOWN].mem.size,
-			     part_table[PART_DOWN].reg.start,
-			     part_table[PART_DOWN].reg.size);
+	memcpy(&partition, &part_table[PART_DOWN], sizeof(partition));
+	partition.mem.start = dest;
+	wl1271_set_partition(wl, &partition);
 
 	/* 10.1 set partition limit and chunk num */
 	chunk_num = 0;
@@ -130,13 +154,8 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 			addr = dest + chunk_num * CHUNK_SIZE;
 			partition_limit = chunk_num * CHUNK_SIZE +
 				part_table[PART_DOWN].mem.size;
-
-			/* FIXME: Over 80 chars! */
-			wl1271_set_partition(wl,
-					     addr,
-					     part_table[PART_DOWN].mem.size,
-					     part_table[PART_DOWN].reg.start,
-					     part_table[PART_DOWN].reg.size);
+			partition.mem.start = addr;
+			wl1271_set_partition(wl, &partition);
 		}
 
 		/* 10.3 upload the chunk */
@@ -261,11 +280,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	/* FIXME: The driver sets the partition here, but this is not needed,
 	   since it sets to the same one as currently in use */
 	/* Now we must set the partition correctly */
-	wl1271_set_partition(wl,
-			     part_table[PART_WORK].mem.start,
-			     part_table[PART_WORK].mem.size,
-			     part_table[PART_WORK].reg.start,
-			     part_table[PART_WORK].reg.size);
+	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
 	/* Copy the NVS tables to a new block to ensure alignment */
 	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
@@ -371,11 +386,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	wl->event_box_addr = wl1271_reg_read32(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
-	wl1271_set_partition(wl,
-			     part_table[PART_WORK].mem.start,
-			     part_table[PART_WORK].mem.size,
-			     part_table[PART_WORK].reg.start,
-			     part_table[PART_WORK].reg.size);
+	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
 	wl1271_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
 		     wl->cmd_box_addr, wl->event_box_addr);
@@ -469,11 +480,7 @@ int wl1271_boot(struct wl1271 *wl)
 	wl1271_reg_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
 	udelay(500);
 
-	wl1271_set_partition(wl,
-			     part_table[PART_DRPW].mem.start,
-			     part_table[PART_DRPW].mem.size,
-			     part_table[PART_DRPW].reg.start,
-			     part_table[PART_DRPW].reg.size);
+	wl1271_set_partition(wl, &part_table[PART_DRPW]);
 
 	/* Read-modify-write DRPW_SCRATCH_START register (see next state)
 	   to be used by DRPw FW. The RTRIM value will be added by the FW
@@ -488,11 +495,7 @@ int wl1271_boot(struct wl1271 *wl)
 	clk |= (REF_CLOCK << 1) << 4;
 	wl1271_reg_write32(wl, DRPW_SCRATCH_START, clk);
 
-	wl1271_set_partition(wl,
-			     part_table[PART_WORK].mem.start,
-			     part_table[PART_WORK].mem.size,
-			     part_table[PART_WORK].reg.start,
-			     part_table[PART_WORK].reg.size);
+	wl1271_set_partition(wl, &part_table[PART_WORK]);
 
 	/* Disable interrupts */
 	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index b9f2091..22d44ba 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -315,6 +315,7 @@ static int wl1271_setup(struct wl1271 *wl)
 
 static int wl1271_chip_wakeup(struct wl1271 *wl)
 {
+	struct wl1271_partition_set partition;
 	int ret = 0;
 
 	wl1271_power_on(wl);
@@ -324,11 +325,10 @@ static int wl1271_chip_wakeup(struct wl1271 *wl)
 
 	/* We don't need a real memory partition here, because we only want
 	 * to use the registers at this point. */
-	wl1271_set_partition(wl,
-			     0x00000000,
-			     0x00000000,
-			     REGISTERS_BASE,
-			     REGISTERS_DOWN_SIZE);
+	memset(&partition, 0, sizeof(partition));
+	partition.reg.start = REGISTERS_BASE;
+	partition.reg.size = REGISTERS_DOWN_SIZE;
+	wl1271_set_partition(wl, &partition);
 
 	/* ELP module wake up */
 	wl1271_fw_wakeup(wl);
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.c b/drivers/net/wireless/wl12xx/wl1271_spi.c
index 504991a..367f2d3 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.c
@@ -30,17 +30,29 @@
 #include "wl12xx_80211.h"
 #include "wl1271_spi.h"
 
-static int wl1271_translate_reg_addr(struct wl1271 *wl, int addr)
+static int wl1271_translate_addr(struct wl1271 *wl, int addr)
 {
-	return addr - wl->physical_reg_addr + wl->virtual_reg_addr;
-}
-
-static int wl1271_translate_mem_addr(struct wl1271 *wl, int addr)
-{
-	return addr - wl->physical_mem_addr + wl->virtual_mem_addr;
+	/*
+	 * To translate, first check to which window of addresses the
+	 * particular address belongs. Then subtract the starting address
+	 * of that window from the address. Then, add offset of the
+	 * translated region.
+	 *
+	 * The translated regions occur next to each other in physical device
+	 * memory, so just add the sizes of the preceeding address regions to
+	 * get the offset to the new region.
+	 *
+	 * Currently, only the two first regions are addressed, and the
+	 * assumption is that all addresses will fall into either of those
+	 * two.
+	 */
+	if ((addr >= wl->part.reg.start) &&
+	    (addr < wl->part.reg.start + wl->part.reg.size))
+		return addr - wl->part.reg.start + wl->part.mem.size;
+	else
+		return addr - wl->part.mem.start;
 }
 
-
 void wl1271_spi_reset(struct wl1271 *wl)
 {
 	u8 *cmd;
@@ -123,123 +135,61 @@ void wl1271_spi_init(struct wl1271 *wl)
 
 /* Set the SPI partitions to access the chip addresses
  *
- * There are two VIRTUAL (SPI) partitions (the memory partition and the
- * registers partition), which are mapped to two different areas of the
- * PHYSICAL (hardware) memory.  This function also makes other checks to
- * ensure that the partitions are not overlapping.  In the diagram below, the
- * memory partition comes before the register partition, but the opposite is
- * also supported.
+ * To simplify driver code, a fixed (virtual) memory map is defined for
+ * register and memory addresses. Because in the chipset, in different stages
+ * of operation, those addresses will move around, an address translation
+ * mechanism is required.
  *
- *                               PHYSICAL address
+ * There are four partitions (three memory and one register partition),
+ * which are mapped to two different areas of the hardware memory.
+ *
+ *                                Virtual address
  *                                     space
  *
  *                                    |    |
- *                                 ...+----+--> mem_start
- *          VIRTUAL address     ...   |    |
+ *                                 ...+----+--> mem.start
+ *          Physical address    ...   |    |
  *               space       ...      |    | [PART_0]
  *                        ...         |    |
- * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
+ *  00000000  <--+----+...         ...+----+--> mem.start + mem.size
  *               |    |         ...   |    |
  *               |MEM |      ...      |    |
  *               |    |   ...         |    |
- *  part_size <--+----+...            |    | {unused area)
+ *  mem.size  <--+----+...            |    | {unused area)
  *               |    |   ...         |    |
  *               |REG |      ...      |    |
- *  part_size    |    |         ...   |    |
- *      +     <--+----+...         ...+----+--> reg_start
- *  reg_size              ...         |    |
- *                           ...      |    | [PART_1]
- *                              ...   |    |
- *                                 ...+----+--> reg_start + reg_size
+ *  mem.size     |    |         ...   |    |
+ *      +     <--+----+...         ...+----+--> reg.start
+ *  reg.size     |    |   ...         |    |
+ *               |MEM2|      ...      |    | [PART_1]
+ *               |    |         ...   |    |
+ *                                 ...+----+--> reg.start + reg.size
  *                                    |    |
  *
  */
 int wl1271_set_partition(struct wl1271 *wl,
-			  u32 mem_start, u32 mem_size,
-			  u32 reg_start, u32 reg_size)
+			 struct wl1271_partition_set *p)
 {
-	struct wl1271_partition *partition;
-	struct spi_transfer t;
-	struct spi_message m;
-	size_t len, cmd_len;
-	u32 *cmd;
-	int addr;
-
-	cmd_len = sizeof(u32) + 2 * sizeof(struct wl1271_partition);
-	cmd = kzalloc(cmd_len, GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
-
-	spi_message_init(&m);
-	memset(&t, 0, sizeof(t));
-
-	partition = (struct wl1271_partition *) (cmd + 1);
-	addr = HW_ACCESS_PART0_SIZE_ADDR;
-	len = 2 * sizeof(struct wl1271_partition);
-
-	*cmd |= WSPI_CMD_WRITE;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
+	/* copy partition info */
+	memcpy(&wl->part, p, sizeof(*p));
 
 	wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-		     mem_start, mem_size);
+		     p->mem.start, p->mem.size);
 	wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-		     reg_start, reg_size);
-
-	/* Make sure that the two partitions together don't exceed the
-	 * address range */
-	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
-		wl1271_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
-			     " address range.  Truncating partition[0].");
-		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
-		wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	if ((mem_start < reg_start) &&
-	    ((mem_start + mem_size) > reg_start)) {
-		/* Guarantee that the memory partition doesn't overlap the
-		 * registers partition */
-		wl1271_debug(DEBUG_SPI, "End of partition[0] is "
-			     "overlapping partition[1].  Adjusted.");
-		mem_size = reg_start - mem_start;
-		wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	} else if ((reg_start < mem_start) &&
-		   ((reg_start + reg_size) > mem_start)) {
-		/* Guarantee that the register partition doesn't overlap the
-		 * memory partition */
-		wl1271_debug(DEBUG_SPI, "End of partition[1] is"
-			     " overlapping partition[0].  Adjusted.");
-		reg_size = mem_start - reg_start;
-		wl1271_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl1271_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	partition[0].start = mem_start;
-	partition[0].size  = mem_size;
-	partition[1].start = reg_start;
-	partition[1].size  = reg_size;
-
-	wl->physical_mem_addr = mem_start;
-	wl->physical_reg_addr = reg_start;
-
-	wl->virtual_mem_addr = 0;
-	wl->virtual_reg_addr = mem_size;
-
-	t.tx_buf = cmd;
-	t.len = cmd_len;
-	spi_message_add_tail(&t, &m);
-
-	spi_sync(wl->spi, &m);
-
-	kfree(cmd);
+		     p->reg.start, p->reg.size);
+	wl1271_debug(DEBUG_SPI, "mem2_start %08X mem2_size %08X",
+		     p->mem2.start, p->mem2.size);
+	wl1271_debug(DEBUG_SPI, "mem3_start %08X mem3_size %08X",
+		     p->mem3.start, p->mem3.size);
+
+	/* write partition info to the chipset */
+	wl1271_write32(wl, HW_PART0_START_ADDR, p->mem.start);
+	wl1271_write32(wl, HW_PART0_SIZE_ADDR, p->mem.size);
+	wl1271_write32(wl, HW_PART1_START_ADDR, p->reg.start);
+	wl1271_write32(wl, HW_PART1_SIZE_ADDR, p->reg.size);
+	wl1271_write32(wl, HW_PART2_START_ADDR, p->mem2.start);
+	wl1271_write32(wl, HW_PART2_SIZE_ADDR, p->mem2.size);
+	wl1271_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
 
 	return 0;
 }
@@ -391,7 +341,7 @@ void wl1271_spi_mem_read(struct wl1271 *wl, int addr, void *buf,
 {
 	int physical;
 
-	physical = wl1271_translate_mem_addr(wl, addr);
+	physical = wl1271_translate_addr(wl, addr);
 
 	wl1271_spi_read(wl, physical, buf, len, false);
 }
@@ -401,7 +351,7 @@ void wl1271_spi_mem_write(struct wl1271 *wl, int addr, void *buf,
 {
 	int physical;
 
-	physical = wl1271_translate_mem_addr(wl, addr);
+	physical = wl1271_translate_addr(wl, addr);
 
 	wl1271_spi_write(wl, physical, buf, len, false);
 }
@@ -411,7 +361,7 @@ void wl1271_spi_reg_read(struct wl1271 *wl, int addr, void *buf, size_t len,
 {
 	int physical;
 
-	physical = wl1271_translate_reg_addr(wl, addr);
+	physical = wl1271_translate_addr(wl, addr);
 
 	wl1271_spi_read(wl, physical, buf, len, fixed);
 }
@@ -421,27 +371,27 @@ void wl1271_spi_reg_write(struct wl1271 *wl, int addr, void *buf, size_t len,
 {
 	int physical;
 
-	physical = wl1271_translate_reg_addr(wl, addr);
+	physical = wl1271_translate_addr(wl, addr);
 
 	wl1271_spi_write(wl, physical, buf, len, fixed);
 }
 
 u32 wl1271_mem_read32(struct wl1271 *wl, int addr)
 {
-	return wl1271_read32(wl, wl1271_translate_mem_addr(wl, addr));
+	return wl1271_read32(wl, wl1271_translate_addr(wl, addr));
 }
 
 void wl1271_mem_write32(struct wl1271 *wl, int addr, u32 val)
 {
-	wl1271_write32(wl, wl1271_translate_mem_addr(wl, addr), val);
+	wl1271_write32(wl, wl1271_translate_addr(wl, addr), val);
 }
 
 u32 wl1271_reg_read32(struct wl1271 *wl, int addr)
 {
-	return wl1271_read32(wl, wl1271_translate_reg_addr(wl, addr));
+	return wl1271_read32(wl, wl1271_translate_addr(wl, addr));
 }
 
 void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val)
 {
-	wl1271_write32(wl, wl1271_translate_reg_addr(wl, addr), val);
+	wl1271_write32(wl, wl1271_translate_addr(wl, addr), val);
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_spi.h b/drivers/net/wireless/wl12xx/wl1271_spi.h
index 2c99684..c58e027 100644
--- a/drivers/net/wireless/wl12xx/wl1271_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1271_spi.h
@@ -29,10 +29,14 @@
 
 #define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
 
-#define HW_ACCESS_PART0_SIZE_ADDR           0x1FFC0
-#define HW_ACCESS_PART0_START_ADDR          0x1FFC4
-#define HW_ACCESS_PART1_SIZE_ADDR           0x1FFC8
-#define HW_ACCESS_PART1_START_ADDR          0x1FFCC
+#define HW_PARTITION_REGISTERS_ADDR         0x1ffc0
+#define HW_PART0_SIZE_ADDR                  (HW_PARTITION_REGISTERS_ADDR)
+#define HW_PART0_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 4)
+#define HW_PART1_SIZE_ADDR                  (HW_PARTITION_REGISTERS_ADDR + 8)
+#define HW_PART1_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 12)
+#define HW_PART2_SIZE_ADDR                  (HW_PARTITION_REGISTERS_ADDR + 16)
+#define HW_PART2_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 20)
+#define HW_PART3_START_ADDR                 (HW_PARTITION_REGISTERS_ADDR + 24)
 
 #define HW_ACCESS_REGISTER_SIZE             4
 
@@ -92,8 +96,7 @@ void wl1271_reg_write32(struct wl1271 *wl, int addr, u32 val);
 void wl1271_spi_reset(struct wl1271 *wl);
 void wl1271_spi_init(struct wl1271 *wl);
 int wl1271_set_partition(struct wl1271 *wl,
-			 u32 part_start, u32 part_size,
-			 u32 reg_start,  u32 reg_size);
+			 struct wl1271_partition_set *p);
 
 static inline u32 wl1271_read32(struct wl1271 *wl, int addr)
 {
-- 
1.5.6.5

