Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bear.ext.ti.com ([192.94.94.41]:46568 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756190Ab1AKRZa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jan 2011 12:25:30 -0500
From: <coelho@ti.com>
To: <linux-wireless@vger.kernel.org>
CC: arik@wizery.com, johannes@sipsolutions.net,
	Luciano Coelho <coelho@ti.com>
Subject: [PATCH] wl12xx: don't modify the global supported band structures
Date: Tue, 11 Jan 2011 19:25:18 +0200
Message-ID: <1294766718-2472-1-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <coelho@ti.com>

When 11a is not supported, we were modifying the global structure that
contains the bands supported by the driver.  This causes problems when
having more one wl12xx device in the same system because they all use
the same global.  This also causes problems when the wl12xx_sdio
module is removed and the wl12xx module remains.

Fix this problem by copying the band structure into the wl12xx
instance.

Reported-by: Arik Nemtsov <arik@wizery.com>
Reported-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c   |   16 ++++++++++++++--
 drivers/net/wireless/wl12xx/wl12xx.h |    3 +++
 2 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 8a35491..862ec9c 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -3148,8 +3148,20 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	 */
 	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 			sizeof(struct ieee80211_header);
-	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
-	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
+
+	/*
+	 * We keep local copies of the band structs because we need to
+	 * modify them on a per-device basis.
+	 */
+	memcpy(&wl->bands[IEEE80211_BAND_2GHZ], &wl1271_band_2ghz,
+	       sizeof(wl1271_band_2ghz));
+	memcpy(&wl->bands[IEEE80211_BAND_5GHZ], &wl1271_band_5ghz,
+	       sizeof(wl1271_band_5ghz));
+
+	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] =
+		&wl->bands[IEEE80211_BAND_2GHZ];
+	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
+		&wl->bands[IEEE80211_BAND_5GHZ];
 
 	wl->hw->queues = 4;
 	wl->hw->max_rates = 1;
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 80e0e39..cf5c1a5 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -457,6 +457,9 @@ struct wl1271 {
 
 	/* recoreded keys for AP-mode - set here before AP startup */
 	struct wl1271_ap_key *recorded_ap_keys[MAX_NUM_KEYS];
+
+	/* bands supported by this instance of wl12xx */
+	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
 };
 
 struct wl1271_station {
-- 
1.7.1

