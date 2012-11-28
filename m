Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58302 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753855Ab2K1Jnb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 04:43:31 -0500
Received: by mail-wg0-f44.google.com with SMTP id dr13so3507300wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2012 01:43:30 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Eyal Shapira <eyal@wizery.com>,
	Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 18/20] wlcore: support scan reports during periodic scan
Date: Wed, 28 Nov 2012 11:42:47 +0200
Message-Id: <1354095769-8724-19-git-send-email-arik@wizery.com> (sfid-20121128_104346_475949_499931C2)
In-Reply-To: <1354095769-8724-1-git-send-email-arik@wizery.com>
References: <1354095769-8724-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Eyal Shapira <eyal@wizery.com>

FW API changed and now PERIODIC_SCAN_REPORT_EVENT is sent
in case results were found at the end of each sched scan
cycle. Previous FW was missing that and broke sched scan.

This API change is available from 18xx FW 8.5.0.0.27

[Arik - move changes to 18xx specific files, align FW structures to
latest for scan command]

Signed-off-by: Eyal Shapira <eyal@wizery.com>
Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/event.c |   10 +++++++---
 drivers/net/wireless/ti/wl18xx/event.c |    8 ++++++++
 drivers/net/wireless/ti/wl18xx/event.h |    1 +
 drivers/net/wireless/ti/wl18xx/main.c  |    1 +
 drivers/net/wireless/ti/wl18xx/scan.c  |    4 ++++
 drivers/net/wireless/ti/wl18xx/scan.h  |   20 +++++++++++++++++---
 drivers/net/wireless/ti/wlcore/event.c |   10 ----------
 drivers/net/wireless/ti/wlcore/event.h |    2 --
 drivers/net/wireless/ti/wlcore/scan.c  |    3 ++-
 drivers/net/wireless/ti/wlcore/scan.h  |    2 +-
 10 files changed, 41 insertions(+), 20 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/event.c b/drivers/net/wireless/ti/wl12xx/event.c
index 6437dac..6ac0ed7 100644
--- a/drivers/net/wireless/ti/wl12xx/event.c
+++ b/drivers/net/wireless/ti/wl12xx/event.c
@@ -64,9 +64,13 @@ int wl12xx_process_mailbox_events(struct wl1271 *wl)
 			wl12xx_scan_completed(wl, wl->scan_wlvif);
 	}
 
-	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID)
-		wlcore_event_sched_scan_report(wl,
-					       mbox->scheduled_scan_status);
+	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT,
+			     "PERIODIC_SCAN_REPORT_EVENT (status 0x%0x)",
+			     mbox->scheduled_scan_status);
+
+		wlcore_scan_sched_scan_results(wl);
+	}
 
 	if (vector & PERIODIC_SCAN_COMPLETE_EVENT_ID)
 		wlcore_event_sched_scan_completed(wl,
diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 02ef5aa..c9199d7 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -61,6 +61,14 @@ int wl18xx_process_mailbox_events(struct wl1271 *wl)
 			wl18xx_scan_completed(wl, wl->scan_wlvif);
 	}
 
+	if (vector & PERIODIC_SCAN_REPORT_EVENT_ID) {
+		wl1271_debug(DEBUG_EVENT,
+			     "PERIODIC_SCAN_REPORT_EVENT (results %d)",
+			     mbox->number_of_sched_scan_results);
+
+		wlcore_scan_sched_scan_results(wl);
+	}
+
 	if (vector & PERIODIC_SCAN_COMPLETE_EVENT_ID)
 		wlcore_event_sched_scan_completed(wl, 1);
 
