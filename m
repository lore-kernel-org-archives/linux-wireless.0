Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:49460 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756175AbZJLMNr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Oct 2009 08:13:47 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 16/16] wl1271: remove unnecessary joins and join only when the bssid changes
Date: Mon, 12 Oct 2009 15:08:57 +0300
Message-Id: <1255349337-9776-17-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
References: <1255349337-9776-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were using the join command to change some settings when the stack asked
us to do it.  In many cases they were not needed (and could cause potential
problems), so they were removed.  In other cases there are ACX commands that
can be used instead of using join to reconfigure.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
Reviewed-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    4 --
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    4 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   61 ++++++++++------------------
 3 files changed, 24 insertions(+), 45 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index b2bc7b5..aa9bb2e 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -378,10 +378,6 @@ struct wl1271 {
 	/* Our association ID */
 	u16 aid;
 
-	/* Beacon parameters */
-	u16 beacon_int;
-	u8 dtim_period;
-
 	/* currently configured rate set */
 	u32 basic_rate_set;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index f727744..eaa1de9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -232,8 +232,8 @@ int wl1271_cmd_join(struct wl1271 *wl)
 	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
 		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
 
-	join->beacon_interval = wl->beacon_int;
-	join->dtim_interval = wl->dtim_period;
+	join->beacon_interval = WL1271_DEFAULT_BEACON_INT;
+	join->dtim_interval = WL1271_DEFAULT_DTIM_PERIOD;
 	join->bss_type = wl->bss_type;
 	join->channel = wl->channel;
 	join->ssid_len = wl->ssid_len;
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index fc0d03f..821a775 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -710,7 +710,15 @@ static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out;
 
-	memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+	if (memcmp(wl->bssid, conf->bssid, ETH_ALEN)) {
+		wl1271_debug(DEBUG_MAC80211, "bssid changed");
+
+		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
+
+		ret = wl1271_cmd_join(wl);
+		if (ret < 0)
+			goto out_sleep;
+	}
 
 	ret = wl1271_cmd_build_null_data(wl);
 	if (ret < 0)
@@ -720,12 +728,6 @@ static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 	if (wl->ssid_len)
 		memcpy(wl->ssid, conf->ssid, wl->ssid_len);
 
-	if (wl->bss_type != BSS_TYPE_IBSS) {
-		ret = wl1271_cmd_join(wl);
-		if (ret < 0)
-			goto out_sleep;
-	}
-
 	if (conf->changed & IEEE80211_IFCC_BEACON) {
 		beacon = ieee80211_beacon_get(hw, vif);
 		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
@@ -743,11 +745,6 @@ static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 
 		if (ret < 0)
 			goto out_sleep;
-
-		ret = wl1271_cmd_join(wl);
-
-		if (ret < 0)
-			goto out_sleep;
 	}
 
 out_sleep:
@@ -782,14 +779,13 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		goto out;
 
 	if (channel != wl->channel) {
-		u8 old_channel = wl->channel;
+		/*
+		 * We assume that the stack will configure the right channel
+		 * before associating, so we don't need to send a join
+		 * command here.  We will join the right channel when the
+		 * BSSID changes
+		 */
 		wl->channel = channel;
-
-		ret = wl1271_cmd_join(wl);
-		if (ret < 0) {
-			wl->channel = old_channel;
-			goto out_sleep;
-		}
 	}
 
 	ret = wl1271_cmd_build_null_data(wl);
@@ -1102,17 +1098,14 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
-			wl->beacon_int = bss_conf->beacon_int;
-			wl->dtim_period = bss_conf->dtim_period;
 			wl->aid = bss_conf->aid;
 
-			ret = wl1271_cmd_join(wl);
-			if (ret < 0) {
-				wl1271_warning("Association configuration "
-					       "failed %d", ret);
-				goto out_sleep;
-			}
-
+			/*
+			 * with wl1271, we don't need to update the
+			 * beacon_int and dtim_period, because the firmware
+			 * updates it by itself when the first beacon is
+			 * received after a join.
+			 */
 			ret = wl1271_cmd_build_ps_poll(wl, wl->aid);
 			if (ret < 0)
 				goto out_sleep;
@@ -1130,8 +1123,6 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 			}
 		} else {
 			/* use defaults when not associated */
-			wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
-			wl->dtim_period = WL1271_DEFAULT_DTIM_PERIOD;
 			wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 			wl->aid = 0;
 		}
@@ -1170,18 +1161,12 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	if (changed & BSS_CHANGED_BASIC_RATES) {
 		wl->basic_rate_set = wl1271_enabled_rates_get(
 			wl, bss_conf->basic_rates);
-		ret = wl1271_acx_rate_policies(wl, wl->basic_rate_set);
 
+		ret = wl1271_acx_rate_policies(wl, wl->basic_rate_set);
 		if (ret < 0) {
 			wl1271_warning("Set rate policies failed %d", ret);
 			goto out_sleep;
 		}
-		ret = wl1271_cmd_join(wl);
-		if (ret < 0) {
-			wl1271_warning("Join with new basic rate "
-				       "set failed %d", ret);
-			goto out_sleep;
-		}
 	}
 
 out_sleep:
@@ -1380,8 +1365,6 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->psm_requested = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
-	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
-	wl->dtim_period = WL1271_DEFAULT_DTIM_PERIOD;
 	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 	wl->band = IEEE80211_BAND_2GHZ;
 	wl->vif = NULL;
-- 
1.5.6.5

