Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63277 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbZKQQtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:45 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 11/16] wl1251: Add IRQ looping support
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:31 +0200
Message-ID: <20091117164930.2236.43530.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janne Ylalehto <janne.ylalehto@nokia.com>

Add support for IRQ looping. Helps in the case that we have e.g. multiple
packets coming from the network when we wake up from the ELP.

Signed-off-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_main.c |  127 +++++++++++++++--------------
 1 files changed, 67 insertions(+), 60 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index cc32ba6..dad010d 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -212,9 +212,10 @@ out:
 	return ret;
 }
 
+#define WL1251_IRQ_LOOP_COUNT 10
 static void wl1251_irq_work(struct work_struct *work)
 {
-	u32 intr;
+	u32 intr, ctr = WL1251_IRQ_LOOP_COUNT;
 	struct wl1251 *wl =
 		container_of(work, struct wl1251, irq_work);
 	int ret;
@@ -235,78 +236,84 @@ static void wl1251_irq_work(struct work_struct *work)
 	intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
 	wl1251_debug(DEBUG_IRQ, "intr: 0x%x", intr);
 
-	if (wl->data_path) {
-		wl->rx_counter =
-			wl1251_mem_read32(wl, wl->data_path->rx_control_addr);
-
-		/* We handle a frmware bug here */
-		switch ((wl->rx_counter - wl->rx_handled) & 0xf) {
-		case 0:
-			wl1251_debug(DEBUG_IRQ, "RX: FW and host in sync");
-			intr &= ~WL1251_ACX_INTR_RX0_DATA;
-			intr &= ~WL1251_ACX_INTR_RX1_DATA;
-			break;
-		case 1:
-			wl1251_debug(DEBUG_IRQ, "RX: FW +1");
-			intr |= WL1251_ACX_INTR_RX0_DATA;
-			intr &= ~WL1251_ACX_INTR_RX1_DATA;
-			break;
-		case 2:
-			wl1251_debug(DEBUG_IRQ, "RX: FW +2");
-			intr |= WL1251_ACX_INTR_RX0_DATA;
-			intr |= WL1251_ACX_INTR_RX1_DATA;
-			break;
-		default:
-			wl1251_warning("RX: FW and host out of sync: %d",
-				       wl->rx_counter - wl->rx_handled);
-			break;
-		}
-
-		wl->rx_handled = wl->rx_counter;
+	do {
+		if (wl->data_path) {
+			wl->rx_counter = wl1251_mem_read32(
+				wl, wl->data_path->rx_control_addr);
+
+			/* We handle a frmware bug here */
+			switch ((wl->rx_counter - wl->rx_handled) & 0xf) {
+			case 0:
+				wl1251_debug(DEBUG_IRQ,
+					     "RX: FW and host in sync");
+				intr &= ~WL1251_ACX_INTR_RX0_DATA;
+				intr &= ~WL1251_ACX_INTR_RX1_DATA;
+				break;
+			case 1:
+				wl1251_debug(DEBUG_IRQ, "RX: FW +1");
+				intr |= WL1251_ACX_INTR_RX0_DATA;
+				intr &= ~WL1251_ACX_INTR_RX1_DATA;
+				break;
+			case 2:
+				wl1251_debug(DEBUG_IRQ, "RX: FW +2");
+				intr |= WL1251_ACX_INTR_RX0_DATA;
+				intr |= WL1251_ACX_INTR_RX1_DATA;
+				break;
+			default:
+				wl1251_warning(
+					"RX: FW and host out of sync: %d",
+					wl->rx_counter - wl->rx_handled);
+				break;
+			}
 
+			wl->rx_handled = wl->rx_counter;
 
-		wl1251_debug(DEBUG_IRQ, "RX counter: %d", wl->rx_counter);
-	}
+			wl1251_debug(DEBUG_IRQ, "RX counter: %d",
+				     wl->rx_counter);
+		}
 
-	intr &= wl->intr_mask;
+		intr &= wl->intr_mask;
 
-	if (intr == 0) {
-		wl1251_debug(DEBUG_IRQ, "INTR is 0");
-		wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK,
-				   ~(wl->intr_mask));
+		if (intr == 0) {
+			wl1251_debug(DEBUG_IRQ, "INTR is 0");
+			goto out_sleep;
+		}
 
-		goto out_sleep;
-	}
+		if (intr & WL1251_ACX_INTR_RX0_DATA) {
+			wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX0_DATA");
+			wl1251_rx(wl);
+		}
 
-	if (intr & WL1251_ACX_INTR_RX0_DATA) {
-		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX0_DATA");
-		wl1251_rx(wl);
-	}
+		if (intr & WL1251_ACX_INTR_RX1_DATA) {
+			wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX1_DATA");
+			wl1251_rx(wl);
+		}
 
-	if (intr & WL1251_ACX_INTR_RX1_DATA) {
-		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_RX1_DATA");
-		wl1251_rx(wl);
-	}
+		if (intr & WL1251_ACX_INTR_TX_RESULT) {
+			wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_TX_RESULT");
+			wl1251_tx_complete(wl);
+		}
 
-	if (intr & WL1251_ACX_INTR_TX_RESULT) {
-		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_TX_RESULT");
-		wl1251_tx_complete(wl);
-	}
+		if (intr & (WL1251_ACX_INTR_EVENT_A |
+			    WL1251_ACX_INTR_EVENT_B)) {
+			wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT (0x%x)",
+				     intr);
+			if (intr & WL1251_ACX_INTR_EVENT_A)
+				wl1251_event_handle(wl, 0);
+			else
+				wl1251_event_handle(wl, 1);
+		}
 
-	if (intr & (WL1251_ACX_INTR_EVENT_A | WL1251_ACX_INTR_EVENT_B)) {
-		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_EVENT (0x%x)", intr);
-		if (intr & WL1251_ACX_INTR_EVENT_A)
-			wl1251_event_handle(wl, 0);
-		else
-			wl1251_event_handle(wl, 1);
-	}
+		if (intr & WL1251_ACX_INTR_INIT_COMPLETE)
+			wl1251_debug(DEBUG_IRQ,
+				     "WL1251_ACX_INTR_INIT_COMPLETE");
 
-	if (intr & WL1251_ACX_INTR_INIT_COMPLETE)
-		wl1251_debug(DEBUG_IRQ, "WL1251_ACX_INTR_INIT_COMPLETE");
+		intr = wl1251_reg_read32(wl, ACX_REG_INTERRUPT_CLEAR);
 
-	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
+	} while (intr && --ctr);
 
 out_sleep:
+	wl1251_reg_write32(wl, ACX_REG_INTERRUPT_MASK, ~(wl->intr_mask));
 	wl1251_ps_elp_sleep(wl);
 
 out:

