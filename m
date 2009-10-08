Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56630 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbZJHS6i (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Oct 2009 14:58:38 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 14/20] wl1271: Clear probe-request template after scan
Date: Thu,  8 Oct 2009 21:56:30 +0300
Message-Id: <1255028196-6565-15-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
References: <1255028196-6565-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Clear the probe-request template on the firmware after scan. Unless
cleared, the firmware can independently send probe requests to the AP
and interfere with the mac80211 logic.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index f3afd4a..87055f7 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -26,6 +26,7 @@
 #include "wl1271_spi.h"
 #include "wl1271_event.h"
 #include "wl1271_ps.h"
+#include "wl12xx_80211.h"
 
 static int wl1271_event_scan_complete(struct wl1271 *wl,
 				      struct event_mailbox *mbox)
@@ -34,6 +35,9 @@ static int wl1271_event_scan_complete(struct wl1271 *wl,
 		     mbox->scheduled_scan_status);
 
 	if (wl->scanning) {
+		int size = sizeof(struct wl12xx_probe_req_template);
+		wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
+					size);
 		mutex_unlock(&wl->mutex);
 		ieee80211_scan_completed(wl->hw, false);
 		mutex_lock(&wl->mutex);
-- 
1.5.6.5

