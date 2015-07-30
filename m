Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from comal.ext.ti.com ([198.47.26.152]:51682 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbbG3TuK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 15:50:10 -0400
Received: from dflxv15.itg.ti.com ([128.247.5.124])
	by comal.ext.ti.com (8.13.7/8.13.7) with ESMTP id t6UJoA2w026446
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 14:50:10 -0500
Received: from DLEE70.ent.ti.com (dlee70.ent.ti.com [157.170.170.113])
	by dflxv15.itg.ti.com (8.14.3/8.13.8) with ESMTP id t6UJoA9W017454
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 14:50:10 -0500
From: Yaniv Machani <yanivma@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <yanivma@ti.com>
Subject: [PATCH 1/4] wlcore/wl18xx : add time sync event handling
Date: Thu, 30 Jul 2015 22:38:19 +0300
Message-ID: <1438285102-32751-1-git-send-email-yanivma@ti.com> (sfid-20150730_215015_316585_F4029A2C)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Added support for a new time sync event
the event data contains the WiLink TSF value.
To trigger the event, a HW modification is required,
so as a supporting firmware binary.

Signed-off-by: Yaniv Machani <yanivma@ti.com>
---
 drivers/net/wireless/ti/wl18xx/event.c |   13 +++++++++++++
 drivers/net/wireless/ti/wl18xx/event.h |   12 ++++++++----
 drivers/net/wireless/ti/wl18xx/main.c  |    4 ++--
 3 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 548bb9e..09c7e09 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -112,6 +112,14 @@ static int wlcore_smart_config_decode_event(struct wl1271 *wl,
 	return 0;
 }
 
+static void wlcore_event_time_sync(struct wl1271 *wl, u16 tsf_msb, u16 tsf_lsb)
+{
+	u32 clock;
+	/* convert the MSB+LSB to a u32 TSF value */
+	clock = (tsf_msb << 16) | tsf_lsb;
+	wl1271_info("TIME_SYNC_EVENT_ID: clock %u", clock);
+}
+
 int wl18xx_process_mailbox_events(struct wl1271 *wl)
 {
 	struct wl18xx_event_mailbox *mbox = wl->mbox;
@@ -128,6 +136,11 @@ int wl18xx_process_mailbox_events(struct wl1271 *wl)
 			wl18xx_scan_completed(wl, wl->scan_wlvif);
 	}
 
+	if (vector & TIME_SYNC_EVENT_ID)
+		wlcore_event_time_sync(wl,
+				mbox->time_sync_tsf_msb,
+				mbox->time_sync_tsf_lsb);
+
 	if (vector & RADAR_DETECTED_EVENT_ID) {
 		wl1271_info("radar event: channel %d type %s",
 			    mbox->radar_channel,
diff --git a/drivers/net/wireless/ti/wl18xx/event.h b/drivers/net/wireless/ti/wl18xx/event.h
index 266ee87..f3d4f13 100644
--- a/drivers/net/wireless/ti/wl18xx/event.h
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -38,8 +38,9 @@ enum {
 	REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID      = BIT(18),
 	DFS_CHANNELS_CONFIG_COMPLETE_EVENT       = BIT(19),
 	PERIODIC_SCAN_REPORT_EVENT_ID            = BIT(20),
-	SMART_CONFIG_SYNC_EVENT_ID		 = BIT(22),
-	SMART_CONFIG_DECODE_EVENT_ID		 = BIT(23),
+	SMART_CONFIG_SYNC_EVENT_ID               = BIT(22),
+	SMART_CONFIG_DECODE_EVENT_ID             = BIT(23),
+	TIME_SYNC_EVENT_ID                       = BIT(24),
 };
 
 enum wl18xx_radar_types {
@@ -95,13 +96,16 @@ struct wl18xx_event_mailbox {
 	/* smart config sync channel */
 	u8 sc_sync_channel;
 	u8 sc_sync_band;
-	u8 padding2[2];
 
+	/* time sync msb*/
+	u16 time_sync_tsf_msb;
 	/* radar detect */
 	u8 radar_channel;
 	u8 radar_type;
 
-	u8 padding3[2];
+	/* time sync lsb*/
+	u16 time_sync_tsf_lsb;
+
 } __packed;
 
 int wl18xx_wait_for_event(struct wl1271 *wl, enum wlcore_wait_event event,
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 49aca2c..2984056 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1026,8 +1026,8 @@ static int wl18xx_boot(struct wl1271 *wl)
 		CHANNEL_SWITCH_COMPLETE_EVENT_ID |
 		DFS_CHANNELS_CONFIG_COMPLETE_EVENT |
 		SMART_CONFIG_SYNC_EVENT_ID |
-		SMART_CONFIG_DECODE_EVENT_ID;
-;
+		SMART_CONFIG_DECODE_EVENT_ID |
+		TIME_SYNC_EVENT_ID;
 
 	wl->ap_event_mask = MAX_TX_FAILURE_EVENT_ID;
 
-- 
1.7.9

