Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:60425 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757735AbZLKNlp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 Dec 2009 08:41:45 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH v2 20/31] wl1271: Fix event acknowledging functionality
Date: Fri, 11 Dec 2009 15:40:59 +0200
Message-Id: <1260538870-32297-21-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
References: <1260538870-32297-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

In reference source, events are acknowledged separately - fix the driver to
do the same.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    6 ++----
 drivers/net/wireless/wl12xx/wl1271_event.h |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c  |    5 ++---
 3 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index d13fdd9..227caa1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -184,7 +184,7 @@ void wl1271_event_mbox_config(struct wl1271 *wl)
 		     wl->mbox_ptr[0], wl->mbox_ptr[1]);
 }
 
-int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num, bool do_ack)
+int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num)
 {
 	struct event_mailbox mbox;
 	int ret;
@@ -204,9 +204,7 @@ int wl1271_event_handle(struct wl1271 *wl, u8 mbox_num, bool do_ack)
 		return ret;
 
 	/* then we let the firmware know it can go on...*/
-	if (do_ack)
-		wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG,
-				   INTR_TRIG_EVENT_ACK);
+	wl1271_spi_write32(wl, ACX_REG_INTERRUPT_TRIG, INTR_TRIG_EVENT_ACK);
 
 	return 0;
 }
diff --git a/drivers/net/wireless/wl12xx/wl1271_event.h b/drivers/net/wireless/wl12xx/wl1271_event.h
index 4e3f55e..278f920 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.h
+++ b/drivers/net/wireless/wl12xx/wl1271_event.h
@@ -112,6 +112,6 @@ struct event_mailbox {
 
 int wl1271_event_unmask(struct wl1271 *wl);
 void wl1271_event_mbox_config(struct wl1271 *wl);
-int wl1271_event_handle(struct wl1271 *wl, u8 mbox, bool do_ack);
+int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 272a8fa..d507dae 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -450,14 +450,13 @@ static void wl1271_irq_work(struct work_struct *work)
 	intr &= WL1271_INTR_MASK;
 
 	if (intr & WL1271_ACX_INTR_EVENT_A) {
-		bool do_ack = (intr & WL1271_ACX_INTR_EVENT_B) ? false : true;
 		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_A");
-		wl1271_event_handle(wl, 0, do_ack);
+		wl1271_event_handle(wl, 0);
 	}
 
 	if (intr & WL1271_ACX_INTR_EVENT_B) {
 		wl1271_debug(DEBUG_IRQ, "WL1271_ACX_INTR_EVENT_B");
-		wl1271_event_handle(wl, 1, true);
+		wl1271_event_handle(wl, 1);
 	}
 
 	if (intr & WL1271_ACX_INTR_INIT_COMPLETE)
-- 
1.6.3.3

