Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.233]:33065 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752362Ab0CRK1V (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Mar 2010 06:27:21 -0400
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 15/21] wl1271: Remove deprecated interface config function
Date: Thu, 18 Mar 2010 12:26:40 +0200
Message-Id: <1268908006-16992-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
References: <1268908006-16992-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

It's no longer needed.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Kalle Valo <kalle.valo@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   68 -----------------------------
 1 files changed, 0 insertions(+), 68 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index d8cb514..688009b 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1088,73 +1088,6 @@ static void wl1271_op_remove_interface(struct ieee80211_hw *hw,
 	mutex_unlock(&wl->mutex);
 }
 
-#if 0
-static int wl1271_op_config_interface(struct ieee80211_hw *hw,
-				      struct ieee80211_vif *vif,
-				      struct ieee80211_if_conf *conf)
-{
-	struct wl1271 *wl = hw->priv;
-	struct sk_buff *beacon;
-	int ret;
-
-	wl1271_debug(DEBUG_MAC80211, "mac80211 config_interface bssid %pM",
-		     conf->bssid);
-	wl1271_dump_ascii(DEBUG_MAC80211, "ssid: ", conf->ssid,
-			  conf->ssid_len);
-
-	mutex_lock(&wl->mutex);
-
-	ret = wl1271_ps_elp_wakeup(wl, false);
-	if (ret < 0)
-		goto out;
-
-	if (memcmp(wl->bssid, conf->bssid, ETH_ALEN)) {
-		wl1271_debug(DEBUG_MAC80211, "bssid changed");
-
-		memcpy(wl->bssid, conf->bssid, ETH_ALEN);
-
-		ret = wl1271_cmd_join(wl, wl->bss_type);
-		if (ret < 0)
-			goto out_sleep;
-
-		ret = wl1271_cmd_build_null_data(wl);
-		if (ret < 0)
-			goto out_sleep;
-	}
-
-	wl->ssid_len = conf->ssid_len;
-	if (wl->ssid_len)
-		memcpy(wl->ssid, conf->ssid, wl->ssid_len);
-
-	if (conf->changed & IEEE80211_IFCC_BEACON) {
-		beacon = ieee80211_beacon_get(hw, vif);
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_BEACON,
-					      beacon->data, beacon->len);
-
-		if (ret < 0) {
-			dev_kfree_skb(beacon);
-			goto out_sleep;
-		}
-
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_PROBE_RESPONSE,
-					      beacon->data, beacon->len);
-
-		dev_kfree_skb(beacon);
-
-		if (ret < 0)
-			goto out_sleep;
-	}
-
-out_sleep:
-	wl1271_ps_elp_sleep(wl);
-
-out:
-	mutex_unlock(&wl->mutex);
-
-	return ret;
-}
-#endif
-
 static int wl1271_join_channel(struct wl1271 *wl, int channel)
 {
 	int ret = 0;
@@ -1940,7 +1873,6 @@ static const struct ieee80211_ops wl1271_ops = {
 	.add_interface = wl1271_op_add_interface,
 	.remove_interface = wl1271_op_remove_interface,
 	.config = wl1271_op_config,
-/* 	.config_interface = wl1271_op_config_interface, */
 	.prepare_multicast = wl1271_op_prepare_multicast,
 	.configure_filter = wl1271_op_configure_filter,
 	.tx = wl1271_op_tx,
-- 
1.6.3.3

