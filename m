Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:25268 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754276Ab0DAIiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Apr 2010 04:38:54 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 7/8] wl1271: Fix debug prints for beacon-loss and psm-entry-fail scenarios
Date: Thu,  1 Apr 2010 11:38:23 +0300
Message-Id: <1270111104-29549-8-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
References: <1270111104-29549-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Remove ERROR print from psm-entry-fail scenario, instead use an INFO print.
Also, add INFO print to the beacon-loss scenario.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index 4fc212a..daacf17 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -81,7 +81,7 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE,
 						 true);
 		} else {
-			wl1271_error("PSM entry failed, giving up.\n");
+			wl1271_info("No ack to nullfunc from AP.");
 			wl->psm_entry_retry = 0;
 			*beacon_loss = true;
 		}
@@ -160,7 +160,7 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 	 *
 	 */
 	if (vector & BSS_LOSE_EVENT_ID) {
-		wl1271_debug(DEBUG_EVENT, "BSS_LOSE_EVENT");
+		wl1271_info("Beacon loss detected.");
 
 		/* indicate to the stack, that beacons have been lost */
 		beacon_loss = true;
-- 
1.6.3.3

