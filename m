Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.platinumzone24.at ([88.198.159.93]:49923 "EHLO
	mail.platinumzone24.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab1A3TLG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:11:06 -0500
Message-ID: <4D45B7BF.9040308@davizone.at>
Date: Sun, 30 Jan 2011 20:10:55 +0100
From: David Gnedt <david.gnedt@davizone.at>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
CC: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	Grazvydas Ignotas <notasas@gmail.com>,
	Denis 'GNUtoo' Carikli <GNUtoo@no-log.org>
Subject: [PATCH 05/18] wl1251: retry power save entry
References: <4D45A5AD.4010402@davizone.at>
In-Reply-To: <4D45A5AD.4010402@davizone.at>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Port of the power save entry retry code from wl1251 driver version included
in the Maemo Fremantle kernel.
This tries to enable power save mode up to 3 times before failing.

Signed-off-by: David Gnedt <david.gnedt@davizone.at>
---
Sorry for the partly broken patches, I thought I configured my client the
right way. I tried to stop the mails at my mailserver, but it was mostly
already too late.
---
 drivers/net/wireless/wl1251/boot.c   |    3 +-
 drivers/net/wireless/wl1251/event.c  |   44 ++++++++++++++++++++++++++++++++++
 drivers/net/wireless/wl1251/event.h  |    7 +++++
 drivers/net/wireless/wl1251/main.c   |    2 +
 drivers/net/wireless/wl1251/wl1251.h |    3 ++
 5 files changed, 58 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl1251/boot.c b/drivers/net/wireless/wl1251/boot.c
index d729daf..2ff2a00 100644
--- a/drivers/net/wireless/wl1251/boot.c
+++ b/drivers/net/wireless/wl1251/boot.c
@@ -299,7 +299,8 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 		ROAMING_TRIGGER_LOW_RSSI_EVENT_ID |
 		ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID |
 		REGAINED_BSS_EVENT_ID | BT_PTA_SENSE_EVENT_ID |
-		BT_PTA_PREDICTION_EVENT_ID | JOIN_EVENT_COMPLETE_ID;
+		BT_PTA_PREDICTION_EVENT_ID | JOIN_EVENT_COMPLETE_ID |
+		PS_REPORT_EVENT_ID;
 
 	ret = wl1251_event_unmask(wl);
 	if (ret < 0) {
diff --git a/drivers/net/wireless/wl1251/event.c b/drivers/net/wireless/wl1251/event.c
index 712372e..1f931e3 100644
--- a/drivers/net/wireless/wl1251/event.c
+++ b/drivers/net/wireless/wl1251/event.c
@@ -42,6 +42,43 @@ static int wl1251_event_scan_complete(struct wl1251 *wl,
 	return 0;
 }
 
+#define WL1251_PSM_ENTRY_RETRIES  3
+static int wl1251_event_ps_report(struct wl1251 *wl,
+				  struct event_mailbox *mbox)
+{
+	int ret = 0;
+
+	wl1251_debug(DEBUG_EVENT, "ps status: %x", mbox->ps_status);
+
+	switch (mbox->ps_status) {
+	case EVENT_ENTER_POWER_SAVE_FAIL:
+		wl1251_debug(DEBUG_PSM, "PSM entry failed");
+
+		if (!wl->psm) {
+			/* remain in active mode */
+			wl->psm_entry_retry = 0;
+			break;
+		}
+
+		if (wl->psm_entry_retry < WL1251_PSM_ENTRY_RETRIES) {
+			wl->psm_entry_retry++;
+			ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+		} else {
+			wl1251_error("Power save entry failed, giving up");
+			wl->psm_entry_retry = 0;
+		}
+		break;
+	case EVENT_ENTER_POWER_SAVE_SUCCESS:
+	case EVENT_EXIT_POWER_SAVE_FAIL:
+	case EVENT_EXIT_POWER_SAVE_SUCCESS:
+	default:
+		wl->psm_entry_retry = 0;
+		break;
+	}
+
+	return 0;
+}
+
 static void wl1251_event_mbox_dump(struct event_mailbox *mbox)
 {
 	wl1251_debug(DEBUG_EVENT, "MBOX DUMP:");
@@ -75,6 +112,13 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 		}
 	}
 
+	if (vector & PS_REPORT_EVENT_ID) {
+		wl1251_debug(DEBUG_EVENT, "PS_REPORT_EVENT");
+		ret = wl1251_event_ps_report(wl, mbox);
+		if (ret < 0)
+			return ret;
+	}
+
 	if (vector & SYNCHRONIZATION_TIMEOUT_EVENT_ID && wl->psm) {
 		wl1251_debug(DEBUG_EVENT, "SYNCHRONIZATION_TIMEOUT_EVENT");
 
diff --git a/drivers/net/wireless/wl1251/event.h b/drivers/net/wireless/wl1251/event.h
index 30eb5d1..88570a5 100644
--- a/drivers/net/wireless/wl1251/event.h
+++ b/drivers/net/wireless/wl1251/event.h
@@ -112,6 +112,13 @@ struct event_mailbox {
 	u8 padding[19];
 } __packed;
 
+enum {
+	EVENT_ENTER_POWER_SAVE_FAIL = 0,
+	EVENT_ENTER_POWER_SAVE_SUCCESS,
+	EVENT_EXIT_POWER_SAVE_FAIL,
+	EVENT_EXIT_POWER_SAVE_SUCCESS,
+};
+
 int wl1251_event_unmask(struct wl1251 *wl);
 void wl1251_event_mbox_config(struct wl1251 *wl);
 int wl1251_event_handle(struct wl1251 *wl, u8 mbox);
diff --git a/drivers/net/wireless/wl1251/main.c b/drivers/net/wireless/wl1251/main.c
index 86f3136..591080a 100644
--- a/drivers/net/wireless/wl1251/main.c
+++ b/drivers/net/wireless/wl1251/main.c
@@ -501,6 +501,7 @@ static void wl1251_op_stop(struct ieee80211_hw *hw)
 	wl->next_tx_complete = 0;
 	wl->elp = false;
 	wl->psm = 0;
+	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->channel = WL1251_DEFAULT_CHANNEL;
@@ -1478,6 +1479,7 @@ struct ieee80211_hw *wl1251_alloc_hw(void)
 	wl->elp = false;
 	wl->psm = 0;
 	wl->psm_requested = false;
+	wl->psm_entry_retry = 0;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1251_DEFAULT_POWER_LEVEL;
 	wl->beacon_int = WL1251_DEFAULT_BEACON_INT;
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index 2877023..04e8f7c 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -370,6 +370,9 @@ struct wl1251 {
 	/* PSM mode requested */
 	bool psm_requested;
 
+	/* retry counter for PSM entries */
+	u8 psm_entry_retry;
+
 	u16 beacon_int;
 	u8 dtim_period;
 
-- 
1.7.0.4


