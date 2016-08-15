Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([198.47.19.11]:37701 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbcHOISM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2016 04:18:12 -0400
From: Maxim Altshul <maxim.altshul@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: Maxim Altshul <maxim.altshul@ti.com>,
	Kalle Valo <kvalo@codeaurora.org>,
	<linux-wireless@vger.kernel.org>
Subject: [PATCH 2/2 v2] wlcore: Remove wl pointer from wl_sta structure
Date: Mon, 15 Aug 2016 11:23:38 +0300
Message-ID: <20160815082400.12053-1-maxim.altshul@ti.com> (sfid-20160815_101835_911378_596F2713)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This field was added to wl_sta struct to get hw in situations
where it was not given to driver by mac80211.

In our case, get_expected_throughput op did not send hw to driver.

This patch reverts the change, as it is no longer needed due to
get_expected_throughput op change (hw is now sent as a parameter)

Signed-off-by: Maxim Altshul <maxim.altshul@ti.com>
---
Changed the commit message to better explain the changey

 drivers/net/wireless/ti/wlcore/main.c     | 1 -
 drivers/net/wireless/ti/wlcore/wlcore_i.h | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1ec3545..8589e5a 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -5043,7 +5043,6 @@ static int wl12xx_sta_add(struct wl1271 *wl,
 		return ret;
 
 	wl_sta = (struct wl1271_station *)sta->drv_priv;
-	wl_sta->wl = wl;
 	hlid = wl_sta->hlid;
 
 	ret = wl12xx_cmd_add_peer(wl, wlvif, sta, hlid);
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 3875190..8ee5206 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -352,7 +352,6 @@ struct wl1271_station {
 	 * Used in both AP and STA mode.
 	 */
 	u64 total_freed_pkts;
-	struct wl1271 *wl;
 };
 
 struct wl12xx_vif {
-- 
2.9.0

