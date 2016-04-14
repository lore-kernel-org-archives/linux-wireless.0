Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:33895 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571AbcDNJCb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Apr 2016 05:02:31 -0400
Received: from dlelxv90.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id u3E92UvK000945
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 04:02:30 -0500
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv90.itg.ti.com (8.14.3/8.13.8) with ESMTP id u3E92UQp007013
	for <linux-wireless@vger.kernel.org>; Thu, 14 Apr 2016 04:02:30 -0500
From: Guy Mishol <guym@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Guy Mishol <guym@ti.com>
Subject: [PATCH] wlcore/wl12xx: Fix fw logger over sdio
Date: Thu, 14 Apr 2016 11:58:17 +0300
Message-ID: <1460624297-28420-1-git-send-email-guym@ti.com> (sfid-20160414_110235_758301_F4286CCE)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The commit fb724ed5c617 ("wlcore: Fix regression in
wlcore_set_partition()") fixed wl12xx functionality.
However, it reverted the support in fw logger
over sdio in wl18xx.

This patch reverts the changes made and also fixes
the original functionality issue introduced in wl12xx.

Fixes: fb724ed5c617
("wlcore: Fix regression in wlcore_set_partition()")

Signed-off-by: Guy Mishol <guym@ti.com>
---
 drivers/net/wireless/ti/wl12xx/main.c |  4 ++--
 drivers/net/wireless/ti/wlcore/io.c   | 17 ++++++++++++++---
 drivers/net/wireless/ti/wlcore/io.h   |  3 ++-
 3 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index a0d6ccc..2a52e894 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -553,8 +553,8 @@ static struct wlcore_partition_set wl12xx_ptable[PART_TABLE_LEN] = {
 			.size  = 0x00000004
 		},
 		.mem3 = {
-			.start = 0x00040404,
-			.size  = 0x00000000
+			.start = 0x00000000,
+			.size  = 0x00040404
 		},
 	},
 
diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 564ca75..1cc6d5a 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -175,14 +175,25 @@ int wlcore_set_partition(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
-	/* We don't need the size of the last partition, as it is
-	 * automatically calculated based on the total memory size and
-	 * the sizes of the previous partitions.
+	/* wl12xx only: We don't need the size of the last partition,
+	 * as it is automatically calculated based on the total memory
+	 * size and the sizes of the previous partitions.
+	 *
+	 * wl18xx re-defines the HW_PART3 addresses for logger over
+	 * SDIO support. wl12xx is expecting the write to
+	 * HW_PART3_START_ADDR at offset 24. This creates conflict
+	 * between the addresses.
+	 * In order to fix this the expected value is written to
+	 * HW_PART3_SIZE_ADDR instead which is at offset 24 after changes.
 	 */
 	ret = wlcore_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
 	if (ret < 0)
 		goto out;
 
+	ret = wlcore_raw_write32(wl, HW_PART3_SIZE_ADDR, p->mem3.size);
+	if (ret < 0)
+		goto out;
+
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 10cf374..704ce64 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -36,7 +36,8 @@
 #define HW_PART1_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 12)
 #define HW_PART2_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 16)
 #define HW_PART2_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 20)
-#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 24)
+#define HW_PART3_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 24)
+#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 28)
 
 #define HW_ACCESS_REGISTER_SIZE         4
 
-- 
2.6.4

