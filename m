Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16943 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932871Ab0I0Iie (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:34 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8c5Ec024679
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:34 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 20/25] wl1271: Fix work cancelling when shutting down the driver
Date: Mon, 27 Sep 2010 11:37:44 +0300
Message-Id: <1285576669-8070-21-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The work cancelling has had several hazards, ranging from potentially
executing work after the driver is in OFF state, to executing work after
the driver and relevant memory structures are already removed.

Fix these.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_event.c |    3 +++
 drivers/net/wireless/wl12xx/wl1271_main.c  |    3 +++
 drivers/net/wireless/wl12xx/wl1271_ps.c    |    3 +++
 3 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_event.c b/drivers/net/wireless/wl12xx/wl1271_event.c
index bced829..e6c839a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_event.c
+++ b/drivers/net/wireless/wl12xx/wl1271_event.c
@@ -41,6 +41,9 @@ void wl1271_pspoll_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
 	if (!test_and_clear_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags))
 		goto out;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 37f61de..2c03cb1 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -792,6 +792,8 @@ int wl1271_plt_stop(struct wl1271 *wl)
 out:
 	mutex_unlock(&wl->mutex);
 
+	cancel_work_sync(&wl->irq_work);
+
 	return ret;
 }
 
@@ -995,6 +997,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	cancel_work_sync(&wl->irq_work);
 	cancel_work_sync(&wl->tx_work);
 	cancel_delayed_work_sync(&wl->pspoll_work);
+	cancel_delayed_work_sync(&wl->elp_work);
 
 	mutex_lock(&wl->mutex);
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_ps.c b/drivers/net/wireless/wl12xx/wl1271_ps.c
index f75668e..150dc67 100644
--- a/drivers/net/wireless/wl12xx/wl1271_ps.c
+++ b/drivers/net/wireless/wl12xx/wl1271_ps.c
@@ -39,6 +39,9 @@ void wl1271_elp_work(struct work_struct *work)
 
 	mutex_lock(&wl->mutex);
 
+	if (unlikely(wl->state == WL1271_STATE_OFF))
+		goto out;
+
 	if (test_bit(WL1271_FLAG_IN_ELP, &wl->flags) ||
 	    (!test_bit(WL1271_FLAG_PSM, &wl->flags) &&
 	     !test_bit(WL1271_FLAG_IDLE, &wl->flags)))
-- 
1.6.3.3

