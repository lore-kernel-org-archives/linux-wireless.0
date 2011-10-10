Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41933 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752853Ab1JJINA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Oct 2011 04:13:00 -0400
Received: by mail-ey0-f174.google.com with SMTP id 27so1109073eye.19
        for <linux-wireless@vger.kernel.org>; Mon, 10 Oct 2011 01:12:59 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 14/29] wl12xx: make WL1271_FLAG_AP_STARTED flag per-vif
Date: Mon, 10 Oct 2011 10:13:02 +0200
Message-Id: <1318234397-21081-15-git-send-email-eliad@wizery.com> (sfid-20111010_101305_726195_3F1144C3)
In-Reply-To: <1318234397-21081-1-git-send-email-eliad@wizery.com>
References: <1318234397-21081-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This flag should be set per-vif, rather than globally.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |   14 +++++++-------
 drivers/net/wireless/wl12xx/tx.c     |    2 +-
 drivers/net/wireless/wl12xx/wl12xx.h |    2 +-
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 092b3b5..4c4b34d 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1235,7 +1235,7 @@ static void wl1271_recovery_work(struct work_struct *work)
 	 */
 	wl12xx_for_each_wlvif(wl, wlvif) {
 		if (test_bit(WLVIF_FLAG_STA_ASSOCIATED, &wlvif->flags) ||
-		    test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
+		    test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags))
 			wlvif->tx_security_seq +=
 				WL1271_TX_SQN_POST_RECOVERY_PADDING;
 	}
@@ -1662,7 +1662,7 @@ static int wl1271_configure_suspend_ap(struct wl1271 *wl,
 
 	mutex_lock(&wl->mutex);
 
-	if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
+	if (!test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags))
 		goto out_unlock;
 
 	ret = wl1271_ps_elp_wakeup(wl);
@@ -2758,7 +2758,7 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 			hlid = wlvif->ap.bcast_hlid;
 		}
 
-		if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+		if (!test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags)) {
 			/*
 			 * We do not support removing keys after AP shutdown.
 			 * Pretend we do to make mac80211 happy.
@@ -3416,7 +3416,7 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 
 	if ((changed & BSS_CHANGED_BEACON_ENABLED)) {
 		if (bss_conf->enable_beacon) {
-			if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+			if (!test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags)) {
 				ret = wl12xx_cmd_role_start_ap(wl, wlvif);
 				if (ret < 0)
 					goto out;
@@ -3425,16 +3425,16 @@ static void wl1271_bss_info_changed_ap(struct wl1271 *wl,
 				if (ret < 0)
 					goto out;
 
-				set_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
+				set_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags);
 				wl1271_debug(DEBUG_AP, "started AP");
 			}
 		} else {
-			if (test_bit(WL1271_FLAG_AP_STARTED, &wl->flags)) {
+			if (test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags)) {
 				ret = wl12xx_cmd_role_stop_ap(wl, wlvif);
 				if (ret < 0)
 					goto out;
 
-				clear_bit(WL1271_FLAG_AP_STARTED, &wl->flags);
+				clear_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags);
 				wl1271_debug(DEBUG_AP, "stopped AP");
 			}
 		}
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 5ad4173..a6bc979 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -168,7 +168,7 @@ u8 wl12xx_tx_get_hlid_ap(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 	} else {
 		struct ieee80211_hdr *hdr;
 
-		if (!test_bit(WL1271_FLAG_AP_STARTED, &wl->flags))
+		if (!test_bit(WLVIF_FLAG_AP_STARTED, &wlvif->flags))
 			return wl->system_hlid;
 
 		hdr = (struct ieee80211_hdr *)skb->data;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index aa198a6..042ab07 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -325,7 +325,6 @@ enum wl12xx_flags {
 	WL1271_FLAG_PSPOLL_FAILURE,
 	WL1271_FLAG_STA_STATE_SENT,
 	WL1271_FLAG_FW_TX_BUSY,
-	WL1271_FLAG_AP_STARTED,
 	WL1271_FLAG_IF_INITIALIZED,
 	WL1271_FLAG_DUMMY_PACKET_PENDING,
 	WL1271_FLAG_SUSPENDED,
@@ -339,6 +338,7 @@ enum wl12xx_flags {
 enum wl12xx_vif_flags {
 	WLVIF_FLAG_STA_ASSOCIATED,
 	WLVIF_FLAG_IBSS_JOINED,
+	WLVIF_FLAG_AP_STARTED,
 };
 
 struct wl1271_link {
-- 
1.7.6.401.g6a319

