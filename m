Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from muru.com ([72.249.23.125]:48206 "EHLO muru.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S937505AbeFSJoB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Jun 2018 05:44:01 -0400
From: Tony Lindgren <tony@atomide.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Eyal Reizer <eyalr@ti.com>, Kishon Vijay Abraham I <kishon@ti.com>,
        Guy Mishol <guym@ti.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Maital Hahn <maitalm@ti.com>,
        Maxim Altshul <maxim.altshul@ti.com>,
        Shahar Patury <shaharp@ti.com>, linux-wireless@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: [PATCH 4/8] wlcore: Fix misplaced PM call for scan_complete_work()
Date: Tue, 19 Jun 2018 02:43:38 -0700
Message-Id: <20180619094342.81831-5-tony@atomide.com> (sfid-20180619_114406_345929_DA1C05C2)
In-Reply-To: <20180619094342.81831-1-tony@atomide.com>
References: <20180619094342.81831-1-tony@atomide.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

With runtime PM enabled, we now need to have wlcore enabled longer
until after we're done calling wlcore_cmd_regdomain_config_locked():

scan_complete_work()
 wlcore_cmd_regdomain_config_locked()
   wlcore_cmd_send_failsafe()
     wl12xx_sdio_raw_read()

Note that this is not needed before runtime PM support as the
custom PM code had it's own timer. We have not yet enabled runtime
PM autosuspend for wlcore and this is why this issue now shows up.

Let's fix the issues first before we enable runtime PM autosuspend.

Signed-off-by: Tony Lindgren <tony@atomide.com>
---
 drivers/net/wireless/ti/wlcore/scan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/scan.c b/drivers/net/wireless/ti/wlcore/scan.c
--- a/drivers/net/wireless/ti/wlcore/scan.c
+++ b/drivers/net/wireless/ti/wlcore/scan.c
@@ -78,8 +78,6 @@ void wl1271_scan_complete_work(struct work_struct *work)
 		wl1271_cmd_build_ap_probe_req(wl, wlvif, wlvif->probereq);
 	}
 
-	pm_runtime_put(wl->dev);
-
 	if (wl->scan.failed) {
 		wl1271_info("Scan completed due to error.");
 		wl12xx_queue_recovery_work(wl);
@@ -87,6 +85,8 @@ void wl1271_scan_complete_work(struct work_struct *work)
 
 	wlcore_cmd_regdomain_config_locked(wl);
 
+	pm_runtime_put(wl->dev);
+
 	ieee80211_scan_completed(wl->hw, &info);
 
 out:
-- 
2.17.1
