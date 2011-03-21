Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:52074 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752956Ab1CUVWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Mar 2011 17:22:39 -0400
Received: by mail-ew0-f43.google.com with SMTP id 20so1980110ewy.16
        for <linux-wireless@vger.kernel.org>; Mon, 21 Mar 2011 14:21:49 -0700 (PDT)
From: Luciano Coelho <coelho@ti.com>
To: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: use a bitmask instead of list of booleans in scanned_ch
Date: Mon, 21 Mar 2011 23:19:45 +0200
Message-Id: <1300742385-15813-1-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We were using an array of booleans to mark the channels we had already scanned.  This was causing a sparse error, because bool is not a type with defined size.  To fix this, use bitmasks instead, which is much cleaner anyway.

Thanks Johannes Berg for the idea.

Signed-off-by: Luciano Coelho <coelho@ti.com>
---
 drivers/net/wireless/wl12xx/main.c   |    6 ++++--
 drivers/net/wireless/wl12xx/scan.c   |   17 ++++++++++-------
 drivers/net/wireless/wl12xx/wl12xx.h |    3 ++-
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
index 85cb4da..ba1c3f8 100644
--- a/drivers/net/wireless/wl12xx/main.c
+++ b/drivers/net/wireless/wl12xx/main.c
@@ -1423,8 +1423,7 @@ static void __wl1271_op_remove_interface(struct wl1271 *wl)
 
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE) {
 		wl->scan.state = WL1271_SCAN_STATE_IDLE;
-		kfree(wl->scan.scanned_ch);
-		wl->scan.scanned_ch = NULL;
+		memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 		wl->scan.req = NULL;
 		ieee80211_scan_completed(wl->hw, true);
 	}
@@ -3502,6 +3501,9 @@ int wl1271_init_ieee80211(struct wl1271 *wl)
 	wl->hw->wiphy->max_scan_ie_len = WL1271_CMD_TEMPL_MAX_SIZE -
 			sizeof(struct ieee80211_header);
 
+	/* make sure all our channels fit in the scanned_ch bitmask */
+	BUG_ON(ARRAY_SIZE(wl1271_channels) + ARRAY_SIZE(wl1271_channels_5ghz) >
+	       WL1271_MAX_CHANNELS);
 	/*
 	 * We keep local copies of the band structs because we need to
 	 * modify them on a per-device basis.
diff --git a/drivers/net/wireless/wl12xx/scan.c b/drivers/net/wireless/wl12xx/scan.c
index 420653a..5d0544c 100644
--- a/drivers/net/wireless/wl12xx/scan.c
+++ b/drivers/net/wireless/wl12xx/scan.c
@@ -48,8 +48,7 @@ void wl1271_scan_complete_work(struct work_struct *work)
 		goto out;
 
 	wl->scan.state = WL1271_SCAN_STATE_IDLE;
-	kfree(wl->scan.scanned_ch);
-	wl->scan.scanned_ch = NULL;
+	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 	wl->scan.req = NULL;
 	ieee80211_scan_completed(wl->hw, false);
 
@@ -87,7 +86,7 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 
 		flags = req->channels[i]->flags;
 
-		if (!wl->scan.scanned_ch[i] &&
+		if (!test_bit(i, wl->scan.scanned_ch) &&
 		    !(flags & IEEE80211_CHAN_DISABLED) &&
 		    ((!!(flags & IEEE80211_CHAN_PASSIVE_SCAN)) == passive) &&
 		    (req->channels[i]->band == band)) {
@@ -124,7 +123,7 @@ static int wl1271_get_scan_channels(struct wl1271 *wl,
 			memset(&channels[j].bssid_msb, 0xff, 2);
 
 			/* Mark the channels we already used */
-			wl->scan.scanned_ch[i] = true;
+			set_bit(i, wl->scan.scanned_ch);
 
 			j++;
 		}
@@ -291,6 +290,12 @@ void wl1271_scan_stm(struct wl1271 *wl)
 int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 		struct cfg80211_scan_request *req)
 {
+	/*
+	 * cfg80211 should guarantee that we don't get more channels
+	 * than what we have registered.
+	 */
+	BUG_ON(req->n_channels > WL1271_MAX_CHANNELS);
+
 	if (wl->scan.state != WL1271_SCAN_STATE_IDLE)
 		return -EBUSY;
 
@@ -304,10 +309,8 @@ int wl1271_scan(struct wl1271 *wl, const u8 *ssid, size_t ssid_len,
 	}
 
 	wl->scan.req = req;
+	memset(wl->scan.scanned_ch, 0, sizeof(wl->scan.scanned_ch));
 
-	wl->scan.scanned_ch = kcalloc(req->n_channels,
-				      sizeof(*wl->scan.scanned_ch),
-				      GFP_KERNEL);
 	/* we assume failure so that timeout scenarios are handled correctly */
 	wl->scan.failed = true;
 	ieee80211_queue_delayed_work(wl->hw, &wl->scan_complete_work,
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index b04481a..ba98e18 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -302,9 +302,10 @@ struct wl1271_rx_mem_pool_addr {
 	u32 addr_extra;
 };
 
+#define WL1271_MAX_CHANNELS 64
 struct wl1271_scan {
 	struct cfg80211_scan_request *req;
-	bool *scanned_ch;
+	unsigned long scanned_ch[BITS_TO_LONGS(WL1271_MAX_CHANNELS)];
 	bool failed;
 	u8 state;
 	u8 ssid[IW_ESSID_MAX_SIZE+1];
-- 
1.7.1

