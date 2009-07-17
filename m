Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh02.mail.saunalahti.fi ([62.142.5.108]:47351 "EHLO
	emh02.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbZGQS4D (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 14:56:03 -0400
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [RFC PATCH v2 5/8] wl1251: make wl1251_set_partition bus agnostic
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 17 Jul 2009 21:48:20 +0300
Message-ID: <20090717184819.25883.59128.stgit@tikku>
In-Reply-To: <20090717184643.25883.95065.stgit@tikku>
References: <20090717184643.25883.95065.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Bob Copeland <me@bobcopeland.com>

The same partition setting code can be used for both SPI and SDIO
modes, if we remove the spi-specific commands and use the more
generic buffer write routines.  Do that and move it to io.c
since it deals with register/memory address offsets.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_io.c  |   95 +++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_io.h  |   15 ++++
 drivers/net/wireless/wl12xx/wl1251_spi.c |  124 ------------------------------
 drivers/net/wireless/wl12xx/wl1251_spi.h |   15 ----
 4 files changed, 110 insertions(+), 139 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_io.c b/drivers/net/wireless/wl12xx/wl1251_io.c
index bc95785..db2cfbf 100644
--- a/drivers/net/wireless/wl12xx/wl1251_io.c
+++ b/drivers/net/wireless/wl12xx/wl1251_io.c
@@ -84,3 +84,98 @@ void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val)
 {
 	wl1251_write32(wl, wl1251_translate_reg_addr(wl, addr), val);
 }
+
+/* Set the partitions to access the chip addresses.
+ *
+ * There are two VIRTUAL partitions (the memory partition and the
+ * registers partition), which are mapped to two different areas of the
+ * PHYSICAL (hardware) memory.  This function also makes other checks to
+ * ensure that the partitions are not overlapping.  In the diagram below, the
+ * memory partition comes before the register partition, but the opposite is
+ * also supported.
+ *
+ *                               PHYSICAL address
+ *                                     space
+ *
+ *                                    |    |
+ *                                 ...+----+--> mem_start
+ *          VIRTUAL address     ...   |    |
+ *               space       ...      |    | [PART_0]
+ *                        ...         |    |
+ * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
+ *               |    |         ...   |    |
+ *               |MEM |      ...      |    |
+ *               |    |   ...         |    |
+ *  part_size <--+----+...            |    | {unused area)
+ *               |    |   ...         |    |
+ *               |REG |      ...      |    |
+ *  part_size    |    |         ...   |    |
+ *      +     <--+----+...         ...+----+--> reg_start
+ *  reg_size              ...         |    |
+ *                           ...      |    | [PART_1]
+ *                              ...   |    |
+ *                                 ...+----+--> reg_start + reg_size
+ *                                    |    |
+ *
+ */
+void wl1251_set_partition(struct wl1251 *wl,
+			  u32 mem_start, u32 mem_size,
+			  u32 reg_start, u32 reg_size)
+{
+	struct wl1251_partition partition[2];
+
+	wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		     mem_start, mem_size);
+	wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		     reg_start, reg_size);
+
+	/* Make sure that the two partitions together don't exceed the
+	 * address range */
+	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
+		wl1251_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
+			     " address range.  Truncating partition[0].");
+		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
+		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	if ((mem_start < reg_start) &&
+	    ((mem_start + mem_size) > reg_start)) {
+		/* Guarantee that the memory partition doesn't overlap the
+		 * registers partition */
+		wl1251_debug(DEBUG_SPI, "End of partition[0] is "
+			     "overlapping partition[1].  Adjusted.");
+		mem_size = reg_start - mem_start;
+		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	} else if ((reg_start < mem_start) &&
+		   ((reg_start + reg_size) > mem_start)) {
+		/* Guarantee that the register partition doesn't overlap the
+		 * memory partition */
+		wl1251_debug(DEBUG_SPI, "End of partition[1] is"
+			     " overlapping partition[0].  Adjusted.");
+		reg_size = mem_start - reg_start;
+		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	partition[0].start = mem_start;
+	partition[0].size  = mem_size;
+	partition[1].start = reg_start;
+	partition[1].size  = reg_size;
+
+	wl->physical_mem_addr = mem_start;
+	wl->physical_reg_addr = reg_start;
+
+	wl->virtual_mem_addr = 0;
+	wl->virtual_reg_addr = mem_size;
+
+	wl->if_ops->write(wl, HW_ACCESS_PART0_SIZE_ADDR, partition,
+		sizeof(partition));
+}
diff --git a/drivers/net/wireless/wl12xx/wl1251_io.h b/drivers/net/wireless/wl12xx/wl1251_io.h
index 1fa2ab1..b89d2ac 100644
--- a/drivers/net/wireless/wl12xx/wl1251_io.h
+++ b/drivers/net/wireless/wl12xx/wl1251_io.h
@@ -23,6 +23,17 @@
 
 #include "wl1251.h"
 
+#define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
+
+#define HW_ACCESS_PART0_SIZE_ADDR           0x1FFC0
+#define HW_ACCESS_PART0_START_ADDR          0x1FFC4
+#define HW_ACCESS_PART1_SIZE_ADDR           0x1FFC8
+#define HW_ACCESS_PART1_START_ADDR          0x1FFCC
+
+#define HW_ACCESS_REGISTER_SIZE             4
+
+#define HW_ACCESS_PRAM_MAX_RANGE		0x3c000
+
 static inline u32 wl1251_read32(struct wl1251 *wl, int addr)
 {
 	u32 response;
@@ -46,4 +57,8 @@ void wl1251_mem_write32(struct wl1251 *wl, int addr, u32 val);
 u32 wl1251_reg_read32(struct wl1251 *wl, int addr);
 void wl1251_reg_write32(struct wl1251 *wl, int addr, u32 val);
 
+void wl1251_set_partition(struct wl1251 *wl,
+			  u32 part_start, u32 part_size,
+			  u32 reg_start,  u32 reg_size);
+
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.c b/drivers/net/wireless/wl12xx/wl1251_spi.c
index 61a0852..ceb237b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.c
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.c
@@ -115,130 +115,6 @@ static void wl1251_spi_reset_wake(struct wl1251 *wl)
 	wl1251_spi_init(wl);
 }
 
