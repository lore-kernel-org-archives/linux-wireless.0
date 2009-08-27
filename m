Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:50867 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752874AbZH0VAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Aug 2009 17:00:33 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, juuso.oikarinen@nokia.com,
	kalle.valo@nokia.com
Subject: [PATCH 09/13] wl1271: Update join usage
Date: Fri, 28 Aug 2009 00:00:03 +0300
Message-Id: <1251406807-31495-10-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
References: <1251406807-31495-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

Update the usage of join's, including using actual beacon interval and
dtim from AP, and configuring a basic rate set from AP.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271.h      |   12 ++++++++
 drivers/net/wireless/wl12xx/wl1271_cmd.c  |   15 +++-------
 drivers/net/wireless/wl12xx/wl1271_cmd.h  |    3 +-
 drivers/net/wireless/wl12xx/wl1271_main.c |   42 ++++++++++++++++++++++-------
 4 files changed, 50 insertions(+), 22 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271.h b/drivers/net/wireless/wl12xx/wl1271.h
index 671dc5a..05eb29c 100644
--- a/drivers/net/wireless/wl12xx/wl1271.h
+++ b/drivers/net/wireless/wl12xx/wl1271.h
@@ -104,6 +104,8 @@ enum {
 				  CFG_RX_CTL_EN | CFG_RX_BCN_EN |     \
 				  CFG_RX_AUTH_EN | CFG_RX_ASSOC_EN)
 
+#define WL1271_DEFAULT_BASIC_RATE_SET (ACX_RATE_MASK_ALL)
+
 #define WL1271_FW_NAME "wl1271-fw.bin"
 #define WL1271_NVS_NAME "wl1271-nvs.bin"
 
