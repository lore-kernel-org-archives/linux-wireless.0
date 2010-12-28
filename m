Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:53087 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0L1RhF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Dec 2010 12:37:05 -0500
Received: by mail-ey0-f174.google.com with SMTP id 27so4306524eye.19
        for <linux-wireless@vger.kernel.org>; Tue, 28 Dec 2010 09:37:05 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH v3 03/18] wl1271: AP mode - add AP specific event
Date: Tue, 28 Dec 2010 19:36:33 +0200
Message-Id: <1293557808-27068-4-git-send-email-arik@wizery.com>
In-Reply-To: <1293557808-27068-1-git-send-email-arik@wizery.com>
References: <1293557808-27068-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add STA-remove completion event. Unmask it during boot if operating in
AP-mode.
Ignore unrelated events in AP-mode.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/boot.c  |    3 +++
 drivers/net/wireless/wl12xx/event.c |    7 ++++---
 drivers/net/wireless/wl12xx/event.h |    1 +
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 4a9f929..bb4f283 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -432,6 +432,9 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
 		SOFT_GEMINI_SENSE_EVENT_ID;
 
+	if (wl->bss_type == BSS_TYPE_AP_BSS)
+		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
+
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
 		wl1271_error("EVENT mask setting failed");
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index f9146f5..3376a5d 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -186,6 +186,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	int ret;
 	u32 vector;
 	bool beacon_loss = false;
+	bool is_ap = (wl->bss_type == BSS_TYPE_AP_BSS);
 
 	wl1271_event_mbox_dump(mbox);
 
@@ -218,21 +219,21 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	 * BSS_LOSE_EVENT, beacon loss has to be reported to the stack.
 	 *
 	 */
-	if (vector & BSS_LOSE_EVENT_ID) {
+	if ((vector & BSS_LOSE_EVENT_ID) && !is_ap) {
 		wl1271_info("Beacon loss detected.");
 
 		/* indicate to the stack, that beacons have been lost */
 		beacon_loss = true;
 	}
 
-	if (vector & PS_REPORT_EVENT_ID) {
+	if ((vector & PS_REPORT_EVENT_ID) && !is_ap) {
 		wl1271_debug(DEBUG_EVENT, "PS_REPORT_EVENT");
 		ret = wl1271_event_ps_report(wl, mbox, &beacon_loss);
 		if (ret < 0)
 			return ret;
 	}
 
-	if (vector & PSPOLL_DELIVERY_FAILURE_EVENT_ID)
+	if ((vector & PSPOLL_DELIVERY_FAILURE_EVENT_ID) && !is_ap)
 		wl1271_event_pspoll_delivery_fail(wl);
 
 	if (vector & RSSI_SNR_TRIGGER_0_EVENT_ID) {
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index 6cce014..fd955f3 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -59,6 +59,7 @@ enum {
 	BSS_LOSE_EVENT_ID			 = BIT(18),
 	REGAINED_BSS_EVENT_ID			 = BIT(19),
 	ROAMING_TRIGGER_MAX_TX_RETRY_EVENT_ID	 = BIT(20),
+	STA_REMOVE_COMPLETE_EVENT_ID		 = BIT(21), /* AP */
 	SOFT_GEMINI_SENSE_EVENT_ID		 = BIT(22),
 	SOFT_GEMINI_PREDICTION_EVENT_ID		 = BIT(23),
 	SOFT_GEMINI_AVALANCHE_EVENT_ID		 = BIT(24),
-- 
1.7.1

