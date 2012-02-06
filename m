Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34898 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718Ab2BFKoV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 05:44:21 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so4057049wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 02:44:20 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 4/4] wl12xx: delete wl->vif (and allow multiple vifs)
Date: Mon,  6 Feb 2012 12:47:57 +0200
Message-Id: <1328525277-25334-5-git-send-email-eliad@wizery.com> (sfid-20120206_114425_762317_073BC1BA)
In-Reply-To: <1328525277-25334-1-git-send-email-eliad@wizery.com>
References: <1328525277-25334-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Delete the global wl->vif (and the checks on it),
so multiple vifs could be added.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   11 -----------
 drivers/net/wireless/wl12xx/wl12xx.h |    2 --
 2 files changed, 0 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index eeb80f5..0434afa 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2160,13 +2160,6 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_unlock;
 
-	if (wl->vif) {
-		wl1271_debug(DEBUG_MAC80211,
-			     "multiple vifs are not supported yet");
-		ret = -EBUSY;
-		goto out;
-	}
-
 	/*
 	 * in some very corner case HW recovery scenarios its possible to
 	 * get here before __wl1271_op_remove_interface is complete, so
@@ -2240,7 +2233,6 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	wl->vif = vif;
 	list_add(&wlvif->list, &wl->wlvif_list);
 	set_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags);
 
@@ -2273,8 +2265,6 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 	if (!test_and_clear_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
 		return;
 
-	wl->vif = NULL;
-
 	/* because of hardware recovery, we may get here twice */
 	if (wl->state != WL1271_STATE_ON)
 		return;
@@ -5155,7 +5145,6 @@ static struct ieee80211_hw *wl1271_alloc_hw(void)
 	wl->rx_counter = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
 	wl->band = IEEE80211_BAND_2GHZ;
-	wl->vif = NULL;
 	wl->flags = 0;
 	wl->sg_enabled = true;
 	wl->hw_pg_ver = -1;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 021d84f..89467b2 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -440,8 +440,6 @@ struct wl1271 {
 	struct wl12xx_fw_status *fw_status;
 	struct wl1271_tx_hw_res_if *tx_res_if;
 
-	struct ieee80211_vif *vif;
-
 	/* Current chipset configuration */
 	struct conf_drv_settings conf;
 
-- 
1.7.6.401.g6a319

