Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:62351 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964906Ab2KVS7M (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Nov 2012 13:59:12 -0500
Received: by mail-ee0-f46.google.com with SMTP id e53so3046787eek.19
        for <linux-wireless@vger.kernel.org>; Thu, 22 Nov 2012 10:59:11 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 01/14] wlcore: don't call ieee80211_sched_scan_stopped directly
Date: Thu, 22 Nov 2012 18:06:11 +0200
Message-Id: <1353600384-32462-2-git-send-email-eliad@wizery.com> (sfid-20121122_195919_841995_DB263EF8)
In-Reply-To: <1353600384-32462-1-git-send-email-eliad@wizery.com>
References: <1353600384-32462-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When we stop sched scan during connection, we shouldn't
call ieee80211_sched_scan_stopped directly, but do it
in the normal flow, as part of the SCHED_SCAN_COMPLETED
event handling.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index ff9437a..9e6b7eb 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -3820,10 +3820,8 @@ static int wlcore_set_bssid(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 						wlvif->band);
 
 	/* we only support sched_scan while not connected */
-	if (wl->sched_scanning) {
+	if (wl->sched_scanning)
 		wl1271_scan_sched_scan_stop(wl, wlvif);
-		ieee80211_sched_scan_stopped(wl->hw);
-	}
 
 	ret = wl1271_acx_sta_rate_policies(wl, wlvif);
 	if (ret < 0)
-- 
1.7.6.401.g6a319

