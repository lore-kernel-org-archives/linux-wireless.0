Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:47136 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab1HYJna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Aug 2011 05:43:30 -0400
Received: by wwe5 with SMTP id 5so4823630wwe.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 Aug 2011 02:43:29 -0700 (PDT)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 5/6] wl12xx: AP mode - enable the BA constraint event from the FW
Date: Thu, 25 Aug 2011 12:43:16 +0300
Message-Id: <1314265397-19873-5-git-send-email-arik@wizery.com> (sfid-20110825_114334_096253_FDFF5272)
In-Reply-To: <1314265397-19873-1-git-send-email-arik@wizery.com>
References: <1314265397-19873-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Unblock the RX BA constraint event from firmware in AP mode as well.
This allows us to stop RX BA sessions when the FW requests it.

In addition refactor the handler for this event to make the flow
clearer.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c |   39 +++++++++++++++++++++-------------
 1 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 0bd7b02..c73fe4c 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -171,19 +171,26 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
 	wl->last_rssi_event = event;
 }
 
-static void wl1271_stop_ba_event(struct wl1271 *wl, u8 ba_allowed)
+static void wl1271_stop_ba_event(struct wl1271 *wl)
 {
-	/* Convert the value to bool */
-	wl->ba_allowed = !!ba_allowed;
-
-	/*
-	 * Return in case:
-	 * there are not BA open or the event indication is to allowed BA
-	 */
-	if ((!wl->ba_rx_bitmap) || (wl->ba_allowed))
-		return;
+	if (wl->bss_type != BSS_TYPE_AP_BSS) {
+		if (!wl->ba_rx_bitmap)
+			return;
+		ieee80211_stop_rx_ba_session(wl->vif, wl->ba_rx_bitmap,
+					     wl->bssid);
+	} else {
+		int i;
+		struct wl1271_link *lnk;
+		for (i = WL1271_AP_STA_HLID_START; i < WL12XX_MAX_LINKS; i++) {
+			lnk = &wl->links[i];
+			if (!wl1271_is_active_sta(wl, i) || !lnk->ba_bitmap)
+				continue;
 
-	ieee80211_stop_rx_ba_session(wl->vif, wl->ba_rx_bitmap, wl->bssid);
+			ieee80211_stop_rx_ba_session(wl->vif,
+						     lnk->ba_bitmap,
+						     lnk->addr);
+		}
+	}
 }
 
 static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
@@ -283,12 +290,14 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_event_rssi_trigger(wl, mbox);
 	}
 
-	if ((vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID) && !is_ap) {
+	if ((vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID)) {
 		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID. "
 			     "ba_allowed = 0x%x", mbox->rx_ba_allowed);
 
-		if (wl->vif)
-			wl1271_stop_ba_event(wl, mbox->rx_ba_allowed);
+		wl->ba_allowed = !!mbox->rx_ba_allowed;
+
+		if (wl->vif && !wl->ba_allowed)
+			wl1271_stop_ba_event(wl);
 	}
 
 	if ((vector & DUMMY_PACKET_EVENT_ID)) {
-- 
1.7.4.1

