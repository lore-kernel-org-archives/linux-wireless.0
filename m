Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:17002 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754255Ab0I0Iiz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:55 -0400
Received: from vaebh106.NOE.Nokia.com (vaebh106.europe.nokia.com [10.160.244.32])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8cRcA026005
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:54 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 23/25] wl1271: Add handling for failing hardware scan command
Date: Mon, 27 Sep 2010 11:37:47 +0300
Message-Id: <1285576669-8070-24-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Currently, the driver does not handle a failing hardware command to scan in
any way - effectively, the scan machine will jam until the driver is shut down,
and future scan requests will just return -EBUSY to user space, resulting in
a type of busy-loop. The same problem occurs if the firmware fails to deliver
the scan completion event - add timeout for this.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +-
 drivers/net/wireless/wl12xx/wl1271_scan.c |   30 +++++++++++++++++++++++++---
 drivers/net/wireless/wl12xx/wl1271_scan.h |    2 +
 4 files changed, 32 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index b5369a6..6eb96ce 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -298,6 +298,7 @@ struct wl1271_rx_mem_pool_addr {
 struct wl1271_scan {
 	struct cfg80211_scan_request *req;
 	bool *scanned_ch;
+	bool failed;
 	u8 state;
 	u8 ssid[IW_ESSID_MAX_SIZE+1];
 	size_t ssid_len;
@@ -421,7 +422,7 @@ struct wl1271 {
 
 	/* Are we currently scanning */
 	struct wl1271_scan scan;
-	struct work_struct scan_complete_work;
+	struct delayed_work scan_complete_work;
 
 	/* Our association ID */
 	u16 aid;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 6e98c75..3f4e154 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -657,8 +657,8 @@ static int wl1271_setup(struct wl1271 *wl)
 
 	INIT_WORK(&wl->irq_work, wl1271_irq_work);
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
-	INIT_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
+	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
 
 	return 0;
 }
@@ -1013,7 +1013,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 
 	mutex_unlock(&wl->mutex);
 
-	cancel_work_sync(&wl->scan_complete_work);
+	cancel_delayed_work_sync(&wl->scan_complete_work);
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_delayed_work_sync(&wl->pspoll_work);
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.c b/drivers/net/wireless/wl12xx/wl1271_scan.c
index 20caceb..37f9ccb 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.c
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.c
@@ -30,8 +30,11 @@
 
 void wl1271_scan_complete_work(struct work_struct *work)
 {
-	struct wl1271 *wl =
-		container_of(work, struct wl1271, scan_complete_work);
+	struct delayed_work *dwork;
+	struct wl1271 *wl;
+
+	dwork = container_of(work, struct delayed_work, work);
+	wl = container_of(dwork, struct wl1271, scan_complete_work);
 
 	wl1271_debug(DEBUG_SCAN, "Scanning complete");
 
@@ -48,6 +51,11 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	mutex_unlock(&wl->mutex);
 
 	ieee80211_scan_completed(wl->hw, false);
+
+	if (wl->scan.failed) {
+		wl1271_info("Scan completed due to error.");
+		ieee80211_queue_work(wl->hw, &wl->recovery_work);
+	}
 }
 
 
@@ -191,7 +199,7 @@ out:
 
 void wl1271_scan_stm(struct wl1271 *wl)
 {
-	int ret;
+	int ret = 0;
 
 	switch (wl->scan.state) {
 	case WL1271_SCAN_STATE_IDLE:
@@ -241,13 +249,22 @@ void wl1271_scan_stm(struct wl1271 *wl)
 		break;
 
 	case WL1271_SCAN_STATE_DONE:
-		ieee80211_queue_work(wl->hw, &wl->scan_complete_work);
+		wl->scan.failed = false;
+		cancel_delayed_work(&wl->scan_complete_work);
+		ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
+					     msecs_to_jiffies(0));
 		break;
 
 	default:
 		wl1271_error("invalid scan state");
 		break;
 	}
+
+	if (ret < 0) {
+		cancel_delayed_work(&wl->scan_complete_work);
+		ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
+					     msecs_to_jiffies(0));
+	}
 }
 
 int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
@@ -270,6 +287,11 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	wl->scan.scanned_ch = kzalloc(req->n_channels *
 				      sizeof(*wl->scan.scanned_ch),
 				      GFP_KERNEL);
+	/* we assume failure so that timeout scenarios are handled correctly */
+	wl->scan.failed = true;
+	ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
+				     msecs_to_jiffies(WL1271_SCAN_TIMEOUT));
+
 	wl1271_scan_stm(wl);
 
 	return 0;
diff --git a/drivers/net/wireless/wl12xx/wl1271_scan.h b/drivers/net/wireless/wl12xx/wl1271_scan.h
index 1404e00..bb7af2a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_scan.h
+++ b/drivers/net/wireless/wl12xx/wl1271_scan.h
@@ -46,6 +46,8 @@ void wl1271_scan_complete_work(struct work_struct *work);
 #define WL1271_SCAN_BAND_5_GHZ 1
 #define WL1271_SCAN_PROBE_REQS 3
 
+#define WL1271_SCAN_TIMEOUT    10000 /* msec */
+
 enum {
 	WL1271_SCAN_STATE_IDLE,
 	WL1271_SCAN_STATE_2GHZ_ACTIVE,
-- 
1.6.3.3

