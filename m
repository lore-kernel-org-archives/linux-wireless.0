Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42683 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757488Ab1CAUg6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Mar 2011 15:36:58 -0500
Received: by mail-wy0-f174.google.com with SMTP id 36so5089422wyg.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 Mar 2011 12:36:57 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: [RFC 7/9] wl12xx: save wl->wow_enabled on suspend
Date: Tue,  1 Mar 2011 22:36:42 +0200
Message-Id: <1299011804-13899-8-git-send-email-eliad@wizery.com>
In-Reply-To: <1299011804-13899-1-git-send-email-eliad@wizery.com>
References: <1299011804-13899-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

save the WoW parameters we got in the .stop callback, so we will be
able to consider them later (while suspending wl12xx_sdio/spi).

Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c   |    6 ++++--
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 3a7d788..a46022f 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1084,7 +1084,7 @@ static struct notifier_block wl1271_dev_notifier = {
 static int wl1271_op_start(struct ieee80211_hw *hw,
 			   struct cfg80211_wow *wow)
 {
-	wl1271_debug(DEBUG_MAC80211, "mac80211 start");
+	wl1271_debug(DEBUG_MAC80211, "mac80211 start resume=%d", !!wow);
 
 	/*
 	 * We have to delay the booting of the hardware because
@@ -1106,7 +1106,9 @@ static int wl1271_op_start(struct ieee80211_hw *hw,
 static void wl1271_op_stop(struct ieee80211_hw *hw,
 			   struct cfg80211_wow *wow)
 {
-	wl1271_debug(DEBUG_MAC80211, "mac80211 stop");
+	struct wl1271 *wl = hw->priv;
+	wl1271_debug(DEBUG_MAC80211, "mac80211 stop suspend=%d", !!wow);
+	wl->wow_enabled = !!(wow && wow->enabled_triggers);
 }
 
 static int wl1271_op_add_interface(struct ieee80211_hw *hw,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 338acc9..dd21818 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -521,6 +521,9 @@ struct wl1271 {
 	bool ba_support;
 	u8 ba_rx_bitmap;
 
+	/* tell sdio to stay awake (TODO: move to other place) */
+	bool wow_enabled;
+
 	/*
 	 * AP-mode - links indexed by HLID. The global and broadcast links
 	 * are always active.
-- 
1.7.0.4

