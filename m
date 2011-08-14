Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55381 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752750Ab1HNKRX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Aug 2011 06:17:23 -0400
Received: by wwf5 with SMTP id 5so4061056wwf.1
        for <linux-wireless@vger.kernel.org>; Sun, 14 Aug 2011 03:17:22 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 09/40] wl12xx: enable/disable role on interface add/remove
Date: Sun, 14 Aug 2011 13:17:08 +0300
Message-Id: <1313317059-16567-10-git-send-email-eliad@wizery.com> (sfid-20110814_121727_401725_D370F2A2)
In-Reply-To: <1313317059-16567-1-git-send-email-eliad@wizery.com>
References: <1313317059-16567-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the new multi-role flow, we have to enable the
role before using (starting) it, and disable it on cleanup
(after it's no longer needed).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
v2: consider WL12XX_INVALID_ROLE_TYPE, skip cmd on wake-up error.

 drivers/net/wireless/wl12xx/main.c |   41 ++++++++++++++++++++++++++++++++++++
 1 files changed, 41 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 4689d0b..3e77f59 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1776,19 +1776,35 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 
 static void wl1271_op_stop(struct ieee80211_hw *hw)
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 }
 
+static u8 wl12xx_get_role_type(struct wl1271 *wl)
+{
+	switch (wl->bss_type) {
+	case BSS_TYPE_AP_BSS:
+		return WL1271_ROLE_AP;
+
+	case BSS_TYPE_STA_BSS:
+		return WL1271_ROLE_STA;
+
+	default:
+		wl1271_error("invalid bss_type: %d", wl->bss_type);
+	}
+	return WL12XX_INVALID_ROLE_TYPE;
+}
+
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wiphy *wiphy = hw->wiphy;
 	int retries = WL1271_BOOT_RETRIES;
 	int ret = 0;
+	u8 role_type;
 	bool booted = false;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 add interface type %d mac %pM",
 		     vif->type, vif->addr);
 
 	mutex_lock(&wl->mutex);
@@ -1823,12 +1839,17 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 		break;
 	default:
 		ret = -EOPNOTSUPP;
 		goto out;
 	}
 
+	role_type = wl12xx_get_role_type(wl);
+	if (role_type == WL12XX_INVALID_ROLE_TYPE) {
+		ret = -EINVAL;
+		goto out;
+	}
 	memcpy(wl->mac_addr, vif->addr, ETH_ALEN);
 
 	if (wl->state != WL1271_STATE_OFF) {
 		wl1271_error("cannot start because not in off state: %d",
 			     wl->state);
 		ret = -EBUSY;
@@ -1842,12 +1863,16 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 			goto power_off;
 
 		ret = wl1271_boot(wl);
 		if (ret < 0)
 			goto power_off;
 
+		ret = wl12xx_cmd_role_enable(wl, role_type, &wl->role_id);
+		if (ret < 0)
+			goto irq_disable;
+
 		ret = wl1271_hw_init(wl);
 		if (ret < 0)
 			goto irq_disable;
 
 		booted = true;
 		break;
@@ -1906,12 +1931,13 @@ out:
 	return ret;
 }
 
 static void __wl1271_op_remove_interface(struct wl1271 *wl,
 					 bool reset_tx_queues)
 {
+	int ret;
 
 	wl1271_debug(DEBUG_MAC80211, "mac80211 remove interface");
 
 	/* because of hardware recovery, we may get here twice */
 	if (wl->state != WL1271_STATE_ON)
 		return;
@@ -1930,12 +1956,27 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 		wl->scan.req = NULL;
 		ieee80211_scan_completed(wl->hw, true);
 	}
 
+	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
+		/* disable active roles */
+		ret = wl1271_ps_elp_wakeup(wl);
+		if (ret < 0)
+			goto deinit;
+
+		ret = wl12xx_cmd_role_disable(wl, &wl->role_id);
+		if (ret < 0)
+			goto deinit;
+
+		wl1271_ps_elp_sleep(wl);
+	}
+deinit:
+	wl->sta_hlid = WL12XX_INVALID_LINK_ID;
+
 	/*
 	 * this must be before the cancel_work calls below, so that the work
 	 * functions don't perform further work.
 	 */
 	wl->state = WL1271_STATE_OFF;
 
-- 
1.7.6.401.g6a319

