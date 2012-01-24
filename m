Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56342 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755383Ab2AXJGx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:53 -0500
Received: by lahc1 with SMTP id c1so2814714lah.5
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:50 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 5/8] wl12xx: move partition table definition to io.c
Date: Tue, 24 Jan 2012 11:06:26 +0200
Message-Id: <1327395989-29663-6-git-send-email-coelho@ti.com> (sfid-20120124_100702_181068_AB2BA3BE)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Up till now we only needed to access the partition table in boot.c.
But to add support for reading the MAC address from the FUSE in
testmode, we will have to change the partition in testmode.c.

Thus, we move the partition table to io.c and export it via io.h.  It
makes more sense to have it in the io part anyway.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c |   73 +++--------------------------------
 drivers/net/wireless/wl12xx/io.c   |   59 +++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/io.h   |    2 +
 3 files changed, 68 insertions(+), 66 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 8f9cf5a..84d2951 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -33,65 +33,6 @@
 #include "event.h"
 #include "rx.h"
 
-static struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
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
 static void wl1271_boot_set_ecpu_ctrl(struct wl1271 *wl, u32 flag)
 {
 	u32 cpu_ctrl;
@@ -181,13 +122,13 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		return -ENOMEM;
 	}
 
-	memcpy(&partition, &part_table[PART_DOWN], sizeof(partition));
+	memcpy(&partition, &wl12xx_part_table[PART_DOWN], sizeof(partition));
 	partition.mem.start = dest;
 	wl1271_set_partition(wl, &partition);
 
 	/* 10.1 set partition limit and chunk num */
 	chunk_num = 0;
-	partition_limit = part_table[PART_DOWN].mem.size;
+	partition_limit = wl12xx_part_table[PART_DOWN].mem.size;
 
 	while (chunk_num < fw_data_len / CHUNK_SIZE) {
 		/* 10.2 update partition, if needed */
@@ -195,7 +136,7 @@ static int wl1271_boot_upload_firmware_chunk(struct wl1271 *wl, void *buf,
 		if (addr > partition_limit) {
 			addr = dest + chunk_num * CHUNK_SIZE;
 			partition_limit = chunk_num * CHUNK_SIZE +
-				part_table[PART_DOWN].mem.size;
+				wl12xx_part_table[PART_DOWN].mem.size;
 			partition.mem.start = addr;
 			wl1271_set_partition(wl, &partition);
 		}
@@ -383,7 +324,7 @@ static int wl1271_boot_upload_nvs(struct wl1271 *wl)
 	nvs_len -= nvs_ptr - (u8 *)wl->nvs;
 
 	/* Now we must set the partition correctly */
-	wl1271_set_partition(wl, &part_table[PART_WORK]);
+	wl1271_set_partition(wl, &wl12xx_part_table[PART_WORK]);
 
 	/* Copy the NVS tables to a new block to ensure alignment */
 	nvs_aligned = kmemdup(nvs_ptr, nvs_len, GFP_KERNEL);
@@ -492,7 +433,7 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	wl->event_box_addr = wl1271_read32(wl, REG_EVENT_MAILBOX_PTR);
 
 	/* set the working partition to its "running" mode offset */
-	wl1271_set_partition(wl, &part_table[PART_WORK]);
+	wl1271_set_partition(wl, &wl12xx_part_table[PART_WORK]);
 
 	wl1271_debug(DEBUG_MAILBOX, "cmd_box_addr 0x%x event_box_addr 0x%x",
 		     wl->cmd_box_addr, wl->event_box_addr);
@@ -769,7 +710,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 	wl1271_write32(wl, WELP_ARM_COMMAND, WELP_ARM_COMMAND_VAL);
 	udelay(500);
 
-	wl1271_set_partition(wl, &part_table[PART_DRPW]);
+	wl1271_set_partition(wl, &wl12xx_part_table[PART_DRPW]);
 
 	/* Read-modify-write DRPW_SCRATCH_START register (see next state)
 	   to be used by DRPw FW. The RTRIM value will be added by the FW
@@ -788,7 +729,7 @@ int wl1271_load_firmware(struct wl1271 *wl)
 
 	wl1271_write32(wl, DRPW_SCRATCH_START, clk);
 
-	wl1271_set_partition(wl, &part_table[PART_WORK]);
+	wl1271_set_partition(wl, &wl12xx_part_table[PART_WORK]);
 
 	/* Disable interrupts */
 	wl1271_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index 079ad38..c574a3b 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -45,6 +45,65 @@
 #define OCP_STATUS_REQ_FAILED 0x20000
 #define OCP_STATUS_RESP_ERROR 0x30000
 
+struct wl1271_partition_set wl12xx_part_table[PART_TABLE_LEN] = {
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
 bool wl1271_set_block_size(struct wl1271 *wl)
 {
 	if (wl->if_ops->set_block_size) {
diff --git a/drivers/net/wireless/wl12xx/io.h b/drivers/net/wireless/wl12xx/io.h
index d398cbc..4fb3dab 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -43,6 +43,8 @@
 
 #define HW_ACCESS_PRAM_MAX_RANGE	0x3c000
 
+extern struct wl1271_partition_set wl12xx_part_table[PART_TABLE_LEN];
+
 struct wl1271;
 
 void wl1271_disable_interrupts(struct wl1271 *wl);
-- 
1.7.4.1

