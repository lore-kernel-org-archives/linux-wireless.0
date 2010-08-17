Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:61807 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752466Ab0HQTrZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Aug 2010 15:47:25 -0400
Received: by mail-ey0-f174.google.com with SMTP id 5so2243590eyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Aug 2010 12:47:24 -0700 (PDT)
From: Grazvydas Ignotas <notasas@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>
Subject: [PATCH 4/4] wl1251: wait for join command complete event
Date: Tue, 17 Aug 2010 22:46:55 +0300
Message-Id: <1282074415-6168-5-git-send-email-notasas@gmail.com>
In-Reply-To: <1282074415-6168-1-git-send-email-notasas@gmail.com>
References: <1282074415-6168-1-git-send-email-notasas@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Poll for join command completion instead of waiting blindly for 10
msecs. There is a timeout of 100 msecs, if the command doesn't complete
by then, we return an error code.

Based on wl1271 patch 99d84c1de8fdf5f9b09f07fdbc628857a040bf8b
by Luciano Coelho.

Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
---
 drivers/net/wireless/wl12xx/wl1251_boot.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1251_event.c |   29 ++++++++++++++++++++++++++++
 drivers/net/wireless/wl12xx/wl1251_event.h |    1 +
 drivers/net/wireless/wl12xx/wl1251_main.c  |    8 ++----
 4 files changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 65e0416..5e65f47 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -302,7 +302,7 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 		ROAMING_TRIGGER_LOW_RSSI_EVENT_ID |
 		ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID |
 		REGAINED_BSS_EVENT_ID | BT_PTA_SENSE_EVENT_ID |
-		BT_PTA_PREDICTION_EVENT_ID;
+		BT_PTA_PREDICTION_EVENT_ID | JOIN_EVENT_COMPLETE_ID;
 
 	ret = wl1251_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index 020d764..e093a1c 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -97,6 +97,35 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 	return 0;
 }
 
+/*
+ * Poll the mailbox event field until any of the bits in the mask is set or a
+ * timeout occurs (WL1251_EVENT_TIMEOUT in msecs)
+ */
+int wl1251_event_wait(struct wl1251 *wl, u32 mask, int timeout_ms)
+{
+	u32 events_vector, event;
+	unsigned long timeout;
+
+	timeout = jiffies + msecs_to_jiffies(timeout_ms);
+
+	do {
+		if (time_after(jiffies, timeout))
+			return -ETIMEDOUT;
+
+		msleep(1);
+
+		/* read from both event fields */
+		wl1251_mem_read(wl, wl->mbox_ptr[0], &events_vector,
+				sizeof(events_vector));
+		event = events_vector & mask;
+		wl1251_mem_read(wl, wl->mbox_ptr[1], &events_vector,
+				sizeof(events_vector));
+		event |= events_vector & mask;
+	} while (!event);
+
+	return 0;
+}
+
 int wl1251_event_unmask(struct wl1251 *wl)
 {
 	int ret;
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.h b/drivers/net/wireless/wl12xx/wl1251_event.h
index f48a2b6..ec45647 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.h
+++ b/drivers/net/wireless/wl12xx/wl1251_event.h
@@ -117,5 +117,6 @@ struct event_mailbox {
 int wl1251_event_unmask(struct wl1251 *wl);
 void wl1251_event_mbox_config(struct wl1251 *wl);
 int wl1251_event_handle(struct wl1251 *wl, u8 mbox);
+int wl1251_event_wait(struct wl1251 *wl, u32 mask, int timeout_ms);
 
 #endif
diff --git a/drivers/net/wireless/wl12xx/wl1251_main.c b/drivers/net/wireless/wl12xx/wl1251_main.c
index 51474b6..c81e95b 100644
--- a/drivers/net/wireless/wl12xx/wl1251_main.c
+++ b/drivers/net/wireless/wl12xx/wl1251_main.c
@@ -339,11 +339,9 @@ static int wl1251_join(struct wl1251 *wl, u8 bss_type, u8 channel,
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * FIXME: we should wait for JOIN_EVENT_COMPLETE_ID but to simplify
-	 * locking we just sleep instead, for now
-	 */
-	msleep(10);
+	ret = wl1251_event_wait(wl, JOIN_EVENT_COMPLETE_ID, 100);
+	if (ret < 0)
+		wl1251_warning("join timeout");
 
 out:
 	return ret;
-- 
1.5.6.3

