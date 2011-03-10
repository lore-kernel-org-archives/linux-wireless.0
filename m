Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([147.243.128.24]:54119 "EHLO mgw-da01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab1CJIBw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 03:01:52 -0500
From: juuso.oikarinen@nokia.com
To: coelho@ti.com
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH] wl12xx: Fix potential incorrect band in rx-status
Date: Thu, 10 Mar 2011 10:01:43 +0200
Message-Id: <1299744103-11077-1-git-send-email-juuso.oikarinen@nokia.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Juuso Oikarinen <juuso.oikarinen@nokia.com>

The rx-status passed to mac80211 along with each received frame contains the
band on which the frame was received. Under certain circumstances, this band
information may be incorrect, causing in worst case a WARNING from mac80211,
and causes the received frame to be dropped.

This scenario mainly occurs when performing connected-mode scans, when the
received scan results are from the other band than the one currentl
associated to.

Signed-off-by: Juuso Oikarinen <juuso.oikarinen@nokia.com>
---
 drivers/net/wireless/wl12xx/rx.c |   10 +++-------
 1 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/wl12xx/rx.c b/drivers/net/wireless/wl12xx/rx.c
index 919b59f..e58c453 100644
--- a/drivers/net/wireless/wl12xx/rx.c
+++ b/drivers/net/wireless/wl12xx/rx.c
@@ -48,18 +48,14 @@ static void wl1271_rx_status(struct wl1271 *wl,
 			     struct ieee80211_rx_status *status,
 			     u8 beacon)
 {
-	enum ieee80211_band desc_band;
-
 	memset(status, 0, sizeof(struct ieee80211_rx_status));
 
-	status->band = wl->band;
-
 	if ((desc->flags & WL1271_RX_DESC_BAND_MASK) == WL1271_RX_DESC_BAND_BG)
-		desc_band = IEEE80211_BAND_2GHZ;
+		status->band = IEEE80211_BAND_2GHZ;
 	else
-		desc_band = IEEE80211_BAND_5GHZ;
+		status->band = IEEE80211_BAND_5GHZ;
 
-	status->rate_idx = wl1271_rate_to_idx(desc->rate, desc_band);
+	status->rate_idx = wl1271_rate_to_idx(desc->rate, status->band);
 
 #ifdef CONFIG_WL12XX_HT
 	/* 11n support */
-- 
1.7.1

