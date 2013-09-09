Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:36961 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3IIJY4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Sep 2013 05:24:56 -0400
Received: by mail-wg0-f50.google.com with SMTP id j13so5041984wgh.17
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 02:24:54 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <luca@coelho.fi>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 03/13] wlcore: add ap_event_mask
Date: Mon,  9 Sep 2013 12:24:34 +0300
Message-Id: <1378718684-14430-3-git-send-email-eliad@wizery.com> (sfid-20130909_112459_000861_1B77AFF9)
In-Reply-To: <1378718684-14430-1-git-send-email-eliad@wizery.com>
References: <1378718684-14430-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add new ap_event_mask field, to indicate events that
should be unmasked only when there's an ap interface.

This is done in order to avoid spurious wakeups
when we don't care about the incoming event anyway.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   | 3 ++-
 drivers/net/wireless/ti/wl18xx/main.c   | 3 ++-
 drivers/net/wireless/ti/wlcore/event.c  | 1 +
 drivers/net/wireless/ti/wlcore/init.c   | 6 ++++++
 drivers/net/wireless/ti/wlcore/main.c   | 6 ++++++
 drivers/net/wireless/ti/wlcore/wlcore.h | 2 ++
 6 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 1c627da..f147e32 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1262,9 +1262,10 @@ static int wl12xx_boot(struct wl1271 *wl)
 		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
 		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID |
 		INACTIVE_STA_EVENT_ID |
-		MAX_TX_RETRY_EVENT_ID |
 		CHANNEL_SWITCH_COMPLETE_EVENT_ID;
 
+	wl->ap_event_mask = MAX_TX_RETRY_EVENT_ID;
+
 	ret = wlcore_boot_run_firmware(wl);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 7302308..a02e0bf 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -988,10 +988,11 @@ static int wl18xx_boot(struct wl1271 *wl)
 		BA_SESSION_RX_CONSTRAINT_EVENT_ID |
 		REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID |
 		INACTIVE_STA_EVENT_ID |
-		MAX_TX_FAILURE_EVENT_ID |
 		CHANNEL_SWITCH_COMPLETE_EVENT_ID |
 		DFS_CHANNELS_CONFIG_COMPLETE_EVENT;
 
+	wl->ap_event_mask = MAX_TX_FAILURE_EVENT_ID;
+
 	ret = wlcore_boot_run_firmware(wl);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/ti/wlcore/event.c b/drivers/net/wireless/ti/wlcore/event.c
index 67f6168..8d3b349 100644
--- a/drivers/net/wireless/ti/wlcore/event.c
+++ b/drivers/net/wireless/ti/wlcore/event.c
@@ -266,6 +266,7 @@ int wl1271_event_unmask(struct wl1271 *wl)
 {
 	int ret;
 
+	wl1271_debug(DEBUG_EVENT, "unmasking event_mask 0x%x", wl->event_mask);
 	ret = wl1271_acx_event_mbox_mask(wl, ~(wl->event_mask));
 	if (ret < 0)
 		return ret;
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 5c6f11e..7699f9d 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -571,6 +571,12 @@ int wl1271_init_vif_specific(struct wl1271 *wl, struct ieee80211_vif *vif)
 		ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
 		if (ret < 0)
 			return ret;
+
+		/* unmask ap events */
+		wl->event_mask |= wl->ap_event_mask;
+		ret = wl1271_event_unmask(wl);
+		if (ret < 0)
+			return ret;
 	/* first STA, no APs */
 	} else if (wl->sta_count == 0 && wl->ap_count == 0 && !is_ap) {
 		u8 sta_auth = wl->conf.conn.sta_sleep_auth;
diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index a537483..dbf3315 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2623,6 +2623,12 @@ deinit:
 	    !test_bit(WL1271_FLAG_INTENDED_FW_RECOVERY, &wl->flags))
 		goto unlock;
 
+	if (wl->ap_count == 0 && is_ap) {
+		/* mask ap events */
+		wl->event_mask &= ~wl->ap_event_mask;
+		wl1271_event_unmask(wl);
+	}
+
 	if (wl->ap_count == 0 && is_ap && wl->sta_count) {
 		u8 sta_auth = wl->conf.conn.sta_sleep_auth;
 		/* Configure for power according to debugfs */
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 54ce5d5..f927222 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -307,6 +307,8 @@ struct wl1271 {
 
 	/* The mbox event mask */
 	u32 event_mask;
+	/* events to unmask only when ap interface is up */
+	u32 ap_event_mask;
 
 	/* Mailbox pointers */
 	u32 mbox_size;
-- 
1.8.3.rc1.35.g9b79519