diff --git a/drivers/net/wireless/ti/wl18xx/event.h b/drivers/net/wireless/ti/wl18xx/event.h
index b55fd31..398f3d2 100644
--- a/drivers/net/wireless/ti/wl18xx/event.h
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -37,6 +37,7 @@ enum {
 	BA_SESSION_RX_CONSTRAINT_EVENT_ID        = BIT(17),
 	REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID      = BIT(18),
 	DFS_CHANNELS_CONFIG_COMPLETE_EVENT       = BIT(19),
+	PERIODIC_SCAN_REPORT_EVENT_ID            = BIT(20),
 };
 
 struct wl18xx_event_mailbox {
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index ed44ba6..5529c4b 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -921,6 +921,7 @@ static int wl18xx_boot(struct wl1271 *wl)
 		SCAN_COMPLETE_EVENT_ID |
 		RSSI_SNR_TRIGGER_0_EVENT_ID |
 		PERIODIC_SCAN_COMPLETE_EVENT_ID |
+		PERIODIC_SCAN_REPORT_EVENT_ID |
 		DUMMY_PACKET_EVENT_ID |
 		PEER_REMOVE_COMPLETE_EVENT_ID |
 		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
diff --git a/drivers/net/wireless/ti/wl18xx/scan.c b/drivers/net/wireless/ti/wl18xx/scan.c
index 1df88d5..09d9445 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.c
+++ b/drivers/net/wireless/ti/wl18xx/scan.c
@@ -227,6 +227,10 @@ int wl18xx_scan_sched_scan_config(struct wl1271 *wl,
 
 	cmd->tag = WL1271_SCAN_DEFAULT_TAG;
 
+	/* create a PERIODIC_SCAN_REPORT_EVENT whenever we've got a match */
+	cmd->report_threshold = 1;
+	cmd->terminate_on_report = 0;
+
 	if (cmd->active[0]) {
 		u8 band = IEEE80211_BAND_2GHZ;
 		ret = wl12xx_cmd_build_probe_req(wl, wlvif,
diff --git a/drivers/net/wireless/ti/wl18xx/scan.h b/drivers/net/wireless/ti/wl18xx/scan.h
index 5eb8c7f..49d7d02 100644
--- a/drivers/net/wireless/ti/wl18xx/scan.h
+++ b/drivers/net/wireless/ti/wl18xx/scan.h
@@ -78,8 +78,7 @@ struct wl18xx_cmd_scan_params {
 	__le16 long_cycles_sec;
 	u8 short_cycles_count;
 	u8 total_cycles; /* 0 - infinite */
-	u8 rate;
-	u8 padding[1];
+	u8 padding[2];
 
 	union {
 		struct {
@@ -93,7 +92,22 @@ struct wl18xx_cmd_scan_params {
 	u8 ssid[IEEE80211_MAX_SSID_LEN];
 	u8 ssid_len;	 /* For SCAN_SSID_FILTER_SPECIFIC */
 	u8 tag;
-	u8 padding1[2];
+	u8 rate;
+
+	/*
+	* send SCAN_REPORT_EVENT in periodic scans after each cycle
+	* if number of results >= report_threshold. Must be 0 for
+	* non periodic scans
+	*/
+	u8 report_threshold;
+
+	/*
+	* Should periodic scan stop after a report event was created.
+	* Must be 0 for non periodic scans.
+	*/
+	u8 terminate_on_report;
+
+	u8 padding1[3];
 } __packed;
 
 struct wl18xx_cmd_scan_stop {
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 2776d95..70f289a 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -94,16 +94,6 @@ void wlcore_event_soft_gemini_sense(struct wl1271 *wl, u8 enable)
 }
 EXPORT_SYMBOL_GPL(wlcore_event_soft_gemini_sense);
 
-void wlcore_event_sched_scan_report(struct wl1271 *wl,
-				    u8 status)
-{
-	wl1271_debug(DEBUG_EVENT, "PERIODIC_SCAN_REPORT_EVENT (status 0x%0x)",
-		     status);
-
-	wl1271_scan_sched_scan_results(wl);
-}
-EXPORT_SYMBOL_GPL(wlcore_event_sched_scan_report);
-
 void wlcore_event_sched_scan_completed(struct wl1271 *wl,
 				       u8 status)
 {
diff --git a/drivers/net/wireless/ti/wlcore/event.h b/drivers/net/wireless/ti/wlcore/event.h
index b4353be..acc7a59 100644
--- a/drivers/net/wireless/ti/wlcore/event.h
+++ b/drivers/net/wireless/ti/wlcore/event.h
@@ -70,8 +70,6 @@ int wl1271_event_unmask(struct wl1271 *wl);
 int wl1271_event_handle(struct wl1271 *wl, u8 mbox);
 
 void wlcore_event_soft_gemini_sense(struct wl1271 *wl, u8 enable);
-void wlcore_event_sched_scan_report(struct wl1271 *wl,
-				    u8 status);
 void wlcore_event_sched_scan_completed(struct wl1271 *wl,
 				       u8 status);
 void wlcore_event_ba_rx_constraint(struct wl1271 *wl,
diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
index 2cbd5e8..c44a1c7 100644
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -461,9 +461,10 @@ out:
 }
 EXPORT_SYMBOL_GPL(wlcore_scan_sched_scan_ssid_list);
 
-void wl1271_scan_sched_scan_results(struct wl1271 *wl)
+void wlcore_scan_sched_scan_results(struct wl1271 *wl)
 {
 	wl1271_debug(DEBUG_SCAN, "got periodic scan results");
 
 	ieee80211_sched_scan_results(wl->hw);
 }
+EXPORT_SYMBOL_GPL(wlcore_scan_sched_scan_results);
diff --git a/drivers/net/wireless/ti/wlcore/scan.h b/drivers/net/wireless/ti/wlcore/scan.h
index 9ae6065..a6ab24b 100644
--- a/drivers/net/wireless/ti/wlcore/scan.h
+++ b/drivers/net/wireless/ti/wlcore/scan.h
@@ -39,7 +39,7 @@ int wl1271_scan_sched_scan_config(struct wl1271 *wl,
 				     struct cfg80211_sched_scan_request *req,
 				     struct ieee80211_sched_scan_ies *ies);
 int wl1271_scan_sched_scan_start(struct wl1271 *wl, struct wl12xx_vif *wlvif);
-void wl1271_scan_sched_scan_results(struct wl1271 *wl);
+void wlcore_scan_sched_scan_results(struct wl1271 *wl);
 
 #define WL1271_SCAN_MAX_CHANNELS       24
 #define WL1271_SCAN_DEFAULT_TAG        1
-- 
1.7.9.5

