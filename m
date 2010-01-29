Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6728 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752503Ab0A2SCR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Jan 2010 13:02:17 -0500
From: <shanyu.zhao@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Shanyu Zhao <shanyu.zhao@intel.com>
Subject: [PATCH 1/1] cfg80211: wext: fix cfg80211's SIOCSIWAP function
Date: Fri, 29 Jan 2010 10:02:11 -0800
Message-Id: <1264788131-11671-1-git-send-email-shanyu.zhao@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Shanyu Zhao <shanyu.zhao@intel.com>

The cfg80211's SIOCSIWAP function is broken, the reason is we cannot
get the correct bss with previously set ssid. Need to clear it by
setting ssid_len to 0 in cfg80211_mgd_wext_siwap() and fix other
places accordingly.

Signed-off-by: Shanyu Zhao <shanyu.zhao@intel.com>
---
 net/wireless/sme.c      |    9 +++++++--
 net/wireless/wext-sme.c |    3 ++-
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 745c37e..51c3cdb 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -779,10 +779,15 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
 			wdev->conn->auto_auth = false;
 		}
 
-		memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
+		/* make sure it can connect if only bssid is provided */
 		wdev->ssid_len = connect->ssid_len;
-		wdev->conn->params.ssid = wdev->ssid;
 		wdev->conn->params.ssid_len = connect->ssid_len;
+		if (connect->ssid_len) {
+			memcpy(wdev->ssid, connect->ssid, connect->ssid_len);
+			wdev->conn->params.ssid = wdev->ssid;
+		}
+		else
+			wdev->conn->params.ssid = NULL;
 
 		/* see if we have the bss already */
 		bss = cfg80211_get_conn_bss(wdev);
diff --git a/net/wireless/wext-sme.c b/net/wireless/wext-sme.c
index 5615a88..eede356 100644
--- a/net/wireless/wext-sme.c
+++ b/net/wireless/wext-sme.c
@@ -34,7 +34,7 @@ int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			wdev->wext.connect.privacy = true;
 	}
 
-	if (!wdev->wext.connect.ssid_len)
+	if (!wdev->wext.connect.ssid_len && !wdev->wext.connect.bssid)
 		return 0;
 
 	if (wdev->wext.keys) {
@@ -280,6 +280,7 @@ int cfg80211_mgd_wext_siwap(struct net_device *dev,
 	if (bssid) {
 		memcpy(wdev->wext.bssid, bssid, ETH_ALEN);
 		wdev->wext.connect.bssid = wdev->wext.bssid;
+		wdev->wext.connect.ssid_len = 0;
 	} else
 		wdev->wext.connect.bssid = NULL;
 
-- 
1.6.0.4

