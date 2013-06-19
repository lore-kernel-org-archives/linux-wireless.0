Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43275 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756551Ab3FSNxr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 09:53:47 -0400
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 2/2] cfg80211: hold BSS over association process
Date: Wed, 19 Jun 2013 15:53:37 +0200
Message-Id: <1371650017-14293-2-git-send-email-johannes@sipsolutions.net> (sfid-20130619_155405_759729_971ECA04)
In-Reply-To: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net>
References: <1371650017-14293-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This fixes the potential issue that the BSS struct that we use
and later assign to wdev->current_bss is removed from the scan
list while associating.

Also warn when we don't have a BSS struct in connect_result
unless it's from a driver that only has the connect() API.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 net/wireless/mlme.c |  4 ++++
 net/wireless/sme.c  | 15 ++++++++++-----
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/net/wireless/mlme.c b/net/wireless/mlme.c
index dd6f79d..bfac5e1 100644
--- a/net/wireless/mlme.c
+++ b/net/wireless/mlme.c
@@ -38,6 +38,7 @@ void cfg80211_rx_assoc_resp(struct net_device *dev, struct cfg80211_bss *bss,
 	 * frame instead of reassoc.
 	 */
 	if (cfg80211_sme_rx_assoc_resp(wdev, status_code)) {
+		cfg80211_unhold_bss(bss_from_pub(bss));
 		cfg80211_put_bss(wiphy, bss);
 		return;
 	}
@@ -142,6 +143,7 @@ void cfg80211_assoc_timeout(struct net_device *dev, struct cfg80211_bss *bss)
 	nl80211_send_assoc_timeout(rdev, dev, bss->bssid, GFP_KERNEL);
 	cfg80211_sme_assoc_timeout(wdev);
 
+	cfg80211_unhold_bss(bss_from_pub(bss));
 	cfg80211_put_bss(wiphy, bss);
 }
 EXPORT_SYMBOL(cfg80211_assoc_timeout);
@@ -309,6 +311,8 @@ int cfg80211_mlme_assoc(struct cfg80211_registered_device *rdev,
 		goto out;
 
 	err = rdev_assoc(rdev, dev, req);
+	if (!err)
+		cfg80211_hold_bss(bss_from_pub(req->bss));
 
 out:
 	if (err)
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index ae7e2cb..c0bf781 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -615,19 +615,24 @@ void __cfg80211_connect_result(struct net_device *dev, const u8 *bssid,
 		kfree(wdev->connect_keys);
 		wdev->connect_keys = NULL;
 		wdev->ssid_len = 0;
-		cfg80211_put_bss(wdev->wiphy, bss);
+		if (bss) {
+			cfg80211_unhold_bss(bss_from_pub(bss));
+			cfg80211_put_bss(wdev->wiphy, bss);
+		}
 		return;
 	}
 
-	if (!bss)
+	if (!bss) {
+		WARN_ON_ONCE(!wiphy_to_dev(wdev->wiphy)->ops->connect);
 		bss = cfg80211_get_bss(wdev->wiphy, NULL, bssid,
 				       wdev->ssid, wdev->ssid_len,
 				       WLAN_CAPABILITY_ESS,
 				       WLAN_CAPABILITY_ESS);
-	if (WARN_ON(!bss))
-		return;
+		if (WARN_ON(!bss))
+			return;
+		cfg80211_hold_bss(bss_from_pub(bss));
+	}
 
-	cfg80211_hold_bss(bss_from_pub(bss));
 	wdev->current_bss = bss_from_pub(bss);
 
 	cfg80211_upload_connect_keys(wdev);
-- 
1.8.0

