Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:45369 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754411Ab2FWGmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jun 2012 02:42:02 -0400
Received: by lbon10 with SMTP id n10so4433878lbo.41
        for <linux-wireless@vger.kernel.org>; Fri, 22 Jun 2012 23:41:59 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com, ido@wizery.com
Subject: [PATCH 05/18] wlcore: Propagate errors from wlcore_raw_*_data functions
Date: Sat, 23 Jun 2012 09:41:16 +0300
Message-Id: <1340433689-24320-6-git-send-email-coelho@ti.com> (sfid-20120623_085130_782811_2D771226)
In-Reply-To: <1340433689-24320-1-git-send-email-coelho@ti.com>
References: <1340433689-24320-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

wlcore_raw_read_data is called when the FW status is read which happens
while handling interrupts and when the FW log is read following a
recovery. Request a recovery in the former case, and don't read the FW
log in case the FW status read failed.

Signed-off-by: Ido Yariv <ido@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/io.h   |   12 ++++++------
 drivers/net/wireless/ti/wlcore/main.c |   27 ++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/io.h b/drivers/net/wireless/ti/wlcore/io.h
index 60b9503..2713ce1 100644
--- a/drivers/net/wireless/ti/wlcore/io.h
+++ b/drivers/net/wireless/ti/wlcore/io.h
@@ -65,16 +65,16 @@ static inline int wlcore_raw_read(struct wl1271 *wl, int addr, void *buf,
 	return wl->if_ops->read(wl->dev, addr, buf, len, fixed);
 }
 
-static inline void wlcore_raw_read_data(struct wl1271 *wl, int reg, void *buf,
-					size_t len, bool fixed)
+static inline int wlcore_raw_read_data(struct wl1271 *wl, int reg, void *buf,
+				       size_t len, bool fixed)
 {
-	wlcore_raw_read(wl, wl->rtable[reg], buf, len, fixed);
+	return wlcore_raw_read(wl, wl->rtable[reg], buf, len, fixed);
 }
 
-static inline void wlcore_raw_write_data(struct wl1271 *wl, int reg, void *buf,
-					 size_t len, bool fixed)
+static inline int wlcore_raw_write_data(struct wl1271 *wl, int reg, void *buf,
+					size_t len, bool fixed)
 {
-	wlcore_raw_write(wl, wl->rtable[reg], buf, len, fixed);
+	return wlcore_raw_write(wl, wl->rtable[reg], buf, len, fixed);
 }
 
 static inline u32 wl1271_raw_read32(struct wl1271 *wl, int addr)
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index c94351a..085cd17 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -378,9 +378,9 @@ static void wl12xx_irq_update_links_status(struct wl1271 *wl,
 	}
 }
 
-static void wl12xx_fw_status(struct wl1271 *wl,
-			     struct wl_fw_status_1 *status_1,
-			     struct wl_fw_status_2 *status_2)
+static int wlcore_fw_status(struct wl1271 *wl,
+			    struct wl_fw_status_1 *status_1,
+			    struct wl_fw_status_2 *status_2)
 {
 	struct wl12xx_vif *wlvif;
 	struct timespec ts;
@@ -388,12 +388,15 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 	int avail, freed_blocks;
 	int i;
 	size_t status_len;
+	int ret;
 
 	status_len = WLCORE_FW_STATUS_1_LEN(wl->num_rx_desc) +
 		sizeof(*status_2) + wl->fw_status_priv_len;
 
-	wlcore_raw_read_data(wl, REG_RAW_FW_STATUS_ADDR, status_1,
-			     status_len, false);
+	ret = wlcore_raw_read_data(wl, REG_RAW_FW_STATUS_ADDR, status_1,
+				   status_len, false);
+	if (ret < 0)
+		return ret;
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
@@ -462,6 +465,8 @@ static void wl12xx_fw_status(struct wl1271 *wl,
 	getnstimeofday(&ts);
 	wl->time_offset = (timespec_to_ns(&ts) >> 10) -
 		(s64)le32_to_cpu(status_2->fw_localtime);
+
+	return 0;
 }
 
 static void wl1271_flush_deferred_work(struct wl1271 *wl)
@@ -530,7 +535,11 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		clear_bit(WL1271_FLAG_IRQ_RUNNING, &wl->flags);
 		smp_mb__after_clear_bit();
 
-		wl12xx_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
+		ret = wlcore_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
+		if (ret < 0) {
+			wl12xx_queue_recovery_work(wl);
+			goto out;
+		}
 
 		wlcore_hw_tx_immediate_compl(wl);
 
@@ -781,6 +790,7 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 	u32 offset;
 	u32 end_of_log;
 	u8 *block;
+	int ret;
 
 	if ((wl->quirks & WLCORE_QUIRK_FWLOG_NOT_IMPLEMENTED) ||
 	    (wl->conf.fwlog.mem_blocks == 0))
@@ -802,7 +812,10 @@ static void wl12xx_read_fwlog_panic(struct wl1271 *wl)
 		wl12xx_cmd_stop_fwlog(wl);
 
 	/* Read the first memory block address */
-	wl12xx_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
+	ret = wlcore_fw_status(wl, wl->fw_status_1, wl->fw_status_2);
+	if (ret < 0)
+		goto out;
+
 	addr = le32_to_cpu(wl->fw_status_2->log_start_addr);
 	if (!addr)
 		goto out;
-- 
1.7.10

