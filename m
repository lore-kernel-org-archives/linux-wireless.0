Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:45177 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752679AbaBJLsC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Feb 2014 06:48:02 -0500
Received: by mail-wg0-f47.google.com with SMTP id m15so4026325wgh.2
        for <linux-wireless@vger.kernel.org>; Mon, 10 Feb 2014 03:48:01 -0800 (PST)
From: Eliad Peller <eliad@wizery.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Subject: [PATCH 12/18] wlcore: wl18xx: allow CCK rates for AP mode
Date: Mon, 10 Feb 2014 13:47:28 +0200
Message-Id: <1392032854-28126-13-git-send-email-eliad@wizery.com> (sfid-20140210_130007_742021_F42A210F)
In-Reply-To: <1392032854-28126-1-git-send-email-eliad@wizery.com>
References: <1392032854-28126-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

12xx chips allow only OFDM rates in AP mode for BT-Coex purposes. This
is no longer required in 18xx chips, starting with FW 8.6.0.0.8.

Update the min allowed FW version in 18xx to support this functionality.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
Signed-off-by: Eliad Peller <eliad@wizery.com>
---
 drivers/net/wireless/ti/wl12xx/main.c   | 1 +
 drivers/net/wireless/ti/wlcore/init.c   | 2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h | 3 +++
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wl12xx/main.c b/drivers/net/wireless/ti/wl12xx/main.c
index 33071a7..d50dfac 100644
--- a/drivers/net/wireless/ti/wl12xx/main.c
+++ b/drivers/net/wireless/ti/wl12xx/main.c
@@ -1789,6 +1789,7 @@ static int wl12xx_setup(struct wl1271 *wl)
 	wl->fw_status_len = sizeof(struct wl12xx_fw_status);
 	wl->fw_status_priv_len = 0;
 	wl->stats.fw_stats_len = sizeof(struct wl12xx_acx_statistics);
+	wl->ofdm_only_ap = true;
 	wlcore_set_ht_cap(wl, IEEE80211_BAND_2GHZ, &wl12xx_ht_cap);
 	wlcore_set_ht_cap(wl, IEEE80211_BAND_5GHZ, &wl12xx_ht_cap);
 	wl12xx_conf_init(wl);
diff --git a/drivers/net/wireless/ti/wlcore/init.c b/drivers/net/wireless/ti/wlcore/init.c
index 7699f9d..b376c99 100644
--- a/drivers/net/wireless/ti/wlcore/init.c
+++ b/drivers/net/wireless/ti/wlcore/init.c
@@ -462,7 +462,7 @@ int wl1271_init_ap_rates(struct wl1271 *wl, struct wl12xx_vif *wlvif)
 	 * If the basic rates contain OFDM rates, use OFDM only
 	 * rates for unicast TX as well. Else use all supported rates.
 	 */
-	if ((wlvif->basic_rate_set & CONF_TX_OFDM_RATES))
+	if (wl->ofdm_only_ap && (wlvif->basic_rate_set & CONF_TX_OFDM_RATES))
 		supported_rates = CONF_TX_OFDM_RATES;
 	else
 		supported_rates = CONF_TX_ENABLED_RATES;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index a1cc1c6..95a5450 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -407,6 +407,9 @@ struct wl1271 {
 	/* AP-mode - number of currently connected stations */
 	int active_sta_count;
 
+	/* Flag determining whether AP should broadcast OFDM-only rates */
+	bool ofdm_only_ap;
+
 	/* last wlvif we transmitted from */
 	struct wl12xx_vif *last_wlvif;
 
-- 
1.8.5.2.229.g4448466.dirty

