Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1648 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761660AbZFKCDs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:48 -0400
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org, pierre@ossman.eu
Cc: kalle.valo@iki.fi, san@google.com,
	Bob Copeland <me@bobcopeland.com>
Subject: [PATCH/RFC 4/7] wl12xx: make wl12xx_set_partition bus agnostic
Date: Wed, 10 Jun 2009 22:02:57 -0400
Message-Id: <1244685780-28930-5-git-send-email-me@bobcopeland.com>
In-Reply-To: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
References: <1244685780-28930-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The same partition setting code can be used for both SPI and SDIO
modes, if we remove the spi-specific commands and use the more
generic buffer write routines.  Do that and move it to io.c
since it deals with register/memory address offsets.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/io.c  |   95 ++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/io.h  |   15 +++++-
 drivers/net/wireless/wl12xx/spi.c |  117 -------------------------------------
 drivers/net/wireless/wl12xx/spi.h |   11 ----
 4 files changed, 109 insertions(+), 129 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index 611b644..b4178d8 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -84,3 +84,98 @@ void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val)
 {
 	wl12xx_write32(wl, wl12xx_translate_reg_addr(wl, addr), val);
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
+void wl12xx_set_partition(struct wl12xx *wl,
+			  u32 mem_start, u32 mem_size,
+			  u32 reg_start, u32 reg_size)
+{
+	struct wl12xx_partition partition[2];
+
+	wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+		     mem_start, mem_size);
+	wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+		     reg_start, reg_size);
+
+	/* Make sure that the two partitions together don't exceed the
+	 * address range */
+	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
+		wl12xx_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
+			     " address range.  Truncating partition[0].");
+		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	}
+
+	if ((mem_start < reg_start) &&
+	    ((mem_start + mem_size) > reg_start)) {
+		/* Guarantee that the memory partition doesn't overlap the
+		 * registers partition */
+		wl12xx_debug(DEBUG_SPI, "End of partition[0] is "
+			     "overlapping partition[1].  Adjusted.");
+		mem_size = reg_start - mem_start;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
+			     reg_start, reg_size);
+	} else if ((reg_start < mem_start) &&
+		   ((reg_start + reg_size) > mem_start)) {
+		/* Guarantee that the register partition doesn't overlap the
+		 * memory partition */
+		wl12xx_debug(DEBUG_SPI, "End of partition[1] is"
+			     " overlapping partition[0].  Adjusted.");
+		reg_size = mem_start - reg_start;
+		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
+			     mem_start, mem_size);
+		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
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
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index ecc18b6..b1ea67a 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -23,6 +23,17 @@
 
 #include "wl12xx.h"
 
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
 static inline u32 wl12xx_read32(struct wl12xx *wl, int addr)
 {
 	u32 response;
@@ -45,5 +56,7 @@ void wl12xx_mem_write32(struct wl12xx *wl, int addr, u32 val);
 /* Registers IO */
 u32 wl12xx_reg_read32(struct wl12xx *wl, int addr);
 void wl12xx_reg_write32(struct wl12xx *wl, int addr, u32 val);
-
+void wl12xx_set_partition(struct wl12xx *wl,
+			  u32 part_start, u32 part_size,
+			  u32 reg_start,  u32 reg_size);
 #endif
diff --git a/drivers/net/wireless/wl12xx/spi.c b/drivers/net/wireless/wl12xx/spi.c
index 085755d..658464e 100644
--- a/drivers/net/wireless/wl12xx/spi.c
+++ b/drivers/net/wireless/wl12xx/spi.c
@@ -117,123 +117,6 @@ static void wl12xx_spi_reset_wake(struct wl12xx *wl)
 	wl12xx_spi_init(wl);
 }
 
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
-void wl12xx_set_partition(struct wl12xx *wl,
-			  u32 mem_start, u32 mem_size,
-			  u32 reg_start, u32 reg_size)
-{
-	u8 tx_buf[sizeof(u32) + 2 * sizeof(struct wl12xx_partition)];
-	struct wl12xx_partition *partition;
-	struct spi_transfer t;
-	struct spi_message m;
-	u32 *cmd;
-	size_t len;
-	int addr;
-
-	spi_message_init(&m);
-	memset(&t, 0, sizeof(t));
-	memset(tx_buf, 0, sizeof(tx_buf));
-
-	cmd = (u32 *) tx_buf;
-	partition = (struct wl12xx_partition *) (tx_buf + sizeof(u32));
-	addr = HW_ACCESS_PART0_SIZE_ADDR;
-	len = 2 * sizeof(struct wl12xx_partition);
-
-	*cmd |= WSPI_CMD_WRITE;
-	*cmd |= (len << WSPI_CMD_BYTE_LENGTH_OFFSET) & WSPI_CMD_BYTE_LENGTH;
-	*cmd |= addr & WSPI_CMD_BYTE_ADDR;
-
-	wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-		     mem_start, mem_size);
-	wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-		     reg_start, reg_size);
-
-	/* Make sure that the two partitions together don't exceed the
-	 * address range */
-	if ((mem_size + reg_size) > HW_ACCESS_MEMORY_MAX_RANGE) {
-		wl12xx_debug(DEBUG_SPI, "Total size exceeds maximum virtual"
-			     " address range.  Truncating partition[0].");
-		mem_size = HW_ACCESS_MEMORY_MAX_RANGE - reg_size;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	}
-
-	if ((mem_start < reg_start) &&
-	    ((mem_start + mem_size) > reg_start)) {
-		/* Guarantee that the memory partition doesn't overlap the
-		 * registers partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[0] is "
-			     "overlapping partition[1].  Adjusted.");
-		mem_size = reg_start - mem_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
-			     reg_start, reg_size);
-	} else if ((reg_start < mem_start) &&
-		   ((reg_start + reg_size) > mem_start)) {
-		/* Guarantee that the register partition doesn't overlap the
-		 * memory partition */
-		wl12xx_debug(DEBUG_SPI, "End of partition[1] is"
-			     " overlapping partition[0].  Adjusted.");
-		reg_size = mem_start - reg_start;
-		wl12xx_debug(DEBUG_SPI, "mem_start %08X mem_size %08X",
-			     mem_start, mem_size);
-		wl12xx_debug(DEBUG_SPI, "reg_start %08X reg_size %08X",
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
-	t.tx_buf = tx_buf;
-	t.len = sizeof(tx_buf);
-	spi_message_add_tail(&t, &m);
-
-	spi_sync(wl->spi, &m);
-}
-
 static void wl12xx_spi_read(struct wl12xx *wl, int addr, void *buf,
 			    size_t len)
 {
diff --git a/drivers/net/wireless/wl12xx/spi.h b/drivers/net/wireless/wl12xx/spi.h
index 761401b..1cbedcf 100644
--- a/drivers/net/wireless/wl12xx/spi.h
+++ b/drivers/net/wireless/wl12xx/spi.h
@@ -29,17 +29,6 @@
 #include "acx.h"
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
-- 
1.6.0.6


