Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.1.47]:37867 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751406Ab0KZMnH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Nov 2010 07:43:07 -0500
Received: from nokia.com (localhost [127.0.0.1])
	by mgw-sa01.nokia.com (Switch-3.4.3/Switch-3.4.3) with ESMTP id oAQCh4dp005785
	for <linux-wireless@vger.kernel.org>; Fri, 26 Nov 2010 14:43:05 +0200
From: luciano.coelho@nokia.com
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	Juuso Oikarinen <juuso.oikarinen@nokia.com>
Subject: [PATCH] wl12xx: disable 11a channels when regulatory changes if 11a is not supported
Date: Fri, 26 Nov 2010 14:43:10 +0200
Message-Id: <1290775390-3391-1-git-send-email-luciano.coelho@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@nokia.com>

Instead of simply not scanning for the 11a channels when not supported by the
hardware, disable the channels in reg_notify.  This centralizes the decision
on whether to scan 5GHz channel in one place and allows userspace to know
exactly which channels are in use.

Based on Juuso Oikarinen's idea.

Cc: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Signed-off-by: Luciano Coelho <luciano.coelho@nokia.com>
---
 drivers/net/wireless/wl12xx/main.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 35cfcf6..97eb186 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -336,7 +336,9 @@ out:
 }
 
 static int wl1271_reg_notify(struct wiphy *wiphy,
-			     struct regulatory_request *request) {
+			     struct regulatory_request *request)
+{
+	struct wl1271 *wl = wiphy_to_ieee80211_hw(wiphy)->priv;
 	struct ieee80211_supported_band *band;
 	struct ieee80211_channel *ch;
 	int i;
@@ -347,6 +349,11 @@ static int wl1271_reg_notify(struct wiphy *wiphy,
 		if (ch->flags & IEEE80211_CHAN_DISABLED)
 			continue;
 
+		if (!wl->enable_11a) {
+			ch->flags |= IEEE80211_CHAN_DISABLED;
+			continue;
+		}
+
 		if (ch->flags & IEEE80211_CHAN_RADAR)
 			ch->flags |= IEEE80211_CHAN_NO_IBSS |
 				     IEEE80211_CHAN_PASSIVE_SCAN;
-- 
1.7.0.4

