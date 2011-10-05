Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35975 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934298Ab1JEJ4U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 05:56:20 -0400
Received: by mail-ey0-f174.google.com with SMTP id 28so1405752eya.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 02:56:20 -0700 (PDT)
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 22/29] wl12xx: move default_key into wlvif
Date: Wed,  5 Oct 2011 11:55:59 +0200
Message-Id: <1317808566-18857-23-git-send-email-eliad@wizery.com> (sfid-20111005_115626_751288_9421956C)
In-Reply-To: <1317808566-18857-1-git-send-email-eliad@wizery.com>
References: <1317808566-18857-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

move default_key into the per-interface data, rather than
being global.

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    7 +++----
 drivers/net/wireless/wl12xx/tx.c     |    4 ++--
 drivers/net/wireless/wl12xx/wl12xx.h |    6 +++---
 3 files changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 54c146a..9302c88 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2699,7 +2699,7 @@ static int wl1271_ap_init_hwenc(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	}
 
 	if (wep_key_added) {
-		ret = wl12xx_cmd_set_default_wep_key(wl, wl->default_key,
+		ret = wl12xx_cmd_set_default_wep_key(wl, wlvif->default_key,
 						     wlvif->ap.bcast_hlid);
 		if (ret < 0)
 			goto out;
@@ -2796,8 +2796,8 @@ static int wl1271_set_key(struct wl1271 *wl, struct wl12xx_vif *wlvif,
 		/* the default WEP key needs to be configured at least once */
 		if (key_type == KEY_WEP) {
 			ret = wl12xx_cmd_set_default_wep_key(wl,
-							     wl->default_key,
-							     wlvif->sta.hlid);
+							wlvif->default_key,
+							wlvif->sta.hlid);
 			if (ret < 0)
 				return ret;
 		}
@@ -4850,7 +4850,6 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 	}
 
 	wl->channel = WL1271_DEFAULT_CHANNEL;
-	wl->default_key = 0;
 	wl->rx_counter = 0;
 	wl->psm_entry_retry = 0;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
diff --git a/drivers/net/wireless/wl12xx/tx.c b/drivers/net/wireless/wl12xx/tx.c
index 8db68c6..509ae10 100644
--- a/drivers/net/wireless/wl12xx/tx.c
+++ b/drivers/net/wireless/wl12xx/tx.c
@@ -424,11 +424,11 @@ static int wl1271_prepare_tx_frame(struct wl1271 *wl, struct sk_buff *skb,
 		is_wep = (cipher == WLAN_CIPHER_SUITE_WEP40) ||
 			 (cipher == WLAN_CIPHER_SUITE_WEP104);
 
-		if (unlikely(is_wep && wl->default_key != idx)) {
+		if (unlikely(is_wep && wlvif->default_key != idx)) {
 			ret = wl1271_set_default_wep_key(wl, wlvif, idx);
 			if (ret < 0)
 				return ret;
-			wl->default_key = idx;
+			wlvif->default_key = idx;
 		}
 	}
 	hlid = wl1271_tx_get_hlid(wl, vif, skb);
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 3646410..4755aad 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -502,9 +502,6 @@ struct wl1271 {
 	/* The current band */
 	enum ieee80211_band band;
 
-	/* Default key (for WEP) */
-	u32 default_key;
-
 	/* Rx Streaming */
 	struct work_struct rx_streaming_enable_work;
 	struct work_struct rx_streaming_disable_work;
@@ -644,6 +641,9 @@ struct wl12xx_vif {
 	/* Beaconing interval (needed for ad-hoc) */
 	u32 beacon_int;
 
+	/* Default key (for WEP) */
+	u32 default_key;
+
 	/* Our association ID */
 	u16 aid;
 
-- 
1.7.6.401.g6a319

