Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:34342 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751238Ab2GHHXr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 8 Jul 2012 03:23:47 -0400
Received: by lbbgj10 with SMTP id gj10so4634185lbb.23
        for <linux-wireless@vger.kernel.org>; Sun, 08 Jul 2012 00:23:44 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Cc: coelho@ti.com, arik@wizery.com
Subject: [PATCH 4/8] wlcore: define number of supported bands internally
Date: Sun,  8 Jul 2012 10:23:27 +0300
Message-Id: <1341732211-25871-5-git-send-email-coelho@ti.com> (sfid-20120708_092353_785084_55E59D0E)
In-Reply-To: <1341732211-25871-1-git-send-email-coelho@ti.com>
References: <1341732211-25871-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arik Nemtsov <arik@wizery.com>

Avoid using the IEEE80211_NUM_BANDS constant for arrays sizes etc, as
this can contain bands unsupported by the driver (e.g. 60Ghz). Use an
internal constant to determine the number of bands.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/ti/wlcore/main.c     |    2 +-
 drivers/net/wireless/ti/wlcore/wlcore.h   |    4 ++--
 drivers/net/wireless/ti/wlcore/wlcore_i.h |    5 ++++-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 5632194..1aecc46 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -4569,7 +4569,7 @@ static int wl12xx_set_bitrate_mask(struct ieee80211_hw *hw,
 
 	mutex_lock(&wl->mutex);
 
-	for (i = 0; i < IEEE80211_NUM_BANDS; i++)
+	for (i = 0; i < WLCORE_NUM_BANDS; i++)
 		wlvif->bitrate_masks[i] =
 			wl1271_tx_enabled_rates_get(wl,
 						    mask->control[i].legacy,
diff --git a/drivers/net/wireless/ti/wlcore/wlcore.h b/drivers/net/wireless/ti/wlcore/wlcore.h
index 0df731a..27ccc27 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore.h
@@ -304,7 +304,7 @@ struct wl1271 {
 	s8 noise;
 
 	/* bands supported by this instance of wl12xx */
-	struct ieee80211_supported_band bands[IEEE80211_NUM_BANDS];
+	struct ieee80211_supported_band bands[WLCORE_NUM_BANDS];
 
 	/*
 	 * wowlan trigger was configured during suspend.
@@ -371,7 +371,7 @@ struct wl1271 {
 	u8 hw_min_ht_rate;
 
 	/* HW HT (11n) capabilities */
-	struct ieee80211_sta_ht_cap ht_cap[IEEE80211_NUM_BANDS];
+	struct ieee80211_sta_ht_cap ht_cap[WLCORE_NUM_BANDS];
 
 	/* size of the private FW status data */
 	size_t fw_status_priv_len;
diff --git a/drivers/net/wireless/ti/wlcore/wlcore_i.h b/drivers/net/wireless/ti/wlcore/wlcore_i.h
index 2a0e896..0187eef 100644
--- a/drivers/net/wireless/ti/wlcore/wlcore_i.h
+++ b/drivers/net/wireless/ti/wlcore/wlcore_i.h
@@ -62,6 +62,9 @@
 #define WL12XX_INVALID_ROLE_ID     0xff
 #define WL12XX_INVALID_LINK_ID     0xff
 
+/* the driver supports the 2.4Ghz and 5Ghz bands */
+#define WLCORE_NUM_BANDS           2
+
 #define WL12XX_MAX_RATE_POLICIES 16
 
 /* Defined by FW as 0. Will not be freed or allocated. */
@@ -360,7 +363,7 @@ struct wl12xx_vif {
 	int channel;
 	enum nl80211_channel_type channel_type;
 
-	u32 bitrate_masks[IEEE80211_NUM_BANDS];
+	u32 bitrate_masks[WLCORE_NUM_BANDS];
 	u32 basic_rate_set;
 
 	/*
-- 
1.7.10

