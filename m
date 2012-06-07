Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog104.obsmtp.com ([74.125.149.73]:58760 "EHLO
	na3sys009aog104.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751488Ab2FGJRk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 05:17:40 -0400
Received: by lban1 with SMTP id n1so389359lba.24
        for <linux-wireless@vger.kernel.org>; Thu, 07 Jun 2012 02:17:36 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Reis <idor@ti.com>, Orit Brayer <orit@ti.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 4/5] wl18xx: PG2.0 HW Watch dog interrupt support
Date: Thu,  7 Jun 2012 12:17:24 +0300
Message-Id: <1339060645-3574-5-git-send-email-coelho@ti.com> (sfid-20120607_111744_007136_083396A7)
In-Reply-To: <1339060645-3574-1-git-send-email-coelho@ti.com>
References: <1339060645-3574-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Reis <idor@ti.com>

In PG2, the HW watchdog interrupt occupies bit0 of the event vector, and
the SW watchdog is relocated to bit9. We perform the relocation
globally, as there's only one watchdog bit on previous platforms (bit0).

[Only mask in the new bit9 for platforms supporting it. This avoids
spurious events on other platforms - Arik]

Signed-off-by: Orit Brayer <orit@ti.com>
Signed-off-by: Ido Reis <idor@ti.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wl12xx/acx.h  |   14 ++++++++++++++
 drivers/net/wireless/ti/wl12xx/main.c |    4 ++--
 drivers/net/wireless/ti/wl18xx/acx.h  |   20 ++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/main.c |   14 ++++++++++++--
 drivers/net/wireless/ti/wlcore/acx.h  |   27 ++++++++++++---------------
 drivers/net/wireless/ti/wlcore/main.c |   13 +++++++++++--
 6 files changed, 71 insertions(+), 21 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/acx.h b/drivers/net/wireless/ti/wl12xx/acx.h
index 1be0f2d..2a26868 100644
--- a/drivers/net/wireless/ti/wl12xx/acx.h
+++ b/drivers/net/wireless/ti/wl12xx/acx.h
@@ -26,6 +26,20 @@
 #include "../wlcore/wlcore.h"
 #include "../wlcore/acx.h"
 
+#define WL12XX_ACX_ALL_EVENTS_VECTOR	(WL1271_ACX_INTR_WATCHDOG      | \
+					WL1271_ACX_INTR_INIT_COMPLETE | \
+					WL1271_ACX_INTR_EVENT_A       | \
+					WL1271_ACX_INTR_EVENT_B       | \
+					WL1271_ACX_INTR_CMD_COMPLETE  | \
+					WL1271_ACX_INTR_HW_AVAILABLE  | \
+					WL1271_ACX_INTR_DATA)
+
+#define WL12XX_INTR_MASK		(WL1271_ACX_INTR_WATCHDOG      | \
+					WL1271_ACX_INTR_EVENT_A       | \
+					WL1271_ACX_INTR_EVENT_B       | \
+					WL1271_ACX_INTR_HW_AVAILABLE  | \
+					WL1271_ACX_INTR_DATA)
+
 struct wl1271_acx_host_config_bitmap {
 	struct acx_header header;
 
diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 41017ba..f74d76c 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1034,11 +1034,11 @@ static void wl12xx_pre_upload(struct wl1271 *wl)
 
 static void wl12xx_enable_interrupts(struct wl1271 *wl)
 {
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_ALL_EVENTS_VECTOR);
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL12XX_ACX_ALL_EVENTS_VECTOR);
 
 	wlcore_enable_interrupts(wl);
 	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
-			 WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
+			 WL1271_ACX_INTR_ALL & ~(WL12XX_INTR_MASK));
 
 	wl1271_write32(wl, WL12XX_HI_CFG, HI_CFG_DEF_VAL);
 }
diff --git a/drivers/net/wireless/ti/wl18xx/acx.h b/drivers/net/wireless/ti/wl18xx/acx.h
index cb6fd85..7d74b03 100644
--- a/drivers/net/wireless/ti/wl18xx/acx.h
+++ b/drivers/net/wireless/ti/wl18xx/acx.h
@@ -28,6 +28,26 @@
 /* numbers of bits the length field takes (add 1 for the actual number) */
 #define WL18XX_HOST_IF_LEN_SIZE_FIELD 15
 
