Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:44042 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755232Ab2FUONc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 10:13:32 -0400
Received: by bkcjk13 with SMTP id jk13so683936bkc.12
        for <linux-wireless@vger.kernel.org>; Thu, 21 Jun 2012 07:13:29 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 08/12] wlcore: read FW logs from FW memory on watchdog recovery
Date: Thu, 21 Jun 2012 17:13:07 +0300
Message-Id: <1340287991-15241-9-git-send-email-coelho@ti.com> (sfid-20120621_161409_931009_A52BA618)
In-Reply-To: <1340287991-15241-1-git-send-email-coelho@ti.com>
References: <1340287991-15241-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Igal Chernobelsky <igalc@ti.com>

FW uses a few memory blocks as a buffer to accumulate FW logs before
transmitting them to the host over SDIO. When FW WatchDog recovery
occurs, the last FW traces are still pending in the buffer. Driver is
to read these FW traces whether log mode is continuous or on demand.

FW memory blocks allocated for the log buffer are handled as a link list:
the first 4 bytes in each memory block contain FW address to the next block.
The end of list condition depends on FW log mode:
- on demand: the list is cyclic, the next address is equal to the first address
- continuous: the address is  equal to 0x2000000

Log data resides inside FW memory block with offset depending on
logger mode:
- on demand:  4 bytes (address of the next memory block)
- continuous: 4 bytes and Rx Descriptor structure size

Described FW logger API is backward compatible with previous FW versions.

Signed-off-by: Igal Chernobelsky <igalc@ti.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   34 +++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a7c5e32..78edc58 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -770,14 +770,16 @@ size_t wl12xx_copy_fwlog(struct wl1271 *wl, u8 *memblock, size_t maxlen)
 	return len;
 }
 
+#define WLCORE_FW_LOG_END 0x2000000
+
 static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 {
 	u32 addr;
-	u32 first_addr;
+	u32 offset;
+	u32 end_of_log;
 	u8 *block;
 
 	if ((wl->quirks & WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED) ||
-	    (wl->conf.fwlog.mode != WL12XX_FWLOG_ON_DEMAND) ||
 	    (wl->conf.fwlog.mem_blocks == 0))
 		return;
 
@@ -791,19 +793,26 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 	 * Make sure the chip is awake and the logger isn't active.
 	 * Do not send a stop fwlog command if the fw is hanged.
 	 */
-	if (!wl1271_ps_elp_wakeup(wl) && !wl->watchdog_recovery)
-		wl12xx_cmd_stop_fwlog(wl);
-	else
+	if (wl1271_ps_elp_wakeup(wl))
 		goto out;
+	if (!wl->watchdog_recovery)
+		wl12xx_cmd_stop_fwlog(wl);
 
 	/* Read the first memory block address */
 	wl12xx_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
-	first_addr = le32_to_cpu(wl->fw_status_2->log_start_addr);
-	if (!first_addr)
+	addr = le32_to_cpu(wl->fw_status_2->log_start_addr);
+	if (!addr)
 		goto out;
 
+	if (wl->conf.fwlog.mode == WL12XX_FWLOG_CONTINUOUS) {
+		offset = sizeof(addr) + sizeof(struct wl1271_rx_descriptor);
+		end_of_log = WLCORE_FW_LOG_END;
+	} else {
+		offset = sizeof(addr);
+		end_of_log = addr;
+	}
+
 	/* Traverse the memory blocks linked list */
-	addr = first_addr;
 	do {
 		memset(block, 0, WL12XX_HW_BLOCK_SIZE);
 		wl1271_read_hwaddr(wl, addr, block, WL12XX_HW_BLOCK_SIZE,
@@ -812,13 +821,14 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 		/*
 		 * Memory blocks are linked to one another. The first 4 bytes
 		 * of each memory block hold the hardware address of the next
-		 * one. The last memory block points to the first one.
+		 * one. The last memory block points to the first one in
+		 * on demand mode and is equal to 0x2000000 in continuous mode.
 		 */
 		addr = le32_to_cpup((__le32 *)block);
-		if (!wl12xx_copy_fwlog(wl, block + sizeof(addr),
-				       WL12XX_HW_BLOCK_SIZE - sizeof(addr)))
+		if (!wl12xx_copy_fwlog(wl, block + offset,
+				       WL12XX_HW_BLOCK_SIZE - offset))
 			break;
-	} while (addr && (addr != first_addr));
+	} while (addr && (addr != end_of_log));
 
 	wake_up_interruptible(&wl->fwlog_waitq);
 
-- 
1.7.10