-
-/* Set the SPI partitions to access the chip addresses
- *
- * There are two VIRTUAL (SPI) partitions (the memory partition and the
- * registers partition), which are mapped to two different areas of the
- * PHYSICAL (hardware) memory.  This function also makes other checks to
- * ensure that the partitions are not overlapping.  In the diagram below, the
- * memory partition comes before the register partition, but the opposite is
- * also supported.
- *
- *                               PHYSICAL address
- *                                     space
- *
- *                                    |    |
- *                                 ...+----+--> mem_start
- *          VIRTUAL address     ...   |    |
- *               space       ...      |    | [PART_0]
- *                        ...         |    |
- * 0x00000000 <--+----+...         ...+----+--> mem_start + mem_size
- *               |    |         ...   |    |
- *               |MEM |      ...      |    |
- *               |    |   ...         |    |
- *  part_size <--+----+...            |    | {unused area)
- *               |    |   ...         |    |
- *               |REG |      ...      |    |
- *  part_size    |    |         ...   |    |
- *      +     <--+----+...         ...+----+--> reg_start
- *  reg_size              ...         |    |
- *                           ...      |    | [PART_1]
- *                              ...   |    |
- *                                 ...+----+--> reg_start + reg_size
- *                                    |    |
- *
- */
-int wl1251_set_partition(struct wl1251 *wl,
-			  u32 mem_start, u32 mem_size,
-			  u32 reg_start, u32 reg_size)
-{
-	struct wl1251_partition *partition;
-	struct spi_transfer t;
-	struct spi_message m;
-	size_t len, cmd_len;
-	u32 *cmd;
-	int addr;
-
-	cmd_len = sizeof(u32) + 2 * sizeof(struct wl1251_partition);
-	cmd = kzalloc(cmd_len, GFP_KERNEL);
-	if (!cmd)
-		return -ENOMEM;
-
-	spi_message_init(&m);
-	memset(&t, 0, sizeof(t));
-
-	partition = (struct wl1251_partition *) (cmd + 1);
-	addr = HW_ACCESS_PART0_SIZE_ADDR;
-	len = 2 * sizeof(struct wl1251_partition);
-
-	*cmd |= WSPI_CMD_WRITE;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
-
-	wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-		     mem_start, mem_size);
-	wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-		     reg_start, reg_size);
-
-	/* Make sure that the two partitions together don't exceed the
-	 * address range */
-	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
-		wl1251_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
-			     " address range.  Truncating partition[0].");
-		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
-		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	if ((mem_start < reg_start) &&
-	    ((mem_start + mem_size) > reg_start)) {
-		/* Guarantee that the memory partition doesn't overlap the
-		 * registers partition */
-		wl1251_debug(DEBUG_SPI, "End of partition[0] is "
-			     "overlapping partition[1].  Adjusted.");
-		mem_size = reg_start - mem_start;
-		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	} else if ((reg_start < mem_start) &&
-		   ((reg_start + reg_size) > mem_start)) {
-		/* Guarantee that the register partition doesn't overlap the
-		 * memory partition */
-		wl1251_debug(DEBUG_SPI, "End of partition[1] is"
-			     " overlapping partition[0].  Adjusted.");
-		reg_size = mem_start - reg_start;
-		wl1251_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl1251_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
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
-
-	return 0;
-}
-
 static void wl1251_spi_read(struct wl1251 *wl, int addr, void *buf,
 			    size_t len)
 {
diff --git a/drivers/net/wireless/wl12xx/wl1251_spi.h b/drivers/net/wireless/wl12xx/wl1251_spi.h
index 7c6da21..cb0c228 100644
--- a/drivers/net/wireless/wl12xx/wl1251_spi.h
+++ b/drivers/net/wireless/wl12xx/wl1251_spi.h
@@ -29,17 +29,6 @@
 #include "wl1251_acx.h"
 #include "reg.h"
 
-#define HW_ACCESS_MEMORY_MAX_RANGE		0x1FFC0
-
-#define HW_ACCESS_PART0_SIZE_ADDR           0x1FFC0
-#define HW_ACCESS_PART0_START_ADDR          0x1FFC4
-#define HW_ACCESS_PART1_SIZE_ADDR           0x1FFC8
-#define HW_ACCESS_PART1_START_ADDR          0x1FFCC
-
-#define HW_ACCESS_REGISTER_SIZE             4
-
-#define HW_ACCESS_PRAM_MAX_RANGE		0x3c000
-
 #define WSPI_CMD_READ                 0x40000000
 #define WSPI_CMD_WRITE                0x00000000
 #define WSPI_CMD_FIXED                0x20000000
@@ -69,8 +58,4 @@
 		((WL1251_BUSY_WORD_LEN - 4) / sizeof(u32))
 #define HW_ACCESS_WSPI_INIT_CMD_MASK  0
 
-int wl1251_set_partition(struct wl1251 *wl,
-			 u32 part_start, u32 part_size,
-			 u32 reg_start,  u32 reg_size);
-
 #endif /* __WL1251_SPI_H__ */

