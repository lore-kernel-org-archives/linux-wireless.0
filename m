Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.48]:26543 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755378Ab0KJK11 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Nov 2010 05:27:27 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa02.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAAAROBF024251
	for <linux-wireless@vger.kernel.org>; Wed, 10 Nov 2010 12:27:24 +0200
From: juuso.oikarinen@nokia.com
To: luciano.coelho@nokia.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 1/2] wl1271: Prevent ad-hoc and active scanning on 11a DFS frequencies
Date: Wed, 10 Nov 2010 12:27:19 +0200
Message-Id: <1289384840-28305-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The wl1271 does not support radar detection. Hence, prevent ad-hoc and
active scanning on frequencies requiring DFS.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/wl1271_main.c |   23 +++++++++++++++++++++++
 1 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/wl1271_main.c b/drivers/net/wireless/wl12xx/wl1271_main.c
index f5b1d19..eb9f821 100644
--- a/drivers/net/wireless/wl12xx/wl1271_main.c
+++ b/drivers/net/wireless/wl12xx/wl1271_main.c
@@ -335,6 +335,27 @@ out:
 	return NOTIFY_OK;
 }
 
+static int wl1271_reg_notify(struct wiphy *wiphy,
+			     struct regulatory_request *request) {
+	struct ieee80211_supported_band *band;
+	struct ieee80211_channel *ch;
+	int i;
+
+	band = wiphy->bands[IEEE80211_BAND_5GHZ];
+	for (i = 0; i < band->n_channels; i++) {
+		ch = &band->channels[i];
+		if (ch->flags % IEEE80211_CHAN_DISABLED)
+			continue;
+
+		if (ch->flags & IEEE80211_CHAN_RADAR)
+			ch->flags |= IEEE80211_CHAN_NO_IBSS |
+				     IEEE80211_CHAN_PASSIVE_SCAN;
+
+	}
+
+	return 0;
+}
+
 static void wl1271_conf_init(struct wl1271 *wl)
 {
 
@@ -2590,6 +2611,8 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->queues = 4;
 	wl->hw->max_rates = 1;
 
+	wl->hw->wiphy->reg_notifier = wl1271_reg_notify;
+
 	SET_IEEE80211_DEV(wl->hw, wl1271_wl_to_dev(wl));
 
 	return 0;
-- 
1.7.1

