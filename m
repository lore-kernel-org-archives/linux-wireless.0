Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:50461 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756514Ab0KRNTZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 08:19:25 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-da01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAIDJOPa030426
	for <linux-wireless@vger.kernel.org>; Thu, 18 Nov 2010 15:19:24 +0200
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Fix kernel crash related to hw recovery and interface shutdown
Date: Thu, 18 Nov 2010 15:19:02 +0200
Message-Id: <1290086342-12015-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

It is possible that the op_remove_interface function  is invoked exactly at
the same time has hw recovery is started. In this case it is possible for the
interface to be already removed in the op_remove_interface call, which
currently leads to a kernel warning and a subsequent kernel crash.

Fix this by ignoring the op_remove_interface call if the interface is already
down at that point.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 31f0e2f..11b0477 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1157,10 +1157,16 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	struct wl1271 *wl = hw->priv;
 
 	mutex_lock(&wl->mutex);
-	WARN_ON(wl->vif != vif);
-	__wl1271_op_remove_interface(wl);
-	mutex_unlock(&wl->mutex);
+	/*
+	 * wl->vif can be null here if someone shuts down the interface
+	 * just when hardware recovery has been started.
+	 */
+	if (wl->vif) {
+		WARN_ON(wl->vif != vif);
+		__wl1271_op_remove_interface(wl);
+	}
 
+	mutex_unlock(&wl->mutex);
 	cancel_work_sync(&wl->recovery_work);
 }
 
-- 
1.7.1

