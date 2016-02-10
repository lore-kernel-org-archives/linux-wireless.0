Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout.easymail.ca ([64.68.201.169]:42717 "EHLO
	mailout.easymail.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753115AbcBJBVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Feb 2016 20:21:48 -0500
Date: Wed, 10 Feb 2016 02:22:16 +0100
From: Emil Goode <emil.fsw@goode.io>
To: Kalle Valo <kvalo@codeaurora.org>, Shahar Patury <shaharp@ti.com>,
	Guy Mishol <guym@ti.com>,
	Igor Grinberg <grinberg@compulab.co.il>,
	Uri Mashiach <uri.mashiach@compulab.co.il>,
	Ross Green <rgkernel@gmail.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] wlcore: Fix regression in wlcore_set_partition()
Message-ID: <20160210012216.GA18819@lianli> (sfid-20160210_022253_858632_11A7A6FD)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The below commit introduced a regression causing the wlcore
to time out and go into recovery.

commit 3719c17e1816695f415dd3b4ddcb679f7dc617c8
("wlcore/wl18xx: fw logger over sdio")

Reverting the changes regarding write of the last partition size
brings the module back to it's functional state.

Reported-by: Ross Green <rgkernel@gmail.com>
Signed-off-by: Emil Goode <emil.fsw@goode.io>
---
 drivers/net/wireless/ti/wlcore/io.c | 8 ++++----
 drivers/net/wireless/ti/wlcore/io.h | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.c b/drivers/net/wireless/ti/wlcore/io.c
index 9ac118e..564ca75 100644
--- a/drivers/net/wireless/ti/wlcore/io.c
+++ b/drivers/net/wireless/ti/wlcore/io.c
@@ -175,14 +175,14 @@ int wlcore_set_partition(struct wl1271 *wl,
 	if (ret < 0)
 		goto out;
 
+	/* We don't need the size of the last partition, as it is
+	 * automatically calculated based on the total memory size and
+	 * the sizes of the previous partitions.
+	 */
 	ret = wlcore_raw_write32(wl, HW_PART3_START_ADDR, p->mem3.start);
 	if (ret < 0)
 		goto out;
 
-	ret = wlcore_raw_write32(wl, HW_PART3_SIZE_ADDR, p->mem3.size);
-	if (ret < 0)
-		goto out;
-
 out:
 	return ret;
 }
diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 6c257b5..10cf374 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -36,8 +36,8 @@
 #define HW_PART1_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 12)
 #define HW_PART2_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 16)
 #define HW_PART2_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 20)
-#define HW_PART3_SIZE_ADDR              (HW_PARTITION_REGISTERS_ADDR + 24)
-#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 28)
+#define HW_PART3_START_ADDR             (HW_PARTITION_REGISTERS_ADDR + 24)
+
 #define HW_ACCESS_REGISTER_SIZE         4
 
 #define HW_ACCESS_PRAM_MAX_RANGE	0x3c000
-- 
2.1.4

