Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33147 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CRK1m (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:42 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 18/21] wl1271: Update filters properly
Date: Thu, 18 Mar 2010 12:26:43 +0200
Message-Id: <1268908006-16992-19-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch adds support for the filters configured by the mac80211 stack.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Teemu Paasikivi <ext-teemu.3.paasikivi@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |    2 +
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |    9 ----
 drivers/net/wireless/wl12xx/wl1271_main.c |   58 ++++++++++++++++++++++++----
 3 files changed, 51 insertions(+), 18 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 4e60806..a0262b7 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -54,6 +54,7 @@ enum {
 	DEBUG_CMD	= BIT(12),
 	DEBUG_ACX	= BIT(13),
 	DEBUG_SDIO	= BIT(14),
+	DEBUG_FILTERS   = BIT(15),
 	DEBUG_ALL	= ~0,
 };
 
@@ -458,6 +459,7 @@ struct wl1271 {
 	/* Default key (for WEP) */
 	u32 default_key;
 
+	unsigned int filters;
 	unsigned int rx_config;
 	unsigned int rx_filter;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index 0cbb0e1..035ddc0 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -281,15 +281,6 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type)
 	join->rx_filter_options = cpu_to_le32(wl->rx_filter);
 	join->bss_type = bss_type;
 
-	/*
-	 * FIXME: disable temporarily all filters because after commit
-	 * 9cef8737 "mac80211: fix managed mode BSSID handling" broke
-	 * association. The filter logic needs to be implemented properly
-	 * and once that is done, this hack can be removed.
-	 */
-	join->rx_config_options = cpu_to_le32(0);
-	join->rx_filter_options = cpu_to_le32(WL1271_DEFAULT_RX_FILTER);
-
 	if (wl->band == IEEE80211_BAND_2GHZ)
 		join->basic_rate_set = cpu_to_le32(CONF_HW_BIT_RATE_1MBPS   |
 						   CONF_HW_BIT_RATE_2MBPS   |
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 688009b..befc2e9 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1080,6 +1080,7 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	wl->sta_rate_set = 0;
 	wl->flags = 0;
 	wl->vif = NULL;
+	wl->filters = 0;
 
 	for (i = 0; i < NUM_TX_QUEUES; i++)
 		wl->tx_blocks_freed[i] = 0;
@@ -1088,6 +1089,40 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&wl->mutex);
 }
 
+static void wl1271_configure_filters(struct wl1271 *wl, unsigned int filters)
+{
+	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
+	wl->rx_filter = WL1271_DEFAULT_RX_FILTER;
+
+	/* combine requested filters with current filter config */
+	filters = wl->filters | filters;
+
+	wl1271_debug(DEBUG_FILTERS, "RX filters set: ");
+
+	if (filters & FIF_PROMISC_IN_BSS) {
+		wl1271_debug(DEBUG_FILTERS, " - FIF_PROMISC_IN_BSS");
+		wl->rx_config &= ~CFG_UNI_FILTER_EN;
+		wl->rx_config |= CFG_BSSID_FILTER_EN;
+	}
+	if (filters & FIF_BCN_PRBRESP_PROMISC) {
+		wl1271_debug(DEBUG_FILTERS, " - FIF_BCN_PRBRESP_PROMISC");
+		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
+		wl->rx_config &= ~CFG_SSID_FILTER_EN;
+	}
+	if (filters & FIF_OTHER_BSS) {
+		wl1271_debug(DEBUG_FILTERS, " - FIF_OTHER_BSS");
+		wl->rx_config &= ~CFG_BSSID_FILTER_EN;
+	}
+	if (filters & FIF_CONTROL) {
+		wl1271_debug(DEBUG_FILTERS, " - FIF_CONTROL");
+		wl->rx_filter |= CFG_RX_CTL_EN;
+	}
+	if (filters & FIF_FCSFAIL) {
+		wl1271_debug(DEBUG_FILTERS, " - FIF_FCSFAIL");
+		wl->rx_filter |= CFG_RX_FCS_ERROR;
+	}
+}
+
 static int wl1271_join_channel(struct wl1271 *wl, int channel)
 {
 	int ret = 0;
@@ -1095,12 +1130,12 @@ static int wl1271_join_channel(struct wl1271 *wl, int channel)
 	static const u8 dummy_bssid[ETH_ALEN] = { 0x0b, 0xad, 0xde,
 						  0xad, 0xbe, 0xef };
 
-	/* disable mac filter, so we hear everything */
-	wl->rx_config &= ~CFG_BSSID_FILTER_EN;
-
 	wl->channel = channel;
 	memcpy(wl->bssid, dummy_bssid, ETH_ALEN);
 
+	/* pass through frames from all BSS */
+	wl1271_configure_filters(wl, FIF_OTHER_BSS);
+
 	/* the dummy join is performed always with STATION BSS type to allow
 	   also ad-hoc mode to listen to the surroundings without sending any
 	   beacons yet. */
@@ -1126,7 +1161,9 @@ static int wl1271_unjoin_channel(struct wl1271 *wl)
 	clear_bit(WL1271_FLAG_JOINED, &wl->flags);
 	wl->channel = 0;
 	memset(wl->bssid, 0, ETH_ALEN);
-	wl->rx_config = WL1271_DEFAULT_RX_CONFIG;
+
+	/* stop filterting packets based on bssid */
+	wl1271_configure_filters(wl, FIF_OTHER_BSS);
 
 out:
 	return ret;
@@ -1299,14 +1336,14 @@ static void wl1271_op_configure_filter(struct ieee80211_hw *hw,
 	if (ret < 0)
 		goto out_sleep;
 
-	kfree(fp);
-
-	/* FIXME: We still need to set our filters properly */
-
 	/* determine, whether supported filter values have changed */
 	if (changed == 0)
 		goto out_sleep;
 
+	/* configure filters */
+	wl->filters = *total;
+	wl1271_configure_filters(wl, 0);
+
 	/* apply configured filters */
 	ret = wl1271_acx_rx_config(wl, wl->rx_config, wl->rx_filter);
 	if (ret < 0)
@@ -1317,6 +1354,7 @@ out_sleep:
 
 out:
 	mutex_unlock(&wl->mutex);
+	kfree(fp);
 }
 
 static int wl1271_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
@@ -1580,7 +1618,6 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	     * and enable the BSSID filter
 	     */
 	    memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
-			wl->rx_config |= CFG_BSSID_FILTER_EN;
 			memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
 			ret = wl1271_cmd_build_null_data(wl);
 			if (ret < 0) {
@@ -1589,6 +1626,9 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				goto out_sleep;
 			}
 
+			/* filter out all packets not from this BSSID */
+			wl1271_configure_filters(wl, 0);
+
 			/* Need to update the BSSID (for filtering etc) */
 			do_join = true;
 	}
-- 
1.6.3.3

