Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:30723 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540Ab0CZKyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 06:54:21 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 16/24] wl1271: Update beacon interval properly for ad-hoc
Date: Fri, 26 Mar 2010 12:53:25 +0200
Message-Id: <1269600813-32145-17-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
References: <1269600813-32145-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Configure the hardware beacon interval to whatever requested by the
mac80211.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    3 +++
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    2 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   10 ++++++++++
 3 files changed, 14 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 37ad5cd..c5559ef 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -452,6 +452,9 @@ struct wl1271 {
 	/* The current band */
 	enum ieee80211_band band;
 
+	/* Beaconing interval (needed for ad-hoc) */
+	u32 beacon_int;
+
 	/* Default key (for WEP) */
 	u32 default_key;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 0aa2422..0dcb3c2 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -323,7 +323,7 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 						   CONF_HW_BIT_RATE_24MBPS);
 	}
 
-	join->beacon_interval = cpu_to_le16(WL1271_DEFAULT_BEACON_INT);
+	join->beacon_interval = cpu_to_le16(wl->beacon_int);
 	join->dtim_interval = WL1271_DEFAULT_DTIM_PERIOD;
 
 	join->channel = wl->channel;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 49f37b0..523e051 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1575,6 +1575,15 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
+	if ((changed && BSS_CHANGED_BEACON_INT) &&
+	    (wl->bss_type == BSS_TYPE_IBSS)) {
+		wl1271_debug(DEBUG_ADHOC, "ad-hoc beacon interval updated: %d",
+			bss_conf->beacon_int);
+
+		wl->beacon_int = bss_conf->beacon_int;
+		do_join = true;
+	}
+
 	if ((changed && BSS_CHANGED_BEACON) &&
 	    (wl->bss_type == BSS_TYPE_IBSS)) {
 		struct sk_buff *beacon = ieee80211_beacon_get(hw, vif);
@@ -2193,6 +2202,7 @@ struct ieee80211_hw *wl1271_alloc_hw(void)
 
 	INIT_DELAYED_WORK(&wl->elp_work, wl1271_elp_work);
 	wl->channel = WL1271_DEFAULT_CHANNEL;
+	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
 	wl->default_key = 0;
 	wl->rx_counter = 0;
 	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
-- 
1.6.3.3

