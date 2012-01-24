Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:47378 "HELO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754750Ab2AXJGm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jan 2012 04:06:42 -0500
Received: by mail-lpp01m010-f47.google.com with SMTP id s15so3026393lag.34
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jan 2012 01:06:40 -0800 (PST)
MIME-Version: 1.0
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, Ido Yariv <ido@wizery.com>
Subject: [PATCH 1/8] wl12xx: Acquire lock before stopping plt
Date: Tue, 24 Jan 2012 11:06:22 +0200
Message-Id: <1327395989-29663-2-git-send-email-coelho@ti.com> (sfid-20120124_100655_172174_CF37D8FC)
In-Reply-To: <1327395989-29663-1-git-send-email-coelho@ti.com>
References: <1327395989-29663-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ido Yariv <ido@wizery.com>

__wl1271_plt_stop is called from both wl1271_plt_stop and
wl1271_unregister_hw. While wl1271_plt_stop acquires a mutex,
wl1271_unregister_hw does not.

Fix this by calling wl1271_plt_stop instead of __wl1271_plt_stop from
wl1271_unregister_hw.

Signed-off-by: Ido Yariv <ido@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   18 +++++-------------
 1 files changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 915d56c..fc4d4d5 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1391,13 +1391,15 @@ out:
 	return ret;
 }
 
-static int __wl1271_plt_stop(struct wl1271 *wl)
+int wl1271_plt_stop(struct wl1271 *wl)
 {
 	int ret = 0;
 
 	wl1271_notice("power down");
 
+	mutex_lock(&wl->mutex);
 	if (wl->state != WL1271_STATE_PLT) {
+		mutex_unlock(&wl->mutex);
 		wl1271_error("cannot power down because not in PLT "
 			     "state: %d", wl->state);
 		ret = -EBUSY;
@@ -1410,25 +1412,15 @@ static int __wl1271_plt_stop(struct wl1271 *wl)
 	wl->rx_counter = 0;
 
 	mutex_unlock(&wl->mutex);
+
 	wl1271_disable_interrupts(wl);
 	wl1271_flush_deferred_work(wl);
 	cancel_work_sync(&wl->netstack_work);
 	cancel_work_sync(&wl->recovery_work);
-	mutex_lock(&wl->mutex);
 out:
 	return ret;
 }
 
-int wl1271_plt_stop(struct wl1271 *wl)
-{
-	int ret;
-
-	mutex_lock(&wl->mutex);
-	ret = __wl1271_plt_stop(wl);
-	mutex_unlock(&wl->mutex);
-	return ret;
-}
-
 static void wl1271_op_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
 {
 	struct wl1271 *wl = hw->priv;
@@ -4878,7 +4870,7 @@ static int wl1271_register_hw(struct wl1271 *wl)
 static void wl1271_unregister_hw(struct wl1271 *wl)
 {
 	if (wl->state == WL1271_STATE_PLT)
-		__wl1271_plt_stop(wl);
+		wl1271_plt_stop(wl);
 
 	unregister_netdevice_notifier(&wl1271_dev_notifier);
 	ieee80211_unregister_hw(wl->hw);
-- 
1.7.4.1

