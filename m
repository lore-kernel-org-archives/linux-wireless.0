Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:55910 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996Ab0I3KoL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Sep 2010 06:44:11 -0400
Received: from esebh106.NOE.Nokia.com (esebh106.ntc.nokia.com [172.21.138.213])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8UAhgB2030518
	for <linux-wireless@vger.kernel.org>; Thu, 30 Sep 2010 05:44:08 -0500
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 2/2] wl1271: Move work-init calls to hw allocation
Date: Thu, 30 Sep 2010 13:43:28 +0300
Message-Id: <1285843408-6726-2-git-send-email-juuso.oikarinen@nokia.com>
In-Reply-To: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
References: <1285843408-6726-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Due to legacy reason, dating back to when the wl1251 and wl1271 still were
a unified driver, some work-structures are initialized on hardware startup.

The hardware recovery code creates a scenario in which it is possible for a
workstruct to be re-initialized while the work-function itself is running,
which causes a kernel WARNing and a subsequent reboot.

To remedy this, move the work initialization calls to the hw allocation,
which is the logically correct place for them anyway.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 2253458..1ed9d11 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -667,11 +667,6 @@ static int wl1271_setup(struct wl1271 *wl)
 		return -ENOMEM;
 	}
 
-	INIT_WORK(&wl->irq_work, wl1271_irq_work);
-	INIT_WORK(&wl->tx_work, wl1271_tx_work);
-	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
-	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
-
 	return 0;
 }
 
@@ -2489,6 +2484,10 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	INIT_DELAYED_WORK(&wl->pspoll_work, wl1271_pspoll_work);
+	INIT_WORK(&wl->irq_work, wl1271_irq_work);
+	INIT_WORK(&wl->tx_work, wl1271_tx_work);
+	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
+	INIT_DELAYED_WORK(&wl->scan_complete_work, wl1271_scan_complete_work);
 	wl->channel = WL1271_DEFAULT_CHANNEL;
 	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
-- 
1.6.3.3

