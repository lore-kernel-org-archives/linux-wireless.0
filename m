Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:52775 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1CAK1d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 05:27:33 -0500
Received: by wyg36 with SMTP id 36so4507990wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 02:27:32 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: wakeup chip from ELP during scan
Date: Tue,  1 Mar 2011 12:27:26 +0200
Message-Id: <1298975246-1720-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commands are sometimes sent to FW on scan completion. Make sure the chip
is awake to receive them. Sending commands while the chip is in ELP
can cause SDIO read errors and/or crash the FW.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/cmd.c  |    1 +
 drivers/net/wireless/wl12xx/scan.c |   20 ++++++++++++++------
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/cmd.c b/drivers/net/wireless/wl12xx/cmd.c
index 97ffd7a..f0aa7ab 100644
--- a/drivers/net/wireless/wl12xx/cmd.c
+++ b/drivers/net/wireless/wl12xx/cmd.c
@@ -63,6 +63,7 @@ int wl1271_cmd_send(struct wl1271 *wl, u16 id, void *buf, size_t len,
 	cmd->status = 0;
 
 	WARN_ON(len % 4 != 0);
+	WARN_ON(test_bit(WL1271_FLAG_IN_ELP, &wl->flags));
 
 	wl1271_write(wl, wl->cmd_box_addr, buf, len, false);
 
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 6f897b9..4c26977 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -27,6 +27,7 @@
 #include "cmd.h"
 #include "scan.h"
 #include "acx.h"
+#include "ps.h"
 
 void wl1271_scan_complete_work(struct work_struct *work)
 {
@@ -40,10 +41,11 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
-	if (wl->scan.state == WL1271_SCAN_STATE_IDLE) {
-		mutex_unlock(&wl->mutex);
-		return;
-	}
+	if (wl->state == WL1271_STATE_OFF)
+		goto out;
+
+	if (wl->scan.state == WL1271_SCAN_STATE_IDLE)
+		goto out;
 
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
 	kfree(wl->scan.scanned_ch);
@@ -52,13 +54,19 @@ void wl1271_scan_complete_work(struct work_struct *work)
 	ieee80211_scan_completed(wl->hw, false);
 
 	/* restore hardware connection monitoring template */
-	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags))
-		wl1271_cmd_build_ap_probe_req(wl, wl->probereq);
+	if (test_bit(WL1271_FLAG_STA_ASSOCIATED, &wl->flags)) {
+		if (wl1271_ps_elp_wakeup(wl, false) == 0) {
+			wl1271_cmd_build_ap_probe_req(wl, wl->probereq);
+			wl1271_ps_elp_sleep(wl);
+		}
+	}
 
 	if (wl->scan.failed) {
 		wl1271_info("Scan completed due to error.");
 		ieee80211_queue_work(wl->hw, &wl->recovery_work);
 	}
+
+out:
 	mutex_unlock(&wl->mutex);
 
 }
-- 
1.7.1

