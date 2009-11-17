Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:52687 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329AbZKQQta (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Nov 2009 11:49:30 -0500
From: Kalle Valo <kalle.valo@iki.fi>
Subject: [PATCH 10/16] wl1251: Increase the beacon loss timeout value and
	handle regain event
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Date: Tue, 17 Nov 2009 18:49:23 +0200
Message-ID: <20091117164922.2236.70726.stgit@tikku>
In-Reply-To: <20091117164614.2236.8543.stgit@tikku>
References: <20091117164614.2236.8543.stgit@tikku>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Vidhya Govindan <vidhya.govindan@nokia.com>

This patch increases the number of beacons to be missed before generating
SYNC TIMEOUT event. It increases the beacon timeout period to 500
microseconds, which gives enough time for the firmware to receive probe
response or beacon. Also handled the regain event from firmware once it
receives a probe response or beacon.

Signed-off-by: Vidhya Govindan <vidhya.govindan@nokia.com>
Reviewed-by: Janne Ylalehto <janne.ylalehto@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Kalle Valo <kalle.valo@nokia.com>
---

 drivers/net/wireless/wl12xx/wl1251_acx.h   |    4 ++--
 drivers/net/wireless/wl12xx/wl1251_event.c |    8 ++++++++
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1251_acx.h b/drivers/net/wireless/wl12xx/wl1251_acx.h
index 44a4b04..6523714 100644
--- a/drivers/net/wireless/wl12xx/wl1251_acx.h
+++ b/drivers/net/wireless/wl12xx/wl1251_acx.h
@@ -463,8 +463,8 @@ struct acx_beacon_filter_ie_table {
 	u8 pad[3];
 } __attribute__ ((packed));
 
-#define SYNCH_FAIL_DEFAULT_THRESHOLD    5     /* number of beacons */
-#define NO_BEACON_DEFAULT_TIMEOUT       (100) /* TU */
+#define SYNCH_FAIL_DEFAULT_THRESHOLD    10     /* number of beacons */
+#define NO_BEACON_DEFAULT_TIMEOUT       (500) /* in microseconds */
 
 struct acx_conn_monit_params {
 	struct acx_header header;
diff --git a/drivers/net/wireless/wl12xx/wl1251_event.c b/drivers/net/wireless/wl12xx/wl1251_event.c
index f42121c..9d488c6 100644
--- a/drivers/net/wireless/wl12xx/wl1251_event.c
+++ b/drivers/net/wireless/wl12xx/wl1251_event.c
@@ -89,6 +89,14 @@ static int wl1251_event_process(struct wl1251 *wl, struct event_mailbox *mbox)
 		mutex_lock(&wl->mutex);
 	}
 
+	if (vector & REGAINED_BSS_EVENT_ID) {
+		if (wl->psm_requested) {
+			ret = wl1251_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
+			if (ret < 0)
+				return ret;
+		}
+	}
+
 	return 0;
 }
 

