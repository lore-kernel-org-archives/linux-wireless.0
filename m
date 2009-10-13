Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:36168 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933762AbZJMJuD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Oct 2009 05:50:03 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 17/22] wl1271: Fix event handling mechanism
Date: Tue, 13 Oct 2009 12:47:54 +0300
Message-Id: <1255427279-1224-18-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
References: <1255427279-1224-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The event handling mechanism could miss events if multiple events would
occur simultaneously. Fix event handling mechanism to process all
events.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    6 ++++--
 drivers/net/wireless/wl12xx/wl1271_event.h |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |   17 +++++++++--------
 3 files changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index e2d7758..a4b11e4 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -126,7 +126,7 @@ void wl1271_event_mbox_config(struct wl1271 *wl)
 		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
 }
 
-int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
+int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num, bool do_ack)
 {
 	struct event_mailbox mbox;
 	int ret;
@@ -146,7 +146,9 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 		return ret;
 
 	/* then we let the firmware know it can go on...*/
-	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
+	if (do_ack)
+		wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG,
+				   INTR_TRIG_EVENT_ACK);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/wl1271_event.h
index 2cdce7c..adc4653 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.h
+++ b/drivers/net/wireless/wl12xx/wl1271_event.h
@@ -105,6 +105,6 @@ struct event_mailbox {
 
 int wl1271_event_unmask(struct wl1271 *wl);
 void wl1271_event_mbox_config(struct wl1271 *wl);
-int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
+int wl1271_event_handle(struct wl1271 *wl, u8 mbox, bool do_ack);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 19dbdb1..d6d1a4c 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -437,14 +437,15 @@ static void wl1271_irq_work(struct work_struct *work)
 
 	intr &= WL1271_INTR_MASK;
 
-	if (intr & (WL1271_ACX_INTR_EVENT_A |
-		    WL1271_ACX_INTR_EVENT_B)) {
-		wl1271_debug(DEBUG_IRQ,
-			     "WL1271_ACX_INTR_EVENT (0x%x)", intr);
-		if (intr & WL1271_ACX_INTR_EVENT_A)
-			wl1271_event_handle(wl, 0);
-		else
-			wl1271_event_handle(wl, 1);
+	if (intr & WL1271_ACX_INTR_EVENT_A) {
+		bool do_ack = (intr & WL1271_ACX_INTR_EVENT_B) ? false : true;
+		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_A");
+		wl1271_event_handle(wl, 0, do_ack);
+	}
+
+	if (intr & WL1271_ACX_INTR_EVENT_B) {
+		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_B");
+		wl1271_event_handle(wl, 1, true);
 	}
 
 	if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
-- 
1.5.6.5

