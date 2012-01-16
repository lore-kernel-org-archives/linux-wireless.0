Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:58580 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754417Ab2APOXn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jan 2012 09:23:43 -0500
Received: by laah2 with SMTP id h2so912392laa.37
        for <linux-wireless@vger.kernel.org>; Mon, 16 Jan 2012 06:23:39 -0800 (PST)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com
Subject: [PATCH 1/2] wl12xx: move partition table definition to io.c
Date: Mon, 16 Jan 2012 16:23:25 +0200
Message-Id: <1326723806-15960-2-git-send-email-coelho@ti.com> (sfid-20120116_152347_055646_C1422F40)
In-Reply-To: <1326723806-15960-1-git-send-email-coelho@ti.com>
References: <1326723806-15960-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Up till now we only needed to access the partition table in boot.c.
But to add support for reading the MAC address from the FUSE in
testmode, we will have to change the partition in testmode.c.

Thus, we move the partition table to io.c and export it via io.h.  It
makes more sense to have it in the io part anyway.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c |   59 ------------------------------------
 drivers/net/wireless/wl12xx/io.c   |   59 ++++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/io.h   |    2 +
 3 files changed, 61 insertions(+), 59 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 8f9cf5a..9197a07 100644
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
diff --git a/drivers/net/wireless/wl12xx/io.c b/drivers/net/wireless/wl12xx/io.c
index 079ad38..6ad0181 100644
--- a/drivers/net/wireless/wl12xx/io.c
+++ b/drivers/net/wireless/wl12xx/io.c
@@ -45,6 +45,65 @@
 #define OCP_STATUS_REQ_FAILED 0x20000
 #define OCP_STATUS_RESP_ERROR 0x30000
 
+struct wl1271_partition_set part_table[PART_TABLE_LEN] = {
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
index d398cbc..458f1f1 100644
--- a/drivers/net/wireless/wl12xx/io.h
+++ b/drivers/net/wireless/wl12xx/io.h
@@ -43,6 +43,8 @@
 
 #define HW_ACCESS_PRAM_MAX_RANGE	0x3c000
 
+extern struct wl1271_partition_set part_table[PART_TABLE_LEN];
+
 struct wl1271;
 
 void wl1271_disable_interrupts(struct wl1271 *wl);
-- 
1.7.4.1

