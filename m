Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.26]:35522 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998Ab0LCPFA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Dec 2010 10:05:00 -0500
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: luciano.coelho@nokia.com, geryk@ti.com
Subject: [PATCH] wl12xx: disable 11a channels when wl->enable_11a is known
Date: Fri,  3 Dec 2010 17:05:40 +0200
Message-Id: <1291388740-27218-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Disabling the 11a channels when not supported in the reg_notify function was
not working as it should, because when the driver is initiailizing (and
registering itself with mac80211), it would get the reg notification too
early.  At that point the driver wouldn't have received the NVS yet, so it
wouldn't know whether 11a was supported.

To fix this, we disable 11a channels when we read the NVS instead.  Also, it
is easier (and still safe) to set n_channels to zero instead of setting the
disabled flag on every 11a channel.

Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c |   16 ++++++++++------
 1 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index dc3a093..9cdbfde 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -338,7 +338,6 @@ out:
 static int wl1271_reg_notify(struct wiphy *wiphy,
 			     struct regulatory_request *request)
 {
-	struct wl1271 *wl = wiphy_to_ieee80211_hw(wiphy)->priv;
 	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *ch;
 	int i;
@@ -349,11 +348,6 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 		if (ch->flags & IEEE80211_CHAN_DISABLED)
 			continue;
 
-		if (!wl->enable_11a) {
-			ch->flags |= IEEE80211_CHAN_DISABLED;
-			continue;
-		}
-
 		if (ch->flags & IEEE80211_CHAN_RADAR)
 			ch->flags |= IEEE80211_CHAN_NO_IBSS |
 				     IEEE80211_CHAN_PASSIVE_SCAN;
@@ -1071,6 +1065,16 @@ power_off:
 	strncpy(wiphy->fw_version, wl->chip.fw_ver,
 		sizeof(wiphy->fw_version));
 
+	/*
+	 * Now we know if 11a is supported (info from the NVS), so disable
+	 * 11a channels if not supported
+	 */
+	if (!wl->enable_11a)
+		wiphy->bands[IEEE80211_BAND_5GHZ]->n_channels = 0;
+
+	wl1271_debug(DEBUG_MAC80211, "11a is %ssupported",
+		     wl->enable_11a ? "":"not ");
+
 out:
 	mutex_unlock(&wl->mutex);
 
-- 
1.7.0.4

