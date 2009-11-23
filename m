Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:41121 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756035AbZKWVW7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Nov 2009 16:22:59 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 2/8] wl1271: Prevent PSM-entry retry loop if PSM cancelled
Date: Mon, 23 Nov 2009 23:22:13 +0200
Message-Id: <1259011339-28149-3-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
References: <1259011339-28149-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Prevent endless PSM-entry retry loops, if PSM has already been cancelled while
PSM entry was attempted.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index e135d89..d13fdd9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -78,12 +78,16 @@ static int wl1271_event_ps_report(struct wl1271 *wl,
 
 	switch (mbox->ps_status) {
 	case EVENT_ENTER_POWER_SAVE_FAIL:
+		if (!wl->psm) {
+			wl->psm_entry_retry = 0;
+			break;
+		}
+
 		if (wl->psm_entry_retry < wl->conf.conn.psm_entry_retries) {
 			wl->psm_entry_retry++;
-			wl1271_error("PSM entry failed, retrying %d\n",
-				     wl->psm_entry_retry);
 			ret = wl1271_ps_set_mode(wl, STATION_POWER_SAVE_MODE);
 		} else {
+			wl1271_error("PSM entry failed, giving up.\n");
 			wl->psm_entry_retry = 0;
 			*beacon_loss = true;
 		}
-- 
1.6.3.3

