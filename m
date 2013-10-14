Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.neomailbox.net ([178.209.62.157]:30872 "EHLO
	s3.neomailbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855Ab3JNXZV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 19:25:21 -0400
From: Antonio Quartulli <antonio@meshcoding.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH 1/2] cfg80211: on ibss_joined use the channel to get the proper bss object
Date: Tue, 15 Oct 2013 00:38:01 +0200
Message-Id: <1381790282-1146-1-git-send-email-antonio@meshcoding.com> (sfid-20131015_012527_601875_6D0A08E7)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

It may be the case that the same IBSS (same bssid and essid)
exists on two different channels (i.e. two IBSSes created
with different but fixed freq) and therefore the latter must
be also used to distinguish them.

Fix wdev->current_bss assignment by passing the channel to
cfg80211_get_bss() on ibss_joined.
This ensures that cfg80211_get_bss() picks up the proper bss
object.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/wireless/ibss.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/ibss.c b/net/wireless/ibss.c
index 403fe29..12c878b 100644
--- a/net/wireless/ibss.c
+++ b/net/wireless/ibss.c
@@ -28,7 +28,7 @@ void __cfg80211_ibss_joined(struct net_device *dev, const u8 *bssid)
 	if (!wdev->ssid_len)
 		return;
 
-	bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
+	bss = cfg80211_get_bss(wdev->wiphy, wdev->channel, bssid,
 			       wdev->ssid, wdev->ssid_len,
 			       WLAN_CAPABILITY_IBSS, WLAN_CAPABILITY_IBSS);
 
-- 
1.8.3.2

