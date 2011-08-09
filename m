Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35863 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751812Ab1HIJNt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 05:13:49 -0400
Received: by mail-ww0-f44.google.com with SMTP id 5so2430702wwf.1
        for <linux-wireless@vger.kernel.org>; Tue, 09 Aug 2011 02:13:49 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 09/40] wl12xx: enable/disable role on interface add/remove
Date: Tue,  9 Aug 2011 12:13:22 +0300
Message-Id: <1312881233-9366-10-git-send-email-eliad@wizery.com> (sfid-20110809_111352_583384_D65FF08A)
In-Reply-To: <1312881233-9366-1-git-send-email-eliad@wizery.com>
References: <1312881233-9366-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

According to the new multi-role flow, we have to enable the
role before using (starting) it, and disable it on cleanup
(after it's no longer needed).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |   38 ++++++++++++++++++++++++++++++++++++
 1 files changed, 38 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index a348d18..ba0470f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1770,12 +1770,27 @@ static int wl1271_op_start(struct ieee80211_hw *hw)
 
 static void wl1271_op_stop(struct ieee80211_hw *hw)
 {
 	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
 }
 
+static u8 wl1271_get_role_type(struct wl1271 *wl)
+{
+	switch (wl->bss_type) {
+	case BSS_TYPE_AP_BSS:
+		return WL1271_ROLE_AP;
+
+	case BSS_TYPE_STA_BSS:
+		return WL1271_ROLE_STA;
+
+	default:
+		wl1271_info("invalid bss_type: %d", wl->bss_type);
+	}
+	return 0xff;
+}
+
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 				   struct ieee80211_vif *vif)
 {
 	struct wl1271 *wl = hw->priv;
 	struct wiphy *wiphy = hw->wiphy;
 	int retries = WL1271_BOOT_RETRIES;
@@ -1836,12 +1851,17 @@ static int wl1271_op_add_interface(struct ieee80211_hw *hw,
 			goto power_off;
 
 		ret = wl1271_boot(wl);
 		if (ret < 0)
 			goto power_off;
 
+		ret = wl1271_cmd_role_enable(wl, wl1271_get_role_type(wl),
+					     &wl->role_id);
+		if (ret < 0)
+			goto irq_disable;
+
 		ret = wl1271_hw_init(wl);
 		if (ret < 0)
 			goto irq_disable;
 
 		booted = true;
 		break;
@@ -1900,12 +1920,13 @@ out:
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
@@ -1924,12 +1945,29 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl,
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
 		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 		wl->scan.req = NULL;
 		ieee80211_scan_completed(wl->hw, true);
 	}
 
+	if (!test_bit(WL1271_FLAG_RECOVERY_IN_PROGRESS, &wl->flags)) {
+		/* disable active roles */
+		ret = wl1271_ps_elp_wakeup(wl);
+		if (ret < 0) {
+			/*
+			 * do nothing. we are going to power off the chip
+			 * anyway. handle this case when we'll really
+			 * support multi-role...
+			 */
+		}
+		wl1271_cmd_role_disable(wl, &wl->role_id);
+
+		wl1271_ps_elp_sleep(wl);
+	}
+
+	wl->sta_hlid = WL1271_INVALID_LINK_ID;
+
 	/*
 	 * this must be before the cancel_work calls below, so that the work
 	 * functions don't perform further work.
 	 */
 	wl->state = WL1271_STATE_OFF;
 
-- 
1.7.6.401.g6a319

