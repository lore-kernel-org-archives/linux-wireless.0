Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:37669 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932861Ab0I0Iiy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:54 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx06.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8clXw013190
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 11:38:52 +0300
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 19/25] wl1271: Move scan complete invocation into work function
Date: Mon, 27 Sep 2010 11:37:43 +0300
Message-Id: <1285576669-8070-20-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The current scan implementation can jam, if the scan request ends up
containing no work. This can especially happen if there is a scan request
with only 11a band channels for HW that does not support 11a.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    1 +
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 ++++
 drivers/net/wireless/wl12xx/wl1271_scan.c |   23 ++++++++++++++++++-----
 drivers/net/wireless/wl12xx/wl1271_scan.h |    1 +
 4 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 9782bc1..55ec656 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -418,6 +418,7 @@ struct wl1271 {
 
 	/* Are we currently scanning */
 	struct wl1271_scan scan;
+	struct work_struct scan_complete_work;
 
 	/* Our association ID */
 	u16 aid;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 44915ee..37f61de 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -634,6 +634,8 @@ static int wl1271_setup(struct wl1271 *wl)
 
 	INIT_WORK(&wl->irq_work, wl1271_irq_work);
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
+	INIT_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
+
 	return 0;
 }
 
@@ -962,6 +964,8 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 	int i;
 
+	cancel_work_sync(&wl->scan_complete_work);
+
 	mutex_lock(&wl->mutex);
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index 8d30150..9f1da82 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -28,6 +28,23 @@
 #include "wl1271_scan.h"
 #include "wl1271_acx.h"
 
+void wl1271_scan_complete_work(struct work_struct *work)
+{
+	struct wl1271 *wl =
+		container_of(work, struct wl1271, scan_complete_work);
+
+	wl1271_debug(DEBUG_SCAN, "Scanning complete");
+
+	mutex_lock(&wl->mutex);
+	wl->scan.state = WL1271_SCAN_STATE_IDLE;
+	kfree(wl->scan.scanned_ch);
+	wl->scan.scanned_ch = NULL;
+	mutex_unlock(&wl->mutex);
+
+	ieee80211_scan_completed(wl->hw, false);
+}
+
+
 static int wl1271_get_scan_channels(struct wl1271 *wl,
 				    struct cfg80211_scan_request *req,
 				    struct basic_scan_channel_params *channels,
@@ -218,11 +235,7 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		break;
 
 	case WL1271_SCAN_STATE_DONE:
-		kfree(wl->scan.scanned_ch);
-		wl->scan.scanned_ch = NULL;
-
-		wl->scan.state = WL1271_SCAN_STATE_IDLE;
-		ieee80211_scan_completed(wl->hw, false);
+		ieee80211_queue_work(wl->hw, &wl->scan_complete_work);
 		break;
 
 	default:
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.h b/drivers/net/wireless/wl12xx/wl1271_scan.h
index f181570..1404e00 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.h
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.h
@@ -32,6 +32,7 @@ int wl1271_scan_build_probe_req(struct wl1271 *wl,
 				const u8 *ssid, size_t ssid_len,
 				const u8 *ie, size_t ie_len, u8 band);
 void wl1271_scan_stm(struct wl1271 *wl);
+void wl1271_scan_complete_work(struct work_struct *work);
 
 #define WL1271_SCAN_MAX_CHANNELS       24
 #define WL1271_SCAN_DEFAULT_TAG        1
-- 
1.6.3.3