@@ -118,6 +120,9 @@ enum {
 #define WL1271_ELP_HW_STATE_ASLEEP 0
 #define WL1271_ELP_HW_STATE_IRQ    1
 
+#define WL1271_DEFAULT_BEACON_INT  100
+#define WL1271_DEFAULT_DTIM_PERIOD 1
+
 enum wl1271_state {
 	WL1271_STATE_OFF,
 	WL1271_STATE_ON,
@@ -369,6 +374,13 @@ struct wl1271 {
 	/* Our association ID */
 	u16 aid;
 
+	/* Beacon parameters */
+	u16 beacon_int;
+	u8 dtim_period;
+
+	/* currently configured rate set */
+	u32 basic_rate_set;
+
 	/* The current band */
 	enum ieee80211_band band;
 
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.c b/drivers/net/wireless/wl12xx/wl1271_cmd.c
index bd65b38..35a6e67 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.c
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.c
@@ -175,11 +175,9 @@ int wl1271_cmd_cal(struct wl1271 *wl)
 	return ret;
 }
 
-int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type, u8 dtim_interval,
-		    u16 beacon_interval, u8 wait)
+int wl1271_cmd_join(struct wl1271 *wl)
 {
 	static bool do_cal = true;
-	unsigned long timeout;
 	struct wl1271_cmd_join *join;
 	int ret, i;
 	u8 *bssid;
@@ -213,9 +211,9 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type, u8 dtim_interval,
 	join->basic_rate_set = RATE_MASK_1MBPS | RATE_MASK_2MBPS |
 		RATE_MASK_5_5MBPS | RATE_MASK_11MBPS;
 
-	join->beacon_interval = beacon_interval;
-	join->dtim_interval = dtim_interval;
-	join->bss_type = bss_type;
+	join->beacon_interval = wl->beacon_int;
+	join->dtim_interval = wl->dtim_period;
+	join->bss_type = wl->bss_type;
 	join->channel = wl->channel;
 	join->ssid_len = wl->ssid_len;
 	memcpy(join->ssid, wl->ssid, wl->ssid_len);
@@ -239,14 +237,11 @@ int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type, u8 dtim_interval,
 		goto out_free;
 	}
 
-	timeout = msecs_to_jiffies(JOIN_TIMEOUT);
-
 	/*
 	 * ugly hack: we should wait for JOIN_EVENT_COMPLETE_ID but to
 	 * simplify locking we just sleep instead, for now
 	 */
-	if (wait)
-		msleep(10);
+	msleep(10);
 
 out_free:
 	kfree(join);
diff --git a/drivers/net/wireless/wl12xx/wl1271_cmd.h b/drivers/net/wireless/wl12xx/wl1271_cmd.h
index 7c4d3aa..63bc441 100644
--- a/drivers/net/wireless/wl12xx/wl1271_cmd.h
+++ b/drivers/net/wireless/wl12xx/wl1271_cmd.h
@@ -30,8 +30,7 @@
 struct acx_header;
 
 int wl1271_cmd_send(struct wl1271 *wl, u16 type, void *buf, size_t buf_len);
-int wl1271_cmd_join(struct wl1271 *wl, u8 bss_type, u8 dtim_interval,
-		    u16 beacon_interval, u8 wait);
+int wl1271_cmd_join(struct wl1271 *wl);
 int wl1271_cmd_test(struct wl1271 *wl, void *buf, size_t buf_len, u8 answer);
 int wl1271_cmd_interrogate(struct wl1271 *wl, u16 id, void *buf, size_t len);
 int wl1271_cmd_configure(struct wl1271 *wl, u16 id, void *buf, size_t len);
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 0f5958d..f5e757d 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -394,8 +394,7 @@ static void wl1271_filter_work(struct work_struct *work)
 	if (ret < 0)
 		goto out;
 
-	/* FIXME: replace the magic numbers with proper definitions */
-	ret = wl1271_cmd_join(wl, wl->bss_type, 1, 100, 0);
+	ret = wl1271_cmd_join(wl);
 	if (ret < 0)
 		goto out_sleep;
 
@@ -673,8 +672,7 @@ static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 		memcpy(wl->ssid, conf->ssid, wl->ssid_len);
 
 	if (wl->bss_type != BSS_TYPE_IBSS) {
-		/* FIXME: replace the magic numbers with proper definitions */
-		ret = wl1271_cmd_join(wl, wl->bss_type, 5, 100, 1);
+		ret = wl1271_cmd_join(wl);
 		if (ret < 0)
 			goto out_sleep;
 	}
@@ -697,8 +695,7 @@ static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 		if (ret < 0)
 			goto out_sleep;
 
-		/* FIXME: replace the magic numbers with proper definitions */
-		ret = wl1271_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl1271_cmd_join(wl);
 
 		if (ret < 0)
 			goto out_sleep;
@@ -739,8 +736,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		u8 old_channel = wl->channel;
 		wl->channel = channel;
 
-		/* FIXME: use beacon interval provided by mac80211 */
-		ret = wl1271_cmd_join(wl, wl->bss_type, 1, 100, 0);
+		ret = wl1271_cmd_join(wl);
 		if (ret < 0) {
 			wl->channel = old_channel;
 			goto out_sleep;
@@ -1017,8 +1013,17 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 
 	if (changed & BSS_CHANGED_ASSOC) {
 		if (bss_conf->assoc) {
+			wl->beacon_int = bss_conf->beacon_int;
+			wl->dtim_period = bss_conf->dtim_period;
 			wl->aid = bss_conf->aid;
 
+			ret = wl1271_cmd_join(wl);
+			if (ret < 0) {
+				wl1271_warning("Association configuration "
+					       "failed %d", ret);
+				goto out_sleep;
+			}
+
 			ret = wl1271_cmd_build_ps_poll(wl, wl->aid);
 			if (ret < 0)
 				goto out_sleep;
@@ -1034,7 +1039,14 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 				if (ret < 0)
 					goto out_sleep;
 			}
+		} else {
+			/* use defaults when not associated */
+			wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
+			wl->dtim_period = WL1271_DEFAULT_DTIM_PERIOD;
+			wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
+			wl->aid = 0;
 		}
+
 	}
 
 	if (changed & BSS_CHANGED_ERP_SLOT) {
@@ -1067,13 +1079,20 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
 	}
 
 	if (changed & BSS_CHANGED_BASIC_RATES) {
-		u32 enabled_rates = wl1271_enabled_rates_get(
+		wl->basic_rate_set = wl1271_enabled_rates_get(
 			wl, bss_conf->basic_rates);
-		ret = wl1271_acx_rate_policies(wl, enabled_rates);
+		ret = wl1271_acx_rate_policies(wl, wl->basic_rate_set);
+
 		if (ret < 0) {
 			wl1271_warning("Set rate policies failed %d", ret);
 			goto out_sleep;
 		}
+		ret = wl1271_cmd_join(wl);
+		if (ret < 0) {
+			wl1271_warning("Join with new basic rate "
+				       "set failed %d", ret);
+			goto out_sleep;
+		}
 	}
 
 out_sleep:
@@ -1270,6 +1289,9 @@ static int __devinit wl1271_probe(struct spi_device *spi)
 	wl->psm_requested = false;
 	wl->tx_queue_stopped = false;
 	wl->power_level = WL1271_DEFAULT_POWER_LEVEL;
+	wl->beacon_int = WL1271_DEFAULT_BEACON_INT;
+	wl->dtim_period = WL1271_DEFAULT_DTIM_PERIOD;
+	wl->basic_rate_set = WL1271_DEFAULT_BASIC_RATE_SET;
 	wl->band = IEEE80211_BAND_2GHZ;
 
 	/* We use the default power on sleep time until we know which chip
-- 
1.5.6.5

