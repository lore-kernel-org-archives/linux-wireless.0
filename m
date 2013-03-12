Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:50605 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755468Ab3CLNpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:49 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 12/13] wlcore: correctly check state before regdomain conf
Date: Tue, 12 Mar 2013 15:44:23 +0200
Message-ID: <1363095864-24422-13-git-send-email-coelho@ti.com> (sfid-20130312_144556_592032_CE895084)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The wlcore state was checked without the mutex being taken. This leads
to WARN_ONs sometimes if a notification arrives when the driver
is on, but the mutex is only taken after it is off. This usually
happens if stopping the driver while connected to a network.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 43865d1..248daa9 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -108,8 +108,7 @@ static void wl1271_reg_notify(struct wiphy *wiphy,
 
 	}
 
-	if (likely(wl->state == WLCORE_STATE_ON))
-		wlcore_regdomain_config(wl);
+	wlcore_regdomain_config(wl);
 }
 
 static int wl1271_set_rx_streaming(struct wl1271 *wl, struct wl12xx_vif *wlvif,
@@ -3364,6 +3363,10 @@ void wlcore_regdomain_config(struct wl1271 *wl)
 		return;
 
 	mutex_lock(&wl->mutex);
+
+	if (unlikely(wl->state != WLCORE_STATE_ON))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
-- 
1.7.10.4

