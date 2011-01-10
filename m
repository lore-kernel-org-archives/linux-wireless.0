Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:60298 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab1AJVE5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Jan 2011 16:04:57 -0500
Received: by wwa36 with SMTP id 36so1049916wwa.1
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jan 2011 13:04:54 -0800 (PST)
From: Arik Nemtsov <arik@wizery.com>
To: <linux-wireless@vger.kernel.org>
Cc: Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: [PATCH] wl12xx: reset 5ghz num channels on hw init
Date: Mon, 10 Jan 2011 23:04:04 +0200
Message-Id: <1294693444-30807-1-git-send-email-arik@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The number of 5ghz channels is set to 0 when 11a is not supported in the
NVS file. When a single rmmod/insmod of wl12xx_sdio this leads to a
supported band (5ghz) with 0 supported channels, which mac80211
considers illegal.

Fix this by always resetting the number of supported 5ghz channels
before the HW is registered.

Signed-off-by: Arik Nemtsov <arik@wizery.com>
---
 drivers/net/wireless/wl12xx/main.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 062247e..44cdefd 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -2679,6 +2679,10 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl1271_band_2ghz;
 	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ] = &wl1271_band_5ghz;
 
+	/* reset the number of channels as this can be changed at runtime */
+	wl->hw->wiphy->bands[IEEE80211_BAND_5GHZ]->n_channels =
+					ARRAY_SIZE(wl1271_channels_5ghz);
+
 	wl->hw->queues = 4;
 	wl->hw->max_rates = 1;
 
-- 
1.7.1

