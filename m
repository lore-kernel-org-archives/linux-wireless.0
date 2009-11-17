Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:63276 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbZKQQto (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:44 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 12/16] wl1251: Filter out unwanted events
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:38 +0200
Message-ID: <20091117164937.2236.78530.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Janne Ylalehto <janne.ylalehto@nokia.com>

Filter out unwanted events to reduce wakeups.

Signed-off-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Reviewed-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_boot.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_boot.c b/drivers/net/wireless/wl12xx/wl1251_boot.c
index 8febf27..5094f24 100644
--- a/drivers/net/wireless/wl12xx/wl1251_boot.c
+++ b/drivers/net/wireless/wl12xx/wl1251_boot.c
@@ -296,8 +296,12 @@ int wl1251_boot_run_firmware(struct wl1251 *wl)
 		WL1251_ACX_INTR_INIT_COMPLETE;
 	wl1251_boot_target_enable_interrupts(wl);
 
-	/* unmask all mbox events  */
-	wl->event_mask = 0xffffffff;
+	wl->event_mask = SCAN_COMPLETE_EVENT_ID | BSS_LOSE_EVENT_ID |
+		SYNCHRONIZATION_TIMEOUT_EVENT_ID |
+		ROAMING_TRIGGER_LOW_RSSI_EVENT_ID |
+		ROAMING_TRIGGER_REGAINED_RSSI_EVENT_ID |
+		REGAINED_BSS_EVENT_ID | BT_PTA_SENSE_EVENT_ID |
+		BT_PTA_PREDICTION_EVENT_ID;
 
 	ret = wl1251_event_unmask(wl);
 	if (ret < 0) {