+#define WL18XX_ACX_EVENTS_VECTOR_PG1	(WL1271_ACX_INTR_WATCHDOG      | \
+					WL1271_ACX_INTR_INIT_COMPLETE | \
+					WL1271_ACX_INTR_EVENT_A       | \
+					WL1271_ACX_INTR_EVENT_B       | \
+					WL1271_ACX_INTR_CMD_COMPLETE  | \
+					WL1271_ACX_INTR_HW_AVAILABLE  | \
+					WL1271_ACX_INTR_DATA)
+
+#define WL18XX_ACX_EVENTS_VECTOR_PG2	(WL18XX_ACX_EVENTS_VECTOR_PG1 | \
+					WL1271_ACX_SW_INTR_WATCHDOG)
+
+#define WL18XX_INTR_MASK_PG1		(WL1271_ACX_INTR_WATCHDOG      | \
+					WL1271_ACX_INTR_EVENT_A       | \
+					WL1271_ACX_INTR_EVENT_B       | \
+					WL1271_ACX_INTR_HW_AVAILABLE  | \
+					WL1271_ACX_INTR_DATA)
+
+#define WL18XX_INTR_MASK_PG2		(WL18XX_INTR_MASK_PG1         | \
+					WL1271_ACX_SW_INTR_WATCHDOG)
+
 struct wl18xx_acx_host_config_bitmap {
 	struct acx_header header;
 
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index bdf4ee1..84f8e27 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -776,11 +776,21 @@ static void wl18xx_set_mac_and_phy(struct wl1271 *wl)
 
 static void wl18xx_enable_interrupts(struct wl1271 *wl)
 {
-	wlcore_write_reg(wl, REG_INTERRUPT_MASK, WL1271_ACX_ALL_EVENTS_VECTOR);
+	u32 event_mask, intr_mask;
+
+	if (wl->chip.id == CHIP_ID_185x_PG10) {
+		event_mask = WL18XX_ACX_EVENTS_VECTOR_PG1;
+		intr_mask = WL18XX_INTR_MASK_PG1;
+	} else {
+		event_mask = WL18XX_ACX_EVENTS_VECTOR_PG2;
+		intr_mask = WL18XX_INTR_MASK_PG2;
+	}
+
+	wlcore_write_reg(wl, REG_INTERRUPT_MASK, event_mask);
 
 	wlcore_enable_interrupts(wl);
 	wlcore_write_reg(wl, REG_INTERRUPT_MASK,
-			 WL1271_ACX_INTR_ALL & ~(WL1271_INTR_MASK));
+			 WL1271_ACX_INTR_ALL & ~intr_mask);
 }
 
 static int wl18xx_boot(struct wl1271 *wl)
diff --git a/drivers/net/wireless/ti/wlcore/acx.h b/drivers/net/wireless/ti/wlcore/acx.h
index 46c300d..c018125 100644
--- a/drivers/net/wireless/ti/wlcore/acx.h
+++ b/drivers/net/wireless/ti/wlcore/acx.h
@@ -51,21 +51,18 @@
 #define WL1271_ACX_INTR_TRACE_A            BIT(7)
 /* Trace message on MBOX #B */
 #define WL1271_ACX_INTR_TRACE_B            BIT(8)
-
-#define WL1271_ACX_INTR_ALL		   0xFFFFFFFF
-#define WL1271_ACX_ALL_EVENTS_VECTOR       (WL1271_ACX_INTR_WATCHDOG      | \
-					    WL1271_ACX_INTR_INIT_COMPLETE | \
-					    WL1271_ACX_INTR_EVENT_A       | \
-					    WL1271_ACX_INTR_EVENT_B       | \
-					    WL1271_ACX_INTR_CMD_COMPLETE  | \
-					    WL1271_ACX_INTR_HW_AVAILABLE  | \
-					    WL1271_ACX_INTR_DATA)
-
-#define WL1271_INTR_MASK                   (WL1271_ACX_INTR_WATCHDOG     | \
-					    WL1271_ACX_INTR_EVENT_A      | \
-					    WL1271_ACX_INTR_EVENT_B      | \
-					    WL1271_ACX_INTR_HW_AVAILABLE | \
-					    WL1271_ACX_INTR_DATA)
+/* SW FW Initiated interrupt Watchdog timer expiration */
+#define WL1271_ACX_SW_INTR_WATCHDOG        BIT(9)
+
+#define WL1271_ACX_INTR_ALL             0xFFFFFFFF
+
+/* all possible interrupts - only appropriate ones will be masked in */
+#define WLCORE_ALL_INTR_MASK		(WL1271_ACX_INTR_WATCHDOG     | \
+					WL1271_ACX_INTR_EVENT_A       | \
+					WL1271_ACX_INTR_EVENT_B       | \
+					WL1271_ACX_INTR_HW_AVAILABLE  | \
+					WL1271_ACX_INTR_DATA          | \
+					WL1271_ACX_SW_INTR_WATCHDOG)
 
 /* Target's information element */
 struct acx_header {
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 8800a63..176a311 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -535,14 +535,23 @@ static irqreturn_t wl1271_irq(int irq, void *cookie)
 		wlcore_hw_tx_immediate_compl(wl);
 
 		intr = le32_to_cpu(wl->fw_status_1->intr);
-		intr &= WL1271_INTR_MASK;
+		intr &= WLCORE_ALL_INTR_MASK;
 		if (!intr) {
 			done = true;
 			continue;
 		}
 
 		if (unlikely(intr & WL1271_ACX_INTR_WATCHDOG)) {
-			wl1271_error("watchdog interrupt received! "
+			wl1271_error("HW watchdog interrupt received! starting recovery.");
+			wl->watchdog_recovery = true;
+			wl12xx_queue_recovery_work(wl);
+
+			/* restarting the chip. ignore any other interrupt. */
+			goto out;
+		}
+
+		if (unlikely(intr & WL1271_ACX_SW_INTR_WATCHDOG)) {
+			wl1271_error("SW watchdog interrupt received! "
 				     "starting recovery.");
 			wl->watchdog_recovery = true;
 			wl12xx_queue_recovery_work(wl);
-- 
1.7.10

