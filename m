Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:4362 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752516AbZDVDl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Apr 2009 23:41:29 -0400
Date: Tue, 21 Apr 2009 23:38:45 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: kalle.valo@nokia.com, linux-wireless@vger.kernel.org
Subject: [PATCH v2] wl12xx: update to 2.6.29 mac80211 hw scan API
Message-ID: <20090422033845.GA8849@hash.localnet> (sfid-20090422_054134_006780_83A8B214)
References: <1238897428-19639-1-git-send-email-me@bobcopeland.com> <1238897428-19639-2-git-send-email-me@bobcopeland.com> <1238921906.3782.5.camel@johannes.local> <20090405143357.GA21913@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090405143357.GA21913@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ops->hw_scan callback now takes a struct *cfg80211_scan_request,
and the scan_completed notifier takes a parameter to indicate whether
the scan was aborted.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---

Kalle, this is just an update to 1/6, the others in the series are
probably ok as-is.

v2: just added the max_scan_ssids.

 drivers/net/wireless/wl12xx/event.c |    2 +-
 drivers/net/wireless/wl12xx/main.c  |   15 ++++++++++++---
 2 files changed, 13 insertions(+), 4 deletions(-)

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
index 7c4e538..e4d1e12 100644
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
@@ -1237,6 +1245,7 @@ static int wl12xx_init_ieee80211(struct wl12xx *wl)
 	wl->hw->flags = IEEE80211_HW_SIGNAL_DBM |
 		IEEE80211_HW_NOISE_DBM;
 
+	wl->hw->wiphy->max_scan_ssids = 1;
 	wl->hw->wiphy->bands[IEEE80211_BAND_2GHZ] = &wl12xx_band_2ghz;
 
 	SET_IEEE80211_DEV(wl->hw, &wl->spi->dev);
-- 
1.6.0.6


