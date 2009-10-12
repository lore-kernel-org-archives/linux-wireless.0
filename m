Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:60071 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131AbZJLMWG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:22:06 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 09/16] wl1271: Update interrupt handling by removing an extra SPI read
Date: Mon, 12 Oct 2009 15:08:50 +0300
Message-Id: <1255349337-9776-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Remove separate interrupt register reading from the interrupt handling
routine. This will slightly improve interrupt performance.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   74 ++++++++++++-----------------
 drivers/net/wireless/wl12xx/wl1271_reg.h  |    2 +-
 2 files changed, 31 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 22d44ba..8ac9bc1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -76,20 +76,14 @@ static void wl1271_power_on(struct wl1271 *wl)
 	wl->set_power(true);
 }
 
-static void wl1271_fw_status(struct wl1271 *wl, struct wl1271_fw_status *status)
+static void wl1271_fw_status(struct wl1271 *wl,
+			     struct wl1271_fw_status *status)
 {
 	u32 total = 0;
 	int i;
 
-	/*
-	 * FIXME: Reading the FW status directly from the registers seems to
-	 * be the right thing to do, but it doesn't work.  And in the
-	 * reference driver, there is a workaround called
-	 * USE_SDIO_24M_WORKAROUND, which reads the status from memory
-	 * instead, so we do the same here.
-	 */
-
-	wl1271_spi_mem_read(wl, STATUS_MEM_ADDRESS, status, sizeof(*status));
+	wl1271_spi_reg_read(wl, FW_STATUS_ADDR, status,
+			    sizeof(*status), false);
 
 	wl1271_debug(DEBUG_IRQ, "intr: 0x%x (fw_rx_counter = %d, "
 		     "drv_rx_counter = %d, tx_results_counter = %d)",
@@ -114,11 +108,10 @@ static void wl1271_fw_status(struct wl1271 *wl, struct wl1271_fw_status *status)
 	wl->time_offset = jiffies_to_usecs(jiffies) - status->fw_localtime;
 }
 
-#define WL1271_IRQ_MAX_LOOPS 10
 static void wl1271_irq_work(struct work_struct *work)
 {
-	u32 intr, ctr = WL1271_IRQ_MAX_LOOPS;
 	int ret;
+	u32 intr;
 	struct wl1271 *wl =
 		container_of(work, struct wl1271, irq_work);
 
@@ -135,7 +128,8 @@ static void wl1271_irq_work(struct work_struct *work)
 
 	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK, WL1271_ACX_INTR_ALL);
 
-	intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
+	wl1271_fw_status(wl, wl->fw_status);
+	intr = wl->fw_status->intr;
 	if (!intr) {
 		wl1271_debug(DEBUG_IRQ, "Zero interrupt received.");
 		goto out_sleep;
@@ -143,43 +137,35 @@ static void wl1271_irq_work(struct work_struct *work)
 
 	intr &= WL1271_INTR_MASK;
 
-	do {
-		wl1271_fw_status(wl, wl->fw_status);
-
-
-		if (intr & (WL1271_ACX_INTR_EVENT_A |
-			    WL1271_ACX_INTR_EVENT_B)) {
-			wl1271_debug(DEBUG_IRQ,
-				     "WL1271_ACX_INTR_EVENT (0x%x)", intr);
-			if (intr & WL1271_ACX_INTR_EVENT_A)
-				wl1271_event_handle(wl, 0);
-			else
-				wl1271_event_handle(wl, 1);
-		}
+	if (intr & (WL1271_ACX_INTR_EVENT_A |
+		    WL1271_ACX_INTR_EVENT_B)) {
+		wl1271_debug(DEBUG_IRQ,
+			     "WL1271_ACX_INTR_EVENT (0x%x)", intr);
+		if (intr & WL1271_ACX_INTR_EVENT_A)
+			wl1271_event_handle(wl, 0);
+		else
+			wl1271_event_handle(wl, 1);
+	}
 
-		if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
-			wl1271_debug(DEBUG_IRQ,
-				     "WL1271_ACX_INTR_INIT_COMPLETE");
+	if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
+		wl1271_debug(DEBUG_IRQ,
+			     "WL1271_ACX_INTR_INIT_COMPLETE");
 
-		if (intr & WL1271_ACX_INTR_HW_AVAILABLE)
-			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
+	if (intr & WL1271_ACX_INTR_HW_AVAILABLE)
+		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_HW_AVAILABLE");
 
-		if (intr & WL1271_ACX_INTR_DATA) {
-			u8 tx_res_cnt = wl->fw_status->tx_results_counter -
-				wl->tx_results_count;
+	if (intr & WL1271_ACX_INTR_DATA) {
+		u8 tx_res_cnt = wl->fw_status->tx_results_counter -
+			wl->tx_results_count;
 
-			wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
+		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_DATA");
 
-			/* check for tx results */
-			if (tx_res_cnt)
-				wl1271_tx_complete(wl, tx_res_cnt);
+		/* check for tx results */
+		if (tx_res_cnt)
+			wl1271_tx_complete(wl, tx_res_cnt);
 
-			wl1271_rx(wl, wl->fw_status);
-		}
-
-		intr = wl1271_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
-		intr &= WL1271_INTR_MASK;
-	} while (intr && --ctr);
+		wl1271_rx(wl, wl->fw_status);
+	}
 
 out_sleep:
 	wl1271_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
diff --git a/drivers/net/wireless/wl12xx/wl1271_reg.h b/drivers/net/wireless/wl12xx/wl1271_reg.h
index bd12615..6af87b5 100644
--- a/drivers/net/wireless/wl12xx/wl1271_reg.h
+++ b/drivers/net/wireless/wl12xx/wl1271_reg.h
@@ -34,7 +34,7 @@
 #define REGISTERS_WORK_SIZE 0x0000b000
 
 #define HW_ACCESS_ELP_CTRL_REG_ADDR         0x1FFFC
-#define STATUS_MEM_ADDRESS                  0x40400
+#define FW_STATUS_ADDR                      (0x14FC0 + 0xA000)
 
 /* ELP register commands */
 #define ELPCTRL_WAKE_UP             0x1
-- 
1.5.6.5

