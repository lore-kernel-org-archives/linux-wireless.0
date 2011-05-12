Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:43068 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757259Ab1ELOPx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 10:15:53 -0400
Received: by mail-ey0-f173.google.com with SMTP id 6so1482156eyb.18
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 07:15:51 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 2/7] wl12xx: listen to scheduled scan events
Date: Thu, 12 May 2011 17:15:35 +0300
Message-Id: <1305209740-30287-3-git-send-email-coelho@ti.com> (sfid-20110512_161555_444198_FE04D067)
In-Reply-To: <1305209740-30287-1-git-send-email-coelho@ti.com>
References: <1305209740-30287-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subscribe and listen to PERIODIC_SCAN_REPORT_EVENT_ID and
PERIODIC_SCAN_COMPLETE_EVENT_ID in preparation for the scheduled scan
implementation.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/boot.c  |    4 +++-
 drivers/net/wireless/wl12xx/event.c |   10 ++++++++++
 2 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 2b0cf85..b07f8b7 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -478,7 +478,9 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		DISCONNECT_EVENT_COMPLETE_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
-		SOFT_GEMINI_SENSE_EVENT_ID;
+		SOFT_GEMINI_SENSE_EVENT_ID |
+		PERIODIC_SCAN_REPORT_EVENT_ID |
+		PERIODIC_SCAN_COMPLETE_EVENT_ID;
 
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index ae69330..dc110e8 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -188,6 +188,16 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl1271_scan_stm(wl);
 	}
 
+	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_REPORT_EVENT "
+			     "(status 0x%0x)", mbox->scheduled_scan_status);
+	}
+
+	if (vector & PERIODIC_SCAN_COMPLETE_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_COMPLETE_EVENT "
+			     "(status 0x%0x)", mbox->scheduled_scan_status);
+	}
+
 	/* disable dynamic PS when requested by the firmware */
 	if (vector & SOFT_GEMINI_SENSE_EVENT_ID &&
 	    wl->bss_type == BSS_TYPE_STA_BSS) {
-- 
1.7.1

