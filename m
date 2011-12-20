Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:61599 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751224Ab1LTMzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Dec 2011 07:55:47 -0500
Received: by wibhm6 with SMTP id hm6so1391677wib.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Dec 2011 04:55:46 -0800 (PST)
From: Eyal Shapira <eyal@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH] wl12xx: mark no sched scan only after FW event
Date: Tue, 20 Dec 2011 14:55:38 +0200
Message-Id: <1324385738-3132-1-git-send-email-eyal@wizery.com> (sfid-20111220_135550_640837_4DB716C1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

stop sched scan isn't an immediate operation
and we need to wait for PERIODIC_SCAN_COMPLETE_EVENT_ID
after sending a stop before changing internal state
and notifying upper layers.
Not doing this caused problems when canceling an existing sched
scan and immediately requesting to start a new one
with a different configuration as the FW was still
in the middle of the previous sched scan.

Signed-off-by: Eyal Shapira <eyal@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c |    2 +-
 drivers/net/wireless/wl12xx/scan.c  |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 00ce794..d3280df68 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -267,8 +267,8 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 		wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_COMPLETE_EVENT "
 			     "(status 0x%0x)", mbox->scheduled_scan_status);
 		if (wl->sched_scanning) {
-			wl1271_scan_sched_scan_stop(wl);
 			ieee80211_sched_scan_stopped(wl->hw);
+			wl->sched_scanning = false;
 		}
 	}
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 260986b..8ff680e 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -754,7 +754,6 @@ void wl1271_scan_sched_scan_stop(struct wl1271 *wl)
 		wl1271_error("failed to send sched scan stop command");
 		goto out_free;
 	}
-	wl->sched_scanning = false;
 
 out_free:
 	kfree(stop);
-- 
1.7.4.1

