Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from devils.ext.ti.com ([198.47.26.153]:59753 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab3A3IyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 03:54:11 -0500
Received: from dlelxv30.itg.ti.com ([172.17.2.17])
	by devils.ext.ti.com (8.13.7/8.13.7) with ESMTP id r0U8sBoQ029967
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 02:54:11 -0600
Received: from DFLE72.ent.ti.com (dfle72.ent.ti.com [128.247.5.109])
	by dlelxv30.itg.ti.com (8.13.8/8.13.8) with ESMTP id r0U8sBde006964
	for <linux-wireless@vger.kernel.org>; Wed, 30 Jan 2013 02:54:11 -0600
From: Luciano Coelho <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: <coelho@ti.com>
Subject: [PATCH] wlcore: don't hide real error code when booting fails
Date: Wed, 30 Jan 2013 10:53:14 +0200
Message-ID: <1359535995-18092-1-git-send-email-coelho@ti.com> (sfid-20130130_095414_897733_1C73D879)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There's no need to hide the actual error that was reported when
booting fails.  For instance, on I/O error, we were returing
-EINVALID, which doesn't make sense at all.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/ti/wlcore/main.c |   11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 731dd26..6455e2d 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -2072,7 +2072,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 	return 0;
 }
 
-static bool wl12xx_init_fw(struct wl1271 *wl)
+static int wl12xx_init_fw(struct wl1271 *wl)
 {
 	int retries = WL1271_BOOT_RETRIES;
 	bool booted = false;
@@ -2138,7 +2138,7 @@ power_off:
 
 	wl->state = WLCORE_STATE_ON;
 out:
-	return booted;
+	return ret;
 }
 
 static bool wl12xx_dev_role_started(struct wl12xx_vif *wlvif)
@@ -2206,7 +2206,6 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	struct vif_counter_data vif_count;
 	int ret = 0;
 	u8 role_type;
-	bool booted = false;
 
 	vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
 			     IEEE80211_VIF_SUPPORTS_CQM_RSSI;
@@ -2263,11 +2262,9 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		 */
 		memcpy(wl->addresses[0].addr, vif->addr, ETH_ALEN);
 
-		booted = wl12xx_init_fw(wl);
-		if (!booted) {
-			ret = -EINVAL;
+		ret = wl12xx_init_fw(wl);
+		if (ret < 0)
 			goto out;
-		}
 	}
 
 	ret = wl12xx_cmd_role_enable(wl, vif->addr,
-- 
1.7.10.4

