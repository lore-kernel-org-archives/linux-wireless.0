Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:55138 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab1EVNLN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 May 2011 09:11:13 -0400
Received: from dlep33.itg.ti.com ([157.170.170.112])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id p4MDBCqB029006
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 08:11:12 -0500
Received: from dlep26.itg.ti.com (localhost [127.0.0.1])
	by dlep33.itg.ti.com (8.13.7/8.13.7) with ESMTP id p4MDBCpH018966
	for <linux-wireless@vger.kernel.org>; Sun, 22 May 2011 08:11:12 -0500 (CDT)
From: Shahar Levi <shahar_levi@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: Luciano Coelho <coelho@ti.com>
Subject: [PATCH v2 2/2] wl12xx: Stop BA session event from device
Date: Sun, 22 May 2011 16:10:22 +0300
Message-ID: <1306069822-3125-2-git-send-email-shahar_levi@ti.com> (sfid-20110522_151116_936831_A2AF7E5C)
In-Reply-To: <1306069822-3125-1-git-send-email-shahar_levi@ti.com>
References: <1306069822-3125-1-git-send-email-shahar_levi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding new event that close RX BA session in case of periodic BT activity
limiting WLAN activity.

Signed-off-by: Shahar Levi <shahar_levi@ti.com>
---
Changes from v1:
- Work queue implementation in mac80211
- wl1271_event_ba() to wl1271_stop_ba_event()
- Align 'struct event_mailbox'
- Mask events in Ap mode
- wl->ba_allowed type from u8 to bool
- Add debug to wl1271_op_ampdu_action()

 drivers/net/wireless/wl12xx/boot.c   |    3 ++-
 drivers/net/wireless/wl12xx/event.c  |   23 +++++++++++++++++++++++
 drivers/net/wireless/wl12xx/event.h  |   17 +++++++++++++++--
 drivers/net/wireless/wl12xx/init.c   |    1 +
 drivers/net/wireless/wl12xx/main.c   |    5 ++++-
 drivers/net/wireless/wl12xx/wl12xx.h |    1 +
 6 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/boot.c b/drivers/net/wireless/wl12xx/boot.c
index b07f8b7..7ccec07 100644
--- a/drivers/net/wireless/wl12xx/boot.c
+++ b/drivers/net/wireless/wl12xx/boot.c
@@ -485,7 +485,8 @@ static int wl1271_boot_run_firmware(struct wl1271 *wl)
 	if (wl->bss_type == BSS_TYPE_AP_BSS)
 		wl->event_mask |= STA_REMOVE_COMPLETE_EVENT_ID;
 	else
-		wl->event_mask |= DUMMY_PACKET_EVENT_ID;
+		wl->event_mask |= DUMMY_PACKET_EVENT_ID |
+			BA_SESSION_RX_CONSTRAINT_EVENT_ID;
 
 	ret = wl1271_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 9102443..0b68f13 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -186,6 +186,21 @@ static void wl12xx_event_soft_gemini_sense(struct wl1271 *wl,
 
 }
 
+static void wl1271_stop_ba_event(struct wl1271 *wl, u8 ba_allowed)
+{
+	/* Convert the value to bool */
+	wl->ba_allowed = !!ba_allowed;
+
+	/*
+	 * Return in case:
+	 * there are not BA open or the event indication is to allowed BA
+	 */
+	if ((!wl->ba_rx_bitmap) || (wl->ba_allowed))
+		return;
+
+	ieee80211_stop_rx_ba_session(wl->vif, wl->ba_rx_bitmap, wl->bssid);
+}
+
 static void wl1271_event_mbox_dump(struct event_mailbox *mbox)
 {
 	wl1271_debug(DEBUG_EVENT, "MBOX DUMP:");
@@ -266,6 +281,14 @@ static int wl1271_event_process(struct wl1271 *wl, struct event_mailbox *mbox)
 			wl1271_event_rssi_trigger(wl, mbox);
 	}
 
