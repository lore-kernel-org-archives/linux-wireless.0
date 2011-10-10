Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1JJINH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:07 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:13:06 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 18/29] wl12xx: make WL1271_FLAG_IF_INITIALIZED per-vif
Date: Mon, 10 Oct 2011 10:13:06 +0200
Message-Id: <1318234397-21081-19-git-send-email-eliad@wizery.com> (sfid-20111010_101314_115749_5DD593BD)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Make the initialization flag per-vif, and add some checks for it.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   32 +++++++++++++++++++++++++-------
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 36c7493..25599ad 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1817,14 +1817,20 @@ static void wl1271_op_stop(struct ieee80211_hw *hw)
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 
-	mutex_lock(&wl_list_mutex);
-	list_del(&wl->list);
-
+	mutex_lock(&wl->mutex);
+	if (wl->state == WL1271_STATE_OFF) {
+		mutex_unlock(&wl->mutex);
+		return;
+	}
 	/*
 	 * this must be before the cancel_work calls below, so that the work
 	 * functions don't perform further work.
 	 */
 	wl->state = WL1271_STATE_OFF;
+	mutex_unlock(&wl->mutex);
+
+	mutex_lock(&wl_list_mutex);
+	list_del(&wl->list);
 	mutex_unlock(&wl_list_mutex);
 
 	wl1271_disable_interrupts(wl);
@@ -1971,7 +1977,6 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 	setup_timer(&wlvif->rx_streaming_timer, wl1271_rx_streaming_timer,
 		    (unsigned long) wlvif);
-
 	return 0;
 }
 
@@ -2069,7 +2074,8 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 	 * get here before __wl1271_op_remove_interface is complete, so
 	 * opt out if that is the case.
 	 */
-	if (test_bit(WL1271_FLAG_IF_INITIALIZED, &wl->flags)) {
+	if (test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags) ||
+	    test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)) {
 		ret = -EBUSY;
 		goto out;
 	}
@@ -2129,7 +2135,7 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 
 	wl->vif = vif;
 	list_add(&wlvif->list, &wl->wlvif_list);
-	set_bit(WL1271_FLAG_IF_INITIALIZED, &wl->flags);
+	set_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags);
 out:
 	mutex_unlock(&wl->mutex);
 
@@ -2150,6 +2156,9 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
+	if (!test_and_clear_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
+		return;
+
 	/* because of hardware recovery, we may get here twice */
 	if (wl->state != WL1271_STATE_ON)
 		return;
@@ -2214,8 +2223,14 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 				       struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
+	struct wl12xx_vif *wlvif = wl12xx_vif_to_data(vif);
 
 	mutex_lock(&wl->mutex);
+
+	if (wl->state == WL1271_STATE_OFF ||
+	    !test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags))
+		goto out;
+
 	/*
 	 * wl->vif can be null here if someone shuts down the interface
 	 * just when hardware recovery has been started.
@@ -2224,7 +2239,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 		WARN_ON(wl->vif != vif);
 		__wl1271_op_remove_interface(wl, vif, true);
 	}
-
+out:
 	mutex_unlock(&wl->mutex);
 	cancel_work_sync(&wl->recovery_work);
 }
@@ -3833,6 +3848,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (unlikely(wl->state == WL1271_STATE_OFF))
 		goto out;
 
+	if (unlikely(!test_bit(WLVIF_FLAG_INITIALIZED, &wlvif->flags)))
+		goto out;
+
 	ret = wl1271_ps_elp_wakeup(wl);
 	if (ret < 0)
 		goto out;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 4741a4b..88d48b1 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -322,7 +322,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_IDLE,
 	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_FW_TX_BUSY,
-	WL1271_FLAG_IF_INITIALIZED,
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
 	WL1271_FLAG_SUSPENDED,
 	WL1271_FLAG_PENDING_WORK,
@@ -332,6 +331,7 @@ enum wl12xx_flags {
 };
 
 enum wl12xx_vif_flags {
+	WLVIF_FLAG_INITIALIZED,
 	WLVIF_FLAG_STA_ASSOCIATED,
 	WLVIF_FLAG_IBSS_JOINED,
 	WLVIF_FLAG_AP_STARTED,
-- 
1.7.6.401.g6a319

