Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab1JJINW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:22 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:21 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 26/29] wl12xx: call stop() on recovery
Date: Mon, 10 Oct 2011 10:13:14 +0200
Message-Id: <1318234397-21081-27-git-send-email-eliad@wizery.com> (sfid-20111010_101330_063201_CB15E932)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The recovery work should call stop() after it removed
all the existing interfaces.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index e9120c2..da89ff2 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -379,6 +379,7 @@ static bool bug_on_recovery;
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 struct ieee80211_vif *vif,
 					 bool reset_tx_queues);
+static void wl1271_op_stop(struct ieee80211_hw *hw);
 static void wl1271_free_ap_keys(struct wl1271 *wl, struct wl12xx_vif *wlvif);
 
 
@@ -1220,7 +1221,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	mutex_lock(&wl->mutex);
 
 	if (wl->state != WL1271_STATE_ON)
-		goto out;
+		goto out_unlock;
 
 	/* Avoid a recursive recovery */
 	set_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
@@ -1259,6 +1260,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 		vif = wl12xx_wlvif_to_vif(wlvif);
 		__wl1271_op_remove_interface(wl, vif, false);
 	}
+	mutex_unlock(&wl->mutex);
+	wl1271_op_stop(wl->hw);
 
 	clear_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags);
 
@@ -1269,8 +1272,8 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 * to restart the HW.
 	 */
 	ieee80211_wake_queues(wl->hw);
-
-out:
+	return;
+out_unlock:
 	mutex_unlock(&wl->mutex);
 }
 
-- 
1.7.6.401.g6a319