+	if ((vector & BA_SESSION_RX_CONSTRAINT_EVENT_ID) && !is_ap) {
+		wl1271_debug(DEBUG_EVENT, "BA_SESSION_RX_CONSTRAINT_EVENT_ID. "
+			     "ba_allowed = 0x%x", mbox->ba_allowed);
+
+		if (wl->vif)
+			wl1271_stop_ba_event(wl, mbox->ba_allowed);
+	}
+
 	if ((vector & DUMMY_PACKET_EVENT_ID) && !is_ap) {
 		wl1271_debug(DEBUG_EVENT, "DUMMY_PACKET_ID_EVENT_ID");
 		if (wl->vif)
diff --git a/drivers/net/wireless/wl12xx/event.h b/drivers/net/wireless/wl12xx/event.h
index b6cf06e..ce99adf 100644
--- a/drivers/net/wireless/wl12xx/event.h
+++ b/drivers/net/wireless/wl12xx/event.h
@@ -71,7 +71,7 @@ enum {
 	HEALTH_CHECK_REPLY_EVENT_ID		 = BIT(27),
 	PERIODIC_SCAN_COMPLETE_EVENT_ID		 = BIT(28),
 	PERIODIC_SCAN_REPORT_EVENT_ID		 = BIT(29),
-	BA_SESSION_TEAR_DOWN_EVENT_ID		 = BIT(30),
+	BA_SESSION_RX_CONSTRAINT_EVENT_ID	 = BIT(30),
 	EVENT_MBOX_ALL_EVENT_ID			 = 0x7fffffff,
 };
 
@@ -122,7 +122,20 @@ struct event_mailbox {
 	__le16 sta_aging_status;
 	__le16 sta_tx_retry_exceeded;
 
-	u8 reserved_5[24];
+	/*
+	 * Bitmap, Each bit set represents the Role ID for which this constraint
+	 * is set. Range: 0 - FF, FF means ANY role
+	 */
+	u8 ba_role_id;
+	/*
+	 * Bitmap, Each bit set represents the Link ID for which this constraint
+	 * is set. Not applicable if ba_role_id is set to ANY role (FF).
+	 * Range: 0 - FFFF, FFFF means ANY link in that role
+	 */
+	u8 ba_link_id;
+	u8 ba_allowed;
+
+	u8 reserved_5[21];
 } __packed;
 
 int wl1271_event_unmask(struct wl1271 *wl);
diff --git a/drivers/net/wireless/wl12xx/init.c b/drivers/net/wireless/wl12xx/init.c
index b85edcc..741d7a4 100644
--- a/drivers/net/wireless/wl12xx/init.c
+++ b/drivers/net/wireless/wl12xx/init.c
@@ -546,6 +546,7 @@ static int wl1271_set_ba_policies(struct wl1271 *wl)
 
 	/* Reset the BA RX indicators */
 	wl->ba_rx_bitmap = 0;
+	wl->ba_allowed = true;
 
 	/* validate that FW support BA */
 	wl1271_check_ba_support(wl);
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index fb0f764..94036bb 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3471,9 +3471,12 @@ static int wl1271_op_ampdu_action(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	wl1271_debug(DEBUG_MAC80211, "mac80211 ampdu: Rx tid %d action %d",
+		     tid, action);
+
 	switch (action) {
 	case IEEE80211_AMPDU_RX_START:
-		if (wl->ba_support) {
+		if ((wl->ba_support) && (wl->ba_allowed)) {
 			ret = wl1271_acx_set_ba_receiver_session(wl, tid, *ssn,
 								 true);
 			if (!ret)
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 1cafb08..4bc22d8 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -571,6 +571,7 @@ struct wl1271 {
 	/* RX BA constraint value */
 	bool ba_support;
 	u8 ba_rx_bitmap;
+	bool ba_allowed;
 
 	int tcxo_clock;
 
-- 
1.7.1

