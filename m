Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:1615 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756263AbZDECLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Apr 2009 22:11:08 -0400
From: Bob Copeland <me@bobcopeland.com>
To: kalle.valo@nokia.com
Cc: linux-wireless@vger.kernel.org, Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 1/6] wl12xx: update to 2.6.29 mac80211 hw scan API
Date: Sat,  4 Apr 2009 22:10:23 -0400
Message-Id: <1238897428-19639-2-git-send-email-me@bobcopeland.com> (sfid-20090405_041128_490081_5FFF7983)
In-Reply-To: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ops->hw_scan callback now takes a struct *cfg80211_scan_request,
and the scan_completed notifier takes a parameter to indicate whether
the scan was aborted.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/wl12xx/event.c |    2 +-
 drivers/net/wireless/wl12xx/main.c  |   14 +++++++++++---
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/event.c b/drivers/net/wireless/wl12xx/event.c
index 5c3b22b..7095772 100644
--- a/drivers/net/wireless/wl12xx/event.c
+++ b/drivers/net/wireless/wl12xx/event.c
@@ -37,7 +37,7 @@ static int wl12xx_event_scan_complete(struct wl12xx *wl,
 
 	if (wl->scanning) {
 		mutex_unlock(&wl->mutex);
-		ieee80211_scan_completed(wl->hw);
+		ieee80211_scan_completed(wl->hw, false);
 		mutex_lock(&wl->mutex);
 		wl->scanning = false;
 	}
diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 7c4e538..27f4f15 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -511,7 +511,7 @@ static void wl12xx_op_stop(struct ieee80211_hw *hw)
 
 	if (wl->scanning) {
 		mutex_unlock(&wl->mutex);
-		ieee80211_scan_completed(wl->hw);
+		ieee80211_scan_completed(wl->hw, true);
 		mutex_lock(&wl->mutex);
 		wl->scanning = false;
 	}
@@ -1092,15 +1092,23 @@ out:
 
 }
 
-static int wl12xx_op_hw_scan(struct ieee80211_hw *hw, u8 *ssid, size_t len)
+static int wl12xx_op_hw_scan(struct ieee80211_hw *hw,
+			     struct cfg80211_scan_request *req)
 {
 	struct wl12xx *wl = hw->priv;
 	int ret;
+	u8 *ssid = NULL;
+	size_t ssid_len = 0;
 
 	wl12xx_debug(DEBUG_MAC80211, "mac80211 hw scan");
 
+	if (req->n_ssids) {
+		ssid = req->ssids[0].ssid;
+		ssid_len = req->ssids[0].ssid_len;
+	}
+
 	mutex_lock(&wl->mutex);
-	ret = wl12xx_hw_scan(hw->priv, ssid, len, 1, 0, 13, 3);
+	ret = wl12xx_hw_scan(hw->priv, ssid, ssid_len, 1, 0, 13, 3);
 	mutex_unlock(&wl->mutex);
 
 	return ret;
-- 
1.6.0.6


