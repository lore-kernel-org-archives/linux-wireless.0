Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:42822 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188AbcDZHfq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Apr 2016 03:35:46 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wext: remove a/b/g/n from SIOCGIWNAME
Date: Tue, 26 Apr 2016 09:35:42 +0200
Message-Id: <1461656142-29456-1-git-send-email-johannes@sipsolutions.net> (sfid-20160426_093549_956386_56939AA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Since a/b/g/n no longer exist as spec amendements and VHT (ex 802.11ac)
wasn't handled at all, it's better to just remove the amendment strings
to avoid confusion.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/wext-compat.c | 35 -----------------------------------
 1 file changed, 35 deletions(-)

diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
index 4c89f0ca61ba..9f27221c8913 100644
--- a/net/wireless/wext-compat.c
+++ b/net/wireless/wext-compat.c
@@ -25,42 +25,7 @@ int cfg80211_wext_giwname(struct net_device *dev,
 			  struct iw_request_info *info,
 			  char *name, char *extra)
 {
-	struct wireless_dev *wdev = dev->ieee80211_ptr;
-	struct ieee80211_supported_band *sband;
-	bool is_ht = false, is_a = false, is_b = false, is_g = false;
-
-	if (!wdev)
-		return -EOPNOTSUPP;
-
-	sband = wdev->wiphy->bands[NL80211_BAND_5GHZ];
-	if (sband) {
-		is_a = true;
-		is_ht |= sband->ht_cap.ht_supported;
-	}
-
-	sband = wdev->wiphy->bands[NL80211_BAND_2GHZ];
-	if (sband) {
-		int i;
-		/* Check for mandatory rates */
-		for (i = 0; i < sband->n_bitrates; i++) {
-			if (sband->bitrates[i].bitrate == 10)
-				is_b = true;
-			if (sband->bitrates[i].bitrate == 60)
-				is_g = true;
-		}
-		is_ht |= sband->ht_cap.ht_supported;
-	}
-
 	strcpy(name, "IEEE 802.11");
-	if (is_a)
-		strcat(name, "a");
-	if (is_b)
-		strcat(name, "b");
-	if (is_g)
-		strcat(name, "g");
-	if (is_ht)
-		strcat(name, "n");
-
 	return 0;
 }
 EXPORT_WEXT_HANDLER(cfg80211_wext_giwname);
-- 
2.8.0.rc3

