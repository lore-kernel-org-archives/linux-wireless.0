Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934311Ab1JEJ4W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:22 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:21 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 23/29] wl12xx: move pspoll_work into wlvif
Date: Wed,  5 Oct 2011 11:56:00 +0200
Message-Id: <1317808566-18857-24-git-send-email-eliad@wizery.com> (sfid-20111005_115628_512984_3B2F846F)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move pspoll_work into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/event.c  |    8 ++++----
 drivers/net/wireless/wl12xx/main.c   |    8 +++++---
 drivers/net/wireless/wl12xx/wl12xx.h |    4 +++-
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index f59e354..1ea508b 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -38,9 +38,9 @@ void wl1271_pspoll_work(struct work_struct *work)
 	int ret;
 
 	dwork = container_of(work, struct delayed_work, work);
-	wl = container_of(dwork, struct wl1271, pspoll_work);
-	vif = wl->vif; /* TODO: move work into vif struct */
-	wlvif = wl12xx_vif_to_data(vif);
+	wlvif = container_of(dwork, struct wl12xx_vif, pspoll_work);
+	vif = container_of((void *)wlvif, struct ieee80211_vif, drv_priv);
+	wl = wlvif->wl;
 
 	wl1271_debug(DEBUG_EVENT, "pspoll work");
 
@@ -90,7 +90,7 @@ static void wl1271_event_pspoll_delivery_fail(struct wl1271 *wl,
 		if (ret < 0)
 			return;
 		set_bit(WL1271_FLAG_PSPOLL_FAILURE, &wl->flags);
-		ieee80211_queue_delayed_work(wl->hw, &wl->pspoll_work,
+		ieee80211_queue_delayed_work(wl->hw, &wlvif->pspoll_work,
 					     msecs_to_jiffies(delay));
 	}
 
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 9302c88..4fe7662 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1766,7 +1766,7 @@ static int wl1271_op_suspend(struct ieee80211_hw *hw,
 
 	wl1271_enable_interrupts(wl);
 	flush_work(&wl->tx_work);
-	flush_delayed_work(&wl->pspoll_work);
+	flush_delayed_work(&wlvif->pspoll_work);
 	flush_delayed_work(&wl->elp_work);
 
 	return 0;
@@ -1902,6 +1902,8 @@ static int wl12xx_init_vif_data(struct ieee80211_vif *vif)
 	wlvif->rate_set = CONF_TX_RATE_MASK_BASIC;
 	wlvif->beacon_int = WL1271_DEFAULT_BEACON_INT;
 
+	INIT_DELAYED_WORK(&wlvif->pspoll_work, wl1271_pspoll_work);
+
 	return 0;
 }
 
@@ -1941,6 +1943,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	wlvif->wl = wl;
 	role_type = wl12xx_get_role_type(wl, wlvif);
 	if (role_type == WL12XX_INVALID_ROLE_TYPE) {
 		ret = -EINVAL;
@@ -2126,7 +2129,7 @@ deinit:
 	del_timer_sync(&wl->rx_streaming_timer);
 	cancel_work_sync(&wl->rx_streaming_enable_work);
 	cancel_work_sync(&wl->rx_streaming_disable_work);
-	cancel_delayed_work_sync(&wl->pspoll_work);
+	cancel_delayed_work_sync(&wlvif->pspoll_work);
 	cancel_delayed_work_sync(&wl->elp_work);
 
 	mutex_lock(&wl->mutex);
@@ -4833,7 +4836,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	skb_queue_head_init(&wl->deferred_tx_queue);
 
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
-	INIT_DELAYED_WORK(&wl->pspoll_work, wl1271_pspoll_work);
 	INIT_WORK(&wl->netstack_work, wl1271_netstack_work);
 	INIT_WORK(&wl->tx_work, wl1271_tx_work);
 	INIT_WORK(&wl->recovery_work, wl1271_recovery_work);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4755aad..d016509 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -510,7 +510,6 @@ struct wl1271 {
 	struct completion *elp_compl;
 	struct completion *ps_compl;
 	struct delayed_work elp_work;
-	struct delayed_work pspoll_work;
 
 	/* counter for ps-poll delivery failures */
 	int ps_poll_failures;
@@ -603,6 +602,7 @@ struct wl1271_station {
 };
 
 struct wl12xx_vif {
+	struct wl1271 *wl;
 	u8 bss_type;
 	u8 p2p; /* we are using p2p role */
 	u8 role_id;
@@ -649,6 +649,8 @@ struct wl12xx_vif {
 
 	/* Session counter for the chipset */
 	int session_counter;
+
+	struct delayed_work pspoll_work;
 };
 
 static inline struct wl12xx_vif *wl12xx_vif_to_data(struct ieee80211_vif *vif)
-- 
1.7.6.401.g6a319

