Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59631 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752322Ab0KYOjq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Nov 2010 09:39:46 -0500
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <luciano.coelho@nokia.com>
Subject: [RFC 2/2] wl12xx: Stop BA session event from device
Date: Thu, 25 Nov 2010 16:39:24 +0200
Message-Id: <1290695964-4208-2-git-send-email-shahar_levi@ti.com>
In-Reply-To: <1290695964-4208-1-git-send-email-shahar_levi@ti.com>
References: <1290695964-4208-1-git-send-email-shahar_levi@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding new event that close RX BA session in case of periodic BT activity
limiting WLAN activity.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Dependencies:
- BA Initiator patches have a runtime dependency on commit
   "[PATCH v3] wl12xx: BA Initiator support" and
   "[PATCH ] wl12xx: BA receiver support"

 drivers/net/wireless/wl12xx/boot.c  |    3 ++-
 drivers/net/wireless/wl12xx/event.c |   24 +++++++++++++++++++++++-
 2 files changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index 1eafb81..1270f5d 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -430,7 +430,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 		DISCONNECT_EVENT_COMPLETE_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PSPOLL_DELIVERY_FAILURE_EVENT_ID |
-		SOFT_GEMINI_SENSE_EVENT_ID;
+		SOFT_GEMINI_SENSE_EVENT_ID |
+		BA_SESSION_RX_CONSTRAINT_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 9815b7b..7cbeb2b 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -174,6 +174,25 @@ static void wl1271_event_rssi_trigger(struct wl1271 *wl,
 	wl->last_rssi_event = event;
 }
 
+static void wl1271_event_ba_rx_constraint(struct wl1271 *wl,
+					  struct event_mailbox *mbox)
+{
+	u8 tid_index = 0;
+
+	wl1271_debug(DEBUG_EVENT, "BA RX constraint event. ba_allowed = %d",
+		     mbox->ba_allowed);
+
+	wl->ba_allowed = mbox->ba_allowed;
+
+	if (!wl->ba_rx_bitmap)
+		return;
+
+	for (tid_index = 0; tid_index < CONF_TX_MAX_TID_COUNT; ++tid_index)
+		if (wl->ba_rx_bitmap & (BIT(0) << tid_index))
+			ieee80211_stop_rx_ba_session(wl->vif, tid_index,
+						     wl->bssid);
+}
+
 static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
 {
 	wl1271_debug(DEBUG_EVENT, "MBOX DUMP:");
@@ -241,8 +260,11 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_event_rssi_trigger(wl, mbox);
 	}
 
-	if (vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID)
+	if (vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID) {
 		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID");
+		if (wl->vif)
+			wl1271_event_ba_rx_constraint(wl, mbox);
+	}
 
 	if (wl->vif && beacon_loss)
 		ieee80211_connection_loss(wl->vif);
-- 
1.7.0.4

