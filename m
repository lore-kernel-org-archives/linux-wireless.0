Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16937 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932863Ab0I0Iid (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Sep 2010 04:38:33 -0400
Received: from esebh105.NOE.Nokia.com (esebh105.ntc.nokia.com [172.21.138.211])
	by mgw-mx09.nokia.com (Switch-3.3.3/Switch-3.3.3) with ESMTP id o8R8c5Ea024679
	for <linux-wireless@vger.kernel.org>; Mon, 27 Sep 2010 03:38:33 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linux-wireless@vger.kernel.org
Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 15/25] wl1271: Enable 11a support always, prevent scanning for unsupporting chips
Date: Mon, 27 Sep 2010 11:37:39 +0300
Message-Id: <1285576669-8070-16-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
References: <1285576669-8070-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

This patch always enables 11a band towards the mac80211, but prevents scanning
(and hence the usage of) 11a band channels if the chipset does not support it.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_init.c |   15 +++++++--------
 drivers/net/wireless/wl12xx/wl1271_main.c |    4 +---
 2 files changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_init.c b/drivers/net/wireless/wl12xx/wl1271_init.c
index 879bae0..5614a35 100644
--- a/drivers/net/wireless/wl12xx/wl1271_init.c
+++ b/drivers/net/wireless/wl12xx/wl1271_init.c
@@ -53,6 +53,7 @@ static int wl1271_init_hwenc_config(struct wl1271 *wl)
 int wl1271_init_templates_config(struct wl1271 *wl)
 {
 	int ret, i;
+	size_t size;
 
 	/* send empty templates for fw memory reservation */
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_2_4, NULL,
@@ -61,14 +62,12 @@ int wl1271_init_templates_config(struct wl1271 *wl)
 	if (ret < 0)
 		return ret;
 
-	if (wl->enable_11a) {
-		size_t size = sizeof(struct wl12xx_probe_req_template);
-		ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
-					      NULL, size, 0,
-					      WL1271_RATE_AUTOMATIC);
-		if (ret < 0)
-			return ret;
-	}
+	size = sizeof(struct wl12xx_probe_req_template);
+	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_CFG_PROBE_REQ_5,
+				      NULL, size, 0,
+				      WL1271_RATE_AUTOMATIC);
+	if (ret < 0)
+		return ret;
 
 	ret = wl1271_cmd_template_set(wl, CMD_TEMPL_NULL_DATA, NULL,
 				      sizeof(struct wl12xx_null_data_template),
diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 81f92a0..f0c2532 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -2403,9 +2403,7 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 		BIT(NL80211_IFTYPE_ADHOC);
 	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
-
-	if (wl->enable_11a)
-		wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
+	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
 
 	wl->hw->queues = 4;
 	wl->hw->max_rates = 1;
-- 
1.6.3.3

