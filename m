Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:24423 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab0CZKyT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:19 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 19/24] wl1271: Configure probe-request template when associated
Date: Fri, 26 Mar 2010 12:53:28 +0200
Message-Id: <1269600813-32145-20-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Configure a probe-request template to the wl1271 when associated - the
wl1271 will use this to attempt to recover a connection when beacon loss
is detected.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |   12 ------------
 drivers/net/wireless/wl12xx/wl1271_main.c  |    9 +++++++++
 2 files changed, 9 insertions(+), 12 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index a5c1910..0e0808f 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -31,14 +31,11 @@
 static int wl1271_event_scan_complete(struct wl1271 *wl,
 				      struct event_mailbox *mbox)
 {
-	int size = sizeof(struct wl12xx_probe_req_template);
 	wl1271_debug(DEBUG_EVENT, "status: 0x%x",
 		     mbox->scheduled_scan_status);
 
 	if (test_bit(WL1271_FLAG_SCANNING, &wl->flags)) {
 		if (wl->scan.state == WL1271_SCAN_BAND_DUAL) {
-			wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4,
-						NULL, size);
 			/* 2.4 GHz band scanned, scan 5 GHz band, pretend
 			 * to the wl1271_cmd_scan function that we are not
 			 * scanning as it checks that.
@@ -52,15 +49,6 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 						WL1271_SCAN_BAND_5_GHZ,
 						wl->scan.probe_requests);
 		} else {
-			if (wl->scan.state == WL1271_SCAN_BAND_2_4_GHZ)
-				wl1271_cmd_template_set(wl,
-						CMD_TEMPL_CFG_PROBE_REQ_2_4,
-						NULL, size);
-			else
-				wl1271_cmd_template_set(wl,
-						CMD_TEMPL_CFG_PROBE_REQ_5,
-						NULL, size);
-
 			mutex_unlock(&wl->mutex);
 			ieee80211_scan_completed(wl->hw, false);
 			mutex_lock(&wl->mutex);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 523e051..849c4ac 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1667,6 +1667,15 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			if (ret < 0)
 				goto out_sleep;
 
+			/*
+			 * The SSID is intentionally set to NULL here - the
+			 * firmware will set the probe request with a
+			 * broadcast SSID regardless of what we set in the
+			 * template.
+			 */
+			ret = wl1271_cmd_build_probe_req(wl, NULL, 0,
+							 NULL, 0, wl->band);
+
 			ret = wl1271_acx_aid(wl, wl->aid);
 			if (ret < 0)
 				goto out_sleep;
-- 
1.6.3.3

