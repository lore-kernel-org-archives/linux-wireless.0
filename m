Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.105.134]:16455 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756530AbZKBSWZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 13:22:25 -0500
From: Luciano Coelho <luciano.coelho@nokia.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH 1/6] wl1271: Remove excess null-data template settings
Date: Mon,  2 Nov 2009 20:22:08 +0200
Message-Id: <1257186133-18367-2-git-send-email-luciano.coelho@nokia.com>
In-Reply-To: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
References: <1257186133-18367-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The null-data template (nullfunc) is dependent on the BSSID of the
current AP only, so it needs to be updated only when the BSSID changes.

Removed excess setting of the template.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Reviewed-by: Luciano Coelho <luciano.coelho@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index 86132bb..0ae506a 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -1067,11 +1067,11 @@ static int wl1271_op_config_interface(struct ieee80211_hw *hw,
 		ret = wl1271_cmd_join(wl);
 		if (ret < 0)
 			goto out_sleep;
-	}
 
-	ret = wl1271_cmd_build_null_data(wl);
-	if (ret < 0)
-		goto out_sleep;
+		ret = wl1271_cmd_build_null_data(wl);
+		if (ret < 0)
+			goto out_sleep;
+	}
 
 	wl->ssid_len = conf->ssid_len;
 	if (wl->ssid_len)
@@ -1137,10 +1137,6 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 		wl->channel = channel;
 	}
 
-	ret = wl1271_cmd_build_null_data(wl);
-	if (ret < 0)
-		goto out_sleep;
-
 	if (conf->flags & IEEE80211_CONF_PS && !wl->psm_requested) {
 		wl1271_info("psm enabled");
 
@@ -1165,7 +1161,7 @@ static int wl1271_op_config(struct ieee80211_hw *hw, u32 changed)
 	if (conf->power_level != wl->power_level) {
 		ret = wl1271_acx_tx_power(wl, conf->power_level);
 		if (ret < 0)
-			goto out;
+			goto out_sleep;
 
 		wl->power_level = conf->power_level;
 	}
-- 
1.5.6.5

