Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arroyo.ext.ti.com ([198.47.19.12]:49432 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753677AbcHRH3m (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Aug 2016 03:29:42 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <kvalo@codeaurora.org>, <johannes@sipsolutions.net>,
	Maxim Altshul <maxim.altshul@ti.com>
Subject: [PATCH 3/3] wlcore: Add RX_BA_WIN_SIZE_CHANGE_EVENT event
Date: Thu, 18 Aug 2016 10:36:27 +0300
Message-ID: <20160818073627.30972-4-maxim.altshul@ti.com> (sfid-20160818_092945_634439_4423F3B9)
In-Reply-To: <20160818073627.30972-3-maxim.altshul@ti.com>
References: <20160818073627.30972-1-maxim.altshul@ti.com>
 <20160818073627.30972-2-maxim.altshul@ti.com>
 <20160818073627.30972-3-maxim.altshul@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This event is used by the Firmware to limit the RX BA win size
for a specific link.

The event handler updates the new size in the mac's sta->sta struct.

BA sessions opened for that link will use the new restricted
win_size. This limitation remains until a new update is received or
until the link is closed.

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
 drivers/net/wireless/ti/wl18xx/event.c | 22 ++++++++++++++++++++++
 drivers/net/wireless/ti/wl18xx/event.h |  1 +
 drivers/net/wireless/ti/wl18xx/main.c  |  3 ++-
 3 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl18xx/event.c b/drivers/net/wireless/ti/wl18xx/event.c
index 2c5df43..a69be96 100644
--- a/drivers/net/wireless/ti/wl18xx/event.c
+++ b/drivers/net/wireless/ti/wl18xx/event.c
@@ -217,5 +217,27 @@ int wl18xx_process_mailbox_events(struct wl1271 *wl)
 	if (vector & FW_LOGGER_INDICATION)
 		wlcore_event_fw_logger(wl);
 
+	if (vector & RX_BA_WIN_SIZE_CHANGE_EVENT_ID) {
+		struct wl12xx_vif *wlvif;
+		struct ieee80211_vif *vif;
+		u8 link_id = mbox->rx_ba_link_id;
+		u8 win_size = mbox->rx_ba_win_size;
+		const u8 *addr;
+
+		wlvif = wl->links[link_id].wlvif;
+		vif = wl12xx_wlvif_to_vif(wlvif);
+
+		/* Call MAC routine to update win_size and stop all link active
+		 * BA sessions. This routine returns 0 on failure or previous
+		 * win_size on success
+		 */
+		if (wlvif->bss_type != BSS_TYPE_AP_BSS)
+			addr = vif->bss_conf.bssid;
+		else
+			addr = wl->links[link_id].addr;
+
+		ieee80211_change_rx_ba_max_subframes(vif, addr, win_size);
+	}
+
 	return 0;
 }
diff --git a/drivers/net/wireless/ti/wl18xx/event.h b/drivers/net/wireless/ti/wl18xx/event.h
index ce8ea9c0..4af297f 100644
--- a/drivers/net/wireless/ti/wl18xx/event.h
+++ b/drivers/net/wireless/ti/wl18xx/event.h
@@ -38,6 +38,7 @@ enum {
 	REMAIN_ON_CHANNEL_COMPLETE_EVENT_ID      = BIT(18),
 	DFS_CHANNELS_CONFIG_COMPLETE_EVENT       = BIT(19),
 	PERIODIC_SCAN_REPORT_EVENT_ID            = BIT(20),
+	RX_BA_WIN_SIZE_CHANGE_EVENT_ID           = BIT(21),
 	SMART_CONFIG_SYNC_EVENT_ID               = BIT(22),
 	SMART_CONFIG_DECODE_EVENT_ID             = BIT(23),
 	TIME_SYNC_EVENT_ID                       = BIT(24),
diff --git a/drivers/net/wireless/ti/wl18xx/main.c b/drivers/net/wireless/ti/wl18xx/main.c
index 00a04df..dafb2fd 100644
--- a/drivers/net/wireless/ti/wl18xx/main.c
+++ b/drivers/net/wireless/ti/wl18xx/main.c
@@ -1041,7 +1041,8 @@ static int wl18xx_boot(struct wl1271 *wl)
 		SMART_CONFIG_SYNC_EVENT_ID |
 		SMART_CONFIG_DECODE_EVENT_ID |
 		TIME_SYNC_EVENT_ID |
-		FW_LOGGER_INDICATION;
+		FW_LOGGER_INDICATION |
+		RX_BA_WIN_SIZE_CHANGE_EVENT_ID;
 
 	wl->ap_event_mask = MAX_TX_FAILURE_EVENT_ID;
 
-- 
2.9.0
