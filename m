Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:34898 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754545Ab2BFKoT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 05:44:19 -0500
Received: by mail-wi0-f174.google.com with SMTP id s10so4057049wic.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 02:44:18 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 3/4] wl12xx: enter forced-psm on fw change
Date: Mon,  6 Feb 2012 12:47:56 +0200
Message-Id: <1328525277-25334-4-git-send-email-eliad@wizery.com> (sfid-20120206_114423_469841_BBA7933E)
In-Reply-To: <1328525277-25334-1-git-send-email-eliad@wizery.com>
References: <1328525277-25334-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Enter forced psm when changing fw, in order to make the
sta a bit more disconnection-persistent.
(DPM doesn't know about the incoming recovery, so it
won't enter psm by itself)

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a3c464f..eeb80f5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2127,6 +2127,19 @@ static bool wl12xx_need_fw_change(struct wl1271 *wl,
 	return false;
 }
 
+/*
+ * Enter "forced psm". Make sure the sta is in psm against the ap,
+ * to make the fw switch a bit more disconnection-persistent.
+ */
+static void wl12xx_force_active_psm(struct wl1271 *wl)
+{
+	struct wl12xx_vif *wlvif;
+
+	wl12xx_for_each_wlvif_sta(wl, wlvif) {
+		wl1271_ps_set_mode(wl, wlvif, STATION_POWER_SAVE_MODE);
+	}
+}
+
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
@@ -2178,6 +2191,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	}
 
 	if (wl12xx_need_fw_change(wl, vif_count, true)) {
+		wl12xx_force_active_psm(wl);
 		mutex_unlock(&wl->mutex);
 		wl1271_recovery_work(&wl->recovery_work);
 		return 0;
@@ -2370,6 +2384,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	}
 	WARN_ON(iter != wlvif);
 	if (wl12xx_need_fw_change(wl, vif_count, false)) {
+		wl12xx_force_active_psm(wl);
 		wl12xx_queue_recovery_work(wl);
 		cancel_recovery = false;
 	}
-- 
1.7.6.401.g6a319

