Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from contumacia.investici.org ([178.255.144.35]:59973 "EHLO
	contumacia.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750738Ab2KGLxE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Nov 2012 06:53:04 -0500
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <ordex@autistici.org>
Subject: [PATCH 1/2] cfg80211: store the ssid into wirless_dev in AP mode
Date: Wed,  7 Nov 2012 12:52:19 +0100
Message-Id: <1352289140-20515-1-git-send-email-ordex@autistici.org> (sfid-20121107_125318_066060_67C78C69)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Store the configured ssid in wdev->ssid when starting an AP

Signed-off-by: Antonio Quartulli <ordex@autistici.org>
---
 net/wireless/ap.c      | 1 +
 net/wireless/nl80211.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/net/wireless/ap.c b/net/wireless/ap.c
index e143505..324e8d8 100644
--- a/net/wireless/ap.c
+++ b/net/wireless/ap.c
@@ -28,6 +28,7 @@ static int __cfg80211_stop_ap(struct cfg80211_registered_device *rdev,
 	if (!err) {
 		wdev->beacon_interval = 0;
 		wdev->channel = NULL;
+		wdev->ssid_len = 0;
 	}
 
 	return err;
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index ba44f98..e521ca0 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2649,6 +2649,8 @@ static int nl80211_start_ap(struct sk_buff *skb, struct genl_info *info)
 		wdev->preset_chantype = params.channel_type;
 		wdev->beacon_interval = params.beacon_interval;
 		wdev->channel = params.channel;
+		wdev->ssid_len = params.ssid_len;
+		memcpy(wdev->ssid, params.ssid, wdev->ssid_len);
 	}
 	return err;
 }
-- 
1.8.0

