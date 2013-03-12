Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:60200 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755455Ab3CLNph (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Mar 2013 09:45:37 -0400
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH 04/13] wlcore: don't risk using stale HLID during .sta_state callback
Date: Tue, 12 Mar 2013 15:44:15 +0200
Message-ID: <1363095864-24422-5-git-send-email-coelho@ti.com> (sfid-20130312_144551_974287_18960DA0)
In-Reply-To: <1363095864-24422-1-git-send-email-coelho@ti.com>
References: <1363095864-24422-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

The HLID of a STA can change, particularly during recovery. Don't cache
the HLID before it was potentially allocated.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 389ae1a..c3e2471 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4620,13 +4620,11 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 				   enum ieee80211_sta_state new_state)
 {
 	struct wl1271_station *wl_sta;
-	u8 hlid;
 	bool is_ap = wlvif->bss_type == BSS_TYPE_AP_BSS;
 	bool is_sta = wlvif->bss_type == BSS_TYPE_STA_BSS;
 	int ret;
 
 	wl_sta = (struct wl1271_station *)sta->drv_priv;
-	hlid = wl_sta->hlid;
 
 	/* Add station (AP mode) */
 	if (is_ap &&
@@ -4652,12 +4650,12 @@ static int wl12xx_update_sta_state(struct wl1271 *wl,
 	/* Authorize station (AP mode) */
 	if (is_ap &&
 	    new_state == IEEE80211_STA_AUTHORIZED) {
-		ret = wl12xx_cmd_set_peer_state(wl, wlvif, hlid);
+		ret = wl12xx_cmd_set_peer_state(wl, wlvif, wl_sta->hlid);
 		if (ret < 0)
 			return ret;
 
 		ret = wl1271_acx_set_ht_capabilities(wl, &sta->ht_cap, true,
-						     hlid);
+						     wl_sta->hlid);
 		if (ret)
 			return ret;
 
-- 
1.7.10.4

